// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// Description: m14k_cp1_stub
//      Dummy stub-module of CP1 IF module
//
// $Id: \$
// mips_repository_id: m14k_cp1_stub.mv, v 1.16 
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

// Comments for verilint
// This is a stub module so most of the inputs are unused
//verilint 240 off  // Unused input


`include "m14k_const.vh"
module m14k_cp1_stub(
	CP1_abusy_0,
	CP1_tbusy_0,
	CP1_fbusy_0,
	CP1_cccs_0,
	CP1_ccc_0,
	CP1_fppresent,
	CP1_ufrpresent,
	CP1_mdmxpresent,
	CP1_idle,
	CP1_excs_0,
	CP1_exc_0,
	CP1_exccode_0,
	CP1_excs_1,
	CP1_exc_1,
	CP1_exccode_1,
	CP1_fds_0,
	CP1_forder_0,
	CP1_fdata_0,
	CP1_tordlim_0,
	CP1_as_0,
	CP1_ts_0,
	CP1_fs_0,
	CP1_irenable_0,
	CP1_ir_0,
	CP1_endian_0,
	CP1_inst32_0,
	CP1_nulls_0,
	CP1_null_0,
	CP1_gprs_0,
	CP1_gpr_0,
	CP1_reset,
	CP1_kills_0,
	CP1_kill_0,
	CP1_kills_1,
	CP1_kill_1,
	CP1_tds_0,
	CP1_tdata_0,
	CP1_torder_0,
	CP1_fordlim_0,
	CP1_fr32_0,
	gclk,
	greset,
	gscanenable,
	gscanmode,
	mpc_srcvld_e,
	mpc_irval_e,
	mpc_ir_e,
	mpc_predec_e,
	mpc_umipspresent,
	cpz_rbigend_e,
	cpz_kuc_e,
	mpc_killcp1_w,
	mpc_cp1exc,
	mpc_brrun_ie,
	mpc_run_ie,
	mpc_run_m,
	mpc_run_w,
	mpc_wait_m,
	mpc_lsdc1_m,
	mpc_lsdc1_e,
	mpc_ldc1_m,
	mpc_ldc1_w,
	mpc_lsdc1_w,
	mpc_sdc1_w,
	edp_bbus_e,
	cpz_fr,
	dcc_valid_d_access,
	mpc_auexc_x,
	cpz_cu1,
	mpc_fixupd,
	dcc_dmiss_m,
	edp_ldcpdata_w,
	cp1_coppresent,
	cp1_copidle,
	cp1_fixup_m,
	cp1_fixup_w,
	cp1_fixup_i,
	cp1_stall_e,
	cp1_bstall_e,
	cp1_btaken,
	cp1_bvalid,
	cp1_movefrom_m,
	cp1_moveto_m,
	cp1_storekill_w,
	cp1_datasel,
	cp1_storeissued_m,
	cp1_ldst_m,
	cp1_missexc_w,
	cp1_exc_w,
	cp1_exccode_w,
	cp1_data_w,
	dcc_store_allocate,
	dcc_par_kill_mw,
	cp1_storealloc_reg,
	cp1_fixup_w_nolsdc1,
	cp1_stall_m,
	cp1_seen_nodmiss_m,
	cp1_data_missing,
	cp1_ufrp);


/*hookios*/
   // Cop1 I/F input/output signals
   input         CP1_abusy_0;		// COP1 Arithmetric instruction busy
   input 	 CP1_tbusy_0;		// COP1 To data busy
   input 	 CP1_fbusy_0;		// COP1 From data busy
   input 	 CP1_cccs_0;		// COP1 Condition Code Check Strobe
   input 	 CP1_ccc_0;		// COP1 Condition Code Check
   input 	 CP1_fppresent;		// COP1 is present (1=present)
   input 	 CP1_ufrpresent;	
   input 	 CP1_mdmxpresent;		// COP1 is present (1=present)
   input 	 CP1_idle;		// COP1 Coprocessor is idle
   input 	 CP1_excs_0;		// COP1 Exceptions strobe
   input 	 CP1_exc_0;		// COP1 Exception
   input [4:0] 	 CP1_exccode_0;		// COP1 Exception Code (Valid if CP1_exc_0 == 1)
   input 	 CP1_excs_1;		// COP1 Exceptions strobe
   input 	 CP1_exc_1;		// COP1 Exception
   input [4:0] 	 CP1_exccode_1;		// COP1 Exception Code (Valid if CP1_exc_1 == 1)
   input 	 CP1_fds_0;		// COP1 From data Data strobe
   input [2:0]	 CP1_forder_0;		// COP1 From data ordering
   input [63:0]  CP1_fdata_0;		// COP1 From data
   input [2:0] 	 CP1_tordlim_0;		// COP1 To data ordering limit
   output 	 CP1_as_0;		// COP1 Arithmetric instruction strobe
   output 	 CP1_ts_0;		// COP1 To data instruction strobe
   output 	 CP1_fs_0;		// COP1 From data instruction strobe
   output 	 CP1_irenable_0;	// COP1 Enable Instruction registering
   output [31:0] CP1_ir_0;		// COP1 Arithmich and To/From instruction
   output 	 CP1_endian_0;		// COP1 Big Endian used in instruction/To/From
   output 	 CP1_inst32_0;		// COP1 MIPS32 compatible instruction
   output 	 CP1_nulls_0;		// COP1 Nullify strobe
   output 	 CP1_null_0;		// COP1 Nullify
   output	 CP1_gprs_0;
   output [3:0]	 CP1_gpr_0;
   output 	 CP1_reset;		// COP1 greset signal
   output 	 CP1_kills_0;		// COP1 Kill strobe
   output [1:0]  CP1_kill_0;		// COP1 Kill (00, 01=NoKill, 10=KillNotCP, 11=KillCP)
   output 	 CP1_kills_1;		// COP1 Kill strobe
   output [1:0]  CP1_kill_1;		// COP1 Kill (00, 01=NoKill, 10=KillNotCP, 11=KillCP)
   output 	 CP1_tds_0;		// COP1 To data Data strobe
   output [63:0] CP1_tdata_0;		// COP1 To data
   output [2:0]  CP1_torder_0;		// COP1 To data ordering
   output [2:0]  CP1_fordlim_0;		// COP1 From data ordering limit
   output	 CP1_fr32_0;

   
   // Integer unit input/output signals
   input 	 gclk;			// Global clock
   input 	 greset;		// Global reset
   input 	 gscanenable;		// Global Scan Enable
   input         gscanmode;
   input 	 mpc_srcvld_e;		// Abus and Bbus are valid.
   input 	 mpc_irval_e;		// Instruction on mpc_ir_e is valid
   input [31:0]  mpc_ir_e;		// Instruction in E stage
   input [22:0]  mpc_predec_e;		// umips predecoded instructions
   input         mpc_umipspresent;	// umips decoder present
   input 	 cpz_rbigend_e;		// Endianess of current instruction
   input 	 cpz_kuc_e;		// Current instruction is in user mode
   input 	 mpc_killcp1_w;		// Kill all E, M and W stage commands
   input 	 mpc_cp1exc;		// Kill exception due to COP1 (Valid first cycle of mpc_killcp1_w)
   input 	 mpc_brrun_ie;		// Stage I,E  is moving to next stage. Not deaserted for COP1 branch.
   input 	 mpc_run_ie;		// Stage I,E is moving to next stage.
   input 	 mpc_run_m;		// Stage M is moving to next stage.
   input 	 mpc_run_w;		// Stage W is moving to next stage.
   input	 mpc_wait_m;            // Wait instruction is in M stage, 
   input 	 mpc_lsdc1_m;
   input 	 mpc_lsdc1_e;
   input		mpc_ldc1_m;
   input		mpc_ldc1_w;
   input 	 mpc_lsdc1_w;
   input 	 mpc_sdc1_w;
   input	[31:0]	edp_bbus_e;		
   input 	 cpz_fr;
   input 	 dcc_valid_d_access;
   input 	 mpc_auexc_x;
					// following cop1 in E stage will be cancelled
   input 	 cpz_cu1;		// CU1 bit from Status register
   input 	 mpc_fixupd;		// D$ rerunning M-stage due to cache miss
   input 	 dcc_dmiss_m;		// Miss in D$
   input [31:0]  edp_ldcpdata_w;	// Result of Cache hit/Register read
   output 	 cp1_coppresent;	// COP 1 is present on the interface.
   output 	 cp1_copidle;		// COP 1 is Idle, biu_shutdown is OK for COP 1
   output 	 cp1_fixup_m;		// Previous E-stage is rerun in cp1, due to busy signal
   output 	 cp1_fixup_w;		// Rerun Stage-M
   output 	 cp1_fixup_i;		// Rerun Stage-I
   output 	 cp1_stall_e;		// Stall Current E-stage due to COP1 delay
   output 	 cp1_bstall_e;		// Stall Current E-stage due to branch on COP1 condition
   output 	 cp1_btaken;		// COP1 Branch is taken (Valid when cp1_bvalid == '1')
   output 	 cp1_bvalid;		// COP1 Bransh taken Valid
   output 	 cp1_movefrom_m;	// COP1 Move to/from register file
   output 	 cp1_moveto_m;	// COP1 Move to/from register file
   output 	 cp1_storekill_w; 	// Invalidate COP1 store data in SB
   output 	 cp1_datasel; 		// Select cp1_data_w in store buffer.
   output 	 cp1_storeissued_m;	// Indicate that a SWC1 is issued to CP1
   output 	 cp1_ldst_m;		// LWC1 or SWC1 is in W stage
   output 	 cp1_missexc_w; 	// COP1 Exception Not ready
   output 	 cp1_exc_w;		// COP1 Exception
   output [4:0]  cp1_exccode_w;		// COP1 Exception Code
   output [63:0] cp1_data_w;   		// Return Data from COP1

   // Data Cache Controller input/outputs
   // to bring registers only needed in m14k_dcc when m14k_cp1 is implemented
   // into this modules.
   input 	 dcc_store_allocate;
   input 	 dcc_par_kill_mw;
   output 	 cp1_storealloc_reg;
   output 	 cp1_fixup_w_nolsdc1;
   output 	 cp1_stall_m;

   output 	 cp1_seen_nodmiss_m;
   output 	 cp1_data_missing;
   output 	 cp1_ufrp;

// BEGIN Wire declarations made by MVP
wire [1:0] /*[1:0]*/ CP1_kill_0;
wire CP1_ts_0;
wire CP1_irenable_0;
wire cp1_copidle;
wire cp1_stall_m;
wire cp1_coppresent;
wire cp1_fixup_w_nolsdc1;
wire [4:0] /*[4:0]*/ cp1_exccode_w;
wire CP1_endian_0;
wire cp1_movefrom_m;
wire CP1_fs_0;
wire cp1_storealloc_reg;
wire CP1_null_0;
wire CP1_kills_0;
wire cp1_exc_w;
wire cp1_fixup_w;
wire cp1_ufrp;
wire cp1_ldst_m;
wire cp1_fixup_m;
wire CP1_tds_0;
wire [63:0] /*[63:0]*/ CP1_tdata_0;
wire [31:0] /*[31:0]*/ CP1_ir_0;
wire [2:0] /*[2:0]*/ CP1_torder_0;
wire cp1_storeissued_m;
wire CP1_reset;
wire cp1_btaken;
wire cp1_data_missing;
wire cp1_bvalid;
wire [2:0] /*[2:0]*/ CP1_fordlim_0;
wire CP1_nulls_0;
wire CP1_as_0;
wire cp1_fixup_i;
wire cp1_moveto_m;
wire cp1_seen_nodmiss_m;
wire cp1_missexc_w;
wire cp1_storekill_w;
wire cp1_stall_e;
wire CP1_inst32_0;
wire cp1_datasel;
wire cp1_bstall_e;
wire [63:0] /*[63:0]*/ cp1_data_w;
// END Wire declarations made by MVP


   // Apply dummy outputs
   assign CP1_as_0 = 		1'd0;
   assign CP1_ts_0 =		1'd0;
   assign CP1_fs_0 =		1'd0;
   assign CP1_irenable_0 =	1'd0;
   assign CP1_ir_0 [31:0] =	32'd0;
   assign CP1_endian_0 =	1'd0;
   assign CP1_inst32_0 =	1'd0;
   assign CP1_nulls_0 =        1'd0;
   assign CP1_null_0 =		1'd0;
   assign CP1_reset =		1'd1;
   assign CP1_kills_0 =	1'd0;
   assign CP1_kill_0 [1:0] =	2'd0;
   assign CP1_tds_0 =		1'd0;
   assign CP1_tdata_0 [63:0] =	64'd0;
   assign CP1_torder_0 [2:0] =	3'd0;
   assign CP1_fordlim_0 [2:0] = 3'd0;
   
   assign cp1_coppresent =	1'd0;
   assign cp1_copidle =	1'd1;
   assign cp1_fixup_m =	1'd0;
   assign cp1_fixup_w =	1'd0;
   assign cp1_stall_e =	1'd0;
   assign cp1_bstall_e =	1'd0;
   assign cp1_btaken =		1'd0;
   assign cp1_bvalid =		1'd0;
   assign cp1_movefrom_m =	1'd0;
   assign cp1_moveto_m =	1'd0;
   assign cp1_storekill_w =	1'd0;
   assign cp1_datasel =	1'd0;
   assign cp1_storealloc_reg =	1'd0;
   assign cp1_fixup_w_nolsdc1 =	1'd0;
   assign cp1_stall_m =	1'd0;
   assign cp1_storeissued_m =	1'd0;
   assign cp1_ldst_m =		1'd0;
   assign cp1_missexc_w =	1'd0;
   assign cp1_exc_w =		1'd0;
   assign cp1_exccode_w [4:0] =5'd0;
   assign cp1_data_w [63:0] = 64'd0;
   assign cp1_seen_nodmiss_m =	1'd0;
   assign cp1_data_missing =	1'd0;
   assign cp1_fixup_i =	1'd0;
   assign cp1_ufrp =	1'd0;
   
   
// 
 `ifdef MIPS_SIMULATION 
 //VCS coverage off 
//
//verilint 528 off        // Variable set but not used

	wire cmd_movci_e = 1'b0;
	wire [1:0] disp_current_stage = 2'b0;

 //VCS coverage on  
 `endif 
//
//
//verilint 528 on        // Variable set but not used

//verilint 240 on  // Unused input
endmodule // cp1_stub
