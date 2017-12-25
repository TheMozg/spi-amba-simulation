// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// Description: m14k_dspram_stub 
//      DSPRAM stub module
//
// $Id: \$
// mips_repository_id: m14k_dspram_ext_stub.mv, v 1.8 
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
module m14k_dspram_ext_stub(
	DSP_TagAddr,
	DSP_TagRdStr,
	DSP_TagWrStr,
	DSP_TagCmpValue,
	DSP_DataAddr,
	DSP_DataWrValue,
	DSP_DataRdStr,
	DSP_DataWrStr,
	DSP_DataWrMask,
	DSP_Lock,
	SI_ClkIn,
	SI_ColdReset,
	SI_gClkOut,
	SI_Sleep,
	gscanenable,
	gmbinvoke,
	DSP_Present,
	DSP_DataRdValue,
	DSP_TagRdValue,
	DSP_Hit,
	DSP_Stall,
	DSP_todsp,
	DSP_fromdsp,
	DSP_ParityEn,
	DSP_WPar,
	DSP_ParPresent,
	DSP_RPar);


	input [19:2]	DSP_TagAddr;	// Index into tag array
	input		DSP_TagRdStr;	// Tag Read Strobe
	input		DSP_TagWrStr;	// Tag Write Strobe
        input [23:0] 	DSP_TagCmpValue;    // Data for tag compare {PA[31:10], 2'b0}
 	
	
	input [19:2]	DSP_DataAddr;       // Index into data array
	input [31:0]	DSP_DataWrValue;	// Data in
	input		DSP_DataRdStr;	// Data Read Strobe
	input 		DSP_DataWrStr;	// Data Write Strobe 
	input [3:0]	DSP_DataWrMask;
	input		DSP_Lock;	// Start a RMW sequence for DSPRAM

	input		SI_ClkIn;		// Clock
	input		SI_ColdReset;          // Reset
	input		SI_gClkOut;
	input		SI_Sleep;
        input		gscanenable;
        input		gmbinvoke;

	/* Outputs */
	output 		DSP_Present;        // Static output indicating spram is present
	output [31:0]	DSP_DataRdValue;	// Read data
	output [23:0]	DSP_TagRdValue;	// read tag
	output		DSP_Hit;	// This reference hit and was valid
	output 		DSP_Stall;          // Read has not completed
    // external DSP signals
  input  [`M14K_DSP_EXT_TODSP_WIDTH-1:0] DSP_todsp; // External input to DSP module
  output  [`M14K_DSP_EXT_FROMDSP_WIDTH-1:0] DSP_fromdsp; // Output from DSP module to external system    
    
	input		DSP_ParityEn;		// Parity enable for DSPRAM 
	input	[3:0]	DSP_WPar;		// Parity bit for DSPRAM write data 
	output		DSP_ParPresent;		// DSPRAM has parity support
	output	[3:0]	DSP_RPar;		// Parity bits read from DSPRAM

// BEGIN Wire declarations made by MVP
wire DSP_ParPresent;
wire [`M14K_DSP_EXT_FROMDSP_WIDTH-1:0] /*[0:0]*/ DSP_fromdsp;
wire [3:0] /*[3:0]*/ DSP_RPar;
wire DSP_Present;
wire [23:0] /*[23:0]*/ DSP_TagRdValue;
wire [31:0] /*[31:0]*/ DSP_DataRdValue;
wire [7:0] /*[7:0]*/ SP_GuestID;
wire DSP_Hit;
wire DSP_Stall;
// END Wire declarations made by MVP



	assign SP_GuestID[7:0] = 8'h0;

assign DSP_fromdsp[`M14K_DSP_EXT_FROMDSP_WIDTH-1:0] = {`M14K_DSP_EXT_FROMDSP_WIDTH{1'b0}};

    
	assign DSP_Present = 1'b0;
	assign DSP_DataRdValue [31:0] = 32'h0;
	assign DSP_TagRdValue [23:0] = 24'h0;
	assign DSP_Hit = 1'b0;
	assign DSP_Stall = 1'b0;
	assign DSP_ParPresent = 1'b0;
	assign DSP_RPar [3:0] = 4'b0;

endmodule
