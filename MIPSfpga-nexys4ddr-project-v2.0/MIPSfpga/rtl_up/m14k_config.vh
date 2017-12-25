//
// m14k_config.vh:  `defines for core configuration
//
//	The defines in this file control the configuration of various model
//	build options.  Primarily this is to control implementation options
//	for the caches, mmu, and register file.
//
//	Typically the default values in this file represent settings that are
//	useful for simulation, not implementation.  For implementation settings
//	see the specific options below.
//
//
// $Id: \$
// mips_repository_id: template.m14k_config, v 1.27 
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

// Set the timescale for the design
//#mvp escape begin
`timescale 100ps/1ps
//#mvp escape end

// *************************************************************************
// Insertion of Scan Flops
// *************************************************************************

//  This define indicates if Scan flops for I/O signals should be inserted 
//  or not.
//
//`define M14K_SCAN_INS_ENABLE 1


// SmartMIPS
//`define M14K_SMARTMIPS 1

//`define M14K_QUARTZ 1

//
// This `define controls the flop output delay to help with
// possible hold time problems in gate simulation
//
`define M14K_FDELAY  1

//
// This define control whether pli routines for power analysis are included
//   in watcher.
//
//`define M14K_POWER 1

// *************************************************************************
// Bist configuration
// *************************************************************************
//
//  These `define statements control the width of bist-related i/o busses
//   which connect to a top-level bist control module (m14k_bistctl) instantiated
//   in m14k_top, and to the controllers located in the m14k_ic and m14k_dc modules.
//   Each of these values can be configured independently.
//

// For bist busses to/from m14k_bistctl module in m14k_top
`define M14K_TOP_BIST_IN		1
`define M14K_TOP_BIST_OUT		1
`define M14K_DC_BIST_TO			1
`define M14K_DC_BIST_FROM		1
`define M14K_IC_BIST_TO			1
`define M14K_IC_BIST_FROM		1
`define M14K_TCB_TRMEM_BIST_TO		1
`define M14K_TCB_TRMEM_BIST_FROM	1
`define M14K_RF_BIST_TO			1
`define M14K_RF_BIST_FROM		1
`define M14K_NUM_SCAN_CHAIN     	1

// For bist busses to/from m14k_dc_bistctl module in m14k_dc
`define M14K_DC_BIST_TAG_TO	1
`define M14K_DC_BIST_TAG_FROM	1
`define M14K_DC_BIST_DATA_TO	1
`define M14K_DC_BIST_DATA_FROM	1
`define M14K_DC_BIST_WS_TO	1
`define M14K_DC_BIST_WS_FROM	1

// For bist busses to/from m14k_ic_bistctl module in m14k_ic
`define M14K_IC_BIST_TAG_TO	1
`define M14K_IC_BIST_TAG_FROM	1
`define M14K_IC_BIST_DATA_TO	1
`define M14K_IC_BIST_DATA_FROM	1
`define M14K_IC_BIST_WS_TO	1
`define M14K_IC_BIST_WS_FROM	1


// *************************************************************************
// I/D$ Configuration Options
// *************************************************************************

//  This define indicates that the simulation-only wrapper module for
//   caches is not present 
//
`define M14K_STATIC_CACHE_CONFIG 1

// Cache Module Options:
//	m14k_ic, m14k_dc: normal parameterized cache block
//	m14k_ic_stub, m14k_dc_stub: dummy block for No Cache
//	scache: simulation cache - allows run-time selection of cache config

`ifdef M14K_STATIC_CACHE_CONFIG
	`define M14K_ICACHE_MODULE m14k_ic
	`define M14K_DCACHE_MODULE m14k_dc
`else
	`define M14K_ICACHE_MODULE sicache
	`define M14K_DCACHE_MODULE sdcache
`endif

// *************************************************************************
// Cache module parameters
// Not used with scache or cache stub modules
// *************************************************************************
// Cache Associativity
//	1-4 way set associative

`define M14K_ICACHE_ASSOC 2
`define M14K_DCACHE_ASSOC 2

// Cache Way Size
// 	Size/Way in KB
//	1,2,4,8,16 KB

`define M14K_ICACHE_WAYSIZE 2
`define M14K_DCACHE_WAYSIZE 2



// *************************************************************************
// Cache Controller parameters
// *************************************************************************
// ! If changing manually, remember to change WS Ram Width below to match !
// Maximum Cache Associativity
//	1-4 way set associative (including Spram)

`define M14K_MAX_IC_ASSOC 2
`define M14K_MAX_DC_ASSOC 2


// *************************************************************************
// WS Ram Width
// *************************************************************************
// This should correlate with the MAX ASSOC above:
// M14K_MAX_IC_WS = (MAX_IC_ASSOC == 4) ? 6 :
//                  (MAX_IC_ASSOC == 3) ? 3 : 1
// M14K_MAX_DC_WS = (MAX_DC_ASSOC == 4) ? 10 :
//                  (MAX_DC_ASSOC == 3) ? 6 :
//                  (MAX_DC_ASSOC == 2) ? 3 : 1

//M14K_MAX_DC_WS_NOPAR = (`M14K_MAX_DC_ASSOC == 4) ? 10 :
//                       (`M14K_MAX_DC_ASSOC == 3) ? 6 :
//                       (`M14K_MAX_DC_ASSOC == 2) ? 3 : 1
//M14K_MAX_DC_WS_PAR = (`M14K_MAX_DC_ASSOC == 4) ? 14 :
//                     (`M14K_MAX_DC_ASSOC == 3) ? 9 :
//                     (`M14K_MAX_DC_ASSOC == 2) ? 5 : 2

`define M14K_MAX_IC_WS 1
//`define M14K_PARITY 	1


// Integrated Memory BIST Module selections
// Legal selections are:
// 	m14k_icc_mb:	 Implement memory bist for I-Cache rams
// 	m14k_icc_mb_stub: Stub off I-Cache memory bist.
`define M14K_ICCMB_MODULE m14k_icc_mb_stub

// Legal selections are:
// 	m14k_dcc_mb:	 Implement memory bist for D-Cache rams
// 	m14k_dcc_mb_stub: Stub off D-Cache memory bist.
`define M14K_DCCMB_MODULE m14k_dcc_mb_stub

// Integrated SPRAM BIST Module selections
// Legal selections are:
// 	m14k_icc_spmb:	 Implement memory bist for ISPRAM rams
// 	m14k_icc_spmb_stub: Stub off ISPRAM memory bist.
`define M14K_ISPMB_MODULE m14k_icc_spmb_stub

// Legal selections are:
// 	m14k_dcc_spmb:	 Implement memory bist for DSPRAM rams
// 	m14k_dcc_spmb_stub: Stub off DSPRAM memory bist.
`define M14K_DSPMB_MODULE m14k_dcc_spmb_stub

// Integrated Memory BIST parameters
// Legal values for bist algorithm is:
//	3'b000:		No algorithm (select stub modules instead)
// 	3'b001:		Implement the March C+ algorithm
//	3'b010:		Implement the IFA-13 algorithm (March C+ & Retention)
//	others:		Reserved
//`define M14K_MBIST_ALGORITHM             3'b000

