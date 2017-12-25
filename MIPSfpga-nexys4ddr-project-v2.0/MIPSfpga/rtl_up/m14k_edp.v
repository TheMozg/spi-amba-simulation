// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_edp
//            execution data path
//
//	$Id: \$
//	mips_repository_id: m14k_edp.mv, v 1.58 
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

module m14k_edp(
	rf_adt_e,
	rf_bdt_e,
	dcc_ddata_m,
	cpz_cp0read_m,
	mdu_res_w,
	mpc_ir_e,
	mpc_predec_e,
	mpc_abs_e,
	MDU_info_e,
	mmu_dva_m,
	mmu_dva_mapped_m,
	cp2_data_w,
	cp1_data_w,
	mpc_muldiv_w,
	mpc_lnksel_m,
	mpc_lnksel_e,
	mpc_compact_e,
	mpc_alusel_m,
	mpc_udisel_m,
	mpc_clsel_e,
	mpc_clinvert_e,
	mpc_clvl_e,
	mpc_udislt_sel_m,
	mpc_aselres_e,
	mpc_aselwr_e,
	mpc_bselres_e,
	mpc_bselall_e,
	mpc_imsgn_e,
	mpc_selimm_e,
	mpc_br16_e,
	mpc_br32_e,
	mpc_sequential_e,
	mpc_apcsel_e,
	icc_pcrel_e,
	mpc_pcrel_e,
	mpc_lxs_e,
	mpc_usesrca_e,
	mpc_usesrcb_e,
	mpc_selrot_e,
	mpc_addui_e,
	mpc_cnvt_e,
	mpc_cnvts_e,
	mpc_cnvtsh_e,
	mpc_swaph_e,
	mpc_shright_e,
	mpc_shamt_e,
	mpc_sharith_e,
	mpc_shvar_e,
	mpc_insext_e,
	mpc_ext_e,
	mpc_insext_size_e,
	mpc_shf_rot_cond_e,
	mpc_prealu_cond_e,
	mpc_movci_e,
	mpc_selcp_m,
	mpc_selcp2to_m,
	mpc_selcp2from_m,
	mpc_selcp2from_w,
	mpc_selcp1to_m,
	mpc_selcp1from_m,
	mpc_selcp1from_w,
	mpc_selcp0_m,
	mpc_updateldcp_m,
	mpc_dcba_w,
	mpc_signd_w,
	mpc_signc_w,
	mpc_signb_w,
	mpc_signa_w,
	mpc_lda31_24sel_w,
	mpc_lda23_16sel_w,
	mpc_lda15_8sel_w,
	mpc_lda7_0sel_w,
	mpc_cdsign_w,
	mpc_bsign_w,
	mpc_subtract_e,
	mpc_signed_m,
	mpc_auexc_x,
	mpc_ret_e,
	mpc_defivasel_e,
	mpc_umips_defivasel_e,
	mpc_umips_mirrordefivasel_e,
	mpc_umipsfifosupport_i,
	mpc_eqcond_e,
	mpc_fixupi,
	mpc_jreg_e,
	mpc_jimm_e,
	cpz_ebase,
	cpz_vectoroffset,
	mpc_evecsel,
	cpz_eretpc,
	mpc_isamode_i,
	mpc_excisamode_i,
	mpc_isamode_m,
	icc_umipspresent,
	mpc_updateepc_e,
	mpc_ll_e,
	mpc_sc_e,
	mpc_cop_e,
	mpc_dspinfo_e,
	ej_rdvec_read,
	mpc_isamode_e,
	mpc_jalx_e,
	mpc_pf_phase2_done,
	mpc_hw_ls_i,
	mpc_hw_ls_e,
	mpc_tint,
	mpc_expect_isa,
	mpc_hw_load_e,
	mpc_cont_pf_phase1,
	mpc_chain_hold,
	mpc_busty_e,
	icc_umipsconfig,
	icc_addiupc_22_21_e,
	icc_umipsmode_i,
	icc_macro_e,
	icc_umips_sds,
	mpc_macro_e,
	mpc_sds_e,
	icc_halfworddethigh_i,
	icc_imiss_i,
	icc_umipsfifo_imip,
	icc_umipsfifo_ieip2,
	icc_umipsfifo_ieip4,
	icc_umipsfifo_stat,
	mpc_alufunc_e,
	mpc_aluasrc_e,
	mpc_alubsrc_e,
	mpc_sellogic_m,
	mpc_cmov_e,
	mpc_run_m,
	mpc_run_ie,
	mpc_irval_e,
	mpc_irval_m,
	mpc_irval_w,
	mpc_killmd_m,
	cpz_kuc_e,
	cpz_rbigend_e,
	cpz_erl_e,
	greset,
	gclk,
	gscanenable,
	gscanmode,
	mpc_atomic_e,
	mpc_atomic_m,
	mpc_atomic_w,
	mpc_atomic_bit_dest_w,
	mpc_atomic_clrorset_w,
	mpc_be_w,
	mpc_hw_sp,
	mpc_hw_save_epc_e,
	mpc_hw_save_status_e,
	mpc_hw_save_srsctl_e,
	mpc_hw_save_epc_m,
	mpc_hw_save_status_m,
	mpc_hw_save_srsctl_m,
	mpc_hw_load_status_e,
	mpc_hw_load_epc_e,
	mpc_hw_load_srsctl_e,
	cpz_status,
	cpz_srsctl,
	mpc_wr_sp2gpr,
	mpc_int_pref,
	mpc_epi_vec,
	mpc_iretval_e,
	mpc_iret_ret,
	cpz_iretpc,
	mpc_chain_vec,
	cpz_iack,
	cpz_epc_rd_data,
	cpz_iv,
	mpc_chain_strobe,
	mpc_chain_take,
	mpc_stkdec_in_bytes,
	mpc_lsdc1_m,
	mpc_lsdc1_w,
	mpc_lsdc1_e,
	mpc_lsuxc1_e,
	CP1_endian_0,
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
	mpc_dec_imm_apipe_sh_e,
	mpc_dec_imm_rsimm_e,
	mpc_ctl_dsp_valid_m,
	mpc_nullify_e,
	mpc_nullify_m,
	mpc_nullify_w,
	mpc_dec_rt_csel_e,
	mpc_dec_rt_bsel_e,
	mpc_mf_m2_w,
	mpc_mdu_m,
	mpc_vd_m,
	mpc_run_w,
	mpc_stall_m,
	x3_trig,
	mdu_alive_gpr_a,
	mpc_first_det_int,
	MDU_pend_ouflag_wr_xx,
	MDU_ouflag_vld_xx,
	MDU_ouflag_hilo_xx,
	MDU_ouflag_mulq_muleq_xx,
	MDU_ouflag_extl_extr_xx,
	MDU_ouflag_age_xx,
	MDU_ouflag_tcid_xx,
	MDU_data_ack_ms,
	edp_dsp_add_e,
	edp_dsp_sub_e,
	edp_dsp_modsub_e,
	edp_dsp_present_xx,
	edp_dsp_valid_e,
	edp_dsp_mdu_valid_e,
	edp_dsp_stallreq_e,
	edp_dsp_pos_r_m,
	edp_dsp_pos_ge32_e,
	edp_dsp_alu_sat_xx,
	edp_dsp_dspc_ou_wren_e,
	MDU_rs_ex,
	MDU_rt_ex,
	edp_stdata_iap_m,
	edp_abus_e,
	edp_alu_m,
	edp_bbus_e,
	edp_dva_e,
	edp_dva_mapped_e,
	edp_stalign_byteoffset_e,
	edp_iva_p,
	edp_iva_i,
	edp_epc_e,
	edp_eisa_e,
	edp_stdata_m,
	edp_wrdata_w,
	edp_ldcpdata_w,
	edp_res_w,
	edp_cacheiva_p,
	edp_cacheiva_i,
	edp_trapeq_m,
	edp_cndeq_e,
	edp_povf_m,
	edp_udi_wrreg_e,
	edp_udi_ri_e,
	edp_udi_stall_m,
	edp_udi_present,
	edp_udi_honor_cee,
	UDI_rd_m,
	UDI_wrreg_e,
	UDI_ri_e,
	UDI_stall_m,
	UDI_present,
	UDI_honor_cee,
	UDI_ir_e,
	UDI_irvalid_e,
	UDI_rs_e,
	UDI_rt_e,
	UDI_endianb_e,
	UDI_kd_mode_e,
	UDI_kill_m,
	UDI_start_e,
	UDI_run_m,
	UDI_greset,
	UDI_gscanenable,
	UDI_gclk,
	alu_cp0_rtc_ex,
	mpc_scop1_m,
	mpc_sdc1_w,
	mpc_g_int_pf,
	mpc_g_auexc_x,
	cpz_g_vectoroffset,
	cpz_gm_m,
	cpz_gm_e,
	cpz_g_iv,
	cpz_g_iretpc,
	cpz_g_rbigend_e,
	cpz_g_kuc_e,
	cpz_g_epc_rd_data,
	cpz_g_status,
	cpz_g_srsctl,
	cpz_g_erl_e,
	cpz_g_ebase);

	
	/*hookios*//* IO declarations added by hookup */
/* End of hookup IO declarations */
/* Wire declarations added by hookup */
/* End of hookup wire declarations */


	/* Inputs */
	input [31:0]	rf_adt_e;		// edp_abus_e data from register file
	input [31:0]	rf_bdt_e;		// edp_bbus_e data from register file
	input [31:0]	dcc_ddata_m;	// D$ Read data
	input [31:0]	cpz_cp0read_m;	// MFC0 data
	input [31:0]	mdu_res_w;        // MDU result (MUL, MFHI/LO)
	input [31:0]	mpc_ir_e;		// Full instn
	input [22:0]	mpc_predec_e;		// predecoded instn
	input		mpc_abs_e;		// umips operand swapped
	input [39:0]	MDU_info_e;
	input [31:0] 	mmu_dva_m;
	input [31:29] 	mmu_dva_mapped_m;
	input [31:0] 	cp2_data_w;  // Return Data from COP2
	input [63:0] 	cp1_data_w;  // Return Data from COP1

	// res_m mux controls
	input		mpc_muldiv_w;       // MDU op in W
	input		mpc_lnksel_m;       // Link instn (JAL/BAL)
	input		mpc_lnksel_e;       // Link instn (JAL/BAL)
	input 		mpc_compact_e;  // Compact jump
	input		mpc_alusel_m;       // Select ALU
        input           mpc_udisel_m;       // Select UDI
	input		mpc_clsel_e;        // Select Count Leading
	input 		mpc_clinvert_e;     // Invert Count Leading input (CL0)
        input 		mpc_clvl_e;        // Count extension
	input		mpc_udislt_sel_m;  // Select UDI or SLT
	
	// A/edp_bbus_e bypass controls
	input		mpc_aselres_e;       // Bypass res_m as src A      
	input		mpc_aselwr_e;        // Bypass res_w as src A
	input		mpc_bselres_e;       // Bypass res_m as src B
	input		mpc_bselall_e;       // Bypass res_w as src B
	
	input		mpc_imsgn_e;        // Sign Bit to extend immediate with
	input		mpc_selimm_e;       // Select Immediate
        input 		mpc_br16_e;     // UMIPS Branch instn in E
        input 		mpc_br32_e;     // MIPS32 Branch instn in E
	input           mpc_sequential_e;   // sequential instn stream
	input 		mpc_apcsel_e;       // Select PC as src A
	input 		icc_pcrel_e;        // Mask low 2b of PC for PC relative ops
	input 		mpc_pcrel_e;        // Mask low 2b of PC for PC relative ops
	input		mpc_lxs_e;		// Load index scaled command
	input		mpc_usesrca_e;
	input		mpc_usesrcb_e;

// Rotate control
	input		mpc_selrot_e;	// Perform rotate instead of shift

