// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_ejt_gate
//           Simple Break Bus Gate Module
//
//      $Id: \$
//      mips_repository_id: m14k_ejt_gate.mv, v 1.3 
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
module m14k_ejt_gate(
	edp_iva_i,
	mmu_dva_m,
	mmu_asid,
	cpz_guestid,
	cpz_guestid_i,
	cpz_guestid_m,
	dcc_ejdata,
	mpc_lsbe_m,
	mpc_be_w,
	pwrsave_en,
	gt_ivaaddr,
	gt_dvaaddr,
	gt_asid,
	gt_guestid,
	gt_guestid_i,
	gt_guestid_m,
	gt_data,
	gt_bytevalid_m,
	gt_bytevalid_w);


/* Inputs */

	input	[31:0]	edp_iva_i;	// Virtual addr of inst
	input 	[31:0]	mmu_dva_m;	// Virtual addr of load/store

	input	[7:0]	mmu_asid;	// Current mmu_asid
	input	[7:0]	cpz_guestid;	// Current guestid
	input	[7:0]	cpz_guestid_i;	// Current guestid
	input	[7:0]	cpz_guestid_m;	// Current guestid
	input	[31:0]	dcc_ejdata;	// Muxed store+load data bus
	input	[3:0]	mpc_lsbe_m;	// Bytes valid for L/S in M stage
	input	[3:0]	mpc_be_w;	// Bytes valid for load in W stage
	input		pwrsave_en;	// When 1 low pwr is enabled

/* Outputs */

	output	[31:0]	gt_ivaaddr;	// Virtual addr of inst
	output 	[31:0]	gt_dvaaddr;	// Virtual addr of load/store

	output	[7:0]	gt_asid;	// Current mmu_asid
	output	[7:0]	gt_guestid;	// Current guestid
	output	[7:0]	gt_guestid_i;	// Current guestid
	output	[7:0]	gt_guestid_m;	// Current guestid
	output	[31:0]	gt_data;	// Muxed store+load data bus
	output	[3:0]	gt_bytevalid_m;	// Bytes valid for L/S in M stage
	output	[3:0]	gt_bytevalid_w;	// Bytes valid for load in W stage

// BEGIN Wire declarations made by MVP
wire [3:0] /*[3:0]*/ gt_bytevalid_m;
wire [31:0] /*[31:0]*/ gt_ivaaddr;
wire [31:0] /*[31:0]*/ gt_data;
wire [7:0] /*[7:0]*/ gt_asid;
wire [7:0] /*[7:0]*/ gt_guestid;
wire [3:0] /*[3:0]*/ gt_bytevalid_w;
wire [7:0] /*[7:0]*/ gt_guestid_m;
wire [7:0] /*[7:0]*/ gt_guestid_i;
wire [31:0] /*[31:0]*/ gt_dvaaddr;
// END Wire declarations made by MVP


/* Code */

	assign gt_ivaaddr 	[31:0]	= pwrsave_en ? 32'b0 : edp_iva_i;
	assign gt_dvaaddr	[31:0]	= pwrsave_en ? 32'b0 : mmu_dva_m;
	
	assign gt_asid		[7:0]	= pwrsave_en ? 8'b0  : mmu_asid;
	assign gt_guestid	[7:0]	= pwrsave_en ? 8'b0  : cpz_guestid;
	assign gt_guestid_m	[7:0]	= pwrsave_en ? 8'b0  : cpz_guestid_m;
	assign gt_guestid_i	[7:0]	= pwrsave_en ? 8'b0  : cpz_guestid_i;

	assign gt_data		[31:0]	= pwrsave_en ? 32'b0 : dcc_ejdata;
	assign gt_bytevalid_m	[3:0]	= pwrsave_en ? 4'b0  : mpc_lsbe_m;
	assign gt_bytevalid_w	[3:0]	= pwrsave_en ? 4'b0  : mpc_be_w;

endmodule