// Legal values for retention delay counter is:
// 	1-32:		Delay counter bits.
//	The value is the number of bits in the delay counter
//	The delay is always a full count from 0 to all bits set.
//	Delay cycles = 2^<delay_bits>
//`define M4K_MBIST_RETENTION_DELAY 	1

// Define Scan support in Cache controller (only active when gscanmode is high)
// Make the following defines active to enable the scan support they control

// Enable read/write strobe control in D-Cache on gscanramwr
//`define M14K_DCC_SCAN_RAM_RWCTL 1

// Enable read/write strobe control in I-Cache on gscanramwr
//`define M14K_ICC_SCAN_RAM_RWCTL 1

// Enable address force to 0 in D-Cache
//`define M14K_DCC_SCAN_RAM_ADDRCTL 1
// Add observe flops on internal address logic in D-Cache
// (Only used if Address force is on)
//`define M14K_DCC_SCAN_OBSERVE_FLOPS 1

// Enable address force to 0 in I-Cache
//`define M14K_ICC_SCAN_RAM_ADDRCTL 1
// Add observe flops on internal address logic in I-Cache
// (Only used if Address force is on)
//`define M14K_ICC_SCAN_OBSERVE_FLOPS 1

// Define the cells to be used for the tag/data rams for each array I/D*Tag/Data

// This define indicates that the users self-defined ram instantiations are used
//  instead of the simulation only cache memories.
//  Make this define active to use self-defined ram instantiations.
`define M14K_STATIC_CACHE_RAMS 1

`ifdef M14K_STATIC_CACHE_RAMS
	// These rams has been created by the user, to instatiate his/her
	//  paticular physical ram models.
	`define M14K_IC_TAGRAM	tagram_2k2way_xilinx
	`define M14K_DC_TAGRAM	tagram_2k2way_xilinx
	`define M14K_IC_WSRAM   i_wsram_2k2way_xilinx
	`define M14K_DC_WSRAM   d_wsram_2k2way_xilinx
	`define M14K_IC_DATARAM	dataram_2k2way_xilinx
	`define M14K_DC_DATARAM	dataram_2k2way_xilinx
`else
	// These simulation rams use parameters in the m14k_{i,d}c.mv modules
	`define M14K_IC_TAGRAM	m14k_generic_tagram #(ASSOC, WAYSIZE, BITS_PER_BYTE_TAG,`M14K_IC_BIST_TAG_TO, `M14K_IC_BIST_TAG_FROM)
	`define M14K_DC_TAGRAM	m14k_generic_tagram #(ASSOC, WAYSIZE, BITS_PER_BYTE_TAG,`M14K_DC_BIST_TAG_TO, `M14K_DC_BIST_TAG_FROM)
	`define M14K_IC_WSRAM	m14k_generic_wsram #(WS_WIDTH, WAYSIZE, `M14K_IC_BIST_WS_TO, `M14K_IC_BIST_WS_FROM)
	`define M14K_DC_WSRAM	m14k_generic_wsram #(WS_WIDTH, WAYSIZE, `M14K_DC_BIST_WS_TO, `M14K_DC_BIST_WS_FROM)

	`define M14K_IC_DATARAM	m14k_generic_dataram #(ASSOC, WAYSIZE,BITS_PER_BYTE_DATA, `M14K_IC_BIST_DATA_TO, `M14K_IC_BIST_DATA_FROM)
	`define M14K_DC_DATARAM	m14k_generic_dataram #(ASSOC, WAYSIZE, BITS_PER_BYTE_DATA,`M14K_DC_BIST_DATA_TO, `M14K_DC_BIST_DATA_FROM)
`endif

// *************************************************************************
// Hardware Cache Init Module
// *************************************************************************
// m14k_cache_hci   - Hardware Cache Init
// m14k_cache_nohci - No Hardware Cache Init 
`define M14K_CACHE_INIT_MODULE m14k_cache_nohci

// *************************************************************************
// SPRAM (ScratchPad Ram) Configuration
// *************************************************************************

// SPRAM arrays toplevel moduleb

// m14k_spram_top       - module to instantiate I & D modules
// m14k_unispram_custom - custom module for a unified SPRAM
`define M14K_SPRAMTOP_EXT_MODULE m14k_spram_top
 
// I-side SPRAM array module
// m14k_ispram_tb - testbench
// m14k_ispram_multi  
// m14k_ispram_custom - customer module
// m14k_ispram_ext_stub - NO ISPRAM external module
// s_ispram_enable - simulation module for ISPRAM
`define M14K_ISPRAM_EXT_MODULE m14k_ispram_ext_stub

// D-side SPRAM array module
// m14k_dspram_tb - testbench
// m14k_dspram_multi  
// m14k_dspram_custom - customer module
// m14k_dspram_ext_stub - NO ISPRAM external module
// s_dspram_enable - simulation module for DSPRAM
`define M14K_DSPRAM_EXT_MODULE m14k_dspram_ext_stub


// I-side SPRAM control module
// s_icc_spram    - simulation module
// m14k_icc_spram  - support for SPRAM
// m14k_icc_spstub - no SPRAM
`define M14K_ISPRAM_MODULE m14k_icc_spstub

// *************************************************************************
// external ISPRAM input signal port width
// *************************************************************************
`define M14K_ISP_EXT_TOISP_WIDTH 1

// *************************************************************************
// external ISPRAM output signal port width
// *************************************************************************
`define M14K_ISP_EXT_FROMISP_WIDTH 1

// *************************************************************************
// external DSPRAM input signal port width
// *************************************************************************
`define M14K_DSP_EXT_TODSP_WIDTH 1

// *************************************************************************
// external DSPRAM output signal port width
// *************************************************************************
`define M14K_DSP_EXT_FROMDSP_WIDTH 1

// D-side SPRAM control module
// s_dcc_spram    - simulation module
// m14k_dcc_spram  - support for SPRAM
// m14k_dcc_spstub - no SPRAM
`define M14K_DSPRAM_MODULE m14k_dcc_spstub
// *************************************************************************
// VZ 
// *************************************************************************
`define vz 0

// *************************************************************************
// MMU 
// *************************************************************************

// MMU module instantiation options:
//	m14k_tlb: tlb - flop based with or without gated clocks
`define GTLB 1
`define RTLB 1
`ifdef M14K_SMARTMIPS
`define M14K_MMU_MODULE m14k_tlb
`else 
// m14kec Guest MMU 
// 	m14k_fix: Fixed Mapping MMU (no TLB) with no VZ
// 	m14k_tlb: TLB Base MMU with no VZ
// 	m14k_tlb_vz: TLB Base Guest with VZ
// 	m14k_fix_vz: Fixed Mapping Guest with VZ
// 	smmu:    simulation-only module which instantiates both jtlba and bat
`define M14K_MMU_MODULE m14k_tlb

// TLB Small page support
//	ssps:			simulation-only module which instantiates both m14k_sps_yes and m14k_sps_no
//	m14k_cpz_sps:		Smallpage Support
//	m14k_cpz_sps_stub:	No Smallpage Support
`define M14K_MMU_SMALLPAGE_SUPPORT m14k_cpz_sps_stub

