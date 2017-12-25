// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// Description: m14k_cp2_stub
//      Dummy stub-module of CP2 IF module
//
// $Id: \$
// mips_repository_id: m14k_cp2_stub.mv, v 1.7 
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
module m14k_cp2_stub(
	CP2_abusy_0,
	CP2_tbusy_0,
	CP2_fbusy_0,
	CP2_cccs_0,
	CP2_ccc_0,
	CP2_present,
	CP2_idle,
	CP2_excs_0,
	CP2_exc_0,
	CP2_exccode_0,
	CP2_fds_0,
	CP2_forder_0,
	CP2_fdata_0,
	CP2_tordlim_0,
	CP2_as_0,
	CP2_ts_0,
	CP2_fs_0,
	CP2_irenable_0,
	CP2_ir_0,
	CP2_endian_0,
	CP2_kd_mode_0,
	CP2_inst32_0,
	CP2_nulls_0,
	CP2_null_0,
	CP2_reset,
	CP2_kills_0,
	CP2_kill_0,
	CP2_tds_0,
	CP2_tdata_0,
	CP2_torder_0,
	CP2_fordlim_0,
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
	mpc_killcp2_w,
	mpc_cp2exc,
	mpc_brrun_ie,
	mpc_run_ie,
	mpc_run_m,
	mpc_run_w,
	mpc_wait_m,
	cpz_cu2,
	mpc_fixupd,
	dcc_dmiss_m,
	edp_ldcpdata_w,
	cp2_coppresent,
	cp2_copidle,
	cp2_fixup_m,
	cp2_fixup_w,
	cp2_stall_e,
	cp2_bstall_e,
	cp2_btaken,
	cp2_bvalid,
	cp2_movefrom_m,
	cp2_moveto_m,
	cp2_storekill_w,
	cp2_datasel,
	cp2_storeissued_m,
	cp2_ldst_m,
	cp2_missexc_w,
	cp2_exc_w,
	cp2_exccode_w,
	cp2_data_w,
	dcc_store_allocate,
	dcc_par_kill_mw,
	mpc_tlb_exc_type,
	cp2_storealloc_reg);


/*hookios*/
   // Cop2 I/F input/output signals
   input         CP2_abusy_0;		// COP2 Arithmetric instruction busy
   input 	 CP2_tbusy_0;		// COP2 To data busy
   input 	 CP2_fbusy_0;		// COP2 From data busy
   input 	 CP2_cccs_0;		// COP2 Condition Code Check Strobe
   input 	 CP2_ccc_0;		// COP2 Condition Code Check
   input 	 CP2_present;		// COP2 is present (1=present)
   input 	 CP2_idle;		// COP2 Coprocessor is idle
   input 	 CP2_excs_0;		// COP2 Exceptions strobe
   input 	 CP2_exc_0;		// COP2 Exception
   input [4:0] 	 CP2_exccode_0;		// COP2 Exception Code (Valid if CP2_exc_0 == 1)
   input 	 CP2_fds_0;		// COP2 From data Data strobe
   input [2:0]	 CP2_forder_0;		// COP2 From data ordering
   input [31:0]  CP2_fdata_0;		// COP2 From data
   input [2:0] 	 CP2_tordlim_0;		// COP2 To data ordering limit
   output 	 CP2_as_0;		// COP2 Arithmetric instruction strobe
   output 	 CP2_ts_0;		// COP2 To data instruction strobe
   output 	 CP2_fs_0;		// COP2 From data instruction strobe
   output 	 CP2_irenable_0;	// COP2 Enable Instruction registering
   output [31:0] CP2_ir_0;		// COP2 Arithmich and To/From instruction
   output 	 CP2_endian_0;		// COP2 Big Endian used in instruction/To/From
   output	 CP2_kd_mode_0;         // COP2 Instn executing in kernel or debug mode
   output 	 CP2_inst32_0;		// COP2 MIPS32 compatible instruction
   output 	 CP2_nulls_0;		// COP2 Nullify strobe
   output 	 CP2_null_0;		// COP2 Nullify
   output 	 CP2_reset;		// COP2 greset signal
   output 	 CP2_kills_0;		// COP2 Kill strobe
   output [1:0]  CP2_kill_0;		// COP2 Kill (00, 01=NoKill, 10=KillNotCP, 11=KillCP)
   output 	 CP2_tds_0;		// COP2 To data Data strobe
   output [31:0] CP2_tdata_0;		// COP2 To data
   output [2:0]  CP2_torder_0;		// COP2 To data ordering
   output [2:0]  CP2_fordlim_0;		// COP2 From data ordering limit

   
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
   input 	 mpc_killcp2_w;		// Kill all E, M and W stage commands
   input 	 mpc_cp2exc;		// Kill exception due to COP2 (Valid first cycle of mpc_killcp2_w)
   input 	 mpc_brrun_ie;		// Stage I,E  is moving to next stage. Not deaserted for COP2 branch.
   input 	 mpc_run_ie;		// Stage I,E is moving to next stage.
   input 	 mpc_run_m;		// Stage M is moving to next stage.
   input 	 mpc_run_w;		// Stage W is moving to next stage.
   input	 mpc_wait_m;            // Wait instruction is in M stage, 
					// following cop2 in E stage will be cancelled
   input 	 cpz_cu2;		// CU2 bit from Status register
   input 	 mpc_fixupd;		// D$ rerunning M-stage due to cache miss
   input 	 dcc_dmiss_m;		// Miss in D$
   input [31:0]  edp_ldcpdata_w;	// Result of Cache hit/Register read
   output 	 cp2_coppresent;	// COP 2 is present on the interface.
   output 	 cp2_copidle;		// COP 2 is Idle, biu_shutdown is OK for COP 2
   output 	 cp2_fixup_m;		// Previous E-stage is rerun in cp2, due to busy signal
   output 	 cp2_fixup_w;		// Rerun Stage-M
   output 	 cp2_stall_e;		// Stall Current E-stage due to COP2 delay
   output 	 cp2_bstall_e;		// Stall Current E-stage due to branch on COP2 condition
   output 	 cp2_btaken;		// COP2 Branch is taken (Valid when cp2_bvalid == '1')
   output 	 cp2_bvalid;		// COP2 Bransh taken Valid
   output 	 cp2_movefrom_m;	// COP2 Move to/from register file
   output 	 cp2_moveto_m;	// COP2 Move to/from register file
   output 	 cp2_storekill_w; 	// Invalidate COP2 store data in SB
   output 	 cp2_datasel; 		// Select cp2_data_w in store buffer.
   output 	 cp2_storeissued_m;	// Indicate that a SWC2 is issued to CP2
   output 	 cp2_ldst_m;		// LWC2 or SWC2 is in W stage
   output 	 cp2_missexc_w; 	// COP2 Exception Not ready
   output 	 cp2_exc_w;		// COP2 Exception
   output [4:0]  cp2_exccode_w;		// COP2 Exception Code
   output [31:0] cp2_data_w;   		// Return Data from COP2

   // Data Cache Controller input/outputs
   // to bring registers only needed in m14k_dcc when m14k_cp2 is implemented
   // into this modules.
   input 	 dcc_store_allocate;
   input 	 dcc_par_kill_mw;
   input	 mpc_tlb_exc_type;	    // i stage exception type
   output 	 cp2_storealloc_reg;

