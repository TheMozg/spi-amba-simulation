// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_mpc_exc
//           Exception processing logic
//
//    $Id: \$
//    mips_repository_id: m14k_mpc_exc.mv, v 1.130 
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
module m14k_mpc_exc(
	cpz_sst,
	cpz_hotdm_i,
	cpz_dm_m,
	debug_mode_e,
	cpz_dm_w,
	ej_probtrap,
	ej_rdvec,
	icc_imiss_i,
	icc_umipsfifo_null_i,
	icc_halfworddethigh_fifo_i,
	icc_slip_n_nhalf,
	icc_umipsfifo_stat,
	mpc_isamode_i,
	mpc_excisamode_i,
	mpc_compact_e,
	icc_nobds_e,
	hold_intpref_done,
	cpz_iexi,
	cpz_hotiexi,
	cpz_hotexl,
	cpz_exl,
	cpz_iv,
	cpz_bev,
	mpc_squash_i,
	squash_e,
	mpc_squash_m,
	squash_w,
	mpc_updateepc_e,
	mpc_nomacroepc_e,
	mpc_fixupi,
	sst_instn_valid_e,
	mpc_irval_e,
	mpc_irvalunpred_e,
	mpc_irvaldsp_e,
	dspver_e,
	edp_trapeq_m,
	mpc_load_m,
	mdu_stall,
	sarop_e,
	sdbbp_e,
	syscall_e,
	break_e,
	raw_trap_in_e,
	trap_type_e,
	cp_un_e,
	ce_un_e,
	ri_e,
	qual_umipsri_e,
	ejt_ejtagbrk,
	ejt_dbrk_w,
	ejt_dbrk_m,
	ejt_ivabrk,
	ejt_dvabrk,
	ejt_cbrk_m,
	mpc_sbstrobe_w,
	dcc_ldst_m,
	edp_povf_m,
	greset,
	cpz_nmi_e,
	cpz_nmi_mw,
	mmu_tlbshutdown,
	cp2_exc_w,
	cp1_exc_w,
	cpz_dwatchhit,
	mmu_dtexc_m,
	cpz_iwatchhit,
	mmu_itexc_i,
	mmu_adrerr,
	mmu_r_tlbshutdown,
	mmu_r_dtexc_m,
	mmu_r_itexc_i,
	mmu_r_adrerr,
	mmu_iec,
	mmu_itxiexc_i,
	mmu_dtriexc_m,
	mmu_tlbinv,
	mmu_tlbrefill,
	mmu_tlbmod,
	mmu_r_iec,
	mmu_r_itxiexc_i,
	mmu_r_dtriexc_m,
	mmu_r_tlbinv,
	mmu_r_tlbrefill,
	mmu_r_tlbmod,
	cp2_exccode_w,
	cp2_missexc_w,
	cp1_exccode_w,
	cp1_missexc_w,
	dcc_intkill_m,
	dcc_intkill_w,
	cpz_int_mw,
	cpz_int_e,
	cpz_wpexc_m,
	biu_dbe_exc,
	biu_ibe_exc,
	dcc_precisedbe_w,
	dcc_dbe_killfixup_w,
	icc_preciseibe_i,
	icc_preciseibe_e,
	cpz_setdbep,
	biu_wbe,
	biu_lock,
	dcc_exc_nokill_m,
	cpz_setibep,
	mpc_annulds_e,
	mpc_run_ie,
	mpc_run_i,
	mpc_run_m,
	mpc_run_w,
	gscanenable,
	gclk,
	cpz_ext_int,
	at_pro_done_i,
	at_epi_done_i,
	cpz_pf,
	mpc_hw_save_epc_e,
	mpc_hw_save_status_e,
	mpc_hw_save_srsctl_e,
	mpc_hw_load_status_e,
	mpc_hw_load_epc_e,
	mpc_hw_load_srsctl_e,
	mpc_atpro_w,
	mpc_atepi_w,
	cpz_takeint,
	cpz_at_pro_start_val,
	mpc_atpro_m,
	mpc_atepi_m,
	mpc_atomic_m,
	mpc_atomic_e,
	mpc_atomic_w,
	chain_vec_end,
	mpc_chain_strobe,
	cpz_excisamode,
	cpz_bootisamode,
	hw_save_epc_i,
	mpc_hw_load_status_i,
	continue_squash_i,
	mpc_chain_vec,
	mpc_hw_save_srsctl_i,
	hw_save_status_i,
	hw_load_epc_i,
	hw_load_srsctl_i,
	mpc_hw_ls_i,
	mpc_iretret_m,
	mpc_eret_null_m,
	mpc_lsdc1_e,
	mpc_lsdc1_m,
	mpc_lsdc1_w,
	cp1_seen_nodmiss_m,
	dec_dsp_exc_e,
	cpz_mx,
	cdmm_mputriggered_i,
	cdmm_mputriggered_m,
	cdmm_mmulock,
	mpc_ebld_e,
	pend_exc,
	mpc_auexc_x,
	mpc_ndauexc_x,
	mpc_dmsquash_m,
	mpc_dmsquash_w,
	mpc_eexc_e,
	mpc_imsquash_i,
	mpc_imsquash_e,
	mpc_exc_e,
	mpc_exc_m,
	mpc_hold_hwintn,
	mpc_evecsel,
	mpc_exc_w,
	mpc_exc_w_org,
	mpc_exccode,
	dexc_type,
	mpc_tlb_exc_type,
	mpc_jamepc_w,
	mpc_jamdepc_w,
	mpc_jamerror_w,
	mpc_ebexc_w,
	mpc_jamtlb_w,
	mpc_killmd_m,
	mpc_ekillmd_m,
	mpc_ekillmd_w,
	mpc_ldcause,
	mpc_pexc_i,
	mpc_pexc_e,
	mpc_pexc_m,
	mpc_pexc_w,
	mpc_penddbe,
	mpc_pendibe,
	mpc_nmitaken,
	mpc_sbtake_w,
	mpc_mputake_w,
	mpc_sdbreak_w,
	mpc_dparerr_for_eviction,
	mpc_killcp2_w,
	mpc_cp2exc,
	mpc_killcp1_w,
	mpc_cp1exc,
	cpz_g_hotexl,
	cpz_g_exl,
	icc_parerr_i,
	icc_parerr_w,
	dcc_parerr_m,
	qual_iparerr_i,
	qual_iparerr_w,
	mpc_hold_int_pref_phase1_val,
	dcc_parerr_w,
	mpc_int_pref,
	mpc_int_pf_phase1_reg,
	mpc_ld_causeap,
	mpc_qual_auexc_x,
	mpc_first_det_int,
	pf_phase1_nosquash_i,
	hw_exc_m,
	hw_exc_w,
	mpc_squash_e,
	mpc_expect_isa,
	mpc_int_pref_phase1,
	hold_pf_phase1_nosquash_i,
	int_pref_phase2,
	set_pf_auexc_nosquash,
	set_pf_phase1_nosquash,
	mpc_cont_pf_phase1,
	mpc_pf_phase2_done,
	mpc_tint,
	mpc_dis_int_e,
	mpc_itqualcond_i,
	mpc_ibrk_qual,
	mpc_mputriggeredres_i,
	mpc_atomic_impr,
	held_parerrexc_i,
	new_exc_i,
	cpz_ghfc_i,
	cpz_ghfc_w,
	cpz_gsfc_m,
	cpz_gm_i,
	cpz_gm_e,
	cpz_gm_m,
	cpz_gm_w,
	cpz_g_mx,
	cpz_g_dwatchhit,
	cpz_g_takeint,
	cpz_g_iwatchhit,
	cpz_g_int_e,
	cpz_g_int_mw,
	cpz_g_wpexc_m,
	cpz_g_iv,
	cpz_g_ext_int,
	cpz_g_pf,
	cpz_g_bev,
	cpz_g_excisamode,
	cpz_g_bootisamode,
	cpz_g_at_pro_start_val,
	qual_umipsri_g_e,
	ri_g_e,
	ce_g_un_e,
	cp_g_un_e,
	g_p_eret_e,
	g_p_iret_e,
	g_p_deret_e,
	g_p_hypcall_e,
	g_p_diei_e,
	g_p_cop_e,
	g_p_wait_e,
	g_p_idx_cop_e,
	g_p_perfcnt_e,
	g_p_tlb_e,
	g_p_config_e,
	g_p_cc_e,
	g_p_rh_cp0_e,
	g_p_count_e,
	g_p_srs_e,
	g_p_rwpgpr_e,
	g_p_cp0_always_e,
	g_p_cp0_e,
	g_p_og_e,
	p_hypcall_e,
	cpz_ri,
	scop2_w,
	lscop2_w,
	icc_macrobds_e,
	mpc_g_int_pf,
	mpc_g_jamepc_w,
	mpc_g_jamtlb_w,
	mpc_r_auexc_x,
	mpc_g_auexc_x,
	mpc_r_auexc_x_qual,
	mpc_g_auexc_x_qual,
	mpc_gexccode,
	mpc_g_eexc_e,
	mpc_g_ldcause,
	mpc_g_ld_causeap,
	mpc_badins_type,
	mpc_tlb_i_side,
	mpc_tlb_d_side,
	mpc_ge_exc,
	mpc_auexc_on,
	mpc_gpsi_perfcnt,
	mpc_exc_type_w);


	// CPZ state
	input cpz_sst;                      // Single Step Enabled
	input cpz_hotdm_i;                  // I-stage is in Debug Mode
	input cpz_dm_m;                     // M-stage is in Debug Mode
	input debug_mode_e;                 // E-stage is in Debug Mode
	input cpz_dm_w;                     // W-stage is in Debug Mode
	input ej_probtrap;                  // EJTAG exceptions should go to Probe
	input ej_rdvec;			    
	input icc_imiss_i;		    
	input icc_umipsfifo_null_i;	    
	input icc_halfworddethigh_fifo_i;   
	input icc_slip_n_nhalf;
	input [3:0] icc_umipsfifo_stat;	    
	input mpc_isamode_i;		    
	input mpc_excisamode_i;
	input mpc_compact_e;
	input icc_nobds_e;
	input hold_intpref_done;	    
	input cpz_iexi;                     // Imprecise Exception Inhibit
	input cpz_hotiexi;                  // I-stage IEXI
	input cpz_hotexl;                   // I-stage version of Status.EXL
	input cpz_exl;                      // M-stage version of Status.EXL
	input cpz_iv;                       // State of Cause.IV 
	input cpz_bev;                      // State of Status.BEV
	
	
	// Control signals
	input mpc_squash_i;                 // Squash I-stage exception
	input squash_e;                     // Squash E-stage exception
	input mpc_squash_m;                 // Squash M-stage exception
	input squash_w;                     // Squash W-stage exception
	
	input mpc_updateepc_e;              // Capture EPC for E-stage instn (also, enable single step exception)
	input mpc_nomacroepc_e;
	input mpc_fixupi;                   // I$ miss previous cycle
	input sst_instn_valid_e;            // Instruction is valid (but possibly exceptional)
	input mpc_irval_e;                  // Instruction register has valid data
	input mpc_irvalunpred_e;            // Instruction register has valid data, but may have architecturally unpredictable behavior
	input mpc_irvaldsp_e;                  // Instruction register has valid data
	input dspver_e;			    // instruction is dsp related
	input edp_trapeq_m;                 // Trap Equality
	input mpc_load_m;                   // load in m-stage
        input mdu_stall;                    // Stalling MDU op in M-stage

	// Decode signals
	input sarop_e;                      // Signed Arithmetic op (overflow possible)
	input sdbbp_e;                      // SDBBP instn
	input syscall_e;                    // SysCall instn
	input break_e;                      // Break instn
	input raw_trap_in_e;                // Trap instn
	input trap_type_e;                  // Type of trap
	input cp_un_e;                      // CpU exception
	input ce_un_e;                      // CEU exception
	input ri_e;                         // RI exception
	input qual_umipsri_e;                 // UMIPS RI exception
	
	// EJTAG inputs
	input ejt_ejtagbrk;                 // Break requested from EJTAG unit (DINT, etc.)
	input ejt_dbrk_w;                   // EJTAG Data breakpoint
	input ejt_dbrk_m;                   // EJTAG Data breakpoint
	input ejt_ivabrk;                   // EJTAG IVA breakpoint
	input ejt_dvabrk;                   // EJTAG DVA breakpoint
	input ejt_cbrk_m;		    // EJTAG complex break
	input mpc_sbstrobe_w;               // Simple Break strobe - used to clear dbits/ibits
	input dcc_ldst_m;                   // load or store in M-stage
	

	input edp_povf_m;                   // Addition overflow
	input greset;                       // global reset
	input cpz_nmi_e;                    // E-stage NMI
	input cpz_nmi_mw;                   // M and W-stage NMI
	input mmu_tlbshutdown;              // TLB Shutdown condition
	input cp2_exc_w;                    // W-stage Cop2 exception
	input cp1_exc_w;                    // W-stage Cop1 exception
	input cpz_dwatchhit;                // Data Watch exception
	input mmu_dtexc_m;                  // Data translation exception
	input cpz_iwatchhit;                // Instn Watch exception
	input mmu_itexc_i;                  // Instn translation exception
	input mmu_adrerr;                   // TransExc was Address error
	input mmu_r_tlbshutdown;              // TLB Shutdown condition
	input mmu_r_dtexc_m;                  // Data translation exception
	input mmu_r_itexc_i;                  // Instn translation exception
	input mmu_r_adrerr;                   // TransExc was Address error
	input mmu_iec;			    // enable unique exception code for ri/xi
	input mmu_itxiexc_i;		    // itlb execution inhibit exception
	input mmu_dtriexc_m;		    // D-addr RI exception
	input mmu_tlbinv;                   // TransExc was TLB Invalid
	input mmu_tlbrefill;                // TransExc was TLB Refill
	input mmu_tlbmod;                   // TransExc was TLB Modified
	input mmu_r_iec;			    // enable unique exception code for ri/xi
	input mmu_r_itxiexc_i;		    // itlb execution inhibit exception
	input mmu_r_dtriexc_m;		    // D-addr RI exception
	input mmu_r_tlbinv;                   // TransExc was TLB Invalid
	input mmu_r_tlbrefill;                // TransExc was TLB Refill
	input mmu_r_tlbmod;                   // TransExc was TLB Modified

	input [4:0] cp2_exccode_w;          // Exception code returned from Cop2
	input 	    cp2_missexc_w;          // Waiting for valid exception
	input [4:0] cp1_exccode_w;          // Exception code returned from Cop1
	input 	    cp1_missexc_w;          // Waiting for valid exception

        input dcc_intkill_m;                // Interrupt killed M-stage L/S instn
	input dcc_intkill_w;           	    // Interrupt killed W-stage L/S instn
	input cpz_int_mw;                   // Interrupt in M/W stage
	input cpz_int_e;                    // Interrupt in E stage
	
	input cpz_wpexc_m;                  // Watch Pending Exception
	input biu_dbe_exc;                      // Data Bus Error
	input biu_ibe_exc;                      // Instruction Bus Error
	input dcc_precisedbe_w;             // DBE was precise
	input dcc_dbe_killfixup_w;          // DBE killed W-stage instn
	input icc_preciseibe_i;             // IBE was precise in I-stage
	input icc_preciseibe_e;             // IBE was precise in E-stage
	input cpz_setdbep;                  // Set DBE pending
	input biu_wbe;                      // Write Bus Error
	input biu_lock;			    // Bus was locked
	input dcc_exc_nokill_m;   	    // atomic load is already in fixup w stage
                                            // Bus is waiting to be locked
	input cpz_setibep;                  // Set IBE pending
	input mpc_annulds_e;                // Annulled Delay Slot in E
	
	input mpc_run_ie;                   // I/E-stage run signal
	input mpc_run_i;                    // I-stage run signal
	input mpc_run_m;                    // M-stage run signal
	input mpc_run_w;                    // W-stage run signal
	
	input gscanenable;                  // Scan Enable
	input gclk;                         // Clock
	
	input cpz_ext_int;                    //external interrupt
        input at_pro_done_i;                  //HW entry sequence is done
        input at_epi_done_i;         	      //HW exit sequence is done
        input cpz_pf;                         //speculative prefetch enable
        input          mpc_hw_save_epc_e;     //E-stage HW save EPC operation
        input          mpc_hw_save_status_e;  //E-stage HW save Status operation
        input          mpc_hw_save_srsctl_e;  //E-stage HW save SRSCTL operation
        input          mpc_hw_load_status_e;  //E-stage HW load Status operation
        input          mpc_hw_load_epc_e;     //E-stage HW load EPC operation
        input          mpc_hw_load_srsctl_e;  //E-stage HW load SRSCTL operation
	input	       mpc_atpro_w;           //auto-prologue in W-stage
	input          mpc_atepi_w;           //auto-epilogue in W-stage
        input          cpz_takeint;           //interrupt recognized finally
        input          cpz_at_pro_start_val;  //valid start of HW auto prologue
	input          mpc_atpro_m;               //auto-prologue in M-stage
	input          mpc_atepi_m;           //auto-epilogue in M-stage
	input	       mpc_atomic_m;	      // Atomic instruction entered into M stage for load
	input	       mpc_atomic_e;	      // Atomic instruction decoded in E stage 
	input	       mpc_atomic_w;	      // Atomic instruction entered into W stage for store 
	input          chain_vec_end;         //end cycle of hold tail chain jump
	input          mpc_chain_strobe;      //tail chain happen strobe
	input          cpz_excisamode;
        input          cpz_bootisamode;
	input          hw_save_epc_i;         //HW save epc i-stage
        input          mpc_hw_load_status_i;  //I-stage HW load Status operation
	input          continue_squash_i;     //continue squash in I-stage
        input          mpc_chain_vec;         //jump to next interrupt PC on IRET if tailchain happen
	input	       mpc_hw_save_srsctl_i;      //HW save srcctl in I-stage
	input	       hw_save_status_i;      //HW save status in I-stage
	input	       hw_load_epc_i;	      //HW load epc in I-stage
	input          hw_load_srsctl_i;      //HW load srsctl in I-stage
	input	       mpc_hw_ls_i;	      //HW operation in I-stage
	input	       mpc_iretret_m;	      //M-stage qualified iret_ret
	input	       mpc_eret_null_m;	      //M-stage qualified eret
	input	       mpc_lsdc1_e;
	input	       mpc_lsdc1_m;
	input	       mpc_lsdc1_w;
	input	       cp1_seen_nodmiss_m;

	input	       dec_dsp_exc_e;
	input	       cpz_mx;
	input		cdmm_mputriggered_i;	// i-access in protected region
	input		cdmm_mputriggered_m;	// r/w-access in protected region
	input		cdmm_mmulock;		// mmu and ebase protected
	input		mpc_ebld_e;		// ebase load 
	output 		pend_exc;
	output		mpc_auexc_x;	    // Exception has reached end of pipe, redirect fetch
	output		mpc_ndauexc_x;	    // performance counter signal. not-debug-mode exception
	output		mpc_dmsquash_m;	    // Kill D$ miss due to M-stage exceptions.

	output		mpc_dmsquash_w;	    // Kill D$ Miss if Fixup instn is killable

	output		mpc_eexc_e;	    // early exceptions detected in E-stage
	output		mpc_imsquash_i;	    // Kill I$ miss due to I-stage exceptions.
	output		mpc_imsquash_e;	    // Kill I$ Miss due to E-stage exceptions
	output		mpc_exc_e;	    // E-stage killed by exception
	output		mpc_exc_m;	    // M-stage killed by exception 
	output		mpc_hold_hwintn;    // Hold hwint pins until exception taken

	output [7:0]  mpc_evecsel;        // Exception Vector Selection bits

	output		mpc_exc_w;	    // W-stage killed by exception
	output		mpc_exc_w_org;	    // W-stage killed by exception
	output [4:0]	mpc_exccode;	    // cause PLA to encode exceptions into a 5 bit field
	output [2:0] 	dexc_type;          // Encoded values for debug exceptions
	output 		mpc_tlb_exc_type;	    // i stage exception type
	output		mpc_jamepc_w;	    // load EPC register from EPC timing chain
	output		mpc_jamdepc_w;	    // load DEPC register from EPC timing chain
	output		mpc_jamerror_w;	    // load ErrorPC register from EPC timing chain
	output		mpc_ebexc_w;	    // core taking ebase exception
	output		mpc_jamtlb_w;       // load translation registers from shadow values
	output		mpc_killmd_m;       // Kill MDU instn
	output		mpc_ekillmd_m;      // Early Kill MDU instn
	output		mpc_ekillmd_w;      // Early Kill MDU instn
	output		mpc_ldcause;	    // load cause register for exception
	output		mpc_pexc_i;	    // prior exception
	output		mpc_pexc_e;		    // prior exception
	output		mpc_pexc_m;	    // prior exception
	output		mpc_pexc_w;	    // prior exception
	output 		mpc_penddbe;        // DBE is pending
	output 		mpc_pendibe;        // IBE is pending
	output 		mpc_nmitaken;       // biu_nmi exception is being taken
	output		mpc_sbtake_w;       // Simple Break exception is being taken
	output		mpc_mputake_w;	    // MPU exception being taken
	output		mpc_sdbreak_w;      // ejtag SB D-break taken (kill store)
	output          mpc_dparerr_for_eviction; // t_dperr
	output 		mpc_killcp2_w;      // Kill cp2 instn
	output 		mpc_cp2exc;         // cp2 exc was taken
	output 		mpc_killcp1_w;      // Kill cp1 instn
	output 		mpc_cp1exc;         // cp1 exc was taken

	input		cpz_g_hotexl;		// cpz_g_exl bit from status
	input		cpz_g_exl;		// cpz_g_exl bit from status

        input           icc_parerr_i;       //I$ parity error detected at I stage 
        input           icc_parerr_w;       //I$ CacheOP parity error 
        input           dcc_parerr_m;       //D$ parity error detected at M cycle 
	output		qual_iparerr_i;	    // Qualified D$ parity exception
	output		qual_iparerr_w;	    // Qualified D$ parity exception
	output		mpc_hold_int_pref_phase1_val;  //phase1 of interrupt prefetch
        input           dcc_parerr_w;       //D$ parity error detected at W cycle 
		
	output          mpc_int_pref;         //PC held for interrupt vector prefetch during pipeline flush or auto-prologue seqence
	output          mpc_int_pf_phase1_reg;
        output          mpc_ld_causeap;       //load Cause.AP when detect exception during auto prologue
        output          mpc_qual_auexc_x;     //final cycle of mpc_auexc_x
        output          mpc_first_det_int;    //first cycle interrupt detected
        output          pf_phase1_nosquash_i; //not squash imiss due to pend_exc during ISR instruction prefetch
        output          hw_exc_m;             //exception during HW operations
        output          hw_exc_w;             //exception during HW operations
	output		mpc_squash_e;	      //Squash E-stage exception
	output		mpc_expect_isa;	      //core is expected to be in isa mode
	output		mpc_int_pref_phase1;  //phase1 of interrupt prefetch
	output		hold_pf_phase1_nosquash_i;
	output		int_pref_phase2;
	output		set_pf_auexc_nosquash;
	output		set_pf_phase1_nosquash;
	output		mpc_cont_pf_phase1;   //continue phase1 of interrupt prefetch
	output		mpc_pf_phase2_done;   //phase2 of interrupt prefetch is done
	output		mpc_tint;	      //interrupt is taken
	output		mpc_dis_int_e;	      //disable interrupt in E-stage

	output		mpc_itqualcond_i;     //itlb exception
	output		mpc_ibrk_qual;	      //ibrk exception
	output		mpc_mputriggeredres_i;

	output		mpc_atomic_impr;	//atomic lead imprecise data breakpoint 

	output		held_parerrexc_i;	// hold i-stage parity error

        output          new_exc_i;

	input		cpz_ghfc_i;	
	input		cpz_ghfc_w;	
	input		cpz_gsfc_m;	
	input		cpz_gm_i;	
	input		cpz_gm_e;	
	input		cpz_gm_m;	
	input		cpz_gm_w;	
	input		cpz_g_mx;	
	input		cpz_g_dwatchhit;	// data Watch comparison matched
	input		cpz_g_takeint;            //interrupt recognized finally
	input		cpz_g_iwatchhit;	// instruction Watch comparison matched
	input		cpz_g_int_e;	// external, software, and non-maskable interrupts
	input 		cpz_g_int_mw;                   // Interrupt in M/W stage
	input 		cpz_g_wpexc_m;        // Deferred watch exception
	input		cpz_g_iv;		// cpz_g_iv bit from cause
	input           cpz_g_ext_int;            //external interrupt
	input           cpz_g_pf;                 //speculative prefetch enable
	input		cpz_g_bev;		// Bootstrap exception vectors
	input           cpz_g_excisamode; // isamode for exception
	input           cpz_g_bootisamode; // isamode for boot
	input           cpz_g_at_pro_start_val;
        input           qual_umipsri_g_e;
        input           ri_g_e;
        input           ce_g_un_e;
        input           cp_g_un_e;
	input		g_p_eret_e;
	input		g_p_iret_e;
	input		g_p_deret_e;
	input		g_p_hypcall_e;
	input		g_p_diei_e;
	input		g_p_cop_e;
        input           g_p_wait_e;
        input           g_p_idx_cop_e;
        input           g_p_perfcnt_e;
        input           g_p_tlb_e;
	input		g_p_config_e;
	input		g_p_cc_e;
	input		g_p_rh_cp0_e;
	input		g_p_count_e;
	input		g_p_srs_e;
	input		g_p_rwpgpr_e;
	input		g_p_cp0_always_e;
	input		g_p_cp0_e;
	input		g_p_og_e;
	input		p_hypcall_e;
	input		cpz_ri;
	input		scop2_w;
	input		lscop2_w;
	input 		icc_macrobds_e;
	
	output		mpc_g_int_pf;	
	output		mpc_g_jamepc_w;	    // load EPC register from EPC timing chain
	output		mpc_g_jamtlb_w;       // load translation registers from shadow values
	output		mpc_r_auexc_x;	    // Exception has reached end of pipe, redirect fetch
	output		mpc_g_auexc_x;	    // Exception has reached end of pipe, redirect fetch
	output		mpc_r_auexc_x_qual;
	output		mpc_g_auexc_x_qual;
	output [4:0]	mpc_gexccode;	    // cause PLA to encode exceptions into a 5 bit field
	output		mpc_g_eexc_e;	
	output		mpc_g_ldcause;	
	output		mpc_g_ld_causeap;	
	output		mpc_badins_type;	
	output		mpc_tlb_i_side;	
	output		mpc_tlb_d_side;	
	output		mpc_ge_exc;	
	output		mpc_auexc_on;	
	output 		mpc_gpsi_perfcnt;
	output          mpc_exc_type_w;         //for performance counter use(indicate dss or ibrk or dbrk or dint or sdbbp exception).

