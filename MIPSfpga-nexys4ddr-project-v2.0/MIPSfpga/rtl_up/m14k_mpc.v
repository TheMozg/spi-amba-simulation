// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_mpc 
//           Master Pipeline Control
//
//	$Id: \$
//	mips_repository_id: m14k_mpc.hook, v 1.126 
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
module m14k_mpc(
	biu_ibe_exc,
	biu_dbe_exc,
	biu_wbe,
	cp2_bstall_e,
	cp2_btaken,
	cp2_bvalid,
	cp2_exc_w,
	cp2_exccode_w,
	cp2_fixup_m,
	cp2_fixup_w,
	cp2_missexc_w,
	cp2_moveto_m,
	cp2_movefrom_m,
	cp2_stall_e,
	cp1_bstall_e,
	cp1_btaken,
	cp1_bvalid,
	cp1_exc_w,
	cp1_exccode_w,
	cp1_fixup_m,
	cp1_fixup_w,
	cp1_fixup_i,
	cp1_missexc_w,
	cp1_moveto_m,
	cp1_movefrom_m,
	cp1_stall_e,
	cp1_coppresent,
	cp1_copidle,
	cp1_seen_nodmiss_m,
	cpz_at_pro_start_i,
	cpz_fr,
	cpz_at_epi_en,
	cpz_at_pro_start_val,
	cpz_bev,
	cpz_bootisamode,
	cpz_causeap,
	cpz_cee,
	cpz_copusable,
	cpz_debugmode_i,
	cpz_dm_m,
	cpz_dm_w,
	cpz_dwatchhit,
	cpz_eretisa,
	cpz_erl,
	cpz_excisamode,
	biu_lock,
	cp1_stall_m,
	mpc_scop1_m,
	cpz_ext_int,
	cpz_hotdm_i,
	cpz_exl,
	cpz_hotexl,
	cpz_hotiexi,
	cpz_hwrena,
	cpz_hwrena_29,
	cpz_iap_um,
	cpz_ice,
	cpz_iexi,
	cpz_int_e,
	cpz_int_enable,
	cpz_int_excl_ie_e,
	cpz_int_mw,
	cpz_int_pend_ed,
	cpz_iret_chain_reg,
	cpz_iret_m,
	cpz_iv,
	cpz_iwatchhit,
	cpz_kuc_e,
	cpz_mmutype,
	cpz_nmi_e,
	cpz_nmi_mw,
	cpz_pf,
	cpz_rbigend_e,
	cpz_setdbep,
	cpz_setibep,
	cpz_srsctl_css,
	cpz_srsctl_pss,
	cpz_srsctl_pss2css_m,
	cpz_sst,
	cpz_stkdec,
	cpz_takeint,
	cpz_usekstk,
	cpz_wpexc_m,
	dcc_dbe_killfixup_w,
	dcc_ddata_m,
	dcc_dmiss_m,
	dcc_ev,
	dcc_fixup_w,
	dcc_intkill_m,
	dcc_intkill_w,
	dcc_ldst_m,
	dcc_parerr_w,
	dcc_exc_nokill_m,
	dcc_spram_write,
	dcc_parerr_m,
	dcc_precisedbe_w,
	dcc_stall_m,
	debug_mode_e,
	dexc_type,
	edp_abus_e,
	edp_cndeq_e,
	edp_dva_1_0_e,
	edp_povf_m,
	edp_stalign_byteoffset_e,
	edp_trapeq_m,
	edp_udi_honor_cee,
	edp_udi_ri_e,
	edp_udi_stall_m,
	edp_udi_wrreg_e,
	ej_fdc_busy_xx,
	ej_fdc_int,
	ej_isaondebug_read,
	ej_probtrap,
	ej_rdvec,
	ej_rdvec_read,
	ejt_cbrk_m,
	ejt_dbrk_m,
	ejt_dbrk_w,
	ejt_dcrinte,
	ejt_dvabrk,
	ejt_ejtagbrk,
	ejt_ivabrk,
	ejt_disableprobedebug,
	ejt_pdt_stall_w,
	ejt_stall_st_e,
	gclk,
	gfclk,
	greset,
	gscanenable,
	icc_halfworddethigh_fifo_i,
	icc_halfworddethigh_i,
	icc_slip_n_nhalf,
	icc_umips_sds,
	icc_idata_i,
	icc_predec_i,
	icc_imiss_i,
	icc_macro_jr,
	icc_umipspresent,
	icc_umipsri_e,
	icc_macro_e,
	icc_macrobds_e,
	icc_nobds_e,
	mpc_nobds_e,
	icc_poten_be,
	icc_parerr_i,
	icc_parerrint_i,
	icc_parerr_w,
	icc_umips_16bit_needed,
	icc_pcrel_e,
	mpc_usesrca_e,
	mpc_usesrcb_e,
	mpc_pcrel_e,
	mpc_cop_e,
	icc_preciseibe_e,
	icc_preciseibe_i,
	icc_rdpgpr_i,
	icc_dspver_i,
	icc_stall_i,
	icc_umipsfifo_null_i,
	icc_umipsfifo_null_w,
	icc_umipsfifo_stat,
	icc_umips_active,
	icc_umipsfifo_imip,
	icc_umipsfifo_ieip2,
	icc_umipsfifo_ieip4,
	mdu_busy,
	mdu_stall,
	cdmm_mputriggered_i,
	cdmm_mputriggered_m,
	cdmm_mmulock,
	mmu_tlbshutdown,
	mmu_dtexc_m,
	mmu_itexc_i,
	mmu_adrerr,
	mmu_dtriexc_m,
	mmu_itxiexc_i,
	mmu_tlbinv,
	mmu_tlbmod,
	mmu_tlbrefill,
	mmu_iec,
	mmu_r_adrerr,
	mmu_r_dtexc_m,
	mmu_r_dtriexc_m,
	mmu_r_itexc_i,
	mmu_r_itxiexc_i,
	mmu_r_tlbinv,
	mmu_r_tlbmod,
	mmu_r_tlbrefill,
	mmu_r_tlbshutdown,
	mmu_r_iec,
	mmu_itmack_i,
	mmu_dtmack_m,
	mmu_tlbbusy,
	x3_trig,
	mpc_addui_e,
	mpc_alu_w,
	mpc_aluasrc_e,
	mpc_alubsrc_e,
	mpc_alufunc_e,
	mpc_alusel_m,
	mpc_annulds_e,
	mpc_apcsel_e,
	mpc_aselres_e,
	mpc_aselwr_e,
	mpc_atepi_m,
	mpc_atepi_w,
	mpc_atomic_impr,
	mpc_atpro_w,
	mpc_auexc_x,
	mpc_ndauexc_x,
	mpc_bds_m,
	mpc_be_w,
	mpc_br_e,
	mpc_br16_e,
	mpc_br32_e,
	mpc_shvar_e,
	mpc_brrun_ie,
	mpc_bselall_e,
	mpc_bselres_e,
	mpc_bsign_w,
	mpc_cp2a_e,
	mpc_cp2tf_e,
	mpc_dspinfo_e,
	mpc_buf_epc,
	mpc_buf_srsctl,
	mpc_buf_status,
	mpc_bussize_m,
	mpc_tlb_exc_type,
	mpc_busty_raw_e,
	mpc_busty_e,
	mpc_busty_m,
	mpc_strobe_e,
	mpc_strobe_m,
	mpc_strobe_w,
	mpc_cbstrobe_w,
	mpc_mpustrobe_w,
	mpc_cdsign_w,
	mpc_chain_take,
	mpc_chain_vec,
	mpc_cleard_strobe,
	mpc_clinvert_e,
	mpc_clsel_e,
	mpc_clvl_e,
	mpc_cmov_e,
	mpc_cnvt_e,
	mpc_cnvts_e,
	mpc_cnvtsh_e,
	mpc_compact_e,
	mpc_cont_pf_phase1,
	mpc_coptype_m,
	mpc_dmsquash_w,
	mpc_idx_cop_e,
	mpc_continue_squash_i,
	mpc_cp0func_e,
	mpc_ctlen_noe_e,
	mpc_dmsquash_m,
	mpc_cp0diei_m,
	mpc_cp0move_m,
	mpc_cp0r_m,
	mpc_cp0sc_m,
	mpc_cp0sr_m,
	mpc_cp2exc,
	mpc_cp1exc,
	mpc_cpnm_e,
	mpc_dcba_w,
	mpc_dec_nop_w,
	mpc_defivasel_e,
	mpc_deret_m,
	mpc_deretval_e,
	mpc_dest_w,
	mpc_dparerr_for_eviction,
	mpc_eexc_e,
	mpc_ekillmd_m,
	mpc_epi_vec,
	mpc_eqcond_e,
	mpc_eret_m,
	mpc_eretval_e,
	mpc_evecsel,
	mpc_exc_e,
	mpc_exc_iae,
	mpc_exc_m,
	mpc_exc_w,
	mpc_exc_w_org,
	mpc_exccode,
	mpc_expect_isa,
	mpc_ext_e,
	mpc_first_det_int,
	mpc_fixup_m,
	mpc_fixupd,
	mpc_fixupi,
	mpc_fixupi_wascall,
	mpc_hold_epi_vec,
	mpc_hold_hwintn,
	mpc_hw_load_done,
	mpc_hw_load_e,
	mpc_hw_load_epc_e,
	mpc_hw_load_epc_m,
	mpc_hw_load_srsctl_e,
	mpc_hw_load_srsctl_m,
	mpc_hw_load_status_e,
	mpc_hw_ls_i,
	mpc_hw_ls_e,
	mpc_chain_hold,
	mpc_hw_save_done,
	mpc_hw_save_epc_e,
	mpc_hw_save_epc_m,
	mpc_hw_save_srsctl_e,
	mpc_hw_save_srsctl_m,
	mpc_hw_save_status_e,
	mpc_hw_save_status_m,
	mpc_hw_sp,
	mpc_iae_done_exc,
	mpc_ibrk_qual,
	mpc_icop_m,
	mpc_iccop_m,
	mpc_hold_int_pref_phase1_val,
	mpc_imsgn_e,
	mpc_imsquash_e,
	mpc_imsquash_i,
	mpc_insext_e,
	MDU_info_e,
	mpc_insext_size_e,
	mpc_int_pref_phase1,
	mpc_pf_phase2_done,
	mpc_int_pref,
	mpc_int_pf_phase1_reg,
	mpc_chain_strobe,
	mpc_ir_e,
	mpc_predec_e,
	mpc_abs_e,
	mpc_umipspresent,
	mpc_macro_e,
	mpc_macro_end_e,
	mpc_macro_m,
	mpc_macro_w,
	mpc_sds_e,
	mpc_iret_m,
	mpc_iret_ret,
	mpc_iret_ret_start,
	mpc_ireton_e,
	mpc_stkdec_in_bytes,
	mpc_iretval_e,
	mpc_irval_e,
	mpc_irval_m,
	mpc_irval_w,
	mpc_isamode_e,
	mpc_isamode_i,
	mpc_isamode_m,
	mpc_excisamode_i,
	mpc_isachange0_i,
	mpc_isachange1_i,
	mpc_itqualcond_i,
	mpc_mputriggeredres_i,
	mpc_ivaval_i,
	mpc_jalx_e,
	mpc_jamdepc_w,
	mpc_jamepc_w,
	mpc_jamerror_w,
	mpc_jamtlb_w,
	mpc_ebld_e,
	mpc_ebexc_w,
	mpc_jimm_e,
	mpc_jimm_e_fc,
	mpc_jreg_e,
	mpc_jreg31_e,
	mpc_jreg31non_e,
	mpc_jreg_e_jalr,
	mpc_killcp2_w,
	mpc_killcp1_w,
	mpc_killmd_m,
	mpc_ld_causeap,
	mpc_ld_m,
	mpc_st_m,
	mpc_lda15_8sel_w,
	mpc_lda23_16sel_w,
	mpc_lda31_24sel_w,
	mpc_lda7_0sel_w,
	mpc_ldcause,
	mpc_ldst_e,
	mpc_ll_e,
	mpc_ll1_m,
	mpc_newiaddr,
	mpc_umipsfifosupport_i,
	mpc_ll_m,
	mpc_lnksel_e,
	mpc_lnksel_m,
	mpc_load_m,
	mpc_load_status_done,
	mpc_lsbe_m,
	mpc_lxs_e,
	mpc_muldiv_w,
	mpc_pm_muldiv_e,
	mpc_nmitaken,
	mpc_nonseq_e,
	mpc_nonseq_ep,
	mpc_pdstrobe_w,
	mpc_ltu_e,
	mpc_mcp0stall_e,
	mpc_bubble_e,
	mpc_penddbe,
	mpc_pendibe,
	mpc_pexc_i,
	mpc_pexc_e,
	mpc_pexc_m,
	mpc_pexc_w,
	mpc_pm_complete,
	PM_InstnComplete,
	mpc_prealu_cond_e,
	mpc_movci_e,
	mpc_pref_w,
	mpc_pref_m,
	mpc_qual_auexc_x,
	mpc_rega_cond_i,
	mpc_rega_i,
	mpc_regb_cond_i,
	mpc_regb_i,
	mpc_ret_e,
	mpc_ret_e_ndg,
	mpc_rfwrite_w,
	mpc_run_i,
	mpc_run_ie,
	mpc_run_m,
	mpc_run_w,
	mpc_sbstrobe_w,
	mpc_sbdstrobe_w,
	mpc_sbtake_w,
	mpc_mputake_w,
	mpc_sc_e,
	mpc_sc_m,
	mpc_sdbreak_w,
	mpc_pcrel_m,
	mpc_sel_hw_e,
	mpc_selcp0_m,
	mpc_selcp2to_m,
	mpc_selcp2from_m,
	mpc_selcp2from_w,
	mpc_selcp1to_m,
	mpc_selcp1from_m,
	mpc_selcp1from_w,
	mpc_disable_gclk_xx,
	mpc_selcp_m,
	mpc_selimm_e,
	mpc_sellogic_m,
	mpc_selrot_e,
	mpc_sequential_e,
	mpc_shamt_e,
	mpc_sharith_e,
	mpc_shf_rot_cond_e,
	mpc_shright_e,
	mpc_signa_w,
	mpc_signb_w,
	mpc_signc_w,
	mpc_signd_w,
	mpc_signed_m,
	mpc_squash_e,
	mpc_dis_int_e,
	mpc_squash_i,
	mpc_squash_m,
	mpc_srcvld_e,
	mpc_stall_ie,
	mpc_stall_m,
	mpc_stall_w,
	mpc_subtract_e,
	mpc_swaph_e,
	mpc_tint,
	mpc_udisel_m,
	mpc_udislt_sel_m,
	mpc_umips_defivasel_e,
	mpc_umips_mirrordefivasel_e,
	mpc_updateepc_e,
	mpc_updateldcp_m,
	mpc_wait_w,
	mpc_wait_m,
	mpc_lsdc1_m,
	mpc_lsuxc1_m,
	mpc_ldc1_m,
	mpc_ldc1_w,
	mpc_lsdc1_w,
	mpc_sdc1_w,
	mpc_lsdc1_e,
	mpc_lsuxc1_e,
	mpc_wr_sp2gpr,
	mpc_wr_status_m,
	mpc_wr_intctl_m,
	mpc_wr_view_ipl_m,
	mpc_atomic_bit_dest_w,
	mpc_atomic_clrorset_w,
	mpc_atomic_e,
	mpc_atomic_m,
	mpc_atomic_store_w,
	mpc_atomic_w,
	mpc_noseq_16bit_w,
	mpc_tail_chain_1st_seen,
	mpc_trace_iap_iae_e,
	edp_dsp_add_e,
	edp_dsp_sub_e,
	edp_dsp_modsub_e,
	edp_dsp_present_xx,
	edp_dsp_valid_e,
	edp_dsp_mdu_valid_e,
	edp_dsp_stallreq_e,
	edp_dsp_pos_ge32_e,
	edp_dsp_dspc_ou_wren_e,
	MDU_stallreq_e,
	MDU_ouflag_mulq_muleq_xx,
	MDU_ouflag_extl_extr_xx,
	MDU_ouflag_vld_xx,
	cpz_mx,
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
	mpc_dec_logic_func_m,
	mpc_dec_logic_func_e,
	mpc_dec_sh_shright_m,
	mpc_dec_sh_shright_e,
	mpc_dec_sh_subst_ctl_m,
	mpc_dec_sh_subst_ctl_e,
	mpc_dec_sh_high_sel_m,
	mpc_dec_sh_high_sel_e,
	mpc_append_m,
	mpc_append_e,
	mpc_prepend_m,
	mpc_prepend_e,
	mpc_balign_m,
	mpc_balign_e,
	mpc_dec_sh_high_index_m,
	mpc_dec_sh_high_index_e,
	mpc_dec_sh_low_sel_m,
	mpc_dec_sh_low_sel_e,
	mpc_dec_sh_low_index_4_m,
	mpc_dec_sh_low_index_4_e,
	mpc_dec_insv_e,
	mpc_mf_m2_w,
	mpc_dec_imm_apipe_sh_e,
	mpc_dec_imm_rsimm_e,
	mpc_ctl_dsp_valid_m,
	MDU_dec_e,
	MDU_opcode_issue_e,
	MDU_data_valid_e,
	mpc_nullify_e,
	mpc_nullify_m,
	mpc_nullify_w,
	mpc_mdu_m,
	mpc_vd_m,
	MDU_run_e,
	MDU_data_ack_m,
	mpc_dec_rt_csel_e,
	mpc_dec_rt_bsel_e,
	mpc_dest_e,
	MDU_data_val_e,
	mpc_wrdsp_e,
	cpz_vz,
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
	cpz_g_bev,
	cpz_g_excisamode,
	cpz_g_bootisamode,
	cpz_g_at_epi_en,
	cpz_g_erl,
	cpz_g_at_pro_start_i,
	cpz_g_at_pro_start_val,
	cpz_g_hss,
	cpz_g_mmutype,
	cpz_g_hwrena,
	cpz_g_copusable,
	cpz_g_kuc_e,
	cpz_g_cee,
	cpz_g_usekstk,
	cpz_g_iap_um,
	cpz_g_stkdec,
	cpz_g_int_pend_ed,
	cpz_g_ice,
	cpz_g_int_enable,
	cpz_g_srsctl_css,
	cpz_g_srsctl_pss,
	cpz_g_int_excl_ie_e,
	cpz_g_srsctl_pss2css_m,
	cpz_g_pf,
	cpz_g_rbigend_e,
	cpz_g_eretisa,
	cpz_g_causeap,
	cpz_g_hwrena_29,
	cpz_ri,
	cpz_cp0,
	cpz_at,
	cpz_gt,
	cpz_cg,
	cpz_cf,
	dcc_g_intkill_w,
	cpz_cgi,
	cpz_og,
	cpz_bg,
	cpz_mg,
	cpz_pc_ctl0_ec1,
	cpz_pc_ctl1_ec1,
	cpz_g_pc_present,
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
	cp1_ufrp,
	cpz_ufr,
	cpz_g_ufr,
	cpz_g_iret_m,
	mpc_g_int_pf,
	mpc_wr_guestctl0_m,
	mpc_wr_guestctl2_m,
	mpc_g_cp0move_m,
	mpc_gexccode,
	mpc_g_exc_e,
	mpc_g_eexc_e,
	mpc_g_ldcause,
	mpc_g_jamepc_w,
	mpc_g_jamtlb_w,
	mpc_r_auexc_x,
	mpc_g_auexc_x,
	mpc_r_auexc_x_qual,
	mpc_g_auexc_x_qual,
	mpc_g_ld_causeap,
	mpc_g_cp0func_e,
	mpc_badins_type,
	mpc_tlb_i_side,
	mpc_tlb_d_side,
	mpc_ge_exc,
	mpc_auexc_on,
	mpc_gpsi_perfcnt,
	mpc_ctc1_fr0_m,
	mpc_ctc1_fr1_m,
	mpc_cfc1_fr_m,
	mpc_rdhwr_m,
	mpc_exc_type_w,
	mpc_hw_save_srsctl_i,
	mpc_atomic_load_e,
	cpz_g_hotexl,
	cpz_g_exl,
	qual_iparerr_i,
	qual_iparerr_w,
	rf_bdt_e,
	rf_adt_e,
	rf_init_done,
	cpz_rslip_e,
	bstall_ie);


	/*hookios*//* IO declarations added by hookup */
