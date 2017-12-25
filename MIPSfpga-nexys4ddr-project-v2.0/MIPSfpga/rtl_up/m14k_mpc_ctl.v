// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_mpc_ctl 
//            Master Pipeline Control Control
//
//    $Id: \$
//    mips_repository_id: m14k_mpc_ctl.mv, v 1.171 
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

//verilint 528 off        // Variable set but not used
module m14k_mpc_ctl(
	raw_ll_e,
	new_sc_e,
	dest_e,
	src_a_e,
	src_b_e,
	mmu_tlbbusy,
	mpc_ldst_e,
	cp0_e,
	use_src_a_e,
	use_src_b_e,
	muldiv_e,
	cp2_movefrom_m,
	cp2_moveto_m,
	cp1_movefrom_m,
	cp1_moveto_m,
	mdu_busy,
	mdu_stall,
	mfhilo_e,
	p_cp0_mv_e,
	p_cp0_sc_e,
	p_cp0_diei_e,
	bds_e,
	icc_macro_e,
	icc_umipsri_e,
	icc_preciseibe_e,
	icc_poten_be,
	icc_parerrint_i,
	mmu_tlbinv,
	mmu_tlbrefill,
	mmu_r_tlbrefill,
	mmu_r_tlbinv,
	mpc_macro_jr,
	edp_dva_1_0_e,
	edp_stalign_byteoffset_e,
	mpc_cmov_e,
	cmov_type_e,
	edp_cndeq_e,
	vd_e,
	xfc2_e,
	xfc1_e,
	load_e,
	lsdc1_e,
	lsdxc1_e,
	lsuxc1_e,
	cp0_r_e,
	cp0_sr_e,
	p_eret_e,
	p_deret_e,
	p_wait_e,
	br_likely_e,
	mpc_br16_e,
	mpc_br32_e,
	icc_nobds_e,
	mpc_nobds_e,
	mpc_jalx_e,
	rf_init_done,
	dcc_dmiss_m,
	dcc_spram_write,
	dcc_fixup_w,
	dcc_stall_m,
	dcc_ev,
	icc_imiss_i,
	icc_stall_i,
	cp2_fixup_w,
	cp1_fixup_w,
	cp1_fixup_i,
	mmu_dtmack_m,
	cp2_stall_e,
	cp1_stall_e,
	edp_udi_stall_m,
	cp2_bstall_e,
	cp1_bstall_e,
	greset,
	mpc_exc_e,
	coptype_e,
	mpc_exc_m,
	pend_exc,
	icc_umipspresent,
	icc_pcrel_e,
	sh_var_e,
	sh_fix_e,
	sh_fix_amt_e,
	udi_sel_e,
	alu_sel_e,
	mpc_addui_e,
	mpc_bussize_e,
	pbus_type_e,
	unal_type_e,
	mpc_unal_ref_e,
	signed_ld_e,
	cpz_rbigend_e,
	edp_abus_e,
	cpz_eretisa,
	br_eq,
	br_le,
	br_ne,
	cmp_br,
	br_gr,
	br_lt,
	br_ge,
	mpc_auexc_x,
	mpc_jreg_e,
	jreg_hb_e,
	mpc_jimm_e,
	sel_logic_e,
	slt_sel_e,
	mpc_lnksel_e,
	signed_e,
	cp2_bvalid,
	cp1_bvalid,
	cpz_dm_w,
	cp2_btaken,
	cp1_btaken,
	mpc_pexc_m,
	mpc_pexc_w,
	mpc_exc_w,
	cp2_fixup_m,
	cp1_fixup_m,
	mmu_itmack_i,
	mpc_pexc_e,
	mpc_ekillmd_m,
	mpc_ekillmd_w,
	mpc_eexc_e,
	ejt_stall_st_e,
	ejt_pdt_stall_w,
	cpz_excisamode,
	cpz_bootisamode,
	cpz_debugmode_i,
	icc_macro_jr,
	icc_umips_16bit_needed,
	icc_umipsfifo_stat,
	icc_umips_active,
	icc_umipsfifo_imip,
	icc_umipsfifo_ieip2,
	icc_umipsfifo_ieip4,
	mpc_umipspresent,
	mpc_macro_e,
	mpc_pcrel_e,
	cpz_srsctl_css,
	cpz_srsctl_pss,
	gscanenable,
	gclk,
	mpc_cont_pf_phase1,
	mpc_int_pref,
	int_pref_phase2,
	cpz_at_pro_start_i,
	cpz_at_epi_en,
	cpz_mx,
	rf_bdt_e,
	rf_adt_e,
	cpz_int_pend_ed,
	cpz_stkdec,
	dcc_ddata_m,
	p_iret_e,
	cpz_iret_m,
	cpz_ice,
	pf_phase1_nosquash_i,
	hw_exc_m,
	hw_exc_w,
	cpz_erl,
	cpz_bev,
	cpz_usekstk,
	cpz_causeap,
	cpz_int_enable,
	ejt_dcrinte,
	mpc_sel_hw_e,
	cpz_iret_chain_reg,
	mpc_pf_phase2_done,
	mpc_int_pref_phase1,
	hold_pf_phase1_nosquash_i,
	set_pf_auexc_nosquash,
	set_pf_phase1_nosquash,
	cpz_pf,
	cpz_at_pro_start_val,
	mpc_qual_auexc_x,
	cpz_iap_um,
	cpz_int_excl_ie_e,
	mpc_tlb_exc_type,
	dspver_e,
	dec_cp1_e,
	cp1_copidle,
	gfclk,
	cpz_rslip_e,
	mpc_atomic_e,
	mpc_atomic_clrorset_e,
	mpc_atomic_bit_dest_e,
	mpc_cleard_strobe,
	sst_instn_valid_e,
	mpc_alusel_m,
	mpc_udislt_sel_m,
	mpc_udisel_m,
	mpc_lnksel_m,
	mpc_aselres_e,
	mpc_aselwr_e,
	mpc_bselres_e,
	mpc_bselall_e,
	mpc_apcsel_e,
	mpc_shamt_e,
	mpc_disable_gclk_xx,
	mpc_selcp_m,
	mpc_selcp2to_m,
	mpc_selcp2from_m,
	mpc_selcp2from_w,
	mpc_selcp1from_w,
	mpc_selcp1to_m,
	mpc_selcp1from_m,
	mpc_selcp0_m,
	mpc_updateldcp_m,
	mpc_dcba_w,
	mpc_signa_w,
	mpc_signb_w,
	mpc_signc_w,
	mpc_signd_w,
	mpc_lda31_24sel_w,
	mpc_lda23_16sel_w,
	mpc_lda15_8sel_w,
	mpc_lda7_0sel_w,
	mpc_cdsign_w,
	mpc_bsign_w,
	mpc_signed_m,
	mpc_defivasel_e,
	mpc_sequential_e,
	mpc_umips_defivasel_e,
	mpc_umips_mirrordefivasel_e,
	mpc_sellogic_m,
	mpc_eqcond_e,
	mpc_lsbe_m,
	ej_rdvec_read,
	ej_rdvec,
	ej_isaondebug_read,
	ej_probtrap,
	icc_umipsfifo_null_i,
	icc_umipsfifo_null_w,
	mpc_nonseq_e,
	p_idx_cop_e,
	mpc_idx_cop_e,
	mpc_nonseq_ep,
	hold_intpref_done,
	mpc_ireton_e,
	mpc_stkdec_in_bytes,
	mpc_lsdc1_m,
	mpc_lsuxc1_m,
	mpc_lsuxc1_e,
	mpc_ldc1_m,
	mpc_ldc1_w,
	mpc_lsdc1_w,
	mpc_sdc1_w,
	mpc_lsdc1_e,
	mpc_eretval_e,
	mpc_ctlen_noe_e,
	mpc_updateepc_e,
	mpc_nomacroepc_e,
	mpc_umipsfifosupport_i,
	mpc_be_w,
	mpc_brrun_ie,
	mpc_eret_m,
	mpc_eret_null_m,
	mpc_deret_m,
	mpc_deretval_e,
	mpc_ret_e,
	mpc_cp0move_m,
	mpc_cp0sc_m,
	mpc_cp0diei_m,
	mpc_cp0r_m,
	mpc_cp0sr_m,
	mpc_wait_w,
	mpc_wait_m,
	mpc_dest_w,
	mpc_rfwrite_w,
	mpc_busty_e,
	mpc_busty_m,
	mpc_irval_e,
	mpc_irvalunpred_e,
	mpc_irvaldsp_e,
	mpc_irval_m,
	mpc_irval_w,
	mpc_dec_nop_w,
	mpc_pref_w,
	mpc_pref_m,
	mpc_st_m,
	mpc_ld_m,
	pref_e,
	prefx_e,
	mpc_alu_w,
	mpc_stall_ie,
	mpc_stall_m,
	mpc_stall_w,
	mpc_coptype_m,
	mpc_ivaval_i,
	mpc_icop_m,
	mpc_iccop_m,
	mpc_ll1_m,
	mpc_busty_raw_e,
	mpc_ll_m,
	mpc_load_m,
	mpc_wr_status_m,
	mpc_wr_intctl_m,
	mpc_muldiv_w,
	mpc_newiaddr,
	mpc_bussize_m,
	mpc_fixupi,
	mpc_fixupi_wascall,
	mpc_fixupd,
	mpc_fixup_m,
	mpc_run_i,
	mpc_run_ie,
	mpc_run_m,
	mpc_run_w,
	mpc_sc_e,
	mpc_sc_m,
	mpc_ll_e,
	mpc_srcvld_e,
	mpc_squash_i,
	mpc_squash_i_qual,
	squash_e,
	mpc_squash_m,
	mpc_strobe_e,
	mpc_strobe_m,
	mpc_strobe_w,
	mpc_sbstrobe_w,
	mpc_sbdstrobe_w,
	mpc_cbstrobe_w,
	mpc_mpustrobe_w,
	mpc_bds_m,
	mpc_compact_e,
	squash_w,
	mpc_annulds_e,
	annul_ds_i,
	qual_umipsri_e,
	mpc_isamode_i,
	mpc_isamode_e,
	mpc_isamode_m,
	mpc_isachange0_i,
	mpc_isachange1_i,
	mpc_excisamode_i,
	mpc_pm_complete,
	mpc_pdstrobe_w,
	mpc_ltu_e,
	mpc_mcp0stall_e,
	mpc_bubble_e,
	PM_InstnComplete,
	mpc_rslip_w,
	mpc_atomic_m,
	mpc_atomic_w,
	mpc_atomic_store_w,
	mpc_atomic_clrorset_w,
	mpc_atomic_bit_dest_w,
	mpc_macro_m,
	mpc_macro_w,
	mpc_atomic_load_e,
	mpc_ret_e_ndg,
	mpc_noseq_16bit_w,
	mpc_tail_chain_1st_seen,
	mpc_trace_iap_iae_e,
	mpc_chain_strobe,
	mpc_wr_sp2gpr,
	at_pro_done_i,
	at_epi_done_i,
	hw_rdpgpr,
	hw_g_rdpgpr,
	hw_rdgpr,
	mpc_chain_take,
	mpc_buf_epc,
	mpc_buf_status,
	mpc_buf_srsctl,
	mpc_hw_sp,
	hw_save_i,
	mpc_hw_save_done,
	mpc_hw_save_epc_e,
	mpc_hw_save_status_e,
	mpc_hw_save_srsctl_e,
	mpc_hw_save_epc_m,
	mpc_hw_save_status_m,
	mpc_hw_save_srsctl_m,
	mpc_sel_hw_load_i,
	hw_save_epc_i,
	mpc_hw_load_status_i,
	mpc_hw_load_status_e,
	mpc_hw_load_epc_e,
	mpc_hw_load_srsctl_e,
	mpc_hw_load_epc_m,
	mpc_hw_load_srsctl_m,
	hw_load_epc_i,
	hw_load_srsctl_i,
	mpc_iret_m,
	mpc_iret_ret,
	mpc_iretret_m,
	mpc_iret_ret_start,
	mpc_epi_vec,
	mpc_wr_view_ipl_m,
	mpc_atpro_w,
	mpc_atepi_w,
	mpc_atpro_m,
	mpc_atepi_m,
	mpc_iretval_e,
	mpc_chain_vec,
	chain_vec_end,
	mpc_hw_load_done,
	mpc_iae_done_exc,
	mpc_exc_iae,
	mpc_hw_ls_i,
	mpc_hw_ls_e,
	mpc_load_status_done,
	mpc_hold_epi_vec,
	mpc_hw_load_e,
	continue_squash_i,
	mpc_hw_save_srsctl_i,
	hw_save_status_i,
	mpc_continue_squash_i,
	mpc_chain_hold,
	mpc_ctl_dsp_valid_m,
	MDU_opcode_issue_e,
	MDU_data_valid_e,
	mpc_nullify_e,
	mpc_nullify_m,
	mpc_nullify_w,
	mpc_mdu_m,
	mpc_vd_m,
	MDU_run_e,
	MDU_data_ack_m,
	mpc_dec_sh_shright_m,
	mpc_dec_sh_subst_ctl_m,
	mpc_dec_sh_low_index_4_m,
	mpc_dec_sh_low_sel_m,
	mpc_dec_sh_high_index_m,
	mpc_dec_sh_high_sel_m,
	mpc_append_m,
	mpc_prepend_m,
	mpc_balign_m,
	MDU_data_val_e,
	mpc_mf_m2_w,
	mpc_g_cp0move_m,
	mpc_wr_guestctl0_m,
	mpc_wr_guestctl2_m,
	p_g_cp0_mv_e,
	edp_dsp_present_xx,
	dec_dsp_valid_e,
	edp_dsp_stallreq_e,
	edp_dsp_pos_ge32_e,
	edp_dsp_dspc_ou_wren_e,
	MDU_dec_e,
	ri_e,
	MDU_stallreq_e,
	dec_redirect_bposge32_e,
	MDU_ouflag_vld_xx,
	rddsp_e,
	mpc_wrdsp_e,
	mpc_ir_e,
	illinstn_e,
	dec_sh_shright_e,
	dec_sh_subst_ctl_e,
	dec_sh_low_index_4_e,
	dec_sh_low_sel_e,
	dec_sh_high_index_e,
	dec_sh_high_sel_e,
	append_e,
	prepend_e,
	balign_e,
	mpc_dec_imm_rsimm_e,
	mpc_dec_imm_apipe_sh_e,
	mpc_dec_insv_e,
	mpc_mulgpr_e,
	mdu_rfwrite_w,
	mdu_dest_w,
	mdu_alive_gpr_m1,
	mdu_alive_gpr_m2,
	mdu_alive_gpr_m3,
	mdu_alive_gpr_a,
	mdu_mf_m1,
	mdu_mf_m2,
	mdu_mf_m3,
	mdu_mf_a,
	mdu_nullify_m2,
	mdu_dest_m1,
	mdu_dest_m2,
	mdu_dest_m3,
	mdu_stall_issue_xx,
	mpc_movci_e,
	ej_fdc_busy_xx,
	ej_fdc_int,
	held_parerrexc_i,
	cpz_gm_e,
	cpz_gm_i,
	cpz_gm_w,
	cpz_gm_m,
	cpz_g_at_epi_en,
	cpz_g_erl,
	cpz_g_bev,
	cpz_g_at_pro_start_i,
	cpz_g_at_pro_start_val,
	cpz_g_mx,
	cpz_g_usekstk,
	cpz_g_iap_um,
	cpz_g_stkdec,
	cpz_g_int_pend_ed,
	cpz_g_ice,
	cpz_g_int_enable,
	cpz_g_srsctl_css,
	cpz_g_srsctl_pss,
	cpz_g_int_excl_ie_e,
	cpz_g_pf,
	cpz_g_rbigend_e,
	cpz_g_eretisa,
	cpz_g_excisamode,
	cpz_g_bootisamode,
	mpc_g_auexc_x,
	cpz_g_causeap,
	ctc1_fr0_e,
	ctc1_fr1_e,
	cfc1_fr_e,
	cp1_stall_m,
	mpc_scop1_m,
	scop2_e,
	lscop2_e,
	scop1_e,
	rdhwr_e,
	g_cp0_e,
	cpz_g_iret_m,
	qual_umipsri_g_e,
	scop2_w,
	lscop2_w,
	bstall_ie,
	mpc_ctc1_fr0_m,
	mpc_ctc1_fr1_m,
	mpc_cfc1_fr_m,
	mpc_rdhwr_m,
	mpc_pcrel_m);

	input 	    raw_ll_e;           // Load linked
	input 	    new_sc_e;           // Store Conditional
	input [5:0] dest_e;             // Destination register, bit 5 : 0=css, 1=pss
	input [4:0] src_a_e;            // Source A register number
	input [5:0] src_b_e;            // Source B register number
	input 	    mmu_tlbbusy;        // TLB is busy
	input 	    mpc_ldst_e;             // Load/Store instn
	input 	    cp0_e;              // Cop0 instn
	input 	    use_src_a_e;        // Instn uses src A
	input 	    use_src_b_e;        // Instn uses src B
	input 	    muldiv_e;           // MulDiv instn
	input 	    cp2_movefrom_m;     // Coprocessor Move
	input 	    cp2_moveto_m;       // Coprocessor Move
	input 	    cp1_movefrom_m;     // Coprocessor Move
	input 	    cp1_moveto_m;       // Coprocessor Move
	input 	    mdu_busy;           // MDU busy 
	input 	    mdu_stall;          // MDU stall
	input 	    mfhilo_e;           // MFHI/LO
	input 	    p_cp0_mv_e;         // Possible MTC0/MFC0
	input	    p_cp0_sc_e;         // possible set/clear CP0 instn
	input	    p_cp0_diei_e;       // possible DI/EI instn
	input 	    bds_e;              // Instn in E has branch delay slot
	input 	    icc_macro_e;        // Macro instn 
	input 	    icc_umipsri_e;        // Reserved UMIPS instn
        input 	    icc_preciseibe_e;   // Bus Error on E-stage instn
	input	    icc_poten_be;
	input	    icc_parerrint_i;	// parity error on i-stage
	input	    mmu_tlbinv;		// TLB invalid exception
	input	    mmu_tlbrefill;	// TLB refill exception
	input	    mmu_r_tlbrefill;	// TLB refill exception
	input	    mmu_r_tlbinv;		// TLB invalid exception
	input		mpc_macro_jr;		// macro jump cmd
	input [1:0]	edp_dva_1_0_e;  // Data virtual address (E-stage)
	input [1:0]	edp_stalign_byteoffset_e;// Data virtual address[1:0] used for store align byte
	input 	    mpc_cmov_e;         // Conditional move
	input 	    cmov_type_e;        // Type of conditional move 
	input 	    edp_cndeq_e;        // Result of Equality compare
	input 	    vd_e;               // Instn has Valid destination
	input 	    xfc2_e;             // MFC2/CFC2 
	input 	    xfc1_e;             // MFC1/CFC1 
	input 	    load_e;             // Direction of transfer (0 - to proc, 1 - from proc)
	input	    lsdc1_e;		// LDC1, SDC1 
	input	    lsdxc1_e;		// LDC1, SDC1 
	input	    lsuxc1_e;		// LDC1, SDC1 
	input [4:0] cp0_r_e;            // Register number
	input [2:0] cp0_sr_e;           // Shadow register number
	input 	    p_eret_e;           // Possible ERET instn
	input 	    p_deret_e;          // Possible DERET instn
	input 	    p_wait_e;           // Possible Wait instn
	input 	    br_likely_e;        // Branch Likely
	input 	    mpc_br16_e;         // UMIPS branch
	input 	    mpc_br32_e;         // MIPS32 branch
	input 	    icc_nobds_e;        // Instn does not have branch delay slot
	input	    mpc_nobds_e;	// This instruction has no delay slot
	input	    mpc_jalx_e;         // Jump and Link Exchange
	input	    rf_init_done;	// rf init done
	input 	    dcc_dmiss_m;        // D$ miss
	input	    dcc_spram_write;
	input 	    dcc_fixup_w;        // Fixup W-stage for dcc
	input 	    dcc_stall_m;        // M-stage stall for dcc
        input 	    dcc_ev;             // Eviction in progress
	input 	    icc_imiss_i;        // I$ miss
	input 	    icc_stall_i;        // I-stage stall for icc
	input 	    cp2_fixup_w;        // Fixup W-stage for Cop2 instn
	input 	    cp1_fixup_w;        // Fixup W-stage for Cop1 instn
	input 	    cp1_fixup_i;        // Fixup I-stage for Cop1 instn
	input 	    mmu_dtmack_m;       // DTLB Miss Acknowledge
	input 	    cp2_stall_e;        // Stall for Cop2 dispatch
	input 	    cp1_stall_e;        // Stall for Cop1 dispatch
	input 	    edp_udi_stall_m;    // Stall for UDI result
	input 	    cp2_bstall_e;       // Stall to resolve Cop2 branch
	input 	    cp1_bstall_e;       // Stall to resolve Cop1 branch
	input 	    greset;             // Global reset
	input 	    mpc_exc_e;          // Exception in E-stage
	input [3:0] coptype_e;          // Cacheop type
	input 	      mpc_exc_m;        // Exception in M-stage
	input 	    pend_exc;           // There is a pending exception
	input 	    icc_umipspresent;     // UMIPS block is present
	input 	    icc_pcrel_e;        // PC relative instn
	input 	    sh_var_e;           // Shift variable amount
	input 	    sh_fix_e;           // Shift fixed amount
	input [4:0] sh_fix_amt_e;       // Amount for a fixed shift instn
	input 	    udi_sel_e;          // Select UDI result
	input 	    alu_sel_e;          // Select ALU result

	input	    mpc_addui_e;	// lui instn
	input [1:0] mpc_bussize_e;      // Size of load/store reference
	input [2:0] pbus_type_e;        // Early reference type indication
	input 	    unal_type_e;        // Type of unaligned reference (Left/Right)
	input 	    mpc_unal_ref_e;     // Unaligned reference (L/SWL/R)
	input 	    signed_ld_e;        // Signed load in E-stage
	input 	    cpz_rbigend_e;      // CPU is effectively in big endian mode
	input [31:0]  edp_abus_e;        // SrcA bus (rs)
	input 	      cpz_eretisa;       // ISA Mode to return to
	input 	      br_eq;            // Branch on =
	input 	      br_le;            // Branch on <=
	input 	      br_ne;            // Branch on !=
	input 	      cmp_br;           // Comparitive branch
	input 	      br_gr;            // Branch on >
	input 	      br_lt;            // Branch on <
	input 	      br_ge;            // Branch on >=
	input 	      mpc_auexc_x;      // Exception in X-stage, redirect fetch
	input 	      mpc_jreg_e;       // Jump register in E-stage
	input 	      jreg_hb_e;        // Jump register HB in E-stage
	input 	      mpc_jimm_e;       // Jump immediate in E-stage
	input 	      sel_logic_e;      // Select Logic as result
	input 	      slt_sel_e;        // Select SetLessThan as result
	input 	      mpc_lnksel_e;     // Select link address as result
	input 	      signed_e;         // This is a signed Trap/SLT
	input 	      cp2_bvalid;       // Cop2 Branch detected
	input 	      cp1_bvalid;       // Cop1 Branch detected
	input 	      cpz_dm_w;         // W-stage DebugMode indication
	input 	      cp2_btaken;       // Cop2 branch taken
	input 	      cp1_btaken;       // Cop1 branch taken
	input 	      mpc_pexc_m;       // Prior exception in M-stage
	input 	      mpc_pexc_w;       // Prior exception in W-stage
	input 	      mpc_exc_w;        // Exception in W-stage
	input 	      cp2_fixup_m;      // Fixup M-stage for Cop2 op
	input 	      cp1_fixup_m;      // Fixup M-stage for Cop1 op
	input 	      mmu_itmack_i;     // ITLB Miss acknowledge
	input 	      mpc_pexc_e;           // prior exception in E-stage
	input	      mpc_ekillmd_m;      // Early Kill MDU instn
	input	      mpc_ekillmd_w;      // Early Kill MDU instn
	input	      mpc_eexc_e;	    // early exceptions detected in E-stage
        input 	      ejt_stall_st_e;
	input         ejt_pdt_stall_w; 	// Stall in W stage
        input         cpz_excisamode;	// exception isa mode (1: umips, 0: mips32)
        input         cpz_bootisamode;	// boot isa mode (1: umips, 0: mips32)
	input	      cpz_debugmode_i;	// debug isa mode  (1: umips, 0: mips32)
	input	      icc_macro_jr;	// performing a jump in macro
        input	      icc_umips_16bit_needed;	
	input [3:0] 	icc_umipsfifo_stat;	
	input		icc_umips_active;
	input 		icc_umipsfifo_imip;
	input 		icc_umipsfifo_ieip2;
	input 		icc_umipsfifo_ieip4;

	input		mpc_umipspresent;	// native umips present
	input		mpc_macro_e;		// macro instn @ e-stage
	input		mpc_pcrel_e;		// PC relative instn

	input [3:0]	cpz_srsctl_css;	    // Current SRS
	input [3:0]	cpz_srsctl_pss;	    // Previous SRS

	input 	        gscanenable;        // Global scan enable
	input 	        gclk;               // Global gated clock

	input		mpc_cont_pf_phase1;   //continue phase1 of interrupt prefetch
	input           mpc_int_pref;         //PC hold during HW seqence
	input		int_pref_phase2;
        input           cpz_at_pro_start_i;   //start cycle of HW auto prologue
        input           cpz_at_epi_en;     	//enable iae
	input		cpz_mx;		      //dsp enable
        input [31:0]    rf_bdt_e;             //regfile B read port
        input [31:0]    rf_adt_e;             //regfile A read port
        input [7:0]     cpz_int_pend_ed;      //pending iterrupt
        input [4:0]     cpz_stkdec;           //number of words for the decremented value of sp
        input [31:0]    dcc_ddata_m;          //Data bus to core
        input           p_iret_e;             // Possible IRET instn
        input           cpz_iret_m;           //active version of M-stage IRET instn
        input           cpz_ice;              //enable tail chain
        input           pf_phase1_nosquash_i; //not squash imiss due to pend_exc during ISR instruction prefetch
        input           hw_exc_m;             //exception during HW operations
        input           hw_exc_w;             //exception during HW operations
	input           cpz_erl;              //cpz_erl bit from status
	input           cpz_bev;              //Bootstrap exception vectors
	input		cpz_usekstk;	      //Use kernel stack during IAP
	input           cpz_causeap;          //exception happened during auto-prologue
	input           cpz_int_enable;       //interrupt enable
	input           ejt_dcrinte;          //EJTAG interrupt enable
	input           mpc_sel_hw_e;         //select hw ops
	input           cpz_iret_chain_reg;   //reg version of iret_tailchain 
	input           mpc_pf_phase2_done;   //phase2 of interrupt prefetch is done
	input		mpc_int_pref_phase1;  //phase1 of interrupt prefetch
	input		hold_pf_phase1_nosquash_i;
	input		set_pf_auexc_nosquash;
	input		set_pf_phase1_nosquash;
        input		cpz_pf;               //speculative prefetch enable
        input           cpz_at_pro_start_val; //valid start of HW auto prologue
        input           mpc_qual_auexc_x;     //final cycle of mpc_auexc_x
	input		cpz_iap_um; 	      //user mode when iap

	input		cpz_int_excl_ie_e;    //wii present. ignore ie bit
	input 		mpc_tlb_exc_type;	    // i stage exception type
	input		dspver_e;

	input		dec_cp1_e;
	input 	 	cp1_copidle;		// COP 1 is Idle, biu_shutdown is OK for COP 1
	input 		gfclk;		// global free clock
		
	input		cpz_rslip_e;      // Inject a pipeline slip
	input 		mpc_atomic_e; 		//Atomic enable 
	input 		mpc_atomic_clrorset_e;	//Bit clear or set for Atomic operation
	input [2:0]	mpc_atomic_bit_dest_e;	//The bit need to be clear or set
	output 	        mpc_cleard_strobe;      // Clear EJTAG Dbits
	output 	        sst_instn_valid_e;  // Early indication of valid instruction

	// res_m mux controls
	output 		mpc_alusel_m;     // Select ALU
	output		mpc_udislt_sel_m; // Select UDI or SLT
	output 		mpc_udisel_m;     // Select the result of UDI in M stage
	output 		mpc_lnksel_m;     // Select pc_hold for JAL/BAL/JALR
	
	// A/edp_bbus_e bypass controls
	output		mpc_aselres_e;    // Bypass res_m as src A
	output		mpc_aselwr_e;     // Bypass res_w as src A
	output		mpc_bselres_e;    // Bypass res_m as src B
	output		mpc_bselall_e;     // Bypass res_w as src B
	
	output 		mpc_apcsel_e;     // Select PC as src A