// BEGIN Wire declarations made by MVP
wire cov_it_mod;
wire cov_addrerr;
wire cov_nmi;
wire [5:0] /*[5:0]*/ trap_e;
wire trap_inst_exc_m;
wire cov_cpun;
wire auexc_done;
wire mpc_int_pref;
wire mpc_dmsquash_w;
wire mpc_g_eexc_e;
wire mpc_atomic_impr;
wire poss_pend_exc_reg;
wire mpc_itqualcond_i;
wire pexc_x;
wire see_imiss_off;
wire t_cu;
wire ssdi_e;
wire [5:0] /*[5:0]*/ exc_type_reg;
wire mpc_exc_e;
wire causepla10;
wire causepla12;
wire qual_int_e;
wire int_vect;
wire causepla1;
wire qual_int_w;
wire lexc_w;
wire ssexc_id;
wire mpc_ge_exc;
wire mpc_qual_auexc_x;
wire causepla8;
wire mpc_sdbreak_w;
wire atomic_w_reg;
wire mpc_badins_type;
wire pf_phase1_nosquash_i_off;
wire [1:0] /*[1:0]*/ clear_pend_w;
wire trap_in_m;
wire ej_ldbreak_w;
wire qual_dbe_w;
wire mpc_hold_int_pref_phase1_val;
wire cont_pf_phase1;
wire mpc_cp2exc;
wire iapiae_e;
wire mpc_mputake_w;
wire t_dw;
wire t_ebmp;
wire eerr_w;
wire error_w;
wire umips_qual;
wire t_itxi;
wire hold_pf_phase1_nosquash_i;
wire mpc_jamdepc_w;
wire qual_ibe_e;
wire qual_auexc_x;
wire mpc_penddbe;
wire mpc_pexc_e;
wire new_exc_w;
wire mpc_g_auexc_x_qual;
wire error_w_cache;
wire cov_dt_mod;
wire mpc_g_jamepc_w;
wire hold_parerrexc_i;
wire reset_edge;
wire [5:0] /*[5:0]*/ exc_type;
wire hold_pf_auexc_nosquash_i;
wire mpc_tlb_d_side;
wire t_mc;
wire cov_ss;
wire mpc_auexc_x;
wire hw_exc_w;
wire mpc_exc_w;
wire pend_ibe_reg;
wire causepla20;
wire mpc_ndauexc_x_raw;
wire edm_e;
wire [7:0] /*[7:0]*/ mpc_evecsel;
wire mpc_nmitaken;
wire mpc_dmsquash_m;
wire debug_rdvec;
wire causepla7;
wire jtag_exc_m;
wire mpc_sdbreak_m_raw_reg;
wire [1:0] /*[1:0]*/ clear_pend_m;
wire t_dtri;
wire qual_wp_m;
wire t_dbp;
wire t_nmi;
wire t_br;
wire mpuexc_i;
wire machine_check_w;
wire ej_dbreak_w;
wire t_dsp;
wire mpc_eexc_e;
wire [5:0] /*[5:0]*/ new_exc_type;
wire clear_pend_id;
wire set_pf_phase1_nosquash;
wire mpc_int_pref_phase1;
wire qual_ibe_i;
wire ej_ivabreak_i;
wire istage_exc_reg;
wire hold_exc_i;
wire [1:0] /*[1:0]*/ pclear_pend_e;
wire mpc_g_auexc_x;
wire t_cbrk;
wire [4:0] /*[4:0]*/ mpc_gexccode;
wire t_reset;
wire t_dbsa;
wire dsp_e;
wire error;
wire hold_hwintn_reg;
wire mpc_jamerror_w;
wire new_exc_m;
wire mpc_auexc_on;
wire mpc_cont_pf_phase1;
wire cov_gpsi;
wire [1:0] /*[1:0]*/ pclear_pend_m;
wire prev_int_w;
wire cov_grr;
wire t_sys;
wire seen_run_id;
wire t_dmod;
wire t_int;
wire int_pref_phase2_done;
wire lexc_e;
wire [2:0] /*[2:0]*/ exc_type_w;
wire causepla30;
wire mpc_ekillmd_w;
wire mpc_pendibe;
wire causepla26;
wire causepla6;
wire t_cp1;
wire eexc_i;
wire prev_int_m;
wire mpc_pf_phase2_done;
wire t_derr;
wire t_dmp;
wire mpc_int_pf_phase1_reg;
wire [1:0] /*[1:0]*/ pclear_pend_w;
wire mpc_run_id;
wire mpc_cp1exc;
wire cov_defer_watch;
wire mpc_imsquash_e;
wire cov_dt_refill;
wire mpc_hold_hwintn;
wire hw_i;
wire tlb_exc;
wire mpc_pexc_w;
wire auexc_on;
wire mpc_ebexc_w;
wire mpc_g_ldcause;
wire umipsfifo_null_d;
wire mpc_tlb_i_side;
wire t_dbsd_m_imprecise;
wire mpc_dis_int_e;
wire ldm_m;
wire hold_see_at_pro_done;
wire hold_mpuexc_i;
wire cov_it_refill;
wire sarop_m;
wire detect_int_reg;
wire cacheerr_vect;
wire held_parerrexc_i;
wire int_pref_phase2;
wire mpc_sbtake_w;
wire first_exc_w;
wire cov_fpe;
wire new_exc_i;
wire trap_type_m;
wire mpc_dparerr_for_eviction;
wire detect_int;
wire mpc_killmd_m;
wire cov_ri;
wire cov_ghfc;
wire t_it_pre;
wire [18:0] /*[18:0]*/ gpsi_code_x;
wire int_pref_phase1_val_start;
wire mpc_killcp2_w;
wire t_dae;
wire [2:0] /*[2:0]*/ dexc_type;
wire g_exc_w;
wire t_it;
wire cov_gpa;
wire t_ov;
wire poss_pend_exc;
wire mpc_first_det_int;
wire set_pf_auexc_nosquash;
wire pend_exc_reg;
wire mpc_squash_e;
wire mpc_g_jamtlb_w;
wire sb_dexc;
wire cov_it_inv;
wire hold_see_pf_phase1_nosquash_i;
wire hold_int_pref_phase1;
wire t_tr;
wire mpc_ld_causeap;
wire [4:0] /*[4:0]*/ pre_evec_sel_reg;
wire t_cp2;
wire t_dss;
wire pend_exc;
wire ssdi_m;
wire causepla11;
wire cov_cacheerr;
wire causepla13;
wire jtag_exc_w;
wire causepla17;
wire pend_dbe_reg;
wire err_w;
wire causepla19;
wire mpc_g_int_pf;
wire auexc_reg;
wire clear_pend_i;
wire trap_cond_m;
wire jtag_exc_i;
wire cov_shutdown;
wire ssdi_id;
wire mpc_sdbreak_m_raw;
wire edm_m;
wire eexc_m;
wire pexc_kill_w_org;
wire error_cache;
wire t_ri;
wire old_reset;
wire mpc_gpsi_perfcnt;
wire lexc_i;
wire hw_exc_m;
wire n_dexc;
wire set_pf_phase1_nosquash_reg;
wire mpc_ldcause;
wire cov_buserr;
wire causepla24;
wire causepla4;
wire mpc_sdbreak_m;
wire exc_wd;
wire mpc_ndauexc_x;
wire pf_phase1_nosquash_i;
wire ej_loadstorem_reg;
wire mpc_pexc_m;
wire mpc_tint;
wire mpc_pexc_w_org;
wire mpc_exc_type_w;
wire t_iw;
wire first_det_int;
wire t_dbe;
wire mpc_jamepc_w;
wire cov_hypcall;
wire mpc_jamtlb_w;
wire set_pf_auexc_nosquash_reg;
wire sb_dexc_w;
wire cov_dint;
wire hold_int_pref_phase2;
wire mpc_r_auexc_x;
wire iapiae_i;
wire new_exc_e;
wire [1:0] /*[1:0]*/ raw_debug_vect;
wire int_pref_phase1;
wire mpc_exc_w_org;
wire raw_pexc_e;
wire cov_reset;
wire t_dt;
wire ldm_i;
wire hold_first_det_int;
wire set_pend_exc_reg;
wire cov_gsfc;
wire mpc_mputriggeredres_i;
wire int_pref_phase1_val;
wire int_pref_phase1_done;
wire exc_i;
wire ovf_exc_m;
wire mpc_tlb_exc_type;
wire t_iae;
wire mpc_r_auexc_x_qual;
wire pending_pre_ss_exc_i;
wire t_ceu;
wire [1:0] /*[1:0]*/ clear_pend_e;
wire pending_ss_exc_i;
wire causepla23;
wire qual_int_m;
wire pf_phase1_nosquash_i_on;
wire mpc_killcp1_w;
wire [1:0] /*[1:0]*/ debug_vect;
wire jtag_exc_e;
wire ej_dexc_w;
wire tlb_refill_vec_n;
wire t_dbld;
wire int_pref_phase2_reg;
wire [4:0] /*[4:0]*/ mpc_exccode;
wire lexc_m;
wire qual_dparerr_w;
wire mpc_ibrk_qual;
wire qual_iparerr_i;
wire mpc_imsquash_i;
wire edm_i;
wire [6:0] /*[6:0]*/ gpa_code_x;
wire [4:0] /*[4:0]*/ pre_evec_sel;
wire mpc_expect_isa;
wire imsquash_i;
wire ej_cbreak_m;
wire t_dib;
wire mpc_ekillmd_m;
wire mpc_pexc_i;
wire pexc_kill_w;
wire new_exc_chain_id;
wire au_reset_reg;
wire mpc_g_ld_causeap;
wire new_exc_id;
wire ss_exc_i;
wire ssdi_i;
wire t_dbsd;
wire qual_dparerr_m;
wire t_ibe;
wire qual_iparerr_w;
wire int_pref_phase1_reg;
wire pre_ss_exc_i;
wire cov_dt_inv;
wire hold_see_imiss_off;
wire see_at_pro_done;
wire causepla2;
wire trap_in_e;
wire ldm_w;
wire ej_dvabreak_m;
wire causepla29;
wire causepla9;
wire mpc_exc_m;
wire qual_dbe_m;
wire pf_auexc_nosquash_i;
wire t_imp;
wire int_pref_phase2_end;
wire t_dint;
wire eexc_w;
wire exc_lock_cond;
wire set_pend_exc;
wire cov_int;
wire t_ierr;
// END Wire declarations made by MVP

	assign mpc_g_int_pf = 1'b0;
	assign mpc_g_jamepc_w = 1'b0;
	assign mpc_g_jamtlb_w = 1'b0;
	assign mpc_r_auexc_x = 1'b0;
	assign mpc_g_auexc_x = 1'b0;
	assign mpc_r_auexc_x_qual = 1'b0;
	assign mpc_g_auexc_x_qual = 1'b0;
	assign mpc_gexccode [4:0] = 5'b0;
	assign mpc_g_eexc_e = 1'b0;
	assign mpc_g_ldcause = 1'b0;
	assign mpc_g_ld_causeap = 1'b0;
	assign mpc_badins_type = 1'b0;
	assign mpc_tlb_i_side = 1'b0;
	assign mpc_tlb_d_side = 1'b0;
	assign mpc_ge_exc = 1'b0;
	assign g_exc_w = 1'b0;
	assign mpc_gpsi_perfcnt = 1'b0;
	
	//lock exception condition

	assign exc_lock_cond = biu_lock || dcc_exc_nokill_m; 

        // ss_exc_i:  Single Step Exception
	assign ss_exc_i = pre_ss_exc_i && !(mpc_squash_i && !continue_squash_i) && !mpc_pexc_i && !mpc_hw_ls_i;
	assign pending_ss_exc_i = pending_pre_ss_exc_i && !(mpc_squash_i && !continue_squash_i) && !mpc_pexc_i && !mpc_hw_ls_i;

	assign mpc_pf_phase2_done = int_pref_phase2_done;
	assign mpc_tint = qual_int_e | qual_int_m | qual_int_w;

	assign pre_ss_exc_i = cpz_sst & ( (mpc_updateepc_e | (~mpc_updateepc_e & icc_nobds_e)) & !mpc_fixupi & sst_instn_valid_e || ssexc_id) & 
			!(umipsfifo_null_d & ~mpc_iretret_m & ~mpc_eret_null_m);
	assign pending_pre_ss_exc_i = cpz_sst & ( (mpc_nomacroepc_e | (~mpc_nomacroepc_e & icc_nobds_e)) & !mpc_fixupi & sst_instn_valid_e || ssexc_id) & 
			!(umipsfifo_null_d & ~mpc_iretret_m & ~mpc_eret_null_m);
	mvp_cregister #(1) _umipsfifo_null_d(umipsfifo_null_d,greset | (!icc_imiss_i & (mpc_fixupi | mpc_run_ie)), gclk, 
					~greset & icc_umipsfifo_null_i & ~mpc_exc_e);

	mvp_register #(1) _ssexc_id(ssexc_id, gclk, pre_ss_exc_i & !greset);

	// Bus trap_e[5:0]: assemble trap vector from cpz_copusable RI BP & SyS traps
	assign trap_e [5:0] ={	mpc_irvalunpred_e & ce_un_e, 
			mpc_irval_e & sdbbp_e, 
			mpc_irval_e & break_e, 
			mpc_irval_e & syscall_e, 
			mpc_irvalunpred_e & ri_e, 
			mpc_irvalunpred_e & cp_un_e } | 
		      {4'b0, qual_umipsri_e, 1'b0};	

	// ovf_exc_m: Overflow exception
	assign ovf_exc_m = edp_povf_m & sarop_m;

	mvp_cregister #(1) _sarop_m(sarop_m,mpc_run_ie, gclk, sarop_e);

	assign trap_in_e = raw_trap_in_e && mpc_irval_e;

	mvp_cregister #(1) _trap_in_m(trap_in_m,mpc_run_ie, gclk, trap_in_e);

	// TrapType:  What trap condition are we looking for (0) zero, or (1) not zero
	mvp_cregister #(1) _trap_type_m(trap_type_m,mpc_run_ie, gclk, trap_type_e);

	// trap_cond_m: Trap condition is met
	assign trap_cond_m = trap_type_m ^ edp_trapeq_m;

	// trap_inst_exc_m: Trap Instn exception
	assign trap_inst_exc_m = trap_cond_m & trap_in_m;


	// Bus mpc_exccode[4:0]: cause PLA to encode exceptions into a 4 bit field
	assign mpc_exccode [4:0] =	(causepla1 ? 5'h1 : 5'h0) | (causepla2 ? 5'h2 : 5'h0)  | (causepla4 ? 5'h4 : 5'h0) |
		        (causepla6 ? 5'h6 : 5'h0) | (causepla7 ? 5'h7 : 5'h0)  | (causepla8 ? 5'h8 : 5'h0) |
		        (causepla9 ? 5'h9 : 5'h0) | (causepla10 ? 5'ha : 5'h0) | (causepla11 ? 5'hb : 5'h0) |
		       (causepla12 ? 5'hc : 5'h0) | (causepla13 ? 5'hd : 5'h0) | (causepla17 ? 5'h11 : 5'h0) |
			(causepla19 ? 5'h13 : 5'h0) | (causepla20 ? 5'h14 : 5'h0) |
			(causepla23 ? 5'h17 :5'h0) |(causepla24 ? 5'h18 :5'h0) | (t_cp2 ? cp2_exccode_w : 5'h0) | (t_cp1 ? cp1_exccode_w : 5'h0) |
			(causepla29 ? 5'h1d : 5'h0) |
			(causepla26 ? 5'h1a : 5'h0) | (causepla30 ? 5'h1e :5'h0);

	assign causepla1 =	(!mpc_load_m || mpc_atomic_m) && (t_dt || t_dmod || t_dae || t_dtri && ~mmu_iec);
	assign causepla19 =	mpc_load_m && t_dtri && mmu_iec;
	assign causepla20 =	t_itxi && mmu_iec;

	// causepla2: TLB Miss - load (plus TLB Miss - store), TLB Miss -inst
	assign causepla2 =	t_dt || t_it || t_dtri && ~mmu_iec || t_itxi && ~mmu_iec;

	// causepla4: Adr Err - load, inst, store
	assign causepla4 =	t_dae || t_iae;

	// causepla6: Bus error - inst
	assign causepla6 =	t_ibe;

	// causepla7: Bus error - data
	assign causepla7 =	t_dbe;	

	// causepla8: Syscall
	assign causepla8 =	t_sys;

	// causepla9: Break
	assign causepla9 =	t_br;

	// causepla10: Reserved Instruction
	assign causepla10 =	t_ri;

	// causepla11: Coprocessor Unusable
	assign causepla11 =	t_cu;

	// causepla12: Overflow- orthogonal to Trap/DTrExc
	assign causepla12 =	t_ov;

	// causepla13: Trap- orthogonal to Ovf/DTrExc
	assign causepla13 = 	t_tr;
	
	// causepla17: CorExtend Unusable
	assign causepla17 =	t_ceu;

	// causepla23: Watch exception
	assign causepla23 = t_iw || t_dw;
	
	assign causepla24 = t_mc;

	assign causepla26 = t_dsp;

	// causepla29: mpu exception
	assign causepla29 = t_imp || t_dmp || t_ebmp;

	// causepla30: parity error exception
	assign causepla30 = t_ierr || t_derr;

	// Track Errors through the pipeline
	assign eerr_w = greset || cpz_nmi_mw && qual_int_w;

	assign err_w = eerr_w;

        // Address Unit greset:
        mvp_register #(1) _au_reset_reg(au_reset_reg, gclk, t_reset || t_nmi);


	
	assign machine_check_w = mmu_tlbshutdown;	// mmu_tlbshutdown is the only cause of Machine Check

	assign eexc_w = machine_check_w || eerr_w || cp2_exc_w && !(mpc_pexc_w && !((exc_type_reg[5] || exc_type_reg[2]) && lscop2_w)) || 
		cp1_exc_w && !squash_w && !mpc_pexc_w;


	assign lexc_w =	ldm_w || qual_int_w || qual_dbe_w || qual_dparerr_w || qual_iparerr_w;


	// eexc_m: early exceptions detected in memory cycle
	assign eexc_m =	qual_int_m || qual_wp_m || 
		((ovf_exc_m || trap_inst_exc_m || cpz_dwatchhit) && !mpc_pexc_m) ||
	        qual_dbe_m || eexc_w  || edm_m;

	// lexc_m: late exceptions detected in memory cycle
 	assign lexc_m =	mmu_dtexc_m || mmu_dtriexc_m || ldm_m || lexc_w || (cdmm_mputriggered_m & ~mpc_exc_w);

	assign mpc_dmsquash_m = eexc_w || cpz_dwatchhit || ej_dvabreak_m || ej_dbreak_w || qual_dparerr_w ||
			 jtag_exc_m ||
			ej_cbreak_m || qual_dbe_m || mpc_pexc_m || mpc_sdbreak_m || cdmm_mputriggered_m;
	assign mpc_dmsquash_w = qual_dbe_m;


	assign imsquash_i = mpc_squash_i;

        assign mpc_imsquash_i = ((eexc_i || mpc_pexc_i) || imsquash_i) 
			&& !mpc_hold_int_pref_phase1_val || continue_squash_i;
	assign first_det_int = mpc_first_det_int & cpz_pf | hold_first_det_int;
	mvp_register #(1) _hold_first_det_int(hold_first_det_int, gclk, first_det_int & ~mpc_run_ie);
	assign int_pref_phase1_val_start = first_det_int & mpc_run_ie;
	mvp_register #(1) _mpc_hold_int_pref_phase1_val(mpc_hold_int_pref_phase1_val, gclk, int_pref_phase1_val);
	assign int_pref_phase1_val = int_pref_phase1_val_start | mpc_hold_int_pref_phase1_val 
			      & icc_imiss_i & ~(auexc_on & (~cpz_takeint | ~cpz_at_pro_start_val));
	

	assign mpc_imsquash_e = mpc_eexc_e || mpc_pexc_e && ~hold_pf_auexc_nosquash_i && ~hold_pf_phase1_nosquash_i;
	assign dsp_e = mpc_irvaldsp_e & dec_dsp_exc_e & ~cpz_mx;

        assign mpc_eexc_e =	((trap_e[5] || trap_e[3] || trap_e[2] || trap_e[1] || trap_e[0])) || eexc_m || edm_e || qual_int_e 
			|| dsp_e || (mpc_ebld_e && cdmm_mmulock);

	// lexc_e: late exceptions detected in ALU cycle
	assign lexc_e =	lexc_m | qual_ibe_e;


	assign lexc_i = 	mmu_itexc_i || mmu_itxiexc_i || lexc_e || ldm_i || qual_iparerr_i;
        assign eexc_i =	cpz_iwatchhit || mpc_eexc_e || edm_i || qual_ibe_i || cdmm_mputriggered_i;
	assign new_exc_i =	(eexc_i | lexc_i) & ~(iapiae_i & ~new_exc_e);
	// tracing
	mvp_register #(1) _hold_mpuexc_i(hold_mpuexc_i,gclk, mpuexc_i & ~mpc_run_i );
	assign mpuexc_i = cdmm_mputriggered_i & ~(iapiae_i & ~new_exc_e) | hold_mpuexc_i;


	assign new_exc_e =      mpc_eexc_e | lexc_e;
	assign new_exc_m =      eexc_m | lexc_m;
	assign new_exc_w =      eexc_w | lexc_w;

	
        assign exc_i = new_exc_i || hold_exc_i;
   

        mvp_register #(1) _hold_exc_i(hold_exc_i, gclk, (exc_i && !mpc_run_i) || hold_parerrexc_i && exc_type[3]);
