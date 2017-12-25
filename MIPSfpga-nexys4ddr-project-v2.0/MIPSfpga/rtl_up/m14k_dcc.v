// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	m14k_dcc : Data Cache controller
//
//	$Id: \$
//	mips_repository_id: m14k_dcc.mv, v 1.87 
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
module	m14k_dcc(
	mpc_atomic_load_e,
	mpc_run_ie,
	mpc_atomic_w,
	mpc_atomic_store_w,
	mpc_atomic_m,
	edp_dval_e,
	mmu_dpah,
	mmu_rawdtexc_m,
	mmu_dtmack_m,
	edp_stdata_m,
	mpc_lsbe_m,
	cpz_llbit,
	mpc_sc_e,
	mmu_dcmode,
	ejt_stall_st_e,
	mpc_run_m,
	mpc_run_w,
	mpc_fixupd,
	mpc_fixup_m,
	mpc_busty_e,
	mpc_busty_raw_e,
	mpc_exc_e,
	mpc_exc_m,
	mpc_exc_w,
	mpc_dparerr_for_eviction,
	greset,
	mpc_dmsquash_m,
	mpc_dmsquash_w,
	cpz_int_mw,
	biu_dbe,
	biu_dbe_pre,
	mpc_coptype_m,
	cpz_taglo,
	cpz_wst,
	cpz_spram,
	cpz_datalo,
	icc_icopstall,
	dc_datain,
	dc_tagin,
	dc_wsin,
	dca_parity_present,
	DSP_TagRdValue,
	DSP_Hit,
	DSP_Stall,
	DSP_Present,
	DSP_TagAddr,
	DSP_TagCmpValue,
	DSP_TagWrStr,
	DSP_TagRdStr,
	DSP_DataRdStr,
	DSP_DataWrStr,
	DSP_Lock,
	dcc_spram_write,
	dcc_sp_pres,
	dcc_dspram_stall,
	dcc_pm_fb_active,
	dcc_pm_fbfull,
	dcc_uncache_load,
	dcc_uncached_store,
	dcc_dcop_stall,
	DSP_DataAddr,
	DSP_DataWrValue,
	DSP_DataWrMask,
	DSP_DataRdValue,
	cpz_dcnsets,
	cpz_dcssize,
	cpz_dcpresent,
	cpz_dsppresent,
	biu_datain,
	biu_ddataval,
	biu_datawd,
	biu_lastwd,
	biu_dreqsdone,
	biu_wtbf,
	biu_nofreebuff,
	edp_ldcpdata_w,
	mpc_sbstrobe_w,
	mpc_sdbreak_w,
	gclk,
	gscanenable,
	gscanmode,
	gscanramwr,
	cp2_data_w,
	cp2_datasel,
	cp2_fixup_m,
	cp2_fixup_w,
	cp2_exc_w,
	cp2_missexc_w,
	cp2_storekill_w,
	cp2_storeissued_m,
	cp2_ldst_m,
	dcc_store_allocate,
	cp2_storealloc_reg,
	cp1_data_w,
	cp1_datasel,
	cp1_fixup_m,
	cp1_fixup_w,
	cp1_exc_w,
	cp1_missexc_w,
	cp1_storekill_w,
	cp1_storeissued_m,
	cp1_ldst_m,
	cp1_storealloc_reg,
	cp1_fixup_w_nolsdc1,
	CP1_endian_0,
	cp1_seen_nodmiss_m,
	cp1_data_missing,
	mpc_chain_take,
	mpc_hw_save_status_m,
	mpc_hw_save_srsctl_m,
	mpc_hw_load_epc_m,
	mpc_hw_load_srsctl_m,
	cpz_causeap,
	mpc_exc_iae,
	edp_stdata_iap_m,
	dcc_wb,
	dcc_ddata_m,
	dcc_dmiss_m,
	dcc_pm_dhit_m,
	dcc_fixup_w,
	dcc_stall_m,
	dcc_advance_m,
	dcc_ev,
	dcc_intkill_m,
	dcc_intkill_w,
	dcc_dbe_killfixup_w,
	dcc_precisedbe_w,
	dcc_exc_nokill_m,
	dcc_newdaddr,
	dcc_dval_m,
	dcc_dcopdata_m,
	dcc_dcoptag_m,
	dcc_dcopld_m,
	dcc_copsync_m,
	dcc_dcached_m,
	dcc_lscacheread_m,
	dcc_tagaddr,
	dcc_trstb,
	dcc_twstb,
	dcc_tagwren,
	dcc_tagwrdata,
	dcc_wsaddr,
	dcc_wsrstb,
	dcc_wswstb,
	dcc_wswren,
	dcc_wswrdata,
	dcc_dataaddr,
	dcc_drstb,
	dcc_dwstb,
	dcc_writemask,
	dcc_data,
	dcc_exaddr,
	dcc_exaddr_ev,
	dcc_exaddr_sel,
	dcc_exbe,
	dcc_excached,
	dcc_exmagicl,
	dcc_exrdreqval,
	dcc_exwrreqval,
	dcc_exdata,
	dcc_exnewaddr,
	dcc_ev_kill,
	biu_mbdata,
	biu_mbtag,
	cpz_mbtag,
	dcc_stalloc,
	dcc_exsyncreq,
	dcc_dvastrobe,
	dcc_dcopaccess_m,
	dcc_sc_ack_m,
	dcc_stdstrobe,
	dcc_ldst_m,
	dcc_lddatastr_w,
	dcc_ejdata,
	dcc_pm_dcmiss_pc,
	gmbinvoke,
	dcc_mbdone,
	dcc_spmbdone,
	gmbddfail,
	gmbtdfail,
	gmbwdfail,
	gmbspfail,
	dmbinvoke,
	gmb_dc_algorithm,
	gmb_sp_algorithm,
	pdva_load,
	dcc_early_data_ce,
	dcc_early_tag_ce,
	dcc_early_ws_ce,
	DSP_ParityEn,
	DSP_WPar,
	DSP_ParPresent,
	DSP_RPar,
	cpz_pe,
	cpz_po,
	cpz_pd,
	dcc_dcoppar_m,
	dcc_parerr_ev,
	dsp_data_parerr,
	dcc_parerr_m,
	dcc_parerr_w,
	dcc_parerr_cpz_w,
	dcc_parerr_data,
	dcc_parerr_tag,
	dcc_parerr_ws,
	dcc_derr_way,
	icc_parerr_w,
	dcc_parerr_idx,
	dcc_par_kill_mw,
	dcc_valid_d_access,
	mpc_lsdc1_w,
	mpc_sdc1_w,
	mpc_lsdc1_m,
	cpz_g_int_mw,
	cpz_g_llbit,
	cpz_gm_m,
	cpz_gm_e,
	cpz_g_causeap,
	mmu_r_rawdtexc_m,
	mpc_idx_cop_e);


parameter PARITY =  `M14K_PARITY_ENABLE;

parameter    IDLE = 0;
parameter    LOCK_START = 1;
parameter    RD_HOLD = 2;
parameter    FLUSH_SB= 3;
parameter    UNLOCK = 4;

// Calculated parameter

parameter T_BITS = (PARITY == 1) ? `M14K_T_PAR_BITS : `M14K_T_NOPAR_BITS;
parameter D_BITS = (PARITY == 1) ? `M14K_D_PAR_BITS : `M14K_D_NOPAR_BITS;
parameter D_BYTES = (PARITY == 1) ? `M14K_D_PAR_BYTES : `M14K_D_NOPAR_BYTES;

	input		mpc_atomic_load_e;
	input		mpc_run_ie;
	input    	mpc_atomic_w;	    // Atomic instruction in W stage
        input           mpc_atomic_store_w;     // Atomic instruction in W_store stage
	input    	mpc_atomic_m;	    // Atomic instruction in W stage
	input [19:2]	edp_dval_e;	    // Data PA Low		
	input [`M14K_PAH] mmu_dpah;	    // Data PA High		
	input		mmu_rawdtexc_m;     // Raw translation exception (includes PREFS)
        input 		mmu_dtmack_m;       // TLB Miss acknowledge
	input [31:0]	edp_stdata_m;	    // Store Data
	input [3:0]	mpc_lsbe_m;	    // Byte Enables for L/S accesses
	input 		cpz_llbit;          // Load Linked bit - enables SC
	input		mpc_sc_e;           // This store is realy an SC
        input [2:0]	mmu_dcmode;         // Cache mode: 001=UC 011=magic 
                                            //  000=WB 010=WT-WA 110=WT-NWA
	input 		ejt_stall_st_e;     // Indicates simple break needs to check load data
	input		mpc_run_m;	    // Run signal
	input		mpc_run_w;	    // Run signal
	input 		mpc_fixupd;
	input 		mpc_fixup_m;
	input [2:0]	mpc_busty_e;	    // Bus Type
	input [2:0]	mpc_busty_raw_e;    // Unqualified bus type (no Exc_E or dcc_dmiss_m)
	input 		mpc_exc_e;          // E-stage instn killed by exception
	input 		mpc_exc_m;          // M-stage instn killed by exception
	input		mpc_exc_w;	    // W-stage instn killed by exception
	input		mpc_dparerr_for_eviction; //t_dperr
	input		greset;             // greset (cold/warm)
	input		mpc_dmsquash_m;	    // Kill Dcache miss due to M-stage exceptions.
	input		mpc_dmsquash_w;	    // Kill Dcache miss due to M-stage exceptions.
	input 		cpz_int_mw;         // Interrupt (external, sw, or non-maskable)
	input		biu_dbe;            // Data bus error
	input		biu_dbe_pre;        // Previous Data bus error
	
	input [3:0]	mpc_coptype_m;	    // Cacheop specifier (raw from instn register)	

	input [25:0]	cpz_taglo;	    // Tag for CacheOp (includes dirty bit)
        input 		cpz_wst;            // write to WS ram on idx st tag cacheop
	input 		cpz_spram;          // Write to SPRAM on indexed cacheops
	input [31:0] 	cpz_datalo;         // Data for CacheOp
	input		icc_icopstall;      // I$ access not complete - stall
	
	input [(D_BITS*`M14K_MAX_DC_ASSOC-1):0]  dc_datain;     // D$ Data
	input [(T_BITS*`M14K_MAX_DC_ASSOC-1):0]  dc_tagin;      // D$ Tag
	input [13:0]        			 dc_wsin;    // D$ WS

        input 					 dca_parity_present;
        // Spram ports
	input [23:0] 	DSP_TagRdValue;     // dspram tag value
	input 		DSP_Hit;            // dspram hit
	input 		DSP_Stall;          // dspram not ready
	input 		DSP_Present;
	
	output [19:2] 	DSP_TagAddr;        // Additional index bits for SPRAM
        output [23:0] 	DSP_TagCmpValue;    // tag compare data
	output 		DSP_TagWrStr;       // SP tag write strobe
	output 		DSP_TagRdStr;       // Tag Read strobe
	output 		DSP_DataRdStr;      // Data Read strobe
	output 		DSP_DataWrStr;      // Data write strobe
	output		DSP_Lock;	    // Start a RMW sequence
	output		dcc_spram_write;
	output 		dcc_sp_pres;

        output          dcc_dspram_stall;
	output		dcc_pm_fb_active;
	output		dcc_pm_fbfull;
	output          dcc_uncache_load;
        output          dcc_uncached_store;
	output		dcc_dcop_stall;

	output [19:2] 	DSP_DataAddr;       // Additional index bits for SPRAM
	output [31:0] 	DSP_DataWrValue;
	output [3:0]	DSP_DataWrMask;     // SP write mask
	input [31:0] 	DSP_DataRdValue;    // dspram data value
	// End Spram Ports

	input [2:0]	cpz_dcnsets;	    // Number of sets   - from Config1
	input [1:0]	cpz_dcssize;	    // D$ associativity - from Config1
        input 		cpz_dcpresent;      // Data cache is present - from Config1
        input 		cpz_dsppresent;      // Data spram is present - from Config0

	input [31:0]	biu_datain;	    // External Data In
	input		biu_ddataval;	    // biu_datain contains valid Instn
	input [1:0]	biu_datawd;	    // Which word is being returned
	input		biu_lastwd;	    // Last word of this request
	input		biu_dreqsdone;	    // BIU has completed this sync request
	input		biu_wtbf;	    // Write Thru buffer is full
        input 		biu_nofreebuff;     // there is no free buffer, so keep any eviction from starting
	input [31:0]	edp_ldcpdata_w;     // W-stage load data for ejtag
	input		mpc_sbstrobe_w;     // ejtag simple break strobe
	input 		mpc_sdbreak_w;      // ejtag simple break on data taken (kill store)
	input		gclk;               // Clock
	input 		gscanenable;
	input 		gscanmode;
	input 		gscanramwr;
	input [31:0] 	cp2_data_w;         // Return Data from COP2
	input 	 	cp2_datasel;        // Select cp2_data_w in store buffer.
	input 	 	cp2_fixup_m; 	    // Rerun Stage-E
	input 	 	cp2_fixup_w; 	    // Rerun Stage-M
	input 	 	cp2_exc_w; 	    // COP2 Exception
	input 	 	cp2_missexc_w;      // COP2 Exception Not ready
	input		cp2_storekill_w;    // Invalidate COP2 store data in SB
	input		cp2_storeissued_m;  // Indicate that a SWC2 is issued to CP2
	input 	 	cp2_ldst_m;	    // CP2 Ld/St instruction in M-stage
        
   	output 	 	dcc_store_allocate; // Control output to CP2
   	input 	 	cp2_storealloc_reg; // Control input from CP2

	input [63:0] 	cp1_data_w;         // Return Data from COP1
	input 	 	cp1_datasel;        // Select cp1_data_w in store buffer.
	input 	 	cp1_fixup_m; 	    // Rerun Stage-E
	input 	 	cp1_fixup_w; 	    // Rerun Stage-M
	input 	 	cp1_exc_w; 	    // COP1 Exception
	input 	 	cp1_missexc_w;      // COP1 Exception Not ready
	input		cp1_storekill_w;    // Invalidate COP1 store data in SB
	input		cp1_storeissued_m;  // Indicate that a SWC1 is issued to CP1
	input 	 	cp1_ldst_m;	    // CP1 Ld/St instruction in M-stage
   	input 	 	cp1_storealloc_reg; // Control input from CP1
   	input 	 	cp1_fixup_w_nolsdc1;
	input 	 	CP1_endian_0;		// COP1 Big Endian used in instruction/To/From
	input 	 	cp1_seen_nodmiss_m;		
	input 	 	cp1_data_missing;		

	input           mpc_chain_take;        // kill dmiss due to tail chain
        input           mpc_hw_save_status_m;  // M-stage HW save EPC operation
        input           mpc_hw_save_srsctl_m;  // M-stage HW save SRSCTL operation
        input           mpc_hw_load_epc_m;     // M-stage HW load EPC operation
        input           mpc_hw_load_srsctl_m;  // M-stage HW load SRSCTL operation
        input           cpz_causeap;           // exception happened during auto-prologue
	input           mpc_exc_iae;           // exceptions happened during IAE
        input  [31:0]   edp_stdata_iap_m;      // Store Data mux with interrupt auto prologue store

        output          dcc_wb;

	output [31:0]	dcc_ddata_m;	    // Data bus to core
	output		dcc_dmiss_m;	    // Data ref. missed
	output		dcc_pm_dhit_m;	    // pm data ref. hit
	output 		dcc_fixup_w;
	output 		dcc_stall_m;        // Force M-stage stall (spram stall)
	output 		dcc_advance_m;
        output 		dcc_ev;             // Eviction taking place
        output		dcc_intkill_m;      // M-stage op is being killed by interrupt
	output 		dcc_intkill_w;      // dcc_dmiss_m is going away because of interrupt
	output 		dcc_dbe_killfixup_w;// dcc_dmiss_m is going away because of DBE
	output 		dcc_precisedbe_w;   // Precise DBE on W-stage instn
	output		dcc_exc_nokill_m;   // atomic load is already in fixup w stage
					    // Bus is waiting to be locked

	output 		dcc_newdaddr;

        output [19:2] 	dcc_dval_m;         // Lower bits of PA for ICOp
	output [31:0]	dcc_dcopdata_m;	    // Cacheop Data Value
	output [25:0]	dcc_dcoptag_m;	    // Cacheop Tag Value (includes Dirty bit and Parity bit)
	output		dcc_dcopld_m;	    // Cacheop cpz_taglo write strobe
	output		dcc_copsync_m;      // Tell ic_ctl that sync for $op is not done yet 

	output		dcc_dcached_m;	    // indicates whether access is cached or in uncached region
	output		dcc_lscacheread_m;    // cacheread includes tag/data/way
	output [13:4]	dcc_tagaddr;	    // Index into tag array
	output 		dcc_trstb;	    // Tag Read Strobe
	output		dcc_twstb;	    // Tag write strobe
	output[(`M14K_MAX_DC_ASSOC-1):0]	dcc_tagwren;	// Write way
	output [T_BITS-1:0]    dcc_tagwrdata;      // Tag write data

	output [13:4]	dcc_wsaddr;	    // Index into WS array
	output 		dcc_wsrstb;	    // WS Read Strobe
	output		dcc_wswstb;	    // WS write strobe
	output [13:0] dcc_wswren;   // WS write mask
	output [13:0] dcc_wswrdata; // WS write data

	output [13:2]	dcc_dataaddr;	    // Index into data array
	output		dcc_drstb;	    // Data read strobe
	output 		dcc_dwstb;	    // Data write Strobe
	output [(4*`M14K_MAX_DC_ASSOC-1):0]  dcc_writemask; // Write mask
	output [D_BITS-1:0]    dcc_data;           // Write Data
	
	output [31:2]	dcc_exaddr;	    // Addr for D$ miss, write,  or uncached D ref
        output [31:2] 	dcc_exaddr_ev;      // Addr for eviction
        output 		dcc_exaddr_sel;     // Select address to use
	output [3:0]	dcc_exbe;	    // Byte Enables for Write
	output 		dcc_excached;	    // D Request is cacheable
	output 		dcc_exmagicl;	    // D Request is to Probe Space
	output		dcc_exrdreqval;	    // D Request is valid
	output		dcc_exwrreqval;	    // D Request is valid
	output [31:0]	dcc_exdata;	    // Write Data
	output 		dcc_exnewaddr;      // Valid L/S/P/$ instn in M-stage
	output		dcc_ev_kill;	    // Kill entire line of eviction
        input  [31:0]   biu_mbdata;	    // BIST read Data
        input  [23:2]   biu_mbtag;	    // BIST read TAG Data
	input  [1:0]    cpz_mbtag;          // BIST read TAG data
	
	output 		dcc_stalloc;        // Write allocate, don't flush the WTB
	output		dcc_exsyncreq;      // Sync request
	
	output		dcc_dvastrobe;	    // Data Virtual Address strobe for EJTAG
	output		dcc_dcopaccess_m;   // D cache op
	output		dcc_sc_ack_m;
	output 		dcc_stdstrobe;      // Store data ready to be checked
	output		dcc_ldst_m;         // Data is Load (1) or Store (0)
	output		dcc_lddatastr_w;    // EJTAG Data strobe for dcc_ejdata
	output [31:0]	dcc_ejdata;	    // Read or Write value for EJTAG data match

	output          dcc_pm_dcmiss_pc;      // Perf. monitor D$ miss

        // BIST Signals
	input		gmbinvoke;
	output		dcc_mbdone;
	output		dcc_spmbdone;
	output		gmbddfail;
	output		gmbtdfail;
	output		gmbwdfail;
	output		gmbspfail;
	output		dmbinvoke;	
        input   [7:0]   gmb_dc_algorithm; // Alogrithm selection for D$ BIST controller.
        input   [7:0]   gmb_sp_algorithm; // Alogrithm selection for DSPRAM BIST controller.
	output		pdva_load;		//indicate valid load data is in W stage;
	
	output		dcc_early_data_ce;
	output		dcc_early_tag_ce;
	output		dcc_early_ws_ce;

	output		DSP_ParityEn;		// Parity enable for DSPRAM 
	output	[3:0]	DSP_WPar;		// Parity bit for DSPRAM write data 
	input		DSP_ParPresent;		// DSPRAM has parity support
	input	[3:0]	DSP_RPar;		// Parity bits read from DSPRAM
	
	// CPZ interface for parity
	input           cpz_pe;             // parity enable bit
        input           cpz_po;             // parity overwrite bit
        input [3:0]     cpz_pd;             // parity bits of D$ data array
	output [3:0]    dcc_dcoppar_m;      // Cacheop Parity bits to be stored to ErrCtl register

	// parity exception interface
	output		dcc_parerr_ev;	    // parity error detected on eviction
	output		dsp_data_parerr;    // parity error detected on DSPRAM
	output          dcc_parerr_m;       // parity error detected at M stage
        output          dcc_parerr_w;       // parity error detected at W stage
        output          dcc_parerr_cpz_w;       // parity error detected at W stage for cpz update
        output          dcc_parerr_data;    // parity error detected at data ram
        output          dcc_parerr_tag;     // parity error detected at tag ram
        output          dcc_parerr_ws;      // parity error detected at WS ram
        output  [1:0]   dcc_derr_way;       // indicate which way detected parity error
        input           icc_parerr_w;       // parity error detected on I$ at W stage
	output	[19:0]	dcc_parerr_idx;	    
	output		dcc_par_kill_mw;	    

	output		dcc_valid_d_access;

	input		mpc_lsdc1_w; 
	input		mpc_sdc1_w; 
	input		mpc_lsdc1_m; 
	input 		cpz_g_int_mw;         // Interrupt (external, sw, or non-maskable)
	input		cpz_g_llbit;          // Load linked bit - enables SC
	input		cpz_gm_m;	    
	input		cpz_gm_e;	    
	input		cpz_g_causeap;	    
	input 		mmu_r_rawdtexc_m;		// Raw translation exception (includes PREFS)
	input		mpc_idx_cop_e;