// Shifter controls
	input 		mpc_addui_e;            // Add Upper Immediate
	input 		mpc_cnvt_e;		// Convert/Swap Operations: SEB/SEH/WSBH
	input 		mpc_cnvts_e;		// Convert signextension operations: SEB/SEH
	input 		mpc_cnvtsh_e;		// Convert signextension operations: SEH
	input 		mpc_swaph_e;		// Swap operations: WSBH
	input		mpc_shright_e;          // Right shift (vs. Left)

	input [4:0]	mpc_shamt_e;        // 1st stage shift amount

	input		mpc_sharith_e;         // Arithmetic shift (vs. logical)
	input		mpc_shvar_e;		// instn is shift variable 

	input		mpc_insext_e;		// INS/EXT instruction
	input		mpc_ext_e;		// EXT instruction
	input [4:0]	mpc_insext_size_e;	// INS/EXT filed size

	input		mpc_shf_rot_cond_e;	// cregister condition for shf_rot_e->m
	input		mpc_prealu_cond_e;	//  cregister condition for prealu_e->m
	input		mpc_movci_e;

// Load Aligner controls
	input		mpc_selcp_m;        // Select Cp0 read data or Cp2 To data 
	input		mpc_selcp2to_m;       // Select Cp2 To data
	input		mpc_selcp2from_m;       // Select Cp2 To data
	input		mpc_selcp2from_w;       // Select Cp2 From data
	input		mpc_selcp1to_m;       // Select Cp1 To data
	input		mpc_selcp1from_m;       // Select Cp1 To data
	input		mpc_selcp1from_w;       // Select Cp1 From data
	input		mpc_selcp0_m;       // Select Cp0 read data (MFC0 or SC)
	input 		mpc_updateldcp_m; // Capture Load or CP0 data
	input		mpc_dcba_w;         // Select all bytes from D$
	input		mpc_signd_w;  	// Use sign bit of byte D
	input		mpc_signc_w;  	// Use sign bit of byte C
	input		mpc_signb_w;  	// Use sign bit of byte B
	input		mpc_signa_w;  	// Use sign bit of byte A
	input [1:0] 	mpc_lda31_24sel_w; 	// Mux select of ld_algn_w[31:24]
	input [1:0]	mpc_lda23_16sel_w;	// Mux select of ld_algn_w[23:16]
	input [1:0]	mpc_lda15_8sel_w;  	// Mux select of ld_algn_w[15:8]
	input [1:0]	mpc_lda7_0sel_w;  	// Mux select of ld_algn_w[7:0]
	input		mpc_cdsign_w;       // Sign extend to fill upper half 
	input		mpc_bsign_w;        // Sign extend to fill byte B

// AGEN Controls
	input		mpc_subtract_e;     // Use adder to Subtract
	input		mpc_signed_m;       // This is a signed operation

// edp_iva_e Mux Controls
	input 		mpc_auexc_x;
	input 		mpc_ret_e;
	input 		mpc_defivasel_e;
	input		mpc_umips_defivasel_e; 
	input		mpc_umips_mirrordefivasel_e; //smode port. specific to native umips
	input		mpc_umipsfifosupport_i; // smod port. specific to native umips
	input 		mpc_eqcond_e;
	input 		mpc_fixupi;
	input 		mpc_jreg_e;
	input 		mpc_jimm_e;
	input [31:12]	cpz_ebase;		// Exception base
	input [17:1]	cpz_vectoroffset;	// Interrupt vector offset

	input [7:0]   mpc_evecsel; 

	input [31:0] 	cpz_eretpc;

	input 		mpc_isamode_i;		// umips instn in i stage
	input		mpc_excisamode_i;	// isa change when isa not avail.
	input 		mpc_isamode_m;		// umips instn in m stage
	input 		icc_umipspresent;	// umips implemented
	input 		mpc_updateepc_e;	// update the PC
	input		mpc_ll_e;		// instn is an ll
	input		mpc_sc_e;		// instn is a sc
	input		mpc_cop_e;		// instn is a cache op
	input [22:0]	mpc_dspinfo_e;
	

	input [31:0]	ej_rdvec_read;		// ejt exception vector
	input 		mpc_isamode_e;		// umips instn in e stage
	input		mpc_jalx_e;		// jalx cmd executed

	input		mpc_pf_phase2_done;	// phase2 of interrupt prefetch is done
	input		mpc_hw_ls_i;
	input		mpc_hw_ls_e;	       //HW operation in E-stage
	input		mpc_tint;
	input		mpc_expect_isa;		// core is expected to be in isa mode
	input		mpc_hw_load_e;
	input		mpc_cont_pf_phase1;	// continue phase1 of interrupt prefetch
	input		mpc_chain_hold;		// hold chain info
	input [2:0]	mpc_busty_e;		// bus type

	input [1:0]	icc_umipsconfig;	// umips positioning
	input [1:0]	icc_addiupc_22_21_e;	// addiupc decode bits
	input		icc_umipsmode_i;
        input           icc_macro_e;		// macro in e-stage
	input		icc_umips_sds;		// short delay slot instn
	input		mpc_macro_e;		// smod port
	input		mpc_sds_e;		// smod port
        input           icc_halfworddethigh_i;	// i stage has 16b instn
        input           icc_imiss_i;		// miss in i stage
	input		icc_umipsfifo_imip;	// incr memory PC
	input		icc_umipsfifo_ieip2;	// incr PC by 2
	input		icc_umipsfifo_ieip4;	// incr PC by 4
	input [3:0]	icc_umipsfifo_stat;	// umips fifo fullness
	
// ALU Controls
	input [1:0]	mpc_alufunc_e;    // Logic Function 00-AND,01-OR,10-XOR,11-NOR 
	input		mpc_aluasrc_e;    // A src for ALU (0-edp_abus_e, 1-BBusOrImm)
	input		mpc_alubsrc_e;    // B src for ALU (0-edp_abus_e, 1-BBusOrImm)
	input		mpc_sellogic_m;  // Select Logic Function output
	
	input		mpc_cmov_e;	        // Conditional move instn
	input		mpc_run_m;          // M-stage Run signal
	input		mpc_run_ie;          // E-stage Run signal

	// UDI control signals
        input           mpc_irval_e;      // IR is valid 
        input           mpc_irval_m;      // Instn register is valid
        input           mpc_irval_w;      // Instn register is valid

        input           mpc_killmd_m;       // Kill signal for UDI
	input 		cpz_kuc_e;         // Kernel/User indication: 0-Kernel, 1-user
	input 		cpz_rbigend_e;     // Endian 0-little, 1-big
	input		cpz_erl_e;
	

	input		greset;		// To be used in UDI for resetting state reg.
	input		gclk;            // Clock
	input 		gscanenable;
	input 		gscanmode;    
//Atomic control 
	input 		mpc_atomic_e; 		// Atomic instruciton in E stage
	input 		mpc_atomic_m; 		// Atomic instruciton in M stage
	input 		mpc_atomic_w; 		// Atomic instruciton in W stage
	input  [2:0]	mpc_atomic_bit_dest_w;	//Which bit need to do set or clr operation
	input 		mpc_atomic_clrorset_w;	//set or clr for bit operation
	input  [3:0]		mpc_be_w;


        input [31:0]    mpc_hw_sp;             // sp saved to GPR during HW sequence
        input           mpc_hw_save_epc_e;     // E-stage HW save EPC operation
        input           mpc_hw_save_status_e;  // E-stage HW save Status operation
        input           mpc_hw_save_srsctl_e;  // E-stage HW save SRSCTL operation
        input           mpc_hw_save_epc_m;     // M-stage HW save EPC operation
        input           mpc_hw_save_status_m;  // M-stage HW save Status operation
        input           mpc_hw_save_srsctl_m;  // M-stage HW save SRSCTL operation
        input           mpc_hw_load_status_e;  // E-stage HW load Status operation
        input           mpc_hw_load_epc_e;     // E-stage HW load EPC operation
        input           mpc_hw_load_srsctl_e;  // E-stage HW load SRSCTL operation
        input [31:0]    cpz_status;            // Status saved to stack during HW sequence
        input [31:0]    cpz_srsctl;            // SRSCTL saved to stack during HW sequence
        input           mpc_wr_sp2gpr;         // write stobe to update sp to GPR during HW sequence
        input           mpc_int_pref;          // PC hold during HW seqence
        input           mpc_epi_vec;           // hold pc during auto epilogue until normal return or jump to next interrupt
        input           mpc_iretval_e;         // E-stage IRET instruction
        input           mpc_iret_ret;          // PC redirect due to IRET return
        input [31:0]    cpz_iretpc;            // return to the original epc on IRET if tail chain not happen
        input           mpc_chain_vec;         // jump to next interrupt PC on IRET if tailchain happen
	input           cpz_iack;              // interrupt acknowledge
	input [31:0]    cpz_epc_rd_data;       // EPC data for HW saving operation
	input 		cpz_iv;                // State of Cause.IV
	input           mpc_chain_strobe;      // tail chain happen strobe
	input           mpc_chain_take;        // tail chain taken
	input	[6:0]	mpc_stkdec_in_bytes;
	input           mpc_lsdc1_m;	       
	input           mpc_lsdc1_w;	       
	input           mpc_lsdc1_e;	       
	input           mpc_lsuxc1_e;	       
	input           CP1_endian_0;	       

	input	[3:0]	mpc_dec_logic_func_m;
	input	[3:0]	mpc_dec_logic_func_e;
	input		mpc_dec_sh_shright_m;
	input		mpc_dec_sh_shright_e;
	input		mpc_dec_sh_subst_ctl_m;
	input		mpc_dec_sh_subst_ctl_e;
	input		mpc_dec_sh_high_sel_m;
	input		mpc_dec_sh_high_sel_e;
	input		mpc_append_m;
	input		mpc_append_e;
	input		mpc_prepend_m;
	input		mpc_prepend_e;
	input		mpc_balign_m;
	input		mpc_balign_e;
	input	[4:0]	mpc_dec_sh_high_index_m;
	input	[4:0]	mpc_dec_sh_high_index_e;
	input		mpc_dec_sh_low_sel_m;
	input		mpc_dec_sh_low_sel_e;
	input		mpc_dec_sh_low_index_4_m;
	input		mpc_dec_sh_low_index_4_e;
	input		mpc_dec_insv_e;
	input	[15:0]	mpc_dec_imm_apipe_sh_e;
	input		mpc_dec_imm_rsimm_e;
	input		mpc_ctl_dsp_valid_m;
	input		mpc_nullify_e;
	input		mpc_nullify_m;
	input		mpc_nullify_w;
	input		mpc_dec_rt_csel_e;
	input		mpc_dec_rt_bsel_e;
	input		mpc_mf_m2_w;
	input		mpc_mdu_m;
	input		mpc_vd_m;
	input		mpc_run_w;		// W-stage Run
        input           mpc_stall_m;   
	input		x3_trig;
	input		mdu_alive_gpr_a;
	input		mpc_first_det_int;


	//OUFlag updates from MDU 
	input [8:0]     MDU_pend_ouflag_wr_xx; 	// update to ouflag pending
	input           MDU_ouflag_vld_xx;  	// ouflag values are valid
	input [3:0]     MDU_ouflag_hilo_xx; 	// ouflag values for HI/LO sets
	input           MDU_ouflag_mulq_muleq_xx;  	// ouflag value for MULQ/MULEQ
	input           MDU_ouflag_extl_extr_xx;  	// ouflag value for EXTL/R
	input [1:0]     MDU_ouflag_age_xx;  	// age of instr. setting ouflag
	input [3:0]     MDU_ouflag_tcid_xx;  	// TC id of instr. setting ouflag
	input 		MDU_data_ack_ms;  	

	output		edp_dsp_add_e;		// Add instruction from DSP
	output		edp_dsp_sub_e;		// Sub instruction from DSP
	output		edp_dsp_modsub_e;		
	output		edp_dsp_present_xx;		
	output		edp_dsp_valid_e;		
	output		edp_dsp_mdu_valid_e;		
	output		edp_dsp_stallreq_e;		
	output	[5:0]	edp_dsp_pos_r_m;		
	output		edp_dsp_pos_ge32_e;		
	output		edp_dsp_alu_sat_xx;		
	output		edp_dsp_dspc_ou_wren_e;
	output	[31:0]	MDU_rs_ex;		
	output	[31:0]	MDU_rt_ex;		

        output [31:0]   edp_stdata_iap_m;      // Store Data mux with interrupt auto prologue store

	/* Outputs */
	output [31:0]	edp_abus_e;         // Src A bus
	output [31:0]	edp_alu_m;          // ALU output for MTC0
	output [31:0]	edp_bbus_e;         // Src B bus
	output [31:0]	edp_dva_e;            // Data virtual address (E-stage)
	output [31:29]	edp_dva_mapped_e;   // Data virtual address mapped (E-stage)
	output [1:0]	edp_stalign_byteoffset_e;	// Data virtual address[1:0] used for store align byte
	output [31:0] 	edp_iva_p;            // Instn virtual address (preI-stage)
	output [31:0] 	edp_iva_i;          // Instn virtual address (I-stage)
	output [31:0] 	edp_epc_e;          // Exception Program Counter
	output 		edp_eisa_e;         // Exception ISA Mode
	output [31:0]	edp_stdata_m;    // Store Data
	output [31:0]	edp_wrdata_w;            // Register File write data
	output [31:0]	edp_ldcpdata_w;   // Load or MFC0 data
	output [31:0] 	edp_res_w;		// Store data for trace

	output [31:0]   edp_cacheiva_p; //replaces the edp_iva_p for memories
	output [31:0]	edp_cacheiva_i;

	
 
	output		edp_trapeq_m;         // Trap compare result 
	output		edp_cndeq_e;          // Branch compare result
	output		edp_povf_m;         // Possible overflow
        output [4:0]    edp_udi_wrreg_e;       // Reg to be written by UDI
        output          edp_udi_ri_e;         // UDI not implemented.
        output          edp_udi_stall_m;       // Stall the pipe due to multicycle UDI
	output 		edp_udi_present;      // UDI is implemented
	output 		edp_udi_honor_cee;    // Look at CEE bit


        // UDI Interface Signals
        input [31:0]        UDI_rd_m;    
        input [4:0]         UDI_wrreg_e;
        input               UDI_ri_e;
        input               UDI_stall_m;
        input               UDI_present;
        input               UDI_honor_cee;
        output [31:0]       UDI_ir_e;		// Full instn
        output              UDI_irvalid_e;          // IR is valid
        output [31:0]       UDI_rs_e;               
        output [31:0]       UDI_rt_e;
        output              UDI_endianb_e;
        output              UDI_kd_mode_e;
        output              UDI_kill_m;
        output              UDI_start_e;
        output              UDI_run_m;
        output              UDI_greset;
        output              UDI_gscanenable;
        output              UDI_gclk;               

	output [8:0]	    alu_cp0_rtc_ex; 

	input		mpc_scop1_m;
	input		mpc_sdc1_w;

	input		mpc_g_int_pf;
	input		mpc_g_auexc_x;	    // Exception has reached end of pipe, redirect fetch
	input [17:1]	cpz_g_vectoroffset;	// Interrupt vector offset
	input		cpz_gm_m;
	input		cpz_gm_e;
	input		cpz_g_iv;
        input [31:0]    cpz_g_iretpc;             //return to the original epc on IRET if tail chain not happen
	input		cpz_g_rbigend_e;	// reverse Endianess from state of bigend mode bit in user mode
	input		cpz_g_kuc_e;
        input [31:0]    cpz_g_epc_rd_data;        //EPC data for HW saving operation
        input [31:0]   	cpz_g_status;             //Status data for HW sequence
	input [31:0]   	cpz_g_srsctl;             //SRSCTL data for HW entry sequence
	input		cpz_g_erl_e;
	input [31:12]	cpz_g_ebase;	// Exception base

