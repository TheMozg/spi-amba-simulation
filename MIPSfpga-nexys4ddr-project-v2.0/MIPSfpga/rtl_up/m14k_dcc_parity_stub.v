// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//      mips_start_of_legal_notice
//      **********************************************************************
//      Unpublished work (c) MIPS Technologies, Inc.  All rights reserved. 
//      Unpublished rights reserved under the copyright laws of the United
//      States of America and other countries.
//      
//      MIPS TECHNOLOGIES PROPRIETARY / RESTRICTED CONFIDENTIAL - HEIGHTENED
//      STANDARD OF CARE REQUIRED AS PER CONTRACT
//      
//      This code is confidential and proprietary to MIPS Technologies, Inc.
//      ("MIPS Technologies") and may be disclosed only as permitted in
//      writing by MIPS Technologies.  Any copying, reproducing, modifying,
//      use or disclosure of this code (in whole or in part) that is not
//      expressly permitted in writing by MIPS Technologies is strictly
//      prohibited.  At a minimum, this code is protected under trade secret,
//      unfair competition and copyright laws.	Violations thereof may result
//      in criminal penalties and fines.
//      
//      MIPS Technologies reserves the right to change the code to improve
//      function, design or otherwise.	MIPS Technologies does not assume any
//      liability arising out of the application or use of this code, or of
//      any error or omission in such code.  Any warranties, whether express,
//      statutory, implied or otherwise, including but not limited to the
//      implied warranties of merchantability or fitness for a particular
//      purpose, are excluded.	Except as expressly provided in any written
//      license agreement from MIPS Technologies, the furnishing of this code
//      does not give recipient any license to any intellectual property
//      rights, including any patent rights, that cover this code.
//      
//      This code shall not be exported, reexported, transferred, or released,
//      directly or indirectly, in violation of the law of any country or
//      international law, regulation, treaty, Executive Order, statute,
//      amendments or supplements thereto.  Should a conflict arise regarding
//      the export, reexport, transfer, or release of this code, the laws of
//      the United States of America shall be the governing law.
//      
//      This code may only be disclosed to the United States government
//      ("Government"), or to Government users, with prior written consent
//      from MIPS Technologies.  This code constitutes one or more of the
//      following: commercial computer software, commercial computer software
//      documentation or other commercial items.  If the user of this code, or
//      any related documentation of any kind, including related technical
//      data or manuals, is an agency, department, or other entity of the
//      Government, the use, duplication, reproduction, release, modification,
//      disclosure, or transfer of this code, or any related documentation of
//      any kind, is restricted in accordance with Federal Acquisition
//      Regulation 12.212 for civilian agencies and Defense Federal
//      Acquisition Regulation Supplement 227.7202 for military agencies.  The
//      use of this code by the Government is further restricted in accordance
//      with the terms of the license agreement(s) and/or applicable contract
//      terms and conditions covering this code from MIPS Technologies.
//      
//      
//      
//      **********************************************************************
//      mips_end_of_legal_notice
//

//verilint 240 off  // Unused input
//verilint 528 off
`include "m14k_const.vh"

module m14k_dcc_parity_stub(
	gclk,
	gscanenable,
	scan_mb_wsrstb,
	scan_mb_drstb,
	scan_mb_trstb,
	scan_mb_stb_ctl,
	dmbinvoke,
	dspmbinvoke,
	mbdddata,
	mbtddata,
	dcached,
	dcop_read,
	dcop_ready,
	dcop_idx_stt,
	dcop_idx_ld,
	dcop_access_m,
	dcop_d_write,
	cacheread_m,
	ev_dirtyway,
	ev_dirtyway_reg,
	ev_word_reg,
	dcc_wsrstb_reg,
	spram_way,
	data_line_sel,
	spram_sel,
	tag_line_sel,
	valid,
	dcc_data_raw,
	dcc_data_par,
	dcc_tagwrdata_raw,
	dc_wsin,
	spram_cache_tag,
	dspram_par_present,
	DSP_DataAddr,
	DSP_DataRdStr,
	DSP_DataRdStr_reg,
	DSP_RPar,
	dcc_drstb,
	dcc_trstb_reg,
	dcc_wsrstb,
	dcc_dataaddr,
	dcc_wsaddr,
	dcc_tagaddr_reg,
	cpz_taglo,
	dcop_indexed,
	sp_read_m,
	held_dtmack,
	spram_cache_data,
	cpz_pe,
	cpz_po,
	cpz_pd,
	mpc_run_m,
	dcc_fixup_w,
	dcc_dcoppar_m,
	mbddpar,
	mbdsppar,
	mbtdtag_p,
	mbtdtag_p_reg,
	dcc_data,
	dcc_tagwrdata,
	dcc_parerr_m,
	dcc_parerr_w,
	dcc_parerr_cpz_w,
	dcc_parerr_ev,
	dcc_parerr_data,
	dcc_parerr_tag,
	dcc_parerr_ws,
	dsp_data_parerr,
	dcc_derr_way,
	dcc_parerr_idx,
	held_parerr_m,
	exaddr_sel_disable,
	dcc_ev_kill);


parameter PARITY =  `M14K_PARITY_ENABLE;

