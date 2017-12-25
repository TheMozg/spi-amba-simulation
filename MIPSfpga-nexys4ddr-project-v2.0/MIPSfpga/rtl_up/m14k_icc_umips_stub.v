// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_icc_umips_stub 
//             Stub module to replace UMIPS decompressor
//             Parameterized by width
//
//      $Id: \$
//      mips_repository_id: m14k_icc_umips_stub.mv, v 1.27 
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

// Comments for verilint
// This is a stub module so most of the inputs are unused
//verilint 240 off  // Unused input
//verilint 175 off  // Unused parameter

`include "m14k_const.vh"
module m14k_icc_umips_stub(
	gscanenable,
	raw_instn_in,
	instn_in,
	cpz_rbigend_i,
	cpz_mx,
	umipsmode_i,
	umips_active,
	edp_ival_p,
	mpc_run_ie,
	mpc_fixupi,
	mpc_isachange0_i,
	mpc_isachange1_i,
	mpc_atomic_e,
	mpc_hw_ls_i,
	mpc_sel_hw_e,
	mpc_hold_epi_vec,
	mpc_epi_vec,
	mpc_int_pref,
	mpc_chain_take,
	mpc_tint,
	kill_i,
	ibe_kill_macro,
	mpc_annulds_e,
	precise_ibe,
	mpc_nonseq_e,
	kill_e,
	greset,
	hit_fb,
	hold_imiss_n,
	imbinvoke,
	data_line_sel,
	spram_sel,
	icc_imiss_i,
	icc_umipsconfig,
	mpc_itqualcond_i,
	cdmm_mputrigresraw_i,
	biu_ibe,
	poten_be,
	poten_parerr,
	gclk,
	cpz_vz,
	instn_out,
	icc_umipsri_e,
	icc_macro_e,
	icc_macroend_e,
	icc_nobds_e,
	icc_macrobds_e,
	icc_pcrel_e,
	icc_umipspresent,
	icc_halfworddethigh_i,
	icc_halfworddethigh_fifo_i,
	umipsfifo_imip,
	umipsfifo_ieip2,
	umipsfifo_ieip4,
	umipsfifo_null_i,
	umipsfifo_null_raw,
	umipsfifo_stat,
	macro_jr,
	umips_rdpgpr,
	icc_dspver_i,
	umips_sds,
	isachange1_i_reg,
	isachange0_i_reg,
	slip_n_nhalf,
	icc_umips_instn_i,
	raw_instn_in_postws,
	isachange_waysel,
	icc_dwstb_reg,
	requalify_parerr);

// synopsys template
	parameter WIDTH=5;
	parameter MEMIDX=0;     // dummy parameter to match "ports" with smodule
	
	/* Inputs */
        input			gscanenable;
	input [(48*WIDTH-1):0]	raw_instn_in;	// Raw Data from I$/FB
	input [47:0]		instn_in;
        input			cpz_rbigend_i;
	input		cpz_mx;		// indicates dsp sw enable
	input			umipsmode_i;
	input			umips_active;	// operating in UMIPS mode
	input [3:1]		edp_ival_p;

	input			mpc_run_ie;
	input			mpc_fixupi;
	input			mpc_isachange0_i;  // Indicates isa change happening during abnormal pipeline process
	input			mpc_isachange1_i;  // Indicates isa change happening during abnormal pipeline process
	input			mpc_atomic_e;		// atomic instruction at e stage
	input			mpc_hw_ls_i;		// iap/iae at i stage
	input			mpc_sel_hw_e;		// iap/iae at e stage
	input			mpc_hold_epi_vec;	// iae vector indicator
	input			mpc_epi_vec;		// 
	input			mpc_int_pref;		// interrupt prefetched indicator
	input			mpc_chain_take;		// tail chain taken
	input			mpc_tint;		// interrupt accepted
	input			kill_i;			// i stage instruction killed
	input			ibe_kill_macro;		// kill macro signal is current instn is an ibe
	input			mpc_annulds_e;		// delay slot instruction killed
	input			precise_ibe;		// incoming bus error
	input			mpc_nonseq_e;		// instruction stream is non sequential
	input			kill_e;			// e stage instruction killed
	input			greset;

	input			hit_fb;
	input			hold_imiss_n;
	input			imbinvoke;
	input [3:0]		data_line_sel;
	input [3:0]		spram_sel;
	input			icc_imiss_i;
	input [1:0]		icc_umipsconfig;
	input			mpc_itqualcond_i;
	input			cdmm_mputrigresraw_i;
	input			biu_ibe;
	input			poten_be;
	input			poten_parerr;

	input		 gclk;
	input		 cpz_vz;
	
	/* Outputs */
	output [(48*WIDTH-1):0]	instn_out;
	output	icc_umipsri_e;	// Reserved instn detected (including macro ri)
	output	icc_macro_e;	// Macro instn detected
	output	icc_macroend_e; // last macro issued on e-stage
	output	icc_nobds_e;	// No delay slot (umips branch or compact jump)
	output	icc_macrobds_e; // jraddiusp in e-stage
        output	icc_pcrel_e;	// PC relative instn
	output	icc_umipspresent;
	output	icc_halfworddethigh_i; 		// high half of i-stage instruction is 16b
	output	icc_halfworddethigh_fifo_i;	// instruction in fifo is 16b
	output	umipsfifo_imip;			// memory incr indicator (p-stage)
	output	umipsfifo_ieip2;		// PC incr+2 control
	output	umipsfifo_ieip4;		// PC incr+4 control
	output	umipsfifo_null_i;		// umips instruction slip occured
	output umipsfifo_null_raw;//raw instruction slip. only used for tracing. no loading at core level.
	output [3:0] umipsfifo_stat;		// umips fifo fullness
	output	macro_jr;			// macro is performing jump
	output [4:0] umips_rdpgpr;
	output [4:0] icc_dspver_i;
	output	umips_sds;			// short delay slot
	output isachange1_i_reg;
	output isachange0_i_reg;
	output slip_n_nhalf;
	output [31:0] icc_umips_instn_i;
	output [31:0] raw_instn_in_postws;	// raw un-recoded instn
	output [3:0] isachange_waysel;
	input icc_dwstb_reg;
	input requalify_parerr;

// BEGIN Wire declarations made by MVP
wire icc_macrobds_e;
wire [4:0] /*[4:0]*/ icc_dspver_i;
wire umipsfifo_null_i;
wire [3:0] /*[3:0]*/ umipsfifo_stat;
wire icc_macro_e;
wire [239:0] /*[239:0]*/ instn_out240;
wire slip_n_nhalf;
wire icc_macroend_e;
wire [31:0] /*[31:0]*/ raw_instn_in_postws;
wire icc_umipsri_e;
wire umipsfifo_ieip2;
wire icc_nobds_e;
wire umips_sds;
wire [31:0] /*[31:0]*/ icc_umips_instn_i;
wire umipsfifo_ieip4;
wire isachange0_i_reg;
wire [3:0] /*[3:0]*/ isachange_waysel;
wire umipsfifo_imip;
wire [(48*WIDTH-1):0] /*[239:0]*/ instn_out;
wire umipsfifo_null_raw;
wire icc_halfworddethigh_fifo_i;
wire [4:0] /*[4:0]*/ umips_rdpgpr;
wire isachange1_i_reg;
wire icc_umipspresent;
wire macro_jr;
wire icc_halfworddethigh_i;
wire [239:0] /*[239:0]*/ instn_in240;
wire icc_pcrel_e;
// END Wire declarations made by MVP

	assign raw_instn_in_postws [31:0] = 32'b0;
	assign isachange_waysel [3:0] = 4'b0;

	// End of I/O

	assign instn_in240 [239:0] = {raw_instn_in};
	
	assign instn_out240 [239:0] = instn_in240;
	
	assign instn_out [(48*WIDTH-1):0] = instn_out240[(48*WIDTH-1):0];

	assign icc_umipsri_e = 1'b0;
	assign icc_macro_e = 1'b0;
	assign icc_macroend_e = 1'b0;
	assign icc_nobds_e = 1'b0;
	assign icc_macrobds_e = 1'b0;
	assign icc_umipspresent = 1'b0;
	assign icc_halfworddethigh_i = 1'b0;
	assign icc_halfworddethigh_fifo_i = 1'b0;
	assign icc_pcrel_e = 1'b0;
	assign umipsfifo_imip = 1'b0;
	assign umipsfifo_ieip2 = 1'b0;
	assign umipsfifo_ieip4 = 1'b0;
	assign umipsfifo_null_i = 1'b0;
	assign umipsfifo_null_raw = 1'b0;
	assign umipsfifo_stat[3:0] = 4'b0;
	assign umips_rdpgpr[4:0] = 5'b00000;
	assign icc_dspver_i[4:0] = 5'b0;
	assign umips_sds = 1'b0;
	assign macro_jr = 1'b0;
	assign isachange1_i_reg = 1'b0;
	assign isachange0_i_reg = 1'b0;
	assign slip_n_nhalf = 1'b0;
	assign icc_umips_instn_i[31:0] = 32'b0;

	  
 //VCS coverage off 
	//
	//
	// dummy signals for umips instn tracing hotwires
	wire [12:0] sidebits = 13'b0;
        wire [31:0] ci0_f = 32'b0;
        wire [31:0] ci1_f = 32'b0;
        wire [31:0] ci2_f = 32'b0;
        wire [31:0] ci3_f = 32'b0;
        wire [31:0] ci4_f = 32'b0;
	//
 //VCS coverage on 
	 
	// 
	
//verilint 240 on  // Unused input
//verilint 175 on  // Unused parameter
endmodule // m14k_icc_umips_stub


