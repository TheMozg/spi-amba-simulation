// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	m14k_icc: Instn Cache Controller
//
//	$Id: \$
//	mips_repository_id: m14k_icc.mv, v 1.77 
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
module	m14k_icc(
	edp_ival_p,
	edp_ival_exe_p,
	edp_iva_i,
	mmu_ipah,
	mmu_itmack_i,
	mmu_itmres_nxt_i,
	mmu_icacabl,
	mmu_imagicl,
	mpc_fixupi,
	mpc_fixupd,
	mpc_run_ie,
	mpc_umipspresent,
	dcc_advance_m,
	greset,
	cpz_rbigend_i,
	mmu_rawitexc_i,
	biu_ibe,
	biu_if_enable,
	biu_ibe_pre,
	mpc_imsquash_i,
	mpc_annulds_e,
	mpc_imsquash_e,
	mpc_isamode_i,
	mpc_isachange0_i,
	mpc_isachange1_i,
	mpc_umipsfifosupport_i,
	mpc_macro_e,
	mpc_sequential_e,
	mpc_atomic_e,
	mpc_atomic_m,
	mpc_hw_ls_i,
	mpc_hold_epi_vec,
	mpc_epi_vec,
	mpc_nonseq_e,
	mpc_nonseq_ep,
	mpc_itqualcond_i,
	cdmm_mputrigresraw_i,
	mpc_squash_i,
	mpc_int_pref,
	mpc_hold_int_pref_phase1_val,
	mpc_cont_pf_phase1,
	mpc_sel_hw_e,
	mpc_chain_take,
	mpc_tint,
	mpc_auexc_x,
	mpc_ibrk_qual,
	dcc_dval_m,
	mmu_dpah,
	mmu_dcmode0,
	mpc_icop_m,
	mpc_iccop_m,
	mpc_coptype_m,
	dcc_copsync_m,
	cpz_taglo,
	cpz_wst,
	cpz_spram,
	cpz_datalo,
	cpz_icnsets,
	cpz_icssize,
	cpz_icpresent,
	cpz_isppresent,
	cpz_goodnight,
	cpz_mx,
	gclk,
	gscanenable,
	gscanmode,
	gscanramwr,
	icc_icop_m,
	icc_idata_i,
	icc_rdpgpr_i,
	icc_dspver_i,
	icc_imiss_i,
	icc_stall_i,
	icc_pcrel_e,
	icc_nobds_e,
	icc_macrobds_e,
	icc_umipsri_e,
	icc_macro_e,
	icc_macroend_e,
	icc_umips_sds,
	icc_umipspresent,
	icc_umipsconfig,
	icc_halfworddethigh_i,
	icc_halfworddethigh_fifo_i,
	icc_umipsmode_i,
	icc_umips_active,
	icc_umipsfifo_imip,
	icc_umipsfifo_ieip2,
	icc_umipsfifo_ieip4,
	icc_umipsfifo_null_i,
	icc_umipsfifo_null_raw,
	icc_umipsfifo_stat,
	icc_macro_jr,
	icc_addiupc_22_21_e,
	icc_umips_16bit_needed,
	icc_icopdata,
	icc_icoptag,
	icc_icopld,
	icc_icopstall,
	icc_preciseibe_i,
	icc_preciseibe_e,
	icc_isachange0_i_reg,
	icc_isachange1_i_reg,
	icc_slip_n_nhalf,
	icc_predec_i,
	icc_poten_be,
	ic_datain,
	ic_tagin,
	ic_wsin,
	ica_parity_present,
	icc_tagaddr,
	icc_trstb,
	icc_twstb,
	icc_tagwren,
	icc_tagwrdata,
	icc_wsaddr,
	icc_wsrstb,
	icc_wswstb,
	icc_wswren,
	icc_wswrdata,
	icc_dataaddr,
	icc_drstb,
	icc_dwstb,
	icc_writemask,
	icc_readmask,
	asid_update,
	icc_data,
	ISP_TagRdValue,
	ISP_Hit,
	ISP_Stall,
	ISP_Present,
	icc_sp_pres,
	icc_spram_stall,
	ISP_TagWrStr,
	ISP_RdStr,
	ISP_DataWrStr,
	ISP_ParityEn,
	ISP_WPar,
	ISP_ParPresent,
	ISP_RPar,
	ISP_Addr,
	ISP_DataTagValue,
	ISP_DataRdValue,
	icc_spwr_active,
	biu_datain,
	biu_idataval,
	biu_datawd,
	biu_lastwd,
	icc_exaddr,
	icc_excached,
	icc_exmagicl,
	icc_exreqval,
	icc_exhe,
	icc_pm_icmiss,
	gmbinvoke,
	icc_mbdone,
	icc_spmbdone,
	gmbdifail,
	gmbtifail,
	gmbwifail,
	gmbispfail,
	gmb_ic_algorithm,
	gmb_isp_algorithm,
	cpz_config_ld,
	icc_early_data_ce,
	icc_early_tag_ce,
	icc_early_ws_ce,
	cpz_pe,
	cpz_po,
	cpz_pi,
	icc_icoppar,
	isp_data_parerr,
	icc_parerr_i,
	icc_parerrint_i,
	icc_parerr_w,
	icc_parerr_cpz_w,
	icc_parerr_data,
	icc_parerr_tag,
	icc_derr_way,
	icc_parerr_idx,
	icc_fb_vld,
	icc_umips_instn_i,
	isp_dataaddr_scr,
	mpc_lsdc1_e,
	cpz_g_rbigend_i,
	cpz_gm_i,
	cpz_g_mx,
	cpz_g_config_ld,
	r_asid_update,
	mmu_r_rawitexc_i,
	cpz_vz);


