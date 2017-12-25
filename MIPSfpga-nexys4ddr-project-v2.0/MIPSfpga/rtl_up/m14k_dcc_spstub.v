// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_dcc_spstub 
//            stub module for dcc SPRAM control logic
//
//	$Id: \$
//	mips_repository_id: m14k_dcc_spstub.mv, v 1.12 
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

// Comments for verilint...Since the ports on this module need to match others,
//  some inputs are unused.
//verilint 240 off  // Unused input

`include "m14k_const.vh"
module	m14k_dcc_spstub(
	DSP_TagAddr,
	DSP_TagWrStr,
	advance_m,
	raw_cacheread_e,
	mpc_atomic_load_e,
	ev_dirtyway,
	ev_wrtag_inv,
	edp_dval_e,
	dcc_dval_m,
	dcc_dataaddr,
	raw_dstore_e,
	storewrite_e,
	raw_dcop_access_e,
	raw_dsync_e,
	storebuff_idx_mx,
	dcc_tagwren4,
	dcc_twstb,
	dcc_writemask16,
	spram_way,
	spram_sel,
	raw_dsp_hit,
	block_hit_way,
	cache_hit_way,
	DSP_Hit,
	DSP_Stall,
	use_idx,
	dmbinvoke,
	spram_cache_data,
	spram_cache_tag,
	DSP_TagRdValue,
	dc_datain,
	dc_tagin,
	spram_support,
	spram_hit,
	gclk,
	gscanenable,
	gscanmode,
	sp_stall,
	enabled_sp_hit,
	cacheread_m,
	valid_d_access,
	pref_m,
	store_m,
	dcached,
	greset,
	DSP_TagRdStr,
	cacheread_e,
	DSP_DataRdStr,
	DSP_Lock,
	dsp_lock_start,
	dsp_lock_present,
	mpc_busty_raw_e,
	dcop_read,
	dcop_access_m,
	dcop_ready,
	dcop_tag,
	DSP_DataWrStr,
	dcc_spwstb,
	DSP_TagCmpValue,
	dcc_tagcmpdata,
	dcc_tagwrdata,
	dcc_data_raw,
	DSP_Present,
	dcc_sp_pres,
	dsp_size,
	dspmbinvoke,
	dsp_data_raw,
	mbdspbytesel,
	scan_mb_dspaddr,
	mbdspread,
	gscanramwr,
	scan_dspmb_stb_ctl,
	mbdspdata,
	DSP_DataAddr,
	DSP_DataWrValue,
	DSP_DataWrMask,
	DSP_DataRdValue,
	sp_read_m,
	dcc_data_par,
	cpz_pe,
	dspram_par_present,
	DSP_ParityEn,
	DSP_WPar,
	DSP_ParPresent,
	DSP_RPar,
	DSP_DataRdStr_reg);


parameter PARITY =  `M14K_PARITY_ENABLE;

// Calculated parameter

parameter T_BITS = (PARITY == 1) ? `M14K_T_PAR_BITS : `M14K_T_NOPAR_BITS;
parameter D_BITS = (PARITY == 1) ? `M14K_D_PAR_BITS : `M14K_D_NOPAR_BITS;
parameter D_BYTES = (PARITY == 1) ? `M14K_D_PAR_BYTES : `M14K_D_NOPAR_BYTES;

	output [19:2]  DSP_TagAddr;
	output 	       DSP_TagWrStr;

	input          advance_m;
	input 	       raw_cacheread_e;
	input		mpc_atomic_load_e;
	input 	       ev_dirtyway;
	input 	       ev_wrtag_inv;
	input [19:2]   edp_dval_e;
	input [19:2]   dcc_dval_m;
	input [9:2]    dcc_dataaddr;
	input 	       raw_dstore_e;
	input 	       storewrite_e;
	input 	       raw_dcop_access_e;
	input 	       raw_dsync_e;
	input [19:10]  storebuff_idx_mx;
	input [3:0]    dcc_tagwren4;
	input 	       dcc_twstb;
	input [15:0]   dcc_writemask16;
	

	output [3:0]   spram_way;
	output [3:0]   spram_sel;

	output 	       raw_dsp_hit;
	output [3:0]   block_hit_way;
	input [3:0]    cache_hit_way;

	input 	       DSP_Hit;
	input 	       DSP_Stall;
	input 	       use_idx;
	input 	       dmbinvoke;

	output [D_BITS*`M14K_MAX_DC_ASSOC-1:0]      spram_cache_data;
	output [T_BITS*`M14K_MAX_DC_ASSOC-1:0]       spram_cache_tag;

	input [23:0] 	DSP_TagRdValue;
	input [D_BITS*`M14K_MAX_DC_ASSOC-1:0] 	dc_datain;
	input [T_BITS*`M14K_MAX_DC_ASSOC-1:0] 	dc_tagin;

	output 					spram_support;
	output 					spram_hit;
	input 				 gclk;
	input 					gscanenable;
        input                                   gscanmode;
	output 					sp_stall;
	output 					enabled_sp_hit;
	input 					cacheread_m;
	input 					valid_d_access;
	input 					pref_m;
	input 					store_m;
	input 					dcached;
	input 					greset;

	output 					DSP_TagRdStr;
	input 					cacheread_e;

	output 					DSP_DataRdStr;
	//Gracy:
	output					DSP_Lock;
	output					dsp_lock_start;
	input					dsp_lock_present;
	input [2:0] 				mpc_busty_raw_e;
	input 					dcop_read;
	input 					dcop_access_m;
	input 					dcop_ready;
	input [23:0] 				dcop_tag;

	output 					DSP_DataWrStr;
	input 					dcc_spwstb;

	output [23:0] 				DSP_TagCmpValue;
	input [31:10] 				dcc_tagcmpdata;

	input [T_BITS-1:0] 				dcc_tagwrdata;

	input [31:0] 				dcc_data_raw;

	input 					DSP_Present;
	output 					dcc_sp_pres;

	output  [20:12]                         dsp_size;
        input                                   dspmbinvoke;
        output  [31:0]                    	dsp_data_raw;
        input   [3:0]                           mbdspbytesel;
        input   [19:2]                          scan_mb_dspaddr;
        input                                   mbdspread;
        input                                   gscanramwr;
        input                                   scan_dspmb_stb_ctl;
        input   [D_BITS-1:0]                    mbdspdata;

	output [19:2] 	DSP_DataAddr;       // Additional index bits for SPRAM
	output [31:0] 	DSP_DataWrValue;
	output [3:0]	DSP_DataWrMask;     // SP write mask
        input [31:0] 	DSP_DataRdValue;    // dspram data value

	output		sp_read_m;
	input	[3:0]	dcc_data_par;		// core generated parity bits for write data
	input		cpz_pe;
	output		dspram_par_present;	// spram supports parity
	output		DSP_ParityEn;		// Parity enable for DSPRAM 
	output	[3:0]	DSP_WPar;		// Parity bit for DSPRAM write data 
	input		DSP_ParPresent;		// DSPRAM has parity support
	input	[3:0]	DSP_RPar;		// Parity bits read from DSPRAM

	output          DSP_DataRdStr_reg;      // delayed version of DSP_DataRdStr

