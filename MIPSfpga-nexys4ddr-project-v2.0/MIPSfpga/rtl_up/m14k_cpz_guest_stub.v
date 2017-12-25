// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_cpz_guest_stub 
//           Coprocessor Zero System control coprocessor
//
//      $Id: \$
//      mips_repository_id: m14k_cpz_guest_stub.mv, v 1.59 
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
//	
//	

`include "m14k_const.vh"

module m14k_cpz_guest_stub(
	gscanenable,
	edp_alu_m,
	mmu_dva_m,
	bds_x,
	siu_cpunum,
	siu_ipti,
	fdc_present,
	ej_fdc_int,
	siu_ifdci,
	siu_ippci,
	siu_eicpresent,
	siu_bigend,
	biu_shutdown,
	edp_udi_present,
	mpc_busty_m,
	siu_coldreset,
	mpc_eret_m,
	biu_merging,
	icc_sp_pres,
	dcc_sp_pres,
	mpc_cp0move_m,
	mpc_cp0diei_m,
	mpc_cp0sc_m,
	mpc_cp0r_m,
	mpc_cp0sr_m,
	mpc_dmsquash_m,
	ic_present,
	dc_present,
	ic_nsets,
	ic_ssize,
	dc_nsets,
	dc_ssize,
	mmu_type,
	mmu_size,
	icc_umipspresent,
	mpc_umipspresent,
	icc_umipsfifo_null_i,
	mpc_umipsfifosupport_i,
	mpc_isamode_i,
	mpc_excisamode_i,
	mmu_it_segerr,
	mpc_nonseq_e,
	mpc_cpnm_e,
	mpc_exccode,
	mpc_exc_e,
	mpc_exc_m,
	mpc_exc_w,
	mpc_hold_hwintn,
	mpc_fixup_m,
	mpc_pexc_m,
	mpc_pexc_w,
	mpc_pexc_i,
	siu_g_int,
	siu_g_eicvector,
	siu_g_offset,
	siu_bootexcisamode,
	siu_srsdisable,
	siu_g_eiss,
	mpc_g_jamepc_w,
	mpc_g_jamtlb_w,
	mpc_g_ldcause,
	mpc_load_m,
	mpc_wr_status_m,
	mpc_wr_intctl_m,
	mpc_ll_m,
	mpc_run_i,
	mpc_run_ie,
	mpc_run_m,
	mpc_run_w,
	greset,
	mpc_squash_i,
	mpc_squash_m,
	mdu_type,
	mmu_tlbshutdown,
	mmu_transexc,
	gclk,
	gfclk,
	ejt_dcrinte,
	mmu_cpyout,
	edp_iva_i,
	edp_cacheiva_i,
	edp_epc_e,
	edp_eisa_e,
	mmu_asid,
	mmu_vafromi,
	cp2_coppresent,
	cp1_coppresent,
	ejt_pdt_present,
	mpc_chain_take,
	mpc_hw_save_done,
	mpc_hw_load_done,
	mpc_iae_done_exc,
	mpc_g_ld_causeap,
	mpc_wr_view_ipl_m,
	mpc_atpro_w,
	mpc_atepi_w,
	mpc_qual_auexc_x,
	mpc_first_det_int,
	mpc_buf_epc,
	mpc_buf_status,
	mpc_buf_srsctl,
	mpc_iretval_e,
	mpc_load_status_done,
	mpc_squash_e,
	dcc_intkill_m,
	dcc_intkill_w,
	mpc_hw_load_e,
	mpc_atepi_m,
	mpc_int_pref_phase1,
	mpc_tint,
	mpc_dis_int_e,
	mpc_int_pf_phase1_reg,
	mpc_lsdc1_m,
	mpc_lsdc1_w,
	cp1_seen_nodmiss_m,
	mpc_ivaval_i,
	mpc_ll1_m,
	mdu_stall,
	mpc_fixupi,
	icc_imiss_i,
	cpz_g_bev,
	g_cp0read_m,
	cpz_g_copusable,
	cpz_g_cee,
	g_eretpc,
	cpz_g_eretisa,
	cpz_g_erl,
	cpz_g_erl_e,
	g_nest_exl,
	g_nest_erl,
	cpz_g_hotexl,
	cpz_g_exl,
	cpz_g_um,
	cpz_g_um_vld,
	cpz_g_int_e,
	cpz_g_int_mw,
	cpz_g_iv,
	cpz_g_hwrena,
	cpz_g_hwrena_29,
	cpz_g_ebase,
	cpz_g_vectoroffset,
	cpz_g_srsctl_pss2css_m,
	cpz_g_srsctl_css,
	cpz_g_srsctl_pss,
	cpz_g_hoterl,
	cpz_g_k0cca,
	cpz_g_k23cca,
	cpz_g_kucca,
	cpz_g_kuc_i,
	cpz_g_kuc_e,
	cpz_g_kuc_m,
	cpz_g_kuc_w,
	cpz_g_llbit,
	cpz_g_rbigend_e,
	cpz_g_rbigend_i,
	cpz_g_excisamode,
	cpz_g_bootisamode,
	cpz_g_rp,
	cpz_g_smallpage,
	cpz_g_swint,
	cpz_g_ipl,
	cpz_g_ivn,
	cpz_g_ion,
	cpz_g_iack,
	cpz_g_iwatchhit,
	cpz_g_dwatchhit,
	cpz_g_wpexc_m,
	g_doze,
	cpz_g_mmusize,
	cpz_g_mmutype,
	cpz_g_srsctl,
	cpz_g_status,
	cpz_g_ext_int,
	cpz_g_epc_rd_data,
	cpz_g_pf,
	cpz_g_takeint,
	cpz_g_at_epi_en,
	cpz_g_stkdec,
	cpz_g_ice,
	cpz_g_int_pend_ed,
	cpz_g_iretpc,
	cpz_g_usekstk,
	cpz_g_causeap,
	cpz_g_int_enable,
	g_iret_tailchain,
	cpz_g_iap_um,
	cpz_g_at_pro_start_i,
	cpz_g_at_pro_start_val,
	g_iap_exce_handler_trace,
	cpz_g_mx,
	vz_present,
	cpz_ghfc_i,
	cpz_ghfc_w,
	cpz_gsfc_m,
	cpz_g_hss,
	cpz_g_int_excl_ie_e,
	cpz_g_config_ld,
	g_fr,
	cpz_g_cause_pci,
	cpz_g_timerint,
	gripl_clr,
	cpz_g_ulri,
	cpz_g_cdmm,
	cpz_g_watch_present,
	cpz_g_watch_present__1,
	cpz_g_watch_present__2,
	cpz_g_watch_present__3,
	cpz_g_watch_present__4,
	cpz_g_watch_present__5,
	cpz_g_watch_present__6,
	cpz_g_watch_present__7,
	cpz_g_ufr,
	cpz_g_pc_present,
	badva,
	cause_s,
	dcc_dvastrobe,
	mpc_atomic_m,
	mpc_pdstrobe_w,
	edp_dsp_present_xx,
	mpc_g_int_pf,
	mpc_g_cp0move_m,
	cpz_eret_m,
	cpz_iret_m,
	cp0_eret_w,
	cp0_iret_w,
	r_pip,
	r_pip_e,
	cpz_gm_i,
	cpz_gm_e,
	cpz_gm_m,
	cpz_gm_w,
	r_count,
	r_gtoffset,
	cpz_iret_ret,
	hot_eret_m,
	sfc2,
	sfc1,
	g_cause_pci,
	epc_w,
	eisa_w,
	guestctl0_mc,
	perfcnt_rdata_ex,
	mpc_auexc_on,
	mpc_iret_ret,
	mpc_chain_vec,
	fcd,
	hot_wr_guestctl2_noneic,
	siu_int,
	int_pend_e,
	glss,
	gripl,
	geicss,
	gvec,
	vip,
	vip_e,
	pc_present,
	ir_w,
	ir_x,
	mpc_badins_type,
	cp1_ufrp,
	r_internal_int,
	mpc_ctc1_fr0_m,
	mpc_ctc1_fr1_m,
	mpc_cfc1_fr_m,
	mpc_rdhwr_m,
	count_ld,
	hold_count_ld,
	r_srsctl,
	badva_jump,
	instn_slip_e,
	hot_ignore_watch,
	ignore_watch);


/*hookios*//* IO declarations added by hookup */
/* End of hookup IO declarations */
/* Wire declarations added by hookup */
wire [31:0] cpz;		// cpz write data
wire cpz_dwatchhit;
wire cpz_iwatchhit;
wire cpz_mmutype;
wire cpz_srsctl_pss2css_m;		// Copy PSS to CSS
wire cpz_watch_present__1;
wire cpz_watch_present__2;
wire cpz_watch_present__3;
wire cpz_watch_present__4;
wire cpz_watch_present__5;
wire cpz_watch_present__6;
wire cpz_watch_present__7;
wire delay_watch;
wire eic_present;		// External Interrupt cpntroller present
wire [3:0] eiss;		// Shadow set, comes with the requested interrupt
wire hot_delay_watch;
wire [3:0] hot_srsctl_pss;
wire mfcp0_m;		// cp0 control
wire mtcp0_m;		// cp0 control
wire set_watch_pend_w;
wire [31:0] srsctl;		// SRS Control rergister
wire srsctl_css2pss_w;		// Copy CSS to PSS
wire srsctl_ess2css_w;		// Copy ESS to CSS
wire srsctl_ld;		// Load srsctl register via MTC0
wire srsctl_rd;		// Read srsctl onto cpz line
wire srsctl_vec2css_w;		// Copy VEC to CSS
wire [3:0] srsdisable;		// Disable some shadow sets
wire [31:0] srsmap;		// SRS Mapping register
wire [31:0] srsmap2;		// SRS Mapping register 2
wire srsmap2_ld;		// Load srsmap register via MTC0
wire srsmap2_rd;		// Read srsmap onto cpz line
wire srsmap_ld;		// Load srsmap register via MTC0
wire srsmap_rd;		// Read srsmap onto cpz line
wire [5:0] vectornumber;		// Interrupt vektor number
wire [31:0] watch32;
wire watch_present;
/* End of hookup wire declarations */

	/* Inputs */
        input           gscanenable;        // Scan Enable
	input [31:0]	edp_alu_m;	    // ALU result bus -> cpz write data
	input [31:0]	mmu_dva_m;	    
	input		bds_x;
	input [9:0]	siu_cpunum;		// EBase CPU number
	input [2:0]	siu_ipti;		// TimerInt connection
	input 		fdc_present;		// FDC is implemented
	input		ej_fdc_int;		// Int req from fdc
	input [2:0]     siu_ifdci;		// FDCInt connection
	input [2:0]	siu_ippci;		// PCInt connection
	input		siu_eicpresent;		// External Interrupt cpntroller present
	input		siu_bigend;	    // Number bytes starting from the big end of the word
	input 		biu_shutdown;       // Wait instn executed & No transactions outstanding on bus
	input 		edp_udi_present;    // UDI block is implemented
	input [2:0]	mpc_busty_m;        // Transaction type
	input		siu_coldreset;      // Cold reset
	input		mpc_eret_m;	    // ERET instruction
	input 		biu_merging;        // Merging algorithm
	input 		icc_sp_pres;        // ISPRAM is present
	input 		dcc_sp_pres;        // DSPRAM is present
	input		mpc_cp0move_m;	    // MT/F C0
	input		mpc_cp0diei_m;	    // DI/EI
	input		mpc_cp0sc_m;	    // set/clear bit in C0
	input [4:0]	mpc_cp0r_m;	    // coprocessor zero register specifier
	input [2:0]	mpc_cp0sr_m;	    // coprocessor zero shadow register specifier
        input 		mpc_dmsquash_m;     // Exc_M without translation exceptions or interrupts
        input 		ic_present;         // I$ is present
        input 		dc_present;         // D$ is present
   	input [2:0]	ic_nsets;	    // Number of sets   - static
	input [1:0]	ic_ssize;	    // I$ associativity - static
	input [2:0]	dc_nsets;	    // Number of sets   - static
	input [1:0]	dc_ssize;	    // D$ associativity - static
	input		mmu_type;	    // MMU type: 1->BAT, 0->TLB - Static
	input	[1:0]	mmu_size;	    // MMU size: 0->16, 1->16 - Static

	input 		icc_umipspresent;     // UMIPS implemented
	input		mpc_umipspresent;	// native UMIPS implemented
	input		icc_umipsfifo_null_i;	// instn slip at i stage
	input		mpc_umipsfifosupport_i; // Indicates fifo is ready and we do not stall on i-cache miss. not available in umips recoder
        input           mpc_isamode_i;      // current isa mode
	input		mpc_excisamode_i;   // isa mode change w/o isa
	input		mmu_it_segerr;
	input		mpc_nonseq_e;

	input [1:0]	mpc_cpnm_e;	    // coprocessor unit number
	input [4:0]	mpc_exccode;	    // cause PLA to encode exceptions into a 5 bit field
	input		mpc_exc_e;	    // Exception killed E-stage 
	input		mpc_exc_m;	    // Exception killed M-stage 
	input		mpc_exc_w;	    // Exception killed W-stage
	input		mpc_hold_hwintn;	// Hold hwint pins until exception taken
	input 		mpc_fixup_m;        // D$ miss previous cycle
	input		mpc_pexc_m;         // Prior Exception killed M-stage
	input		mpc_pexc_w;         // Prior Exception killed W-stage
	input		mpc_pexc_i;         // Prior Exception killed I-stage
        input [7:0]     siu_g_int;            // external interrupt inputs to cause

	input [5:0]	siu_g_eicvector;	    // Vector number to use for EIC interrupt
	input [17:1]	siu_g_offset;	    // Vector offset to use for EIC interrupt

        input           siu_bootexcisamode;
        input [3:0]     siu_srsdisable;      // Disable some shadow sets

	input [3:0]	siu_g_eiss;	    // Shadow set to use for EIC interrupt
	input		mpc_g_jamepc_w;	    // load epc register from epc timing chain
	input		mpc_g_jamtlb_w;	    // load Translation exception registers
	input		mpc_g_ldcause;	    // load cause register for exception
	input		mpc_load_m;	    // xfer direction for load/store/cpmv - 0:=to proc; 1:=from proc
	input		mpc_wr_status_m;
	input		mpc_wr_intctl_m;
	input		mpc_ll_m;	    // Load linked in M
	input		mpc_run_i;          // I-stage Run - for exceptions only
	input		mpc_run_ie;         // I/E-stage Run
	input		mpc_run_m;	    // M-stage Run
	input		mpc_run_w;	    // W-stage Run
	input		greset;		    // Power on and reset for chip
	input		mpc_squash_i;	    // Squash the instn in I-stage 
	input		mpc_squash_m;	    // M-stage instn was squashed
	input		mdu_type;	    // MDU type: 1->Lite, 0->Full - Static
	input		mmu_tlbshutdown;    // conflict detected on TLB write
	input 		mmu_transexc;       // Translation exception detected
	input		gclk;		    // Clock
	input		gfclk;		    // Free running clock
	input		ejt_dcrinte;        // EJTAG interrupt enable
	input [31:0] 	mmu_cpyout;         // Read bus for CPY registers
	input [31:0] 	edp_iva_i;          // Instruction Virtual Address - I-stage
	input [31:0]	edp_cacheiva_i;	    // cache iva
	input [31:0] 	edp_epc_e;          // Exception PC - E-stage
	input 		edp_eisa_e;         // Exception ISA mode - E-stage
	input [`M14K_ASID] mmu_asid;         // Address Space Identifier
	input 		   mmu_vafromi;     // Select IVA for BadVA
	input 	 	cp2_coppresent;	    // COP 2 is present on the interface.
	input 	 	cp1_coppresent;	    // COP 1 is present on the interface.
	input [1:0] 	ejt_pdt_present;    // PDTrace module is implemented. 01 : PDT/TCB, 10 : IPDT/ITCB

	input           mpc_chain_take;        //tail chain happened
        input           mpc_hw_save_done;      //HW save operation done
        input           mpc_hw_load_done;      //HW load operation done
	input           mpc_iae_done_exc;      //HW load done due to exception
        input           mpc_g_ld_causeap;        //load Cause.AP when detect exception during auto prologue
        input           mpc_wr_view_ipl_m;     //write view_ipl register
        input           mpc_atpro_w;           //auto-prologue in W-stage
        input           mpc_atepi_w;           //auto-epilogue in W-stage
        input           mpc_qual_auexc_x;      //final cycle of mpc_auexc_x
        input           mpc_first_det_int;     //first cycle interrupt detected
        input  [31:0]   mpc_buf_epc;           //EPC saved to stack during HW sequence
        input  [31:0]   mpc_buf_status;        //Status saved to stack during HW sequence
        input  [31:0]   mpc_buf_srsctl;        //SRSCTL saved to stack during HW sequence
	input           mpc_iretval_e;         //IRET valid
	input           mpc_load_status_done;  //HW load status is done
	input		mpc_squash_e;	       //Squash E-stage exception
	input 		dcc_intkill_m;         //Interrupt killed M-stage L/S instn
        input 		dcc_intkill_w;         //Interrupt killed W-stage L/S instn
	input		mpc_hw_load_e;	       //HW load epc or srsctl in E-stage
	input           mpc_atepi_m;           //auto-epilogue in M-stage
	input		mpc_int_pref_phase1;   //phase1 of interrupt prefetch
	input		mpc_tint;	       //interrupt is taken
	input		mpc_dis_int_e;	      //disable interrupt in E-stage
	input		mpc_int_pf_phase1_reg;//reg version of phase1 of interrupt prefetch
	input		mpc_lsdc1_m;
	input		mpc_lsdc1_w;
	input		cp1_seen_nodmiss_m;

	input 		mpc_ivaval_i;       // I-stage IVA is valid
	input		mpc_ll1_m;		// Load linked in first clock of M

	input		mdu_stall;
	input           mpc_fixupi;

	input           icc_imiss_i;

	/* Outputs */
	output		cpz_g_bev;		// Bootstrap exception vectors
	output [31:0]	g_cp0read_m;   // Read data for MFC0 & SC register updates
	output [3:0]	cpz_g_copusable;		// coprocessor usable bits
        output		cpz_g_cee;	// corextend enable
	output [31:0]	g_eretpc;		// Target PC for ERET or DERET (epc or ErrorPC or depc)
	output 		cpz_g_eretisa;	// Target ISA for ERET or DERET (from epc or ErrorPC or depc)
	output		cpz_g_erl;		// cpz_g_erl bit from status
        output 		cpz_g_erl_e;
	output		g_nest_exl;
	output		g_nest_erl;
	output		cpz_g_hotexl;		// cpz_g_exl bit from status
	output		cpz_g_exl;		// cpz_g_exl bit from status
	output		cpz_g_um; 		// cpz_g_um bit from status
	output		cpz_g_um_vld; 		// cpz_g_um bit from status is valid
	output		cpz_g_int_e;	// external, software, and non-maskable interrupts
	output		cpz_g_int_mw;	        // external, software, and non-maskable interrupts
	output		cpz_g_iv;		// cpz_g_iv bit from cause
	output [3:0]	cpz_g_hwrena;	// HWRENA CP0 register
	output   	cpz_g_hwrena_29;	// Bit 29 of HWRENA CP0 register
	output [31:12]	cpz_g_ebase;	// Exception base
	output [17:1]	cpz_g_vectoroffset;	// Interrupt vector offset
	output		cpz_g_srsctl_pss2css_m;	// Copy PSS back to CSS on eret
	output [3:0]	cpz_g_srsctl_css;		// Current SRS
	output [3:0]	cpz_g_srsctl_pss;		// Previous SRS
	output		cpz_g_hoterl;         // Early version of cpz_g_erl
        output [2:0]    cpz_g_k0cca;      // kseg0 cache attributes
        output [2:0]    cpz_g_k23cca;     // kseg2/3 cache attributes
        output [2:0]    cpz_g_kucca;      // kuseg cache attributes
   	output		cpz_g_kuc_i;		// Kernel/user bit - 0:=>kernel; 1:=>user
	output		cpz_g_kuc_e;		// Kernel/user bit - 0:=>kernel; 1:=>user
	output		cpz_g_kuc_m;		// Kernel/user bit - 0:=>kernel; 1:=>user
	output		cpz_g_kuc_w;		// Kernel/user bit - 0:=>kernel; 1:=>user
	output		cpz_g_llbit;          // Load linked bit - enables SC
	output		cpz_g_rbigend_e;	// reverse Endianess from state of bigend mode bit in user mode
	output		cpz_g_rbigend_i;	// reverse Endianess from state of bigend mode bit in user mode
        output          cpz_g_excisamode; // isamode for exception
        output          cpz_g_bootisamode; // isamode for boot

	output 		cpz_g_rp;             // Reduce Power bit from status register

	output		cpz_g_smallpage;		// Small (1KB) page support
	output [1:0]	cpz_g_swint;	// Software interrupt requests to external interrupt controller
        output [7:0]    cpz_g_ipl;        // Current IPL, contains information of which int SI_IACK ack.
        output [5:0]    cpz_g_ivn;        // Current IVN, contains information of which int SI_IACK ack.
        output [17:1]    cpz_g_ion;        // Current ION, contains information of which int SI_IACK ack.
	output		cpz_g_iack;	// interrupt acknowledge
	output		cpz_g_iwatchhit;	// instruction Watch comparison matched
	output		cpz_g_dwatchhit;	// data Watch comparison matched
	output 		cpz_g_wpexc_m;        // Deferred watch exception
	output 		g_doze;        // Processor is in low-power mode
	output 	[1:0]	cpz_g_mmusize;       // mmu_size from config
	output 		cpz_g_mmutype;       // mmu_type from config

	output [31:0]   cpz_g_srsctl;             //SRSCTL data for HW entry sequence
        output [31:0]   cpz_g_status;             //Status data for HW sequence
        output          cpz_g_ext_int;            //external interrupt
        output [31:0]   cpz_g_epc_rd_data;        //EPC data for HW saving operation
        output          cpz_g_pf;                 //speculative prefetch enable
        output          cpz_g_takeint;            //interrupt recognized finally
        output          cpz_g_at_epi_en;     	//enable iae
        output [4:0]    cpz_g_stkdec;             //number of words for the decremented value of sp
        output          cpz_g_ice;                //enable tail chain
        output [7:0]    cpz_g_int_pend_ed;        //pending iterrupt
        output [31:0]   cpz_g_iretpc;             //return to the original epc on IRET if tail chain not happen
	output          cpz_g_usekstk;            //Use kernel stack during IAP
	output          cpz_g_causeap;            //exception happened during auto-prologue
	output          cpz_g_int_enable;         //interrupt enable
	output		g_iret_tailchain;     
	output		cpz_g_iap_um; 	        //user mode when iap
        output          cpz_g_at_pro_start_i;
        output          cpz_g_at_pro_start_val;

	output	        g_iap_exce_handler_trace;	// Instruction is under exception processing of IAP	

	output		cpz_g_mx;	
	output		vz_present;	
	output		cpz_ghfc_i;	
	output		cpz_ghfc_w;	
	output		cpz_gsfc_m;	
	output [3:0]    cpz_g_hss;
	output		cpz_g_int_excl_ie_e;	
	output		cpz_g_config_ld;
	output		g_fr;	
	output		cpz_g_cause_pci;
	output		cpz_g_timerint;
	output		gripl_clr;
	output		cpz_g_ulri;
	output		cpz_g_cdmm;
	output		cpz_g_watch_present;
	output		cpz_g_watch_present__1;
	output		cpz_g_watch_present__2;
	output		cpz_g_watch_present__3;
	output		cpz_g_watch_present__4;
	output		cpz_g_watch_present__5;
	output		cpz_g_watch_present__6;
	output		cpz_g_watch_present__7;
	output		cpz_g_ufr;
	output 		cpz_g_pc_present;
	output [31:0]   badva;
	output [6:0]	cause_s;
	
    	input	  	dcc_dvastrobe;      	// Data Virtual Address strobe for WATCH
	input		mpc_atomic_m;		// Atomic instruction entered into M stage for load
	input		mpc_pdstrobe_w;         // Instn Valid in W

	input		edp_dsp_present_xx;

	input		mpc_g_int_pf;
	input		mpc_g_cp0move_m;	    // MT/F C0
	input		cpz_eret_m;		//active eret for writing registers (m stage)
        input           cpz_iret_m;             //active version of M-stage IRET instn
	input		cp0_eret_w;
	input		cp0_iret_w;
	input [7:0]     r_pip;
	input [7:0]     r_pip_e;
	input		cpz_gm_i;
	input		cpz_gm_e;
	input		cpz_gm_m;
	input		cpz_gm_w;
	input [31:0]    r_count;
	input [31:0]    r_gtoffset;
	input		cpz_iret_ret;		//active iret for writing registers
	input		hot_eret_m;
	input		sfc2;
	input		sfc1;
	input		g_cause_pci;
	input [31:0]    epc_w;
	input		eisa_w;
	input		guestctl0_mc;
	input [31:0]	perfcnt_rdata_ex;
	input		mpc_auexc_on;	
	input 		mpc_iret_ret;		// PC redirect due to IRET return
	input 		mpc_chain_vec;		// hold tail chain jump
	input		fcd;	
	input		hot_wr_guestctl2_noneic;
        input	[7:0]	siu_int;            // external interrupt inputs to cause
        input [7:0]     int_pend_e;
	input	[3:0]	glss;
	input	[7:0]	gripl;
	input	[3:0]	geicss;
	input	[15:0]	gvec;
	input	[7:0]	vip;
	input	[7:0]	vip_e;
	input		pc_present;
	input	[31:0]	ir_w;
	input	[31:0]	ir_x;
	input		mpc_badins_type;	
	input 		cp1_ufrp;
	input	[7:0]	r_internal_int;
	input		mpc_ctc1_fr0_m;
	input		mpc_ctc1_fr1_m;
	input		mpc_cfc1_fr_m;
	input		mpc_rdhwr_m;
	input		count_ld;
	input		hold_count_ld;
	input	[31:0]	r_srsctl;
	input		badva_jump;
	input		instn_slip_e;
	input		hot_ignore_watch;
	input		ignore_watch;

