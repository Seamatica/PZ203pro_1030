#include "gps_validation.h"
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#ifndef MIN
#define MIN(a,b) ((a)<(b)?(a):(b))
#endif

// ---------- small integer rounding helpers (no libm needed) ----------
static long long llround_no_libm(double x){
    return (long long)(x + (x >= 0 ? 0.5 : -0.5));
}
static long lround_no_libm_d(double x){
    return (long)(x + (x >= 0 ? 0.5 : -0.5));
}

// ---------- checksum & string utils ----------
static uint8_t nmea_checksum_compute(const char *line){
    uint8_t cs=0; const char *p=line; if(*p=='$') ++p;
    while(*p && *p!='*') cs^=(uint8_t)(*p++);
    return cs;
}
static bool nmea_checksum_ok(const char *line){
    const char *star=strchr(line,'*'); if(!star) return false;
    unsigned rx=0; if(sscanf(star+1,"%2x",&rx)!=1) return false;
    return ((uint8_t)rx)==nmea_checksum_compute(line);
}
static void rstrip_crlf(char *s){
    size_t n=strlen(s);
    while(n && (s[n-1]=='\r'||s[n-1]=='\n')) s[--n]='\0';
}

// ---------- time & date parsing ----------
/* parse "hhmmss(.cc)" -> hh,mm,ss,cs and seconds-of-day */
static void parse_time_hhmmss(const char *t,
                              int *hh,int *mm,int *ss,int *cs,
                              int32_t *sod_s){
    *hh=*mm=*ss=0; *cs=0; *sod_s=-1;
    if(!t || strlen(t)<6) return;
    int H=(t[0]-'0')*10+(t[1]-'0');
    int M=(t[2]-'0')*10+(t[3]-'0');
    int S=(t[4]-'0')*10+(t[5]-'0');
    if(H<0||H>23||M<0||M>59||S<0||S>59) return;
    int CS=0;
    const char *dot=strchr(t,'.');
    if(dot && isdigit((unsigned char)dot[1])){
        int d1=dot[1]-'0';
        int d2=(dot[2] && isdigit((unsigned char)dot[2]))? dot[2]-'0' : 0;
        CS = d1*10 + d2;  // 0..99
    }
    *hh=H; *mm=M; *ss=S; *cs=CS;
    *sod_s = H*3600 + M*60 + S;
}

/* parse "ddmmyy" -> dd,mm,yy (yy=00..99) */
static void parse_date_ddmmyy(const char *d, uint8_t *dd, uint8_t *mm, uint8_t *yy){
    *dd=*mm=*yy=0;
    if(!d || strlen(d)<6) return;
    int D=(d[0]-'0')*10+(d[1]-'0');
    int M=(d[2]-'0')*10+(d[3]-'0');
    int Y=(d[4]-'0')*10+(d[5]-'0');
    if(D>=1 && D<=31) *dd=(uint8_t)D;
    if(M>=1 && M<=12) *mm=(uint8_t)M;
    if(Y>=0 && Y<=99) *yy=(uint8_t)Y;
}

/* pack time and date into your bit layouts (big-endian later) */
static uint32_t pack_time_24(int hh,int mm,int ss,int cs){
    if(cs>99) cs=99;
    return ((uint32_t)(hh & 0x1F) << 19) |
           ((uint32_t)(mm & 0x3F) << 13) |
           ((uint32_t)(ss & 0x3F) << 7 ) |
           ((uint32_t)(cs & 0x7F)      );
}
static uint16_t pack_date_16(uint8_t dd,uint8_t mm,uint8_t yy){
    return ((uint16_t)(dd & 0x1F) << 11) |
           ((uint16_t)(mm & 0x0F) << 7 ) |
           ((uint16_t)(yy & 0x7F)      );
}

static uint32_t pack_seconds_only(uint8_t ss){
    if(ss > 59) ss = 0;
    // hh=0 (bits 23..19), mm=0 (18..13), ss in (12..7), cs=0 (6..0)
    return ((uint32_t)(ss & 0x3F) << 7);
}

