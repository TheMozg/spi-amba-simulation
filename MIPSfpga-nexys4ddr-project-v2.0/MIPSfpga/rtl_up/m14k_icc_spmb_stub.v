// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//	Description: m14k_icc_spmb_stub
//           Stub module for Instr SPRAM Controller Memory BIST. 
//
//	$Id: \$
//	mips_repository_id: m14k_icc_spmb_stub.mv, v 1.8 
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

//verilint 240 off  // Unused input
`include "m14k_const.vh"
module m14k_icc_spmb_stub(
	gclk,
	greset,
	gmbinvoke,
	gscanenable,
	cpz_isppresent,
	isp_size,
	mbispdatain,
	ispmbinvoke,
	mbispaddr,
	mbispread,
	mbispwrite,
	mbispdata,
	gmbispfail,
	icc_spmbdone,
	gmb_isp_algorithm);


parameter PARITY =  `M14K_PARITY_ENABLE;

// Calculated parameter

parameter D_BITS = (PARITY == 1) ? `M14K_D_PAR_BITS : `M14K_D_NOPAR_BITS;
parameter	DATA_MSB = (PARITY == 1) ? 35 : 31;

//Define inputs
	input 		gclk;
	input 		greset;
	input		gmbinvoke;
	input		gscanenable;	// Scan control signal for delay registers
	input   	cpz_isppresent;	// ISPRAM is present
	input [20:12]	isp_size;	// ISPRAM line size 

	input [D_BITS-1:0]	mbispdatain;	// data from ISPRAM

//Define outputs
	output		ispmbinvoke;
	
	output [19:2]   mbispaddr;	// High group of address for BIST
	
	output		mbispread;	// readstrb for ISPRAM
	
	output		mbispwrite;	// writestrb for ISPRAM
	
	output [D_BITS-1:0] 	mbispdata;	// 32bit data for write in I-cache

	output		gmbispfail;  	// Asserted to indicate that date test failed
	
	output		icc_spmbdone;	// Asserted to indicate that all test is done
	input	[7:0]	gmb_isp_algorithm; // Alogrithm selection for ISPRAM BIST controller

// BEGIN Wire declarations made by MVP
wire mbispwrite;
wire ispmbinvoke;
wire [D_BITS-1:0] /*[35:0]*/ mbispdata;
wire gmbispfail;
wire [19:2] /*[19:2]*/ mbispaddr;
wire mbispread;
wire icc_spmbdone;
// END Wire declarations made by MVP


assign ispmbinvoke = 1'b0;
assign mbispaddr[19:2] = 18'b0;
assign mbispread = 1'b0;
assign mbispwrite = 1'b0;
assign mbispdata[D_BITS-1:0] = {D_BITS{1'b0}};
assign gmbispfail = 1'b0;
assign icc_spmbdone = 1'b1;

  
 //VCS coverage off 
// 
	// Wire used by TB to determine whether MBIST module is present
wire SelectIspmb;

assign SelectIspmb = 1'b0;

  //VCS coverage on  
  
// 

 
//verilint 240 on  // Unused input
endmodule
