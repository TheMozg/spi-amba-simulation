// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_ejt_pdttcb_stub
//           EJTAG PDTrace and TCB stub module
//
//      $Id: \$
//      mips_repository_id: m14k_ejt_pdttcb_stub.mv, v 1.23 
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

//verilint 240 off  // Unused input
`include "m14k_const.vh"
module m14k_ejt_pdttcb_stub(
	gclk,
	gfclk,
	gscanenable,
	gscanmode,
	greset,
	cpz_vz,
	edp_alu_m,
	mpc_cp0move_m,
	mpc_cp0r_m,
	mpc_cp0sr_m,
	mpc_dmsquash_m,
	mpc_load_m,
	mpc_fixup_m,
	mpc_irval_e,
	mpc_run_ie,
	mpc_run_m,
	mpc_run_w,
	mmu_dva_m,
	dcc_dvastrobe,
	dcc_ldst_m,
	mpc_fixupd,
	mpc_sc_m,
	dcc_sc_ack_m,
	cpz_mmutype,
	mmu_asid,
	mmu_asid_m,
	mmu_asid_valid,
	mpc_strobe_w,
	mpc_be_w,
	mpc_macro_e,
	icc_macro_e,
	icc_nobds_e,
	mpc_nobds_e,
	mpc_bds_m,
	mpc_auexc_x,
	mpc_jreg_e,
	mpc_jimm_e,
	mpc_ret_e,
	mpc_eqcond_e,
	mpc_pdstrobe_w,
	cdmm_mpuipdt_w,
	mpc_exc_w,
	mpc_wait_w,
	cpz_epc_w,
	cpz_bds_x,
	cpz_eisa_w,
	cpz_erl,
	cpz_exl,
	cpz_um,
	cpz_um_vld,
	cpz_dm_w,
	edp_ldcpdata_w,
	edp_res_w,
	cp2_data_w,
	cp2_storeissued_m,
	cp1_data_w,
	cp1_storeissued_m,
	CP1_endian_0,
	siu_tracedisable,
	pdtrace_cpzout,
	ejt_pdt_present,
	ejt_pdt_fifo_empty,
	ejt_pdt_stall_w,
	brk_ibs_bcn,
	brk_dbs_bcn,
	brk_i_trig,
	brk_d_trig,
	ej_eagaddr_15_3,
	ej_eagaddr_2_2,
	ej_eagdataout,
	ej_sbwrite,
	pdt_datain,
	EJ_TCK,
	EJ_TRST_N,
	tck_softreset,
	tck_capture,
	tck_shift,
	tck_update,
	tck_inst,
	pdt_tcbdata,
	pdt_present_tck,
	TC_CRMax,
	TC_CRMin,
	TC_ProbeWidth,
	TC_DataBits,
	TC_Stall,
	TC_PibPresent,
	TC_ClockRatio,
	TC_Valid,
	TC_Data,
	TC_TrEnable,
	TC_Calibrate,
	TC_ProbeTrigIn,
	TC_ProbeTrigOut,
	TC_ChipTrigOut,
	TC_ChipTrigIn,
	EJ_DebugM,
	EJ_TDI,
	bc_tcbbistto,
	tcb_bistfrom,
	mpc_ret_e_ndg,
	mpc_jimm_e_fc,
	mpc_jreg_e_jalr,
	pdva_load,
	dcc_ejdata,
	area_itcb_twh,
	area_itcb_tw,
	mpc_noseq_16bit_w,
	mpc_tail_chain_1st_seen,
	mpc_trace_iap_iae_e,
	cpz_iap_exce_handler_trace,
	mpc_sbstrobe_w,
	mpc_atomic_w,
	mpc_lsdc1_e,
	cpz_hotdm_i,
	mpc_sbtake_w,
	itcbtw_sel,
	itcbtwh_sel,
	itcb_tw_rd,
	cpz_guestid,
	cpz_guestid_m,
	cpz_kuc_w,
	itcb_cap_extra_code,
	mpc_jamdepc_w);


   // PDTrace I/Os

   // Signals between PDTrace and Core 
   input 		gclk;			// Clock turned off by WAIT
   input 		gfclk;			// Free running Clock
   input 		gscanenable;		// gscanenable for gated clock cregisters
   input 		gscanmode;		// gscanmode to override async resets
   input 		greset;			// Global reset
   input                cpz_vz;
   input [31:0]		edp_alu_m;		// ALU result bus -> cpz write data
   input		mpc_cp0move_m;		// MT/F C0
   input [4:0]		mpc_cp0r_m;		// coprocessor zero register specifier
   input [2:0]		mpc_cp0sr_m;		// coprocessor zero shadow register specifier
   input 		mpc_dmsquash_m;		// Exc_M without translation exceptions or interrupts
   input		mpc_load_m;		// xfer direction for load/store/cpmv - 0:=to proc; 1:=from proc
   input 		mpc_fixup_m;
   input 		mpc_irval_e; 		// Instn register is valid
   input 		mpc_run_ie; 		// E-stage Run
   input 		mpc_run_m; 		// M-stage Run
   input 		mpc_run_w; 		// W-stage Run
   input [31:0] 	mmu_dva_m; 		// Virtual addr of load/store
   input 		dcc_dvastrobe;		// Data Virtual Address strobe for EJTAG in M
   input 		dcc_ldst_m;		// Data is Load (1) or Store (0)
   input 		mpc_fixupd;
   input		mpc_sc_m;		// Store Conditional in M
   input	        dcc_sc_ack_m;		// Result of "sc" operation.
   input 		cpz_mmutype;		// mmu_type from Config register
   input [7:0] 		mmu_asid; 		// ASID value in cpz (from cpy in mmu)
   input [7:0] 		mmu_asid_m; 		// ASID value in cpz (from cpy in mmu)
   input 		mmu_asid_valid; 	// ASID value is valid
   input		mpc_strobe_w;
   input [3:0] 		mpc_be_w;		// Bytes valid for L/S in W stage
   input 		mpc_macro_e; 		// No addr increment due to macro inst in E. Not set for last macro inst.
   input 		icc_macro_e; 		// No addr increment due to macro inst in E. Not set for last macro inst.
   input 		icc_nobds_e; 		// This instruction has no delay slot
   input 		mpc_nobds_e; 		// This instruction has no delay slot
   input 		mpc_bds_m; 		// Instn in M-stage has branch delay slot
   input 		mpc_auexc_x; 		// Exception target addr in E
   input 		mpc_jreg_e; 		// Jump Registered addr in E
   input 		mpc_jimm_e; 		// Jump Immediate addr in E
   input 		mpc_ret_e; 		// Return from Exception in E
   input 		mpc_eqcond_e; 		// Branch condition met
   input 		mpc_pdstrobe_w; 	// Inst valid in W
   input 		cdmm_mpuipdt_w; 	// trace disable in W
   input 		mpc_exc_w; 		// Exception killed W-stage
   input 		mpc_wait_w; 		// Cp0 wait operation
   input [31:0] 	cpz_epc_w; 		// Address of inst in W
   input 		cpz_bds_x; 		// Current value on cpz_epc_w is from previous inst
   input 		cpz_eisa_w;		// ISA mode of inst in W (1=MIPS16, 0=MIPS32)
   input 		cpz_erl; 		// cpz_erl bit (valid in W)
   input 		cpz_exl; 		// cpz_exl bit (valid in W)
   input 		cpz_um; 		// UM bit in Status
   input 		cpz_um_vld; 		// UM bit in Status is valid
   input 		cpz_dm_w; 		// Debug mode bit W
   input [31:0] 	edp_ldcpdata_w;		// Load data for trace
   input [31:0] 	edp_res_w;		// Store data for trace
   input [31:0] 	cp2_data_w;		// Store data from cop2 for trace
   input 		cp2_storeissued_m;	// Indicate that a SWC2 is issued to CP2
   input [63:0] 	cp1_data_w;		// Store data from cop1 for trace
   input 		cp1_storeissued_m;	// Indicate that a SDC1 is issued to CP2
   input 		CP1_endian_0;		// COP1 Big Endian used in instruction/To/From

   input                siu_tracedisable;       // Disable trace hardware
   output [31:0]	pdtrace_cpzout;         // Read data for MFC0 & SC register updates
   output [1:0]		ejt_pdt_present;	// PDTrace module is implemented
   output 		ejt_pdt_fifo_empty;	// OK to gate off gclk in clock_gate
   output 		ejt_pdt_stall_w;	// Stall in W stage
   
   // Signals between PDTrace and EJTAG Area 

   // Signals between PDTrace and EJTAG Simple Break 
   
   input [3:0]		brk_ibs_bcn;		// Number of inst brk implemented
   input [3:0]		brk_dbs_bcn;		// Number of data brk implemented
   input [7:0]          brk_i_trig;             // Inst triggers
   input [3:0]          brk_d_trig;             // Data triggers

   // Signals between IPDTrace and EJTAG Area 
   input [15:3]		ej_eagaddr_15_3;	// Address of register bus
   input  		ej_eagaddr_2_2;		// Address of register bus bit[2]
   input [31:0]		ej_eagdataout;		// Indata of register bus
   input		ej_sbwrite;		// Write enable of register bus
   output [31:0]	pdt_datain;		// Outdata of register bus

   input		EJ_TCK;			// TCK
   input 		EJ_TRST_N; 		// Async. reset to TAP
   input 		tck_softreset;		// TAP Control State is Test-Logic-greset
   input 		tck_capture;		// TAP Control State is Capture-DR
   input 		tck_shift;		// TAP Control State is Shift-DR
   input 		tck_update;		// TAP Control State is Update-DR
   input [4:0] 		tck_inst;		// Current contents of TAP Instruction Register
   output 		pdt_tcbdata;		// Data from TCB shift register(s)
   output 		pdt_present_tck;	// EJ_TCK synchronous version of PDI_TCBPresent
   
   // Signals between PDTrace and Core boundary 
   // Input signals from PIB
   input [2:0]		TC_CRMax;        	// Maximum clock ratio the PIB supports
   input [2:0]		TC_CRMin;        	// Minimum clock ratio the PIB supports
   input [1:0]		TC_ProbeWidth;   	// Bit width of PIB probe interface
   input [2:0]		TC_DataBits;     	// Number of bits PIB uses from TC_Data in each cycle
   input		TC_Stall;		// PIB requests pause in transmission
   input		TC_PibPresent;		// PIB is present   

   // Output signals to PIB
   output [2:0]		TC_ClockRatio;   	// Clock ratio user has selected
   output		TC_Valid;		// TC_Data contains valid data (64-bit mode only)
   output [63:0]	TC_Data;		// Output trace data to PIB
   output		TC_TrEnable;		// Trace Enable. PIB start TR_Clk
   output		TC_Calibrate;		// Calibrate bit in ControlB set.

   input		TC_ProbeTrigIn;        // Trigger input from probe
   output		TC_ProbeTrigOut;       // Trigger output to probe

   // Cross-trigger signals to other on-chip devices
   output		TC_ChipTrigOut;        // Trigger output to on-chip device
   input		TC_ChipTrigIn;         // Trigger input from on-chip device
   input		EJ_DebugM;             // CPU is in debug mode

   // Input signals from TAP
   input		EJ_TDI;			// JTAG TDI

   // Bist-related signals
   input [`M14K_TCB_TRMEM_BIST_TO-1:0]	bc_tcbbistto;		// bist signals to tcb onchip mem
   output [`M14K_TCB_TRMEM_BIST_FROM-1:0]	tcb_bistfrom;	// bist signals from tcb onchip mem
   input          	mpc_ret_e_ndg;          // IRET and ERET only
   input           	mpc_jimm_e_fc;          // JALX, JAL
   input           	mpc_jreg_e_jalr;        // JALR
   input           	pdva_load;              // indicate valid load data is in W stage;
   input [31:0]    	dcc_ejdata;             // Muxed store+load data bus
   input   		area_itcb_twh;		// Read ITCB register ITCBTWh(0x3F84)
   input  		area_itcb_tw;		// Read ITCB register ITCBTW(0x3F80)
   input		mpc_noseq_16bit_w;  	// The instruction in W stage is 16bit size
   input		mpc_tail_chain_1st_seen; //The instruction in W stage is IRET itself only for tailchain.
   input		mpc_trace_iap_iae_e;       // iap and iae in E stage,data breakpoint could be traced out
   input		cpz_iap_exce_handler_trace;	// Instruction is under exception processing of IAP	
   input                mpc_sbstrobe_w;         // trigger point strobe signal special for trace address match aset/aclr
   input                mpc_atomic_w;		// Atomic instruction is in W stage
   input                mpc_lsdc1_e;

   input                cpz_hotdm_i;            // A debug Exception has been taken
   input		mpc_sbtake_w;		// Simple Brk taken indication (W)
   output               itcbtw_sel;		// Select ITCBTW
   output               itcbtwh_sel;		// Select ITCBTWH
   output         	itcb_tw_rd;             // ITCBTW Is valid

   input [7:0] cpz_guestid;
   input [7:0] cpz_guestid_m;
   input cpz_kuc_w;

   output 		itcb_cap_extra_code;

   input		mpc_jamdepc_w;

// BEGIN Wire declarations made by MVP
wire TC_ProbeTrigOut;
wire ejt_pdt_fifo_empty;
wire [31:0] /*[31:0]*/ pdtrace_cpzout;
wire pdt_present_tck;
wire itcb_cap_extra_code;
wire TC_Valid;
wire [63:0] /*[63:0]*/ TC_Data;
wire itcbtwh_sel;
wire itcbtw_sel;
wire TC_Calibrate;
wire TC_TrEnable;
wire [1:0] /*[1:0]*/ ejt_pdt_present;
wire ejt_pdt_stall_w;
wire itcb_tw_rd;
wire [2:0] /*[2:0]*/ TC_ClockRatio;
wire pdt_tcbdata;
wire [`M14K_TCB_TRMEM_BIST_FROM-1:0] /*[0:0]*/ tcb_bistfrom;
wire TC_ChipTrigOut;
wire [31:0] /*[31:0]*/ pdt_datain;
// END Wire declarations made by MVP

 
   assign itcbtw_sel = 1'b0;
   assign itcbtwh_sel = 1'b0;
   assign itcb_tw_rd = 1'b0;
   assign itcb_cap_extra_code = 1'b0;

   assign pdtrace_cpzout [31:0] = 32'b0;
   assign ejt_pdt_present [1:0] = 2'b0;
   assign ejt_pdt_fifo_empty = 1'b1;
   assign ejt_pdt_stall_w = 1'b0;
   assign pdt_tcbdata = 1'b0;
   assign pdt_present_tck = 1'b0;
   assign pdt_datain [31:0] = 32'b0;
   assign TC_ClockRatio [2:0] = 3'b0;
   assign TC_Valid = 1'b0;
   assign TC_Data [63:0] = 64'b0;
   assign TC_TrEnable = 1'b0;
   assign TC_Calibrate = 1'b0;
   assign TC_ProbeTrigOut = 1'b0;
   assign TC_ChipTrigOut = 1'b0;
   assign tcb_bistfrom [`M14K_TCB_TRMEM_BIST_FROM-1:0] = { `M14K_TCB_TRMEM_BIST_FROM { 1'b0}};


    
 //VCS coverage off 
  // 
  // 

  // Stub tracer hooks

  // PDTrace tracer hooks

  wire 		ctl_g = 1'b0;
  wire [7:0] 	ctl_asid = 8'b0;
  wire [7:0] 	ctl_asid_mask = 8'b0;

  wire		ctl_reset = 1'b0;
  wire		ctl_u = 1'b0;
  wire		ctl_k = 1'b0;
  wire		ctl_s = 1'b0;
  wire		ctl_exl = 1'b0;
  wire		ctl_dm = 1'b0;
  wire		ctl_trigger_on = 1'b0;
  wire		ctl_no_overflow = 1'b0;
  wire [2:0]	ctl_syncperiod = 3'b0;
  wire		ctl_offchiptb = 1'b1;

  wire		ctl_trace_on = 1'b0;
  wire		ctl_trace_en = 1'b0;
  wire		ctl_traceallbranch = 1'b0;
  wire [4:0]	ctl_tracemode = 5'b0;
  wire          fifo_overflow_pending = 1'b0;
  wire 		combo_valid = 1'b0;
  wire 		combo_valid_change = 1'b0;

  wire          ctl_cycmode = 1'b0; 
  wire          ctl_eventmode = 1'b0; 

  wire		PDI_SyncOffEn = 1'b0;
  wire		PDI_TCBPresent = 1'b0;
  wire		PDI_StallSending = 1'b0;
  wire		PDO_IamTracing = 1'b0;
  wire [2:0]	PDO_InsComp = 3'b0;
  wire		PDO_MIPS16 = 1'b0;
  wire [1:0]	PDO_MIPS16Ins = 2'b0;
  wire [15:0]	PDO_AD = 16'b0;
  wire [2:0]	PDO_TType = 3'b0;
  wire		PDO_TEnd = 1'b0;
  wire		PDO_TMode = 1'b0;
  wire [2:0]	PDO_LoadOrder = 3'b0;
  wire		PDO_Overflow = 1'b0;

   wire [31:0] 	TB_NextTRCTL = {32{1'bx}};
   wire [31:0] 	TB_NextTRCTL2 = {32{1'bx}};
   wire [31:0] 	TB_NextTRBPC = {32{1'bx}};
  // TCB tracer hooks
  wire [63:0]	fifo_out = 64'b0;
  wire		fifo_rd = 1'b0;
  wire [31:0]	tcb_controlb = 32'b0;
  wire [`MIPS_TCB_TRIGGER_BITS-1:0] tcb_trig = { `MIPS_TCB_TRIGGER_BITS { 1'b0 }};
  wire [7:0]	trtrigx = 8'b0;
  wire [15:0]	trig_type_bus = 16'b0;
  wire		trb_ton_next = 1'b0;
  wire		tcb_controlb_en_next = 1'b0;

  // Instruction PDTrace tracer hooks

  wire		itrace_valid = 1'b0;
  wire [56:0]	itrace_data = 57'b0;
  wire		starting = 1'b0;

  wire 	        jraddiusp_macro_e = 1'b0;
  wire          itcb_ctrl_est_w = 1'b0; 
  wire 		itcb_ctrl_cyc = 1'b0; 
  wire		itcb_ctrl_fcr = 1'b0;
  wire		itcb_ctrl_fdt = 1'b0;
  wire		itcb_ctrl_fdte = 1'b0;
  wire		itcb_ctrl_bm = 1'b0; 
  wire		itcb_ctrl_er = 1'b0; 
  wire    	tcb_starting = 1'b0; 
  wire		itrace_disable = 1'b0; 
  wire          itcb_trace_en = 1'b0;

wire [7:0] guestid_w = 8'b0;
wire [7:0] asid_d_w = 8'b0;
wire   exl_w = 1'b0;
wire   erl_w = 1'b0;
wire   um_w = 1'b0;

  // 
    //VCS coverage on  
  
  // 

//verilint 240 on  // Unused input
endmodule	// m14k_ejt_pdttcb_stub