// ---------- lat/lon helpers ----------
static int32_t nmea_to_1e7deg(const char *ddmm, char hemi, bool is_lat){
    if(!ddmm || !*ddmm) return 0;
    double v=atof(ddmm);
    int deg=(int)(v/100.0);
    double min=v-deg*100.0;
    double dec=deg+min/60.0;
    if(hemi=='S'||hemi=='W') dec=-dec;
    double limit=is_lat?90.0:180.0;
    if(dec> limit) dec= limit;
    if(dec<-limit) dec=-limit;
    long long i=llround_no_libm(dec*1e7);
    if(i> 2147483647LL) i= 2147483647LL;
    if(i<-2147483648LL) i=-2147483648LL;
    return (int32_t)i;
}

// ---------- unit helpers ----------
static uint16_t knots_to_kmh_u16(double kn){
    if(!(kn>=0)) return 0;
    long v=lround_no_libm_d(kn*1.852);
    if(v<0) v=0; if(v>65535) v=65535;
    return (uint16_t)v;
}
static uint16_t heading_deg_u16(double deg){
    if(!(deg>=0)) return 0;
    while(deg<0) deg+=360.0;
    while(deg>=360.0) deg-=360.0;
    long v=lround_no_libm_d(deg);
    if(v<0) v=0; if(v>359) v=359;
    return (uint16_t)v;
}

// 24-bit writers (big-endian)
static void be24_from_s32(int32_t v, uint8_t out[3]){
    if(v>  8388607) v= 8388607;
    if(v< -8388608) v=-8388608;
    uint32_t u=(uint32_t)(v & 0xFFFFFF);
    out[0]=(uint8_t)((u>>16)&0xFF);
    out[1]=(uint8_t)((u>>8 )&0xFF);
    out[2]=(uint8_t)( u     &0xFF);
}
static void be24_from_u32(uint32_t v, uint8_t out[3]){
    if(v>0xFFFFFFu) v=0xFFFFFFu;
    out[0]=(uint8_t)((v>>16)&0xFF);
    out[1]=(uint8_t)((v>>8 )&0xFF);
    out[2]=(uint8_t)( v     &0xFF);
}

// ---------- context ----------
void gpsv_init(GpsValidatorCtx *ctx){
    memset(ctx,0,sizeof(*ctx));
    for(int i=0;i<4;i++) ctx->bucket[i].sec_of_day=-1;
}
static int oldest_idx(GpsValidatorCtx *ctx){
    int k=0; for(int i=1;i<4;i++) if(ctx->bucket[i].sec_of_day<ctx->bucket[k].sec_of_day) k=i;
    return k;
}
static int bucket_for(GpsValidatorCtx *ctx, int32_t sec){
    for(int i=0;i<4;i++) if(ctx->bucket[i].sec_of_day==sec) return i;
    int k=oldest_idx(ctx);
    ctx->bucket[k].sec_of_day=sec;
    ctx->bucket[k].have_rmc=ctx->bucket[k].have_gga=false;
    ctx->bucket[k].rmc_valid=ctx->bucket[k].gga_valid=false;
    return k;
}

// ---------- frames ----------
typedef struct {
    bool ok, valid;
    int32_t sod_s;
    int hh, mm, ss, cs;
    uint8_t dd, mon, yy;
    int32_t lat_1e7, lon_1e7;
    uint16_t speed_kmh, heading_deg;
} RMCFrame;

typedef struct {
    bool ok, valid;
    int32_t sod_s;
    int hh, mm, ss, cs;
    int32_t lat_1e7, lon_1e7;
    int32_t alt_msl_dm; // dm
    int32_t geoid_dm;   // dm
} GGAFrame;

