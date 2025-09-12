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


// IP VLNV: xilinx.com:module_ref:net_udp_loop:1.0
// IP Revision: 1

(* X_CORE_INFO = "net_udp_loop,Vivado 2019.1" *)
(* CHECK_LICENSE_TYPE = "system_net_udp_loop_0_0,net_udp_loop,{}" *)
(* CORE_GENERATION_INFO = "system_net_udp_loop_0_0,net_udp_loop,{x_ipProduct=Vivado 2019.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=net_udp_loop,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,IDELAY_VALUE=0,UDP_PAYLOAD_BYTES=11}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module system_net_udp_loop_0_0 (
  clk_200m,
  clk_50m,
  sys_rst_n,
  i_payload,
  trigger_valid,
  board_mac,
  board_ip,
  pc_mac,
  pc_ip,
  board_port,
  pc_port,
  eth_mdc,
  eth_mdio,
  net_rxc,
  net_rx_ctl,
  net_rxd,
  net_txc,
  net_tx_ctl,
  net_txd,
  net_rst_n
);

input wire clk_200m;
input wire clk_50m;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME sys_rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 sys_rst_n RST" *)
input wire sys_rst_n;
input wire [87 : 0] i_payload;
(* X_INTERFACE_INFO = "analog.com:interface:fifo_rd:1.0 trigger VALID" *)
input wire trigger_valid;
input wire [47 : 0] board_mac;
input wire [31 : 0] board_ip;
input wire [47 : 0] pc_mac;
input wire [31 : 0] pc_ip;
input wire [15 : 0] board_port;
input wire [15 : 0] pc_port;
output wire eth_mdc;
inout wire eth_mdio;
input wire net_rxc;
input wire net_rx_ctl;
input wire [3 : 0] net_rxd;
output wire net_txc;
output wire net_tx_ctl;
output wire [3 : 0] net_txd;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME net_rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 net_rst_n RST" *)
output wire net_rst_n;

  net_udp_loop #(
    .IDELAY_VALUE(0),
    .UDP_PAYLOAD_BYTES(11)
  ) inst (
    .clk_200m(clk_200m),
    .clk_50m(clk_50m),
    .sys_rst_n(sys_rst_n),
    .i_payload(i_payload),
    .trigger_valid(trigger_valid),
    .board_mac(board_mac),
    .board_ip(board_ip),
    .pc_mac(pc_mac),
    .pc_ip(pc_ip),
    .board_port(board_port),
    .pc_port(pc_port),
    .eth_mdc(eth_mdc),
    .eth_mdio(eth_mdio),
    .net_rxc(net_rxc),
    .net_rx_ctl(net_rx_ctl),
    .net_rxd(net_rxd),
    .net_txc(net_txc),
    .net_tx_ctl(net_tx_ctl),
    .net_txd(net_txd),
    .net_rst_n(net_rst_n)
  );
endmodule