// BEGIN Wire declarations made by MVP
wire [31:0] /*[31:0]*/ CP2_ir_0;
wire [2:0] /*[2:0]*/ CP2_torder_0;
wire cp2_fixup_w;
wire cp2_moveto_m;
wire cp2_storekill_w;
wire cp2_ldst_m;
wire [1:0] /*[1:0]*/ CP2_kill_0;
wire CP2_endian_0;
wire CP2_inst32_0;
wire cp2_bvalid;
wire CP2_fs_0;
wire cp2_missexc_w;
wire CP2_irenable_0;
wire CP2_tds_0;
wire cp2_btaken;
wire cp2_fixup_m;
wire CP2_null_0;
wire [2:0] /*[2:0]*/ CP2_fordlim_0;
wire cp2_coppresent;
wire cp2_stall_e;
wire CP2_nulls_0;
wire cp2_storealloc_reg;
wire cp2_storeissued_m;
wire CP2_kd_mode_0;
wire cp2_exc_w;
wire cp2_copidle;
wire CP2_ts_0;
wire CP2_kills_0;
wire [4:0] /*[4:0]*/ cp2_exccode_w;
wire cp2_bstall_e;
wire [31:0] /*[31:0]*/ CP2_tdata_0;
wire cp2_movefrom_m;
wire CP2_as_0;
wire cp2_datasel;
wire [31:0] /*[31:0]*/ cp2_data_w;
wire CP2_reset;
// END Wire declarations made by MVP


   // Apply dummy outputs
   assign CP2_as_0 = 		1'd0;
   assign CP2_ts_0 =		1'd0;
   assign CP2_fs_0 =		1'd0;
   assign CP2_irenable_0 =	1'd0;
   assign CP2_ir_0 [31:0] =	32'd0;
   assign CP2_endian_0 =	1'd0;
   assign CP2_kd_mode_0 =	1'd0;
   assign CP2_inst32_0 =	1'd0;
   assign CP2_nulls_0 =        1'd0;
   assign CP2_null_0 =		1'd0;
   assign CP2_reset =		1'd1;
   assign CP2_kills_0 =	1'd0;
   assign CP2_kill_0 [1:0] =	2'd0;
   assign CP2_tds_0 =		1'd0;
   assign CP2_tdata_0 [31:0] =	32'd0;
   assign CP2_torder_0 [2:0] =	3'd0;
   assign CP2_fordlim_0 [2:0] = 3'd0;
   
   assign cp2_coppresent =	1'd0;
   assign cp2_copidle =	1'd1;
   assign cp2_fixup_m =	1'd0;
   assign cp2_fixup_w =	1'd0;
   assign cp2_stall_e =	1'd0;
   assign cp2_bstall_e =	1'd0;
   assign cp2_btaken =		1'd0;
   assign cp2_bvalid =		1'd0;
   assign cp2_movefrom_m =	1'd0;
   assign cp2_moveto_m =	1'd0;
   assign cp2_storekill_w =	1'd0;
   assign cp2_datasel =	1'd0;
   assign cp2_storealloc_reg =	1'd0;
   assign cp2_storeissued_m =	1'd0;
   assign cp2_ldst_m =		1'd0;
   assign cp2_missexc_w =	1'd0;
   assign cp2_exc_w =		1'd0;
   assign cp2_exccode_w [4:0] =5'd0;
   assign cp2_data_w [31:0] = 32'd0;
   
//verilint 240 on  // Unused input
endmodule // cp2_stub