/* End of hookup IO declarations */
/* Wire declarations added by hookup */
wire alu_sel_e;
wire annul_ds_i;
wire append_e;
wire at_epi_done_i;
wire at_pro_done_i;
wire balign_e;
wire bds_e;
wire br_eq;
wire br_ge;
wire br_gr;
wire br_le;
wire br_likely_e;
wire br_lt;
wire br_ne;
wire break_e;
wire ce_g_un_e;
wire ce_un_e;
wire cfc1_fr_e;
wire chain_vec_end;
wire cmov_type_e;
wire cmp_br;
wire continue_squash_i;
wire [3:0] coptype_e;
wire cp0_e;
wire [4:0] cp0_r_e;
wire [2:0] cp0_sr_e;
wire cp_g_un_e;
wire cp_un_e;
wire ctc1_fr0_e;
wire ctc1_fr1_e;
wire dec_cp1_e;
wire dec_dsp_exc_e;
wire dec_dsp_valid_e;
wire dec_redirect_bposge32_e;
wire [4:0] dec_sh_high_index_e;
wire dec_sh_high_sel_e;
wire dec_sh_low_index_4_e;
wire dec_sh_low_sel_e;
wire dec_sh_shright_e;
wire dec_sh_subst_ctl_e;
wire [5:0] dest_e;
wire dspver_e;
wire g_cp0_e;
wire g_p_cc_e;
wire g_p_config_e;
wire g_p_cop_e;
wire g_p_count_e;
wire g_p_cp0_always_e;
wire g_p_cp0_e;
wire g_p_deret_e;
wire g_p_diei_e;
wire g_p_eret_e;
wire g_p_hypcall_e;
wire g_p_idx_cop_e;
wire g_p_iret_e;
wire g_p_og_e;
wire g_p_perfcnt_e;
wire g_p_rh_cp0_e;
wire g_p_rwpgpr_e;
wire g_p_srs_e;
wire g_p_tlb_e;
wire g_p_wait_e;
wire held_parerrexc_i;
wire hold_intpref_done;
wire hold_pf_phase1_nosquash_i;
wire hw_exc_m;
wire hw_exc_w;
wire hw_g_rdpgpr;
wire hw_load_epc_i;
wire hw_load_srsctl_i;
wire hw_rdgpr;
wire hw_rdpgpr;
wire hw_save_epc_i;
wire hw_save_i;
wire hw_save_status_i;
wire illinstn_e;
wire int_pref_phase2;
wire jreg_hb_e;
wire load_e;
wire lscop2_e;
wire lscop2_w;
wire lsdc1_e;
wire lsdxc1_e;
wire lsuxc1_e;
wire mfhilo_e;
wire [2:0] mpc_atomic_bit_dest_e;
wire mpc_atomic_clrorset_e;
wire mpc_atpro_m;
wire [1:0] mpc_bussize_e;
wire mpc_ekillmd_w;
wire mpc_eret_null_m;
wire mpc_hw_load_status_i;
wire mpc_iretret_m;
wire mpc_irvaldsp_e;
wire mpc_irvalunpred_e;
wire mpc_macro_jr;
wire mpc_mulgpr_e;
wire mpc_nomacroepc_e;
wire mpc_rslip_w;
wire mpc_sel_hw_load_i;
wire mpc_squash_i_qual;
wire mpc_unal_ref_e;
wire muldiv_e;
wire new_exc_i;
wire new_sc_e;
wire p_cp0_diei_e;
wire p_cp0_mv_e;
wire p_cp0_sc_e;
wire p_deret_e;
wire p_eret_e;
wire p_g_cp0_mv_e;
wire p_hypcall_e;
wire p_idx_cop_e;
wire p_iret_e;
wire p_wait_e;
wire [2:0] pbus_type_e;
wire pend_exc;
wire pf_phase1_nosquash_i;
wire pref_e;
wire prefx_e;
wire prepend_e;
wire qual_umipsri_e;
wire qual_umipsri_g_e;
wire raw_ll_e;
wire raw_trap_in_e;
wire rddsp_e;
wire rdhwr_e;
wire ri_e;
wire ri_g_e;
wire sarop_e;
wire scop1_e;
wire scop2_e;
wire scop2_w;
wire sdbbp_e;
wire sel_logic_e;
wire set_pf_auexc_nosquash;
wire set_pf_phase1_nosquash;
wire [4:0] sh_fix_amt_e;
wire sh_fix_e;
wire sh_var_e;
wire signed_e;
wire signed_ld_e;
wire slt_sel_e;
wire squash_e;
wire squash_w;
wire [4:0] src_a_e;
wire [5:0] src_b_e;
wire sst_instn_valid_e;
wire syscall_e;
wire trap_type_e;
wire udi_sel_e;
wire unal_type_e;
wire use_src_a_e;
wire use_src_b_e;
wire vd_e;
wire xfc1_e;
wire xfc2_e;
/* End of hookup wire declarations */

input biu_ibe_exc;		// Instruction Bus Error
input biu_dbe_exc;		// Data Bus Error
input biu_wbe;		// Write Bus Error
input cp2_bstall_e;		// Stall to resolve Cop2 branch
input cp2_btaken;		// Cop2 branch taken
input cp2_bvalid;		// Cop2 Branch detected
input cp2_exc_w;		// W-stage Cop2 exception
input [4:0] cp2_exccode_w;		// Exception code returned from Cop2
input cp2_fixup_m;		// Fixup M-stage for Cop2 op
input cp2_fixup_w;		// Fixup W-stage for Cop2 instn
input cp2_missexc_w;		// Waiting for valid exception
input cp2_moveto_m;		// Coprocessor Move
input cp2_movefrom_m;		// Coprocessor Move
input cp2_stall_e;		// Stall for Cop2 dispatch
input cp1_bstall_e;		// Stall to resolve Cop1 branch
input cp1_btaken;		// Cop1 branch taken
input cp1_bvalid;		// Cop1 Branch detected
input cp1_exc_w;		// W-stage Cop1 exception
input [4:0] cp1_exccode_w;		// Exception code returned from Cop1
input cp1_fixup_m;		// Fixup M-stage for Cop1 op
input cp1_fixup_w;		// Fixup W-stage for Cop1 instn
input cp1_fixup_i;		// Fixup I-stage for Cop1 instn
input cp1_missexc_w;		// Waiting for valid exception
input cp1_moveto_m;		// Coprocessor Move
input cp1_movefrom_m;		// Coprocessor Move
input cp1_stall_e;		// Stall for Cop1 dispatch
input 	 cp1_coppresent;	// COP 1 is present on the interface.
input 	 cp1_copidle;		// COP 1 is Idle, biu_shutdown is OK for COP 1
input 	 	cp1_seen_nodmiss_m;
input cpz_at_pro_start_i;		// start cycle of HW auto prologue
input cpz_fr;		
input cpz_at_epi_en;     	//enable iae
input cpz_at_pro_start_val;		// valid start of HW auto prologue
input cpz_bev;		// Bootstrap exception vectors
input cpz_bootisamode;
input cpz_causeap;		// exception happened during auto-prologue
input cpz_cee;		// CorExtend Enable
input [3:0] cpz_copusable;		// Coprocessor[3:0] are usuable
input cpz_debugmode_i;
input cpz_dm_m;		// M-stage is in Debug Mode
input cpz_dm_w;		// W-stage DebugMode indication
input cpz_dwatchhit;		// Data Watch exception
input cpz_eretisa;		// ISA Mode to return to
input cpz_erl;		// cpz_erl bit from status
input cpz_excisamode;
input biu_lock;		// Bus is locked
input cp1_stall_m;
output mpc_scop1_m;
input cpz_ext_int;		// external interrupt
input cpz_hotdm_i;		// I-stage is in Debug Mode
input cpz_exl;		// M-stage version of Status.EXL
input cpz_hotexl;		// I-stage version of Status.EXL
input cpz_hotiexi;		// I-stage IEXI
input [3:0] cpz_hwrena;		// HWRENA CP0 register
input cpz_hwrena_29;		// Bit29 of HWRENA CP0 register
input cpz_iap_um;
input cpz_ice;		// enable tail chain
input cpz_iexi;		// Imprecise Exception Inhibit
input cpz_int_e;		// E-stage interrupt detected
input cpz_int_enable;		// interrupt enable
input cpz_int_excl_ie_e;
input cpz_int_mw;		// Interrupt in M/W stage
input [7:0] cpz_int_pend_ed;		// pending iterrupt
input cpz_iret_chain_reg;		// reg version of iret_tailchain 
input cpz_iret_m;		// active version of M-stage IRET instn
input cpz_iv;		// State of Cause.IV 
input cpz_iwatchhit;		// Instn Watch exception
input cpz_kuc_e;		// Core is in User mode
input cpz_mmutype;		// MMU Type (1-Fixed, 0-TLB)
input cpz_nmi_e;		// E-stage NMI
input cpz_nmi_mw;		// M and W-stage NMI
input cpz_pf;		// speculative prefetch enable
input cpz_rbigend_e;		// CPU is effectively in big endian mode
input cpz_setdbep;		// Set DBE pending
input cpz_setibep;		// Set IBE pending
input [3:0] cpz_srsctl_css;		// Current SRS
input [3:0] cpz_srsctl_pss;		// Previous SRS	
input cpz_srsctl_pss2css_m;		// Copy PSS back to CSS on eret
input cpz_sst;		// Single Step Enabled
input [4:0] cpz_stkdec;		// number of words for the decremented value of sp
input cpz_takeint;		// interrupt recognized finally
input cpz_usekstk;		// Use kernel stack during IAP
input cpz_wpexc_m;		// Watch Pending Exception
input dcc_dbe_killfixup_w;		// DBE killed W-stage instn
input [31:0] dcc_ddata_m;		// Data bus to core
input dcc_dmiss_m;		// D$ miss
input dcc_ev;		// Eviction in progress
input dcc_fixup_w;		// Fixup W-stage for dcc
input dcc_intkill_m;		// Interrupt killed M-stage L/S instn
input dcc_intkill_w;		// Interrupt killed W-stage L/S instn
input dcc_ldst_m;		// load or store in M-stage

input dcc_parerr_w;		// Description: m14k_parity --D$ parity error detected at W cycle 
input dcc_exc_nokill_m;   	// atomic load is already in fixup w stage
input dcc_spram_write;
input dcc_parerr_m;       	// parity error detected at M stage
input dcc_precisedbe_w;		// DBE was precise
                                // Bus is waiting to be locked
