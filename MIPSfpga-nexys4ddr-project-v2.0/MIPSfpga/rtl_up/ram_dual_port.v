// 7 November 2014
//
// Made after Altera's simple dual-port memory template

module ram_dual_port 
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=6)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] read_addr, write_addr,
	input we, clk,
	output reg [(DATA_WIDTH-1):0] q
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

	initial
	begin
	  $readmemh("ram_program_init.txt", ram);
	end

	always @ (posedge clk)
	begin
		// Write
		if (we)
			ram[write_addr] <= data;

		q <= ram[read_addr];
	end

endmodule