// BEGIN Wire declarations made by MVP
wire g_iret_tailchain;
wire cpz_g_usekstk;
wire [31:0] /*[31:0]*/ g_cp0read_m;
wire [2:0] /*[2:0]*/ cpz_g_k23cca;
wire cpz_g_rbigend_i;
wire cpz_g_pf;
wire cpz_g_rp;
wire cpz_g_cause_pci;
wire cpz_g_um;
wire cpz_g_watch_present__6;
wire cpz_g_at_pro_start_val;
wire cpz_g_exl;
wire cpz_g_srsctl_pss2css_m;
wire cpz_g_dwatchhit;
wire cpz_g_eretisa;
wire cpz_g_kuc_e;
wire cpz_g_hotexl;
wire cpz_g_config_ld;
wire cpz_g_int_e;
wire cpz_g_iap_um;
wire [2:0] /*[2:0]*/ cpz_g_kucca;
wire cpz_g_int_enable;
wire [2:0] /*[2:0]*/ cpz_g_k0cca;
wire [4:0] /*[4:0]*/ cpz_g_stkdec;
wire cpz_g_watch_present__4;
wire cpz_g_hwrena_29;
wire [3:0] /*[3:0]*/ cpz_g_hss;
wire [3:0] /*[3:0]*/ cpz_g_hwrena;
wire cpz_g_iwatchhit;
wire cpz_g_cdmm;
wire cpz_g_hoterl;
wire [31:0] /*[31:0]*/ cpz_g_iretpc;
wire [31:0] /*[31:0]*/ cpz_g_srsctl;
wire cpz_g_smallpage;
wire cpz_g_int_excl_ie_e;
wire [17:1] /*[17:1]*/ cpz_g_ion;
wire gripl_clr;
wire [31:12] /*[31:12]*/ cpz_g_ebase;
wire cpz_g_ufr;
wire cpz_g_ice;
wire g_nest_exl;
wire cpz_ghfc_w;
wire cpz_g_watch_present__2;
wire [7:0] /*[7:0]*/ cpz_g_ipl;
wire cpz_g_erl_e;
wire cpz_ghfc_i;
wire cpz_g_llbit;
wire cpz_g_causeap;
wire [31:0] /*[31:0]*/ g_eretpc;
wire cpz_g_ext_int;
wire cpz_gsfc_m;
wire cpz_g_bev;
wire cpz_g_wpexc_m;
wire cpz_g_watch_present__7;
wire cpz_g_excisamode;
wire [7:0] /*[7:0]*/ cpz_g_int_pend_ed;
wire g_fr;
wire [31:0] /*[31:0]*/ cpz_g_status;
wire [31:0] /*[31:0]*/ cpz_g_epc_rd_data;
wire cpz_g_iack;
wire cpz_g_timerint;
wire cpz_g_mx;
wire [1:0] /*[1:0]*/ cpz_g_swint;
wire [31:0] /*[31:0]*/ badva;
wire cpz_g_at_epi_en;
wire cpz_g_watch_present__5;
wire cpz_g_int_mw;
wire [3:0] /*[3:0]*/ cpz_g_srsctl_css;
wire cpz_g_bootisamode;
wire cpz_g_takeint;
wire [17:1] /*[17:1]*/ cpz_g_vectoroffset;
wire g_nest_erl;
wire cpz_g_ulri;
wire cpz_g_rbigend_e;
wire [5:0] /*[5:0]*/ cpz_g_ivn;
wire cpz_g_pc_present;
wire cpz_g_watch_present__3;
wire g_doze;
wire cpz_g_mmutype;
wire cpz_g_um_vld;
wire [3:0] /*[3:0]*/ cpz_g_copusable;
wire [1:0] /*[1:0]*/ cpz_g_mmusize;
wire cpz_g_kuc_m;
wire g_iap_exce_handler_trace;
wire vz_present;
wire cpz_g_cee;
wire cpz_g_kuc_w;
wire cpz_g_watch_present;
wire cpz_g_iv;
wire cpz_g_watch_present__1;
wire [3:0] /*[3:0]*/ cpz_g_srsctl_pss;
wire cpz_g_erl;
wire cpz_g_at_pro_start_i;
wire cpz_g_kuc_i;
// END Wire declarations made by MVP


	// End of I/O

	/* Outputs */
	assign cpz_g_bev		 = 1'b0;
	assign g_cp0read_m [31:0]	 = 32'b0;
	assign cpz_g_copusable [3:0]	 = 4'b0;
        assign cpz_g_cee		 = 1'b0;
	assign g_eretpc [31:0]	 = 32'b0;
	assign cpz_g_eretisa 		 = 1'b0;
	assign cpz_g_erl		 = 1'b0;
        assign cpz_g_erl_e 		 = 1'b0;
	assign g_nest_exl		 = 1'b0;
	assign g_nest_erl		 = 1'b0;
	assign cpz_g_hotexl		 = 1'b0;
	assign cpz_g_exl		 = 1'b0;
	assign cpz_g_um		 = 1'b0;
	assign cpz_g_um_vld		 = 1'b0;
	assign cpz_g_int_e		 = 1'b0;
	assign cpz_g_int_mw		 = 1'b0;
	assign cpz_g_iv		 = 1'b0;
	assign cpz_g_hwrena [3:0]	 = 4'b0;
	assign cpz_g_hwrena_29   	 = 1'b0;
	assign cpz_g_ebase [31:12]	 = 20'b0;
	assign cpz_g_vectoroffset [17:1]	 = 17'b0;
	assign cpz_g_srsctl_pss2css_m		 = 1'b0;
	assign cpz_g_srsctl_css [3:0]	 = 4'b0;
	assign cpz_g_srsctl_pss [3:0]	 = 4'b0;
	assign cpz_g_hoterl		 = 1'b0;
        assign cpz_g_k0cca [2:0]     = 3'b0;
        assign cpz_g_k23cca [2:0]     = 3'b0;
        assign cpz_g_kucca [2:0]     = 3'b0;
   	assign cpz_g_kuc_i		= 1'b0;
	assign cpz_g_kuc_e		= 1'b0;
	assign cpz_g_kuc_m		= 1'b0;
	assign cpz_g_kuc_w		= 1'b0;
	assign cpz_g_llbit		 = 1'b0;
	assign cpz_g_rbigend_e		 = 1'b0;
	assign cpz_g_rbigend_i		 = 1'b0;
        assign cpz_g_excisamode           = 1'b0;
        assign cpz_g_bootisamode           = 1'b0;

	assign cpz_g_rp 		 = 1'b0;

	assign cpz_g_smallpage		 = 1'b0;
	assign cpz_g_ipl [7:0]     = 8'b0;
        assign cpz_g_ivn [5:0]     = 6'b0;
        assign cpz_g_ion [17:1]     = 17'b0;
        assign cpz_g_swint [1:0]     = 2'b0;
	assign cpz_g_iack		 = 1'b0;
	assign cpz_g_iwatchhit		 = 1'b0;
	assign cpz_g_dwatchhit		 = 1'b0;
	assign cpz_g_wpexc_m 		 = 1'b0;
	assign g_doze 		 = 1'b0;
	assign cpz_g_mmusize [1:0]	= 2'b0;
	assign cpz_g_mmutype 		 = 1'b0;

	assign cpz_g_srsctl [31:0]    = 32'b0;
        assign cpz_g_status [31:0]    = 32'b0;
        assign cpz_g_ext_int           = 1'b0;
        assign cpz_g_epc_rd_data [31:0]    = 32'b0;
        assign cpz_g_pf           = 1'b0;
        assign cpz_g_takeint           = 1'b0;
        assign cpz_g_at_epi_en           = 1'b0;
        assign cpz_g_stkdec [4:0]     = 5'b0;
        assign cpz_g_ice           = 1'b0;
        assign cpz_g_int_pend_ed [7:0]     = 8'b0;
        assign cpz_g_iretpc [31:0]    = 32'b0;
	assign cpz_g_usekstk           = 1'b0;
	assign cpz_g_causeap           = 1'b0;
	assign cpz_g_int_enable           = 1'b0;
	assign g_iret_tailchain		 = 1'b0;
	assign cpz_g_iap_um		 = 1'b0;
        assign cpz_g_at_pro_start_i           = 1'b0;
        assign cpz_g_at_pro_start_val           = 1'b0;

	assign g_iap_exce_handler_trace	         = 1'b0;

	assign cpz_g_mx		 = 1'b0;
	assign vz_present		 = 1'b0;
	assign cpz_ghfc_i		 = 1'b0;
	assign cpz_ghfc_w		 = 1'b0;
	assign cpz_gsfc_m		 = 1'b0;
	assign cpz_g_hss [3:0]     = 4'b0;
	assign cpz_g_int_excl_ie_e = 1'b0;	
	assign cpz_g_config_ld = 1'b0;
	assign g_fr = 1'b0;
	assign cpz_g_pc_present = 1'b0;
	assign cpz_g_cause_pci = 1'b0;
	assign cpz_g_timerint = 1'b0;
	assign gripl_clr = 1'b0;
	assign cpz_g_ulri = 1'b0;
	assign cpz_g_cdmm = 1'b0;
	assign cpz_g_watch_present = 1'b0;
	assign cpz_g_watch_present__1 = 1'b0;
	assign cpz_g_watch_present__2 = 1'b0;
	assign cpz_g_watch_present__3 = 1'b0;
	assign cpz_g_watch_present__4 = 1'b0;
	assign cpz_g_watch_present__5 = 1'b0;
	assign cpz_g_watch_present__6 = 1'b0;
	assign cpz_g_watch_present__7 = 1'b0;
	assign cpz_g_ufr = 1'b0;
	assign badva [31:0] = 32'b0;

