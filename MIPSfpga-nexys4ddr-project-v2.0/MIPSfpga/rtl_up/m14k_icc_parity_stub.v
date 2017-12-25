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
`include "m14k_const.vh"

module	m14k_icc_parity_stub(
	gclk,
	imbinvoke,
	ispmbinvoke,
	gscanenable,
	scan_mb_trstb,
	scan_mb_drstb,
	spram_cache_data,
	tag_rd_int112,
	data_line_sel,
	spram_sel,
	ifill_done,
	fill_data_raw,
	icop_active_m,
	icop_idx_ld,
	icop_idx_stt,
	icop_ready,
	cpz_taglo,
	icc_tagwrdata_raw,
	mpc_icop_m,
	raw_kill_i,
	icc_drstb,
	icc_trstb,
	ISP_RdStr,
	ISP_Addr,
	ISP_RPar,
	icc_tagaddr,
	icc_dataaddr,
	icop_use_idx,
	icop_wway_reg,
	spram_way,
	valid,
	icc_readmask,
	cpz_pi,
	cpz_pe,
	cpz_po,
	ispram_par_present,
	mmu_icacabl,
	mbdipar,
	mbisppar,
	isp_data_parerr,
	icc_parerr_idx,
	icc_derr_way,
	icc_parerr_w,
	icc_parerr_cpz_w,
	icc_parerr_i,
	icc_parerr_data,
	icc_parerr_tag,
	fill_data_par,
	icc_tag_par,
	icc_icoppar);


parameter PARITY =  `M14K_PARITY_ENABLE;

// Calculated parameter

parameter T_BITS = (PARITY == 1) ? `M14K_T_PAR_BITS : `M14K_T_NOPAR_BITS;
parameter D_BITS = (PARITY == 1) ? `M14K_D_PAR_BITS : `M14K_D_NOPAR_BITS;

	input		 gclk;
	input			imbinvoke;
	input			ispmbinvoke;
	input			gscanenable;
	input			scan_mb_trstb;
	input			scan_mb_drstb;
	
	input	[D_BITS*`M14K_MAX_IC_ASSOC-1:0]	spram_cache_data;
	input	[4*T_BITS-1:0] tag_rd_int112;
	input	[3:0]		data_line_sel;
	input	[3:0]		spram_sel;
	input			ifill_done;
	input	[31:0]		fill_data_raw;
	input			icop_active_m;
	input			icop_idx_ld;
	input			icop_idx_stt;
	input			icop_ready;
	input	[25:0]		cpz_taglo;
	input	[23:0]		icc_tagwrdata_raw;	
	input			mpc_icop_m;
	input			raw_kill_i;
	input			icc_drstb;
	input			icc_trstb;
	input			ISP_RdStr;
	input	[19:2]		ISP_Addr;
	input	[3:0]		ISP_RPar;
	input	[13:4]		icc_tagaddr;
	input	[13:2]		icc_dataaddr;
	input			icop_use_idx;
	input	[3:0]		icop_wway_reg;
	input	[3:0]		spram_way;
	input	[3:0]		valid;
	input   [`M14K_MAX_IC_ASSOC-1:0] icc_readmask;

	input	[3:0]		cpz_pi;
	input			cpz_pe;
	input			cpz_po;
	input			ispram_par_present;
	input			mmu_icacabl;

	output	[3:0]		mbdipar;
	output	[3:0]		mbisppar;
	output			isp_data_parerr;	// parity error detected on ISPRAM
	output	[19:0]		icc_parerr_idx;
	output	[1:0]		icc_derr_way;	
	output			icc_parerr_w;
	output			icc_parerr_cpz_w;
	output			icc_parerr_i;
	output			icc_parerr_data;
	output			icc_parerr_tag;

	output	[3:0]		fill_data_par;		// generated parity bits for data write operation
	output			icc_tag_par;		// generated parity bits for tag write operation
	output	[3:0]		icc_icoppar;		// split parity bits from read data

// BEGIN Wire declarations made by MVP
wire [3:0] /*[3:0]*/ fill_data_par;
wire isp_data_parerr;
wire [3:0] /*[3:0]*/ mbdipar;
wire [3:0] /*[3:0]*/ icc_icoppar;
wire icc_parerr_data;
wire icc_parerr_tag;
wire [19:0] /*[19:0]*/ icc_parerr_idx;
wire icc_parerr_i;
wire [3:0] /*[3:0]*/ mbisppar;
wire [1:0] /*[1:0]*/ icc_derr_way;
wire icc_tag_par;
wire icc_parerr_w;
wire icc_parerr_cpz_w;
// END Wire declarations made by MVP



	assign mbdipar[3:0] = 4'b0;
	assign mbisppar[3:0] = 4'b0;
	assign isp_data_parerr = 1'b0;
	assign icc_parerr_idx[19:0] = 20'b0;
	assign icc_derr_way[1:0] = 2'b0;
	assign icc_parerr_w = 1'b0;
	assign icc_parerr_cpz_w = 1'b0;
	assign icc_parerr_i = 1'b0;
	assign icc_parerr_data = 1'b0;
	assign icc_parerr_tag = 1'b0;
	assign fill_data_par[3:0] = 4'b0;
	assign icc_tag_par = 1'b0;
	assign icc_icoppar[3:0] = 4'b0;

//verilint 240 on  // Unused input
endmodule
