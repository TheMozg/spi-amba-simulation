// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description:  m14k_mpc_dec
//             MIPS32 instruction decoder
//
//    $Id: \$
//    mips_repository_id: m14k_mpc_dec.mv, v 1.127.2.1 
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

module m14k_mpc_dec(
	icc_idata_i,
	icc_rdpgpr_i,
	icc_dspver_i,
	icc_macro_e,
	gscanenable,
	mpc_run_ie,
	mpc_fixupi,
	gclk,
	edp_udi_wrreg_e,
	edp_udi_ri_e,
	cpz_mmutype,
	mpc_irval_e,
	mpc_irvalunpred_e,
	edp_udi_honor_cee,
	cpz_copusable,
	cpz_cee,
	cpz_kuc_e,
	cpz_hwrena,
	cpz_hwrena_29,
	cpz_srsctl_css,
	cpz_g_srsctl_css,
	cpz_srsctl_pss,
	cpz_g_srsctl_pss,
	cpz_srsctl_pss2css_m,
	cpz_g_srsctl_pss2css_m,
	greset,
	icc_nobds_e,
	icc_macrobds_e,
	mpc_bds_m,
	mpc_isamode_e,
	icc_umipspresent,
	icc_predec_i,
	icc_halfworddethigh_i,
	icc_umips_sds,
	mpc_umipsfifosupport_i,
	icc_imiss_i,
	mpc_imsquash_e,
	mpc_squash_e,
	mpc_squash_i,
	mpc_squash_i_qual,
	mpc_imsquash_i,
	mpc_hold_epi_vec,
	cpz_at_pro_start_val,
	MDU_info_e,
	mpc_annulds_e,
	annul_ds_i,
	mpc_atomic_m,
	mpc_lsdc1_m,
	mpc_busty_m,
	hw_rdpgpr,
	hw_g_rdpgpr,
	hw_rdgpr,
	hw_save_i,
	mpc_sel_hw_load_i,
	at_pro_done_i,
	mpc_isamode_i,
	mpc_int_pref_phase1,
	cpz_iap_um,
	cpz_g_iap_um,
	cpz_usekstk,
	cpz_g_usekstk,
	cpz_at_pro_start_i,
	cpz_g_at_pro_start_i,
	cpz_mx,
	cpz_g_mx,
	cpz_fr,
	edp_dsp_add_e,
	edp_dsp_sub_e,
	edp_dsp_modsub_e,
	edp_dsp_present_xx,
	edp_dsp_valid_e,
	edp_dsp_mdu_valid_e,
	cp1_coppresent,
	mpc_lsdc1_e,
	x3_trig,
	mpc_dec_logic_func_m,
	mpc_dec_logic_func_e,
	mpc_dec_insv_e,
	mpc_dec_imm_apipe_sh_e,
	mpc_dec_imm_rsimm_e,
	dec_dsp_valid_e,
	MDU_dec_e,
	mpc_dec_rt_csel_e,
	mpc_dec_rt_bsel_e,
	dec_redirect_bposge32_e,
	rddsp_e,
	mpc_wrdsp_e,
	dec_dsp_exc_e,
	dspver_e,
	dec_sh_shright_e,
	mpc_dec_sh_shright_e,
	dec_sh_subst_ctl_e,
	mpc_dec_sh_subst_ctl_e,
	dec_sh_low_index_4_e,
	mpc_dec_sh_low_index_4_e,
	dec_sh_low_sel_e,
	mpc_dec_sh_low_sel_e,
	dec_sh_high_index_e,
	mpc_dec_sh_high_index_e,
	dec_sh_high_sel_e,
	mpc_dec_sh_high_sel_e,
	append_e,
	mpc_append_e,
	prepend_e,
	mpc_prepend_e,
	balign_e,
	mpc_balign_e,
	mpc_dest_e,
	mpc_mulgpr_e,
	dec_cp1_e,
	scop1_e,
	scop2_e,
	lscop2_e,
	p_iret_e,
	mpc_sel_hw_e,
	br_likely_e,
	raw_ll_e,
	new_sc_e,
	cp0_e,
	mpc_cpnm_e,
	cp0_r_e,
	coptype_e,
	mpc_cp0func_e,
	cp0_sr_e,
	cp_un_e,
	ce_un_e,
	p_cp0_mv_e,
	p_cp0_sc_e,
	p_cp0_diei_e,
	p_eret_e,
	p_deret_e,
	p_wait_e,
	syscall_e,
	raw_trap_in_e,
	mpc_ir_e,
	illinstn_e,
	mpc_predec_e,
	mpc_abs_e,
	mpc_umipspresent,
	mpc_nobds_e,
	udi_sel_e,
	trap_type_e,
	unal_type_e,
	mpc_unal_ref_e,
	mpc_clinvert_e,
	mpc_clvl_e,
	mpc_cmov_e,
	mpc_ebld_e,
	cmov_type_e,
	mpc_br_e,
	mpc_sds_e,
	mpc_macro_e,
	mpc_macro_end_e,
	mpc_macro_jr,
	mpc_br16_e,
	mpc_br32_e,
	mpc_pcrel_e,
	mpc_cop_e,
	mpc_shvar_e,
	mpc_usesrca_e,
	mpc_usesrcb_e,
	ri_e,
	vd_e,
	mpc_jimm_e,
	mpc_jalx_e,
	muldiv_e,
	mpc_pm_muldiv_e,
	xfc2_e,
	xfc1_e,
	mfhilo_e,
	bds_e,
	mpc_bussize_e,
	load_e,
	lsdc1_e,
	lsdxc1_e,
	lsuxc1_e,
	pbus_type_e,
	mpc_ldst_e,
	src_a_e,
	src_b_e,
	dest_e,
	use_src_b_e,
	use_src_a_e,
	mpc_jreg_e,
	jreg_hb_e,
	sarop_e,
	mpc_rega_cond_i,
	mpc_rega_i,
	mpc_regb_cond_i,
	mpc_regb_i,
	mpc_imsgn_e,
	mpc_selimm_e,
	sh_fix_e,
	sh_fix_amt_e,
	mpc_shright_e,
	sh_var_e,
	mpc_sharith_e,
	mpc_cnvt_e,
	mpc_cnvts_e,
	mpc_cnvtsh_e,
	mpc_swaph_e,
	mpc_addui_e,
	alu_sel_e,
	slt_sel_e,
	mpc_clsel_e,
	mpc_lnksel_e,
	signed_ld_e,
	mpc_subtract_e,
	signed_e,
	mpc_aluasrc_e,
	mpc_alubsrc_e,
	mpc_alufunc_e,
	sel_logic_e,
	sdbbp_e,
	break_e,
	cmp_br,
	br_le,
	br_ne,
	br_gr,
	br_eq,
	br_lt,
	br_ge,
	pref_e,
	mpc_lxs_e,
	mpc_insext_e,
	mpc_ext_e,
	mpc_insext_size_e,
	mpc_selrot_e,
	mpc_shf_rot_cond_e,
	mpc_prealu_cond_e,
	mpc_movci_e,
	p_idx_cop_e,
	mpc_atomic_e,
	mpc_atomic_clrorset_e,
	mpc_atomic_bit_dest_e,
	mpc_jimm_e_fc,
	mpc_jreg_e_jalr,
	mpc_jreg31_e,
	mpc_jreg31non_e,
	mpc_cp2a_e,
	mpc_cp2tf_e,
	mpc_dspinfo_e,
	p_g_cp0_mv_e,
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
	mpc_g_cp0func_e,
	ctc1_fr0_e,
	ctc1_fr1_e,
	cfc1_fr_e,
	rdhwr_e,
	g_cp0_e,
	cpz_g_hss,
	cpz_g_mmutype,
	cpz_gm_e,
	cpz_gm_i,
	cpz_vz,
	cpz_g_hwrena,
	cpz_g_copusable,
	cpz_g_kuc_e,
	cpz_g_cee,
	cpz_g_hwrena_29,
	cpz_cp0,
	cpz_at,
	cpz_gt,
	cpz_cg,
	cpz_cf,
	cpz_cgi,
	cpz_og,
	cpz_bg,
	cpz_mg,
	cpz_pc_ctl0_ec1,
	cpz_pc_ctl1_ec1,
	cpz_g_pc_present,
	rf_bdt_e,
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
	cpz_ufr,
	cpz_g_ufr,
	cp1_ufrp);



	/* Inputs */
	input [31:0]	icc_idata_i;		// instruction bus
	input		icc_rdpgpr_i;		// Early decode for SRS selection for RDPGPR instruction
	input		icc_dspver_i;		// identify mf/mt/hi/lo/madd/u/msub/u/mult/u
	input		icc_macro_e;		// macro in e-stage
	input 		gscanenable;            // global scan enable
	input 		mpc_run_ie;             // I/E stages run signal
	input 		mpc_fixupi;             // Fixup I$ miss
	input 		gclk;                   // global gated clock
	input [4:0] 	edp_udi_wrreg_e;        // UDI destination register
	input 		edp_udi_ri_e;           // UDI reserved instn indication
	input 		cpz_mmutype;            // MMU Type (1-Fixed, 0-TLB)
	input 		mpc_irval_e;            // Instn register is valid
	input		mpc_irvalunpred_e;	// Instn register is valid but may contain unpredictable behavior
        input 		edp_udi_honor_cee;      // Look at CEE bit
	input [3:0] 	cpz_copusable;          // Coprocessor[3:0] are usuable
        input		cpz_cee;                // CorExtend Enable
	input 		cpz_kuc_e;              // Core is in User mode
	input [3:0]	cpz_hwrena;		// HWRENA CP0 register
	input 	        cpz_hwrena_29;		// Bit29 of HWRENA CP0 register
	input [3:0]	cpz_srsctl_css;		// Current SRS
	input [3:0]	cpz_g_srsctl_css;		// Current SRS
	input [3:0]	cpz_srsctl_pss;		// Previous SRS	
	input [3:0]	cpz_g_srsctl_pss;		// Previous SRS	
	input		cpz_srsctl_pss2css_m;	// Copy PSS back to CSS on eret
	input		cpz_g_srsctl_pss2css_m;	// Copy PSS back to CSS on eret
	input		greset;
	input		icc_nobds_e;
	input		icc_macrobds_e;
	input		mpc_bds_m;
	input 		mpc_isamode_e;          // UMIPS mode
	input 		icc_umipspresent;         // UMIPS block is present
	input [22:0]	icc_predec_i;		// Specific to native umips
	input		icc_halfworddethigh_i;
	input		icc_umips_sds;
	input		mpc_umipsfifosupport_i;
	input		icc_imiss_i;
	input		mpc_imsquash_e;		// smod port
	input		mpc_squash_e;
	input		mpc_squash_i;
	input		mpc_squash_i_qual; 
	input		mpc_imsquash_i;		// smod port
	input		mpc_hold_epi_vec;
	input		cpz_at_pro_start_val;
	input [39:0]	MDU_info_e;
	input		mpc_annulds_e;		// smod port
	input		annul_ds_i;

//Atomic input
	input		mpc_atomic_m;	
	input		mpc_lsdc1_m;	
	input [2:0]	mpc_busty_m;	

	input           hw_rdpgpr;              // read sp from previous GPR in case of SRS switching
	input           hw_g_rdpgpr;              // read sp from previous GPR in case of SRS switching
        input           hw_rdgpr;               // read sp strobe for HW sequence
        input           hw_save_i;      // select HW save operation for icc_idata_i
        input           mpc_sel_hw_load_i;      // select HW load operation for icc_idata_i
	input		at_pro_done_i;		// HW save operations done
        input           mpc_isamode_i;          // I-stage instn is umips
	input		mpc_int_pref_phase1;	// phase1 of interrupt prefetch
	input		cpz_iap_um; 	        // user mode when iap
	input		cpz_g_iap_um; 	        // user mode when iap
	input           cpz_usekstk;            // Use kernel stack during IAP
	input           cpz_g_usekstk;            // Use kernel stack during IAP
        input           cpz_at_pro_start_i;     // start cycle of HW auto prologue
        input           cpz_g_at_pro_start_i;     // start cycle of HW auto prologue
	input		cpz_mx;
	input		cpz_g_mx;
	input		cpz_fr;

	input		edp_dsp_add_e;		// Add instruction from DSP
	input		edp_dsp_sub_e;		// Sub instruction from DSP
	input		edp_dsp_modsub_e;		
	input		edp_dsp_present_xx;		
	input		edp_dsp_valid_e;		
	input		edp_dsp_mdu_valid_e;		

	input 	 	cp1_coppresent;	// COP 1 is present on the interface.
	input		mpc_lsdc1_e;

	output		x3_trig;
	output	[3:0]	mpc_dec_logic_func_m;
	output	[3:0]	mpc_dec_logic_func_e;
	output		mpc_dec_insv_e;
	output	[15:0]	mpc_dec_imm_apipe_sh_e;
	output		mpc_dec_imm_rsimm_e;
	output		dec_dsp_valid_e;
	output		MDU_dec_e;
	output		mpc_dec_rt_csel_e;
	output		mpc_dec_rt_bsel_e;
	output		dec_redirect_bposge32_e;
	output		rddsp_e;
	output		mpc_wrdsp_e;
	output		dec_dsp_exc_e;
	output		dspver_e;
	output		dec_sh_shright_e;
	output		mpc_dec_sh_shright_e;
	output		dec_sh_subst_ctl_e;
	output		mpc_dec_sh_subst_ctl_e;
	output		dec_sh_low_index_4_e;
	output		mpc_dec_sh_low_index_4_e;
	output		dec_sh_low_sel_e;
	output		mpc_dec_sh_low_sel_e;
	output	[4:0]	dec_sh_high_index_e;
	output	[4:0]	mpc_dec_sh_high_index_e;
	output		dec_sh_high_sel_e;
	output		mpc_dec_sh_high_sel_e;
	output		append_e;
	output		mpc_append_e;
	output		prepend_e;
	output		mpc_prepend_e;
	output		balign_e;
	output		mpc_balign_e;
	output	[4:0]	mpc_dest_e;
	output 		mpc_mulgpr_e;
	
	output		dec_cp1_e;
	output		scop1_e;
	output		scop2_e;
	output		lscop2_e;

        output          p_iret_e;               // Possible IRET instn
	output		mpc_sel_hw_e;		// select hw ops

	output 		br_likely_e;            // branch likely
	output 		raw_ll_e;               // load linked
	output 		new_sc_e;               // store conditional
	output 		cp0_e;                  // cop0 operation
	output [1:0] 	mpc_cpnm_e;             // coprocessor number
	output [4:0] 	cp0_r_e;                // cop0 register number
	output [3:0] 	coptype_e;             // cacheop type
	output [5:0] 	mpc_cp0func_e;          // cop0 function field
	output [2:0] 	cp0_sr_e;               // cop0 shadow register number
	output 		cp_un_e;                // cop unusable exception
	output 		ce_un_e;                // corextend unusable exception
	output 		p_cp0_mv_e;             // possible cop0 move instn MFC0/MTC0/DI/EI
	output 		p_cp0_sc_e;             // possible set/clear CP0 instn
	output 		p_cp0_diei_e;           // possible DI/EI instn
	output 		p_eret_e;               // possible ERET
	output 		p_deret_e;              // possible DERET
	output 		p_wait_e;               // possible WAIT
	output 		syscall_e;              // SYSCALL exception
	output 		raw_trap_in_e;          // Trap instn
	output [31:0] 	mpc_ir_e;               // Instruction register
	output          illinstn_e;
	output [22:0]	mpc_predec_e;		// predecoded instructions propagated to e-stage
	output		mpc_abs_e;		// umips operand swapped
	output		mpc_umipspresent;	// Indicates a native micromips decoder
	output		mpc_nobds_e;		// This is a compact instruction

	output 		udi_sel_e;              // Select UDI result
	output 		trap_type_e;            // Type of trap
	output 		unal_type_e;            // Type of unaligned reference
	output 		mpc_unal_ref_e;             // unaligned reference (L/SWL/R)
	output 		mpc_clinvert_e;         // Count leading 1s
        output 		mpc_clvl_e;             // Count extension
	output 		mpc_cmov_e;             // conditional move
	output		mpc_ebld_e;		// mtc0 to ebase
	output 		cmov_type_e;            // type of cmov
	