// a parity exception detected at any stage of the iap/iae routine must be held until 
// the iap/iae routine completes and mpc_run_i=1
	assign iapiae_i = hw_save_epc_i || hw_save_status_i || mpc_hw_save_srsctl_i || 
		 hw_load_epc_i || hw_load_srsctl_i || mpc_hw_load_status_i;
	mvp_register #(1) _hold_parerrexc_i(hold_parerrexc_i,gclk, (qual_iparerr_i || hold_parerrexc_i) && iapiae_i && exc_type[3]);
	assign held_parerrexc_i = hold_parerrexc_i & exc_type[3];
	assign iapiae_e = mpc_hw_save_epc_e || mpc_hw_save_status_e || mpc_hw_save_srsctl_e ||
		mpc_hw_load_epc_e || mpc_hw_load_status_e || mpc_hw_load_srsctl_e;

// ******************** Debug Exception Pipe ********************
//
// Naming Convention:
//  E prefix means early, L prefix means Late

	// Late Debug Exception W stage
	assign ldm_w = ej_dbreak_w || jtag_exc_w; // Data Value Break or late dint

	//  DINT was not taken once bus is locked
        assign jtag_exc_w = 1'b0;
	assign jtag_exc_m = ejt_ejtagbrk && !(mpc_lsdc1_w || cp1_seen_nodmiss_m) && !cpz_dm_m 
		&& !(mpc_pexc_w || mpc_pexc_m && ssdi_m) && !mpc_squash_m && !exc_lock_cond 
		&& !(mpc_atpro_m || mpc_atepi_m || iapiae_e);
        assign jtag_exc_e = 1'b0;
	assign jtag_exc_i = ejt_ejtagbrk && !cpz_hotdm_i && !mpc_squash_i && !mpc_pexc_i && !mpc_fixupi && !mpc_hw_ls_i;

	// edm_m: early Dexc's detected in memory cycle
	assign edm_m =	jtag_exc_m;

	// ldm_m: late Dexc's detected in memory cycle
	assign ldm_m  =	ej_dvabreak_m | mpc_sdbreak_m |
		        ej_cbreak_m; 

	// edm_e: early Dexc's detected in ALU cycle
	assign edm_e  =	trap_e[4] || jtag_exc_e;   // SDBBP or DINT
   
	// edm_i: early Dexc's detected in fetch cycle
        assign edm_i  =	ss_exc_i || jtag_exc_i; // Single-Step Exception or DINT
	// ldm_i: late Dexc's detected in fetch cycle
	assign ldm_i  =     ej_ivabreak_i; // Instruction Address Match


