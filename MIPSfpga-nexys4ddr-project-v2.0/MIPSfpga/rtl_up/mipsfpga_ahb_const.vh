// 
// mipsfpga_ahb_const.vh
//
// Verilog include file with AHB definitions
// 

//-------------------------------------------
// Memory-mapped I/O addresses
//-------------------------------------------
`define H_LEDR_ADDR   			(32'h1f800000)
`define H_LEDG_ADDR   			(32'h1f800004)
`define H_SW_ADDR   			(32'h1f800008)
`define H_PB_ADDR   			(32'h1f80000c)

`define H_LEDR_IONUM   			(4'h0)
`define H_LEDG_IONUM   			(4'h1)
`define H_SW_IONUM  			(4'h2)
`define H_PB_IONUM  			(4'h3)

//-------------------------------------------
// RAM addresses
//-------------------------------------------
`define H_RAM_RESET_ADDR 		(32'h1fc?????)
`define H_RAM_ADDR	 		(32'h0???????)
`define H_RAM_RESET_ADDR_WIDTH		(15) 
`define H_RAM_ADDR_WIDTH		(16) 

`define H_RAM_RESET_ADDR_Match 		(7'h7f)
`define H_RAM_ADDR_Match 		(1'b0)
`define H_LEDR_ADDR_Match		(7'h7e)