// BEGIN Wire declarations made by MVP
wire cond_hw;
wire [31:0] /*[31:0]*/ srie_3_e;
wire [8:0] /*[8:0]*/ alu_cp0_rtc_ex;
wire [31:0] /*[31:0]*/ edp_bbus_e;
wire edp_cndeq_e;
wire dp_add_c32_e;
wire [31:0] /*[31:0]*/ edp_iva_p_n;
wire [31:0] /*[31:0]*/ hold_hw_ret_pc;
wire [11:0] /*[11:0]*/ evec_11_0_e;
wire edp_iva_i_cond;
wire [8:0] /*[8:0]*/ alu_tcid1hot_ms;
wire [31:0] /*[31:0]*/ aop_e;
wire pro31_m;
wire [31:0] /*[31:0]*/ iva_e;
wire [31:0] /*[31:0]*/ sgnd_imm_e;
wire car30_m;
wire [31:0] /*[31:0]*/ edp_dva_e;
wire [31:0] /*[31:0]*/ MDU_rt_ex;
wire [7:0] /*[7:0]*/ ld_algn_7_0_w;
wire [31:0] /*[31:0]*/ logic_b_1_0_e;
wire [31:0] /*[31:0]*/ asp_m;
wire [15:0] /*[15:0]*/ abus_noinsv_e;
wire [31:0] /*[31:0]*/ pipe_abus_e;
wire [4:0] /*[4:0]*/ abus_noinsv_imm_e;
wire [31:0] /*[31:0]*/ cp0_or_cp2_or_cp1_m;
wire [31:0] /*[31:0]*/ mirror_edp_iva_p_hold;
wire atomic_store_stall_rddata_back_reg;
wire [3:0] /*[3:0]*/ alu_tcid_ex;
wire [31:0] /*[31:0]*/ shf_rot_m;
wire [31:0] /*[31:0]*/ edp_stdata_iap_m;
wire [4:0] /*[4:0]*/ shamt_e;
wire [31:0] /*[31:0]*/ dcba_or_res_w;
wire [31:0] /*[31:0]*/ incsum_e;
wire edp_iva_i_legacy_cond;
wire pro31_e;
wire edp_trapeq_m;
wire incsum_e_cond;
wire [3:0] /*[3:0]*/ alu_tcid_ms;
wire dp_opb_sign_e;
wire edp_iva_p_holdcond;
wire [31:0] /*[31:0]*/ pc_hold;
wire [31:0] /*[31:0]*/ edp_iva_p_umips;
wire [7:0] /*[7:0]*/ srie_subst_7_0_e;
wire [31:0] /*[31:0]*/ shf_rot_m_mux;
wire [31:0] /*[31:0]*/ dp_shift_merge_e;
wire [31:0] /*[31:0]*/ edp_cacheiva_p;
wire [15:8] /*[15:8]*/ srie_subst_15_8_e;
wire dp_overflow_e;
wire [31:0] /*[31:0]*/ atomic_word_w_reg;
wire edp_iva_i_umips_cond;
wire [31:0] /*[31:0]*/ edp_res_w;
wire [31:0] /*[31:0]*/ cp2_or_cp1_w;
wire edp_eisa_e;
wire [31:0] /*[31:0]*/ edp_iva_p_hold;
wire [31:0] /*[31:0]*/ prealu_m;
wire [31:0] /*[31:0]*/ preiva_p;
wire [8:0] /*[8:0]*/ alu_tcid1hot_rf;
wire [4:0] /*[4:0]*/ dp_apipe_plus_e;
wire [31:0] /*[31:0]*/ cl_in_e;
wire [31:0] /*[31:0]*/ br_targ_e_c1;
wire [7:0] /*[7:0]*/ atomic_bit_dest_exp_w;
wire [31:0] /*[31:0]*/ shf_rot_e;
wire [31:0] /*[31:0]*/ edp_iva_p_exit;
wire [8:0] /*[8:0]*/ alu_cp0_wtc_er;
wire [31:0] /*[31:0]*/ asp_nodsp_m;
wire [31:0] /*[31:0]*/ bbus_imm_e;
wire [31:0] /*[31:0]*/ sp_m;
wire mfttr_minus_one_ag;
wire sh_low_sel_plus_e;
wire [1:0] /*[1:0]*/ edp_stalign_byteoffset_e;
wire [31:0] /*[31:0]*/ edp_abus_e;
wire [31:0] /*[31:0]*/ mirror_edp_iva_p;
wire [31:0] /*[31:0]*/ preabus_e;
wire [31:29] /*[31:29]*/ new_dva_mapped_e;
wire [31:0] /*[31:0]*/ mirror_edp_iva_p_raw;
wire [31:0] /*[31:0]*/ MDU_rs_ex;
wire bit0_m;
wire [31:20] /*[31:20]*/ evec_31_20_e;
wire [31:0] /*[31:0]*/ pc_hold_raw;
wire [31:0] /*[31:0]*/ srie_2_e;
wire [4:0] /*[4:0]*/ srie_high_e;
wire atomic_store_stall_rddata_back;
wire [31:0] /*[31:0]*/ prebbus_e;
wire [31:0] /*[31:0]*/ srie_4_e;
wire [31:0] /*[31:0]*/ umips_pc_hold;
wire [31:0] /*[31:0]*/ alu_e;
wire [31:0] /*[31:0]*/ mirror_preiva_p;
wire [31:0] /*[31:0]*/ mirror_incsum_e;
wire [3:0] /*[3:0]*/ alu_tcid_ag;
wire sh_shright_plus_e;
wire [31:0] /*[31:0]*/ br_targ_e;
wire [31:0] /*[31:0]*/ edp_iva_p;
wire [31:0] /*[31:0]*/ dp_cpipe_e;
wire [8:0] /*[8:0]*/ alu_tcid1hot_ex;
wire [31:0] /*[31:0]*/ dp_add_e;
wire [31:0] /*[31:0]*/ dp_cpipe_zero_e;
wire [7:0] /*[7:0]*/ ld_algn_15_8_w;
wire edp_iva_p_holdcond_d;
wire [4:0] /*[4:0]*/ srie_low_e;
wire [31:0] /*[31:0]*/ alu_or_save;
wire [31:0] /*[31:0]*/ mirror_edp_iva_i;
wire [31:0] /*[31:0]*/ atomic_word_w;
wire [31:0] /*[31:0]*/ ld_or_cp_m;
wire [31:0] /*[31:0]*/ dp_bpipe_e;
wire [31:0] /*[31:0]*/ a_nor_b_e;
wire [31:0] /*[31:0]*/ edp_epc_e;
wire [31:0] /*[31:0]*/ a_and_b_e;
wire edp_iva_p_holdcond_ini;
wire [31:0] /*[31:0]*/ x_pc_hold;
wire [8:0] /*[8:0]*/ alu_cp0_rtc_ag;
wire [31:0] /*[31:0]*/ a_xor_b_e;
wire [31:0] /*[31:0]*/ srie_1_e;
wire [31:0] /*[31:0]*/ edp_alu_m;
wire mdu_data_valid_m_tmp_reg;
wire [31:0] /*[31:0]*/ edp_ldcpdata_w;
wire dec_subtract_e;
wire [31:0] /*[31:0]*/ edp_iva_i;
wire [31:0] /*[31:0]*/ srie_0_e;
wire [31:0] /*[31:0]*/ jaddr_e;
wire car31_m;
wire [31:0] /*[31:0]*/ srie_in_e;
wire incsum_e_umips_cond;
wire [19:12] /*[19:12]*/ evec_19_12_e;
wire [31:0] /*[31:0]*/ hw_ret_pc;
wire [31:0] /*[31:0]*/ bop_e;
wire mirror_default;
wire [31:0] /*[31:0]*/ mirror_edp_iva_p_atomic;
wire [7:0] /*[7:0]*/ cdsgn_or_ld_w;
wire edp_povf_m;
wire dp_add_c31_e;
wire [7:0] /*[7:0]*/ atomic_byte_w;
wire [31:29] /*[31:29]*/ edp_dva_mapped_e;
wire [31:0] /*[31:0]*/ a_or_b_e;
wire [7:0] /*[7:0]*/ ld_algn_23_16_w;
wire [31:0] /*[31:0]*/ preiva_p_c1;
wire [31:0] /*[31:0]*/ logic_ain_e;
wire mdu_data_valid_m_tmp;
wire [31:16] /*[31:16]*/ srie_subst_31_16_e;
wire [31:0] /*[31:0]*/ cp2_or_md_w;
wire [31:0] /*[31:0]*/ jraddr_e;
wire [31:0] /*[31:0]*/ wrdata_w_int;
wire [7:0] /*[7:0]*/ bsgn_or_ld_w;
wire [31:0] /*[31:0]*/ new_dva_e;
wire sgn_bit;
wire [31:0] /*[31:0]*/ ld_algn_w;
wire [3:0] /*[3:0]*/ alu_tcid_er;
wire dp_add_c31_ex;
wire [31:0] /*[31:0]*/ bbusis_e;
wire [31:0] /*[31:0]*/ dva_offset_e;
wire [31:0] /*[31:0]*/ edp_cacheiva_i;
wire chain_take_reg;
wire [8:0] /*[8:0]*/ alu_tcid1hot_ag;
wire [31:0] /*[31:0]*/ pcoffset_e;
wire [31:0] /*[31:0]*/ edp_stdata_m;
wire [31:0] /*[31:0]*/ adder_res_m;
wire incsum_e_legacy_cond;
wire [31:0] /*[31:0]*/ evec_e;
wire [7:0] /*[7:0]*/ ld_algn_31_24_w;
wire [31:0] /*[31:0]*/ acmp_e;
wire [31:0] /*[31:0]*/ logic_bin_e;
wire [8:0] /*[8:0]*/ alu_tcid1hot_er;
wire [31:0] /*[31:0]*/ logic_out_e;
wire [31:0] /*[31:0]*/ edp_wrdata_w;
wire sh_high_sel_plus_e;
// END Wire declarations made by MVP



	wire [31:0] cnt_lead_e;
        wire [31:0]         res_m;

        wire [31:0]         dsp_data_m;
        wire [4:0]         dsp_dspc_pos_e;
	wire		dsp_carryin_e;


	wire	umipspremodule, umipspostmodule;
	wire	auexc_x_handling, int_pref_handling; 



	assign x_pc_hold[31:0] = mpc_isamode_m ? umips_pc_hold[31:0] : pc_hold[31:0];

	// sp_m: LinkAddr or shift/rotate output
	mvp_mux2 #(32) _sp_m_31_0_(sp_m[31:0],mpc_lnksel_m, shf_rot_m_mux, {x_pc_hold[31:1], mpc_isamode_m});

	mvp_mux2 #(32) _asp_nodsp_m_31_0_(asp_nodsp_m[31:0],mpc_alusel_m, sp_m , edp_alu_m[31:0]);
	mvp_mux2 #(32) _asp_m_31_0_(asp_m[31:0],mpc_ctl_dsp_valid_m, asp_nodsp_m , dsp_data_m[31:0]);


	mvp_cregister_wide #(32) _edp_res_w_31_0_(edp_res_w[31:0],gscanenable, mpc_run_m, gclk, res_m[31:0]);

	// Bus edp_abus_e[31:0]: A Bypass Mux output
        mvp_mux2 #(32) _preabus_e_31_0_(preabus_e[31:0],mpc_aselwr_e, res_m[31:0], edp_wrdata_w[31:0]);

	mvp_mux2 #(16) _edp_abus_e_31_16_(edp_abus_e[31:16],mpc_aselres_e, rf_adt_e[31:16], preabus_e[31:16]);
	mvp_mux2 #(16) _abus_noinsv_e_15_0_(abus_noinsv_e[15:0],mpc_aselres_e, rf_adt_e[15:0], preabus_e[15:0]);
	mvp_mux2 #(5) _abus_noinsv_imm_e_4_0_(abus_noinsv_imm_e[4:0],mpc_dec_imm_rsimm_e, abus_noinsv_e[4:0], mpc_dec_imm_apipe_sh_e[4:0]);
	mvp_mux2 #(5) _edp_abus_e_4_0_(edp_abus_e[4:0],mpc_dec_insv_e, abus_noinsv_imm_e[4:0], dsp_dspc_pos_e[4:0]);
	mvp_mux2 #(11) _edp_abus_e_15_5_(edp_abus_e[15:5],mpc_dec_imm_rsimm_e, abus_noinsv_e[15:5], mpc_dec_imm_apipe_sh_e[15:5]);

	// Bus edp_bbus_e[31:0]: B Bypass Mux
        mvp_mux2 #(32) _prebbus_e_31_0_(prebbus_e[31:0],mpc_bselall_e, edp_wrdata_w[31:0], res_m[31:0]);

	mvp_mux2 #(32) _edp_bbus_e_31_0_(edp_bbus_e[31:0],mpc_bselres_e, rf_bdt_e, prebbus_e);