`endif

// m14ke Guest Fix + Root RPU
// 	m14k_fix_vz: lite MMU for MUC with VZ
// 	m14k_fix_vz_stub: stub module with no VZ
// 	SLITEmmu:    simulation-only module which instantiates both vz_lite and stub
`define M14K_LITEMMU_MODULE m14k_fix_vz_stub 

// 	m14k_mpc_mmu: Fixed Mapping MMU for MUC (no VZ)
// 	m14k_mpc_mmu_stub: stub module with VZ
// 	s_mpc_mmu:    simulation-only module which instantiates both m14k_mpc_mmu and stub
`define M14K_MPCMMU_MODULE m14k_mpc_mmu 

// m14ke /m14kec
// 	m14k_mpc_exc: mpc exc module with no VZ
// 	m14k_mpc_exc_vz: mpc exc module with VZ
// 	s_mpc_exc:    
`define M14K_MPCEXC_MODULE m14k_mpc_exc 

// m14ke /m14kec
// 	m14k_cpz_root_stub: cpz root module with no VZ
// 	m14k_cpz_root: cpz root module with VZ
// 	scpz_root:    
`define M14K_CPZ_ROOT_MODULE m14k_cpz_root_stub 

// m14ke /m14kec
// 	m14k_cpz_guest_stub: cpz guest module with no VZ
// 	m14k_cpz_guest: cpz guest module with VZ
// 	scpz_guest:    
`define M14K_CPZ_GUEST_MODULE m14k_cpz_guest_stub 

// m14ke /m14kec
// 	m14k_tlb_utlbentry: utlb entry module with no VZ, or select RTLB with VZ
// 	m14k_tlb_ubatentry: ubat entry module when select RPU with VZ and Guest fix mode 
// 	sutlbentry:    
`define M14K_UTLBENTRY_MODULE m14k_tlb_utlbentry 

// m14ke /m14kec 
// 	m14k_tlb_jtlb1entry: jtlb entry module with no VZ, or select RTLB with VZ
// 	m14k_tlb_rpu1entry: rpu entry module when select RPU with VZ
// 	sjtlbentry:    
`define M14K_JTLBENTRY_MODULE m14k_tlb_jtlb1entry 

// Guest TLB size
//	sjtlb:			simulation-only module which instantiates both 16 and 32 entry JTLB
//	m14k_tlb_jtlb16:		16 entry JTLB
//	m14k_tlb_jtlb32:		32 entry JTLB
`define M14K_TLB_ARRAY m14k_tlb_jtlb16

// Root TLB or RPU size
//	srjtlb:			simulation-only module which instantiates both 16 and 32 entry JTLB
//	m14k_rtlb_jtlb8:		8 entry RTLB/RPU
//	m14k_rtlb_jtlb16:		16 entry RTLB/RPU
//	m14k_rtlb_jtlb32:		32 entry RTLB/RPU
`define M14K_RTLB_ARRAY m14k_rtlb_jtlb32 


// TLB module instantiation options: 
//	screg:			simulation-only version that instantiates all versions
//	mvp_cregister_gc:	register-based JTLB with gated clocks
//	mvp_cregister_ngc:	register-based JTLB without gated clocks
`define M14K_CREGW_TLB_MODULE mvp_cregister_ngc

// UTLB module instantiation options:  (selects both itlb and dtlb)
//	screg:			simulation-only version that instantiates all versions
//	mvp_cregister_gc:	register-based UTLB with gated clocks
//	mvp_cregister_ngc:	register-based UTLB without gated clocks
`define M14K_CREGW_UTLB_MODULE mvp_cregister_ngc

// *************************************************************************
// Interrupt synchronization
// *************************************************************************
// m14k_siu_int_sync:		Include double flop synchronizers on interrupt pins
// m14k_siu_int_nosync:          Single input flop for syncrhonous interrupts
`define M14K_SIU_INTSYNC m14k_siu_int_sync


// *************************************************************************
// Watch Register Options
// *************************************************************************

// Watch Module:
`ifdef M14K_QUARTZ
`define M14K_CPZ_WATCH_MODULE m14k_cpz_watch_stub

`else
// m14k_cpz_watch_top	// Watch registers 
// m14k_cpz_watch_stub	// No Watch registers

`define M14K_CPZ_WATCH_MODULE  m14k_cpz_watch_stub
`endif

// Per Channel watch definitions
// m14k_cpz_watch_chan		// Watch Channel 
// m14k_cpz_watch_cstub	        // No Watch Channel

`define M14K_WATCH_MODULE0 m14k_cpz_watch_cstub
`define M14K_WATCH_MODULE1 m14k_cpz_watch_cstub
`define M14K_WATCH_MODULE2 m14k_cpz_watch_cstub
`define M14K_WATCH_MODULE3 m14k_cpz_watch_cstub
`define M14K_WATCH_MODULE4 m14k_cpz_watch_cstub
`define M14K_WATCH_MODULE5 m14k_cpz_watch_cstub
`define M14K_WATCH_MODULE6 m14k_cpz_watch_cstub
`define M14K_WATCH_MODULE7 m14k_cpz_watch_cstub

// *************************************************************************
// RF options
// *************************************************************************

// RF module instantiation options:
//	srf:	simulation-only version that generator and flop based
//	m14k_rf_reg:   register-based model
//      m14k_rf_gen:        1 register set generator based model
//      m14k_rf_srs2_gen:   2 register set generator based model
//      m14k_rf_srs4_gen:   4 register set generator based model
//      m14k_rf_srs8_gen:   8 register set generator based model
//      m14k_rf_srs16_gen: 16 register set generator based model

`define M14K_RF_MODULE m14k_rf_reg

// RFR Module:
// For each possible register set, select version
//     m14k_rf_rgc:    gated clock
//     m14k_rf_rngc:   no gated clocks
//     m14k_rf_stub:   register set not present
`define M14K_RF_REG_MODULE0  m14k_rf_rngc
`define M14K_RF_REG_MODULE1  m14k_rf_stub
`define M14K_RF_REG_MODULE2  m14k_rf_stub
`define M14K_RF_REG_MODULE3  m14k_rf_stub
`define M14K_RF_REG_MODULE4  m14k_rf_stub
`define M14K_RF_REG_MODULE5  m14k_rf_stub
`define M14K_RF_REG_MODULE6  m14k_rf_stub
`define M14K_RF_REG_MODULE7  m14k_rf_stub
`define M14K_RF_REG_MODULE8  m14k_rf_stub
`define M14K_RF_REG_MODULE9  m14k_rf_stub
`define M14K_RF_REG_MODULE10 m14k_rf_stub
`define M14K_RF_REG_MODULE11 m14k_rf_stub
`define M14K_RF_REG_MODULE12 m14k_rf_stub
`define M14K_RF_REG_MODULE13 m14k_rf_stub
`define M14K_RF_REG_MODULE14 m14k_rf_stub
`define M14K_RF_REG_MODULE15 m14k_rf_stub

// Mask based on number of register sets
//     4'h0: 1 register set
//     4'h1: 2 register sets
//     4'h3: 4 register sets
//     4'h7: 8 register sets
`define M14K_RF_MASK 4'b0000


