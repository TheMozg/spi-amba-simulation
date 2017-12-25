// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
////////////////////////////////////////////////////////////////////////////////
//
//      Description: m14k_rf_reg
//      flop-based integer register file
//
//	This module represents 1 to 8 31x32 register files.  Entries
//	1-31 are generally read/write registers. Writing with
//	index of 0 is ignored.  Reads to index 0 reads all
//	0's.

//
//	$Id: \$
//	mips_repository_id: m14k_rf_reg.hook, v 1.2 
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

module m14k_rf_reg(
	mpc_dest_w,
	mpc_rega_cond_i,
	mpc_rega_i,
	mpc_regb_cond_i,
	mpc_regb_i,
	mpc_rfwrite_w,
	edp_wrdata_w,
	gclk,
	greset,
	gscanenable,
	bc_rfbistto,
	rf_init_done,
	rf_adt_e,
	rf_bdt_e,
	rf_bistfrom,
	grfclk);


/*hookios*//* IO declarations added by hookup */
/* End of hookup IO declarations */
/* Wire declarations added by hookup */
/* End of hookup wire declarations */


	/* Inputs */
	input [8:0]	mpc_dest_w;		// destination register
	input		mpc_rega_cond_i;	// regfile source A register condition
	input [8:0]	mpc_rega_i;		// regfile source A register
	input		mpc_regb_cond_i;	// regfile source B register condition
	input [8:0]	mpc_regb_i;		// regfile source B register
	input		mpc_rfwrite_w;	// regfile write enable
	input [31:0]	edp_wrdata_w;		// regfile write data
	input		gclk;		// Global clock
	input 		greset;
	input		gscanenable;	// gscanenable input is unused for register-based rf
	input [`M14K_RF_BIST_TO-1:0]	bc_rfbistto;	// bist signals to generator based RF



	/* Outputs */
	output		rf_init_done;
	output [31:0]	rf_adt_e;		// regfile A read port
	output [31:0]	rf_bdt_e;		// regfile B read port
	output [`M14K_RF_BIST_FROM-1:0]	rf_bistfrom;	// bist signals from generator based RF

        input           grfclk;         // gated clock on cachemiss