// Prioritization Logic
/* Priority: (Hi to Lo)
 Reset -                           t_reset  error W
 Soft reset -                      t_reset  error W
 Debug Single Step -               t_dss    DM I
 Debug Interrupt -                 t_dint   DM I/M
 NMI -                             t_nmi    error M      ( or W if fixup)
 Machine Check-                    t_mc     Exception W
 Interrupt -                       t_int    Exception M  ( or W if fixup)
 Deferred Watch -                   - grouped with watch (L/S)
 Debug Instn Break -               t_dib    DM I
 Watch (ifetch) -                  t_iw     Exception I
 Address error (ifetch) -          t_iae    Exception I
 TLB refill (ifetch) -             t_it     Exception I (+1 - only after ITLB miss)
 TLB invalid (ifetch) -            t_it     Exception I (+1 - only after ITLB miss)
 TLB execution inhibit (ifetch) -  t_itxi   Exception I (+1 - only after ITLB miss)
 //Cache error (ifetch) -                   Not applicable
 Cache error (ifetch) -            t_ierr   Exception I/E
 Bus error (ifetch) -              t_ibe    Exception E
 Debug Break Point (SDBBP) -       t_dbp    DM E
 Instruction Validity Exc -        t_cu     Exception E
                                   t_ri     Exception E
                                   t_ceu    Exception E
                                   t_dsp    Exception E
                                   t_cp2    Exception W
                                   t_cp1    Exception W
 Execution exceptions (E)          t_sys    Exception E
                                   t_br     Exception E
 Complex Break			   t_cbrk   DM M
 Execution exceptions (M)          t_ov     Exception M
                                   t_tr     Exception M
 Debug Data BP (L/S addr) -        t_dbsa   DM M
 Watch (L/S) -                     t_dw     Exception M
 Addr error (L/S) -                t_dae    Exception M
 TLB Refill (L/S) -                t_dt     Exception M
 TLB invalid (L/S) -               t_dt     Exception M
 TLB read inhibit (L/S) -          t_dtri   Exception M
 TLB Modified (L/S) -              t_dmod   Exception M
 Debug Data BP Store(addr +data)-  t_dbsd   DM W(fixup)
 //Cache error (D) -                        Not applicable
 Cache error (D) -                 t_derr   Exception M/W
 Bus error (D) -                   t_dbe    Exception W
 Debug Data BP Load(addr +data)-   t_dbld   DM W
 */