input dcc_stall_m;		// M-stage stall for dcc
input debug_mode_e;		// E-stage is in Debug Mode
output [2:0] dexc_type;		// Encoded values for debug exceptions
input [31:0] edp_abus_e;		// SrcA bus (rs)
input edp_cndeq_e;		// Result of Equality compare
input [1:0] edp_dva_1_0_e;		// Data virtual address (E-stage)
input edp_povf_m;		// Addition overflow
input [1:0] edp_stalign_byteoffset_e;		// Data virtual address[1:0] used for store align byte
input edp_trapeq_m;		// Trap Equality
input edp_udi_honor_cee;		// Look at CEE bit
input edp_udi_ri_e;		// UDI reserved instn indication
input edp_udi_stall_m;		// Stall for UDI result
input [4:0] edp_udi_wrreg_e;		// UDI destination register
input ej_fdc_busy_xx;
input ej_fdc_int;
input ej_isaondebug_read;
input ej_probtrap;		// EJTAG exceptions should go to Probe
input ej_rdvec;	
input [31:0] ej_rdvec_read;		// DebugVectorAddr
input ejt_cbrk_m;		// EJTAG complex break
input ejt_dbrk_m;		// EJTAG Data breakpoint
input ejt_dbrk_w;		// EJTAG Data breakpoint
input ejt_dcrinte;		// EJTAG interrupt enable
input ejt_dvabrk;		// EJTAG DVA breakpoint
input ejt_ejtagbrk;		// Break requested from EJTAG unit (DINT, etc.)
input ejt_ivabrk;		// EJTAG IVA breakpoint
input		ejt_disableprobedebug; // disable ejtag mem space
input ejt_pdt_stall_w;		// Stall in W stage
input ejt_stall_st_e;
input gclk;		// global gated clock
input gfclk;		// Clock 
input greset;		// Global reset
input gscanenable;		// global scan enable
input icc_halfworddethigh_fifo_i;	
input icc_halfworddethigh_i;
input icc_slip_n_nhalf;
input icc_umips_sds;
input [31:0] icc_idata_i;	// instruction bus
input [22:0] icc_predec_i;	// predecoded instns
input icc_imiss_i;		// I$ miss
input icc_macro_jr;
input icc_umipspresent;		// UMIPS block is present
input icc_umipsri_e;		// Reserved UMIPS instn
input icc_macro_e;		// Macro instn 
input icc_macrobds_e;
input icc_nobds_e;		// Instn does not have branch delay slot
output mpc_nobds_e; 		// This instruction has no delay slot
input icc_poten_be;
input icc_parerr_i;		// Description: m14k_parity --I$ parity error detected at I stage 
input	    icc_parerrint_i;	// parity error on i-stage
input icc_parerr_w;		// Description: m14k_parity --I$ CacheOP parity error 
input icc_umips_16bit_needed;
input icc_pcrel_e;		// PC relative instn
output		mpc_usesrca_e;		      // Instn in _E uses the srcB (rt) register
output		mpc_usesrcb_e; 		      // Instn in _E uses the srcA (rs) register
output mpc_pcrel_e;		// PC relative instn
output mpc_cop_e;		// instn is a cache op
input icc_preciseibe_e;		// Bus Error on E-stage instn
input icc_preciseibe_i;		// IBE was precise in I-stage
input icc_rdpgpr_i;		// Early decode for SRS selection for RDPGPR instruction
input icc_dspver_i;
input icc_stall_i;		// I-stage stall for icc
input icc_umipsfifo_null_i;	
output icc_umipsfifo_null_w;
input [3:0] icc_umipsfifo_stat;	
input icc_umips_active;
input icc_umipsfifo_imip;
input icc_umipsfifo_ieip2;
input icc_umipsfifo_ieip4;
input mdu_busy;		// MDU busy 
input mdu_stall;		// MDU stall
input		cdmm_mputriggered_i;	// i-access in protected region
input		cdmm_mputriggered_m;	// r/w-access in protected region
input		cdmm_mmulock;
input mmu_tlbshutdown;		// TLB Shutdown condition
input mmu_dtexc_m;		// Data translation exception
input mmu_itexc_i;		// Instn translation exception
input mmu_adrerr;		// TransExc was Address error
input mmu_dtriexc_m;		    // D-addr RI exception
input mmu_itxiexc_i;		// itlb execution inhibit exception
input mmu_tlbinv;		// TransExc was TLB Invalid
input mmu_tlbmod;		// TransExc was TLB Modified
input mmu_tlbrefill;		// TransExc was TLB Refill
input mmu_iec;			// enable unique exception code for ri/xi
input mmu_r_adrerr;		// TransExc was Address error
input mmu_r_dtexc_m;		// Data translation exception
input mmu_r_dtriexc_m;		    // D-addr RI exception
input mmu_r_itexc_i;		// Instn translation exception
input mmu_r_itxiexc_i;		// itlb execution inhibit exception
input mmu_r_tlbinv;		// TransExc was TLB Invalid
input mmu_r_tlbmod;		// TransExc was TLB Modified
input mmu_r_tlbrefill;		// TransExc was TLB Refill
input mmu_r_tlbshutdown;		// TLB Shutdown condition
input mmu_r_iec;			// enable unique exception code for ri/xi

input mmu_itmack_i;		// ITLB Miss acknowledge
input mmu_dtmack_m;		// DTLB Miss Acknowledge
input mmu_tlbbusy;		// TLB is busy

output		x3_trig;
output mpc_addui_e;		// Add Upper Immediate
output mpc_alu_w;		
output mpc_aluasrc_e;		// A Source for ALU - 0:edp_abus_e 1:BBusOrImm
output mpc_alubsrc_e;		// B Source for ALU - 0:edp_abus_e 1:BBusOrImm
output [1:0] mpc_alufunc_e;		// ALU Function - 00:and 01:or 10:xor 11:nor
output mpc_alusel_m;		// Select ALU
output mpc_annulds_e;		// Annulled Delay Slot in E-stage
output mpc_apcsel_e;		// Select PC as src A
output mpc_aselres_e;		// Bypass res_m as src A
output mpc_aselwr_e;		// Bypass res_w as src A
output mpc_atepi_m;		// auto-epilogue in M-stage
output mpc_atepi_w;		// auto-epilogue in W-stage
output mpc_atomic_impr;		// atomic lead imprecise data breakpoint 
output mpc_atpro_w;		// auto-prologue in W-stage
output mpc_auexc_x;		// Exception has reached end of pipe, redirect fetch
output mpc_ndauexc_x;	    // performance counter signal. not-debug-mode exception
output mpc_bds_m;		// Instn in M-stage has branch delay slot
output [3:0] mpc_be_w;		// Byte enables for L/S
output mpc_br_e;		// branch in e-stage
output mpc_br16_e;		// UMIPS branch
output mpc_br32_e;		// MIPS32 branch
output mpc_shvar_e;		// instn is shift variable 
output mpc_brrun_ie;		// Stage I,E  is moving to next stage. 
output mpc_bselall_e;		// Bypass res_w as src B
output mpc_bselres_e;		// Bypass res_m as src B
output mpc_bsign_w;		// Sign extend to fill byte B
output mpc_cp2a_e;
output mpc_cp2tf_e;
output [22:0]	mpc_dspinfo_e;
output [31:0] mpc_buf_epc;		// EPC saved to stack during HW sequence
output [31:0] mpc_buf_srsctl;		// SRSCTL saved to stack during HW sequence
output [31:0] mpc_buf_status;		// Status saved to stack during HW sequence
output [1:0] mpc_bussize_m;		// load/store data size 
output 		mpc_tlb_exc_type;	    // i stage exception type
output [2:0] mpc_busty_raw_e;		// Bus operation type not qualified with exc_e or dcc_dmiss_m
output [2:0] mpc_busty_e;		// Bus operation type - 0-nil, 1-load, 2-store, 3-pref, 4-sync, 5-ICacheOp, 6-DCacheOp
output [2:0] mpc_busty_m;		// Bus operation type - 0-nil, 1-load, 2-store, 3-pref, 4-sync, 5-ICacheOp, 6-DCacheOp
output		mpc_strobe_e;
output		mpc_strobe_m;
output		mpc_strobe_w;
output mpc_cbstrobe_w;		// ejtag complex break strobe - not strobed on exception
output		mpc_mpustrobe_w;  // mpu region access strobe
output mpc_cdsign_w;		// Sign extend to fill upper half 
output mpc_chain_take;		// tail chain happened
output mpc_chain_vec;		// hold tail chain jump
output mpc_cleard_strobe;		// Clear EJTAG Dbits
output mpc_clinvert_e;		// Count leading 1s
output mpc_clsel_e;		// Select CL output
output mpc_clvl_e;		// Count extension
output mpc_cmov_e;		// conditional move
output mpc_cnvt_e;		// Convert/Swap Operations: SEB/SEH/WSBH
output mpc_cnvts_e;		// Convert signextension operations: SEB/SEH
output mpc_cnvtsh_e;		// Convert signextension operations: SEH
output mpc_compact_e;		// Compact branch instruction
output mpc_cont_pf_phase1;
output [3:0] mpc_coptype_m;		// CacheOp type: Raw bits from Instn
output mpc_dmsquash_w;		// Kill D$ Miss if Fixup instn is killable
output		mpc_idx_cop_e;
output mpc_continue_squash_i;
output [5:0] mpc_cp0func_e;		// cop0 function field
output mpc_ctlen_noe_e;		// Early enable signal, not qualified with exc_e
output mpc_dmsquash_m;		// Kill D$ miss due to M-stage exceptions.
output mpc_cp0diei_m;		// DI/EI
output mpc_cp0move_m;		// MT/MF C0
output [4:0] mpc_cp0r_m;		// coprocessor zero register specifier
output mpc_cp0sc_m;		// set/clear bit in C0
output [2:0] mpc_cp0sr_m;		// coprocessor zero shadow register specifier
output mpc_cp2exc;		// cp2 exc was taken
output mpc_cp1exc;		// cp1 exc was taken
output [1:0] mpc_cpnm_e;		// coprocessor number
output mpc_dcba_w;		// Select all bytes from D$
output mpc_dec_nop_w;
output mpc_defivasel_e;		// Use PC+2/4 as next PC
output mpc_deret_m;		// DERet instn
output mpc_deretval_e;		// DERet instn
output [8:0] mpc_dest_w;		// destination register (phase one WRB)
output mpc_dparerr_for_eviction;// t_dperr
output mpc_eexc_e;		// early exceptions detected in E-stage
output mpc_ekillmd_m;		// Early Kill MDU instn
output mpc_epi_vec;		// hold pc during auto epilogue until normal return or jump to next interrupt
output mpc_eqcond_e;		// Branch condition met
output mpc_eret_m;		// ERet instn
output mpc_eretval_e;		// ERet instn
output [7:0] mpc_evecsel;		// Exception Vector Selection bits
output mpc_exc_e;		// E-stage killed by exception
output mpc_exc_iae;		// exceptions happened during IAE
output mpc_exc_m;		// M-stage killed by exception 
output mpc_exc_w;		// W-stage killed by exception 
output mpc_exc_w_org;		// W-stage killed by exception 
output [4:0] mpc_exccode;		// cause PLA to encode exceptions into a 5 bit field
output mpc_expect_isa;
output mpc_ext_e;		// EXT instruction
output mpc_first_det_int;		// first cycle interrupt detected
output mpc_fixup_m;		// D$ Miss previous cycle
output mpc_fixupd;		// D$ Miss previous cycle
output mpc_fixupi;		// I$ Miss previous cycle
output mpc_fixupi_wascall;		// I$ Miss previous cycle
output mpc_hold_epi_vec;
output mpc_hold_hwintn;		// Hold hwint pins until exception taken
output mpc_hw_load_done;		// HW load operation done
output mpc_hw_load_e;
output mpc_hw_load_epc_e;		// E-stage HW load EPC operation
output mpc_hw_load_epc_m;		// M-stage HW load EPC operation
output mpc_hw_load_srsctl_e;		// E-stage HW load SRSCTL operation
output mpc_hw_load_srsctl_m;		// M-stage HW load SRSCTL operation
output mpc_hw_load_status_e;		// E-stage HW load Status operation
output mpc_hw_ls_i;
output mpc_hw_ls_e;
output mpc_chain_hold;
output mpc_hw_save_done;		// HW sequence done
output mpc_hw_save_epc_e;		// E-stage HW save EPC operation
output mpc_hw_save_epc_m;		// M-stage HW save EPC operation
output mpc_hw_save_srsctl_e;		// E-stage HW save SRSCTL operation
output mpc_hw_save_srsctl_m;		// M-stage HW save SRSCTL operation
output mpc_hw_save_status_e;		// E-stage HW save Status operation
output mpc_hw_save_status_m;		// M-stage HW save Status operation
output [31:0] mpc_hw_sp;		// sp saved to GPR during HW sequence
output mpc_iae_done_exc;		// HW load done due to exception
output mpc_ibrk_qual;
output mpc_icop_m;		// I-side cache op
output mpc_iccop_m;		// I-side cache op
output mpc_hold_int_pref_phase1_val;
output mpc_imsgn_e;		// Sign of the Immediate field
output mpc_imsquash_e;		// Kill I$ Miss due to E-stage exceptions
output mpc_imsquash_i;		// Kill I$ miss due to I-stage exceptions.
output mpc_insext_e;		// INS/EXT instruction
input [39:0]	MDU_info_e;
output [4:0] mpc_insext_size_e;		// INS/EXT filed size
output mpc_int_pref_phase1;
output mpc_pf_phase2_done;      //phase2 of prefetch is done
output mpc_int_pref;            //PC held for interrupt vector prefetch during pipeline flush or auto-prologue seqence
output mpc_int_pf_phase1_reg;
output mpc_chain_strobe;        //tail chain happen strobe
output [31:0] mpc_ir_e;		// Instruction register
output [22:0] mpc_predec_e;	// predecoded instructions propagated to e-stage
output		mpc_abs_e;		// umips operand swapped
output mpc_umipspresent;	// Indicates a native micromips decoder
output mpc_macro_e;		// macros in native umips
output		mpc_macro_end_e;	// macro end
output mpc_macro_m;
output mpc_macro_w;
output mpc_sds_e;		// short delay slot instn in native umips
output mpc_iret_m;		// M-stage IRET instruction done
output mpc_iret_ret;		// PC redirect due to IRET return
output mpc_iret_ret_start;	// start cycle of mpc_iret_ret
output mpc_ireton_e;
output	[6:0]	mpc_stkdec_in_bytes;
output mpc_iretval_e;		// E-stage IRET instruction
output mpc_irval_e;		// Instn register is valid
output mpc_irval_m;      // Instn register is valid
output mpc_irval_w;      // Instn register is valid
output mpc_isamode_e;		// E-stage instn is UMIPS
output mpc_isamode_i;		// I-stage instn is UMIPS
output mpc_isamode_m;		// M-stage isntn is UMIPS
output mpc_excisamode_i;	// changing isa when isa is not available
output		mpc_isachange0_i;  // Indicates isa change happening during abnormal pipeline process
output		mpc_isachange1_i;  // Indicates isa change happening during abnormal pipeline process
output mpc_itqualcond_i;	
output mpc_mputriggeredres_i;
output mpc_ivaval_i;		// Instn VA is valid
output mpc_jalx_e;		// JALX instn
output mpc_jamdepc_w;		// load DEPC register from EPC timing chain
output mpc_jamepc_w;		// load EPC register from EPC timing chain
output mpc_jamerror_w;		// load ErrorPC register from EPC timing chain
output mpc_jamtlb_w;		// load translation registers from shadow values
output mpc_ebld_e;		// ebase write in e stage
output mpc_ebexc_w;		// ebase exception in w stage
output mpc_jimm_e;		// jump or jump & link
output mpc_jimm_e_fc;
output mpc_jreg_e;
output mpc_jreg31_e;
output mpc_jreg31non_e;
output mpc_jreg_e_jalr;
output mpc_killcp2_w;		// Kill cp2 instn
output mpc_killcp1_w;		// Kill cp1 instn
output mpc_killmd_m;		// Kill MDU instn
output mpc_ld_causeap;
output mpc_ld_m;		
output mpc_st_m;
output [1:0] mpc_lda15_8sel_w;		// Mux select of ld_algn_w[15:8]
output [1:0] mpc_lda23_16sel_w;		// Mux select of ld_algn_w[23:16]
output [1:0] mpc_lda31_24sel_w;		// Mux select of ld_algn_w[31:24]
output [1:0] mpc_lda7_0sel_w;		// Mux select of ld_algn_w[7:7]
output mpc_ldcause;		// load cause register for exception
output mpc_ldst_e;
output mpc_ll_e;		// Load linked in E
output mpc_ll1_m;		// Load linked in first clock of M
output mpc_newiaddr;		// New Instn Address
output		mpc_umipsfifosupport_i;
output mpc_ll_m;		// Load linked in M
output mpc_lnksel_e;		// Select Link address
output mpc_lnksel_m;		// Select pc_hold for JAL/BAL/JALR
output mpc_load_m;		// Load or MFC0
output mpc_load_status_done;	
output [3:0] mpc_lsbe_m;		// Byte enables for L/S
output mpc_lxs_e;		// Load index scaled
output mpc_muldiv_w;		// MDU op in W-stage
output		mpc_pm_muldiv_e;	      // Multiply/Divide (excludes mflo and xf2 instns)
output mpc_nmitaken;		// biu_nmi exception is being taken
output mpc_nonseq_e;
output		mpc_nonseq_ep;		// nonsequential pulse
output mpc_pdstrobe_w;		// Instn Valid in W
output		mpc_ltu_e;	  // stall due to load-to-use. (for loads only)
output		mpc_mcp0stall_e;  // stall due to cp0 return data.
output		mpc_bubble_e;	  // stalls e-stage due to arithmetic/deadlock/return data reasons
output mpc_penddbe;		// DBE is pending
output mpc_pendibe;		// IBE is pending
output mpc_pexc_i;		// prior exception
output mpc_pexc_e;		// prior exception
output mpc_pexc_m;		// prior exception
output mpc_pexc_w;		// prior exception
output mpc_pm_complete;		// Instn. successfully completed
// Performance monitoring signals after I/O registers
output          PM_InstnComplete;