// BEGIN Wire declarations made by MVP
wire [31:0] /*[31:0]*/ rf_bdt_e;
wire [4:0] /*[4:0]*/ src_b_reg;
wire [`M14K_RF_BIST_FROM-1:0] /*[0:0]*/ rf_bistfrom;
wire [4:0] /*[4:0]*/ src_a_reg;
wire [31:0] /*[31:0]*/ rf_adt_e;
wire [15:0] /*[15:0]*/ srs_write_en;
wire [3:0] /*[3:0]*/ src_b_srs;
wire [3:0] /*[3:0]*/ src_a_srs;
// END Wire declarations made by MVP


	// End of I/O


	//	Input Registers

//
  wire [3:0] rf_mask = `M14K_RF_MASK;
//


	mvp_cregister_wide #(9) _src_a_srs_3_0_src_a_reg_4_0({ src_a_srs[3:0], src_a_reg[4:0] }, gscanenable, mpc_rega_cond_i, gclk, 
						            mpc_rega_i[8:0] & {rf_mask, 5'b11111});
	mvp_cregister_wide #(9) _src_b_srs_3_0({ src_b_srs[3:0], src_b_reg[4:0] }, gscanenable, mpc_regb_cond_i, gclk, 
							    mpc_regb_i[8:0] & {rf_mask, 5'b11111});


  wire [31:0]		read_data_a_0, read_data_b_0;
  wire [31:0]		read_data_a_1, read_data_b_1;
  wire [31:0]		read_data_a_2, read_data_b_2;
  wire [31:0]		read_data_a_3, read_data_b_3;
  wire [31:0]		read_data_a_4, read_data_b_4;
  wire [31:0]		read_data_a_5, read_data_b_5;
  wire [31:0]		read_data_a_6, read_data_b_6;
  wire [31:0]		read_data_a_7, read_data_b_7;
  wire [31:0]           read_data_a_8,  read_data_b_8;
  wire [31:0]           read_data_a_9,  read_data_b_9;
  wire [31:0]           read_data_a_10, read_data_b_10;
  wire [31:0]           read_data_a_11,  read_data_b_11;
  wire [31:0]           read_data_a_12,  read_data_b_12;
  wire [31:0]           read_data_a_13,  read_data_b_13;
  wire [31:0]           read_data_a_14,  read_data_b_14;
  wire [31:0]           read_data_a_15,  read_data_b_15;



  wire rf_init_done, rf_init_done_0, rf_init_done_1, rf_init_done_2, rf_init_done_3, rf_init_done_4,
	rf_init_done_5, rf_init_done_6, rf_init_done_7, rf_init_done_8, rf_init_done_9, rf_init_done_10,
	rf_init_done_11, rf_init_done_12, rf_init_done_13, rf_init_done_14, rf_init_done_15;

//VCS coverage off
	assign rf_init_done = rf_init_done_0 & rf_init_done_1 & rf_init_done_2 & rf_init_done_3 & rf_init_done_4 &
	rf_init_done_5 & rf_init_done_6 & rf_init_done_7 & rf_init_done_8 & rf_init_done_9 &
	rf_init_done_10 & rf_init_done_11 & rf_init_done_12 & rf_init_done_13 & rf_init_done_14 & rf_init_done_15;
//VCS coverage on

  // Write Port
  assign srs_write_en [15:0] = mpc_rfwrite_w ? (16'h1 << mpc_dest_w[8:5]) : 16'h0;

  /*hookup*/
  `M14K_RF_REG_MODULE0 rf_reg0 (
	.dest(mpc_dest_w[4:0]),
	.gclk( grfclk),
	.gscanenable(gscanenable),
	.read_data_a(read_data_a_0),
	.read_data_b(read_data_b_0),
	.rf_init_done(rf_init_done_0),
	.src_a(src_a_reg[4:0]),
	.src_b(src_b_reg[4:0]),
	.write_data(edp_wrdata_w),
	.write_en(srs_write_en[0]));

  /*hookup*/
  `M14K_RF_REG_MODULE1 rf_reg1 (
	.dest(mpc_dest_w[4:0]),
	.gclk( grfclk),
	.gscanenable(gscanenable),
	.read_data_a(read_data_a_1),
	.read_data_b(read_data_b_1),
	.rf_init_done(rf_init_done_1),
	.src_a(src_a_reg[4:0]),
	.src_b(src_b_reg[4:0]),
	.write_data(edp_wrdata_w),
	.write_en(srs_write_en[1]));

  /*hookup*/
  `M14K_RF_REG_MODULE2 rf_reg2 (
	.dest(mpc_dest_w[4:0]),
	.gclk( grfclk),
	.gscanenable(gscanenable),
	.read_data_a(read_data_a_2),
	.read_data_b(read_data_b_2),
	.rf_init_done(rf_init_done_2),
	.src_a(src_a_reg[4:0]),
	.src_b(src_b_reg[4:0]),
	.write_data(edp_wrdata_w),
	.write_en(srs_write_en[2]));

  /*hookup*/
  `M14K_RF_REG_MODULE3 rf_reg3 (
	.dest(mpc_dest_w[4:0]),
	.gclk( grfclk),
	.gscanenable(gscanenable),
	.read_data_a(read_data_a_3),
	.read_data_b(read_data_b_3),
	.rf_init_done(rf_init_done_3),
	.src_a(src_a_reg[4:0]),
	.src_b(src_b_reg[4:0]),
	.write_data(edp_wrdata_w),
	.write_en(srs_write_en[3]));

  /*hookup*/
  `M14K_RF_REG_MODULE4 rf_reg4 (
	.dest(mpc_dest_w[4:0]),
	.gclk( grfclk),
	.gscanenable(gscanenable),
	.read_data_a(read_data_a_4),
	.read_data_b(read_data_b_4),
	.rf_init_done(rf_init_done_4),
	.src_a(src_a_reg[4:0]),
	.src_b(src_b_reg[4:0]),
	.write_data(edp_wrdata_w),
	.write_en(srs_write_en[4]));

  /*hookup*/
  `M14K_RF_REG_MODULE5 rf_reg5 (
	.dest(mpc_dest_w[4:0]),
	.gclk( grfclk),
	.gscanenable(gscanenable),
	.read_data_a(read_data_a_5),
	.read_data_b(read_data_b_5),
	.rf_init_done(rf_init_done_5),
	.src_a(src_a_reg[4:0]),
	.src_b(src_b_reg[4:0]),
	.write_data(edp_wrdata_w),
	.write_en(srs_write_en[5]));

  /*hookup*/
  `M14K_RF_REG_MODULE6 rf_reg6 (
	.dest(mpc_dest_w[4:0]),
	.gclk( grfclk),
	.gscanenable(gscanenable),
	.read_data_a(read_data_a_6),
	.read_data_b(read_data_b_6),
	.rf_init_done(rf_init_done_6),
	.src_a(src_a_reg[4:0]),
	.src_b(src_b_reg[4:0]),
	.write_data(edp_wrdata_w),
	.write_en(srs_write_en[6]));

  /*hookup*/
  `M14K_RF_REG_MODULE7 rf_reg7 (
	.dest(mpc_dest_w[4:0]),
	.gclk( grfclk),
	.gscanenable(gscanenable),
	.read_data_a(read_data_a_7),
	.read_data_b(read_data_b_7),
	.rf_init_done(rf_init_done_7),
	.src_a(src_a_reg[4:0]),
	.src_b(src_b_reg[4:0]),
	.write_data(edp_wrdata_w),
	.write_en(srs_write_en[7]));

  /*hookup*/
  `M14K_RF_REG_MODULE8 rf_reg8 (
	.dest(mpc_dest_w[4:0]),
	.gclk( grfclk),
	.gscanenable(gscanenable),
	.read_data_a(read_data_a_8),
	.read_data_b(read_data_b_8),
	.rf_init_done(rf_init_done_8),
	.src_a(src_a_reg[4:0]),
	.src_b(src_b_reg[4:0]),
	.write_data(edp_wrdata_w),
	.write_en(srs_write_en[8]));

  /*hookup*/
  `M14K_RF_REG_MODULE9 rf_reg9 (
	.dest(mpc_dest_w[4:0]),
	.gclk( grfclk),
	.gscanenable(gscanenable),
	.read_data_a(read_data_a_9),
	.read_data_b(read_data_b_9),
	.rf_init_done(rf_init_done_9),
	.src_a(src_a_reg[4:0]),
	.src_b(src_b_reg[4:0]),
	.write_data(edp_wrdata_w),
	.write_en(srs_write_en[9]));

  /*hookup*/
  `M14K_RF_REG_MODULE10 rf_reg10 (
	.dest(mpc_dest_w[4:0]),
	.gclk( grfclk),
	.gscanenable(gscanenable),
	.read_data_a(read_data_a_10),
	.read_data_b(read_data_b_10),
	.rf_init_done(rf_init_done_10),
	.src_a(src_a_reg[4:0]),
	.src_b(src_b_reg[4:0]),
	.write_data(edp_wrdata_w),
	.write_en(srs_write_en[10]));

  /*hookup*/
  `M14K_RF_REG_MODULE11 rf_reg11 (
	.dest(mpc_dest_w[4:0]),
	.gclk( grfclk),
	.gscanenable(gscanenable),
	.read_data_a(read_data_a_11),
	.read_data_b(read_data_b_11),
	.rf_init_done(rf_init_done_11),
	.src_a(src_a_reg[4:0]),
	.src_b(src_b_reg[4:0]),
	.write_data(edp_wrdata_w),
	.write_en(srs_write_en[11]));

  /*hookup*/
  `M14K_RF_REG_MODULE12 rf_reg12 (
	.dest(mpc_dest_w[4:0]),
	.gclk( grfclk),
	.gscanenable(gscanenable),
	.read_data_a(read_data_a_12),
	.read_data_b(read_data_b_12),
	.rf_init_done(rf_init_done_12),
	.src_a(src_a_reg[4:0]),
	.src_b(src_b_reg[4:0]),
	.write_data(edp_wrdata_w),
	.write_en(srs_write_en[12]));

  /*hookup*/
  `M14K_RF_REG_MODULE13 rf_reg13 (
	.dest(mpc_dest_w[4:0]),
	.gclk( grfclk),
	.gscanenable(gscanenable),
	.read_data_a(read_data_a_13),
	.read_data_b(read_data_b_13),
	.rf_init_done(rf_init_done_13),
	.src_a(src_a_reg[4:0]),
	.src_b(src_b_reg[4:0]),
	.write_data(edp_wrdata_w),
	.write_en(srs_write_en[13]));

  /*hookup*/
  `M14K_RF_REG_MODULE14 rf_reg14 (
	.dest(mpc_dest_w[4:0]),
	.gclk( grfclk),
	.gscanenable(gscanenable),
	.read_data_a(read_data_a_14),
	.read_data_b(read_data_b_14),
	.rf_init_done(rf_init_done_14),
	.src_a(src_a_reg[4:0]),
	.src_b(src_b_reg[4:0]),
	.write_data(edp_wrdata_w),
	.write_en(srs_write_en[14]));

  /*hookup*/
  `M14K_RF_REG_MODULE15 rf_reg15 (
	.dest(mpc_dest_w[4:0]),
	.gclk( grfclk),
	.gscanenable(gscanenable),
	.read_data_a(read_data_a_15),
	.read_data_b(read_data_b_15),
	.rf_init_done(rf_init_done_15),
	.src_a(src_a_reg[4:0]),
	.src_b(src_b_reg[4:0]),
	.write_data(edp_wrdata_w),
	.write_en(srs_write_en[15]));


  // a read port
  mvp_mux16 #(32) _rf_adt_e_31_0_(rf_adt_e[31:0],src_a_srs[3:0], 
			   read_data_a_0, read_data_a_1,
			   read_data_a_2, read_data_a_3,
			   read_data_a_4, read_data_a_5,
			   read_data_a_6, read_data_a_7,
			   read_data_a_8, read_data_a_9,
			   read_data_a_10, read_data_a_11,
			   read_data_a_12, read_data_a_13,
			   read_data_a_14, read_data_a_15);

  // b read port
  mvp_mux16 #(32) _rf_bdt_e_31_0_(rf_bdt_e[31:0],src_b_srs[3:0], 
			   read_data_b_0, read_data_b_1,
			   read_data_b_2, read_data_b_3,
			   read_data_b_4, read_data_b_5,
			   read_data_b_6, read_data_b_7,
			   read_data_b_8, read_data_b_9,
			   read_data_b_10, read_data_b_11,
			   read_data_b_12, read_data_b_13,
			   read_data_b_14, read_data_b_15);

  assign rf_bistfrom[`M14K_RF_BIST_FROM-1:0] = {`M14K_RF_BIST_FROM{1'b0}};

endmodule
