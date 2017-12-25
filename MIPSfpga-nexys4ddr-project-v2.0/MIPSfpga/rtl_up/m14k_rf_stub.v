// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
////////////////////////////////////////////////////////////////////////////////
//
//	Description: m14k_rf_rgc
//      	stub-module for flop-based integer register file
//
//	$Id: \$
//	mips_repository_id: m14k_rf_stub.mv, v 1.3 
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

module m14k_rf_stub(
	gclk,
	gscanenable,
	src_a,
	src_b,
	dest,
	write_en,
	write_data,
	rf_init_done,
	read_data_a,
	read_data_b);


	//  Inputs 

	input	 gclk;		// Global Clock
	input		gscanenable;	// Global Scanenable

	input [4:0]	src_a;		// source A register
	input [4:0]	src_b;		// source B register

	input [4:0]	dest;		// destination register
	input		write_en;	// write enable
	input [31:0]	write_data;	// write data


	//  Outputs 
	output		rf_init_done;	// only used for consistent s-modules with m14k_rf_srs_gen
	output [31:0]	read_data_a;	// read data A
	output [31:0]	read_data_b;	// read data B

// BEGIN Wire declarations made by MVP
wire rf_init_done;
wire [31:0] /*[31:0]*/ read_data_b;
wire [31:0] /*[31:0]*/ read_data_a;
// END Wire declarations made by MVP


	// End of I/O
  assign rf_init_done = 1'b1;
  assign read_data_a [31:0] = 32'hxxxxxxxx;
  assign read_data_b [31:0] = 32'hxxxxxxxx;

//verilint 240 on  // Unused input
endmodule
