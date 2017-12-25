// ###########################################################################
//
// Core-specific testbench definitions.
//
// $Id: \$
// mips_repository_id: tb_config.vh, v 3.7 
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

`include "m14k_const.vh"


`define PHASE_TIME		    	`M14K_PHASETIME
`define PHASE_DELAY		    	#(`PHASE_TIME)
`define CYCLE_TIME		    	`M14K_CYCLETIME
`define CYCLE_DELAY		    	#(`CYCLE_TIME)
`define HOLD_TIME 		    	`M14K_FDELAY
`define HOLD_DELAY 		    	#(`HOLD_TIME)
`define UNIT_TIME 		    	0.01
`define UNIT_DELAY 		    	#(`UNIT_TIME)

// Time to do sparse memory reads and writes
`define MEMORY_TIME			(`HOLD_TIME + `UNIT_TIME)
`define MEMORY_DELAY			#(`MEMORY_TIME)

`define DATABUS_WIDTH		    	32
`define ADDRBUS_WIDTH	    	    	34
`define ADDRBUS_LO		    	2
`define MEMADDR_HI  	    	    	31
`define BE_WIDTH    	    	    	4

// Connect testbench to BFM
`ifdef BFM_CONNECT
`define BFM_SOURCEFILE                  "bfm.tcl"    // Designate BFM Script File or ILS configuration file.
`define CPIF_SOURCEFILE                 "cpif.script"// Designate CPIF Script File.
`endif

`define CORE_MODULE		    	m14k_top
`define COP_MODULE	    	    	cop2_tb_for_4k
`define LV_MODULE   	    	    	m14k_lv

`define LV_PDTRACE			1

`define DEFAULT_BURST_MODE              0
`define DEFAULT_MERGE_MODE  	    	2'h0
`define DEFAULT_SIMPLE_BE   	    	2'h0
`define DEFAULT_SYSAD_PIPEWR	    	1
`define DEFAULT_SYSAD_4WBLK 	    	1
`define DEFAULT_PLL_MULTIPLIER	    	2

`ifdef LV
`define DEFAULT_RESET2_PERIOD	    	4
`define DEFAULT_COLD_RESET_PERIOD   	16
`define DEFAULT_WARM_RESET_PERIOD   	16
`else
`define DEFAULT_RESET2_PERIOD	    	5
`define DEFAULT_COLD_RESET_PERIOD   	`M14K_MIN_RESET
`define DEFAULT_WARM_RESET_PERIOD   	`M14K_MIN_RESET
`endif

// mips_eci_checker.mv
`define FatalHWString	    	    	`M14K_FATAL_HW_STR
`define FatalSWString	    	    	`M14K_FATAL_SW_STR


// Emerald specific defines

`define TOPMODULE    	    	    	toplevel


`ifdef LV
  `define M14K_PATH   	    	    	toplevel.wrapper.lv.m14k_top.cpu
  `define M14K_INST_LEVEL_PATH	    	toplevel.wrapper.lv
`else
  `ifdef BFM_CONNECT
    `define M14K_PATH   	    	    	toplevel.wrapper
  `else
    `ifdef AHB_OCP_BRIDGE
      `define M14K_PATH   	    	    	toplevel.wrapper.mips_soc.mips_css.ahb_ocp.core.cpu
    `else
      `define M14K_PATH   	    	    	toplevel.wrapper.mips_soc.mips_css.core.cpu
    `endif
  `endif
  `define M14K_INST_LEVEL_PATH	    	toplevel.wrapper
`endif

`ifdef MIPS_VMC_SYSTEM
  `define M14K_DISPLAY_TOP `M14K_PATH
  `define M14K_TRACER_TOP `M14K_PATH
`else
  `define M14K_DISPLAY_TOP `M14K_PATH.testbench.display
  `define M14K_TRACER_TOP `M14K_PATH.testbench.tracer
`endif

`define RANDOM_STALL_SEED		100
`define RANDOM_CHTRIG_SEED		150
`define RANDOM_PRTRIG_SEED		200

`define CHTRIG_INTERVAL		5000
`define PRTRIG_INTERVAL		5000

// COP Interface checker/tracer defines
`define MIPS_CPI_PIPELINE_DEPTH 6
`define MIPS_CPI1_PATH          toplevel.core_tb.cop_if_checker
`define MIPS_CPI2_PATH          toplevel.core_tb.cop_if_checker




// Cop2 testbench defines
//--------------------------------------------
// Defines for the COP2 test bench
//--------------------------------------------

// Allocate a fitting number of slots in cop2 pipeline. This value should be
// larger than CPI_PIPELINE_DEPTH. The check that used to  
// be done in the cop2 module is moved to the COP I/F checker.
`define M14K_RECORD_DEPTH		8

// Trace defines
// Secondary Itag defines
`define M14K_SidCp2   11
`define M14K_SidCp2B  12
`define M14K_SidCp2C  13
`define M14K_SidCp2D  14
`define M14K_SidCp2E  15

`define M14K_SidC2Gpr 23

