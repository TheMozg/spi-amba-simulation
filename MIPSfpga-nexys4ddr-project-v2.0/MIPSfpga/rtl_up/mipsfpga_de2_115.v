// mipsfpga_de2_115.v
// 22 Oct 2014
//
// Instantiate the mipsfpga system and rename signals to
// match GPIO, LEDs and switches on Altera's DE2-115 board

// Altera's DE2-115 board:
// Outputs:
// 18 red LEDs (IO_LEDR), 9 green LEDs (IO_LEDG) 
// Inputs:
// 18 slide switches (IO_Switch), 4 pushbutton switches (IO_PB[3:0])
//
// Note the right-most pushbutton IO_PB[0] (KEY[0] on the board)
// is used to reset the processor.

module mipsfpga_de2_115(input         CLOCK_50,
				 input  [17:0] SW,
				 input  [ 3:0] KEY,
				 output [17:0] LEDR,
				 output [ 8:0] LEDG,
				 inout  [ 6:0] EXT_IO);

  // Use KEY[0] (push button switch 0) for SI_Reset_N. 
  // Note: KEY[0] must be pushed down (held low) to reset the processor. 
          
  wire clk_out;
  
  altpll0 altpll0 (.inclk0(CLOCK_50), .c0(clk_out));


  mipsfpga_sys mipsfpga_sys(.SI_Reset_N(KEY[0]),
                    .SI_ClkIn(clk_out),
                    .HADDR(),
                    .HRDATA(),
                    .HWDATA(),
                    .HWRITE(),
                    .EJ_TRST_N_probe(EXT_IO[6]),
                    .EJ_TDI(EXT_IO[5]),
                    .EJ_TDO(EXT_IO[4]),
                    .EJ_TMS(EXT_IO[3]),
                    .EJ_TCK(EXT_IO[2]),
                    .SI_ColdReset_N(EXT_IO[1]),
                    .EJ_DINT(EXT_IO[0]),
                    .IO_Switch(SW),
                    .IO_PB({1'b0, ~KEY}),
                    .IO_LEDR(LEDR),
                    .IO_LEDG(LEDG));
          
endmodule