// Shifter/Rotator/Insert/Extract - Entire SRIE computed in E-stage
	// Select source
	mvp_mux2 #(32) _srie_in_e_31_0_(srie_in_e[31:0],mpc_aluasrc_e, edp_bbus_e, edp_abus_e);

	mvp_mux2 #(5) _shamt_e_4_0_(shamt_e[4:0],mpc_shright_e, {mpc_shamt_e[4] ^ (|mpc_shamt_e[3:0]),
					     mpc_shamt_e[3] ^ (|mpc_shamt_e[2:0]),
					     mpc_shamt_e[2] ^ (|mpc_shamt_e[1:0]),
					     mpc_shamt_e[1] ^ (mpc_shamt_e[0]),
					     mpc_shamt_e[0]},
					    mpc_shamt_e);

	// barrel shifter, first shift bytes, then bits
	mvp_mux2 #(32) _srie_0_e_31_0_(srie_0_e[31:0],shamt_e[3], srie_in_e, { srie_in_e[7:0], srie_in_e[31:8] });
	mvp_mux2 #(32) _srie_1_e_31_0_(srie_1_e[31:0],shamt_e[4], srie_0_e, { srie_0_e[15:0], srie_0_e[31:16] });
	mvp_mux2 #(32) _srie_2_e_31_0_(srie_2_e[31:0],shamt_e[0], srie_1_e, { srie_1_e[0], srie_1_e[31:1] });
	mvp_mux2 #(32) _srie_3_e_31_0_(srie_3_e[31:0],shamt_e[1], srie_2_e, { srie_2_e[1:0], srie_2_e[31:2] });
	mvp_mux2 #(32) _srie_4_e_31_0_(srie_4_e[31:0],shamt_e[2], srie_3_e, { srie_3_e[3:0], srie_3_e[31:4] });


	// Subst, setup value of bits to be substituted 
	assign srie_subst_7_0_e[7:0] = ({ 8 {mpc_sharith_e & edp_bbus_e[31]}}) |
				({ 8 {mpc_insext_e & ~mpc_ext_e}} & edp_bbus_e[7:0]) |
				({ 8 {mpc_swaph_e}} & edp_bbus_e[15:8]);

	assign srie_subst_15_8_e[15:8] = ({ 8 {mpc_sharith_e & edp_bbus_e[31]}}) |
				  ({ 8 {mpc_cnvts_e & edp_bbus_e[7]}}) |
				  ({ 8 {mpc_insext_e & ~mpc_ext_e}} & edp_bbus_e[15:8]) |
				  ({ 8 {mpc_swaph_e}} & edp_bbus_e[7:0]);

	assign srie_subst_31_16_e[31:16] = ({ 16 {mpc_sharith_e & edp_bbus_e[31]}}) |
				    ({ 16 {mpc_cnvts_e & (mpc_cnvtsh_e ? edp_bbus_e[15] : edp_bbus_e[7])}}) |
				    ({ 16 {mpc_insext_e & ~mpc_ext_e}} & edp_bbus_e[31:16]) |
				    ({ 16 {mpc_swaph_e}} & { edp_bbus_e[23:16],edp_bbus_e[31:24] });

	// Lower end of "bits to keep" range, for swap just make sure that low >= 5'h10
	assign srie_low_e [4:0] = (mpc_shright_e | mpc_ext_e | mpc_cnvt_e) ? { mpc_swaph_e, 4'b0 } :
										  mpc_shamt_e;

	// Higher end of "bits to keep" range, for swap just make sure that high < 5'h10
	assign srie_high_e [4:0] =
		(mpc_insext_e) ? mpc_insext_size_e :
				 ((mpc_cnvt_e) ? ((mpc_cnvtsh_e) ? 5'hf : 5'h7) :
						 ((mpc_shright_e & ~mpc_selrot_e) ? ~mpc_shamt_e : 5'h1f));

	assign shf_rot_e [31:0] = { ((srie_high_e >= 5'h1f) & (5'h1f >= srie_low_e)) ? srie_4_e[31] : srie_subst_31_16_e[31],
			     ((srie_high_e >= 5'h1e) & (5'h1e >= srie_low_e)) ? srie_4_e[30] : srie_subst_31_16_e[30],
			     ((srie_high_e >= 5'h1d) & (5'h1d >= srie_low_e)) ? srie_4_e[29] : srie_subst_31_16_e[29],
			     ((srie_high_e >= 5'h1c) & (5'h1c >= srie_low_e)) ? srie_4_e[28] : srie_subst_31_16_e[28],
			     ((srie_high_e >= 5'h1b) & (5'h1b >= srie_low_e)) ? srie_4_e[27] : srie_subst_31_16_e[27],
			     ((srie_high_e >= 5'h1a) & (5'h1a >= srie_low_e)) ? srie_4_e[26] : srie_subst_31_16_e[26],
			     ((srie_high_e >= 5'h19) & (5'h19 >= srie_low_e)) ? srie_4_e[25] : srie_subst_31_16_e[25],
			     ((srie_high_e >= 5'h18) & (5'h18 >= srie_low_e)) ? srie_4_e[24] : srie_subst_31_16_e[24],
			     ((srie_high_e >= 5'h17) & (5'h17 >= srie_low_e)) ? srie_4_e[23] : srie_subst_31_16_e[23],
			     ((srie_high_e >= 5'h16) & (5'h16 >= srie_low_e)) ? srie_4_e[22] : srie_subst_31_16_e[22],
			     ((srie_high_e >= 5'h15) & (5'h15 >= srie_low_e)) ? srie_4_e[21] : srie_subst_31_16_e[21],
			     ((srie_high_e >= 5'h14) & (5'h14 >= srie_low_e)) ? srie_4_e[20] : srie_subst_31_16_e[20],
			     ((srie_high_e >= 5'h13) & (5'h13 >= srie_low_e)) ? srie_4_e[19] : srie_subst_31_16_e[19],
			     ((srie_high_e >= 5'h12) & (5'h12 >= srie_low_e)) ? srie_4_e[18] : srie_subst_31_16_e[18],
			     ((srie_high_e >= 5'h11) & (5'h11 >= srie_low_e)) ? srie_4_e[17] : srie_subst_31_16_e[17],
			     ((srie_high_e >= 5'h10) & (5'h10 >= srie_low_e)) ? srie_4_e[16] : srie_subst_31_16_e[16],

			     ((srie_high_e >= 5'hf) & (5'hf >= srie_low_e)) ? srie_4_e[15] : srie_subst_15_8_e[15],
			     ((srie_high_e >= 5'he) & (5'he >= srie_low_e)) ? srie_4_e[14] : srie_subst_15_8_e[14],
			     ((srie_high_e >= 5'hd) & (5'hd >= srie_low_e)) ? srie_4_e[13] : srie_subst_15_8_e[13],
			     ((srie_high_e >= 5'hc) & (5'hc >= srie_low_e)) ? srie_4_e[12] : srie_subst_15_8_e[12],
			     ((srie_high_e >= 5'hb) & (5'hb >= srie_low_e)) ? srie_4_e[11] : srie_subst_15_8_e[11],
			     ((srie_high_e >= 5'ha) & (5'ha >= srie_low_e)) ? srie_4_e[10] : srie_subst_15_8_e[10],
			     ((srie_high_e >= 5'h9) & (5'h9 >= srie_low_e)) ? srie_4_e[9] : srie_subst_15_8_e[9],
			     ((srie_high_e >= 5'h8) & (5'h8 >= srie_low_e)) ? srie_4_e[8] : srie_subst_15_8_e[8],

			     ((srie_high_e >= 5'h7) & (5'h7 >= srie_low_e)) ? srie_4_e[7] : srie_subst_7_0_e[7],
			     ((srie_high_e >= 5'h6) & (5'h6 >= srie_low_e)) ? srie_4_e[6] : srie_subst_7_0_e[6],
			     ((srie_high_e >= 5'h5) & (5'h5 >= srie_low_e)) ? srie_4_e[5] : srie_subst_7_0_e[5],
			     ((srie_high_e >= 5'h4) & (5'h4 >= srie_low_e)) ? srie_4_e[4] : srie_subst_7_0_e[4],
			     ((srie_high_e >= 5'h3) & (5'h3 >= srie_low_e)) ? srie_4_e[3] : srie_subst_7_0_e[3],
			     ((srie_high_e >= 5'h2) & (5'h2 >= srie_low_e)) ? srie_4_e[2] : srie_subst_7_0_e[2],
			     ((srie_high_e >= 5'h1) & (5'h1 >= srie_low_e)) ? srie_4_e[1] : srie_subst_7_0_e[1],
			     ((srie_high_e >= 5'h0) & (5'h0 >= srie_low_e)) ? srie_4_e[0] : srie_subst_7_0_e[0]};

	mvp_cregister_wide #(32) _shf_rot_m_31_0_(shf_rot_m[31:0],gscanenable, mpc_shf_rot_cond_e, gclk, shf_rot_e); 
	assign edp_stdata_m [31:0] = mpc_atomic_w & !atomic_store_stall_rddata_back_reg ? atomic_word_w_reg
				: mpc_atomic_w ?	atomic_word_w
				: mpc_sdc1_w ? (CP1_endian_0 ? cp1_data_w[31:0] : cp1_data_w[63:32]) 
				: mpc_scop1_m ? (CP1_endian_0 ? cp1_data_w[63:32] : cp1_data_w[31:0]) 
				: shf_rot_m;

        mvp_mux1hot_4 #(32) _edp_stdata_iap_m_31_0_(edp_stdata_iap_m[31:0],mpc_hw_save_epc_m , cpz_gm_m ? cpz_g_epc_rd_data : cpz_epc_rd_data[31:0] ,
                                  mpc_hw_save_status_m , cpz_gm_m ? cpz_g_status : cpz_status[31:0] ,
                                  mpc_hw_save_srsctl_m , cpz_gm_m ? cpz_g_srsctl : cpz_srsctl[31:0] ,
                                  ~(mpc_hw_save_epc_m | mpc_hw_save_status_m | mpc_hw_save_srsctl_m), 
				  edp_stdata_m[31:0]);
	assign shf_rot_m_mux[31:0] = edp_stdata_iap_m;	

// Load Aligner:
	mvp_mux2 #(32) _alu_or_save_31_0_(alu_or_save[31:0],mpc_selcp2to_m | mpc_selcp2from_m | mpc_selcp1to_m | mpc_selcp1from_m, edp_ldcpdata_w[31:0], edp_alu_m);

	mvp_mux2 #(32) _cp0_or_cp2_or_cp1_m_31_0_(cp0_or_cp2_or_cp1_m[31:0],mpc_selcp0_m, alu_or_save, cpz_cp0read_m);

	mvp_mux2 #(32) _ld_or_cp_m_31_0_(ld_or_cp_m[31:0],mpc_selcp_m, dcc_ddata_m, cp0_or_cp2_or_cp1_m);

	mvp_cregister_wide #(32) _edp_ldcpdata_w_31_0_(edp_ldcpdata_w[31:0],gscanenable, mpc_updateldcp_m, gclk, ld_or_cp_m);

	assign sgn_bit = (mpc_signd_w & edp_ldcpdata_w[31]) |
	     (mpc_signc_w & edp_ldcpdata_w[23]) |
	     (mpc_signb_w & edp_ldcpdata_w[15]) |
	     (mpc_signa_w & edp_ldcpdata_w[7]);

	mvp_mux2 #(32) _dcba_or_res_w_31_0_(dcba_or_res_w[31:0],mpc_dcba_w, edp_res_w, edp_ldcpdata_w);

	mvp_mux2 #(8) _bsgn_or_ld_w_7_0_(bsgn_or_ld_w[7:0],mpc_bsign_w, edp_ldcpdata_w[7:0], {8{ sgn_bit }});
	
	mvp_mux2 #(8) _cdsgn_or_ld_w_7_0_(cdsgn_or_ld_w[7:0],mpc_cdsign_w, edp_ldcpdata_w[15:8], {8{ sgn_bit }});

	mvp_mux4 #(8) _ld_algn_31_24_w_7_0_(ld_algn_31_24_w[7:0],mpc_lda31_24sel_w,
			 bsgn_or_ld_w,
			 cdsgn_or_ld_w,
			 edp_ldcpdata_w[23:16],
			 dcba_or_res_w[31:24]);
   
	mvp_mux4 #(8) _ld_algn_23_16_w_7_0_(ld_algn_23_16_w[7:0],mpc_lda23_16sel_w,
			 bsgn_or_ld_w,
			 cdsgn_or_ld_w,
			 edp_ldcpdata_w[31:24],
			 dcba_or_res_w[23:16]);
			 
	mvp_mux4 #(8) _ld_algn_15_8_w_7_0_(ld_algn_15_8_w[7:0],mpc_lda15_8sel_w,
			 bsgn_or_ld_w,
			 edp_ldcpdata_w[23:16],
			 edp_ldcpdata_w[31:24],
			 dcba_or_res_w[15:8]);
			 
	mvp_mux4 #(8) _ld_algn_7_0_w_7_0_(ld_algn_7_0_w[7:0],mpc_lda7_0sel_w,
			 edp_ldcpdata_w[15:8],
			 edp_ldcpdata_w[23:16],
			 edp_ldcpdata_w[31:24],
			 dcba_or_res_w[7:0]);