// Common outputs	
	output		mpc_br_e;		// branch in e-stage
	output		mpc_sds_e;		// smod port. instruction has short DS
	output		mpc_macro_e;		// smod port. macro instruction for 32 instns only
	output		mpc_macro_end_e;	// macro end
	output		mpc_macro_jr;		// macro jump cmd
	output 		mpc_br16_e;                   // UMIPS branch
	output 		mpc_br32_e;                   // MIPS32 branch
	output		mpc_pcrel_e;
//verilint 528 off        // Variable set but not used
	output		mpc_cop_e;		// instn is a cache op
	output		mpc_shvar_e;		// instn is shift variable 
	output		mpc_usesrca_e;		      // Instn in _E uses the srcB (rt) register
	output		mpc_usesrcb_e; 		      // Instn in _E uses the srcA (rs) register
//verilint 528 on        // Variable set but not used
	output 		ri_e;                         // Reserved instruction trap
	output 		vd_e;                         // valid destination
	output 		mpc_jimm_e;                   // jump or jump & link
//	output 		jalx_e;                       // JALX instn - obsolete
	output		mpc_jalx_e;		      // JALX instn
	output 		muldiv_e;                     // Multiply/Divide operation
	output		mpc_pm_muldiv_e;	      // Multiply/Divide (excludes mflo and xf2 instns)
	output 		xfc2_e;                       // MFC2/CFC2
	output 		xfc1_e;                       // MFC1/CFC1
	output 		mfhilo_e;                     // MFHI/MFLO (treated specially for MDU stalls)
	output 		bds_e;                        // This instn has a branch delay slot
	output [1:0] 	mpc_bussize_e;                // Size of request: 00-byte, 01-half, 10-unaligned, 11-word
	output 		load_e;                       // Direction of xfer for l/s/cpmv: 1 - to proc, 0 - from prc
	output 		lsdc1_e;                      // LDC1, SDC1 
	output 		lsdxc1_e;                      // LDC1, SDC1 
	output 		lsuxc1_e;                      // LDC1, SDC1 
	output [2:0] 	pbus_type_e;                  // 0-nil, 1-load, 2-store, 3-pref, 4-sync, 5-ICacheOp, 6-DCacheOp
	output 		mpc_ldst_e;                       // Load or store op
	output [4:0] 	src_a_e;                      // rs field of instruction
	output [5:0] 	src_b_e;                      // rt field of instruction, bit 5 : 0=css, 1=pss
	output [5:0] 	dest_e;                       // destination register of instruction, bit 5 : 0=css, 1=pss
	output 		use_src_b_e;                  // Instn in _E uses the srcB (rt) register
	output 		use_src_a_e;                  // Instn in _E uses the srcA (rs) register
	output 		mpc_jreg_e;                   // Jump register
	output 		jreg_hb_e;                // Jump register HB
	output 		sarop_e;                      // Signed arithmetic op
	output		mpc_rega_cond_i;              // condition for rs field of instruction
	output [8:0] 	mpc_rega_i;                   // rs field of instruction
	output		mpc_regb_cond_i;              // condition for rt field of instruction
	output [8:0] 	mpc_regb_i;                   // rt field of instruction
	output 		mpc_imsgn_e;                  // Sign of the Immediate field
	output 		mpc_selimm_e;                 // Select immediate value for srcB
	output 		sh_fix_e;                     // Shift instn w/ fixed amount
	output [4:0] 	sh_fix_amt_e;                 // Shift amount for fixed shift
	output 		mpc_shright_e;                // Shift is to the right
	output 		sh_var_e;                     // Shift instn w/ variable amount
	output 		mpc_sharith_e;                // Shift arithmetic
	output 		mpc_cnvt_e;                   // Convert/Swap Operations: SEB/SEH/WSBH
	output 		mpc_cnvts_e;                  // Convert signextension operations: SEB/SEH
	output 		mpc_cnvtsh_e;                 // Convert signextension operations: SEH
	output 		mpc_swaph_e;                  // Swap operations: WSBH
	output 		mpc_addui_e;                  // Add Upper Immediate
	output 		alu_sel_e;                    // Select ALU output
	output 		slt_sel_e;                    // Select SLT output
	output 		mpc_clsel_e;                  // Select CL output
	output 		mpc_lnksel_e;                 // Select Link address
	output 		signed_ld_e;                  // Signed Load instn
	output 		mpc_subtract_e;               // Force AGEN to do A-B
	output 		signed_e;                     // SLT/Trap instn is signed
	output 		mpc_aluasrc_e;                // A Source for ALU - 0:edp_abus_e 1:BBusOrImm
	output 		mpc_alubsrc_e;                // B Source for ALU - 0:edp_abus_e 1:BBusOrImm
	output [1:0] 	mpc_alufunc_e;                // ALU Function - 00:and 01:or 10:xor 11:nor
	output 		sel_logic_e;                  // Select Logic output
	output 		sdbbp_e;                      // Software DeBug BreakPoint instn
	output 		break_e;                      // Break instn
	output 		cmp_br;                       // Comparison branch instn
	output 		br_le;                        // Branch on <=
	output 		br_ne;                        // Branch on !=
	output 		br_gr;                        // Branch on >
	output 		br_eq;                        // Branch on ==
	output 		br_lt;                        // Branch on <
	output 		br_ge;                        // Branch on >=
	output		pref_e;			      // Pref Inst.

	output		mpc_lxs_e;                    // Load index scaled

	output		mpc_insext_e;		// INS/EXT instruction
	output		mpc_ext_e;		// EXT instruction
	output [4:0]	mpc_insext_size_e;	// INS/EXT filed size

	output		mpc_selrot_e;                 // Select rotate instead of shift

	output		mpc_shf_rot_cond_e;	// cregister condition for edp.shf_rot_e->m
	output		mpc_prealu_cond_e;	//  cregister condition for edp.prealu_e->m
	output		mpc_movci_e;

	output		p_idx_cop_e;
//Atomic output;
	output 		mpc_atomic_e;
	output 		mpc_atomic_clrorset_e;
	output [2:0]    mpc_atomic_bit_dest_e;
	output 		mpc_jimm_e_fc;
	output		mpc_jreg_e_jalr;

	output		mpc_jreg31_e;
	output		mpc_jreg31non_e;
	output		mpc_cp2a_e;
	output		mpc_cp2tf_e;

	output [22:0]	mpc_dspinfo_e;

	output		p_g_cp0_mv_e;
	output		ri_g_e;
	output		ce_g_un_e;
	output		cp_g_un_e;
	output		g_p_eret_e;
	output		g_p_iret_e;
	output		g_p_deret_e;
	output		g_p_hypcall_e;
	output		g_p_diei_e;
	output		g_p_cop_e;
	output		g_p_wait_e;
	output		g_p_idx_cop_e;
	output		g_p_perfcnt_e;
	output		g_p_tlb_e;
	output		g_p_config_e;
	output		g_p_cc_e;
	output		g_p_rh_cp0_e;
	output		g_p_count_e;
	output		g_p_srs_e;
	output		g_p_rwpgpr_e;
	output		g_p_cp0_always_e;
	output		g_p_cp0_e;
	output		g_p_og_e;
	output		p_hypcall_e;
	output [5:0]	mpc_g_cp0func_e;
	output		ctc1_fr0_e;
	output		ctc1_fr1_e;
	output		cfc1_fr_e;
	output		rdhwr_e;
	output 		g_cp0_e;                  // cop0 operation
	
	input	[3:0]	cpz_g_hss;
	input		cpz_g_mmutype;
	input		cpz_gm_e;
	input		cpz_gm_i;
	input		cpz_vz;
	input [3:0]	cpz_g_hwrena;	// HWRENA CP0 register
	input [3:0]	cpz_g_copusable;		// coprocessor usable bits
	input		cpz_g_kuc_e;		// Kernel/user bit - 0:=>kernel; 1:=>user
	input		cpz_g_cee;	// corextend enable
	input		cpz_g_hwrena_29;	
	input		cpz_cp0;
	input	[1:0]	cpz_at;
	input		cpz_gt;
	input		cpz_cg;
	input		cpz_cf;
	input		cpz_cgi;
	input		cpz_og;
	input		cpz_bg;
	input		cpz_mg;
	input cpz_pc_ctl0_ec1;
	input cpz_pc_ctl1_ec1;
	input cpz_g_pc_present;
	input [31:0]	rf_bdt_e;		// edp_bbus_e data from register file
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
	input		cpz_ufr;
	input		cpz_g_ufr;
	input		cp1_ufrp;

// BEGIN Wire declarations made by MVP
wire mpc_sds_e;
wire ri_e;
wire [5:0] /*[5:0]*/ dest_e;
wire cp_g_un_e;
wire [5:0] /*[5:0]*/ mpc_cp0func_e;
wire sel_hw_e;
wire [3:0] /*[3:0]*/ mpc_dec_logic_func_e;
wire mpc_dec_sh_low_sel_e;
wire br_likely_e;
wire dec_sh_subst_ctl_e;
wire cp_un_e;
wire ce_un_e;
wire spec3_g_ri_e;
wire [4:0] /*[4:0]*/ mpc_dest_e;
wire fpr32;
wire [1:0] /*[1:0]*/ dec_dsp_logic_func_e;
wire cp2_e;
wire mpc_clsel_e;
wire cfc1_fr_e;
wire lsdc1_e;
wire dec_sh_high_sel_e;
wire break_e;
wire mpc_macro_end_e;
wire sel_logic_e;
wire g_p_config_e;
wire mpc_insext_e;
wire mpc_dec_imm_rsimm_e;
wire mpc_sharith_e;
wire [4:0] /*[4:0]*/ dec_sh_high_index_e;
wire sync_e;
wire cp1_d_e;
wire [4:0] /*[4:0]*/ cp0_r_e;
wire mpc_atomic_e;
wire mpc_cnvt_e;
wire dec_shft_left_e;
wire lwx_e;
wire mpc_selimm_e;
wire mpc_rega_cond_i;
wire cp2_ri_e;
wire cp1_wl_e;
wire trap_type_e;
wire MDU_dec_e;
wire cp1_s_e;
wire cmp_br;
wire use_src_b_e;
wire mpc_ext_e;
wire bds_size_err;
wire g_p_cp0_e;
wire br_ne;
wire br_ge;
wire sdbbp_e;
wire cp_vd_e;
wire mpc_jalx_e;
wire [2:0] /*[2:0]*/ cp0_sr_e;
wire cp0_g_ri_e;
wire dec_shll_e;
wire mpc_umipspresent;
wire rddsp_e;
wire sh_var_e;
wire mpc_jimm_e;
wire mpc_wrdsp_e;
wire mpc_cnvtsh_e;
wire xfc2_e;
wire prepend_e;
wire p_eret_e;
wire pref_e;
wire spec3_vd_e;
wire alu_sel_e;
wire spec2_e;
wire scop2_e;
wire synci_e;
wire [1:0] /*[1:0]*/ mpc_cpnm_e;
wire [4:0] /*[4:0]*/ mpc_insext_size_e;
wire vd_e;
wire dspver_e;
wire dec_cp1_e;
wire mpc_addui_e;
wire spec_vd_e;
wire g_p_iret_e;
wire [22:0] /*[22:0]*/ mpc_predec_e;
wire vcp0_op_e;
wire mpc_jreg31non_e;
wire p_deret_e;
wire mfhilo_e;
wire rwpgpr_e;
wire lbux_e;
wire br_cond;
wire base_dsp_exc_e;
wire mpc_selrot_e;
wire slt_sel_e;
wire rdhwr_e;
wire mpc_macro_jr;
wire prefx_e;
wire [2:0] /*[2:0]*/ mpc_atomic_bit_dest_e;
wire umips_ri_e;
wire icc_halfworddethigh_e;
wire g_vcp0_op_e;
wire cop_e;
wire [22:0] /*[22:0]*/ mpc_dspinfo_e;
wire ce_g_un_e;
wire mfttr_inst0_e;
wire [8:0] /*[8:0]*/ mpc_regb_i;
wire scop1_e;
wire mpc_shf_rot_cond_e;
wire special_e;
wire [4:0] /*[4:0]*/ pdest_e;
wire mpc_subtract_e;
wire [5:0] /*[5:0]*/ src_b_e;
wire [8:0] /*[8:0]*/ mpc_rega_i;
wire dec_insv_e;
wire mpc_aluasrc_e;
wire mpc_sel_hw_e;
wire bds_e;
wire illinstn_e;
wire dec_dsp_valid_e;
wire p_g_cp0_mv_e;
wire mpc_nobds_e;
wire cp3_ri_e;
wire cp0_ri_e;
wire dec_redirect_bposge32_e;
wire g_p_tlb_e;
wire [4:0] /*[4:0]*/ sh_fix_amt_e;
wire mpc_dec_rt_csel_e;
wire mpc_usesrcb_e;
wire br_le;
wire maj_vd_e;
wire mpc_dec_sh_shright_e;
wire mpc_pm_muldiv_e;
wire mpc_unal_ref_e;
wire sdc1_ri_e;
wire amds_e;
wire [4:0] /*[4:0]*/ src_a_e;
wire g_p_rwpgpr_e;
wire dec_sh_low_sel_e;
wire balign_e;
wire lsuxc1_e;
wire g_p_og_e;
wire [31:0] /*[31:0]*/ mpc_ir_e;
wire cp_ls_un_e;
wire [15:0] /*[15:0]*/ mpc_dec_imm_apipe_sh_e;
wire cmov_type_e;
wire maj_ri_e;
wire mpc_jimm_e_fc;
wire raw_trap_in_e;
wire mpc_lnksel_e;
wire x3_trig;
wire dec_mdu_e;
wire spec2_vd_e;
wire mpc_dec_sh_low_index_4_e;
wire sarop_e;
wire mpc_cp2tf_e;
wire cp0_e;
wire g_p_rh_cp0_e;
wire [4:0] /*[4:0]*/ mpc_dec_sh_high_index_e;
wire lx_e;
wire val_pref_hint_e;
wire spec2_ri_e;
wire hw_op;
wire ctc1_fr0_e;
wire spec_ri_e;
wire mpc_br32_e;
wire mpc_clvl_e;
wire sh_fix_e;
wire cp_g_ls_un_e;
wire xl_trig;
wire p_idx_cop_e;
wire [31:0] /*[31:0]*/ int_ir_e;
wire g_p_deret_e;
wire mpc_jreg_e;
wire append_e;
wire lhx_e;
wire use_src_a_e;
wire mpc_dec_sh_subst_ctl_e;
wire mpc_atomic_clrorset_e;
wire muldiv_e;
wire mpc_dec_insv_e;
wire mpc_jreg_e_jalr;
wire rdpgpr_e;
wire mpc_ebld_e;
wire p_cp0_sc_e;
wire mpc_movci_e;
wire mpc_shvar_e;
wire mpc_dec_rt_bsel_e;
wire mpc_mulgpr_e;
wire mpc_jreg31_e;
wire dsp_mdu_valid_e;
wire dsp_valid_qual_e;
wire mpc_br16_e;
wire mpc_prealu_cond_e;
wire spec3_e;
wire br_lt;
wire raw_ll_e;
wire syscall_e;
wire mpc_regb_cond_i;
wire ctc1_fr1_e;
wire mpc_append_e;
wire mpc_cp2a_e;
wire p_hypcall_e;
wire p_iret_e;
wire g_p_cop_e;
wire g_p_eret_e;
wire mpc_lxs_e;
wire br_eq;
wire g_p_wait_e;
wire dest_cnvt_dsp_e;
wire g_p_hypcall_e;
wire mpc_imsgn_e;
wire dec_sh_shright_e;
wire g_p_cc_e;
wire p_cp0_diei_e;
wire lnk31_e;
wire p_wait_e;
wire lscop2_e;
wire cp1_ri_e;
wire g_cp0_e;
wire regimm_ri_e;
wire mpc_br_e;
wire [2:0] /*[2:0]*/ pbus_type_e;
wire [1:0] /*[1:0]*/ dec_logic_func_e;
wire mpc_macro_e;
wire mpc_shright_e;
wire regimm_e;
wire cpin_e;
wire p_cp0_mv_e;
wire g_p_idx_cop_e;
wire signed_ld_e;
wire xfc1_e;
wire mpc_clinvert_e;
wire mpc_alubsrc_e;
wire g_p_cp0_always_e;
wire mpc_swaph_e;
wire lsdxc1_e;
wire g_p_perfcnt_e;
wire unal_type_e;
wire mpc_ldst_e;
wire mpc_cop_e;
wire dec_special3_sll_e;
wire ri_g_e;
wire [1:0] /*[1:0]*/ mpc_bussize_e;
wire g_p_diei_e;
wire cp1_e;
wire mpc_cmov_e;
wire [1:0] /*[1:0]*/ mpc_lnksel_e_countdown;
wire dec_sh_low_index_4_e;
wire sds_m;
wire signed_e;
wire mpc_usesrca_e;
wire dec_dsp_exc_e;
wire g_p_count_e;
wire [31:0] /*[31:0]*/ hw_ir_e;
wire andlink_m;
wire g_p_srs_e;
wire mpc_prepend_e;
wire mpc_lnksel_e_X;
wire [5:0] /*[5:0]*/ mpc_g_cp0func_e;
wire mpc_abs_e;
wire udi_sel_e;
wire [3:0] /*[3:0]*/ mpc_dec_logic_func_m;
wire [1:0] /*[1:0]*/ mpc_alufunc_e;
wire mpc_pcrel_e;
wire br_gr;
wire mpc_dec_sh_high_sel_e;
wire new_sc_e;
wire mpc_balign_e;
wire [3:0] /*[3:0]*/ coptype_e;
wire mpc_cnvts_e;
wire jreg_hb_e;
wire spec3_ri_e;
wire ldc1_ri_e;
wire load_e;
// END Wire declarations made by MVP


	assign mpc_dspinfo_e [22:0] = 23'b0;		
	assign mpc_predec_e[22:0] = 23'b0;
	assign mpc_abs_e = 1'b0;
	assign mpc_umipspresent = 1'b0;
	assign mpc_macro_e = 1'b0;
	assign mpc_macro_end_e = 1'b0;
	assign mpc_macro_jr = 1'b0;
	assign mpc_sds_e = 1'b0;
	assign mpc_pcrel_e = 1'b0;
	assign mpc_nobds_e = 1'b0;
	assign x3_trig = 1'b0;