// Uncomment this line if not using srf module
`define M14K_STATIC_RF_CONFIG 1
//
// RFInstPath must be set to match RFModule setting, this is
//	to make watcher.v happy.  Only important for simulation.
//
`ifdef M14K_STATIC_RF_CONFIG
// Should be used if RFModule!=srf
	`define M14K_RF_INST_PATH rf          
`else
// Should be used if RFModule==srf
	`define M14K_RF_INST_PATH rf.rf_rngc  
`endif

// SRS module instatiation options
//	s_cpz_srs:	simulation-only version that instantiates all
//	m14k_cpz_srs1:	support of 1 register files
//	m14k_cpz_srs2:	support of 2 register files
//	m14k_cpz_srs4:	support of 4 register files
//	m14k_cpz_srs8:	support of 8 register files
//	m14k_cpz_srs16:	support of 16 register files
`define M14K_CPZ_SRS_MODULE m14k_cpz_srs1

// SRS module instatiation options
//	s_cpz_guest_srs:	simulation-only version that instantiates all
//	m14k_cpz_guest_srs1:	support of 1 register files
//	m14k_cpz_guest_srs2:	support of 2 register files
//	m14k_cpz_guest_srs4:	support of 4 register files
//	m14k_cpz_guest_srs8:	support of 8 register files
//	m14k_cpz_guest_srs16:	support of 16 register files
`define M14K_CPZ_GUEST_SRS_MODULE m14k_cpz_guest_srs1

// PRID submodule
//     sprid:          simulation model
//     m14k_cpz_prid    Actual RTL model
`define M14K_PRID_MODULE m14k_cpz_prid

//*************************************************************************
// EJTAG options
//*************************************************************************
// EJTAG features in the EJTAG toplevel module is configured by setting 
// a number of defines describing what modules to use.
// Only the following configurations indicated by columns makes sense in 
// the implementation: (.: *_stub Dummy module   X: *_top Real module)
// EJTAGArea..: XXXXXX
// TAP........: .X.XXX
// SimpleBreak: ..XX.X
// PDTrace....: ....XX

// EJTAG Area Handler options:
// With DCR and EJTAG Area
`define M14K_AREA_MODULE m14k_ejt_area  

// TAP Module options:
// sejt                 // Simulation module
// m14k_ejt_tap         // With TAP Module
// m14k_ejt_tapstub     // No TAP Module
`define M14K_TAP_MODULE m14k_ejt_tap

// Simple Break options:
// sejs                   // Simulation Simple Break Module
// m14k_ejt_brk62         // With 6 I and 2 D breaks
// m14k_ejt_brk42         // With 4 I and 2 D breaks
// m14k_ejt_brk21         // With 2 I and 1 D breaks
// m14k_ejt_brkstub       // No Simple Break
`define M14K_BREAK_MODULE m14k_ejt_brk21

// Complex Break options:
// m14k_ejt_cbrk62         // With 6 I and 2 D breaks
`define M14K_CBRK_MODULE m14k_ejt_cbrkstub

`define M14K_CBRK_PP 1
`define M14K_CBRK_FSM 1

// HardWare Address range trigger BreakPoint
`define M14K_EJT_IBRK7	m14k_ejt_ibrk
`define M14K_EJT_IBRK6	m14k_ejt_ibrk
`define M14K_EJT_IBRK5	m14k_ejt_ibrk
`define M14K_EJT_IBRK4	m14k_ejt_ibrk
`define M14K_EJT_IBRK3	m14k_ejt_ibrk
`define M14K_EJT_IBRK2	m14k_ejt_ibrk
`define M14K_EJT_IBRK1	m14k_ejt_ibrk
`define M14K_EJT_IBRK0	m14k_ejt_ibrk

`define M14K_EJT_DBRK3	m14k_ejt_dbrk
`define M14K_EJT_DBRK2	m14k_ejt_dbrk
`define M14K_EJT_DBRK1	m14k_ejt_dbrk
`define M14K_EJT_DBRK0	m14k_ejt_dbrk

// *************************************************************************
// TRACE OPTIONS
// *************************************************************************
`define M14K_TRACER_NO_PDTRACE 1

// TRACE Module options:
// spdttcb			// Simulation module
// m14k_ejt_pdttcb_stub		// No PDtrace/TCB Module
// m14k_ejt_pdttcb_wrapper	// With PDtrace/TCB Module
// m14k_ejt_ipdttcb_wrapper	// With Instruction PDtrace/TCB Module
`define M14K_TRACE_TCB_MODULE m14k_ejt_pdttcb_stub


// *************************************************************************
// TCB OPTIONS
// *************************************************************************
// TCB Module options:
// mips_tcb_im				// Internal memory control
// mips_tcb_im_stub			// No Internal memory control
// mips_generic_tcbram			// Internal simulation memory
// mips_tcb_trmem_tcbram_2kmax_xilinx	// Internal memory (for Xilinx FPGA) 2KB max
// mips_tcb_tc				// Offchip memory controller
// mips_tcb_tc_stub			// No Offchip memory controller
// mips_tcb_trb				// Trigger Module
// mips_tcb_trb_stub			// No Trigger Module
// mips_tcb_trb_trig			// Trigger Trig Module
// mips_tcb_trb_trig_stub		// No Trigger Trig Module
// mips_pib				// With PIB Module
// mips_pib_stub			// No PIB Module
// *************************************************************************

// mips_tcb_im		// Internal memory control
// mips_tcb_im_stub	// No Internal memory control
`define M14K_TCB_ONCHIPMEM_MODULE mips_tcb_im_stub

// mips_generic_tcbram	// Internal simulation memory
// mips_tcb_trmem_tcbram_2kmax_xilinx	// Internal memory (for Xilinx FPGA) 2KB max
`define M14K_TCB_DATARAM mips_generic_tcbram

// ITCB TRACE fifo options:
// sitcb_onoff_fifo		// Simulation module
// mips_itcb_fifo_offchip      	// Offchip memory control
// mips_itcb_fifo_onchip	// Onchip memory control 
// mips_itcb_fifo		// Both onchip and offchip memory control
`define  M14K_ITCB_FIFO_MODULE mips_itcb_fifo_offchip

// On-chip trace memory depth in 64-bit words (2^5 to 2^20)
// off-chip trace fifo depth default to 2^4
`define MIPS_ITCB_ONCHIP_SIZE      5'd4     

// Valid for offchip trace. Replace 16 entry FIFO with SRAM
//`define M14K_FIFO_CONFIG 1