//Atomic bit operation 
	assign atomic_bit_dest_exp_w [7:0] = (8'b1 << mpc_atomic_bit_dest_w); 
	assign atomic_byte_w [7:0] = mpc_atomic_clrorset_w ? (ld_algn_7_0_w | atomic_bit_dest_exp_w) : (ld_algn_7_0_w & ~atomic_bit_dest_exp_w);
	mvp_mux1hot_4 #(32) _atomic_word_w_31_0_(atomic_word_w[31:0],mpc_be_w[3], { atomic_byte_w [7:0], 24'h0},
					mpc_be_w[2], { 8'h0, atomic_byte_w [7:0], 16'h0},
					mpc_be_w[1], { 16'h0, atomic_byte_w [7:0], 8'h0},
					mpc_be_w[0], { 24'h0, atomic_byte_w [7:0]} );

	assign atomic_store_stall_rddata_back = mpc_atomic_w & mpc_atomic_m & mpc_run_m;
	mvp_cregister #(1) _atomic_store_stall_rddata_back_reg(atomic_store_stall_rddata_back_reg, (atomic_store_stall_rddata_back | ~mpc_atomic_w), gclk, ~(atomic_store_stall_rddata_back & mpc_atomic_w));
	mvp_cregister_wide #(32) _atomic_word_w_reg_31_0_(atomic_word_w_reg[31:0],gscanenable, atomic_store_stall_rddata_back & atomic_store_stall_rddata_back_reg, gclk, atomic_word_w); 
	assign ld_algn_w [31:0] = {ld_algn_31_24_w, ld_algn_23_16_w, ld_algn_15_8_w, ld_algn_7_0_w};
   
	assign cp2_or_cp1_w [31:0] = {32{mpc_selcp2from_w}} & cp2_data_w | {32{mpc_selcp1from_w}} & cp1_data_w[31:0];
	mvp_mux2 #(32) _cp2_or_md_w_31_0_(cp2_or_md_w[31:0],mpc_selcp2from_w|mpc_selcp1from_w, mdu_res_w, cp2_or_cp1_w);

	// Bus edp_wrdata_w[31:0]: RF write data
        mvp_mux2 #(32) _wrdata_w_int_31_0_(wrdata_w_int[31:0],mpc_muldiv_w | mdu_alive_gpr_a | mpc_mf_m2_w, ld_algn_w, cp2_or_md_w);
        mvp_mux2 #(32) _edp_wrdata_w_31_0_(edp_wrdata_w[31:0],mpc_wr_sp2gpr, wrdata_w_int, mpc_hw_sp);










	// Bus sgnd_imm_e[31:0]: Sign extended immediate value and upper immediate value
	assign sgnd_imm_e [31:0] =  icc_pcrel_e ? { {7{icc_addiupc_22_21_e[1]}}, icc_addiupc_22_21_e, mpc_ir_e[25:21], mpc_ir_e[15:0], 2'b0} :
				mpc_addui_e ? { mpc_ir_e[15:0], 16'b0 } :
						 {{16{mpc_imsgn_e}}, mpc_ir_e[15:0]};
	mvp_mux2 #(32) _bbus_imm_e_31_0_(bbus_imm_e[31:0],mpc_selimm_e, edp_bbus_e, sgnd_imm_e);


	assign bop_e [31:0] = {32{mpc_subtract_e}} ^ bbus_imm_e;

	// Mask low 2b for pc-relative ops (but not for branches)
	mvp_cregister_wide #(32) _iva_e_31_0_(iva_e[31:0],gscanenable, mpc_run_ie, gclk, edp_iva_i); 
	// pcmasked_e [31:0] = icc_pcrel_e ? (iva_e & ~{30'b0, {2{icc_pcrel_e}}}) : pc_hold;
	
        assign aop_e [31:0] = icc_pcrel_e ? (iva_e & ~{30'b0, {2{icc_pcrel_e}}}) :  edp_abus_e;

	// Carry Propagate Adder
	wire 		c31_e;
        wire [31:0]     adder_res_e;
        wire [31:0]     new_dva_e_int;

	wire 		car31_e;

 	assign dva_offset_e[31:0] = !mpc_selimm_e ? bbusis_e 
		: (mpc_atomic_e || mpc_atomic_m) ? {{20{mpc_imsgn_e}}, mpc_ir_e[11:0]} 
		: {{16{mpc_imsgn_e}}, mpc_ir_e[15:0]};
	assign new_dva_e_int[31:0] = aop_e[31:0] + dva_offset_e;
 
	`M14K_EDP_ADD edp_add( .a(aop_e),
			     .b(bop_e),
			     .ci(mpc_subtract_e),
                             .s(adder_res_e),

			     .co(car31_e),
			     .c31(c31_e));

//flag
        assign pcoffset_e [31:0] =  mpc_br16_e ? { {15{mpc_imsgn_e}}, mpc_ir_e[15:0], 1'b0} :
			                  { {14{mpc_imsgn_e}}, mpc_ir_e[15:0], 2'b0};

        assign br_targ_e [31:0] = pc_hold + pcoffset_e;

	mvp_register #(1) _chain_take_reg(chain_take_reg,gclk, mpc_chain_take);

        assign new_dva_e[31:0] = ~mpc_hw_ls_e ? (mpc_lsdc1_m ? {mmu_dva_m[31:3], 3'b100} : 
			  {new_dva_e_int[31:3], {3{~mpc_lsuxc1_e}} & new_dva_e_int[2:0]} ) :
			  mpc_hw_save_epc_e ? mpc_hw_sp :
			  mpc_hw_save_status_e ? mpc_hw_sp + 32'd4 : 
			  mpc_hw_save_srsctl_e ? mpc_hw_sp + 32'd8 :
			  mpc_hw_load_status_e ? mpc_hw_sp : 
			  mpc_hw_load_epc_e ? (chain_take_reg ? mpc_hw_sp :
					      mpc_hw_sp - mpc_stkdec_in_bytes) : 
			  chain_take_reg ? mpc_hw_sp + 32'd8 
					 : mpc_hw_sp - mpc_stkdec_in_bytes + 32'd8;







	assign new_dva_mapped_e [31:29] = { (cpz_gm_e ? cpz_g_erl_e : cpz_erl_e) ? (new_dva_e[31:30] == 2'b11) : new_dva_e[30],		// bit 31
				     (cpz_gm_e ? cpz_g_erl_e : cpz_erl_e) ? new_dva_e[30] : (new_dva_e[31] ^~ new_dva_e[30]),	// bit 30
				     ((new_dva_e[31:30] != 2'b10) & new_dva_e[29]) };			// bit 29

	mvp_mux2 #(32) _edp_dva_e_31_0_(edp_dva_e[31:0],!mpc_run_ie, new_dva_e, mmu_dva_m);
	mvp_mux2 #(3) _edp_dva_mapped_e_31_29_(edp_dva_mapped_e[31:29],!mpc_run_ie, new_dva_mapped_e, mmu_dva_mapped_m);
	assign edp_stalign_byteoffset_e [1:0] = aop_e[1:0] + mpc_ir_e[1:0];

	assign pro31_e = aop_e[31] ^ bop_e[31];

	mvp_cregister #(1) _pro31_m(pro31_m,mpc_run_ie, gclk, pro31_e);

	mvp_cregister #(1) _car31_m(car31_m,mpc_run_ie, gclk, car31_e);

	mvp_cregister #(1) _car30_m(car30_m,mpc_run_ie, gclk, c31_e);

	// Possible Overflow:  CarryOut30 != CarryOut31
	assign edp_povf_m = car30_m ^ car31_m;

	// bit0_m: result of set less than operation (inverted)
	assign bit0_m =	mpc_signed_m ?	(pro31_m ^ car31_m) : ~car31_m;

	// Bus jaddr_e[31:0]: Immediate page mode extended for J/JAL
        assign jaddr_e [31:0] = mpc_isamode_e & !mpc_jalx_e ? {edp_iva_i[31:27], mpc_ir_e[25:0], 1'h0 } :
                                        { edp_iva_i[31:28], mpc_ir_e[25:0], 2'h0 } ;


	// jraddr_e[31:0]: destination for a jump register
	assign jraddr_e [31:0] = edp_abus_e[31:0] & ~{31'b0, icc_umipspresent};
	assign incsum_e [31:0] = edp_iva_i[31:0] + 32'h0000_0004;

	// Bus evec_e[31:0]: Selected exception vector
	assign evec_31_20_e [31:20] =
                          mpc_evecsel[`M14K_EVEC_DEBUG] && !mpc_evecsel[`M14K_EVEC_PROBE] ?
                                mpc_evecsel[`M14K_EVEC_RDVEC] ? ej_rdvec_read[31:20] : `M14K_DEBUG_BASE :
                          mpc_evecsel[`M14K_EVEC_DEBUG] && mpc_evecsel[`M14K_EVEC_PROBE] ? `M14K_DEBUGPRB_BASE :
                          (mpc_evecsel[`M14K_EVEC_RESET] || mpc_evecsel[`M14K_EVEC_BEV]) && ~mpc_first_det_int ? `M14K_RESET_BASE :
                         {mpc_g_auexc_x ? cpz_g_ebase[31:30] : cpz_ebase[31:30], (mpc_evecsel[`M14K_EVEC_CACHEERR] ? 1'b1 : 
			(mpc_g_auexc_x ? cpz_g_ebase[29] : cpz_ebase[29])), mpc_g_auexc_x ? cpz_g_ebase[28:20] : cpz_ebase[28:20]};

        assign evec_19_12_e [19:12] =  (mpc_evecsel[`M14K_EVEC_RESET] | mpc_evecsel[`M14K_EVEC_BEV]) & ~mpc_first_det_int |
                                (mpc_evecsel[`M14K_EVEC_DEBUG] && (mpc_evecsel[`M14K_EVEC_PROBE] ||
                                        !mpc_evecsel[`M14K_EVEC_PROBE] && !mpc_evecsel[`M14K_EVEC_RDVEC])) ? 8'h0 :
                                (mpc_evecsel[`M14K_EVEC_DEBUG] && !mpc_evecsel[`M14K_EVEC_PROBE] &&
                                        mpc_evecsel[`M14K_EVEC_RDVEC]) ? ej_rdvec_read[19:12] :
                                (mpc_g_auexc_x ? cpz_g_ebase[19:12] : cpz_ebase[19:12]) |
                                               {2'h0, (mpc_int_pref | mpc_cont_pf_phase1) & mpc_g_int_pf & cpz_g_iv |
							mpc_chain_vec & cpz_gm_m ? cpz_g_vectoroffset[17:12] : 
							(mpc_int_pref | mpc_cont_pf_phase1) & ~mpc_g_int_pf & cpz_iv |
							mpc_chain_vec & ~cpz_gm_m ? cpz_vectoroffset[17:12] : 
							{6 {mpc_evecsel[`M14K_EVEC_INT]}} & (mpc_g_auexc_x ? 
							cpz_g_vectoroffset[17:12] : cpz_vectoroffset[17:12])};

	assign evec_11_0_e [11:0] =
                             mpc_evecsel[`M14K_EVEC_DEBUG] & ~mpc_evecsel[`M14K_EVEC_PROBE] ?
                                        mpc_evecsel[`M14K_EVEC_RDVEC] ? {ej_rdvec_read[11:1], 1'b0} : `M14K_DEBUG_OFF :
                             mpc_evecsel[`M14K_EVEC_DEBUG] & mpc_evecsel[`M14K_EVEC_PROBE] ? `M14K_DEBUGPRB_OFF :
                             mpc_evecsel[`M14K_EVEC_RESET] & ~mpc_first_det_int ? 12'b0 :
                             (mpc_evecsel[`M14K_EVEC_BEV] & (mpc_evecsel[`M14K_EVEC_INT] | (mpc_int_pref | mpc_cont_pf_phase1) & 
				(mpc_g_int_pf ? cpz_g_iv : cpz_iv) | mpc_chain_vec )) ? `M14K_BEVINT_OFF :
                              ((mpc_evecsel[`M14K_EVEC_BEV] ? (mpc_evecsel[`M14K_EVEC_CACHEERR] ?
                                                             `M14K_BEVCACHEERR_OFF : `M14K_BEV_OFF) : 12'b0) |
			       	( (mpc_int_pref | mpc_cont_pf_phase1) & mpc_g_int_pf & cpz_g_iv | mpc_chain_vec & cpz_gm_m ?
				{cpz_g_vectoroffset[11:1], 1'h0} :
				(mpc_int_pref | mpc_cont_pf_phase1) & ~mpc_g_int_pf & cpz_iv | mpc_chain_vec & ~cpz_gm_m ?
				{cpz_vectoroffset[11:1], 1'h0} :
                              mpc_evecsel[`M14K_EVEC_INT] ? {mpc_g_auexc_x ? cpz_g_vectoroffset[11:1] : cpz_vectoroffset[11:1], 1'h0} :
                                                            ((mpc_evecsel[`M14K_EVEC_TLB] ? `M14K_GEN_OFF :
                                                            mpc_evecsel[`M14K_EVEC_CACHEERR] ? `M14K_CACHEERR_OFF : 12'b0))));

	assign evec_e [31:0] = {evec_31_20_e, evec_19_12_e, evec_11_0_e};

	// Bus edp_iva_p[31:0]: Output of condition mux
	mvp_mux2 #(32) _edp_iva_p_n_31_0_(edp_iva_p_n[31:0],mpc_eqcond_e, preiva_p, br_targ_e);

	assign preiva_p_c1 [31:0] = ~icc_umipsmode_i | mpc_auexc_x | edp_iva_p_holdcond_ini ? preiva_p :
				edp_iva_p_holdcond_d ? edp_iva_p_hold : 
				preiva_p;
	assign br_targ_e_c1 [31:0] =  ~icc_umipsmode_i | mpc_auexc_x | edp_iva_p_holdcond_ini ? br_targ_e :
				edp_iva_p_holdcond_d ? edp_iva_p_hold :
				br_targ_e;
	mvp_mux2 #(32) _edp_iva_p_31_0_(edp_iva_p[31:0],mpc_eqcond_e, preiva_p_c1, br_targ_e_c1);


	assign edp_iva_p_umips [31:0] = (icc_umipsmode_i & incsum_e_cond & ~mpc_eqcond_e) ? 
		( icc_umipsfifo_ieip2 & ~icc_umipsfifo_ieip4) ? edp_iva_i[31:0] + 32'h0000_0002 : 
		(~icc_umipsfifo_ieip2 &  icc_umipsfifo_ieip4) ? edp_iva_p_n[31:0] : edp_iva_i /*null-slip*/ :
		        edp_iva_p_n[31:0] ;

	mvp_cregister_wide #(32) _edp_iva_p_hold_31_0_(edp_iva_p_hold[31:0],gscanenable, mpc_run_ie | greset, gclk, edp_iva_p_umips & ~{32{greset}});
	assign edp_iva_p_exit[31:0] = ~icc_umipsmode_i | mpc_auexc_x | edp_iva_p_holdcond_ini ? edp_iva_p_umips : edp_iva_p_holdcond_d ? edp_iva_p_hold : edp_iva_p_umips;



	mvp_register #(1) _edp_iva_p_holdcond_d(edp_iva_p_holdcond_d, gclk, ~greset & edp_iva_p_holdcond & (icc_umipsmode_i ? (icc_imiss_i & (mpc_run_ie | mpc_fixupi | mpc_hw_load_e & ~(mpc_chain_strobe | mpc_chain_take))) : (icc_imiss_i & mpc_run_ie) ) );

	assign edp_iva_p_holdcond_ini = ((mpc_iret_ret | mpc_eqcond_e | mpc_jreg_e | mpc_jimm_e | mpc_ret_e | auexc_x_handling | int_pref_handling | cond_hw) & icc_umipsmode_i) | 
			(mpc_chain_vec & mpc_expect_isa);
	assign edp_iva_p_holdcond = edp_iva_p_holdcond_ini | edp_iva_p_holdcond_d;


	assign edp_iva_i_legacy_cond = ( (mpc_fixupi & ~(mpc_int_pref | mpc_cont_pf_phase1) ) | (icc_macro_e & ~mpc_jreg_e)) & ~mpc_iret_ret & ~mpc_chain_vec;
	assign edp_iva_i_umips_cond  = ( (~mpc_auexc_x & (icc_imiss_i | (!mpc_run_ie & !mpc_fixupi))) | icc_macro_e) &
				~(mpc_int_pref | mpc_cont_pf_phase1) & 
				~mpc_iret_ret & ~mpc_chain_vec & ~mpc_lsdc1_e &
				~mpc_epi_vec & ~mpc_jreg_e & ~mpc_jimm_e & ~mpc_ret_e & ~mpc_iret_ret & ~mpc_atomic_e;
	assign edp_iva_i_cond = mpc_isamode_i ? edp_iva_i_umips_cond : edp_iva_i_legacy_cond;
	assign incsum_e_legacy_cond  = mpc_defivasel_e;
	assign incsum_e_umips_cond   = mpc_umips_defivasel_e;
	assign incsum_e_cond  = mpc_isamode_i ? incsum_e_umips_cond : incsum_e_legacy_cond;

        mvp_mux1hot_10 #(32) _preiva_p_31_0_(preiva_p[31:0],edp_iva_i_cond | ((mpc_atomic_e | mpc_lsdc1_e) & mpc_isamode_i & ~(mpc_int_pref | mpc_cont_pf_phase1) ), edp_iva_i,
                                 mpc_auexc_x & ~(mpc_int_pref | mpc_cont_pf_phase1) & ~( (mpc_fixupi & ~icc_umipsmode_i)  | 
				 (icc_macro_e & ~mpc_jreg_e) | mpc_iret_ret) | mpc_chain_vec, evec_e,
                                 (mpc_int_pref | mpc_cont_pf_phase1) & ~mpc_iret_ret & ~mpc_chain_vec, evec_e,
				 mpc_epi_vec & ~(mpc_fixupi | (icc_macro_e & ~mpc_jreg_e)), hw_ret_pc,
                                 mpc_jreg_e, jraddr_e,
                                 mpc_jimm_e, jaddr_e,
                                 mpc_ret_e, cpz_eretpc,
                                 mpc_iret_ret, cpz_gm_m ? cpz_g_iretpc : cpz_iretpc,
				 (mpc_atomic_e | mpc_lsdc1_e) & ~mpc_isamode_i & ~(mpc_int_pref | mpc_cont_pf_phase1) ,edp_iva_i,
                                 incsum_e_cond, incsum_e);

	assign umipspremodule  = icc_umipsconfig[1] & ~icc_umipsconfig[0];
	assign umipspostmodule = ~icc_umipsconfig[1] & icc_umipsconfig[0];

        assign auexc_x_handling = mpc_auexc_x & ~(mpc_int_pref | mpc_cont_pf_phase1) & ~( (mpc_fixupi & ~icc_umipsmode_i)  | (icc_macro_e & ~mpc_jreg_e) | mpc_iret_ret);
        assign int_pref_handling = (mpc_int_pref | mpc_cont_pf_phase1) & ~mpc_iret_ret;

	assign cond_hw   = mpc_epi_vec & ~(mpc_fixupi | (icc_macro_e & ~mpc_jreg_e));
	assign mirror_default = auexc_x_handling | int_pref_handling | mpc_chain_vec | cond_hw | mpc_jreg_e | mpc_jimm_e | mpc_ret_e | mpc_iret_ret;

	mvp_mux1hot_4 #(32) _mirror_preiva_p_31_0_(mirror_preiva_p[31:0],
				~mpc_isamode_i | mirror_default,
					preiva_p,
				mpc_isamode_i & ((mpc_atomic_e | mpc_lsdc1_e) & ~(mpc_int_pref | mpc_cont_pf_phase1) ),
					mirror_edp_iva_p_atomic,
				mpc_isamode_i & edp_iva_i_cond,
					mirror_edp_iva_i,
				mpc_isamode_i & incsum_e_cond,
					mirror_incsum_e
				);
	mvp_mux2 #(32) _mirror_edp_iva_p_raw_31_0_(mirror_edp_iva_p_raw[31:0],mpc_eqcond_e, mirror_preiva_p, br_targ_e);
	assign mirror_edp_iva_p[31:0] = ~mpc_isamode_i | mpc_auexc_x | edp_iva_p_holdcond_ini ? mirror_edp_iva_p_raw : ~edp_iva_p_holdcond_ini & edp_iva_p_holdcond ? mirror_edp_iva_p_hold : mirror_edp_iva_p_raw;
	mvp_cregister_wide #(32) _mirror_edp_iva_p_hold_31_0_(mirror_edp_iva_p_hold[31:0],gscanenable, mpc_run_ie | greset, gclk, mirror_edp_iva_p_raw & ~{32{greset}});
	mvp_register #(32) _mirror_edp_iva_p_atomic_31_0_(mirror_edp_iva_p_atomic[31:0], gclk, mirror_edp_iva_p & ~{32{greset}}); 
	mvp_cregister_wide #(32) _mirror_edp_iva_i_31_0_(mirror_edp_iva_i[31:0],gscanenable, ( mpc_run_ie | (mpc_fixupi & !icc_imiss_i)) | greset,
				 gclk, mirror_edp_iva_p & ~{32{greset}});

	assign mirror_incsum_e [31:0]  = icc_umipsfifo_imip ? mirror_edp_iva_i[31:0] + 32'h0000_0004 : mirror_edp_iva_i[31:0];

	assign edp_cacheiva_p [31:0] = (mpc_isamode_i && (umipspremodule | umipspostmodule)) ? mirror_edp_iva_p[31:0] : edp_iva_p[31:0];
	assign edp_cacheiva_i [31:0] = (mpc_isamode_i && (umipspremodule | umipspostmodule)) ? mirror_edp_iva_i[31:0] : edp_iva_i[31:0];


	// hold incsum_e during HW interrupt return sequence
        assign hw_ret_pc[31:0] = mpc_iretval_e ? edp_iva_i : hold_hw_ret_pc;
        mvp_cregister_wide #(32) _hold_hw_ret_pc_31_0_(hold_hw_ret_pc[31:0],gscanenable, mpc_iretval_e, gclk, hw_ret_pc);

	mvp_cregister_wide #(32) _edp_iva_i_31_0_(edp_iva_i[31:0],gscanenable, (!icc_umipsmode_i & mpc_run_ie) ||
			( icc_umipsmode_i & !(icc_imiss_i & ~(mpc_hw_ls_i | mpc_chain_hold)) & (mpc_run_ie | mpc_fixupi)), gclk, edp_iva_p_exit);

	mvp_cregister_wide #(32) _pc_hold_31_0_(pc_hold[31:0],gscanenable, (!icc_umipsmode_i & mpc_run_ie & !mpc_compact_e) ||
						     ( icc_umipsmode_i & !mpc_compact_e &
							(mpc_run_ie | (mpc_fixupi & !icc_imiss_i))),
				 gclk, pc_hold_raw);

        mvp_mux1hot_4 #(32) _pc_hold_raw_31_0_(pc_hold_raw[31:0],
                        ~icc_umipsmode_i, incsum_e,
                        icc_umipsfifo_ieip2 & ~icc_umipsfifo_ieip4, (edp_iva_i[31:0] + 32'h0000_0002),
                        ~icc_umipsfifo_ieip2 & icc_umipsfifo_ieip4, incsum_e,
                        icc_umipsmode_i & (~icc_umipsfifo_ieip2 & ~icc_umipsfifo_ieip4), edp_iva_i
                        );

	mvp_cregister_wide #(32) _umips_pc_hold_31_0_(umips_pc_hold[31:0],gscanenable, (mpc_lnksel_e & mpc_run_ie),
				 gclk, (edp_iva_i[31:0] + (icc_umips_sds ? 32'h0000_0002: 32'h0000_0004)) ); 


	// Bus edp_epc_e[31:0]: exception pc stack
	mvp_cregister_wide #(32) _edp_epc_e_31_0_(edp_epc_e[31:0],gscanenable, mpc_run_ie && mpc_updateepc_e && !mpc_epi_vec, gclk, edp_iva_i);
	mvp_cregister #(1) _edp_eisa_e(edp_eisa_e,mpc_run_ie && mpc_updateepc_e, gclk, mpc_isamode_i);
	


	