/*hookup*/
	m14k_cpz_watch_stub watch(
	.cpz(cpz),
	.cpz_dwatchhit(cpz_dwatchhit),
	.cpz_iwatchhit(cpz_iwatchhit),
	.cpz_mmutype(cpz_mmutype),
	.cpz_watch_present__1(cpz_watch_present__1),
	.cpz_watch_present__2(cpz_watch_present__2),
	.cpz_watch_present__3(cpz_watch_present__3),
	.cpz_watch_present__4(cpz_watch_present__4),
	.cpz_watch_present__5(cpz_watch_present__5),
	.cpz_watch_present__6(cpz_watch_present__6),
	.cpz_watch_present__7(cpz_watch_present__7),
	.dcc_dvastrobe(dcc_dvastrobe),
	.delay_watch(delay_watch),
	.edp_alu_m(edp_alu_m),
	.edp_iva_i(edp_iva_i),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.hot_delay_watch(hot_delay_watch),
	.hot_ignore_watch(hot_ignore_watch),
	.ignore_watch(ignore_watch),
	.mfcp0_m(mfcp0_m),
	.mmu_asid(mmu_asid),
	.mmu_dva_m(mmu_dva_m),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_busty_m(mpc_busty_m),
	.mpc_cp0r_m(mpc_cp0r_m),
	.mpc_cp0sr_m(mpc_cp0sr_m),
	.mpc_exc_e(mpc_exc_e),
	.mpc_exc_m(mpc_exc_m),
	.mpc_exc_w(mpc_exc_w),
	.mpc_fixup_m(mpc_fixup_m),
	.mpc_ivaval_i(mpc_ivaval_i),
	.mpc_pexc_i(mpc_pexc_i),
	.mpc_run_i(mpc_run_i),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_squash_i(mpc_squash_i),
	.mtcp0_m(mtcp0_m),
	.set_watch_pend_w(set_watch_pend_w),
	.watch32(watch32),
	.watch_present(watch_present));
	
