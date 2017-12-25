// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE

module m14k_cpz_antitamper_stub(
	gfclk,
	greset,
	gscanenable,
	mpc_run_m,
	sec_ld,
	sec_rd,
	sec_indx,
	cpz,
	siu_slip,
	secReg,
	cpz_rslip_e,
	cpz_rclen,
	cpz_rclval,
	cpz_scramblecfg_write,
	cpz_scramblecfg_sel,
	cpz_scramblecfg_data,
	antitamper_present);

	input gfclk;
	input greset;
	input gscanenable;
	input mpc_run_m;
	input sec_ld;
	input sec_rd;
	input [2:0] sec_indx;
	input [31:0] cpz;
	input siu_slip;
	output [31:0] secReg;
	output cpz_rslip_e;
	output cpz_rclen;
	output [1:0] cpz_rclval;
	output cpz_scramblecfg_write;
	output [7:0] cpz_scramblecfg_sel;
	output [31:0] cpz_scramblecfg_data;
	output antitamper_present;

// BEGIN Wire declarations made by MVP
wire [31:0] /*[31:0]*/ secReg;
wire [1:0] /*[1:0]*/ cpz_rclval;
wire [7:0] /*[7:0]*/ cpz_scramblecfg_sel;
wire cpz_rclen;
wire cpz_scramblecfg_write;
wire antitamper_present;
wire [31:0] /*[31:0]*/ cpz_scramblecfg_data;
wire cpz_rslip_e;
// END Wire declarations made by MVP


	assign secReg [31:0] = 32'b0;
	assign cpz_rslip_e = 1'b0;
	assign cpz_rclen = 1'b0;
	assign cpz_rclval [1:0] = 2'bx;
	assign cpz_scramblecfg_write = 1'b0;
	assign cpz_scramblecfg_sel [7:0] = 8'bx;
	assign cpz_scramblecfg_data [31:0] = 32'bx;
	assign antitamper_present = 1'b0;

endmodule