// mpc_ir_e decoding
// Decode Major opcodes that have minor opcode tables	
	// special_e: Special instruction decode
	assign special_e =	(mpc_ir_e[31:26] == 6'o0);	

	// regimm_e: Register Immediate decode
	assign regimm_e =	(mpc_ir_e[31:26] == 6'o1);

	// spec2_e: Special 2
	assign spec2_e =       (mpc_ir_e[31:26] == 6'o34);

	// spec3_e: Special 3
	assign spec3_e =       (mpc_ir_e[31:26] == 6'o37);

	// cpin_e: Co Processor instruction - COPx
	assign cpin_e =	(mpc_ir_e[31:28] == 4'b010_0);

// Reserved Instruction and Valid Destination Decoding	
	// ri_e: Reserved instruction trap
	assign ri_e =	(maj_ri_e || spec_ri_e || regimm_ri_e || cp0_ri_e || cp2_ri_e || cp1_ri_e || cp3_ri_e ||
	      spec2_ri_e || umips_ri_e || spec3_ri_e || illinstn_e) & ~cpz_gm_e;	

	assign ri_g_e =	(maj_ri_e || spec_ri_e || regimm_ri_e || cp0_g_ri_e || cp2_ri_e || cp1_ri_e || cp3_ri_e ||
	      spec2_ri_e || umips_ri_e || spec3_g_ri_e || illinstn_e) & cpz_gm_e;	


	assign amds_e = mpc_bds_m;
	assign illinstn_e = amds_e & (mpc_br_e || 
				regimm_e && (mpc_ir_e[20:16] == 5'o07) && !mpc_atomic_m /*mpc_atomic_e*/ || 
				icc_macro_e || 
				p_wait_e || p_eret_e || p_iret_e || p_deret_e || 
				((mpc_ir_e[31:27] == 5'b1) || (mpc_ir_e[31:26] == 6'o35)) /*mpc_jimm_e*/ || 
				special_e && (mpc_ir_e[5:1] == 5'b001_00) /*mpc_jreg_e*/ || 
				/*bds_size_err ||*/
			        ((mpc_ir_e[25:24] == 2'h1) && (^mpc_ir_e[27:26]) && cpin_e) 
				);
	mvp_cregister #(1) _sds_m(sds_m,mpc_run_ie, gclk, icc_umips_sds);
	mvp_cregister #(1) _andlink_m(andlink_m,mpc_run_ie, gclk, lnk31_e | mpc_jreg_e_jalr & (mpc_ir_e[15:11] != 5'o0));
	assign bds_size_err = (sds_m ^ icc_halfworddethigh_e) & andlink_m;
	mvp_cregister #(1) _icc_halfworddethigh_e(icc_halfworddethigh_e,(mpc_run_ie | mpc_fixupi) & ~mpc_atomic_e & ~mpc_lsdc1_e, gclk, icc_halfworddethigh_i);

	// maj_ri_e: illegal instruction decode from major opcode
	assign maj_ri_e = (mpc_ir_e[31:28] == 4'b011_0) ||
		 (mpc_ir_e[31:26] == 6'o36) ||
		 (mpc_ir_e[31:26] == 6'o47) ||	
		 (mpc_ir_e[31:27] == 5'b101_10) ||
		 (mpc_ir_e[31:26] == 6'o64) ||
		 (mpc_ir_e[31:26] == 6'o67) ||
		 (mpc_ir_e[31:26] == 6'o74) ||
		 (mpc_ir_e[31:26] == 6'o77) ||
		 (mpc_ir_e[31:26] == 6'o73);

	// cp0_ri_e: illegal cp0 instn decode
	assign cp0_ri_e = (mpc_ir_e[31:26] == 6'o20) &    					// Cp0 Major Opcode
		    ~((mpc_ir_e[25:21] == 5'o00) | 					// MTC0
		      (mpc_ir_e[25:21] == 5'o04) |					// MFC0
		      (mpc_ir_e[25:21] == 5'o03) & ~(mpc_ir_e[10] | mpc_ir_e[8]) & cpz_vz | // MFGC0/MTGC0
		      ((mpc_ir_e[25:21] == 5'o13) & (mpc_ir_e[15:6] == 10'b0110000000) &
						    (mpc_ir_e[4:0] == 5'b00000)) | 	// DI/EI
		      (mpc_ir_e[25:21] == 5'o12) |					// RDPGPR
		      (mpc_ir_e[25:21] == 5'o16) |					// WRPGPR
		      (mpc_ir_e[25] & ((mpc_ir_e[5:0] == 6'o01) & (~cpz_mmutype | cpz_vz) |	// TLBR
				       (mpc_ir_e[5:0] == 6'o11) & ~cpz_g_mmutype & cpz_vz | 	// TLBGR
				       (mpc_ir_e[5:0] == 6'o02) & (~cpz_mmutype | cpz_vz) | 	// TLBWI
				       (mpc_ir_e[5:0] == 6'o12) & ~cpz_g_mmutype & cpz_vz | 	// TLBGWI
				       (mpc_ir_e[5:0] == 6'o06) & (~cpz_mmutype | cpz_vz) | 	// TLBWR
				       (mpc_ir_e[5:0] == 6'o16) & ~cpz_g_mmutype & cpz_vz | 	// TLBGWR
				       (mpc_ir_e[5:0] == 6'o10) & (~cpz_mmutype | cpz_vz) | 	// TLBP
				       (mpc_ir_e[5:0] == 6'o20) & ~cpz_g_mmutype & cpz_vz | 	// TLBGP
				       (mpc_ir_e[5:0] == 6'o30) | 			// ERET
				       (mpc_ir_e[5:0] == 6'o37) |			// DERET
				       (mpc_ir_e[5:0] == 6'o70) |      			// IRET
				       (mpc_ir_e[5:0] == 6'o50) & cpz_vz |		// HYPCALL
				       (mpc_ir_e[5:0] == 6'o40))));			// WAIT

                                                             


	assign cp0_g_ri_e = (mpc_ir_e[31:26] == 6'o20) &    					// Cp0 Major Opcode
		    ~((mpc_ir_e[25:21] == 5'o00) | 					// MTC0
		      (mpc_ir_e[25:21] == 5'o04) |					// MFC0
		      ((mpc_ir_e[25:21] == 5'o13) & (mpc_ir_e[15:6] == 10'b0110000000) &
						    (mpc_ir_e[4:0] == 5'b00000)) | 	// DI/EI
		      (mpc_ir_e[25:21] == 5'o12) |					// RDPGPR
		      (mpc_ir_e[25:21] == 5'o16) |					// WRPGPR
		      (mpc_ir_e[25] & ((mpc_ir_e[5:0] == 6'o01) & ~cpz_g_mmutype |	// TLBR
				       (mpc_ir_e[5:0] == 6'o02) & ~cpz_g_mmutype | 	// TLBWI
				       (mpc_ir_e[5:0] == 6'o06) & ~cpz_g_mmutype | 	// TLBWR
				       (mpc_ir_e[5:0] == 6'o10) & ~cpz_g_mmutype | 	// TLBP
				       (mpc_ir_e[5:0] == 6'o30) | 			// ERET
				       (mpc_ir_e[5:0] == 6'o70) |      			// IRET
				       (mpc_ir_e[5:0] == 6'o50) |      			// HYPCALL
				       (mpc_ir_e[5:0] == 6'o40))));			// WAIT
					
   	// cp2_ri_e: illegal cp2 instn decode (No need to check CU2 here)
	// CU has higher priority and will override this
  	assign cp2_ri_e = (mpc_ir_e[31:26] == 6'o66) || 			// LDC2
		  (mpc_ir_e[31:26] == 6'o76) || 			// SDC2
		  ( (mpc_ir_e[31:26] == 6'o22) && 			// Cp2 Major Opcode
		    !( (mpc_ir_e[25:21] == 5'o00) || 		// MFC2
		       (mpc_ir_e[25:22] == 4'b0001) || 		// CFC2/MFHC2
		       (mpc_ir_e[25:21] == 5'o04) || 		// MTC2
		       (mpc_ir_e[25:22] == 4'b0011) || 		// CTC2/MTHC2
		       (mpc_ir_e[25:24] == 2'b01) || 		// BC2
		       (mpc_ir_e[25]) ) ); 				// CO2

	assign mfttr_inst0_e = (mpc_ir_e[31:26] == 6'o20) & (mpc_ir_e[25:24] == 2'b01) & ~mpc_ir_e[22];
 
	assign fpr32 = !cpz_fr;

	assign ldc1_ri_e = mpc_ir_e[31:26] == 6'o65 & fpr32 & mpc_ir_e[16];
	assign sdc1_ri_e = mpc_ir_e[31:26] == 6'o75 & fpr32 & mpc_ir_e[16];
 
	assign dec_cp1_e = cp1_coppresent & 
                      (((mpc_ir_e[31:30] == 2'b01) & ~mpc_ir_e[28] & mpc_ir_e[26]) |	  // COP1, COP3
	               ((mpc_ir_e[31:30] == 2'b11) & (mpc_ir_e[27:26] == 2'b01)) |		  // LWC1, LDC1, SWC1, SDC1
	               (special_e & (mpc_ir_e[5:3] == 3'b000) & (mpc_ir_e[1:0] == 2'b01)) // MOVCI (MOVF, MOVT)
	               );		  

	assign scop1_e = (mpc_ir_e[31:29] == 3'b111) & (mpc_ir_e[27:26] == 2'b01) |					// SWC1, SDC1, SWC2
		cpin_e & (mpc_ir_e[27:26] == 2'b11) & (mpc_ir_e[5:3] == 3'b001) & ~(&mpc_ir_e[2:0]);	// SWXC1, SDXC1, SUXC1
	assign scop2_e = (mpc_ir_e[31:29] == 3'b111) & (mpc_ir_e[27:26] == 2'b10);				// SWC2, SDC2
	assign lscop2_e = (mpc_ir_e[31:30] == 2'b11) & (mpc_ir_e[27:26] == 2'b10);				// SWC2, SDC2, LWC2, LDC2
   
	// Reserved instructions for Cop1 opcodes
	//	CU1 has higher priority and will override this
	assign cp1_ri_e = 
		cpin_e & (mpc_ir_e[27:26] == 2'b01) &
	~((mpc_ir_e[25:24] == 2'b00) & (mpc_ir_e[22] |				// 02, 03	CFC1, MFHC1
											// 06, 07	CTC1, MTHC1
					 ~mpc_ir_e[21])) &				// 00, 04	MFC1, MTC1
	~(~mpc_ir_e[25] & (mpc_ir_e[23:21] == 3'o0)) &				// 10		BC1
	~((mpc_ir_e[25:24] == 2'b10) & (((mpc_ir_e[23:21] == 3'o0) & cp1_s_e) |	// rs=S
					 ((mpc_ir_e[23:21] == 3'o1) & cp1_d_e) |	// rs=D
					 ((mpc_ir_e[23:22] == 3'b10) & cp1_wl_e))) | 	// rs=W,L
                                           ldc1_ri_e | sdc1_ri_e |
		(ctc1_fr0_e | ctc1_fr1_e | cfc1_fr_e) & cp1_ufrp & ~(cpz_gm_e ? cpz_g_ufr : cpz_ufr);

	assign cp1_s_e = (mpc_ir_e[5:4] == 2'b00) |		// 00..17	ADD..FLOOR.W
	     (~mpc_ir_e[3] & (mpc_ir_e[1:0] == 2'b01)) |		// 21,25,41,45	MOVCF, RECIP
	     (~mpc_ir_e[5] & (mpc_ir_e[3:1] == 3'b0_01)) |			// 22, 23	MOVZ, MOVN
	     (~mpc_ir_e[5] & ~mpc_ir_e[3] & (mpc_ir_e[1:0] == 2'b10)) |	// 26		RSQRT
	     (mpc_ir_e[5] & (mpc_ir_e[3:1] == 3'b010)) | 	// 44	CVT.D, CVT.W
	     (mpc_ir_e[5:4] == 2'b11);						// 60..77	C.F..C.NGT
	assign cp1_d_e = (mpc_ir_e[5:4] == 2'b00) |		// 00..17	ADD..FLOOR.W
	     (~mpc_ir_e[5] & (mpc_ir_e[3:2] == 2'b0_0) & mpc_ir_e[0]) |	// 21, 23	MOVCF, MOVN
	     (~mpc_ir_e[5] & ~mpc_ir_e[3] & (mpc_ir_e[1:0] == 2'b10)) |	// 22, 26	MOVZ, RSQRT
	     (~mpc_ir_e[5] & (mpc_ir_e[3:0] == 4'b0_101)) |			// 25		RECIP
	     (mpc_ir_e[5] & ~mpc_ir_e[3] & (mpc_ir_e[1:0] == 2'b00)) | 	// 40, 44	CVT.S, CVT.W
		(mpc_ir_e[5] & (mpc_ir_e[3:1] == 3'b0_10)) |		// 45           CVT.L
	     (mpc_ir_e[5:4] == 2'b11);						// 60..77	C.F..C.NGT
	assign cp1_wl_e = (mpc_ir_e[5:1] == 5'b100_00);					// 41, 42	CVT.S, CVT.D
   
		

	assign cp3_ri_e = cpin_e && (mpc_ir_e[27:26] == 2'b11) &&
              ~(mpc_ir_e[5] && (mpc_ir_e[2:1] == 2'b00) ||                    // 40,41,50,51,60,61,70,71 MADD.S..NMSUB.D
		(mpc_ir_e[5:4] == 2'b00) & (mpc_ir_e[2:0] == 3'b000 ||		// L/SWXC1
				       (mpc_ir_e[2:0] == 3'b001 || mpc_ir_e[2:0] == 3'b101) && !(fpr32 && (mpc_ir_e[3] ? mpc_ir_e[11] : mpc_ir_e[6]) ) ||	// L/SUXC1 L/SDXC1
					mpc_ir_e[3:0] == 4'b1111)   );		// PREFX


	assign regimm_ri_e = regimm_e & ~((~mpc_ir_e[20] & ~mpc_ir_e[18]) |
				   (mpc_ir_e[19:18] == 2'b00) |
				   ((mpc_ir_e[20:19] == 2'b01) & ~mpc_ir_e[16]) |
				   (mpc_ir_e[20:16] == 5'b00111) |	
				   (mpc_ir_e[20:16] == 5'b11111) |
				(mpc_ir_e[20:16] == 5'b11100) & dsp_valid_qual_e);

	assign spec_ri_e =	special_e && ((mpc_ir_e[5:0] == 6'o05) ||
				      (mpc_ir_e[5:0] == 6'o16) || 
				      (mpc_ir_e[5:2] == 4'b010_1) ||
				      (mpc_ir_e[5:2] == 4'b011_1) ||
				      (mpc_ir_e[5:1] == 5'b101_00) ||
				      (mpc_ir_e[5:2] == 4'b101_1) ||
				      (mpc_ir_e[0] && mpc_ir_e[5:2] == 4'b110_1) ||
			((mpc_ir_e[5:3] == 3'o2) & ~edp_dsp_present_xx &
                                (mpc_ir_e[0] ? (mpc_ir_e[12:11] != 2'b00) :           // 11, 13 (HI/LO 1-3)
                                                (mpc_ir_e[22:21] != 2'b00))) ||
				      (mpc_ir_e[5:3] == 3'o7));

	assign dsp_valid_qual_e = edp_dsp_valid_e & edp_dsp_present_xx;

   // Instructions in the base arch that could cause a DSP exc
   // MADD, MADDU, MSUB, MSUBU, MULT, MULTU with a non-zero value
   // in the ac field ([15:11] of the instruction)

	assign base_dsp_exc_e = (
                      (spec2_e & (mpc_ir_e[5:3] == 3'b000) & ~mpc_ir_e[1])                  // MADD/MADDU/MSUB/MSUBU
                      |
		      (special_e & (mpc_ir_e[5:3] == 3'b011) & ~mpc_ir_e[2] & ~mpc_ir_e[1])   // MULT/MULTU
		     )
                     & 
                     (|mpc_ir_e[15:11]);
	
	assign dec_dsp_exc_e = dsp_valid_qual_e | base_dsp_exc_e | dspver_e;
	mvp_cregister #(1) _dspver_e(dspver_e,(mpc_run_ie || mpc_fixupi) & ~mpc_atomic_e, gclk, icc_dspver_i & 
			~(hw_save_i | mpc_sel_hw_load_i));

        // Illegal Spec2 minor opcode
        assign spec2_ri_e = spec2_e && !((mpc_ir_e[5:0] == 6'o77) ||
				  (mpc_ir_e[5:1] == 5'b100_00) ||
				  (mpc_ir_e[5:0] == 6'o02) ||
				  ((mpc_ir_e[5:3] == 3'o0) && !mpc_ir_e[1]) || 
				  (mpc_isamode_e && (mpc_ir_e[5:0] == 6'o10)) || 
				  ((mpc_ir_e[5:4] == 2'b01) && !edp_udi_ri_e));

        // Illegal Spec3 minor opcode
        assign spec3_ri_e = spec3_e & ~(((mpc_ir_e[5:3] == 3'o0) & (mpc_ir_e[1:0] == 2'b00)) |	
				 (mpc_ir_e[5:0] == 6'o40) |
				 ((mpc_ir_e[5:0] == 6'o73) &							
			(((mpc_ir_e[15:11] == 5'd0) & (cpz_hwrena[0] | cpz_copusable[0] | ~cpz_kuc_e)) |
			 ((mpc_ir_e[15:11] == 5'd1) & (cpz_hwrena[1] | cpz_copusable[0] | ~cpz_kuc_e)) |	
			 ((mpc_ir_e[15:11] == 5'd2) & (cpz_hwrena[2] | cpz_copusable[0] | ~cpz_kuc_e)) |	
			 ((mpc_ir_e[15:11] == 5'd3) & (cpz_hwrena[3] | cpz_copusable[0] | ~cpz_kuc_e)) |	
			 ((mpc_ir_e[15:11] == 5'd29) & (cpz_hwrena_29 | cpz_copusable[0] | ~cpz_kuc_e)))) |
				dsp_valid_qual_e);	

        assign spec3_g_ri_e = spec3_e & ~(((mpc_ir_e[5:3] == 3'o0) & (mpc_ir_e[1:0] == 2'b00)) |	
				 (mpc_ir_e[5:0] == 6'o40) |
				 ((mpc_ir_e[5:0] == 6'o73) &							
			(((mpc_ir_e[15:11] == 5'd0) & (cpz_g_hwrena[0] | cpz_g_copusable[0] | ~cpz_g_kuc_e)) |
			 ((mpc_ir_e[15:11] == 5'd1) & (cpz_g_hwrena[1] | cpz_g_copusable[0] | ~cpz_g_kuc_e)) |	
			 ((mpc_ir_e[15:11] == 5'd2) & (cpz_g_hwrena[2] | cpz_g_copusable[0] | ~cpz_g_kuc_e)) |	
			 ((mpc_ir_e[15:11] == 5'd3) & (cpz_g_hwrena[3] | cpz_g_copusable[0] | ~cpz_g_kuc_e)) |	
			 ((mpc_ir_e[15:11] == 5'd29) & (cpz_g_hwrena_29 | cpz_g_copusable[0] | ~cpz_g_kuc_e) & cpz_g_ulri))) |
				dsp_valid_qual_e);	

	assign umips_ri_e = ((mpc_ir_e[31:26] == 6'o35) && !icc_umipspresent);
	
	assign vd_e =	 maj_vd_e || cp_vd_e || spec3_vd_e || spec2_vd_e || spec_vd_e;

	assign maj_vd_e = (mpc_ir_e[31:29] == 3'o1) || (mpc_ir_e[31:29] == 3'o4) & ~sel_hw_e ||              

		  lnk31_e || raw_ll_e || new_sc_e;

	// Valid destination for Coprocessor opcodes
	assign cp_vd_e =  cpin_e & ~(&mpc_ir_e[27:26]) & ((mpc_ir_e[25:23] == 3'b000) & 
			((mpc_ir_e[23:21] != 3'b011) | ~mpc_ir_e[9]) |		// MFCx/CFCx
			     (mpc_ir_e[27:24] == 4'b00_01));		// COP0: RDPGPR/WRPGPR/DI/EI
	
	// Valid Destination for Special opcode
	assign spec_vd_e = special_e && !( (mpc_ir_e[5:1] == 5'b001_10) ||                     // Break or Syscall
				   raw_trap_in_e || (sync_e
						     && !xl_trig
						     ) || (mpc_ir_e[5:0] == 6'o10) ||   // JR
				   (mpc_ir_e[5:2] == 4'b011_0) ||                      // Mult(u)/Div(u)
				   ((mpc_ir_e[5:2] == 4'b010_0) && mpc_ir_e[0]));          // MTHi/Lo

	// Valid Destination for Special2 opcode
	assign spec2_vd_e = spec2_e && ((mpc_ir_e[5:1] == 5'b10000) || 	 // CLO/CLZ
				(mpc_isamode_e && (mpc_ir_e[5:0] == 6'o10)) ||		// LXS
				(mpc_ir_e[5:0] == 6'o02) ||		// MUL 
				(mpc_ir_e[5:4] == 2'b01));  	// UDI

	// Valid Destination for Special3 opcode
	assign spec3_vd_e = spec3_e & ( ~mpc_ir_e[4] |          // EXT, INSx, BSHFL
                                           mpc_ir_e[1] |          // ABSQ.PH, SLL.QB, RDHWR

                                    (~mpc_ir_e[5] & ~mpc_ir_e[3] & ~mpc_ir_e[0]) | // ADDU.QB

                                    (~mpc_ir_e[5] & mpc_ir_e[3] & ~mpc_ir_e[0]) | //ADDUH.* SUBUH.*

                                    (mpc_ir_e[1:0] == 2'b01)    | //CMPU.xx, APPEND
                                    (mpc_ir_e[5] & mpc_ir_e[3] & (~mpc_ir_e[10] |
                                    ~mpc_ir_e[9] & ~mpc_ir_e[6])));//RDDSP,WRDSP

	assign rddsp_e = spec3_e && (mpc_ir_e[5:0] == 6'o70) && (mpc_ir_e[10:9] == 2'b10) && !mpc_ir_e[6]; // RDDSP
	assign mpc_wrdsp_e = spec3_e && (mpc_ir_e[5:0] == 6'o70) && (mpc_ir_e[10:9] == 2'b10) && mpc_ir_e[6]; // WRDSP


	assign mpc_jimm_e =	((mpc_ir_e[31:27] == 5'b1) || (mpc_ir_e[31:26] == 6'o35)) && mpc_irval_e && ~mpc_int_pref_phase1;
	assign mpc_jimm_e_fc =	((mpc_ir_e[31:26] == 6'o03) || (mpc_ir_e[31:26] == 6'o35)) && mpc_irval_e;	
	assign mpc_jalx_e = mpc_irval_e && (mpc_ir_e[31:26] == 6'o35);
	
	// lnk31_e: Jump & Link instruction decode 
	assign lnk31_e = (mpc_ir_e[31:26] == 6'o03) |
		  (mpc_ir_e[31:26] == 6'o35) |
		  (regimm_e & (mpc_ir_e[20:19] == 2'b10));

	assign br_likely_e = (mpc_ir_e[31:28] == 4'b010_1) || 
		    (regimm_e && !mpc_ir_e[19] && mpc_ir_e[17] && !mpc_ir_e[18]) ||
		    (((mpc_ir_e[31:28] == 4'b0100) && ^mpc_ir_e[27:26] && (mpc_ir_e[25:24] == 2'b01)) && mpc_ir_e[17]);



	assign raw_ll_e = (mpc_ir_e[31:26] == 6'o60);
	assign new_sc_e = (mpc_ir_e[31:26] == 6'o70) && mpc_irval_e;

	assign mpc_br16_e = mpc_isamode_e && ((regimm_e && (mpc_ir_e[19:18] == 2'b0)) ||
				(!mpc_ir_e[31] && !mpc_ir_e[29] && mpc_ir_e[28]) ||
				((mpc_ir_e[31:26] == 6'o22) && (mpc_ir_e[25:24] == 2'b01)) ||
				((mpc_ir_e[31:26] == 6'o21) && (mpc_ir_e[25:24] == 2'b01)) ||
				(edp_dsp_present_xx && regimm_e && (mpc_ir_e[20:16] == 5'b11_100)) 
				);

        assign mpc_br32_e = !mpc_isamode_e &&((regimm_e && (mpc_ir_e[19:18] == 2'b0)) || 
                                  (!mpc_ir_e[31] && !mpc_ir_e[29] && mpc_ir_e[28]) ||
                                  (((mpc_ir_e[31:30] == 2'b01) && !mpc_ir_e[28] && ^mpc_ir_e[27:26]) && (mpc_ir_e[25:24] == 2'b01)) ||
				(edp_dsp_present_xx && regimm_e && (mpc_ir_e[20:16] == 5'b11_100))
				);
	assign mpc_br_e = ((regimm_e && (mpc_ir_e[19:18] == 2'b0)) ||
				(!mpc_ir_e[31] && !mpc_ir_e[29] && mpc_ir_e[28]) ||
                                (((mpc_ir_e[31:30] == 2'b01) && !mpc_ir_e[28] && ^mpc_ir_e[27:26]) && (mpc_ir_e[25:24] == 2'b01)) ||
				(edp_dsp_present_xx && regimm_e && (mpc_ir_e[20:16] == 5'b11_100))
				);

	// cp0_e: Co Processor 0 instruction
	assign cp0_e =	(mpc_ir_e[31:26] == 6'o20) && ~cpz_gm_e && (cpz_copusable[0] || !cpz_kuc_e);
	assign g_cp0_e = (mpc_ir_e[31:26] == 6'o20) && cpz_gm_e && (cpz_g_copusable[0] || !cpz_g_kuc_e);

	// cp2_e: Co Processor 2 instruction
	assign cp2_e =	(mpc_ir_e[31:26] == 6'o22) && (cpz_gm_e ? cpz_g_copusable[2] : cpz_copusable[2]);	

	assign mpc_cp2a_e = cp2_e && mpc_ir_e[25];
	assign mpc_cp2tf_e = cp2_e && (mpc_ir_e[25:24] == 2'b00);

	// cp1_e: Co Processor 1 instruction
	assign cp1_e =	(mpc_ir_e[31:26] == 6'o21) && (cpz_gm_e ? cpz_g_copusable[1] : cpz_copusable[1]);	

	
	// cp_ls_un_e: Co Processor load/store to unusable cop
	assign cp_ls_un_e = (mpc_ir_e[31:26] == 6'o57) && !cpz_copusable[0] && cpz_kuc_e && !cpz_gm_e || 
		(mpc_ir_e[31:30] == 2'b11) && (mpc_ir_e[27:26] == 2'b01) && !cpz_copusable[1] 
		&& (!cpz_gm_e || cpz_g_copusable[1]) || 
		(mpc_ir_e[31:30] == 2'b11) && (mpc_ir_e[27:26] == 2'b10) && !cpz_copusable[2] 
		&& (!cpz_gm_e || cpz_g_copusable[2]);

	assign cp_g_ls_un_e = (mpc_ir_e[31:26] == 6'o57) && !(cpz_g_copusable[0]) && cpz_g_kuc_e || 
		   (mpc_ir_e[31:30] == 2'b11) && (mpc_ir_e[27:26] == 2'b01) && !cpz_g_copusable[1] || 
		   (mpc_ir_e[31:30] == 2'b11) && (mpc_ir_e[27:26] == 2'b10) && !cpz_g_copusable[2];

	// cp_un_e: Co Processor Unusable
	assign cp_un_e = (mpc_ir_e[31:26] == 6'o20) && !cpz_copusable[0] && cpz_kuc_e && !cpz_gm_e || 
	       (special_e && (mpc_ir_e[5:0] == 6'o01) || 						// MOVCI
		(mpc_ir_e[31:26] == 6'o21)) && !cpz_copusable[1] && (!cpz_gm_e || cpz_g_copusable[1]) || // Cop1
		(mpc_ir_e[31:26] == 6'o22) && !cpz_copusable[2] && (!cpz_gm_e || cpz_g_copusable[2]) ||  // Cop2
		(mpc_ir_e[31:26] == 6'o23) && !cpz_copusable[1] && (!cpz_gm_e || cpz_g_copusable[1]) ||  // Cop3
		cp_ls_un_e;

	assign cp_g_un_e =	((mpc_ir_e[31:26] == 6'o20) && !cpz_g_copusable[0] && cpz_g_kuc_e || 
	       (special_e && (mpc_ir_e[5:0] == 6'o01) ||                	// MOVCI
		(mpc_ir_e[31:26] == 6'o21)) && !cpz_g_copusable[1] ||               // Cop1
		(mpc_ir_e[31:26] == 6'o22) && !cpz_g_copusable[2] ||                // Cop2
		(mpc_ir_e[31:26] == 6'o23) && !cpz_g_copusable[1] ||                // Cop3
		cp_g_ls_un_e) && cpz_gm_e;

	// ce_un_e: CorExtend Unusable
	assign ce_un_e = spec2_e && (mpc_ir_e[5:4] == 2'b01) && !cpz_cee && edp_udi_honor_cee;
	assign ce_g_un_e = spec2_e && (mpc_ir_e[5:4] == 2'b01) && cpz_gm_e && !cpz_g_cee && edp_udi_honor_cee;

        // sdbbp_e: Software DeBug BreakPoint
        assign sdbbp_e = spec2_e && (mpc_ir_e[5:0] == 6'o77);

	// bds_e: This instn has a branch delay slot
	assign bds_e = ~icc_nobds_e && mpc_irval_e && (mpc_br_e ||
			      ((mpc_ir_e[25:24] == 2'h1) && (^mpc_ir_e[27:26]) && cpin_e)) ||
	       mpc_jimm_e ||
	       (mpc_jreg_e && ~icc_macrobds_e);


	assign break_e = special_e && (mpc_ir_e[5:0] == 6'o15);

	assign syscall_e = special_e && (mpc_ir_e[5:0] == 6'o14);
	assign lx_e = spec3_e && (mpc_ir_e[5:0] == 6'o12);
	assign lhx_e = lx_e && (mpc_ir_e[8:7] == 2'b10);
	assign lwx_e = lx_e && (mpc_ir_e[8:7] == 2'b00);
	assign lbux_e = lx_e && (mpc_ir_e[8:7] == 2'b11);
	assign mpc_bussize_e [1:0] =	(pref_e || prefx_e || cop_e || synci_e || mpc_atomic_e || mpc_atomic_m || lbux_e) && !mpc_lsdc1_m ? 2'b0 :
		       (mpc_ir_e[31:30] == 2'b11) || mpc_lsdc1_m || (mpc_ir_e[31:26] == 6'o23) ? 2'h3 : 
		       (mpc_lxs_e || lwx_e) ? 2'h3 :
			lhx_e ? 2'b01 :
		       mpc_ir_e[27:26];
	assign load_e =	!(mpc_ldst_e & ~(mpc_ir_e[31:26] == 6'o23) ? (mpc_ir_e[29] || mpc_atomic_m) : 
			(mpc_ir_e[31:26] == 6'o23) ? mpc_ir_e[3] : 
			(mpc_ir_e[23:21] == 3'b011) ? mpc_ir_e[9] : mpc_ir_e[23]) || 
		        mpc_lxs_e || lx_e || cop_e || synci_e || mpc_atomic_e ;	
	assign lsdc1_e = &{mpc_ir_e[31:30], mpc_ir_e[28]};
	assign lsdxc1_e = (mpc_ir_e[31:26] == 6'o23) & mpc_ir_e[5:4]==2'b0 && (mpc_ir_e[2:0]==3'b001);
	assign lsuxc1_e = (mpc_ir_e[31:26] == 6'o23) && mpc_ir_e[5:4]==2'b0 && mpc_ir_e[2:0]==3'b101;

	assign pbus_type_e [2:0] =
			   synci_e ? 3'h7 :
			   cop_e ? (mpc_ir_e[17] ? 3'h0 : 
                                       mpc_ir_e[16] ? 3'h6 : 3'h5) :
			sync_e ? 3'h4 :                                            
			pref_e | prefx_e ? (val_pref_hint_e ? 3'h3 : 3'h0) :                 
			mpc_ldst_e & ~(mpc_ir_e[31:26] == 6'o23) ? (((mpc_ir_e[29] || mpc_atomic_m) && !mpc_lxs_e && !lx_e) ? 3'h2 : 3'h1) :
			mpc_ldst_e & (mpc_ir_e[31:26] == 6'o23) ? (mpc_ir_e[3] ? 3'h2 : 3'h1) :
			mpc_lsdc1_m ? mpc_busty_m :
				      3'h0;                                       
	assign p_idx_cop_e = ~mpc_ir_e[20] & cop_e;

	// vcp0_op_e: coprocessor 0 operation
	assign vcp0_op_e =	(mpc_ir_e[25]) && cp0_e && !cp0_ri_e;	
	assign g_vcp0_op_e =	(mpc_ir_e[25]) && g_cp0_e && !cp0_g_ri_e;	

	// mpc_ldst_e: Load or store op
	assign mpc_ldst_e =	mpc_lxs_e || mpc_ir_e[31] || (regimm_e && (mpc_ir_e[20:16] == 5'o07))
			|| lx_e || (mpc_ir_e[31:26] == 6'o23) && !mpc_ir_e[5];

	assign cop_e = 	(mpc_ir_e[31:26] == 6'o57);

	// muldiv_e: Multiply/Divide operation
	assign muldiv_e = special_e && (mpc_ir_e[5:4] == 2'b01) && !mpc_ir_e[2] || 
		   spec2_e && (mpc_ir_e[5:3] == 3'o0) ||
		   spec3_e && (mpc_ir_e[5:0] == 6'o20) && ((mpc_ir_e[10:8] == 3'o7) 
			|| (mpc_ir_e[10:7] == 4'o03)) ||
		   spec3_e && (mpc_ir_e[5:0] == 6'o60) ||
		   spec3_e && ((mpc_ir_e[5:0] == 6'o70) && !(mpc_ir_e[10:9] == 2'b10)) || 
		   spec3_e && ((mpc_ir_e[5:0] == 6'o30) && mpc_ir_e[8]); 
	assign mpc_pm_muldiv_e = special_e && (mpc_ir_e[5:3] == 3'b011) && !mpc_ir_e[2] ||
		   spec2_e && (mpc_ir_e[5:3] == 3'o0);
	assign mpc_mulgpr_e = 
		   spec2_e && (mpc_ir_e[5:3] == 3'o0) && mpc_ir_e[1] || // MUL
		   spec3_e && (mpc_ir_e[5:0] == 6'o20) && ((mpc_ir_e[10:8] == 3'o7) 
			|| (mpc_ir_e[10:7] == 4'o03)) || // MULEU, MULEQ, MULQ
		   spec3_e && ((mpc_ir_e[5:0] == 6'o70) && !mpc_ir_e[10]) || // EXTR
		   spec3_e && ((mpc_ir_e[5:0] == 6'o30) && mpc_ir_e[8]);  // MUL, MULQ

	// MFC2 or CFC2
	assign xfc2_e = cp2_e && (mpc_ir_e[25:23] == 3'o0);

	// MFC1 or CFC1
	assign xfc1_e = cp1_e && (mpc_ir_e[25:23] == 3'o0) && !((mpc_ir_e[22:21] == 2'b10) 
		&& (mpc_ir_e[15:11] == 5'd1));

	// MFHI/MFLO are treated differently for stalls
	assign mfhilo_e = (special_e && (mpc_ir_e[5:2] == 4'b010_0) && !mpc_ir_e[0]);

	// TrapType: Trap Instn
	assign raw_trap_in_e = 	special_e && (mpc_ir_e[5:3] == 3'o6) ||
			regimm_e && (mpc_ir_e[20:19] == 2'b01);

	// Bus src_a_e[4:0]: rs field of instruction 
	assign src_a_e [4:0] = mpc_ir_e[25:21];	

	// Bus src_b_e[5:0]: rt field of instruction , bit 5 : 0=css, 1=pss
	assign src_b_e [5:0] = { rdpgpr_e, mpc_ir_e[20:16]};
	assign mpc_atomic_clrorset_e = mpc_ir_e [15] ;
	assign mpc_atomic_bit_dest_e [2:0] = mpc_ir_e [14:12] ;

        assign xl_trig = (mpc_ir_e[23:16] == 8'h3c) && (dest_e[4:0] != 5'h0);
   
	assign pdest_e [4:0] = (spec2_e && (mpc_ir_e[5:4] == 2'b01)) ? edp_udi_wrreg_e[4:0] : mpc_ir_e[15:11];

	assign dest_cnvt_dsp_e = spec3_e &
                        ( (mpc_ir_e[5:4] == 2'b01) & ~(mpc_ir_e[0] & (mpc_ir_e[10:8] == 3'b111)) |	// ADDU.QB .. SLL.QB
                         (mpc_ir_e[5:4] == 2'b10) |                            // BSHFL
                         (mpc_ir_e[5] & ~mpc_ir_e[0] & mpc_ir_e[10]));       // RDDSP

        assign dest_e [5:0] = (special_e | spec2_e | mpc_cnvt_e | rwpgpr_e | dest_cnvt_dsp_e | lx_e) ? { rwpgpr_e & ~rdpgpr_e, pdest_e } : 
		                    				       ((lnk31_e) ? 6'h1f :
										    { 1'b0, src_b_e[4:0] });
	assign mpc_dest_e[4:0] = dest_e[4:0];
	assign use_src_b_e =	(special_e & ~(break_e | syscall_e | sync_e)) |
		  	(spec2_e & ~mpc_ir_e[5]) |
			(spec3_e & (mpc_ir_e[2] |                                  // INS INSV
					(mpc_ir_e[4:1] == 4'b01_01) |			// LX
                                        ((mpc_ir_e[5:4] == 2'b01) &
                                         ((~mpc_ir_e[1] & (~mpc_ir_e[10] |            // ADDU.QB, ~ RADDU.WQ
                                           mpc_ir_e[9] | ~mpc_ir_e[8] | mpc_ir_e[7])) |
                                          mpc_ir_e[0] |                                // C.EQ.QB, SLL.QB
                                          (mpc_ir_e[1] & (mpc_ir_e[8] |               // ABSQ.PH, ~ REPL.QB, ~ REPL.PH
                                           ~mpc_ir_e[7] | mpc_ir_e[6])))) |
                                        (mpc_ir_e[5] & ~mpc_ir_e[3]) |                // BSHFL (SEB, SEH, WSBH), MULAQ
                                        (mpc_ir_e[5] & ~mpc_ir_e[1] &
                                           (mpc_ir_e[10:9] == 2'b10) & mpc_ir_e[6]))) |
			(mpc_ir_e[31:26] == 6'o04) |
			(mpc_ir_e[31:26] == 6'o05) |
			(mpc_ir_e[31:26] == 6'o20) |
			(mpc_ir_e[31:23] == 9'o221) |
			(mpc_ir_e[31:26] == 6'o24) |
			(mpc_ir_e[31:26] == 6'o23) & ~mpc_ir_e[5]|
			(mpc_ir_e[31:26] == 6'o25) |
			(mpc_ir_e[31:26] == 6'o42) |
			(mpc_ir_e[31:26] == 6'o46) |
			(mpc_ir_e[31:29] == 3'o5) |
			((mpc_ir_e[31:26] == 6'o21) & (^mpc_ir_e[5:4] & (mpc_ir_e[2:1] == 2'b01) | 
							(mpc_ir_e[25:23] == 3'b001))
			) |
			((mpc_ir_e[31:26] == 6'o23) & ~mpc_ir_e[5]) |
		        new_sc_e;

	assign use_src_a_e = !(cp0_e || g_cp0_e || cp2_e || cp1_e || mpc_jimm_e || break_e || syscall_e || sync_e || sdbbp_e);
	
	// Bus cp0_sr_e: coprocessor zero shadow register specifier
	// RDHWR : rd == 0  :  sel = 2 for CPUNumber
	//         rd == 1  :  sel = 3 for SYNCI_Step
	//         rd == 2  :  sel = 0 for Cyclecount
	//         rd == 3  :  sel = 1 for Cyclecount Resolution
        //         rd == 29 :  sel = 2 for UserLocal
	assign cp0_sr_e [2:0] = (rdhwr_e) ? { 1'b0, 
				       mpc_ir_e[15] | ~mpc_ir_e[12],   // Set for 29,0,1
				       ~mpc_ir_e[15] & mpc_ir_e[11]} : // Set for 1,3 not 29
			(ctc1_fr0_e | ctc1_fr1_e | cfc1_fr_e) ? 3'd0 :		// CT/FC1.FR
			 mpc_ir_e[2:0];	

	// Bus cp0_r_e[4:0]: coprocessor zero register specifier
	// RDHWR : rd == 0 : reg = 7 for CPUNumber
	//         rd == 1 : reg = 7 for SYNCI_Step
	//         rd == 2 : reg = 9 for Cyclecount
	//         rd == 3 : reg = 7 for Cyclecount Resolution
        //         rd == 4 : reg = 4 for UserLocal register
	assign cp0_r_e [4:0] = (rdhwr_e) ? ((mpc_ir_e[12:11] == 2'h2) ? 5'd9 :    // CycleCount
				      mpc_ir_e[15] ? 5'd4 :                // UserLocal
                                                     5'd7) :                // Other RDHWR
			(ctc1_fr0_e | ctc1_fr1_e | cfc1_fr_e) ? 5'd12 :		// CT/FC1.FR
			            mpc_ir_e[15:11];	                   // Normal cop0


	assign mpc_ebld_e = cp0_e & mpc_ir_e[25:21]==5'b00100 & (cp0_r_e == 5'd15) & cp0_sr_e[0] & ~cp0_sr_e[1] & mpc_irval_e;

	// The read part of DI/EI is executed as a MFC0
	assign p_cp0_mv_e = (~mpc_ir_e[25] & (~mpc_ir_e[22] | mpc_ir_e[21] & (mpc_ir_e[24:21] != 4'b0011)) 
		& (cp0_e | g_cp0_e)) | rdhwr_e 
		| cfc1_fr_e & (cpz_gm_e ? cpz_g_ufr : cpz_ufr); 
	assign p_g_cp0_mv_e = (mpc_ir_e[25:21] == 5'o03) & ~(mpc_ir_e[10] | mpc_ir_e[8]) & cp0_e;

	// Decode of r/w previous register-file set instructions
	assign rwpgpr_e = (mpc_ir_e[25:24] == 2'b01) & (mpc_ir_e[22:21] == 2'b10) & (cp0_e | g_cp0_e);	// RDPGPR/WRPGPR

	assign rdpgpr_e = rwpgpr_e & ~mpc_ir_e[23];						// RDPGPR

	assign p_cp0_sc_e = mpc_ir_e[5];							// Set/Clear CP0 (DI/EI)

	assign p_cp0_diei_e = (mpc_ir_e[25:21] == 5'o13) & (cp0_e | g_cp0_e & cpz_cp0);	// DI/EI

	// mpc_jreg_e: jump reg 
	assign mpc_jreg_e =	mpc_irval_e && special_e && (mpc_ir_e[5:1] == 5'b001_00) && ~mpc_int_pref_phase1;
	assign mpc_jreg_e_jalr = mpc_jreg_e && (mpc_ir_e[5:0] == 6'o11);

	assign mpc_jreg31_e = mpc_jreg_e && (mpc_ir_e[25:21] == 5'o37);
	assign mpc_jreg31non_e = mpc_jreg_e && ~(mpc_ir_e[25:21] == 5'o37) ;
	
	// mpc_atomic_e: atomic instruction mpc_irval_e 
	assign mpc_atomic_e = mpc_irval_e && regimm_e && (mpc_ir_e[20:16] == 5'o07) && !mpc_atomic_m;

	// jreg_hb_e: jump reg HB
	assign jreg_hb_e = mpc_jreg_e & mpc_ir_e[10];	

	// sarop_e: Signed arithmetic op
	assign sarop_e = mpc_irval_e && ((mpc_ir_e[31:26] == 6'o10) || 
		               (special_e && ((mpc_ir_e[5:0] == 6'o40) || (mpc_ir_e[5:0] == 6'o42))));
	
	// Decode Cp0 Ops
        assign p_eret_e = ~mpc_ir_e[5] & mpc_ir_e[3] & mpc_ir_e[4]  & ~mpc_ir_e[0] 
		& (vcp0_op_e | g_vcp0_op_e & cpz_cp0);              // ERET
        assign p_deret_e = ~mpc_ir_e[5] & mpc_ir_e[4] & mpc_ir_e[0] & (vcp0_op_e | g_vcp0_op_e & cpz_cp0);               // DERET
        assign p_wait_e = mpc_ir_e[5] & ~mpc_ir_e[4] & ~mpc_ir_e[3] & (vcp0_op_e | g_vcp0_op_e & cpz_cp0);               // WAIT
        assign p_iret_e = mpc_ir_e[5] & mpc_ir_e[4] & ~mpc_ir_e[0] & (vcp0_op_e | g_vcp0_op_e & cpz_cp0);                // IRET

        assign p_hypcall_e = mpc_ir_e[5] & ~mpc_ir_e[4] & mpc_ir_e[3] & 
		(vcp0_op_e | g_vcp0_op_e);               						// HYPCALL
		
        assign g_p_eret_e = ~mpc_ir_e[5] & mpc_ir_e[3] & mpc_ir_e[4] & ~mpc_ir_e[0] 
		& g_vcp0_op_e & ~cpz_cp0;              // ERET
        assign g_p_deret_e = ~mpc_ir_e[5] & mpc_ir_e[4] & mpc_ir_e[0] & g_vcp0_op_e & ~cpz_cp0;               // DERET
        assign g_p_iret_e = mpc_ir_e[5] & mpc_ir_e[4] & ~mpc_ir_e[0] & g_vcp0_op_e & ~cpz_cp0;                // IRET
	assign g_p_hypcall_e = 1'b0;
	assign g_p_diei_e = (mpc_ir_e[25:21] == 5'o13) & g_cp0_e & ~cpz_cp0;					// DI/EI
	assign g_p_cop_e  = (mpc_ir_e[31:26] == 6'o57) & g_cp0_e & ~cpz_cp0;					// Cache

	assign g_p_wait_e = mpc_ir_e[5] & ~mpc_ir_e[4] & ~mpc_ir_e[3] & g_vcp0_op_e;
	assign g_p_tlb_e = ~mpc_ir_e[25] & ~mpc_ir_e[22] & (
		~(|mpc_ir_e[15:13]) & (mpc_ir_e[2:0] == 3'd0) |				// Index, Random, EntryLo0/1
		(mpc_ir_e[15:11] == 5'd4) & (mpc_ir_e[2:0] == 3'd0) |			// Context
		(mpc_ir_e[15:11] == 5'd5) & (mpc_ir_e[2:0] == 3'd0) |			// PageMask
		(mpc_ir_e[15:11] == 5'd10) & (mpc_ir_e[2:0] == 3'd0))			// EntryHi
		& g_cp0_e & (cpz_mg & ~cpz_g_mmutype | cpz_og & cpz_g_mmutype) |
		mpc_ir_e[25] & ~(|mpc_ir_e[5:4]) & g_cp0_e & (~cpz_cp0 | (cpz_at == 2'd1));	// TLBR, TLBP, TLBWI, TLBWR; 
	assign g_p_config_e = ~mpc_ir_e[25] & ~mpc_ir_e[22] & (mpc_ir_e[15:11] == 5'd16)
		& g_cp0_e & (mpc_ir_e[23] & ~cpz_cf) & (mpc_ir_e[2:0] != 3'd6) & (mpc_ir_e[2:0] != 3'd7);
	assign g_p_cc_e = ~cpz_gt & (~mpc_ir_e[25] & ~mpc_ir_e[22] & g_cp0_e &
		((mpc_ir_e[15:11] == 5'd9) | (mpc_ir_e[15:11] == 5'd11)) 
		& (mpc_ir_e[2:0] == 3'd0)
		| rdhwr_e & cpz_gm_e & (cp0_r_e[4:0] == 5'd9));				// Count/Compare
	assign g_p_rh_cp0_e = rdhwr_e & cpz_gm_e & ~cpz_cp0 & (
		(cp0_r_e[4:0] == 5'd4) |						// UserLocal
		(cp0_r_e[4:0] == 5'd9) |						// CC
		(cp0_r_e[4:0] == 5'd7) & ~cp0_sr_e[2]);					// CPUNumber, SYNCI_Step
	assign g_p_count_e = ~mpc_ir_e[25] & mpc_ir_e[23] & ~mpc_ir_e[22] & g_cp0_e 
		& (mpc_ir_e[15:11] == 5'd9) & (mpc_ir_e[2:0] == 3'd0);			// Count
	assign g_p_srs_e = ~mpc_ir_e[25] & ~mpc_ir_e[22] & g_cp0_e &
		(mpc_ir_e[15:11] == 12) & ((mpc_ir_e[2:0] == 3'd2) |			// SRSCTL
		(mpc_ir_e[2:0] == 3'd3) |						// SRSMAP
		(mpc_ir_e[2:0] == 3'd5));						// SRSMAP2
	assign g_p_rwpgpr_e = (mpc_ir_e[25:24] == 2'b01) & (mpc_ir_e[22:21] == 2'b10) 
		& g_cp0_e & ((cpz_g_hss == 4'b0) | ~cpz_cp0);
	assign g_p_cp0_always_e = ~mpc_ir_e[25] & ~mpc_ir_e[22] & g_cp0_e & (
		(mpc_ir_e[15:11] == 5'd15) & (mpc_ir_e[2:0] == 3'd0) |			// PRID
		(mpc_ir_e[15:11] == 5'd15) & (mpc_ir_e[2:0] == 3'd2) & cpz_g_cdmm |	// CDMMBase
		(mpc_ir_e[15:11] == 5'd23) & ((mpc_ir_e[2:0] == 3'd0) | (mpc_ir_e[2:0] == 3'd6)) |	// Debug, Debug2
		(mpc_ir_e[15:11] == 5'd24) & (mpc_ir_e[2:0] == 3'd0) |			// DEPC
		(mpc_ir_e[15:11] == 5'd26) & (mpc_ir_e[2:0] == 3'd0) |			// ErrCtl
		(mpc_ir_e[15:11] == 5'd27) & (mpc_ir_e[2:0] == 3'd0) |			// CacheErr
		(mpc_ir_e[15:11] == 5'd28) & ~mpc_ir_e[2] |				// TagLo, DataLo
		(mpc_ir_e[15:11] == 5'd29) & ~mpc_ir_e[2] |				// TagHi, DataHi
		(mpc_ir_e[15:11] == 5'd31) & (mpc_ir_e[2:0] == 3'd0) 			// DESAVE
		);				
	assign g_p_og_e = ~mpc_ir_e[25] & ~mpc_ir_e[22] & g_cp0_e & (
		(~(|mpc_ir_e[15:13]) & (|mpc_ir_e[2:0]) |		
		(mpc_ir_e[15:11] == 5'd4) & (mpc_ir_e[2:0] != 3'd0) & (mpc_ir_e[2:0] != 3'd2) |
		(mpc_ir_e[15:11] == 5'd5) & (mpc_ir_e[2:0] != 3'd0) & (mpc_ir_e[2:0] != 3'd1) | 		
		(mpc_ir_e[15:11] == 5'd6) & (|mpc_ir_e[2:0]) | 	
		(mpc_ir_e[15:11] == 5'd10) & (|mpc_ir_e[2:0])) & cpz_og |
		(mpc_ir_e[15:11] == 5'd4) & (mpc_ir_e[2:0] != 3'd0) & cpz_og |			// 
		(mpc_ir_e[15:11] == 5'd5) & (mpc_ir_e[2:0] == 3'd1) 
			& ((cpz_at == 2'd1) & ~cpz_g_mmutype | cpz_og & cpz_g_mmutype) |	// PageGrain
		(mpc_ir_e[15:11] == 5'd6) & (mpc_ir_e[2:0] == 3'd0) 
			& ((cpz_at == 2'd1) & ~cpz_g_mmutype | cpz_og & cpz_g_mmutype) |	// Wired
		(mpc_ir_e[15:11] == 5'd7) & cpz_og |						// HWREna
		(mpc_ir_e[15:11] == 5'd8) & 
			(cpz_bg & ((mpc_ir_e[2:0] == 3'd0) | (mpc_ir_e[2:0] == 3'd1) | (mpc_ir_e[2:0] == 3'd2)) // BadVAddr, BadInstr, BadInstrP
			| cpz_og & (mpc_ir_e[2:0] != 3'd0) & (mpc_ir_e[2:0] != 3'd1) & (mpc_ir_e[2:0] != 3'd2)) |	
		(mpc_ir_e[15:11] == 5'd9) & cpz_og & (mpc_ir_e[2:0] != 3'd0) |
		(mpc_ir_e[15:11] == 5'd11) & cpz_og & (mpc_ir_e[2:0] != 3'd0) |
		(mpc_ir_e[15:11] == 5'd12) & cpz_og & 
			((mpc_ir_e[2:0] == 3'd6) | (mpc_ir_e[2:0] == 3'd7)) |				
		(mpc_ir_e[15:11] == 5'd13) & cpz_og & 
			(mpc_ir_e[2:0] != 3'd0) & (mpc_ir_e[2:0] != 3'd4) & (mpc_ir_e[2:0] != 3'd5) |	// Cause, NestedExc
		(mpc_ir_e[15:11] == 5'd14) & cpz_og & 
			(mpc_ir_e[2:0] != 3'd0) & (mpc_ir_e[2:0] != 3'd2) |			// EPC, NestedEPC
		(mpc_ir_e[15:11] == 5'd15) & (mpc_ir_e[2:0] == 3'd2) & ~cpz_g_cdmm & cpz_og |	// CDMMBase
		(mpc_ir_e[15:11] == 5'd15) & cpz_og &
		((mpc_ir_e[2:0] != 3'd0) & (mpc_ir_e[2:0] != 3'd1) & (mpc_ir_e[2:0] != 3'd2)) |
		(mpc_ir_e[15:11] == 5'd16) & cpz_og & ((mpc_ir_e[2:0] == 3'd6) | (mpc_ir_e[2:0] == 3'd7)) |	// Config6/7
		(mpc_ir_e[15:11] == 5'd17) & cpz_og |						// LLAddr
		((mpc_ir_e[15:11] == 5'd18) | (mpc_ir_e[15:11] == 5'd19)) & cpz_og &
			(~cpz_g_watch_present & (mpc_ir_e[2:0] == 3'd0) |			// WatchLo, WatchHi
			~cpz_g_watch_present__1 & (mpc_ir_e[2:0] == 3'd1) |		
			~cpz_g_watch_present__2 & (mpc_ir_e[2:0] == 3'd2) |		
			~cpz_g_watch_present__3 & (mpc_ir_e[2:0] == 3'd3) |		
			~cpz_g_watch_present__4 & (mpc_ir_e[2:0] == 3'd4) |		
			~cpz_g_watch_present__5 & (mpc_ir_e[2:0] == 3'd5) |		
			~cpz_g_watch_present__6 & (mpc_ir_e[2:0] == 3'd6) |		
			~cpz_g_watch_present__7 & (mpc_ir_e[2:0] == 3'd7)) |		
		(mpc_ir_e[15:11] == 5'd20) & cpz_og |				
		(mpc_ir_e[15:11] == 5'd21) & cpz_og |				
		(mpc_ir_e[15:11] == 5'd22) & cpz_og |				
		(mpc_ir_e[15:11] == 5'd23) & (mpc_ir_e[2:0] != 3'd0) & (mpc_ir_e[2:0] != 3'd6) & cpz_og |	// TraceControl/TraceControl2/UserTraceData1/TraceBPC
		(mpc_ir_e[15:11] == 5'd24) & (mpc_ir_e[2:0] != 3'd0) & cpz_og |			// DEPC/UserTraceData2
		(mpc_ir_e[15:11] == 5'd25) & cpz_og & ~cpz_g_pc_present |			// PerfCnt
		(mpc_ir_e[15:11] == 5'd26) & (mpc_ir_e[2:0] != 3'd0) & cpz_og |		
		(mpc_ir_e[15:11] == 5'd27) & (mpc_ir_e[2:0] != 3'd0) & cpz_og |		
		(mpc_ir_e[15:11] == 5'd28) & mpc_ir_e[2] & cpz_og |		
		(mpc_ir_e[15:11] == 5'd29) & mpc_ir_e[2] & cpz_og |		
		(mpc_ir_e[15:11] == 5'd30) & cpz_og & (mpc_ir_e[2:0] != 3'd0) |			// ErrorEPC
		(mpc_ir_e[15:11] == 5'd31) & cpz_og 						// Kscratch1/2
		);
	assign g_p_cp0_e = ~mpc_ir_e[25] & ~mpc_ir_e[22] & g_cp0_e & ~cpz_cp0;
	assign g_p_idx_cop_e = (mpc_ir_e[31:26] == 6'o57) & (~cpz_cg | (|mpc_ir_e[19:18] | ~cpz_cgi) 
		& ~mpc_ir_e[20]) & cpz_gm_e & (cpz_g_copusable[0] | ~cpz_g_kuc_e);
	//g_p_perfcnt_e = ~mpc_ir_e[25] & mpc_ir_e[23] & ~mpc_ir_e[22] & g_cp0_e &
	//	(mpc_ir_e[15:11] == 5'd25) & cpz_g_pc_present &
	//	(~mpc_ir_e[2] & ~mpc_ir_e[0] & rf_bdt_e[12] |
	//	mpc_ir_e[2:1]==2'b0 & ~cpz_pc_ctl0_ec1 |
	//	mpc_ir_e[2:1]==2'b1 & ~cpz_pc_ctl1_ec1);
	assign g_p_perfcnt_e = ((~mpc_ir_e[25] & mpc_ir_e[23] & ~mpc_ir_e[22] &
                (~mpc_ir_e[2] & ~mpc_ir_e[0] & rf_bdt_e[12] |
                mpc_ir_e[2:1]==2'b0 & ~cpz_pc_ctl0_ec1 |
                mpc_ir_e[2:1]==2'b1 & ~cpz_pc_ctl1_ec1 |
                mpc_ir_e[2])) | (~mpc_ir_e[23] & ~mpc_ir_e[22] & ~mpc_ir_e[21] & mpc_ir_e[2])) & g_cp0_e & (mpc_ir_e[15:11] == 5'd25) & cpz_g_pc_present;

	assign mpc_cp0func_e [5:0] = {6{vcp0_op_e}} & mpc_ir_e[5:0];
	// Cacheop type
	assign coptype_e [3:0] = {synci_e, mpc_ir_e[20:18]};

	// forward cp0 function to TLB
	assign mpc_g_cp0func_e [5:0] = {6{g_vcp0_op_e}} & mpc_ir_e[5:0];

	// ValPrefHint:  Don't do anything for reserved hint values or nudge (2,3, >7)
	assign val_pref_hint_e = ((mpc_ir_e[20:19] == 2'b0) && !(!mpc_ir_e[18] && mpc_ir_e[17])) ||
			   (mpc_ir_e[20:16] == 5'b11001); // nudge

	
	// Bus mpc_cpnm_e[1:0]: coprocessor unit number
	assign mpc_cpnm_e [1:0] = mpc_ir_e[30] ? { mpc_ir_e[27] & ~mpc_ir_e[26], mpc_ir_e[26] } :	// CP0-3, Load/Store CP1/2
				    { 1'b0, ~mpc_ir_e[31] };				        // 00: Cache, 01: MOVCI

		      
	// sync_e: Sync instn
	assign sync_e = special_e && (mpc_ir_e[5:0] == 6'o17);

	// synci_e: synci instn
	assign synci_e = regimm_e && (mpc_ir_e[20:16] == 5'o37);

	// pref_e: Prefetch instn:  
	assign pref_e = (mpc_ir_e[31:26] == 6'o63);
	assign prefx_e = (mpc_ir_e[31:26] == 6'o23) && mpc_ir_e[1];
	
        mvp_cregister_wide #(32) _int_ir_e_31_0_(int_ir_e[31:0],gscanenable, (mpc_run_ie | mpc_fixupi) & ~mpc_atomic_e 
		& ~mpc_lsdc1_e, gclk, icc_idata_i);
	mvp_cregister #(1) _hw_op(hw_op,mpc_run_ie & (hw_save_i | mpc_sel_hw_load_i),
                                       gclk, hw_save_i ? 1'b1 : 1'b0);
        assign hw_ir_e[31:0] = {2'b10, hw_op, 29'hfba0000};
        mvp_cregister #(1) _sel_hw_e(sel_hw_e,mpc_run_ie, gclk, hw_save_i | mpc_sel_hw_load_i);
	assign mpc_sel_hw_e = sel_hw_e;
        assign mpc_ir_e[31:0] = sel_hw_e ? hw_ir_e : int_ir_e;
	

	assign mpc_rega_cond_i = (mpc_run_ie || mpc_fixupi) && ~mpc_atomic_e || hw_rdgpr;
	assign mpc_rega_i [8:0] = { cpz_g_srsctl_pss2css_m ? cpz_g_srsctl_pss : 
		cpz_gm_i ? cpz_g_srsctl_css : 
		cpz_srsctl_pss2css_m ? cpz_srsctl_pss : 
		cpz_srsctl_css, icc_idata_i[25:21] };

        assign mpc_regb_cond_i = ((mpc_run_ie || mpc_fixupi) && ~mpc_atomic_e) || hw_rdgpr;
        assign mpc_regb_i[8:0] = {(cpz_gm_i & icc_rdpgpr_i & ~icc_macro_e & ~(cpz_at_pro_start_i | cpz_g_at_pro_start_i) 
		| cpz_g_srsctl_pss2css_m | hw_g_rdpgpr) ? cpz_g_srsctl_pss : 
		(~cpz_gm_i & icc_rdpgpr_i & ~icc_macro_e & ~(cpz_at_pro_start_i | cpz_g_at_pro_start_i)
		| cpz_srsctl_pss2css_m & ~cpz_gm_i | hw_rdpgpr) ? cpz_srsctl_pss : 
		cpz_g_at_pro_start_i & cpz_g_iap_um & cpz_g_usekstk | 
		cpz_at_pro_start_i & cpz_iap_um & cpz_usekstk ? 4'b1 : 
		cpz_gm_i ? cpz_g_srsctl_css : cpz_srsctl_css,
		hw_rdgpr ? 5'd29 : icc_idata_i[20:16] };
	
	// mpc_imsgn_e: Sign of immediate
	assign mpc_imsgn_e =	(mpc_ir_e[15]) && (mpc_ir_e[31] || !(mpc_ir_e[28] && mpc_ir_e[29]) && !(mpc_atomic_e||mpc_atomic_m)) 
			|| (mpc_ir_e[11]) && (mpc_atomic_e||mpc_atomic_m);	

	assign mpc_movci_e = special_e && (mpc_ir_e[5:0] == 6'o01);

	assign mpc_selimm_e = mpc_movci_e || !(special_e || mpc_lxs_e || lx_e || (mpc_ir_e[31:26] == 6'o23) ||
		     ((mpc_ir_e[31:28] == 4'b0100) && !(^mpc_ir_e[27:26] && (mpc_ir_e[25:24] == 2'b01))));


	// rdhwr_e: RDHWR instruction
	assign rdhwr_e = spec3_e & (mpc_ir_e[5:0] == 6'o73);

	// mpc_cnvt_e: Convert/Swap Operations: SEB/SEH, rel2 WSBH
	assign mpc_cnvt_e = spec3_e & (mpc_ir_e[5:0] == 6'o40);

	// mpc_cnvts_e: Convert Operations: SEB/SEH
	assign mpc_cnvts_e = mpc_cnvt_e & mpc_ir_e[10];

	// mpc_cnvtsh_e: Convert Operations: Half SEH
	assign mpc_cnvtsh_e = mpc_cnvt_e & mpc_ir_e[9];

	// mpc_swaph_e: Convert Operations: WSBH
	assign mpc_swaph_e = mpc_cnvt_e & (mpc_ir_e[10:9] == 2'b00) & mpc_ir_e[7];

	// sh_fix_e: decode shift fixed amount from major & minor op
	assign sh_fix_e = (special_e & ~mpc_ir_e[2]) | mpc_insext_e;

	// sh_var_e: decode shift variable amount from major & minor op
	assign sh_var_e = special_e && mpc_ir_e[2];

	// mpc_insext_e: M32R2 INS instruction
	assign mpc_insext_e = spec3_e & ~mpc_ir_e[5];

	// mpc_ext_e: M32R2 EXT instruction
	assign mpc_ext_e = mpc_insext_e & ~mpc_ir_e[2];

	// mpc_insext_size_e: M32R2 INS/EXT size field
	assign mpc_insext_size_e[4:0] = mpc_ir_e[15:11];

	// mpc_selrot_e: select rotate
	assign mpc_selrot_e = (sh_fix_e && (mpc_ir_e[25:21]==5'b00001)) || (sh_var_e && (mpc_ir_e[10:6]==5'b00001));

	// mpc_sharith_e: decode arithmetic shift from major & minor op
	assign mpc_sharith_e =	special_e & mpc_ir_e[0];

	// mpc_shright_e: decode right shift from major op (srl/sra/srlv/srav/swl/rotr/rotrv/ext)
	assign mpc_shright_e =	(special_e & mpc_ir_e[1]) | (mpc_ir_e[31:26] == 6'o52) | mpc_ext_e;

	// sh_fix_amt_e - amount for a fixed shift
	assign sh_fix_amt_e [4:0] = mpc_ir_e[10:6];

	// mpc_addui_e: decode ADDUI instruction from major op
	assign mpc_addui_e =	(mpc_ir_e[31:26] == 6'o17);

	// extension of CFC1/CTC1
	assign ctc1_fr0_e = (mpc_ir_e[31:26] == 6'o21) & (mpc_ir_e[25:21] == 5'b00110) 
		& ~(|mpc_ir_e[20:16]) & (mpc_ir_e[15:11] == 5'd1);
	assign ctc1_fr1_e = (mpc_ir_e[31:26] == 6'o21) & (mpc_ir_e[25:21] == 5'b00110) 
		& ~(|mpc_ir_e[20:16]) & (mpc_ir_e[15:11] == 5'd4);
	assign cfc1_fr_e = (mpc_ir_e[31:26] == 6'o21) & (mpc_ir_e[25:21] == 5'b00010) 
		& (mpc_ir_e[15:11] == 5'd1);

	// alu_sel_e: select ALU for output to ResBus in M stage
	assign alu_sel_e =	(mpc_ir_e[31:29] == 3'o1) && !mpc_ir_e[27] ||			// addi, addiu, andi, ori
			(mpc_ir_e[31:26] == 6'o16) ||				// xori
			(mpc_ir_e[31:26] == 6'o17) ||				// addui
			special_e && (mpc_ir_e[5:3] == 3'o4)  ||		// add, addu, sub, subu, and, or, xor, nor
			special_e && (mpc_ir_e[5:3] == 3'o6) && mpc_ir_e[2] || 		// teq, tne
			regimm_e && (mpc_ir_e[20:18] == 3'o3) ||			// teqi, tnei
			(mpc_ir_e[31:26] == 6'o20)	||		// cop0 (only need it for mtc0)
			mpc_cmov_e || mpc_movci_e ||
		  	mpc_clsel_e;
			
	// slt_sel_e: select set less than for output to ResBus in M stage(also Trap LT, GE)
	assign slt_sel_e =	(mpc_ir_e[31:27] == 5'b001_01)	||			// slti, sltiu
			special_e && (mpc_ir_e[5:1] == 5'b101_01) ||		// slt, sltu
			special_e && (mpc_ir_e[5:2] == 4'b110_0)  ||		// tge, tgeu, tlt, tltu
			regimm_e && (mpc_ir_e[20:18] == 3'o2);			// tgei, tgeiu, tlti tltiu

	// mpc_clsel_e: select Count Leading output for output to ResBus
	assign mpc_clsel_e = (mpc_ir_e[31:26] == 6'o34) && (mpc_ir_e[5:3] == 3'o4);

        assign mpc_clvl_e = !(mpc_ir_e[20:16] == mpc_ir_e[15:11]);
   
	// mpc_lnksel_e: Select link address: JAL/BAL/JALR
	assign mpc_lnksel_e_X = (mpc_ir_e[31:26] == 6'o03) |
		    (mpc_ir_e[31:26] == 6'o35) |
		    (regimm_e & (mpc_ir_e[20:19] == 2'b10)) |
		    (special_e & (mpc_ir_e[5:0] == 6'o11));
	mvp_cregister #(2) _mpc_lnksel_e_countdown_1_0_(mpc_lnksel_e_countdown[1:0], (mpc_run_ie & (mpc_lnksel_e_countdown[1] | mpc_lnksel_e_countdown[0])) | greset,
							 gclk,
							(greset ? 2'b10 : mpc_lnksel_e_countdown - 2'b01) );
	assign mpc_lnksel_e = (mpc_lnksel_e_countdown[0] | mpc_lnksel_e_countdown[1]) ? 1'b0 : mpc_lnksel_e_X;



	assign udi_sel_e = spec2_e && (mpc_ir_e[5:4] == 2'b01);

	assign mpc_lxs_e =	spec2_e && (mpc_ir_e[5:3] == 3'b001) && mpc_isamode_e;

	assign trap_type_e = mpc_ir_e[26] ?	mpc_ir_e[17] : mpc_ir_e[1];

	// unal_type_e: Unaligned type
	assign unal_type_e =	mpc_ir_e[28];	

	assign mpc_unal_ref_e =	(mpc_ir_e[31:30] == 2'b10) && (mpc_ir_e[27:26] == 2'b10);

	  assign signed_ld_e = !(mpc_ir_e[28]) | dec_dsp_valid_e & ~mpc_ir_e[7];

	assign mpc_subtract_e = 
	    (mpc_ir_e[31:27] == 5'h05)                 ||  // SLTI(U)
	    ((mpc_ir_e[31:26] == 6'h1) &&                  // RegImm
		(mpc_ir_e[20:19] == 2'b01))            ||  // trap immed
            ((mpc_ir_e[31:26] == 6'h0)     &&		   // SPECIAL   
	       (mpc_ir_e[5:1] != 5'b10000));               // Add(U)

	assign signed_e = (mpc_ir_e[29] & ~mpc_ir_e[26]) | (~mpc_ir_e[29] & ~mpc_ir_e[26] & ~mpc_ir_e[0]) | 
		   (~mpc_ir_e[29] & mpc_ir_e[26] & ~mpc_ir_e[16]);

	assign mpc_aluasrc_e = (mpc_ir_e[30] & ~mpc_ir_e[29]) | mpc_insext_e;
	assign mpc_alubsrc_e = !(mpc_ir_e[30] && mpc_ir_e[29] || mpc_cmov_e || mpc_movci_e);
	assign mpc_dec_rt_csel_e = (mpc_ir_e[30:29] == 2'b11)  & mpc_ir_e[27] & 
			~((mpc_ir_e[2:0] == 3'b001) & (mpc_ir_e[10:8] == 3'b111)) &
			~append_e & ~prepend_e & ~balign_e;
	assign append_e = (mpc_ir_e[5:0] == 6'o61) & (mpc_ir_e[10:9] == 2'b0) & ~mpc_ir_e[6];
	assign prepend_e = (mpc_ir_e[5:0] == 6'o61) & (mpc_ir_e[10:9] == 2'b0) & mpc_ir_e[6];
	assign balign_e = (mpc_ir_e[5:0] == 6'o61) & (mpc_ir_e[10:9] == 2'b10); 
	assign mpc_dec_rt_bsel_e = ((mpc_ir_e[30:28] == 3'b11_1) & (((mpc_ir_e[27:26] == 2'b00) & ~mpc_ir_e[5]) |
                                                     ( mpc_ir_e[27] & (mpc_ir_e[5] | mpc_ir_e[4] |
                                                                        (mpc_ir_e[3:0] == 4'b1_000)))));
	assign mpc_prepend_e = prepend_e;
	assign mpc_balign_e = balign_e;
	assign mpc_append_e = append_e;

	assign mpc_alufunc_e [1:0] =     (mpc_ir_e[30:29] == 2'b11) ? {2{mpc_ir_e[0]}} :		// CLZ/CLO
				(mpc_ir_e[30:29] == 2'b10) ? 2'b0 :			// CPZ write
				(mpc_ir_e[30:29] == 2'b01) ? mpc_ir_e[27:26] :		// Immediate Logic ops
				mpc_ir_e[5] | (mpc_ir_e[5:0] == 6'o01) ? mpc_ir_e[1:0] :		// Special Logic Ops
							 2'b0;			// CMov

	assign mpc_clinvert_e = mpc_ir_e[0];

	assign sel_logic_e = ((mpc_ir_e[31:28] == 4'b001_1) & (mpc_ir_e[27:26] != 2'b11)) |	// Imm Logic, not addui
		      (spec2_e & (mpc_ir_e[5:4] == 2'b10)) |				// CLZ/CLO
		      (special_e & ((mpc_ir_e[5:0] == 6'o01) |				// MOVF/T
				    (mpc_ir_e[5:1] == 5'b001_01) | 			// MOVZ/N
				    (mpc_ir_e[5:2] == 4'b100_1))) | 			// Spec. Logic
		      ((mpc_ir_e[31:28] == 4'b0100) & (mpc_ir_e[27:26] != 2'b11) & (mpc_ir_e[25:24] == 2'b00)) |	// CP write
		      ((mpc_ir_e[31:24] == 8'b010_000_01));				// RDPGPR/WRPGPR

// cregister conditions

	assign mpc_shf_rot_cond_e = mpc_run_ie & ((mpc_ldst_e & ~load_e) |
		((dest_e[4:0] != 5'h0) &
		 (mpc_unal_ref_e | (special_e & (mpc_ir_e[5:3] == 3'o0)) | spec3_e)));

	assign mpc_prealu_cond_e = mpc_run_ie & sel_logic_e;

// branch condition
	assign br_cond =	regimm_e && mpc_ir_e[19:18] == 2'b0;

	// br_gr: Branch on greater than zero (+L)
	assign br_gr =	(mpc_ir_e[31:26] == 6'o07) || (mpc_ir_e[31:26] == 6'o27);

	// br_le: Branch on Less than or equal to zero (+L)
	assign br_le =	(mpc_ir_e[31:26] == 6'o06) || (mpc_ir_e[31:26] == 6'o26);

	// br_ne: Branch on not equal (+L) 
	assign br_ne =	(mpc_ir_e[31:26] == 6'o05) || (mpc_ir_e[31:26] == 6'o25);

	// br_eq: Branch on equal (+L) 
	assign br_eq =	(mpc_ir_e[31:26] == 6'o04) || (mpc_ir_e[31:26] == 6'o24);

	// br_ge: Branch on greater than or equal (+L +AL +ALL)
	assign br_ge =	br_cond && mpc_ir_e[16];

	// br_lt: Branch on less than (+L +AL +ALL)
	assign br_lt =	br_cond && !mpc_ir_e[16];

	// cmp_br: comparison-type branch - BEQ or br_ne or BLEZ or BGTZ (+L)
	assign cmp_br =	(!mpc_ir_e[31] && mpc_ir_e[29:28] == 2'b01);

	// mpc_cmov_e: Conditional Move Instn
	assign mpc_cmov_e = special_e && (mpc_ir_e[5:1] == 5'b001_01);

	assign cmov_type_e = ~mpc_ir_e[0];
	
	assign dec_dsp_logic_func_e[1:0] = {edp_dsp_add_e, edp_dsp_sub_e};

	assign dec_dsp_valid_e = dsp_valid_qual_e & ~edp_dsp_mdu_valid_e;
	assign dec_logic_func_e[1:0] = {2{dec_dsp_valid_e}} & dec_dsp_logic_func_e[1:0];

	// Bit 3:2 used to zero bit 31:8 for DSP MODSUB instruction
	mvp_cregister_wide #(4) _mpc_dec_logic_func_m_3_0_(mpc_dec_logic_func_m[3:0],gscanenable, mpc_run_ie, gclk,
        { dec_logic_func_e[1] | dec_dsp_valid_e & edp_dsp_modsub_e,
          dec_logic_func_e[0] | dec_dsp_valid_e & edp_dsp_modsub_e, dec_logic_func_e });

	assign mpc_dec_logic_func_e [3:0] = 
        { dec_logic_func_e[1] | dec_dsp_valid_e & edp_dsp_modsub_e,
          dec_logic_func_e[0] | dec_dsp_valid_e & edp_dsp_modsub_e, dec_logic_func_e };

	assign dec_shll_e   = spec3_e & (mpc_ir_e[2:0] == 3'b011    );
	assign dec_insv_e   = spec3_e & ~mpc_ir_e[5] & mpc_ir_e[3] & mpc_ir_e[2];
	assign dec_shft_left_e  = (dec_shll_e & ~mpc_ir_e[6] & ~(mpc_ir_e[10:8]==3'b001) ) | //SHLL* SHLLV*
                       dec_insv_e |  //INSV
                       append_e | balign_e;
	assign dec_sh_shright_e = ~dec_shft_left_e;
	assign mpc_dec_sh_shright_e = dec_sh_shright_e;

	assign dec_sh_subst_ctl_e = mpc_ir_e[29] & ~mpc_ir_e[31] & mpc_ir_e[0] & 
			(mpc_ir_e[6] | (mpc_ir_e[10:8] == 3'b111)) & ~mpc_ir_e[5]; 
			// SRA, SRAV, SHRA_R.W, SHRAV_R.W
	assign mpc_dec_sh_subst_ctl_e = dec_sh_subst_ctl_e;

	// Shifter Output mux control (bit controlled)
	//	High range index
	//	  31		ROTR, ROTV, SLL, SLLV,Stores
	//	  15		SEH
	//	  7		SEB
	//	  EXT.msbd	EXT
	//	  INS.msb	INS
	//	  31-Cpipe	SRL, SRLV, SRA, SRAV
	//	  (7)		WSBH (just need to be lower than the WSBH low value)

	// High Select: 0: dec_sh_high_index_ag, 1: 31-Cpipe
	assign dec_sh_high_sel_e =  mpc_ir_e[29] & ~mpc_ir_e[31] & mpc_ir_e[0] & // SHRA_R.W, SHRAV_R.W
			(mpc_ir_e[6] | (mpc_ir_e[10:8] == 3'b111) | 
			(mpc_ir_e[5:3] == 3'b110) & mpc_ir_e[0] & (mpc_ir_e[8:6] == 3'b001)); 
	assign mpc_dec_sh_high_sel_e = dec_sh_high_sel_e;
                                
	// High range index

	// in case of Special3 SLL instruction, make high index all 1s
	assign dec_special3_sll_e = ~mpc_ir_e[31] & mpc_ir_e[30] & mpc_ir_e[0] & ~mpc_ir_e[2];

	assign dec_sh_high_index_e [4:0] = (~mpc_ir_e[31] & mpc_ir_e[29] & ~mpc_ir_e[5]) & 
                               ~(dec_special3_sll_e & ~mpc_ir_e[6]) ?
				  mpc_ir_e[15:11] :
				  { dec_special3_sll_e, dec_special3_sll_e, 3'h7 };
	assign mpc_dec_sh_high_index_e[4:0] = dec_sh_high_index_e[4:0];



	//	Low range index								   
	//	  0		ROTR, ROTV, SRL, SRLV, SRA, SRAV, EXT, SEB, SEH, Stores, SHLL_S.W, SHLLV_S.W
	//	  Cpipe		SLL, SLLV, INS, INSV 
	//	  (16)		WSBH (just need to be higher than the WSBH high value)

	// Low Select: 0: dec_sh_low_index_e, 1: Cpipe
	assign dec_sh_low_sel_e = ~mpc_ir_e[31] & mpc_ir_e[29] & (mpc_ir_e[2] | 
                      (mpc_ir_e[0] & ~mpc_ir_e[2] & ~mpc_ir_e[6] & ~(mpc_ir_e[10:9] == 2'b11)));
	assign mpc_dec_sh_low_sel_e = dec_sh_low_sel_e;
                      

	// Low range index, [3:0] = 4'b0
	assign dec_sh_low_index_4_e = ~mpc_ir_e[31] & mpc_ir_e[29] & mpc_ir_e[5] & ~mpc_ir_e[10] 
			& ~prepend_e & ~balign_e;
	assign mpc_dec_sh_low_index_4_e = dec_sh_low_index_4_e;
	
	// End mpc_ir_e block

	// INSV instruction
	assign mpc_dec_insv_e = dec_insv_e & dec_dsp_valid_e;

	assign mpc_dec_imm_rsimm_e = spec3_e & ( ((mpc_ir_e[3:0] == 4'o02) & (mpc_ir_e[8:7] != 2'b00)) |      // ABSQ.PH
                                  ((mpc_ir_e[2:0] == 3'o3) & ~mpc_ir_e[7])	|			// SLL.QB
				(mpc_ir_e[5] & mpc_ir_e[3] &
                                        (~mpc_ir_e[0] & ((~mpc_ir_e[10] & ~mpc_ir_e[6]) |   // MOVAC
                                                          (~mpc_ir_e[8] & ~mpc_ir_e[6]))) ) |
				((mpc_ir_e[2:0] == 3'b001) & (mpc_ir_e[5] & (mpc_ir_e[8:7] == 2'b00) | 
				~mpc_ir_e[5] & (mpc_ir_e[8:7] == 2'b11) & (mpc_ir_e[10:9] == 2'b11))));

	assign mpc_dec_imm_apipe_sh_e [15:8] = { 8 { mpc_ir_e[9] }} & {{ 7 { mpc_ir_e[25] }}, mpc_ir_e[24] };
	assign mpc_dec_imm_apipe_sh_e [7:5] = mpc_ir_e[23:21];
	assign mpc_dec_imm_apipe_sh_e [4:0] = (mpc_ir_e[26] & mpc_ir_e[4]) ?
                                ((mpc_ir_e[1:0] == 2'b10) ? mpc_ir_e[20:16] : 
				(mpc_ir_e[2:0] == 3'b001) ? ((mpc_ir_e[10:9] == 2'b10) ? (mpc_ir_e[12:11] << 3) : 
				mpc_ir_e[15:11]) : mpc_ir_e[25:21]) : mpc_ir_e[10:6];

	
	// MDU/UDI instruction
	assign dec_mdu_e = (special_e & (mpc_ir_e[5:4] == 2'b01)) |			// MFHI..MTLO, MULT..DIVU
	       (spec2_e & ~mpc_ir_e[5]) |				// MADD..MSUBU, UDI
	       dsp_mdu_valid_e;		// DSP instructions for MDU

	assign dsp_mdu_valid_e = dsp_valid_qual_e & edp_dsp_mdu_valid_e;

	assign MDU_dec_e = dec_mdu_e;

	assign dec_redirect_bposge32_e = regimm_e && (mpc_ir_e[20:16] == 5'o34);

	assign mpc_cop_e = cop_e;		// instn is a cache op
	assign mpc_shvar_e = 1'b0;		// instn is shift variable 
	assign mpc_usesrca_e = 1'b0;		      // Instn in _E uses the srcB (rt) register
	assign mpc_usesrcb_e = 1'b0; 		      // Instn in _E uses the srcA (rs) register

endmodule // m14k_mpc_dec




