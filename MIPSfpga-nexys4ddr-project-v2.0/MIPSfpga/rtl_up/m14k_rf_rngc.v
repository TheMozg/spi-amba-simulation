// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
////////////////////////////////////////////////////////////////////////////////
//
//      Description: m14k_rf_rngc 
//      flop-based integer register file, no gated clocks
//
//	This module represents a 31x32 register file.  Entries
//	1-31 are generally read/write registers. Writing with
//	index of 0 is ignored.  Reads to index 0 reads all
//	0's.
//
//	$Id: \$
//	mips_repository_id: m14k_rf_rngc.mv, v 1.2 
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

`include "m14k_const.vh"

module m14k_rf_rngc(
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



  wire [31:0]	rf1, rf2, rf3, rf4, rf5, rf6, rf7, rf8, rf9;
  wire [31:0]	rf10, rf11, rf12, rf13, rf14, rf15, rf16, rf17, rf18, rf19;
  wire [31:0]	rf20, rf21, rf22, rf23, rf24, rf25, rf26, rf27, rf28, rf29;
  wire [31:0]	rf30, rf31;

	assign rf_init_done = 1'b1;


  // ----------------------------------------
  // Read Port
  // ----------------------------------------

  assign read_data_a [31:0] = rf_read(	src_a,
				rf1,
				rf2,
				rf3,
				rf4,
				rf5,
				rf6,
				rf7,
				rf8,
				rf9,
				rf10,
				rf11,
				rf12,
				rf13,
				rf14,
				rf15,
				rf16,
				rf17,
				rf18,
				rf19,
				rf20,
				rf21,
				rf22,
				rf23,
				rf24,
				rf25,
				rf26,
				rf27,
				rf28,
				rf29,
				rf30,
				rf31);

  assign read_data_b [31:0] = rf_read(	src_b,
				rf1,
				rf2,
				rf3,
				rf4,
				rf5,
				rf6,
				rf7,
				rf8,
				rf9,
				rf10,
				rf11,
				rf12,
				rf13,
				rf14,
				rf15,
				rf16,
				rf17,
				rf18,
				rf19,
				rf20,
				rf21,
				rf22,
				rf23,
				rf24,
				rf25,
				rf26,
				rf27,
				rf28,
				rf29,
				rf30,
				rf31);

  // ----------------------------------------
  // Write Port
  // ----------------------------------------


  mvp_cregister_wide #(32) _rf1_31_0_(rf1[31:0],gscanenable,  write_en && (dest[4:0]==5'd1), gclk, write_data);
  mvp_cregister_wide #(32) _rf2_31_0_(rf2[31:0],gscanenable,  write_en && (dest[4:0]==5'd2), gclk, write_data);
  mvp_cregister_wide #(32) _rf3_31_0_(rf3[31:0],gscanenable,  write_en && (dest[4:0]==5'd3), gclk, write_data);
  mvp_cregister_wide #(32) _rf4_31_0_(rf4[31:0],gscanenable,  write_en && (dest[4:0]==5'd4), gclk, write_data);
  mvp_cregister_wide #(32) _rf5_31_0_(rf5[31:0],gscanenable,  write_en && (dest[4:0]==5'd5), gclk, write_data);
  mvp_cregister_wide #(32) _rf6_31_0_(rf6[31:0],gscanenable,  write_en && (dest[4:0]==5'd6), gclk, write_data);
  mvp_cregister_wide #(32) _rf7_31_0_(rf7[31:0],gscanenable,  write_en && (dest[4:0]==5'd7), gclk, write_data);
  mvp_cregister_wide #(32) _rf8_31_0_(rf8[31:0],gscanenable,  write_en && (dest[4:0]==5'd8), gclk, write_data);
  mvp_cregister_wide #(32) _rf9_31_0_(rf9[31:0],gscanenable,  write_en && (dest[4:0]==5'd9), gclk, write_data);
  mvp_cregister_wide #(32) _rf10_31_0_(rf10[31:0],gscanenable,  write_en && (dest[4:0]==5'd10), gclk, write_data);
  mvp_cregister_wide #(32) _rf11_31_0_(rf11[31:0],gscanenable,  write_en && (dest[4:0]==5'd11), gclk, write_data);
  mvp_cregister_wide #(32) _rf12_31_0_(rf12[31:0],gscanenable,  write_en && (dest[4:0]==5'd12), gclk, write_data);
  mvp_cregister_wide #(32) _rf13_31_0_(rf13[31:0],gscanenable,  write_en && (dest[4:0]==5'd13), gclk, write_data);
  mvp_cregister_wide #(32) _rf14_31_0_(rf14[31:0],gscanenable,  write_en && (dest[4:0]==5'd14), gclk, write_data);
  mvp_cregister_wide #(32) _rf15_31_0_(rf15[31:0],gscanenable,  write_en && (dest[4:0]==5'd15), gclk, write_data);
  mvp_cregister_wide #(32) _rf16_31_0_(rf16[31:0],gscanenable,  write_en && (dest[4:0]==5'd16), gclk, write_data);
  mvp_cregister_wide #(32) _rf17_31_0_(rf17[31:0],gscanenable,  write_en && (dest[4:0]==5'd17), gclk, write_data);
  mvp_cregister_wide #(32) _rf18_31_0_(rf18[31:0],gscanenable,  write_en && (dest[4:0]==5'd18), gclk, write_data);
  mvp_cregister_wide #(32) _rf19_31_0_(rf19[31:0],gscanenable,  write_en && (dest[4:0]==5'd19), gclk, write_data);
  mvp_cregister_wide #(32) _rf20_31_0_(rf20[31:0],gscanenable,  write_en && (dest[4:0]==5'd20), gclk, write_data);
  mvp_cregister_wide #(32) _rf21_31_0_(rf21[31:0],gscanenable,  write_en && (dest[4:0]==5'd21), gclk, write_data);
  mvp_cregister_wide #(32) _rf22_31_0_(rf22[31:0],gscanenable,  write_en && (dest[4:0]==5'd22), gclk, write_data);
  mvp_cregister_wide #(32) _rf23_31_0_(rf23[31:0],gscanenable,  write_en && (dest[4:0]==5'd23), gclk, write_data);
  mvp_cregister_wide #(32) _rf24_31_0_(rf24[31:0],gscanenable,  write_en && (dest[4:0]==5'd24), gclk, write_data);
  mvp_cregister_wide #(32) _rf25_31_0_(rf25[31:0],gscanenable,  write_en && (dest[4:0]==5'd25), gclk, write_data);
  mvp_cregister_wide #(32) _rf26_31_0_(rf26[31:0],gscanenable,  write_en && (dest[4:0]==5'd26), gclk, write_data);
  mvp_cregister_wide #(32) _rf27_31_0_(rf27[31:0],gscanenable,  write_en && (dest[4:0]==5'd27), gclk, write_data);
  mvp_cregister_wide #(32) _rf28_31_0_(rf28[31:0],gscanenable,  write_en && (dest[4:0]==5'd28), gclk, write_data);
  mvp_cregister_wide #(32) _rf29_31_0_(rf29[31:0],gscanenable,  write_en && (dest[4:0]==5'd29), gclk, write_data);
  mvp_cregister_wide #(32) _rf30_31_0_(rf30[31:0],gscanenable,  write_en && (dest[4:0]==5'd30), gclk, write_data);
  mvp_cregister_wide #(32) _rf31_31_0_(rf31[31:0],gscanenable,  write_en && (dest[4:0]==5'd31), gclk, write_data);


  function [31:0] rf_read;
	input [4:0] index;

	// Need to specify all the RF values as inputs so they appear
	//  on the sensitivity list for the rf_read function.
	input [31:0] rf1;
	input [31:0] rf2;
	input [31:0] rf3;
	input [31:0] rf4;
	input [31:0] rf5;
	input [31:0] rf6;
	input [31:0] rf7;
	input [31:0] rf8;
	input [31:0] rf9;
	input [31:0] rf10;
	input [31:0] rf11;
	input [31:0] rf12;
	input [31:0] rf13;
	input [31:0] rf14;
	input [31:0] rf15;
	input [31:0] rf16;
	input [31:0] rf17;
	input [31:0] rf18;
	input [31:0] rf19;
	input [31:0] rf20;
	input [31:0] rf21;
	input [31:0] rf22;
	input [31:0] rf23;
	input [31:0] rf24;
	input [31:0] rf25;
	input [31:0] rf26;
	input [31:0] rf27;
	input [31:0] rf28;
	input [31:0] rf29;
	input [31:0] rf30;
	input [31:0] rf31;

	case (index)	
		5'd0:	rf_read = 32'h0;
		5'd1:	rf_read = rf1;
		5'd2:	rf_read = rf2;
		5'd3:	rf_read = rf3;
		5'd4:	rf_read = rf4;
		5'd5:	rf_read = rf5;
		5'd6:	rf_read = rf6;
		5'd7:	rf_read = rf7;
		5'd8:	rf_read = rf8;
		5'd9:	rf_read = rf9;
		5'd10:	rf_read = rf10;
		5'd11:	rf_read = rf11;
		5'd12:	rf_read = rf12;
		5'd13:	rf_read = rf13;
		5'd14:	rf_read = rf14;
		5'd15:	rf_read = rf15;
		5'd16:	rf_read = rf16;
		5'd17:	rf_read = rf17;
		5'd18:	rf_read = rf18;
		5'd19:	rf_read = rf19;
		5'd20:	rf_read = rf20;
		5'd21:	rf_read = rf21;
		5'd22:	rf_read = rf22;
		5'd23:	rf_read = rf23;
		5'd24:	rf_read = rf24;
		5'd25:	rf_read = rf25;
		5'd26:	rf_read = rf26;
		5'd27:	rf_read = rf27;
		5'd28:	rf_read = rf28;
		5'd29:	rf_read = rf29;
		5'd30:	rf_read = rf30;
		5'd31:	rf_read = rf31;
		default: rf_read = 32'hxxxxxxxx;
	endcase
  endfunction

endmodule