// ---------- parse RMC ----------
static RMCFrame parse_RMC(const char *line){
    RMCFrame r; memset(&r,0,sizeof(r));
    if(!nmea_checksum_ok(line)) return r;

    char buf[192]; strncpy(buf,line,sizeof(buf)); buf[sizeof(buf)-1]='\0';
    // $--RMC,1:time,2:status,3:lat,4:N/S,5:lon,6:E/W,7:speed(kn),8:cog,9:date,...
    char *save=0,*tok=strtok_r(buf,",*",&save);
    int idx=-1; char time_s[16]="", date_s[16]="";
    char lat_s[24]="", lon_s[24]=""; char ns='N', ew='E';
    char status='V'; double sp_kn=0.0, cog=0.0; bool sp_set=false, cog_set=false;

    while(tok){
        idx++;
        if(idx==1) strncpy(time_s,tok,sizeof(time_s)-1);
        else if(idx==2) status=tok[0];
        else if(idx==3) strncpy(lat_s,tok,sizeof(lat_s)-1);
        else if(idx==4) ns=tok[0];
        else if(idx==5) strncpy(lon_s,tok,sizeof(lon_s)-1);
        else if(idx==6) ew=tok[0];
        else if(idx==7){ sp_kn = atof(tok); sp_set=true; }
        else if(idx==8){ cog   = atof(tok); cog_set=true; }
        else if(idx==9) strncpy(date_s,tok,sizeof(date_s)-1);
        tok=strtok_r(NULL,",*",&save);
    }

    r.ok=true; r.valid=(status=='A');
    parse_time_hhmmss(time_s, &r.hh,&r.mm,&r.ss,&r.cs, &r.sod_s);
    parse_date_ddmmyy(date_s, &r.dd,&r.mon,&r.yy);
    r.lat_1e7=nmea_to_1e7deg(lat_s,ns,true);
    r.lon_1e7=nmea_to_1e7deg(lon_s,ew,false);
    r.speed_kmh = sp_set ? knots_to_kmh_u16(sp_kn) : 0;
    r.heading_deg = cog_set ? heading_deg_u16(cog) : 0;
    return r;
}

// ---------- parse GGA ----------
static GGAFrame parse_GGA(const char *line){
    GGAFrame g; memset(&g,0,sizeof(g));
    if(!nmea_checksum_ok(line)) return g;

    char buf[192]; strncpy(buf,line,sizeof(buf)); buf[sizeof(buf)-1]='\0';
    // $--GGA,1:time,2:lat,3:N/S,4:lon,5:E/W,6:fix,7:sats,8:HDOP,9:altMSL,10:M,11:geoid,12:M,...
    char *save=0,*tok=strtok_r(buf,",*",&save);
    int idx=-1; char time_s[16]="";
    char lat_s[24]="", lon_s[24]=""; char ns='N', ew='E';
    int fix=0; double alt_m=0.0, geoid=0.0; bool alt_set=false, geo_set=false;

    while(tok){
        idx++;
        if(idx==1) strncpy(time_s,tok,sizeof(time_s)-1);
        else if(idx==2) strncpy(lat_s,tok,sizeof(lat_s)-1);
        else if(idx==3) ns=tok[0];
        else if(idx==4) strncpy(lon_s,tok,sizeof(lon_s)-1);
        else if(idx==5) ew=tok[0];
        else if(idx==6) fix = tok[0]? atoi(tok):0;
        else if(idx==9){ alt_m = atof(tok); alt_set=true; }
        else if(idx==11){ geoid = atof(tok); geo_set=true; }
        tok=strtok_r(NULL,",*",&save);
    }

    g.ok=true; g.valid=(fix>=1);
    parse_time_hhmmss(time_s, &g.hh,&g.mm,&g.ss,&g.cs, &g.sod_s);
    g.lat_1e7=nmea_to_1e7deg(lat_s,ns,true);
    g.lon_1e7=nmea_to_1e7deg(lon_s,ew,false);
    g.alt_msl_dm = alt_set ? (int32_t)lround_no_libm_d(alt_m*10.0) : 0;
    g.geoid_dm   = geo_set ? (int32_t)lround_no_libm_d(geoid*10.0) : 0;
    return g;
}

