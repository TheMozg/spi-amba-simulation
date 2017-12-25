// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
// ###########################################################################
//
// cop1: Cop1 emulator
//
// $Id: \$
// mips_repository_id: m14k_cop1_stub.mv, v 1.7 
//
// mips_start_of_legal_notice
// ***************************************************************************
// Unpublished work (c) MIPS Technologies, Inc.  All rights reserved. 
// Unpublished rights reserved under the copyright laws of the United States
// of America and other countries.
// 
// MIPS TECHNOLOGIES PROPRIETARY / RESTRICTED CONFIDENTIAL - HEIGHTENED
// STANDARD OF CARE REQUIRED AS PER CONTRACT
// 
// This code is confidential and proprietary to MIPS Technologies, Inc. ("MIPS
// Technologies") and may be disclosed only as permitted in writing by MIPS
// Technologies.  Any copying, reproducing, modifying, use or disclosure of
// this code (in whole or in part) that is not expressly permitted in writing
// by MIPS Technologies is strictly prohibited.  At a minimum, this code is
// protected under trade secret, unfair competition and copyright laws. 
// Violations thereof may result in criminal penalties and fines.
// 
// MIPS Technologies reserves the right to change the code to improve
// function, design or otherwise.	MIPS Technologies does not assume any
// liability arising out of the application or use of this code, or of any
// error or omission in such code.  Any warranties, whether express,
// statutory, implied or otherwise, including but not limited to the implied
// warranties of merchantability or fitness for a particular purpose, are
// excluded.  Except as expressly provided in any written license agreement
// from MIPS Technologies, the furnishing of this code does not give recipient
// any license to any intellectual property rights, including any patent
// rights, that cover this code.
// 
// This code shall not be exported, reexported, transferred, or released,
// directly or indirectly, in violation of the law of any country or
// international law, regulation, treaty, Executive Order, statute, amendments
// or supplements thereto.  Should a conflict arise regarding the export,
// reexport, transfer, or release of this code, the laws of the United States
// of America shall be the governing law.
// 
// This code may only be disclosed to the United States government
// ("Government"), or to Government users, with prior written consent from
// MIPS Technologies.  This code constitutes one or more of the following:
// commercial computer software, commercial computer software documentation or
// other commercial items.  If the user of this code, or any related
// documentation of any kind, including related technical data or manuals, is
// an agency, department, or other entity of the Government, the use,
// duplication, reproduction, release, modification, disclosure, or transfer
// of this code, or any related documentation of any kind, is restricted in
// accordance with Federal Acquisition Regulation 12.212 for civilian agencies
// and Defense Federal Acquisition Regulation Supplement 227.7202 for military
// agencies.  The use of this code by the Government is further restricted in
// accordance with the terms of the license agreement(s) and/or applicable
// contract terms and conditions covering this code from MIPS Technologies.
// 
// 
// 
// ***************************************************************************
// mips_end_of_legal_notice
//
// ###########################################################################
`include "m14k_const.vh"
module m14k_cop1_stub(
	CP1_abusy_0,
	CP1_tbusy_0,
	CP1_fbusy_0,
	CP1_cccs_0,
	CP1_ccc_0,
	CP1_excs_0,
	CP1_exc_0,
	CP1_exccode_0,
	CP1_fds_0,
	CP1_forder_0,
	CP1_fdata_0,
	CP1_tordlim_0,
	CP1_idle,
	CP1_excs_1,
	CP1_exc_1,
	CP1_exccode_1,
	CP1_fppresent,
	CP1_ufrpresent,
	CP1_mdmxpresent,
	CP1_as_0,
	CP1_ts_0,
	CP1_fs_0,
	CP1_irenable_0,
	CP1_ir_0,
	CP1_endian_0,
	CP1_inst32_0,
	CP1_nulls_0,
	CP1_null_0,
	CP1_kills_0,
	CP1_kill_0,
	CP1_kills_1,
	CP1_kill_1,
	CP1_tds_0,
	CP1_tdata_0,
	CP1_torder_0,
	CP1_fordlim_0,
	CP1_reset,
	CP1_gpr_0,
	CP1_gprs_0,
	CP1_fr32_0,
	fpu_gclk,
	fpu_gfclk,
	gfclk,
	gscanenable,
	cpz_mnan,
	cpz_prid16);


   // Cop1 I/F output signals
   output                   CP1_abusy_0;        // COP1 Arithmetric instruction busy
   output                   CP1_tbusy_0;        // COP1 To data busy
   output                   CP1_fbusy_0;        // COP1 From data busy
   output                   CP1_cccs_0;         // COP1 Condition Code Check Strobe
   output                   CP1_ccc_0;          // COP1 Condition Code Check
   output                   CP1_excs_0;		// COP1 Exceptions strobe
   output                   CP1_exc_0;		// COP1 Exception
   output [4:0]             CP1_exccode_0;      // COP1 Exception Code
   output                   CP1_fds_0;		// COP1 From data Data strobe
   output [2:0]             CP1_forder_0;       // COP1 From data ordering
   output [63:0] 	    CP1_fdata_0;	// COP1 From data
   output [2:0]             CP1_tordlim_0;      // COP1 To data ordering limit
   output                   CP1_idle;           // COP1 Coprocessor is idle
   output		CP1_excs_1;		// COP1 Exceptions strobe
   output		CP1_exc_1;		// COP1 Exception
   output [4:0]	CP1_exccode_1;		// COP1 Exception Code

	output   CP1_fppresent;
	output   CP1_ufrpresent;
        output   CP1_mdmxpresent;

   // Cop1 I/F input signals
   input                    CP1_as_0;           // COP1 Arith strobe
   input                    CP1_ts_0;           // COP1 To strobe
   input                    CP1_fs_0;           // COP1 From strobe
   input                    CP1_irenable_0;     // COP1 Enable Instruction
   input [31:0]             CP1_ir_0;           // COP1 instruction word
   input                    CP1_endian_0;       // COP1 Endianess
   input                    CP1_inst32_0;       // COP1 MIPS32 compatible inst
   input                    CP1_nulls_0;        // COP1 Nullify strobe
   input                    CP1_null_0;         // COP1 Nullify
   input                    CP1_kills_0;        // COP1 Kill strobe
   input [1:0]              CP1_kill_0;         // COP1 Kill code
   input                    CP1_kills_1;        // COP1 Kill strobe
   input [1:0]              CP1_kill_1;         // COP1 Kill code
   input                    CP1_tds_0;          // COP1 To data strobe
   input [63:0]  	    CP1_tdata_0;        // COP1 To data
   input [2:0]              CP1_torder_0;       // COP1 To data ordering
   input [2:0]              CP1_fordlim_0;      // COP1 From data order limit
   input                    CP1_reset;		// COP1 greset signal
   input [3:0] 	 CP1_gpr_0;		
   input 	 CP1_gprs_0;		
   input	 CP1_fr32_0;


   // Cop1 emulator control
   input           fpu_gclk;               // FPU Clock (when not in idle)
   input           fpu_gfclk;              // FPU Free-Running Clock (when not in sleep mode)
   input 		gfclk;		// Global clock
   input 		gscanenable;

   input                cpz_mnan;
   input [15:0]		cpz_prid16;

// BEGIN Wire declarations made by MVP
wire [63:0] /*[63:0]*/ CP1_fdata_0;
wire CP1_exc_0;
wire CP1_idle;
wire CP1_tbusy_0;
wire CP1_mdmxpresent;
wire CP1_ccc_0;
wire [2:0] /*[2:0]*/ CP1_forder_0;
wire [3:0] /*[3:0]*/ CP1_gpr_0;
wire CP1_gprs_0;
wire CP1_fbusy_0;
wire CP1_cccs_0;
wire CP1_excs_0;
wire CP1_abusy_0;
wire [4:0] /*[4:0]*/ CP1_exccode_0;
wire CP1_fds_0;
wire [2:0] /*[2:0]*/ CP1_tordlim_0;
wire CP1_fppresent;
// END Wire declarations made by MVP


   assign CP1_abusy_0 = 1'b0;
   assign CP1_tbusy_0 = 1'b0;
   assign CP1_fbusy_0 = 1'b0;        // COP1 From data busy
   assign CP1_cccs_0 = 1'b0;         // COP1 Condition Code Check Strobe
   assign CP1_ccc_0 = 1'b0;          // COP1 Condition Code Check
   assign CP1_excs_0 = 1'b0;		// COP1 Exceptions strobe
   assign CP1_exc_0 = 1'b0;		// COP1 Exception
   assign CP1_exccode_0[4:0] = 5'b0;      // COP1 Exception Code
   assign CP1_fds_0 = 1'b0;		// COP1 From data Data strobe
   assign CP1_forder_0[2:0] = 3'b0;       // COP1 From data ordering
   assign CP1_fdata_0[63:0] = 64'b0;	// COP1 From data
   assign CP1_tordlim_0[2:0] = 3'b0;      // COP1 To data ordering limit
   assign CP1_idle = 1'b0;           // COP1 Coprocessor is idle
//   assign CP1_gpr_0[3:0] = 4'b0;
//   assign CP1_gprs_0 = 1'b0;
   assign CP1_fppresent = 1'b0;
   assign CP1_mdmxpresent = 1'b0;








//
`ifdef MIPS_SIMULATION

