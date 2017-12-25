// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
// ###########################################################################
//
// cop2: Cop2 emulator
//
// $Id: \$
// mips_repository_id: m14k_cop2_stub.mv, v 1.1 
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
module m14k_cop2_stub(
	CP2_abusy_0,
	CP2_tbusy_0,
	CP2_fbusy_0,
	CP2_cccs_0,
	CP2_ccc_0,
	CP2_excs_0,
	CP2_exc_0,
	CP2_exccode_0,
	CP2_fds_0,
	CP2_forder_0,
	CP2_fdata_0,
	CP2_tordlim_0,
	CP2_present,
	CP2_idle,
	CP2_as_0,
	CP2_ts_0,
	CP2_fs_0,
	CP2_irenable_0,
	CP2_ir_0,
	CP2_endian_0,
	CP2_inst32_0,
	CP2_nulls_0,
	CP2_null_0,
	CP2_kills_0,
	CP2_kill_0,
	CP2_tds_0,
	CP2_tdata_0,
	CP2_torder_0,
	CP2_fordlim_0,
	CP2_reset,
	CP2_kd_mode_0,
	SI_Reset,
	SI_ClkIn,
	CP2_tocp2,
	CP2_fromcp2);


   // Cop2 I/F output signals
   output                   CP2_abusy_0;        // COP2 Arithmetric instruction busy
   output                   CP2_tbusy_0;        // COP2 To data busy
   output                   CP2_fbusy_0;        // COP2 From data busy
   output                   CP2_cccs_0;         // COP2 Condition Code Check Strobe
   output                   CP2_ccc_0;          // COP2 Condition Code Check
   output                   CP2_excs_0;		// COP2 Exceptions strobe
   output                   CP2_exc_0;		// COP2 Exception
   output [4:0]             CP2_exccode_0;      // COP2 Exception Code
   output                   CP2_fds_0;		// COP2 From data Data strobe
   output [2:0]             CP2_forder_0;       // COP2 From data ordering
   output [31:0] 	    CP2_fdata_0;	// COP2 From data
   output [2:0]             CP2_tordlim_0;      // COP2 To data ordering limit
   output                   CP2_present;        // COP2 is present (1=present)
   output                   CP2_idle;           // COP2 Coprocessor is idle

   // Cop2 I/F input signals
   input                    CP2_as_0;           // COP2 Arith strobe
   input                    CP2_ts_0;           // COP2 To strobe
   input                    CP2_fs_0;           // COP2 From strobe
   input                    CP2_irenable_0;     // COP2 Enable Instruction
   input [31:0]             CP2_ir_0;           // COP2 instruction word
   input                    CP2_endian_0;       // COP2 Endianess
   input                    CP2_inst32_0;       // COP2 MIPS32 compatible inst
   input                    CP2_nulls_0;        // COP2 Nullify strobe
   input                    CP2_null_0;         // COP2 Nullify
   input                    CP2_kills_0;        // COP2 Kill strobe
   input [1:0]              CP2_kill_0;         // COP2 Kill code
   input                    CP2_tds_0;          // COP2 To data strobe
   input [31:0]  	    CP2_tdata_0;        // COP2 To data
   input [2:0]              CP2_torder_0;       // COP2 To data ordering
   input [2:0]              CP2_fordlim_0;      // COP2 From data order limit
   input                    CP2_reset;		// COP2 greset signal
   input                    CP2_kd_mode_0;      // COP2 kernel mode signal             

   // Cop2 emulator control
   input 		SI_Reset;		// Global reset
   input 		SI_ClkIn;		// Global clock

    // external CP2 signals
  input  [`M14K_CP2_EXT_TOCP2_WIDTH-1:0] CP2_tocp2; // External input to CP2 module
  output  [`M14K_CP2_EXT_FROMCP2_WIDTH-1:0] CP2_fromcp2; // Output from CP2 module to external system    

// BEGIN Wire declarations made by MVP
wire [4:0] /*[4:0]*/ CP2_exccode_0;
wire [31:0] /*[31:0]*/ CP2_fdata_0;
wire CP2_idle;
wire CP2_fbusy_0;
wire [`M14K_CP2_EXT_FROMCP2_WIDTH-1:0] /*[0:0]*/ CP2_fromcp2;
wire CP2_ccc_0;
wire CP2_cccs_0;
wire CP2_tbusy_0;
wire [2:0] /*[2:0]*/ CP2_forder_0;
wire CP2_abusy_0;
wire CP2_excs_0;
wire CP2_exc_0;
wire CP2_present;
wire [2:0] /*[2:0]*/ CP2_tordlim_0;
wire CP2_fds_0;
// END Wire declarations made by MVP

    
assign CP2_fromcp2[`M14K_CP2_EXT_FROMCP2_WIDTH-1:0] = {`M14K_CP2_EXT_FROMCP2_WIDTH{1'b0}};
    

   assign CP2_abusy_0 = 1'b0;
   assign CP2_tbusy_0 = 1'b0;
   assign CP2_fbusy_0 = 1'b0;        // COP2 From data busy
   assign CP2_cccs_0 = 1'b0;         // COP2 Condition Code Check Strobe
   assign CP2_ccc_0 = 1'b0;          // COP2 Condition Code Check
   assign CP2_excs_0 = 1'b0;		// COP2 Exceptions strobe
   assign CP2_exc_0 = 1'b0;		// COP2 Exception
   assign CP2_exccode_0[4:0] = 5'b0;      // COP2 Exception Code
   assign CP2_fds_0 = 1'b0;		// COP2 From data Data strobe
   assign CP2_forder_0[2:0] = 3'b0;       // COP2 From data ordering
   assign CP2_fdata_0[31:0] = 32'b0;	// COP2 From data
   assign CP2_tordlim_0[2:0] = 3'b0;      // COP2 To data ordering limit
   assign CP2_present = 1'b0;        // COP2 is present (1=present)
   assign CP2_idle = 1'b0;           // COP2 Coprocessor is idle
    


endmodule // m14k_cop2_stub