// BEGIN Wire declarations made by MVP
wire DSP_DataWrStr;
wire [23:0] /*[23:0]*/ DSP_TagCmpValue;
wire sp_stall;
wire [3:0] /*[3:0]*/ block_hit_way;
wire DSP_TagWrStr;
wire [31:0] /*[31:0]*/ dsp_data_raw;
wire DSP_DataRdStr;
wire sp_read_m;
wire [19:2] /*[19:2]*/ DSP_DataAddr;
wire [3:0] /*[3:0]*/ DSP_DataWrMask;
wire dcc_sp_pres;
wire dspram_par_present;
wire [T_BITS*`M14K_MAX_DC_ASSOC-1:0] /*[99:0]*/ spram_cache_tag;
wire [20:12] /*[20:12]*/ dsp_size;
wire DSP_TagRdStr;
wire [19:2] /*[19:2]*/ DSP_TagAddr;
wire [D_BITS*`M14K_MAX_DC_ASSOC-1:0] /*[143:0]*/ spram_cache_data;
wire DSP_Lock;
wire DSP_DataRdStr_reg;
wire raw_dsp_hit;
wire spram_support;
wire spram_hit;
wire enabled_sp_hit;
wire DSP_ParityEn;
wire dsp_lock_start;
wire [3:0] /*[3:0]*/ DSP_WPar;
wire [31:0] /*[31:0]*/ DSP_DataWrValue;
wire [3:0] /*[3:0]*/ spram_way;
wire [3:0] /*[3:0]*/ spram_sel;
// END Wire declarations made by MVP

 
	assign DSP_DataAddr[19:2] = 18'b0;
	assign DSP_DataWrMask[3:0] = 4'b0;
	assign DSP_DataWrValue[31:0] = 32'b0;
	
	assign DSP_TagAddr [19:2] = 16'b0;
	assign DSP_TagWrStr = 1'b0;
	assign spram_way[3:0] = 4'b0;
	assign spram_sel[3:0] = 4'b0;
	assign raw_dsp_hit = 1'b0;
	assign block_hit_way[3:0] = cache_hit_way;
	assign spram_cache_data[D_BITS*`M14K_MAX_DC_ASSOC-1:0] = dc_datain;
	assign spram_cache_tag[T_BITS*`M14K_MAX_DC_ASSOC-1:0] = dc_tagin;
	assign spram_support = 1'b0;
	assign spram_hit = 1'b0;
	assign sp_stall = 1'b0;
	assign enabled_sp_hit = 1'b0;
	assign DSP_TagRdStr = 1'b0;
	assign DSP_DataRdStr = 1'b0;
	assign DSP_Lock = 1'b0; 
	assign dsp_lock_start = 1'b0;
	assign DSP_DataWrStr = 1'b0;
	assign DSP_TagCmpValue[23:0] = 24'b0;
	assign dcc_sp_pres = 1'b0;
	
	assign sp_read_m = 1'b0;
	assign DSP_ParityEn = 1'b0;
	assign DSP_WPar[3:0] = 4'b0;
	assign dspram_par_present = 1'b0;
	
	assign DSP_DataRdStr_reg = 1'b0;
	
	assign dsp_size[20:12] = 9'b0;
	assign dsp_data_raw[31:0] = mbdspdata[31:0];
// 
// verilint 528 off
	wire	sp_stall_en;
	assign sp_stall_en = 1'b0;
// verilint 528 on
// 
	
//verilint 240 on  // Unused input
endmodule // m14k_dcc_spstub

