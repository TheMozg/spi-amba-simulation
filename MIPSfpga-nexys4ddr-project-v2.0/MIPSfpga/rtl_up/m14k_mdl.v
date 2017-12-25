// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// Description: m14k_mdl
//     MDU_lite Top-level Module
//
// $Id: \$
// mips_repository_id: m14k_mdl.hook, v 1.15 
//

//	mips_start_of_legal_notice
//	***************************************************************************
//	Unpublished work (c) MIPS Technologies, Inc.  All rights reserved. 
//	Unpublished rights reserved under the copyright laws of the United States
//	of America and other countries.
//	
//	MIPS TECHNOLOGIES PROPRIETARY / RESTRICTED CONFIDENTIAL - HEIGHTENED
//	STANDARD OF CARE REQUIRED AS PER CONTRACT
//	
//	This code is confidential and proprietary to MIPS Technologies, Inc. ("MIPS
//	Technologies") and may be disclosed only as permitted in writing by MIPS
//	Technologies.  Any copying, reproducing, modifying, use or disclosure of
//	this code (in whole or in part) that is not expressly permitted in writing
//	by MIPS Technologies is strictly prohibited.  At a minimum, this code is
//	protected under trade secret, unfair competition and copyright laws. 
//	Violations thereof may result in criminal penalties and fines.
//	
//	MIPS Technologies reserves the right to change the code to improve
//	function, design or otherwise.	MIPS Technologies does not assume any
//	liability arising out of the application or use of this code, or of any
//	error or omission in such code.  Any warranties, whether express,
//	statutory, implied or otherwise, including but not limited to the implied
//	warranties of merchantability or fitness for a particular purpose, are
//	excluded.  Except as expressly provided in any written license agreement
//	from MIPS Technologies, the furnishing of this code does not give recipient
//	any license to any intellectual property rights, including any patent
//	rights, that cover this code.
//	
//	This code shall not be exported, reexported, transferred, or released,
//	directly or indirectly, in violation of the law of any country or
//	international law, regulation, treaty, Executive Order, statute, amendments
//	or supplements thereto.  Should a conflict arise regarding the export,
//	reexport, transfer, or release of this code, the laws of the United States
//	of America shall be the governing law.
//	
//	This code may only be disclosed to the United States government
//	("Government"), or to Government users, with prior written consent from
//	MIPS Technologies.  This code constitutes one or more of the following:
//	commercial computer software, commercial computer software documentation or
//	other commercial items.  If the user of this code, or any related
//	documentation of any kind, including related technical data or manuals, is
//	an agency, department, or other entity of the Government, the use,
//	duplication, reproduction, release, modification, disclosure, or transfer
//	of this code, or any related documentation of any kind, is restricted in
//	accordance with Federal Acquisition Regulation 12.212 for civilian agencies
//	and Defense Federal Acquisition Regulation Supplement 227.7202 for military
//	agencies.  The use of this code by the Government is further restricted in
//	accordance with the terms of the license agreement(s) and/or applicable
//	contract terms and conditions covering this code from MIPS Technologies.
//	
//	
//	
//	***************************************************************************
//	mips_end_of_legal_notice
//	

// Comments for verilint...Some of this module is encapsulated in synopsys translate
//  directives, so need to disable verilint unused variable warnings
//verilint 123 off  // Variable never gets set
//verilint 241 off  // Output never gets set
//verilint 528 off  // Variable set but not used