// BEGIN Wire declarations made by MVP
wire st_alloc_rd_sent;
wire [3:0] /*[3:0]*/ fb_store_dirty;
wire ev_dirtyway;
wire dcop_fandl;
wire dcop_read_wait;
wire ev_dirtyway_reg;
wire advance_m;
wire ls_tag_read;
wire [3:0] /*[3:0]*/ dcop_pa_wsparity;
wire dcop_idx_stt;
wire flush_sb;
wire write_thru_reg;
wire [31:0] /*[31:0]*/ dcc_ddata_m_reg;
wire [3:0] /*[3:0]*/ lock;
wire [`M14K_D_PAR_BYTES-1:0] /*[8:0]*/ mbdspdatain_b3_raw;
wire [`M14K_D_PAR_BYTES-1:0] /*[8:0]*/ mbdspdatain_b0_raw;
wire advance_m_reg;
wire [D_BYTES-1:0] /*[8:0]*/ mbdspdatain_b2;
wire unc_st_stall;
wire dcop_fill_done;
wire dcc_early_data_ce;
wire early_dcc_wswstb;
wire pdva_load;
wire [3:0] /*[3:0]*/ ev_fill_tbist_dcop_way;
wire st_alloc_wait;
wire [31:0] /*[31:0]*/ fb_hold_data;
wire other_req;
wire cp2_fixup_m_legit;
wire dcop_fill_pending;
wire [3:0] /*[3:0]*/ repl_wway_reg;
wire [31:0] /*[31:0]*/ dc_datain_3;
wire dcop_hit_only;
wire dcc_pm_dcmiss_pc;
wire [31:0] /*[31:0]*/ dcc_data_raw;
wire dcc_wsrstb_reg;
wire dcop_idx_inval_ev;
wire [D_BITS*4:0] /*[144:0]*/ spram_cache_data_lf;
wire [D_BYTES-1:0] /*[8:0]*/ mbdddata_b1;
wire [8:3] /*[8:3]*/ dcop_pa6;
wire dstore_write;
wire store_hit_fb;
wire cp1_missexc_w_legit;
wire sync_not_done_reg;
wire cop_stall;
wire imm_store;
wire early_dcc_drstb;
wire spram_hit_for_atomicwrite;
wire rd_req_enable;
wire ev_wrtag_inv_ws;
wire dcc_spwstb;
wire dcc_twstb_reg;
wire [3:0] /*[3:0]*/ ev_compare_way_ws;
wire store_force_stall;
wire ev_new;
wire [19:2] /*[19:2]*/ dcc_tagaddrint;
wire spram_hit_atomic_ld_raw;
wire ev_exold_addr;
wire fb_wb_idx_match;
wire early_stall;
wire imm_load_hit;
wire dcached;
wire dcc_lscacheread_m;
wire [`M14K_D_PAR_BYTES-1:0] /*[8:0]*/ mbdddata_b2_raw;
wire dcc_stall_m;
wire [7:0] /*[7:0]*/ sb_fb_data0;
wire dcc_intkill_w;
wire [13:0] /*[13:0]*/ mbwd_mask;
wire store_m;
wire killedmiss_w;
wire [1:0] /*[1:0]*/ ev_word_reg;
wire dcop_idx_writedirty;
wire [31:0] /*[31:0]*/ ej_core_data_temp;
wire [`M14K_D_PAR_BYTES-1:0] /*[8:0]*/ mbdddata_b1_raw;
wire ev_stall_nofill;
wire [19:2] /*[19:2]*/ storebuff_idx;
wire early_dcc_dwstb;
wire dcc_early_ws_ce;
wire [19:2] /*[19:2]*/ dcc_dval_m;
wire store_alloc_en;
wire [3:0] /*[3:0]*/ ev_fill_dbist_dcop_way;
wire ev_fbhit_sel_pre_reg;
wire [5:0] /*[5:0]*/ lru_mask;
wire sb_dsp_hit;
wire fxexc_e_reg;
wire dcop_wrafterws_ev;
wire dsp_lock_hold;
wire dstore_e;
wire cacheread_m;
wire use_idx;
wire [D_BYTES-1:0] /*[8:0]*/ mbdspdatain_b0;
wire wtwa_st_stall;
wire [3:0] /*[3:0]*/ repl_way_reg;
wire dcc_drstb;
wire [31:0] /*[31:0]*/ ej_core_data_read;
wire [3:0] /*[3:0]*/ held_be;
wire killable_m_reg;
wire [3:0] /*[3:0]*/ ev_way_mx1;
wire [`M14K_D_PAR_BYTES-1:0] /*[8:0]*/ mbdddata_b3_raw;
wire early_imm_load;
wire ev_exnew_addr_reg;
wire dcop_read_reg_reg;
wire [3:0] /*[3:0]*/ fb_repl;
wire [3:0] /*[3:0]*/ ev_way_sel_mx1;
wire sb_addrhit;
wire ev_way_on;
wire ev_fb_wayhit_b;
wire spram_hit_in_atomic;
wire stall;
wire ev_sb_hitdone_reg;
wire [13:0] /*[13:0]*/ dcc_wswren_adj;
wire dcc_trstb;
wire [31:0] /*[31:0]*/ mmu_dpah_31_0;
wire dcop_indexed;
wire store_alloc_hit_fb;
wire dcop_access_e;
wire [3:0] /*[3:0]*/ dvalid;
wire imm_cop_prefndg;
wire [31:0] /*[31:0]*/ storebuff_data;
wire dcop_hit_inval_wb;
wire dcop_evictable;
wire ev_exception_detected;
wire ev_noadv;
wire [D_BITS-1:0] /*[35:0]*/ mbdddatain;
wire dcop_hit_wb;
wire early_raw_cacheread_e;
wire [31:0] /*[31:0]*/ dcc_ejdata;
wire cache_hit_reg;
wire [3:0] /*[3:0]*/ dcop_wway_reg;
wire raw_dstore_presc_m;
wire ev_fbmatch_b_reg;
wire dccop_m;
wire ev_exnew_addr;
wire dcc_stalloc;
wire req_out;
wire dcop_idx_stw;
wire dcc_exnewaddr;
wire kick_atomic_write_hold;
wire dccop_w_ev;
wire dcop_idx_std_dsp;
wire [13:4] /*[13:4]*/ dcc_wsaddr;
wire dcc_early_tag_ce;
wire [D_BYTES-1:0] /*[8:0]*/ mbdddata_b0;
wire dcc_excached;
wire [13:4] /*[13:4]*/ dcc_tagaddr_reg;
wire dcop_idx_ld;
wire dcc_store_allocate;
wire [13:4] /*[13:4]*/ dcc_tagaddr;
wire [(`M14K_MAX_DC_ASSOC*22)-1:0] /*[87:0]*/ tag_cmp_pa;
wire early_imm_store;
wire no_way;
wire dcached_mix;
wire dcc_pm_dhit_m;
wire cacheread_m_pc;
wire [13:0] /*[13:0]*/ dcc_wswrdata_adj;
wire dcop_access_m;
wire raw_cacheread_e_pc;
wire spram_hit_in_atomic_hold;
wire store_alloc_en_stall;
wire lscacheread_e;
wire held_parerr_w;
wire spram_hit_atomic_ld;
wire dcc_dcopld_md;
wire [5:0] /*[5:0]*/ lru_fillmask;
wire sync_not_done;
wire ev_cur;
wire dcc_dcopaccess_m;
wire wt_wa_req_w;
wire [3:0] /*[3:0]*/ ev_compare_way_idx;
wire dcop_ready;
wire raw_writethru;
wire [13:0] /*[13:0]*/ dcc_wswrdata;
wire dcop_idx_std_dc;
wire [23:0] /*[23:0]*/ tag_rd_int2;
wire [3:0] /*[3:0]*/ next_valid;
wire restart;
wire [13:0] /*[13:0]*/ dcc_wsaddr_13_0;
wire [31:2] /*[31:2]*/ dcc_exaddr;
wire dcc_dmiss_m;
wire dsync_e;
wire [3:0] /*[3:0]*/ dunavail_raw;
wire dcc_parerr_ev_reg;
wire hold_parerr_w;
wire [3:0] /*[3:0]*/ block_hit_way_reg;
wire [3:0] /*[3:0]*/ repl_way;
wire dcop_read;
wire early_store_force_stall;
wire dcop_pref_hit;
wire force_wt;
wire [13:2] /*[13:2]*/ dcc_dataaddr;
wire hold_restart;
wire early_dstore_e;
wire [31:0] /*[31:0]*/ dc_datain_0;
wire [3:0] /*[3:0]*/ ev_cache_way_mx;
wire dsp_lock_hold_hit;
wire ev_fbhit_sel_pre;
wire [3:0] /*[3:0]*/ data_line_sel;
wire [13:4] /*[13:4]*/ ev_tagaddr;
wire hold_dcc_parerr_w;
wire dcop_nop;
wire dcop_idx_inval;
wire early_cachewrite_e;
wire dcc_wb;
wire imm_load_miss;
wire [3:0] /*[3:0]*/ ev_way;
wire hold_fb_wb_idx_match;
wire ev_cancel;
wire store_allocate_reg;
wire [23:16] /*[23:16]*/ sb_fb_data2;
wire [3:0] /*[3:0]*/ dcc_dcoppar_m;
wire cacheread_e;
wire [13:0] /*[13:0]*/ dcc_wswren;
wire dcop_hit_noinv;
wire early_cacheread_e;
wire new_addr_nxt;
wire [31:0] /*[31:0]*/ datamuxout_data;
wire cp2_tag_reg;
wire block_hit_fb_reg;
wire tagdirty;
wire [3:0] /*[3:0]*/ ev_repl_way;
wire [19:2] /*[19:2]*/ dcc_tagaddr_nomunge;
wire dsp_lock_present;
wire dcop_write_reg;
wire dcc_dspram_stall;
wire [3:0] /*[3:0]*/ tag_line_sel;
wire [31:24] /*[31:24]*/ data_in3;
wire dcop_d_dsp_write;
wire dcc_dvastrobe;
wire store_allocate;
wire stalled_m;
wire [3:0] /*[3:0]*/ ev_compare_way_pref;
wire [3:0] /*[3:0]*/ ev_wway_reg;
wire [25:0] /*[25:0]*/ dcc_dcoptag_m;
wire dcc_trstb_reg;
wire early_store_stall;
wire [3:0] /*[3:0]*/ dbist_dcop_way;
wire [13:0] /*[13:0]*/ dcc_wswren_full;
wire wb;
wire held_hit_reg;
wire ev_wait;
wire raw_dstore_m;
wire no_way_reg;
wire raw_dstore_e;
wire early_held_hit;
wire wb_noavail_reg;
wire dcc_fixup_w;
wire new_addr_sync;
wire fandl_read;
wire [3:0] /*[3:0]*/ ev_way_mx2;
wire [3:0] /*[3:0]*/ ev_ex_be;
wire dcc_ldst_m;
wire spram_hit_in_atomic_delay;
wire ev_done;
wire cp2_missexc_w_real;
wire rd_req_enable_next;
wire [3:0] /*[3:0]*/ wway_reg;
wire dcop_done;
wire [5:0] /*[5:0]*/ lru_hitdata;
wire [D_BYTES-1:0] /*[8:0]*/ mbdspdatain_b3;
wire [3:0] /*[3:0]*/ ways_locked;
wire wb_st_stall;
wire [3:0] /*[3:0]*/ unavail;
wire ev_wrtag_inv;
wire [31:0] /*[31:0]*/ dc_datain_2;
wire sb_addrhit_word;
wire ev_hitback_fb;
wire dcc_precisedbe_w;
wire [`M14K_PAH] /*[31:10]*/ storebuff_tag;
wire [3:0] /*[3:0]*/ ev_sb_hit;
wire mmu_rawdtexc_reg;
wire [3:0] /*[3:0]*/ ev_way_reg;
wire ev_way_on_reg;
wire cp2_missexc_w_legit;
wire imm_store_hit;
wire [13:2] /*[13:2]*/ storebuff_idx_mx_munge;
wire sync_req_sync;
wire [23:16] /*[23:16]*/ data_in2;
wire store_stall;
wire imm_cop_prefndg_reg;
wire [31:10] /*[31:10]*/ dcc_tagcmpdata;
wire [3:0] /*[3:0]*/ ev_cache_way;
wire ev_sb_hitacc;
wire req_out_reg;
wire kick_atomic_write;
wire early_dcop_access_e;
wire kill_sc_m;
wire kick_atomic_write_raw;
wire dcc_exc_nokill_m;
wire cachewrite_e;
wire store_alloc_flush_reg;
wire [1:0] /*[1:0]*/ dcop_way_sel_bits;
wire [31:0] /*[31:0]*/ dcc_exaddr_ev_31_0;
wire rd_req;
wire cacheread_e_pc;
wire mbtdtag_p;
wire [31:0] /*[31:0]*/ ev_ex_dataout;
wire dcc_uncached_store;
wire [`M14K_T_PAR_BITS-1:0] /*[24:0]*/ mbtdtag_raw;
wire fxexc_e;
wire dcc_pm_fbfull;
wire fandl_read_reg;
wire dcop_fill_req;
wire hold_dmiss_n;
wire cp2_datasel_legit;
wire dmagicl;
wire dc_hit_en;
wire ev_sb_highhit;
wire [31:2] /*[31:2]*/ dcc_exaddr_ev;
wire clear_wt;
wire [13:0] /*[13:0]*/ index_mask;
wire fb_hit_en;
wire [15:0] /*[15:0]*/ dcc_writemask16;
wire dcc_exaddr_sel;
wire [13:0] /*[13:0]*/ dcc_wswrdata_full;
wire dcop_mux_sel;
wire cp2_datasel_real;
wire cp2_not_legit;
wire ev_stall;
wire [31:0] /*[31:0]*/ storebuff_data_reg;
wire dcc_twstb;
wire [23:0] /*[23:0]*/ tag_rd_int0;
wire sync_stall;
wire dcop_lock_write_reg;
wire raw_cacheread_e;
wire dsync_m_reg;
wire dcc_dwstb;
wire dcc_dbe_killfixup_w;
wire [D_BYTES-1:0] /*[8:0]*/ mbdspdatain_b1;
wire wb_noavail;
wire dcop_access_m_reg;
wire prefetch;
wire wt_wa;
wire [5:0] /*[5:0]*/ lru_data;
wire ev_use_idx;
wire [3:0] /*[3:0]*/ pending_fill_way;
wire [3:0] /*[3:0]*/ store_way;
wire [D_BITS*4:D_BITS*`M14K_MAX_DC_ASSOC] /*[144:144]*/ spram_cache_data_df;
wire [3:0] /*[3:0]*/ sb_valid_bits;
wire early_prefnudge_imm;
wire ev_hit_cancel;
wire cp1_missexc_w_real;
wire [15:8] /*[15:8]*/ data_in1;
wire [3:0] /*[3:0]*/ dcc_tagwren4;
wire [19:2] /*[19:2]*/ ev_dval_addr;
wire ev_wrtag_noinv;
wire dcc_stdstrobe;
wire [3:0] /*[3:0]*/ ev_wrtag_inv_msk;
wire cp2_storekill_w_real;
wire raw_dcop_access_m;
wire [19:2] /*[19:2]*/ storebuff_idx_mx;
wire [3:0] /*[3:0]*/ dcc_wswrdata_dirty;
wire wt_req_w;
wire dcc_exmagicl;
wire [3:0] /*[3:0]*/ tag_cmp_v4;
wire sb_addrhit_high;
wire dcc_parerr_ws_reg;
wire ev_dirtyway_reg_reg;
wire [(4*`M14K_MAX_DC_ASSOC-1):0] /*[15:0]*/ dcc_writemask;
wire pre_ev_way_on;
wire killable_m;
wire dcop_hit_nolru;
wire [3:0] /*[3:0]*/ dcop_wway;
wire storewrite_m;
wire dcc_spram_write;
wire ev_fbhit_fill;
wire cp2_storeissued_m_real;
wire hold_dtmack;
wire sb_addrhit_lower;
wire early_imm_cop_prefndg;
wire dcc_dcopld_m;
wire ev_fb_wayhit;
wire [(T_BITS*4)-1:0] /*[99:0]*/ tag_rd_int112;
wire [3:0] /*[3:0]*/ dcop_pa_wsdirty;
wire wr_req_enable;
wire [13:2] /*[13:2]*/ ev_store_addr;
wire held_dcc_parerr_w;
wire par_kill_m;
wire rdreq_sync_next;
wire [3:0] /*[3:0]*/ dunavail;
wire cp2_ldst_m_reg;
wire [3:0] /*[3:0]*/ wway_reg_sel;
wire [1:0] /*[1:0]*/ dcop_mask_way_sel;
wire [23:0] /*[23:0]*/ tag_rd_int3;
wire [(`M14K_MAX_DC_ASSOC)-1:0] /*[3:0]*/ tag_cmp_v;
wire [`M14K_D_PAR_BYTES-1:0] /*[8:0]*/ mbdspdatain_b2_raw;
wire advance_mmu_m;
wire idx_match_fb_b_reg;
wire [`M14K_D_PAR_BYTES-1:0] /*[8:0]*/ mbdspdatain_b1_raw;
wire [3:0] /*[3:0]*/ ws_dirty_en;
wire [3:0] /*[3:0]*/ tbist_dcop_way;
wire prefnudge_reg;
wire [3:2] /*[3:2]*/ dc_tagaddr_l;
wire dcop_fill_miss;
wire dcc_lddatastr_w;
wire pre_flush_sb;
wire ev_fbhit;
wire [31:2] /*[31:2]*/ ev_exaddr;
wire [3:0] /*[3:0]*/ spram_sel_atomic_write;
wire dcop_hit_nolru_reg;
wire prefnudge_m;
wire [D_BYTES-1:0] /*[8:0]*/ mbdddata_b3;
wire [19:0] /*[19:0]*/ fill_addr_lo_19_0;
wire fb_wb_end;
wire killmiss_m;
wire dcc_dmiss_m_ev_reg;
wire cachewrite_m;
wire [7:0] /*[7:0]*/ data_in0;
wire ev_exception_kill_wr;
wire [`M14K_D_PAR_BYTES-1:0] /*[8:0]*/ mbdddata_b0_raw;
wire dcop_d_dsp_write_pend;
wire ev_fbhitb;
wire dcc_newdaddr;
wire [15:8] /*[15:8]*/ sb_fb_data1;
wire prefnudge_stall;
wire store_killable;
wire [23:0] /*[23:0]*/ dcop_tag;
wire dcc_dcop_stall;
wire spram_lock_stall;
wire dcop_ready_reg;
wire cp2_fixup_m_real;
wire ev_rdreq_seen_cnd;
wire pend_dbe_kill_fixup;
wire dcc_valid_d_access;
wire ev_use_idx_data;
wire [5:0] /*[5:0]*/ lru_hitmask;
wire [T_BITS-1:0] /*[24:0]*/ mbtdtag;
wire [3:0] /*[3:0]*/ ws_en;
wire dcop_hit_inval;
wire dstore_m;
wire ev_cache_way_sel;
wire ev_rdreq_seen;
wire cp2_store_stall;
wire storebuff_valid;
wire dcop_pref_hit_reg;
wire [13:2] /*[13:2]*/ ev_dataaddr;
wire store_alloc_flush;
wire [3:0] /*[3:0]*/ ws_mask;
wire dccop_w_ev_tmp;
wire raw_dsync_e;
wire dcc_exrdreqval;
wire dccop_m_reg;
wire [13:0] /*[13:0]*/ dcc_dataaddr_13_0;
wire raw_dcop_access_e;
wire early_dcc_wsrstb;
wire dcop_wrafterws;
wire ej_loadstore_md;
wire dcop_lru_write;
wire dcc_par_kill_mw;
wire dcc_exwrreqval;
wire ev_sb_wayhit;
wire cp2_storealloc_reg_reg;
wire early_dcc_twstb;
wire dsp_lock_hold_hit_long;
wire [`M14K_PAH] /*[31:10]*/ storebuff_tag_mx;
wire dcc_copsync_m;
wire ev_dirtyway_reg_reg_nopar;
wire ev_fbhit_sel_pre_allow;
wire [3:0] /*[3:0]*/ ev_sb_hit_reg;
wire ev_sb_wordhit;
wire [1:0] /*[1:0]*/ ev_word;
wire dsync_m;
wire dcc_dcached_m;
wire precise_dbe;
wire held_dtmack;
wire sb_addrhit_idx_munge;
wire [D_BITS-1:0] /*[35:0]*/ mbdspdatain;
wire [3:0] /*[3:0]*/ dcc_wway;
wire [13:0] /*[13:0]*/ dcc_tagaddr_13_0;
wire bypass_d;
wire pref_m;
wire early_raw_dsync_e;
wire ej_dvastrobe_sync;
wire early_dsync_e;
wire [23:0] /*[23:0]*/ dcc_tagwrdata_raw;
wire fb_fill_mark_dirty;
wire dcache_miss_pc;
wire dcc_intkill_m;
wire rdreq_sync;
wire ev_fbhit_justfilled;
wire held_dsp_lock_hold_hit;
wire early_dstore_write;
wire dcop_ws_valid;
wire ev_exwrreq_val;
wire dcc_ev;
wire [3:0] /*[3:0]*/ hit_sb;
wire [31:0] /*[31:0]*/ storebuff_data_mx;
wire [31:0] /*[31:0]*/ dcc_dcopdata_m;
wire ev_dirty_start_reg;
wire [5:0] /*[5:0]*/ lru_filldata;
wire ev_fbmatch_b;
wire ev_fbhitb_reg;
wire write_thru;
wire imm_load;
wire [3:0] /*[3:0]*/ drepl;
wire [D_BYTES-1:0] /*[8:0]*/ mbdddata_b2;
wire storewrite_e;
wire dstore_m_reg;
wire [5:0] /*[5:0]*/ lru;
wire start_new_access;
wire [19:0] /*[19:0]*/ dcc_dval_m_19_0;
wire [31:0] /*[31:0]*/ dc_datain_1;
wire store_alloc_dis;
wire cop_access_e;
wire ev_wrtag_inv_ws_nopar;
wire [13:0] /*[13:0]*/ dc_wsin_full;
wire imm_store_miss;
wire [3:0] /*[3:0]*/ ill_ways;
wire [3:0] /*[3:0]*/ ws_en_tobe;
wire lkill_fixup_w;
wire dcop_read_reg;
wire wb_reg;
wire dcop_d_write;
wire valid_d_access;
wire [87:0] /*[87:0]*/ tag_cmp_pa88;
wire [13:4] /*[13:4]*/ ev_tagaddr_reg;
wire raw_dcop_read_reg;
wire dstore_presc_m;
wire idx_match_fb_repl_reg;
wire early_dcc_trstb;
wire dcop_d_dc_write;
wire fb_filled_tag;
wire prefnudge_imm;
wire dcop_write;
wire ev_fbhit_reg;
wire wtnwa_st_stall;
wire [31:0] /*[31:0]*/ dcc_exaddr_31_0;
wire [31:0] /*[31:0]*/ dcc_ddata_m;
wire [23:0] /*[23:0]*/ tag_rd_int1;
wire ev_fbhit_sel;
wire dcop_synci;
wire [31:0] /*[31:0]*/ fill_cop_data;
wire ev_fbhit_fill_reg;
wire [3:0] /*[3:0]*/ lsbe_md;
wire dcc_wsrstb;
wire dstore_presc_m_reg;
wire early_advance_m;
wire store_alloc_issue;
wire dcc_advance_m;
wire fb_wb_idx_match_reg;
wire dcc_sc_ack_m;
wire killable_w;
wire [23:0] /*[23:0]*/ dcc_tagwrdata_fb;
wire raw_dsync_m;
wire [31:2] /*[31:2]*/ dcc_pa;
wire raw_dstore_dcopaccess_e;
wire dcc_wswstb;
wire dccop_w;
wire local_fixup_m;
wire [3:0] /*[3:0]*/ store_way_reg;
wire cp1_ldst_m_reg;
wire held_hit;
wire raw_dccop_m;
wire [127:0] /*[127:0]*/ spram_cache_data_nopar;
wire [(`M14K_MAX_DC_ASSOC-1):0] /*[3:0]*/ dcc_tagwren;
wire [31:0] /*[31:0]*/ dcc_exdata;
wire raw_dstore_pre_m;
wire [3:0] /*[3:0]*/ dcop_index_way;
wire [3:0] /*[3:0]*/ storebuff_validbits_mx;
wire cp2_storeissued_m_legit;
wire dcop_lock_write;
wire kick_atomic_write_reg;
wire way_hit;
wire disable_dmiss;
wire ev_dirty_start;
wire [13:0] /*[13:0]*/ dc_wsin_ex;
wire [3:0] /*[3:0]*/ dcc_bytemask;
wire dcc_exsyncreq;
wire [31:24] /*[31:24]*/ sb_fb_data3;
// END Wire declarations made by MVP


        //wires
	wire		dmbinvoke;	
        wire [T_BITS-1:0]      tagmuxout;
        wire [D_BITS-1:0]      datamuxout;

	wire [3:0]	line_sel;	    // Per Line Comp and Valid
	wire 		cache_way_hit;
	wire [3:0]	cache_hit_way;
	wire [3:0] 	valid;
        wire            fill_data_ready;
        wire            fill_done;
        wire            block_hit_fb;
        wire 		hit_fb;
        wire [12:0]     fb_repl_inf_mx;
        wire [12:0]     fb_repl_inf;
        wire [3:0]      fb_taglo;
        wire [19:2]     fill_addr_lo;
        wire [3:0]      repl_wway;
        wire [31:0]     fill_data;
        wire [3:0]      raw_ldfb;
        wire            idx_match_fb;
        wire [31:0]     fb_data;
        wire [23:0]     fill_tag;
        wire            fb_full;            // Both entries in the fill buffer are in use, stall on
        wire 		fb_trans_btof_reg;  //     next load miss/WB store miss/prefetch/
	wire		fb_trans_btof_active_entry;
        wire 		ld_tag_reg;
        wire [3:0] 	fb_fill_way;
        wire 		fb_update_tag;
        wire [3:0] 	dcc_exbe;
        wire 		sb_to_fb_stb;
