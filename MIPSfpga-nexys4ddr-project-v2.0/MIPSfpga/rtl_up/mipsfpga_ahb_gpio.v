// mipsfpga_ahb_gpio.v
//
// General-purpose I/O module for Altera's DE2-115 and 
// Digilent's (Xilinx) Nexys4-DDR board
//
// Altera's DE2-115 board:
// Outputs:
// 18 red LEDs (IO_LEDR), 9 green LEDs (IO_LEDG) 
// Inputs:
// 18 slide switches (IO_Switch), 4 pushbutton switches (IO_PB[3:0])
//
// Digilent's (Xilinx) Nexys4-DDR board:
// Outputs:
// 15 LEDs (IO_LEDR[14:0]) 
// Inputs:
// 15 slide switches (IO_Switch[14:0]), 
// 5 pushbutton switches (IO_PB)
//


`timescale 100ps/1ps

`include "mipsfpga_ahb_const.vh"


module mipsfpga_ahb_gpio(
    input               HCLK,
    input               HRESETn,
    input      [  3: 0] HADDR,
    input      [ 31: 0] HWDATA,
    input               HWRITE,
    input               HSEL,
    output reg [ 31: 0] HRDATA,

// memory-mapped I/O
    input      [ 17: 0] IO_Switch,
    input      [  4: 0] IO_PB,
    output reg [ 17: 0] IO_LEDR,
    output reg [  8: 0] IO_LEDG
);


    always @(posedge HCLK or negedge HRESETn)
       if (~HRESETn) begin
         IO_LEDR <= 18'b0;  // Red LEDs
         IO_LEDG <= 9'b0;  // Green LEDs
       end else if (HWRITE & HSEL)
         case (HADDR)
           `H_LEDR_IONUM: IO_LEDR <= HWDATA[17:0];
           `H_LEDG_IONUM: IO_LEDG <= HWDATA[8:0];
         endcase
    
    always @(*)
      case (HADDR)
        `H_SW_IONUM: HRDATA = {14'b0, IO_Switch};
        `H_PB_IONUM: HRDATA = {27'b0, IO_PB};
        default:     HRDATA = 32'h00000000;
      endcase

endmodule