output mpc_prealu_cond_e;		//  cregister condition for edp.prealu_e->m
output		mpc_movci_e;

output mpc_pref_w;
output mpc_pref_m;
output mpc_qual_auexc_x;		// final cycle of mpc_auexc_x
output mpc_rega_cond_i;		// condition for rs field of instruction
output [8:0] mpc_rega_i;		// rs field of instruction
output mpc_regb_cond_i;		// condition for rt field of instruction
output [8:0] mpc_regb_i;		// rt field of instruction
output mpc_ret_e;		// ERet or DERet instn
output mpc_ret_e_ndg;		// IRET or ERET is valid in E stage
output mpc_rfwrite_w;		// Reg. File write enable
output mpc_run_i;		// I-stage Run (used for exc processing)
output mpc_run_ie;		// E-stage Run
output mpc_run_m;		// M-stage Run
output mpc_run_w;		// W-stage Run
output mpc_sbstrobe_w;		// ejtag simple break strobe
output	mpc_sbdstrobe_w;  // ejtag simple break strobe for d channels
output mpc_sbtake_w;		// Simple Break exception is being taken
output		mpc_mputake_w;	    // MPU exception being taken
output mpc_sc_e;		// Store Conditional in E
output mpc_sc_m;		// Store Conditional in M
output mpc_sdbreak_w;		// ejtag SB D-break taken (kill store)
output mpc_pcrel_m;      	// PC relative instn in M stage
output mpc_sel_hw_e;
output mpc_selcp0_m;		// Select Cp0 read data (MFC0 or SC)
output		mpc_selcp2to_m;     // Select Cp2 To data
output		mpc_selcp2from_m;     // Select Cp2 To data
output		mpc_selcp2from_w;     // Select Cp2 From data
output		mpc_selcp1to_m;     // Select Cp1 To data
output		mpc_selcp1from_m;     // Select Cp1 To data
output		mpc_selcp1from_w;     // Select Cp1 From data
output		mpc_disable_gclk_xx;
output mpc_selcp_m;		// Select Cp0 read data or Cp2 To data 
output mpc_selimm_e;		// Select immediate value for srcB
output mpc_sellogic_m;		// Select Logic Function output
output mpc_selrot_e;		// Select rotate instead of shift
output mpc_sequential_e;	// Next PC is sequential
output [4:0] mpc_shamt_e;	// 1st stage shift amount
output mpc_sharith_e;		// Shift arithmetic
output mpc_shf_rot_cond_e;		// cregister condition for edp.shf_rot_e->m
output mpc_shright_e;		// Shift is to the right
output mpc_signa_w;		// Use sign bit of byte A
output mpc_signb_w;		// Use sign bit of byte B
output mpc_signc_w;		// Use sign bit of byte C
output mpc_signd_w;		// Use sign bit of byte D
output mpc_signed_m;		// This is a signed operation
output mpc_squash_e;
output mpc_dis_int_e;	        //disable interrupt in E-stage
output mpc_squash_i;		// Squash the instn in _I by faking an Exception
output mpc_squash_m;		// Instn in M was squashed
output mpc_srcvld_e;		// Src registers are valid (for MDU)
output mpc_stall_ie;
output mpc_stall_m;
output mpc_stall_w;
output mpc_subtract_e;		// Force AGEN to do A-B
output mpc_swaph_e;		// Swap operations: WSBH
output mpc_tint;
output mpc_udisel_m;		// Select the result of UDI in M stage
output mpc_udislt_sel_m;		// Select UDI or SLT
output mpc_umips_defivasel_e;
output		mpc_umips_mirrordefivasel_e;
output mpc_updateepc_e;		// Capture a new EPC for the E-stage instn
output mpc_updateldcp_m;		// Capture Load or CP0 data
output mpc_wait_w;		// Cp0 wait operation
output mpc_wait_m;		// Cp0 wait operation
output mpc_lsdc1_m;
output mpc_lsuxc1_m;
output		mpc_ldc1_m;
output		mpc_ldc1_w;
output mpc_lsdc1_w;
output mpc_sdc1_w;
output mpc_lsdc1_e;
output mpc_lsuxc1_e;
output mpc_wr_sp2gpr;		// write stobe to update sp to GPR during HW sequence
output mpc_wr_status_m;
output mpc_wr_intctl_m;
output mpc_wr_view_ipl_m;		// write view_ipl register
output [2:0] mpc_atomic_bit_dest_w; // which bit set/clr by atomic instn
output mpc_atomic_clrorset_w;	    // set or clear by atomic bit operation
output mpc_atomic_e;		//Atomic enable 
output mpc_atomic_m;		// Atomic instruction entered into M stage for load
output mpc_atomic_store_w;	// Atomic instruction in store operation
output mpc_atomic_w;		// Atomic instruction entered into W stage for store 
output mpc_noseq_16bit_w;		// The instruction in W stage is 16bit size
output mpc_tail_chain_1st_seen;		// The instruction in W stage is IRET itself only for tailchain
output mpc_trace_iap_iae_e;		// iap and iae in E stage,data breakpoint could be traced out
input		edp_dsp_add_e;		// Add instruction from DSP
input		edp_dsp_sub_e;		// Sub instruction from DSP
input		edp_dsp_modsub_e;		
input		edp_dsp_present_xx;		
input		edp_dsp_valid_e;		
input		edp_dsp_mdu_valid_e;		
input		edp_dsp_stallreq_e;		
input		edp_dsp_pos_ge32_e;		
input		edp_dsp_dspc_ou_wren_e;		
input		MDU_stallreq_e;		
input		MDU_ouflag_mulq_muleq_xx;  // ouflag value for MULQ/MULEQ
input		MDU_ouflag_extl_extr_xx;  // ouflag value for EXTL/R
input		MDU_ouflag_vld_xx;  // ouflag value for EXTL/R
input		cpz_mx;
input		mdu_rfwrite_w;
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

output	[3:0]	mpc_dec_logic_func_m;
output	[3:0]	mpc_dec_logic_func_e;
output		mpc_dec_sh_shright_m;
output		mpc_dec_sh_shright_e;
output		mpc_dec_sh_subst_ctl_m;
output		mpc_dec_sh_subst_ctl_e;
output		mpc_dec_sh_high_sel_m;
output		mpc_dec_sh_high_sel_e;
output		mpc_append_m;
output		mpc_append_e;
output		mpc_prepend_m;
output		mpc_prepend_e;
output		mpc_balign_m;
output		mpc_balign_e;
output	[4:0]	mpc_dec_sh_high_index_m;
output	[4:0]	mpc_dec_sh_high_index_e;
output		mpc_dec_sh_low_sel_m;
output		mpc_dec_sh_low_sel_e;
output		mpc_dec_sh_low_index_4_m;
output		mpc_dec_sh_low_index_4_e;
output		mpc_dec_insv_e;
output		mpc_mf_m2_w;		
output	[15:0]	mpc_dec_imm_apipe_sh_e;
output		mpc_dec_imm_rsimm_e;
output		mpc_ctl_dsp_valid_m;
output		MDU_dec_e;
output		MDU_opcode_issue_e;
output		MDU_data_valid_e;
output		mpc_nullify_e;
output		mpc_nullify_m;
output		mpc_nullify_w;
output		mpc_mdu_m;
output		mpc_vd_m;
output		MDU_run_e;
output	 	MDU_data_ack_m;	//Data accept from MPC on MDU data
output		mpc_dec_rt_csel_e;
output		mpc_dec_rt_bsel_e;
output	[4:0]	mpc_dest_e;
output		MDU_data_val_e;
output		mpc_wrdsp_e;
	
input		cpz_vz;
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
input		cpz_g_bev;		// Bootstrap exception vectors
input           cpz_g_excisamode; // isamode for exception
input           cpz_g_bootisamode; // isamode for boot
input           cpz_g_at_epi_en;     	//enable iae
input           cpz_g_erl;
input           cpz_g_at_pro_start_i;
input           cpz_g_at_pro_start_val;
input [3:0]     cpz_g_hss;
input		cpz_g_mmutype;
input [3:0]	cpz_g_hwrena;	// HWRENA CP0 register
input [3:0]	cpz_g_copusable;		// coprocessor usable bits
input		cpz_g_kuc_e;		// Kernel/user bit - 0:=>kernel; 1:=>user
input		cpz_g_cee;	// corextend enable
input           cpz_g_usekstk;            //Use kernel stack during IAP
input           cpz_g_iap_um;
input [4:0]     cpz_g_stkdec;             //number of words for the decremented value of sp
input [7:0]     cpz_g_int_pend_ed;        //pending iterrupt
input           cpz_g_ice;                //enable tail chain
input           cpz_g_int_enable;         //interrupt enable
input [3:0]	cpz_g_srsctl_css;		// Current SRS
input [3:0]	cpz_g_srsctl_pss;		// Previous SRS
input		cpz_g_int_excl_ie_e;	
input		cpz_g_srsctl_pss2css_m;	// Copy PSS back to CSS on eret
input		cpz_g_pf;               //speculative prefetch enable
input 	    	cpz_g_rbigend_e;      // CPU is effectively in big endian mode
input 		cpz_g_eretisa;	// Target ISA for ERET or DERET (from epc or ErrorPC or depc)
input           cpz_g_causeap;            //exception happened during auto-prologue
input		cpz_g_hwrena_29;	
input		cpz_ri;
input		cpz_cp0;
input	[1:0]	cpz_at;
input		cpz_gt;
input		cpz_cg;
input		cpz_cf;
input 		dcc_g_intkill_w;           	    // Interrupt killed W-stage L/S instn
input		cpz_cgi;
input		cpz_og;
input		cpz_bg;
input		cpz_mg;
input 		cpz_pc_ctl0_ec1;
input 		cpz_pc_ctl1_ec1;
input 		cpz_g_pc_present;
input		cpz_g_ulri;
input		cpz_g_cdmm;
input		cpz_g_watch_present;
input		cpz_g_watch_present__1;
input		cpz_g_watch_present__2;
input		cpz_g_watch_present__3;
input		cpz_g_watch_present__4;
input		cpz_g_watch_present__5;
input		cpz_g_watch_present__6;
input		cpz_g_watch_present__7;
input		cp1_ufrp;
input		cpz_ufr;
input		cpz_g_ufr;
input 		cpz_g_iret_m;		// active version of M-stage IRET instn

output		mpc_g_int_pf;
output		mpc_wr_guestctl0_m;
output		mpc_wr_guestctl2_m;
output		mpc_g_cp0move_m;
output [4:0]	mpc_gexccode;	    // cause PLA to encode exceptions into a 5 bit field
output		mpc_g_exc_e;	
output		mpc_g_eexc_e;	
output		mpc_g_ldcause;	
output		mpc_g_jamepc_w;	    // load EPC register from EPC timing chain
output		mpc_g_jamtlb_w;       // load translation registers from shadow values
output		mpc_r_auexc_x;	    // Exception has reached end of pipe, redirect fetch
output		mpc_g_auexc_x;	    // Exception has reached end of pipe, redirect fetch
output		mpc_r_auexc_x_qual;
output		mpc_g_auexc_x_qual;
output		mpc_g_ld_causeap;	
output [5:0]	mpc_g_cp0func_e;
output		mpc_badins_type;	
output		mpc_tlb_i_side;	
output		mpc_tlb_d_side;	
output		mpc_ge_exc;	
output		mpc_auexc_on;	
output 		mpc_gpsi_perfcnt;
output		mpc_ctc1_fr0_m;
output		mpc_ctc1_fr1_m;
output		mpc_cfc1_fr_m;
output		mpc_rdhwr_m;
output          mpc_exc_type_w;	
output          mpc_hw_save_srsctl_i;     //select HW save operation for icc_idata_i
	
output mpc_atomic_load_e;

input		cpz_g_hotexl;		// cpz_g_exl bit from status
input		cpz_g_exl;		// cpz_g_exl bit from status
output qual_iparerr_i;		// Qualified I$ parity exception
output qual_iparerr_w;		// Qualified I$ parity exception
input [31:0] rf_bdt_e;		// regfile B read port
input [31:0] rf_adt_e;		// regfile A read port
input rf_init_done;
input cpz_rslip_e;