// Calculated parameter

parameter T_BITS = (PARITY == 1) ? `M14K_T_PAR_BITS : `M14K_T_NOPAR_BITS;
parameter D_BITS = (PARITY == 1) ? `M14K_D_PAR_BITS : `M14K_D_NOPAR_BITS;
parameter D_BYTES = (PARITY == 1) ? `M14K_D_PAR_BYTES : `M14K_D_NOPAR_BYTES;

	input		 gclk;
	input			gscanenable;
	input			scan_mb_wsrstb;
	input			scan_mb_drstb;
	input			scan_mb_trstb;
	input			scan_mb_stb_ctl;
	input			dmbinvoke;
	input			dspmbinvoke;
	input	[D_BITS-1:0]	mbdddata;
	input	[T_BITS-1:0]	mbtddata;

	input			dcached;
	input			dcop_read;
	input			dcop_ready;
	input			dcop_idx_stt;
	input			dcop_idx_ld;
	input			dcop_access_m;
	input                   dcop_d_write;
	input			cacheread_m;
	input			ev_dirtyway;
	input			ev_dirtyway_reg;
	input	[1:0]		ev_word_reg;
	input			dcc_wsrstb_reg;

	input	[3:0]		spram_way;
	input	[3:0]		data_line_sel;
	input	[3:0]		spram_sel;
	input	[3:0]		tag_line_sel;
	input	[3:0]		valid;

	input	[31:0]		dcc_data_raw;
	output	[3:0]		dcc_data_par;
	input	[23:0]		dcc_tagwrdata_raw;
	input	[13:0]		dc_wsin;
	input	[T_BITS*`M14K_MAX_DC_ASSOC-1:0]       spram_cache_tag;
	input			dspram_par_present;	// enable spram parity check
	input	[19:2]		DSP_DataAddr;
	input			DSP_DataRdStr;
	input			DSP_DataRdStr_reg;
	input	[3:0]		DSP_RPar;
	input			dcc_drstb;
	input			dcc_trstb_reg;
	input			dcc_wsrstb;
	input	[13:2]		dcc_dataaddr;
	input	[13:4]		dcc_wsaddr;
	input	[13:4]		dcc_tagaddr_reg;
	input	[25:0]		cpz_taglo;
	input			dcop_indexed;
	input			sp_read_m;
	input			held_dtmack;
	input	[D_BITS*`M14K_MAX_DC_ASSOC-1:0] spram_cache_data;

	input			cpz_pe;
	input			cpz_po;
	input	[3:0]		cpz_pd;
	input			mpc_run_m;
	input			dcc_fixup_w;
	
	input	[3:0]		dcc_dcoppar_m;	// data ram parity bits for BIST
	output	[3:0]		mbddpar;	// data ram parity bits flopped for BIST
	output	[3:0]		mbdsppar;	// dsp ram parity bits flopped for BIST
	input			mbtdtag_p;	// tag ram parity bit for BIST
	output			mbtdtag_p_reg;	// tag ram parity bit flopped for BIST

	output	[D_BITS-1:0]	dcc_data;
	output	[T_BITS-1:0]	dcc_tagwrdata;

	output			dcc_parerr_m;	// error detected on dcc at M-stage
	output			dcc_parerr_w;	// error detected on dcc at W-stage
	output			dcc_parerr_cpz_w;	// error detected on dcc at W-stage for cpz update
	output			dcc_parerr_ev;	// error detected on evection
	output			dcc_parerr_data; // error on dcc data ram
	output			dcc_parerr_tag;	 // error on dcc tag ram
	output			dcc_parerr_ws;	 // error on dcc ws ram
	output			dsp_data_parerr; // error on dspram
	output	[1:0]		dcc_derr_way;	// which has cache error
	output	[19:0]		dcc_parerr_idx;	
	output			held_parerr_m;

	output			exaddr_sel_disable;
	output			dcc_ev_kill;