`include "m14k_const.vh"
module m14k_mdl(
	edp_abus_e,
	edp_bbus_e,
	gclk,
	greset,
	gscanenable,
	mpc_ekillmd_m,
	mpc_wrdsp_e,
	mpc_ir_e,
	mpc_predec_e,
	mpc_umipspresent,
	mpc_irval_e,
	mpc_killmd_m,
	mpc_run_ie,
	mpc_run_m,
	mpc_srcvld_e,
	MDU_run_ag,
	MDU_ir_ag,
	edp_dsp_present_xx,
	MDU_dec_ag,
	MDU_opcode_issue_ag,
	MDU_run_ex,
	MDU_nullify_ex,
	MDU_data_valid_ex,
	MDU_rs_ex,
	MDU_rt_ex,
	alu_cp0_rtc_ex,
	alu_dsp_pos_r_ex,
	MDU_run_ms,
	MDU_nullify_ms,
	MDU_data_ack_ms,
	MDU_run_er,
	MDU_nullify_er,
	MDU_kill_er,
	mpc_dest_e,
	MDU_data_val_ex,
	MDU_stallreq_ag,
	mdu_type,
	MDU_pend_ouflag_wr_xx,
	MDU_ouflag_vld_xx,
	MDU_ouflag_hilo_xx,
	MDU_ouflag_mulq_muleq_xx,
	MDU_ouflag_extl_extr_xx,
	MDU_ouflag_age_xx,
	MDU_ouflag_tcid_xx,
	MDU_count_sat_xx,
	MDU_count_sat_tcid_xx,
	MDU_rfwrite_ms,
	MDU_dest_ms,
	mdu_alive_gpr_m1,
	mdu_alive_gpr_m2,
	mdu_alive_gpr_m3,
	mdu_mf_m1,
	mdu_mf_m2,
	mdu_mf_m3,
	mdu_mf_a,
	mdu_nullify_m2,
	mdu_dest_m1,
	mdu_dest_m2,
	mdu_dest_m3,
	mdu_stall_issue_xx,
	mdu_alive_gpr_a,
	mdu_busy,
	mdu_res_w,
	mdu_stall,
	mdu_result_done,
	MDU_info_e);


input [31:0] 	edp_abus_e;
input [31:0] 	edp_bbus_e;
input 		gclk;
input 		greset;
input 		gscanenable;
input 		mpc_ekillmd_m;
input 		mpc_wrdsp_e;
input [31:0] 	mpc_ir_e;
input [22:0]  	mpc_predec_e;
input		mpc_umipspresent;
input 		mpc_irval_e;
input 		mpc_killmd_m;
input 		mpc_run_ie;
input 		mpc_run_m;
input 		mpc_srcvld_e;

  // AG stage I/O
  input           MDU_run_ag;     // Run signal from ALU
  input [31:0]    MDU_ir_ag;   // Instruction word for source/dest and RI decode
  input		  edp_dsp_present_xx;
  input           MDU_dec_ag;  // Instruction word on MDU_ir_ag decodes to a 
                               // MDU/UDI instruction. This is used by the MDU
                               // to determine when to assert stallreq without
                               // using MDU_opcode_issue_ag because 
                               // MDU_opcode_issue_ag is timing critical.
  input           MDU_opcode_issue_ag; // issue Instruction on MDU_ir_ag; active
                                       // the last cycle Instruction is in AG

  // EX stage I/O
  input           MDU_run_ex;     // Run signal from ALU
  input		  MDU_nullify_ex;  // Nullify inst already sent to MDU before
                                   // it gets to MS stage
  input           MDU_data_valid_ex;  // Data word(s) to udi/MDU valid. 
                                      // Asserted for the remain of EX
  input [31:0]    MDU_rs_ex;      // Source operand
  input [31:0]    MDU_rt_ex;      // Source operand
  input [8:0]     alu_cp0_rtc_ex;  // selects which TC a MTTR/MFTR accesses
  input [5:0]     alu_dsp_pos_r_ex; // pos - size - 1


  // MS stage I/O
  input           MDU_run_ms;     // Run signal from ALU
  input           MDU_nullify_ms;       // Nullify MDU instruction in MS
  input           MDU_data_ack_ms; // Result returned to ALU when this signal
                                   // is asserted asserted is accepted. 
                                   // Otherwise, MDU_rd_strobe_ms must be kept
                                   // asserted until this signal is asserted.
  // ER stage I/O
  input           MDU_run_er;     // Run signal from ALU
  input           MDU_nullify_er;      // Nullify MDU instruction in ER
  input           MDU_kill_er;       // Kill signal due to an exception 
                                     // generated by an earlier instruction
  input [4:0]     mpc_dest_e;
  input           MDU_data_val_ex;


  output          MDU_stallreq_ag;  // Stalls MDU instr moving from AG to EX 
                                    // next cycle.

  // no particular stage I/O
  output          mdu_type;    //MDU type: 0 normal, 1 iterative

  output [8:0]    MDU_pend_ouflag_wr_xx; // update to ouflag pending 
  output          MDU_ouflag_vld_xx;  // ouflag values are valid
  output [3:0]    MDU_ouflag_hilo_xx; // ouflag values for HI/LO sets
  output          MDU_ouflag_mulq_muleq_xx;  // ouflag value for MULQ/MULEQ
  output          MDU_ouflag_extl_extr_xx;  // ouflag value for EXTL/R
  output [1:0]    MDU_ouflag_age_xx;  // age of instr. setting ouflag
  output [3:0]    MDU_ouflag_tcid_xx;  // TC id of instr. setting ouflag
  output          MDU_count_sat_xx;  // Increment MDU saturation count in
                                     // performance counter
  output [3:0]    MDU_count_sat_tcid_xx;  // TC id of performance counter
  output          MDU_rfwrite_ms;
  output [4:0]    MDU_dest_ms;         
  output          mdu_alive_gpr_m1;
  output          mdu_alive_gpr_m2;
  output          mdu_alive_gpr_m3;
  output          mdu_mf_m1;
  output          mdu_mf_m2;
  output          mdu_mf_m3;
  output          mdu_mf_a;
  output          mdu_nullify_m2;
  output [4:0]    mdu_dest_m1;         
  output [4:0]    mdu_dest_m2;         
  output [4:0]    mdu_dest_m3;         
  output          mdu_stall_issue_xx;
  output          mdu_alive_gpr_a;

output 		mdu_busy;
output [31:0] 	mdu_res_w;
output 		mdu_stall;
output 		mdu_result_done;
output [39:0] MDU_info_e;

// BEGIN Wire declarations made by MVP
wire [8:0] /*[8:0]*/ MDU_pend_ouflag_wr_xx;
wire mdu_mf_m3;
wire mdu_alive_gpr_m3;
wire MDU_ouflag_mulq_muleq_xx;
wire [3:0] /*[3:0]*/ MDU_ouflag_hilo_xx;
wire [3:0] /*[3:0]*/ MDU_count_sat_tcid_xx;
wire [4:0] /*[4:0]*/ mdu_dest_m1;
wire MDU_ouflag_vld_xx;
wire mdu_mf_m2;
wire MDU_count_sat_xx;
wire mdu_alive_gpr_m2;
wire mdu_mf_a;
wire [4:0] /*[4:0]*/ mdu_dest_m2;
wire mdu_stall_issue_xx;
wire [4:0] /*[4:0]*/ MDU_dest_ms;
wire mdu_alive_gpr_a;
wire MDU_rfwrite_ms;
wire MDU_ouflag_extl_extr_xx;
wire MDU_stallreq_ag;
wire mdu_mf_m1;
wire [4:0] /*[4:0]*/ mdu_dest_m3;
wire [1:0] /*[1:0]*/ MDU_ouflag_age_xx;
wire mdu_alive_gpr_m1;
wire [3:0] /*[3:0]*/ MDU_ouflag_tcid_xx;
wire [39:0] /*[39:0]*/ MDU_info_e;
wire mdu_nullify_m2;
// END Wire declarations made by MVP


/*hookios*//* IO declarations added by hookup */
/* End of hookup IO declarations */
/* Wire declarations added by hookup */
wire b_inv_sel;		// Invert all bits on B input to adder
wire c_in;		// Carry in to adder
wire carry_out;		// Carry out from adder
wire dm_cond;		// Register Update to dm.
wire dm_sgn;		// dm sign bit
wire hi_cond;		// Register Update to hi
wire hi_lo_sel;		// hilo selector
wire [1:0] hilo_rp_zero_sel;		// A input selector
wire lo_cond;		// Register Update to lo
wire mdu_active;		// Gating signal for ucregisters
wire qp_lsb;		// qp LSB bit (for Booth)
wire qp_lsb_early;		// qp LSB bit (for Booth)
wire [1:0] qp_rpnxt_rp_sel;		// hi_nxt selector
wire qp_sgn;		// qp sign bit
wire qpnxt_abus_sel;		// qp_abus_nxt selector
wire qpnxt_qp_sel;		// lo_nxt selector
wire [1:0] rp_dm_qp_sel;		// B input selector
wire rp_sum_sgn;		// MSB of rp before shift
wire shft_in;		// Bit to shift in on Up/Down shift
wire shift_out;		// Drop out from shifter on down shift
wire shift_qp_sel;		// qp_nxt selector
wire shift_rp_sel;		// rp_nxt selector
wire sum_qp_sel;		// qp_sum selector
wire up_dwn_sel;		// Shift direction selecter
wire [1:0] zero_rp_sum_sel;		// rp_sum selector
/* End of hookup wire declarations */


assign MDU_info_e [39:0] = 40'b0;

assign MDU_stallreq_ag          = 1'b0;

assign MDU_pend_ouflag_wr_xx [8:0]    = 9'b0;

assign MDU_ouflag_vld_xx          = 1'b0;
assign MDU_ouflag_hilo_xx [3:0]    = 4'b0;
assign MDU_ouflag_mulq_muleq_xx          = 1'b0;
assign MDU_ouflag_extl_extr_xx          = 1'b0;
assign MDU_ouflag_age_xx [1:0]    = 2'b0;
assign MDU_ouflag_tcid_xx [3:0]    = 4'b0;
assign MDU_count_sat_xx          = 1'b0;

assign MDU_count_sat_tcid_xx [3:0]    = 4'b0;
assign MDU_rfwrite_ms          = 1'b0;
assign MDU_dest_ms [4:0]    = 5'b0;
assign mdu_alive_gpr_m1          = 1'b0;
assign mdu_alive_gpr_m2          = 1'b0;
assign mdu_alive_gpr_m3          = 1'b0;
assign mdu_mf_m1          = 1'b0;
assign mdu_mf_m2          = 1'b0;
assign mdu_mf_m3          = 1'b0;
assign mdu_mf_a          = 1'b0;
assign mdu_nullify_m2          = 1'b0;
assign mdu_dest_m1 [4:0]    = 5'b0;
assign mdu_dest_m2 [4:0]    = 5'b0;
assign mdu_dest_m3 [4:0]    = 5'b0;
assign mdu_stall_issue_xx          = 1'b0;
assign mdu_alive_gpr_a          = 1'b0;

/*hookup*/
m14k_mdl_ctl mdl_ctl(
	.b_inv_sel(b_inv_sel),
	.c_in(c_in),
	.carry_out(carry_out),
	.dm_cond(dm_cond),
	.dm_sgn(dm_sgn),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.hi_cond(hi_cond),
	.hi_lo_sel(hi_lo_sel),
	.hilo_rp_zero_sel(hilo_rp_zero_sel),
	.lo_cond(lo_cond),
	.mdu_active(mdu_active),
	.mdu_busy(mdu_busy),
	.mdu_result_done(mdu_result_done),
	.mdu_stall(mdu_stall),
	.mdu_type(mdu_type),
	.mpc_ekillmd_m(mpc_ekillmd_m),
	.mpc_ir_e(mpc_ir_e),
	.mpc_irval_e(mpc_irval_e),
	.mpc_killmd_m(mpc_killmd_m),
	.mpc_predec_e(mpc_predec_e),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_srcvld_e(mpc_srcvld_e),
	.mpc_umipspresent(mpc_umipspresent),
	.qp_lsb(qp_lsb),
	.qp_lsb_early(qp_lsb_early),
	.qp_rpnxt_rp_sel(qp_rpnxt_rp_sel),
	.qp_sgn(qp_sgn),
	.qpnxt_abus_sel(qpnxt_abus_sel),
	.qpnxt_qp_sel(qpnxt_qp_sel),
	.rp_dm_qp_sel(rp_dm_qp_sel),
	.rp_sum_sgn(rp_sum_sgn),
	.shft_in(shft_in),
	.shift_out(shift_out),
	.shift_qp_sel(shift_qp_sel),
	.shift_rp_sel(shift_rp_sel),
	.sum_qp_sel(sum_qp_sel),
	.up_dwn_sel(up_dwn_sel),
	.zero_rp_sum_sel(zero_rp_sum_sel));


/*hookup*/
m14k_mdl_dp mdl_dp(
	.b_inv_sel(b_inv_sel),
	.c_in(c_in),
	.carry_out(carry_out),
	.dm_cond(dm_cond),
	.dm_sgn(dm_sgn),
	.edp_abus_e(edp_abus_e),
	.edp_bbus_e(edp_bbus_e),
	.gclk(gclk),
	.gscanenable(gscanenable),
	.hi_cond(hi_cond),
	.hi_lo_sel(hi_lo_sel),
	.hilo_rp_zero_sel(hilo_rp_zero_sel),
	.lo_cond(lo_cond),
	.mdu_active(mdu_active),
	.mdu_res_w(mdu_res_w),
	.qp_lsb(qp_lsb),
	.qp_lsb_early(qp_lsb_early),
	.qp_rpnxt_rp_sel(qp_rpnxt_rp_sel),
	.qp_sgn(qp_sgn),
	.qpnxt_abus_sel(qpnxt_abus_sel),
	.qpnxt_qp_sel(qpnxt_qp_sel),
	.rp_dm_qp_sel(rp_dm_qp_sel),
	.rp_sum_sgn(rp_sum_sgn),
	.shft_in(shft_in),
	.shift_out(shift_out),
	.shift_qp_sel(shift_qp_sel),
	.shift_rp_sel(shift_rp_sel),
	.sum_qp_sel(sum_qp_sel),
	.up_dwn_sel(up_dwn_sel),
	.zero_rp_sum_sel(zero_rp_sum_sel));

   // 
    `ifdef MIPS_SIMULATION 
 //VCS coverage off 
   // 
   // mvp doesnt like direct hooks into modules
   // Generate hook wires for watcher
   wire	       write2lo, write2hi;
   wire [31:0] HIData, LOData;
   wire        mthi_m,	mtlo_m;
   wire [31:0] hiwb, lowb;

   wire [31:0]  hi, lo;
   assign       hi = mdl_dp.hi[31:0];
   assign       lo = mdl_dp.lo[31:0];