// Shifter controls
	output [4:0]	mpc_shamt_e;      // 1st stage shift amount

	output		mpc_disable_gclk_xx;

// Load Aligner controls
	output		mpc_selcp_m;      // Select Cp0 read data or Cp2 To data 
	output		mpc_selcp2to_m;     // Select Cp2 To data
	output		mpc_selcp2from_m;     // Select Cp2 To data
	output		mpc_selcp2from_w;     // Select Cp2 From data
	output		mpc_selcp1from_w;     // Select Cp1 From data
	output		mpc_selcp1to_m;     // Select Cp1 To data
	output		mpc_selcp1from_m;     // Select Cp1 To data
	output		mpc_selcp0_m;     // Select Cp0 read data (MFC0 or SC)
	output 		mpc_updateldcp_m; // Capture Load or CP0 data
	output		mpc_dcba_w;       // Select all bytes from D$
	output 		mpc_signa_w;  	  // Use sign bit of byte A
	output		mpc_signb_w;  	  // Use sign bit of byte B
	output		mpc_signc_w;  	  // Use sign bit of byte C
	output		mpc_signd_w;  	  // Use sign bit of byte D
	output [1:0] 	mpc_lda31_24sel_w; // Mux select of ld_algn_w[31:24]
	output [1:0] 	mpc_lda23_16sel_w; // Mux select of ld_algn_w[23:16]
	output [1:0] 	mpc_lda15_8sel_w;  // Mux select of ld_algn_w[15:8]
	output [1:0] 	mpc_lda7_0sel_w;  // Mux select of ld_algn_w[7:7]
	output		mpc_cdsign_w;     // Sign extend to fill upper half 
	output		mpc_bsign_w;      // Sign extend to fill byte B

// AGEN Controls
	output		mpc_signed_m;     // This is a signed operation

// edp_iva_e Mux Controls
	output 		mpc_defivasel_e;  // Use PC+2/4 as next PC
	output 		mpc_sequential_e; // Next PC is sequential
	output		mpc_umips_defivasel_e;
	output		mpc_umips_mirrordefivasel_e;
	
// ALU Controls
	output		mpc_sellogic_m;   // Select Logic Function output
	
	// Misc. controls
	output		mpc_eqcond_e;     // Branch condition met
	output [3:0]	mpc_lsbe_m;       // Byte enables for L/S
	input [31:0]	ej_rdvec_read;	  // DebugVectorAddr
	input		ej_rdvec;
	input		ej_isaondebug_read;
	input		ej_probtrap;
	input		icc_umipsfifo_null_i;	// instn slip i-stage
	output		icc_umipsfifo_null_w;	// instn slip propagated to w-stage
	output		mpc_nonseq_e;		// instn is nonsequential
	input		p_idx_cop_e;
	output		mpc_idx_cop_e;
	output		mpc_nonseq_ep;		// nonsequential pulse
	output		hold_intpref_done;
	output		mpc_ireton_e;
	output	[6:0]	mpc_stkdec_in_bytes;
	output		mpc_lsdc1_m;
	output		mpc_lsuxc1_m;
	output		mpc_lsuxc1_e;
	output		mpc_ldc1_m;
	output		mpc_ldc1_w;
	output		mpc_lsdc1_w;
	output		mpc_sdc1_w;
	output		mpc_lsdc1_e;

        output          mpc_eretval_e;    // ERet instn

	output 		mpc_ctlen_noe_e;  // Early enable signal, not qualified with exc_e
	output 		mpc_updateepc_e;  // Capture a new EPC for the E-stage instn
	output		mpc_nomacroepc_e;
	output		mpc_umipsfifosupport_i;
	
// EJTAG controls
	output [3:0]	mpc_be_w;         // Byte enables for L/S

   	output 	 	mpc_brrun_ie;     // Stage I,E  is moving to next stage. 
   					  // Not deaserted for COP2 branch.


	output		mpc_eret_m;       // ERet instn
	output		mpc_eret_null_m;       // ERet instn
	output		mpc_deret_m;      // DERet instn
	output		mpc_deretval_e;   // DERet instn
	output		mpc_ret_e;        // ERet or DERet instn
	output		mpc_cp0move_m;	  // MT/MF C0
	output		mpc_cp0sc_m;	  // set/clear bit in C0
	output		mpc_cp0diei_m;	  // DI/EI
	output [4:0]	mpc_cp0r_m;	  // coprocessor zero register specifier
	output [2:0]	mpc_cp0sr_m;	  // coprocessor zero shadow register specifier
	output		mpc_wait_w;	  // Cp0 wait operation
	output		mpc_wait_m;	  // Cp0 wait operation

	// outputs to RF
	output [8:0]	mpc_dest_w;	  // destination register (phase one WRB)
	output		mpc_rfwrite_w;	  // Reg. File write enable

	// outputs to $ Ctl
	output [2:0]	mpc_busty_e;	  // Bus operation type - 0-nil, 1-load, 2-store, 3-pref, 4-sync, 5-ICacheOp, 6-DCacheOp
	output [2:0]	mpc_busty_m;	  // Bus operation type - 0-nil, 1-load, 2-store, 3-pref, 4-sync, 5-ICacheOp, 6-DCacheOp

	output		mpc_irval_e;      // Instn register is valid
	output          mpc_irvalunpred_e;// Instn register is valid, but may have architecturally unpredictable behavior
	output		mpc_irvaldsp_e;   // Instn register is valid
	output		mpc_irval_m;      // Instn register is valid
	output		mpc_irval_w;      // Instn register is valid

        output          mpc_dec_nop_w;
        output          mpc_pref_w;
        output          mpc_pref_m;
	output		mpc_st_m;
	output		mpc_ld_m;
	input		pref_e;
	input		prefx_e;
	output		mpc_alu_w;

	output          mpc_stall_ie;   
        output          mpc_stall_m;   
        output          mpc_stall_w;   
	output [3:0]	mpc_coptype_m;    // CacheOp type: Raw bits from Instn
        output          mpc_ivaval_i;     // Instn VA is valid
	output		mpc_icop_m;       // I-side cache op
	output		mpc_iccop_m;       // I-side cache op
	output		mpc_ll1_m;	  // Load linked in first clock of M
	output [2:0]	mpc_busty_raw_e;  // Bus operation type not qualified with exc_e or dcc_dmiss_m
	
	output		mpc_ll_m;	  // Load linked in M
	output		mpc_load_m;	  // Load or MFC0
	output		mpc_wr_status_m;
	output		mpc_wr_intctl_m;
	output		mpc_muldiv_w;     // MDU op in W-stage
	output 		mpc_newiaddr;     // New Instn Address
	output [1:0]	mpc_bussize_m;	  // load/store data size 

        output 		mpc_fixupi;       // I$ Miss previous cycle
        output 		mpc_fixupi_wascall;       // I$ Miss previous cycle
        output 		mpc_fixupd;       // D$ Miss previous cycle
        output 		mpc_fixup_m;      // D$ Miss previous cycle
	output		mpc_run_i;        // I-stage Run (used for exc processing)
	output		mpc_run_ie;       // E-stage Run
	output		mpc_run_m;        // M-stage Run
	output		mpc_run_w;        // W-stage Run
	output		mpc_sc_e;         // Store Conditional in E
	output		mpc_sc_m;         // Store Conditional in M
	output 		mpc_ll_e;         // Load linked in E
	output		mpc_srcvld_e;     // Src registers are valid (for MDU)
	output		mpc_squash_i;	  // Squash the instn in _I by faking an Exception
	output		mpc_squash_i_qual; 
	output		squash_e;	  // Squash the instn in _E by faking an Exception
	output		mpc_squash_m; 	  // Instn in M was squashed
	output		mpc_strobe_e;
	output		mpc_strobe_m;
	output		mpc_strobe_w;
	output		mpc_sbstrobe_w;   // ejtag simple break strobe
	output		mpc_sbdstrobe_w;  // ejtag simple break strobe for d channels
	output		mpc_cbstrobe_w;   // ejtag complex break strobe - not strobed on exception
	output		mpc_mpustrobe_w;  // mpu region access strobe
	output 		mpc_bds_m;        // Instn in M-stage has branch delay slot
	output 		mpc_compact_e;    // Compact branch instruction
	output 		squash_w;         // W-stage instn was squashed
	output 		mpc_annulds_e;    // Annulled Delay Slot in E-stage
	output 		annul_ds_i;    // Annulled Delay Slot in I-stage
	output 		qual_umipsri_e;     // RI qualified with valid instn

	output 		mpc_isamode_i;    // I-stage instn is UMIPS
	output 		mpc_isamode_e;    // E-stage instn is UMIPS
	output 		mpc_isamode_m;    // M-stage isntn is UMIPS
	output		mpc_isachange0_i;  // Indicates isa change happening during abnormal pipeline process
	output		mpc_isachange1_i;  // Indicates isa change happening during abnormal pipeline process
	output		mpc_excisamode_i;  // indicates isa change when isa not available 

        output 		mpc_pm_complete;  // Instn. successfully completed
        output 		mpc_pdstrobe_w;   // Instn Valid in W

	output		mpc_ltu_e;	  // stall due to load-to-use. (for loads only)
	output		mpc_mcp0stall_e;  // stall due to cp0 return data.
	output		mpc_bubble_e;	  // stalls e-stage due to arithmetic/deadlock/return data reasons

	// Performance monitoring signals after I/O registers
        output          PM_InstnComplete;


	output		mpc_rslip_w;      // injected slip is in W-stage
//Atomic control signal
	output		mpc_atomic_m;		// Atomic instruciton in M stage
	output	        mpc_atomic_w;   	// Atomic instruciton in W stage
	output	        mpc_atomic_store_w;	// Atomic instruciton in store operation
	output          mpc_atomic_clrorset_w;	// Atomic instruciton clr/set in W stage 
	output [2:0]    mpc_atomic_bit_dest_w;	// Atomic instruciton bit in W stage
	output		mpc_macro_m;
	output		mpc_macro_w;

	output		mpc_atomic_load_e;