// Logic Unit This unit passes CMov data, CPZ write data, and 
// also does the logic functions, and, or, xor, nor
	mvp_mux2 #(32) _logic_bin_e_31_0_(logic_bin_e[31:0],mpc_alubsrc_e, edp_abus_e, bbus_imm_e);

	mvp_mux2 #(32) _logic_ain_e_31_0_(logic_ain_e[31:0],mpc_aluasrc_e, edp_abus_e, bbus_imm_e);

	assign a_and_b_e [31:0] = logic_ain_e & logic_bin_e;

	assign a_or_b_e [31:0] = logic_ain_e | logic_bin_e;

	assign a_xor_b_e [31:0] = a_or_b_e & ~a_and_b_e;
	
	assign a_nor_b_e [31:0] = ~a_or_b_e;

	mvp_mux4 #(32) _logic_out_e_31_0_(logic_out_e[31:0],mpc_alufunc_e, a_and_b_e, a_or_b_e, a_xor_b_e, a_nor_b_e);

	mvp_mux2 #(32) _alu_e_31_0_(alu_e[31:0],mpc_clsel_e, logic_out_e, cnt_lead_e);

	mvp_cregister_wide #(32) _prealu_m_31_0_(prealu_m[31:0],gscanenable, mpc_prealu_cond_e, gclk, alu_e);
	mvp_cregister_wide #(32) _adder_res_m_31_0_(adder_res_m[31:0],gscanenable, mpc_run_ie, gclk, adder_res_e); 

	mvp_mux2 #(32) _edp_alu_m_31_0_(edp_alu_m[31:0],mpc_sellogic_m, adder_res_m, prealu_m);
	
	// count leading zeros unit
	assign cl_in_e [31:0] = mpc_clinvert_e ? ~edp_abus_e : edp_abus_e;
	
	m14k_edp_clz edp_clz(cnt_lead_e, cl_in_e
			    , mpc_clvl_e
			    );
	
	