/*hookup*/
	m14k_cpz_guest_srs1 cpz_srs(
	.cpz(cpz),
	.cpz_gm_m(cpz_gm_m),
	.cpz_srsctl_pss2css_m(cpz_srsctl_pss2css_m),
	.eic_present(eic_present),
	.eiss(eiss),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.hot_srsctl_pss(hot_srsctl_pss),
	.srsctl(srsctl),
	.srsctl_css2pss_w(srsctl_css2pss_w),
	.srsctl_ess2css_w(srsctl_ess2css_w),
	.srsctl_ld(srsctl_ld),
	.srsctl_rd(srsctl_rd),
	.srsctl_vec2css_w(srsctl_vec2css_w),
	.srsdisable(srsdisable),
	.srsmap(srsmap),
	.srsmap2(srsmap2),
	.srsmap2_ld(srsmap2_ld),
	.srsmap2_rd(srsmap2_rd),
	.srsmap_ld(srsmap_ld),
	.srsmap_rd(srsmap_rd),
	.vectornumber(vectornumber));
	
// 
 `ifdef MIPS_SIMULATION 
 //VCS coverage off 
//
//verilint 528 off        // Variable set but not used

	wire	[25:0]	status_nxt = 26'b0;
	wire	[25:0]	status = 26'b0;
	wire	[31:0]	intctl32 = 32'b0;
	wire	[17:0]	intctl_nxt = 18'b0;
	wire	[31:0]	config0 = 32'b0;
	wire	[12:0]	config0w = 13'b0;
	wire	[24:20]	config0static_hi = 5'b0;
	wire	[18:3]	config0static_lo = 16'b0;
	wire		config1_ld = 1'b0;
	wire	[11:0]	config1w_cnxt = 12'b0;
	wire	[11:0]	config1w = 12'b0;
	wire	[31:0]	config1 = 32'b0;
	wire		config3_ld = 1'b0;
	wire		config3_excisa_cnxt = 1'b0;
	wire	[31:0]	config2 = 32'b0;
	wire	[31:0]	config3 = 32'b0;
	wire	[31:0]	config4 = 32'b0;
	wire	[31:0]	config5 = 32'b0;
	wire		setll_w = 1'b0;
	wire	[27:0]	lladdr_s = 28'b0;
	wire	[27:0]	lladdr = 28'b0;
	wire	[31:0]	epc_cnxt = 32'b0;
	wire		eisa_cnxt = 1'b0;
	wire		nestepc_cond = 1'b0;
	wire	[31:0]	nestepc = 32'b0;
	wire		nesteisa = 1'b0;
	wire		epc_cond = 1'b0;
	wire	[31:0]	epc = 32'b0;
	wire		eisa = 1'b0;
	wire		errpc_cond = 1'b0;
	wire	[31:0]	errpc = 32'b0;
	wire		errisa = 1'b0;
	wire	[31:0]	ebase32 = 32'b0;
	wire		dieicp0_m = 1'b0;
	wire		g_eic_mode = 1'b0;
	wire	[14:0]	cause_nxt = 15'b0;
	wire		nesterl_cond = 1'b0;
	wire		nestexl_cond = 1'b0;
	wire	[7:0]	causeip = 8'b0;
	wire		watch_pend = 1'b0;
	wire	[31:0]	cause32 = 32'b0;
	wire	[31:0]	nestexc32 = 32'b0;
	wire		arch_llbit_nxt = 1'b0;
	wire	[7:0]	int_pend_ed = 8'b0;
	wire	[7:0]	g_int_pend_e = 8'b0;
	wire	[1:0]	sw_int_e = 2'b0;
	wire	[1:0]	sw_int_m = 2'b0;
	wire	[7:0]	hw_int_e = 8'b0;
	wire	[7:0]	hw_int_m = 8'b0;
	wire	[31:0]	cntxt32 = 32'b0;
	wire		cntxt_ld = 1'b0;
	wire		userlocal_ld = 1'b0;
	wire	[31:23]	cntxt = 8'b0;
	wire	[31:0]	badva_s = 32'b0;
	wire		compare_ld = 1'b0;
	wire	[31:0]	compare = 32'b0;
	wire	[9:0]	view_ipl_nxt = 10'b0;
	wire		config1_fp = 1'b0;
	wire		int_enable_m = 1'b0;
	wire	[31:0]	status32 = 32'b0;
	wire	[31:0]	badinstr = 32'b0;
	wire	[31:0]	badinstrp = 32'b0;
	wire    [31:0]  view_ripl32 = 32'b0;
	wire		wr_cause = 1'b0;
	wire		ctc1_fr0_m = 1'b0;
	wire		ctc1_fr1_m = 1'b0;
	wire		int_gripl_ed = 1'b0;
	wire    [31:0]  g_srsctl = 32'b0;
	wire    [31:0]  cpz_count = 32'b0;
	wire		ebase_ld = 1'b0;

 //VCS coverage on  
 `endif 
//
//
//verilint 528 on        // Variable set but not used

endmodule