// BEGIN Wire declarations made by MVP
wire [T_BITS-1:0] /*[24:0]*/ dcc_tagwrdata;
wire dcc_parerr_data;
wire dcc_parerr_m;
wire dcc_parerr_ev;
wire [3:0] /*[3:0]*/ mbdsppar;
wire held_parerr_m;
wire [3:0] /*[3:0]*/ mbddpar;
wire [19:0] /*[19:0]*/ dcc_parerr_idx;
wire [1:0] /*[1:0]*/ dcc_derr_way;
wire dsp_data_parerr;
wire dcc_parerr_ws;
wire mbtdtag_p_reg;
wire dcc_ev_kill;
wire dcc_parerr_w;
wire [`M14K_T_PAR_BITS-1:0] /*[24:0]*/ dcc_tagwrdata_par;
wire [D_BITS-1:0] /*[35:0]*/ dcc_data;
wire dcc_parerr_cpz_w;
wire [3:0] /*[3:0]*/ tag_par_waysel;
wire [3:0] /*[3:0]*/ dcc_data_par;
wire dcc_parerr_tag;
wire [8:0] /*[8:0]*/ dcc_data_b3;
wire [8:0] /*[8:0]*/ dcc_data_b2;
wire [8:0] /*[8:0]*/ dcc_data_b1;
wire [8:0] /*[8:0]*/ dcc_data_b0;
wire exaddr_sel_disable;
// END Wire declarations made by MVP


	
	assign exaddr_sel_disable = 1'b0;
	assign mbddpar[3:0] = 4'b0;
	assign mbdsppar[3:0] = 4'b0;
	assign mbtdtag_p_reg = 1'b0;

	 // insert parity bits
         assign dcc_data_b0[8:0] = {dcc_data_par[0],dcc_data_raw[7:0]};
         assign dcc_data_b1[8:0] = {dcc_data_par[1],dcc_data_raw[15:8]};
         assign dcc_data_b2[8:0] = {dcc_data_par[2],dcc_data_raw[23:16]};
         assign dcc_data_b3[8:0] = {dcc_data_par[3],dcc_data_raw[31:24]};
         assign dcc_data[D_BITS-1:0] = dmbinvoke ? mbdddata : {dcc_data_b3[D_BYTES-1:0],
                                                         dcc_data_b2[D_BYTES-1:0],
                                                         dcc_data_b1[D_BYTES-1:0],
                                                         dcc_data_b0[D_BYTES-1:0]};

	assign dcc_tagwrdata_par[`M14K_T_PAR_BITS-1:0] = {1'b0, dcc_tagwrdata_raw};
	assign dcc_tagwrdata[T_BITS-1:0] = dcc_tagwrdata_par[T_BITS-1:0];
	assign dcc_parerr_m = 1'b0;
	assign dcc_parerr_w = 1'b0;
	assign dcc_parerr_cpz_w = 1'b0;
	assign dcc_parerr_ev = 1'b0;
	assign dcc_parerr_data = 1'b0;
	assign dcc_parerr_tag = 1'b0;
	assign dcc_parerr_ws = 1'b0;	
	assign dsp_data_parerr = 1'b0;
	assign held_parerr_m = 1'b0;
	assign dcc_derr_way[1:0] = 2'b0;
	assign dcc_parerr_idx[19:0] = 20'b0;
	assign dcc_data_par[3:0] = 4'b0;
	assign dcc_ev_kill = 1'b0;
	assign tag_par_waysel[3:0] = 4'b0;
//verilint 528 on

//verilint 240 on  // Unused input
endmodule