// verilint 528 off
	wire 		fb_active_entry;
// verilint 528 on
	wire 		fb_trans_btof;
        wire 		wt_nwa;
        wire [12:0]     fb_replinf_init_b;
        wire 		idx_match_fb_b;
        wire 		fb_dirty;
        wire 		fb_dirty_b;

	wire 		enabled_sp_hit, spram_support, spram_hit, dcc_sp_pres;
	
	wire [(D_BITS*`M14K_MAX_DC_ASSOC-1):0] spram_cache_data;
	wire [(T_BITS*`M14K_MAX_DC_ASSOC-1):0] spram_cache_tag;

	wire [3:0]      spram_sel, spram_way;
	wire 		sp_stall;
	wire 	        cache_hit;
	wire [3:0]      block_hit_way;
	wire            raw_dsp_hit;
// verilint 528 off
        wire 	        bus_err_line;
// verilint 528 on
        wire 	        last_word_fill;

	wire [3:0]	mbddwayselect;	
	wire [3:0]	mbtdwayselect;	
	wire [3:0]	mbddbytesel;	
	wire [13:2]     mbddaddr;       
	wire [13:4]	mbtdaddr;	
	wire [13:4]	mbwdaddr;	
	wire 		mbddread;		
	wire		mbtdread;		
	wire 		mbwdread;		
	wire 		mbddwrite;		
	wire 		mbtdwrite;		
	wire 		mbwdwrite;		
	wire [D_BITS-1:0] 	mbdddata;	
	wire [T_BITS-1:0] 	mbtddata;	
	wire [13:0] 		mbwddata;	
	
	wire [3:0]		dcc_data_par;
	wire			sp_read_m;
	wire [3:0]		mbddpar;
	wire [3:0]		mbdsppar;
	wire			mbtdtag_p_reg;
	wire			exaddr_sel_disable;
	wire			held_parerr_m;
	wire			DSP_DataRdStr_reg;
	wire			dspram_par_present;

	wire	[20:12]		dsp_size;
	wire			dspmbinvoke;
	wire	[31:0]		dsp_data_raw;
	wire	[3:0]		mbdspbytesel;
	wire	[19:2]		mbdspaddr;
	wire			mbdspread;
	wire			mbdspwrite;
	wire	[D_BITS-1:0]	mbdspdata;

	wire			dsp_lock_start;
	wire			raw_dsp_hit_raw;


`ifdef M14K_DCC_SCAN_RAM_RWCTL
	wire scan_mb_drstb 	= (mbddread & ~gscanmode) | (~gscanramwr & gscanmode);
	wire scan_mb_wsrstb 	= (mbwdread & ~gscanmode) | (~gscanramwr & gscanmode);
	wire scan_mb_trstb 	= (mbtdread & ~gscanmode) | (~gscanramwr & gscanmode);
	wire scan_mb_dwstb 	= (mbddwrite & ~gscanmode) | (gscanramwr & gscanmode);
	wire scan_mb_wswstb 	= (mbwdwrite & ~gscanmode) | (gscanramwr & gscanmode);
	wire scan_mb_twstb 	= (mbtdwrite & ~gscanmode) | (gscanramwr & gscanmode);
	wire scan_mb_spwstb 	= (mbdspwrite & ~gscanmode) | (gscanramwr & gscanmode);
	wire scan_mb_stb_ctl 	= dmbinvoke | gscanmode;
	wire scan_dspmb_stb_ctl = dspmbinvoke | gscanmode;
`else
	wire scan_mb_drstb 	= mbddread;
	wire scan_mb_wsrstb 	= mbwdread;
	wire scan_mb_trstb 	= mbtdread;
	wire scan_mb_dwstb 	= mbddwrite;
	wire scan_mb_wswstb 	= mbwdwrite;
	wire scan_mb_twstb 	= mbtdwrite;
	wire scan_mb_spwstb 	= mbdspwrite; 
	wire scan_mb_stb_ctl 	= dmbinvoke;
	wire scan_dspmb_stb_ctl = dspmbinvoke;
`endif

`ifdef M14K_DCC_SCAN_RAM_ADDRCTL
	wire [13:2] scan_mb_ddaddr 	= mbddaddr & {12{~gscanmode}};
	wire [13:4] scan_mb_tdaddr 	= mbtdaddr & {10{~gscanmode}};
	wire [13:4] scan_mb_wdaddr 	= mbwdaddr & {10{~gscanmode}};
	wire [19:2] scan_mb_dspaddr 	= mbdspaddr & {18{~gscanmode}};
	wire scan_mb_addr_ctl 		= dmbinvoke | gscanmode;