// ---------- packet emit ----------
static void emit_packet(uint8_t *out,
                        uint32_t time24, uint16_t date16,
                        int32_t lat_1e7, int32_t lon_1e7,
                        int32_t h_ellip_m, uint16_t speed_kmh,
                        uint16_t heading_deg, uint8_t type)
{
    // time 24b (bit-packed hh/mm/ss/cs)
    be24_from_u32(time24, &out[0]);

    // date 16b (bit-packed dd/mm/yy)
    out[3]=(uint8_t)((date16>>8)&0xFF);
    out[4]=(uint8_t)( date16     &0xFF);

    // lat/lon s32 BE
    out[5]=(uint8_t)((lat_1e7>>24)&0xFF);
    out[6]=(uint8_t)((lat_1e7>>16)&0xFF);
    out[7]=(uint8_t)((lat_1e7>>8 )&0xFF);
    out[8]=(uint8_t)( lat_1e7      &0xFF);

    out[9] =(uint8_t)((lon_1e7>>24)&0xFF);
    out[10]=(uint8_t)((lon_1e7>>16)&0xFF);
    out[11]=(uint8_t)((lon_1e7>>8 )&0xFF);
    out[12]=(uint8_t)( lon_1e7      &0xFF);

    // height 24b signed meters
    be24_from_s32(h_ellip_m, &out[13]);

    // speed km/h u16
    out[16]=(uint8_t)((speed_kmh>>8)&0xFF);
    out[17]=(uint8_t)( speed_kmh     &0xFF);

    // heading(12) + type(4)
    uint16_t ht = (uint16_t)(((heading_deg & 0x0FFF)<<4) | (type & 0x0F));
    out[18]=(uint8_t)((ht>>8)&0xFF);
    out[19]=(uint8_t)( ht     &0xFF);
}



// ---------- ingest (seconds-only, no fusion) ----------
static bool ingest_line_seconds_only(const char *line,
                                     uint8_t *out, size_t *out_len)
{
    if(!line || line[0] != '$') return false;

    const bool is_rmc = strstr(line,"RMC,") != NULL;
    const bool is_gga = strstr(line,"GGA,") != NULL;
    if(!is_rmc && !is_gga) return false;


    if(!nmea_checksum_ok(line)) return false;

    if(is_rmc){
        RMCFrame r = parse_RMC(line);

        uint8_t ss = (r.sod_s >= 0) ? (uint8_t)r.ss : 0;
        uint32_t t24 = pack_seconds_only(ss);

        // Everything else zero. Type can still tag source if you want.
        emit_packet(out,
                    t24,        /* time24: seconds only */
                    0,          /* date16: zero */
                    0, 0,       /* lat/lon: zero */
                    0,          /* height: zero */
                    0,          /* speed: zero */
                    0,          /* heading: zero */
                    GPS_PL_TYPE_GNRMC);
        *out_len = GPS_PL_PACKET_SIZE;
        return true;

    }

//    else { // GGA
//        GGAFrame g = parse_GGA(line);
//        uint8_t ss = (g.sod_s >= 0) ? (uint8_t)g.ss : 0;
//        uint32_t t24 = pack_seconds_only(ss);
//
//        emit_packet(out,
//                    t24,        /* time24: seconds only */
//                    0,          /* date16: zero */
//                    0, 0,       /* lat/lon: zero */
//                    0,          /* height: zero */
//                    0,          /* speed: zero */
//                    0,          /* heading: zero */
//                    GPS_PL_TYPE_GNGGA);
//        *out_len = GPS_PL_PACKET_SIZE;
//        return true;
//    }
}




// ---------- public entry (wire up the seconds-only ingest) ----------
bool gpsv_process_block(GpsValidatorCtx *ctx, const char *block,
                        uint8_t *out, size_t *out_len)
{
    (void)ctx; // unused now
    if(!block || !out || !out_len) return false;

    char local[1024];
    size_t L = strlen(block);
    while(L){
        size_t n = MIN(L, sizeof(local)-1);
        memcpy(local, block, n); local[n] = '\0';

        char *save = 0, *line = strtok_r(local, "\n", &save);
        while(line){
            rstrip_crlf(line);
            char *p = line;
            while((p = strchr(p, '$'))){
                const char *star = strchr(p, '*'); if(!star) break;
                size_t want = (size_t)(star - p + 3);
                char sent[192]; size_t m = MIN(want, sizeof(sent)-1);
                strncpy(sent, p, m); sent[m] = '\0';

                // seconds-only path
                if(ingest_line_seconds_only(sent, out, out_len)) return true;

                p = (char*)star + 3;
            }
            line = strtok_r(NULL, "\n", &save);
        }
        if(n == L) break; block += n; L -= n;
    }
    return false;
}




