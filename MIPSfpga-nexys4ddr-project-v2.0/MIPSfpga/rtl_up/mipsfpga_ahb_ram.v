// mipsfpga_ahb_ram.v
// 
// Program RAM

`timescale 100ps/1ps

`include "mipsfpga_ahb_const.vh"

module mipsfpga_ahb_ram
(
    input               HCLK,
    input               HRESETn,
    input      [ 31: 0] HADDR,
    input      [ 31: 0] HWDATA,
    input               HWRITE,
    input               HSEL,
    output     [ 31: 0] HRDATA 
);

  wire [31:0] HADDR_d;

  flop #(32)  adrreg(HCLK, HADDR, HADDR_d);

  ram_dual_port #(32, `H_RAM_ADDR_WIDTH) ram_dual_port
  (
    .data(HWDATA),
    .read_addr(HADDR[(`H_RAM_ADDR_WIDTH+1):2]),
    .write_addr(HADDR_d[(`H_RAM_ADDR_WIDTH+1):2]),
    .we( (HWRITE & HSEL) ),
    .clk(HCLK),
    .q(HRDATA)
  );

endmodule