parameter PARITY =  `M14K_PARITY_ENABLE;

// Calculated parameter

parameter T_BITS = (PARITY == 1) ? `M14K_T_PAR_BITS : `M14K_T_NOPAR_BITS;
parameter D_BITS = (PARITY == 1) ? `M14K_D_PAR_BITS : `M14K_D_NOPAR_BITS;

parameter 	WSWIDTH = `M14K_MAX_IC_ASSOC + 1;
	
	// Core interface
	input [19:1]	edp_ival_p;	// Instn VA Low on fetch
	input [19:1]	edp_ival_exe_p; // Instn VA Low on execute
	input [31:0]	edp_iva_i; 
	input [`M14K_PAH] mmu_ipah;	// Instn PA High
	input		mmu_itmack_i;	// ITLB Miss	
	input		mmu_itmres_nxt_i;	// ITLB Miss resolving next cycle
	input		mmu_icacabl;	// cacheable request	
	input		mmu_imagicl;	// Reference to Probe Space
        input 		mpc_fixupi;     // I$ Miss previous cycle
        input 		mpc_fixupd;     // D$ Miss previous cycle
	input		mpc_run_ie;	// Run signal -> valid request
	input 		mpc_umipspresent;
	input		dcc_advance_m;	// Advance $op
	input		greset;         // chip reset
	input 		cpz_rbigend_i;  // Chip is effectively in BigEndian mode
	input		mmu_rawitexc_i; // Raw ITranslation exception
	input		biu_ibe;        // Instn Bus Error
	input		biu_if_enable;  // Sync BUS 
	input		biu_ibe_pre;    // Previous Instn Bus Error
	input 		mpc_imsquash_i;  // Kill I$ miss due to I-stage exceptions.
	input 		mpc_annulds_e;
	input 		mpc_imsquash_e;  // Kill I$ miss due to E-stage exceptions.
	input 		mpc_isamode_i;      // ISA mode
	input		mpc_isachange0_i;  // Indicates isa change happening during abnormal pipeline process
	input		mpc_isachange1_i;  // Indicates isa change happening during abnormal pipeline process
	input		mpc_umipsfifosupport_i; // Indicates fifo is ready and we do not stall on i-cache miss
	input		mpc_macro_e;	// macro instruction in e-stage
	input 		mpc_sequential_e;   // Next instn will be sequential - may not need to reaccess cache
	input		mpc_atomic_e; 	// Atomic instruction is in E stage
	input		mpc_atomic_m; 	// Atomic instruction is in M stage

	input		mpc_hw_ls_i;	    // HW operation in I-stage
	input		mpc_hold_epi_vec;   // register version of mpc_epi_vec
	input		mpc_epi_vec; 	    // hold pc during auto epilogue until normal return or jump to next interrupt
	input		mpc_nonseq_e;	    // nonsequential instn stream
	input		mpc_nonseq_ep;		// nonsequential pulse
	input		mpc_itqualcond_i;   // itlb exception
	input		cdmm_mputrigresraw_i;
	input	  	mpc_squash_i;	    // Squash I-stage exception
	input		mpc_int_pref;	    // interrup prefetch
	input 		mpc_hold_int_pref_phase1_val;
	input		mpc_cont_pf_phase1; // continue phase1 of interrupt prefetch
	input		mpc_sel_hw_e;	    // select HW operation
	input		mpc_chain_take;     // interrupt chaining has been taken
	input		mpc_tint;	    // interrupt is taken
	input		mpc_auexc_x;	    // Exception has reached end of pipe, redirect fetch

	input		mpc_ibrk_qual;  // ibrk exception
	input [19:2]	dcc_dval_m;	// CacheOp VA Low	

	input [`M14K_PAH] mmu_dpah;	// CacheOp PA High
        input 		mmu_dcmode0;    // Indicates cacheability for CacheOp addresses
	input		mpc_icop_m;	// This is an instn cache op			
	input		mpc_iccop_m;	// This is an instn cache op			
	input [3:0]	mpc_coptype_m;	// cacheop type
	input		dcc_copsync_m;	// signal from dc_ctl indicating that the sync is not done yet
	//tag contains 1 parity bit
	input [25:0]	cpz_taglo;	// Tag for CacheOp 
        input 		cpz_wst;        // write to WS ram on cacheop store
	input 		cpz_spram;      // write to SPRAM on indexed cacheops
	input [31:0] 	cpz_datalo;     // Data for cacheop
	input [2:0]	cpz_icnsets;	// Number of sets   - from Config1
	input [1:0]	cpz_icssize;	// I$ associativity - from Config1
        input 		cpz_icpresent;  // Instn cache is present - from Config1
	input           cpz_isppresent;      // Instn spram is present - from Config0
	input		cpz_goodnight;	// indicates sleep mode. do not start core until core is fully awake
	input		cpz_mx;		// indicates dsp sw enable
	//input		cpz_rslip_e;
	input		gclk;            // Clock
	input 		gscanenable;
	input 		gscanmode;
	input 		gscanramwr;

	output          icc_icop_m;
	output [31:0]	icc_idata_i;	// Instn bus to core					
	output		icc_rdpgpr_i;	// Early decode for SRS selection for RDPGPR instruction
	output		icc_dspver_i;   // identify dsp version of mf/mt/hi/lo/madd/u/msub/u/mult/u
	output		icc_imiss_i;	// Instn ref. missed
	output 		icc_stall_i;    // Stall in i-stage (for SPRAM)
	output 		icc_pcrel_e;    // PC relative instn
	output 		icc_nobds_e;    // jump has no bds
	output		icc_macrobds_e; // macro form of bds
	output 		icc_umipsri_e;  // micromips ri
	output 		icc_macro_e;    // executing macro
	output		icc_macroend_e; // macro end
	output		icc_umips_sds;  // short delay slot
	output 		icc_umipspresent;
	output [1:0]	icc_umipsconfig; // umips positioning	
	output          icc_halfworddethigh_i;	// high half instn is 16b
	output          icc_halfworddethigh_fifo_i; // instn in fifo is 16b
	output		icc_umipsmode_i;	// umips in i-stage + interrupt cases
	output		icc_umips_active;
	output          icc_umipsfifo_imip;	// incr. memory counter
	output          icc_umipsfifo_ieip2;	// incr. PC by 2
	output          icc_umipsfifo_ieip4;	// incr. PC by 4
	output          icc_umipsfifo_null_i;	// instn. slip
	output		icc_umipsfifo_null_raw;//raw instruction slip. only used for tracing. no loading at core level.
	output [3:0]    icc_umipsfifo_stat;	// fifo fullness
	output		icc_macro_jr;		// executing macro jump
	output [1:0]	icc_addiupc_22_21_e;
        output        	icc_umips_16bit_needed;

	output [31:0]	icc_icopdata;	// Cacheop data result from cache			
	output [25:0]	icc_icoptag;	// Cacheop Tag Value (includes 1'b0 for dirty bit)
	output		icc_icopld;     // Load Tag/Data in cpz_taglo/DataLo
	output		icc_icopstall;  // I$op is not done (stall W)
	output 		icc_preciseibe_i;   // I-stage instn being killed by IBE
	output 		icc_preciseibe_e;   // E-stage instn being killed by IBE
	output		icc_isachange0_i_reg; //isa change speed fix
	output		icc_isachange1_i_reg; //isa change speed fix
	output		icc_slip_n_nhalf; //early prepared version for immediate PC detection
	// Native umips outputs only
	output [22:0]	icc_predec_i;
	output		icc_poten_be;

	// I$ interface
	input [(D_BITS*`M14K_MAX_IC_ASSOC-1):0]	ic_datain;	// I$ Data						
	input [(T_BITS*`M14K_MAX_IC_ASSOC-1):0]	ic_tagin;	// I$ Tag

        input [(`M14K_MAX_IC_WS-1):0]              ic_wsin;        // I$ WS

	input           ica_parity_present;     // I$ supports parity

	output [13:4]	icc_tagaddr;	// Index to Tag array	
	output 		icc_trstb;	// Tag Read Strobe					
	output		icc_twstb;	// Tag write strobe					
	output [(`M14K_MAX_IC_ASSOC-1):0]	icc_tagwren;	// Write way/ Access way (Cacheop)			
        output [T_BITS-1:0] 	icc_tagwrdata;   // tag write data

        output [13:4]   icc_wsaddr;     // Index into WS array
        output          icc_wsrstb;     // WS Read Strobe
        output          icc_wswstb;     // WS write strobe
        output [(`M14K_MAX_IC_WS-1):0]     icc_wswren;   // WS write mask
        output [(`M14K_MAX_IC_WS-1):0] icc_wswrdata;   // WS write data

	output [13:2]   icc_dataaddr;   // Tied to TagAddr

	output		icc_drstb;	// Tied to TRStb					
	output 		icc_dwstb;	// Data write Strobe					
	output [(4*`M14K_MAX_IC_ASSOC-1):0]	icc_writemask;	// Data write Byte Mask
	output [`M14K_MAX_IC_ASSOC-1:0]	icc_readmask;
	input		asid_update;
	output [D_BITS-1:0]	icc_data;	// Write Data						

	// Spram Interface
	input [23:0] 	ISP_TagRdValue;      // tag in
	input 		ISP_Hit;	// SPRAM hit
	input 		ISP_Stall;      // SPRAM stall
	input 		ISP_Present;

	output 		icc_sp_pres;
	output		icc_spram_stall;    // ispram stall
       
	output 		ISP_TagWrStr;     // scratchpad tag write strobe
	output 		ISP_RdStr;
	output 		ISP_DataWrStr;
	output		ISP_ParityEn;		// Parity enable for ISPRAM 
	output	[3:0]	ISP_WPar;		// Parity bit for ISPRAM write data 
	input		ISP_ParPresent;		// ISPRAM has parity support
	input	[3:0]	ISP_RPar;		// Parity bits read from ISPRAM
 

	output [19:2] 	ISP_Addr;   // Additional index bits for SPRAM
	output [31:0] 	ISP_DataTagValue;
	input [31:0] 	ISP_DataRdValue;     // data in
	output 		icc_spwr_active;

	// Biu interface
	input [31:0]	biu_datain;	// External Data In					
	input		biu_idataval;	// biu_datain contains valid Instn
	input [1:0]	biu_datawd;	// Which word is being returned
	input		biu_lastwd;	// BIU has completed this request

	output [31:2]	icc_exaddr;	// Addr for I$ miss or uncached I
	output 		icc_excached;	// I Request is cacheable
	output 		icc_exmagicl;	// I Request is to Probe Space
	output		icc_exreqval;	// I Request is valid
	output [1:0] 	icc_exhe;       // Half enables for read request

        output 		icc_pm_icmiss;  // Perf. monitor $ miss
   
	//ICBIST SIgnals
	input		gmbinvoke;
	output		icc_mbdone;
	output		icc_spmbdone;
	output		gmbdifail;
	output		gmbtifail;
	output		gmbwifail;
	output		gmbispfail;
        input   [7:0]   gmb_ic_algorithm; // Alogrithm selection for I$ BIST controller.
        input   [7:0]   gmb_isp_algorithm; // Alogrithm selection for ISPRAM BIST controller.

	input		cpz_config_ld;

        output          icc_early_data_ce;
        output          icc_early_tag_ce;
        output          icc_early_ws_ce;

	// CPZ interface for parity
        input           cpz_pe;             //parity enable bit
        input           cpz_po;             //parity overwrite bit
        input [3:0]     cpz_pi;             //parity bits of I$ data array
        output [3:0]    icc_icoppar;      // Cacheop Parity bits to be stored to ErrCtl register for idx_ld

	output          isp_data_parerr;        // parity error detected on ISPRA
	output          icc_parerr_i;   // parity error detected at I stage
	output		icc_parerrint_i;	// parity error on i-stage
        output          icc_parerr_w;   // parity error detected at W stage
        output          icc_parerr_cpz_w;   // parity error detected at W stage for cpz update
        output          icc_parerr_data;// parity error detected on data ram
        output          icc_parerr_tag; // parity error detected on tag ram
	output	[1:0]	icc_derr_way;
	output	[19:0]	icc_parerr_idx;
	output	[3:0]	icc_fb_vld;
	output [31:0] icc_umips_instn_i;
	output [19:2] 	isp_dataaddr_scr;

        input           mpc_lsdc1_e;
        input           cpz_g_rbigend_i;
        input           cpz_gm_i;
        input           cpz_g_mx;
	input		cpz_g_config_ld;
	input		r_asid_update;
	input		mmu_r_rawitexc_i; 
	input		cpz_vz; 

// BEGIN Wire declarations made by MVP
wire [3:0] /*[3:0]*/ iunavail;
wire early_icop_ws_read;
wire icc_drstb;
wire icc_dspver_i_pre;
wire icc_exmagicl;
wire [31:0] /*[31:0]*/ fb_data0_cnxt;
wire [19:4] /*[19:4]*/ fb_index;
wire ireq;
wire [3:0] /*[3:0]*/ lock_raw;
wire [13:4] /*[13:4]*/ icc_tagaddrintbmunge;
wire first_word_fill;
wire readhit;
wire [3:0] /*[3:0]*/ lock;
wire spram_hit_en_stall;
wire [1:0] /*[1:0]*/ biu_datawd_reg;
wire [31:0] /*[31:0]*/ ic_datain_2;
wire [13:4] /*[13:4]*/ icc_tagaddr;
wire icc_dspver_i;
wire icc_preciseibe_e;
wire last_word_fill;
wire icc_twstb_reg;
wire icop_fill_pend;
wire early_icc_wswstb;
wire [31:9] /*[31:9]*/ icc_tagcmpdata;
wire [T_BITS-1:0] /*[24:0]*/ icc_tagwrdata;
wire isp_data_parerr;
wire [3:0] /*[3:0]*/ pend_fill_way;
wire [3:0] /*[3:0]*/ icop_wway_reg;
wire early_icc_trstb_int;
wire kill_miss_i;
wire three_word_fill;
wire icc_dwstb;
wire [3:0] /*[3:0]*/ iunavail_raw;
wire icc_umipsfifo_imip;
wire umips_active;
wire hit_pre_fetch_md;
wire umips_j;
wire biu_ibe_reg;
wire raw_icop_read_reg;
wire [D_BITS*4:0] /*[144:0]*/ spram_cache_data_lf;
wire [25:0] /*[25:0]*/ icc_icoptag;
wire umips_sds_post;
wire icc_excached;
wire [31:0] /*[31:0]*/ buf_data_in;
wire [3:0] /*[3:0]*/ icc_readmask4;
wire umips_halfworddet_low;
wire icc_umips_active;
wire [31:0] /*[31:0]*/ biu_datain_reg;
wire icop_idx_ld;
wire idx_match_fb_low;
wire umips_pcrel_i;
wire dcached;
wire icc_spram_stall;
wire [3:0] /*[3:0]*/ icc_bytemask;
wire [19:2] /*[19:2]*/ miss_idx;
wire [`M14K_PAH] /*[31:10]*/ fb_taghi_mx;
wire icc_macro_jr;
wire spram_boot;
wire ld_mtag;
wire [5:0] /*[5:0]*/ lru_mask;
wire [5:0] /*[5:0]*/ ic_wsin_full;
wire [31:2] /*[31:2]*/ icc_dpa;
wire [3:0] /*[3:0]*/ icc_umipsfifo_stat;
wire [13:4] /*[13:4]*/ icc_tagaddr_reg;
wire icop_fandl;
wire icc_icop_m;
wire icc_umipsfifo_ieip4;
wire isp_data_parerr_pi;
wire biu_idataval_reg;
wire fb_fill;
wire enable_ireq;
wire [3:0] /*[3:0]*/ valid_nxt;
wire icc_isachange0_i_reg;
wire icop_hit_inv;
wire [(4*`M14K_MAX_IC_ASSOC-1):0] /*[15:0]*/ icc_writemask;
wire [3:0] /*[3:0]*/ fb_repl;
wire icop_fill_hit;
wire idx_match_fb_reg;
wire fb_repl_inf_last_reg;
wire [3:0] /*[3:0]*/ valid_md;
wire [`M14K_MAX_IC_ASSOC-1:0] /*[3:0]*/ icc_readmask;
wire [4:0] /*[4:0]*/ icc_rdpgpr;
wire mpc_int_pref_d;
wire [47:0] /*[47:0]*/ way_select_in_pre;
wire [19:1] /*[19:1]*/ ival_i;
wire early_icc_wsrstb;
wire umips_nobds_post;
wire [31:0] /*[31:0]*/ fb_data1;
wire [3:0] /*[3:0]*/ fb_taglo_mx;
wire hold_imiss_n;
wire cache_sp_hit_reg;
wire [31:0] /*[31:0]*/ mmu_dpah_31_0;
wire icc_preciseibe_i;
wire hold_itmres_nxt;
wire icop_idx_inv;
wire [12:0] /*[12:0]*/ raw_fb_repl_inf;
wire dcached_reg;
wire hold_valid_ic_data;
wire icop_use_idx;
wire early_icache_read_e;
wire icop_indexed;
wire [15:5] /*[15:5]*/ miss_repl_inf;
wire [31:0] /*[31:0]*/ fb_data3;
wire [1:0] /*[1:0]*/ umips_addiupc_22_21_i_post;
wire [47:0] /*[47:0]*/ way_select_in_reg;
wire disable_miss;
wire cache_hit_reg;
wire umips_mp_post;
wire poten_be_init;
wire [`M14K_PAH] /*[31:10]*/ fb_taghi;
wire [3:0] /*[3:0]*/ icc_wway;
wire stop_ireq;
wire kill_i;
wire icop_active_m;
wire icop_write_reg;
wire umips_ri_post;
wire [23:0] /*[23:0]*/ icc_tagwrdata_raw;
wire [D_BITS-1:0] /*[35:0]*/ mbdidatain;
wire macro_e;
wire icc_early_ws_ce;
wire [3:0] /*[3:0]*/ lock_md;
wire tag_updated;
wire icop_ws_read;
wire early_icache_write_e;
wire [(`M14K_MAX_IC_ASSOC*22)-1:0] /*[87:0]*/ tag_cmp_pa;
wire no_way;
wire [(`M14K_MAX_IC_WS-1):0] /*[5:0]*/ icc_wswrdata;
wire ibe_line;
wire icc_parerr_data;
wire [2:0] /*[2:0]*/ edp_iva_i_inc1;
wire [31:0] /*[31:0]*/ umips_wsi_instn;
wire icc_imiss_i;
wire [3:0] /*[3:0]*/ raw_fill_wd_reg;
wire icc_rdpgpr_i_reg;
wire icop_idx_stt;
wire icc_parerr_tag;
wire fill_data_ready;
wire [5:0] /*[5:0]*/ lru_fillmask;
wire [3:0] /*[3:0]*/ irepl;
wire icc_dwstb_reg;
wire [3:0] /*[3:0]*/ index_way_sel;
wire icc_trstb_int;
wire [13:2] /*[13:2]*/ icc_tagaddrintb_pre;
wire requalify_parerr;
wire [31:0] /*[31:0]*/ ic_datain_1;
wire [23:0] /*[23:0]*/ tag_rd_int2;
wire [1:0] /*[1:0]*/ icc_addiupc_22_21_e;
wire icc_rdpgpr_i_int;
wire [31:1] /*[31:1]*/ icc_ipa;
wire ld_tag;
wire ireq_out_reg;
wire [19:2] /*[19:2]*/ miss_idx_mx;
wire req_uncached;
wire be_recovered;
wire [31:0] /*[31:0]*/ icc_umips_instn_i;
wire [3:0] /*[3:0]*/ data_line_sel;
wire valid_ic_data;
wire readmiss;
wire [31:4] /*[31:4]*/ fb_tag;
wire [12:0] /*[12:0]*/ fb_repl_inf_mx;
wire buf_idataval;
wire [D_BITS-1:0] /*[35:0]*/ icc_data;
wire umips_halfworddet_high_post;
wire icc_parerr_i;
wire [((`M14K_MAX_IC_ASSOC + 1)*48-1):0] /*[239:0]*/ umips_instnin;
wire [`M14K_PAH] /*[31:10]*/ dpah_reg;
wire icc_icopld;
wire poten_parerr_hold;
wire [3:0] /*[3:0]*/ tag_line_sel;
wire [13:2] /*[13:2]*/ ival_munge;
wire icc_icopld_d;
wire [3:0] /*[3:0]*/ fill_wd_reg;
wire [19:4] /*[19:4]*/ fb_index_mx;
wire [3:0] /*[3:0]*/ ivalid;
wire [13:2] /*[13:2]*/ icc_dataaddrintbmunge;
wire icc_parerr_data_pi;
wire precise_ibe;
wire icache_read_e;
wire mpc_int_pref_c;
wire icc_twstb;
wire [43:39] /*[43:39]*/ umips_decomp_reglist;
wire isp_icop_fill;
wire [1:0] /*[1:0]*/ icc_exhe;
wire no_way_reg;
wire held_cpz_updated;
wire [3:0] /*[3:0]*/ illegal_ways;
wire [31:0] /*[31:0]*/ fb_data1_cnxt;
wire icop_nop;
wire cache_hit_enable;
wire [3:0] /*[3:0]*/ tag_cmp_mix;
wire fandl_read;
wire [15:0] /*[15:0]*/ icc_writemask16;
wire [31:0] /*[31:0]*/ icc_icopdata;
wire icache_write_i;
wire [3:0] /*[3:0]*/ raw_ldfb;
wire [23:0] /*[23:0]*/ icop_tag;
wire [47:0] /*[47:0]*/ way_select_in_int;
wire enable_ireq_nxt;
wire icc_stall_i;
wire [5:0] /*[5:0]*/ lru_hitdata;
wire [`M14K_D_PAR_BITS-1:0] /*[35:0]*/ mbdidatain_raw;
wire [3:0] /*[3:0]*/ unavail;
wire [23:0] /*[23:0]*/ fill_tag;
wire cur_ins_fetch_md;
wire icc_early_tag_ce;
wire early_icc_trstb;
wire [5:0] /*[5:0]*/ icc_wswrdata_adj;
wire buf_last_wd;
wire [1:0] /*[1:0]*/ buf_data_wd;
wire [3:0] /*[3:0]*/ raw_fb_vld;
wire hit_pre_fetch;
wire icc_slip_n_nhalf;
wire icop_fill_req;
wire umips_macro;
wire icc_poten_be;
wire icc_pm_icmiss;
wire [13:0] /*[13:0]*/ icc_wsaddr_13_0;
wire icop_fill_pend_reg;
wire [43:39] /*[43:39]*/ umips_decomp_reglist_post;
wire [`M14K_PAH] /*[31:10]*/ miss_tag_mx;
wire flush_fb;
wire same_line;
wire umips_mp;
wire icop_read;
wire hold_cpz_updated;
wire [3:0] /*[3:0]*/ fill_data_rdy;
wire [4:4] /*[4]*/ pre_ins_fetch_addr;
wire itmres_nxt;
wire held_tag_updated;
wire icc_wswstb;
wire icc_dspver_i_reg;
wire [19:2] /*[19:2]*/ icc_tagaddrint;
wire hold_itmack;
wire [13:2] /*[13:2]*/ index_mask;
wire [31:0] /*[31:0]*/ fill_data_raw;
wire icc_dspver_i_int;
wire fb_update_tag;
wire tag_invalid;
wire ibe_kill_macro;
wire [(`M14K_MAX_IC_WS-1):0] /*[5:0]*/ icc_wswren;
wire icache_read_i;
wire icc_wsrstb;
wire icop_read_reg;
wire [3:0] /*[3:0]*/ cache_hit_way_md;
wire umips_ri;
wire buf_ibe_reg;
wire mpc_sequential_md;
wire held_tag_invalid;
wire [23:0] /*[23:0]*/ tag_rd_int0;
wire icop_idx_stw;
wire [31:0] /*[31:0]*/ ic_datain_0;
wire ireq_out;
wire icop_ws_write;
wire nonseq_d;
wire [5:0] /*[5:0]*/ lru_data;
wire [D_BITS*4:D_BITS*`M14K_MAX_IC_ASSOC] /*[144:144]*/ spram_cache_data_df;
wire icc_dspver_i_post;
wire hold_tag_updated;
wire [3:0] /*[3:0]*/ tag_cmp_v4;
wire poten_be_line;
wire [`M14K_PAH] /*[31:10]*/ miss_tag;
wire [3:0] /*[3:0]*/ line_sel_md;
wire buf_ibe;
wire [31:0] /*[31:0]*/ icc_idata_i;
wire same_word;
wire icop_lock_no_write;
wire clear_ireq;
wire icop_read_reg2;
wire umips_pcrel_i_post;
wire [`M14K_T_PAR_BITS-1:0] /*[24:0]*/ icc_raw_tagwrdata;
wire icache_miss;
wire ld_mtag_reg;
wire icc_imiss_reg;
wire [4*T_BITS-1:0] /*[99:0]*/ tag_rd_int112;
wire [1:0] /*[1:0]*/ umips_addiupc_22_21_i;
wire [47:0] /*[47:0]*/ wsi_wide_idata_in;
wire [8 : 1] /*[8:1]*/ rdpgpr_dspver_i;
wire [3:0] /*[3:0]*/ irepl_way;
wire icc_sptrstb;
wire cpz_updated;
wire umips_j_post;
wire umips_halfworddet_high;
wire icop_data_write;
wire poten_be_still_raw;
wire [23:0] /*[23:0]*/ tag_rd_int3;
wire [(`M14K_MAX_IC_ASSOC)-1:0] /*[3:0]*/ tag_cmp_v;
wire [31:0] /*[31:0]*/ fb_data0;
wire umipsmode_i;
wire [D_BITS-1:0] /*[35:0]*/ fill_data;
wire umips_halfworddet_low_post;
wire icc_isachange1_i_reg;
wire [3:0] /*[3:0]*/ icc_tagwren4_reg;
wire [31:0] /*[31:0]*/ fb_data2;
wire ld_tag_reg;
wire [19:0] /*[19:0]*/ fill_addr_lo_19_0;
wire umips_macro_post;
wire [31:0] /*[31:0]*/ fb_data2_cnxt;
wire icop_enable_reg;
wire early_icc_drstb;
wire [3:0] /*[3:0]*/ irepl_way_reg;
wire icc_parerrint_i;
wire icc_icopstall;
wire [3:0] /*[3:0]*/ fb_taglo;
wire [5:0] /*[5:0]*/ icc_wswren_adj;
wire [31:0] /*[31:0]*/ icc_ipa_31_0;
wire [5:0] /*[5:0]*/ ic_wsin_ex;
wire spram_hit_en;
wire [D_BITS-1:0] /*[35:0]*/ mbispdatain;
wire in_i_stage;
wire cache_hit_md;
wire [`M14K_MAX_IC_ASSOC-1:0] /*[3:0]*/ icc_tagwren;
wire icc_trstb;
wire [31:0] /*[31:0]*/ ic_datain_3;
wire biu_lastwd_reg;
wire [159:0] /*[159:0]*/ umips_instnin160;
wire icc_halfworddethigh_fifo_i;
wire [5:0] /*[5:0]*/ lru_hitmask;
wire [13:0] /*[13:0]*/ icc_dataaddr_13_0;
wire icc_umipsfifo_null_i;
wire held_itmack;
wire icop_idx_std;
wire icc_early_data_ce;
wire umips_nobds;
wire buffer_data;
wire ifill_done_reg;
wire icc_wsrstb_reg;
wire [3:0] /*[3:0]*/ raw_fill_wd;
wire icc_trstb_reg;
wire icop_hit_inv_hit;
wire [13:2] /*[13:2]*/ icc_dataaddr;
wire [31:2] /*[31:2]*/ icc_exaddr;
wire icc_umipsfifo_null_raw;
wire [22:0] /*[22:0]*/ icc_predec_i;
wire cur_ins_fetch;
wire icop_done;
wire [3:0] /*[3:0]*/ ldfb;
wire early_icc_twstb;
wire [31:0] /*[31:0]*/ icc_exaddr_31_0;
wire ipah_match;
wire early_icc_dwstb;
wire icc_rdpgpr_i_post;
wire [12:0] /*[12:0]*/ fb_repl_inf;
wire icop_ws_valid;
wire icc_rdpgpr_i_pre;
wire icc_halfworddethigh_i;
wire icop_ready;
wire [15:5] /*[15:5]*/ miss_repl_inf_mx;
wire icop_fill;
wire [3:0] /*[3:0]*/ icop_wway;
wire [13:0] /*[13:0]*/ icc_tagaddr_13_0;
wire fb_hit_enable;
wire [`M14K_D_PAR_BITS-1:0] /*[35:0]*/ mbispdatain_raw;
wire [47:0] /*[47:0]*/ way_select_in;
wire [5:0] /*[5:0]*/ mbwi_mask;
wire icc_umips_16bit_needed;
wire [3:0] /*[3:0]*/ icc_tagwren4;
wire buffer_data_reg;
wire [3:0] /*[3:0]*/ repl_wway;
wire [239:0] /*[239:0]*/ umips_instnin240;
wire [5:0] /*[5:0]*/ lru_filldata;
wire icc_exreqval;
wire [1:0] /*[1:0]*/ mask_way_sel;
wire icc_rdpgpr_i;
wire [31:0] /*[31:0]*/ fb_data;
wire [4:4] /*[4]*/ cur_ins_fetch_addr;
wire [13:4] /*[13:4]*/ icc_wsaddr;
wire [3:0] /*[3:0]*/ icc_fb_vld;
wire [5:0] /*[5:0]*/ lru;
wire [19:0] /*[19:0]*/ dcc_dval_m_19_0;
wire icc_umipsfifo_ieip2;
wire icop_enable;
wire fill_read;
wire spram_stall;
wire [1:0] /*[1:0]*/ way_sel_bits;
wire [31:0] /*[31:0]*/ fb_data3_cnxt;
wire hold_tag_invalid;
wire umipsmode_id;
wire mmu_icacabl_md;
wire icc_umipsmode_i;
wire ifill_done;
wire [87:0] /*[87:0]*/ tag_cmp_pa88;
wire [31:0] /*[31:0]*/ umips_wsi_instn_post;
wire [3:0] /*[3:0]*/ spram_sel;
wire nonseq_done;
wire precise_ibe_d;
wire [23:0] /*[23:0]*/ tag_rd_int1;
wire [19:2] /*[19:2]*/ icc_tagaddrintb;
wire icc_sptrstb_int;
wire poten_be_still;
wire idx_match_fb;
wire [7:2] /*[7:2]*/ icop_pag6;
wire clear_valid;
wire kill_e;
wire fandl_read_reg2;
wire icc_parerr_tag_pi;
wire icop_lock_write;
wire [127:0] /*[127:0]*/ spram_cache_data_nopar;
wire icop_write;
wire [19:2] /*[19:2]*/ fill_addr_lo;
wire poss_hit_fb;
wire icache_write_e;
wire [`M14K_D_PAR_BITS-1:0] /*[35:0]*/ fill_raw_data;
wire hit_fb;
wire raw_kill_i;
// END Wire declarations made by MVP



	wire		icc_parerr_i_int;
	wire		poten_be;
	wire		poten_parerr;
	wire		icc_parerr_tag_int, icc_parerr_data_int, isp_data_parerr_int;

	wire		imbinvoke, spram_support;
	wire [T_BITS-1:0]	tagmuxout;
        wire    [47:0]  datamuxout;

	wire		icc_rdpgpr_muxout;
	wire		icc_dspver_muxout;
	wire [3:0]	line_sel;	// Per Line compare and valid
	wire [3:0] 	valid;
	wire [3:0]	valid_raw;
	wire [3:0]	line_sel_raw;
	wire [3:0]	cache_hit_way_raw;
	wire 		icc_umipspresent, pre_umipspresent, post_umipspresent;
	wire [1:0]	icc_umipsconfig;
	wire 		icc_umipsri_e, pre_umipsri_e, post_umipsri_e;
	wire 		icc_macro_e, pre_macro_e, post_macro_e;
	wire 		icc_macroend_e, pre_macroend_e, post_macroend_e;
	wire 		icc_nobds_e, pre_nobds_e, post_nobds_e;
	wire		icc_macrobds_e, pre_macrobds_e, post_macrobds_e;
	wire 		icc_pcrel_e, pre_pcrel_e, post_pcrel_e;
	wire	        pre_icc_halfworddethigh_i  , post_icc_halfworddethigh_i;
	wire	        pre_icc_halfworddethigh_fifo_i  , post_icc_halfworddethigh_fifo_i;
        wire		pre_umipsfifo_imip  , post_umipsfifo_imip;
        wire		pre_umipsfifo_ieip2 , post_umipsfifo_ieip2;
        wire		pre_umipsfifo_ieip4 , post_umipsfifo_ieip4;
        wire		pre_umipsfifo_null  , post_umipsfifo_null;
        wire		pre_umipsfifo_raw   , post_umipsfifo_raw ;
        wire [3:0]	pre_umipsfifo_stat  , post_umipsfifo_stat;
        wire		pre_macro_jr    , post_macro_jr;
	wire [4:0]	umips_rdpgpr, pre_umips_rdpgpr, post_umips_rdpgpr;
	wire [4:0]	icc_dspver_i_presel, pre_icc_dspver_i, post_icc_dspver_i, icc_dspver;
	wire		icc_umips_sds, pre_umips_sds, post_umips_sds, umips_sds;
	wire [31:0]	raw_instn_in_postws, pre_raw_instn_in_postws; 
// verilint 528 off
	wire [31:0]	post_raw_instn_in_postws;
// verilint 528 on
	wire [3:0]	pre_isachange_waysel, post_isachange_waysel, isachange_waysel;
	wire		pre_isachange1_i_reg, post_isachange1_i_reg, isachange1_i_reg;
	wire		pre_isachange0_i_reg, post_isachange0_i_reg, isachange0_i_reg;
	wire		pre_slip_n_nhalf, post_slip_n_nhalf;
	wire [31:0]	pre_icc_umips_instn_i, post_icc_umips_instn_i;
	
	

        wire [(WSWIDTH*48-1):0]           cache_recode;

        wire [47:0]                             wide_idatain;

	wire [3:0] spram_sel_raw, spram_way;
	wire 	   raw_isp_hit;
	wire 	   raw_isp_stall;
        wire 	   isp_write_active;
	wire 	   cache_hit;
	wire [3:0] cache_hit_way;
	
	wire [(D_BITS*`M14K_MAX_IC_ASSOC-1):0] spram_cache_data;
	wire [(T_BITS*`M14K_MAX_IC_ASSOC-1):0] spram_cache_tag;

	wire [`M14K_MAX_IC_ASSOC-1:0] icc_tagwren_reg;
	
	wire [3:0]	mbdiwayselect;	
	wire [3:0]	mbtiwayselect;	
	wire [13:2]     mbdiaddr;       
	wire [13:4]	mbtiaddr;	
	wire [13:4]	mbwiaddr;	
	wire 		mbdiread;		
	wire		mbtiread;		
	wire 		mbwiread;		
	wire 		mbdiwrite;		
	wire 		mbtiwrite;		
	wire 		mbwiwrite;		
	wire [D_BITS-1:0] mbdidata;
	wire [T_BITS-1:0] mbtidata;
	wire [5:0] 	mbwidata;	
	wire [3:0]	fill_data_par;
	wire		icc_tag_par;
	wire [3:0]	mbdipar;
	wire [3:0]	mbisppar;
	wire		sp_stall_en;
	wire		ispram_par_present;
	wire		cache_hit_raw;

	wire    [20:12]         isp_size;
        wire                    ispmbinvoke;
        wire    [31:0]    	isp_data_raw;
        wire    [19:2]          mbispaddr;
        wire                    mbispread;
        wire                    mbispwrite;
        wire    [D_BITS-1:0]    mbispdata;

   

`ifdef M14K_ICC_SCAN_RAM_RWCTL
	wire scan_mb_drstb 	= (mbdiread & ~gscanmode) | (~gscanramwr & gscanmode);
	wire scan_mb_wsrstb 	= (mbwiread & ~gscanmode) | (~gscanramwr & gscanmode);
	wire scan_mb_trstb 	= (mbtiread & ~gscanmode) | (~gscanramwr & gscanmode);
	wire scan_mb_isprstb 	= (mbispread & ~gscanmode) | (~gscanramwr & gscanmode);
	wire scan_mb_dwstb 	= (mbdiwrite & ~gscanmode) | (gscanramwr & gscanmode);
	wire scan_mb_wswstb 	= (mbwiwrite & ~gscanmode) | (gscanramwr & gscanmode);
	wire scan_mb_twstb 	= (mbtiwrite & ~gscanmode) | (gscanramwr & gscanmode);
	wire scan_mb_stb_ctl 	= imbinvoke | gscanmode;
	wire scan_ispmb_stb_ctl	= ispmbinvoke | gscanmode;
`else
	wire scan_mb_drstb 	= mbdiread;
	wire scan_mb_wsrstb 	= mbwiread;
	wire scan_mb_trstb 	= mbtiread;
	wire scan_mb_isprstb 	= mbispread;
	wire scan_mb_dwstb 	= mbdiwrite;
	wire scan_mb_wswstb 	= mbwiwrite;
	wire scan_mb_twstb 	= mbtiwrite;
	wire scan_mb_stb_ctl 	= imbinvoke;
	wire scan_ispmb_stb_ctl	= ispmbinvoke;
`endif

`ifdef M14K_ICC_SCAN_RAM_ADDRCTL
	wire [13:2] scan_mb_diaddr 	= mbdiaddr & {12{~gscanmode}};
	wire [13:4] scan_mb_tiaddr 	= mbtiaddr & {10{~gscanmode}};
	wire [13:4] scan_mb_wiaddr 	= mbwiaddr & {10{~gscanmode}};
	wire [19:2] scan_mb_ispaddr      = mbispaddr & {18{~gscanmode}};
	wire scan_mb_addr_ctl 		= imbinvoke | gscanmode;

`ifdef M14K_ICC_SCAN_OBSERVE_FLOPS
	wire [`M14K_ICCSC_MAX:0] iccscancov_bus;   
	wire [`M14K_ICCSC_MAX:0] iccscancov;   

	mvp_ucregister_wide #(`M14K_ICCSC_MAX+1) _iccscancov_(iccscancov[`M14K_ICCSC_MAX:0],
							     gscanenable, gscanmode, gclk, 
							     iccscancov_bus);
	assign iccscancov_bus[`M14K_ICCSC_TAGADDR] = icc_tagaddrintb_pre;
	assign iccscancov_bus[`M14K_ICCSC_IVA] = ival_munge;
	assign iccscancov_bus[`M14K_ICCSC_ICCWAY] = icc_wway[`M14K_MAX_IC_ASSOC-1:0];
	assign iccscancov_bus[`M14K_ICCSC_ICCTWAY] = icc_tagwren;
`endif

`else
	wire [13:2] scan_mb_diaddr 	= mbdiaddr;
	wire [13:4] scan_mb_tiaddr 	= mbtiaddr;
	wire [13:4] scan_mb_wiaddr 	= mbwiaddr;
	wire [19:2] scan_mb_ispaddr      = mbispaddr;
	wire scan_mb_addr_ctl 		= imbinvoke;
`endif


  
 //VCS coverage off 
// 
   
   //verilint 550 off	Mux is inferred: case (1'b1)
   //verilint 226 off 	Case-select expression is constant
   //verilint 225 off 	Case expression is not constant
   //verilint 180 off 	Zero extension of extra bits
   //verilint 528 off 	Variable set but not used
   // Generate a text description of state and next state for debugging
	assign icc_dataaddr_13_0[13:0] = {icc_dataaddr[13:2], 2'b0};
	assign icc_exaddr_31_0[31:0] = {icc_exaddr[31:2], 2'b0};
	assign icc_wsaddr_13_0[13:0] = {icc_wsaddr[13:4], 4'b0};
	assign icc_tagaddr_13_0[13:0] = {icc_tagaddr[13:4], 4'b0};
	assign icc_ipa_31_0[31:0] = {icc_ipa[31:1], 1'b0};
	assign fill_addr_lo_19_0[19:0] = {fill_addr_lo[19:2], 2'b0};
	assign mmu_dpah_31_0[31:0] = {mmu_dpah[31:10], 10'b0};
	assign dcc_dval_m_19_0[19:0] = {dcc_dval_m[19:2], 2'b0};
	assign ic_datain_0[31:0] = spram_cache_data_nopar[31:0];
	assign ic_datain_1[31:0] = spram_cache_data_nopar[63:32];
	assign ic_datain_2[31:0] = spram_cache_data_nopar[95:64];
	assign ic_datain_3[31:0] = spram_cache_data_nopar[127:96];
   //verilint 550 on	Mux is inferred: case (1'b1)
   //verilint 226 on 	Case-select expression is constant
   //verilint 225 on 	Case expression is not constant
   //verilint 180 on 	Zero extension of extra bits
   //verilint 528 on 	Variable set but not used
    // else MIPS_ACCELERATION_BUILD
  //VCS coverage on  
  
// 

	//native umips only signals
	assign icc_predec_i[22:0] = 23'b0;
	assign icc_poten_be = 1'b0;



	assign dcached = ~mmu_dcmode0;

	assign held_itmack = mmu_itmack_i | hold_itmack;
	mvp_register #(1) _hold_itmack(hold_itmack, gclk, held_itmack & spram_stall);

        assign itmres_nxt = mmu_itmres_nxt_i | hold_itmres_nxt;
        mvp_register #(1) _hold_itmres_nxt(hold_itmres_nxt, gclk, itmres_nxt & spram_stall);
   
	// Do not strobe spram data when atomic instruction is in E stage
	 assign icache_read_e = ((mpc_run_ie & ~(mpc_atomic_e & spram_stall)) | (itmres_nxt & ~spram_stall) | mpc_fixupi) &
			~icc_imiss_i & ~cpz_goodnight & ~greset;


        assign icache_write_e = ~icache_read_e & ~spram_stall & ~isp_write_active & fill_data_ready & ~cpz_goodnight;

	mvp_register #(1) _mpc_int_pref_c(mpc_int_pref_c, gclk, (mpc_int_pref | mpc_cont_pf_phase1) & ~greset);
	assign mpc_int_pref_d = mpc_int_pref_c & ~(mpc_int_pref | mpc_cont_pf_phase1);
	assign umipsmode_i = mpc_fixupi ? (mpc_int_pref_d & ~mpc_sel_hw_e) ? mpc_isamode_i : umipsmode_id : mpc_isamode_i;

        mvp_register #(1) _umipsmode_id(umipsmode_id, gclk, umipsmode_i);

	assign same_word = 1'b0; 

	assign valid_ic_data = (icc_trstb_reg & ~raw_icop_read_reg) | hold_valid_ic_data;
	mvp_register #(1) _hold_valid_ic_data(hold_valid_ic_data, gclk, valid_ic_data & ~icc_twstb & ~icc_dwstb & ~icc_trstb);
   
	mvp_cregister_wide #(19) _ival_i_19_1_(ival_i[19:1],gscanenable, (mpc_run_ie | mpc_fixupi) & ~icc_imiss_i, gclk, edp_ival_p[19:1]);

        mvp_register #(1) _dcached_reg(dcached_reg, gclk, dcached);

	mvp_ucregister_wide #(22) _dpah_reg_31_10_(dpah_reg[`M14K_PAH],gscanenable, mpc_icop_m, gclk, mmu_dpah);
	assign icc_dpa [31:2] = {dpah_reg, dcc_dval_m[`M14K_PALHI:2]}; 

	assign icc_icop_m = icop_active_m & icop_ready;
	assign icc_tagaddrint [19:2] = (icop_active_m & icop_ready) ? dcc_dval_m[19:2] : fill_addr_lo[19:2];

        assign icc_tagaddrintb [19:2] = itmres_nxt ? ival_i[19:2] : icc_tagaddrint;


	assign index_mask[13:2] = {(cpz_icnsets[2:0] > 3'h3),     // > 8K/way
				(cpz_icnsets[2:0] > 3'h2), // > 4K/way
				(cpz_icnsets[2:0] > 3'h1), // > 2K/way
				(|cpz_icnsets[2:0]),       // > 1K/way
				{8{1'b1}}};
	// Based on cache size, mask the upper address bits

	assign icc_tagaddrintb_pre   [13:2] = icc_tagaddrintb[13:2] & index_mask[13:2];
	assign icc_tagaddrintbmunge  [13:4] = scan_mb_addr_ctl ? scan_mb_tiaddr : 
				       icc_tagaddrintb_pre[13:4];
	assign icc_dataaddrintbmunge [13:2] = scan_mb_addr_ctl ? scan_mb_diaddr[13:2] : 
					icc_tagaddrintb_pre[13:2];

	// Based on cache size, mask the upper address bits
	assign ival_munge [13:2] = edp_ival_p[13:2] & index_mask[13:2];


	assign icc_dataaddr [13:2] = ((mpc_run_ie | mpc_fixupi) & ~icc_imiss_i & ~scan_mb_addr_ctl) ? ival_munge :
			      icc_dataaddrintbmunge;
	assign icc_tagaddr [13:4] = ((mpc_run_ie | mpc_fixupi) & ~icc_imiss_i & ~scan_mb_addr_ctl) ? ival_munge[13:4] :
			     icc_tagaddrintbmunge;


        assign icc_tagcmpdata [31:9] = (raw_icop_read_reg) ? {icop_tag[23:2], ~dcached} : {icc_ipa[31:10], ~mmu_icacabl};

	assign spram_sel[3:0] = spram_sel_raw & {4{spram_hit_en}};

	`M14K_ISPRAM_MODULE #(PARITY) spram(
				 .ISP_TagWrStr(ISP_TagWrStr),
				 .gclk( gclk),
				 .gscanenable(gscanenable),
                                 .gscanmode(gscanmode),
				 .mpc_run_ie(mpc_run_ie),
				 .mpc_fixupi(mpc_fixupi),
				 .icc_imiss_i(icc_imiss_i),
				 .edp_ival_p_19_10(edp_ival_p[19:10]),
				 .icc_tagaddrintb(icc_tagaddrintb[19:10]),
				 .icop_write(icop_write),
				 .icop_data_write(icop_data_write),
				 .icop_active_m(icop_active_m),
				 .icop_ready(icop_ready),
				 .icache_write_e(icache_write_e),
				 .icc_tagwren4(icc_tagwren4),
				 .icc_tagaddr(icc_tagaddr),
				 .icc_dataaddr(icc_dataaddr),
				 .ISP_DataWrStr(ISP_DataWrStr),
				 .ISP_RdStr(ISP_RdStr),
				 .icc_sptrstb(icc_sptrstb),
				 .icop_tag(icop_tag),
				 .icc_tagcmpdata(icc_tagcmpdata),
				 .fill_data_raw(fill_data_raw),
				 .icop_idx_stt(icop_idx_stt),
				 .icop_idx_std(icop_idx_std),
				 .icop_fill_pend(icop_fill_pend),
				 .spram_way(spram_way),
				 .spram_sel_raw(spram_sel_raw),
				 .raw_isp_hit(raw_isp_hit),
				 .raw_isp_stall(raw_isp_stall),
				 .sp_stall_en(sp_stall_en),
				 .isp_write_active(isp_write_active),
				 .ISP_Hit(ISP_Hit),
				 .ISP_Stall(ISP_Stall),
				 .icop_use_idx(icop_use_idx),
				 .imbinvoke(imbinvoke),
				 .spram_cache_data(spram_cache_data),
				 .spram_cache_tag(spram_cache_tag),
				 .ISP_TagRdValue(ISP_TagRdValue),
				 .ic_datain(ic_datain),
				 .ic_tagin(ic_tagin),
				 .spram_support(spram_support),
				 .ISP_Present(ISP_Present),
				 .icc_sp_pres(icc_sp_pres),
				 .ispram_par_present(ispram_par_present),
				 .ISP_ParityEn(ISP_ParityEn),
				 .ISP_WPar(ISP_WPar),
				 .ISP_ParPresent(ISP_ParPresent),
				 .ISP_RPar(ISP_RPar),
				 .cpz_pe(cpz_pe),
				 .fill_data_par(fill_data_par),
				 
				 .ISP_Addr(ISP_Addr),
				 .isp_dataaddr_scr(isp_dataaddr_scr),
				 .ISP_DataRdValue(ISP_DataRdValue),
				 .ISP_DataTagValue(ISP_DataTagValue),
				 .icc_spwr_active(icc_spwr_active),
				 .ispmbinvoke(ispmbinvoke),
                                 .isp_size(isp_size),
                                 .isp_data_raw(isp_data_raw),
                                 .scan_mb_ispaddr(scan_mb_ispaddr),
                        	 .mbispwrite(mbispwrite),
                                 .scan_ispmb_stb_ctl(scan_ispmb_stb_ctl),
                                 .gscanramwr(gscanramwr),
                                 .mbispdata(mbispdata)
				 );
				 

	assign icc_trstb_int = (icache_read_e & ~same_word & ~scan_mb_stb_ctl ) | (icop_read & ~scan_mb_stb_ctl);
	assign icc_sptrstb_int = (icache_read_e & ~scan_mb_stb_ctl) | 
			(icop_read & ~scan_mb_stb_ctl) |
			scan_mb_isprstb;
	

   	assign icc_trstb = (icache_read_e & ~same_word & ~hit_pre_fetch & ~scan_mb_stb_ctl ) | 
		    (icop_read & ~scan_mb_stb_ctl) | scan_mb_trstb;
	assign icc_drstb = icc_trstb_int | scan_mb_drstb;

	assign icc_sptrstb = icc_sptrstb_int;

        mvp_register #(1) _icc_trstb_reg(icc_trstb_reg, gclk, icc_trstb_int);


	assign icc_twstb = (icache_write_e & fb_update_tag & ~scan_mb_stb_ctl) |
		    (icop_write & ~scan_mb_stb_ctl) | scan_mb_twstb;

	assign icc_bytemask [3:0] = 4'hf;
	assign icc_dwstb = (icache_write_e & ~scan_mb_stb_ctl) | 
		    (icop_data_write & ~scan_mb_stb_ctl) | scan_mb_dwstb;

	assign icc_wway [3:0] = (icop_active_m & icop_ready & ~imbinvoke) ? icop_wway : 
			imbinvoke ? mbdiwayselect [3:0] : repl_wway[3:0];

	assign icc_tagwren4 [3:0] = (icop_active_m & icop_ready & ~imbinvoke) ? icop_wway : 
			     imbinvoke ? mbtiwayselect [3:0] : repl_wway[3:0]; 
	assign icc_tagwren [`M14K_MAX_IC_ASSOC-1:0] = icc_tagwren4[`M14K_MAX_IC_ASSOC-1:0];

	
	assign icc_writemask16 [15:0] = { {4{icc_wway[3]}} & icc_bytemask,
				{4{icc_wway[2]}} & icc_bytemask,
				{4{icc_wway[1]}} & icc_bytemask,
				{4{icc_wway[0]}} & icc_bytemask };

	assign icc_writemask[(4*`M14K_MAX_IC_ASSOC-1):0] = 	icc_writemask16[(4*`M14K_MAX_IC_ASSOC-1):0];

	assign icc_data [D_BITS-1:0] = imbinvoke ? mbdidata[D_BITS-1:0] : fill_data[D_BITS-1:0];

	assign icc_tagwrdata_raw[23:0] = (icop_active_m & icop_ready) ? icop_tag : fill_tag;
	assign icc_raw_tagwrdata [`M14K_T_PAR_BITS-1:0] = {icc_tag_par, icc_tagwrdata_raw};
        assign icc_tagwrdata [T_BITS-1:0] = imbinvoke ? mbtidata : icc_raw_tagwrdata[T_BITS-1:0];


	assign icc_ipa [31:1] = {mmu_ipah[`M14K_PAH], ival_i[`M14K_PALHI:1]};

	mvp_register #(1) _icache_read_i(icache_read_i, gclk, icache_read_e);
	
	mvp_register #(1) _icache_write_i(icache_write_i, gclk, icache_write_e);
	
	assign icop_idx_inv = (mpc_coptype_m == 4'h0);

	assign icop_idx_ld = (mpc_coptype_m == 4'h1) & mpc_iccop_m;

	assign icop_idx_stt = (mpc_coptype_m == 4'h2) & (~cpz_wst | cpz_spram);

	assign icop_idx_stw = (mpc_coptype_m == 4'h2) & (cpz_wst & ~cpz_spram);

	assign icop_idx_std = (mpc_coptype_m == 4'h3) & (cpz_wst | cpz_spram);

	assign icop_hit_inv = (mpc_coptype_m == 4'h4) | (mpc_coptype_m == 4'hf);

	assign icop_fill = (mpc_coptype_m == 4'h5) & dcached_reg & mpc_iccop_m;
	assign icop_nop = (mpc_coptype_m == 4'h6) | ((mpc_coptype_m == 4'h3) & ~(cpz_wst | cpz_spram)) | 
		   (~(dcached_reg) & (mpc_coptype_m >= 4'h5));
	assign icop_fandl = (mpc_coptype_m == 4'h7) & dcached_reg & mpc_iccop_m;

	assign icop_indexed = ~(mpc_coptype_m[2]);

	assign icop_read = icop_active_m & icop_ready & ~raw_icop_read_reg & ~icop_done & (icop_idx_ld | icop_hit_inv | 
						 (icop_fill | icop_fandl) & ~icop_fill_pend & ~icop_read_reg2);

	mvp_register #(1) _raw_icop_read_reg(raw_icop_read_reg, gclk, icop_read | (raw_icop_read_reg & raw_isp_stall));
	assign icop_read_reg = raw_icop_read_reg & ~raw_isp_stall;

	assign icop_write = icop_active_m  & ~icop_done & ((icop_ready & (icop_idx_inv | icop_idx_stt)) |
		    	(icop_read_reg & icop_hit_inv & icop_hit_inv_hit) | 
			(icop_lock_write));
        mvp_register #(1) _icop_write_reg(icop_write_reg, gclk, icop_write);
    
	assign icop_data_write = icop_active_m & ~icop_done & icop_ready & icop_idx_std;

	mvp_register #(1) _icop_done(icop_done, gclk, (icop_active_m & icop_ready & (icop_nop | icop_fill_pend & (icop_fill | icop_fandl))) |
			    icop_write | icop_lock_no_write | icop_data_write | icop_ws_write | (icop_read_reg & icop_indexed) | 
			     (icop_read_reg & icop_hit_inv & ~icop_hit_inv_hit) |
			     (icop_done & ~dcc_advance_m));

	assign icop_enable = hold_imiss_n & icop_enable_reg;
	mvp_register #(1) _icop_enable_reg(icop_enable_reg, gclk, hold_imiss_n & (icop_enable_reg | ~spram_stall));
	
	assign icop_active_m = mpc_icop_m & icop_enable & mpc_fixupd;

	mvp_register #(1) _cache_sp_hit_reg(cache_sp_hit_reg, gclk, cache_hit | raw_isp_hit);
	mvp_register #(1) _cache_hit_reg(cache_hit_reg, gclk, cache_hit);

        assign fandl_read = icop_read_reg & icop_fandl;

	mvp_register #(1) _fandl_read_reg2(fandl_read_reg2, gclk, fandl_read);

	mvp_register #(1) _icop_read_reg2(icop_read_reg2, gclk, icop_read_reg & ~icop_done);

        assign fill_read = icop_read_reg & icop_fill;
	
        assign icop_fill_req = fill_read | ~cache_sp_hit_reg & fandl_read_reg2;

	assign icop_lock_write = cache_hit_reg & fandl_read_reg2;

	assign icop_lock_no_write = (cache_sp_hit_reg & ~cache_hit_reg) & fandl_read_reg2;

        assign icop_fill_pend = icop_fill_pend_reg & ~(icop_done | greset);
  
	mvp_register #(1) _icop_fill_pend_reg(icop_fill_pend_reg, gclk, icop_fill_pend | icop_fill_req);

	assign icop_hit_inv_hit = cache_hit & ((mpc_coptype_m != 4'hf) || !tagmuxout[1]);
	
	assign icop_tag [23:0] = icop_idx_stt ? {cpz_taglo[25:4], cpz_taglo[1], cpz_taglo[3]} :
			 {icc_dpa[31:10], {2{icop_fandl}} & {1'b1, 1'b1}};

        mvp_register #(1) _icop_ws_valid(icop_ws_valid, gclk, cpz_taglo[3] & icop_idx_stt & icop_write); 

        assign way_sel_bits [1:0] = (cpz_icnsets==3'h4) ? dcc_dval_m[15:14] :  // 16KB/way
			     (cpz_icnsets==3'h3) ? dcc_dval_m[14:13] :  // 8KB/way
			     (cpz_icnsets==3'h2) ? dcc_dval_m[13:12] :  // 4KB/way
			     (cpz_icnsets==3'h1) ? dcc_dval_m[12:11] :  // 2KB/way
			                        dcc_dval_m[11:10];      // 1KB/way

	assign mask_way_sel [1:0] = {cpz_icssize[1], |(cpz_icssize[1:0])} & way_sel_bits;

	assign index_way_sel [3:0] = (1'b1 << mask_way_sel) & ~spram_way;
	
	assign icop_wway [3:0] = icop_indexed ? (cpz_spram ? spram_way : index_way_sel) :
			  (icop_read_reg & cache_hit) ? cache_hit_way : 
			  (icop_read_reg & raw_isp_hit) ? spram_way : 
			  icop_wway_reg[3:0];

        mvp_register #(4) _icop_wway_reg_3_0_(icop_wway_reg[3:0], gclk, icop_wway[3:0]);

        assign icop_ws_write = icop_idx_stw & ~icop_done & icop_use_idx & icop_active_m;   
        assign icop_ws_read = (icop_read_reg & icop_idx_ld) | ((fandl_read | fill_read) & ~cache_hit); 
   
	assign icc_icopld = icop_read_reg & icop_idx_ld;
        mvp_register #(1) _icc_icopld_d(icc_icopld_d, gclk, icc_icopld);

	assign icc_icoptag [25:0] = {tagmuxout[23:8], icop_pag6[7:2], tagmuxout[0], 1'b0, tagmuxout[1],tagmuxout[T_BITS-1]};   
        assign icop_pag6[7:2] = icc_icopld_d ? ic_wsin_full[5:0] : tagmuxout[7:2];
	assign icc_icopdata [31:0] = datamuxout[31:0] & {32{!isachange1_i_reg}};

	mvp_register #(1) _icop_use_idx(icop_use_idx, gclk, icop_indexed & icop_active_m & icop_ready);

	assign icop_ready = ~dcc_copsync_m & ifill_done;

	assign icc_icopstall = mpc_icop_m & ~icop_done;

      assign kill_i = mpc_imsquash_i | mmu_rawitexc_i | mmu_r_rawitexc_i | held_itmack | (mpc_squash_i & (mpc_int_pref | mpc_auexc_x) );
	assign kill_e = mpc_imsquash_e;
    assign raw_kill_i = mpc_imsquash_i | mmu_rawitexc_i | mmu_r_rawitexc_i | held_itmack;
	
	assign kill_miss_i = ~(ireq_out & fill_data_ready) & 
		      (mpc_fixupi ? kill_e : raw_kill_i);
	
	assign poten_be_line = buf_ibe & (hit_fb & ~cache_hit);


	mvp_register #(1) _nonseq_d(nonseq_d, gclk, mpc_nonseq_e);
	assign nonseq_done = ~mpc_nonseq_e & nonseq_d;
	mvp_cregister #(1) _poten_be_still_raw(poten_be_still_raw,nonseq_done | greset | poten_be_init | be_recovered, gclk, ~nonseq_done & poten_be_init & ~greset &
				~be_recovered);

	assign be_recovered = 	(~buf_ibe & hit_fb); 
	assign poten_be_still = ~nonseq_done & poten_be_still_raw & ~be_recovered;

	assign edp_iva_i_inc1[2:0] = edp_iva_i[3:2]+2'b01;

	mvp_register #(1) _precise_ibe(precise_ibe, gclk, (poten_be_line &
			((~icc_umipsmode_i & raw_ldfb[ival_i[3:2]]) |
			 ( icc_umipsmode_i & ((raw_ldfb[edp_iva_i[3:2]] & icc_umipsfifo_stat[3:0]==4'b0000) |
					    (raw_ldfb[edp_iva_i_inc1[1:0]] & icc_umipsfifo_stat[3:0]==4'b0001 & ~icc_halfworddethigh_i) |
					    (raw_ldfb[edp_iva_i[3:2]] & icc_umipsfifo_stat[3:0]==4'b0010) 
			 )
			))) 
			);

	assign ibe_kill_macro = poten_be_line & icc_umipsmode_i & 
			((raw_ldfb[edp_iva_i[3:2]] & icc_umipsfifo_stat[3:0]==4'b0000) |
			(raw_ldfb[edp_iva_i_inc1[1:0]] & icc_umipsfifo_stat[3:0]==4'b0001 & ~icc_halfworddethigh_i) |
			(raw_ldfb[edp_iva_i[3:2]] & icc_umipsfifo_stat[3:0]==4'b0010));


	assign poten_be = poten_be_still | poten_be_init;
	assign poten_be_init = (poten_be_line & (icc_umipsmode_i & 
			(raw_ldfb[ival_i[3:2]] 
			)
		  ));

	// notify fifoctrl to stop the fifo b/c there is a parerr
	assign poten_parerr = icc_parerr_i_int | poten_parerr_hold;
	assign icc_parerrint_i = icc_parerr_i_int;
	// detect whether a cache write is happening. if a cache-write occurs on the same parerr index address, then
	// re-evaluate the parerr.
	assign requalify_parerr = 1'b0;
	// hold a possible parity error until a jump is made (false pre-fetch), or parity error is confirmed
	// or the next read does not generate a parity error 
	mvp_register #(1) _poten_parerr_hold(poten_parerr_hold,gclk, poten_parerr & ~icc_parerr_i & ~mpc_nonseq_e & ~requalify_parerr & ~greset
				& ~(raw_kill_i & ~mpc_atomic_e) );
	// delay parerr until the PC is actually reached. icc_parerr_i_int is already qualified by ~mpc_icop_m


	// must wait till the next i-stage read before we can regenerate a parity error
	assign icc_parerr_i = (icc_parerr_i_int | poten_parerr_hold & icache_read_i & ~mpc_atomic_e) & 
				(icc_umipsfifo_stat[3:0] == 4'b0 | 
				 icc_umipsfifo_stat[3:0] == 4'b0010 |
				 (icc_umipsfifo_stat[3:0] == 4'b0001 & ~icc_halfworddethigh_fifo_i)
				); 
	mvp_cregister #(1) _icc_parerr_tag_pi(icc_parerr_tag_pi,icache_read_i | ~mpc_nonseq_e, gclk, icc_parerr_tag_int);
	mvp_cregister #(1) _icc_parerr_data_pi(icc_parerr_data_pi,icache_read_i | ~mpc_nonseq_e, gclk, icc_parerr_data_int);
	mvp_cregister #(1) _isp_data_parerr_pi(isp_data_parerr_pi,greset | ~mpc_nonseq_e | spram_hit_en & raw_isp_hit & ~raw_isp_stall, gclk, isp_data_parerr_int & ~greset);
	assign icc_parerr_tag = icc_parerr_tag_pi | icc_parerr_tag_int;
	assign icc_parerr_data = icc_parerr_data_pi | icc_parerr_data_int;
	assign isp_data_parerr = isp_data_parerr_pi | isp_data_parerr_int;

	mvp_register #(1) _in_i_stage(in_i_stage, gclk, ~mpc_run_ie & ~mpc_fixupi | mpc_atomic_e);


	assign macro_e = icc_macro_e | icc_macroend_e;
	mvp_cregister #(1) _precise_ibe_d(precise_ibe_d,greset | ((mpc_run_ie | mpc_fixupi) & ~icc_imiss_i) | nonseq_done | mpc_nonseq_e, gclk, ~mpc_nonseq_e & ~nonseq_done & icc_macro_e & (precise_ibe | precise_ibe_d) & ~greset);

	assign icc_preciseibe_i = (precise_ibe | precise_ibe_d) & in_i_stage & ~icc_macro_e;
	assign icc_preciseibe_e = (precise_ibe | precise_ibe_d) & ~in_i_stage & ~macro_e;


	assign disable_miss = kill_miss_i | (greset & ~imbinvoke) | hold_imiss_n;

	assign icc_imiss_i = ~(disable_miss | (cache_hit_enable & cache_hit) | (fb_hit_enable & hit_fb)
			| (spram_hit_en & raw_isp_hit & ~raw_isp_stall));

	mvp_register #(1) _icc_imiss_reg(icc_imiss_reg, gclk, icc_imiss_i);

	assign cache_hit_enable = icache_read_i & mmu_icacabl;

	assign fb_hit_enable = icache_read_i | icc_imiss_reg;

        assign spram_hit_en = ((icache_read_i & ~mmu_imagicl) | spram_hit_en_stall) & ~raw_kill_i & 
			~(mpc_squash_i & ~mpc_hold_int_pref_phase1_val);

	mvp_register #(1) _spram_hit_en_stall(spram_hit_en_stall, gclk, spram_hit_en & raw_isp_stall & ~greset);

	assign spram_stall = sp_stall_en & raw_isp_stall;
	assign icc_stall_i = spram_stall | hold_itmack;

        assign icc_spram_stall = spram_stall;
	
	assign stop_ireq = spram_stall | held_itmack;
	
	assign icache_miss = icache_read_i & ~kill_miss_i & mmu_icacabl & ~(cache_hit | hit_fb);
	mvp_register #(1) _icc_pm_icmiss(icc_pm_icmiss, gclk, icache_miss);
   
	mvp_register #(1) _hold_imiss_n(hold_imiss_n, gclk, ~icc_imiss_i & ~mpc_run_ie & ~mpc_fixupi & ~held_itmack);

	assign icc_exaddr [31:2] = {miss_tag_mx, miss_idx_mx[`M14K_PALHI : 2]};
	assign icc_excached = ~miss_repl_inf_mx[`M14K_FBR_UNCACHED];
	assign icc_exmagicl = miss_repl_inf_mx[`M14K_FBR_MAGICL];
	assign icc_exhe [1:0] = miss_repl_inf_mx[`M14K_FBR_HE];

	assign enable_ireq_nxt = fb_repl_inf_mx[`M14K_FBR_LAST] & ~ireq_out & ~greset &
			  ~stop_ireq;
	mvp_register #(1) _enable_ireq(enable_ireq, gclk, enable_ireq_nxt);
	mvp_register #(1) _ireq(ireq, gclk, (icc_imiss_i | icop_fill_req));
	assign icc_exreqval = ireq & enable_ireq;

	assign ireq_out = icc_exreqval | ireq_out_reg;
	assign clear_ireq = greset | buf_idataval;
	mvp_register #(1) _ireq_out_reg(ireq_out_reg, gclk, ireq_out & ~clear_ireq);
	
	mvp_register #(1) _fb_repl_inf_last_reg(fb_repl_inf_last_reg, gclk, fb_repl_inf[`M14K_FBR_LAST]);

	assign ifill_done = ~ireq_out & fb_repl_inf[`M14K_FBR_LAST] & fb_repl_inf_last_reg & ~fill_data_ready;

        assign way_select_in_int [47:0] = hit_fb ? cache_recode[47:0] : way_select_in_reg;
        //For PRE:
        // raw_instn_in_postws needed for isachange to 0. previous way_select_in_reg are umips-recoded. need raw value.
        //For POST: way_select_in_reg is raw already. not needed.
        assign way_select_in_pre [47:0] = (hit_fb | (hold_imiss_n & ~isachange1_i_reg)) & ~imbinvoke ? 
					isachange0_i_reg ? {16'b0, raw_instn_in_postws[31:0]} : way_select_in_int : 
					(icc_umipsconfig[0] & icc_dwstb_reg) ? way_select_in_int : datamuxout;

	mvp_register #(1) _icc_dwstb_reg(icc_dwstb_reg,gclk, icc_dwstb & icc_umipspresent);


	assign icc_idata_i [31:0] = umips_wsi_instn_post[31:0];
	
	mvp_ucregister_wide #(48) _way_select_in_reg_47_0_(way_select_in_reg[47:0],gscanenable,
                                                (imbinvoke | icache_read_i | spram_hit_en | hit_fb | isachange1_i_reg
						| isachange0_i_reg),
                                                gclk, way_select_in);
	
	assign buffer_data = (biu_idataval & ireq_out & fill_data_ready) | (biu_idataval_reg & buffer_data_reg & biu_if_enable);
	mvp_cregister #(1) _buffer_data_reg(buffer_data_reg,biu_if_enable, gclk, buffer_data);
	
	mvp_cregister_wide #(32) _biu_datain_reg_31_0_(biu_datain_reg[31:0],gscanenable, biu_idataval & buffer_data & biu_if_enable, gclk, biu_datain);
	mvp_cregister #(2) _biu_datawd_reg_1_0_(biu_datawd_reg[1:0],biu_if_enable, gclk, biu_datawd);
	mvp_cregister #(1) _biu_lastwd_reg(biu_lastwd_reg,biu_if_enable, gclk, biu_lastwd);
	mvp_cregister #(1) _biu_idataval_reg(biu_idataval_reg,biu_if_enable, gclk, biu_idataval);
	assign biu_ibe_reg = biu_ibe_pre;
	
	assign buf_data_in [31:0] = buffer_data ? biu_datain_reg : biu_datain;
	assign buf_data_wd [1:0] = buffer_data ? biu_datawd_reg : biu_datawd;
	assign buf_last_wd = buffer_data ? biu_lastwd_reg : biu_lastwd;
	assign buf_idataval = buffer_data ? biu_idataval_reg : biu_idataval;
	assign buf_ibe = buffer_data ? biu_ibe_reg : biu_ibe;

	assign buf_ibe_reg = biu_ibe_reg;
        mvp_cregister #(1) _ibe_line(ibe_line,biu_ibe | (icache_write_i & ifill_done) | greset, gclk, 
				biu_ibe & ~ifill_done);

        assign fb_update_tag = first_word_fill | last_word_fill;

        assign last_word_fill = fb_repl_inf[`M14K_FBR_LAST] & three_word_fill;
        assign three_word_fill = (fb_repl_inf[4] & fb_repl_inf[3] & fb_repl_inf[2]) |
			  (fb_repl_inf[3] & fb_repl_inf[2] & fb_repl_inf[1]) |
			  (fb_repl_inf[4] & fb_repl_inf[3] & fb_repl_inf[1]) |
			  (fb_repl_inf[4] & fb_repl_inf[2] & fb_repl_inf[1]);
   
        assign first_word_fill = ~(|fb_repl_inf[`M14K_FBR_FILLED]);
	
	// ldfb:  Load external data into fill buffer
	assign raw_ldfb[3:0] = { buf_data_wd[1] &  buf_data_wd[0], 
	                  buf_data_wd[1] & ~buf_data_wd[0], 
	                 ~buf_data_wd[1] &  buf_data_wd[0], 
	                 ~buf_data_wd[1] & ~buf_data_wd[0]} & 
	                {4{buf_idataval}};
	
	assign ldfb [3:0] = raw_ldfb & {4{~buf_ibe}};

	mvp_ucregister_wide #(32) _fb_data0_31_0_(fb_data0[31:0],gscanenable, ldfb[0], gclk, fb_data0_cnxt);

	assign fb_data0_cnxt [31:0] = raw_ldfb[0] ? buf_data_in : fb_data0;

	mvp_ucregister_wide #(32) _fb_data1_31_0_(fb_data1[31:0],gscanenable, ldfb[1], gclk, fb_data1_cnxt);

	assign fb_data1_cnxt [31:0] = raw_ldfb[1] ? buf_data_in : fb_data1;

	mvp_ucregister_wide #(32) _fb_data2_31_0_(fb_data2[31:0],gscanenable, ldfb[2], gclk, fb_data2_cnxt);

	assign fb_data2_cnxt [31:0] = raw_ldfb[2] ? buf_data_in : fb_data2;

	mvp_ucregister_wide #(32) _fb_data3_31_0_(fb_data3[31:0],gscanenable, ldfb[3], gclk, fb_data3_cnxt);

	assign fb_data3_cnxt [31:0] = raw_ldfb[3] ? buf_data_in : fb_data3;


	mvp_cregister_wide #(22) _fb_taghi_31_10_(fb_taghi[`M14K_PAH],gscanenable, ld_tag, gclk, fb_taghi_mx);
	assign fb_taghi_mx [`M14K_PAH] = ld_tag ? miss_tag : fb_taghi;
	mvp_register #(4) _fb_taglo_3_0_(fb_taglo[3:0], gclk, (fb_taglo_mx | ldfb[3:0]) & ~{4{flush_fb}});
	assign fb_taglo_mx [3:0] = ld_tag ? ldfb : greset ? 4'b0 : fb_taglo;

	mvp_cregister_wide #(16) _fb_index_19_4_(fb_index[19:4],gscanenable, ld_tag, gclk, fb_index_mx[19:4]);
	assign fb_index_mx [19:4] = ld_tag ? miss_idx[19:4] : fb_index[19:4];


	assign fb_repl_inf [12:0] = raw_fb_repl_inf | {8'b0, fill_wd_reg, 1'b0};
	mvp_register #(13) _raw_fb_repl_inf_12_0_(raw_fb_repl_inf[12:0], gclk, fb_repl_inf_mx);
	assign fb_repl_inf_mx [12:0] = (ld_tag ? {miss_repl_inf[12:5], 5'b0} : fb_repl_inf) |
				{12'b0, (buf_last_wd & ( buf_idataval || buf_ibe_reg )) | (greset)};

	assign miss_tag_mx [`M14K_PAH] = ld_mtag ? (icop_active_m ? dpah_reg : mmu_ipah) : miss_tag;
	mvp_ucregister_wide #(22) _miss_tag_31_10_(miss_tag[`M14K_PAH],gscanenable, ld_mtag, gclk, miss_tag_mx);
	
	assign miss_idx_mx[19:2] = ld_mtag ? (icop_active_m ? dcc_dval_m[19:2] : ival_i[19:2]) : miss_idx;
	mvp_ucregister_wide #(18) _miss_idx_19_2_(miss_idx[19:2],gscanenable, ld_mtag, gclk, miss_idx_mx[19:2]);

	assign miss_repl_inf_mx [15:10] = ld_mtag ? {1'b1, 1'b1, 
					      ~icop_active_m & mmu_imagicl, icop_active_m & icop_fandl, req_uncached,
					   (no_way | req_uncached)} :				  
				   miss_repl_inf[15:10];   
        assign miss_repl_inf_mx [9:5] = ld_mtag_reg ? {irepl_way[3:0], 1'b0}:
				 miss_repl_inf[9:5];
	
	mvp_ucregister_wide #(6) _miss_repl_inf_15_10_(miss_repl_inf[15:10],gscanenable, ld_mtag, gclk, miss_repl_inf_mx[15:10]);
	mvp_ucregister_wide #(5) _miss_repl_inf_9_5_(miss_repl_inf[9:5],gscanenable, ld_mtag_reg, gclk, miss_repl_inf_mx[9:5]);      
	
	assign req_uncached = ~(icop_active_m ? dcached_reg : mmu_icacabl);
	
	assign ld_mtag = enable_ireq_nxt;
        mvp_register #(1) _ld_mtag_reg(ld_mtag_reg, gclk, ld_mtag);
   
	assign ld_tag = ireq_out & buf_idataval;
        mvp_register #(1) _ld_tag_reg(ld_tag_reg, gclk, ld_tag);   

	assign hit_fb = poss_hit_fb & ipah_match | icc_macro_e;

	assign ipah_match = (mmu_ipah == fb_taghi_mx) & (mmu_icacabl ^ fb_repl_inf_mx[`M14K_FBR_UNCACHED]);

        assign poss_hit_fb = idx_match_fb & (raw_fb_vld[ival_i[3:2]]);

	assign raw_fb_vld[3:0] = fb_taglo_mx | raw_ldfb;

        assign icc_fb_vld[3:0] = raw_fb_vld[3:0];
	
	assign idx_match_fb_low = (ival_i[9:4] == fb_index_mx[9:4]);
        assign idx_match_fb = idx_match_fb_low & ((ival_i[13:10] & index_mask[13:10]) == (fb_index_mx[13:10] & index_mask[13:10]));
        mvp_register #(1) _idx_match_fb_reg(idx_match_fb_reg, gclk, idx_match_fb);

	assign fb_data [31:0] = (ival_i[3:2] == 2'h0) ? fb_data0_cnxt[31:0] :
		(ival_i[3:2] == 2'h1) ? fb_data1_cnxt[31:0] :
		(ival_i[3:2] == 2'h2) ? fb_data2_cnxt[31:0] :
		fb_data3_cnxt[31:0];

	assign fill_data_rdy [3:0] = fb_taglo & ~(fb_repl_inf[`M14K_FBR_FILLED]);

	assign fill_data_ready = |(fill_data_rdy[3:0]) & ~fb_repl_inf[`M14K_FBR_NOFILL];

	assign raw_fill_wd [3:0] = {(fill_data_rdy[3] & ~|(fill_data_rdy[2:0])), 
			     (fill_data_rdy[2] & ~|(fill_data_rdy[1:0])), (fill_data_rdy[1] & ~fill_data_rdy[0]),
			     fill_data_rdy[0]};

	mvp_register #(4) _raw_fill_wd_reg_3_0_(raw_fill_wd_reg[3:0], gclk, raw_fill_wd);
	assign fill_wd_reg [3:0] = {4{icache_write_i & ~ld_tag_reg}} & raw_fill_wd_reg;
   
	assign fill_data_raw [31:0]	= ifill_done ? cpz_datalo[31:0] :
			  fill_data_rdy[0] ? fb_data0[31:0] :
			  fill_data_rdy[1] ? fb_data1[31:0] :
			  fill_data_rdy[2] ? fb_data2[31:0] :
			  fb_data3[31:0];
	assign fill_raw_data[`M14K_D_PAR_BITS-1:0] = {fill_data_par,fill_data_raw};
        assign fill_data[D_BITS-1:0] = fill_raw_data[D_BITS-1:0];

	assign fb_tag [31:4] = {fb_taghi, fb_index[`M14K_PAL]};
	assign fill_tag [23:0] = {fb_tag[31:10], 
			   fb_repl_inf[`M14K_FBR_LOCK] & last_word_fill & ~ibe_line, 
			   last_word_fill & ~ibe_line};   
		
	assign fill_addr_lo [19:2] = {fb_index[19:4], |(raw_fill_wd[3:2]), raw_fill_wd[3] | raw_fill_wd[1]};		

	assign repl_wway[3:0] = fb_repl_inf[`M14K_FBR_REPLWAY];

	assign flush_fb = (fb_repl_inf_mx[`M14K_FBR_UNCACHED] & (mpc_run_ie | mpc_fixupi) & ~icc_imiss_i) |
		  (ifill_done & mpc_icop_m);
   
        assign icc_wsaddr[13:4] = scan_mb_addr_ctl ? scan_mb_wiaddr : icc_tagaddr_reg[13:4];
        mvp_register #(10) _icc_tagaddr_reg_13_4_(icc_tagaddr_reg[13:4], gclk, icc_tagaddr[13:4]);

        assign icc_wsrstb = (readmiss & ~kill_miss_i & ~scan_mb_stb_ctl) | 
		     (icop_ws_read & ~scan_mb_stb_ctl) | scan_mb_wsrstb;
        
	assign icc_wswstb = (readhit & ~kill_miss_i & ~scan_mb_stb_ctl) |
		     (fb_fill & ~scan_mb_stb_ctl) | 
		     (icop_ws_write & ~scan_mb_stb_ctl) |
		     scan_mb_wswstb; 

        mvp_register #(1) _icc_wsrstb_reg(icc_wsrstb_reg, gclk, icc_wsrstb);

        assign readmiss = icc_trstb_reg & ~(cache_hit | hit_fb) & mmu_icacabl;
        assign readhit = icc_trstb_reg & cache_hit & mmu_icacabl & ~icop_ws_read;
        assign fb_fill = icc_twstb_reg;

        mvp_register #(1) _icc_twstb_reg(icc_twstb_reg, gclk, icc_twstb);

        mvp_register #(`M14K_MAX_IC_ASSOC) icc_tagwren_reg_(icc_tagwren_reg[`M14K_MAX_IC_ASSOC-1:0], gclk, 
							    icc_tagwren[`M14K_MAX_IC_ASSOC-1:0]);

	assign icc_tagwren4_reg [3:0] = {icc_tagwren_reg};

        assign ic_wsin_ex[5:0] = {ic_wsin};
        assign ic_wsin_full[5:0] = (`M14K_MAX_IC_WS == 6) ? ic_wsin_ex :
			    (`M14K_MAX_IC_WS == 3) ? {ic_wsin_ex[2],2'b0,ic_wsin_ex[1:0],1'b0} :
			    (`M14K_MAX_IC_WS == 1 & `M14K_MAX_IC_ASSOC == 2) ? {3'b0,ic_wsin_ex[0],2'b0} :
			    6'b0;
   
        assign icc_wswren[(`M14K_MAX_IC_WS-1):0] = icc_wswren_adj[(`M14K_MAX_IC_WS-1):0];
        assign icc_wswren_adj[5:0] = (`M14K_MAX_IC_WS == 6) ? lru_mask[5:0] :
			      (`M14K_MAX_IC_WS == 3) ? {3'b0,lru_mask[5],lru_mask[2:1]} :
			      (`M14K_MAX_IC_WS == 1 & `M14K_MAX_IC_ASSOC == 2) ? {5'b0,lru_mask[2]} :
			      {5'b0,1'b0};

        assign icc_wswrdata[(`M14K_MAX_IC_WS-1):0] = icc_wswrdata_adj[(`M14K_MAX_IC_WS-1):0];
        assign icc_wswrdata_adj[5:0] = (`M14K_MAX_IC_WS == 6) ? lru_data[5:0] :
				(`M14K_MAX_IC_WS == 3) ? {3'b0,lru_data[5],lru_data[2:1]} :
				(`M14K_MAX_IC_WS == 1 & `M14K_MAX_IC_ASSOC == 2) ? {5'b0,lru_data[2]} :
			        {5'b0,1'b0};

// LRU encoding
	assign mbwi_mask[5:0] = (cpz_icssize==2'd3) ? 6'b111111:
			 (cpz_icssize==2'd2) ? 6'b100110:
		  	 (cpz_icssize==2'd1) ? 6'b000100:
			 6'b000000;
              

        assign lru_mask[5:0] = (icop_ws_write | imbinvoke) ? 
			(imbinvoke ? mbwi_mask[5:0] : 6'h3f) :
			(icc_trstb_reg & cache_hit) ? lru_hitmask[5:0] :
			lru_fillmask[5:0];

        assign lru_hitmask[5] = (cache_hit_way[2] | cache_hit_way[0]);
        assign lru_hitmask[4] = (cache_hit_way[3] | cache_hit_way[1]);
        assign lru_hitmask[3] = (cache_hit_way[3] | cache_hit_way[0]);
        assign lru_hitmask[2] = (cache_hit_way[1] | cache_hit_way[0]);
        assign lru_hitmask[1] = (cache_hit_way[2] | cache_hit_way[1]);
        assign lru_hitmask[0] = (cache_hit_way[3] | cache_hit_way[2]);

        assign lru_fillmask[5] = (icc_tagwren4_reg[2] | icc_tagwren4_reg[0]);
        assign lru_fillmask[4] = (icc_tagwren4_reg[3] | icc_tagwren4_reg[1]);
        assign lru_fillmask[3] = (icc_tagwren4_reg[3] | icc_tagwren4_reg[0]);
        assign lru_fillmask[2] = (icc_tagwren4_reg[1] | icc_tagwren4_reg[0]);
        assign lru_fillmask[1] = (icc_tagwren4_reg[2] | icc_tagwren4_reg[1]);
        assign lru_fillmask[0] = (icc_tagwren4_reg[3] | icc_tagwren4_reg[2]);  

        assign lru_data[5:0] = (icop_ws_write | imbinvoke) ? 
			(imbinvoke ? mbwidata[5:0] : cpz_taglo[9:4]) :
			(icc_trstb_reg & cache_hit) ? lru_hitdata[5:0] :
			(icop_write_reg & ~icop_ws_valid) ? ~(lru_filldata[5:0]) :
			lru_filldata[5:0];

        assign lru_hitdata[5] = (~cache_hit_way[2] | cache_hit_way[0]);
        assign lru_hitdata[4] = (~cache_hit_way[3] | cache_hit_way[1]);
        assign lru_hitdata[3] = (~cache_hit_way[3] | cache_hit_way[0]);
        assign lru_hitdata[2] = (~cache_hit_way[1] | cache_hit_way[0]);
        assign lru_hitdata[1] = (~cache_hit_way[2] | cache_hit_way[1]);
        assign lru_hitdata[0] = (~cache_hit_way[3] | cache_hit_way[2]);

        assign lru_filldata[5] = (~icc_tagwren4_reg[2] | icc_tagwren4_reg[0]);
        assign lru_filldata[4] = (~icc_tagwren4_reg[3] | icc_tagwren4_reg[1]);
        assign lru_filldata[3] = (~icc_tagwren4_reg[3] | icc_tagwren4_reg[0]);
        assign lru_filldata[2] = (~icc_tagwren4_reg[1] | icc_tagwren4_reg[0]);
        assign lru_filldata[1] = (~icc_tagwren4_reg[2] | icc_tagwren4_reg[1]);
        assign lru_filldata[0] = (~icc_tagwren4_reg[3] | icc_tagwren4_reg[2]);

// LRU decoding

        assign lru[5] = (ic_wsin_full[5] & ~fb_repl[2]) | (fb_repl[0]);
        assign lru[4] = (ic_wsin_full[4] & ~fb_repl[3]) | (fb_repl[1]);   
        assign lru[3] = (ic_wsin_full[3] & ~fb_repl[3]) | (fb_repl[0]);   
        assign lru[2] = (ic_wsin_full[2] & ~fb_repl[1]) | (fb_repl[0]);   
        assign lru[1] = (ic_wsin_full[1] & ~fb_repl[2]) | (fb_repl[1]);   
        assign lru[0] = (ic_wsin_full[0] & ~fb_repl[3]) | (fb_repl[2]);

        mvp_register #(4) _unavail_3_0_(unavail[3:0], gclk, iunavail[3:0]);

        assign irepl[0] = ~unavail[0] & ((~lru[5] | unavail[2]) & (~lru[3] | unavail[3]) & (~lru[2] | unavail[1]));
        assign irepl[1] = ~unavail[1] & ((~lru[4] | unavail[3]) & (lru[2] | unavail[0]) & (~lru[1] | unavail[2]));
        assign irepl[2] = ~unavail[2] & ((lru[5] | unavail[0]) & (lru[1] | unavail[1]) & (~lru[0] | unavail[3]));
        assign irepl[3] = ~unavail[3] & ((lru[4] | unavail[1]) & (lru[3] | unavail[0]) & (lru[0] | unavail[2]));

        assign fb_repl[3:0] = fb_repl_inf[`M14K_FBR_REPLWAY] & 
		       {4{ (idx_match_fb_reg & ~fb_repl_inf[`M14K_FBR_NOFILL] & ~ifill_done_reg) }};

        mvp_register #(1) _ifill_done_reg(ifill_done_reg, gclk, ifill_done);
   
        assign pend_fill_way [3:0] = fb_repl_inf[`M14K_FBR_REPLWAY] & {4{ idx_match_fb & ~fb_repl_inf[`M14K_FBR_NOFILL] & 
						    |(fb_taglo) & ~icop_active_m}};
   
        assign valid_nxt [3:0] = valid | pend_fill_way;
   
	assign illegal_ways [3:0] =  cpz_icpresent ? {(3'h7 << cpz_icssize),1'h0} : 4'hf;

	assign iunavail_raw[3:0] = lock | illegal_ways;

	assign iunavail[3:0] = (lock & valid) | illegal_ways;    

	assign ivalid[3:0] = illegal_ways | valid_nxt;

        assign isp_icop_fill = raw_isp_hit & fill_read;
   
	assign no_way = icc_trstb_reg ? (&({iunavail_raw, ivalid, ~isp_icop_fill})) :
		 icop_read_reg ? (no_way_reg & ~isp_icop_fill) : 
		 no_way_reg;

	mvp_register #(1) _no_way_reg(no_way_reg, gclk, no_way);

	assign irepl_way[3:0] = icop_fill_hit ? icop_wway_reg : 
			 icc_wsrstb_reg  ? irepl : irepl_way_reg;   

	mvp_register #(4) _irepl_way_reg_3_0_(irepl_way_reg[3:0], gclk, irepl_way);

        mvp_register #(1) _icop_fill_hit(icop_fill_hit, gclk, icop_read_reg & (cache_hit | raw_isp_hit));

	assign tag_rd_int112 [4*T_BITS-1:0] = {spram_cache_tag};

	assign tag_rd_int0 [23:0] = tag_rd_int112[23:0];
        assign tag_rd_int1 [23:0] = tag_rd_int112[T_BITS+23:T_BITS];
        assign tag_rd_int2 [23:0] = tag_rd_int112[2*T_BITS+23:2*T_BITS];
        assign tag_rd_int3 [23:0] = tag_rd_int112[3*T_BITS+23:3*T_BITS];

	assign lock_raw [3:0] = { tag_rd_int3[1], tag_rd_int2[1], tag_rd_int1[1], tag_rd_int0[1] };

	//Tag Comparison
	assign tag_cmp_pa88 [87:0] = {
		tag_rd_int3[23:2],
		tag_rd_int2[23:2],
		tag_rd_int1[23:2],
		tag_rd_int0[23:2]};

	assign tag_cmp_pa [(`M14K_MAX_IC_ASSOC*22)-1:0] = tag_cmp_pa88[(`M14K_MAX_IC_ASSOC*22)-1:0];

	assign tag_cmp_v4 [3:0] = {4{icache_read_i | raw_icop_read_reg}} & { tag_rd_int3[0], tag_rd_int2[0], tag_rd_int1[0], tag_rd_int0[0] };
	assign tag_cmp_v [(`M14K_MAX_IC_ASSOC)-1:0] = tag_cmp_mix [(`M14K_MAX_IC_ASSOC)-1:0];

	m14k_cache_cmp #(22, `M14K_MAX_IC_ASSOC) tagcmp (
		.tag_cmp_data( icc_tagcmpdata[31:10]),
		.tag_cmp_pa( tag_cmp_pa ),
		.tag_cmp_v( tag_cmp_v ),
		.valid( valid_raw ),
		.line_sel( line_sel_raw ),
		.hit_way( cache_hit_way_raw ),
		.cachehit( cache_hit_raw ),
	        .spram_support( spram_support )
	);

        assign spram_boot = spram_support && !mmu_icacabl;
   
	assign tag_line_sel[3:0] = (icop_use_idx | imbinvoke) ? 
			    (imbinvoke ? mbtiwayselect : icop_wway_reg) : line_sel & {4{!spram_boot}};
	assign data_line_sel[3:0] =  (icop_use_idx | imbinvoke) ? 
			      (imbinvoke ? mbdiwayselect : icop_wway_reg) : line_sel & {4{!spram_boot}};

	assign umips_instnin160 [159:0] = {spram_cache_data_nopar, fb_data};
	assign spram_cache_data_df[D_BITS*4:D_BITS*`M14K_MAX_IC_ASSOC] = {D_BITS*(4-`M14K_MAX_IC_ASSOC)+1{1'b0}};
	assign spram_cache_data_lf[D_BITS*4:0] = {spram_cache_data_df, spram_cache_data};
	assign spram_cache_data_nopar[127:0] = {
		(`M14K_MAX_IC_ASSOC == 4) ? spram_cache_data_lf[3*D_BITS+31:3*D_BITS] : 32'b0,
		(`M14K_MAX_IC_ASSOC >= 3) ? spram_cache_data_lf[2*D_BITS+31:2*D_BITS] : 32'b0,
		(`M14K_MAX_IC_ASSOC >= 2) ? spram_cache_data_lf[D_BITS+31:D_BITS] : 32'b0,
		(`M14K_MAX_IC_ASSOC >= 1) ? spram_cache_data_lf[31:0] : 32'b0 };

	

        assign umips_instnin240 [239:0] = {16'b0, umips_instnin160[159:128], 16'b0, umips_instnin160[127:96],
                              16'b0, umips_instnin160[95:64], 16'b0, umips_instnin160[63:32],
                              16'b0, umips_instnin160[31:0]};
        assign umips_instnin [((`M14K_MAX_IC_ASSOC + 1)*48-1):0] = umips_instnin240[((`M14K_MAX_IC_ASSOC + 1)*48-1):0];

	

	assign umips_active = umipsmode_i & ~(icc_icopld & mpc_icop_m) & ~imbinvoke;
	assign icc_umips_active = umips_active; 
	assign icc_umipsmode_i = umipsmode_i;
	

	`M14K_UMIPS_PREWS_MODULE #(WSWIDTH, 15) umips_prews (
					.gscanenable(gscanenable),
					.raw_instn_in(umips_instnin),
					.instn_in(way_select_in),
					.cpz_rbigend_i(cpz_gm_i ? cpz_g_rbigend_i : cpz_rbigend_i),
					.cpz_mx(cpz_gm_i ? cpz_g_mx : cpz_mx),
					.umipsmode_i(umipsmode_i),
					.umips_active(umips_active),
					.edp_ival_p(edp_ival_p[3:1]),
					.mpc_run_ie(mpc_run_ie),
					.mpc_fixupi(mpc_fixupi),
					.mpc_isachange0_i(mpc_isachange0_i),
					.mpc_isachange1_i(mpc_isachange1_i),
					.mpc_atomic_e(mpc_atomic_e | mpc_lsdc1_e),
					.mpc_hw_ls_i(mpc_hw_ls_i),
					.mpc_sel_hw_e(mpc_sel_hw_e),
					.mpc_hold_epi_vec(mpc_hold_epi_vec),
					.mpc_epi_vec(mpc_epi_vec),
					.mpc_int_pref(mpc_int_pref),
					.mpc_chain_take(mpc_chain_take),
					.mpc_tint(mpc_tint),
					.kill_i(kill_i),
					.ibe_kill_macro(ibe_kill_macro),
					.mpc_annulds_e(mpc_annulds_e),
					.precise_ibe(precise_ibe),
					.mpc_nonseq_e(mpc_nonseq_e),
					.kill_e(kill_e),
					.greset(greset),
					.hit_fb(hit_fb),
					.hold_imiss_n(hold_imiss_n),
					.imbinvoke(imbinvoke),
					.data_line_sel(data_line_sel),
					.spram_sel(spram_sel),
					.icc_imiss_i(icc_imiss_i),
					.mpc_itqualcond_i(mpc_itqualcond_i),
					.cdmm_mputrigresraw_i(cdmm_mputrigresraw_i),
					.biu_ibe(biu_ibe),
					.poten_be(poten_be),
					.poten_parerr(poten_parerr),
					.icc_umipsconfig(icc_umipsconfig),
					.requalify_parerr(requalify_parerr),
					.gclk( gclk),
					.cpz_vz(cpz_vz),
					.instn_out(cache_recode),
					.icc_umipsri_e(pre_umipsri_e),
					.icc_macro_e(pre_macro_e),
					.icc_macroend_e(pre_macroend_e),
					.icc_nobds_e(pre_nobds_e),
					.icc_macrobds_e(pre_macrobds_e),
					.icc_pcrel_e(pre_pcrel_e),
					.icc_umipspresent(pre_umipspresent),
					.icc_halfworddethigh_i(pre_icc_halfworddethigh_i),
					.icc_halfworddethigh_fifo_i(pre_icc_halfworddethigh_fifo_i),
					.umips_rdpgpr(pre_umips_rdpgpr),
					.icc_dspver_i(pre_icc_dspver_i),
					.umips_sds(pre_umips_sds),
					.raw_instn_in_postws(pre_raw_instn_in_postws),
					.umipsfifo_imip(pre_umipsfifo_imip),
					.umipsfifo_ieip2(pre_umipsfifo_ieip2),
					.umipsfifo_ieip4(pre_umipsfifo_ieip4),
					.umipsfifo_null_i(pre_umipsfifo_null),
					.umipsfifo_null_raw(pre_umipsfifo_raw),
					.umipsfifo_stat(pre_umipsfifo_stat),
					.isachange_waysel(pre_isachange_waysel),
					.isachange1_i_reg(pre_isachange1_i_reg),
					.isachange0_i_reg(pre_isachange0_i_reg),
					.slip_n_nhalf(pre_slip_n_nhalf),
					.icc_dwstb_reg(icc_dwstb_reg),
					.icc_umips_instn_i(pre_icc_umips_instn_i),
					.macro_jr(pre_macro_jr)
			    );

	`M14K_UMIPS_POSTWS_MODULE #(1, 16) umips_postws (
					.gscanenable(gscanenable),
					.raw_instn_in(way_select_in),
					.instn_in(wsi_wide_idata_in),
					.cpz_rbigend_i(cpz_gm_i ? cpz_g_rbigend_i : cpz_rbigend_i),
					.cpz_mx(cpz_gm_i ? cpz_g_mx : cpz_mx),
					.umipsmode_i(umipsmode_i),
					.umips_active(umips_active),
					.edp_ival_p(edp_ival_p[3:1]),
					.mpc_run_ie(mpc_run_ie),
					.mpc_fixupi(mpc_fixupi),
                                        .mpc_isachange0_i(mpc_isachange0_i),
                                        .mpc_isachange1_i(mpc_isachange1_i),
					.mpc_atomic_e(mpc_atomic_e | mpc_lsdc1_e),
					.mpc_hw_ls_i(mpc_hw_ls_i),
					.mpc_sel_hw_e(mpc_sel_hw_e),
					.mpc_hold_epi_vec(mpc_hold_epi_vec),
					.mpc_epi_vec(mpc_epi_vec),
					.mpc_int_pref(mpc_int_pref),
					.mpc_chain_take(mpc_chain_take),
					.mpc_tint(mpc_tint),
					.kill_i(kill_i),
					.ibe_kill_macro(ibe_kill_macro),
					.mpc_annulds_e(mpc_annulds_e),
					.precise_ibe(precise_ibe),
					.mpc_nonseq_e(mpc_nonseq_e),
					.kill_e(kill_e),
					.greset(greset),
					.hit_fb(hit_fb),
					.hold_imiss_n(hold_imiss_n),
					.imbinvoke(imbinvoke),
					.data_line_sel(data_line_sel),
					.spram_sel(spram_sel),
					.icc_imiss_i(icc_imiss_i),
					.mpc_itqualcond_i(mpc_itqualcond_i),
					.cdmm_mputrigresraw_i(cdmm_mputrigresraw_i),
					.biu_ibe(biu_ibe),
					.poten_be(poten_be),
					.poten_parerr(poten_parerr),
					.icc_umipsconfig(icc_umipsconfig),
					.requalify_parerr(requalify_parerr),
					.gclk( gclk),
					.cpz_vz(cpz_vz),
					.instn_out(wide_idatain),
					.icc_umipsri_e(post_umipsri_e),
					.icc_macro_e(post_macro_e),
					.icc_macroend_e(post_macroend_e),
					.icc_nobds_e(post_nobds_e),
					.icc_macrobds_e(post_macrobds_e),
					.icc_pcrel_e(post_pcrel_e),
					.icc_umipspresent(post_umipspresent),
					.icc_halfworddethigh_i(post_icc_halfworddethigh_i),
					.icc_halfworddethigh_fifo_i(post_icc_halfworddethigh_fifo_i),
					.umips_rdpgpr(post_umips_rdpgpr),
					.icc_dspver_i(post_icc_dspver_i),
					.umips_sds(post_umips_sds),
// verilint 528 off
					.raw_instn_in_postws(post_raw_instn_in_postws),
// verilint 528 on
					.umipsfifo_imip(post_umipsfifo_imip),
					.umipsfifo_ieip2(post_umipsfifo_ieip2),
					.umipsfifo_ieip4(post_umipsfifo_ieip4),
					.umipsfifo_null_i(post_umipsfifo_null),
					.umipsfifo_null_raw(post_umipsfifo_raw),
					.umipsfifo_stat(post_umipsfifo_stat),
					.isachange_waysel(post_isachange_waysel),
					.isachange1_i_reg(post_isachange1_i_reg),
					.isachange0_i_reg(post_isachange0_i_reg),
					.slip_n_nhalf(post_slip_n_nhalf),
					.icc_dwstb_reg(icc_dwstb_reg),
					.icc_umips_instn_i(post_icc_umips_instn_i),
					.macro_jr(post_macro_jr)
			    );


	assign icc_umipsri_e = pre_umipsri_e | post_umipsri_e;
	assign icc_macro_e = pre_macro_e | post_macro_e;
	assign icc_macroend_e = pre_macroend_e | post_macroend_e;
	assign icc_pcrel_e = pre_pcrel_e | post_pcrel_e;
	assign icc_nobds_e = pre_nobds_e | post_nobds_e;
	assign icc_macrobds_e = pre_macrobds_e | post_macrobds_e;
	assign icc_umipspresent = pre_umipspresent | post_umipspresent;
	assign icc_umipsconfig[1:0] = {pre_umipspresent, post_umipspresent};

	assign icc_halfworddethigh_i = (pre_icc_halfworddethigh_i | post_icc_halfworddethigh_i) ; 
	assign icc_halfworddethigh_fifo_i = pre_icc_halfworddethigh_fifo_i | post_icc_halfworddethigh_fifo_i;
	assign icc_umipsfifo_imip    = pre_umipsfifo_imip | post_umipsfifo_imip;
	assign icc_umipsfifo_ieip2   = pre_umipsfifo_ieip2 | post_umipsfifo_ieip2;
	assign icc_umipsfifo_ieip4   = pre_umipsfifo_ieip4 | post_umipsfifo_ieip4;
	assign icc_umipsfifo_null_i  = pre_umipsfifo_null  | post_umipsfifo_null;
	assign icc_umipsfifo_null_raw  = pre_umipsfifo_raw  | post_umipsfifo_raw;
	assign icc_umipsfifo_stat[3:0] = pre_umipsfifo_stat | post_umipsfifo_stat;
	assign icc_macro_jr      = pre_macro_jr    | post_macro_jr;

	assign umips_rdpgpr = pre_umips_rdpgpr | post_umips_rdpgpr;
	assign icc_dspver_i_presel[4:0] = (pre_icc_dspver_i | post_icc_dspver_i) & {5{~(icc_umipsfifo_null_i | icc_macrobds_e | icc_nobds_e | icc_macro_e | mpc_atomic_e)}};

	assign icc_umips_sds = pre_umips_sds | post_umips_sds;
	assign raw_instn_in_postws = icc_umipsconfig[1] ? pre_raw_instn_in_postws : way_select_in_int[31:0];
	assign isachange_waysel [3:0] = pre_isachange_waysel | post_isachange_waysel;
	assign isachange1_i_reg = pre_isachange1_i_reg | post_isachange1_i_reg;
	assign icc_isachange1_i_reg = isachange1_i_reg;
	assign isachange0_i_reg = pre_isachange0_i_reg | post_isachange0_i_reg;
	assign icc_isachange0_i_reg = isachange0_i_reg;
	assign icc_slip_n_nhalf = pre_slip_n_nhalf | post_slip_n_nhalf;
	assign icc_umips_instn_i[31:0] = pre_icc_umips_instn_i | post_icc_umips_instn_i;
	

	assign umips_wsi_instn[31:0] = pre_umipsfifo_null ? 32'b0 : way_select_in_pre[31:0] ;

	assign umips_nobds = pre_umipsfifo_null ? 1'b0 : way_select_in_pre[32] ; 
	assign umips_j     = pre_umipsfifo_null ? 1'b0 : way_select_in_pre[33] ; 
	assign umips_ri    = (pre_umipsfifo_null || mpc_ibrk_qual) ? 1'b0 : way_select_in_pre[34] ; 
	assign umips_macro = pre_umipsfifo_null ? 1'b0 : way_select_in_pre[35] ; 
	assign umips_sds   = way_select_in_pre[47] ;
	assign umips_halfworddet_low  = way_select_in_pre[36] ; 
	assign umips_halfworddet_high = way_select_in_pre[37] | (icc_halfworddethigh_fifo_i & (~mpc_itqualcond_i | cdmm_mputrigresraw_i));
	assign umips_mp    = way_select_in_pre[38] ; 
	assign umips_decomp_reglist[43:39]   = way_select_in_pre[43:39] ;
	assign umips_pcrel_i = way_select_in_pre[44];
	assign umips_addiupc_22_21_i [1:0] = way_select_in_pre[46:45];
	assign way_select_in [47:0] = {umips_sds, umips_addiupc_22_21_i, umips_pcrel_i, umips_decomp_reglist[43:39], umips_mp, umips_halfworddet_high, umips_halfworddet_low, umips_macro, umips_ri, umips_j, umips_nobds, umips_wsi_instn[31:0] };

	assign umips_wsi_instn_post[31:0] = post_umipsfifo_null ? 32'b0 : wide_idatain[31:0] ;
	assign umips_nobds_post = post_umipsfifo_null ? 1'b0 : wide_idatain[32] ;
	assign umips_j_post     = post_umipsfifo_null ? 1'b0 : wide_idatain[33] ;
	assign umips_ri_post    = (post_umipsfifo_null || mpc_ibrk_qual) ? 1'b0 : wide_idatain[34] ;
	assign umips_macro_post = post_umipsfifo_null ? 1'b0 : wide_idatain[35] ;
	assign umips_sds_post   = wide_idatain[47] ;
	assign umips_halfworddet_low_post  = wide_idatain[36] ;
	assign umips_halfworddet_high_post = wide_idatain[37] | (icc_halfworddethigh_fifo_i & (~mpc_itqualcond_i | cdmm_mputrigresraw_i));
	assign umips_mp_post    = wide_idatain[38] ;
	assign umips_decomp_reglist_post[43:39]   = wide_idatain[43:39] ;
	assign umips_pcrel_i_post = wide_idatain[44];
	assign umips_addiupc_22_21_i_post [1:0] = wide_idatain[46:45];
	assign wsi_wide_idata_in [47:0] = {umips_sds_post, umips_addiupc_22_21_i_post, umips_pcrel_i_post, umips_decomp_reglist_post[43:39], umips_mp_post, umips_halfworddet_high_post, umips_halfworddet_low_post, umips_macro_post, umips_ri_post, umips_j_post, umips_nobds_post, umips_wsi_instn_post[31:0] };

	mvp_cregister #(2) _icc_addiupc_22_21_e_1_0_(icc_addiupc_22_21_e[1:0],~icc_imiss_i & (mpc_run_ie || mpc_fixupi) & ~mpc_atomic_e, gclk, 
					(umips_addiupc_22_21_i | umips_addiupc_22_21_i_post));

        mvp_cregister #(1) _icc_umips_16bit_needed(icc_umips_16bit_needed,(mpc_fixupi | greset | mpc_run_ie), gclk, (greset ? 1'b0 :icc_halfworddethigh_i));

	m14k_cache_mux #(T_BITS, `M14K_MAX_IC_ASSOC) tagmux (
		.data_in(spram_cache_tag[T_BITS*`M14K_MAX_IC_ASSOC-1:0]),
		.waysel(tag_line_sel | spram_sel),
		.data_out(tagmuxout)
	);

	
	m14k_cache_mux #(48, `M14K_MAX_IC_ASSOC) datamux (
                .data_in( cache_recode[(48*(1+`M14K_MAX_IC_ASSOC))-1:48] ),
                .waysel( isachange1_i_reg ? isachange_waysel :  data_line_sel | spram_sel ),
                .data_out( datamuxout )
        );

	assign icc_rdpgpr[0] = (~umips_active & (umips_instnin160[31:21]   == 11'b010_000_01_010)) | 		// RDPGPR
			( umips_active & umips_rdpgpr[0]);
	assign icc_rdpgpr[1] = (~umips_active & (umips_instnin160[63:53]   == 11'b010_000_01_010)) | 		// RDPGPR
			( umips_active & umips_rdpgpr[1]);
	assign icc_rdpgpr[2] = (~umips_active & (umips_instnin160[95:85]   == 11'b010_000_01_010)) | 		// RDPGPR
			( umips_active & umips_rdpgpr[2]);
	assign icc_rdpgpr[3] = (~umips_active & (umips_instnin160[127:117] == 11'b010_000_01_010)) | 		// RDPGPR
			( umips_active & umips_rdpgpr[3]);
	assign icc_rdpgpr[4] = (~umips_active & (umips_instnin160[159:149] == 11'b010_000_01_010)) | 		// RDPGPR
			( umips_active & umips_rdpgpr[4]);


	assign icc_dspver[0] = umips_active & icc_dspver_i_presel[0];
	assign icc_dspver[1] = umips_active & icc_dspver_i_presel[1];
	assign icc_dspver[2] = umips_active & icc_dspver_i_presel[2];
	assign icc_dspver[3] = umips_active & icc_dspver_i_presel[3];
	assign icc_dspver[4] = umips_active & icc_dspver_i_presel[4];


	assign rdpgpr_dspver_i[8 : 1] = {icc_rdpgpr[4], icc_dspver[4],
				icc_rdpgpr[3], icc_dspver[3],
				icc_rdpgpr[2], icc_dspver[2],
				icc_rdpgpr[1], icc_dspver[1]};
        m14k_cache_mux #(2, `M14K_MAX_IC_ASSOC) icc_rdpgpr_mux (
                .data_in( {rdpgpr_dspver_i[2*`M14K_MAX_IC_ASSOC : 1]
			} ),
                .waysel( data_line_sel | spram_sel ),
                .data_out( {icc_rdpgpr_muxout,icc_dspver_muxout} )
        );

	assign icc_rdpgpr_i_int = hit_fb ? icc_rdpgpr[0] : icc_rdpgpr_i_reg;
	assign icc_rdpgpr_i_pre  = (hit_fb | hold_imiss_n) ? icc_rdpgpr_i_int : icc_rdpgpr_muxout;
	assign icc_rdpgpr_i_post = icc_rdpgpr[0];
	assign icc_rdpgpr_i = (icc_umipsconfig[0] & umips_active) ? icc_rdpgpr_i_post : icc_rdpgpr_i_pre;
	mvp_cregister #(1) _icc_rdpgpr_i_reg(icc_rdpgpr_i_reg,(icache_read_i | spram_hit_en | hit_fb), gclk, icc_rdpgpr_i);

	assign icc_dspver_i_int = hit_fb ? icc_dspver[0] : icc_dspver_i_reg;
	assign icc_dspver_i_pre  = (hit_fb | hold_imiss_n) ? icc_dspver_i_int : icc_dspver_muxout;
	assign icc_dspver_i_post = icc_dspver[0];
	assign icc_dspver_i = (icc_umipsconfig[0] & umips_active) ? icc_dspver_i_post : icc_dspver_i_pre;
	mvp_cregister #(1) _icc_dspver_i_reg(icc_dspver_i_reg,(icache_read_i | spram_hit_en | hit_fb), gclk, icc_dspver_i);




	assign mbdidatain_raw[`M14K_D_PAR_BITS-1:0] = {mbdipar[3:0], way_select_in_reg[31:0]};
	assign mbdidatain[D_BITS-1:0] = mbdidatain_raw[D_BITS-1:0];
 
	assign mbispdatain_raw[`M14K_D_PAR_BITS-1:0] = {mbisppar[3:0], isp_data_raw[31:0]};
	assign mbispdatain[D_BITS-1:0] = mbispdatain_raw[D_BITS-1:0];
 
`M14K_ICCMB_MODULE #(PARITY) iccmb(.gclk( gclk),
			.greset(greset),
			.gmbinvoke(gmbinvoke),
			.imbinvoke(imbinvoke),
			.gscanenable(gscanenable),
			.cpz_icpresent(cpz_icpresent),
			.cpz_icnsets(cpz_icnsets),
			.cpz_icssize(cpz_icssize),
			.mbdidatain(mbdidatain),
			.mbtitagin(tagmuxout),
			.mbwiwsin(ic_wsin_full[5:0]),
			.mbdiwayselect(mbdiwayselect),
			.mbtiwayselect(mbtiwayselect),
			.mbdiaddr(mbdiaddr),
			.mbtiaddr(mbtiaddr),
			.mbwiaddr(mbwiaddr),
			.mbdiread(mbdiread),
			.mbtiread(mbtiread),
			.mbwiread(mbwiread),
			.mbdiwrite(mbdiwrite),
			.mbtiwrite(mbtiwrite),
			.mbwiwrite(mbwiwrite),
			.mbdidata(mbdidata),
			.mbtidata(mbtidata),
			.mbwidata(mbwidata),
			.gmbdifail(gmbdifail),
			.gmbtifail(gmbtifail),
			.gmbwifail(gmbwifail),
			.gmb_ic_algorithm(gmb_ic_algorithm),
			.icc_mbdone(icc_mbdone));

`M14K_ISPMB_MODULE #(PARITY) ispmb(.gclk( gclk),
                        .greset(greset),
                        .gmbinvoke(gmbinvoke),
                        .ispmbinvoke(ispmbinvoke),
                        .gscanenable(gscanenable),
                        .cpz_isppresent(cpz_isppresent),
                        .isp_size(isp_size),
                        .mbispdatain(mbispdatain),

                        .mbispaddr(mbispaddr),
                        .mbispread(mbispread),
                        .mbispwrite(mbispwrite),
                        .mbispdata(mbispdata),
                        .gmbispfail(gmbispfail),
                        .gmb_isp_algorithm(gmb_isp_algorithm),
                        .icc_spmbdone(icc_spmbdone));

	assign early_icop_ws_read = (icop_read_reg & icop_idx_ld) | ((fandl_read | fill_read)); 
	assign early_icache_read_e = (mpc_run_ie | (itmres_nxt & ~spram_stall) | mpc_fixupi) & ~greset;
	assign early_icc_trstb_int = (early_icache_read_e & ~scan_mb_stb_ctl ) | (icop_read & ~scan_mb_stb_ctl);
	assign early_icache_write_e = ~spram_stall & ~isp_write_active & fill_data_ready;
	
	assign early_icc_trstb = early_icc_trstb_int | scan_mb_trstb;
        assign early_icc_drstb = early_icc_trstb_int | scan_mb_drstb;
	assign early_icc_twstb = (early_icache_write_e & fb_update_tag & ~scan_mb_stb_ctl) |
                    (icop_write & ~scan_mb_stb_ctl) | scan_mb_twstb;
	assign early_icc_dwstb = (early_icache_write_e & ~scan_mb_stb_ctl) |
                    (icop_data_write & ~scan_mb_stb_ctl) | scan_mb_dwstb;

	assign early_icc_wsrstb = (icc_trstb_reg & ~kill_miss_i & ~scan_mb_stb_ctl) |
                     (early_icop_ws_read & ~scan_mb_stb_ctl) | scan_mb_wsrstb;

        assign early_icc_wswstb = (icc_trstb_reg & ~kill_miss_i & ~scan_mb_stb_ctl) |
                     (fb_fill & ~scan_mb_stb_ctl) |
                     (icop_ws_write & ~scan_mb_stb_ctl) |
                     scan_mb_wswstb;

	assign icc_early_data_ce = early_icc_drstb | early_icc_dwstb;
	assign icc_early_tag_ce = early_icc_trstb | early_icc_twstb;
	assign icc_early_ws_ce = early_icc_wsrstb | early_icc_wswstb;



       	assign cur_ins_fetch = (icache_read_e & ~same_word & ~scan_mb_stb_ctl );

	mvp_cregister #(1) _mpc_sequential_md(mpc_sequential_md,mpc_run_ie, gclk,mpc_sequential_e);
	assign same_line = ((mpc_sequential_md && !mpc_run_ie) || (mpc_run_ie && mpc_sequential_e)) && (cur_ins_fetch_addr[4] == pre_ins_fetch_addr[4]) & ~poten_parerr;
        assign cur_ins_fetch_addr[4] = greset ? 1'b0 : icc_tagaddr[4];
        mvp_cregister #(1) _pre_ins_fetch_addr_4_4_(pre_ins_fetch_addr[4],greset | cur_ins_fetch, gclk, cur_ins_fetch_addr[4]);
        mvp_register #(1) _tag_updated(tag_updated, gclk, icc_twstb && (cur_ins_fetch_addr == pre_ins_fetch_addr));
	
        mvp_register #(1) _hold_tag_updated(hold_tag_updated, gclk, held_tag_updated && !cur_ins_fetch);
        assign held_tag_updated = tag_updated || hold_tag_updated;
	mvp_register #(1) _cpz_updated(cpz_updated, gclk, cpz_config_ld | cpz_g_config_ld | greset | asid_update | r_asid_update); 
	mvp_register #(1) _hold_cpz_updated(hold_cpz_updated, gclk, held_cpz_updated && !cur_ins_fetch);
	assign held_cpz_updated = cpz_updated | hold_cpz_updated | cpz_config_ld | cpz_g_config_ld | asid_update | r_asid_update;

        assign hit_pre_fetch = cur_ins_fetch && same_line && ~mpc_int_pref && 
			!held_cpz_updated && !held_tag_updated && !(held_itmack & ~spram_stall);

        mvp_register #(1) _hit_pre_fetch_md(hit_pre_fetch_md, gclk,hit_pre_fetch);
        mvp_register #(1) _cur_ins_fetch_md(cur_ins_fetch_md, gclk,cur_ins_fetch);

        mvp_cregister_wide #(4) _valid_md_3_0_(valid_md[3:0],gscanenable, cur_ins_fetch_md, gclk,valid);
        mvp_cregister_wide #(4) _line_sel_md_3_0_(line_sel_md[3:0],gscanenable, cur_ins_fetch_md, gclk, line_sel);
        mvp_cregister_wide #(4) _cache_hit_way_md_3_0_(cache_hit_way_md[3:0],gscanenable, cur_ins_fetch_md, gclk, cache_hit_way);
        mvp_cregister #(1) _cache_hit_md(cache_hit_md,cur_ins_fetch_md, gclk, cache_hit);
        mvp_cregister_wide #(4) _lock_md_3_0_(lock_md[3:0],gscanenable, cur_ins_fetch_md, gclk, lock);

        assign {valid[3:0],line_sel[3:0], cache_hit_way[3:0], cache_hit,lock[3:0]} = hit_pre_fetch_md ?
                                        {valid_md, line_sel_md, cache_hit_way_md, cache_hit_md, lock_md} :
                                        {valid_raw, line_sel_raw, cache_hit_way_raw, cache_hit_raw, lock_raw};

        mvp_register #(1) _tag_invalid(tag_invalid, gclk, icc_twstb && same_line && first_word_fill);
        mvp_register #(1) _hold_tag_invalid(hold_tag_invalid, gclk, held_tag_invalid && !cur_ins_fetch);
        assign held_tag_invalid = tag_invalid || hold_tag_invalid;

        mvp_register #(1) _clear_valid(clear_valid, gclk, held_tag_invalid && hit_pre_fetch);
        assign tag_cmp_mix[3:0] = tag_cmp_v4 & {4{!clear_valid}};

	mvp_cregister #(1) _mmu_icacabl_md(mmu_icacabl_md,cur_ins_fetch_md, gclk, mmu_icacabl);

	assign icc_readmask4[3:0] = hit_pre_fetch? (cur_ins_fetch_md? (cache_hit_way & {4{mmu_icacabl}}) : 
					    (cache_hit_way_md & {4{mmu_icacabl_md}})) : 4'b1111;
	assign icc_readmask[`M14K_MAX_IC_ASSOC-1:0] = icc_readmask4[`M14K_MAX_IC_ASSOC-1:0];

`M14K_IC_PARITY 	#(PARITY) icc_parity(.gclk	( gclk),
			.gscanenable (gscanenable),
			.imbinvoke(imbinvoke),
			.ispmbinvoke(ispmbinvoke),
			.scan_mb_trstb(scan_mb_trstb),
			.scan_mb_drstb(scan_mb_drstb),
			.tag_rd_int112(tag_rd_int112),
			.spram_cache_data(spram_cache_data),
			.ispram_par_present(ispram_par_present),
			.data_line_sel(data_line_sel),
			.spram_sel(spram_sel),
			.ifill_done(ifill_done),
			.fill_data_raw(fill_data_raw),
                        .icop_active_m(icop_active_m),
			.icop_idx_ld(icop_idx_ld),
			.icop_idx_stt(icop_idx_stt),
                        .icop_ready(icop_ready),
                        .cpz_taglo(cpz_taglo),
                        .icc_tagwrdata_raw(icc_tagwrdata_raw),
                        .icc_trstb(icc_trstb),
                        .mpc_icop_m(mpc_icop_m),
                        .raw_kill_i(raw_kill_i),
			.icop_use_idx(icop_use_idx),
			.valid(valid),
			.icc_readmask(icc_readmask),
			.icop_wway_reg(icop_wway_reg),
			.spram_way(spram_way),
			.icc_drstb(icc_drstb),
			.ISP_RdStr(ISP_RdStr),
                        .ISP_Addr(ISP_Addr),
                        .ISP_RPar(ISP_RPar),
			.icc_tagaddr(icc_tagaddr),
			.icc_dataaddr(icc_dataaddr),
                        .cpz_pi(cpz_pi),
			.cpz_pe(cpz_pe),
                        .cpz_po(cpz_po),
			.mbdipar(mbdipar),
			.mbisppar(mbisppar),
                        .icc_parerr_idx(icc_parerr_idx),
			.isp_data_parerr(isp_data_parerr_int),
                        .icc_derr_way(icc_derr_way),
                        .icc_parerr_w(icc_parerr_w),
                        .icc_parerr_cpz_w(icc_parerr_cpz_w),
                        .icc_parerr_i(icc_parerr_i_int),
			.icc_parerr_tag(icc_parerr_tag_int),
			.icc_parerr_data(icc_parerr_data_int),
			.fill_data_par(fill_data_par),
			.icc_tag_par(icc_tag_par),
			.mmu_icacabl(mmu_icacabl),
			.icc_icoppar(icc_icoppar));



// Assertion checker


  
 //VCS coverage off 
// 
	// Wire used by TB to determine whether parity is enabled
	wire selparicc;
  assign selparicc 		= PARITY ? 1'b1 : 1'b0;
  //VCS coverage on  
  
// 

endmodule // m14k_icc