// mips_generic_itcbram	         // Internal simulation memory
// mips_itcb_fifo_16_reg         // Flop-based FIFO, used for offchip trace
`define M14K_ITCB_DATARAM mips_generic_itcbram

// mips_tcb_tc		// Offchip memory controller
// mips_tcb_tc_stub	// No Offchip memory controller
`define M14K_TCB_OFFCHIPMEM_MODULE mips_tcb_tc_stub

// mips_tcb_trb		// Trigger Module
// mips_tcb_trb_stub	// No Trigger Module
`define M14K_TCB_TRIGGER_MODULE mips_tcb_trb_stub

// mips_tcb_trb_trig		// Trigger Trig Module
// mips_tcb_trb_trig_stub	// No Trigger Trig Module
`define M14K_TCB_TRIGGER_TRIG_MODULE0 mips_tcb_trb_trig_stub

`define M14K_TCB_TRIGGER_TRIG_MODULE1 mips_tcb_trb_trig_stub
`define M14K_TCB_TRIGGER_TRIG_MODULE2 mips_tcb_trb_trig_stub
`define M14K_TCB_TRIGGER_TRIG_MODULE3 mips_tcb_trb_trig_stub
`define M14K_TCB_TRIGGER_TRIG_MODULE4 mips_tcb_trb_trig_stub
`define M14K_TCB_TRIGGER_TRIG_MODULE5 mips_tcb_trb_trig_stub
`define M14K_TCB_TRIGGER_TRIG_MODULE6 mips_tcb_trb_trig_stub
`define M14K_TCB_TRIGGER_TRIG_MODULE7 mips_tcb_trb_trig_stub

// mips_pib		// With PIB Module
// mips_pib_stub	// No PIB Module
`define M14K_PIB_MODULE mips_pib_stub

// Number of Triggers
//   0:    Do not define
//   1-8:  Define
`define MIPS_TCB_TRIGGERS 0

// On-chip trace memory depth in 64-bit words (2^5 to 2^20)
`define MIPS_TCB_ONCHIP_SIZE      5'd4     

// 4, 8, 16
`define MIPS_PIB_TRDATAWIDTH	  5'd4	


// *************************************************************************
// MICROMIPS Modules:  MicroMIPS recoding can occur in two different locations
// Refer to the implementor's guide for details
//
// Before the cache way select muxes:  The recoder is replicated N+1 time
// (N=MAX_IC_ASSOC).  This costs area, but has less of a frequency impact
// `define M14K_UMIPS_PREWS_MODULE m14k_icc_umips_top
// `define M14K_UMIPS_POSTWS_MODULE m14k_icc_umips_stub
//
// After the way select muxes:  This is slower, but also smaller
// `define M14K_UMIPS_PREWS_MODULE m14k_icc_umips_stub
// `define M14K_UMIPS_POSTWS_MODULE m14k_icc_umips_top
//
`ifdef M14K_SMARTMIPS
`else
// No UMIPS support: fastest and smallest
// `define M14K_UMIPS_PREWS_MODULE m14k_icc_umips_stub
// `define M14K_UMIPS_POSTWS_MODULE m14k_icc_umips_stub
`endif
//
// *************************************************************************
`define M14K_UMIPS_PREWS_MODULE m14k_icc_umips_stub
`define M14K_UMIPS_POSTWS_MODULE m14k_icc_umips_stub
//`define M14K_UMIPSPreModule 1
//`define M14K_UMIPSPostModule 1

`define M14K_ICC_NATIVEUMIPS_PREMODULE  m14k_icc_umips_predec_stub
`define M14K_ICC_NATIVEUMIPS_POSTMODULE  m14k_icc_umips_predec_stub

// *************************************************************************
// User Defined Instructions (UDI) Options
// m14k_udi_stub // No UDIs implemented
// m14k_udi_custom // custom udi module
// m14k_udi_2cycle/lmac/multicycle/pipe // example modules
// m14k_umips_udi  			// example modules for native umips (id=6)
// m14k_umipsudi_2cycle 		// example modules for native umips (id=7)
// m14k_umipsudi_multicycle 		// example modules for native umips (id=8)
// m14k_umipsudi_pipe  			// example modules for native umips (id=9)
// sudi_pro  				// simulation module for internal use
// *************************************************************************
`define M14K_UDI_MODULE m14k_udi_stub


// *************************************************************************
// m14k_edp_buf_misc Options
// m14k_edp_buf_misc - Non-pro core
// m14k_edp_buf_misc_pro - Pro Core
// sedp_buf_misc.mv - smodule to choose between both the above at run time
// *************************************************************************
`define M14K_EDP_BUF_MODULE m14k_edp_buf_misc

// *************************************************************************
// external UDI input signal port width
// *************************************************************************
`define M14K_UDI_EXT_TOUDI_WIDTH 1

// *************************************************************************
// external UDI output signal port width
// *************************************************************************
`define M14K_UDI_EXT_FROMUDI_WIDTH 1

// *************************************************************************
// COP2 IF (CP2) Options
// scp2 // Simulation COP2 IF
// m14k_cp2_stub // No COP2 IF implemented
// m14k_cp2 // COP2 IF implemented
// *************************************************************************
`define M14K_CP2_MODULE m14k_cp2_stub

// *************************************************************************
// COP2 EXTERNALMODULE(COP2) Options
// scop2_enable // Simulation COP2 module for internal testing only
// m14k_cop2_tb   // COP2 behavioral test bench
// m14k_cop2_stub // COP2 stub module
// m14k_cop2_custom // COP2 custom module which customers can replace
// m14k_cop2_umipstb   // COP2 behavioral test bench for native micromips (id=4)
// m14k_cop2_umipssyn  // COP2 synthesizeable RTL for native micromips (id=5)
// *************************************************************************
`define M14K_COP2_MODULE m14k_cop2_stub

// *************************************************************************
// external COP2 input signal port width
// *************************************************************************
`define M14K_CP2_EXT_TOCP2_WIDTH 1

// *************************************************************************
// external CP2 output signal port width
// *************************************************************************
`define M14K_CP2_EXT_FROMCP2_WIDTH 1



// *************************************************************************
// COP1 IF (CP1) Options
// scp1 // Simulation COP1 IF
// m14k_cp1_stub // No COP1 IF implemented
// m14k_cp1 // COP1 IF implemented
// *************************************************************************
`define M14K_CP1_MODULE m14k_cp1_stub

//`define M14K_ENABLE_FPU 1

// *************************************************************************
// COP1 EXTERNALMODULE(COP1) Options
// m14k_cop1_stub // COP1 stub module
// m14k_fpu_wrapper// COP1 synthesizeable RTL for native micromips (id=5)
// *************************************************************************
`define M14K_COP1_MODULE m14k_cop1_stub

// *************************************************************************
// external COP1 input signal port width
// *************************************************************************
`define M14K_CP1_EXT_TOCP1_WIDTH 1 