//verilint 599 off
//verilint 239 off
//verilint 528 off        // Variable set but not used
//hotwires for tracer
  
  

wire  tracer_fcrun_a1 = 1'b0;
wire  tracer_fcrun_a2 = 1'b0;
wire  tracer_fcrun_fp = 1'b0;
wire  tracer_fc_fprwr_a1 = 1'b0;
wire  tracer_got_kill_a2_nxt = 1'b0;
wire  tracer_killed_a2_nxt = 1'b0;
wire  tracer_got_kill_fp_nxt = 1'b0;
wire  tracer_killed_fp_nxt = 1'b0;
wire  tracer_killed_fp = 1'b0;
wire  tracer_d_rf_write = 1'b0;
wire  tracer_fc_tdata_cond = 1'b0;
wire  tracer_fc_hold_dr_cond = 1'b0;
wire  tracer_fc_data_d1_cond = 1'b0;
wire  tracer_fc_data_d2_cond = 1'b0;
wire  tracer_fc_data_dw_cond = 1'b0;
wire  tracer_fc_mux2_sel_dr = 1'b0;
wire  tracer_fc_mux_sel_d1 = 1'b0;
wire  tracer_fc_mux_sel_d2 = 1'b0;
wire [63:0]  tracer_fpr00 = 64'b0; 
wire [63:0]  tracer_fpr01 = 64'b0;
wire [63:0]  tracer_fpr02 = 64'b0; 
wire [63:0]  tracer_fpr03 = 64'b0;
wire [63:0]  tracer_fpr04 = 64'b0; 
wire [63:0]  tracer_fpr05 = 64'b0;
wire [63:0]  tracer_fpr06 = 64'b0; 
wire [63:0]  tracer_fpr07 = 64'b0;
wire [63:0]  tracer_fpr08 = 64'b0; 
wire [63:0]  tracer_fpr09 = 64'b0;
wire [63:0]  tracer_fpr10 = 64'b0; 
wire [63:0]  tracer_fpr11 = 64'b0;
wire [63:0]  tracer_fpr12 = 64'b0; 
wire [63:0]  tracer_fpr13 = 64'b0;
wire [63:0]  tracer_fpr14 = 64'b0; 
wire [63:0]  tracer_fpr15 = 64'b0;
wire [63:0]  tracer_fpr16 = 64'b0; 
wire [63:0]  tracer_fpr17 = 64'b0;
wire [63:0]  tracer_fpr18 = 64'b0; 
wire [63:0]  tracer_fpr19 = 64'b0;
wire [63:0]  tracer_fpr20 = 64'b0; 
wire [63:0]  tracer_fpr21 = 64'b0;
wire [63:0]  tracer_fpr22 = 64'b0; 
wire [63:0]  tracer_fpr23 = 64'b0;
wire [63:0]  tracer_fpr24 = 64'b0; 
wire [63:0]  tracer_fpr25 = 64'b0;
wire [63:0]  tracer_fpr26 = 64'b0; 
wire [63:0]  tracer_fpr27 = 64'b0;
wire [63:0]  tracer_fpr28 = 64'b0; 
wire [63:0]  tracer_fpr29 = 64'b0;
wire [63:0]  tracer_fpr30 = 64'b0; 
wire [63:0]  tracer_fpr31 = 64'b0;
wire  tracer_fc_fr32_fp = 1'b0;
wire  tracer_d_rf_write_fr32 = 1'b0;
wire  tracer_fc_wrenlo1 = 1'b0;
wire  tracer_fc_wrenhi1 = 1'b0;
wire [4:0] tracer_fc_wra1 = 5'b0;
wire  tracer_fc_wrenlo2 = 1'b0;
wire  tracer_fc_wrenhi2 = 1'b0;
wire [4:0] tracer_fc_wra2 = 5'b0;
wire  tracer_gclk_fpu = 1'b0;
wire [8:0]  tracer_fcsr_cond = 9'b0;
wire [31:0]  tracer_fcr25_value_dr = 32'b0;
wire [31:0]  tracer_fcr26_value_dr = 32'b0;
wire [31:0]  tracer_fcr28_value_dr = 32'b0;
wire [31:0]  tracer_fcr31_value_dr = 32'b0;
wire [31:0]  tracer_fcr0_value = 32'b0;