`ifdef M14K_DCC_SCAN_OBSERVE_FLOPS
	wire [`M14K_DCCSC_MAX:0] dccscancov_bus;   
	wire [`M14K_DCCSC_MAX:0] dccscancov;   
   
	mvp_ucregister_wide #(`M14K_DCCSC_MAX+1) _dccscancov_(dccscancov[`M14K_DCCSC_MAX:0],
							     gscanenable, gscanmode, gclk, 
							     dccscancov_bus);
	assign dccscancov_bus[`M14K_DCCSC_EVDVADDR] = ev_dval_addr[13:4];
	assign dccscancov_bus[`M14K_DCCSC_STOREADDR] = storebuff_idx_mx_munge;
`endif

`else
	wire [13:2] scan_mb_ddaddr 	= mbddaddr;
	wire [13:4] scan_mb_tdaddr 	= mbtdaddr;
	wire [13:4] scan_mb_wdaddr 	= mbwdaddr;
	wire [19:2] scan_mb_dspaddr 	= mbdspaddr;
	wire scan_mb_addr_ctl 		= dmbinvoke;
`endif


// 
   
//VCS coverage off
   
   //verilint 550 off	Mux is inferred: case (1'b1)
   //verilint 226 off 	Case-select expression is constant
   //verilint 225 off 	Case expression is not constant
   //verilint 180 off 	Zero extension of extra bits
   //verilint 528 off 	Variable set but not used
   // Generate a text description of state and next state for debugging
	assign dcc_dataaddr_13_0[13:0] = {dcc_dataaddr[13:2], 2'b0};
	assign dcc_exaddr_31_0[31:0] = {dcc_exaddr[31:2], 2'b0};
	assign dcc_exaddr_ev_31_0[31:0] = {dcc_exaddr_ev[31:2], 2'b0};
	assign dcc_wsaddr_13_0[13:0] = {dcc_wsaddr[13:4], 4'b0};
	assign dcc_tagaddr_13_0[13:0] = {dcc_tagaddr[13:4], 4'b0};
	assign fill_addr_lo_19_0[19:0] = {fill_addr_lo[19:2], 2'b0};
	assign mmu_dpah_31_0[31:0] = {mmu_dpah[31:10], 10'b0};
	assign dcc_dval_m_19_0[19:0] = {dcc_dval_m[19:2], 2'b0};
	assign spram_cache_data_df[D_BITS*4:D_BITS*`M14K_MAX_DC_ASSOC] = {D_BITS*(4-`M14K_MAX_DC_ASSOC)+1{1'b0}};
	assign spram_cache_data_lf[D_BITS*4:0] = {spram_cache_data_df, spram_cache_data};
	assign spram_cache_data_nopar[127:0] = {
		(`M14K_MAX_DC_ASSOC == 4) ? spram_cache_data_lf[3*D_BITS+31:3*D_BITS] : 32'b0,
		(`M14K_MAX_DC_ASSOC >= 3) ? spram_cache_data_lf[2*D_BITS+31:2*D_BITS] : 32'b0,
		(`M14K_MAX_DC_ASSOC >= 2) ? spram_cache_data_lf[D_BITS+31:D_BITS] : 32'b0,
		(`M14K_MAX_DC_ASSOC >= 1) ? spram_cache_data_lf[31:0] : 32'b0 };
	assign dc_datain_0[31:0] = spram_cache_data_nopar[31:0];
	assign dc_datain_1[31:0] = spram_cache_data_nopar[63:32];
	assign dc_datain_2[31:0] = spram_cache_data_nopar[95:64];
	assign dc_datain_3[31:0] = spram_cache_data_nopar[127:96];
   //verilint 550 on	Mux is inferred: case (1'b1)
   //verilint 226 on 	Case-select expression is constant
   //verilint 225 on 	Case expression is not constant
   //verilint 180 on 	Zero extension of extra bits
   //verilint 528 on 	Variable set but not used
    // else MIPS_ACCELERATION_BUILD
  //VCS coverage on  
  
// 


	assign dcc_pm_fbfull = fb_full;

        // CacheMode bits
        assign dcached = ~mmu_dcmode[0];
	assign dcc_dcached_m = dcached;
        assign dmagicl = dcached ? 1'b0 : mmu_dcmode[1];

        // Cache Modes - wt_nwa = WriteThru (no write allocate)
        //               wt_wa = WriteThru (write allocate)
        //               wb = WriteBack (write allocate)
        // (if no cache exists, wb and wt_wa become wt_nwa).
        assign wt_nwa = mmu_dcmode[2] | force_wt;
        assign wt_wa = (~wt_nwa & dcached & mmu_dcmode[1]);
        assign wb = dcached & ~wt_nwa & ~wt_wa;

        assign dcc_wb = wb & dcc_exwrreqval ; //write-back transaction. each transaction is held for 1 cycle.

        mvp_register #(1) _wb_reg(wb_reg, gclk, wb);

        // force cache mode to WT-NWA if there is no cache.
        assign force_wt = ~cpz_dcpresent | wb_noavail_reg;   

	mvp_cregister #(1) _raw_dccop_m(raw_dccop_m,advance_m, gclk, (|mpc_busty_e) & ~(pre_ev_way_on & ~ev_cancel));
	assign dccop_m = dcc_fixup_w ? dccop_m_reg : raw_dccop_m;
	mvp_register #(1) _dccop_m_reg(dccop_m_reg, gclk, dccop_m);

	assign dccop_w_ev_tmp = (mpc_run_m | mpc_lsdc1_w & cp1_seen_nodmiss_m & cp1_fixup_w & valid_d_access) ? 
		(dccop_m & ~greset & ~killmiss_m & ~par_kill_m) : dccop_w_ev;
	mvp_register #(1) _dccop_w_ev(dccop_w_ev, gclk, dccop_w_ev_tmp & ~(advance_m & ~(pre_ev_way_on & ~ev_cancel) & ~held_dtmack));

	mvp_register #(1) _dccop_w(dccop_w, gclk, ((mpc_run_m | mpc_lsdc1_w & cp1_seen_nodmiss_m & cp1_fixup_w & valid_d_access) ? 
		(dccop_m & ~greset & ~killmiss_m & ~par_kill_m) : dccop_w & ~held_dcc_parerr_w) & 
		~(advance_m & ~held_dtmack));
	
	assign dcc_fixup_w = dccop_w & dcc_dmiss_m_ev_reg;

	mvp_register #(1) _dcc_dmiss_m_ev_reg(dcc_dmiss_m_ev_reg, gclk, (dcc_ev & ~(ev_cancel | ev_wrtag_inv_ws | ev_wrtag_inv_ws_nopar)) | dcc_dmiss_m);

	mvp_register #(1) _stalled_m(stalled_m, gclk, dccop_m & ~mpc_run_m & ~dcc_fixup_w);

	assign local_fixup_m = dcc_fixup_w | stalled_m;
	
 	assign bypass_d = ((biu_ddataval & ~fb_full) | (pref_m & (rd_req_enable_next | rd_req_enable)) |
		    fb_trans_btof_reg | ev_wrtag_inv_ws | ev_wrtag_inv_ws_nopar | fb_wb_end);     

        // Load/Store in e-stage can access cache
	assign start_new_access = ((mpc_run_m | held_dtmack) | (~valid_d_access & ~pref_m & 
							   ~early_stall & ~ev_noadv | bypass_d));

	mvp_register #(1) _dcc_newdaddr(dcc_newdaddr, gclk, advance_mmu_m & (|mpc_busty_e & ~(mpc_idx_cop_e & mpc_busty_e[2] & ^mpc_busty_e[1:0]) 
		& ~(pre_ev_way_on & ~ev_cancel)));

	// Do not restrobe newdaddr on uTLB misses.  
	assign advance_mmu_m = (mpc_run_m | dcc_fixup_w | (restart & !sp_stall)) &
		    ~dcc_dmiss_m;
	
	assign advance_m = (mpc_run_m | dcc_fixup_w | ((restart | held_dtmack) & !sp_stall)) & ~dcc_dmiss_m;
	assign dcc_advance_m = advance_m;
	mvp_register #(1) _advance_m_reg(advance_m_reg, gclk, advance_m);

	// If there is a spram stall and a dtlb miss - wait for the spram stall to go
	// away, then reaccess the cache/spram (getting new address)
	assign held_dtmack = mmu_dtmack_m | hold_dtmack;
	mvp_register #(1) _hold_dtmack(hold_dtmack, gclk, held_dtmack & sp_stall);

        assign dcc_dspram_stall = sp_stall;

	assign restart = ev_wrtag_inv_ws | ev_wrtag_inv_ws_nopar | fb_wb_end | hold_restart;
	mvp_register #(1) _hold_restart(hold_restart, gclk, restart & sp_stall);
	
        // Raw signals are used to set up next transaction
        // dcc_dmiss_m & ~mpc_exc_e come in late and prevents anything from happening	
	assign fxexc_e = mpc_run_m ? mpc_exc_e : fxexc_e_reg | mpc_exc_m;
	mvp_register #(1) _fxexc_e_reg(fxexc_e_reg, gclk, fxexc_e);
	
	assign raw_cacheread_e = start_new_access & ~(mpc_busty_raw_e[2]) & (mpc_busty_raw_e[1] | mpc_busty_raw_e[0]) & ~(mpc_busty_raw_e[1] & (spram_hit_atomic_ld_raw | spram_hit_in_atomic_hold));
	assign cacheread_e = raw_cacheread_e & advance_m & ~fxexc_e & ~(mpc_lsdc1_w & hit_fb & biu_ddataval & sp_stall);

	assign lscacheread_e = start_new_access & (mpc_busty_raw_e==3'b001 || mpc_busty_raw_e==3'b010) & advance_m & ~fxexc_e;

	assign raw_cacheread_e_pc = start_new_access & ~(mpc_busty_raw_e[2]) & (mpc_busty_raw_e[1] & ~mpc_busty_raw_e[0] | ~mpc_busty_raw_e[1] & mpc_busty_raw_e[0]);
	assign cacheread_e_pc = raw_cacheread_e_pc & advance_m & ~fxexc_e;
	
        // prefetches flush store buffer, so they are included here, but killed in dstore_m
        assign raw_dstore_e = ((mpc_busty_raw_e == 3'h2) | (mpc_busty_raw_e == 3'h3)) & start_new_access;   
	assign dstore_e = raw_dstore_e & advance_m & ~fxexc_e;      

        // fill cache from fill buffer
	assign cachewrite_e = ~(raw_cacheread_e | kick_atomic_write | (mpc_busty_raw_e[1] & (spram_hit_atomic_ld_raw | spram_hit_in_atomic_hold)) |raw_dcop_access_e | raw_dsync_e | sp_stall |
			  (ev_stall_nofill & ~ev_fbhit_reg)) & fill_data_ready;

        // fill cache from store buffer (preempted by fill from fill buffer)
        assign storewrite_e = ~(fill_data_ready | dcop_access_m) &
		       (mpc_busty_raw_e == 3'h0);
        // valid signal for sb fill. sb data fillable (opportunistically) 2 cycles after store's e-stage.

        assign storebuff_valid = |(sb_valid_bits[3:0]) & ~storewrite_m & ~raw_dstore_m & ~kick_atomic_write_reg;   
   
	assign raw_dcop_access_e = start_new_access & (mpc_busty_raw_e == 3'h6 | mpc_busty_raw_e == 3'h7);
	assign dcop_access_e = raw_dcop_access_e & advance_m & ~fxexc_e;

	assign cop_access_e = advance_m & (mpc_busty_e == 3'h6 | mpc_busty_e == 3'h5 | mpc_busty_e == 3'h7);

        // edp_dva_e is flopped for EJTAG, so it is valid during M-stage
	assign dcc_stdstrobe = (~cp2_fixup_m & ~cp2_storeissued_m & ~dcc_ldst_m & dcc_dvastrobe) |
			(cp2_datasel_real & ~cp2_fixup_w);
	
	assign dcc_dvastrobe = ~(cp2_fixup_w | cp1_fixup_w | dcc_fixup_w) & (((cacheread_m | kick_atomic_write) & (valid_d_access | dstore_presc_m)) |
				      ej_dvastrobe_sync);

	mvp_register #(1) _ej_dvastrobe_sync(ej_dvastrobe_sync, gclk, ((cacheread_m | kick_atomic_write) & (valid_d_access | dstore_presc_m)
					   & ~mpc_run_m) | (ej_dvastrobe_sync & ~mpc_run_m));
	mvp_cregister #(1) _pdva_load(pdva_load,mpc_run_w, gclk, dcc_dvastrobe & dcc_ldst_m & ejt_stall_st_e); 

	mvp_cregister #(1) _killedmiss_w(killedmiss_w,mpc_run_m | dcc_fixup_w, gclk, killmiss_m);

	// Do not strobe data if the load was killed by another exception
	assign dcc_lddatastr_w   = mpc_sbstrobe_w & pdva_load & ~killedmiss_w & ~dcc_precisedbe_w;

        // Data R/W: 0-store, 1-load
        // Make sure the the value is saved when ej_dvastrobe_sync is asserted
	assign dcc_ldst_m = ej_dvastrobe_sync ? ej_loadstore_md : ~dstore_presc_m;
	mvp_register #(1) _ej_loadstore_md(ej_loadstore_md, gclk, dcc_ldst_m);

	mvp_cregister_wide #(18) _dcc_dval_m_19_2_(dcc_dval_m[19:2],gscanenable, advance_m, gclk, edp_dval_e[19:2]);

        // Tag Index: 
        // mux dval, eviction index
        assign ev_dval_addr[19:14] = dcc_dval_m[19:14];
        mvp_mux2 #(10) _ev_dval_addr_13_4_(ev_dval_addr[13:4],ev_dirtyway | ev_wrtag_inv, dcc_dval_m[13:4], ev_tagaddr_reg[13:4]);
        assign ev_dval_addr[3:2] = dcc_dval_m[3:2];

        // mux in fill buffer index
        mvp_mux2 #(18) _dcc_tagaddrint_19_2_(dcc_tagaddrint[19:2],raw_cacheread_e & ~(ev_dirtyway | ev_wrtag_inv) & ~scan_mb_addr_ctl,
				    (scan_mb_addr_ctl ? {6'd0, scan_mb_tdaddr, 2'd0} : ev_dval_addr[19:2]),
				    edp_dval_e[19:2]);

	mvp_mux2 #(18) _dcc_tagaddr_nomunge_19_2_(dcc_tagaddr_nomunge[19:2],cachewrite_e & ~scan_mb_addr_ctl,
					  dcc_tagaddrint[19:2], fill_addr_lo[19:2]); 

	assign index_mask[13:0] = {(cpz_dcnsets[2:0] > 3'h3),              // > 8K/way
			   (cpz_dcnsets[2:0] > 3'h2),               // > 4K/way
			   (cpz_dcnsets[2:0] > 3'h1),               // > 2K/way
			   (cpz_dcnsets[2:0] > 3'h0),               // > 1K/way
			   {10{1'b1}}};

	// Based on cache size, mask the upper address bits
	assign dcc_tagaddr [13:4] = dcc_tagaddr_nomunge[13:4] & index_mask[13:4];   

	assign dc_tagaddr_l [3:2] = dcc_tagaddr_nomunge[3:2];

	assign dcc_trstb = (cacheread_e & ~scan_mb_stb_ctl) |
		    (dcop_read & ~scan_mb_stb_ctl) |
		    (ev_dirtyway & ~scan_mb_stb_ctl) |
		    scan_mb_trstb;

        // Data Index:
	// Base on cache size, mask the upper address bits
	assign storebuff_idx_mx_munge [13:2] = storebuff_idx_mx[13:2] & index_mask[13:2];

        // mux store buffer index, and eviction index
        mvp_mux2 #(12) _ev_store_addr_13_2_(ev_store_addr[13:2],(ev_dirtyway_reg | scan_mb_addr_ctl), storebuff_idx_mx_munge[13:2], 
				    (scan_mb_addr_ctl ? scan_mb_ddaddr[13:2] : ev_dataaddr[13:2]));

        mvp_mux2 #(12) _dcc_dataaddr_13_2_(dcc_dataaddr[13:2],(raw_dstore_e | storewrite_e | kick_atomic_write | raw_dcop_access_e | 
				    raw_dsync_e | ev_dirtyway_reg | scan_mb_addr_ctl),
				   {dcc_tagaddr,dc_tagaddr_l},  ev_store_addr[13:2]);   

   	// Only need to access the data array on loads and cacheops
        assign dcc_drstb = (cacheread_e & (mpc_busty_raw_e == 3'h1) & ~scan_mb_stb_ctl) |
		    (dcop_read & ~scan_mb_stb_ctl) |
		    (ev_dirtyway_reg & ~scan_mb_stb_ctl) |
		    scan_mb_drstb;

	assign dcc_twstb = (cachewrite_e & fb_update_tag & ~scan_mb_stb_ctl) |
		    (dcop_write & ~scan_mb_stb_ctl) |
		    (ev_wrtag_inv & ~dcc_parerr_w & ~scan_mb_stb_ctl) |
		    scan_mb_twstb;

	assign dcc_dwstb = (cachewrite_e & ~scan_mb_stb_ctl) | 
		    (dcop_access_e & ~scan_mb_stb_ctl) | 
		    (dsync_e & ~scan_mb_stb_ctl) | 
		    (dcop_d_dc_write & ~scan_mb_stb_ctl) |
		    (advance_m & dstore_write & ~scan_mb_stb_ctl) |
		    scan_mb_dwstb;

	assign dcc_spwstb = (dcop_access_e & ~scan_mb_stb_ctl) | 
		     (dsync_e & ~scan_mb_stb_ctl) | 
		     (dcop_d_dsp_write & ~scan_mb_stb_ctl) |
		     ((advance_m & dstore_write) & ~scan_mb_stb_ctl) | 
		     (kick_atomic_write & dstore_m & ~scan_mb_stb_ctl) |
		     scan_mb_spwstb;

        assign dstore_write = (dstore_e & (dstore_m | storebuff_valid)) |
		       (storewrite_e & storebuff_valid);

        mvp_register #(1) _storewrite_m(storewrite_m, gclk, advance_m & storebuff_valid & storewrite_e);

        assign raw_dstore_dcopaccess_e = mpc_busty_raw_e[1] & start_new_access;	// mpc_busty_raw_e == 2,3,6,7
	mvp_mux2 #(4) _dcc_bytemask_3_0_(dcc_bytemask[3:0],(raw_dstore_dcopaccess_e | storewrite_e | kick_atomic_write | raw_dsync_e) & ~dmbinvoke,
				  (dmbinvoke ? mbddbytesel : 4'hf), storebuff_validbits_mx[3:0]);   

        // bist / dcop  muxes
        mvp_mux2 #(4) _dbist_dcop_way_3_0_(dbist_dcop_way[3:0],dmbinvoke, dcop_wway, mbddwayselect);
        mvp_mux2 #(4) _tbist_dcop_way_3_0_(tbist_dcop_way[3:0],dmbinvoke, dcop_wway, mbtdwayselect);   

        // cache write (fill) and eviction
        mvp_mux2 #(4) _ev_repl_way_3_0_(ev_repl_way[3:0],ev_wrtag_inv, repl_wway[3:0], (ev_wrtag_inv_msk[3:0] & ~{4{ev_wrtag_noinv}}));

        // store_way (late signal) and bist/dcop
        mvp_mux2 #(4) _ev_fill_dbist_dcop_way_3_0_(ev_fill_dbist_dcop_way[3:0],dcop_mux_sel | dmbinvoke, 
					   ev_repl_way[3:0], dbist_dcop_way[3:0]);
        mvp_mux2 #(4) _ev_fill_tbist_dcop_way_3_0_(ev_fill_tbist_dcop_way[3:0],dcop_mux_sel | dmbinvoke, 
					   ev_repl_way[3:0], tbist_dcop_way[3:0]);

        assign dcop_mux_sel = dcop_access_m & dcop_ready & ~dcop_done & ~ev_wrtag_inv;
   
        // last wren muxes (cachewrite_e and store_way are late signals)
	mvp_mux2 #(4) _dcc_wway_3_0_(dcc_wway[3:0],cachewrite_e | ev_wrtag_inv | dcop_mux_sel | dmbinvoke, 
			      store_way[3:0], ev_fill_dbist_dcop_way[3:0]);
   
	mvp_mux2 #(4) _dcc_tagwren4_3_0_(dcc_tagwren4[3:0],cachewrite_e | ev_wrtag_inv | dcop_mux_sel | dmbinvoke, 
				  store_way[3:0], ev_fill_tbist_dcop_way[3:0]);      

	assign dcc_tagwren[(`M14K_MAX_DC_ASSOC-1):0] = dcc_tagwren4[(`M14K_MAX_DC_ASSOC-1):0];

	assign dcc_writemask16 [15:0] = { {4{dcc_wway[3]}} & dcc_bytemask,
				   {4{dcc_wway[2]}} & dcc_bytemask,
				   {4{dcc_wway[1]}} & dcc_bytemask,
				   {4{dcc_wway[0]}} & dcc_bytemask };

	assign dcc_writemask [(4*`M14K_MAX_DC_ASSOC-1):0] = dcc_writemask16[(4*`M14K_MAX_DC_ASSOC-1):0];

	mvp_mux2 #(32) _dcc_data_raw_31_0_(dcc_data_raw[31:0],(cachewrite_e | dcop_access_m), storebuff_data_mx[31:0],(fill_cop_data[31:0]));

	mvp_mux2 #(32) _fill_cop_data_31_0_(fill_cop_data[31:0],fill_done, fill_data[31:0], cpz_datalo);

        mvp_mux2 #(24) _dcc_tagwrdata_fb_23_0_(dcc_tagwrdata_fb[23:0],(dcop_access_m & dcop_ready & ~dmbinvoke), 
					(dmbinvoke ? mbtddata[23:0] : fill_tag), dcop_tag);

	assign dcc_tagwrdata_raw [23:1] = dcc_tagwrdata_fb[23:1];
	assign dcc_tagwrdata_raw [0] = dcc_tagwrdata_fb[0] & ~ev_wrtag_inv; // invalidate line after eviction

	assign dcc_pa [31:2]  = {mmu_dpah, dcc_dval_m[`M14K_PALHI:2]};
	assign dcc_tagcmpdata [31:10]  = dcc_pa[31:10];

	`M14K_DSPRAM_MODULE #(PARITY) spram(
				 .DSP_DataAddr(DSP_DataAddr),
				 .DSP_DataWrValue(DSP_DataWrValue),
				 .DSP_DataWrMask(DSP_DataWrMask),
				 .DSP_DataRdValue(DSP_DataRdValue),
				 .DSP_DataRdStr(DSP_DataRdStr),
				 .DSP_DataWrStr(DSP_DataWrStr),
				 .DSP_Lock(DSP_Lock),
				 .dsp_lock_start(dsp_lock_start),
				 .dsp_lock_present(dsp_lock_present),
				 .DSP_Hit(DSP_Hit),
				 .DSP_Present(DSP_Present),
				 .DSP_Stall(DSP_Stall),
				 .DSP_TagAddr(DSP_TagAddr),
				 .DSP_TagCmpValue(DSP_TagCmpValue),
				 .DSP_TagRdStr(DSP_TagRdStr),
				 .DSP_TagRdValue(DSP_TagRdValue),
				 .DSP_TagWrStr(DSP_TagWrStr),
				 .advance_m(advance_m),
				 .block_hit_way(block_hit_way),
				 .cache_hit_way(cache_hit_way),
				 .cacheread_e(cacheread_e),
				 .cacheread_m(cacheread_m),
				 .gclk( gclk),
				 .gscanenable(gscanenable),
                                 .gscanmode(gscanmode),
				 .dc_datain(dc_datain),
				 .dcc_dataaddr(dcc_dataaddr[9:2]),
				 .dc_tagin(dc_tagin),
				 .dcached(dcached),
				 .dcc_data_raw(dcc_data_raw),
				 .dcc_spwstb(dcc_spwstb),
				 .dcc_sp_pres(dcc_sp_pres),
				 .dcc_tagcmpdata(dcc_tagcmpdata),
				 .dcc_tagwrdata(dcc_tagwrdata),
				 .dcc_tagwren4(dcc_tagwren4),
				 .dcc_twstb(dcc_twstb),
				 .dcc_writemask16(dcc_writemask16),
				 .dcop_read(dcop_read),
				 .dcop_access_m(dcop_access_m),
				 .dcop_ready(dcop_ready),
				 .dcop_tag(dcop_tag),
				 .dmbinvoke(dmbinvoke),
				 .edp_dval_e(edp_dval_e[19:2]),
				 .dcc_dval_m(dcc_dval_m[19:2]),
				 .enabled_sp_hit(enabled_sp_hit),
				 .ev_dirtyway(ev_dirtyway),
				 .ev_wrtag_inv(ev_wrtag_inv),
				 .greset(greset),
				 .mpc_busty_raw_e(mpc_busty_raw_e),
				 .pref_m(pref_m),
				 .raw_cacheread_e(raw_cacheread_e),
				 .mpc_atomic_load_e(mpc_atomic_load_e),
				 .raw_dcop_access_e(raw_dcop_access_e),
				 .raw_dsp_hit(raw_dsp_hit_raw),
				 .raw_dstore_e(raw_dstore_e),
				 .storewrite_e(storewrite_e),
				 .raw_dsync_e(raw_dsync_e),
				 .sp_stall(sp_stall),
				 .spram_cache_data(spram_cache_data),
				 .spram_cache_tag(spram_cache_tag),
				 .spram_hit(spram_hit),
				 .spram_sel(spram_sel),
				 .spram_support(spram_support),
				 .spram_way(spram_way),
				 .store_m(store_m),
				 .storebuff_idx_mx(storebuff_idx_mx[19:10]),
				 .use_idx(use_idx),
				 .valid_d_access(valid_d_access),
				 .sp_read_m(sp_read_m),
				 .dcc_data_par(dcc_data_par),
				 .DSP_ParityEn(DSP_ParityEn),
				 .DSP_WPar(DSP_WPar),
				 .DSP_ParPresent(DSP_ParPresent),
				 .DSP_RPar(DSP_RPar),
				 .cpz_pe(cpz_pe),
				 .DSP_DataRdStr_reg(DSP_DataRdStr_reg),
				 .dspram_par_present(dspram_par_present),
				 .dspmbinvoke(dspmbinvoke),
				 .dsp_size(dsp_size),
				 .dsp_data_raw(dsp_data_raw),
				 .mbdspbytesel(mbdspbytesel),
				 .scan_mb_dspaddr(scan_mb_dspaddr),
				 .mbdspread(mbdspread),
				 .scan_dspmb_stb_ctl(scan_dspmb_stb_ctl),
				 .gscanramwr(gscanramwr),
				 .mbdspdata(mbdspdata)
				);
 	
	
        mvp_register #(1) _cacheread_m(cacheread_m, gclk, cacheread_e);      
	mvp_register #(1) _dcc_lscacheread_m(dcc_lscacheread_m, gclk, lscacheread_e);

	mvp_register #(1) _cacheread_m_pc(cacheread_m_pc, gclk, cacheread_e_pc);

   	mvp_register #(1) _cachewrite_m(cachewrite_m, gclk, cachewrite_e);
	
	mvp_register #(1) _raw_dcop_access_m(raw_dcop_access_m, gclk, dcop_access_e);

	assign dcc_dcopaccess_m = dcop_access_m;
	assign dcop_access_m = local_fixup_m ? dcop_access_m_reg : raw_dcop_access_m;
	mvp_register #(1) _dcop_access_m_reg(dcop_access_m_reg, gclk, dcop_access_m);
	
        // kill store conditional if llbit not set
	mvp_register #(1) _kill_sc_m(kill_sc_m, gclk, mpc_sc_e & ~(cpz_gm_e ? cpz_g_llbit : cpz_llbit));
	assign dcc_sc_ack_m = ~kill_sc_m;

        mvp_register #(1) _raw_dstore_pre_m(raw_dstore_pre_m, gclk, dstore_e & (cp2_fixup_m_real | ~(pre_ev_way_on & ~ev_cancel)));
        assign raw_dstore_presc_m = raw_dstore_pre_m & ~prefetch;   
        assign raw_dstore_m = raw_dstore_presc_m & ~kill_sc_m;

        // store in m-stage
        // prevent sc kill from ejt match
        assign dstore_presc_m = (local_fixup_m | fb_wb_idx_match_reg) ? dstore_presc_m_reg : raw_dstore_presc_m;
	mvp_register #(1) _dstore_presc_m_reg(dstore_presc_m_reg, gclk, dstore_presc_m);
        assign dstore_m = (local_fixup_m | fb_wb_idx_match_reg) ? dstore_m_reg : raw_dstore_m;
	mvp_register #(1) _dstore_m_reg(dstore_m_reg, gclk, dstore_m);

        /////   
        // CP2 control signals
        ////		       
        mvp_cregister #(1) _cp2_fixup_m_legit(cp2_fixup_m_legit,cp2_tag_reg | ~cp2_fixup_m, gclk, cp2_tag_reg & cp2_fixup_m & ~cp2_not_legit);
        assign cp2_fixup_m_real = cp2_fixup_m & (cp2_tag_reg | cp2_fixup_m_legit);

        mvp_cregister #(1) _cp2_storeissued_m_legit(cp2_storeissued_m_legit,cp2_tag_reg | cp2_fixup_m_legit | ~cp2_storeissued_m | cp2_datasel, gclk, 
					    (cp2_tag_reg | cp2_fixup_m_legit) & cp2_storeissued_m & ~cp2_datasel & 
					    ~cp2_not_legit);
        assign cp2_storeissued_m_real = cp2_storeissued_m & ~cp2_datasel &
				 (cp2_tag_reg | cp2_fixup_m_legit | cp2_storeissued_m_legit);

	mvp_register #(1) _cp2_tag_reg(cp2_tag_reg, gclk,  dcc_trstb & ~(dccop_w_ev_tmp & pre_ev_way_on & ~ev_cancel));
        assign cp2_not_legit = fb_wb_idx_match | held_dtmack;

        mvp_cregister #(1) _cp2_missexc_w_legit(cp2_missexc_w_legit,cp2_ldst_m_reg | ~cp2_missexc_w, gclk, cp2_ldst_m_reg & cp2_missexc_w);
        assign cp2_missexc_w_real = cp2_missexc_w & (cp2_ldst_m_reg | cp2_missexc_w_legit);
   
        mvp_register #(1) _cp2_ldst_m_reg(cp2_ldst_m_reg, gclk, cp2_ldst_m);

        assign cp2_storekill_w_real = cp2_storekill_w & cp2_datasel_legit;   

        mvp_cregister #(1) _cp2_datasel_legit(cp2_datasel_legit,cp2_storeissued_m_legit | cp2_tag_reg | ~cp2_datasel, gclk, cp2_datasel & ~cp2_not_legit);
        assign cp2_datasel_real = cp2_datasel & (cp2_tag_reg | cp2_storeissued_m_legit | cp2_datasel_legit);

        assign cp2_store_stall = (cp2_storeissued_m_real & dstore_m & ~cp2_storekill_w_real & ~held_dtmack) | 
			  (cp2_datasel_real & cp2_fixup_w);   

        /////   
        // CP1 control signals
        ////		       
        mvp_cregister #(1) _cp1_missexc_w_legit(cp1_missexc_w_legit,cp1_ldst_m_reg | ~cp1_missexc_w, gclk, cp1_ldst_m_reg & cp1_missexc_w);
        assign cp1_missexc_w_real = cp1_missexc_w & (cp1_ldst_m_reg | cp1_missexc_w_legit);
   
        mvp_register #(1) _cp1_ldst_m_reg(cp1_ldst_m_reg, gclk, cp1_ldst_m);
        // CacheOp control:
        // CacheOpType: 0 - Index Invalidate, 1- Index Load Tag, 2- Index Store Tag, 3- Reserved
        //	        4 - Hit Invalidate,   5- Hit Invalidate WB, 6- Hit WB, 7- Fetch & Lock
	//              15 - SYNCI
        // cpz_wst: 0 - normal
        //          1 - Index LdTag/StTag go to WS array, Index StData enabled - Other $ops work like NOP 
        // cpz_spram: 0 - normal
        //            1 - Indexed ops (inc. StData) go to SPRAM - Other $ops work like NOP 
  
	assign dcop_idx_inval = (mpc_coptype_m == 4'h0) && ~(cpz_spram | cpz_wst);

	assign dcop_idx_ld = (mpc_coptype_m == 4'h1);

	assign dcop_idx_stt = (mpc_coptype_m == 4'h2) & (~cpz_wst | cpz_spram);

	assign dcop_idx_stw = (mpc_coptype_m == 4'h2) & (cpz_wst & ~cpz_spram);

	assign dcop_idx_std_dc = (mpc_coptype_m == 4'h3) & cpz_wst & ~cpz_spram;
	assign dcop_idx_std_dsp = (mpc_coptype_m == 4'h3) & cpz_spram; //qualifier mpc_dcop_m 

	assign dcop_hit_inval = (mpc_coptype_m == 4'h4) & dcached;

        assign dcop_hit_inval_wb = (mpc_coptype_m == 4'h5) & dcached;

	assign dcop_nop = ((mpc_coptype_m == 4'h3) & ~(cpz_wst | cpz_spram)) |
		   ((mpc_coptype_m == 4'h0) & (cpz_wst | cpz_spram)) |
		   (mpc_coptype_m[2] & ~dcached);

        assign dcop_hit_wb = (mpc_coptype_m == 4'h6 | dcop_synci) & dcached;

        assign dcop_synci = (mpc_coptype_m == 4'hf);

	assign dcop_fandl = (mpc_coptype_m == 4'h7) & dcached;

	assign dcop_indexed = ~(mpc_coptype_m[2]);

	mvp_register #(1) _dcc_copsync_m(dcc_copsync_m, gclk, cop_access_e | (dcc_copsync_m & ~(biu_dreqsdone & ~dcc_exsyncreq)));

	assign dcop_read = dcop_access_m & dcop_ready & ~raw_dcop_read_reg & ~dcop_done & ~dcop_read_wait &
		    (dcop_idx_ld | dcop_idx_inval | dcop_hit_inval | dcop_hit_inval_wb | dcop_hit_wb |
		     (dcop_fandl & ~dcop_read_reg_reg & ~dcop_fill_pending));

	mvp_register #(1) _raw_dcop_read_reg(raw_dcop_read_reg, gclk, dcop_read | (raw_dcop_read_reg & sp_stall));
	assign dcop_read_reg = raw_dcop_read_reg & ~sp_stall;

	assign dcop_write = dcop_access_m & ~dcop_done & ((dcop_ready & dcop_idx_stt) |
						  (dcop_read_reg_reg & dcop_hit_inval & cache_hit_reg) |
						  (dcop_wrafterws_ev) |
						  (dcop_lock_write));
        mvp_register #(1) _dcop_write_reg(dcop_write_reg, gclk, dcop_write);

	assign dcop_d_write = dcop_d_dc_write | dcop_d_dsp_write;
	assign dcop_d_dc_write = dcop_access_m & ~dcop_done & dcop_ready & dcop_idx_std_dc;
	// this will cause a dsp write strobe. dis qualify on a subsequent stall
	assign dcop_d_dsp_write = dcop_access_m & ~dcop_done & dcop_ready & dcop_idx_std_dsp & ~dcop_d_dsp_write_pend;
	mvp_register #(1) _dcop_d_dsp_write_pend(dcop_d_dsp_write_pend,gclk, dcop_d_dsp_write | dcop_d_dsp_write_pend & sp_stall & ~greset);

        // write the LRU bits of the WS array.
        assign dcop_lru_write = dcop_idx_stw & dcop_access_m & ~dcop_done & dcop_ready_reg;   

        mvp_register #(1) _dcop_ready_reg(dcop_ready_reg, gclk, dcop_ready);



	mvp_register #(1) _dcop_done(dcop_done, gclk, dcop_access_m & dcop_ready & ~dcop_done & 
			     (dcop_nop | dcop_fill_done |	     
			      (dcop_write | dcop_lru_write) |
			      (dcop_d_dc_write) |  
			      (dcop_d_dsp_write_pend & ~sp_stall) | 
			      (dcop_read_reg & dcop_idx_ld) |	 
			      (dcop_evictable & (ev_wrtag_inv || dcc_parerr_cpz_w)) | // wait for eviction to complete
			      (dcop_hit_wb & (dcop_read_reg_reg & ~ev_wait & ~dcop_done || dcc_parerr_cpz_w)) |// done if no evict
			      (dcop_read_reg & dcop_hit_only & ~cache_hit) | 
			      (dcop_done & ~advance_m)));

        // wait for eviction or reading of WS
        assign dcop_read_wait = (dcop_read_reg_reg | ev_way_on_reg | ev_dirtyway_reg | dcop_wrafterws_ev) &
			 (dcop_evictable | dcop_hit_only);

        mvp_register #(1) _dcop_wrafterws_ev(dcop_wrafterws_ev, gclk, dcop_read_reg_reg & dcop_wrafterws & ~ev_wait & ~dcop_done);
   
        assign ev_wait = ev_way_on | ev_dirtyway_reg;

        assign dcop_hit_only = dcop_hit_inval | dcop_hit_inval_wb | dcop_hit_wb;
        assign dcop_evictable = dcop_hit_inval_wb | dcop_hit_wb | dcop_idx_inval;
        assign dcop_wrafterws = dcop_hit_inval_wb | dcop_idx_inval;
   
        // don't invalidate tag, but do clear dirty bit
        assign dcop_hit_noinv = dcop_hit_wb & dcop_access_m & dcop_ready;
        assign dcop_hit_nolru = dcop_hit_noinv & ~dcop_synci;

        // after dcop_hit_wb, don't update lru bits
        mvp_register #(1) _dcop_hit_nolru_reg(dcop_hit_nolru_reg, gclk, dcop_hit_nolru);

        // index invalidate.. use dcop_wway for eviction compare
        assign dcop_idx_inval_ev = dcop_idx_inval & dcop_access_m & dcop_ready;
        
        mvp_register #(1) _cache_hit_reg(cache_hit_reg, gclk, cache_hit | DSP_Hit);

        assign fandl_read = dcop_read_reg & dcop_fandl;
   
	mvp_register #(1) _fandl_read_reg(fandl_read_reg,gclk, fandl_read & !(mpc_exc_w | held_parerr_w));
	//fandl_read_reg = register(gclk, fandl_read);

	mvp_register #(1) _dcop_read_reg_reg(dcop_read_reg_reg, gclk, dcop_read_reg & ~dcop_done);
	
	assign dcop_fill_req = dcop_fill_miss;

        assign dcop_fill_miss = ~cache_hit_reg & fandl_read_reg;

	assign dcop_lock_write = cache_hit_reg & fandl_read_reg;

        // f&l on dirty line, don't remove dirty bit.
        mvp_register #(1) _dcop_lock_write_reg(dcop_lock_write_reg, gclk,dcop_lock_write);

        mvp_register #(1) _dcop_fill_pending(dcop_fill_pending, gclk, dcop_fill_req | dcop_fill_pending & ~(dcop_done | greset));
        assign dcop_fill_done = dcop_fill_pending & (fill_done & ~dcc_exrdreqval);

        // cacheop tag
        //                                 PA[31:10]         Lock         Valid
	assign dcop_tag [23:0] = dcop_idx_stt ? {cpz_taglo[25:4], cpz_taglo[1], cpz_taglo[3]} :
			 {dcc_tagcmpdata[31:10], {2{dcop_fandl}} & {1'b1, 1'b1}};

        // set dirty bit only if valid bit (and dirty bit) is set.   
        assign dcop_idx_writedirty = dcop_write_reg & dcop_idx_stt & cpz_taglo[2] & cpz_taglo[3];

        // doing a index store tag, writing it valid, set LRU bits to MRU
        mvp_register #(1) _dcop_ws_valid(dcop_ws_valid, gclk, cpz_taglo[3] & dcop_idx_stt & dcop_write);
        

	assign dcop_way_sel_bits [1:0] = (cpz_dcnsets==3'h4) ? (dcc_dval_m[15:14])  : // 16kb/way
				  (cpz_dcnsets==3'h3) ? (dcc_dval_m[14:13])  : // 8kb/way
				  (cpz_dcnsets==3'h2) ? (dcc_dval_m[13:12])  : // 4kb/way
				  (cpz_dcnsets==3'h1) ? (dcc_dval_m[12:11])  : // 2kb/way
				  (dcc_dval_m[11:10]); // 1kb/way

	// If assoc < 3, only 1 bit of address should be used to set the way
	// If assoc = 1, 0 bits should be used (only access way 0)
	assign dcop_mask_way_sel [1:0] = {cpz_dcssize[1], |(cpz_dcssize[1:0])} & dcop_way_sel_bits;

	// Do not allow the spram_way to be directly indexed, must set spram
	// bit to get access to the spram
	assign dcop_index_way [3:0] = (1'b1 << dcop_mask_way_sel) & ~spram_way;
		    
	assign dcop_wway [3:0] = dcop_indexed ?  (cpz_spram ? spram_way : dcop_index_way) : 
			  dcop_pref_hit_reg ? dcop_wway_reg[3:0] :
			  ({4{dcop_pref_hit}} & block_hit_way_reg[3:0]);   
   
        mvp_register #(4) _dcop_wway_reg_3_0_(dcop_wway_reg[3:0], gclk, dcop_wway[3:0]);

	assign dcc_dcopld_m = dcop_read_reg & dcop_idx_ld;
        mvp_register #(1) _dcc_dcopld_md(dcc_dcopld_md, gclk, dcc_dcopld_m);

	assign dcc_dcoptag_m [25:0] = {tagmuxout[23:16], dcop_pa_wsparity[3:0], dcop_pa_wsdirty[3:0],
                                dcop_pa6[8:3], tagmuxout[0], tagdirty, tagmuxout[1], tagmuxout[T_BITS-1]};

        assign tagdirty = |(dc_wsin_full[9:6] & dcop_wway[3:0]);
	assign dcop_pa_wsdirty[3:0] = dcc_dcopld_md ? dc_wsin_full[9:6] : tagmuxout[11:8];       // WSD
        assign dcop_pa_wsparity[3:0] = dcc_dcopld_md ? dc_wsin_full[13:10] : tagmuxout[15:12];   // WSDP
        assign dcop_pa6 [8:3] = dcc_dcopld_md ? dc_wsin_full[5:0] : tagmuxout[7:2];   // send lru

	assign dcc_dcopdata_m [31:0] = datamuxout_data[31:0];

	assign use_idx = (dcop_indexed & dcop_access_m) | ev_use_idx | ev_use_idx_data;

	// Waiting for fixup ensures that we have entered the W-stage and this instn can complete
	assign dcop_ready = ~dcc_copsync_m & ~sync_not_done & fill_done & ~fb_full & dcc_fixup_w;

	assign dcc_dcop_stall = dcop_access_m & ~(dcop_done | ev_wrtag_inv_ws_nopar & dcc_parerr_w & dcop_evictable);

	assign cop_stall = dcc_dcop_stall | icc_icopstall;

	mvp_cregister #(1) _valid_d_access(valid_d_access,advance_m & ~(pre_ev_way_on & ~ev_cancel), gclk, (mpc_busty_raw_e == 3'h1) & ~fxexc_e);
	assign dcc_valid_d_access = valid_d_access;

        // prefetch
	mvp_cregister #(1) _prefetch(prefetch,advance_m, gclk, (mpc_busty_raw_e == 3'h3) & ~fxexc_e);   

        // prefetch load
        assign pref_m = prefetch & ~(mpc_coptype_m[2:0] == 3'h6);

        // Prefetch Nudge :
        // coptype_m is ie[20:18]. only when 20:16 = h19 does this signifies a nudge.
        assign prefnudge_m = prefetch & (mpc_coptype_m[2:0] == 3'h6) & dcached;
        mvp_cregister #(1) _prefnudge_reg(prefnudge_reg,~ev_wait, gclk, prefnudge_m);
        assign prefnudge_imm = prefnudge_m & ls_tag_read & ~killmiss_m & ~pre_ev_way_on;

        assign killmiss_m = (mmu_rawdtexc_m | mmu_r_rawdtexc_m | mmu_rawdtexc_reg | mpc_dmsquash_m | 
		      (cpz_gm_m ? cpz_g_int_mw : cpz_int_mw) & ~(mpc_atomic_w | mpc_atomic_m) | held_dtmack |
                      (cpz_gm_m ? cpz_g_causeap : cpz_causeap) & (mpc_hw_save_status_m | mpc_hw_save_srsctl_m) |
                      (mpc_chain_take | mpc_exc_iae) & (mpc_hw_load_epc_m | mpc_hw_load_srsctl_m) 
		       ) & killable_m | 
		      lkill_fixup_w;
	assign par_kill_m = (dcc_parerr_cpz_w | icc_parerr_w | dcc_parerr_m) & killable_m;
	assign held_parerr_w = (dcc_parerr_cpz_w | icc_parerr_w | dcc_parerr_w) | hold_parerr_w;
	mvp_register #(1) _hold_parerr_w(hold_parerr_w, gclk, held_parerr_w & ~mpc_run_w);
	assign dcc_par_kill_mw = held_parerr_m & killable_m | held_parerr_w;

        mvp_cregister #(1) _mmu_rawdtexc_reg(mmu_rawdtexc_reg,mpc_run_m | mmu_rawdtexc_m | mmu_r_rawdtexc_m, gclk, 
		(mmu_rawdtexc_m | mmu_r_rawdtexc_m) & ~mpc_run_m);

	// Allow interrupts to kill all ops in 1st cycle of M,
	// 	Cacheable loads, and stalling stores that have not been sent out yet
	// Also have Fixup kills for biu_dbe's and store data SB
	assign killable_m = ~dcc_fixup_w;
	assign killable_w = (dcc_fixup_w | cp2_fixup_w | cp1_fixup_w) & killable_m_reg &
		     ~ev_dirty_start & ~ev_dirtyway_reg ;      
	mvp_register #(1) _killable_m_reg(killable_m_reg, gclk, ~lkill_fixup_w & 
				  (
				   (dcached & valid_d_access) |
				   dsync_m |
				   (cp2_fixup_w & cp2_datasel) |
				   store_killable
				   )
				  );

        // only store not killable in fixup is wt-wa between read sent and write pending.
        // - this is slightly pessimistic, in that a wt-wa store that hits is not killable
        //   until write is sent to biu IF another data read is currently outstanding.
        assign store_killable = store_stall & ( ~wt_wa | (wt_wa & st_alloc_wait) );
  	
	// Once atomic instruction is in fixup stage,interrupt is disable
        // atomic instruction must sure next M stage is also non-interruptable
        // We're killing instn in fixup stage due to Interrupt
	assign dcc_intkill_w = killable_w & (cpz_int_mw | cpz_g_int_mw) & ~(mpc_atomic_w | mpc_atomic_store_w) ;
	assign dcc_intkill_m = killable_m & (cpz_int_mw | cpz_g_int_mw) & ~(mpc_atomic_w | mpc_atomic_m) & raw_dccop_m ;
     	// Atomic load is in fixup w stage, M stage should be kept
        assign dcc_exc_nokill_m = ~killable_m & mpc_atomic_w;

	// Data Bus Error kill only allowed if not cp2_missexc_w
	// Save possible bus error until after cp2_missexc_w, 
        assign dcc_dbe_killfixup_w =  ~cp2_missexc_w & ~cp1_missexc_w & ((killable_w & mpc_dmsquash_w) | pend_dbe_kill_fixup);
	mvp_register #(1) _pend_dbe_kill_fixup(pend_dbe_kill_fixup, gclk, (cp2_missexc_w | cp1_missexc_w) & ((killable_w & mpc_dmsquash_w) |
							     pend_dbe_kill_fixup));

        // We don't know if this was precise until late in the cycle.  Wait until the
        // next clock (the 'real' W stage) to kill the instn.  If the pipeline is stalled
	// hold this signal until we start rolling again
	mvp_register #(1) _precise_dbe(precise_dbe, gclk, (valid_d_access & biu_dbe & biu_ddataval & hit_fb & raw_ldfb[dcc_dval_m[3:2]])
			       | (precise_dbe & local_fixup_m));

	// Instn in W killed by precise DBE
	assign dcc_precisedbe_w = precise_dbe;

	assign lkill_fixup_w = dstore_m & dcc_fixup_w & mpc_sdbreak_w | dcc_parerr_ws_reg | 
			dcc_intkill_w | dcc_dbe_killfixup_w | cp2_exc_w | cp2_storekill_w_real | cp1_exc_w |
			(dcc_precisedbe_w & dcc_fixup_w & ~ev_dirty_start & ~ev_dirtyway_reg) | greset;
	mvp_register #(1) _dcc_parerr_ws_reg(dcc_parerr_ws_reg, gclk, dcc_parerr_ws);

        // Stores pessimistically stall when index matching in front or back fill buffer.
        //     Cache access is re-issued when the fill buffer is empty.
        // WT or UNC stores stall when biu write-through buffer is full.
        // WT-WA/WB/PREF stall one cycle on a miss.
        assign store_stall = dstore_m & store_force_stall;         
     
        // Fill buffer index match
        assign fb_wb_idx_match = ( (idx_match_fb   & (~fill_done | dcc_exrdreqval)) | 
			    (idx_match_fb_b & (fb_trans_btof_active_entry))  |
			    hold_fb_wb_idx_match) &
			  (raw_dstore_m & ~kick_atomic_write_raw | fb_wb_idx_match_reg);   
   
	mvp_register #(1) _hold_fb_wb_idx_match(hold_fb_wb_idx_match, gclk, fb_wb_idx_match & sp_stall); 
        mvp_register #(1) _fb_wb_idx_match_reg(fb_wb_idx_match_reg, gclk, fb_wb_idx_match & ~killmiss_m & ~par_kill_m);

        assign fb_wb_end = fb_wb_idx_match_reg & ~fb_wb_idx_match;

        assign prefnudge_stall = (prefnudge_reg & ev_way_on_reg) |
			  (prefnudge_m & dcc_trstb_reg & ~ev_way_on_reg); 

        assign early_store_stall = dstore_m & early_store_force_stall;

        // Normal Store Stalls :
        // WB store miss       - stall if req out, or fb_full, or just out of e-stage (1 cycle stall).
        // WT-WA store hit     - stall if biu_wtbf.
        // WT-WA store miss    - stall if req out, fb_full, or biu_wtbf, or just out of e-stage (1 cycle stall).
        // WT-NWA store hit    - stall if biu_wtbf, or if fb_full (in case it needs to hit in back fb).
        // WT-NWA store miss   - stall if biu_wtbf, or if fb_full (in case it needs to hit in back fb).
        // Uncached store      - stall if biu_wtbf.
        assign store_force_stall = wb_st_stall | wtwa_st_stall | wtnwa_st_stall | unc_st_stall;   

        assign wb_st_stall = wb & (st_alloc_wait);
        assign wtwa_st_stall = wt_wa & (st_alloc_wait | biu_wtbf);   
        assign wtnwa_st_stall = wt_nwa & (biu_wtbf | fb_full);
        assign unc_st_stall = ~dcached & biu_wtbf;

        assign dcc_uncached_store = unc_st_stall;

        // similar to req_out, but only allowed to go when biu free, or after the first cycle of a miss (which ever is later)
        assign st_alloc_wait = ~(rd_req_enable_next | rd_req_enable | st_alloc_rd_sent) | ls_tag_read;

        // disable st_alloc_wait after our read went out (in case we're stalling due to biu_wtbf for wt_wa and 
        //    we don't want to match on ourself)
        mvp_cregister #(1) _st_alloc_rd_sent(st_alloc_rd_sent,ls_tag_read | dcc_exrdreqval, gclk, dcc_exrdreqval & ~ls_tag_read & wt_wa & dstore_m);
   
        assign early_store_force_stall = (st_alloc_wait & (wb | wt_wa)) |
				  (fb_full & wt_nwa);            


	assign sync_not_done = dcc_exsyncreq | (sync_not_done_reg & ~biu_dreqsdone);
	mvp_register #(1) _sync_not_done_reg(sync_not_done_reg, gclk, sync_not_done);
	
	assign sync_stall = dsync_m & (req_out | sync_not_done | fb_full | ~fill_done);

        assign stall = store_stall | sync_stall | cop_stall | ev_stall | prefnudge_stall |
		cp2_store_stall | fb_wb_idx_match;

        assign early_stall = early_store_stall | sync_stall | cop_stall | ev_fbhit_fill_reg |
		      fb_wb_idx_match;

        // If it's a wt_wa store, and the biu wtb is full, don't allow a hit to remove the store
        assign store_m = raw_dstore_m & ( ~dcached | wb | (wt_wa & ~biu_wtbf)) & ~fb_wb_idx_match;
   
	assign dc_hit_en = (valid_d_access | pref_m | store_m) & cacheread_m & dcached;

	assign fb_hit_en = (valid_d_access | pref_m);

        // In BIST mode: greset =1 and dmbinvoke =1.  greset is kept at 1 to reset the core 
        // logic and the greset signal is inverted in the BIST module. 
	assign disable_dmiss = killmiss_m | (~valid_d_access & ~stall & ~pref_m) | fb_wb_end |
			(pref_m & (((rd_req_enable_next | rd_req_enable | ev_wrtag_inv_ws | ev_wrtag_inv_ws_nopar) & ~dcc_trstb_reg) | ~dcached)) |
			hold_dmiss_n | (greset & ~dmbinvoke);


	assign dcc_pm_dhit_m = 	(cache_hit & dc_hit_en  & ~ev_stall & ~cp2_store_stall) | 
			(hit_fb & fb_hit_en     & ~ev_stall & ~cp2_store_stall) |
			(enabled_sp_hit          & ~ev_stall & ~cp2_store_stall);
	assign dcc_dmiss_m = !(
			(disable_dmiss           & ~ev_stall & ~cp2_store_stall) | 
			dcc_pm_dhit_m
			);
/*	
	dcc_dmiss_m = !(
			(disable_dmiss           & ~ev_stall & ~cp2_store_stall) | 
			(cache_hit & dc_hit_en  & ~ev_stall & ~cp2_store_stall) | 
			(hit_fb & fb_hit_en     & ~ev_stall & ~cp2_store_stall) |
			(enabled_sp_hit          & ~ev_stall & ~cp2_store_stall)
			);
*/
 
	mvp_register #(1) _hold_dmiss_n(hold_dmiss_n, gclk, (valid_d_access | pref_m) & ~dcc_dmiss_m & 
				~mpc_run_m & ~dcc_fixup_w & ~held_dtmack & ~(dcc_ev & ~ev_cancel));


	// True M-stage stalls - not fixup in W
	assign dcc_stall_m = sp_stall | fb_wb_idx_match | fb_wb_idx_match_reg | hold_dtmack;
	
        // Performance monitoring outputs
// 
// verilint 528 off
	wire	dcache_hit;
	assign dcache_hit = cacheread_m & ~killmiss_m & dcached & (hit_fb | cache_hit);
// verilint 528 on
// 
	assign dcache_miss_pc = cacheread_m_pc & ~killmiss_m & dcached & ~(hit_fb | cache_hit);
	mvp_register #(1) _dcc_pm_dcmiss_pc(dcc_pm_dcmiss_pc, gclk, dcache_miss_pc);

	// Capture new d address on loads, stores, pref, D$ ops, evictions, and bist
	assign dcc_exnewaddr = (new_addr_sync & ~cp2_fixup_m & ~cp1_fixup_m) | ev_exnew_addr | ev_exold_addr | dmbinvoke;    
	
	mvp_register #(1) _new_addr_sync(new_addr_sync, gclk, new_addr_nxt);
	assign new_addr_nxt = ~greset &
		       ((new_addr_sync & (cp2_fixup_m | cp1_fixup_m)) |			
			(((mpc_busty_e[2:0] == 3'b001) | mpc_busty_e[1]) &
			 ~(dcc_dmiss_m & ~dstore_m)));   

	assign dcc_exaddr [31:2] = (ev_exnew_addr & exaddr_sel_disable) ? ev_exaddr[31:2] : dcc_pa[31:2];   

        assign dcc_exaddr_ev [31:2] = ev_exaddr[31:2];

        assign dcc_exaddr_sel = ev_exnew_addr & !exaddr_sel_disable;
   
	assign dcc_excached = dcached | ev_exnew_addr;  
	
	mvp_register #(1) _ev_exnew_addr_reg(ev_exnew_addr_reg,gclk, ev_exnew_addr);

	assign dcached_mix = dcached | ev_exnew_addr_reg; 

	assign dcc_exmagicl = dmagicl & ~ev_exnew_addr;

        // Sync   
       	assign raw_dsync_e = start_new_access & (mpc_busty_raw_e == 3'h4);
	assign dsync_e = raw_dsync_e & advance_m & ~fxexc_e;   

        mvp_register #(1) _raw_dsync_m(raw_dsync_m, gclk, dsync_e);
	assign dsync_m = local_fixup_m ? dsync_m_reg : raw_dsync_m;
        mvp_register #(1) _dsync_m_reg(dsync_m_reg, gclk, dsync_m);

        // CacheOps/Syncs are Synchronizing instns
	assign dcc_exsyncreq = sync_req_sync & ~cp2_fixup_w & ~cp1_fixup_w;
	mvp_register #(1) _sync_req_sync(sync_req_sync, gclk, (~greset &
				      ((sync_req_sync & (cp2_fixup_w | cp1_fixup_w)) |
				       (mpc_busty_e[2] & advance_m) |
				       (dcop_access_m & dcop_evictable & ev_wrtag_inv)))); // sync after cacheop wb evict

        // Read miss request- only allow 1 outstanding miss at a time
	// Other read requests - pref, store allocate, cacheop
	mvp_register #(1) _other_req(other_req, gclk,
// 			    (pref_m & dcached & ~killmiss_m & ~hold_dmiss_n &
 			    (pref_m & dcached & ~killmiss_m & ~par_kill_m & ~hold_dmiss_n &
			     ~(ev_stall_nofill | ev_dirtyway_reg_reg) &
			     ~(hit_fb | (cache_hit & dc_hit_en) | (enabled_sp_hit))) |
			    (dstore_m & store_allocate & ~cp2_fixup_w & ~cp2_storeissued_m_real) | 
			    dcop_fill_req);

	assign dcc_store_allocate = store_allocate; // used in CP2 module

	// Delay sending out a read request if pipeline stalled by another source.
	// Needed for sp_stall, wasted time for PDTrace stalls.
        assign rd_req_enable_next = ~req_out & fb_repl_inf[`M14K_FBR_LAST] & ~greset & ~fb_full & 
			     (mpc_run_m | dcc_fixup_w | dcc_ev);   
	mvp_register #(1) _rd_req_enable(rd_req_enable, gclk, rd_req_enable_next & ~held_dcc_parerr_w & ~dcc_parerr_ws_reg);
	mvp_register #(1) _hold_dcc_parerr_w(hold_dcc_parerr_w,gclk, dcc_parerr_w & ~mpc_run_w);
	assign held_dcc_parerr_w = dcc_parerr_w | hold_dcc_parerr_w;

	assign rdreq_sync_next = ~greset &
			  (
			   (
			    (dcc_dmiss_m & ~stall & ~cp2_ldst_m & ~cp1_ldst_m) | 
			    (cp2_storealloc_reg & ~killmiss_m & ~par_kill_m & (cp2_datasel_real & ~cp2_fixup_w))
			    ) &
			   ( 
			     ~(cp2_fixup_m | (cp2_missexc_w_real & ~cp2_storealloc_reg) | cp2_exc_w) | 
			     (rdreq_sync & ~cp2_exc_w) 
			     ) &
			   ( 
			     ~(cp1_fixup_m | cp1_missexc_w_real | cp1_exc_w) | 
			     (rdreq_sync & ~cp1_exc_w) 
			     ) 
			   );   
	mvp_register #(1) _rdreq_sync(rdreq_sync, gclk, rdreq_sync_next);

	assign rd_req = rdreq_sync;   

	assign dcc_exrdreqval = (rd_req | other_req) & rd_req_enable & ~dcc_parerr_ws_reg & ~dcc_parerr_w & ~cp1_exc_w;

        mvp_register #(1) _cp2_storealloc_reg_reg(cp2_storealloc_reg_reg, gclk, cp2_storealloc_reg); 
                       
        // Disable write-thrus...
        //  for stores hitting in a scratchpad RAM and kill them for WB stores
	assign dsp_lock_hold_hit_long = dsp_lock_hold_hit || held_dsp_lock_hold_hit;
	mvp_register #(1) _held_dsp_lock_hold_hit(held_dsp_lock_hold_hit, gclk, dsp_lock_hold_hit_long && !advance_m);
	
	assign raw_dsp_hit = raw_dsp_hit_raw | dsp_lock_hold_hit_long; 

        assign raw_writethru = (wt_nwa | wt_wa | wb_noavail | (~dcached & spram_support)) & ~raw_dsp_hit | (~dcached & ~spram_support);		    

        // WB stores that miss with all lines locked should write-thru
	assign wb_noavail = (wb & (&ways_locked[3:0]) & cpz_dcpresent & raw_dstore_m & ~(cache_hit | block_hit_fb)) | wb_noavail_reg;
        assign ways_locked[3:0] = dunavail[3:0] | ({4{idx_match_fb & fb_repl_inf[`M14K_FBR_LOCK] & ~fill_done}} & repl_wway[3:0]);
        mvp_cregister #(1) _wb_noavail_reg(wb_noavail_reg,raw_dstore_m | advance_m | greset, gclk, wb_noavail & ~greset & ~advance_m);

	assign write_thru = dcc_fixup_w ? write_thru_reg : raw_writethru;
	mvp_register #(1) _write_thru_reg(write_thru_reg, gclk, write_thru);
	
	// Send out request when we really make it into the W-stage
	mvp_register #(1) _wr_req_enable(wr_req_enable, gclk, mpc_run_m | dcc_fixup_w | (cp2_fixup_w & ~cp2_exc_w));
	assign dcc_exwrreqval = (wt_req_w & wr_req_enable) | 			 
			 ev_exwrreq_val | dmbinvoke;

	// Tell BIU if read request for this WT-WA request is pending
	assign dcc_stalloc = wt_req_w & wr_req_enable & wt_wa_req_w & (rd_req | other_req);

	mvp_cregister #(1) _wt_req_w(wt_req_w,advance_m | dcc_exwrreqval, gclk, ((dstore_m | (cp2_datasel_real & ~cp2_fixup_w)) &
								~killmiss_m & ~par_kill_m & write_thru & 
								~(fb_wb_idx_match_reg | fb_wb_idx_match)) & ~clear_wt);
        assign clear_wt = dcc_exwrreqval & ~advance_m;


	mvp_cregister #(1) _wt_wa_req_w(wt_wa_req_w,advance_m, gclk, wt_wa);
	
	
	assign req_out = dcc_exrdreqval | req_out_reg;
	mvp_register #(1) _req_out_reg(req_out_reg, gclk, req_out & ~biu_ddataval & ~greset);
	
	mvp_mux2 #(32) _fb_hold_data_31_0_(fb_hold_data[31:0],hold_dmiss_n, fb_data, dcc_ddata_m_reg);
	
        // Data from Fill Buffer or Store Buffer	
	mvp_mux2 #(8) _sb_fb_data3_31_24_(sb_fb_data3[31:24],hit_sb[3], fb_hold_data[31:24], storebuff_data[31:24]);
	mvp_mux2 #(8) _sb_fb_data2_23_16_(sb_fb_data2[23:16],hit_sb[2], fb_hold_data[23:16], storebuff_data[23:16]);
	mvp_mux2 #(8) _sb_fb_data1_15_8_(sb_fb_data1[15:8],hit_sb[1], fb_hold_data[15:8], storebuff_data[15:8]);
	mvp_mux2 #(8) _sb_fb_data0_7_0_(sb_fb_data0[7:0],hit_sb[0], fb_hold_data[7:0], storebuff_data[7:0]);

	mvp_mux2 #(8) _data_in3_31_24_(data_in3[31:24],(hit_sb[3] | hit_fb | hold_dmiss_n), datamuxout_data[31:24], sb_fb_data3);
        mvp_mux2 #(8) _data_in2_23_16_(data_in2[23:16],(hit_sb[2] | hit_fb | hold_dmiss_n), datamuxout_data[23:16], sb_fb_data2);
        mvp_mux2 #(8) _data_in1_15_8_(data_in1[15:8],(hit_sb[1] | hit_fb | hold_dmiss_n), datamuxout_data[15:8], sb_fb_data1);
        mvp_mux2 #(8) _data_in0_7_0_(data_in0[7:0],(hit_sb[0] | hit_fb | hold_dmiss_n), datamuxout_data[7:0], sb_fb_data0);

	assign dcc_ddata_m [31:0] = {data_in3,data_in2, data_in1, data_in0};

	mvp_register #(32) _dcc_ddata_m_reg_31_0_(dcc_ddata_m_reg[31:0], gclk, dcc_ddata_m);
	
	// Pre-aligner load data for EJTAG load/store data comparison.
	assign ej_core_data_read [31:0] = edp_ldcpdata_w [31:0]; 
	assign ej_core_data_temp [31:0] = pdva_load ? ej_core_data_read : edp_stdata_iap_m;
	assign dcc_ejdata [31:0] = cp2_datasel_real & ~pdva_load ? cp2_data_w : ej_core_data_temp;

        ////////////
        // WS - write back, dirty bits, eviction
        ///////////			     
        // Dirty bit control:
        assign dcc_wsaddr[13:4] = scan_mb_addr_ctl ? scan_mb_wdaddr : dcc_tagaddr_reg;

        mvp_register #(10) _dcc_tagaddr_reg_13_4_(dcc_tagaddr_reg[13:4], gclk, dcc_tagaddr);

        assign dcc_wsrstb = (((imm_store_miss | imm_load_miss) & ~dcc_parerr_m | imm_cop_prefndg & ~dcc_parerr_w) & 
		      ~pre_ev_way_on & ~fb_wb_idx_match & ~killmiss_m &
		      ~(raw_dsp_hit & ~(dcop_access_m & dcop_indexed)) & 
		      ~scan_mb_stb_ctl) | 
		     scan_mb_wsrstb;

        assign dcc_wswstb = ((imm_store_hit | imm_load_hit) & ~ev_cur & ~killmiss_m & ~fb_wb_idx_match & ~scan_mb_stb_ctl) |
		     (fb_filled_tag & ~scan_mb_stb_ctl) | 
		     (dcop_lru_write & ~scan_mb_stb_ctl) | 
		     (ev_wrtag_inv_ws & ~scan_mb_stb_ctl) |
		     scan_mb_wswstb;

		     
        mvp_register #(1) _dcc_wsrstb_reg(dcc_wsrstb_reg, gclk, dcc_wsrstb);
        // cache_hit and hit_fb are not necessarily mutually exclusive
        assign imm_store_hit = imm_store & (cache_hit & ~hit_fb) & dcached; // hit_fb updates FB (not WS direct)
        // hit_fb below to trigger eviction if back fill buffer index/way matches with a now dirty front buffer
        assign imm_store_miss = imm_store & dcached & ~wt_nwa &
			 (~cache_hit | hit_fb) & ~(hit_fb & wt_wa);
        assign imm_load_miss = imm_load & ~(cache_hit | hit_fb) & dcached;
        assign imm_load_hit = imm_load & cache_hit & dcached;      
        assign imm_cop_prefndg = (dcop_read_reg & dcop_evictable & ~dcop_hit_only) | // index invalidate
			  (dcc_dcopld_m) |  // index load
			  (fandl_read & ~cache_hit) |  // fetch and lock miss
			  (dcop_read_reg & cache_hit & dcop_hit_only & dcop_evictable) | 
			  (prefnudge_imm & (cache_hit | hit_fb));     

	// Hold this signal valid until the instn reaches the w-stage
	// dccop_w will be on if instn is already in W ($op)
	// advance_m_reg will be on for nudge missing in cache
        mvp_register #(1) _imm_cop_prefndg_reg(imm_cop_prefndg_reg, gclk, imm_cop_prefndg | (imm_cop_prefndg_reg & ~(dccop_w | advance_m_reg)));

        assign imm_load = (valid_d_access | pref_m) & ls_tag_read;
        assign imm_store = raw_dstore_m & ls_tag_read;

        assign ls_tag_read = dcc_trstb_reg & cacheread_m;
        mvp_register #(1) _dcc_trstb_reg(dcc_trstb_reg, gclk, dcc_trstb);

        assign fb_filled_tag = dcc_twstb_reg & cachewrite_m;    
        mvp_register #(1) _dcc_twstb_reg(dcc_twstb_reg, gclk, dcc_twstb);

        mvp_register #(1) _dcc_ev(dcc_ev, gclk, (pre_ev_way_on & ~ev_cancel & dccop_w_ev_tmp & ~dcc_dcopld_m) | ev_stall);

        assign ev_noadv = ev_way_on_reg & ~(dcc_dcopld_md);

        assign dc_wsin_ex[13:0] = {dc_wsin};
	assign dc_wsin_full[13:10] = {dc_wsin_ex[13], dc_wsin_ex[11], dc_wsin_ex[9], dc_wsin_ex[7]};
	assign dc_wsin_full[9:0] = {dc_wsin_ex[12],dc_wsin_ex[10], dc_wsin_ex[8], dc_wsin_ex[6:0]};
	assign dcc_wswren[13:0] = dcc_wswren_adj[13:0];
	assign dcc_wswren_adj[13:0] = dcc_wswren_full[13:0];

	assign dcc_wswrdata[13:0] = dcc_wswrdata_adj[13:0];
	assign dcc_wswrdata_adj[13:0] = dcc_wswrdata_full[13:0];
	

 	assign dcc_wswren_full[13:0] = dmbinvoke ? mbwd_mask[13:0] : 
				{{2{ws_mask[3]}}, {2{ws_mask[2]}}, {2{ws_mask[1]}}, {2{ws_mask[0]}}, lru_mask[5:0]};

        assign dcc_wswrdata_full[13:0] = dmbinvoke? mbwddata[13:0] : 
				   {dcc_wswrdata_dirty[3], fb_store_dirty[3], dcc_wswrdata_dirty[2], fb_store_dirty[2],
                                    dcc_wswrdata_dirty[1], fb_store_dirty[1], dcc_wswrdata_dirty[0], fb_store_dirty[0],
                                    lru_data[5:0]};

        assign dcc_wswrdata_dirty[3:0] = dcop_lru_write ? (cpz_po ? cpz_taglo[17:14] : cpz_taglo[13:10]) : fb_store_dirty;
	
	assign fb_store_dirty[3:0] = dcop_lru_write ? cpz_taglo[13:10] : (ws_dirty_en[3:0] &
			       {4{(((fb_fill_mark_dirty | imm_store_hit) & ~ev_wrtag_inv_ws) |
				   dcop_idx_writedirty)}}); 

	assign ws_mask[3:0] = (ws_dirty_en[3:0] & {4{~((imm_store_hit & ~wb) | imm_load_hit)}}); 
   
        assign ws_dirty_en[3:0] = dcop_lru_write ? 4'b1111 :imm_store_hit ? block_hit_way[3:0] : ws_en[3:0];   
        mvp_register #(4) _ws_en_3_0_(ws_en[3:0], gclk, ws_en_tobe[3:0]);
        // tag enables, except when there is a dcop_hit_wb, when the tag is not invalidated
        assign ws_en_tobe[3:0] = (ev_wrtag_noinv & ev_wrtag_inv) ? ev_wrtag_inv_msk[3:0] : 
			   dcc_tagwren4[3:0];
   
        assign store_hit_fb = hit_fb & dstore_m & wb; 

        mvp_register #(1) _fb_fill_mark_dirty(fb_fill_mark_dirty, gclk, fb_dirty & last_word_fill); // only write dirty on last word of fill

        // Eviction:
        // Block while doing an eviction.
        // load/store miss reads WS array, as well as FB (if index hit) to determine way to replace...
        mvp_mux2 #(4) _ev_cache_way_3_0_(ev_cache_way[3:0],ev_cache_way_sel, ev_compare_way_ws[3:0], ev_cache_way_mx[3:0]);
        mvp_mux2 #(4) _ev_cache_way_mx_3_0_(ev_cache_way_mx[3:0],dcop_idx_inval_ev, ev_compare_way_pref[3:0], ev_compare_way_idx[3:0]);
        assign ev_cache_way_sel = dcop_idx_inval_ev | dcop_pref_hit;

        assign ev_compare_way_pref[3:0] = dc_wsin_full[9:6] & ~ill_ways[3:0] & block_hit_way_reg[3:0]; // pref nudge or dcop hit
        assign ev_compare_way_ws[3:0]   = dc_wsin_full[9:6] & ~ill_ways[3:0] & drepl[3:0];             // normal load/pref/store
        assign ev_compare_way_idx[3:0]  = dc_wsin_full[9:6] & ~ill_ways[3:0] & dcop_wway_reg[3:0];     // index invalidate
   
        // cancel eviction if the store/load hits in the FB or SPRAM before we do the read & start the eviction
        assign ev_hit_cancel = ((hit_fb & (fb_hit_en | (dstore_m_reg & (wb | wt_wa)))) |
			  (enabled_sp_hit | (raw_dsp_hit & (dstore_m_reg & (wb | wt_wa)))))
			  & ~(|ev_word[1:0]) & ~ev_dirty_start & ~imm_load;
        // Determine way to evict
        assign ev_way[3:0] = ev_way_mx1[3:0];

        mvp_mux2 #(4) _ev_way_mx1_3_0_(ev_way_mx1[3:0],(dcc_wsrstb_reg | ev_hitback_fb),    			       
			                                      ev_way_mx2[3:0], ev_way_sel_mx1[3:0]);
        mvp_mux2 #(4) _ev_way_mx2_3_0_(ev_way_mx2[3:0],ev_done, ev_way_reg[3:0], 4'b0);      
   
        mvp_mux2 #(4) _ev_way_sel_mx1_3_0_(ev_way_sel_mx1[3:0],ev_fbhit | dcc_dcopld_md, 
				   ev_cache_way[3:0], 
				   repl_wway[3:0] & {4{~dcc_dcopld_md}});

        mvp_register #(4) _ev_way_reg_3_0_(ev_way_reg[3:0], gclk, ev_way & {4{~ev_cancel}});
        assign pre_ev_way_on = |ev_way[3:0];
        mvp_register #(1) _ev_way_on_reg(ev_way_on_reg, gclk, dccop_w_ev_tmp & pre_ev_way_on & ~ev_cancel);
        assign ev_way_on = pre_ev_way_on & dccop_w_ev;
        assign ev_cancel = ev_hit_cancel | (killmiss_m & ~dccop_w_ev) | dcc_parerr_ws | dcc_parerr_w |
		    (lkill_fixup_w & ~(cp2_exc_w & dcc_exrdreqval) & ~(cp1_exc_w & dcc_exrdreqval)) | 
		    greset;      
  	assign ev_done = ~(|ev_word[1:0]) & ev_dirtyway_reg | dcc_parerr_ev_reg | dcc_parerr_w;
	mvp_register #(1) _dcc_parerr_ev_reg(dcc_parerr_ev_reg, gclk, dcc_parerr_ev);
 
   
        mvp_register #(10) _ev_tagaddr_reg_13_4_(ev_tagaddr_reg[13:4], gclk, ev_tagaddr[13:4]);
        assign ev_tagaddr[13:4] = ~pre_ev_way_on ? dcc_tagaddr_reg : 
			   (ev_hitback_fb) ? fill_addr_lo[13:4] : ev_tagaddr_reg;      
        assign ev_dataaddr [13:2] = {ev_tagaddr_reg[13:4],ev_word_reg[1:0]} & index_mask[13:2];   

        mvp_cregister #(1) _ev_word_0_0_(ev_word[0],ev_cur | ev_new | dcc_parerr_ev, gclk, ~ev_word[0] & ev_dirtyway & ~greset & ~dcc_parerr_ev);
        mvp_cregister #(1) _ev_word_1_1_(ev_word[1],ev_cur | ev_new | dcc_parerr_ev, gclk, (ev_word[0] ^ ev_word[1]) & ev_dirtyway & ~greset & ~dcc_parerr_ev);

        mvp_register #(2) _ev_word_reg_1_0_(ev_word_reg[1:0], gclk, ev_word[1:0]); // used to evict to the biu
	mvp_register #(1) _ev_exception_detected(ev_exception_detected, gclk, mpc_exc_w & ( ev_exception_detected ||
				 (dcc_parerr_ev_reg & mpc_dparerr_for_eviction && 
			(ev_word_reg[1] == 1'b1) )));
	assign ev_exception_kill_wr = ev_exception_detected;

        assign ev_new = ls_tag_read | greset;  // new read, no eviction going on
        assign ev_cur = ev_dirtyway;   // there is a current eviction going on.   

        // signals used for starting eviction
        assign ev_stall = ev_stall_nofill | (ev_fbhit_fill_reg & ~ev_cancel);   
        assign ev_stall_nofill = ev_dirtyway | ev_dirtyway_reg | ev_rdreq_seen;   
        // the biu read went out.. remember it incase biu_wtbf is on
	assign ev_rdreq_seen_cnd = ((dcc_exrdreqval | imm_cop_prefndg_reg) & ev_way_on) |
			    ev_dirtyway | greset;
   
        mvp_cregister #(1) _ev_rdreq_seen(ev_rdreq_seen,ev_rdreq_seen_cnd, gclk, (dcc_exrdreqval & ~dcc_parerr_cpz_w | 
				  imm_cop_prefndg_reg & ~dcc_parerr_w) & ~greset );

	assign ev_dirtyway = ((ev_dirty_start_reg & ~wt_req_w) ? ev_way_on_reg :
                      (|ev_word[1:0]))  // evict dirty way tag
			& ~dcc_parerr_w;
        assign ev_dirty_start = dcc_exrdreqval | ev_rdreq_seen |
			 imm_cop_prefndg_reg;

        mvp_register #(1) _ev_dirty_start_reg(ev_dirty_start_reg, gclk, ev_dirty_start & ~ev_fbhit & ~biu_nofreebuff);   
        mvp_register #(1) _ev_dirtyway_reg(ev_dirtyway_reg, gclk, ev_dirtyway & ~greset);                           // evict dirty way data
        mvp_register #(1) _ev_dirtyway_reg_reg(ev_dirtyway_reg_reg, gclk, ev_dirtyway_reg & ~dcc_parerr_ev & ~greset);                    // eviction to biu.
	mvp_register #(1) _ev_dirtyway_reg_reg_nopar(ev_dirtyway_reg_reg_nopar, gclk, ev_dirtyway_reg & ~greset);
	assign ev_wrtag_inv_ws_nopar = ev_dirtyway_reg_reg_nopar & ~ev_dirtyway_reg;

        assign ev_wrtag_inv = (ev_dirtyway_reg) & ~(|ev_word[1:0]);                // invalidate tag cycle after last tag eviction   
        assign ev_wrtag_inv_ws = ((ev_dirtyway_reg_reg) & ~(ev_dirtyway_reg)) |   // clear WS dirty bit cycle after that
			  (dcop_write_reg & ~dcop_lock_write_reg );          // or on cacheop invalidate
        assign ev_wrtag_inv_msk[3:0] = ev_way_reg[3:0];
        assign ev_wrtag_noinv = dcop_hit_noinv;
   
        // SB hit - evict the SB (while evicting the cache line) if it matches the cache line
        assign ev_sb_wordhit = (ev_word_reg[1:0] == storebuff_idx[3:2]);
        assign ev_sb_wayhit = (store_way_reg[3:0] == ev_way_reg[3:0]);   
        // match high bits of store buffer with tag being evicted
        assign ev_sb_highhit = (ev_exaddr[31:12] == storebuff_tag[31:12]);   

        // if another store comes in before SB force eviction, don't evict the SB
        assign ev_sb_hitacc = sb_addrhit_lower & sb_addrhit_idx_munge & ev_sb_highhit &
		       ev_sb_wordhit & ev_sb_wayhit & ev_dirtyway_reg;
        assign ev_sb_hit[3:0] = {4{ev_sb_hitacc}} & sb_valid_bits[3:0];
        mvp_register #(4) _ev_sb_hit_reg_3_0_(ev_sb_hit_reg[3:0], gclk, ev_sb_hit[3:0]);
        assign ev_sb_hitdone_reg = (|ev_sb_hit_reg[3:0]);
   
        // FB hit - wait till FB completes fill, then evict.
        assign ev_fb_wayhit = (repl_wway[3:0] == drepl[3:0]);   
        // normal index match, or if we immediately match after a front to back FB transfer
        assign ev_fbhit_sel_pre = ((idx_match_fb & (~fill_done | dcc_exrdreqval)) | 
			    (idx_match_fb_b & fb_trans_btof)) &  
			   fb_dirty & ~ev_way_on & dcc_wsrstb;   
        mvp_register #(1) _ev_fbhit_sel_pre_reg(ev_fbhit_sel_pre_reg, gclk, ev_fbhit_sel_pre);
        assign ev_fbhit_sel_pre_allow = ev_fbhit_sel_pre_reg & ~prefnudge_reg;   
        assign ev_fbhit_sel = ev_fb_wayhit & ev_fbhit_sel_pre_allow;

        assign ev_fbhit_fill = ev_fbhit & ev_way_on & ~ev_cancel;      
        mvp_register #(1) _ev_fbhit_fill_reg(ev_fbhit_fill_reg, gclk, ev_fbhit_fill);   
        assign ev_fbhit = (dcc_wsrstb_reg) ? (ev_fbhit_sel) :	     
		   (ev_hitback_fb) ? 1'b1 :		   
                   (fill_done | fb_trans_btof | ev_fbhit_justfilled) ? 1'b0 : ev_fbhit_reg;   
        mvp_register #(1) _ev_fbhit_reg(ev_fbhit_reg, gclk, ev_fbhit);
        mvp_register #(1) _ev_fbhit_justfilled(ev_fbhit_justfilled, gclk, dcc_wsrstb_reg & ev_fbhit_sel & (fill_done | fb_trans_btof));


        mvp_register #(1) _ev_hitback_fb(ev_hitback_fb, gclk, ev_fbhitb & fb_trans_btof & dcc_dmiss_m);

        // Back FB Hit (index/way match and dirty)
        assign ev_fbhitb = ((ev_fbmatch_b_reg & ev_fb_wayhit_b) | ev_fbhitb_reg) & ~fb_trans_btof_reg & 
		    ~greset & ~dcc_intkill_w & ~enabled_sp_hit;   
        mvp_register #(1) _ev_fbhitb_reg(ev_fbhitb_reg, gclk, ev_fbhitb);
        assign ev_fbmatch_b = ~(cache_hit | hit_fb | enabled_sp_hit) & idx_match_fb_b & ~pre_ev_way_on &
		       fb_dirty_b & ~killmiss_m & imm_load & dcached;      
        mvp_register #(1) _ev_fbmatch_b_reg(ev_fbmatch_b_reg, gclk, ev_fbmatch_b);
        assign ev_fb_wayhit_b = (repl_way[3:0] == fb_replinf_init_b[`M14K_FBR_REPLWAY]);   
								
        mvp_register #(1) _idx_match_fb_b_reg(idx_match_fb_b_reg, gclk, idx_match_fb_b);	      
        // evict cache (or SB) data to the biu
        assign ev_exaddr[31:2] = {tagmuxout[23:2], ev_tagaddr_reg[9:4], ev_word_reg[1:0]};   
        assign ev_exnew_addr = ev_dirtyway_reg;  
        assign ev_exold_addr = ev_dirtyway_reg_reg;
        assign ev_ex_dataout[31:0] = datamuxout_data[31:0];
        assign ev_exwrreq_val = ev_dirtyway_reg_reg & ~dcc_parerr_ev_reg & ~ev_exception_kill_wr;
        assign ev_ex_be[3:0] = 4'hf;   

        assign ev_use_idx = ev_dirtyway_reg;         
        assign ev_use_idx_data = ev_dirtyway_reg_reg;


        assign ev_wway_reg[3:0] = ev_way_reg[3:0];        

///////
// LRU update data - (encode)
/*
  Way    LRU[5:0] written on hit   LRU[5:0] written on invalidate   we[5:0]
   0          1x11xx                     0x00xx                     101100
   1          x1x01x                     x0x10x                     010110
   2          0xxx01                     1xxx10                     100011
   3          x00xx0                     x11xx1                     011001
*/    
//////
        // LRU write enable.  1) hit  2) fill from FB 3) store cacheop
	
	assign mbwd_mask[13:0] = ~dmbinvoke ? 14'b00000000000000 : 
			  (PARITY ? 
			 	((cpz_dcssize==2'd3) ? 14'b11111111111111:
			 	(cpz_dcssize==2'd2) ? 14'b00111111_100110: 
		  	 	(cpz_dcssize==2'd1) ? 14'b00001111_000100:
			 	14'b00011_000000) :
				((cpz_dcssize==2'd3) ? 14'b01010101_111111:
			 	(cpz_dcssize==2'd2) ? 14'b00010101_100110:
		  	 	(cpz_dcssize==2'd1) ? 14'b00000101_000100:
			 	14'b00000001_000000));


        assign lru_mask[5:0] = (dcop_lru_write  | dcop_hit_nolru_reg) ? 
			({6{~dcop_hit_nolru_reg}}) :
			(cacheread_m & cache_hit) ? lru_hitmask[5:0] :
			lru_fillmask[5:0];
       
        assign lru_hitmask[5] = (block_hit_way[2] | block_hit_way[0]);
        assign lru_hitmask[4] = (block_hit_way[3] | block_hit_way[1]);
        assign lru_hitmask[3] = (block_hit_way[3] | block_hit_way[0]);
        assign lru_hitmask[2] = (block_hit_way[1] | block_hit_way[0]);
        assign lru_hitmask[1] = (block_hit_way[2] | block_hit_way[1]);
        assign lru_hitmask[0] = (block_hit_way[3] | block_hit_way[2]);

        assign lru_fillmask[5] = (ws_en[2] | ws_en[0]);
        assign lru_fillmask[4] = (ws_en[3] | ws_en[1]);
        assign lru_fillmask[3] = (ws_en[3] | ws_en[0]);
        assign lru_fillmask[2] = (ws_en[1] | ws_en[0]);
        assign lru_fillmask[1] = (ws_en[2] | ws_en[1]);
        assign lru_fillmask[0] = (ws_en[3] | ws_en[2]);		  

        // LRU data. 1) hit 2) fill from FB 3) invalide 4) store cacheop (cpz taglo)

	assign lru_data[5:0] = dcop_lru_write ? cpz_taglo[9:4] : 
			(cacheread_m & cache_hit) ? lru_hitdata[5:0] :
			ev_wrtag_inv_ws & ~dcop_ws_valid ? ~(lru_filldata[5:0]) :
			lru_filldata[5:0];


        assign lru_hitdata[5] = (~block_hit_way[2] | block_hit_way[0]);
        assign lru_hitdata[4] = (~block_hit_way[3] | block_hit_way[1]);
        assign lru_hitdata[3] = (~block_hit_way[3] | block_hit_way[0]);
        assign lru_hitdata[2] = (~block_hit_way[1] | block_hit_way[0]);
        assign lru_hitdata[1] = (~block_hit_way[2] | block_hit_way[1]);
        assign lru_hitdata[0] = (~block_hit_way[3] | block_hit_way[2]);

        assign lru_filldata[5] = (~ws_en[2] | ws_en[0]);
        assign lru_filldata[4] = (~ws_en[3] | ws_en[1]);
        assign lru_filldata[3] = (~ws_en[3] | ws_en[0]);
        assign lru_filldata[2] = (~ws_en[1] | ws_en[0]);
        assign lru_filldata[1] = (~ws_en[2] | ws_en[1]);
        assign lru_filldata[0] = (~ws_en[3] | ws_en[2]);

        ///////
        // WS logic end
        //////
   
        //Fill Buffer
        m14k_dcc_fb fb (
                     // outputs
                     .gclk		( gclk),
                     .biu_datain	(biu_datain),
                     .biu_ddataval	(biu_ddataval),
                     .biu_datawd	(biu_datawd),
                     .biu_lastwd	(biu_lastwd),
                     .biu_dbe		(biu_dbe),
                     .biu_dbe_pre       (biu_dbe_pre),
                     .gscanenable	(gscanenable),
                     .req_out		(req_out),
		     .req_out_reg	(req_out_reg),
                     .mmu_dpah		(mmu_dpah),
                     .dcc_dval_m	(dcc_dval_m),
                     .cachewrite_m	(cachewrite_m),
                     .greset		(greset),
                     .dcop_access_m	(dcop_access_m),
                     .dcop_fandl	(dcop_fandl),
                     .dcached		(dcached),
                     .repl_way		(repl_way),
                     .held_dtmack	(held_dtmack),
                     .index_mask	(index_mask[13:10]),
                     .dstore_m		(dstore_m),
                     .dcc_dmiss_m	(dcc_dmiss_m),
                     .no_way		(no_way),
		     .dcc_exbe		(dcc_exbe),
		     .storebuff_data	(storebuff_data),
		     .sb_to_fb_stb	(sb_to_fb_stb),
		     .store_hit_fb	(store_hit_fb),
		     .wb_reg		(wb_reg),
		     .wt_nwa            (wt_nwa),
                     // inputs
                     .raw_ldfb		(raw_ldfb),
                     .fill_data		(fill_data),
                     .fb_taglo		(fb_taglo),
                     .hit_fb		(hit_fb),
                     .fill_done		(fill_done),
                     .repl_wway		(repl_wway),
                     .fb_repl_inf	(fb_repl_inf),
                     .fill_addr_lo	(fill_addr_lo),
                     .fill_tag		(fill_tag),
                     .fill_data_ready	(fill_data_ready),
                     .block_hit_fb	(block_hit_fb),
                     .fb_repl_inf_mx	(fb_repl_inf_mx),
                     .idx_match_fb	(idx_match_fb),
                     .fb_data	        (fb_data),
                     .fb_full		(fb_full),
		     .fb_trans_btof_reg	(fb_trans_btof_reg),
		     .fb_trans_btof_active_entry (fb_trans_btof_active_entry),
		     .ld_tag_reg	(ld_tag_reg),
		     .fb_fill_way	(fb_fill_way),
		     .fb_update_tag	(fb_update_tag),
// verilint 528 off
		     .fb_active_entry	(fb_active_entry),
// verilint 528 on
		     .fb_trans_btof	(fb_trans_btof),
		     .fb_dirty		(fb_dirty),
		     .fb_dirty_b        (fb_dirty_b),
		     .fb_replinf_init_b	(fb_replinf_init_b),
		     .idx_match_fb_b	(idx_match_fb_b),
// verilint 528 off
		     .bus_err_line      (bus_err_line),
// verilint 528 on
		     .dcc_pm_fb_active  (dcc_pm_fb_active),
		     .dcc_uncache_load (dcc_uncache_load),
                     .last_word_fill    (last_word_fill)
                     );

   
        // Store Buffer: 
        // Seperate out hit_fb, since we will never need to write the cache immediately after hit_fb

	assign early_held_hit = ( (dcached & cache_hit & cacheread_m) | spram_hit_for_atomicwrite) |
			 (held_hit_reg & local_fixup_m);   

	assign spram_hit_atomic_ld_raw = spram_hit & mpc_atomic_m & !held_dtmack & valid_d_access;
	assign spram_hit_atomic_ld = spram_hit & mpc_atomic_m & !held_dtmack & valid_d_access & ~mpc_exc_m;
	assign spram_lock_stall = sp_stall || storewrite_m;
	mvp_register #(1) _spram_hit_in_atomic(spram_hit_in_atomic, gclk, greset? 1'b0: mpc_run_ie & spram_hit_atomic_ld | spram_hit_in_atomic & spram_lock_stall);
	mvp_register #(1) _spram_hit_in_atomic_hold(spram_hit_in_atomic_hold, gclk, greset? 1'b0: ~mpc_run_ie & (spram_hit_atomic_ld | spram_hit_in_atomic_hold));
	mvp_register #(1) _spram_hit_in_atomic_delay(spram_hit_in_atomic_delay, gclk, greset? 1'b0: mpc_run_ie & spram_hit_in_atomic_hold | spram_hit_in_atomic_delay & spram_lock_stall);
	assign spram_hit_for_atomicwrite = spram_hit | spram_hit_in_atomic | spram_hit_in_atomic_delay; 
	
        assign kick_atomic_write_raw = (spram_hit_in_atomic | spram_hit_in_atomic_delay);
	mvp_register #(1) _kick_atomic_write_hold(kick_atomic_write_hold, gclk, greset? 1'b0 : spram_lock_stall & ( kick_atomic_write_raw | kick_atomic_write_hold));
	assign kick_atomic_write = (kick_atomic_write_hold | kick_atomic_write_raw) & !spram_lock_stall;
	
	mvp_register #(1) _kick_atomic_write_reg(kick_atomic_write_reg, gclk, kick_atomic_write);
	assign dcc_spram_write = kick_atomic_write; 
	
	mvp_register #(1) _dsp_lock_hold(dsp_lock_hold, gclk, dsp_lock_start || (dsp_lock_hold & ~killmiss_m & ( dsp_lock_hold_hit | spram_hit | sp_stall) & ~dcc_ev & ~dcc_spram_write));
	mvp_register #(1) _dsp_lock_hold_hit(dsp_lock_hold_hit, gclk, greset? 1'b0 : dsp_lock_hold & (dsp_lock_hold_hit | spram_hit) & !held_dtmack);
	assign dsp_lock_present = dsp_lock_start || dsp_lock_hold & ~killmiss_m & (dsp_lock_hold_hit |spram_hit | sp_stall) & ~dcc_ev;
	

	assign held_hit = ~killmiss_m & ~par_kill_m & (early_held_hit | (dcached & hit_fb & ~fb_repl_inf_mx[`M14K_FBR_NOFILL]));
	
	mvp_register #(1) _held_hit_reg(held_hit_reg, gclk, held_hit & ~flush_sb);

	assign storebuff_validbits_mx [3:0] = (dstore_m) ? 
			       ((early_held_hit & ~killmiss_m & ~flush_sb & ~cp2_exc_w) ? held_be[3:0] : 4'b0) : 
				       sb_valid_bits[3:0] & {4{~(greset | flush_sb | cp2_storekill_w_real)}};

	mvp_cregister_wide #(4) _sb_valid_bits_3_0_(sb_valid_bits[3:0],gscanenable,
					     ((dstore_m & ~ev_stall) | greset | flush_sb | cp2_storekill_w_real), 
					     gclk, 
					     storebuff_validbits_mx);

        ///////
        // Write Allocate -
        // After detecting a WA store miss, we fetch the missed line before writting
        // the store to the cache. We transfer the store from the Store Buffer to the Fill Buffer when the
        // read request is sent to the BIU. 
        ///////
        assign store_allocate = ~(store_alloc_dis | greset) & ((store_alloc_issue  &  store_alloc_en) |
				                          (store_allocate_reg & ~store_alloc_en));
   
        mvp_register #(1) _store_allocate_reg(store_allocate_reg, gclk, store_allocate);

        assign store_alloc_issue = dstore_m & (dcached & ~wt_nwa) & 
			    ~killmiss_m & ~store_alloc_flush &
			    ~hit_fb & 
			    //~(spram_hit) & 
			    ~(spram_hit_for_atomicwrite) &
			    ~(cache_hit & raw_dstore_m) & ~(|sb_valid_bits[3:0] & ~raw_dstore_m);

        assign store_alloc_en = dstore_m & (~store_alloc_en_stall);   

        assign store_alloc_en_stall = (fb_full & ~wb) | sp_stall |				       
			       (cp2_fixup_w & ~cp2_datasel_real);

        assign store_alloc_dis = sb_to_fb_stb | store_alloc_hit_fb | killmiss_m | store_alloc_flush_reg | 
			  fb_wb_idx_match | fb_wb_idx_match_reg | (~dstore_m);   

        // the store miss hits in the FB while a previous fetch is returning.
        mvp_cregister #(1) _store_alloc_hit_fb(store_alloc_hit_fb,advance_m | ~dstore_m | hit_fb, gclk, 
//				       hit_fb & dstore_m & ~killmiss_m & dcc_dmiss_m);   
				       hit_fb & dstore_m & ~killmiss_m & ~par_kill_m & dcc_dmiss_m);   
        // store buffer was flushed after the store hit and while we were stalling to write the store to mem, 
        //       don't turn it into a store allocate and try to do a read.
        mvp_cregister #(1) _store_alloc_flush_reg(store_alloc_flush_reg,advance_m | ~dstore_m | (flush_sb & ~store_alloc_flush_reg), gclk, 
				      dstore_m & ~killmiss_m & ~par_kill_m & dcc_dmiss_m & store_alloc_flush);
        assign store_alloc_flush = flush_sb & (|sb_valid_bits[3:0]);
   
        // strobe SB data into the fill buffer      
        assign sb_to_fb_stb = (store_allocate_reg | cp2_storealloc_reg_reg) & dcc_exrdreqval; 

        // Flush the Store Buffer if there is a write to the line the store hit on
        // or if we just moved the store buffer entry to the cache because of a cacheop
        // Inclusion of Addr[13:10] is based on Way Size of Cache (1,2,4K,8K,16K)
        // Seperate out way hit detection and DCacheWrite signals since they are late	
        // since the first line write invalidates the current line, just invalidate the sb then   
	mvp_register #(1) _pre_flush_sb(pre_flush_sb, gclk, ((fill_addr_lo[13:4] & index_mask[13:4]) == (storebuff_idx_mx[13:4] 
										  & index_mask[13:4])));   

	mvp_ucregister_wide #(4) _repl_wway_reg_3_0_(repl_wway_reg[3:0],gscanenable, ld_tag_reg | fb_trans_btof_reg, gclk, repl_wway);
	
	assign way_hit = (repl_wway_reg == store_way_reg);

	mvp_register #(1) _block_hit_fb_reg(block_hit_fb_reg, gclk, block_hit_fb);
	
	assign flush_sb = ~(dstore_m & (block_hit_fb_reg | wb)) & pre_flush_sb & cachewrite_m & way_hit | 	   
		   dcop_access_m | prefetch | (ev_sb_hitdone_reg & ~ev_wrtag_noinv) | dsync_m | fb_wb_idx_match |
		   //storewrite_m;
		   storewrite_m | kick_atomic_write_reg;
	

	assign spram_sel_atomic_write[3:0] = {4{(dstore_m & (spram_hit_in_atomic | spram_hit_in_atomic_delay))}} & spram_way;
        assign store_way [3:0] = (dstore_m & ((cache_hit & cacheread_m) |
					//(spram_hit))
					(spram_hit_for_atomicwrite))
			   ) ? (block_hit_way | spram_sel_atomic_write):
			  (dstore_m & hit_fb) ? fb_repl_inf_mx[`M14K_FBR_REPLWAY] : 
			  greset ? 4'b0 : 
			  store_way_reg;
	
	mvp_register #(4) _store_way_reg_3_0_(store_way_reg[3:0], gclk, store_way);
	
	assign storebuff_tag_mx [`M14K_PAH] = (dstore_m) ? mmu_dpah : storebuff_tag;

	mvp_cregister_wide #(22) _storebuff_tag_31_10_(storebuff_tag[`M14K_PAH],gscanenable, dstore_m, gclk, storebuff_tag_mx);
	
	assign sb_dsp_hit = |(store_way_reg & spram_way);

	assign storebuff_idx_mx [19:2] = (dstore_m) ? dcc_dval_m[19:2] : storebuff_idx[19:2];
	
	mvp_cregister_wide #(18) _storebuff_idx_19_2_(storebuff_idx[19:2],gscanenable, dstore_m, gclk, storebuff_idx_mx);

	assign storebuff_data_mx [31:0] = (dstore_m & ~mpc_fixup_m & ~cp2_datasel_real) ? 				     
                                  edp_stdata_iap_m[31:0] : storebuff_data;

	mvp_cregister_wide #(32) _storebuff_data_reg_31_0_(storebuff_data_reg[31:0],gscanenable, (cp2_datasel_real | (dstore_m & ~dcc_fixup_w)), 	  
					 gclk, storebuff_data_mx);
   
	assign storebuff_data [31:0] = cp2_datasel_real ? cp2_data_w : storebuff_data_reg;						   

        // Match on untranslated address bits
        assign sb_addrhit_word = (dcc_dval_m[3:2] == storebuff_idx[3:2]);
        assign sb_addrhit_lower = (dcc_dval_m[9:4] == storebuff_idx[9:4]); 

        // Match on translated address bits
	assign sb_addrhit_high = (mmu_dpah == storebuff_tag);

        // Only mark as a hit if the upper index bits match
        // Match the virtual aliasing present based on the cache size
        // to make aliasing behavior consistent and SB invisible
        assign sb_addrhit_idx_munge = ((storebuff_idx[13:10] & index_mask[13:10]) ==
			       (dcc_dval_m[13:10] & index_mask[13:10]));

        assign sb_addrhit = sb_addrhit_idx_munge & sb_addrhit_lower & 
		    sb_addrhit_high & sb_addrhit_word;		   

	assign hit_sb [3:0] = {4{sb_addrhit & (dcached | sb_dsp_hit)}} & (held_be [3:0]) & (sb_valid_bits[3:0]); 

	mvp_mux2 #(4) _dcc_exbe_3_0_(dcc_exbe[3:0],ev_exnew_addr, held_be[3:0], ev_ex_be[3:0]);

	mvp_register #(4) _lsbe_md_3_0_(lsbe_md[3:0], gclk, held_be);
   
	assign held_be [3:0] = dcc_fixup_w ? lsbe_md : mpc_lsbe_m;

        // biu data comes from cache during eviction, unless there is an "evict hit" in the store buffer
	mvp_mux2 #(8) _dcc_exdata_31_24_(dcc_exdata[31:24],(ev_exwrreq_val & ~ev_sb_hit_reg[3]) | dmbinvoke, storebuff_data[31:24], ev_ex_dataout[31:24]);
	mvp_mux2 #(8) _dcc_exdata_23_16_(dcc_exdata[23:16],(ev_exwrreq_val & ~ev_sb_hit_reg[2]) | dmbinvoke, storebuff_data[23:16], ev_ex_dataout[23:16]);
	mvp_mux2 #(8) _dcc_exdata_15_8_(dcc_exdata[15:8],(ev_exwrreq_val & ~ev_sb_hit_reg[1]) | dmbinvoke, storebuff_data[15:8], ev_ex_dataout[15:8]);
        mvp_mux2 #(8) _dcc_exdata_7_0_(dcc_exdata[7:0],(ev_exwrreq_val & ~ev_sb_hit_reg[0]) | dmbinvoke, storebuff_data[7:0], ev_ex_dataout[7:0]);   

///////
// LRU Replacement algorithm - (decode)
//   - replacement way found from LRU bits of WS array in combo with FB (if index match).
/*
               Way0  lru[2] Way1
                O <---------- O
                ^ ^         ^ ^        + Find way to select by going in direction
                |  \ lru[4]/  |          of arrows until you can't go any further.
                |   \   ->/   | 
                |    \   /    |        + Set a way most recently used (hit) by pointing
                |     \ /     |          arrows away from it.
          lru[3]|      \      | lru[1]
                |     / \     |
                |    /   \    |
                |   /     \   |
                |  / lru[5]\  |
                | /      -> \ |
                O ----------> O
               Way3  lru[0] Way2
*/
        // FB way encoded (see lru encoding diagram in lru encoding section)
        assign lru[5] = (dc_wsin_full[5] & ~fb_repl[2]) | (fb_repl[0]);
        assign lru[4] = (dc_wsin_full[4] & ~fb_repl[3]) | (fb_repl[1]);   
        assign lru[3] = (dc_wsin_full[3] & ~fb_repl[3]) | (fb_repl[0]);   
        assign lru[2] = (dc_wsin_full[2] & ~fb_repl[1]) | (fb_repl[0]);   
        assign lru[1] = (dc_wsin_full[1] & ~fb_repl[2]) | (fb_repl[1]);   
        assign lru[0] = (dc_wsin_full[0] & ~fb_repl[3]) | (fb_repl[2]);

        // locked and non-existant ways are not available for replacement
        mvp_register #(4) _unavail_3_0_(unavail[3:0], gclk, dunavail[3:0]); 

        // decode
        assign drepl[0] = ~unavail[0] & ((~lru[5] | unavail[2]) & (~lru[3] | unavail[3]) & (~lru[2] | unavail[1]));
        assign drepl[1] = ~unavail[1] & ((~lru[4] | unavail[3]) & (lru[2] | unavail[0]) & (~lru[1] | unavail[2]));
        assign drepl[2] = ~unavail[2] & ((lru[5] | unavail[0]) & (lru[1] | unavail[1]) & (~lru[0] | unavail[3]));
        assign drepl[3] = ~unavail[3] & ((lru[4] | unavail[1]) & (lru[3] | unavail[0]) & (lru[0] | unavail[2]));   

        // detect if miss hit in front fill buffer
        assign fb_repl[3:0] = fb_repl_inf[`M14K_FBR_REPLWAY] & {4{ ((idx_match_fb_repl_reg & ~fb_trans_btof_reg) |
							    (idx_match_fb_b_reg & fb_trans_btof_reg)) &
							   ~fb_repl_inf[`M14K_FBR_NOFILL]}};

        mvp_register #(1) _idx_match_fb_repl_reg(idx_match_fb_repl_reg, gclk, idx_match_fb & (~fill_done | dcc_exrdreqval));

        // Update cache information so that it appears that an outstanding
        // fill has already started filling
        // (Otherwise, the second fill will select the same way)
        // Don't need to update lock, since FandL waits until the fill is done
        assign pending_fill_way [3:0] = fb_repl_inf[`M14K_FBR_REPLWAY] & 
				 {4{ idx_match_fb & ~fb_repl_inf[`M14K_FBR_NOFILL] & |(fb_taglo)}};
   
        // We should only be setting valid
        assign next_valid [3:0] = valid | pending_fill_way | fb_fill_way;
   
	// IllWays:  Cache ways that don't exist
	assign ill_ways [3:0] =  cpz_dcpresent ? {(3'h7 << cpz_dcssize),1'h0} : 4'hf;

	// unavail:  Ways that are not available due to locking or non-existance
	assign dunavail_raw[3:0] = lock | ill_ways;

        assign dunavail[3:0] = (lock & valid) | ill_ways;

	// Valid:  Valid vector with 1's for illegal ways
	assign dvalid[3:0] = ill_ways | next_valid;

	// NoWay: All legal ways of the cache are locked and valid- cannot write to this index
	assign no_way = (cacheread_m | dcop_read_reg) ? (&({dunavail_raw, dvalid})) : no_way_reg;

	mvp_register #(1) _no_way_reg(no_way_reg, gclk, no_way);

	// ReplWay: Real replacement way 
        // prefetch nudge does not evict from the fill buffer
	assign repl_way[3:0] = dcop_pref_hit ? block_hit_way_reg :
			dcc_wsrstb_reg ? drepl : repl_way_reg;   

	mvp_register #(4) _repl_way_reg_3_0_(repl_way_reg[3:0], gclk, repl_way);

        mvp_register #(1) _dcop_pref_hit(dcop_pref_hit, gclk, ((prefnudge_imm | dcop_read_reg) & cache_hit));
        mvp_register #(1) _dcop_pref_hit_reg(dcop_pref_hit_reg, gclk, dcop_pref_hit);
   
        // drop prefetch nudge and synci if line is locked (even if it's dirty).
        mvp_register #(4) _block_hit_way_reg_3_0_(block_hit_way_reg[3:0], gclk, block_hit_way & ~({4{prefnudge_imm | dcop_synci}} & lock[3:0]));

	assign tag_rd_int112 [(T_BITS*4)-1:0] = {spram_cache_tag};


	assign tag_rd_int0 [23:0] = tag_rd_int112[23:0];
        assign tag_rd_int1 [23:0] = tag_rd_int112[T_BITS+23:T_BITS];
        assign tag_rd_int2 [23:0] = tag_rd_int112[2*T_BITS+23:2*T_BITS];
        assign tag_rd_int3 [23:0] = tag_rd_int112[3*T_BITS+23:3*T_BITS];

	//	Lock Bit 
	assign lock [3:0] = { tag_rd_int3[1], tag_rd_int2[1], tag_rd_int1[1], tag_rd_int0[1] };

	//	Tag Comparison

	assign tag_cmp_pa88 [87:0] = {
		tag_rd_int3[23:2],
		tag_rd_int2[23:2],
		tag_rd_int1[23:2],
		tag_rd_int0[23:2]};

	assign tag_cmp_pa [(`M14K_MAX_DC_ASSOC*22)-1:0] = tag_cmp_pa88[(`M14K_MAX_DC_ASSOC*22)-1:0];

	assign tag_cmp_v4 [3:0] = {4{cacheread_m | raw_dcop_read_reg}} & { tag_rd_int3[0], tag_rd_int2[0], tag_rd_int1[0], tag_rd_int0[0] };

	assign tag_cmp_v [(`M14K_MAX_DC_ASSOC)-1:0] = tag_cmp_v4 [(`M14K_MAX_DC_ASSOC)-1:0];

        assign wway_reg_sel [3:0] = ev_dirtyway | ev_dirtyway_reg ? ev_wway_reg[3:0] :
			     dcop_wway[3:0];
        mvp_register #(4) _wway_reg_3_0_(wway_reg[3:0], gclk, wway_reg_sel[3:0]);

	assign cache_hit = cache_way_hit;
	
        m14k_cache_cmp #(22, `M14K_MAX_DC_ASSOC) tagcmp (
		.tag_cmp_data( dcc_tagcmpdata[31:10]),
		.tag_cmp_pa( tag_cmp_pa ),
		.tag_cmp_v( tag_cmp_v ),
		.valid( valid ),
		.line_sel( line_sel ),
		.hit_way( cache_hit_way ),
		.cachehit( cache_way_hit ),
                .spram_support(spram_support)
	);


	assign tag_line_sel[3:0] = (use_idx | dmbinvoke)  ? 
			 (dmbinvoke ? mbtdwayselect : wway_reg) : line_sel;
	assign data_line_sel[3:0] =  (use_idx | dmbinvoke)  ? 
			 (dmbinvoke ? mbddwayselect : wway_reg) : line_sel;


	//	Tag Mux
	m14k_cache_mux #(T_BITS, `M14K_MAX_DC_ASSOC) tagmux (
		.data_in(spram_cache_tag[T_BITS*`M14K_MAX_DC_ASSOC-1:0]),
		.waysel(tag_line_sel | spram_sel),
		.data_out(tagmuxout)
	);

	//	Data Mux
	m14k_cache_mux #(D_BITS, `M14K_MAX_DC_ASSOC) datamux (
		.data_in( spram_cache_data[D_BITS*`M14K_MAX_DC_ASSOC-1:0] ),
		.waysel( data_line_sel | spram_sel ),
		.data_out( datamuxout )
	);
        assign datamuxout_data[31:0] = {datamuxout[3*D_BYTES+7:3*D_BYTES], datamuxout[2*D_BYTES+7:2*D_BYTES],
                                 datamuxout[D_BYTES+7:D_BYTES], datamuxout[7:0]};
	assign dcc_dcoppar_m[3:0] = (PARITY == 1)  && (cpz_pe || gmbinvoke) ?
                                        {datamuxout[4*D_BYTES-1],datamuxout[3*D_BYTES-1],
                                         datamuxout[2*D_BYTES-1],datamuxout[D_BYTES-1]} : 4'b0;

	assign mbtdtag_p = tagmuxout[T_BITS-1];	// parity bit to be flopped for bist
	assign mbdddata_b0_raw[`M14K_D_PAR_BYTES-1:0] = {mbddpar[0],biu_mbdata[7:0]};
	assign mbdddata_b1_raw[`M14K_D_PAR_BYTES-1:0] = {mbddpar[1],biu_mbdata[15:8]};
	assign mbdddata_b2_raw[`M14K_D_PAR_BYTES-1:0] = {mbddpar[2],biu_mbdata[23:16]};
	assign mbdddata_b3_raw[`M14K_D_PAR_BYTES-1:0] = {mbddpar[3],biu_mbdata[31:24]};
	assign mbdddata_b0[D_BYTES-1:0] = mbdddata_b0_raw[D_BYTES-1:0];
	assign mbdddata_b1[D_BYTES-1:0] = mbdddata_b1_raw[D_BYTES-1:0];
	assign mbdddata_b2[D_BYTES-1:0] = mbdddata_b2_raw[D_BYTES-1:0];
	assign mbdddata_b3[D_BYTES-1:0] = mbdddata_b3_raw[D_BYTES-1:0];
	assign mbdddatain[D_BITS-1:0] = {mbdddata_b3, mbdddata_b2, mbdddata_b1, mbdddata_b0};

	assign mbtdtag_raw[`M14K_T_PAR_BITS-1:0] = {mbtdtag_p_reg,biu_mbtag[23:2], cpz_mbtag[1:0]};
	assign mbtdtag[T_BITS-1:0] = mbtdtag_raw[T_BITS-1:0];

	assign mbdspdatain_b0_raw[`M14K_D_PAR_BYTES-1:0] = {mbdsppar[0],dsp_data_raw[7:0]};
	assign mbdspdatain_b1_raw[`M14K_D_PAR_BYTES-1:0] = {mbdsppar[1],dsp_data_raw[15:8]};
	assign mbdspdatain_b2_raw[`M14K_D_PAR_BYTES-1:0] = {mbdsppar[2],dsp_data_raw[23:16]};
	assign mbdspdatain_b3_raw[`M14K_D_PAR_BYTES-1:0] = {mbdsppar[3],dsp_data_raw[31:24]};
	assign mbdspdatain_b0[D_BYTES-1:0] = mbdspdatain_b0_raw[D_BYTES-1:0];
	assign mbdspdatain_b1[D_BYTES-1:0] = mbdspdatain_b1_raw[D_BYTES-1:0];
	assign mbdspdatain_b2[D_BYTES-1:0] = mbdspdatain_b2_raw[D_BYTES-1:0];
	assign mbdspdatain_b3[D_BYTES-1:0] = mbdspdatain_b3_raw[D_BYTES-1:0];
	assign mbdspdatain[D_BITS-1:0] = {mbdspdatain_b3, mbdspdatain_b2, mbdspdatain_b1, mbdspdatain_b0};
	
`M14K_DCCMB_MODULE #(PARITY) dccmb(.gclk( gclk),
			.greset(greset),
			.gmbinvoke(gmbinvoke),
			.dmbinvoke(dmbinvoke),
			.gscanenable(gscanenable),
			.cpz_dcpresent(cpz_dcpresent),
			.cpz_dcnsets(cpz_dcnsets),
			.cpz_dcssize(cpz_dcssize),
			.mbdddatain(mbdddatain),
			.mbtdtagin(mbtdtag),
			.mbwdwsin(dc_wsin_ex),

			.mbddbytesel(mbddbytesel),
			.mbddwayselect(mbddwayselect),
			.mbtdwayselect(mbtdwayselect),
			.mbddaddr(mbddaddr),
			.mbtdaddr(mbtdaddr),
			.mbwdaddr(mbwdaddr),
			.mbddread(mbddread),
			.mbtdread(mbtdread),
			.mbwdread(mbwdread),
			.mbddwrite(mbddwrite),
			.mbtdwrite(mbtdwrite),
			.mbwdwrite(mbwdwrite),
			.mbdddata(mbdddata),
			.mbtddata(mbtddata),
			.mbwddata(mbwddata),
			.gmbddfail(gmbddfail),
			.gmbtdfail(gmbtdfail),
			.gmbwdfail(gmbwdfail),
			.gmb_dc_algorithm(gmb_dc_algorithm),
			.dcc_mbdone(dcc_mbdone));

`M14K_DSPMB_MODULE #(PARITY) dspmb(.gclk( gclk),
			.greset(greset),
			.gmbinvoke(gmbinvoke),
			.dspmbinvoke(dspmbinvoke),
			.gscanenable(gscanenable),
			.cpz_dsppresent(cpz_dsppresent),
			.dsp_size(dsp_size),
			.mbdspdatain(mbdspdatain),

			.mbdspbytesel(mbdspbytesel),
			.mbdspaddr(mbdspaddr),
			.mbdspread(mbdspread),
			.mbdspwrite(mbdspwrite),
			.mbdspdata(mbdspdata),
			.gmbspfail(gmbspfail),
			.gmb_sp_algorithm(gmb_sp_algorithm),
			.dcc_spmbdone(dcc_spmbdone));

	assign early_advance_m = (mpc_run_m | dcc_fixup_w | ((restart | held_dtmack) & !sp_stall));
	assign early_raw_cacheread_e = ~(mpc_busty_raw_e[2]) & (mpc_busty_raw_e[1] | mpc_busty_raw_e[0]);
	assign early_raw_dsync_e = (mpc_busty_raw_e == 3'h4);
	assign early_cacheread_e = early_raw_cacheread_e & early_advance_m;
	assign early_cachewrite_e = ~(sp_stall |
                          (ev_stall_nofill & ~ev_fbhit_reg)) & fill_data_ready;
	assign early_dcop_access_e = (mpc_busty_raw_e == 3'h6 | mpc_busty_raw_e == 3'h7) & 	// early raw_dcop_access_e
			      early_advance_m;
	assign early_dsync_e = early_raw_dsync_e & early_advance_m;
	assign early_dstore_e = ((mpc_busty_raw_e == 3'h2) | (mpc_busty_raw_e == 3'h3)) & 	// early raw_dstore_e
			      early_advance_m;

	assign early_dstore_write = (early_dstore_e & (dstore_m | storebuff_valid)) |
                       (storewrite_e & storebuff_valid);

	assign early_prefnudge_imm = prefnudge_m & ls_tag_read & ~killmiss_m;
	assign early_imm_store = imm_store & dcached;
	assign early_imm_load  = imm_load  & dcached;
        assign early_imm_cop_prefndg = (dcop_read_reg & dcop_evictable & ~dcop_hit_only) | // index invalidate
                          (dcc_dcopld_m) |  // index load
                          (fandl_read) |  // fetch and lock miss
                          (dcop_read_reg & dcop_hit_only & dcop_evictable) |
                          (early_prefnudge_imm);


	assign early_dcc_drstb = (early_cacheread_e & (mpc_busty_raw_e == 3'h1) & ~scan_mb_stb_ctl) |
                    (dcop_read & ~scan_mb_stb_ctl) |
                    (ev_dirtyway_reg & ~scan_mb_stb_ctl) |
                    scan_mb_drstb;

	assign early_dcc_twstb = (early_cachewrite_e & fb_update_tag & ~scan_mb_stb_ctl) |
                    (dcop_write & ~scan_mb_stb_ctl) |
                    (ev_wrtag_inv & ~scan_mb_stb_ctl) |
                    scan_mb_twstb;

	assign early_dcc_dwstb = (early_cachewrite_e & ~scan_mb_stb_ctl) |
                    (early_dcop_access_e & ~scan_mb_stb_ctl) |
                    (early_dsync_e & ~scan_mb_stb_ctl) |
                    (dcop_d_dc_write & ~scan_mb_stb_ctl) |
                    (early_advance_m & early_dstore_write & ~scan_mb_stb_ctl) |
                    scan_mb_dwstb;

	assign early_dcc_trstb = (early_cacheread_e & ~scan_mb_stb_ctl) |
                    (dcop_read & ~scan_mb_stb_ctl) |
                    (ev_dirtyway & ~scan_mb_stb_ctl) |
                    scan_mb_trstb;

	assign early_dcc_wsrstb = ((early_imm_store | early_imm_load | early_imm_cop_prefndg) &
                      ~fb_wb_idx_match & ~killmiss_m &
                      ~(raw_dsp_hit & ~(dcop_access_m & dcop_indexed)) &
                      ~scan_mb_stb_ctl) |
                     scan_mb_wsrstb;

        assign early_dcc_wswstb = ((early_imm_store | early_imm_load) & ~ev_cur & ~killmiss_m & ~fb_wb_idx_match & ~scan_mb_stb_ctl) |
                     (fb_filled_tag & ~scan_mb_stb_ctl) |
                     (dcop_lru_write & ~scan_mb_stb_ctl) |
                     (ev_wrtag_inv_ws & ~scan_mb_stb_ctl) |
                     scan_mb_wswstb;

	assign dcc_early_data_ce = early_dcc_drstb | early_dcc_dwstb;
	assign dcc_early_tag_ce = early_dcc_trstb | early_dcc_twstb;
	assign dcc_early_ws_ce = early_dcc_wsrstb | early_dcc_wswstb;



	


//
// Parity handling logic
//
`M14K_DC_PARITY	#(PARITY) dcc_parity(.gclk( gclk),
			.gscanenable(gscanenable),
                        .scan_mb_wsrstb(scan_mb_wsrstb),
                        .scan_mb_drstb(scan_mb_drstb),
                        .scan_mb_trstb(scan_mb_trstb),
			.scan_mb_stb_ctl(scan_mb_stb_ctl),
                        .dmbinvoke(dmbinvoke),
                        .dspmbinvoke(dspmbinvoke),
                        .mbdddata(mbdddata),
                        .mbtddata(mbtddata),
			.dcached(dcached_mix),
                        .dcop_read(dcop_read),
                        .dcop_ready(dcop_ready),
                        .dcop_idx_stt(dcop_idx_stt),
			.dcop_idx_ld(dcop_idx_ld),
                        .dcop_access_m(dcop_access_m),
			.dcop_d_write(dcop_d_write),
                        .cacheread_m(cacheread_m),
                        .ev_dirtyway(ev_dirtyway),
                        .ev_dirtyway_reg(ev_dirtyway_reg),
			.ev_word_reg(ev_word_reg),
                        .dcc_wsrstb_reg(dcc_wsrstb_reg),
                        .spram_way(spram_way),
                        .data_line_sel(data_line_sel),
                        .spram_sel(spram_sel),
			.valid(valid),
                        .tag_line_sel(tag_line_sel),
                        .dcc_data_raw(dcc_data_raw),
                        .dcc_data_par(dcc_data_par),
                        .dcc_tagwrdata_raw(dcc_tagwrdata_raw),
                        .dc_wsin(dc_wsin),
                        .spram_cache_tag(spram_cache_tag),
                        .dspram_par_present(dspram_par_present),
                        .DSP_DataAddr(DSP_DataAddr),
			.DSP_DataRdStr(DSP_DataRdStr),
			.DSP_DataRdStr_reg(DSP_DataRdStr_reg),
			.DSP_RPar(DSP_RPar),
			.dcc_drstb(dcc_drstb),
			.dcc_trstb_reg(dcc_trstb_reg),
			.dcc_wsrstb(dcc_wsrstb),
                        .dcc_dataaddr(dcc_dataaddr),
                        .dcc_wsaddr(dcc_wsaddr),
                        .dcc_tagaddr_reg(dcc_tagaddr_reg),
			.cpz_taglo(cpz_taglo),
			.dcop_indexed(dcop_indexed),
			.sp_read_m(sp_read_m),
			.held_dtmack(held_dtmack),
			.spram_cache_data(spram_cache_data),
                        .cpz_pe(cpz_pe),
                        .cpz_po(cpz_po),
			.cpz_pd(cpz_pd),
			.mpc_run_m(mpc_run_m),
			.dcc_fixup_w(dcc_fixup_w),
			.dcc_dcoppar_m(dcc_dcoppar_m),
			.mbddpar(mbddpar),
			.mbdsppar(mbdsppar),
			.mbtdtag_p(mbtdtag_p),
			.mbtdtag_p_reg(mbtdtag_p_reg),
                        .dcc_data(dcc_data),
                        .dcc_tagwrdata(dcc_tagwrdata),
                        .dcc_parerr_m(dcc_parerr_m),
                        .dcc_parerr_w(dcc_parerr_w),
                        .dcc_parerr_cpz_w(dcc_parerr_cpz_w),
                        .dcc_parerr_ev(dcc_parerr_ev),
                        .dcc_parerr_data(dcc_parerr_data),
                        .dcc_parerr_tag(dcc_parerr_tag),
			.dcc_parerr_ws(dcc_parerr_ws),
                        .dsp_data_parerr(dsp_data_parerr),
                        .dcc_derr_way(dcc_derr_way),
                        .dcc_parerr_idx(dcc_parerr_idx),
                        .held_parerr_m(held_parerr_m),
			.exaddr_sel_disable(exaddr_sel_disable),
			.dcc_ev_kill(dcc_ev_kill));

  
 //VCS coverage off 
// 
	// Wire used by TB to determine whether parity is enabled
	wire selpardcc;
  assign selpardcc 		= PARITY ? 1'b1 : 1'b0;
  //VCS coverage on  
  
// 

// Assertion check: Monitor on DSPRAM Bus


endmodule // dc_ctl
