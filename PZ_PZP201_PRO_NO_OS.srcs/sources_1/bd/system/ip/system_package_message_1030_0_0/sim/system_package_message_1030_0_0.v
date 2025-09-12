// (c) Copyright 1995-2025 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:package_message_1030:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_package_message_1030_0_0 (
  clk,
  rst,
  valid_mode_ac,
  mode_ac_message,
  mode_ac_clk_ts,
  mode_ac_utc_ts,
  mode_ac_drift,
  device_id,
  valid_drift,
  pps_count,
  drift_message,
  valid_out,
  packed_message
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_RESET rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN system_util_ad9361_divclk_0_clk_out, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst RST" *)
input wire rst;
input wire valid_mode_ac;
input wire [23 : 0] mode_ac_message;
input wire [25 : 0] mode_ac_clk_ts;
input wire [5 : 0] mode_ac_utc_ts;
input wire [12 : 0] mode_ac_drift;
input wire [15 : 0] device_id;
input wire valid_drift;
input wire [31 : 0] pps_count;
input wire [15 : 0] drift_message;
output wire valid_out;
output wire [87 : 0] packed_message;

  package_message_1030 inst (
    .clk(clk),
    .rst(rst),
    .valid_mode_ac(valid_mode_ac),
    .mode_ac_message(mode_ac_message),
    .mode_ac_clk_ts(mode_ac_clk_ts),
    .mode_ac_utc_ts(mode_ac_utc_ts),
    .mode_ac_drift(mode_ac_drift),
    .device_id(device_id),
    .valid_drift(valid_drift),
    .pps_count(pps_count),
    .drift_message(drift_message),
    .valid_out(valid_out),
    .packed_message(packed_message)
  );
endmodule
