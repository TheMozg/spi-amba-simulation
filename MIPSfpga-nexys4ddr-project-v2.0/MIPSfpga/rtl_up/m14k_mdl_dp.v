// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// Description: m14k_mdl_dp 
//      MDU_lite Datapath Module
//
// $Id: \$
// mips_repository_id: m14k_mdl_dp.mv, v 1.2 
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

`include "m14k_const.vh"
module m14k_mdl_dp(
	gclk,
	gscanenable,
	edp_abus_e,
	edp_bbus_e,
	mdu_active,
	dm_cond,
	hi_cond,
	lo_cond,
	b_inv_sel,
	c_in,
	shft_in,
	up_dwn_sel,
	rp_dm_qp_sel,
	hilo_rp_zero_sel,
	sum_qp_sel,
	zero_rp_sum_sel,
	shift_rp_sel,
	shift_qp_sel,
	qpnxt_abus_sel,
	qpnxt_qp_sel,
	qp_rpnxt_rp_sel,
	hi_lo_sel,
	mdu_res_w,
	carry_out,
	rp_sum_sgn,
	shift_out,
	dm_sgn,
	qp_sgn,
	qp_lsb,
	qp_lsb_early);



   /* Inputs */

   // All xxxUpdate input are active high.
   // All Select signals for multiplexer's select first one on 1 and second on 0.
   // 3-wayu select user bit 1 for first, and bit 0 for next two.

   // External inputs
   input 	 gclk;			// Global clock
   input 	 gscanenable;		// gscanenable
   input [31:0]  edp_abus_e;		// Register RS from register file
   input [31:0]  edp_bbus_e;		// Register RT from register file

   // Register update controls
   input 	 mdu_active;		// Gating signal for ucregisters
   input 	 dm_cond;		// Register update to dm.
   input 	 hi_cond;		// Register update to hi
   input 	 lo_cond;		// Register update to lo

   // Logic block controls
   input 	 b_inv_sel;		// Invert all bits on B input to adder
   input 	 c_in;			// Carry in to adder
   input 	 shft_in;		// Bit to shift in on Up/Down shift
   input 	 up_dwn_sel;		// Shift direction selecter

   // Multiplexer controls
   input [1:0] 	 rp_dm_qp_sel;		// B input selector
   input [1:0] 	 hilo_rp_zero_sel;	// A input selector
   input 	 sum_qp_sel;		// qp_sum selector
   input [1:0] 	 zero_rp_sum_sel;	// rp_sum selector
   input 	 shift_rp_sel;		// rp_nxt selector
   input 	 shift_qp_sel;		// qp_nxt selector
   input 	 qpnxt_abus_sel;	// qp_abus_nxt selector
   input 	 qpnxt_qp_sel;		// lo_nxt selector
   input [1:0] 	 qp_rpnxt_rp_sel;	// hi_nxt selector
   input 	 hi_lo_sel;		// hilo selector
   
   /* Outputs */
   
   // External outputs
   output [31:0] mdu_res_w;		// Destination register RD to register file
   
   // state machine result inputs
   output 	 carry_out;		// Carry out from adder
   output 	 rp_sum_sgn; 	 	// MSB of rp before shift
   output 	 shift_out;		// Drop out from shifter on down shift
   output 	 dm_sgn;		// dm sign bit
   output 	 qp_sgn;		// qp sign bit
   output 	 qp_lsb;		// qp LSB bit (for Booth)
   output 	 qp_lsb_early;		// qp LSB bit (for Booth)

// BEGIN Wire declarations made by MVP
wire [31:0] /*[31:0]*/ qp;
wire [31:0] /*[31:0]*/ rp;
wire [31:0] /*[31:0]*/ qp_shift;
wire [31:0] /*[31:0]*/ rp_nxt;
wire qp_lsb_early;
wire [31:0] /*[31:0]*/ hi;
wire shift_out;
wire [31:0] /*[31:0]*/ rp_sum;
wire [31:0] /*[31:0]*/ b_in;
wire [31:0] /*[31:0]*/ hilo;
wire qp_sgn;
wire [31:0] /*[31:0]*/ lo;
wire [31:0] /*[31:0]*/ qp_sum;
wire [31:0] /*[31:0]*/ rp_shift;
wire [31:0] /*[31:0]*/ hi_nxt;
wire [31:0] /*[31:0]*/ qp_nxt;
wire [31:0] /*[31:0]*/ pre_inv_b_in;
wire [31:0] /*[31:0]*/ a_in;
wire dm_sgn;
wire [31:0] /*[31:0]*/ dm;
wire [31:0] /*[31:0]*/ lo_nxt;
wire rp_sum_sgn;
wire [31:0] /*[31:0]*/ qp_abus_nxt;
wire qp_lsb;
wire [31:0] /*[31:0]*/ mdu_res_w;
// END Wire declarations made by MVP

   
   /* Inouts */

   /* End I/O's */

   /* Wires */
   wire [31:0] 	 sum;

   //
   // Datapass Top -> Down 
   //

   // Divisor/Multiplicand register. Is loaded directly from edp_bbus_e with RT.
   mvp_cregister_wide #(32) _dm_31_0_(dm[31:0],gscanenable, dm_cond, gclk, edp_bbus_e);
   assign dm_sgn = dm[31];

   // A input to Adder.
   assign a_in [31:0] = hilo_rp_zero_sel[1] ? hilo :
		   hilo_rp_zero_sel[0] ? rp : 32'd0;

   // B input to Adder before possible invert.
   assign pre_inv_b_in [31:0] = rp_dm_qp_sel[1] ? rp :
			 rp_dm_qp_sel[0] ? dm : qp;

   // Invert B input if subtraction is needed
   assign b_in [31:0] = b_inv_sel ? ~pre_inv_b_in : pre_inv_b_in;

   // 32-bit FullAdder
   // c_in are controlled from controller mdc_lite.
   // carry_out is send to controller mdc_lite.
   `M14K_MDL_ADD mdl_add ( .a(a_in),
			 .b(b_in),
			 .ci(c_in),
			 .s(sum),
			 .co(carry_out)
			 );
   
   // Select which calculated result to use for Remainder/Product (HI).
   assign rp_sum [31:0] = zero_rp_sum_sel[1] ? 32'd0 :
		   zero_rp_sum_sel[0] ? rp : sum;
   assign rp_sum_sgn = rp_sum[31];

   // Select which calculated result to use for Quotient/Product (LO).
   // edp_abus_e is RS input to MDU.
   assign qp_sum [31:0] = sum_qp_sel ? sum : qp;

   // Shift rp_sum:qp_sum Up or down to generate rp_shift:qp_shift.
   // UP (divide algorithm): shft_in to LSB controlled from controller mdl_ctl (shift_out not used).
   // DOWN (multiply algorithm): shft_in to MSB, send LSB to controller as shift_out.
   assign rp_shift [31:0] = up_dwn_sel ? {rp_sum[30:0], qp_sum[31]} : {shft_in, rp_sum[31:1]};
   assign qp_shift [31:0] = up_dwn_sel ? {qp_sum[30:0], shft_in} : {rp_sum[0], qp_sum[31:1]};
   assign shift_out = qp_sum[0];

   // Select wheater to use Shifted or calculated result for next version of Rp and Qp.
   assign rp_nxt [31:0] = shift_rp_sel ? rp_shift : rp_sum;
   assign qp_nxt [31:0] = shift_qp_sel ? qp_shift : qp_sum;

   // Sekect between qp_nxt and Abus for Qp.
   assign qp_abus_nxt [31:0] = qpnxt_abus_sel ? qp_nxt : edp_abus_e;
   
   // Remainder/Product (HI) register.
   mvp_ucregister_wide #(32) _rp_31_0_(rp[31:0],gscanenable, mdu_active, gclk, rp_nxt);

   // Quotient/Product (LO) register.
   mvp_ucregister_wide #(32) _qp_31_0_(qp[31:0],gscanenable, mdu_active, gclk, qp_abus_nxt);
   assign qp_sgn = qp[31];
   assign qp_lsb = qp[0];
   assign qp_lsb_early = qp_abus_nxt[0];

   // Select what to use if HI is reloaded. rp is used on MTHI.
   assign hi_nxt [31:0] = qp_rpnxt_rp_sel[1] ? qp :
		  qp_rpnxt_rp_sel[0] ? rp_nxt : rp;

   // Select what to use if LO is reloaded. 
   assign lo_nxt [31:0] = qpnxt_qp_sel ? qp_nxt : qp;

   // HI and LO registers. Conditionally loaded.
   mvp_cregister_wide #(32) _hi_31_0_(hi[31:0],gscanenable, hi_cond, gclk, hi_nxt);
   mvp_cregister_wide #(32) _lo_31_0_(lo[31:0],gscanenable, lo_cond, gclk, lo_nxt);

   // Select between HI and LO register MACC commands or for Move From HI/LO.
   assign hilo [31:0] = hi_lo_sel ? hi : lo;

   // Final output assign.
   assign mdu_res_w [31:0] = hilo;

endmodule