// *************************************************************************
// external CP1 output signal port width
// *************************************************************************
`define M14K_CP1_EXT_FROMCP1_WIDTH 1 

// FPU Clock gating options
// sm14k_fpuclk          // simulation model
// m14k_fpuclk1_gate     // ratio 1:1, clk gating enabled
// m14k_fpuclk1_nogate   // ratio 1:1, no clk gating
`define M14K_FPUCLK_MODULE    m14k_fpuclk1_nogate 

// FPU decoder logic otions
// s_mips_fc_dec         // simulation model
// mips_fc_umips_dec     // native umips mode
// mips_fc_dec           // non-native umips mode 
//`define MIPS_FCDEC_MODULE   mips_fc_dec 

// s_mips_fc_busy       // simulation model
// mips_fc_umips_busy	// native umips mode
// mips_fc_busy		// non-native umips mode 

//`define MIPS_FCBUSY_MODULE mips_fc_busy 



`ifdef M14K_SMARTMIPS
// *************************************************************************
// Cache/SPRAM scramble module
// m14k_cscramble_stub 	// No scrambling
// m14k_cscramble 	// Sample module
// *************************************************************************
`define M14K_CSCRAMBLE_MODULE dummy
`ifdef M14K_SCAN_INS_ENABLE
`define M14K_CSCRAMBLE_SCANIO_MODULE m14k_cscramble_scanio_flops
`else   
`define M14K_CSCRAMBLE_SCANIO_MODULE m14k_cscramble_scanio_stub
`endif
`endif

// *************************************************************************
// Conditional Register Implementation Option
//      Wide conditional registers can be implemented with gated clocks for 
//      power savings.
// Gated clocks  
// `define M14K_UCREGW_MODULE mvp_cregister_gc
// `define M14K_CREGW_MODULE  mvp_cregister_gc
// no gated clocks  
// `define M14K_UCREGW_MODULE mvp_register_ngc
// `define M14K_CREGW_MODULE  mvp_cregister_ngc
// *************************************************************************
`define M14K_UCREGW_MODULE mvp_register_ngc
`define M14K_CREGW_MODULE mvp_cregister_ngc

// *************************************************************************
// Clock definition margin
// Used in ejtag_tb to prevent posedge EJ_TCK near posedge SI_ClkIn
// See Implementor's Guide for description of when changing 
// this might be needed and what value to use
// *************************************************************************
`define MIPS_TB_TCK_SETUP_SYSCLK 1.1
`define MIPS_TB_TCK_HOLD_SYSCLK 1.1

// *************************************************************************
// Clock buffering options
// *************************************************************************
`define M14K_CLK_BUF_BIU		m14k_clock_buf
`define M14K_CLK_BUF_SIU		m14k_clock_buf2
`define M14K_CLK_BUF_CLOCK_GATE		m14k_clock_buf
`define M14K_CLK_BUF_CPZ		m14k_clock_buf2
`define M14K_CLK_BUF_CPY		m14k_clock_buf
`define M14K_CLK_BUF_DC_CTL		m14k_clock_buf
`define M14K_CLK_BUF_DCACHE		m14k_clock_buf
`define M14K_CLK_BUF_EDP		m14k_clock_buf
`define M14K_CLK_BUF_EJT_AREA		m14k_clock_buf2
`define M14K_CLK_BUF_EJT_TAP		m14k_clock_buf2
`define M14K_CLK_BUF_EJT_PDT		m14k_clock_buf2
`define M14K_CLK_BUF_EJT_TCK            m14k_clock_buf
`define M14K_CLK_BUF_IC_CTL		m14k_clock_buf
`define M14K_CLK_BUF_ICACHE		m14k_clock_buf
`define M14K_CLK_BUF_UTLB_MAIN		m14k_clock_buf
`define M14K_CLK_BUF_UTLB_LOCAL		m14k_clock_buf
`define M14K_CLK_BUF_UTLBENTRY		m14k_clock_buf
`define M14K_CLK_BUF_JTLBA_MAIN		m14k_clock_buf
`define M14K_CLK_BUF_JTLBA_LOCAL	m14k_clock_buf
`define M14K_CLK_BUF_TLBENTRY_TAG	m14k_clock_buf
`define M14K_CLK_BUF_TLBENTRY_DATA0	m14k_clock_buf
`define M14K_CLK_BUF_TLBENTRY_DATA1	m14k_clock_buf
`define M14K_CLK_BUF_MDC		m14k_clock_buf
`define M14K_CLK_BUF_MDP		m14k_clock_buf
`define M14K_CLK_BUF_MPC		m14k_clock_buf
`define M14K_CLK_BUF_RF_IN		m14k_clock_buf
`define M14K_CLK_BUF_RF_MAIN		m14k_clock_buf
`define M14K_CLK_BUF_RF_GATED		m14k_clock_buf32
`define M14K_CLK_BUF_TLBC		m14k_clock_buf
`define M14K_CLK_BUF_UDI		m14k_clock_buf
`define M14K_CLK_BUF_CP2DISP		m14k_clock_buf
`define M14K_CLK_BUF_CP2CTL		m14k_clock_buf
`ifdef M14K_QUARTZ
`define M14K_CLK_BUF_SRAM		m14k_clock_buf
`endif

// *************************************************************************
// Enable use of SWIFT readmem routine
// *************************************************************************
//
// Comment this line out to use verilog readmem instead of swift_readmem
//`define M14K_SWIFT 1

// *************************************************************************
// Indicate that simulation modules are in use
// *************************************************************************
//`define M14K_USE_SMODULES 1

// *************************************************************************
// Micro TLB 3 vs 4 entries
// NOT CONFIGURABLE
// *************************************************************************
`define M14K_UTLB4 1

`ifdef M14K_QUARTZ
`else
// *************************************************************************
// Flush data cache dirty lines after diag completion
//   - Used to compare reference model mem dump and rtl mem dump
//     Requires tasks in RAM wrapper modules to read/write arrays
//     Not required in Customer Verification Environment
// *************************************************************************
//`define M14K_FLUSH_DC_SUP 1
`endif

// *************************************************************************
// FPGA Options
// *************************************************************************
//
//
`define M14K_SYSADCLKDELAY clk_delay_null
`define M14K_SYSADCNV sysad_cnv_null
//`define M14K_SYSAD_CNV 1
//`define M14K_DEBUG_PORT 1
//`define M14K_LV_FPGA 1

//
// THE FPGA cannot handle gated clocks.
// To disable the toplevel clock-gating use the m14k_clock_nogate module
//
// clock-gate options:
// sclk                   // Simulation Clock-gate Module
// m14k_clock_gate        // Gate off main clock for WAIT instruction
// m14k_clock_nogate      // Never gate off main clock
`define M14K_CLKGATE_MODULE m14k_clock_nogate

// *************************************************************************
// Adder options
// *************************************************************************
// adder options:
//   m14k_edp_add		: Optimized CLA
//   m14k_edp_add_simple	: Simple "+" adder
//   m14k_mdl_add       	: Optimized CLA
//   m14k_mdl_add_simple        : Simple "+" adder
//   m14k_md_cpa                : Optimized CLA
//   m14k_md_cpa_simple 	: Simple "+" adder
//   m14k_mds_cpa       	: Optimized CLA
//   m14k_mds_cpa_simple        : Simple "+" adder

`define M14K_EDP_ADD m14k_edp_add_simple
`define M14K_MDL_ADD m14k_mdl_add_simple
`define M14K_MD_CPA  m14k_md_cpa_simple
`define M14K_MDS_CPA m14k_mds_cpa_simple

`ifdef M14K_QUARTZ