wire unused_tracer_ok = &{1'b0,
  tracer_fcrun_a1,
  tracer_fcrun_a2,
  tracer_fcrun_fp,
  tracer_fc_fprwr_a1,
  tracer_got_kill_a2_nxt,
  tracer_killed_a2_nxt,
  tracer_got_kill_fp_nxt,
  tracer_killed_fp_nxt,
  tracer_killed_fp,
  tracer_d_rf_write,
  tracer_fc_tdata_cond,
  tracer_fc_hold_dr_cond,
  tracer_fc_data_d1_cond,
  tracer_fc_data_d2_cond,
  tracer_fc_data_dw_cond,
  tracer_fc_mux2_sel_dr,
  tracer_fc_mux_sel_d1,
  tracer_fc_mux_sel_d2,
  tracer_fpr00[63:0], 
  tracer_fpr01[63:0],
  tracer_fpr02[63:0], 
  tracer_fpr03[63:0],
  tracer_fpr04[63:0], 
  tracer_fpr05[63:0],
  tracer_fpr06[63:0], 
  tracer_fpr07[63:0],
  tracer_fpr08[63:0], 
  tracer_fpr09[63:0],
  tracer_fpr10[63:0], 
  tracer_fpr11[63:0],
  tracer_fpr12[63:0], 
  tracer_fpr13[63:0],
  tracer_fpr14[63:0], 
  tracer_fpr15[63:0],
  tracer_fpr16[63:0], 
  tracer_fpr17[63:0],
  tracer_fpr18[63:0], 
  tracer_fpr19[63:0],
  tracer_fpr20[63:0], 
  tracer_fpr21[63:0],
  tracer_fpr22[63:0], 
  tracer_fpr23[63:0],
  tracer_fpr24[63:0], 
  tracer_fpr25[63:0],
  tracer_fpr26[63:0], 
  tracer_fpr27[63:0],
  tracer_fpr28[63:0], 
  tracer_fpr29[63:0],
  tracer_fpr30[63:0], 
  tracer_fpr31[63:0],
  tracer_fc_fr32_fp,
  tracer_d_rf_write_fr32,
  tracer_fc_wrenlo1,
  tracer_fc_wrenhi1,
  tracer_fc_wra1,
  tracer_fc_wrenlo2,
  tracer_fc_wrenhi2,
  tracer_fc_wra2,
  tracer_gclk_fpu,
  tracer_fcsr_cond[8:0],
  tracer_fcr25_value_dr[31:0],
  tracer_fcr26_value_dr[31:0],
  tracer_fcr28_value_dr[31:0],
  tracer_fcr31_value_dr[31:0],
  tracer_fcr0_value[31:0]};


//verilint 528 on        // Variable set but not used

//verilint 599 on
//verilint 239 on

`endif
//








endmodule // m14k_cop1_stub