// comparators
	assign edp_trapeq_m = mpc_alusel_m ? (edp_alu_m == 32'h0) : ~bit0_m;

	mvp_mux2 #(32) _acmp_e_31_0_(acmp_e[31:0],mpc_cmov_e, edp_abus_e, 32'h0);

	assign edp_cndeq_e = acmp_e == edp_bbus_e;

	mvp_mux2 #(32) _bbusis_e_31_0_(bbusis_e[31:0],mpc_lxs_e,edp_bbus_e,{edp_bbus_e[29:0], 2'b00});

	`M14K_EDP_BUF_MODULE misc(
			         .mpc_udisel_m(mpc_udisel_m),
			         .mpc_ir_e(mpc_ir_e),
			         .mpc_irval_e(mpc_irval_e),
                                 .edp_abus_e(edp_abus_e),
                                 .edp_bbus_e(edp_bbus_e),
                                 .cpz_rbigend_e(cpz_gm_e ? cpz_g_rbigend_e : cpz_rbigend_e),
                                 .cpz_kuc_e(cpz_gm_e ? cpz_g_kuc_e : cpz_kuc_e),
                                 .mpc_killmd_m(mpc_killmd_m),
                                 .mpc_run_ie(mpc_run_ie),
                                 .mpc_run_m(mpc_run_m),
                                 .greset(greset),
                                 .gclk( gclk),
                                 .UDI_gclk(UDI_gclk),
                                 .gscanenable(gscanenable),
                                 .gscanmode(gscanmode),
                                 .UDI_rd_m(UDI_rd_m),
                                 .UDI_wrreg_e(UDI_wrreg_e),
                                 .UDI_ri_e(UDI_ri_e),
                                 .UDI_stall_m(UDI_stall_m),
                                 .UDI_present(UDI_present),
                                 .UDI_honor_cee(UDI_honor_cee),
                                 .UDI_ir_e(UDI_ir_e),
                                 .UDI_irvalid_e(UDI_irvalid_e),
                                 .UDI_rs_e(UDI_rs_e),
                                 .UDI_rt_e(UDI_rt_e),
                                 .UDI_endianb_e(UDI_endianb_e),
                                 .UDI_kd_mode_e(UDI_kd_mode_e),
                                 .UDI_kill_m(UDI_kill_m),
                                 .UDI_start_e(UDI_start_e),
                                 .UDI_run_m(UDI_run_m),
                                 .UDI_greset(UDI_greset),
                                 .UDI_gscanenable(UDI_gscanenable),
                                 .res_m(res_m),
                                 .edp_udi_wrreg_e(edp_udi_wrreg_e),
                                 .edp_udi_stall_m(edp_udi_stall_m),
                                 .edp_udi_present(edp_udi_present),
                                 .edp_udi_honor_cee(edp_udi_honor_cee),
                                 .edp_udi_ri_e(edp_udi_ri_e),
                                 .asp_m(asp_m),
                                 .bit0_m(bit0_m),
                                 .mpc_udislt_sel_m(mpc_udislt_sel_m)

        );

	assign pipe_abus_e[31:0] = {edp_abus_e[31:16], abus_noinsv_e[15:0]};
	mvp_mux2 #(32) _dp_bpipe_e_31_0_(dp_bpipe_e[31:0],mpc_aluasrc_e & ~mpc_dec_rt_bsel_e, edp_bbus_e, pipe_abus_e);

	mvp_mux2 #(32) _dp_cpipe_e_31_0_(dp_cpipe_e[31:0],mpc_dec_rt_csel_e, pipe_abus_e, edp_bbus_e);

	assign MDU_rs_ex[31:0] = edp_abus_e;
	assign MDU_rt_ex[31:0] = dp_bpipe_e;

	assign logic_b_1_0_e[31:0] = logic_block(dp_bpipe_e[31:0],
                                {{ 24 {mpc_dec_logic_func_e[3]}}, { 8 {mpc_dec_logic_func_e[1]}}},
                                {{ 24 {mpc_dec_logic_func_e[2]}}, { 8 {mpc_dec_logic_func_e[0]}}});

	// Add/Subtract ----------------------------------------
	assign dec_subtract_e = dsp_carryin_e;

	assign { dp_add_c31_e, dp_add_e[30:0] } = edp_abus_e[30:0] + logic_b_1_0_e[30:0] + { 30'b0, dec_subtract_e };
	assign { dp_add_c32_e, dp_add_e[31] } = edp_abus_e[31] + logic_b_1_0_e[31] + dp_add_c31_e;

	assign dp_overflow_e = dp_add_c32_e ^ dp_add_c31_e;

	assign dp_opb_sign_e = logic_b_1_0_e[31];

	wire	[31:0]	dp_bshift_plus_e;
	wire	[31:0]	dp_shift_plus_e;
	wire	[31:0]	dp_shift_e;
	wire	[31:0]	dp_bshift_e;
	wire		dp_shft_rnd_plus_e;
	wire		dp_shft_rnd_e;

	/*hookup*/
	m14k_alu_shft_32bit shift_32bit_main(
	.append_e(mpc_append_e),
	.dp_apipe_e(edp_abus_e[4:0]),
	.dp_bpipe_e(dp_bpipe_e),
	.dp_bshift_e(dp_bshift_e),
	.dp_cpipe_e(dp_cpipe_zero_e),
	.dp_shft_rnd_e(dp_shft_rnd_e),
	.dp_shift_e(dp_shift_e),
	.sh_high_index_e(mpc_dec_sh_high_index_e),
	.sh_high_sel_e(mpc_dec_sh_high_sel_e),
	.sh_low_index_4_e(mpc_dec_sh_low_index_4_e),
	.sh_low_sel_e(mpc_dec_sh_low_sel_e),
	.sh_shright_e(mpc_dec_sh_shright_e),
	.sh_subst_ctl_e(mpc_dec_sh_subst_ctl_e));

	assign sh_high_sel_plus_e = mpc_dec_sh_high_sel_e & ~mpc_prepend_e | mpc_balign_e;
	assign sh_low_sel_plus_e = mpc_dec_sh_low_sel_e & ~mpc_balign_e | mpc_prepend_e;
	assign sh_shright_plus_e = mpc_dec_sh_shright_e & ~mpc_prepend_e | mpc_balign_e;
	mvp_mux2 #(4) _dp_apipe_plus_e_4_1_(dp_apipe_plus_e[4:1],mpc_prepend_e | mpc_balign_e, edp_abus_e [4:1],
							{ (edp_abus_e[4] ^ (|edp_abus_e[3:0])),
							  (edp_abus_e[3] ^ (|edp_abus_e[2:0])),
							  (edp_abus_e[2] ^ (|edp_abus_e[1:0])),
							  (edp_abus_e[1] ^ (edp_abus_e[0])) }
					);
	assign dp_apipe_plus_e [0] = edp_abus_e[0];
	assign dp_cpipe_zero_e [31:0] = {32{~(mpc_prepend_e | mpc_balign_e)}} & dp_cpipe_e;
		
	/*hookup*/
	m14k_alu_shft_32bit shift_32bit_plus(
	.append_e(mpc_append_e),
	.dp_apipe_e(dp_apipe_plus_e),
	.dp_bpipe_e(dp_cpipe_e),
	.dp_bshift_e(dp_bshift_plus_e),
	.dp_cpipe_e(dp_cpipe_zero_e),
	.dp_shft_rnd_e(dp_shft_rnd_plus_e),
	.dp_shift_e(dp_shift_plus_e),
	.sh_high_index_e(mpc_dec_sh_high_index_e),
	.sh_high_sel_e(sh_high_sel_plus_e),
	.sh_low_index_4_e(mpc_dec_sh_low_index_4_e),
	.sh_low_sel_e(sh_low_sel_plus_e),
	.sh_shright_e(sh_shright_plus_e),
	.sh_subst_ctl_e(mpc_dec_sh_subst_ctl_e));
		
	assign dp_shift_merge_e[31:0] = {32{(mpc_prepend_e | mpc_balign_e) & (|edp_abus_e[4:0])}} & dp_shift_plus_e | dp_shift_e;

	assign alu_cp0_rtc_ex[8:0] = 9'b1;
	assign mfttr_minus_one_ag = 1'b0;
	assign dp_add_c31_ex = 1'b0;
	assign alu_tcid1hot_rf[8:0] = 9'b1;
	assign alu_tcid1hot_ag[8:0] = 9'b1;
	assign alu_tcid_ag[3:0] = 4'b0;
	assign alu_tcid1hot_ex[8:0] = 9'b1;
	assign alu_tcid_ex[3:0] = 4'b0;
	assign alu_tcid1hot_ms[8:0] = 9'b1;
	assign alu_tcid_ms[3:0] = 4'b0;
	assign alu_tcid1hot_er[8:0] = 9'b1;
	assign alu_tcid_er[3:0] = 4'b0;
	assign alu_cp0_rtc_ag[8:0] = 9'b1;
	assign alu_cp0_wtc_er[8:0] = 9'b1;         

	/*hookup*/
        `M14K_ALU_DSP_MODULE dsp(
	.MDU_data_ack_ms(MDU_data_ack_ms),
	.MDU_info_e(MDU_info_e),
	.MDU_ouflag_age_xx(MDU_ouflag_age_xx),
	.MDU_ouflag_extl_extr_xx(MDU_ouflag_extl_extr_xx),
	.MDU_ouflag_hilo_xx(MDU_ouflag_hilo_xx),
	.MDU_ouflag_mulq_muleq_xx(MDU_ouflag_mulq_muleq_xx),
	.MDU_ouflag_tcid_xx(MDU_ouflag_tcid_xx),
	.MDU_ouflag_vld_xx(MDU_ouflag_vld_xx),
	.MDU_pend_ouflag_wr_xx(MDU_pend_ouflag_wr_xx),
	.alu_cp0_rtc_ag(alu_cp0_rtc_ag),
	.alu_cp0_rtc_ex(alu_cp0_rtc_ex),
	.alu_cp0_wtc_er(alu_cp0_wtc_er),
	.alu_dsp_pos_r_ex(edp_dsp_pos_r_m),
	.alu_inst_valid_ag(mpc_irval_e),
	.alu_inst_valid_er(mpc_irval_w),
	.alu_inst_valid_ex(mpc_irval_e),
	.alu_inst_valid_ms(mpc_irval_m),
	.alu_inst_valid_rf(mpc_irval_e),
	.alu_nullify_ag(mpc_nullify_e),
	.alu_nullify_er(mpc_nullify_w),
	.alu_nullify_ex(mpc_nullify_e),
	.alu_nullify_ms(mpc_nullify_m),
	.alu_run_ag(mpc_run_ie),
	.alu_run_er(mpc_run_w),
	.alu_run_ex(mpc_run_ie),
	.alu_run_ms(mpc_run_m),
	.alu_run_rf(mpc_run_ie),
	.alu_stall_ex(mpc_stall_m),
	.alu_tcid1hot_ag(alu_tcid1hot_ag),
	.alu_tcid1hot_er(alu_tcid1hot_er),
	.alu_tcid1hot_ex(alu_tcid1hot_ex),
	.alu_tcid1hot_ms(alu_tcid1hot_ms),
	.alu_tcid1hot_rf(alu_tcid1hot_rf),
	.alu_tcid_ag(alu_tcid_ag),
	.alu_tcid_er(alu_tcid_er),
	.alu_tcid_ex(alu_tcid_ex),
	.alu_tcid_ms(alu_tcid_ms),
	.dec_ir_ag(mpc_ir_e),
	.dec_ir_rf(mpc_ir_e),
	.dp_add_c31_ex(dp_add_c31_ex),
	.dp_add_c32_ex(dp_add_c32_e),
	.dp_add_ex(dp_add_e),
	.dp_bshift_ex(dp_bshift_e),
	.dp_cpipe_ex(dp_cpipe_e),
	.dp_opa_sign_ex(edp_abus_e[31]),
	.dp_opb_sign_ex(dp_opb_sign_e),
	.dp_overflow_ex(dp_overflow_e),
	.dp_rs_ex(edp_abus_e),
	.dp_rt_ex(dp_bpipe_e),
	.dp_shft_rnd_ex(dp_shft_rnd_e),
	.dp_shft_rnd_plus_ex(dp_shft_rnd_plus_e),
	.dp_shift_ex(dp_shift_merge_e),
	.dp_shift_plus_ex(dp_shift_plus_e),
	.dsp_add_ag(edp_dsp_add_e),
	.dsp_alu_sat_xx(edp_dsp_alu_sat_xx),
	.dsp_carryin_ag(dsp_carryin_e),
	.dsp_data_ms(dsp_data_m),
	.dsp_dspc_ou_wren(edp_dsp_dspc_ou_wren_e),
	.dsp_dspc_pos_ag(dsp_dspc_pos_e),
	.dsp_mdu_valid_rf(edp_dsp_mdu_valid_e),
	.dsp_modsub_ag(edp_dsp_modsub_e),
	.dsp_pos_ge32_ag(edp_dsp_pos_ge32_e),
	.dsp_present_xx(edp_dsp_present_xx),
	.dsp_stallreq_ag(edp_dsp_stallreq_e),
	.dsp_sub_ag(edp_dsp_sub_e),
	.dsp_valid_rf(edp_dsp_valid_e),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.mfttr_minus_one_ag(mfttr_minus_one_ag),
	.mpc_dspinfo_e(mpc_dspinfo_e),
	.mpc_predec_e(mpc_predec_e));
        
	// the following function is to take care of simulation issue
	// - the op (1 | x) should result in  a 1 and not "x" in simulation
	function [31:0] logic_block;
		input [31:0] ctl;
		input [31:0] d1;
		input [31:0] d0;
		begin
			logic_block[0] = ctl[0] ? d1[0] : d0[0];
			logic_block[1] = ctl[1] ? d1[1] : d0[1];
			logic_block[2] = ctl[2] ? d1[2] : d0[2];
			logic_block[3] = ctl[3] ? d1[3] : d0[3];
			logic_block[4] = ctl[4] ? d1[4] : d0[4];
			logic_block[5] = ctl[5] ? d1[5] : d0[5];
			logic_block[6] = ctl[6] ? d1[6] : d0[6];
			logic_block[7] = ctl[7] ? d1[7] : d0[7];
			logic_block[8] = ctl[8] ? d1[8] : d0[8];
			logic_block[9] = ctl[9] ? d1[9] : d0[9];
			logic_block[10] = ctl[10] ? d1[10] : d0[10];
			logic_block[11] = ctl[11] ? d1[11] : d0[11];
			logic_block[12] = ctl[12] ? d1[12] : d0[12];
			logic_block[13] = ctl[13] ? d1[13] : d0[13];
			logic_block[14] = ctl[14] ? d1[14] : d0[14];
			logic_block[15] = ctl[15] ? d1[15] : d0[15];
			logic_block[16] = ctl[16] ? d1[16] : d0[16];
			logic_block[17] = ctl[17] ? d1[17] : d0[17];
			logic_block[18] = ctl[18] ? d1[18] : d0[18];
			logic_block[19] = ctl[19] ? d1[19] : d0[19];
			logic_block[20] = ctl[20] ? d1[20] : d0[20];
			logic_block[21] = ctl[21] ? d1[21] : d0[21];
			logic_block[22] = ctl[22] ? d1[22] : d0[22];
			logic_block[23] = ctl[23] ? d1[23] : d0[23];
			logic_block[24] = ctl[24] ? d1[24] : d0[24];
			logic_block[25] = ctl[25] ? d1[25] : d0[25];
			logic_block[26] = ctl[26] ? d1[26] : d0[26];
			logic_block[27] = ctl[27] ? d1[27] : d0[27];
			logic_block[28] = ctl[28] ? d1[28] : d0[28];
			logic_block[29] = ctl[29] ? d1[29] : d0[29];
			logic_block[30] = ctl[30] ? d1[30] : d0[30];
			logic_block[31] = ctl[31] ? d1[31] : d0[31];
		end

	endfunction

	// MDU/UDI data present
	assign mdu_data_valid_m_tmp = mpc_irval_m & mpc_mdu_m;
	mvp_register #(1) _mdu_data_valid_m_tmp_reg(mdu_data_valid_m_tmp_reg,gclk, ~mpc_run_m & (mdu_data_valid_m_tmp | mdu_data_valid_m_tmp_reg));


// Assertion checker

	
//verilint 528 off        // Variable set but not used
wire unused_ok;
  assign unused_ok = &{1'b0,
		dp_bshift_plus_e};
//verilint 528 on        // Variable set but not used

endmodule	// m14k_edp
