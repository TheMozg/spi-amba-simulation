// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// Description: m14k_ispram_ext_stub
//       Stub module
//
// $Id: \$
// mips_repository_id: m14k_ispram_ext_stub.mv, v 1.8 
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

`timescale 1ns/1ps
`include "m14k_const.vh"
module m14k_ispram_ext_stub(
	ISP_TagWrStr,
	ISP_Addr,
	ISP_DataTagValue,
	ISP_TagCmpValue,
	ISP_RdStr,
	ISP_DataWrStr,
	SI_ColdReset,
	SI_ClkIn,
	SI_gClkOut,
	SI_Sleep,
	gscanenable,
	gmbinvoke,
	ISP_Present,
	ISP_DataRdValue,
	ISP_TagRdValue,
	ISP_Hit,
	ISP_Stall,
	ISP_ParityEn,
	ISP_WPar,
	ISP_ParPresent,
	ISP_RPar,
	ISP_toisp,
	ISP_fromisp);


        input ISP_TagWrStr;		// ISPRAM Tag Write Strob
	input [19:2]	ISP_Addr;	// Index into tag array
	input [31:0]	ISP_DataTagValue;
	input [23:0]	ISP_TagCmpValue;
	input		ISP_RdStr;	
        input           ISP_DataWrStr;
        input		SI_ColdReset;
        input		SI_ClkIn;
	input		SI_gClkOut;
	input		SI_Sleep;
        input           gscanenable;
        input		gmbinvoke;
    
	// Outputs
	output 		ISP_Present;        // Static output indicating spram is present
	output [31:0]	ISP_DataRdValue;	// Read data
	output [23:0]	ISP_TagRdValue;	// read tag
	output		ISP_Hit;	// This reference hit and was valid
	output 		ISP_Stall;          // Read has not completed

	input		ISP_ParityEn;		// Parity enable for ISPRAM 
	input	[3:0]	ISP_WPar;		// Parity bit for ISPRAM write data 
	output		ISP_ParPresent;		// ISPRAM has parity support
	output	[3:0]	ISP_RPar;		// Parity bits read from ISPRAM

	// external ISP signals
        input  [`M14K_ISP_EXT_TOISP_WIDTH-1:0]   ISP_toisp;   // External input to ISP module
        output [`M14K_ISP_EXT_FROMISP_WIDTH-1:0] ISP_fromisp; // Output from ISP module to external system    

// BEGIN Wire declarations made by MVP
wire [3:0] /*[3:0]*/ ISP_RPar;
wire ISP_ParPresent;
wire ISP_Present;
wire ISP_Stall;
wire [23:0] /*[23:0]*/ ISP_TagRdValue;
wire [31:0] /*[31:0]*/ ISP_DataRdValue;
wire [7:0] /*[7:0]*/ SP_GuestID;
wire [`M14K_ISP_EXT_FROMISP_WIDTH-1:0] /*[0:0]*/ ISP_fromisp;
wire ISP_Hit;
// END Wire declarations made by MVP

    

	assign SP_GuestID[7:0] = 8'h0;

	assign ISP_fromisp[`M14K_ISP_EXT_FROMISP_WIDTH-1:0] = {`M14K_ISP_EXT_FROMISP_WIDTH{1'b0}};
    
	assign ISP_Present = 1'b0;
	assign ISP_DataRdValue [31:0] = 32'h0;
	assign ISP_TagRdValue [23:0] = 24'h0;
	assign ISP_Hit = 1'b0;
	assign ISP_Stall = 1'b0;
	assign ISP_ParPresent = 1'b0;
	assign ISP_RPar [3:0] = 4'b0;

endmodule