// Hi-priority	
	assign t_reset = greset;
	assign t_dint = (jtag_exc_i && !mpc_exc_e && !ss_exc_i) ||
		 (jtag_exc_e && !mpc_exc_m) ||
		 (jtag_exc_m && !ej_cbreak_m && !mpc_exc_w) ||
		 (jtag_exc_w && !greset);
	assign t_nmi = (qual_int_w && cpz_nmi_mw && !greset && ~jtag_exc_w) || 
		(qual_int_m && cpz_nmi_mw && !mpc_exc_w && !jtag_exc_m && !ej_cbreak_m) || 
		(qual_int_e && cpz_nmi_e && !jtag_exc_e && !mpc_exc_m);    
	assign t_dss = ss_exc_i && !mpc_exc_e;
	assign t_int = (qual_int_w && !cpz_nmi_mw && !greset && !machine_check_w && ~jtag_exc_w) || 
		(qual_int_m && !mpc_exc_w && !cpz_nmi_mw && !jtag_exc_m && !ej_cbreak_m) || 
		(qual_int_e && !cpz_nmi_e && !jtag_exc_e && !mpc_exc_m);
// I-stage
	assign t_imp = 1'b0;
	assign t_dib = ej_ivabreak_i && !mpc_exc_e && !ss_exc_i && !jtag_exc_i && !cdmm_mputriggered_i;
	assign t_iw = cpz_iwatchhit && !ej_ivabreak_i && !mpc_exc_e && !ss_exc_i && !jtag_exc_i && !cdmm_mputriggered_i;
	assign t_iae = (mpc_excisamode_i || mmu_itexc_i && mmu_adrerr ) && 
		!cpz_iwatchhit && !ej_ivabreak_i && !mpc_exc_e && !ss_exc_i && !jtag_exc_i && !cdmm_mputriggered_i;

	assign mpc_ibrk_qual = t_dib;

	assign mpc_mputriggeredres_i = !mpc_exc_e && !pending_ss_exc_i && !jtag_exc_i;
	assign umips_qual = ((icc_umipsfifo_stat[3:0] == 4'b0 | icc_umipsfifo_stat[3:0] == 4'b0010) |
		     (icc_umipsfifo_stat[3:0] == 4'b0001 & icc_slip_n_nhalf)) & ~icc_macrobds_e;  /* && !(icc_nobds_e || mpc_nobds_e) */
	assign mpc_itqualcond_i = mpc_isamode_i ? 
			~(mmu_tlbinv || mmu_tlbrefill) | 
			((mmu_tlbinv || mmu_tlbrefill) & umips_qual)
			: 1'b1; 
	assign t_it_pre       = (mmu_tlbinv || mmu_tlbrefill) && !cpz_iwatchhit && !ej_ivabreak_i && !mpc_exc_e && !ss_exc_i && !jtag_exc_i && !cdmm_mputriggered_i;
	assign t_it = mmu_itexc_i & t_it_pre;
	assign t_itxi = mmu_itxiexc_i && !cpz_iwatchhit && !ej_ivabreak_i && !mpc_exc_e && !ss_exc_i && !jtag_exc_i && !cdmm_mputriggered_i; 

        assign t_ierr = qual_iparerr_i && !cdmm_mputriggered_i && !cpz_iwatchhit && !ej_ivabreak_i && !mpc_exc_e && !ss_exc_i
               && !jtag_exc_i && !mmu_itexc_i ||
               qual_iparerr_w && !cpz_nmi_mw && !greset && ~jtag_exc_w;

	assign t_ibe = qual_ibe_i && !mpc_exc_e && !cdmm_mputriggered_i && !ej_ivabreak_i && !cpz_iwatchhit &&
		!mmu_itexc_i && !ss_exc_i && !jtag_exc_i  & !qual_iparerr_i||
		qual_ibe_e && !mpc_exc_m && !qual_int_e;

// E-stage
	assign t_dbp = trap_e[4] && !debug_mode_e && !qual_int_e && !jtag_exc_e && !mpc_exc_m;
	assign t_sys = trap_e[2]  && !qual_int_e && !jtag_exc_e && !mpc_exc_m;
	assign t_br = (trap_e[3] || (trap_e[4] && debug_mode_e)) && !qual_int_e && !jtag_exc_e && !mpc_exc_m;
	assign t_ebmp = (mpc_ebld_e & cdmm_mmulock) & ~trap_e[0] & ~trap_e[1] & ~trap_e[5] & ~qual_int_e & ~jtag_exc_e & ~mpc_exc_m;
	assign t_cu = trap_e[0] && !qual_int_e && !jtag_exc_e && !mpc_exc_m;
	assign t_ri = trap_e[1] && !trap_e[5] && !trap_e[0] && !qual_int_e && !jtag_exc_e && !mpc_exc_m;
	assign t_ceu = trap_e[5] && !qual_int_e && !jtag_exc_e && !mpc_exc_m;
	assign t_dsp = dsp_e && !trap_e[1] && !trap_e[5] && !trap_e[0] && !qual_int_e && !jtag_exc_e && !mpc_exc_m;

// M-stage
	assign t_cbrk = ej_cbreak_m && !t_dbsd_m_imprecise && !mpc_exc_w;  
	
	assign t_ov = ovf_exc_m && !ej_cbreak_m && !qual_int_m && !jtag_exc_m && !qual_wp_m && !mpc_exc_w;
	assign t_tr = trap_inst_exc_m && !ej_cbreak_m && !qual_int_m && !jtag_exc_m && !qual_wp_m && !mpc_exc_w;
        
	// mpu load or store exception
	assign t_dmp = cdmm_mputriggered_m && !mpc_sdbreak_m && !ej_cbreak_m && !qual_int_m &&
		!jtag_exc_m && !mpc_exc_w && !qual_wp_m;
	// load OR store address break	
	assign t_dbsa = ej_dvabreak_m && !cdmm_mputriggered_m && !mpc_sdbreak_m && !ej_cbreak_m && !qual_int_m && 
		 !jtag_exc_m && !mpc_exc_w && !qual_wp_m;  
	assign t_dw = (cpz_dwatchhit && !ej_dvabreak_m  && !jtag_exc_m  && !cdmm_mputriggered_m || qual_wp_m) && 
		!ej_cbreak_m && !mpc_sdbreak_m && !qual_int_m && !mpc_exc_w;
	assign t_dae = mmu_dtexc_m & mmu_adrerr & ~cpz_dwatchhit & ~qual_wp_m & ~cdmm_mputriggered_m & 
		~ej_dvabreak_m & ~mpc_sdbreak_m & ~ej_cbreak_m & ~qual_int_m & ~jtag_exc_m & ~mpc_exc_w;
	assign t_dt = mmu_dtexc_m && (mmu_tlbrefill || mmu_tlbinv) && !cdmm_mputriggered_m && !cpz_dwatchhit 
		&& !qual_wp_m && !ej_dvabreak_m && !ej_cbreak_m && !mpc_sdbreak_m && !qual_int_m && 
		!jtag_exc_m && !mpc_exc_w;
	assign t_dtri = mmu_dtriexc_m && !cdmm_mputriggered_m && !cpz_dwatchhit && !qual_wp_m && !ej_dvabreak_m 
		&& !ej_cbreak_m && !mpc_sdbreak_m && !qual_int_m && !jtag_exc_m && !mpc_exc_w;
	assign t_dmod = mmu_dtexc_m && mmu_tlbmod && !cdmm_mputriggered_m && !cpz_dwatchhit && !qual_wp_m && 
		!ej_dvabreak_m && !ej_cbreak_m && !mpc_sdbreak_m && !qual_int_m && !jtag_exc_m && !mpc_exc_w;

	assign t_derr = qual_dparerr_w && !err_w && !qual_int_w && !jtag_exc_w;
	assign t_dbe = (qual_dbe_m && !mpc_exc_w && !mmu_dtexc_m && !cdmm_mputriggered_m && !cpz_dwatchhit && 
		!qual_wp_m && !ej_dvabreak_m && !ej_cbreak_m && !mpc_sdbreak_m && !qual_int_m && 
		!jtag_exc_m && !ovf_exc_m) ||
		qual_dbe_w && !err_w && !qual_int_w && !jtag_exc_w && !qual_dparerr_w;
	assign mpc_dparerr_for_eviction = t_derr;

// W-stage
	assign t_mc = machine_check_w && !err_w && !qual_int_w && !jtag_exc_w;
	assign t_cp1 = cp1_exc_w && !err_w && !qual_int_w && !prev_int_w && !jtag_exc_w;
	assign t_cp2 = cp2_exc_w && !err_w && !qual_int_w && !prev_int_w && !jtag_exc_w && !cp1_exc_w;
        assign t_dbsd =  (mpc_sdbreak_m & ~qual_int_m & ~mpc_exc_w)|| (mpc_sdbreak_w && !qual_dbe_w && !err_w &&
                  !qual_int_w && !cp2_exc_w && !cp1_exc_w && !jtag_exc_w);
	assign t_dbsd_m_imprecise = mpc_sdbreak_m & mpc_sdbreak_m_raw_reg & ~qual_int_m & ~mpc_exc_w & atomic_w_reg; 

	assign t_dbld =  ej_ldbreak_w && !qual_dbe_w && !err_w && !qual_int_w && !cp2_exc_w && !cp1_exc_w && !jtag_exc_w && !qual_dparerr_w;
	

// Assertion check: Verify that priority tree yields only 1 taken exception	


// Qualify Exception towards coprocessor if
	assign mpc_cp2exc = t_cp2;
	assign mpc_cp1exc = t_cp1 & ~mpc_pexc_w;

	assign error =  t_reset || t_nmi;
	assign error_cache =  t_ierr || t_derr;

	assign sb_dexc = t_dib || t_dbsa || t_dbsd || t_dbld || t_cbrk;
	assign n_dexc = t_dss || t_dint || t_dbp;


	assign tlb_exc = t_dt || t_dtri || t_dmod || t_dae || t_it || t_itxi || t_iae;

// Generate hot W-stage only versions to break false paths from early
// exceptions to exc_type_w
	assign error_w = t_reset;
	assign error_w_cache = t_ierr && qual_iparerr_w || t_derr && qual_dparerr_w;
	assign sb_dexc_w = t_dbsd || t_dbld;
	
	assign dexc_type [2:0] = (t_dss ? 3'h1 : 3'h0) |
			 (t_dbp ? 3'h2 :  3'h0) |
			 (t_dint ? 3'h3 : 3'h0) |
			 (((t_dbsa & mpc_load_m & !mpc_atomic_m) | t_dbld | t_cbrk) ? 3'h4 : 3'h0) |
			 (((t_dbsa & (~mpc_load_m | mpc_atomic_m)) | t_dbsd) ? 3'h5 : 3'h0) |
			 (t_dib ? 3'h6 : 3'h0) | 
			 (t_cbrk ? 3'h7 : 3'h0);
	

	assign new_exc_type [5:0] = {
		t_dw, 
		t_imp|t_dmp, 
		error_cache, 
		tlb_exc, 
		sb_dexc || n_dexc, 
		error || n_dexc};
	assign exc_type [5:0] = new_exc_i ? new_exc_type : exc_type_reg;
	assign mpc_tlb_exc_type = exc_type[2];
	mvp_register #(6) _exc_type_reg_5_0_(exc_type_reg[5:0], gclk, exc_type & {6{~qual_auexc_x}});
	assign exc_type_w [2:0] = new_exc_w ? {error_w_cache, sb_dexc_w, error_w} : {exc_type_reg[3], exc_type_reg[1:0]};
	assign mpc_exc_type_w = exc_type_w[1];
	
	// EJTAG exceptions
	assign ej_ivabreak_i = ejt_ivabrk && !cpz_hotdm_i;

	assign ej_dvabreak_m = ejt_dvabrk && !cpz_dm_m;

	mvp_register #(1) _atomic_w_reg(atomic_w_reg, gclk, mpc_atomic_w);
	assign mpc_sdbreak_m_raw = ejt_dbrk_m && !cpz_dm_m && !dcc_ldst_m;
	mvp_cregister #(1) _mpc_sdbreak_m_raw_reg(mpc_sdbreak_m_raw_reg,mpc_run_m, gclk, mpc_sdbreak_m_raw);
	assign mpc_sdbreak_m = (mpc_atomic_w || atomic_w_reg && mpc_sdbreak_m_raw_reg) ? mpc_sdbreak_m_raw_reg :  mpc_sdbreak_m_raw; 
	assign mpc_atomic_impr = atomic_w_reg & mpc_sdbreak_m_raw_reg; 


	assign ej_cbreak_m = ejt_cbrk_m && !cpz_dm_m && !mpc_pexc_w & !mpc_squash_m || t_dbsd_m_imprecise;
	
	mvp_cregister #(1) _ej_loadstorem_reg(ej_loadstorem_reg,mpc_run_m, gclk, dcc_ldst_m);

	assign ej_ldbreak_w = ejt_dbrk_w && mpc_sbstrobe_w && ej_loadstorem_reg && !cpz_dm_w && !mpc_pexc_w;

	assign mpc_sdbreak_w = ejt_dbrk_w && !ej_loadstorem_reg && !cpz_dm_w && !mpc_pexc_w ||
		ejt_dbrk_w && scop2_w && !ej_loadstorem_reg && !cpz_dm_w && !(mpc_pexc_w && !exc_type_reg[2])
		;
	
	assign ej_dbreak_w = ej_ldbreak_w | mpc_sdbreak_w;


	assign qual_int_e = cpz_int_e && !(mpc_pexc_m || mpc_pexc_e && ssdi_e) && !squash_e && !mpc_atomic_m && !mpc_lsdc1_m;
	assign mpc_dis_int_e = mpc_pexc_m || mpc_pexc_e && ssdi_e || dcc_parerr_w;

	assign qual_int_m = dcc_intkill_m || (cpz_int_mw && mdu_stall);


	assign qual_int_w = dcc_intkill_w;

	assign qual_wp_m = cpz_wpexc_m && !(mpc_pexc_w || mpc_pexc_m && ssdi_m) && !mpc_squash_m;

	mvp_register #(1) _prev_int_m(prev_int_m, gclk, (mpc_run_ie && qual_int_e) || 
			      ((prev_int_m || qual_int_m || jtag_exc_m) 
			       && !mpc_exc_w && !mpc_run_m));
	
	mvp_register #(1) _prev_int_w(prev_int_w, gclk, ((prev_int_m || qual_int_m || jtag_exc_m) 
				    && !mpc_exc_w && mpc_run_m) ||
			      (prev_int_w && !mpc_run_w));

	assign mpc_penddbe = biu_dbe_exc || biu_wbe || cpz_setdbep || pend_dbe_reg;
	mvp_register #(1) _pend_dbe_reg(pend_dbe_reg, gclk, mpc_penddbe && !((clear_pend_w == 2'h2) && mpc_exc_w) && !greset);

	assign qual_dbe_m = (mpc_penddbe && !mpc_squash_m && !mpc_pexc_m && !cpz_iexi && !exc_lock_cond);
	
	assign qual_dbe_w = (dcc_precisedbe_w || dcc_dbe_killfixup_w) && !mpc_pexc_w && !squash_w ;

	assign mpc_pendibe = (biu_ibe_exc & ~mpc_isamode_i) || cpz_setibep || pend_ibe_reg;
	mvp_register #(1) _pend_ibe_reg(pend_ibe_reg, gclk, mpc_pendibe && !((clear_pend_w == 2'h1) && mpc_exc_w) && !greset);
	assign qual_ibe_i = (mpc_pendibe && !cpz_hotiexi || icc_preciseibe_i ) && !mpc_squash_i && !mpc_pexc_i;
	
	assign qual_ibe_e = icc_preciseibe_e && !squash_e && !mpc_pexc_e;

	assign clear_pend_i = new_exc_i ? t_ibe : clear_pend_id;
	mvp_register #(1) _clear_pend_id(clear_pend_id, gclk, clear_pend_i);
	mvp_register #(2) _pclear_pend_e_1_0_(pclear_pend_e[1:0], gclk, mpc_run_i ? {1'b0, clear_pend_i} : clear_pend_e);
	assign clear_pend_e [1:0] = new_exc_e ? {t_nmi, t_nmi || t_ibe} : pclear_pend_e;
	mvp_register #(2) _pclear_pend_m_1_0_(pclear_pend_m[1:0], gclk, mpc_run_ie ? clear_pend_e : clear_pend_m);
	assign clear_pend_m [1:0] = new_exc_m ? {t_dbe || t_nmi, t_nmi} : pclear_pend_m;
	mvp_register #(2) _pclear_pend_w_1_0_(pclear_pend_w[1:0], gclk, mpc_run_m ? clear_pend_m : clear_pend_w);
	assign clear_pend_w [1:0] = new_exc_w ? {t_dbe || t_nmi, t_nmi} : pclear_pend_w;
	assign mpc_nmitaken = (clear_pend_w == 2'h3) && mpc_exc_w;
	
	assign ssdi_i = new_exc_i ? (t_dss || t_dint) : ssdi_id;
	mvp_register #(1) _ssdi_id(ssdi_id, gclk, ssdi_i && !mpc_run_i);
	mvp_cregister #(1) _ssdi_e(ssdi_e,mpc_run_i, gclk, ssdi_i);
	mvp_cregister #(1) _ssdi_m(ssdi_m,mpc_run_m, gclk, ssdi_e);
	

	
	assign mpc_exc_e =	lexc_e | mpc_eexc_e | mpc_pexc_e;

	assign mpc_exc_m =	lexc_m | eexc_m | mpc_pexc_m;

	assign pexc_kill_w = cp2_missexc_w | cp1_missexc_w ? exc_wd : mpc_pexc_w;
	assign pexc_kill_w_org = cp2_missexc_w | cp1_missexc_w ? exc_wd : mpc_pexc_w_org;
	assign mpc_exc_w =	lexc_w | eexc_w | pexc_kill_w;
	assign mpc_exc_w_org =	lexc_w | eexc_w | pexc_kill_w_org;

	assign ej_dexc_w = mpc_exc_w && !pexc_x && (exc_type_w[1]);
	assign mpc_sbtake_w = ej_dexc_w && !exc_type_w[0];

	// mpu exception is higher than precise breaks, but lower than reset
	assign mpc_mputake_w = mpc_exc_w & ~pexc_x & !exc_type_w[0];

	mvp_register #(1) _istage_exc_reg(istage_exc_reg, gclk, (new_exc_i || (istage_exc_reg && !mpc_run_id)) && !new_exc_e);

	mvp_register #(1) _new_exc_id(new_exc_id, gclk, new_exc_i);

	mvp_register #(1) _new_exc_chain_id(new_exc_chain_id, gclk, new_exc_i | mpc_chain_strobe);

	// Exception vector selection
	mvp_register #(1) _int_vect(int_vect, gclk, new_exc_i && t_int && cpz_iv || mpc_chain_strobe);

	mvp_register #(1) _tlb_refill_vec_n(tlb_refill_vec_n, gclk, !((t_it && !cpz_hotexl || t_dt && (!cpz_exl || mpc_atpro_m || mpc_atepi_m)) && mmu_tlbrefill) 
					  && !(t_ierr || t_derr));
	
	mvp_cregister #(2) _raw_debug_vect_1_0_(raw_debug_vect[1:0],(first_exc_w || greset), gclk, {mpc_jamdepc_w, ej_probtrap});
	assign debug_vect [1:0] = raw_debug_vect & {2{~(int_pref_phase1 | mpc_chain_vec)}};

	mvp_cregister #(1) _debug_rdvec(debug_rdvec,(first_exc_w || greset), gclk, ej_rdvec);
	

	mvp_register #(1) _cacheerr_vect(cacheerr_vect, gclk, (t_ierr || t_derr));
	assign mpc_evecsel [7:0] = {debug_rdvec, debug_vect, pre_evec_sel};
	assign pre_evec_sel [4:0] = new_exc_chain_id ? {au_reset_reg, cpz_bev, tlb_refill_vec_n, cacheerr_vect, int_vect} :
		      pre_evec_sel_reg;

	mvp_ucregister_wide #(5) _pre_evec_sel_reg_4_0_(pre_evec_sel_reg[4:0],gscanenable, new_exc_chain_id, gclk, pre_evec_sel);

	
	// Early Kill signal for MDU
	assign mpc_ekillmd_m = mpc_pexc_m | eexc_m;
	assign mpc_ekillmd_w = mpc_pexc_w | eexc_w;

	// Final Kill signal for MDU 
	assign mpc_killmd_m = mpc_exc_m;

	assign mpc_killcp1_w = mpc_exc_w;
	assign mpc_killcp2_w = mpc_exc_w & ~(scop2_w & exc_type_reg[2] & ~cp2_exc_w);
   
	// mpc_ldcause: load cause shadow register with exception code
	assign mpc_ldcause =	new_exc_i;

	// Detect rising edge of reset
	mvp_register #(1) _old_reset(old_reset, gclk, greset);
	assign reset_edge = greset & ~old_reset;

	assign first_exc_w = mpc_run_w && mpc_exc_w && !pexc_x;
	
	// mpc_jamepc_w: load EPC register from EPC timing chain
	assign mpc_jamepc_w =	first_exc_w && (exc_type_w[2:0] == 3'b0) && !cpz_dm_w;

	assign mpc_jamerror_w = (first_exc_w || reset_edge) && (exc_type_w[2] && !cpz_dm_w || (exc_type_w[1:0] == 2'b1));

	assign mpc_jamdepc_w = first_exc_w && ((exc_type_w[1]) || (exc_type_w[1:0] == 2'b0) && cpz_dm_w);

	assign mpc_ebexc_w = mpc_jamepc_w & ~cpz_dm_w & ~exc_type_w[0];

	assign mpc_jamtlb_w = first_exc_w && !new_exc_w && exc_type_reg[2] && !cpz_dm_w; 

	mvp_register #(1) _mpc_auexc_x(mpc_auexc_x, gclk, (first_exc_w || greset) || 
				(mpc_auexc_x && !((mpc_run_id || seen_run_id) && mpc_run_i)));
	mvp_register #(1) _mpc_ndauexc_x_raw(mpc_ndauexc_x_raw, gclk, ( (first_exc_w && (~exc_type_w[1] && ~cpz_dm_w)) || greset) || 
				(mpc_auexc_x && !((mpc_run_id || seen_run_id) && mpc_run_i)));
	assign mpc_ndauexc_x = mpc_ndauexc_x_raw && ((mpc_run_id || seen_run_id) && mpc_run_i);

	assign qual_auexc_x = mpc_auexc_x && ((mpc_run_id || seen_run_id) && mpc_run_i);


	mvp_register #(1) _seen_run_id(seen_run_id, gclk, mpc_auexc_x && (mpc_run_id || seen_run_id) && !mpc_run_i);
	
	mvp_register #(1) _mpc_run_id(mpc_run_id, gclk, mpc_run_i);

	assign pend_exc = (mpc_run_id && ((poss_pend_exc && !mpc_annulds_e) || set_pend_exc)) || pend_exc_reg;
	mvp_register #(1) _pend_exc_reg(pend_exc_reg, gclk, pend_exc && !qual_auexc_x);

	assign poss_pend_exc = ((new_exc_id && istage_exc_reg) || poss_pend_exc_reg);
	mvp_register #(1) _poss_pend_exc_reg(poss_pend_exc_reg, gclk, poss_pend_exc && !mpc_run_id);

	assign set_pend_exc = ((new_exc_id && !istage_exc_reg) || set_pend_exc_reg);
	mvp_register #(1) _set_pend_exc_reg(set_pend_exc_reg, gclk, set_pend_exc && !mpc_run_id && !qual_auexc_x);

	mvp_register #(1) _mpc_pexc_i(mpc_pexc_i, gclk, exc_i && !mpc_run_i);
	
	// mpc_pexc_e: Previous exception in E-stage
	mvp_register #(1) _raw_pexc_e(raw_pexc_e, gclk, mpc_run_i ? exc_i & ~hw_i & ~(hold_parerrexc_i & iapiae_i & exc_type[3]) : mpc_exc_e);

	assign mpc_pexc_e = raw_pexc_e && !(mpc_annulds_e && istage_exc_reg);

	// mpc_pexc_m: Previous exception in M-stage
	mvp_register #(1) _mpc_pexc_m(mpc_pexc_m, gclk, mpc_run_ie ? mpc_exc_e & ~hw_i : mpc_exc_m);	
	assign hw_i = hw_save_epc_i | mpc_hw_load_status_i;

	mvp_register #(1) _mpc_pexc_w_org(mpc_pexc_w_org, gclk, mpc_run_m ? mpc_exc_m : (mpc_exc_w_org || mpc_pexc_w_org));
	mvp_register #(1) _mpc_pexc_w(mpc_pexc_w, gclk, mpc_run_m ? mpc_exc_m && ~(mpc_run_ie && hw_i) : (mpc_exc_w || mpc_pexc_w));

	mvp_register #(1) _exc_wd(exc_wd, gclk, mpc_exc_w);

	// pexc_x: Prior exception in W-stage
	mvp_cregister #(1) _pexc_x(pexc_x,mpc_run_w, gclk, mpc_exc_w);	

	// mpc_hold_hwintn: Hold hwint pins until exception taken
	assign mpc_hold_hwintn = ~int_vect & hold_hwintn_reg;
        mvp_register #(1) _hold_hwintn_reg(hold_hwintn_reg, gclk, mpc_hold_hwintn | qual_auexc_x & ~mpc_int_pref | 
				   int_pref_phase2_done & ~mpc_auexc_x | chain_vec_end);

        assign qual_iparerr_i = icc_parerr_i && !mpc_squash_i && !mpc_pexc_i;
        assign qual_iparerr_w = icc_parerr_w && !squash_w && !mpc_pexc_w;
        assign qual_dparerr_m = dcc_parerr_m && !mpc_squash_m && !mpc_pexc_m;
        assign qual_dparerr_w = dcc_parerr_w && !squash_w && !mpc_pexc_w;

	// interrupt detected
        mvp_register #(1) _detect_int_reg(detect_int_reg, gclk, detect_int);
        assign detect_int = cpz_ext_int;
	assign mpc_squash_e = squash_e;
        assign mpc_first_det_int = detect_int & ~detect_int_reg;

	// core is expected to be in isa mode
	assign mpc_expect_isa = (!cpz_bev & cpz_excisamode) | (cpz_bev & cpz_bootisamode);

	// interrupt prefetch is divided into two phases: 
	// 1) interrupt detected to exception prioritized;
	// 2) exception prioritized to iap(if iap is enabled);
	assign mpc_int_pref_phase1 = int_pref_phase1;
        assign mpc_int_pref = int_pref_phase1 | int_pref_phase2;
	mvp_register #(1) _mpc_int_pf_phase1_reg(mpc_int_pf_phase1_reg, gclk, int_pref_phase1);
        assign int_pref_phase1 = ~greset & (mpc_first_det_int & cpz_pf | hold_int_pref_phase1);
        mvp_cregister #(1) _hold_int_pref_phase1(hold_int_pref_phase1,greset | mpc_first_det_int & cpz_pf | first_exc_w |
				      hold_pf_phase1_nosquash_i & ~icc_imiss_i, 
					gclk, first_exc_w ? 1'b0 : 
				      hold_pf_phase1_nosquash_i & ~icc_imiss_i ?  1'b0 : 
					int_pref_phase1);
	mvp_register #(1) _int_pref_phase1_reg(int_pref_phase1_reg, gclk, int_pref_phase1);
	assign int_pref_phase1_done = ~int_pref_phase1 & int_pref_phase1_reg;
	mvp_cregister #(1) _cont_pf_phase1(cont_pf_phase1,greset | int_pref_phase1_done | auexc_on, gclk, ~auexc_on & ~greset);
	assign mpc_cont_pf_phase1 = (cont_pf_phase1 | int_pref_phase1_done) & ~auexc_on;
        assign int_pref_phase2 = ~greset & (cpz_at_pro_start_val | hold_int_pref_phase2) & 
			  ~((at_pro_done_i | hold_see_at_pro_done) & hold_see_imiss_off);
        mvp_cregister #(1) _hold_int_pref_phase2(hold_int_pref_phase2,greset | cpz_at_pro_start_val | int_pref_phase2_end | 
				      at_pro_done_i & hold_see_imiss_off, gclk, cpz_at_pro_start_val);
	assign see_imiss_off = mpc_int_pref & ~icc_imiss_i | hold_see_imiss_off;
	mvp_register #(1) _hold_see_imiss_off(hold_see_imiss_off, gclk, see_imiss_off & (mpc_int_pref | cont_pf_phase1 | 
				      int_pref_phase1_done | ~mpc_run_ie));
	assign int_pref_phase2_end = see_at_pro_done & mpc_run_ie;
	assign see_at_pro_done = at_pro_done_i & ~hold_see_imiss_off | hold_see_at_pro_done;
	mvp_register #(1) _hold_see_at_pro_done(hold_see_at_pro_done, gclk, see_at_pro_done & ~mpc_run_ie);

	mvp_register #(1) _int_pref_phase2_reg(int_pref_phase2_reg, gclk, int_pref_phase2);
	assign int_pref_phase2_done = ~int_pref_phase2 & int_pref_phase2_reg;

        assign set_pf_phase1_nosquash = mpc_first_det_int & cpz_pf | set_pf_phase1_nosquash_reg;
        mvp_register #(1) _set_pf_phase1_nosquash_reg(set_pf_phase1_nosquash_reg, gclk, set_pf_phase1_nosquash & ~(~icc_imiss_i & (mpc_fixupi | mpc_run_ie)) 
				    & ~(auexc_on & (~cpz_takeint | ~cpz_at_pro_start_val)) & ~pf_phase1_nosquash_i_off
				    & ~greset);
        assign pf_phase1_nosquash_i =  ~icc_imiss_i & (mpc_fixupi | mpc_run_ie) & set_pf_phase1_nosquash & ~mpc_auexc_x | 
				hold_pf_phase1_nosquash_i & icc_imiss_i & ~(auexc_on & (~cpz_takeint | ~cpz_at_pro_start_val));
        mvp_register #(1) _hold_pf_phase1_nosquash_i(hold_pf_phase1_nosquash_i, gclk, pf_phase1_nosquash_i);
	assign auexc_on = mpc_auexc_x & ~auexc_reg;
	assign mpc_auexc_on = auexc_on;
	assign auexc_done = ~mpc_auexc_x & auexc_reg;
	mvp_register #(1) _auexc_reg(auexc_reg, gclk, mpc_auexc_x);
	assign pf_phase1_nosquash_i_on = pf_phase1_nosquash_i & ~hold_pf_phase1_nosquash_i;
	assign pf_phase1_nosquash_i_off = ~pf_phase1_nosquash_i & hold_pf_phase1_nosquash_i;
	mvp_cregister #(1) _hold_see_pf_phase1_nosquash_i(hold_see_pf_phase1_nosquash_i,pf_phase1_nosquash_i_on | auexc_done & ~int_pref_phase2 | 
					int_pref_phase2_done, gclk, pf_phase1_nosquash_i_on);
	
        assign set_pf_auexc_nosquash = auexc_on & cpz_takeint & cpz_at_pro_start_val & cpz_pf & ~hold_see_pf_phase1_nosquash_i 
				| set_pf_auexc_nosquash_reg;
	mvp_register #(1) _set_pf_auexc_nosquash_reg(set_pf_auexc_nosquash_reg, gclk, set_pf_auexc_nosquash & ~(~icc_imiss_i & (mpc_fixupi | 
				mpc_run_ie)) & mpc_auexc_x);
	assign pf_auexc_nosquash_i = ~icc_imiss_i & (mpc_fixupi | mpc_run_ie) & set_pf_auexc_nosquash | 
				hold_pf_auexc_nosquash_i & icc_imiss_i;
	mvp_register #(1) _hold_pf_auexc_nosquash_i(hold_pf_auexc_nosquash_i, gclk, pf_auexc_nosquash_i);

	// possible exceptions taken during iap/iae
        assign hw_exc_m = mmu_dtexc_m & (mmu_adrerr | mmu_tlbrefill | mmu_tlbinv | mmu_tlbmod) | mmu_itxiexc_i | mmu_dtriexc_m 
		| qual_dbe_m | qual_dbe_w | qual_dparerr_w | qual_dparerr_m | cpz_dwatchhit | qual_wp_m | ej_dvabreak_m 
		| mpc_sdbreak_m | mpc_sdbreak_w | ej_ldbreak_w | ej_cbreak_m |
		cdmm_mputriggered_m;
	assign hw_exc_w = qual_dbe_m | qual_dbe_w | qual_dparerr_w | mpc_sdbreak_w | ej_ldbreak_w | ej_cbreak_m;
        assign mpc_ld_causeap = hw_exc_m & mpc_atpro_m | hw_exc_w & mpc_atpro_w;

        assign mpc_qual_auexc_x = qual_auexc_x;