output bstall_ie; //for performance counter
	// End of I/O


	/*hookup*/	
	`M14K_MPCDEC_MODULE mpc_dec(
	.MDU_dec_e(MDU_dec_e),
	.MDU_info_e(MDU_info_e),
	.alu_sel_e(alu_sel_e),
	.annul_ds_i(annul_ds_i),
	.append_e(append_e),
	.at_pro_done_i(at_pro_done_i),
	.balign_e(balign_e),
	.bds_e(bds_e),
	.br_eq(br_eq),
	.br_ge(br_ge),
	.br_gr(br_gr),
	.br_le(br_le),
	.br_likely_e(br_likely_e),
	.br_lt(br_lt),
	.br_ne(br_ne),
	.break_e(break_e),
	.ce_g_un_e(ce_g_un_e),
	.ce_un_e(ce_un_e),
	.cfc1_fr_e(cfc1_fr_e),
	.cmov_type_e(cmov_type_e),
	.cmp_br(cmp_br),
	.coptype_e(coptype_e),
	.cp0_e(cp0_e),
	.cp0_r_e(cp0_r_e),
	.cp0_sr_e(cp0_sr_e),
	.cp1_coppresent(cp1_coppresent),
	.cp1_ufrp(cp1_ufrp),
	.cp_g_un_e(cp_g_un_e),
	.cp_un_e(cp_un_e),
	.cpz_at(cpz_at),
	.cpz_at_pro_start_i(cpz_at_pro_start_i),
	.cpz_at_pro_start_val(cpz_at_pro_start_val),
	.cpz_bg(cpz_bg),
	.cpz_cee(cpz_cee),
	.cpz_cf(cpz_cf),
	.cpz_cg(cpz_cg),
	.cpz_cgi(cpz_cgi),
	.cpz_copusable(cpz_copusable),
	.cpz_cp0(cpz_cp0),
	.cpz_fr(cpz_fr),
	.cpz_g_at_pro_start_i(cpz_g_at_pro_start_i),
	.cpz_g_cdmm(cpz_g_cdmm),
	.cpz_g_cee(cpz_g_cee),
	.cpz_g_copusable(cpz_g_copusable),
	.cpz_g_hss(cpz_g_hss),
	.cpz_g_hwrena(cpz_g_hwrena),
	.cpz_g_hwrena_29(cpz_g_hwrena_29),
	.cpz_g_iap_um(cpz_g_iap_um),
	.cpz_g_kuc_e(cpz_g_kuc_e),
	.cpz_g_mmutype(cpz_g_mmutype),
	.cpz_g_mx(cpz_g_mx),
	.cpz_g_pc_present(cpz_g_pc_present),
	.cpz_g_srsctl_css(cpz_g_srsctl_css),
	.cpz_g_srsctl_pss(cpz_g_srsctl_pss),
	.cpz_g_srsctl_pss2css_m(cpz_g_srsctl_pss2css_m),
	.cpz_g_ufr(cpz_g_ufr),
	.cpz_g_ulri(cpz_g_ulri),
	.cpz_g_usekstk(cpz_g_usekstk),
	.cpz_g_watch_present(cpz_g_watch_present),
	.cpz_g_watch_present__1(cpz_g_watch_present__1),
	.cpz_g_watch_present__2(cpz_g_watch_present__2),
	.cpz_g_watch_present__3(cpz_g_watch_present__3),
	.cpz_g_watch_present__4(cpz_g_watch_present__4),
	.cpz_g_watch_present__5(cpz_g_watch_present__5),
	.cpz_g_watch_present__6(cpz_g_watch_present__6),
	.cpz_g_watch_present__7(cpz_g_watch_present__7),
	.cpz_gm_e(cpz_gm_e),
	.cpz_gm_i(cpz_gm_i),
	.cpz_gt(cpz_gt),
	.cpz_hwrena(cpz_hwrena),
	.cpz_hwrena_29(cpz_hwrena_29),
	.cpz_iap_um(cpz_iap_um),
	.cpz_kuc_e(cpz_kuc_e),
	.cpz_mg(cpz_mg),
	.cpz_mmutype(cpz_mmutype),
	.cpz_mx(cpz_mx),
	.cpz_og(cpz_og),
	.cpz_pc_ctl0_ec1(cpz_pc_ctl0_ec1),
	.cpz_pc_ctl1_ec1(cpz_pc_ctl1_ec1),
	.cpz_srsctl_css(cpz_srsctl_css),
	.cpz_srsctl_pss(cpz_srsctl_pss),
	.cpz_srsctl_pss2css_m(cpz_srsctl_pss2css_m),
	.cpz_ufr(cpz_ufr),
	.cpz_usekstk(cpz_usekstk),
	.cpz_vz(cpz_vz),
	.ctc1_fr0_e(ctc1_fr0_e),
	.ctc1_fr1_e(ctc1_fr1_e),
	.dec_cp1_e(dec_cp1_e),
	.dec_dsp_exc_e(dec_dsp_exc_e),
	.dec_dsp_valid_e(dec_dsp_valid_e),
	.dec_redirect_bposge32_e(dec_redirect_bposge32_e),
	.dec_sh_high_index_e(dec_sh_high_index_e),
	.dec_sh_high_sel_e(dec_sh_high_sel_e),
	.dec_sh_low_index_4_e(dec_sh_low_index_4_e),
	.dec_sh_low_sel_e(dec_sh_low_sel_e),
	.dec_sh_shright_e(dec_sh_shright_e),
	.dec_sh_subst_ctl_e(dec_sh_subst_ctl_e),
	.dest_e(dest_e),
	.dspver_e(dspver_e),
	.edp_dsp_add_e(edp_dsp_add_e),
	.edp_dsp_mdu_valid_e(edp_dsp_mdu_valid_e),
	.edp_dsp_modsub_e(edp_dsp_modsub_e),
	.edp_dsp_present_xx(edp_dsp_present_xx),
	.edp_dsp_sub_e(edp_dsp_sub_e),
	.edp_dsp_valid_e(edp_dsp_valid_e),
	.edp_udi_honor_cee(edp_udi_honor_cee),
	.edp_udi_ri_e(edp_udi_ri_e),
	.edp_udi_wrreg_e(edp_udi_wrreg_e),
	.g_cp0_e(g_cp0_e),
	.g_p_cc_e(g_p_cc_e),
	.g_p_config_e(g_p_config_e),
	.g_p_cop_e(g_p_cop_e),
	.g_p_count_e(g_p_count_e),
	.g_p_cp0_always_e(g_p_cp0_always_e),
	.g_p_cp0_e(g_p_cp0_e),
	.g_p_deret_e(g_p_deret_e),
	.g_p_diei_e(g_p_diei_e),
	.g_p_eret_e(g_p_eret_e),
	.g_p_hypcall_e(g_p_hypcall_e),
	.g_p_idx_cop_e(g_p_idx_cop_e),
	.g_p_iret_e(g_p_iret_e),
	.g_p_og_e(g_p_og_e),
	.g_p_perfcnt_e(g_p_perfcnt_e),
	.g_p_rh_cp0_e(g_p_rh_cp0_e),
	.g_p_rwpgpr_e(g_p_rwpgpr_e),
	.g_p_srs_e(g_p_srs_e),
	.g_p_tlb_e(g_p_tlb_e),
	.g_p_wait_e(g_p_wait_e),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.hw_g_rdpgpr(hw_g_rdpgpr),
	.hw_rdgpr(hw_rdgpr),
	.hw_rdpgpr(hw_rdpgpr),
	.hw_save_i(hw_save_i),
	.icc_dspver_i(icc_dspver_i),
	.icc_halfworddethigh_i(icc_halfworddethigh_i),
	.icc_idata_i(icc_idata_i),
	.icc_imiss_i(icc_imiss_i),
	.icc_macro_e(icc_macro_e),
	.icc_macrobds_e(icc_macrobds_e),
	.icc_nobds_e(icc_nobds_e),
	.icc_predec_i(icc_predec_i),
	.icc_rdpgpr_i(icc_rdpgpr_i),
	.icc_umips_sds(icc_umips_sds),
	.icc_umipspresent(icc_umipspresent),
	.illinstn_e(illinstn_e),
	.jreg_hb_e(jreg_hb_e),
	.load_e(load_e),
	.lscop2_e(lscop2_e),
	.lsdc1_e(lsdc1_e),
	.lsdxc1_e(lsdxc1_e),
	.lsuxc1_e(lsuxc1_e),
	.mfhilo_e(mfhilo_e),
	.mpc_abs_e(mpc_abs_e),
	.mpc_addui_e(mpc_addui_e),
	.mpc_aluasrc_e(mpc_aluasrc_e),
	.mpc_alubsrc_e(mpc_alubsrc_e),
	.mpc_alufunc_e(mpc_alufunc_e),
	.mpc_annulds_e(mpc_annulds_e),
	.mpc_append_e(mpc_append_e),
	.mpc_atomic_bit_dest_e(mpc_atomic_bit_dest_e),
	.mpc_atomic_clrorset_e(mpc_atomic_clrorset_e),
	.mpc_atomic_e(mpc_atomic_e),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_balign_e(mpc_balign_e),
	.mpc_bds_m(mpc_bds_m),
	.mpc_br16_e(mpc_br16_e),
	.mpc_br32_e(mpc_br32_e),
	.mpc_br_e(mpc_br_e),
	.mpc_bussize_e(mpc_bussize_e),
	.mpc_busty_m(mpc_busty_m),
	.mpc_clinvert_e(mpc_clinvert_e),
	.mpc_clsel_e(mpc_clsel_e),
	.mpc_clvl_e(mpc_clvl_e),
	.mpc_cmov_e(mpc_cmov_e),
	.mpc_cnvt_e(mpc_cnvt_e),
	.mpc_cnvts_e(mpc_cnvts_e),
	.mpc_cnvtsh_e(mpc_cnvtsh_e),
	.mpc_cop_e(mpc_cop_e),
	.mpc_cp0func_e(mpc_cp0func_e),
	.mpc_cp2a_e(mpc_cp2a_e),
	.mpc_cp2tf_e(mpc_cp2tf_e),
	.mpc_cpnm_e(mpc_cpnm_e),
	.mpc_dec_imm_apipe_sh_e(mpc_dec_imm_apipe_sh_e),
	.mpc_dec_imm_rsimm_e(mpc_dec_imm_rsimm_e),
	.mpc_dec_insv_e(mpc_dec_insv_e),
	.mpc_dec_logic_func_e(mpc_dec_logic_func_e),
	.mpc_dec_logic_func_m(mpc_dec_logic_func_m),
	.mpc_dec_rt_bsel_e(mpc_dec_rt_bsel_e),
	.mpc_dec_rt_csel_e(mpc_dec_rt_csel_e),
	.mpc_dec_sh_high_index_e(mpc_dec_sh_high_index_e),
	.mpc_dec_sh_high_sel_e(mpc_dec_sh_high_sel_e),
	.mpc_dec_sh_low_index_4_e(mpc_dec_sh_low_index_4_e),
	.mpc_dec_sh_low_sel_e(mpc_dec_sh_low_sel_e),
	.mpc_dec_sh_shright_e(mpc_dec_sh_shright_e),
	.mpc_dec_sh_subst_ctl_e(mpc_dec_sh_subst_ctl_e),
	.mpc_dest_e(mpc_dest_e),
	.mpc_dspinfo_e(mpc_dspinfo_e),
	.mpc_ebld_e(mpc_ebld_e),
	.mpc_ext_e(mpc_ext_e),
	.mpc_fixupi(mpc_fixupi),
	.mpc_g_cp0func_e(mpc_g_cp0func_e),
	.mpc_hold_epi_vec(mpc_hold_epi_vec),
	.mpc_imsgn_e(mpc_imsgn_e),
	.mpc_imsquash_e(mpc_imsquash_e),
	.mpc_imsquash_i(mpc_imsquash_i),
	.mpc_insext_e(mpc_insext_e),
	.mpc_insext_size_e(mpc_insext_size_e),
	.mpc_int_pref_phase1(mpc_int_pref_phase1),
	.mpc_ir_e(mpc_ir_e),
	.mpc_irval_e(mpc_irval_e),
	.mpc_irvalunpred_e(mpc_irvalunpred_e),
	.mpc_isamode_e(mpc_isamode_e),
	.mpc_isamode_i(mpc_isamode_i),
	.mpc_jalx_e(mpc_jalx_e),
	.mpc_jimm_e(mpc_jimm_e),
	.mpc_jimm_e_fc(mpc_jimm_e_fc),
	.mpc_jreg31_e(mpc_jreg31_e),
	.mpc_jreg31non_e(mpc_jreg31non_e),
	.mpc_jreg_e(mpc_jreg_e),
	.mpc_jreg_e_jalr(mpc_jreg_e_jalr),
	.mpc_ldst_e(mpc_ldst_e),
	.mpc_lnksel_e(mpc_lnksel_e),
	.mpc_lsdc1_e(mpc_lsdc1_e),
	.mpc_lsdc1_m(mpc_lsdc1_m),
	.mpc_lxs_e(mpc_lxs_e),
	.mpc_macro_e(mpc_macro_e),
	.mpc_macro_end_e(mpc_macro_end_e),
	.mpc_macro_jr(mpc_macro_jr),
	.mpc_movci_e(mpc_movci_e),
	.mpc_mulgpr_e(mpc_mulgpr_e),
	.mpc_nobds_e(mpc_nobds_e),
	.mpc_pcrel_e(mpc_pcrel_e),
	.mpc_pm_muldiv_e(mpc_pm_muldiv_e),
	.mpc_prealu_cond_e(mpc_prealu_cond_e),
	.mpc_predec_e(mpc_predec_e),
	.mpc_prepend_e(mpc_prepend_e),
	.mpc_rega_cond_i(mpc_rega_cond_i),
	.mpc_rega_i(mpc_rega_i),
	.mpc_regb_cond_i(mpc_regb_cond_i),
	.mpc_regb_i(mpc_regb_i),
	.mpc_run_ie(mpc_run_ie),
	.mpc_sds_e(mpc_sds_e),
	.mpc_sel_hw_e(mpc_sel_hw_e),
	.mpc_sel_hw_load_i(mpc_sel_hw_load_i),
	.mpc_selimm_e(mpc_selimm_e),
	.mpc_selrot_e(mpc_selrot_e),
	.mpc_sharith_e(mpc_sharith_e),
	.mpc_shf_rot_cond_e(mpc_shf_rot_cond_e),
	.mpc_shright_e(mpc_shright_e),
	.mpc_shvar_e(mpc_shvar_e),
	.mpc_squash_e(mpc_squash_e),
	.mpc_squash_i(mpc_squash_i),
	.mpc_squash_i_qual(mpc_squash_i_qual),
	.mpc_subtract_e(mpc_subtract_e),
	.mpc_swaph_e(mpc_swaph_e),
	.mpc_umipsfifosupport_i(mpc_umipsfifosupport_i),
	.mpc_umipspresent(mpc_umipspresent),
	.mpc_unal_ref_e(mpc_unal_ref_e),
	.mpc_usesrca_e(mpc_usesrca_e),
	.mpc_usesrcb_e(mpc_usesrcb_e),
	.mpc_wrdsp_e(mpc_wrdsp_e),
	.muldiv_e(muldiv_e),
	.new_sc_e(new_sc_e),
	.p_cp0_diei_e(p_cp0_diei_e),
	.p_cp0_mv_e(p_cp0_mv_e),
	.p_cp0_sc_e(p_cp0_sc_e),
	.p_deret_e(p_deret_e),
	.p_eret_e(p_eret_e),
	.p_g_cp0_mv_e(p_g_cp0_mv_e),
	.p_hypcall_e(p_hypcall_e),
	.p_idx_cop_e(p_idx_cop_e),
	.p_iret_e(p_iret_e),
	.p_wait_e(p_wait_e),
	.pbus_type_e(pbus_type_e),
	.pref_e(pref_e),
	.prepend_e(prepend_e),
	.raw_ll_e(raw_ll_e),
	.raw_trap_in_e(raw_trap_in_e),
	.rddsp_e(rddsp_e),
	.rdhwr_e(rdhwr_e),
	.rf_bdt_e(rf_bdt_e),
	.ri_e(ri_e),
	.ri_g_e(ri_g_e),
	.sarop_e(sarop_e),
	.scop1_e(scop1_e),
	.scop2_e(scop2_e),
	.sdbbp_e(sdbbp_e),
	.sel_logic_e(sel_logic_e),
	.sh_fix_amt_e(sh_fix_amt_e),
	.sh_fix_e(sh_fix_e),
	.sh_var_e(sh_var_e),
	.signed_e(signed_e),
	.signed_ld_e(signed_ld_e),
	.slt_sel_e(slt_sel_e),
	.src_a_e(src_a_e),
	.src_b_e(src_b_e),
	.syscall_e(syscall_e),
	.trap_type_e(trap_type_e),
	.udi_sel_e(udi_sel_e),
	.unal_type_e(unal_type_e),
	.use_src_a_e(use_src_a_e),
	.use_src_b_e(use_src_b_e),
	.vd_e(vd_e),
	.x3_trig(x3_trig),
	.xfc1_e(xfc1_e),
	.xfc2_e(xfc2_e));

	/*hookup*/
	`M14K_MPCCTL_MODULE mpc_ctl(
	.MDU_data_ack_m(MDU_data_ack_m),
	.MDU_data_val_e(MDU_data_val_e),
	.MDU_data_valid_e(MDU_data_valid_e),
	.MDU_dec_e(MDU_dec_e),
	.MDU_opcode_issue_e(MDU_opcode_issue_e),
	.MDU_ouflag_vld_xx(MDU_ouflag_vld_xx),
	.MDU_run_e(MDU_run_e),
	.MDU_stallreq_e(MDU_stallreq_e),
	.PM_InstnComplete(PM_InstnComplete),
	.alu_sel_e(alu_sel_e),
	.annul_ds_i(annul_ds_i),
	.append_e(append_e),
	.at_epi_done_i(at_epi_done_i),
	.at_pro_done_i(at_pro_done_i),
	.balign_e(balign_e),
	.bds_e(bds_e),
	.br_eq(br_eq),
	.br_ge(br_ge),
	.br_gr(br_gr),
	.br_le(br_le),
	.br_likely_e(br_likely_e),
	.br_lt(br_lt),
	.br_ne(br_ne),
	.bstall_ie(bstall_ie),
	.cfc1_fr_e(cfc1_fr_e),
	.chain_vec_end(chain_vec_end),
	.cmov_type_e(cmov_type_e),
	.cmp_br(cmp_br),
	.continue_squash_i(continue_squash_i),
	.coptype_e(coptype_e),
	.cp0_e(cp0_e),
	.cp0_r_e(cp0_r_e),
	.cp0_sr_e(cp0_sr_e),
	.cp1_bstall_e(cp1_bstall_e),
	.cp1_btaken(cp1_btaken),
	.cp1_bvalid(cp1_bvalid),
	.cp1_copidle(cp1_copidle),
	.cp1_fixup_i(cp1_fixup_i),
	.cp1_fixup_m(cp1_fixup_m),
	.cp1_fixup_w(cp1_fixup_w),
	.cp1_movefrom_m(cp1_movefrom_m),
	.cp1_moveto_m(cp1_moveto_m),
	.cp1_stall_e(cp1_stall_e),
	.cp1_stall_m(cp1_stall_m),
	.cp2_bstall_e(cp2_bstall_e),
	.cp2_btaken(cp2_btaken),
	.cp2_bvalid(cp2_bvalid),
	.cp2_fixup_m(cp2_fixup_m),
	.cp2_fixup_w(cp2_fixup_w),
	.cp2_movefrom_m(cp2_movefrom_m),
	.cp2_moveto_m(cp2_moveto_m),
	.cp2_stall_e(cp2_stall_e),
	.cpz_at_epi_en(cpz_at_epi_en),
	.cpz_at_pro_start_i(cpz_at_pro_start_i),
	.cpz_at_pro_start_val(cpz_at_pro_start_val),
	.cpz_bev(cpz_bev),
	.cpz_bootisamode(cpz_bootisamode),
	.cpz_causeap(cpz_causeap),
	.cpz_debugmode_i(cpz_debugmode_i),
	.cpz_dm_w(cpz_dm_w),
	.cpz_eretisa(cpz_eretisa),
	.cpz_erl(cpz_erl),
	.cpz_excisamode(cpz_excisamode),
	.cpz_g_at_epi_en(cpz_g_at_epi_en),
	.cpz_g_at_pro_start_i(cpz_g_at_pro_start_i),
	.cpz_g_at_pro_start_val(cpz_g_at_pro_start_val),
	.cpz_g_bev(cpz_g_bev),
	.cpz_g_bootisamode(cpz_g_bootisamode),
	.cpz_g_causeap(cpz_g_causeap),
	.cpz_g_eretisa(cpz_g_eretisa),
	.cpz_g_erl(cpz_g_erl),
	.cpz_g_excisamode(cpz_g_excisamode),
	.cpz_g_iap_um(cpz_g_iap_um),
	.cpz_g_ice(cpz_g_ice),
	.cpz_g_int_enable(cpz_g_int_enable),
	.cpz_g_int_excl_ie_e(cpz_g_int_excl_ie_e),
	.cpz_g_int_pend_ed(cpz_g_int_pend_ed),
	.cpz_g_iret_m(cpz_g_iret_m),
	.cpz_g_mx(cpz_g_mx),
	.cpz_g_pf(cpz_g_pf),
	.cpz_g_rbigend_e(cpz_g_rbigend_e),
	.cpz_g_srsctl_css(cpz_g_srsctl_css),
	.cpz_g_srsctl_pss(cpz_g_srsctl_pss),
	.cpz_g_stkdec(cpz_g_stkdec),
	.cpz_g_usekstk(cpz_g_usekstk),
	.cpz_gm_e(cpz_gm_e),
	.cpz_gm_i(cpz_gm_i),
	.cpz_gm_m(cpz_gm_m),
	.cpz_gm_w(cpz_gm_w),
	.cpz_iap_um(cpz_iap_um),
	.cpz_ice(cpz_ice),
	.cpz_int_enable(cpz_int_enable),
	.cpz_int_excl_ie_e(cpz_int_excl_ie_e),
	.cpz_int_pend_ed(cpz_int_pend_ed),
	.cpz_iret_chain_reg(cpz_iret_chain_reg),
	.cpz_iret_m(cpz_iret_m),
	.cpz_mx(cpz_mx),
	.cpz_pf(cpz_pf),
	.cpz_rbigend_e(cpz_rbigend_e),
	.cpz_rslip_e(cpz_rslip_e),
	.cpz_srsctl_css(cpz_srsctl_css),
	.cpz_srsctl_pss(cpz_srsctl_pss),
	.cpz_stkdec(cpz_stkdec),
	.cpz_usekstk(cpz_usekstk),
	.ctc1_fr0_e(ctc1_fr0_e),
	.ctc1_fr1_e(ctc1_fr1_e),
	.dcc_ddata_m(dcc_ddata_m),
	.dcc_dmiss_m(dcc_dmiss_m),
	.dcc_ev(dcc_ev),
	.dcc_fixup_w(dcc_fixup_w),
	.dcc_spram_write(dcc_spram_write),
	.dcc_stall_m(dcc_stall_m),
	.dec_cp1_e(dec_cp1_e),
	.dec_dsp_valid_e(dec_dsp_valid_e),
	.dec_redirect_bposge32_e(dec_redirect_bposge32_e),
	.dec_sh_high_index_e(dec_sh_high_index_e),
	.dec_sh_high_sel_e(dec_sh_high_sel_e),
	.dec_sh_low_index_4_e(dec_sh_low_index_4_e),
	.dec_sh_low_sel_e(dec_sh_low_sel_e),
	.dec_sh_shright_e(dec_sh_shright_e),
	.dec_sh_subst_ctl_e(dec_sh_subst_ctl_e),
	.dest_e(dest_e),
	.dspver_e(dspver_e),
	.edp_abus_e(edp_abus_e),
	.edp_cndeq_e(edp_cndeq_e),
	.edp_dsp_dspc_ou_wren_e(edp_dsp_dspc_ou_wren_e),
	.edp_dsp_pos_ge32_e(edp_dsp_pos_ge32_e),
	.edp_dsp_present_xx(edp_dsp_present_xx),
	.edp_dsp_stallreq_e(edp_dsp_stallreq_e),
	.edp_dva_1_0_e(edp_dva_1_0_e),
	.edp_stalign_byteoffset_e(edp_stalign_byteoffset_e),
	.edp_udi_stall_m(edp_udi_stall_m),
	.ej_fdc_busy_xx(ej_fdc_busy_xx),
	.ej_fdc_int(ej_fdc_int),
	.ej_isaondebug_read(ej_isaondebug_read),
	.ej_probtrap(ej_probtrap),
	.ej_rdvec(ej_rdvec),
	.ej_rdvec_read(ej_rdvec_read),
	.ejt_dcrinte(ejt_dcrinte),
	.ejt_pdt_stall_w(ejt_pdt_stall_w),
	.ejt_stall_st_e(ejt_stall_st_e),
	.g_cp0_e(g_cp0_e),
	.gclk(gclk),
	.gfclk(gfclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.held_parerrexc_i(held_parerrexc_i),
	.hold_intpref_done(hold_intpref_done),
	.hold_pf_phase1_nosquash_i(hold_pf_phase1_nosquash_i),
	.hw_exc_m(hw_exc_m),
	.hw_exc_w(hw_exc_w),
	.hw_g_rdpgpr(hw_g_rdpgpr),
	.hw_load_epc_i(hw_load_epc_i),
	.hw_load_srsctl_i(hw_load_srsctl_i),
	.hw_rdgpr(hw_rdgpr),
	.hw_rdpgpr(hw_rdpgpr),
	.hw_save_epc_i(hw_save_epc_i),
	.hw_save_i(hw_save_i),
	.hw_save_status_i(hw_save_status_i),
	.icc_imiss_i(icc_imiss_i),
	.icc_macro_e(icc_macro_e),
	.icc_macro_jr(icc_macro_jr),
	.icc_nobds_e(icc_nobds_e),
	.icc_parerrint_i(icc_parerrint_i),
	.icc_pcrel_e(icc_pcrel_e),
	.icc_poten_be(icc_poten_be),
	.icc_preciseibe_e(icc_preciseibe_e),
	.icc_stall_i(icc_stall_i),
	.icc_umips_16bit_needed(icc_umips_16bit_needed),
	.icc_umips_active(icc_umips_active),
	.icc_umipsfifo_ieip2(icc_umipsfifo_ieip2),
	.icc_umipsfifo_ieip4(icc_umipsfifo_ieip4),
	.icc_umipsfifo_imip(icc_umipsfifo_imip),
	.icc_umipsfifo_null_i(icc_umipsfifo_null_i),
	.icc_umipsfifo_null_w(icc_umipsfifo_null_w),
	.icc_umipsfifo_stat(icc_umipsfifo_stat),
	.icc_umipspresent(icc_umipspresent),
	.icc_umipsri_e(icc_umipsri_e),
	.illinstn_e(illinstn_e),
	.int_pref_phase2(int_pref_phase2),
	.jreg_hb_e(jreg_hb_e),
	.load_e(load_e),
	.lscop2_e(lscop2_e),
	.lscop2_w(lscop2_w),
	.lsdc1_e(lsdc1_e),
	.lsdxc1_e(lsdxc1_e),
	.lsuxc1_e(lsuxc1_e),
	.mdu_alive_gpr_a(mdu_alive_gpr_a),
	.mdu_alive_gpr_m1(mdu_alive_gpr_m1),
	.mdu_alive_gpr_m2(mdu_alive_gpr_m2),
	.mdu_alive_gpr_m3(mdu_alive_gpr_m3),
	.mdu_busy(mdu_busy),
	.mdu_dest_m1(mdu_dest_m1),
	.mdu_dest_m2(mdu_dest_m2),
	.mdu_dest_m3(mdu_dest_m3),
	.mdu_dest_w(mdu_dest_w),
	.mdu_mf_a(mdu_mf_a),
	.mdu_mf_m1(mdu_mf_m1),
	.mdu_mf_m2(mdu_mf_m2),
	.mdu_mf_m3(mdu_mf_m3),
	.mdu_nullify_m2(mdu_nullify_m2),
	.mdu_rfwrite_w(mdu_rfwrite_w),
	.mdu_stall(mdu_stall),
	.mdu_stall_issue_xx(mdu_stall_issue_xx),
	.mfhilo_e(mfhilo_e),
	.mmu_dtmack_m(mmu_dtmack_m),
	.mmu_itmack_i(mmu_itmack_i),
	.mmu_r_tlbinv(mmu_r_tlbinv),
	.mmu_r_tlbrefill(mmu_r_tlbrefill),
	.mmu_tlbbusy(mmu_tlbbusy),
	.mmu_tlbinv(mmu_tlbinv),
	.mmu_tlbrefill(mmu_tlbrefill),
	.mpc_addui_e(mpc_addui_e),
	.mpc_alu_w(mpc_alu_w),
	.mpc_alusel_m(mpc_alusel_m),
	.mpc_annulds_e(mpc_annulds_e),
	.mpc_apcsel_e(mpc_apcsel_e),
	.mpc_append_m(mpc_append_m),
	.mpc_aselres_e(mpc_aselres_e),
	.mpc_aselwr_e(mpc_aselwr_e),
	.mpc_atepi_m(mpc_atepi_m),
	.mpc_atepi_w(mpc_atepi_w),
	.mpc_atomic_bit_dest_e(mpc_atomic_bit_dest_e),
	.mpc_atomic_bit_dest_w(mpc_atomic_bit_dest_w),
	.mpc_atomic_clrorset_e(mpc_atomic_clrorset_e),
	.mpc_atomic_clrorset_w(mpc_atomic_clrorset_w),
	.mpc_atomic_e(mpc_atomic_e),
	.mpc_atomic_load_e(mpc_atomic_load_e),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_atomic_store_w(mpc_atomic_store_w),
	.mpc_atomic_w(mpc_atomic_w),
	.mpc_atpro_m(mpc_atpro_m),
	.mpc_atpro_w(mpc_atpro_w),
	.mpc_auexc_x(mpc_auexc_x),
	.mpc_balign_m(mpc_balign_m),
	.mpc_bds_m(mpc_bds_m),
	.mpc_be_w(mpc_be_w),
	.mpc_br16_e(mpc_br16_e),
	.mpc_br32_e(mpc_br32_e),
	.mpc_brrun_ie(mpc_brrun_ie),
	.mpc_bselall_e(mpc_bselall_e),
	.mpc_bselres_e(mpc_bselres_e),
	.mpc_bsign_w(mpc_bsign_w),
	.mpc_bubble_e(mpc_bubble_e),
	.mpc_buf_epc(mpc_buf_epc),
	.mpc_buf_srsctl(mpc_buf_srsctl),
	.mpc_buf_status(mpc_buf_status),
	.mpc_bussize_e(mpc_bussize_e),
	.mpc_bussize_m(mpc_bussize_m),
	.mpc_busty_e(mpc_busty_e),
	.mpc_busty_m(mpc_busty_m),
	.mpc_busty_raw_e(mpc_busty_raw_e),
	.mpc_cbstrobe_w(mpc_cbstrobe_w),
	.mpc_cdsign_w(mpc_cdsign_w),
	.mpc_cfc1_fr_m(mpc_cfc1_fr_m),
	.mpc_chain_hold(mpc_chain_hold),
	.mpc_chain_strobe(mpc_chain_strobe),
	.mpc_chain_take(mpc_chain_take),
	.mpc_chain_vec(mpc_chain_vec),
	.mpc_cleard_strobe(mpc_cleard_strobe),
	.mpc_cmov_e(mpc_cmov_e),
	.mpc_compact_e(mpc_compact_e),
	.mpc_cont_pf_phase1(mpc_cont_pf_phase1),
	.mpc_continue_squash_i(mpc_continue_squash_i),
	.mpc_coptype_m(mpc_coptype_m),
	.mpc_cp0diei_m(mpc_cp0diei_m),
	.mpc_cp0move_m(mpc_cp0move_m),
	.mpc_cp0r_m(mpc_cp0r_m),
	.mpc_cp0sc_m(mpc_cp0sc_m),
	.mpc_cp0sr_m(mpc_cp0sr_m),
	.mpc_ctc1_fr0_m(mpc_ctc1_fr0_m),
	.mpc_ctc1_fr1_m(mpc_ctc1_fr1_m),
	.mpc_ctl_dsp_valid_m(mpc_ctl_dsp_valid_m),
	.mpc_ctlen_noe_e(mpc_ctlen_noe_e),
	.mpc_dcba_w(mpc_dcba_w),
	.mpc_dec_imm_apipe_sh_e(mpc_dec_imm_apipe_sh_e),
	.mpc_dec_imm_rsimm_e(mpc_dec_imm_rsimm_e),
	.mpc_dec_insv_e(mpc_dec_insv_e),
	.mpc_dec_nop_w(mpc_dec_nop_w),
	.mpc_dec_sh_high_index_m(mpc_dec_sh_high_index_m),
	.mpc_dec_sh_high_sel_m(mpc_dec_sh_high_sel_m),
	.mpc_dec_sh_low_index_4_m(mpc_dec_sh_low_index_4_m),
	.mpc_dec_sh_low_sel_m(mpc_dec_sh_low_sel_m),
	.mpc_dec_sh_shright_m(mpc_dec_sh_shright_m),
	.mpc_dec_sh_subst_ctl_m(mpc_dec_sh_subst_ctl_m),
	.mpc_defivasel_e(mpc_defivasel_e),
	.mpc_deret_m(mpc_deret_m),
	.mpc_deretval_e(mpc_deretval_e),
	.mpc_dest_w(mpc_dest_w),
	.mpc_disable_gclk_xx(mpc_disable_gclk_xx),
	.mpc_eexc_e(mpc_eexc_e),
	.mpc_ekillmd_m(mpc_ekillmd_m),
	.mpc_ekillmd_w(mpc_ekillmd_w),
	.mpc_epi_vec(mpc_epi_vec),
	.mpc_eqcond_e(mpc_eqcond_e),
	.mpc_eret_m(mpc_eret_m),
	.mpc_eret_null_m(mpc_eret_null_m),
	.mpc_eretval_e(mpc_eretval_e),
	.mpc_exc_e(mpc_exc_e),
	.mpc_exc_iae(mpc_exc_iae),
	.mpc_exc_m(mpc_exc_m),
	.mpc_exc_w(mpc_exc_w),
	.mpc_excisamode_i(mpc_excisamode_i),
	.mpc_fixup_m(mpc_fixup_m),
	.mpc_fixupd(mpc_fixupd),
	.mpc_fixupi(mpc_fixupi),
	.mpc_fixupi_wascall(mpc_fixupi_wascall),
	.mpc_g_auexc_x(mpc_g_auexc_x),
	.mpc_g_cp0move_m(mpc_g_cp0move_m),
	.mpc_hold_epi_vec(mpc_hold_epi_vec),
	.mpc_hw_load_done(mpc_hw_load_done),
	.mpc_hw_load_e(mpc_hw_load_e),
	.mpc_hw_load_epc_e(mpc_hw_load_epc_e),
	.mpc_hw_load_epc_m(mpc_hw_load_epc_m),
	.mpc_hw_load_srsctl_e(mpc_hw_load_srsctl_e),
	.mpc_hw_load_srsctl_m(mpc_hw_load_srsctl_m),
	.mpc_hw_load_status_e(mpc_hw_load_status_e),
	.mpc_hw_load_status_i(mpc_hw_load_status_i),
	.mpc_hw_ls_e(mpc_hw_ls_e),
	.mpc_hw_ls_i(mpc_hw_ls_i),
	.mpc_hw_save_done(mpc_hw_save_done),
	.mpc_hw_save_epc_e(mpc_hw_save_epc_e),
	.mpc_hw_save_epc_m(mpc_hw_save_epc_m),
	.mpc_hw_save_srsctl_e(mpc_hw_save_srsctl_e),
	.mpc_hw_save_srsctl_i(mpc_hw_save_srsctl_i),
	.mpc_hw_save_srsctl_m(mpc_hw_save_srsctl_m),
	.mpc_hw_save_status_e(mpc_hw_save_status_e),
	.mpc_hw_save_status_m(mpc_hw_save_status_m),
	.mpc_hw_sp(mpc_hw_sp),
	.mpc_iae_done_exc(mpc_iae_done_exc),
	.mpc_iccop_m(mpc_iccop_m),
	.mpc_icop_m(mpc_icop_m),
	.mpc_idx_cop_e(mpc_idx_cop_e),
	.mpc_int_pref(mpc_int_pref),
	.mpc_int_pref_phase1(mpc_int_pref_phase1),
	.mpc_ir_e(mpc_ir_e),
	.mpc_iret_m(mpc_iret_m),
	.mpc_iret_ret(mpc_iret_ret),
	.mpc_iret_ret_start(mpc_iret_ret_start),
	.mpc_ireton_e(mpc_ireton_e),
	.mpc_iretret_m(mpc_iretret_m),
	.mpc_iretval_e(mpc_iretval_e),
	.mpc_irval_e(mpc_irval_e),
	.mpc_irval_m(mpc_irval_m),
	.mpc_irval_w(mpc_irval_w),
	.mpc_irvaldsp_e(mpc_irvaldsp_e),
	.mpc_irvalunpred_e(mpc_irvalunpred_e),
	.mpc_isachange0_i(mpc_isachange0_i),
	.mpc_isachange1_i(mpc_isachange1_i),
	.mpc_isamode_e(mpc_isamode_e),
	.mpc_isamode_i(mpc_isamode_i),
	.mpc_isamode_m(mpc_isamode_m),
	.mpc_ivaval_i(mpc_ivaval_i),
	.mpc_jalx_e(mpc_jalx_e),
	.mpc_jimm_e(mpc_jimm_e),
	.mpc_jreg_e(mpc_jreg_e),
	.mpc_ld_m(mpc_ld_m),
	.mpc_lda15_8sel_w(mpc_lda15_8sel_w),
	.mpc_lda23_16sel_w(mpc_lda23_16sel_w),
	.mpc_lda31_24sel_w(mpc_lda31_24sel_w),
	.mpc_lda7_0sel_w(mpc_lda7_0sel_w),
	.mpc_ldc1_m(mpc_ldc1_m),
	.mpc_ldc1_w(mpc_ldc1_w),
	.mpc_ldst_e(mpc_ldst_e),
	.mpc_ll1_m(mpc_ll1_m),
	.mpc_ll_e(mpc_ll_e),
	.mpc_ll_m(mpc_ll_m),
	.mpc_lnksel_e(mpc_lnksel_e),
	.mpc_lnksel_m(mpc_lnksel_m),
	.mpc_load_m(mpc_load_m),
	.mpc_load_status_done(mpc_load_status_done),
	.mpc_lsbe_m(mpc_lsbe_m),
	.mpc_lsdc1_e(mpc_lsdc1_e),
	.mpc_lsdc1_m(mpc_lsdc1_m),
	.mpc_lsdc1_w(mpc_lsdc1_w),
	.mpc_lsuxc1_e(mpc_lsuxc1_e),
	.mpc_lsuxc1_m(mpc_lsuxc1_m),
	.mpc_ltu_e(mpc_ltu_e),
	.mpc_macro_e(mpc_macro_e),
	.mpc_macro_jr(mpc_macro_jr),
	.mpc_macro_m(mpc_macro_m),
	.mpc_macro_w(mpc_macro_w),
	.mpc_mcp0stall_e(mpc_mcp0stall_e),
	.mpc_mdu_m(mpc_mdu_m),
	.mpc_mf_m2_w(mpc_mf_m2_w),
	.mpc_movci_e(mpc_movci_e),
	.mpc_mpustrobe_w(mpc_mpustrobe_w),
	.mpc_muldiv_w(mpc_muldiv_w),
	.mpc_mulgpr_e(mpc_mulgpr_e),
	.mpc_newiaddr(mpc_newiaddr),
	.mpc_nobds_e(mpc_nobds_e),
	.mpc_nomacroepc_e(mpc_nomacroepc_e),
	.mpc_nonseq_e(mpc_nonseq_e),
	.mpc_nonseq_ep(mpc_nonseq_ep),
	.mpc_noseq_16bit_w(mpc_noseq_16bit_w),
	.mpc_nullify_e(mpc_nullify_e),
	.mpc_nullify_m(mpc_nullify_m),
	.mpc_nullify_w(mpc_nullify_w),
	.mpc_pcrel_e(mpc_pcrel_e),
	.mpc_pcrel_m(mpc_pcrel_m),
	.mpc_pdstrobe_w(mpc_pdstrobe_w),
	.mpc_pexc_e(mpc_pexc_e),
	.mpc_pexc_m(mpc_pexc_m),
	.mpc_pexc_w(mpc_pexc_w),
	.mpc_pf_phase2_done(mpc_pf_phase2_done),
	.mpc_pm_complete(mpc_pm_complete),
	.mpc_pref_m(mpc_pref_m),
	.mpc_pref_w(mpc_pref_w),
	.mpc_prepend_m(mpc_prepend_m),
	.mpc_qual_auexc_x(mpc_qual_auexc_x),
	.mpc_rdhwr_m(mpc_rdhwr_m),
	.mpc_ret_e(mpc_ret_e),
	.mpc_ret_e_ndg(mpc_ret_e_ndg),
	.mpc_rfwrite_w(mpc_rfwrite_w),
	.mpc_rslip_w(mpc_rslip_w),
	.mpc_run_i(mpc_run_i),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_run_w(mpc_run_w),
	.mpc_sbdstrobe_w(mpc_sbdstrobe_w),
	.mpc_sbstrobe_w(mpc_sbstrobe_w),
	.mpc_sc_e(mpc_sc_e),
	.mpc_sc_m(mpc_sc_m),
	.mpc_scop1_m(mpc_scop1_m),
	.mpc_sdc1_w(mpc_sdc1_w),
	.mpc_sel_hw_e(mpc_sel_hw_e),
	.mpc_sel_hw_load_i(mpc_sel_hw_load_i),
	.mpc_selcp0_m(mpc_selcp0_m),
	.mpc_selcp1from_m(mpc_selcp1from_m),
	.mpc_selcp1from_w(mpc_selcp1from_w),
	.mpc_selcp1to_m(mpc_selcp1to_m),
	.mpc_selcp2from_m(mpc_selcp2from_m),
	.mpc_selcp2from_w(mpc_selcp2from_w),
	.mpc_selcp2to_m(mpc_selcp2to_m),
	.mpc_selcp_m(mpc_selcp_m),
	.mpc_sellogic_m(mpc_sellogic_m),
	.mpc_sequential_e(mpc_sequential_e),
	.mpc_shamt_e(mpc_shamt_e),
	.mpc_signa_w(mpc_signa_w),
	.mpc_signb_w(mpc_signb_w),
	.mpc_signc_w(mpc_signc_w),
	.mpc_signd_w(mpc_signd_w),
	.mpc_signed_m(mpc_signed_m),
	.mpc_squash_i(mpc_squash_i),
	.mpc_squash_i_qual(mpc_squash_i_qual),
	.mpc_squash_m(mpc_squash_m),
	.mpc_srcvld_e(mpc_srcvld_e),
	.mpc_st_m(mpc_st_m),
	.mpc_stall_ie(mpc_stall_ie),
	.mpc_stall_m(mpc_stall_m),
	.mpc_stall_w(mpc_stall_w),
	.mpc_stkdec_in_bytes(mpc_stkdec_in_bytes),
	.mpc_strobe_e(mpc_strobe_e),
	.mpc_strobe_m(mpc_strobe_m),
	.mpc_strobe_w(mpc_strobe_w),
	.mpc_tail_chain_1st_seen(mpc_tail_chain_1st_seen),
	.mpc_tlb_exc_type(mpc_tlb_exc_type),
	.mpc_trace_iap_iae_e(mpc_trace_iap_iae_e),
	.mpc_udisel_m(mpc_udisel_m),
	.mpc_udislt_sel_m(mpc_udislt_sel_m),
	.mpc_umips_defivasel_e(mpc_umips_defivasel_e),
	.mpc_umips_mirrordefivasel_e(mpc_umips_mirrordefivasel_e),
	.mpc_umipsfifosupport_i(mpc_umipsfifosupport_i),
	.mpc_umipspresent(mpc_umipspresent),
	.mpc_unal_ref_e(mpc_unal_ref_e),
	.mpc_updateepc_e(mpc_updateepc_e),
	.mpc_updateldcp_m(mpc_updateldcp_m),
	.mpc_vd_m(mpc_vd_m),
	.mpc_wait_m(mpc_wait_m),
	.mpc_wait_w(mpc_wait_w),
	.mpc_wr_guestctl0_m(mpc_wr_guestctl0_m),
	.mpc_wr_guestctl2_m(mpc_wr_guestctl2_m),
	.mpc_wr_intctl_m(mpc_wr_intctl_m),
	.mpc_wr_sp2gpr(mpc_wr_sp2gpr),
	.mpc_wr_status_m(mpc_wr_status_m),
	.mpc_wr_view_ipl_m(mpc_wr_view_ipl_m),
	.mpc_wrdsp_e(mpc_wrdsp_e),
	.muldiv_e(muldiv_e),
	.new_sc_e(new_sc_e),
	.p_cp0_diei_e(p_cp0_diei_e),
	.p_cp0_mv_e(p_cp0_mv_e),
	.p_cp0_sc_e(p_cp0_sc_e),
	.p_deret_e(p_deret_e),
	.p_eret_e(p_eret_e),
	.p_g_cp0_mv_e(p_g_cp0_mv_e),
	.p_idx_cop_e(p_idx_cop_e),
	.p_iret_e(p_iret_e),
	.p_wait_e(p_wait_e),
	.pbus_type_e(pbus_type_e),
	.pend_exc(pend_exc),
	.pf_phase1_nosquash_i(pf_phase1_nosquash_i),
	.pref_e(pref_e),
	.prefx_e(prefx_e),
	.prepend_e(prepend_e),
	.qual_umipsri_e(qual_umipsri_e),
	.qual_umipsri_g_e(qual_umipsri_g_e),
	.raw_ll_e(raw_ll_e),
	.rddsp_e(rddsp_e),
	.rdhwr_e(rdhwr_e),
	.rf_adt_e(rf_adt_e),
	.rf_bdt_e(rf_bdt_e),
	.rf_init_done(rf_init_done),
	.ri_e(ri_e),
	.scop1_e(scop1_e),
	.scop2_e(scop2_e),
	.scop2_w(scop2_w),
	.sel_logic_e(sel_logic_e),
	.set_pf_auexc_nosquash(set_pf_auexc_nosquash),
	.set_pf_phase1_nosquash(set_pf_phase1_nosquash),
	.sh_fix_amt_e(sh_fix_amt_e),
	.sh_fix_e(sh_fix_e),
	.sh_var_e(sh_var_e),
	.signed_e(signed_e),
	.signed_ld_e(signed_ld_e),
	.slt_sel_e(slt_sel_e),
	.squash_e(squash_e),
	.squash_w(squash_w),
	.src_a_e(src_a_e),
	.src_b_e(src_b_e),
	.sst_instn_valid_e(sst_instn_valid_e),
	.udi_sel_e(udi_sel_e),
	.unal_type_e(unal_type_e),
	.use_src_a_e(use_src_a_e),
	.use_src_b_e(use_src_b_e),
	.vd_e(vd_e),
	.xfc1_e(xfc1_e),
	.xfc2_e(xfc2_e));

	/*hookup*/
	`M14K_MPCEXC_MODULE mpc_exc(
	.at_epi_done_i(at_epi_done_i),
	.at_pro_done_i(at_pro_done_i),
	.biu_dbe_exc(biu_dbe_exc),
	.biu_ibe_exc(biu_ibe_exc),
	.biu_lock(biu_lock),
	.biu_wbe(biu_wbe),
	.break_e(break_e),
	.cdmm_mmulock(cdmm_mmulock),
	.cdmm_mputriggered_i(cdmm_mputriggered_i),
	.cdmm_mputriggered_m(cdmm_mputriggered_m),
	.ce_g_un_e(ce_g_un_e),
	.ce_un_e(ce_un_e),
	.chain_vec_end(chain_vec_end),
	.continue_squash_i(continue_squash_i),
	.cp1_exc_w(cp1_exc_w),
	.cp1_exccode_w(cp1_exccode_w),
	.cp1_missexc_w(cp1_missexc_w),
	.cp1_seen_nodmiss_m(cp1_seen_nodmiss_m),
	.cp2_exc_w(cp2_exc_w),
	.cp2_exccode_w(cp2_exccode_w),
	.cp2_missexc_w(cp2_missexc_w),
	.cp_g_un_e(cp_g_un_e),
	.cp_un_e(cp_un_e),
	.cpz_at_pro_start_val(cpz_at_pro_start_val),
	.cpz_bev(cpz_bev),
	.cpz_bootisamode(cpz_bootisamode),
	.cpz_dm_m(cpz_dm_m),
	.cpz_dm_w(cpz_dm_w),
	.cpz_dwatchhit(cpz_dwatchhit),
	.cpz_excisamode(cpz_excisamode),
	.cpz_exl(cpz_exl),
	.cpz_ext_int(cpz_ext_int),
	.cpz_g_at_pro_start_val(cpz_g_at_pro_start_val),
	.cpz_g_bev(cpz_g_bev),
	.cpz_g_bootisamode(cpz_g_bootisamode),
	.cpz_g_dwatchhit(cpz_g_dwatchhit),
	.cpz_g_excisamode(cpz_g_excisamode),
	.cpz_g_exl(cpz_g_exl),
	.cpz_g_ext_int(cpz_g_ext_int),
	.cpz_g_hotexl(cpz_g_hotexl),
	.cpz_g_int_e(cpz_g_int_e),
	.cpz_g_int_mw(cpz_g_int_mw),
	.cpz_g_iv(cpz_g_iv),
	.cpz_g_iwatchhit(cpz_g_iwatchhit),
	.cpz_g_mx(cpz_g_mx),
	.cpz_g_pf(cpz_g_pf),
	.cpz_g_takeint(cpz_g_takeint),
	.cpz_g_wpexc_m(cpz_g_wpexc_m),
	.cpz_ghfc_i(cpz_ghfc_i),
	.cpz_ghfc_w(cpz_ghfc_w),
	.cpz_gm_e(cpz_gm_e),
	.cpz_gm_i(cpz_gm_i),
	.cpz_gm_m(cpz_gm_m),
	.cpz_gm_w(cpz_gm_w),
	.cpz_gsfc_m(cpz_gsfc_m),
	.cpz_hotdm_i(cpz_hotdm_i),
	.cpz_hotexl(cpz_hotexl),
	.cpz_hotiexi(cpz_hotiexi),
	.cpz_iexi(cpz_iexi),
	.cpz_int_e(cpz_int_e),
	.cpz_int_mw(cpz_int_mw),
	.cpz_iv(cpz_iv),
	.cpz_iwatchhit(cpz_iwatchhit),
	.cpz_mx(cpz_mx),
	.cpz_nmi_e(cpz_nmi_e),
	.cpz_nmi_mw(cpz_nmi_mw),
	.cpz_pf(cpz_pf),
	.cpz_ri(cpz_ri),
	.cpz_setdbep(cpz_setdbep),
	.cpz_setibep(cpz_setibep),
	.cpz_sst(cpz_sst),
	.cpz_takeint(cpz_takeint),
	.cpz_wpexc_m(cpz_wpexc_m),
	.dcc_dbe_killfixup_w(dcc_dbe_killfixup_w),
	.dcc_exc_nokill_m(dcc_exc_nokill_m),
	.dcc_intkill_m(dcc_intkill_m),
	.dcc_intkill_w(dcc_intkill_w),
	.dcc_ldst_m(dcc_ldst_m),
	.dcc_parerr_m(dcc_parerr_m),
	.dcc_parerr_w(dcc_parerr_w),
	.dcc_precisedbe_w(dcc_precisedbe_w),
	.debug_mode_e(debug_mode_e),
	.dec_dsp_exc_e(dec_dsp_exc_e),
	.dexc_type(dexc_type),
	.dspver_e(dspver_e),
	.edp_povf_m(edp_povf_m),
	.edp_trapeq_m(edp_trapeq_m),
	.ej_probtrap(ej_probtrap),
	.ej_rdvec(ej_rdvec),
	.ejt_cbrk_m(ejt_cbrk_m),
	.ejt_dbrk_m(ejt_dbrk_m),
	.ejt_dbrk_w(ejt_dbrk_w),
	.ejt_dvabrk(ejt_dvabrk),
	.ejt_ejtagbrk(ejt_ejtagbrk),
	.ejt_ivabrk(ejt_ivabrk),
	.g_p_cc_e(g_p_cc_e),
	.g_p_config_e(g_p_config_e),
	.g_p_cop_e(g_p_cop_e),
	.g_p_count_e(g_p_count_e),
	.g_p_cp0_always_e(g_p_cp0_always_e),
	.g_p_cp0_e(g_p_cp0_e),
	.g_p_deret_e(g_p_deret_e),
	.g_p_diei_e(g_p_diei_e),
	.g_p_eret_e(g_p_eret_e),
	.g_p_hypcall_e(g_p_hypcall_e),
	.g_p_idx_cop_e(g_p_idx_cop_e),
	.g_p_iret_e(g_p_iret_e),
	.g_p_og_e(g_p_og_e),
	.g_p_perfcnt_e(g_p_perfcnt_e),
	.g_p_rh_cp0_e(g_p_rh_cp0_e),
	.g_p_rwpgpr_e(g_p_rwpgpr_e),
	.g_p_srs_e(g_p_srs_e),
	.g_p_tlb_e(g_p_tlb_e),
	.g_p_wait_e(g_p_wait_e),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.held_parerrexc_i(held_parerrexc_i),
	.hold_intpref_done(hold_intpref_done),
	.hold_pf_phase1_nosquash_i(hold_pf_phase1_nosquash_i),
	.hw_exc_m(hw_exc_m),
	.hw_exc_w(hw_exc_w),
	.hw_load_epc_i(hw_load_epc_i),
	.hw_load_srsctl_i(hw_load_srsctl_i),
	.hw_save_epc_i(hw_save_epc_i),
	.hw_save_status_i(hw_save_status_i),
	.icc_halfworddethigh_fifo_i(icc_halfworddethigh_fifo_i),
	.icc_imiss_i(icc_imiss_i),
	.icc_macrobds_e(icc_macrobds_e),
	.icc_nobds_e(icc_nobds_e),
	.icc_parerr_i(icc_parerr_i),
	.icc_parerr_w(icc_parerr_w),
	.icc_preciseibe_e(icc_preciseibe_e),
	.icc_preciseibe_i(icc_preciseibe_i),
	.icc_slip_n_nhalf(icc_slip_n_nhalf),
	.icc_umipsfifo_null_i(icc_umipsfifo_null_i),
	.icc_umipsfifo_stat(icc_umipsfifo_stat),
	.int_pref_phase2(int_pref_phase2),
	.lscop2_w(lscop2_w),
	.mdu_stall(mdu_stall),
	.mmu_adrerr(mmu_adrerr),
	.mmu_dtexc_m(mmu_dtexc_m),
	.mmu_dtriexc_m(mmu_dtriexc_m),
	.mmu_iec(mmu_iec),
	.mmu_itexc_i(mmu_itexc_i),
	.mmu_itxiexc_i(mmu_itxiexc_i),
	.mmu_r_adrerr(mmu_r_adrerr),
	.mmu_r_dtexc_m(mmu_r_dtexc_m),
	.mmu_r_dtriexc_m(mmu_r_dtriexc_m),
	.mmu_r_iec(mmu_r_iec),
	.mmu_r_itexc_i(mmu_r_itexc_i),
	.mmu_r_itxiexc_i(mmu_r_itxiexc_i),
	.mmu_r_tlbinv(mmu_r_tlbinv),
	.mmu_r_tlbmod(mmu_r_tlbmod),
	.mmu_r_tlbrefill(mmu_r_tlbrefill),
	.mmu_r_tlbshutdown(mmu_r_tlbshutdown),
	.mmu_tlbinv(mmu_tlbinv),
	.mmu_tlbmod(mmu_tlbmod),
	.mmu_tlbrefill(mmu_tlbrefill),
	.mmu_tlbshutdown(mmu_tlbshutdown),
	.mpc_annulds_e(mpc_annulds_e),
	.mpc_atepi_m(mpc_atepi_m),
	.mpc_atepi_w(mpc_atepi_w),
	.mpc_atomic_e(mpc_atomic_e),
	.mpc_atomic_impr(mpc_atomic_impr),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_atomic_w(mpc_atomic_w),
	.mpc_atpro_m(mpc_atpro_m),
	.mpc_atpro_w(mpc_atpro_w),
	.mpc_auexc_on(mpc_auexc_on),
	.mpc_auexc_x(mpc_auexc_x),
	.mpc_badins_type(mpc_badins_type),
	.mpc_chain_strobe(mpc_chain_strobe),
	.mpc_chain_vec(mpc_chain_vec),
	.mpc_compact_e(mpc_compact_e),
	.mpc_cont_pf_phase1(mpc_cont_pf_phase1),
	.mpc_cp1exc(mpc_cp1exc),
	.mpc_cp2exc(mpc_cp2exc),
	.mpc_dis_int_e(mpc_dis_int_e),
	.mpc_dmsquash_m(mpc_dmsquash_m),
	.mpc_dmsquash_w(mpc_dmsquash_w),
	.mpc_dparerr_for_eviction(mpc_dparerr_for_eviction),
	.mpc_ebexc_w(mpc_ebexc_w),
	.mpc_ebld_e(mpc_ebld_e),
	.mpc_eexc_e(mpc_eexc_e),
	.mpc_ekillmd_m(mpc_ekillmd_m),
	.mpc_ekillmd_w(mpc_ekillmd_w),
	.mpc_eret_null_m(mpc_eret_null_m),
	.mpc_evecsel(mpc_evecsel),
	.mpc_exc_e(mpc_exc_e),
	.mpc_exc_m(mpc_exc_m),
	.mpc_exc_type_w(mpc_exc_type_w),
	.mpc_exc_w(mpc_exc_w),
	.mpc_exc_w_org(mpc_exc_w_org),
	.mpc_exccode(mpc_exccode),
	.mpc_excisamode_i(mpc_excisamode_i),
	.mpc_expect_isa(mpc_expect_isa),
	.mpc_first_det_int(mpc_first_det_int),
	.mpc_fixupi(mpc_fixupi),
	.mpc_g_auexc_x(mpc_g_auexc_x),
	.mpc_g_auexc_x_qual(mpc_g_auexc_x_qual),
	.mpc_g_eexc_e(mpc_g_eexc_e),
	.mpc_g_int_pf(mpc_g_int_pf),
	.mpc_g_jamepc_w(mpc_g_jamepc_w),
	.mpc_g_jamtlb_w(mpc_g_jamtlb_w),
	.mpc_g_ld_causeap(mpc_g_ld_causeap),
	.mpc_g_ldcause(mpc_g_ldcause),
	.mpc_ge_exc(mpc_ge_exc),
	.mpc_gexccode(mpc_gexccode),
	.mpc_gpsi_perfcnt(mpc_gpsi_perfcnt),
	.mpc_hold_hwintn(mpc_hold_hwintn),
	.mpc_hold_int_pref_phase1_val(mpc_hold_int_pref_phase1_val),
	.mpc_hw_load_epc_e(mpc_hw_load_epc_e),
	.mpc_hw_load_srsctl_e(mpc_hw_load_srsctl_e),
	.mpc_hw_load_status_e(mpc_hw_load_status_e),
	.mpc_hw_load_status_i(mpc_hw_load_status_i),
	.mpc_hw_ls_i(mpc_hw_ls_i),
	.mpc_hw_save_epc_e(mpc_hw_save_epc_e),
	.mpc_hw_save_srsctl_e(mpc_hw_save_srsctl_e),
	.mpc_hw_save_srsctl_i(mpc_hw_save_srsctl_i),
	.mpc_hw_save_status_e(mpc_hw_save_status_e),
	.mpc_ibrk_qual(mpc_ibrk_qual),
	.mpc_imsquash_e(mpc_imsquash_e),
	.mpc_imsquash_i(mpc_imsquash_i),
	.mpc_int_pf_phase1_reg(mpc_int_pf_phase1_reg),
	.mpc_int_pref(mpc_int_pref),
	.mpc_int_pref_phase1(mpc_int_pref_phase1),
	.mpc_iretret_m(mpc_iretret_m),
	.mpc_irval_e(mpc_irval_e),
	.mpc_irvaldsp_e(mpc_irvaldsp_e),
	.mpc_irvalunpred_e(mpc_irvalunpred_e),
	.mpc_isamode_i(mpc_isamode_i),
	.mpc_itqualcond_i(mpc_itqualcond_i),
	.mpc_jamdepc_w(mpc_jamdepc_w),
	.mpc_jamepc_w(mpc_jamepc_w),
	.mpc_jamerror_w(mpc_jamerror_w),
	.mpc_jamtlb_w(mpc_jamtlb_w),
	.mpc_killcp1_w(mpc_killcp1_w),
	.mpc_killcp2_w(mpc_killcp2_w),
	.mpc_killmd_m(mpc_killmd_m),
	.mpc_ld_causeap(mpc_ld_causeap),
	.mpc_ldcause(mpc_ldcause),
	.mpc_load_m(mpc_load_m),
	.mpc_lsdc1_e(mpc_lsdc1_e),
	.mpc_lsdc1_m(mpc_lsdc1_m),
	.mpc_lsdc1_w(mpc_lsdc1_w),
	.mpc_mputake_w(mpc_mputake_w),
	.mpc_mputriggeredres_i(mpc_mputriggeredres_i),
	.mpc_ndauexc_x(mpc_ndauexc_x),
	.mpc_nmitaken(mpc_nmitaken),
	.mpc_nomacroepc_e(mpc_nomacroepc_e),
	.mpc_penddbe(mpc_penddbe),
	.mpc_pendibe(mpc_pendibe),
	.mpc_pexc_e(mpc_pexc_e),
	.mpc_pexc_i(mpc_pexc_i),
	.mpc_pexc_m(mpc_pexc_m),
	.mpc_pexc_w(mpc_pexc_w),
	.mpc_pf_phase2_done(mpc_pf_phase2_done),
	.mpc_qual_auexc_x(mpc_qual_auexc_x),
	.mpc_r_auexc_x(mpc_r_auexc_x),
	.mpc_r_auexc_x_qual(mpc_r_auexc_x_qual),
	.mpc_run_i(mpc_run_i),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_run_w(mpc_run_w),
	.mpc_sbstrobe_w(mpc_sbstrobe_w),
	.mpc_sbtake_w(mpc_sbtake_w),
	.mpc_sdbreak_w(mpc_sdbreak_w),
	.mpc_squash_e(mpc_squash_e),
	.mpc_squash_i(mpc_squash_i),
	.mpc_squash_m(mpc_squash_m),
	.mpc_tint(mpc_tint),
	.mpc_tlb_d_side(mpc_tlb_d_side),
	.mpc_tlb_exc_type(mpc_tlb_exc_type),
	.mpc_tlb_i_side(mpc_tlb_i_side),
	.mpc_updateepc_e(mpc_updateepc_e),
	.new_exc_i(new_exc_i),
	.p_hypcall_e(p_hypcall_e),
	.pend_exc(pend_exc),
	.pf_phase1_nosquash_i(pf_phase1_nosquash_i),
	.qual_iparerr_i(qual_iparerr_i),
	.qual_iparerr_w(qual_iparerr_w),
	.qual_umipsri_e(qual_umipsri_e),
	.qual_umipsri_g_e(qual_umipsri_g_e),
	.raw_trap_in_e(raw_trap_in_e),
	.ri_e(ri_e),
	.ri_g_e(ri_g_e),
	.sarop_e(sarop_e),
	.scop2_w(scop2_w),
	.sdbbp_e(sdbbp_e),
	.set_pf_auexc_nosquash(set_pf_auexc_nosquash),
	.set_pf_phase1_nosquash(set_pf_phase1_nosquash),
	.squash_e(squash_e),
	.squash_w(squash_w),
	.sst_instn_valid_e(sst_instn_valid_e),
	.syscall_e(syscall_e),
	.trap_type_e(trap_type_e));



	

endmodule	// mpc