wire	mul_advance_m2 = 1'b0;
wire	mul_advance_m3 = 1'b0;
wire	mul_advance_a = 1'b0;
wire	mul_alive_a = 1'b0;
wire	mul_write_hilo_a = 1'b0;
wire	mul_advance_alive_a = 1'b0;
wire	stall_xx = 1'b0;
wire	dresult_done = 1'b0;
wire	valid_de = 1'b0;
wire	div_still_alive_xx = 1'b0;
wire	[4:0]	dest_a = 5'd0;
wire	[31:0]	mul_rd_a = 32'd0;
wire	mul_mtlo_a = 1'b0;
wire	mul_mthi_a = 1'b0;

   assign      write2lo = mdl_ctl.lo_cond;
   assign      write2hi = mdl_ctl.hi_cond;
   assign      LOData = mdl_dp.lo_nxt;
   assign      HIData = mdl_dp.hi_nxt;
   assign      mthi_m = mdl_ctl.cmd_m[2];
   assign      mtlo_m = mdl_ctl.cmd_m[1];
   assign      hiwb = mdl_dp.hi_nxt;
   assign      lowb = mdl_dp.lo_nxt;

wire          tracer_inst_wr_hilo_ag;
wire [1:0]    tracer_inst_wr_hilo_id_ag;
wire          tracer_lo_wr_strobe;
wire          tracer_hi_wr_strobe;
wire [31:0]   tracer_hi_xx_next;
wire [31:0]   tracer_lo_xx_next;
wire [1:0]    tracer_hilo_id_wr_xx;
wire [31:0]   tracer_hi_xx;
wire [31:0]   tracer_lo_xx;

     //VCS coverage on  
 `endif 
   // 
   // 

//verilint 123 on  // Variable never gets set
//verilint 241 on  // Output never gets set
//verilint 528 on  // Variable set but not used
endmodule