// 
 `ifdef MIPS_SIMULATION 
 //VCS coverage off 
//

	wire		qual_g_int_e;
	wire		qual_g_int_m;
	wire		qual_g_int_w;

 //VCS coverage on  
 `endif 
//
//

  

assign cov_gpsi = 1'b0;
assign cov_ghfc = 1'b0;
assign cov_gsfc = 1'b0;
assign cov_grr = 1'b0;
assign cov_hypcall = 1'b0;
assign cov_gpa = 1'b0;
assign cov_it_inv = 1'b0;
assign cov_dt_inv = 1'b0;
assign cov_it_mod = 1'b0;
assign cov_dt_mod = 1'b0;
assign cov_it_refill = 1'b0;
assign cov_dt_refill = 1'b0;
assign cov_shutdown = 1'b0;
assign cov_reset = 1'b0;
assign cov_dint = 1'b0;
assign cov_nmi = 1'b0;
assign cov_int = 1'b0;
assign cov_buserr = 1'b0;
assign cov_cacheerr = 1'b0;
assign cov_cpun = 1'b0;
assign cov_ri = 1'b0;
assign cov_fpe = 1'b0;
assign cov_defer_watch = 1'b0;
assign cov_ss = 1'b0;
assign cov_addrerr = 1'b0;
assign gpa_code_x[6:0] = 7'b0;
assign gpsi_code_x[18:0] = 19'b0; 

endmodule // exc