// *************************************************************************
// Dual or Unified SRAM I/F 
// *****************************b********************************************
// SRAM Interface module options:
//	ssram               : Simulation-only version that instantiates both
//			      Dual and Unified interface.
//      m14k_sram_dsif_uni  : Unified Interface
//      m14k_sram_dsif_dual : Dual Interface
`define M14K_SRAM_MODULE m14k_sram_dsif_dual

//`define M14K_SRAM_SCAN_INS_ENABLE 1
`ifdef M14K_SRAM_SCAN_INS_ENABLE
        `define M14K_SRAM_ISIF_SCANIO_MODULE 	  m14k_sram_isif_scanio_flops
        `define M14K_SRAM_DSIF_DUAL_SCANIO_MODULE m14k_sram_dsif_dual_scanio_flops
        `define M14K_SRAM_DSIF_SCANIO_MODULE      m14k_sram_dsif_scanio_flops
`else
        `define M14K_SRAM_ISIF_SCANIO_MODULE 	  m14k_sram_isif_scanio_stub
        `define M14K_SRAM_DSIF_DUAL_SCANIO_MODULE m14k_sram_dsif_dual_scanio_stub
        `define M14K_SRAM_DSIF_SCANIO_MODULE      m14k_sram_dsif_scanio_stub
`endif        
`endif

// Scan module options for CP2 case (others will be similar):
//	scp2_scanio_module: For internal testing
//	m14k_cp2_scanio_module: Module to be instantiated if M14K_SCAN_INS_ENABLE
//	                       is defined.
//      m14k_cp2_scanio_stub:   Module to be instantiated if M14K_SCAN_INS_ENABLE
//                             is not defined.

`ifdef M14K_SCAN_INS_ENABLE
	`define M14K_CP2_SCANIO_MODULE 	  m14k_cp2_scanio_flops
	`define M14K_CP1_SCANIO_MODULE 	  m14k_cp1_scanio_stub 
	`define M14K_UDI_SCANIO_MODULE 	  m14k_udi_scanio_flops
        `define M14K_DSPRAM_SCANIO_MODULE m14k_dspram_scanio_flops
        `define M14K_ISPRAM_SCANIO_MODULE m14k_ispram_scanio_flops
`else
	`define M14K_CP2_SCANIO_MODULE    m14k_cp2_scanio_stub        
	`define M14K_CP1_SCANIO_MODULE    m14k_cp1_scanio_stub        
	`define M14K_UDI_SCANIO_MODULE    m14k_udi_scanio_stub
        `define M14K_DSPRAM_SCANIO_MODULE m14k_dspram_scanio_stub
        `define M14K_ISPRAM_SCANIO_MODULE m14k_ispram_scanio_stub
`endif

//`define M14K_EARLY_RAM_CE    1


`define	M14K_SRAM_PARITY	m14k_sram_parity_stub

`define	M14K_DC_PARITY	m14k_dcc_parity_stub
`define	M14K_IC_PARITY	m14k_icc_parity_stub

// CDMM OPTION.  If either FDC or MPU exists, CDMM will be present
// m14k_cdmm : cdmm controls
// m14k_cdmmstub : stub
`define M14K_CDMM_MODULE m14k_cdmmstub 

// MPU : mpu is under the cdmm top module
// m14k_cdmm_mpu : mpu top controls
// m14k_cdmm_mpustub : stub
`define M14K_MPU_MODULE m14k_cdmm_mpustub

// MPU REGIONS : mpu can configurably have up to 16 regions.
//	these are instantiated under the mdu top module
// m14k_cdmm_mpu_region : region status and ctrl registers
// m14k_cdmm_mpu_regionstub: stub
`define M14K_MPUREGN_MODULE0  m14k_cdmm_mpu_regionstub
`define M14K_MPUREGN_MODULE1  m14k_cdmm_mpu_regionstub
`define M14K_MPUREGN_MODULE2  m14k_cdmm_mpu_regionstub
`define M14K_MPUREGN_MODULE3  m14k_cdmm_mpu_regionstub
`define M14K_MPUREGN_MODULE4  m14k_cdmm_mpu_regionstub
`define M14K_MPUREGN_MODULE5  m14k_cdmm_mpu_regionstub
`define M14K_MPUREGN_MODULE6  m14k_cdmm_mpu_regionstub
`define M14K_MPUREGN_MODULE7  m14k_cdmm_mpu_regionstub
`define M14K_MPUREGN_MODULE8  m14k_cdmm_mpu_regionstub
`define M14K_MPUREGN_MODULE9  m14k_cdmm_mpu_regionstub
`define M14K_MPUREGN_MODULE10 m14k_cdmm_mpu_regionstub
`define M14K_MPUREGN_MODULE11 m14k_cdmm_mpu_regionstub
`define M14K_MPUREGN_MODULE12 m14k_cdmm_mpu_regionstub
`define M14K_MPUREGN_MODULE13 m14k_cdmm_mpu_regionstub
`define M14K_MPUREGN_MODULE14 m14k_cdmm_mpu_regionstub
`define M14K_MPUREGN_MODULE15 m14k_cdmm_mpu_regionstub

// FDC module option
// m14k_ejt_tap_fdc : fdc implemented
// m14k_ejt_tap_fdcstub : stub
`define M14K_FDC_MODULE m14k_ejt_tap_fdcstub

// On-chip FDC FIFO depth  (8'b0-8'b11111111)

`define M14K_FDC_TXFIFO m14k_ejt_fifo_1r1w_stub
`define M14K_FDC_RXFIFO m14k_ejt_fifo_1r1w_stub

// PCsample module option
`define M14K_PCS_MODULE m14k_ejt_tap_pcsamstub

// PC module option
`define M14K_PC_MODULE m14k_cpz_pc_top

// DAsample module option
`define M14K_DAS_MODULE m14k_ejt_tap_dasamstub

// prid
`define M14K_PRID_COMPANYOPT 7'h0

// EIC interrupt vector offset
`define M14K_EIC_SUPPLIES_OFFSET m14k_cpz_eicoffset_stub

// dcc module option
`define M14K_DCC_MODULE m14k_dcc #(0)