//IRET and ERET
	output		mpc_ret_e_ndg;		// IRET or ERET is valid in E stage
	output		mpc_noseq_16bit_w;  	// The instruction in W stage is 16bit size
	output		mpc_tail_chain_1st_seen; // The instruction in W stage is IRET itself only for tailchain
	output		mpc_trace_iap_iae_e;       // iap and iae in E stage,data breakpoint could be traced out

	output          mpc_chain_strobe;      //tail chain happen strobe
        output          mpc_wr_sp2gpr;         //write stobe to update sp to GPR during HW sequence
        output          at_pro_done_i;         //HW entry sequence is done
        output          at_epi_done_i;         //HW exit sequence is done
        output          hw_rdpgpr;             //read sp from previous GPR in case of SRS switching
        output          hw_g_rdpgpr;             //read sp from previous GPR in case of SRS switching
        output          hw_rdgpr;              //read sp strobe for HW sequence
        output          mpc_chain_take;        //tail chain happened
        output [31:0]   mpc_buf_epc;           //EPC saved to stack during HW sequence
        output [31:0]   mpc_buf_status;        //Status saved to stack during HW sequence
        output [31:0]   mpc_buf_srsctl;        //SRSCTL saved to stack during HW sequence
        output [31:0]   mpc_hw_sp;             //sp saved to GPR during HW sequence
        output          hw_save_i;     //select HW save operation for icc_idata_i
        output          mpc_hw_save_done;      //HW sequence done
        output          mpc_hw_save_epc_e;     //E-stage HW save EPC operation
        output          mpc_hw_save_status_e;  //E-stage HW save Status operation
        output          mpc_hw_save_srsctl_e;  //E-stage HW save SRSCTL operation
        output          mpc_hw_save_epc_m;     //M-stage HW save EPC operation
        output          mpc_hw_save_status_m;  //M-stage HW save Status operation
        output          mpc_hw_save_srsctl_m;  //M-stage HW save SRSCTL operation
        output          mpc_sel_hw_load_i;     //select HW load operation for icc_idata_i
        output          hw_save_epc_i;         //HW save epc i-stage
	output          mpc_hw_load_status_i;  //I-stage HW load Status operation
        output          mpc_hw_load_status_e;  //E-stage HW load Status operation
        output          mpc_hw_load_epc_e;     //E-stage HW load EPC operation
        output          mpc_hw_load_srsctl_e;  //E-stage HW load SRSCTL operation
        output          mpc_hw_load_epc_m;     //M-stage HW load EPC operation
        output          mpc_hw_load_srsctl_m;  //M-stage HW load SRSCTL operation
	output		hw_load_epc_i;	       //I-stage HW load EPC operation
	output		hw_load_srsctl_i;      //I-stage HW load SRSCTL operation
        output          mpc_iret_m;            //M-stage IRET instruction done
	output		mpc_iret_ret;          //PC redirect due to IRET return
	output		mpc_iretret_m;	       //M-stage qualified iret_ret
	output		mpc_iret_ret_start;    //start cycle of mpc_iret_ret
	output          mpc_epi_vec;           //hold pc during auto epilogue until normal return or jump to next interrupt
	output		mpc_wr_view_ipl_m;     //write view_ipl register
	output		mpc_atpro_w;           //auto-prologue in W-stage
	output          mpc_atepi_w;           //auto-epilogue in W-stage
	output		mpc_atpro_m;               //auto-prologue in M-stage
	output		mpc_atepi_m;           //auto-epilogue in M-stage
	output          mpc_iretval_e;         //E-stage IRET instruction
	output          mpc_chain_vec;         //hold tail chain jump
	output          chain_vec_end;         //end cycle of hold tail chain jump
	output          mpc_hw_load_done;      //HW load operation done
	output          mpc_iae_done_exc;      //HW load done due to exception
	output		mpc_exc_iae;	       //exceptions happened during IAE
	output		mpc_hw_ls_i;	       //HW operation in I-stage
	output		mpc_hw_ls_e;
	output		mpc_load_status_done;  //HW load status done
	output		mpc_hold_epi_vec;      //register version of mpc_epi_vec
	output		mpc_hw_load_e;	       //HW load epc or srsctl in E-stage
	output		continue_squash_i;     //continue to squash I-stage
	output		mpc_hw_save_srsctl_i;      //HW save srsct in I-stage
	output		hw_save_status_i;      //HW save status in I-stage
	output		mpc_continue_squash_i; //continue to squash I-stage
	output		mpc_chain_hold;	       //hold chain info 

	output		mpc_ctl_dsp_valid_m;
	output		MDU_opcode_issue_e;
	output		MDU_data_valid_e;
	output		mpc_nullify_e;
	output		mpc_nullify_m;
	output		mpc_nullify_w;
	output		mpc_mdu_m;
	output		mpc_vd_m;
	output		MDU_run_e;
	output	 	MDU_data_ack_m;	//Data accept from MPC on MDU data
	output		mpc_dec_sh_shright_m;
	output		mpc_dec_sh_subst_ctl_m;
	output		mpc_dec_sh_low_index_4_m;
	output		mpc_dec_sh_low_sel_m;
	output	[4:0]	mpc_dec_sh_high_index_m;
	output		mpc_dec_sh_high_sel_m;
	output		mpc_append_m;
	output		mpc_prepend_m;
	output		mpc_balign_m;
	output		MDU_data_val_e;
	output		mpc_mf_m2_w;		

	output		mpc_g_cp0move_m;	  // MT/MF C0
	output		mpc_wr_guestctl0_m;     
	output		mpc_wr_guestctl2_m;

	input 	    	p_g_cp0_mv_e;         // Possible MTC0/MFC0

	input		edp_dsp_present_xx;		
	input		dec_dsp_valid_e;
	input		edp_dsp_stallreq_e;
	input		edp_dsp_pos_ge32_e;
	input		edp_dsp_dspc_ou_wren_e;
	input		MDU_dec_e;
	input		ri_e;
	input		MDU_stallreq_e;		
	input		dec_redirect_bposge32_e;		
	input		MDU_ouflag_vld_xx;		
	input		rddsp_e;
	input		mpc_wrdsp_e;
        input [31:0]    mpc_ir_e;
	input		illinstn_e;
	input		dec_sh_shright_e;
	input		dec_sh_subst_ctl_e;
	input		dec_sh_low_index_4_e;
	input		dec_sh_low_sel_e;
	input	[4:0]	dec_sh_high_index_e;
	input		dec_sh_high_sel_e;
	input		append_e;
	input		prepend_e;
	input		balign_e;
	input		mpc_dec_imm_rsimm_e;		
	input	[15:0]	mpc_dec_imm_apipe_sh_e;
	input		mpc_dec_insv_e;		
	input 		mpc_mulgpr_e;
	input 		mdu_rfwrite_w;
	input	[4:0]	mdu_dest_w;
	input          mdu_alive_gpr_m1;
	input          mdu_alive_gpr_m2;
	input          mdu_alive_gpr_m3;
	input          mdu_alive_gpr_a;
	input          mdu_mf_m1;
	input          mdu_mf_m2;
	input          mdu_mf_m3;
	input          mdu_mf_a;
	input          mdu_nullify_m2;
	input [4:0]    mdu_dest_m1;         
	input [4:0]    mdu_dest_m2;         
	input [4:0]    mdu_dest_m3;         
	input          mdu_stall_issue_xx;
	input	       mpc_movci_e;
	
	input 		ej_fdc_busy_xx;
	input		ej_fdc_int;

	input		held_parerrexc_i;	// hold i-stage parity error



	input		cpz_gm_e;
	input		cpz_gm_i;
	input		cpz_gm_w;
	input		cpz_gm_m;
	input		cpz_g_at_epi_en;
	input		cpz_g_erl;
	input		cpz_g_bev;
	input		cpz_g_at_pro_start_i;
        input           cpz_g_at_pro_start_val; 
        input           cpz_g_mx; 
	input           cpz_g_usekstk;            //Use kernel stack during IAP
	input           cpz_g_iap_um;
	input [4:0]     cpz_g_stkdec;             //number of words for the decremented value of sp
	input [7:0]     cpz_g_int_pend_ed;        //pending iterrupt
	input           cpz_g_ice;                //enable tail chain
	input           cpz_g_int_enable;         //interrupt enable
	input [3:0]	cpz_g_srsctl_css;		// Current SRS
	input [3:0]	cpz_g_srsctl_pss;		// Previous SRS
	input		cpz_g_int_excl_ie_e;	
        input		cpz_g_pf;               //speculative prefetch enable
	input 	    	cpz_g_rbigend_e;      // CPU is effectively in big endian mode
	input 		cpz_g_eretisa;	// Target ISA for ERET or DERET (from epc or ErrorPC or depc)
	input           cpz_g_excisamode; // isamode for exception
	input           cpz_g_bootisamode; // isamode for boot
	input		mpc_g_auexc_x;	
	input           cpz_g_causeap;            //exception happened during auto-prologue
	input		ctc1_fr0_e;
	input		ctc1_fr1_e;
	input		cfc1_fr_e;
	input		cp1_stall_m;
        output          mpc_scop1_m;
	input		scop2_e;
	input		lscop2_e;
	input		scop1_e;
	input		rdhwr_e;
	input 	    	g_cp0_e;              // Cop0 instn
	input 		cpz_g_iret_m;		// active version of M-stage IRET instn

        output          qual_umipsri_g_e;
        output          scop2_w;
        output          lscop2_w;
	output		bstall_ie;//for performance counter	
	output		mpc_ctc1_fr0_m;
	output		mpc_ctc1_fr1_m;
	output		mpc_cfc1_fr_m;
	output		mpc_rdhwr_m;
	output 		mpc_pcrel_m;      // PC relative instn in M stage