`define M14K_SidC2Exc1 45
`define M14K_SidC2Exc2 46
`define M14K_SidC2Exc3 47
`define M14K_SidC2Exc4 48

// Hooks for trace information.
`ifdef BFM_CONNECT
  `define ITAG_DISPATCH_HOOK 	32'b0
  `define ITAG_IG1_DISPATCH_HOOK	32'b0
  `define M14K_IG1_DISPATCH		1'b0
  `define MACTAG_DISPATCH_HOOK 	8'b0
  `define CYCLECOUNT_HOOK		`M14K_PATH.core.cpu.BFM_Cycle[31:0]
  `define TRACEON_HOOK		8'b0
  `define TRACEFILEHANDLE_HOOK	8'b0
  `define CP2_SEPARATE_TRACEFILE
  `define CP2_TRACEFILE_NAME		"rtl.cp2trace"
`else
  `ifdef MIPS_MINI_SYSTEM
    `define ITAG_DISPATCH_HOOK 	        ` M14K_PATH_MINITB.testbench.tracer.ITag_M
    `define ITAG_IG1_DISPATCH_HOOK	`M14K_PATH_MINITB.testbench.tracer.ITag_M
    `define M14K_IG1_DISPATCH		1'b0
    `define MACTAG_DISPATCH_HOOK 	`M14K_PATH_MINITB.testbench.tracer.MacTag_M
    `define CYCLECOUNT_HOOK		`M14K_PATH_MINITB.testbench.tracer.CycleCount
    `define TRACEON_HOOK		`M14K_PATH_MINITB.testbench.tracer.existDumpTrace
    `define TRACEFILEHANDLE_HOOK	`M14K_PATH_MINITB.testbench.tracer.TraceFile
    `define CP2_SEPARATE_TRACEFILE      1
    `define CP2_TRACEFILE_NAME		"rtl.cp2trace"
  `else
    `define ITAG_DISPATCH_HOOK 	`M14K_PATH.testbench.tracer.ITag_M
    `define ITAG_IG1_DISPATCH_HOOK	`M14K_PATH.testbench.tracer.ITag_M
    `define M14K_IG1_DISPATCH		1'b0
    `define MACTAG_DISPATCH_HOOK 	`M14K_PATH.testbench.tracer.MacTag_M
    `define CYCLECOUNT_HOOK		`M14K_PATH.testbench.tracer.CycleCount
    `define TRACEON_HOOK		`M14K_PATH.testbench.tracer.existDumpTrace
    `define TRACEFILEHANDLE_HOOK	`M14K_PATH.testbench.tracer.TraceFile
    `define CP2_SEPARATE_TRACEFILE      1
    `define CP2_TRACEFILE_NAME		"rtl.cp2trace"
  `endif
`endif

`ifdef BFM_CONNECT
`define CPTRACER_CYCLECOUNT `M14K_PATH.core.cpu.BFM_Cycle[31:0]
`define CPTRACER_ITAG0      32'b0
`else
`define CPTRACER_CYCLECOUNT `M14K_PATH.testbench.tracer.CycleCount
`define CPTRACER_ITAG0      `M14K_PATH.testbench.tracer.ITag_M
`endif

`define IntDataAddr 		    (36'h1ffffff8)
`define IntCtlAddr  		    (36'h1ffffff0)
`define MBTB_INVOKE		    (32'h15)
`define MBTB_RD_RESULT		    (32'h16)


// Internal data bus width
`define M14K_DATA_WIDTH_INT	64
// Data bus width
`ifdef COP2_TB_64BIT
  `define M14K_DATA_WIDTH	64
`else
  `define M14K_DATA_WIDTH	32
`endif


// Identify the type of processor
`define TB_JADE 1

// SRAM bus bridge module options
//      ssram_dual_switch  : Simulation-only version that instantiates sram
//      bridges
//
//      m14k_sram_dual_switch_stub     : pass-through stub
//      m14k_sram_dual_switch          : bridge with internal RAMs
//      m14k_sram_dual_switch_tie_stub : tie-off stub (use AHB I/F instead
//      of sram I/F)
`define M14K_SRAM_SWITCH_MODULE ssram_dual_switch

//      ssram_ahb_switch  : Simulation-only version that instantiates ahb
//      bridges
//      m14k_sram_dual_switch_ahb          : AHB + Flash interface, with
//      internal RAMs
//      m14k_sram_dual_switch_ahb_tie_stub : tie-off stub (use sram I/F
//      instead of AHB I/F)
`define M14K_SRAM_AHB_MODULE ssram_ahb_switch

//      ssram_bridge_switch  : smodule to select which bus bridge is
//      connected to the CPU
`define M14K_SRAM_BRIDGE_SEL_MODULE ssram_bridge_switch

//	sejtag:   smodule-like file to select EJTAG probe or cJTAG probe
`define EJTAG_MODULE ejtag_s
`define ejtag_tb_module  toplevel.ejtag_tb.tb