// icc module option valid for M14KEc
`define M14K_ICC_MODULE m14k_icc #(0)

// edp module option
`define M14K_EDP_MODULE m14k_edp
// dec module option
`define M14K_MPCDEC_MODULE m14k_mpc_dec
// MDU module with some opcode decoding and DSP control logic
`define M14K_MDU_CTL_DEC_MODULE m14k_mdu_ctl_dec 
// Recoder logic
`define M14K_UMIPS_DSPDECODER m14k_alu_dsp_dec
// ctl module option
`define M14K_MPCCTL_MODULE m14k_mpc_ctl
// sram wrapper option valid for M14KE
`define M14K_SRAMWRAPPER_MODULE m14k_sram_wrapper

// Miscellaneous glue logic
// Speed optimization:
`define M14K_GLU_MODULE m14k_glue

// Enable Tracer DSP-ASE functions or not. 
//**********************************************
//Please do not change the condition below
//**********************************************

//`define M14K_ENABLE_SEC 1
// What the function of belowing MODULE
//
//
`ifdef M14K_ENABLE_SEC
`define M14K_CPZ_ANTITAMPER_MODULE   m14k_cpz_antitamper
`define M14K_CSCRAMBLE_MODULE        m14k_cscramble
`define M14K_CSCRAMBLE_SCANIO_MODULE m14k_cscramble_scanio_flops
`else
`define M14K_CPZ_ANTITAMPER_MODULE   m14k_cpz_antitamper_stub
`define M14K_CSCRAMBLE_MODULE        m14k_cscramble_stub
`define M14K_CSCRAMBLE_SCANIO_MODULE m14k_cscramble_scanio_stub
`endif


//`define M14K_ENABLE_DSP 1

// DSP module under ALU
// m14k_alu_dsp_stub : DSP not implemented
// m14k_alu_dsp : DSP implemented
// sm14k_dsp : simulation module to choose between DSP/no DSP at run
`ifdef M14K_ENABLE_DSP
`define M14K_ALU_DSP_MODULE      m14k_alu_dsp 
`else
`define M14K_ALU_DSP_MODULE      m14k_alu_dsp_stub
`define M14K_TRACER_NO_DSP       1
`endif

// MDU module with some opcode decoding and DSP control logic
// m14k_mdu_ctl_dec : some decoding for no DSP
// m14k_mdu_ctl_dec_dsp : some decoding and logic for DSP ASE
// smdu_ctl_dec : simulation module to choose between DSP/no DSP at run
// time
//`ifdef M14K_ENABLE_DSP
//`define M14K_MDU_CTL_DEC_MODULE m14k_mdu_ctl_dec_dsp 
//`else
//`define M14K_MDU_CTL_DEC_MODULE m14k_mdu_ctl_dec 
//`endif
//
//
//

// *************************************************************************
// MDU options
// *************************************************************************

// MDU module instantiation options:
`ifdef M14K_ENABLE_DSP
`define M14K_MDU_MODULE m14k_mdu 
`else 
//	m14k_md:  Synthesizable Fast MDU using a Wallace-tree multiplier
// 	m14k_mdl: Synthesizable Slow MDU using a recursive bit by bit multiplier
`define M14K_MDU_MODULE m14k_mdl 
`endif

//
//
//

`ifdef M14K_ENABLE_DSP
  `ifdef M14K_ENABLE_FPU
    `define M14K_UMIPS_RECODER m14k_umips_decomp_fpu_dsp 
  `else
    `define M14K_UMIPS_RECODER m14k_umips_decomp_dsp 
  `endif
`else
  `ifdef M14K_ENABLE_FPU
    `define M14K_UMIPS_RECODER m14k_umips_decomp_fpu 
  `else
    `define M14K_UMIPS_RECODER m14k_umips_decomp 
  `endif
`endif

// MDU HI/LO module
// m14k_mdu_hilo 	: single HI/LO set for no DSP
// m14k_mdu_hilo_dsp 	: 4 HI/LO sets for DSP ASE
// smdu_hilo : simulation module to choose between DSP/no DSP at run time
`ifdef M14K_ENABLE_DSP
`define M14K_MDU_MULDIV_HILO_MODULE m14k_mdu_hilo_dsp
`else
`define M14K_MDU_MULDIV_HILO_MODULE m14k_mdu_hilo
`endif

// MDU module with pipelined state bits for DSP control logic
// m14k_mdu_muldiv_pipereg 	: stub for no DSP
// m14k_mdu_muldiv_pipereg_dsp  : DSP ASE implemented
// smdu_muldiv_pipereg 		: simulation module to choose between DSP/no DSP at run 
//                       	  time
`ifdef M14K_ENABLE_DSP
`define M14K_MDU_MULDIV_PIPEREG_MODULE m14k_mdu_muldiv_pipereg_dsp
`else
`define M14K_MDU_MULDIV_PIPEREG_MODULE m14k_mdu_muldiv_pipereg
`endif


// MDU shift module
// m14k_mdu_shft_dsp_stub 	: no shift needed if DSP not implemented
// m14k_mdu_shft_dsp 		: shift module if DSP is implemented
// smdu_shft_dsp 		: simulation module to choose between DSP/no DSP at run time
`ifdef M14K_ENABLE_DSP
`define M14K_MDU_MULDIV_SHIFT_MODULE m14k_mdu_shft_dsp
`else
`define M14K_MDU_MULDIV_SHIFT_MODULE m14k_mdu_shft_dsp_stub
`endif


// MDU module containing various multiply data path components
// m14k_mdu_muldiv_dp_var 	: DSP not implemented
// m14k_mdu_muldiv_dp_var_dsp 	: DSP is implemented
// smdu_muldiv_dp_var 		: simulation module to choose between DSP/no DSP at run
//                      	  time
`ifdef M14K_ENABLE_DSP
`define M14K_MDU_MULDIV_DP_VAR_MODULE m14k_mdu_muldiv_dp_var_dsp
`else
`define M14K_MDU_MULDIV_DP_VAR_MODULE m14k_mdu_muldiv_dp_var
`endif

// MDU module to prepare input data for Booth recoding
// m14k_mdu_mul_booth_dp_in 	: DSP not implemented
// m14k_mdu_mul_booth_dp_in_dsp : DSP is implemented
// smdu_mul_booth_dp_in 	: simulation module to choose between DSP/no DSP at run
//                        	  time
`ifdef M14K_ENABLE_DSP
`define M14K_MDU_MUL_BOOTH_DP_IN_MODULE m14k_mdu_mul_booth_dp_in_dsp
`else
`define M14K_MDU_MUL_BOOTH_DP_IN_MODULE m14k_mdu_mul_booth_dp_in
`endif

// MDU module to connect data in multiplier array
// m14k_mdu_mul_array_dp_connect 	: DSP not implemented
// m14k_mdu_mul_array_dp_connect_dsp 	: DSP is implemented
// smdu_mul_array_dp_connect 		: simulation module to choose between DSP/no DSP 
//                             		  at run time
`ifdef M14K_ENABLE_DSP
`define M14K_MDU_MUL_ARRAY_DP_CONNECT  m14k_mdu_mul_array_dp_connect_dsp
`else
`define M14K_MDU_MUL_ARRAY_DP_CONNECT  m14k_mdu_mul_array_dp_connect
`endif

