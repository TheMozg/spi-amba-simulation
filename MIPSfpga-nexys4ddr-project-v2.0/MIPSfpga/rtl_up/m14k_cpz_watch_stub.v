// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//      Description: m14k_cpz_watch_stub
//             Stub module to replace Watch logic

//	$Id: \$
//	mips_repository_id: m14k_cpz_watch_stub.mv, v 1.7 
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
module m14k_cpz_watch_stub(
	gscanenable,
	greset,
	gclk,
	mfcp0_m,
	mtcp0_m,
	mpc_cp0r_m,
	mpc_cp0sr_m,
	cpz,
	mmu_asid,
	mmu_dva_m,
	mpc_squash_i,
	mpc_pexc_i,
	hot_ignore_watch,
	mpc_ivaval_i,
	edp_iva_i,
	edp_alu_m,
	mpc_busty_m,
	hot_delay_watch,
	delay_watch,
	ignore_watch,
	cpz_mmutype,
	mpc_fixup_m,
	mpc_run_i,
	mpc_run_ie,
	mpc_run_m,
	mpc_exc_e,
	mpc_exc_m,
	mpc_exc_w,
	watch32,
	cpz_iwatchhit,
	cpz_dwatchhit,
	set_watch_pend_w,
	watch_present,
	cpz_watch_present__1,
	cpz_watch_present__2,
	cpz_watch_present__3,
	cpz_watch_present__4,
	cpz_watch_present__5,
	cpz_watch_present__6,
	cpz_watch_present__7,
	mpc_atomic_m,
	dcc_dvastrobe);


input			gscanenable;	// Scan enable 
input			greset;		// Power on and reset for chip
input		 gclk;		// clock
input 			mfcp0_m;	// cp0 control
input 			mtcp0_m;	// cp0 control
input [4:0]		mpc_cp0r_m;	// coprocessor zero register specifier
input [2:0]		mpc_cp0sr_m;	// coprocessor zero shadow register specifier
input [31:0]		cpz;		// cpz write data
input [`M14K_ASID] 	mmu_asid;       // Address Space Identifier
input [31:0] 		mmu_dva_m;       // Address Space Identifier
input			mpc_squash_i;
input			mpc_pexc_i;
input			hot_ignore_watch;
input			mpc_ivaval_i;
input [31:0]		edp_iva_i;
input [31:0]		edp_alu_m;
input [2:0]		mpc_busty_m;		
input			hot_delay_watch;
input			delay_watch;
input			ignore_watch;
input			cpz_mmutype;
input			mpc_fixup_m;
input   		mpc_run_i;
input   		mpc_run_ie;
input   		mpc_run_m;
input   		mpc_exc_e;
input 	        	mpc_exc_m;
input   		mpc_exc_w;

output [31:0]   	watch32;
output			cpz_iwatchhit;
output			cpz_dwatchhit;
output          	set_watch_pend_w;
output 			watch_present;
output 			cpz_watch_present__1;
output 			cpz_watch_present__2;
output 			cpz_watch_present__3;
output 			cpz_watch_present__4;
output 			cpz_watch_present__5;
output 			cpz_watch_present__6;
output 			cpz_watch_present__7;
input			mpc_atomic_m;		// Atomic instruction entered into M stage for load
input	  		dcc_dvastrobe;      	// Data Virtual Address strobe for WATCH

// BEGIN Wire declarations made by MVP
wire cpz_watch_present__1;
wire cpz_watch_present__4;
wire cpz_watch_present__7;
wire [31:0] /*[31:0]*/ watch32;
wire cpz_watch_present__3;
wire cpz_iwatchhit;
wire cpz_watch_present__6;
wire set_watch_pend_w;
wire watch_present;
wire cpz_watch_present__2;
wire cpz_watch_present__5;
wire cpz_dwatchhit;
// END Wire declarations made by MVP


	assign watch_present = 1'b0;
	
	assign cpz_watch_present__1 = 1'b0;
	assign cpz_watch_present__2 = 1'b0;
	assign cpz_watch_present__3 = 1'b0;
	assign cpz_watch_present__4 = 1'b0;
	assign cpz_watch_present__5 = 1'b0;
	assign cpz_watch_present__6 = 1'b0;
	assign cpz_watch_present__7 = 1'b0;

	assign watch32 [31:0] = 32'b0;
	assign cpz_iwatchhit = 1'b0;
	assign cpz_dwatchhit = 1'b0;
	assign set_watch_pend_w = 1'b0;
	
// Artifact code to give the testbench a cannonical reference point independent of 
// how watch is configured
//
 `ifdef MIPS_SIMULATION 
 //VCS coverage off 
//
wire 			chan_present_0 = 1'b0;
wire 			chan_present_1 = 1'b0;
wire 			chan_present_2 = 1'b0;
wire 			chan_present_3 = 1'b0;
wire 			chan_present_4 = 1'b0;
wire 			chan_present_5 = 1'b0;
wire 			chan_present_6 = 1'b0;
wire 			chan_present_7 = 1'b0;

wire [31:0] 		NextWatchHi32_0 = 32'b0;
wire [31:0] 		NextWatchHi32_1 = 32'b0;
wire [31:0] 		NextWatchHi32_2 = 32'b0;
wire [31:0] 		NextWatchHi32_3 = 32'b0;
wire [31:0] 		NextWatchHi32_4 = 32'b0;
wire [31:0] 		NextWatchHi32_5 = 32'b0;
wire [31:0] 		NextWatchHi32_6 = 32'b0;
wire [31:0] 		NextWatchHi32_7 = 32'b0;
	
wire [31:0] 		WatchHi32_0 = 32'b0;
wire [31:0] 		WatchHi32_1 = 32'b0;
wire [31:0] 		WatchHi32_2 = 32'b0;
wire [31:0] 		WatchHi32_3 = 32'b0;
wire [31:0] 		WatchHi32_4 = 32'b0;
wire [31:0] 		WatchHi32_5 = 32'b0;
wire [31:0] 		WatchHi32_6 = 32'b0;
wire [31:0] 		WatchHi32_7 = 32'b0;
	
wire [31:0] 		NextWatchLo32_0 = 32'b0;
wire [31:0] 		NextWatchLo32_1 = 32'b0;
wire [31:0] 		NextWatchLo32_2 = 32'b0;
wire [31:0] 		NextWatchLo32_3 = 32'b0;
wire [31:0] 		NextWatchLo32_4 = 32'b0;
wire [31:0] 		NextWatchLo32_5 = 32'b0;
wire [31:0] 		NextWatchLo32_6 = 32'b0;
wire [31:0] 		NextWatchLo32_7 = 32'b0;
	
wire [31:0] 		WatchLo32_0 = 32'b0;
wire [31:0] 		WatchLo32_1 = 32'b0;
wire [31:0] 		WatchLo32_2 = 32'b0;
wire [31:0] 		WatchLo32_3 = 32'b0;
wire [31:0] 		WatchLo32_4 = 32'b0;
wire [31:0] 		WatchLo32_5 = 32'b0;
wire [31:0] 		WatchLo32_6 = 32'b0;
wire [31:0] 		WatchLo32_7 = 32'b0;
	
wire [7:0] 		SetWatchTaken = 8'b0;
	
wire 			setwp_m = 1'b0;
wire 			setdwp_m = 1'b0;

wire                    watchlo_ld = 1'b0;

 //VCS coverage on  
 `endif 
//
//
	
//verilint 240 on  // Unused input
endmodule	// m14k_watch_reg