// BEGIN Wire declarations made by MVP
wire mpc_chain_strobe;
wire hw_save_epc_w;
wire mpc_sbstrobe_w_long;
wire mpc_ltu_e;
wire hold_pd_valid_noe_e;
wire at_pro_done_i;
wire annul_inst_e;
wire kill_cmov_e;
wire restore_valid_str;
wire raw_bpsall_e;
wire hw_load_status_m;
wire r0;
wire annul_ds_i;
wire [2:0] /*[2:0]*/ mpc_busty_raw_e;
wire mr0d_cp2cp1_m;
wire mpc_hold_epi_vec;
wire mpc_hw_load_done;
wire mr0d_m;
wire axxx_m;
wire mpc_lnksel_m;
wire mpc_bselres_e;
wire mpc_wr_view_ipl_m;
wire hold_valid_e;
wire [31:0] /*[31:0]*/ sp_plus;
wire mpc_selcp1to_m;
wire mpc_newiaddr_raw_reg;
wire mpc_atomic_m;
wire mpc_isachange1_i;
wire eq_cond_noce;
wire mpc_ldc1_w;
wire at_epi_start_i;
wire mpc_rfrd0write_w;
wire mpc_squash_i_trace;
wire prod_cons_stall_e;
wire mpc_ctl_dsp_valid_m;
wire atepi_m_reg;
wire [1:0] /*[1:0]*/ lda23_16sel_m;
wire tail_chain_first_seen_reg;
wire mpc_squash_i_reg;
wire raw_selcp2from_w;
wire wr_intctl_e;
wire mdu_stall_e;
wire delay_clrisa_i_cnxt;
wire greset_reg;
wire mpc_sc_e;
wire mpc_atomic_e_reg;
wire mpc_dec_sh_shright_m;
wire mpc_aselres_e;
wire [6:0] /*[6:0]*/ mpc_stkdec_in_bytes;
wire sst_instn_valid_e;
wire mpc_hw_load_epc_m;
wire mpc_chain_strobe_reg;
wire hold_iret_m;
wire inv_dyn1;
wire qual_cp0_m;
wire mpc_brrun_ie;
wire [2:0] /*[2:0]*/ mpc_busty_m;
wire rfinit_stall_e;
wire mfhilo_m;
wire pss_eq_css;
wire signc_m;
wire mpc_irval_e;
wire mpc_ret_e;
wire pr0d_w;
wire mpc_iretval_e;
wire mpc_cleard_strobe;
wire [3:0] /*[3:0]*/ raw_coptype_m;
wire mpc_ll_e;
wire [4:0] /*[4:0]*/ mpc_cp0r_m;
wire new_cp0_wait_e;
wire mpc_muldiv_w;
wire [4:0] /*[4:0]*/ mpc_dec_sh_high_index_m;
wire [2:0] /*[2:0]*/ mpc_atomic_bit_dest_w;
wire hw_save_status_i;
wire setisa_i_cnxt;
wire mpc_isamode_i;
wire hw_load_epc_m;
wire raw_hw_load_status_m;
wire cp2_cp1_mv_stall_e;
wire scop2_w;
wire wr_dspc_m;
wire [2:0] /*[2:0]*/ mpc_atomic_bit_dest_m;
wire mpc_apcsel_e;
wire mpc_iret_ret;
wire mpc_lnksel_m_x;
wire raw_selcp1from_w;
wire [1:0] /*[1:0]*/ shamt_e;
wire unal_type_m;
wire hw_save_epc_m;
wire dcba_m;
wire mpc_newiaddr_reg;
wire mr0d_e;
wire loadin_e;
wire mpc_pdstrobe_w;
wire pf_nosquash_done;
wire mpc_isamode_m;
wire hw_save_srsctl_w;
wire strobe_e;
wire mpc_rslip_w;
wire mpc_alusel_m;
wire mpc_disable_gclk_xx;
wire loadin_m;
wire mpc_nullify_w;
wire mpc_sellogic_m;
wire mpc_ireton_e;
wire mpc_selcp_m;
wire mpc_irval_umipsri_e;
wire inv_dyn0;
wire mpc_umipsfifosupport_i;
wire hold_chain_strobe;
wire mpc_atomic_clrorset_m;
wire mpc_cdsign_w;
wire bpsall_e_tmp;
wire [1:0] /*[1:0]*/ st_shamt_e;
wire strobe_e_all;
wire [1:0] /*[1:0]*/ mpc_lnksel_m_countdown;
wire [2:0] /*[2:0]*/ mpc_busty_e;
wire mpc_hw_save_srsctl_m;
wire [1:0] /*[1:0]*/ shamt_m;
wire noseq_16bit_e_valid_m;
wire mpc_ldc1_m;
wire mpc_fixup_w;
wire mpc_signd_w;
wire pd_irvalid_noe_e;
wire mpc_updateldcp_m;
wire [4:0] /*[4:0]*/ rfinit_count;
wire load_res_w;
wire bstall_ie;
wire mpc_udisel_m;
wire clear_valid_str;
wire mpc_noseq_16bit_w;
wire irvalid_noe_e;
wire mpc_epi_vec;
wire hw_save_status_m;
wire atomic_load_e_reg;
wire mpc_chain_take;
wire [2:0] /*[2:0]*/ count_hw_load;
wire cnd_eq_en;
wire bpswr_raw_e;
wire mpc_dcba_w;
wire mpc_sbstrobe_w_raw;
wire mpc_run_w;
wire mpc_isamode_e;
wire strobe_m_all;
wire hw_save_status_w;
wire hold_intpref_done;
wire mpc_tail_chain_1st_seen;
wire hw_load_epc_i;
wire oldsc_e;
wire mf_bps_a_m2;
wire strobe_w_all;
wire mpc_rethazard_e;
wire mvd_e;
wire mpc_defivasel_e;
wire mpc_wr_sp2gpr;
wire control_en_e;
wire sst_squash_e;
wire mpc_nonseq_e_d;
wire [1:0] /*[1:0]*/ half_e;
wire mpc_squash_i_qual;
wire mpc_append_m;
wire hold_squash_i;
wire cp0_diei_e;
wire mpc_hw_ls_e;
wire mpc_eret_e;
wire mpc_eqcond_e;
wire s_d_eqwr_1;
wire [1:0] /*[1:0]*/ mpc_lda31_24sel_w;
wire [1:0] /*[1:0]*/ mpc_lda23_16sel_w;
wire mpc_sc_m;
wire load_srsctl_done;
wire mpc_srcvld_e;
wire squash_e;
wire mpc_alu_w;
wire mpc_hw_load_endpulse;
wire mpc_ret_e_ndg;
wire iap_sp_update;
wire xxdc_m;
wire pref_w_pre;
wire newiaddr_lsdc1;
wire mpc_mf_m2_w;
wire mpc_selcp2from_w;
wire [4:0] /*[4:0]*/ hold_dest_m2_w;
wire mpc_macro_m;
wire mpc_stall_w;
wire hold_squash_i_trace;
wire [2:0] /*[2:0]*/ busty_ed;
wire mpc_pref_m;
wire MDU_run_e;
wire [4:0] /*[4:0]*/ pshift_e;
wire mpc_irvaldsp_e;
wire mpc_udislt_sel_m;
wire strobe_noe_w;
wire mf_bps_b_m2;
wire atepi_m_done;
wire strobe_in_chaintake;
wire mpc_bsign_w;
wire raw_dspinstn_valid_e;
wire mpc_eretval_e;
wire pf_nosquash_reg;
wire strobe_noe_w_pm;
wire mpc_mpustrobe_w;
wire icc_umipsfifo_null_w;
wire mpc_hw_save_epc_e;
wire mpc_hw_load_e;
wire at_pro_seq_i;
wire continue_squash_e;
wire pdstrobe_w;
wire lscop2_w;
wire icopaccess_e;
wire mpc_fixupi;
wire mpc_sbstrobe_w;
wire mpc_sbdstrobe_w;
wire noseq_16bit_e_valid;
wire cop1_s_stall_e;
wire [3:0] /*[3:0]*/ mpc_be_w;
wire wr0d_w;
wire vd_w;
wire mpc_mdu_m;
wire see_auexc;
wire mpc_eret_m;
wire mpc_cp0move_m;
wire mpc_excisamode_i;
wire prod_cons_stall_req;
wire mpc_signed_m;
wire raw_icopaccess_m;
wire mpc_nullify_m;
wire mpc_chain_hold;
wire [31:0] /*[31:0]*/ mpc_buf_srsctl;
wire mulgpr_busy;
wire hw_bpsall_e;
wire MDU_opcode_issue_e;
wire hold_mf_m2_w;
wire mpc_wait_m;
wire mpc_pm_complete;
wire hw_load_e;
wire mpc_rslip_m;
wire mpc_squash_m;
wire sign_cond;
wire bpsall_e;
wire [31:0] /*[31:0]*/ mpc_buf_status;
wire mpc_strobe_e;
wire mpc_hw_save_epc_m;
wire cp0_mv_e;
wire wpvd_m;
wire mpc_deretval_e;
wire [5:0] /*[5:0]*/ dest_m;
wire mpc_sel_hw_load_i;
wire irval_e2m;
wire MDU_data_ack_m;
wire mpc_hw_ls_i;
wire [1:0] /*[1:0]*/ lda7_0sel_m;
wire raw_squash_e;
wire dspinstn_valid_e;
wire unal_ref_m;
wire cbax_m;
wire mpc_load_status_done;
wire [1:0] /*[1:0]*/ mpc_lda15_8sel_w;
wire baxx_m;
wire mcp0_stall_e;
wire squash_e_trace;
wire hold_invalid_all;
wire wprstrobe_m_pm;
wire bpswr_e;
wire mpc_hw_load_epc_e;
wire [3:0] /*[3:0]*/ css_for_mdu;
wire mpc_atepi_m;
wire mdu_data_valid_e_tmp;
wire hw_load_status_w;
wire cp0_wait_m;
wire load_to_use_stall_e;
wire mpc_wait_w;
wire [3:0] /*[3:0]*/ lsbe_e;
wire cp0_sc_e;
wire stall_w;
wire mmu_itmack_i_work;
wire pvd_m;
wire mpc_updateepc_e;
wire strobe_m;
wire mpc_lsdc1_w;
wire mpc_ll_m;
wire umips_16bit_needed_reg;
wire mpc_atomic_clrorset_w;
wire s_d_eqall;
wire [1:0] /*[1:0]*/ count_imiss_off;
wire save_srsctl_done;
wire mpc_selcp2from_m;
wire mpc_idx_cop_e;
wire mpc_sequential_e;
wire hold_valid_noe_e;
wire qual_umipsri_e;
wire isachange1_stall_i;
wire mpc_iae_done_exc;
wire exclused_from_strobe_tchain;
wire mpc_st_m;
wire wprstrobe_m_all;
wire mpc_nonseq_e;
wire raw_load_status_done;
wire raw_icopaccess_e;
wire mpc_signb_w;
wire signd_m;
wire mpc_rfwrite_w;
wire raw_instn_valid_e;
wire mpc_run_i;
wire load_res_m;
wire mpc_iret_m;
wire mpc_chain_vec;
wire mpc_exc_iae;
wire mpc_continue_squash_i;
wire mpc_dec_sh_low_sel_m;
wire wr_status_e;
wire chain_vec_end;
wire at_epi_seq_i;
wire mpc_scop1_m;
wire ld_exciae;
wire [1:0] /*[1:0]*/ mpc_lda7_0sel_w;
wire mpc_squash_i;
wire [1:0] /*[1:0]*/ byte_e;
wire mpc_ld_m;
wire mpc_hw_save_srsctl_i;
wire mpc_ctc1_fr0_m;
wire mpc_cp0diei_m;
wire pvd_w;
wire cdsign_m;
wire scop2_m;
wire signb_m;
wire [3:0] /*[3:0]*/ coptype_md;
wire mpc_dec_nop_w;
wire isachange0_stall_i;
wire mpc_deret_e;
wire icc_umipsfifo_null_e;
wire hw_apsall_e;
wire s_d_eqall_1;
wire mpc_selcp1from_w;
wire msquash_e;
wire mpc_lsdc1_e;
wire clrisa_i_cnxt;
wire mpc_umips_mirrordefivasel_e;
wire pstrobe_w_pm;
wire mpc_ll1_m;
wire wr_guestctl0_e;
wire wprstrobe_m;
wire hw_load_epc_w;
wire slt_sel_m;
wire mpc_sbstrobe_w_all;
wire hazard_stall_ie;
wire mpc_cfc1_fr_m;
wire mpc_ctc1_fr1_m;
wire hold_see_at_pro;
wire mpc_alu_w_pre;
wire mpc_fixupd;
wire hold_iret_ret;
wire mpc_bselall_e;
wire mfhilo_w;
wire mpc_dec_sh_low_index_4_m;
wire imiss_negedge;
wire hw_save_i;
wire icopaccess_md;
wire intprefphase2_done_reg;
wire umips_16bit_needed_e;
wire hazard_stall_ret_ie;
wire bubble_e;
wire hw_rdgpr;
wire [19:0] /*[19:0]*/ buf_srsctl;
wire mpc_signa_w;
wire apswr_raw_e;
wire [2:0] /*[2:0]*/ greset_4cycles_reg;
wire mpc_atomic_store_w;
wire mpc_iretret_m;
wire hw_g_rdpgpr;
wire instn_valid_e;
wire s_d_eqwr;
wire bpswr_e_tmp;
wire mpc_cbstrobe_w;
wire pdstrobe_m;
wire mpc_newiaddr;
wire wr_guestctl2_e;
wire setisa_i;
wire mpc_isachange0_i;
wire mpc_pcrel_m;
wire mpc_run_m;
wire exclused_from_strobe_iap;
wire mpc_ivaval_i;
wire mpc_ctlen_noe_e;
wire asign;
wire mpc_hw_load_status_e;
wire apsall_e;
wire mpc_strobe_w;
wire mpc_strobe_m;
wire s_d_eqall_0;
wire p_tail_chain;
wire mpc_hw_load_status_i;
wire pro_epi_cont_fixupi;
wire hold_continue_squash_i;
wire hw_bpswr_e;
wire PM_InstnComplete;
wire mpc_nullify_e;
wire mpc_bubble_e;
wire delay_clrisa_i;
wire debugmode_isa;
wire hold_pref_negedge;
wire mpc_nonseq_ep;
wire mpc_dec_sh_subst_ctl_m;
wire hw_rdpgpr;
wire pstrobe_w;
wire mpc_irvalunpred_e;
wire mpc_prepend_m;
wire s_d_eqwr_0;
wire at_epi_done_i;
wire hw_save_epc_i;
wire apswr_e;
wire mpc_iccop_m;
wire [31:0] /*[31:0]*/ mpc_hw_sp;
wire mpc_nonseq_e_start;
wire wr_sp2gpr_strobe;
wire xxxd_m;
wire idx_cop_ed;
wire clrisa_i;
wire mpc_hw_load_srsctl_m;
wire mpc_selcp1from_m;
wire mpc_g_cp0move_m;
wire hw_load_srsctl_i;
wire g_cp0_mv_e;
wire mpc_irval_m;
wire mpc_signc_w;
wire mpc_trace_iap_iae_e;
wire [31:0] /*[31:0]*/ mpc_buf_epc;
wire mmu_itmack_i_atomic;
wire mpc_fixupi_wascall;
wire vd_m;
wire md_writegpr_stall_e;
wire mpc_run_ie;
wire mpc_rdhwr_m;
wire held_pref_negedge;
wire mpc_icop_m;
wire lscop2_m;
wire mpc_macro_w;
wire mpc_load_m;
wire mpc_ret_m;
wire mpc_sbstrobe_w_all_long;
wire mpc_atpro_m;
wire md_busy_stall_e;
wire mpc_mcp0stall_e;
wire new_cp0_wait_m;
wire bsign_m;
wire mpc_newiaddr_raw;
wire mpc_eret_null_m;
wire load_res_done;
wire alu_sel_m;
wire [25:0] /*[25:0]*/ buf_status;
wire mpc_compact_e;
wire mpc_nomacroepc_e;
wire mpc_hw_load_srsctl_e;
wire mpc_hw_load_ed;
wire tlbstall_e;
wire eqcond_e;
wire lwl_m;
wire mpc_atomic_w;
wire mpc_hw_save_srsctl_e;
wire [3:0] /*[3:0]*/ mpc_coptype_m;
wire mpc_wr_guestctl0_m;
wire dec_dsp_valid_m;
wire mpc_vd_m;
wire muldiv_m;
wire mpc_hw_save_status_m;
wire int_pref_negedge;
wire mpc_sdc1_w;
wire [8:0] /*[8:0]*/ mpc_dest_w;
wire ejt_hazard_e;
wire mpc_selcp2to_m;
wire MDU_data_valid_e;
wire raw_fixupi;
wire icc_imiss_i_reg;
wire mpc_atomic_load;
wire mpc_dec_sh_high_sel_m;
wire int_pref_reg;
wire mpc_lsdc1_m;
wire [1:0] /*[1:0]*/ mpc_bussize_m;
wire pf_nosquash;
wire strobe_w;
wire [3:0] /*[3:0]*/ mpc_lsbe_m;
wire isamode_pipe_i;
wire mpc_lsuxc1_m;
wire mpc_deret_m;
wire icc_umipsfifo_null_m;
wire [2:0] /*[2:0]*/ count_hw_save;
wire mpc_sbstrobe_w_all_raw;
wire mpc_stall_m;
wire raw_apsall_e;
wire strobe_noe_w_all;
wire judge_chain;
wire [2:0] /*[2:0]*/ mpc_cp0sr_m;
wire squash_w;
wire isamode_pipe_id;
wire hw_save_srsctl_m;
wire mpc_hw_save_status_e;
wire mpc_cp0sc_m;
wire mpc_balign_m;
wire [1:0] /*[1:0]*/ lda15_8sel_m;
wire qual_umipsri_g_e;
wire mpc_pref_w;
wire mpc_wr_guestctl2_m;
wire hw_load_srsctl_m;
wire sel_cp0_w;
wire hold_invalid;
wire mpc_iret_ret_start;
wire mpc_hw_save_done;
wire get_saved_sp;
wire mpc_atpro_w;
wire mpc_atepi_w;
wire hold_int_pref;
wire mpc_atomic_load_e;
wire stall_ie;
wire [1:0] /*[1:0]*/ lda31_24sel_m;
wire mpc_annulds_e;
wire mpc_lsuxc1_e;
wire mpc_wr_status_m;
wire pstrobe_w_all;
wire mpc_stall_ie;
wire mpc_fixup_m;
wire strobe_e_pm;
wire dsp_stall_e;
wire [4:0] /*[4:0]*/ mpc_shamt_e;
wire exclused_from_strobe_iae;
wire hazard_stall_hb_ie;
wire mpc_iret_e;
wire mpc_umips_defivasel_e;
wire mpc_aselwr_e;
wire see_at_pro;
wire xdcb_m;
wire mpc_selcp0_m;
wire wr_view_ipl_e;
wire mpc_bds_m;
wire [5:0] /*[5:0]*/ dest_w_tmp;
wire mpc_wr_intctl_m;
wire mpc_irval_w;
wire strobe_m_pm;
wire ldst_m;
wire hw_load_srsctl_w;
wire stall_m;
wire signa_m;
wire wsquash_m;
wire cnd_neq_en;
wire MDU_data_val_e;
wire signed_ld_m;
wire mpc_iret_on_e_reg;
wire isamode_id;
wire continue_squash_i;
// END Wire declarations made by MVP


	wire [`M14K_IE_RANGE]   ie_pipe_in, ie_pipe_out;
	mvp_cregister_wide #(51) _ie_pipe_out_50_0_(ie_pipe_out[`M14K_IE_RANGE],gscanenable, mpc_run_ie, gclk, ie_pipe_in);
	assign mpc_nonseq_ep = 1'b0;
	assign mpc_squash_i_qual = 1'b0;

	mvp_cregister #(1) _mpc_atomic_m(mpc_atomic_m,mpc_run_ie, gclk, mpc_atomic_e);
	mvp_cregister #(1) _mpc_atomic_w(mpc_atomic_w,mpc_run_m, gclk, mpc_atomic_m);
	mvp_cregister #(1) _mpc_atomic_store_w(mpc_atomic_store_w,mpc_run_m, gclk, mpc_atomic_w);
	mvp_cregister #(1) _mpc_atomic_clrorset_m(mpc_atomic_clrorset_m,mpc_run_ie, gclk, mpc_atomic_clrorset_e);
	mvp_cregister #(1) _mpc_atomic_clrorset_w(mpc_atomic_clrorset_w,mpc_run_m, gclk, mpc_atomic_clrorset_m);
        mvp_cregister #(3) _mpc_atomic_bit_dest_m_2_0_(mpc_atomic_bit_dest_m[2:0],mpc_run_ie, gclk, mpc_atomic_bit_dest_e);
        mvp_cregister #(3) _mpc_atomic_bit_dest_w_2_0_(mpc_atomic_bit_dest_w[2:0],mpc_run_m, gclk, mpc_atomic_bit_dest_m);

	wire [`M14K_M_RANGE] 	m_pipe_in, m_pipe_out;

	mvp_cregister_wide #(47) _m_pipe_out_46_0_(m_pipe_out[`M14K_M_RANGE],gscanenable, mpc_run_m, gclk, m_pipe_in);
	mvp_cregister #(1) _squash_e_trace(squash_e_trace,mpc_run_m, gclk, mpc_squash_i_trace);

 	wire [`M14K_W_RANGE] 	w_pipe_in, w_pipe_out;
	mvp_cregister_wide #(6) _w_pipe_out_5_0_(w_pipe_out[`M14K_W_RANGE],gscanenable, mpc_run_w, gclk, w_pipe_in);

	assign mpc_umips_mirrordefivasel_e=1'b0;
	assign mpc_umipsfifosupport_i=1'b0;
  

        assign raw_icopaccess_e = (pbus_type_e == 3'h5) || (pbus_type_e == 3'h7);
	assign icopaccess_e = (mpc_busty_e == 3'h5) || (mpc_busty_e == 3'h7);

	mvp_register #(1) _raw_icopaccess_m(raw_icopaccess_m, gclk, icopaccess_e);

	assign mpc_icop_m = ~mpc_run_m ? icopaccess_md : raw_icopaccess_m;
	assign mpc_iccop_m = mpc_fixup_m ? icopaccess_md : raw_icopaccess_m;

	mvp_register #(1) _icopaccess_md(icopaccess_md, gclk, mpc_icop_m);
   
	assign ie_pipe_in[`M14K_IE_CACHE] = coptype_e;
	assign raw_coptype_m [3:0] = ie_pipe_out[`M14K_IE_CACHE];
	
	assign mpc_coptype_m [3:0] = mpc_fixup_m ? coptype_md : raw_coptype_m;

	mvp_register #(4) _coptype_md_3_0_(coptype_md[3:0], gclk, mpc_coptype_m);

	assign mpc_ll1_m = mpc_ll_m && mpc_run_m;

	assign mpc_ll_e = raw_ll_e && mpc_irval_e;
		
	assign ie_pipe_in[`M14K_IE_LL] = mpc_ll_e;
	assign mpc_ll_m = ie_pipe_out[`M14K_IE_LL];

        // Store conditional
	assign mpc_sc_e = mpc_run_m ? new_sc_e : oldsc_e;
	mvp_register #(1) _oldsc_e(oldsc_e, gclk, mpc_sc_e);
	
	assign ie_pipe_in[`M14K_IE_SC] = mpc_sc_e;
	assign mpc_sc_m = ie_pipe_out[`M14K_IE_SC];
	

        //Bus mpc_busty_e[2:0]: Bus operation type
        assign mpc_busty_e [2:0] = ~mpc_run_m ? busty_ed & {3{~mpc_exc_m}} :
			(control_en_e) ?        pbus_type_e : 3'b0;

        assign mpc_idx_cop_e = ~mpc_run_m ? idx_cop_ed & ~mpc_exc_m :
			(control_en_e) ?        p_idx_cop_e : 1'b0;
        mvp_register #(1) _idx_cop_ed(idx_cop_ed, gclk, mpc_idx_cop_e);

	assign mpc_busty_raw_e [2:0] =  ~mpc_run_m ? busty_ed : 
			    (mpc_ctlen_noe_e) ? pbus_type_e : 3'b0;

        mvp_register #(3) _busty_ed_2_0_(busty_ed[2:0], gclk, mpc_busty_e);
	assign mpc_atomic_load = ~mpc_run_m ? atomic_load_e_reg & ~mpc_exc_m :
			(control_en_e) ? mpc_atomic_e : 1'b0;

	assign mpc_atomic_load_e = ~mpc_run_m ? atomic_load_e_reg :
			(mpc_ctlen_noe_e) ? mpc_atomic_e : 1'b0;
	mvp_register #(1) _atomic_load_e_reg(atomic_load_e_reg, gclk, mpc_atomic_load);


	// r0: register zero
	assign r0 =	dest_e[4:0] == 5'h0;	

	// Bus dest_m[5:0]: destination register
	assign ie_pipe_in[`M14K_IE_DEST] = dest_e;
	assign dest_m [5:0] = ie_pipe_out[`M14K_IE_DEST];

	// Bus mpc_dest_w[5:0]: destination register
	assign m_pipe_in[`M14K_M_DEST] = dest_m;

	assign dest_w_tmp [5:0] = m_pipe_out[`M14K_M_DEST];
	mvp_cregister_wide #(4) _css_for_mdu_3_0_(css_for_mdu[3:0],gscanenable, mpc_mulgpr_e, gclk, 
		cpz_gm_e ? cpz_g_srsctl_css : cpz_srsctl_css);
        assign mpc_dest_w [8:0] = mpc_wr_sp2gpr ? {cpz_gm_m ? cpz_g_srsctl_css : cpz_srsctl_css, 5'd29} :
			mdu_alive_gpr_a ? {css_for_mdu, mdu_dest_w} :
                           { dest_w_tmp[5] ? (cpz_gm_w ? cpz_g_srsctl_pss : cpz_srsctl_pss) : 
			(cpz_gm_w ? cpz_g_srsctl_css : cpz_srsctl_css), dest_w_tmp[4:0]};

	assign pss_eq_css = cpz_gm_e ? (cpz_g_srsctl_pss == cpz_g_srsctl_css) : 
		(cpz_srsctl_pss == cpz_srsctl_css);

	assign s_d_eqall = (src_b_e[5] == dest_m[5]) | pss_eq_css;
	assign s_d_eqall_0 = ~dest_m[5] | pss_eq_css;
	assign s_d_eqall_1 = dest_m[5] | pss_eq_css;

	assign s_d_eqwr = (src_b_e[5] == dest_w_tmp[5]) | pss_eq_css;
	assign s_d_eqwr_0 = ~dest_w_tmp[5] | pss_eq_css;
	assign s_d_eqwr_1 = dest_w_tmp[5] | pss_eq_css;

	// apswr_e: bypass MEM phase result for A operand
	assign apswr_raw_e =	vd_w & (src_a_e == mpc_dest_w[4:0]) & s_d_eqwr;	
	assign apswr_e = (mdu_alive_gpr_a & (src_a_e[4:0] == mdu_dest_w[4:0])
                | mf_bps_a_m2 | hold_mf_m2_w & (src_a_e == hold_dest_m2_w)) 
		& (~src_b_e[5] | pss_eq_css) | apswr_raw_e;
	assign mf_bps_a_m2 = mdu_mf_m2 & (src_a_e[4:0] == mdu_dest_m2);

	assign mpc_mf_m2_w = mdu_mf_m2 | hold_mf_m2_w;
	mvp_register #(1) _hold_mf_m2_w(hold_mf_m2_w,gclk, mpc_mf_m2_w & ~(mfhilo_w & mpc_rfwrite_w) & ~greset & ~mdu_nullify_m2);
	mvp_cregister_wide #(5) _hold_dest_m2_w_4_0_(hold_dest_m2_w[4:0],gscanenable, mdu_mf_m2, gclk, mdu_dest_m2);

	// BPsWr: bypass MEM phase result for B operand
	assign bpswr_e_tmp = vd_w & (src_b_e[4:0] == mpc_dest_w[4:0]);
	mvp_mux2 #(1) _bpswr_raw_e(bpswr_raw_e,src_b_e[5], bpswr_e_tmp & s_d_eqwr_0, bpswr_e_tmp & s_d_eqwr_1);
	assign hw_bpswr_e = (mpc_hw_save_done | mpc_hw_load_done & ~mpc_chain_take 
		       | cpz_iret_chain_reg) & (src_b_e[4:0] == 5'd29) & (!src_b_e[5] | pss_eq_css);	
	assign bpswr_e = (mdu_alive_gpr_a & (src_b_e[4:0] == mdu_dest_w[4:0]) 
		| mf_bps_b_m2 | hold_mf_m2_w & (src_b_e[4:0] == hold_dest_m2_w)) 
		& (~src_b_e[5] | pss_eq_css) | bpswr_raw_e | hw_bpswr_e;
	assign mf_bps_b_m2 = mdu_mf_m2 & (src_b_e[4:0] == mdu_dest_m2);

	// APsAll: bypass ALU phase result for A operand
	assign raw_apsall_e =	vd_m & (src_a_e == dest_m[4:0]) & s_d_eqall & (~mfhilo_m & edp_dsp_present_xx | ~edp_dsp_present_xx); 
	assign hw_apsall_e = (mpc_hw_save_srsctl_m | mpc_hw_save_done | mpc_hw_load_srsctl_m 
			| mpc_hw_load_done & ~mpc_chain_take 
		       | cpz_iret_chain_reg) & (src_a_e == 5'd29) & (!src_b_e[5] | pss_eq_css);	
	assign apsall_e = raw_apsall_e | hw_apsall_e;

	// BPsAll: bypass ALU phase result for B operand
	assign hw_bpsall_e = (mpc_hw_save_srsctl_m | mpc_hw_load_srsctl_m ) & 
			(src_b_e[4:0] == 5'd29) & (!src_b_e[5] | pss_eq_css);	
	assign raw_bpsall_e = vd_m & (src_b_e[4:0] == dest_m[4:0]) & (~mfhilo_m & edp_dsp_present_xx | ~edp_dsp_present_xx);
	assign bpsall_e_tmp = raw_bpsall_e | hw_bpsall_e;
	mvp_mux2 #(1) _bpsall_e(bpsall_e,src_b_e[5], bpsall_e_tmp & s_d_eqall_0, bpsall_e_tmp & s_d_eqall_1);

	// RF Init: generator based RF modules initialize entry 0 of each register set
	//after the falling edge of reset
	mvp_cregister_wide #(5) _rfinit_count_4_0_(rfinit_count[4:0],gscanenable, greset | ~rfinit_count[4], gclk,
					   greset ? 5'b0 : (rfinit_count + 5'b1));
	assign rfinit_stall_e = ~rfinit_count[4] && mpc_irval_e;

        // Prevent L/S, $op/synci, or other cp0 op from issuing immediately after a 
        // TLBxx operation, icacheop, or synci.  Prevent deadlock conditions
        assign tlbstall_e = (mmu_tlbbusy || raw_icopaccess_m) && 
		     (mpc_ldst_e || cp0_e || g_cp0_e || raw_icopaccess_e) && mpc_irval_e;

	assign bubble_e = prod_cons_stall_e | tlbstall_e | rfinit_stall_e |
		   ejt_hazard_e;

	// ProdConsHaz: Source Reg is dependent on load/muldiv immediately preceding it
	assign prod_cons_stall_req = mpc_irval_e &
			    ((apsall_e & use_src_a_e & ~icc_pcrel_e) | (bpsall_e & use_src_b_e));   
	assign load_to_use_stall_e = prod_cons_stall_req & ldst_m; 
	assign mdu_stall_e     = prod_cons_stall_req & muldiv_m & ~edp_dsp_present_xx |
			edp_dsp_present_xx & mpc_irval_e & (~src_b_e[5] | pss_eq_css) & (
			use_src_a_e & ~icc_pcrel_e & 
			((mdu_alive_gpr_m1 | mdu_mf_m1) & (src_a_e == mdu_dest_m1) | 
			mdu_alive_gpr_m2 & (src_a_e == mdu_dest_m2) | 
			mdu_alive_gpr_m3 & (src_a_e == mdu_dest_m3)) |
			use_src_b_e & 
			((mdu_alive_gpr_m1 | mdu_mf_m1) & (src_b_e[4:0] == mdu_dest_m1) | 
			mdu_alive_gpr_m2 & (src_b_e[4:0] == mdu_dest_m2) | 
			mdu_alive_gpr_m3 & (src_b_e[4:0] == mdu_dest_m3))); 
	assign mcp0_stall_e	= prod_cons_stall_req & (mpc_cp0move_m | mpc_g_cp0move_m);
	assign cp2_cp1_mv_stall_e	= prod_cons_stall_req & (cp2_moveto_m | (cp2_movefrom_m & ~mr0d_m) | cp1_moveto_m | (cp1_movefrom_m & ~mr0d_m));
	assign prod_cons_stall_e = load_to_use_stall_e | mdu_stall_e | mcp0_stall_e | cp2_cp1_mv_stall_e;
	assign mpc_ltu_e = load_to_use_stall_e;
	assign mpc_mcp0stall_e = mcp0_stall_e;
	assign mpc_bubble_e = bubble_e;

	// ejt_hazard_e: Hazard on data value comparators.  Stall store in the E-stage
	assign ejt_hazard_e = ejt_stall_st_e & (mpc_ldst_e & ~load_e) & mpc_irval_e;

		       
	assign md_busy_stall_e = mdu_busy && mpc_irval_e && muldiv_e && (!mfhilo_e || edp_dsp_present_xx);

	mvp_cregister #(1) _mfhilo_m(mfhilo_m,mpc_run_m, gclk, mfhilo_e);
	mvp_cregister #(1) _mfhilo_w(mfhilo_w,mpc_run_w, gclk, mfhilo_m & mpc_run_m);
	assign mulgpr_busy = mdu_alive_gpr_m1 | mdu_alive_gpr_m2 | mdu_alive_gpr_m3;
	assign md_writegpr_stall_e = mulgpr_busy & vd_e & ~r0 & ~mpc_mulgpr_e & mpc_irval_e;

	assign mpc_lsdc1_e = (lsdc1_e | lsdxc1_e | lsuxc1_e) & mpc_irval_e & ~mpc_lsdc1_m;
	assign mpc_lsuxc1_e = lsuxc1_e & mpc_irval_e & ~mpc_lsdc1_m;
	// mpc_updateepc_e:  Capture a new EPC
	assign mpc_updateepc_e = ~bds_e & ~icc_macro_e & ~mpc_atomic_e & ~mpc_lsdc1_e;
	assign mpc_nomacroepc_e = ~bds_e & ~mpc_atomic_e & ~mpc_lsdc1_e;

	// mpc_bds_m: Instn in M has a branch delay slot
	assign ie_pipe_in[`M14K_IE_BDS] = bds_e || (mpc_bds_m && (icc_macro_e || mpc_lsdc1_e));
	assign mpc_bds_m = ie_pipe_out[`M14K_IE_BDS];

	assign kill_cmov_e = mpc_cmov_e & (edp_cndeq_e ^ cmov_type_e) |
			mpc_movci_e & ~cp1_btaken;
	
	// mvd_e: M-stage Valid Dest
	assign mvd_e =	vd_e && !r0 && control_en_e && !kill_cmov_e && (!mpc_mulgpr_e || ~edp_dsp_present_xx);	
	assign mr0d_e = vd_e && r0 && control_en_e && !kill_cmov_e;	

	assign m_pipe_in[`M14K_M_VD] = mvd_e ;
	assign pvd_m = m_pipe_out[`M14K_M_VD];

        mvp_cregister #(1) _mr0d_m(mr0d_m,mpc_run_m, gclk, mr0d_e);
        mvp_cregister #(1) _mr0d_cp2cp1_m(mr0d_cp2cp1_m,mpc_run_ie, gclk, mr0d_e);
	assign wr0d_w = mr0d_m & mpc_run_m;
	mvp_cregister #(1) _pr0d_w(pr0d_w,mpc_run_w, gclk, wr0d_w);

	assign wpvd_m = pvd_m && mpc_run_m;
	assign w_pipe_in[`M14K_W_PVD] = wpvd_m;
	assign pvd_w = w_pipe_out[`M14K_W_PVD];

	assign ie_pipe_in[`M14K_IE_LDST] = mpc_ldst_e;
	assign ldst_m = ie_pipe_out[`M14K_IE_LDST];

	assign ie_pipe_in[`M14K_IE_MULDIV] = muldiv_e || xfc2_e || xfc1_e;
	assign muldiv_m = ie_pipe_out[`M14K_IE_MULDIV];

	assign m_pipe_in[`M14K_M_MULDIV] = muldiv_m;
	assign mpc_muldiv_w = m_pipe_out[`M14K_M_MULDIV];

	assign ie_pipe_in[`M14K_IE_WR_STATUS] = wr_status_e;
	assign mpc_wr_status_m = ie_pipe_out[`M14K_IE_WR_STATUS];

        assign wr_status_e = ~load_e & (cp0_r_e == 5'd12) & (cp0_sr_e[1:0] == 2'h0);
	
	assign ie_pipe_in[`M14K_IE_WR_INTCTL] = wr_intctl_e;
	assign mpc_wr_intctl_m = ie_pipe_out[`M14K_IE_WR_INTCTL];

        assign wr_intctl_e = ~load_e & (cp0_r_e == 5'd12) & (cp0_sr_e[1:0] == 2'h1);


        assign wr_guestctl0_e = ~load_e & (cp0_r_e == 5'd12) & (cp0_sr_e[2:0] == 3'h6);
        mvp_cregister #(1) _mpc_wr_guestctl0_m(mpc_wr_guestctl0_m,mpc_run_ie, gclk, wr_guestctl0_e);

        assign wr_guestctl2_e = ~load_e & (cp0_r_e == 5'd10) & (cp0_sr_e[2:0] == 3'h5);
        mvp_cregister #(1) _mpc_wr_guestctl2_m(mpc_wr_guestctl2_m,mpc_run_ie, gclk, wr_guestctl2_e);

        assign wr_view_ipl_e = ~load_e & (cp0_r_e == 5'd12) & (cp0_sr_e[2:0] == 3'h4);
        mvp_cregister #(1) _mpc_wr_view_ipl_m(mpc_wr_view_ipl_m,mpc_run_ie, gclk, wr_view_ipl_e);
	
	assign ie_pipe_in[`M14K_IE_LOAD] = load_e;
	assign mpc_load_m = ie_pipe_out[`M14K_IE_LOAD];

	assign m_pipe_in[`M14K_M_LOADIN] = loadin_e;
	assign loadin_m = m_pipe_out[`M14K_M_LOADIN];

	assign loadin_e = (pbus_type_e == 3'h1);
			 
	// Bus mpc_cp0r_m[4:0]: coprocessor zero register specifier
	assign ie_pipe_in[`M14K_IE_CPR] = cp0_r_e;
	assign mpc_cp0r_m [4:0] = ie_pipe_out[`M14K_IE_CPR];	

	// Bus mpc_cp0sr_m: coprocessor zero shadow register specifier
	assign ie_pipe_in[`M14K_IE_CPSR] = cp0_sr_e;
	assign mpc_cp0sr_m [2:0] = ie_pipe_out[`M14K_IE_CPSR];

	// mpc_cp0move_m: coprocessor zero move to/from cp register
	assign m_pipe_in[`M14K_M_CPMV] = cp0_mv_e;
	assign mpc_cp0move_m = m_pipe_out[`M14K_M_CPMV];

	assign cp0_mv_e = p_cp0_mv_e && control_en_e;

	assign g_cp0_mv_e = p_g_cp0_mv_e && control_en_e;
	mvp_cregister #(1) _mpc_g_cp0move_m(mpc_g_cp0move_m,mpc_run_m, gclk, g_cp0_mv_e);
	
	// mpc_cp0sc_m: coprocessor zero set/clear bit in register
	assign m_pipe_in[`M14K_M_CPSC] = cp0_sc_e;
	assign mpc_cp0sc_m = m_pipe_out[`M14K_M_CPSC];

	assign cp0_sc_e = p_cp0_sc_e && control_en_e;
	
	// mpc_cp0diei_m: coprocessor zero DI/EI
	assign m_pipe_in[`M14K_M_CPDIEI] = cp0_diei_e;
	assign mpc_cp0diei_m = m_pipe_out[`M14K_M_CPDIEI];

	assign cp0_diei_e = p_cp0_diei_e && control_en_e;

	mvp_cregister #(1) _mpc_ctc1_fr0_m(mpc_ctc1_fr0_m,mpc_run_m, gclk, ctc1_fr0_e & control_en_e);
	mvp_cregister #(1) _mpc_ctc1_fr1_m(mpc_ctc1_fr1_m,mpc_run_m, gclk, ctc1_fr1_e & control_en_e);
	mvp_cregister #(1) _mpc_cfc1_fr_m(mpc_cfc1_fr_m,mpc_run_m, gclk, cfc1_fr_e & control_en_e);
	
	assign mpc_eretval_e = (p_eret_e | p_iret_e & (cpz_gm_e ? (~cpz_g_at_epi_en | cpz_g_erl | cpz_g_bev) 
		: (~cpz_at_epi_en | cpz_erl | cpz_bev))) && mpc_irval_e;

	assign mpc_eret_e = (p_eret_e | p_iret_e & (cpz_gm_e ? (~cpz_g_at_epi_en | cpz_g_erl | cpz_g_bev) 
		: (~cpz_at_epi_en | cpz_erl | cpz_bev))) && control_en_e;

	assign m_pipe_in[`M14K_M_ERET] = mpc_eret_e;
	assign mpc_eret_m = m_pipe_out[`M14K_M_ERET];
	mvp_cregister #(1) _mpc_eret_null_m(mpc_eret_null_m,mpc_run_m, gclk, (p_eret_e | p_iret_e & 
		(cpz_gm_e ? (~cpz_g_at_epi_en | cpz_g_erl | cpz_g_bev) : 
		(~cpz_at_epi_en | cpz_erl | cpz_bev))) & ~mpc_exc_e);
	
        assign mpc_iretval_e = p_iret_e & mpc_irval_e & (cpz_gm_e ? (cpz_g_at_epi_en & ~cpz_g_erl & ~cpz_g_bev) 
		: (cpz_at_epi_en & ~cpz_erl & ~cpz_bev));
        assign mpc_iret_e = p_iret_e & control_en_e & (cpz_gm_e ? (cpz_g_at_epi_en & ~cpz_g_erl & ~cpz_g_bev) 
		: (cpz_at_epi_en & ~cpz_erl & ~cpz_bev));
        mvp_cregister #(1) _mpc_iret_m(mpc_iret_m,mpc_run_m, gclk, mpc_iret_e);

	mvp_register #(1) _mpc_hw_load_ed(mpc_hw_load_ed, gclk, mpc_hw_load_epc_e | mpc_hw_load_srsctl_e | mpc_hw_load_status_e);
	assign mpc_hw_load_endpulse = ~(mpc_hw_load_epc_e | mpc_hw_load_srsctl_e | mpc_hw_load_status_e) & mpc_hw_load_ed;
	mvp_cregister #(1) _mpc_iret_on_e_reg(mpc_iret_on_e_reg,greset | mpc_iretval_e | mpc_hw_load_endpulse, gclk, ~greset & mpc_iretval_e & ~mpc_hw_load_endpulse);
	assign mpc_ireton_e = (mpc_iret_on_e_reg | mpc_iretval_e) & ~mpc_hw_load_endpulse;

	assign mpc_ret_e = (p_eret_e | p_iret_e & (cpz_gm_e ? (~cpz_g_at_epi_en | cpz_g_erl | cpz_g_bev) : 
		(~cpz_at_epi_en | cpz_erl | cpz_bev)) | p_deret_e) & mpc_irval_e & ~mpc_int_pref_phase1;
	assign mpc_rethazard_e = (p_eret_e | p_iret_e | p_deret_e) & mpc_irval_e & ~mpc_int_pref_phase1;

	assign m_pipe_in[`M14K_M_RET] = mpc_rethazard_e;
	assign mpc_ret_m = m_pipe_out[`M14K_M_RET];
	assign mpc_ret_e_ndg =   mpc_chain_vec && mpc_run_ie
			|| mpc_epi_vec && mpc_hw_load_srsctl_e  || mpc_eretval_e;

	assign mpc_deretval_e = p_deret_e && mpc_irval_e;
	assign mpc_deret_e = p_deret_e && control_en_e;
	assign m_pipe_in[`M14K_M_DERET] = mpc_deret_e;
	assign mpc_deret_m = m_pipe_out[`M14K_M_DERET];

	assign m_pipe_in[`M14K_M_CP0] = (cp0_e | g_cp0_e) & control_en_e;
	assign qual_cp0_m = m_pipe_out[`M14K_M_CP0];

	assign hazard_stall_ret_ie = mpc_rethazard_e & ~mpc_ret_m | mpc_eret_m;

   	assign hazard_stall_hb_ie = jreg_hb_e & qual_cp0_m;

	assign hazard_stall_ie = hazard_stall_hb_ie | hazard_stall_ret_ie;

	assign new_cp0_wait_e = p_wait_e && control_en_e;
	
	assign m_pipe_in[`M14K_M_NEWCPW] = new_cp0_wait_e;
	assign new_cp0_wait_m = m_pipe_out[`M14K_M_NEWCPW];

	assign cp0_wait_m = (new_cp0_wait_m | mpc_wait_w) & ~mpc_exc_m & ~cpz_int_excl_ie_e 
		& ~cpz_g_int_excl_ie_e & ~ej_fdc_int;

	assign mpc_wait_m = cp0_wait_m;
	assign m_pipe_in[`M14K_M_CPW] = cp0_wait_m;
	assign mpc_wait_w = m_pipe_out[`M14K_M_CPW];
	
	assign vd_m =	pvd_m & ~mpc_pexc_m;	

	mvp_cregister #(1) _mpc_vd_m(mpc_vd_m,mpc_run_ie, gclk, vd_e && !kill_cmov_e);

	assign vd_w =	pvd_w & ~mpc_pexc_w;	

	//mpc_rfwrite_w: Register file write enable
        assign mpc_rfwrite_w = (pvd_w && !mpc_exc_w && mpc_run_w) | wr_sp2gpr_strobe | mdu_rfwrite_w;
        assign mpc_rfrd0write_w = (pr0d_w && !mpc_exc_w && mpc_run_w) | wr_sp2gpr_strobe;


	assign annul_ds_i = (br_likely_e && mpc_irval_e && !mpc_eqcond_e) || 
		      (mpc_jreg_e && icc_nobds_e) || 
		      (mpc_br16_e && icc_nobds_e && mpc_eqcond_e); 

	
	assign mpc_compact_e = (mpc_jreg_e || eqcond_e) && icc_nobds_e;
	
	assign mpc_fixupd = dcc_fixup_w;
	// include auto-prologue/epilogue control to fixupi for not stall pipeline during iap/iae
        mvp_register #(1) _raw_fixupi(raw_fixupi, gclk, (icc_imiss_i && !(at_pro_seq_i || at_epi_seq_i) && 
		!(pf_nosquash && (!mpc_auexc_x || cpz_at_pro_start_val || cpz_g_at_pro_start_val) 
		&& !see_at_pro && !see_auexc) && ((mpc_run_ie && !mpc_atomic_e && !mpc_lsdc1_e) 
		|| mpc_fixupi)) && !greset);
        mvp_register #(1) _mpc_fixupi_wascall(mpc_fixupi_wascall, gclk, (icc_imiss_i && !(at_pro_seq_i || at_epi_seq_i) && 
		!(pf_nosquash && (!mpc_auexc_x || cpz_at_pro_start_val || cpz_g_at_pro_start_val) 
		&& !see_at_pro && !see_auexc) && ((mpc_run_ie && ~mpc_atomic_e) 
		|| mpc_fixupi_wascall)) && !greset);

	// also not stall pipeline during interrupt prefetch before exception priority is done
	assign pf_nosquash = pf_phase1_nosquash_i;
	mvp_register #(1) _pf_nosquash_reg(pf_nosquash_reg, gclk, pf_nosquash);
	assign pf_nosquash_done = pf_nosquash_reg & ~pf_nosquash;
	assign see_at_pro = at_pro_seq_i | hold_see_at_pro;
	mvp_cregister #(1) _see_auexc(see_auexc,mpc_qual_auexc_x | greset | pf_nosquash_done, gclk, 
		mpc_qual_auexc_x & pf_nosquash & ~(cpz_at_pro_start_val | cpz_g_at_pro_start_val));
	mvp_register #(1) _hold_see_at_pro(hold_see_at_pro, gclk, see_at_pro & pf_nosquash);

	// if seen icc_imiss_i at the last cycle of iap/iae, force fixupi at the next cycle
	assign mpc_fixupi = raw_fixupi | pro_epi_cont_fixupi;
	assign pro_epi_cont_fixupi = (at_pro_done_i | at_epi_done_i) & icc_imiss_i_reg;
	mvp_register #(1) _icc_imiss_i_reg(icc_imiss_i_reg, gclk, icc_imiss_i);

	assign mpc_fixup_w = mpc_fixupd;   
	assign mpc_fixup_m = mpc_fixup_w;   

	assign mpc_stall_w = stall_w;
	assign mpc_stall_m = stall_m;
	assign mpc_stall_ie = stall_ie;

	assign stall_w = cp2_fixup_w ||
		cp1_fixup_w || 
		mpc_fixupd || dcc_ev || ejt_pdt_stall_w || (mpc_isachange0_i || mpc_isachange1_i); 
	assign stall_m = cp2_fixup_m || cp1_stall_m ||
		cp1_fixup_m || 
		mdu_stall || mmu_dtmack_m || stall_w || edp_udi_stall_m || dcc_stall_m;

	assign bstall_ie = cp2_stall_e || mpc_fixupi || bubble_e || edp_dsp_stallreq_e || 
		cp1_stall_e || cp1_fixup_i || cop1_s_stall_e ||
		MDU_stallreq_e || md_writegpr_stall_e ||
		md_busy_stall_e || dsp_stall_e || mdu_stall_issue_xx || 
		    cpz_rslip_e ||
		    cp0_wait_m || mpc_wait_w || stall_m || mmu_itmack_i_work || icc_stall_i || hazard_stall_ie;

	mvp_register #(1) _mmu_itmack_i_atomic(mmu_itmack_i_atomic, gclk, mpc_atomic_e & mmu_itmack_i);
	assign mmu_itmack_i_work = mmu_itmack_i_atomic | (!mpc_atomic_e & mmu_itmack_i); 
	assign stall_ie = cp2_bstall_e || 
		cp1_bstall_e || 
		bstall_ie || !rf_init_done || dcc_spram_write;


	assign mpc_brrun_ie = !bstall_ie || greset;
	assign mpc_run_i = (!stall_ie && !icc_macro_e && !mpc_atomic_e && !mpc_lsdc1_e) || greset;
	assign mpc_run_ie = !stall_ie || greset;
	assign mpc_run_m = !stall_m || greset;
	assign mpc_run_w = !stall_w || greset;
   
        // Signal MDU that Src operands are valid   
	assign mpc_srcvld_e = !prod_cons_stall_e;

	assign control_en_e = mpc_ctlen_noe_e && !mpc_exc_e;
	assign mpc_ctlen_noe_e = mpc_run_ie && mpc_irval_e;

	assign raw_instn_valid_e = !raw_squash_e && !(icc_umipsri_e && !mpc_sel_hw_e) && !icc_preciseibe_e;
	assign sst_instn_valid_e = !sst_squash_e && !(icc_umipsri_e && !mpc_sel_hw_e && !mpc_pexc_e) 
		&& !(icc_preciseibe_e && !mpc_pexc_e);
	assign raw_dspinstn_valid_e = !raw_squash_e && !icc_preciseibe_e && edp_dsp_present_xx;
	assign instn_valid_e = raw_instn_valid_e && !mpc_pexc_e;
	assign dspinstn_valid_e = raw_dspinstn_valid_e && !mpc_pexc_e;
	assign mpc_irval_e = instn_valid_e && !annul_inst_e && (!mpc_fixupi || hold_valid_e) && !illinstn_e;
	assign mpc_irvalunpred_e = instn_valid_e && !annul_inst_e && (!mpc_fixupi || hold_valid_e);
	assign mpc_irvaldsp_e = dspinstn_valid_e && !annul_inst_e && (!mpc_fixupi || hold_valid_e);

	assign mpc_irval_umipsri_e = !raw_squash_e && !mpc_pexc_e && !annul_inst_e &&
			    !icc_preciseibe_e && (!mpc_fixupi || hold_valid_e);

	assign qual_umipsri_e = !cpz_gm_e && mpc_irval_umipsri_e && (icc_umipsri_e & ~(~cpz_mx & dspver_e)) 
		&& !mpc_sel_hw_e;
	assign qual_umipsri_g_e = cpz_gm_e && mpc_irval_umipsri_e && (icc_umipsri_e & ~(~cpz_g_mx & dspver_e)) 
		&& !mpc_sel_hw_e;
	
	mvp_register #(1) _hold_valid_e(hold_valid_e, gclk, mpc_irval_e && !mpc_run_ie);

	mvp_cregister #(1) _irval_e2m(irval_e2m,mpc_run_ie, gclk, mpc_irval_e & ~mpc_exc_e); 
	assign mpc_irval_m = irval_e2m & ~mpc_pexc_m;

	mvp_register #(1) _mpc_irval_w(mpc_irval_w,gclk, mpc_run_m & mpc_irval_m & ~mpc_exc_m | 
		~mpc_run_w & mpc_irval_w & ~mpc_exc_w);

	assign ie_pipe_in[`M14K_IE_ANNUL] = annul_ds_i;
	assign mpc_annulds_e = ie_pipe_out[`M14K_IE_ANNUL];
	assign annul_inst_e = mpc_annulds_e;

        mvp_register #(1) _mpc_ivaval_i(mpc_ivaval_i, gclk, mpc_ivaval_i && !mpc_run_ie || !icc_imiss_i);
	mvp_register #(1) _mpc_newiaddr_raw(mpc_newiaddr_raw, gclk,(mpc_run_ie || mpc_fixupi) && !icc_imiss_i);
	mvp_register #(1) _mpc_newiaddr_raw_reg(mpc_newiaddr_raw_reg, gclk, (mpc_newiaddr_raw || mpc_newiaddr_raw_reg) 
		&& mpc_atomic_e);
	mvp_register #(1) _newiaddr_lsdc1(newiaddr_lsdc1,gclk, mpc_newiaddr && mpc_lsdc1_e && mpc_run_ie);
	mvp_register #(1) _mpc_newiaddr_reg(mpc_newiaddr_reg, gclk, mpc_newiaddr_raw_reg && mpc_run_ie && !icc_imiss_i);
	assign mpc_newiaddr = mpc_newiaddr_raw || mpc_newiaddr_reg || newiaddr_lsdc1;

   
	mvp_register #(1) _hold_squash_i(hold_squash_i, gclk, mpc_squash_i && !mpc_run_ie);
	mvp_register #(1) _mpc_atomic_e_reg(mpc_atomic_e_reg, gclk, mpc_atomic_e);

        assign mpc_squash_i = mpc_eretval_e || mpc_deretval_e || (pend_exc) || 
		hold_squash_i && !(mpc_atomic_e_reg && !mpc_atomic_e)
		|| mpc_iretval_e || mpc_hold_epi_vec || mpc_iret_ret || mpc_chain_vec || 
		(set_pf_phase1_nosquash || set_pf_auexc_nosquash) && hw_save_i || 
		mpc_atomic_e || continue_squash_i || mpc_lsdc1_e;
	assign hw_save_i = hw_save_epc_i | hw_save_status_i | mpc_hw_save_srsctl_i;
	assign continue_squash_i = (at_pro_done_i & mpc_squash_i_reg) | hold_continue_squash_i;
	mvp_register #(1) _mpc_squash_i_reg(mpc_squash_i_reg, gclk, mpc_squash_i & mpc_int_pref & (count_imiss_off == 2'b10) & !greset);
	assign hold_int_pref = hold_pf_phase1_nosquash_i | int_pref_phase2;
	mvp_register #(1) _hold_pref_negedge(hold_pref_negedge,gclk, int_pref_negedge | hold_pref_negedge & icc_imiss_i);
	assign held_pref_negedge = int_pref_negedge | hold_pref_negedge;
	mvp_cregister #(2) _count_imiss_off_1_0_(count_imiss_off[1:0],(imiss_negedge & hold_int_pref) | greset | held_pref_negedge
				| hold_pf_phase1_nosquash_i & ~icc_imiss_i, gclk,
				    greset ? 2'b00 : held_pref_negedge ? 2'b00 : count_imiss_off + 2'b1);
	assign imiss_negedge = ~icc_imiss_i & icc_imiss_i_reg;
	assign int_pref_negedge = ~mpc_int_pref & int_pref_reg;
	mvp_register #(1) _int_pref_reg(int_pref_reg, gclk, mpc_int_pref);
	mvp_register #(1) _hold_continue_squash_i(hold_continue_squash_i, gclk, continue_squash_i & ~mpc_run_ie & !greset);

	//Signal for Trace
	mvp_register #(1) _hold_squash_i_trace(hold_squash_i_trace, gclk, mpc_squash_i_trace && !mpc_run_ie);
	assign mpc_squash_i_trace = mpc_eretval_e || mpc_deretval_e || (pend_exc) || hold_squash_i_trace 
		|| mpc_iretval_e || mpc_hold_epi_vec || mpc_iret_ret || mpc_chain_vec || 
		(cpz_gm_i ? cpz_g_pf : cpz_pf) && hw_save_i;


        assign ie_pipe_in[`M14K_IE_SQUASH] = mpc_squash_i & ~(((cpz_gm_i ? cpz_g_pf : cpz_pf) | held_parerrexc_i) 
		& hw_save_i) & ~at_epi_seq_i & ~continue_squash_i & ~mpc_atomic_e & ~mpc_lsdc1_e;
	assign mpc_continue_squash_i = continue_squash_i;
	mvp_cregister #(1) _continue_squash_e(continue_squash_e,mpc_run_ie, gclk, continue_squash_i & pend_exc);

	assign raw_squash_e = ie_pipe_out[`M14K_IE_SQUASH];
	mvp_cregister #(1) _sst_squash_e(sst_squash_e,mpc_run_ie, gclk, mpc_squash_i & ~(((cpz_gm_i ? cpz_g_pf : cpz_pf) | 
		held_parerrexc_i) & hw_save_i) & ~at_epi_seq_i & ~continue_squash_i & ~mpc_atomic_e & ~mpc_lsdc1_e 
		& ~pend_exc);

	assign squash_e = raw_squash_e || annul_inst_e;

	assign msquash_e = squash_e || (mpc_squash_m && !mpc_run_ie);
	assign m_pipe_in[`M14K_M_SQUASH] = msquash_e;
	assign mpc_squash_m = m_pipe_out[`M14K_M_SQUASH];

	assign wsquash_m = mpc_squash_m || (squash_w && !mpc_run_m);
	assign w_pipe_in[`M14K_W_SQUASH] = wsquash_m;
	assign squash_w = w_pipe_out[`M14K_W_SQUASH];

	mvp_cregister #(1) _mpc_isamode_e(mpc_isamode_e,mpc_run_ie & ~mpc_lsdc1_e, gclk, isamode_pipe_i);

	assign m_pipe_in[`M14K_M_UMIPS] = mpc_isamode_e;
	assign mpc_isamode_m = m_pipe_out[`M14K_M_UMIPS];
	
	assign irvalid_noe_e = raw_instn_valid_e && !mpc_annulds_e && (!mpc_fixupi || hold_valid_noe_e);
	mvp_register #(1) _hold_valid_noe_e(hold_valid_noe_e, gclk, irvalid_noe_e && !mpc_run_ie);

	assign strobe_e_all = mpc_run_ie && irvalid_noe_e;
	assign m_pipe_in[`M14K_M_STROBE_ALL] = strobe_e_all;
	assign strobe_m_all = m_pipe_out[`M14K_M_STROBE_ALL];
	
	assign wprstrobe_m_all = strobe_m_all && mpc_run_m;
	assign w_pipe_in[`M14K_W_STROBE_ALL] = wprstrobe_m_all;
	assign pstrobe_w_all = w_pipe_out[`M14K_W_STROBE_ALL];
	
	assign strobe_noe_w_all = mpc_run_w && pstrobe_w_all;

	mvp_register #(1) _hold_invalid_all(hold_invalid_all, gclk, (hold_invalid_all || strobe_w_all) && mpc_exc_w);
	assign strobe_w_all = strobe_noe_w_all && (!mpc_pexc_w || !hold_invalid_all);
	assign mpc_sbstrobe_w_all_raw  = strobe_w_all && !cpz_dm_w;
	mvp_register #(1) _mpc_sbstrobe_w_all_long(mpc_sbstrobe_w_all_long, gclk,(mpc_sbstrobe_w_all_long | mpc_sbstrobe_w_all_raw ) & icc_umipsfifo_null_w & !greset);
	assign mpc_sbstrobe_w_all = mpc_sbstrobe_w_all_raw | mpc_sbstrobe_w_all_long; 
	assign mpc_sbstrobe_w = mpc_sbstrobe_w_all; 
	assign mpc_sbdstrobe_w = mpc_sbstrobe_w_all_raw;

	assign mpc_mpustrobe_w = strobe_w_all;

	assign strobe_e = mpc_run_ie && irvalid_noe_e && !mpc_atomic_e && !mpc_lsdc1_e;
	assign m_pipe_in[`M14K_M_STROBE] = strobe_e;
	assign strobe_m = m_pipe_out[`M14K_M_STROBE];
	assign strobe_e_pm = mpc_run_ie && irvalid_noe_e && !mpc_atomic_e && !mpc_lsdc1_e && exclused_from_strobe_iap
                                && exclused_from_strobe_iae && exclused_from_strobe_tchain ;
	assign mpc_strobe_e = strobe_e_pm;
	assign m_pipe_in[`M14K_M_STROBE_PM] = strobe_e_pm;
	assign strobe_m_pm = m_pipe_out[`M14K_M_STROBE_PM];
	assign mpc_strobe_m = strobe_m_pm;

	
	assign wprstrobe_m = strobe_m && mpc_run_m;
	assign w_pipe_in[`M14K_W_STROBE] = wprstrobe_m;
	assign pstrobe_w = w_pipe_out[`M14K_W_STROBE];
	assign wprstrobe_m_pm = strobe_m_pm && mpc_run_m;
	assign w_pipe_in[`M14K_W_STROBE_PM] = wprstrobe_m_pm;
	assign pstrobe_w_pm = w_pipe_out[`M14K_W_STROBE_PM];

	assign strobe_noe_w = mpc_run_w && pstrobe_w;
	assign strobe_noe_w_pm = mpc_run_w && pstrobe_w_pm;

	assign mpc_cleard_strobe = strobe_noe_w;

	mvp_register #(1) _hold_invalid(hold_invalid, gclk, (hold_invalid || strobe_w) && mpc_exc_w);
	assign strobe_w = strobe_noe_w && (!mpc_pexc_w || !hold_invalid);
	assign mpc_strobe_w = pstrobe_w_pm;
	assign mpc_sbstrobe_w_raw  = strobe_w && !cpz_dm_w;
	mvp_register #(1) _mpc_sbstrobe_w_long(mpc_sbstrobe_w_long, gclk,(mpc_sbstrobe_w_long | mpc_sbstrobe_w_raw ) & icc_umipsfifo_null_w & !greset);
	mvp_cregister #(1) _icc_umipsfifo_null_e(icc_umipsfifo_null_e,greset | (mpc_run_ie | mpc_fixupi), gclk, icc_umipsfifo_null_i   & ~greset);
	mvp_cregister #(1) _icc_umipsfifo_null_m(icc_umipsfifo_null_m,greset | mpc_run_ie, gclk, icc_umipsfifo_null_e & ~greset);
	mvp_cregister #(1) _icc_umipsfifo_null_w(icc_umipsfifo_null_w,greset | mpc_run_m , gclk, icc_umipsfifo_null_m & ~greset);

	assign mpc_cbstrobe_w = mpc_sbstrobe_w_raw && !mpc_exc_w && !icc_umipsfifo_null_w;

	mvp_cregister #(1) _umips_16bit_needed_e(umips_16bit_needed_e, mpc_run_ie, gclk, icc_umips_16bit_needed);
	assign noseq_16bit_e_valid = umips_16bit_needed_e;
	mvp_cregister #(1) _noseq_16bit_e_valid_m(noseq_16bit_e_valid_m,mpc_run_m, gclk, noseq_16bit_e_valid);

	assign mpc_noseq_16bit_w = noseq_16bit_e_valid_m & mpc_run_w;

 

	mvp_register #(1) _umips_16bit_needed_reg(umips_16bit_needed_reg, gclk, (icc_umips_16bit_needed | umips_16bit_needed_reg) & icc_umipsfifo_null_e);
	assign pd_irvalid_noe_e = raw_instn_valid_e && !mpc_exc_e && !annul_inst_e && (!mpc_fixupi || hold_pd_valid_noe_e) && (!icc_umipsfifo_null_e | (umips_16bit_needed_reg|icc_umips_16bit_needed) & mpc_run_ie); 


	mvp_register #(1) _hold_pd_valid_noe_e(hold_pd_valid_noe_e, gclk, pd_irvalid_noe_e && !mpc_run_ie);

	//whole iap do not need to traced out
	assign exclused_from_strobe_iap =!mpc_hw_save_epc_e && !mpc_hw_save_srsctl_e && 
				  	!mpc_hw_save_status_e && !continue_squash_e; 
	//whole iae or tailchain need to traced out once
	assign exclused_from_strobe_iae = !(mpc_epi_vec && !mpc_hw_load_srsctl_e);
	assign exclused_from_strobe_tchain = !(mpc_chain_take && !mpc_chain_vec && (mpc_hw_load_epc_e || mpc_hw_load_srsctl_e));

	assign restore_valid_str = (pd_irvalid_noe_e && !mpc_atomic_e && !icc_macro_e && !mpc_lsdc1_e 
				&& exclused_from_strobe_iap 
				&& exclused_from_strobe_iae && exclused_from_strobe_tchain )  && squash_e_trace;

	assign clear_valid_str = !(exclused_from_strobe_iap && exclused_from_strobe_iae && exclused_from_strobe_tchain && !mpc_atomic_e && !icc_macro_e && !mpc_lsdc1_e);

	assign m_pipe_in[`M14K_M_PDSTROBE] = mpc_run_ie && pd_irvalid_noe_e && !mpc_atomic_e && !icc_macro_e && !mpc_lsdc1_e 
				&& exclused_from_strobe_iap 
				&& exclused_from_strobe_iae && exclused_from_strobe_tchain ;

	assign strobe_in_chaintake = mpc_chain_take && mpc_pdstrobe_w; 
	mvp_cregister #(1) _tail_chain_first_seen_reg(tail_chain_first_seen_reg, (strobe_in_chaintake || !mpc_chain_take)  || greset, gclk, 
						greset ? 1'b0 :
						strobe_in_chaintake );
	assign mpc_tail_chain_1st_seen = !(tail_chain_first_seen_reg & mpc_chain_take) & strobe_in_chaintake & !mpc_exc_w;
	assign mpc_trace_iap_iae_e = mpc_hw_save_epc_e || mpc_hw_save_srsctl_e || mpc_hw_save_status_e || mpc_epi_vec;


	assign pdstrobe_m = m_pipe_out[`M14K_M_PDSTROBE];

	assign w_pipe_in[`M14K_W_PDSTROBE] = pdstrobe_m && mpc_run_m;
	assign pdstrobe_w = w_pipe_out[`M14K_W_PDSTROBE];

	assign mpc_pdstrobe_w  = mpc_run_w && pdstrobe_w;
        //Trace for macro

        mvp_cregister #(1) _mpc_macro_m(mpc_macro_m,greset | mpc_run_ie, gclk, icc_macro_e & ~greset);
        mvp_cregister #(1) _mpc_macro_w(mpc_macro_w,greset | mpc_run_m , gclk, mpc_macro_m & ~greset);

	mvp_cregister #(1) _mpc_lsdc1_m(mpc_lsdc1_m,greset | mpc_run_ie, gclk, mpc_lsdc1_e & ~greset);
	mvp_cregister #(1) _mpc_lsuxc1_m(mpc_lsuxc1_m,greset | mpc_run_ie, gclk, mpc_lsuxc1_e & ~greset);
	mvp_cregister #(1) _mpc_ldc1_m(mpc_ldc1_m,greset | mpc_run_ie, gclk, mpc_lsdc1_e & load_e & ~greset);
	mvp_cregister #(1) _mpc_lsdc1_w(mpc_lsdc1_w,greset | mpc_run_m, gclk, mpc_lsdc1_m & ~greset);
	mvp_cregister #(1) _mpc_sdc1_w(mpc_sdc1_w,greset | mpc_run_m, gclk, mpc_lsdc1_m & ~mpc_load_m & ~greset);
	mvp_cregister #(1) _mpc_ldc1_w(mpc_ldc1_w,greset | mpc_run_m, gclk, mpc_lsdc1_m & mpc_load_m & ~greset);

	// Perf. monitoring bit for instruction completion
        mvp_register #(1) _mpc_pm_complete(mpc_pm_complete, gclk, strobe_noe_w_pm && !mpc_exc_w && !icc_umipsfifo_null_w && !mpc_macro_w);

        mvp_register #(1) _PM_InstnComplete(PM_InstnComplete,gclk, mpc_pm_complete & ~mpc_wait_w);
   
	assign mpc_aselres_e =	(apsall_e | apswr_e) ^ cpz_rslip_e;

	assign mpc_aselwr_e =	apswr_e & ~apsall_e | hw_apsall_e & (mpc_hw_save_done | mpc_hw_load_done | cpz_iret_chain_reg);	

	assign mpc_bselres_e =	(bpsall_e | bpswr_e) ^ cpz_rslip_e;

	// BSlAll: B bypass mux control - pass write data
	assign mpc_bselall_e = bpsall_e;

	// Select PC as source A
	assign mpc_apcsel_e = mpc_br16_e || mpc_br32_e || icc_pcrel_e;

	// lnk_sel_e: Select link address: JAL/BAL/JALR
	assign ie_pipe_in[`M14K_IE_LNK] = mpc_lnksel_e;
	assign mpc_lnksel_m_x = ie_pipe_out[`M14K_IE_LNK];
	mvp_cregister #(2) _mpc_lnksel_m_countdown_1_0_(mpc_lnksel_m_countdown[1:0],(mpc_run_ie & (mpc_lnksel_m_countdown[1] | mpc_lnksel_m_countdown[0])) | greset, 
						 gclk, 
							(greset ? 2'b11 : mpc_lnksel_m_countdown - 2'b01) );
	assign mpc_lnksel_m = (mpc_lnksel_m_countdown[0] | mpc_lnksel_m_countdown[1]) ? 1'b0 : mpc_lnksel_m_x;

	assign pshift_e [4:0] = ({ 5 { sh_var_e}} & edp_abus_e[4:0]) |
			 ({ 5 { sh_fix_e}} & sh_fix_amt_e[4:0]);

	assign mpc_shamt_e [4:0] = { ((mpc_ldst_e && !load_e) ? st_shamt_e : pshift_e[4:3]) , pshift_e[2:0] };

        // mpc_udisel_m: select UDI output in M stage
        mvp_cregister #(1) _mpc_udisel_m(mpc_udisel_m,mpc_run_ie, gclk, udi_sel_e);
	
	// mpc_alusel_m: select ALU output delayed to phase two
	assign ie_pipe_in[`M14K_IE_ALUSEL] = alu_sel_e;
	assign mpc_alusel_m = ie_pipe_out[`M14K_IE_ALUSEL];

	// slt_sel_m: M-stage select slt muxed output
	assign ie_pipe_in[`M14K_IE_SLTSEL] = slt_sel_e;
	assign slt_sel_m = ie_pipe_out[`M14K_IE_SLTSEL];

	// mpc_udislt_sel_m: selects UDI or SLT output in M-stage 
	assign mpc_udislt_sel_m = slt_sel_m | mpc_udisel_m;

	// pcrel_M: PC relative instruction delayed to M-stage
	assign ie_pipe_in[`M14K_IE_PCREL] = icc_pcrel_e;
	assign mpc_pcrel_m = ie_pipe_out[`M14K_IE_PCREL];

	// mpc_rslip_m: random slip output in M-stage
	mvp_cregister #(1) _mpc_rslip_m(mpc_rslip_m,mpc_run_m, gclk, cpz_rslip_e);

	// mpc_rslip_w: random slip output in A-stage
	assign m_pipe_in[`M14K_M_RSLIP] = mpc_rslip_m;
	assign mpc_rslip_w = m_pipe_out[`M14K_M_RSLIP];

	// Bus mpc_bussize_m[1:0]: load/store data size or coprocessor number
	assign ie_pipe_in[`M14K_IE_BS] = mpc_bussize_e;
	assign mpc_bussize_m [1:0] = ie_pipe_out[`M14K_IE_BS];

	assign ie_pipe_in[`M14K_IE_BUSTY] = mpc_busty_e;
	assign mpc_busty_m [2:0] = ie_pipe_out[`M14K_IE_BUSTY];

	assign ie_pipe_in[`M14K_IE_UNALTYP] = unal_type_e;
	assign unal_type_m = ie_pipe_out[`M14K_IE_UNALTYP];

	assign ie_pipe_in[`M14K_IE_UNAL] = mpc_unal_ref_e;
	assign unal_ref_m = ie_pipe_out[`M14K_IE_UNAL];

	assign mpc_selcp2from_m = mpc_run_m & (cp2_movefrom_m & ~mr0d_cp2cp1_m );
	assign m_pipe_in[`M14K_M_SELCP2FROM] = mpc_selcp2from_m;
	assign raw_selcp2from_w = m_pipe_out[`M14K_M_SELCP2FROM];
	assign mpc_selcp2from_w = ~mdu_alive_gpr_a & raw_selcp2from_w;

	assign mpc_selcp2to_m = mpc_run_m && cp2_moveto_m;

	assign mpc_selcp1from_m = mpc_run_m & (cp1_movefrom_m & ~mr0d_cp2cp1_m );
	mvp_cregister #(1) _raw_selcp1from_w(raw_selcp1from_w,mpc_run_w, gclk, mpc_selcp1from_m);
	assign mpc_selcp1from_w = ~mdu_alive_gpr_a & raw_selcp1from_w;

	assign mpc_selcp1to_m = mpc_run_m && cp1_moveto_m;

	assign mpc_selcp0_m = mpc_fixup_m ? sel_cp0_w : (mpc_cp0move_m || mpc_g_cp0move_m || mpc_sc_m);
	assign m_pipe_in[`M14K_M_SELCP0] = mpc_selcp0_m;
	assign sel_cp0_w = m_pipe_out[`M14K_M_SELCP0];

	assign load_res_m = mpc_fixup_m ? load_res_w : loadin_m;
	assign m_pipe_in[`M14K_M_LOADRES] = load_res_m;
	assign load_res_w = m_pipe_out[`M14K_M_LOADRES];

	mvp_register #(1) _load_res_done(load_res_done, gclk, (load_res_m && 
				     ((load_res_done && !mpc_run_m) || 
				      ((mpc_fixup_m || mpc_run_m) && !dcc_dmiss_m))));
	assign mpc_selcp_m = (mpc_selcp2from_m|mpc_selcp2to_m) || ((mpc_selcp2from_w || mpc_selcp1from_w) && !load_res_m) || mpc_selcp0_m 
		|| (load_res_done && (cp2_fixup_w || cp1_fixup_w) || mpc_selcp1from_m || mpc_selcp1to_m) && !mpc_lsdc1_w;

 	assign mpc_updateldcp_m = (mpc_selcp2from_m || mpc_selcp2to_m || mpc_selcp1from_m || mpc_selcp1to_m || mpc_selcp0_m || load_res_m
		) && (mpc_run_m || mpc_fixup_m || mpc_lsdc1_w);
			  
	assign lwl_m = unal_ref_m && !unal_type_m;
	
	assign dcba_m =	mpc_selcp0_m  || (loadin_m  && (shamt_m[1:0] == 2'h0));
	assign m_pipe_in[`M14K_M_DCBA] = dcba_m;
	assign mpc_dcba_w = m_pipe_out[`M14K_M_DCBA];
   
	assign xdcb_m =	loadin_m && (shamt_m[1:0] == 2'h1) && !lwl_m;

	assign xxdc_m =	loadin_m && (shamt_m[1:0] == 2'h2) && !lwl_m;

	assign xxxd_m =	loadin_m && (shamt_m[1:0] == 2'h3) && !lwl_m;

	assign cbax_m =	loadin_m && lwl_m && (shamt_m[1:0] == 2'h1);	

	assign baxx_m =	loadin_m && lwl_m && (shamt_m[1:0] == 2'h2);

	assign axxx_m =	loadin_m && lwl_m && (shamt_m[1:0] == 2'h3);	       

	assign ie_pipe_in[`M14K_IE_SIGN] = signed_ld_e;
	assign signed_ld_m = ie_pipe_out[`M14K_IE_SIGN];

	// SignA: LB A
	assign signa_m =	 loadin_m && signed_ld_m && (mpc_bussize_m[1:0] == 2'h0) && (shamt_m[1:0] == 2'h0);
	assign m_pipe_in[`M14K_M_SIGNA] = signa_m;
	assign mpc_signa_w = m_pipe_out[`M14K_M_SIGNA];

	// SignB: LB B/LH AB
	assign signb_m =	 loadin_m && signed_ld_m && ((mpc_bussize_m[1:0] == 2'h0) && (shamt_m[1:0] == 2'h1) ||
						(mpc_bussize_m[1:0] == 2'h1) && (shamt_m[1:0] == 2'h0));
	assign m_pipe_in[`M14K_M_SIGNB] = signb_m;
	assign mpc_signb_w = m_pipe_out[`M14K_M_SIGNB];

	// SignC: LB C
	assign signc_m =	 loadin_m && signed_ld_m && (mpc_bussize_m[1:0] == 2'h0) && (shamt_m[1:0] == 2'h2);
	assign m_pipe_in[`M14K_M_SIGNC] = signc_m;
	assign mpc_signc_w = m_pipe_out[`M14K_M_SIGNC];

	// SignD: LB D/ LH CD
	assign signd_m =	 loadin_m && signed_ld_m && ((mpc_bussize_m[1:0] == 2'h0) && (shamt_m[1:0] == 2'h3) ||
						(mpc_bussize_m[1:0] == 2'h1) && (shamt_m[1:0] == 2'h2));
	assign m_pipe_in[`M14K_M_SIGND] = signd_m;
	assign mpc_signd_w = m_pipe_out[`M14K_M_SIGND];

	// BSign: byte B sign extension or data
	assign bsign_m =	 loadin_m && (mpc_bussize_m[1:0] == 2'b0);
	assign m_pipe_in[`M14K_M_BSIGN] = bsign_m;
	assign mpc_bsign_w = m_pipe_out[`M14K_M_BSIGN];

	// CDSign: bytes CD sign extension or data
	assign cdsign_m =	 loadin_m && !(mpc_bussize_m[1]);
	assign m_pipe_in[`M14K_M_CDSIGN] = cdsign_m;
	assign mpc_cdsign_w = m_pipe_out[`M14K_M_CDSIGN];

	// LdA31_24Sel: Selecter for 4 to 1 mux of ld_algn_w[31:24]
	assign lda31_24sel_m [1:0] = (bsign_m | axxx_m) ? 2'd0 :
			 (cdsign_m | baxx_m) ? 2'd1 :
			 (cbax_m) ? 2'd2 : 2'd3;
	assign m_pipe_in[`M14K_M_LDA31] = lda31_24sel_m;
	assign mpc_lda31_24sel_w [1:0] = m_pipe_out[`M14K_M_LDA31];

	// LdA23_16Sel: Selecter for 4 to 1 mux of ld_algn_w[23:16]
	assign lda23_16sel_m [1:0] = (bsign_m | baxx_m) ? 2'd0 :
			 (cdsign_m | cbax_m) ? 2'd1 :
			 (xdcb_m) ? 2'd2 : 2'd3;
	assign m_pipe_in[`M14K_M_LDA23] = lda23_16sel_m;
	assign mpc_lda23_16sel_w [1:0] = m_pipe_out[`M14K_M_LDA23];

	// LdA15_8Sel: Selecter for 4 to 1 mux of ld_algn_w[15:8]
	assign lda15_8sel_m [1:0]  = (bsign_m | cbax_m) ? 2'd0 :
			 (xdcb_m) ? 2'd1 :
			 (xxdc_m) ? 2'd2 : 2'd3;
	assign m_pipe_in[`M14K_M_LDA15] = lda15_8sel_m;
	assign mpc_lda15_8sel_w [1:0] = m_pipe_out[`M14K_M_LDA15];

	// LdA7_0Sel: Selecter for 4 to 1 mux of ld_algn_w[7:0]
	assign lda7_0sel_m [1:0]   = (xdcb_m) ? 2'd0 :
			 (xxdc_m) ? 2'd1 :
			 (xxxd_m) ? 2'd2 : 2'd3;
	assign m_pipe_in[`M14K_M_LDA7] = lda7_0sel_m;
	assign mpc_lda7_0sel_w [1:0] = m_pipe_out[`M14K_M_LDA7];

	// Bus shamt_e[1:0]: Shift amount to align address, st_shamt_e for stores

	assign st_shamt_e [1:0] = edp_stalign_byteoffset_e ^ ({ inv_dyn1, inv_dyn0 });
	assign shamt_e [1:0] =	edp_dva_1_0_e[1:0] ^ ({ inv_dyn1, inv_dyn0 });

	assign ie_pipe_in[`M14K_IE_SHAMT] = shamt_e;
	assign shamt_m [1:0] = ie_pipe_out[`M14K_IE_SHAMT];

	assign ie_pipe_in[`M14K_IE_SIGNED] = signed_e;
	assign mpc_signed_m = ie_pipe_out[`M14K_IE_SIGNED];

	// inv_dyn0: Invert dynamic access - bit 0
	assign inv_dyn0 = (~((cpz_gm_e ? cpz_g_rbigend_e : cpz_rbigend_e) ^ unal_type_e) & mpc_unal_ref_e) 
		| ((cpz_gm_e ? cpz_g_rbigend_e : cpz_rbigend_e) & (mpc_bussize_e == 2'h0));	

	// inv_dyn1: Invert dynamic access - bit 1
	assign inv_dyn1 = (~((cpz_gm_e ? cpz_g_rbigend_e : cpz_rbigend_e) ^ unal_type_e) & mpc_unal_ref_e) 
		| ((cpz_gm_e ? cpz_g_rbigend_e : cpz_rbigend_e) & ~(mpc_bussize_e[1]));	

	// byte_e: Byte number within a word
	assign byte_e [1:0] = (edp_dva_1_0_e ^ {2{cpz_gm_e ? cpz_g_rbigend_e : cpz_rbigend_e}});
	
	// Halfword number
	assign half_e [1:0] = 	((edp_dva_1_0_e[1] ^ (cpz_gm_e ? cpz_g_rbigend_e : cpz_rbigend_e)) ? 2'h2 : 2'h0);

	// mpc_lsbe_m [3:0]: Byte enables for stores
	assign lsbe_e [3:0] = mpc_unal_ref_e ? ( unal_type_e ? (4'hf << byte_e) :
				   ~(4'he << byte_e)) :
		       mpc_bussize_e[1] ? 4'hf :
		       mpc_bussize_e[0] ? (4'h3 << half_e) :
		       (4'h1 << byte_e);
	assign ie_pipe_in[`M14K_IE_LSBE] = lsbe_e;
	assign mpc_lsbe_m [3:0] = ie_pipe_out[`M14K_IE_LSBE];

	assign m_pipe_in[`M14K_M_LSBE] = mpc_lsbe_m;
	assign mpc_be_w [3:0] = m_pipe_out[`M14K_M_LSBE];

	assign ie_pipe_in[`M14K_IE_SELLOG] = sel_logic_e;
	assign mpc_sellogic_m = ie_pipe_out[`M14K_IE_SELLOG];
	
	// asign: sign bit of A operand
	assign asign =	edp_abus_e[31];	

	// sign_cond: Output of sign-only condition mux 
	assign sign_cond =	br_ge ?	~asign : 
			br_lt ?	asign :
	                cp2_bvalid ? cp2_btaken :
	                cp1_bvalid ? cp1_btaken & ~mpc_movci_e:
		        1'b0;
	
	// Condition will be true if edp_cndeq_e == 1
	assign cnd_eq_en = mpc_irval_e  & (br_eq | br_le);

	// Condition will be true if edp_cndeq_e == 0 
	assign cnd_neq_en = mpc_irval_e & (br_ne | (br_gr & ~asign));

	// Condition will be true no matter what CndEq is
	assign eq_cond_noce = mpc_irval_e & ((br_le & asign) | (~cmp_br & sign_cond));

	// Branch condition met
	assign eqcond_e = edp_cndeq_e ? ((cnd_eq_en | eq_cond_noce) & mpc_run_ie) : 
			((cnd_neq_en | eq_cond_noce) & mpc_run_ie);
	assign mpc_eqcond_e = (eqcond_e | edp_dsp_pos_ge32_e & dec_redirect_bposge32_e & mpc_irval_e & mpc_run_ie) 
			& ~mpc_int_pref_phase1;

// edp_iva_e Mux Control
        assign mpc_defivasel_e = ~(mpc_fixupi | icc_macro_e | mpc_auexc_x | mpc_jreg_e | mpc_jimm_e | mpc_ret_e | mpc_lsdc1_e
                            | mpc_int_pref | mpc_cont_pf_phase1 | mpc_chain_vec | mpc_epi_vec | mpc_iret_ret | mpc_atomic_e);
	assign mpc_umips_defivasel_e = ~( !(!icc_imiss_i & (mpc_run_ie | mpc_fixupi)) |
				icc_macro_e | mpc_auexc_x | mpc_jreg_e | mpc_jimm_e | mpc_ret_e | mpc_lsdc1_e |
				mpc_int_pref | mpc_cont_pf_phase1 | mpc_chain_vec | mpc_epi_vec | mpc_iret_ret | mpc_atomic_e);


	assign debugmode_isa = ej_probtrap ? ej_isaondebug_read : ej_rdvec ? ej_rdvec_read[0] : cpz_bootisamode;
	assign setisa_i_cnxt = icc_umipspresent && 
			 ((mpc_ret_e && (cpz_gm_e ? cpz_g_eretisa : cpz_eretisa)) || 
			 (mpc_iret_ret && (cpz_gm_m ? cpz_g_eretisa : cpz_eretisa)) || 
			 (mpc_chain_vec && (cpz_gm_m ? cpz_g_excisamode : cpz_excisamode)) || 
			 (mpc_auexc_x && ~mpc_int_pref && !(mpc_g_auexc_x ? cpz_g_bev : cpz_bev) && 
			!cpz_debugmode_i && (mpc_g_auexc_x ? cpz_g_excisamode : cpz_excisamode)) || 
			 (mpc_auexc_x && ~mpc_int_pref &&  (mpc_g_auexc_x ? cpz_g_bev : cpz_bev) && 
			!cpz_debugmode_i && (mpc_g_auexc_x ? cpz_g_bootisamode : cpz_bootisamode)) || 
			 (hold_intpref_done && (cpz_gm_i ? !cpz_g_bev && cpz_g_excisamode : !cpz_bev && cpz_excisamode)) || 
			 (hold_intpref_done &&  (cpz_gm_i ? cpz_g_bev && cpz_g_bootisamode : cpz_bev && cpz_bootisamode)) || 
			 (mpc_auexc_x &&  cpz_debugmode_i && debugmode_isa) ||
			 (greset && cpz_bootisamode) ||
				(icc_umipspresent && ((mpc_jreg_e && edp_abus_e[0]) ||
				(mpc_jalx_e && !mpc_isamode_e))));

	assign hold_intpref_done = mpc_pf_phase2_done | intprefphase2_done_reg;
	mvp_register #(1) _intprefphase2_done_reg(intprefphase2_done_reg, gclk, hold_intpref_done & ~mpc_run_ie);

	mvp_cregister #(1) _setisa_i(setisa_i,mpc_run_ie | isachange1_stall_i, gclk, setisa_i_cnxt);
	assign mpc_excisamode_i = 1'b0;
	assign mpc_isachange0_i  = isachange0_stall_i;
	assign mpc_isachange1_i  = isachange1_stall_i;
	assign isachange1_stall_i = 	~mpc_isamode_i & ((setisa_i_cnxt & ~setisa_i) & (
				(hold_intpref_done && (cpz_gm_i ? !cpz_g_bev && cpz_g_excisamode : !cpz_bev && cpz_excisamode)) |
				(hold_intpref_done && (cpz_gm_i ? cpz_g_bev && cpz_g_bootisamode : cpz_bev && cpz_bootisamode)) |
				(mpc_chain_vec && (cpz_gm_m ? cpz_g_excisamode : cpz_excisamode)))); 
	assign isachange0_stall_i = 	mpc_isamode_i & ((clrisa_i_cnxt & ~clrisa_i) & (
				(hold_intpref_done && (cpz_gm_i ? !cpz_g_bev && cpz_g_excisamode : !cpz_bev && !cpz_excisamode)) | 
				(hold_intpref_done && (cpz_gm_i ? cpz_g_bev && cpz_g_bootisamode : cpz_bev && !cpz_bootisamode)) |
				(mpc_chain_vec && (cpz_gm_m ? cpz_g_excisamode : !cpz_excisamode))));
	
	assign clrisa_i_cnxt = !icc_umipspresent ? 1'b1 : 
			 ((mpc_ret_e && (cpz_gm_e ? !cpz_g_eretisa : !cpz_eretisa)) ||
			 (mpc_iret_ret && (cpz_gm_m ? !cpz_g_eretisa : !cpz_eretisa)) ||
			 (mpc_chain_vec && (cpz_gm_m ? !cpz_g_excisamode : !cpz_excisamode)) || 
			 (mpc_auexc_x && ~mpc_int_pref && !(mpc_g_auexc_x ? cpz_g_bev : cpz_bev) && 
			!cpz_debugmode_i && !(mpc_g_auexc_x ? cpz_g_excisamode : cpz_excisamode)) ||
			 (mpc_auexc_x && ~mpc_int_pref &&  (mpc_g_auexc_x ? cpz_g_bev : cpz_bev) && 
			!cpz_debugmode_i && !(mpc_g_auexc_x ? cpz_g_bootisamode : cpz_bootisamode)) ||
			 (hold_intpref_done && (cpz_gm_i ? !cpz_g_bev && !cpz_g_excisamode : !cpz_bev && !cpz_excisamode)) ||
			 (hold_intpref_done && (cpz_gm_i ? cpz_g_bev && !cpz_g_excisamode : cpz_bev && !cpz_bootisamode)) ||
			 (mpc_auexc_x &&  cpz_debugmode_i && !debugmode_isa) ||
			 (greset && !cpz_bootisamode) ||
			 (icc_umipspresent && ((mpc_jreg_e && icc_nobds_e && !edp_abus_e[0]))));
	mvp_cregister #(1) _clrisa_i(clrisa_i,mpc_run_ie | isachange0_stall_i, gclk, clrisa_i_cnxt);

	assign delay_clrisa_i_cnxt = (mpc_jalx_e && mpc_isamode_e) || (mpc_jreg_e && !edp_abus_e[0] &&
                                                           !icc_nobds_e);

	mvp_cregister #(1) _delay_clrisa_i(delay_clrisa_i,mpc_run_ie && !(icc_macro_e && !icc_macro_jr), gclk, delay_clrisa_i_cnxt);
	

        assign isamode_pipe_i = (setisa_i && !mpc_fixupi || isamode_pipe_id) && 
			 !(clrisa_i && !mpc_fixupi) && 
			 !(delay_clrisa_i && !icc_macro_e && !mpc_fixupi);
        mvp_register #(1) _isamode_pipe_id(isamode_pipe_id, gclk, isamode_pipe_i);
   
   
	assign mpc_isamode_i = (setisa_i || isamode_id) && 
			!clrisa_i && !delay_clrisa_i;
   
	mvp_register #(1) _isamode_id(isamode_id, gclk, mpc_isamode_i);
	
	assign mpc_sequential_e = mpc_defivasel_e && !mpc_eqcond_e;

	assign mpc_nonseq_e_start =  mpc_auexc_x | mpc_jreg_e | mpc_jimm_e | mpc_ret_e | mpc_iret_ret | mpc_eqcond_e | 
		mpc_chain_vec | mpc_int_pref;
	mvp_register #(1) _mpc_nonseq_e_d(mpc_nonseq_e_d, gclk, ~greset & mpc_nonseq_e & ((icc_imiss_i & (mpc_run_ie | mpc_fixupi | mpc_hw_load_e) 
		| (mpc_bds_m & mpc_lsdc1_e))));
	assign mpc_nonseq_e = mpc_nonseq_e_start | mpc_nonseq_e_d;


	mvp_cregister #(1) _alu_sel_m(alu_sel_m,mpc_run_ie, gclk, alu_sel_e & strobe_e);
	mvp_cregister #(1) _mpc_alu_w_pre(mpc_alu_w_pre,mpc_run_m, gclk, alu_sel_m & mpc_run_m & strobe_m);
	mvp_register #(1) _mpc_alu_w(mpc_alu_w, gclk, mpc_alu_w_pre & mpc_run_w & !mpc_exc_w & pstrobe_w);

	assign mpc_dec_nop_w = mpc_rfrd0write_w;

	assign mpc_ld_m = ldst_m & (mpc_busty_m == 1);

	assign mpc_st_m = ldst_m & (mpc_busty_m == 2);

	mvp_cregister #(1) _mpc_pref_m(mpc_pref_m,mpc_run_ie, gclk, pref_e & strobe_e);
	mvp_cregister #(1) _pref_w_pre(pref_w_pre,mpc_run_m, gclk, mpc_pref_m & mpc_run_m & strobe_m);
	mvp_register #(1) _mpc_pref_w(mpc_pref_w, gclk, pref_w_pre & mpc_run_w & !mpc_exc_w & pstrobe_w); 


        //auto-prologue in I-stage 
        assign at_pro_seq_i = (count_hw_save[2:0] == 3'd1) | (count_hw_save[2:0] == 3'd2) | (count_hw_save[2:0] == 3'd3);

        //read sp from previous GPR in case of SRS switching
        assign hw_rdpgpr = cpz_at_pro_start_i & (~cpz_usekstk | ~cpz_iap_um);
	assign hw_g_rdpgpr = cpz_g_at_pro_start_i & (~cpz_g_usekstk | ~cpz_g_iap_um);

        //read sp strobe for HW sequence
        assign hw_rdgpr = cpz_at_pro_start_i | cpz_g_at_pro_start_i | at_epi_start_i;

        mvp_cregister_wide #(32) _mpc_buf_epc_31_0_(mpc_buf_epc[31:0],gscanenable, mpc_hw_load_epc_m & ~dcc_dmiss_m & ~(hw_exc_m | mpc_exc_iae) 
					   & (mpc_run_m | mpc_fixup_m), gclk, dcc_ddata_m);

        mvp_cregister_wide #(26) _buf_status_25_0_(buf_status[25:0],gscanenable, judge_chain, gclk, {dcc_ddata_m[30:24],
					  dcc_ddata_m[22:8], dcc_ddata_m[4], 
					dcc_ddata_m[2:0]});

	assign mpc_buf_status[31:0] = {1'b0,             // CU3 not writeable
                           buf_status[25],        // CU2
                           buf_status[24],        // CU1
                           buf_status[23],        // CU0
                           buf_status[22],        // RP
                           buf_status[21],        // FR
                           buf_status[20],        // Reverse Endian
                           buf_status[19],        // MX
                           1'b0,                  // 0
                           buf_status[18],        // BEV
                           buf_status[17],        // TS
                           buf_status[16],        // SR
                           buf_status[15],        // NMI
                           buf_status[14],        // IPL[7]
                           buf_status[13],        // CEE
                           buf_status[12],        // IPL[6]
                           buf_status[11:4],      // IM[7:0]
                           3'b0,                  // 0
                           buf_status[3],         // UM
                           1'b0,                  // 0
                           buf_status[2:0]};      // ERL,EXL,IE

        mvp_cregister_wide #(20) _buf_srsctl_19_0_(buf_srsctl[19:0],gscanenable, load_srsctl_done, gclk, {dcc_ddata_m[29:26], dcc_ddata_m[21:18],
					  dcc_ddata_m[15:12], dcc_ddata_m[9:6], dcc_ddata_m[3:0]});
	assign mpc_buf_srsctl[31:0] = {2'b0, buf_srsctl[19:16], 4'b0, buf_srsctl[15:12], 2'b0, buf_srsctl[11:8], 2'b0,
                        buf_srsctl[7:4], 2'b0, buf_srsctl[3:0]};

	//get stack pointer decrement number in byte
	assign mpc_stkdec_in_bytes[6:0] = ~cpz_gm_e ? (|cpz_stkdec[4:2] ? cpz_stkdec << 2 : 7'd12) : 
					(|cpz_g_stkdec[4:2] ? cpz_g_stkdec << 2 : 7'd12);

	//update sp during HW entry or return sequence and hold saved sp after read it from gpr
	mvp_register #(1) _iap_sp_update(iap_sp_update, gclk, cpz_at_pro_start_i| cpz_g_at_pro_start_i );
        mvp_register #(1) _get_saved_sp(get_saved_sp, gclk, cpz_iret_m | cpz_g_iret_m);
        mvp_cregister_wide #(32) _sp_plus_31_0_(sp_plus[31:0],gscanenable, greset | iap_sp_update | get_saved_sp | 
				       mpc_hw_load_status_e & mpc_run_ie | mpc_chain_strobe_reg, gclk,
				       greset ? 1'b0 :
				       iap_sp_update ? rf_bdt_e - mpc_stkdec_in_bytes : 
				       get_saved_sp ? rf_bdt_e + 32'd4 : 
				       mpc_hw_load_status_e ? sp_plus - 32'd4 + mpc_stkdec_in_bytes : 
				       sp_plus - mpc_stkdec_in_bytes);
        assign mpc_hw_sp[31:0] = sp_plus;

        //counter for HW entry save operation
        mvp_cregister #(3) _count_hw_save_2_0_(count_hw_save[2:0],at_pro_done_i | cpz_at_pro_start_i | cpz_g_at_pro_start_i | greset |
					    mpc_run_ie & hw_save_i | hw_exc_m & hw_save_i,
					    gclk,
					    greset | at_pro_done_i ? 3'd0 :
					    cpz_at_pro_start_i | cpz_g_at_pro_start_i ? 3'd1 :
					    hw_exc_m & hw_save_i ? 3'd4 :
					    mpc_run_ie & hw_save_i ? count_hw_save[2:0] + 3'd1 : 
					    count_hw_save[2:0]);

	assign mpc_hw_ls_i = hw_save_i | mpc_sel_hw_load_i;
        mvp_cregister #(1) _mpc_hw_ls_e(mpc_hw_ls_e,mpc_run_ie, gclk, mpc_hw_ls_i);

        //write sp to GPR after sp updated during HW entry sequence or not skip for tail chain during HW return sequence
	assign judge_chain = hw_load_status_m & ~dcc_dmiss_m & ~(hw_exc_m | mpc_exc_iae) 
		& (mpc_run_m | mpc_fixup_m);
	mvp_register #(1) _raw_load_status_done(raw_load_status_done, gclk, judge_chain);
	assign mpc_load_status_done = raw_load_status_done & ~hw_exc_w;

	assign p_tail_chain = (~cpz_gm_m ? cpz_int_pend_ed[7:0] : cpz_g_int_pend_ed[7:0]) 
		> {dcc_ddata_m[18], dcc_ddata_m[16:10]};
        assign mpc_wr_sp2gpr = mpc_hw_save_done | mpc_chain_strobe_reg | 
		mpc_hw_load_done & ~mpc_chain_take | cpz_iret_chain_reg; 
        assign wr_sp2gpr_strobe = mpc_hw_save_done | mpc_chain_strobe_reg & ~hw_exc_w | 
		mpc_hw_load_done & ~mpc_chain_take | cpz_iret_chain_reg; 

        //pipe HW save operation
	assign hw_save_epc_i = (count_hw_save[2:0] == 3'd1);
	assign hw_save_status_i = (count_hw_save[2:0] == 3'd2);
	assign mpc_hw_save_srsctl_i = (count_hw_save[2:0] == 3'd3);

        mvp_cregister #(1) _mpc_hw_save_status_e(mpc_hw_save_status_e,mpc_run_ie, gclk, hw_save_status_i);
        mvp_cregister #(1) _mpc_hw_save_epc_e(mpc_hw_save_epc_e,mpc_run_ie, gclk, hw_save_epc_i);
        mvp_cregister #(1) _mpc_hw_save_srsctl_e(mpc_hw_save_srsctl_e,mpc_run_ie, gclk, mpc_hw_save_srsctl_i);

        mvp_cregister #(1) _hw_save_epc_m(hw_save_epc_m,mpc_run_m, gclk, mpc_hw_save_epc_e & control_en_e);
        mvp_cregister #(1) _hw_save_epc_w(hw_save_epc_w,mpc_run_m, gclk, mpc_hw_save_epc_m);
	assign mpc_hw_save_epc_m = mpc_fixup_m ? hw_save_epc_w : hw_save_epc_m;

        mvp_cregister #(1) _hw_save_status_m(hw_save_status_m,mpc_run_m, gclk, mpc_hw_save_status_e & control_en_e);
        mvp_cregister #(1) _hw_save_status_w(hw_save_status_w,mpc_run_m, gclk, mpc_hw_save_status_m);
	assign mpc_hw_save_status_m = mpc_fixup_m ? hw_save_status_w : hw_save_status_m;

        mvp_cregister #(1) _hw_save_srsctl_m(hw_save_srsctl_m,mpc_run_m, gclk, mpc_hw_save_srsctl_e & control_en_e);
        mvp_cregister #(1) _hw_save_srsctl_w(hw_save_srsctl_w,mpc_run_m, gclk, mpc_hw_save_srsctl_m);
	assign mpc_hw_save_srsctl_m = mpc_fixup_m ? hw_save_srsctl_w : hw_save_srsctl_m;

	//auto-prologue completes after srsctl is saved successfully
        assign save_srsctl_done = mpc_hw_save_srsctl_m & ~dcc_dmiss_m & ~(hw_exc_m | 
		(cpz_gm_m ? cpz_g_causeap : cpz_causeap)) & (mpc_run_m | mpc_fixup_m);
        mvp_register #(1) _mpc_hw_save_done(mpc_hw_save_done, gclk, save_srsctl_done);

	//auto-prologue in W/M-stage
	assign mpc_atpro_w = hw_save_epc_w | hw_save_status_w | hw_save_srsctl_w;
	assign mpc_atpro_m = mpc_hw_save_epc_m | mpc_hw_save_status_m | mpc_hw_save_srsctl_m;

	//set at_pro_done_i after CP0 Status updated
        assign at_pro_done_i = (count_hw_save[2:0] == 3'd4); 

        //start HW interrupt return sequence when detect valid cpz_iret_m
        mvp_register #(1) _hold_iret_m(hold_iret_m,gclk, at_epi_start_i & ~(mpc_run_ie | mpc_fixupi));
        assign at_epi_start_i = cpz_iret_m | cpz_g_iret_m | hold_iret_m; 

	//hold exception occured during auto-epilogue
	assign ld_exciae = hw_exc_m & (hw_load_status_m | mpc_hw_load_epc_m | mpc_hw_load_srsctl_m);  
	mvp_cregister #(1) _mpc_scop1_m(mpc_scop1_m,mpc_run_ie, gclk, scop1_e);

	mvp_cregister #(1) _mpc_exc_iae(mpc_exc_iae,greset | mpc_iretval_e | ld_exciae, gclk,
				     greset | mpc_iretval_e ? 1'b0 : 1'b1);

	//hold pc during auto epilogue until normal return or jump to next interrupt
	assign mpc_epi_vec = (mpc_iretval_e | mpc_hold_epi_vec & ~mpc_exc_iae) & ~mpc_iret_ret 
		& ~mpc_chain_vec & ~greset;
	mvp_cregister #(1) _mpc_hold_epi_vec(mpc_hold_epi_vec,greset | mpc_iret_e | mpc_iret_ret | mpc_chain_vec | 
		mpc_exc_iae | mpc_exc_e | mpc_exc_m, gclk, 
		mpc_epi_vec & ~(mpc_exc_e & ~hw_load_e) & ~(mpc_exc_m & mpc_atepi_m));
	assign hw_load_e = mpc_hw_load_status_e | mpc_hw_load_epc_e | mpc_hw_load_srsctl_e;

        //auto-epilogue in I-stage 
        assign at_epi_seq_i = (count_hw_load[2:0] == 3'd1) | (count_hw_load[2:0] == 3'd2) | 
		(count_hw_load[2:0] == 3'd3);

        //counter for HW load operation during EIC interrupt return
        mvp_cregister #(3) _count_hw_load_2_0_(count_hw_load[2:0],greset | at_epi_done_i | cpz_iret_m | cpz_g_iret_m |
			    mpc_run_ie & mpc_sel_hw_load_i | hw_exc_m & mpc_sel_hw_load_i,
			    gclk,
			    greset | at_epi_done_i ? 3'd0 :
			    cpz_iret_m | cpz_g_iret_m ? 3'd1 :
			    hw_exc_m & mpc_sel_hw_load_i ? 3'd4 :
			    mpc_run_ie & mpc_sel_hw_load_i ? (count_hw_load[2:0] + 3'd1) : 
			    count_hw_load[2:0]);
        assign mpc_sel_hw_load_i = (count_hw_load[2:0] == 3'd1) | (count_hw_load[2:0] == 3'd2) | 
		(count_hw_load[2:0] == 3'd3); 

	//skip HW sequence if incoming RIPL is greater than saved Status.IPL
	mvp_cregister #(1) _mpc_chain_take(mpc_chain_take,judge_chain | greset | p_iret_e & mpc_irval_e, gclk, 
					greset | p_iret_e ? 1'b0 : mpc_chain_strobe);

	//skip HW sequence if incoming RIPL is greater than saved Status.IPL and
	//kill HW load operation if skip HW sequence due to tail chain
	assign mpc_chain_strobe = (~cpz_gm_m ? cpz_ice & cpz_int_enable : cpz_g_ice & cpz_g_int_enable) 
		& ejt_dcrinte & judge_chain & p_tail_chain;
	mvp_register #(1) _mpc_chain_strobe_reg(mpc_chain_strobe_reg, gclk, mpc_chain_strobe);
	assign mpc_chain_hold = mpc_chain_strobe & ~hw_exc_w | hold_chain_strobe;
	mvp_register #(1) _hold_chain_strobe(hold_chain_strobe, gclk, mpc_chain_hold & ~mpc_run_ie);

        //pipe HW load operation
	assign mpc_hw_load_status_i = (count_hw_load[2:0] == 3'd1);
	assign hw_load_epc_i = (count_hw_load[2:0] == 3'd2);
	assign hw_load_srsctl_i = (count_hw_load[2:0] == 3'd3);

        mvp_cregister #(1) _mpc_hw_load_status_e(mpc_hw_load_status_e,mpc_run_ie, gclk, mpc_hw_load_status_i);
        mvp_cregister #(1) _mpc_hw_load_epc_e(mpc_hw_load_epc_e,mpc_run_ie, gclk, hw_load_epc_i);
        mvp_cregister #(1) _mpc_hw_load_srsctl_e(mpc_hw_load_srsctl_e,mpc_run_ie, gclk, hw_load_srsctl_i);
	assign mpc_hw_load_e = mpc_hw_load_epc_e | mpc_hw_load_srsctl_e;

        mvp_cregister #(1) _raw_hw_load_status_m(raw_hw_load_status_m,mpc_run_m, gclk, mpc_hw_load_status_e & control_en_e);
        mvp_cregister #(1) _hw_load_status_w(hw_load_status_w,mpc_run_m, gclk, hw_load_status_m);
	assign hw_load_status_m = mpc_fixup_m ? hw_load_status_w : raw_hw_load_status_m;

        mvp_cregister #(1) _hw_load_epc_m(hw_load_epc_m,mpc_run_m, gclk, mpc_hw_load_epc_e & control_en_e);
        mvp_cregister #(1) _hw_load_epc_w(hw_load_epc_w,mpc_run_m, gclk, mpc_hw_load_epc_m);
	assign mpc_hw_load_epc_m = mpc_fixup_m ? hw_load_epc_w : hw_load_epc_m;

        mvp_cregister #(1) _hw_load_srsctl_m(hw_load_srsctl_m,mpc_run_m, gclk, mpc_hw_load_srsctl_e & control_en_e);
        mvp_cregister #(1) _hw_load_srsctl_w(hw_load_srsctl_w,mpc_run_m, gclk, mpc_hw_load_srsctl_m);
	assign mpc_hw_load_srsctl_m = mpc_fixup_m ? hw_load_srsctl_w : hw_load_srsctl_m;

	//auto-epilogue completes after srsctl is loaded successfully
	assign load_srsctl_done = mpc_hw_load_srsctl_m & ~dcc_dmiss_m & ~(hw_exc_m | mpc_exc_iae) & (mpc_run_m | mpc_fixup_m);
	mvp_register #(1) _mpc_hw_load_done(mpc_hw_load_done, gclk, load_srsctl_done & ~mpc_chain_take);
	assign mpc_iae_done_exc = mpc_exc_iae & atepi_m_done;
	assign atepi_m_done = ~mpc_atepi_m & atepi_m_reg;
	mvp_register #(1) _atepi_m_reg(atepi_m_reg, gclk, mpc_atepi_m);

	//auto-epilogue in W/M-stage
	assign mpc_atepi_w = hw_load_epc_w | hw_load_status_w | hw_load_srsctl_w;
	assign mpc_atepi_m = mpc_hw_load_epc_m | hw_load_status_m | mpc_hw_load_srsctl_m;

	//set at_epi_done_i after sp updated
        assign at_epi_done_i = (count_hw_load[2:0] == 3'd4); 

	//jump to next interrupt PC on IRET if tailchain happen
        mvp_cregister #(1) _mpc_chain_vec(mpc_chain_vec,greset | mpc_chain_strobe | mpc_chain_vec, gclk,
		greset ? 1'b0 : mpc_chain_strobe | mpc_chain_vec & ~mpc_run_ie & ~hw_exc_w);
	assign chain_vec_end = mpc_chain_vec & mpc_run_ie;

	//PC redirect due to IRET return
        assign mpc_iret_ret_start = (~cpz_gm_w & (cpz_ice & ~mpc_chain_take | ~cpz_ice) | 
		cpz_gm_w & (cpz_g_ice & ~mpc_chain_take | ~cpz_g_ice)) & mpc_hw_load_done;
	assign hold_iret_ret = mpc_iret_ret | mpc_iret_ret_start;
	mvp_cregister #(1) _mpc_iret_ret(mpc_iret_ret,greset | mpc_iret_ret_start | mpc_run_ie, gclk,
				      greset | mpc_iret_ret & mpc_run_ie ? 1'b0 : hold_iret_ret);
	mvp_cregister #(1) _mpc_iretret_m(mpc_iretret_m,mpc_run_m, gclk, mpc_iret_ret & ~mpc_exc_e);

	assign mpc_nullify_e = mpc_pexc_e | mpc_eexc_e ;
	assign mpc_nullify_m = mpc_ekillmd_m;
	assign mpc_nullify_w = mpc_ekillmd_w;

	mvp_cregister #(1) _dec_dsp_valid_m(dec_dsp_valid_m,mpc_run_ie, gclk, dec_dsp_valid_e);
	assign mpc_ctl_dsp_valid_m = dec_dsp_valid_m & mpc_vd_m & mpc_irval_m;

	// MDU/UDI data present
	assign mdu_data_valid_e_tmp = mpc_irval_e & MDU_dec_e;

	assign MDU_data_valid_e = mdu_data_valid_e_tmp & mpc_run_ie;
	assign MDU_data_val_e = mdu_data_valid_e_tmp;

	// issue MDU instruction in last cycle of AG stage
	assign MDU_opcode_issue_e = ~mpc_nullify_e & (MDU_run_e & mpc_irval_e & MDU_dec_e & ~ri_e);

	mvp_cregister #(1) _mpc_mdu_m(mpc_mdu_m,mpc_run_ie, gclk, MDU_dec_e);

	assign MDU_run_e = mpc_run_ie;

	// Signal to MDU that ALU will read MDU data, if any
	assign MDU_data_ack_m = 1'b1;

	mvp_cregister #(1) _wr_dspc_m(wr_dspc_m,mpc_run_m | greset, gclk, (mpc_wrdsp_e | edp_dsp_dspc_ou_wren_e) & ~greset);
	assign dsp_stall_e = rddsp_e & mpc_irval_e & (wr_dspc_m & mpc_irval_m | MDU_ouflag_vld_xx);

	mvp_cregister #(1) _mpc_dec_sh_shright_m(mpc_dec_sh_shright_m,mpc_run_ie, gclk, dec_sh_shright_e);

	mvp_cregister #(1) _mpc_dec_sh_subst_ctl_m(mpc_dec_sh_subst_ctl_m,mpc_run_ie, gclk, dec_sh_subst_ctl_e);

	mvp_cregister #(1) _mpc_dec_sh_low_index_4_m(mpc_dec_sh_low_index_4_m,mpc_run_ie, gclk, dec_sh_low_index_4_e);

	mvp_cregister #(1) _mpc_dec_sh_low_sel_m(mpc_dec_sh_low_sel_m,mpc_run_ie, gclk, dec_sh_low_sel_e);
	
	mvp_cregister_wide #(5) _mpc_dec_sh_high_index_m_4_0_(mpc_dec_sh_high_index_m[4:0],gscanenable,mpc_run_ie, gclk,
			dec_sh_high_index_e[4:0]);

	mvp_cregister #(1) _mpc_dec_sh_high_sel_m(mpc_dec_sh_high_sel_m,mpc_run_ie, gclk, dec_sh_high_sel_e);

	mvp_cregister #(1) _mpc_append_m(mpc_append_m,mpc_run_ie, gclk, append_e);

	mvp_cregister #(1) _mpc_prepend_m(mpc_prepend_m,mpc_run_ie, gclk, prepend_e);

	mvp_cregister #(1) _mpc_balign_m(mpc_balign_m,mpc_run_ie, gclk, balign_e);

  // Have the FPU clk run for min 4 fpu cycles after reset
	mvp_register #(1) _greset_reg(greset_reg,gfclk,greset);
	mvp_register #(3) _greset_4cycles_reg_2_0_(greset_4cycles_reg[2:0],gfclk, { 3 { ~greset_reg & ~(dec_cp1_e & mpc_irval_e)}} &
					    ((greset_4cycles_reg[2:1] == 2'b11) ? 3'b111 : greset_4cycles_reg + 3'b001));
	assign mpc_disable_gclk_xx = ~(dec_cp1_e & mpc_irval_e) & cp1_copidle &
			    ~greset & (&greset_4cycles_reg);

	mvp_cregister #(1) _scop2_m(scop2_m,mpc_run_ie, gclk, scop2_e);
	mvp_cregister #(1) _scop2_w(scop2_w,mpc_run_m, gclk, scop2_m);
	mvp_cregister #(1) _lscop2_m(lscop2_m,mpc_run_ie, gclk, lscop2_e);
	mvp_cregister #(1) _lscop2_w(lscop2_w,mpc_run_m, gclk, lscop2_m);

	assign cop1_s_stall_e = 1'b0;

	mvp_cregister #(1) _mpc_rdhwr_m(mpc_rdhwr_m,mpc_run_ie, gclk, rdhwr_e);


//verilint 528 on        // Variable set but not used
	
endmodule // control
