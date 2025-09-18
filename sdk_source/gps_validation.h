#ifndef GPS_VALIDATION_H
#define GPS_VALIDATION_H

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

#define GPS_PL_PACKET_SIZE 20

typedef enum {
    GPS_PL_TYPE_FUSED = 0,
    GPS_PL_TYPE_GNRMC = 1,
    GPS_PL_TYPE_GNGGA = 2
} gps_pl_type_t;

/* Per-second pairing bucket */
typedef struct {
    int32_t sec_of_day;   // -1 if empty
    bool have_rmc, have_gga;

    // RMC
    bool     rmc_valid;
    int32_t  rmc_sod_s;           // seconds-of-day (for pairing)
    int      rmc_hh, rmc_mm, rmc_ss, rmc_cs; // cs = centiseconds 0..99
    int32_t  rmc_lat_1e7, rmc_lon_1e7;
    uint16_t rmc_speed_kmh;       // integer km/h
    uint16_t rmc_heading_deg;     // 0..359
    uint8_t  rmc_dd, rmc_mon, rmc_yy; // DD, MM, YY(0..99)

    // GGA
    bool     gga_valid;
    int32_t  gga_sod_s;
    int      gga_hh, gga_mm, gga_ss, gga_cs;
    int32_t  gga_lat_1e7, gga_lon_1e7;
    int32_t  gga_alt_m_msl_dm;    // decimeters
    int32_t  gga_geoid_dm;        // decimeters
} GpsBucket;

typedef struct {
    GpsBucket bucket[4];
} GpsValidatorCtx;

void gpsv_init(GpsValidatorCtx *ctx);

/* Parse/validate an ISR buffer of NMEA text and, if a record is ready,
 * write one 20-byte PL packet into 'out' (big-endian fields).
 * Returns true when a packet was produced. */
bool gpsv_process_block(GpsValidatorCtx *ctx, const char *block,
                        uint8_t *out, size_t *out_len);

#endif // GPS_VALIDATION_H
