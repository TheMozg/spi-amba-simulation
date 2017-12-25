// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_cpz 
//           Coprocessor Zero System control coprocessor
//
//      $Id: \$
//      mips_repository_id: m14k_cpz.mv, v 1.194 
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

module m14k_cpz(
	gscanenable,
	edp_alu_m,
	mmu_dva_m,
	mpc_bds_m,
	siu_cpunum,
	siu_ipti,
	fdc_present,
	ej_fdc_busy_xx,
	ej_fdc_int,
	siu_ifdci,
	siu_ippci,
	cdmm_mpu_present,
	cdmm_mpu_numregion,
	cdmm_mmulock,
	siu_eicpresent,
	siu_bigend,
	biu_shutdown,
	edp_udi_present,
	mpc_busty_m,
	mpc_nmitaken,
	siu_coldreset,
	mpc_eret_m,
	mpc_eretval_e,
	biu_merging,
	icc_sp_pres,
	dcc_sp_pres,
	mpc_deret_m,
	mpc_deretval_e,
	mpc_cp0move_m,
	mpc_cp0diei_m,
	mpc_cp0sc_m,
	mpc_cp0r_m,
	mpc_cp0sr_m,
	mpc_dmsquash_m,
	icc_icoptag,
	icc_icopdata,
	dcc_dcoptag_m,
	dcc_dcopdata_m,
	icc_icopld,
	dcc_dcopld_m,
	ic_present,
	dc_present,
	ic_nsets,
	ic_ssize,
	dc_nsets,
	dc_ssize,
	ic_hci,
	dc_hci,
	mmu_type,
	mmu_size,
	mmu_icacabl,
	mpc_exc_type_w,
	mmu_r_type,
	mmu_r_size,
	icc_umipspresent,
	mpc_umipspresent,
	icc_umipsfifo_null_w,
	icc_umipsfifo_null_i,
	mpc_umipsfifosupport_i,
	mpc_isamode_i,
	mpc_excisamode_i,
	mmu_r_it_segerr,
	mmu_it_segerr,
	mpc_nonseq_e,
	mpc_cpnm_e,
	mpc_exccode,
	dexc_type,
	ejt_cbrk_type_m,
	ejt_ejtagbrk,
	mpc_exc_e,
	mpc_exc_m,
	mpc_exc_w,
	mpc_hold_hwintn,
	mpc_fixup_m,
	mpc_pexc_m,
	mpc_pexc_w,
	mpc_pexc_i,
	siu_int,
	siu_eicvector,
	siu_offset,
	siu_bootexcisamode,
	siu_srsdisable,
	siu_eiss,
	mpc_jamepc_w,
	mpc_jamerror_w,
	mpc_jamdepc_w,
	mpc_jamtlb_w,
	mpc_ldcause,
	mpc_load_m,
	mpc_wr_status_m,
	mpc_wr_intctl_m,
	mpc_ll_m,
	siu_nmi,
	mpc_pendibe,
	mpc_penddbe,
	mpc_run_i,
	mpc_run_ie,
	mpc_run_m,
	mpc_run_w,
	greset,
	mpc_squash_i,
	mpc_squash_m,
	mdu_type,
	mmu_r_tlbshutdown,
	mmu_r_transexc,
	mmu_tlbshutdown,
	mmu_transexc,
	gclk,
	gfclk,
	ejt_dcrinte,
	ejt_dcrnmie,
	mmu_r_cpyout,
	mmu_cpyout,
	edp_iva_i,
	edp_cacheiva_i,
	edp_epc_e,
	edp_eisa_e,
	mmu_r_asid,
	mmu_asid,
	mmu_vafromi,
	cp2_coppresent,
	cp1_coppresent,
	ejt_pdt_present,
	mpc_chain_take,
	mpc_hw_save_done,
	mpc_hw_load_done,
	mpc_iae_done_exc,
	edp_ldcpdata_w,
	mpc_ld_causeap,
	mpc_wr_view_ipl_m,
	mpc_atpro_w,
	mpc_atepi_w,
	mpc_iret_m,
	mpc_qual_auexc_x,
	mpc_ndauexc_x,
	mpc_first_det_int,
	mpc_buf_epc,
	mpc_buf_status,
	mpc_buf_srsctl,
	mpc_iret_ret_start,
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
	mpc_atomic_e,
	mpc_lsdc1_e,
	mpc_lsdc1_m,
	mpc_lsdc1_w,
	cp1_seen_nodmiss_m,
	siu_slip,
	dmbinvoke,
	mpc_ivaval_i,
	mmu_dcmode0,
	mpc_ll1_m,
	mpc_pm_complete,
	mpc_br_e,
	mpc_jimm_e,
	mpc_jreg31_e,
	mpc_jreg31non_e,
	mpc_alu_w,
	mpc_dec_nop_w,
	mpc_sc_e,
	mpc_sc_m,
	mpc_pref_w,
	mpc_pref_m,
	mpc_fixupi,
	mpc_fixupd,
	mpc_ldst_e,
	mpc_st_m,
	mpc_ld_m,
	mpc_pm_muldiv_e,
	mdu_result_done,
	mdu_stall,
	mdu_busy,
	bstall_ie,
	cp2_stall_e,
	brk_i_trig,
	brk_d_trig,
	mpc_cp2a_e,
	mpc_cp2tf_e,
	edp_udi_stall_m,
	mpc_stall_ie,
	mpc_stall_m,
	mpc_stall_w,
	dcc_dmiss_m,
	icc_imiss_i,
	mmu_r_itexc_i,
	mmu_r_itxiexc_i,
	mmu_r_dtexc_m,
	mmu_r_dtriexc_m,
	mmu_pm_ithit,
	mmu_pm_itmiss,
	mmu_pm_dthit,
	mmu_pm_dtmiss,
	mmu_pm_dtlb_miss_qual,
	mmu_pm_jthit_i,
	mmu_pm_jthit_d,
	mmu_pm_jtmiss_i,
	mmu_pm_jtmiss_d,
	mmu_r_pm_jthit_i,
	mmu_r_pm_jtmiss_i,
	mmu_r_pm_jthit_d,
	mmu_r_pm_jtmiss_d,
	icc_trstb,
	icc_twstb,
	icc_drstb,
	icc_stall_i,
	icc_spram_stall,
	icc_fb_vld,
	dcc_dcached_m,
	dcc_lscacheread_m,
	dcc_trstb,
	dcc_twstb,
	dcc_pm_dcmiss_pc,
	dcc_pm_dhit_m,
	dcc_stall_m,
	dcc_wb,
	dcc_dspram_stall,
	dcc_pm_fb_active,
	dcc_pm_fbfull,
	biu_pm_wr_buf_b,
	biu_pm_wr_buf_f,
	biu_wtbf,
	icc_icopstall,
	dcc_dcop_stall,
	dcc_uncache_load,
	dcc_uncached_store,
	cpz_bev,
	cpz_cp0read_m,
	cpz_copusable,
	cpz_cee,
	cpz_hotdm_i,
	EJ_DebugM,
	cpz_dm_m,
	cpz_dm_w,
	cpz_eretpc,
	cpz_eretisa,
	cpz_erl,
	cpz_erl_e,
	cpz_nmi,
	cpz_exl,
	cpz_hotexl,
	cpz_nest_exl,
	cpz_nest_erl,
	cpz_mnan,
	cpz_prid16,
	cpz_um,
	cpz_um_vld,
	cpz_goodnight,
	cpz_iexi,
	cpz_hotiexi,
	cpz_int_e,
	cpz_int_mw,
	cpz_iv,
	cpz_hwrena,
	cpz_hwrena_29,
	cpz_g_hwrena,
	cpz_g_hwrena_29,
	cpz_ebase,
	cpz_cdmmbase,
	cpz_cdmm_enable,
	cpz_vectoroffset,
	cpz_srsctl_pss2css_m,
	cpz_srsctl_css,
	cpz_srsctl_pss,
	cpz_hoterl,
	cpz_k0cca,
	cpz_k23cca,
	cpz_kucca,
	cpz_kuc_i,
	cpz_kuc_e,
	cpz_kuc_m,
	cpz_kuc_w,
	cpz_llbit,
	cpz_nmi_e,
	cpz_nmi_mw,
	cpz_rbigend_e,
	cpz_rbigend_i,
	cpz_excisamode,
	cpz_bootisamode,
	cpz_debugmode_i,
	cpz_rp,
	cpz_setibep,
	cpz_setdbep,
	cpz_taglo,
	cpz_datalo,
	cpz_spram,
	cpz_wst,
	cpz_lsnm,
	cpz_smallpage,
	cpz_timerint,
	cpz_fdcint,
	cpz_swint,
	cpz_ipl,
	cpz_ivn,
	cpz_ion,
	cpz_cause_pci,
	cpz_iack,
	cpz_iwatchhit,
	cpz_dwatchhit,
	cpz_wpexc_m,
	cpz_dm,
	cpz_enm,
	cpz_nmipend,
	cpz_doze,
	cpz_halt,
	cpz_sst,
	cpz_epc_w,
	cpz_bds_x,
	cpz_eisa_w,
	cpz_icpresent,
	cpz_dcpresent,
	cpz_isppresent,
	cpz_dsppresent,
	cpz_icnsets,
	cpz_icssize,
	cpz_dcnsets,
	cpz_dcssize,
	cpz_mbtag,
	cpz_g_mmusize,
	cpz_config_ld,
	cpz_mmutype,
	cpz_mmusize,
	cpz_rslip_e,
	cpz_rclen,
	cpz_rclval,
	cpz_scramblecfg_write,
	cpz_scramblecfg_sel,
	cpz_scramblecfg_data,
	antitamper_present,
	cpz_srsctl,
	cpz_status,
	cpz_ext_int,
	cpz_epc_rd_data,
	cpz_pf,
	cpz_takeint,
	cpz_at_pro_start_i,
	cpz_at_epi_en,
	cpz_at_pro_start_val,
	cpz_stkdec,
	cpz_iret_m,
	cpz_iret_ret,
	cpz_eret_m,
	cpz_ice,
	cpz_int_pend_ed,
	cpz_iretpc,
	cpz_usekstk,
	cpz_causeap,
	cpz_int_enable,
	cpz_iret_chain_reg,
	cpz_iap_um,
	cpz_int_excl_ie_e,
	cpz_g_llbit,
	cpz_iap_exce_handler_trace,
	cpz_mx,
	cpz_fr,
	pdtrace_cpzout,
	dcc_dvastrobe,
	mpc_atomic_m,
	mpc_pdstrobe_w,
	mpc_strobe_e,
	mpc_strobe_m,
	mpc_strobe_w,
	mpc_ltu_e,
	mpc_mcp0stall_e,
	mpc_bubble_e,
	edp_dsp_alu_sat_xx,
	MDU_count_sat_xx,
	MDU_count_sat_tcid_xx,
	edp_dsp_present_xx,
	dcc_dcoppar_m,
	icc_icoppar,
	icc_parerr_i,
	icc_parerr_cpz_w,
	dcc_parerr_data,
	icc_parerr_data,
	icc_parerr_tag,
	dcc_parerr_m,
	dcc_parerr_cpz_w,
	dcc_parerr_tag,
	dcc_parerr_ws,
	dcc_derr_way,
	icc_derr_way,
	dsp_data_parerr,
	isp_data_parerr,
	dcc_parerr_ev,
	dcc_parerr_idx,
	icc_parerr_idx,
	ica_parity_present,
	dca_parity_present,
	qual_iparerr_w,
	qual_iparerr_i,
	mpc_atomic_impr,
	cpz_po,
	cpz_pd,
	cpz_pi,
	cpz_pe,
	cpz_gm_p,
	cpz_gm_i,
	cpz_gm_e,
	cpz_gm_m,
	cpz_gm_w,
	cpz_vz,
	cpz_gid,
	cpz_rid,
	cpz_guestid,
	cpz_guestid_i,
	cpz_guestid_m,
	cpz_ghfc_i,
	cpz_ghfc_w,
	cpz_gsfc_m,
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
	cpz_g_at_epi_en,
	cpz_g_erl,
	cpz_g_at_pro_start_i,
	cpz_g_at_pro_start_val,
	cpz_g_hss,
	cpz_g_mmutype,
	cpz_g_copusable,
	cpz_g_cee,
	cpz_g_usekstk,
	cpz_g_stkdec,
	cpz_g_int_pend_ed,
	cpz_g_ice,
	cpz_g_int_enable,
	cpz_g_vectoroffset,
	cpz_g_iretpc,
	cpz_g_rbigend_e,
	cpz_g_rbigend_i,
	cpz_g_epc_rd_data,
	cpz_g_status,
	cpz_g_srsctl,
	cpz_g_erl_e,
	cpz_g_srsctl_css,
	cpz_g_srsctl_pss,
	cpz_g_int_excl_ie_e,
	cpz_g_eretisa,
	cpz_g_causeap,
	cpz_g_config_ld,
	cpz_g_smallpage,
	cpz_g_ebase,
	cpz_ri,
	cpz_cp0,
	cpz_at,
	cpz_gt,
	cpz_cg,
	cpz_cf,
	cpz_drg,
	cpz_g_k0cca,
	cpz_g_k23cca,
	cpz_g_kucca,
	cpz_g_swint,
	cpz_g_ipl,
	cpz_g_ivn,
	cpz_g_ion,
	cpz_g_iack,
	cpz_cgi,
	cpz_og,
	cpz_bg,
	cpz_mg,
	cpz_g_hotexl,
	cpz_g_exl,
	cpz_g_hoterl,
	cpz_g_kuc_i,
	cpz_g_kuc_e,
	cpz_g_kuc_m,
	cpz_g_kuc_w,
	cpz_g_cause_pci,
	cpz_g_timerint,
	cpz_g_um,
	cpz_g_um_vld,
	cpz_g_ulri,
	cpz_g_srsctl_pss2css_m,
	cpz_drgmode_i,
	cpz_drgmode_m,
	cpz_g_pc_present,
	cpz_pc_ctl0_ec1,
	cpz_pc_ctl1_ec1,
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
	pc0_ctl_ec1,
	pc1_ctl_ec1,
	cpz_g_iret_m,
	mpc_g_cp0move_m,
	mpc_wr_guestctl0_m,
	mpc_wr_guestctl2_m,
	mpc_g_auexc_x,
	mpc_r_auexc_x,
	mpc_r_auexc_x_qual,
	mpc_g_auexc_x_qual,
	mmu_gid,
	mmu_rid,
	mmu_r_read_m,
	mmu_read_m,
	mpc_gexccode,
	mpc_g_ldcause,
	mpc_g_jamepc_w,
	mpc_g_jamtlb_w,
	mpc_g_int_pf,
	mpc_g_ld_causeap,
	mpc_badins_type,
	mpc_ge_exc,
	mpc_ir_e,
	mpc_auexc_on,
	mpc_iret_ret,
	mpc_chain_vec,
	siu_eicgid,
	siu_g_eiss,
	siu_g_int,
	siu_g_eicvector,
	siu_g_offset,
	mmu_vat_hi,
	icc_umips_instn_i,
	mpc_isamode_e,
	mpc_gpsi_perfcnt,
	cp1_ufrp,
	mpc_ctc1_fr0_m,
	mpc_ctc1_fr1_m,
	mpc_cfc1_fr_m,
	mpc_rdhwr_m,
	mpc_hw_save_srsctl_i);


/*hookios*//* IO declarations added by hookup */
/* End of hookup IO declarations */
/* Wire declarations added by hookup */
wire cpz_g_iap_um;
wire cpz_g_rp;
wire fcd;
wire [31:0] g_badva;
wire [6:0] g_cause_s;
wire g_eic_mode;
wire gripl_clr;
wire [31:0] gtoffset;
wire [31:0] guestctl0_32;
wire guestctl0_mc;
wire [31:0] guestctl0ext_32;
wire [31:0] guestctl1_32;
wire [31:0] guestctl2_eic;
wire [31:0] guestctl2_noneic;
wire [31:0] guestctl3_32;
wire [7:0] hc_vip;
wire [7:0] hc_vip_e;
wire hot_drg;
wire hot_wr_guestctl0;
wire hot_wr_guestctl2_noneic;
wire mpc_tlb_d_side;
wire mpc_tlb_i_side;
wire [31:0] r_gtoffset;
wire [7:0] r_pip;
wire [7:0] r_pip_e;
wire sfc1;
wire sfc2;
wire [7:0] vip;
wire [7:0] vip_e;
/* End of hookup wire declarations */


	/* Inputs */
        input           gscanenable;        // Scan Enable
	input [31:0]	edp_alu_m;	    // ALU result bus -> cpz write data
	input [31:0]	mmu_dva_m;	    
	input		mpc_bds_m;          // The M-stage instn has a branch delay slot
	input [9:0]	siu_cpunum;		// EBase CPU number
	input [2:0]	siu_ipti;		// TimerInt connection
	input 		fdc_present;		// FDC is implemented
	input           ej_fdc_busy_xx;          // Wakeup to transfer fast debug channel data
	input		ej_fdc_int;		// Int req from fdc
	input [2:0]     siu_ifdci;		// FDCInt connection
	input [2:0]	siu_ippci;		// PCInt connection
	input		cdmm_mpu_present;		// MPU is implemented
	input [3:0]	cdmm_mpu_numregion;		// number of MPU regions implemented
	input		cdmm_mmulock;
	input		siu_eicpresent;		// External Interrupt cpntroller present
	input		siu_bigend;	    // Number bytes starting from the big end of the word
	input 		biu_shutdown;       // Wait instn executed & No transactions outstanding on bus
	input 		edp_udi_present;    // UDI block is implemented
	input [2:0]	mpc_busty_m;        // Transaction type
	input 		mpc_nmitaken;       // nmi was taken
	input		siu_coldreset;      // Cold reset
	input		mpc_eret_m;	    // ERET instruction
        input           mpc_eretval_e;      // ERet instn valid
	input 		biu_merging;        // Merging algorithm
	input 		icc_sp_pres;        // ISPRAM is present
	input 		dcc_sp_pres;        // DSPRAM is present
	input		mpc_deret_m;	    // DERET instruction
	input		mpc_deretval_e;	    // DERET instruction
	input		mpc_cp0move_m;	    // MT/F C0
	input		mpc_cp0diei_m;	    // DI/EI
	input		mpc_cp0sc_m;	    // set/clear bit in C0
	input [4:0]	mpc_cp0r_m;	    // coprocessor zero register specifier
	input [2:0]	mpc_cp0sr_m;	    // coprocessor zero shadow register specifier
        input 		mpc_dmsquash_m;     // Exc_M without translation exceptions or interrupts
	input [25:0]	icc_icoptag;	    // Cacheop ld_tag- tag
	input [31:0]	icc_icopdata;	    // Cacheop ld_tag- data
	input [25:0]	dcc_dcoptag_m;	    // Cacheop ld_tag- tag
	input [31:0]	dcc_dcopdata_m;	    // Cacheop ld_tag- data
	input		icc_icopld;	    // Cacheop ld strobe
	input		dcc_dcopld_m;	    // Cacheop ld strobe
        input 		ic_present;         // I$ is present
        input 		dc_present;         // D$ is present
   	input [2:0]	ic_nsets;	    // Number of sets   - static
	input [1:0]	ic_ssize;	    // I$ associativity - static
	input [2:0]	dc_nsets;	    // Number of sets   - static
	input [1:0]	dc_ssize;	    // D$ associativity - static
        input 		ic_hci;             // I$ Hardware Cache Init
        input 		dc_hci;             // D$ Hardware Cache Init
	input		mmu_type;	    // MMU type: 1->BAT, 0->TLB - Static
	input	[1:0]	mmu_size;	    // MMU size: 0->16, 1->16 - Static
	input		mmu_icacabl;	    // i$ CCA
	input           mpc_exc_type_w;
	input		mmu_r_type;	    // MMU type: 1->BAT, 0->TLB - Static
	input	[1:0]	mmu_r_size;	    // MMU size: 0->16, 1->16 - Static
	input 		icc_umipspresent;     // UMIPS implemented
	input		mpc_umipspresent;	// native UMIPS implemented
	input		icc_umipsfifo_null_w;	// instn slip propagated to w-stage
	input		icc_umipsfifo_null_i;	// instn slip at i stage
	input		mpc_umipsfifosupport_i; // Indicates fifo is ready and we do not stall on i-cache miss. not available in umips recoder
        input           mpc_isamode_i;      // current isa mode
	input		mpc_excisamode_i;   // isa mode change w/o isa
	input		mmu_r_it_segerr;
	input		mmu_it_segerr;
	input		mpc_nonseq_e;

	input [1:0]	mpc_cpnm_e;	    // coprocessor unit number
	input [4:0]	mpc_exccode;	    // cause PLA to encode exceptions into a 5 bit field
	input [2:0] 	dexc_type;          // debug Exception Type
	input [6:0]	ejt_cbrk_type_m;    // Complex break exception type
	input 		ejt_ejtagbrk;       // EJTAG Break (DINT)
	input		mpc_exc_e;	    // Exception killed E-stage 
	input		mpc_exc_m;	    // Exception killed M-stage 
	input		mpc_exc_w;	    // Exception killed W-stage
	input		mpc_hold_hwintn;	// Hold hwint pins until exception taken
	input 		mpc_fixup_m;        // D$ miss previous cycle
	input		mpc_pexc_m;         // Prior Exception killed M-stage
	input		mpc_pexc_w;         // Prior Exception killed W-stage
	input		mpc_pexc_i;         // Prior Exception killed I-stage
	input [7:0]	siu_int;            // external interrupt inputs to cause

	input [5:0]	siu_eicvector;	    // Vector number to use for EIC interrupt
	input [17:1]	siu_offset;	    // Vector offset to use for EIC interrupt
	input           siu_bootexcisamode;
	input [3:0]     siu_srsdisable;      // Disable some shadow sets
	input [3:0]	siu_eiss;	    // Shadow set to use for EIC interrupt
	input		mpc_jamepc_w;	    // load epc register from epc timing chain
	input		mpc_jamerror_w;	    // load ErrorPC register from epc timing chain
	input		mpc_jamdepc_w;	    // load debug epc register from epc timing chain
	input		mpc_jamtlb_w;	    // load Translation exception registers
	input		mpc_ldcause;	    // load cause register for exception
	input		mpc_load_m;	    // xfer direction for load/store/cpmv - 0:=to proc; 1:=from proc
	input		mpc_wr_status_m;
	input		mpc_wr_intctl_m;
	input		mpc_ll_m;	    // Load linked in M
	input		siu_nmi;            // Non-maskable interrupt
	input 		mpc_pendibe;        // ibe Pending
	input 		mpc_penddbe;        // dbe Pending
	input		mpc_run_i;          // I-stage Run - for exceptions only
	input		mpc_run_ie;         // I/E-stage Run
	input		mpc_run_m;	    // M-stage Run
	input		mpc_run_w;	    // W-stage Run
	input		greset;		    // Power on and reset for chip
	input		mpc_squash_i;	    // Squash the instn in I-stage 
	input		mpc_squash_m;	    // M-stage instn was squashed
	input		mdu_type;	    // MDU type: 1->Lite, 0->Full - Static
	input		mmu_r_tlbshutdown;    // conflict detected on TLB write
	input 		mmu_r_transexc;       // Translation exception detected
	input		mmu_tlbshutdown;    // conflict detected on TLB write
	input 		mmu_transexc;       // Translation exception detected
	input		gclk;		    // Clock
	input		gfclk;		    // Free running clock
	input		ejt_dcrinte;        // EJTAG interrupt enable
	input 		ejt_dcrnmie;        // EJTAG non-maskable interrupt enable
	input [31:0] 	mmu_r_cpyout;         // Read bus for CPY registers
	input [31:0] 	mmu_cpyout;         // Read bus for CPY registers
	input [31:0] 	edp_iva_i;          // Instruction Virtual Address - I-stage
	input [31:0]	edp_cacheiva_i;	    // cache iva
	input [31:0] 	edp_epc_e;          // Exception PC - E-stage
	input 		edp_eisa_e;         // Exception ISA mode - E-stage
	input [`M14K_ASID] mmu_r_asid;         // Address Space Identifier
	input [`M14K_ASID] mmu_asid;         // Address Space Identifier
	input 		   mmu_vafromi;     // Select IVA for BadVA
	input 	 	cp2_coppresent;	    // COP 2 is present on the interface.
	input 	 	cp1_coppresent;	    // COP 1 is present on the interface.
	input [1:0] 	ejt_pdt_present;    // PDTrace module is implemented. 01 : PDT/TCB, 10 : IPDT/ITCB

	input           mpc_chain_take;        //tail chain happened
        input           mpc_hw_save_done;      //HW save operation done
        input           mpc_hw_load_done;      //HW load operation done
	input           mpc_iae_done_exc;      //HW load done due to exception
        input [31:0]    edp_ldcpdata_w;        //Load data for HW auto epilogue
        input           mpc_ld_causeap;        //load Cause.AP when detect exception during auto prologue
        input           mpc_wr_view_ipl_m;     //write view_ipl register
        input           mpc_atpro_w;           //auto-prologue in W-stage
        input           mpc_atepi_w;           //auto-epilogue in W-stage
        input           mpc_iret_m;            //M-stage IRET instruction
        input           mpc_qual_auexc_x;      //final cycle of mpc_auexc_x
	input 		mpc_ndauexc_x;	       // performance counter signal. not-debug-mode exception
        input           mpc_first_det_int;     //first cycle interrupt detected
        input  [31:0]   mpc_buf_epc;           //EPC saved to stack during HW sequence
        input  [31:0]   mpc_buf_status;        //Status saved to stack during HW sequence
        input  [31:0]   mpc_buf_srsctl;        //SRSCTL saved to stack during HW sequence
	input           mpc_iret_ret_start;    //start cycle of mpc_iret_ret
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
	input		mpc_atomic_e;
	input		mpc_lsdc1_e;
	input		mpc_lsdc1_m;
	input		mpc_lsdc1_w;
	input 	 	cp1_seen_nodmiss_m;

	input		siu_slip;	// External signal to inject security slips

	input		dmbinvoke;      // Invoke D Memory BIST
	input 		mpc_ivaval_i;       // I-stage IVA is valid
	input		mmu_dcmode0;
	input		mpc_ll1_m;		// Load linked in first clock of M
	input		mpc_pm_complete;      // IR is valid
	input		mpc_br_e;
	input		mpc_jimm_e;
	input		mpc_jreg31_e;
	input		mpc_jreg31non_e;
	input		mpc_alu_w;
	input		mpc_dec_nop_w;
	input		mpc_sc_e;
	input		mpc_sc_m;
	input		mpc_pref_w;
	input		mpc_pref_m;
	input		mpc_fixupi;
	input		mpc_fixupd;
	input		mpc_ldst_e;
	input		mpc_st_m;
	input		mpc_ld_m; 	
	input		mpc_pm_muldiv_e;	      // Multiply/Divide (excludes mflo and xf2 instns)
	input		mdu_result_done;
	input		mdu_stall;
	input		mdu_busy;	//for performance counter
	input 		bstall_ie;	//for performance counter
	input		cp2_stall_e;
	input[7:0]	brk_i_trig;
	input[3:0]	brk_d_trig;
	input		mpc_cp2a_e;
	input		mpc_cp2tf_e;
	input		edp_udi_stall_m;
	input		mpc_stall_ie;
	input		mpc_stall_m;
	input		mpc_stall_w;
	input 		dcc_dmiss_m;
	input		icc_imiss_i;
	input mmu_r_itexc_i;
        input mmu_r_itxiexc_i;
        input mmu_r_dtexc_m;
        input mmu_r_dtriexc_m;
	input mmu_pm_ithit;
	input mmu_pm_itmiss;
	input mmu_pm_dthit;
	input mmu_pm_dtmiss;
	input mmu_pm_dtlb_miss_qual;
	input mmu_pm_jthit_i; 
	input mmu_pm_jthit_d; 
	input mmu_pm_jtmiss_i; 
	input mmu_pm_jtmiss_d; 
	input mmu_r_pm_jthit_i;
	input mmu_r_pm_jtmiss_i;
	input mmu_r_pm_jthit_d;
	input mmu_r_pm_jtmiss_d;
//	input mmu_r_pm_dtlb_miss_qual;
//	input mmu_r_pm_jthit;
//	input mmu_r_pm_jtmiss;
	input icc_trstb;
	input icc_twstb;
	input icc_drstb;
	input icc_stall_i;
	input icc_spram_stall;
	input [3:0] icc_fb_vld;
	
	input		dcc_dcached_m;
	input		dcc_lscacheread_m;    // cacheread includes tag/data/way
	input		dcc_trstb;
	input		dcc_twstb;
	input		dcc_pm_dcmiss_pc;
	input		dcc_pm_dhit_m;	    // pm data ref. hit
	input		dcc_stall_m;
	input		dcc_wb;
	input		dcc_dspram_stall;
	input		dcc_pm_fb_active;
	input		dcc_pm_fbfull;
	input		biu_pm_wr_buf_b;// used by performance counter to trace wbb status
	input		biu_pm_wr_buf_f;// used by performance counter to trace wbb status
	input		biu_wtbf;
	input		icc_icopstall;
	input		dcc_dcop_stall;
	input		dcc_uncache_load;
	input		dcc_uncached_store;



	/* Outputs */
	output		cpz_bev;		// Bootstrap exception vectors
	output [31:0]	cpz_cp0read_m;   // Read data for MFC0 & SC register updates
	output [3:0]	cpz_copusable;		// coprocessor usable bits
	output		cpz_cee;	// corextend enable
	output		cpz_hotdm_i;	// A debug Exception has been taken
	output		EJ_DebugM;	// A debug Exception has been taken
	output		cpz_dm_m;	// A debug Exception has been taken
	output		cpz_dm_w;	// A debug Exception has been taken
	output [31:0]	cpz_eretpc;		// Target PC for ERET or DERET (epc or ErrorPC or depc)
	output 		cpz_eretisa;	// Target ISA for ERET or DERET (from epc or ErrorPC or depc)
	output		cpz_erl;		// cpz_erl bit from status
	output 		cpz_erl_e;
	output		cpz_nmi;	// NMI from status register
	output		cpz_exl;		// cpz_exl bit from status
	output		cpz_hotexl;		// cpz_exl bit from status
	output		cpz_nest_exl;
	output		cpz_nest_erl;
	output          cpz_mnan;
	output	[15:0]	cpz_prid16;
	output		cpz_um; 		// cpz_um bit from status
	output		cpz_um_vld; 		// cpz_um bit from status is valid
	output 		cpz_goodnight;
	output 		cpz_iexi;           // cpz_iexi bit from debug
	output 		cpz_hotiexi;        // Hot version of cpz_iexi bit from debug
	output		cpz_int_e;	// external, software, and non-maskable interrupts
	output		cpz_int_mw;	        // external, software, and non-maskable interrupts
	output		cpz_iv;		// cpz_iv bit from cause
	output [3:0]	cpz_hwrena;	// HWRENA CP0 register
	output   	cpz_hwrena_29;	// Bit 29 of HWRENA CP0 register
	output [3:0]	cpz_g_hwrena;	// HWRENA CP0 register
	output   	cpz_g_hwrena_29;	// Bit 29 of HWRENA CP0 register
	output [31:12]	cpz_ebase;	// Exception base
	output [31:15]   cpz_cdmmbase;   // CDMM base
	output		cpz_cdmm_enable;
	output [17:1]	cpz_vectoroffset;	// Interrupt vector offset
	output		cpz_srsctl_pss2css_m;	// Copy PSS back to CSS on eret
	output [3:0]	cpz_srsctl_css;		// Current SRS
	output [3:0]	cpz_srsctl_pss;		// Previous SRS
	output		cpz_hoterl;         // Early version of cpz_erl
        output [2:0]    cpz_k0cca;      // kseg0 cache attributes
        output [2:0]    cpz_k23cca;     // kseg2/3 cache attributes
        output [2:0]    cpz_kucca;      // kuseg cache attributes
   	output		cpz_kuc_i;		// Kernel/user bit - 0:=>kernel; 1:=>user
	output		cpz_kuc_e;		// Kernel/user bit - 0:=>kernel; 1:=>user
	output		cpz_kuc_m;		// Kernel/user bit - 0:=>kernel; 1:=>user
	output		cpz_kuc_w;		// Kernel/user bit - 0:=>kernel; 1:=>user
	output		cpz_llbit;          // Load linked bit - enables SC
	output		cpz_nmi_e;          // Interrupt is really an nmi
	output		cpz_nmi_mw;         // Interrupt is really an nmi
	output		cpz_rbigend_e;	// reverse Endianess from state of bigend mode bit in user mode
	output		cpz_rbigend_i;	// reverse Endianess from state of bigend mode bit in user mode
        output          cpz_excisamode; // isamode for exception
        output          cpz_bootisamode; // isamode for boot
	output		cpz_debugmode_i;

	output 		cpz_rp;             // Reduce Power bit from status register
	output 		cpz_setibep;      // Set ibe Pending
	output 		cpz_setdbep;      // Set dbe Pending

	output [25:0]	cpz_taglo;		// Tag for cacheops
	output [31:0]	cpz_datalo;		// Data for cacheops
        output 		cpz_spram;         // write to SPRAM on indxed cacheops
        output 		cpz_wst;         // write to WS RAM on cacheop store
	output		cpz_lsnm;		// Load/Store Normal Memory from DEBUG
	output		cpz_smallpage;		// Small (1KB) page support
	output		cpz_timerint; // count==compare interrupt
	output		cpz_fdcint;   // FDC receive FIFO full
	output [1:0]	cpz_swint;	// Software interrupt requests to external interrupt controller
        output [7:0]    cpz_ipl;        // Current IPL, contains information of which int SI_IACK ack.
        output [5:0]    cpz_ivn;        // Current IVN, contains information of which int SI_IACK ack.
        output [17:1]    cpz_ion;        // Current ION, contains information of which int SI_IACK ack.
	output		cpz_cause_pci;

	output		cpz_iack;	// interrupt acknowledge
	output		cpz_iwatchhit;	// instruction Watch comparison matched
	output		cpz_dwatchhit;	// data Watch comparison matched
	output 		cpz_wpexc_m;        // Deferred watch exception
	output		cpz_dm;		// Copy of cpz_dm bit from DEBUG reg.
	output		cpz_enm;		// BE bit, (Big-Endian Memory)
	output 		cpz_nmipend;  // Signal that an nmi is pending
	output 		cpz_doze;        // Processor is in low-power mode
	output 		cpz_halt;        // Processor clocks are stopped
	output		cpz_sst;		// Enable Single-Step Mode
	output [31:0]	cpz_epc_w;	// Address of inst in W
	output 		cpz_bds_x; 	// Current value on cpz_epc_w is from previous inst
	output 		cpz_eisa_w;	// ISA mode of inst in W (1=UMIPS, 0=MIPS32)
        output 		cpz_icpresent; // I$ is present  - from config1
        output 		cpz_dcpresent; // D$ is present  - from config1
        output 		cpz_isppresent; // I SPRAM is present  - from config0
        output 		cpz_dsppresent; // D SPRAM is present  - from config0
   	output [2:0]	cpz_icnsets;	// Number of sets   - from config1
	output [1:0]	cpz_icssize;	// I$ associativity - from config1
	output [2:0]	cpz_dcnsets;	// Number of sets   - from config1
	output [1:0]	cpz_dcssize;	// D$ associativity - from config1
	output [1:0]	cpz_mbtag;	  // BIST read TAG Data
	output 	[1:0]	cpz_g_mmusize;       // mmu_size from config
	output		cpz_config_ld;
	output 		cpz_mmutype;       // mmu_r_type from config
	output 	[1:0]	cpz_mmusize;       // mmu_r_size from config


	output		cpz_rslip_e;		// Random slip
	output		cpz_rclen;		// Random cache line refill order enable
	output [1:0]	cpz_rclval;		// Random value for RCL
	output 		cpz_scramblecfg_write;	// Scramble configuration write strobe
	output [7:0]	cpz_scramblecfg_sel;	// Scramble configuration H/L
	output [31:0]	cpz_scramblecfg_data;	// Scramble configuration data
	output antitamper_present;
	
	output [31:0]   cpz_srsctl;             //SRSCTL data for HW entry sequence
        output [31:0]   cpz_status;             //Status data for HW sequence
        output          cpz_ext_int;            //external interrupt
        output [31:0]   cpz_epc_rd_data;        //EPC data for HW saving operation
        output          cpz_pf;                 //speculative prefetch enable
        output          cpz_takeint;            //interrupt recognized finally
        output          cpz_at_pro_start_i;     //start cycle of HW auto prologue
        output          cpz_at_epi_en;     	//enable iae
        output          cpz_at_pro_start_val;   //valid start of HW auto prologue
        output [4:0]    cpz_stkdec;             //number of words for the decremented value of sp
        output          cpz_iret_m;             //active version of M-stage IRET instn
	output		cpz_iret_ret;		//active iret for writing registers
	output		cpz_eret_m;		//active eret for writing registers (m stage)
        output          cpz_ice;                //enable tail chain
        output [7:0]    cpz_int_pend_ed;        //pending iterrupt
        output [31:0]   cpz_iretpc;             //return to the original epc on IRET if tail chain not happen
	output          cpz_usekstk;            //Use kernel stack during IAP
	output          cpz_causeap;            //exception happened during auto-prologue
	output          cpz_int_enable;         //interrupt enable
	output		cpz_iret_chain_reg;     //reg version of iret_tailchain 
	output		cpz_iap_um; 	        //user mode when iap
	output		cpz_int_excl_ie_e;
	output		cpz_g_llbit;          // Load linked bit - enables SC

	output		        cpz_iap_exce_handler_trace;	// Instruction is under exception processing of IAP	

	output		        cpz_mx;	
	output		        cpz_fr;	
	
	input [`M14K_BUS]	pdtrace_cpzout;         // Read data for MFC0 register updates
    	input	  		dcc_dvastrobe;      	// Data Virtual Address strobe for WATCH
	input			mpc_atomic_m;		// Atomic instruction entered into M stage for load
	input			mpc_pdstrobe_w;         // Instn Valid in W
	input			mpc_strobe_e;
	input			mpc_strobe_m;
	input			mpc_strobe_w;
	input			mpc_ltu_e;		// stall due to load-to-use. (for loads only)
	input			mpc_mcp0stall_e;	// stall due to cp0 return data.
	input			mpc_bubble_e;	  // stalls e-stage due to arithmetic/deadlock/return data reasons


	input			edp_dsp_alu_sat_xx;
	input			MDU_count_sat_xx;
	input	[3:0]		MDU_count_sat_tcid_xx;
	input			edp_dsp_present_xx;

	// Parity related interfaces
        input   [3:0]   dcc_dcoppar_m;  //PD
        input   [3:0]   icc_icoppar;    //PI
        input           icc_parerr_i;   // parity error detected on I$ at I stage
        input           icc_parerr_cpz_w;   // parity error detected on I$ at W stage
        input           dcc_parerr_data; // parity error detected on data array of D$
        input           icc_parerr_data; // parity error detected on data array of I$
        input           icc_parerr_tag; // parity error detected on tag array of I$
        input           dcc_parerr_m;       // parity error detected at M stage
        input           dcc_parerr_cpz_w;       // parity error detected at W stage
        input           dcc_parerr_tag;     // parity error detected at tag ram
        input           dcc_parerr_ws;      // parity error detected at WS ram
        input   [1:0]   dcc_derr_way;   // indicate which way detected parity error
        input   [1:0]   icc_derr_way;   // indicate which way detected parity error
	input		dsp_data_parerr;   // parity error detected on DSPRAM
	input		isp_data_parerr;   // parity error detected on ISPRAM
	input		dcc_parerr_ev;	   // parity error detected on eviction
	
	input	[19:0]	dcc_parerr_idx;	
	input	[19:0]	icc_parerr_idx;	

	input		ica_parity_present;	// I$ supports parity
	input		dca_parity_present;	// D$ supports parity

	input		qual_iparerr_w;		// Qualified I$ parity exception
	input		qual_iparerr_i;		// Qualified I$ parity exception

  	input          mpc_atomic_impr;         //atomic lead imprecise data breakpoint
        output          cpz_po;                 //parity overwrite bit 
        output [3:0]    cpz_pd;                 //parity bits of D$ data array 
        output [3:0]    cpz_pi;                 //parity bits of I$ data array 

        output          cpz_pe;                 //parity enable bit 

        output          cpz_gm_p;
        output          cpz_gm_i;
        output          cpz_gm_e;
        output          cpz_gm_m;
        output          cpz_gm_w;
        output          cpz_vz;
	output [`M14K_GID] 	cpz_gid;
	output [`M14K_GID] 	cpz_rid;
	output [7:0] 	cpz_guestid;
	output [7:0] 	cpz_guestid_i;
	output [7:0] 	cpz_guestid_m;
	output		cpz_ghfc_i;	
	output		cpz_ghfc_w;	
	output		cpz_gsfc_m;	
	output		cpz_g_mx;	
	output		cpz_g_dwatchhit;	// data Watch comparison matched
        output          cpz_g_takeint;            //interrupt recognized finally
	output		cpz_g_iwatchhit;	// instruction Watch comparison matched
	output		cpz_g_int_e;	// external, software, and non-maskable interrupts
	output 		cpz_g_int_mw;                   // Interrupt in M/W stage
	output 		cpz_g_wpexc_m;        // Deferred watch exception
	output		cpz_g_iv;		// cpz_g_iv bit from cause
        output          cpz_g_ext_int;            //external interrupt
        output          cpz_g_pf;                 //speculative prefetch enable
	output		cpz_g_bev;		// Bootstrap exception vectors
        output          cpz_g_excisamode; // isamode for exception
        output          cpz_g_bootisamode; // isamode for boot
        output          cpz_g_at_epi_en;     	//enable iae
	output		cpz_g_erl;
        output          cpz_g_at_pro_start_i;
        output          cpz_g_at_pro_start_val;
	output [3:0]    cpz_g_hss;
	output		cpz_g_mmutype;
	output [3:0]	cpz_g_copusable;		// coprocessor usable bits
        output		cpz_g_cee;	// corextend enable
	output          cpz_g_usekstk;            //Use kernel stack during IAP
        output [4:0]    cpz_g_stkdec;             //number of words for the decremented value of sp
        output [7:0]    cpz_g_int_pend_ed;        //pending iterrupt
        output          cpz_g_ice;                //enable tail chain
	output          cpz_g_int_enable;         //interrupt enable
	output [17:1]	cpz_g_vectoroffset;	// Interrupt vector offset
        output [31:0]   cpz_g_iretpc;             //return to the original epc on IRET if tail chain not happen
	output		cpz_g_rbigend_e;	// reverse Endianess from state of bigend mode bit in user mode
	output		cpz_g_rbigend_i;	// reverse Endianess from state of bigend mode bit in user mode
        output [31:0]   cpz_g_epc_rd_data;        //EPC data for HW saving operation
        output [31:0]   cpz_g_status;             //Status data for HW sequence
	output [31:0]   cpz_g_srsctl;             //SRSCTL data for HW entry sequence
        output 		cpz_g_erl_e;
	output [3:0]	cpz_g_srsctl_css;		// Current SRS
	output [3:0]	cpz_g_srsctl_pss;		// Previous SRS
	output		cpz_g_int_excl_ie_e;	
	output 		cpz_g_eretisa;	// Target ISA for ERET or DERET (from epc or ErrorPC or depc)
	output          cpz_g_causeap;            //exception happened during auto-prologue
	output		cpz_g_config_ld;
	output		cpz_g_smallpage;		// Small (1KB) page support
	output [31:12]	cpz_g_ebase;	// Exception base
	output		cpz_ri;
	output		cpz_cp0;
	output	[1:0]	cpz_at;
	output		cpz_gt;
	output		cpz_cg;
	output		cpz_cf;
	output		cpz_drg;
        output [2:0]    cpz_g_k0cca;      // kseg0 cache attributes
        output [2:0]    cpz_g_k23cca;     // kseg2/3 cache attributes
        output [2:0]    cpz_g_kucca;      // kuseg cache attributes
	output [1:0]	cpz_g_swint;	// Software interrupt requests to external interrupt controller
        output [7:0]    cpz_g_ipl;        // Current IPL, contains information of which int SI_IACK ack.
        output [5:0]    cpz_g_ivn;        // Current IVN, contains information of which int SI_IACK ack.
        output [17:1]    cpz_g_ion;        // Current ION, contains information of which int SI_IACK ack.
	output		cpz_g_iack;	// interrupt acknowledge
	output		cpz_cgi;
	output		cpz_og;
	output		cpz_bg;
	output		cpz_mg;

	output		cpz_g_hotexl;		// cpz_g_exl bit from status
	output		cpz_g_exl;		// cpz_g_exl bit from status
	output		cpz_g_hoterl;         // Early version of cpz_g_erl
   	output		cpz_g_kuc_i;		// Kernel/user bit - 0:=>kernel; 1:=>user
	output		cpz_g_kuc_e;		// Kernel/user bit - 0:=>kernel; 1:=>user
	output		cpz_g_kuc_m;		// Kernel/user bit - 0:=>kernel; 1:=>user
	output		cpz_g_kuc_w;		// Kernel/user bit - 0:=>kernel; 1:=>user
	output		cpz_g_cause_pci;
	output		cpz_g_timerint;
	output		cpz_g_um;
	output		cpz_g_um_vld;
	output		cpz_g_ulri;
	output		cpz_g_srsctl_pss2css_m;	// Copy PSS back to CSS on eret
	output		cpz_drgmode_i;
	output		cpz_drgmode_m;
	output		cpz_g_pc_present;
	output 		cpz_pc_ctl0_ec1;
	output 		cpz_pc_ctl1_ec1;
	output		cpz_g_cdmm;
	output		cpz_g_watch_present;
	output		cpz_g_watch_present__1;
	output		cpz_g_watch_present__2;
	output		cpz_g_watch_present__3;
	output		cpz_g_watch_present__4;
	output		cpz_g_watch_present__5;
	output		cpz_g_watch_present__6;
	output		cpz_g_watch_present__7;
	output		cpz_ufr;
	output		cpz_g_ufr;
	output		pc0_ctl_ec1;//CX: if 0, generate GPSI on guest access PC0 register
	output		pc1_ctl_ec1;//CX: if 0, generate GPSI on guest access PC1 register
        output          cpz_g_iret_m;             //active version of M-stage IRET instn

	input		mpc_g_cp0move_m;	    // MT/F C0
	input		mpc_wr_guestctl0_m;
	input		mpc_wr_guestctl2_m;
	input		mpc_g_auexc_x;
	input		mpc_r_auexc_x;
	input		mpc_r_auexc_x_qual;
	input		mpc_g_auexc_x_qual;
	input [`M14K_GID] 	mmu_gid;
	input [`M14K_GID] 	mmu_rid;
	input		mmu_r_read_m;
	input		mmu_read_m;
	input [4:0]	mpc_gexccode;	    // cause PLA to encode exceptions into a 5 bit field
	input		mpc_g_ldcause;	
	input		mpc_g_jamepc_w;	    // load EPC register from EPC timing chain
	input		mpc_g_jamtlb_w;       // load translation registers from shadow values
	input		mpc_g_int_pf;	
	input		mpc_g_ld_causeap;	
	input		mpc_badins_type;	
	input		mpc_ge_exc;	
	input [31:0]	mpc_ir_e;
	input		mpc_auexc_on;	
	input 		mpc_iret_ret;		// PC redirect due to IRET return
	input 		mpc_chain_vec;		// hold tail chain jump
	input [`M14K_GID]	siu_eicgid;	    
	input [3:0]	siu_g_eiss;	    // Shadow set to use for EIC interrupt
        input [7:0]     siu_g_int;            // external interrupt inputs to cause
	input [5:0]	siu_g_eicvector;	    // Vector number to use for EIC interrupt
	input [17:1]	siu_g_offset;	    // Vector offset to use for EIC interrupt
	input [`M14K_VPN2RANGE]	mmu_vat_hi;
	input [31:0]	icc_umips_instn_i;
	input 		mpc_isamode_e;    // E-stage instn is UMIPS
	input 		mpc_gpsi_perfcnt;
	input 		cp1_ufrp;
	input		mpc_ctc1_fr0_m;
	input		mpc_ctc1_fr1_m;
	input		mpc_cfc1_fr_m;
	input		mpc_rdhwr_m;
	input           mpc_hw_save_srsctl_i;     //select HW save operation for icc_idata_i

// BEGIN Wire declarations made by MVP
wire [1:0] /*[1:0]*/ sw_int_m;
wire [31:0] /*[31:0]*/ cause_view_ripl_nestexc32;
wire errpc_rd;
wire cpz_hotdm_p;
wire causedc;
wire iret_tailchain;
wire cpz_g_eret_m;
wire countdm;
wire cpz_nest_erl;
wire cpz_gm_i;
wire cpz_gm_p;
wire [9:0] /*[9:0]*/ config0w_cnxt;
wire cpz_gm_x;
wire intctl_ap;
wire [1:0] /*[1:0]*/ cpz_swint;
wire cpz_iack;
wire status_int_srs_view_ipl_ld;
wire at_pro_en;
wire [7:0] /*[7:0]*/ causeip;
wire cpz_ext_int;
wire count_ld;
wire [1:0] /*[1:0]*/ view_ripl;
wire [31:0] /*[31:0]*/ cpz_out;
wire noxnsel;
wire config3_excisa;
wire wr_kscratch2;
wire [5:0] /*[5:0]*/ cpz_ivn;
wire cpz_cee;
wire hw_ext_int_e;
wire [19:0] /*[19:0]*/ cacheerr_idx;
wire enable_cp0_m;
wire config7_hci;
wire [31:0] /*[31:0]*/ desave;
wire ctc1_fr0_m;
wire [11:0] /*[11:0]*/ cause_h;
wire hot_deret_m;
wire view_ripl_cond;
wire cpz_dm;
wire cpz_mx;
wire r_doze;
wire depc0_ld;
wire cpz_iap_um;
wire [7:0] /*[7:0]*/ countb0_cnxt;
wire [6:0] /*[6:0]*/ cdexc_type_h;
wire hot_srsctl_ld;
wire [7:0] /*[7:0]*/ internal_int;
wire [31:0] /*[31:0]*/ config5;
wire intctl_ld;
wire sel_dbg_m;
wire trace_gm_w;
wire [31:0] /*[31:0]*/ epc_cnxt;
wire [31:0] /*[31:0]*/ xn;
wire [31:0] /*[31:0]*/ r_count;
wire int_exc_m;
wire errpc0_ld;
wire cpz_mnan;
wire hw_ext_int_m;
wire nest_wr_epc;
wire debug_cond;
wire config1_ld;
wire [31:0] /*[31:0]*/ cpz_status;
wire carry23;
wire config0static_m;
wire iret_ret;
wire [31:0] /*[31:0]*/ nestepc;
wire clrexl;
wire [31:0] /*[31:0]*/ taglo32;
wire [31:0] /*[31:0]*/ raw_badinstrp;
wire cpz_at_pro_start_val;
wire [31:0] /*[31:0]*/ kscratch1_nxt;
wire cpz_iv_w;
wire hwrena_rd;
wire ebase_ld;
wire hot_wr_view_ipl;
wire cpz_ice;
wire [7:0] /*[7:0]*/ count_sumb3;
wire ctc1_fr1_m;
wire [15:0] /*[15:0]*/ cpz_prid16;
wire [31:0] /*[31:0]*/ debugall32;
wire [17:1] /*[17:1]*/ cpz_vectoroffset;
wire taglo_rd;
wire cpz_eret_m;
wire cpz_po;
wire [31:0] /*[31:0]*/ config_mux;
wire r_iap_exce_handler_trace;
wire cacheerr_et;
wire cp0_deret_m;
wire eret_erl_early;
wire wr_epc;
wire setll_w;
wire userlocal_ld;
wire [14:0] /*[14:0]*/ cause;
wire hot_ignore_watch;
wire [17:1] /*[17:1]*/ cpz_ion;
wire wr_kscratch1;
wire cpz_int_excl_ie_e;
wire [6:0] /*[6:0]*/ cdexc_type_s;
wire [29:12] /*[29:12]*/ ebase;
wire [31:0] /*[31:0]*/ epc_rd_data_nestepc;
wire hot_wr_cause;
wire kscratch1_cond;
wire errpc6_ld;
wire nmi_reg;
wire [31:0] /*[31:0]*/ datald_cnxt;
wire [31:0] /*[31:0]*/ errpc;
wire hot_usermode;
wire hot_deret_e;
wire [31:0] /*[31:0]*/ cntxt32;
wire [1:0] /*[1:0]*/ cpz_mmusize;
wire r_nest_exl;
wire cpz_kuc_i;
wire cpz_vz;
wire nestepc_cond;
wire enter_eic_mode;
wire [31:12] /*[31:12]*/ cpz_ebase;
wire dcc_pm_dcmiss;
wire cpz_fr;
wire llbit_rd;
wire [3:0] /*[3:0]*/ cpz_srsctl_css;
wire [31:0] /*[31:0]*/ badinstrp;
wire [7:0] /*[7:0]*/ countb0;
wire [31:0] /*[31:0]*/ epc_w;
wire cpz_iv;
wire [31:15] /*[31:15]*/ cpz_cdmmbase;
wire watch_pend;
wire dc_present_reg;
wire [15:0] /*[15:0]*/ int_vectoroffset;
wire [9:0] /*[9:0]*/ view_ipl_nxt;
wire config3_ld;
wire bds_x;
wire errpc6_rd;
wire status_cond;
wire [31:0] /*[31:0]*/ epc_rd_data;
wire [31:0] /*[31:0]*/ r_cp0read_m;
wire [2:0] /*[2:0]*/ cpz_k23cca;
wire reverse_endian_e;
wire [31:0] /*[31:0]*/ umips_ir_e;
wire [31:0] /*[31:0]*/ view_ripl32_nestexc32;
wire nesteisa_cond;
wire compare_ld;
wire [31:0] /*[31:0]*/ raw_kscratch1;
wire [31:0] /*[31:0]*/ status_int_srs_view_ipl;
wire [31:0] /*[31:0]*/ cpz_iretpc;
wire [7:0] /*[7:0]*/ hw_int_e;
wire new_nmi;
wire cpz_dm_e;
wire status_nxt_18;
wire [7:0] /*[7:0]*/ countb3_cnxt;
wire [27:0] /*[27:0]*/ debug;
wire guestctl_rd;
wire [31:0] /*[31:0]*/ config4;
wire epc6_rd;
wire config3_excisa_cnxt;
wire scfail_e_root;
wire guestmode_early;
wire arch_llbit;
wire [`M14K_GID] /*[2:0]*/ int_gid_ed;
wire [27:0] /*[27:0]*/ debug_cnxt;
wire [7:0] /*[7:0]*/ count_sumb2;
wire [7:0] /*[7:0]*/ cpz_guestid_i;
wire cp0_iret_w;
wire cpz_sst;
wire cpz_excisamode;
wire nesteisa;
wire perfcnt_rd;
wire [9:0] /*[9:0]*/ view_ipl;
wire [7:0] /*[7:0]*/ cpz_ipl;
wire srsmap2_ld;
wire [31:0] /*[31:0]*/ status32;
wire [7:0] /*[7:0]*/ ti_int;
wire mfcp0_m;
wire [31:0] /*[31:0]*/ raw_kscratch2;
wire wr_view_ripl;
wire [4:0] /*[4:0]*/ cpz_stkdec;
wire mpc_g_iretval_e;
wire cpz_rp;
wire depc6_rd;
wire [7:0] /*[7:0]*/ countb1;
wire mtcp0_m;
wire cp0_g_iret_w;
wire srsmap_ld;
wire [1:0] /*[1:0]*/ cpz_icssize;
wire dcc_dcopld_md;
wire cpz_llbit;
wire errctl_rd;
wire [31:0] /*[31:0]*/ count_resolution;
wire taglo_ld;
wire [31:0] /*[31:0]*/ debug32;
wire [1:0] /*[1:0]*/ cpz_dcssize;
wire depc_rd;
wire watch_rd;
wire [5:0] /*[5:0]*/ vectornumber;
wire hot_bev;
wire mpc_ld_causeap_w;
wire cpz_eisa_x;
wire cacheerr_es;
wire cpz_wst;
wire cacheerr_ed;
wire mpc_g_iret_ret;
wire [31:0] /*[31:0]*/ badva_s;
wire [9:0] /*[9:0]*/ view_ipl_raw;
wire cpz_erl;
wire eret_exl_early;
wire eic_mode;
wire cpz_nest_exl;
wire cpz_iret_chain_reg;
wire [31:0] /*[31:0]*/ raw_badinstr;
wire [7:0] /*[7:0]*/ pci_int;
wire [27:0] /*[27:0]*/ lladdr;
wire [31:0] /*[31:0]*/ cpz_cp0read_m;
wire instn_vld_w;
wire [11:0] /*[11:0]*/ cause_s;
wire [31:0] /*[31:0]*/ llbit32;
wire [31:0] /*[31:0]*/ nestexc32;
wire cacheerr_eb;
wire [5:0] /*[5:0]*/ ie_pipe_out;
wire cpz_nmi_e;
wire srsmap_rd;
wire wr_debug;
wire cpz_hoterl;
wire cpz_gm_e;
wire [2:0] /*[2:0]*/ cpz_kucca;
wire [3:0] /*[3:0]*/ cpz_pi;
wire [25:0] /*[25:0]*/ status_nxt;
wire cacheerr_rd;
wire cpz_at_pro_start_i;
wire [7:0] /*[7:0]*/ countb2;
wire [2:0] /*[2:0]*/ cpz_k0cca;
wire nestexl_cond;
wire [31:0] /*[31:0]*/ kscratch2_nxt;
wire [7:0] /*[7:0]*/ int_pend_ed;
wire cp0_eret_w;
wire config6_ld;
wire cpz_setibep;
wire cpz_hotdm_i;
wire [7:0] /*[7:0]*/ hw_int_ed;
wire cache_err;
wire [31:0] /*[31:0]*/ depc;
wire [7:0] /*[7:0]*/ count_sumb1;
wire hot_inten;
wire config_rd;
wire hot_guestmode;
wire instn_vld_e;
wire cpy2_out;
wire icc_icopld_d;
wire [31:0] /*[31:0]*/ epc;
wire [31:0] /*[31:0]*/ config3;
wire dcc_error;
wire cpz_hwrena_29;
wire cpz_iexi;
wire [31:0] /*[31:0]*/ errpc_rd_data;
wire ext_int_e;
wire [31:0] /*[31:0]*/ ir_w;
wire depc7_ld;
wire cpz_spram;
wire iret_tailchain_pre;
wire pend_nmi_reg;
wire cause_view_ripl_rd;
wire scfail_e;
wire cpz_erl_e;
wire errpc_cond;
wire [25:0] /*[25:0]*/ cpz_taglo;
wire biu_sblock;
wire [17:0] /*[17:0]*/ intctl_nxt;
wire ext_int_excl_ie_e;
wire cpz_int_enable;
wire cpz_dm_w;
wire [1:0] /*[1:0]*/ hot_sw_int;
wire hot_delay_watch;
wire [7:0] /*[7:0]*/ countb3;
wire [31:0] /*[31:0]*/ ir_x;
wire [7:0] /*[7:0]*/ int_mask_e;
wire cpz_bds_x;
wire [5:0] /*[5:0]*/ int_vector_ed;
wire [7:0] /*[7:0]*/ int_mask_m;
wire [11:0] /*[11:0]*/ errctl_cnxt;
wire ic_present_reg;
wire [31:0] /*[31:0]*/ cpz_datalo;
wire errpc7_ld;
wire [7:0] /*[7:0]*/ hw_int_m;
wire cacheerr_er;
wire lladdr_rd;
wire cpz_usekstk;
wire cpz_um_vld;
wire mpc_g_eret_m;
wire siu_lamebus;
wire [3:0] /*[3:0]*/ int_ss_ed;
wire epc_cond;
wire raw_cpz_goodnight;
wire [1:0] /*[1:0]*/ sw_int_mask_m;
wire [18:3] /*[18:3]*/ config0static_lo;
wire wr_errpc;
wire scfail_e_guest;
wire cpz_timerint;
wire load_status_done_reg;
wire srsctl_vec2css_w;
wire cpz_gm_m;
wire cpz_gm_w;
wire depc6_ld;
wire [7:0] /*[7:0]*/ count_sumb0;
wire eisa_cond;
wire epc2_ld;
wire config3_dual_isa;
wire deisa_cond;
wire sel_dbg2_m;
wire hot_iv_w;
wire bds_w;
wire usermode;
wire [1:0] /*[1:0]*/ cacheerr_way;
wire hot_intctl_ld;
wire [31:0] /*[31:0]*/ hwrena32;
wire [3:0] /*[3:0]*/ m_pipe_out;
wire cpz_exl;
wire wr_cause;
wire int_enable_e;
wire [7:0] /*[7:0]*/ cpz_guestid;
wire cpz_goodnight;
wire [31:0] /*[31:0]*/ synci_step;
wire cpz_mmutype;
wire [4:0] /*[4:0]*/ dexc_type_h;
wire badva_jump;
wire [2:0] /*[2:0]*/ cpz_icnsets;
wire at_epi_en;
wire wr_desave;
wire trace_gm_m;
wire [31:0] /*[31:0]*/ epc_m;
wire carry15;
wire [31:0] /*[31:0]*/ config2;
wire cpz_rbigend_i;
wire drgmode_e;
wire wr_view_ipl;
wire compare_rd;
wire [31:0] /*[31:0]*/ ebase32;
wire srsctl_css2pss_w;
wire cpz_lsnm;
wire badva_segerr;
wire int_exc_e;
wire status_cond_reg;
wire [8:0] /*[8:0]*/ csize_tmp;
wire cpz_drgmode_i;
wire [31:0] /*[31:0]*/ nestepc_rd_data;
wire tint_first;
wire hot_wr_debug;
wire cpz_rbigend_e;
wire iret_ret_start_reg;
wire hot_g_eret_m;
wire [31:0] /*[31:0]*/ compare_guestctl0ext;
wire cpz_setdbep;
wire [8:0] /*[8:0]*/ cdmmsize;
wire softreset;
wire badva_badi_badip_rd;
wire srsctl_rd;
wire cpz_takeint;
wire int_enable_m;
wire delay_watch;
wire cpz_bev;
wire cpz_int_mw;
wire cacheerr_ee;
wire udi_present_reg;
wire hold_iret_ret;
wire [31:0] /*[31:0]*/ cpz_srsctl;
wire cpz_iack_nxt;
wire reverse_endian_i;
wire hold_compare_ld;
wire epc6_ld;
wire [31:0] /*[31:0]*/ kscratch1;
wire [3:0] /*[3:0]*/ cpz_srsctl_pss;
wire cacheerr_ew;
wire iack;
wire [31:0] /*[31:0]*/ kscratch2;
wire ignore_watch;
wire [31:0] /*[31:0]*/ cpz_eretpc;
wire [31:0] /*[31:0]*/ errctl32;
wire [11:0] /*[11:0]*/ errctl;
wire int_mode_change;
wire cpz_nmipend;
wire cpz_iret_m;
wire cpz_fdcint;
wire [27:0] /*[27:0]*/ lladdr_s;
wire config3_excisa_disa;
wire [24:20] /*[24:20]*/ config0static_hi;
wire [17:1] /*[17:1]*/ int_offset_ed;
wire cpz_iap_exce_handler_trace;
wire [31:0] /*[31:0]*/ cacheerr_reg;
wire [31:0] /*[31:0]*/ epc_w_with_iap;
wire cpz_nmi;
wire epc0_ld;
wire r_nest_erl;
wire count_rd;
wire eisa_m;
wire [31:0] /*[31:0]*/ status32_fr;
wire guestctl0ext_rd;
wire [31:0] /*[31:0]*/ badva;
wire errisa_cond;
wire cpz_kuc_e;
wire hot_wr_status;
wire cpz_smallpage;
wire [13:0] /*[13:0]*/ config1w;
wire cpz_cdmm_enable;
wire [1:0] /*[1:0]*/ view_ripl_nxt;
wire [17:0] /*[17:0]*/ intctl;
wire status_int_srs_view_ipl_rd;
wire cpz_int_e;
wire cpz_kuc_w;
wire [25:0] /*[25:0]*/ status;
wire cpz_ufr;
wire hot_eic_mode;
wire cpz_gm;
wire [2:0] /*[2:0]*/ ippci;
wire [14:0] /*[14:0]*/ cause_nxt;
wire [10:0] /*[10:0]*/ badva_fix;
wire cpz_config_ld;
wire debugmode_i;
wire iret_disable_int_e;
wire sel_pdt_m;
wire mmutypec_nxt;
wire carry7;
wire [4:0] /*[4:0]*/ dexc_type_s;
wire nesterl_cond;
wire eisa;
wire prid_ebase_rd;
wire [31:0] /*[31:0]*/ config7;
wire dieicp0_m;
wire [9:0] /*[9:0]*/ config0w;
wire cpz_iret_ret;
wire mpc_nonseq_ed;
wire [31:0] /*[31:0]*/ config1;
wire [31:0] /*[31:0]*/ cpz;
wire [31:0] /*[31:0]*/ cdmmbase;
wire cpz_hotexl;
wire errctl_ld;
wire arch_llbit_nxt;
wire hot_eret_m;
wire eic_mode_reg;
wire instn_vld_m;
wire ext_int_m;
wire [31:0] /*[31:0]*/ ir_e;
wire cpz_causeap;
wire wakeup;
wire at_pro_en_reg;
wire hwrena_ld;
wire [31:0] /*[31:0]*/ depc_rd_data;
wire datalo_ld;
wire [31:0] /*[31:0]*/ badva_s_cnxt;
wire cpz_eisa_w;
wire [2:0] /*[2:0]*/ cpz_dcnsets;
wire errisa;
wire view_ipl_cond;
wire [7:0] /*[7:0]*/ cpz_guestid_m;
wire [31:0] /*[31:0]*/ cntxt_rd_data;
wire cpz_debugmode_i;
wire ll_w;
wire cpz_bootisamode;
wire erl_early;
wire cpz_um;
wire [4:0] /*[4:0]*/ hot_vs;
wire int_excl_ie_e;
wire [31:23] /*[31:23]*/ cntxt;
wire wr_depc;
wire debug_rd;
wire cpz_g_iret_m;
wire config3_bootisa;
wire [31:0] /*[31:0]*/ badinstr;
wire [31:0] /*[31:0]*/ compare;
wire cpz_isppresent;
wire timer_int;
wire [31:0] /*[31:0]*/ lladdr32;
wire cpz_enm;
wire [1:0] /*[1:0]*/ sw_int_mask_e;
wire cntxt_rd;
wire pend_nmi;
wire EJ_DebugM;
wire [2:0] /*[2:0]*/ ic_nsets_reg;
wire count_inc;
wire ej_doze_nxt;
wire cpz_dcpresent;
wire [7:0] /*[7:0]*/ int_pend_e;
wire cacheerr_ec;
wire ej_halt_nxt;
wire [31:0] /*[31:0]*/ cause32;
wire cpz_kuc_m;
wire kscratch2_cond;
wire cpz_dm_m;
wire cpy_rd;
wire instn_slip_e;
wire depc_cond;
wire cpz_wpexc_m;
wire [31:0] /*[31:0]*/ cpz_epc_rd_data;
wire tint_reg;
wire desave_rd;
wire cpz_pf;
wire [2:0] /*[2:0]*/ ifdci;
wire deisa;
wire cpz_pe;
wire badinstr_cond;
wire [3:0] /*[3:0]*/ cpz_pd;
wire [1:0] /*[1:0]*/ cpz_mbtag;
wire hold_iret_disable_int;
wire guest_mode;
wire srsctl_ld;
wire [31:0] /*[31:0]*/ guestctl_123;
wire cacheerr_sp;
wire epc_rd;
wire status_re;
wire [7:0] /*[7:0]*/ cpz_int_pend_ed;
wire [7:0] /*[7:0]*/ countb2_cnxt;
wire see_co_ld;
wire [31:0] /*[31:0]*/ view_ipl32;
wire [25:0] /*[25:0]*/ taglo_cnxt;
wire [13:0] /*[13:0]*/ config1w_cnxt;
wire [3:0] /*[3:0]*/ cpz_copusable;
wire badva_tlb;
wire ill_cp0r_m;
wire [31:0] /*[31:0]*/ config6;
wire movefcp0_m;
wire cpz_icpresent;
wire erl_m;
wire [31:0] /*[31:0]*/ intctl32;
wire [31:0] /*[31:0]*/ config0;
wire [2:0] /*[2:0]*/ dc_nsets_reg;
wire eisa_w;
wire [31:0] /*[31:0]*/ r_eretpc;
wire ill_cp0r_m_watch;
wire cacheerr_ef;
wire [7:0] /*[7:0]*/ countb1_cnxt;
wire cpz_drgmode_m;
wire [31:0] /*[31:0]*/ desave_kscratch;
wire cpz_dsppresent;
wire cpz_nmi_mw;
wire [11:0] /*[11:0]*/ cause_code;
wire cpz_hotiexi;
wire cause_cond;
wire [3:0] /*[3:0]*/ cpz_hwrena;
wire [1:0] /*[1:0]*/ dc_ssize_reg;
wire hold_at_pro_en;
wire cdmm_ld;
wire epc7_ld;
wire xn_rd;
wire sec_rd;
wire cpz_srsctl_pss2css_m;
wire [1:0] /*[1:0]*/ sw_int_e;
wire hold_count_ld;
wire atpro_gm_i;
wire [31:0] /*[31:0]*/ badva_instr_instrp;
wire [1:0] /*[1:0]*/ ic_ssize_reg;
wire exit_eic_mode;
wire wakeup_reg;
wire [31:0] /*[31:0]*/ view_ripl32;
wire config5_ld;
wire srsmap2_rd;
wire cntxt_ld;
wire [31:0] /*[31:0]*/ userlocal;
wire [31:0] /*[31:0]*/ ir_m;
wire wr_status;
wire be_pend_change;
wire [31:0] /*[31:0]*/ cpz_epc_w;
wire srsctl_ess2css_w;
wire [31:0] /*[31:0]*/ count;
wire cpz_halt;
wire iret_disable_int_m;
wire cpz_g_iret_ret;
wire [31:0] /*[31:0]*/ debug2_32;
wire config_ld;
wire cpz_at_epi_en;
wire cpz_eretisa;
wire [7:0] /*[7:0]*/ fdc_int;
wire sec_ld;
wire cpz_doze;
wire [31:0] /*[31:0]*/ prid_ebase;
wire eisa_cnxt;
wire hot_mtcp0_m;
wire cp0_g_eret_w;
// END Wire declarations made by MVP

	// End of I/O
	
	parameter GW = `M14K_GIDWIDTH;

	/* Internal Block Wires */
	wire pc_present;
	wire g_cause_pci;
	wire [31:0]	perfcnt_rdata;

	wire [31:0] watch32;
	wire set_watch_pend_w;
	wire watch_present;
//verilint 528 off        // Variable set but not used
	wire watch_present_1;
	wire watch_present_2;
	wire watch_present_3;
	wire watch_present_4;
	wire watch_present_5;
	wire watch_present_6;
	wire watch_present_7;
//verilint 528 on        // Variable set but not used
	wire cpz_iwatchhit;
	wire cpz_dwatchhit;
	wire [31:0] r_srsctl;
	wire [31:0] srsmap;
	wire [31:0] srsmap2;

	wire		vz_present;
	wire		g_fr;
	wire [31:0]	g_cp0read_m;   // Read data for MFC0 & SC register updates
	wire [31:0]	g_eretpc;		// Target PC for ERET or DERET (epc or ErrorPC or depc)
	wire		g_nest_exl;
	wire		g_nest_erl;
	wire 		g_doze;        // Processor is in low-power mode
	wire		g_iret_tailchain;     
	wire	        g_iap_exce_handler_trace;	// Instruction is under exception processing of IAP	
	wire	[3:0]	glss;
	wire	[7:0]	gripl;
	wire	[3:0]	geicss;
	wire	[15:0]	gvec;

/* Pipeline registers */
`define M14K_CPZ_IE_ERL 0
`define M14K_CPZ_IE_DMI 1
`define M14K_CPZ_IE_DME 2
`define M14K_CPZ_IE_KUCI 3
`define M14K_CPZ_IE_KUCE 4
`define M14K_CPZ_IE_IV 5

	wire [5:0] 	ie_pipe_in;
	mvp_cregister_wide #(6) _ie_pipe_out_5_0_(ie_pipe_out[5:0],gscanenable, mpc_run_ie, gclk, ie_pipe_in);
	
`define M14K_CPZ_M_ERET 0
`define M14K_CPZ_M_DM 1
`define M14K_CPZ_M_IV 2
`define M14K_CPZ_M_BDS 3

	wire [3:0] 	m_pipe_in;
	mvp_cregister_wide #(4) _m_pipe_out_3_0_(m_pipe_out[3:0],gscanenable, mpc_run_m, gclk, m_pipe_in);

	// #################################################################
	// General cp0 control 
	// #################################################################
	// move from CP0 register
	assign mfcp0_m =  mpc_load_m && mpc_cp0move_m && !cpz_gm_m && !mpc_fixup_m;
	assign movefcp0_m = mpc_load_m && (mpc_cp0move_m || mpc_g_cp0move_m) && !cpz_gm_m 
		&& !mpc_fixup_m;

	assign enable_cp0_m = !mpc_dmsquash_m && mpc_run_m;

	assign hot_mtcp0_m = !mpc_load_m && !cpz_gm_m && mpc_cp0move_m;
	assign mtcp0_m = hot_mtcp0_m && enable_cp0_m;

	assign dieicp0_m = !cpz_gm_m && mpc_cp0diei_m && enable_cp0_m;	// write strobe for DI/EI

	assign ctc1_fr0_m = !cpz_gm_m && mpc_ctc1_fr0_m && enable_cp0_m;	// write 0 strobe for FR 
	assign ctc1_fr1_m = !cpz_gm_m && mpc_ctc1_fr1_m && enable_cp0_m;	// write 0 strobe for FR 

	assign hot_eret_m = mpc_eret_m;

	// cpz_eret_m
        assign cpz_eret_m = !cpz_gm_m && hot_eret_m && enable_cp0_m;

	//generate legal write strobe
        assign cpz_iret_m = ~cpz_gm_m & mpc_iret_m & enable_cp0_m;
        mvp_cregister #(1) _cp0_iret_w(cp0_iret_w,mpc_run_m, gclk, cpz_iret_m);
	assign cpz_iret_ret = iret_ret & mpc_run_m & ~cpz_gm_m;

	assign m_pipe_in [`M14K_CPZ_M_ERET] = cpz_eret_m;
	assign cp0_eret_w = m_pipe_out[`M14K_CPZ_M_ERET];

	assign hot_deret_m = mpc_deret_m;
	

	assign cp0_deret_m = hot_deret_m && enable_cp0_m;

	// #################################################################
	// context register
	// #################################################################
	// cntxt_ld: load cntxt register via MTC0
	assign cntxt_ld =	mtcp0_m & (mpc_cp0r_m == 5'd4) & (mpc_cp0sr_m == 3'd0);	

	// cntxt_rd: read cntxt onto cpz line
	assign cntxt_rd =	(mfcp0_m & (mpc_cp0r_m == 5'd4));



	mvp_cregister_wide #(9) _cntxt_31_23_(cntxt[31:23],gscanenable, cntxt_ld, gclk, cpz[31:23]);
	assign cntxt32 [31:0] = {cntxt, badva[31:13], 4'h0};

	assign cntxt_rd_data [31:0] = (mpc_cp0sr_m == 3'd2) ? userlocal : cntxt32;


	// #################################################################
        // UserLocal register - reg4 sel 2
	// #################################################################
        assign userlocal_ld = mtcp0_m & (mpc_cp0r_m == 5'd4) & (mpc_cp0sr_m == 3'd2);	

	mvp_cregister_wide #(32) _userlocal_31_0_(userlocal[31:0],gscanenable, userlocal_ld, gclk, cpz);
  
	// #################################################################
	// count and compare registers
	// #################################################################
	// count_resolution used by RDHWR instruction
	assign count_resolution [31:0] = 32'd2;

	assign count_rd =	mfcp0_m && (mpc_cp0r_m == 5'd9)
 	                        && noxnsel
		        ;	
	assign count_ld = 	mtcp0_m && (mpc_cp0r_m == 5'd9)
                                && noxnsel
                        ;
        assign noxnsel =       !config0[19] || (config0[19] && (mpc_cp0sr_m == 3'd0));
	mvp_register #(1) _count_inc(count_inc, gfclk, !(greset || count_ld || causedc ||
					 (!countdm && cpz_dm_m) || count_inc) );

	assign {carry7, count_sumb0[7:0]} = count[7:0] + 8'b1;
	assign {carry15, count_sumb1[7:0]} = count[15:8] + 8'b1;
	assign {carry23, count_sumb2[7:0]} = count[23:16] + 8'b1;
	assign count_sumb3[7:0] = count[31:24] + 8'b1;

	assign countb0_cnxt[7:0] = count_ld ? cpz[7:0] : count_sumb0;
	assign countb1_cnxt[7:0] = count_ld ? cpz[15:8] : count_sumb1;
	assign countb2_cnxt[7:0] = count_ld ? cpz[23:16] : count_sumb2;
	assign countb3_cnxt[7:0] = count_ld ? cpz[31:24] : count_sumb3;
	
	mvp_cregister_wide #(8) _countb0_7_0_(countb0[7:0],gscanenable, (count_inc || count_ld), gfclk, countb0_cnxt);
	mvp_cregister_wide #(8) _countb1_7_0_(countb1[7:0],gscanenable, ((count_inc && carry7) || count_ld), gfclk, countb1_cnxt);
	mvp_cregister_wide #(8) _countb2_7_0_(countb2[7:0],gscanenable, ((count_inc && carry7 && carry15) || count_ld), 
				      gfclk, countb2_cnxt);
	mvp_cregister_wide #(8) _countb3_7_0_(countb3[7:0],gscanenable, ((count_inc && carry7 && carry15 && carry23) || count_ld), 
				      gfclk, countb3_cnxt);
	assign count [31:0] = 	{countb3, countb2, countb1, countb0};
	assign r_count[31:0] = count[31:0];

	
	assign compare_rd = mfcp0_m && (mpc_cp0r_m == 5'd11);	
	assign compare_ld = mtcp0_m && (mpc_cp0r_m == 5'd11) && (mpc_cp0sr_m == 3'd0);	
	mvp_cregister_wide #(32) _compare_31_0_(compare[31:0],gscanenable, compare_ld, gclk, cpz);
	mvp_mux2 #(32) _compare_guestctl0ext_31_0_(compare_guestctl0ext[31:0],mpc_cp0sr_m[2], compare, guestctl0ext_32);

	assign timer_int = (compare == count || cpz_timerint) && !compare_ld ;
	// cpz_timerint is a core output that can be muxed onto SI_Int[5]
	//  externally.
	assign see_co_ld = (count_ld | hold_count_ld) & (compare_ld | hold_compare_ld);
	mvp_cregister #(1) _hold_count_ld(hold_count_ld,greset | count_ld, gclk, count_ld & ~greset);
	mvp_cregister #(1) _hold_compare_ld(hold_compare_ld,greset | compare_ld, gclk, compare_ld & ~greset);
	mvp_register #(1) _cpz_timerint(cpz_timerint, gfclk, timer_int & see_co_ld);

// 
  
 //VCS coverage off 
wire	[31:0]	cpz_count;
	mvp_register #(32) _cpz_count_31_0_(cpz_count[31:0], gfclk, count);
// 
  //VCS coverage on  
  

        assign xn_rd = mfcp0_m && (mpc_cp0r_m == 5'd9) && (mpc_cp0sr_m == 3'd6) && config0[19];
        assign xn[31:0] = {22'b0, 10'h33f};
   
	// #################################################################
	// Security features
	// #################################################################

	assign sec_ld = mtcp0_m && (mpc_cp0r_m == 5'd22);
	assign sec_rd = mfcp0_m && (mpc_cp0r_m == 5'd22) && antitamper_present;
	wire [31:0] secReg;
	
	`M14K_CPZ_ANTITAMPER_MODULE cpz_antitamper (
	.gfclk (gfclk),
	.greset (greset),
	.gscanenable (gscanenable),
	.mpc_run_m (mpc_run_m),
	.sec_ld (sec_ld),
	.sec_rd (sec_rd),
	.sec_indx (mpc_cp0sr_m),
	.cpz (cpz),
	.siu_slip (siu_slip),
	.secReg (secReg),
	.cpz_rslip_e (cpz_rslip_e ),
	.cpz_rclen (cpz_rclen ),
	.cpz_rclval (cpz_rclval ),
	.cpz_scramblecfg_write (cpz_scramblecfg_write ),
	.cpz_scramblecfg_sel (cpz_scramblecfg_sel ),
	.cpz_scramblecfg_data (cpz_scramblecfg_data ),
	.antitamper_present (antitamper_present ));



	// #################################################################
	// badva register
	// #################################################################
	// badva_badi_badip_rd: read BadVAddr onto cpz line
	assign badva_badi_badip_rd =	mfcp0_m & (mpc_cp0r_m == 5'd8);	

	// Bus badva[31:0]: bad virtual address register
	mvp_cregister_wide #(32) _badva_31_0_(badva[31:0],gscanenable, mpc_jamtlb_w, gclk, badva_s);

	mvp_cregister #(1) _mpc_nonseq_ed(mpc_nonseq_ed,mpc_run_ie | greset, gclk, (mpc_nonseq_e | mpc_nonseq_ed & mpc_lsdc1_e) & ~greset);
	mvp_cregister #(1) _instn_slip_e(instn_slip_e,(mpc_run_ie | mpc_fixupi) & (~icc_imiss_i|mpc_umipsfifosupport_i) | greset, 
		gclk, icc_umipsfifo_null_i & ~greset);

	assign badva_jump = mpc_nonseq_ed;
	assign badva_segerr = (mpc_exccode[4:0] == 5'b00100) & mmu_r_it_segerr;
	mvp_register #(1) _status_cond_reg(status_cond_reg,gclk, status_cond);

	assign badva_tlb = (mpc_exccode[4:0] == 5'b00010) | (mpc_exccode[4:0] == 5'b00011) | 
		(mpc_exccode[4:0] == 5'b11011) & ((mpc_gexccode[4:0] == 5'b01000) | (mpc_gexccode[4:0] == 5'b01010));
	assign badva_fix [10:0] = 
		badva_tlb ? 
			badva_jump ? edp_cacheiva_i[10:0] : (  {edp_cacheiva_i[10:2], 2'b00} ) : 
			{edp_cacheiva_i[10:4], 
				// fixes walk to segerr
				( (badva_segerr & ~badva_jump & (~status_cond_reg|instn_slip_e) & ~mpc_excisamode_i) ? 3'b0 : 
				edp_cacheiva_i[3:1]),
				edp_cacheiva_i[0]};

	assign badva_s_cnxt [31:0] =  {mmu_vat_hi[`M14K_VPN2RANGE], (mmu_vafromi ? badva_fix : mmu_dva_m[10:0])};
	mvp_cregister_wide #(32) _badva_s_31_0_(badva_s[31:0],gscanenable, mmu_r_transexc, gclk, badva_s_cnxt);

	mvp_mux8 #(32) _badva_instr_instrp_31_0_(badva_instr_instrp[31:0],mpc_cp0sr_m[2:0], badva, badinstr, badinstrp, 
					      32'b0, 32'b0, 32'b0, 32'b0, 32'b0);

	// #################################################################
	// badinstr register
	// #################################################################
	mvp_cregister_wide #(32) _umips_ir_e_31_0_(umips_ir_e[31:0],gscanenable, (mpc_run_ie | mpc_fixupi) & ~mpc_atomic_e
                & ~mpc_lsdc1_e & (~icc_imiss_i | mpc_umipsfifosupport_i), gclk, icc_umips_instn_i);
	assign ir_e[31:0] = mpc_isamode_e ? umips_ir_e : mpc_ir_e;
	mvp_cregister_wide #(32) _ir_m_31_0_(ir_m[31:0],gscanenable, mpc_run_ie, gclk, ir_e);
	mvp_cregister_wide #(32) _ir_w_31_0_(ir_w[31:0],gscanenable, mpc_run_m, gclk, ir_m);
	mvp_cregister_wide #(32) _ir_x_31_0_(ir_x[31:0],gscanenable, mpc_run_w, gclk, ir_w);
	assign badinstr_cond = mpc_jamepc_w & mpc_badins_type;
	mvp_cregister_wide #(32) _raw_badinstr_31_0_(raw_badinstr[31:0],gscanenable, badinstr_cond, gclk, ir_w);
	assign badinstr [31:0] = cpz_vz ? raw_badinstr : 32'b0;
	mvp_cregister_wide #(32) _raw_badinstrp_31_0_(raw_badinstrp[31:0],gscanenable, badinstr_cond & bds_x, gclk, ir_x);
	assign badinstrp [31:0] = cpz_vz ? raw_badinstrp : 32'b0;

	// #################################################################
	// Common Status/IntCtl/SRS registers decode
	// #################################################################
        assign status_int_srs_view_ipl_rd =  mfcp0_m & (mpc_cp0r_m == 5'd12);
        assign status_int_srs_view_ipl_ld =  mtcp0_m & (mpc_cp0r_m == 5'd12);

	// #################################################################
	// interrupt control register
	// #################################################################

        assign intctl_ld = status_int_srs_view_ipl_ld & (mpc_cp0sr_m[2:0] == 3'h1);    
        assign hot_intctl_ld = mpc_wr_intctl_m & mpc_cp0move_m & (mpc_cp0sr_m[2:0] == 3'h1) ;    

	assign intctl_nxt [4:0] = greset ? 5'b0 : cpz[9:5];
        mvp_cregister_wide #(5) _intctl_4_0_(intctl[4:0],gscanenable, greset | intctl_ld, gclk, intctl_nxt[4:0]);
        assign intctl_nxt [17:8] = greset ? {2'b0, 5'd3, 3'b0} : cpz[22:13];
        mvp_cregister_wide #(10) _intctl_17_8_(intctl[17:8],gscanenable, greset | intctl_ld, gclk, intctl_nxt[17:8]);

	assign intctl32 [31:0] = { siu_ipti, ippci, ifdci, intctl[17:8], 3'b0, intctl[4:0], 5'b0 };
	assign hot_vs [4:0] = hot_intctl_ld ? cpz[9:5] : intctl32[9:5];
	assign ifdci [2:0] = fdc_present ? siu_ifdci[2:0] : 3'b0 ;
	assign ippci [2:0] = pc_present ? siu_ippci[2:0] : 3'b0;

	//choice of EIC Supplies Offset on/off 
	wire	cpz_eic_offset;
	`M14K_EIC_SUPPLIES_OFFSET eicoffset(.eic_offset(cpz_eic_offset));

	wire [3:0]	vectornumber_temp;
//verilint 528 off  // Variable set but not used.
        wire 		countleadingzeroes_dummy;
//verilint 528 on  // Variable set but not used.
	
	m14k_edp_clz_16b countleadingzeroes(.a({ hw_int_ed[7:0], sw_int_e[1:0], 6'b0 }),
					   .count(vectornumber_temp),
					   .allzeron(countleadingzeroes_dummy));

	assign vectornumber[5:0] = siu_eicpresent & ~cpz_eic_offset ? (mpc_int_pref_phase1 & tint_first ?
		siu_eicvector & {6{~(|siu_eicgid) | ~cpz_vz}} : int_vector_ed & {6{~(|int_gid_ed)}}) : 
		{2'b0, (~vectornumber_temp[3:0] - 4'b0110)};
	assign tint_first = mpc_tint & ~tint_reg;
	mvp_register #(1) _tint_reg(tint_reg, gclk, mpc_tint);

	assign int_vectoroffset [15:0] = `M14K_INT_OFF;
	assign cpz_vectoroffset[17:1] = eic_mode & cpz_eic_offset ? (mpc_int_pref_phase1 & mpc_tint ? 
		siu_offset & {17{~(|siu_eicgid) | ~cpz_vz}} : int_offset_ed & {17{~(|int_gid_ed)}}) : 
		{2'b0, int_vectoroffset[15:5] +
                (({ 11 { intctl32[9]}} & {1'b0, vectornumber, 4'b0}) |
                 ({ 11 { intctl32[8]}} & {2'b0, vectornumber, 3'b0}) |
                 ({ 11 { intctl32[7]}} & {3'b0, vectornumber, 2'b0}) |
                 ({ 11 { intctl32[6]}} & {4'b0, vectornumber, 1'b0}) |
                 ({ 11 { intctl32[5]}} & {5'b0, vectornumber})), 4'b0};

	assign eic_mode = siu_eicpresent & ~cpz_bev & cpz_iv_w & (intctl32[9:5] != 5'b0);

        //number of words for the decremented value of sp
        assign cpz_stkdec[4:0] = intctl32[20:16];

        //clear ksu/erl/exl at auto prologue
        assign clrexl = intctl32[15];

        //enable tail chain
        assign cpz_ice = intctl32[21];

        //speculative prefetch enable
        assign cpz_pf = intctl32[22];

        //auto-prologue enable
        assign intctl_ap = intctl32[14];

        //use kernel stack during IAP
        assign cpz_usekstk = intctl32[13];

	// #################################################################
	// shadow register sets:  registers for shadow register sets
	// #################################################################

        assign srsctl_rd = status_int_srs_view_ipl_rd & (mpc_cp0sr_m[2:0] == 3'h2);    

        //load saved SRSCTL to CP0 during HW return sequence
        assign srsctl_ld = status_int_srs_view_ipl_ld & (mpc_cp0sr_m[2:0] == 3'h2)
                    | mpc_hw_load_done; 
	assign hot_srsctl_ld = hot_mtcp0_m & (mpc_cp0r_m == 5'd12) & (mpc_cp0sr_m[2:0] == 3'h2) 
		| mpc_hw_load_done;

        assign srsmap_rd = status_int_srs_view_ipl_rd & (mpc_cp0sr_m[2:0] == 3'h3);    
        assign srsmap_ld = status_int_srs_view_ipl_ld & (mpc_cp0sr_m[2:0] == 3'h3);    
        assign srsmap2_rd = status_int_srs_view_ipl_rd & (mpc_cp0sr_m[2:0] == 3'h5);    
        assign srsmap2_ld = status_int_srs_view_ipl_ld & (mpc_cp0sr_m[2:0] == 3'h5);    

        assign cpz_srsctl_pss2css_m = (cpz_eret_m | cpz_iret_ret) & ~cpz_erl & ~cpz_bev  // Copy PSS back to CSS on eret
				| (mpc_jamerror_w | mpc_jamdepc_w ) & mpc_atpro_w;          

	assign srsctl_css2pss_w = mpc_jamepc_w & ~cpz_bev & ~cpz_exl;			// Save CSS in PSS on exc/int (not debug)

	//designate CSS to ESS for memory exceptions during IAP & IAE
	assign srsctl_ess2css_w = mpc_jamepc_w & ~cpz_bev & (mpc_atpro_w | mpc_atepi_w);			

	//update srsctl on IRET if tailchain happen
        assign srsctl_vec2css_w = srsctl_css2pss_w & cpz_iv_w & (intctl32[9:5] != 5'b0) & (cause_s[4:0] == 5'h0)
                           | iret_tailchain;

	wire	[3:0]	hot_srsctl_pss;
	`M14K_CPZ_SRS_MODULE cpz_srs (
				     .gscanenable(gscanenable),	
				     .greset(greset),
				     .gclk(gclk), 
				     .srsctl_rd(srsctl_rd),
				     .srsctl_ld(srsctl_ld),
				     .srsmap_rd(srsmap_rd),
				     .srsmap_ld(srsmap_ld),
				     .srsmap2_rd(srsmap2_rd),
				     .srsmap2_ld(srsmap2_ld),

				     .cpz_srsctl_pss2css_m(cpz_srsctl_pss2css_m),
				     .srsctl_css2pss_w(srsctl_css2pss_w),
				     .srsctl_vec2css_w(srsctl_vec2css_w),
				     .srsctl_ess2css_w(srsctl_ess2css_w),

				     .eic_present(siu_eicpresent),
				     .srsdisable(siu_srsdisable),
				     .eiss(int_ss_ed),
				     .vectornumber(vectornumber),
                                     .cpz(mpc_hw_load_done ? mpc_buf_srsctl : cpz),

				     .srsctl(r_srsctl),
				     .srsmap(srsmap),
				     .srsmap2(srsmap2),
				     .hot_srsctl_pss(hot_srsctl_pss),

				     .int_gid_ed(int_gid_ed)
				    );


	assign cpz_srsctl_css [3:0] = r_srsctl[3:0];
	assign cpz_srsctl_pss [3:0] = hot_srsctl_ld ? hot_srsctl_pss : r_srsctl[9:6];

	//SRSCTL data for HW entry sequence
        assign cpz_srsctl[31:0] = r_srsctl;

	// #################################################################
	// status:  status register
	// #################################################################
	assign softreset = greset && !siu_coldreset;

	// wr_status: write to status register via MTC0
        assign wr_status =     status_int_srs_view_ipl_ld & (mpc_cp0sr_m[2:0] == 3'h0) & ~greset;
        assign hot_wr_status = mpc_wr_status_m & mpc_cp0move_m & ~cpz_gm_m & (mpc_cp0sr_m[2:0] == 3'h0);

	assign status_nxt [25:0] = 
			wr_status ? ({(cpz[30] & cp2_coppresent),	// CU2 only settable if CP2 Hardware is present
				  cpz[29] & cp1_coppresent, // CU1 
				  cpz[28:27], cpz[26] & cp1_coppresent, cpz[25], cpz[24] & edp_dsp_present_xx,
				  cpz[22],
				  (cpz[21:19] & status32[21:19]), 	// TS, SR, nmi only clearable
				  cpz[18], cpz[17] & udi_present_reg, cpz[16:8],
				  cpz[4], cpz[2:0] }) : 
        //update status during HW ret sequence
                        (mpc_load_status_done & mpc_chain_take | mpc_hw_load_done) & ~cpz_gm_w ? 
					   { mpc_buf_status[30],
					     mpc_buf_status[29],
					     mpc_buf_status[28:27],
					     mpc_buf_status[26] & cp1_coppresent,
					     mpc_buf_status[25],
					     mpc_buf_status[24] & edp_dsp_present_xx,
					     mpc_buf_status[22:8],
					     mpc_buf_status[4],
					     mpc_buf_status[2:0]} :
			    { greset ? 1'b0 : status32[30], // CU2 is reset if no cop2 is present
			      greset ? 1'b0 : status32[29], // CU1 is reset if no cop1 is present
			      status32[28], 
			      greset ? 1'b0 : status32[27], 
			      greset | ctc1_fr0_m ? 1'b0 : ctc1_fr1_m ? 1'b1 : status32[26] & cp1_coppresent, 
			      greset ? 1'b0 : status32[25], 
			      greset ? 1'b0 : status32[24] & edp_dsp_present_xx, 
			      status_nxt_18,
			      (greset | mpc_nmitaken) ? 1'b0 : (mmu_r_tlbshutdown & ~cpz_dm_w) ? 1'b1 : status32[21],
			      softreset ? 1'b1 : (greset | mpc_nmitaken) ? 1'b0 : (status32[20]),
			      greset  ? 1'b0 : mpc_nmitaken ? 1'b1 : (status32[19]),
			      greset ? 1'b0 : mpc_hw_save_done & ~cpz_gm_w ? cpz_ipl[7] : 
			      iret_tailchain ? int_pend_ed[7] : wr_view_ipl ? cpz[9] : status32[18], 

			      greset ? 1'b0 : status32[17],
			      greset ? 7'b0 : mpc_hw_save_done & ~cpz_gm_w ? cpz_ipl[6:0] : 
			      iret_tailchain ? int_pend_ed[6:0] : wr_view_ipl ? cpz[8:2] : status32[16:10], 
	                      wr_view_ipl & ~eic_mode ? cpz[1:0] : status32[9:8],

	                      (iret_tailchain | mpc_hw_save_done & ~cpz_gm_w) & clrexl ? 1'b0 : status32[4],
			      (mpc_jamerror_w | greset) ? 1'b1 : (cpz_eret_m) ? 1'b0 : 
                              (iret_tailchain | mpc_hw_save_done & ~cpz_gm_w) & clrexl ? 1'b0 : 
			      cpz_iret_ret ? 1'b0 : status32[2],
			      mpc_jamepc_w ? 1'b1 : (mpc_jamerror_w | mpc_jamdepc_w) & mpc_atpro_w ? 1'b0 :
				(cpz_eret_m & ~erl_m) ? 1'b0 : 
                              (iret_tailchain | mpc_hw_save_done & ~cpz_gm_w) & clrexl ? 1'b0 : 
			      cpz_iret_ret ? 1'b0 : status32[1],

			      dieicp0_m ? mpc_cp0sc_m : status32[0]  };

	assign status_nxt_18 = (greset | mpc_nmitaken) ? 1'b1 : (status32[22]);

	mvp_cregister #(1) _r_iap_exce_handler_trace(r_iap_exce_handler_trace,greset||mpc_pdstrobe_w||status_cond||iret_tailchain_pre, gclk, 
			greset? 1'b0 :
			mpc_pdstrobe_w? 1'b0 :
		 	(    (iret_tailchain_pre  || mpc_hw_save_done) && cpz_exl   || r_iap_exce_handler_trace ) );
	assign cpz_iap_exce_handler_trace = cpz_gm_w ? g_iap_exce_handler_trace : r_iap_exce_handler_trace;

        assign status_cond = wr_status | greset | mpc_nmitaken | mmu_r_tlbshutdown | mpc_jamerror_w |
                      cpz_eret_m | mpc_jamepc_w | dieicp0_m | mpc_hw_save_done & ~cpz_gm_w | ctc1_fr0_m | ctc1_fr1_m |
                      mpc_hw_load_done & ~cpz_gm_m | mpc_load_status_done & ~cpz_gm_m | iret_tailchain | cpz_iret_ret | wr_view_ipl;

 	mvp_ucregister_wide #(26) _status_25_0_(status[25:0],gscanenable, status_cond, gclk, status_nxt);

	assign status32 [31:0] = {1'b0,              // CU3 not writeable
			   status[25],        // CU2
			   status[24],        // CU1
			   status[23],        // CU0
			   status[22],        // RP
			   status[21],        // FR
			   status[20],        // Reverse Endian
			   status[19] & edp_dsp_present_xx,        // MX
			   1'b0,              // 0
			   status[18],        // BEV
			   status[17],        // TS
			   status[16],        // SR
			   status[15],        // NMI
			   status[14],        //IPL[7]
			   status[13],        // CEE
			   status[12],        //IPL[6]
			   status[11:4],      // IM[7:0]
			   3'b0,              // 0
			   status[3],         // UM
			   1'b0,              // 0
			   status[2:0]};      // ERL,EXL,IE
			   
	//Status data for HW sequence
        assign cpz_status[31:0] = status32;

	assign cpz_mx = status32[24];
	assign cpz_fr = mpc_ctc1_fr0_m ? 1'b0 : mpc_ctc1_fr1_m ? 1'b1 : cpz_gm_e ? g_fr : status32[26];

	assign status32_fr[31:0] = mpc_cfc1_fr_m & ~cpz_gm_m ? {31'b0, status32[26]} : status32;
	mvp_mux8 #(32) _status_int_srs_view_ipl_31_0_(status_int_srs_view_ipl[31:0],mpc_cp0sr_m[2:0], status32_fr, intctl32, r_srsctl, 
					      srsmap, view_ipl32, srsmap2, guestctl0_32, gtoffset);

	mvp_cregister #(1) _cpz_um_vld(cpz_um_vld,wr_status || greset, gclk, !greset);
	assign cpz_um  = status32[4];
	assign cpz_erl = status32[2];
        assign cpz_erl_e = status_nxt[2];
	assign cpz_exl = status32[1];
	assign cpz_nmi = status32[19];

	assign ie_pipe_in[`M14K_CPZ_IE_ERL] = cpz_erl;
	assign erl_m = ie_pipe_out[`M14K_CPZ_IE_ERL];

	assign cpz_hotexl = hot_wr_status ? cpz[1] : hot_eret_m & ~cpz_gm_m & ~cpz_erl ? 1'b0: status32[1];
	assign cpz_hoterl = hot_wr_status ? cpz[2] : hot_eret_m & ~cpz_gm_m ? 1'b0 : status32[2];
        assign erl_early = hot_wr_status ? cpz[2] : status32[2];
	assign cpz_hotdm_i = (hot_deret_m) ? 1'b0 : debug32[30];

	assign debugmode_i = cp0_deret_m ? 1'b0 : debug32[30];
	assign cpz_debugmode_i = debug32[30];

	assign ie_pipe_in[`M14K_CPZ_IE_DMI] = debugmode_i;
	assign cpz_dm_e = ie_pipe_out[`M14K_CPZ_IE_DMI];

	assign ie_pipe_in[`M14K_CPZ_IE_DME] = cpz_dm_e;
	assign cpz_dm_m = ie_pipe_out[`M14K_CPZ_IE_DME];

	assign m_pipe_in[`M14K_CPZ_M_DM] = cpz_dm_m;
	assign cpz_dm_w = m_pipe_out[`M14K_CPZ_M_DM];

	// External Indication that we are in DebugMode
	assign EJ_DebugM = cpz_dm_e;

	assign cpz_rp = status32[27]; // Reduce Power bit from status

	// int_enable: interrupt enable bit
	assign int_enable_e =	hot_inten && !cpz_hotexl && !cpz_hoterl && !mpc_pexc_m && !cpz_dm_e;
	assign int_excl_ie_e =	!cpz_hotexl && !cpz_hoterl && !mpc_pexc_m && !cpz_dm_e;
	assign int_enable_m =	status32[0] && !cpz_exl && !cpz_erl && !mpc_pexc_w && !cpz_dm_m;
	assign cpz_int_enable = status32[0] && !cpz_erl && !mpc_pexc_w && !cpz_dm_m;

	assign hot_inten = hot_wr_status ? cpz[0] : (mpc_cp0diei_m ? mpc_cp0sc_m : status32[0]);

	assign cpz_drgmode_i = hot_drg & ~hot_usermode & ~cpz_hotexl & ~cpz_hoterl & ~cpz_hotdm_i;
	mvp_cregister #(1) _drgmode_e(drgmode_e,mpc_run_ie, gclk, cpz_drgmode_i);
	mvp_cregister #(1) _cpz_drgmode_m(cpz_drgmode_m,mpc_run_ie, gclk, drgmode_e);

	// usermode: Kernel/user bit - 0:=>kernel; 1:=>user
	assign hot_usermode = hot_wr_status ? cpz[4] : status32[4];
	
	assign usermode =	hot_usermode & ~cpz_hotexl & ~cpz_hoterl;	

	// KUc: Kernel/user bit - 0:=>kernel; 1:=>user
	// In DebugMode, we gain kernel privileges
	assign cpz_kuc_i =	usermode && !cpz_hotdm_i && !mpc_int_pf_phase1_reg;


        assign guestmode_early = hot_guestmode & ~eret_exl_early & ~eret_erl_early;
        assign eret_exl_early = (mpc_eretval_e & ~cpz_gm_e & ~erl_early) | (hot_eret_m & ~cpz_gm_m & ~cpz_erl) ? 1'b0 :
                         (hot_wr_status ? cpz[1] : status32[1]);
        assign eret_erl_early = mpc_eretval_e & ~cpz_gm_e | hot_eret_m & ~cpz_gm_m ? 1'b0 : erl_early;
        assign cpz_hotdm_p = (hot_deret_e || hot_deret_m) ? 1'b0 : debug32[30];
        assign hot_deret_e = mpc_deretval_e;
        assign cpz_gm_p =     guestmode_early && !cpz_hotdm_p;

	assign ie_pipe_in[`M14K_CPZ_IE_KUCI] = cpz_kuc_i;
	assign cpz_kuc_e = ie_pipe_out[`M14K_CPZ_IE_KUCI];

	assign ie_pipe_in[`M14K_CPZ_IE_KUCE] = cpz_kuc_e;
	assign cpz_kuc_m = ie_pipe_out[`M14K_CPZ_IE_KUCE];

	assign hot_guestmode = hot_wr_guestctl0 ? cpz[31] : guestctl0_32[31];
	assign guest_mode =	hot_guestmode & ~cpz_hotexl & ~cpz_hoterl;	
	mvp_cregister #(1) _atpro_gm_i(atpro_gm_i,mpc_run_ie, gclk, mpc_hw_save_srsctl_i && clrexl && hot_guestmode);
	assign cpz_gm_i =	guest_mode && !cpz_hotdm_i || atpro_gm_i; 
	mvp_cregister #(1) _cpz_gm_e(cpz_gm_e,mpc_run_ie, gclk, cpz_gm_i);
	mvp_cregister #(1) _cpz_gm_m(cpz_gm_m,mpc_run_ie, gclk, cpz_gm_e);
	mvp_cregister #(1) _cpz_gm_w(cpz_gm_w,mpc_run_m, gclk, cpz_gm_m);
	mvp_cregister #(1) _cpz_gm_x(cpz_gm_x,mpc_run_w, gclk, cpz_gm_w);

	mvp_cregister #(1) _trace_gm_m(trace_gm_m,mpc_run_ie, gclk, cpz_eret_m & ~erl_m & cpz_gm_i);
	mvp_cregister #(1) _trace_gm_w(trace_gm_w,mpc_run_m, gclk, cpz_eret_m & ~erl_m & cpz_gm_i | trace_gm_m);

	// Bus sw_int_mask[1:0]: software interrupt mask
        assign sw_int_mask_e [1:0] =   hot_wr_status | hot_wr_view_ipl ? cpz[9:8] : status32[9:8];

	assign sw_int_mask_m [1:0] =   status32[9:8];

	// Bus int_mask[5:0]: hardware interrupt mask
        assign int_mask_e [7:0] = hot_wr_status ? {cpz[18], cpz[16:10]} : 
		hot_wr_view_ipl ? cpz[9:2] : 
		{status32[18], status32[16:10]}; 

        assign int_mask_m [7:0] = {status32[18], status32[16:10]};

	// send interrupt acknowledge to external interrupt controller
	mvp_cregister #(1) _iack(iack,mpc_run_w | iret_tailchain, gclk, srsctl_vec2css_w);

	// delay cpz_iack so cause.ripl is updated
	mvp_register #(1) _cpz_iack_nxt(cpz_iack_nxt, gclk, iack);
	assign cpz_iack = iack & ~cpz_iack_nxt;

        assign cpz_ipl [7:0] = causeip;

	// cpz_bev: Bootstrap exception vectors
	assign cpz_bev =	status32[22];	
	assign hot_bev = hot_wr_status ? cpz[22] : status32[22];

	// status_re: reverse Endianess status bit
	assign status_re =	status32[25];	

	// RevEnd1: reverse Endianess from state of bigend mode bit in user mode
	assign reverse_endian_e =	status_re & cpz_kuc_e;	

	assign cpz_rbigend_e =	siu_bigend ^ reverse_endian_e;	

	// RevEnd: reverse Endianess from state of bigend mode bit in user mode
	assign reverse_endian_i =	status_re & cpz_kuc_i;	
	
	assign cpz_rbigend_i 	 =	siu_bigend ^ reverse_endian_i;	



	// Bus cpz_copusable[3:0]: coprocessor usable bits
	assign cpz_copusable [3:0] =	status32[31:28];

	// cpz_cee: corextend enable
	assign cpz_cee = status32[17];


	// #################################################################
	// cause register
	// #################################################################
	// wr_cause: write to cause register via MTC0
        assign wr_cause =      mtcp0_m & (mpc_cp0r_m == 5'd13) & (mpc_cp0sr_m[2:0] == 3'h0);
        assign hot_wr_cause =  hot_mtcp0_m & (mpc_cp0r_m == 5'd13) & (mpc_cp0sr_m[2:0] == 3'h0);
	
	// cause_rd: read cause register onto cpz line
        assign cause_view_ripl_rd =    mfcp0_m & (mpc_cp0r_m == 5'd13);

	assign nestexl_cond =	mmu_r_tlbshutdown | mpc_jamepc_w | iret_tailchain ;
	assign nesterl_cond =	mmu_r_tlbshutdown | mpc_jamepc_w | iret_tailchain | 
			mpc_jamerror_w ;
	mvp_cregister #(1) _r_nest_exl(r_nest_exl,greset | nestexl_cond, gclk, status[1] & ~greset);
	mvp_cregister #(1) _r_nest_erl(r_nest_erl,greset | nesterl_cond, gclk, status[2] & ~greset);
	assign nestexc32 [31:0] = {29'b0, r_nest_erl, r_nest_exl, 1'b0};
	mvp_mux2 #(32) _view_ripl32_nestexc32_31_0_(view_ripl32_nestexc32[31:0],mpc_cp0sr_m[0], view_ripl32, nestexc32);
	mvp_mux2 #(32) _cause_view_ripl_nestexc32_31_0_(cause_view_ripl_nestexc32[31:0],mpc_cp0sr_m[2], cause32, view_ripl32_nestexc32);
	assign cpz_nest_exl = cpz_gm_i ? g_nest_exl : r_nest_exl;
	assign cpz_nest_erl = cpz_gm_i ? g_nest_erl : r_nest_erl;

	// cause:  cause register
        assign cause_nxt [14:0] = {(mpc_jamepc_w & ~cpz_exl) ? bds_x : cause[14],
                             (cause_nxt[4:0] == 5'b01011) ? mpc_jamepc_w ? cause_s[6:5] : cause[13:12] : 2'b00,
                             greset ? 1'b0 : wr_cause ? cpz[27] : cause[11],
                             greset ? 1'b0 : iret_tailchain ? 1'b1 : cpz_iret_ret ? 1'b0 : cause[10], // IC
                             greset ? 1'b0 : cpz_iret_ret | mpc_jamepc_w & ~mpc_atpro_w ? 1'b0 : 
			     mpc_ld_causeap ? 1'b1 : cause[9],    // AP
                             wr_cause ? cpz[23] : cause[8],
                             set_watch_pend_w ? 1'b1 : wr_cause ? (cpz[22] & cause[7])   // watch_pend only clearable
                                                                : cause[7],
                             wr_cause ? cpz[9:8] : wr_view_ripl ? cpz[1:0] : cause[6:5],        // software int bits
                             iret_tailchain ? 5'b0 : mpc_jamepc_w ? cause_s[4:0] : cause[4:0] // mpc_exccode
                             };

	assign hot_sw_int [1:0]  = hot_wr_cause ? cpz[9:8] : cause[6:5];
	
        assign cause_cond = mpc_jamepc_w || wr_cause || set_watch_pend_w || greset || iret_tailchain || cpz_iret_ret
                     || mpc_ld_causeap || wr_view_ripl;
        mvp_ucregister_wide #(15) _cause_14_0_(cause[14:0],gscanenable, cause_cond, gclk, cause_nxt);
	
        assign int_pend_e [7:0] = siu_int;

	assign ti_int[7:0] = {8{cpz_timerint}} & ((8'b1 << siu_ipti) >> 2);
	assign pci_int[7:0] = {8{cpz_cause_pci}} & ((8'b1 << ippci) >> 2);
	assign fdc_int[7:0] = {8{cpz_fdcint}} & ((8'b1 << ifdci) >> 2);
	assign internal_int[7:0] = ti_int | pci_int | fdc_int;

        mvp_cregister_wide #(38) _int_pend_ed_7_0_int_vector_ed_5_0_int_offset_ed_17_1_int_ss_ed_3_0_int_gid_ed_2_0({int_pend_ed[7:0],
	 int_vector_ed[5:0],
	 int_offset_ed[17:1],
	 int_ss_ed[3:0],
	 int_gid_ed[`M14K_GID]}, gscanenable, mpc_hold_hwintn, gclk, 
				{int_pend_e & ~r_pip_e & ~hc_vip_e | internal_int,
				 siu_eicvector,
				 siu_offset,
				 siu_eiss,
				 siu_eicgid & {GW{cpz_vz}}});

	//pending interrupt
        assign cpz_int_pend_ed[7:0] = int_pend_ed;

	assign int_mode_change = (hot_eic_mode ^ eic_mode_reg) & cpz_vz;
        mvp_cregister_wide #(6) _causeip_5_0_(causeip[5:0],gscanenable, int_mode_change | (eic_mode ? srsctl_vec2css_w : mpc_run_ie), 
		gclk, int_pend_ed[5:0] & {6{~int_mode_change}});
        mvp_cregister #(2) _causeip_7_6_(causeip[7:6],greset | int_mode_change | (eic_mode ? srsctl_vec2css_w : mpc_run_ie), gclk, 
	       greset | int_mode_change ? 2'b0 : int_pend_ed[7:6]);
	mvp_cregister_wide #(6) _cpz_ivn_5_0_(cpz_ivn[5:0],gscanenable, eic_mode ? srsctl_vec2css_w : mpc_run_ie, gclk, int_vector_ed[5:0]);
	mvp_cregister_wide #(17) _cpz_ion_17_1_(cpz_ion[17:1],gscanenable, eic_mode ? srsctl_vec2css_w : mpc_run_ie, gclk, int_offset_ed[17:1]);

	assign cause32 [31:0] = {cause[14], cpz_timerint, cause[13:12], cause[11], cpz_cause_pci, cause[10:7], cpz_fdcint, 3'h0, causeip,
                          cause[6:5], 1'b0, cause[4:0], 2'b0};
	mvp_register #(1) _cpz_fdcint(cpz_fdcint, gfclk, ej_fdc_int && !greset);

	assign cause_code [11:0] = {mpc_gexccode, mpc_cpnm_e, mpc_exccode};
	mvp_ucregister_wide #(12) _cause_h_11_0_(cause_h[11:0],gscanenable, mpc_ldcause, gclk, cause_s);
	assign cause_s [11:0] = mpc_ldcause ? cause_code : cause_h;

	assign cpz_causeap = cause32[24];

	assign cpz_iv = cause_nxt[8];
	assign cpz_iv_w = cause32[23];
	assign hot_iv_w = hot_wr_cause ? cpz[23] : cause32[23];
	assign watch_pend = watch_present & cause32[22];
	assign causedc = cause32[27];

	// Bus sw_int[1:0]: software interrupt bits
	assign sw_int_e [1:0] =	hot_sw_int[1:0] & sw_int_mask_e;
	assign sw_int_m [1:0] =        cause[6:5] & sw_int_mask_m;

	// cpz_swint[1:0]: send software interrupts to external interrupt controller
	assign cpz_swint [1:0] = cause[6:5];

	assign hw_int_e [7:0] = (int_pend_e[7:0] & ~r_pip_e & ~hc_vip_e | internal_int) & int_mask_e;
        assign hw_int_ed [7:0] = (mpc_first_det_int & cpz_pf ? int_pend_e[7:0] & ~r_pip_e & ~hc_vip_e | internal_int
		: int_pend_ed[7:0]) & int_mask_e[7:0] ;

	assign hw_int_m [7:0] = (int_pend_e[7:0] & ~r_pip & ~hc_vip | internal_int) & int_mask_m; 

	assign int_exc_e = eic_mode ? (int_pend_e > int_mask_e) : (hw_int_e != 8'b0) || (sw_int_e  != 2'b0);
	assign int_exc_m = eic_mode ? (int_pend_e > int_mask_m) : (hw_int_m != 8'b0) || (sw_int_m  != 2'b0);
 
	// ext_int: external (and software) interrupts
	assign iret_disable_int_e = mpc_iretval_e & ~cpz_gm_e | hold_iret_disable_int | mpc_hw_load_e;
	assign iret_disable_int_m = mpc_iretval_e & ~cpz_gm_e | hold_iret_disable_int | mpc_atepi_m;
	mvp_cregister #(1) _hold_iret_disable_int(hold_iret_disable_int,(mpc_iretval_e & mpc_run_ie | mpc_hw_load_done | iret_tailchain 
		| mpc_iae_done_exc) & ~cpz_gm_m | greset, gclk, mpc_hw_load_done | mpc_iae_done_exc 
		| iret_tailchain | greset ? 1'b0 : 1'b1);
	assign ext_int_e =      int_enable_e && ejt_dcrinte && int_exc_e && !iret_disable_int_e 
		&& !(mpc_lsdc1_m || cp1_seen_nodmiss_m);
	assign ext_int_excl_ie_e = 	 int_excl_ie_e && ejt_dcrinte && int_exc_e && !iret_disable_int_e;
	assign ext_int_m =      int_enable_m && ejt_dcrinte && int_exc_m && !iret_disable_int_m 
		&& !(mpc_lsdc1_w || cp1_seen_nodmiss_m);

	assign cpz_int_e = ext_int_e || cpz_nmi_e;
	assign cpz_int_excl_ie_e = ext_int_excl_ie_e || cpz_nmi_e;
	assign cpz_int_mw = ext_int_m || cpz_nmi_mw;

	//external interrut request
        assign hw_ext_int_e = int_enable_e && !iret_disable_int_e && ejt_dcrinte && !mpc_squash_e && !mpc_atomic_m
		       && !(mpc_lsdc1_m || cp1_seen_nodmiss_m) && !mpc_dis_int_e && 
			(eic_mode ? (int_pend_e > int_mask_e) : (hw_int_e != 8'b0));
        assign hw_ext_int_m = int_enable_m && !iret_disable_int_m && ejt_dcrinte && !(mpc_lsdc1_w || cp1_seen_nodmiss_m) 
			&& (dcc_intkill_m || dcc_intkill_w || mdu_stall) &&
		       (eic_mode ? (int_pend_e > int_mask_m) : (hw_int_m != 8'b0));
        assign cpz_ext_int = hw_ext_int_e | hw_ext_int_m;
	mvp_cregister #(1) _cpz_iap_um(cpz_iap_um,cpz_ext_int, gclk, usermode); 

	// #################################################################
	// Clock shutdown logic
	// #################################################################
	mvp_register #(1) _raw_cpz_goodnight(raw_cpz_goodnight, gfclk, biu_shutdown && !(wakeup || wakeup_reg) && ~ej_fdc_busy_xx);
	assign cpz_goodnight = raw_cpz_goodnight & ~greset;

	assign wakeup = cpz_int_excl_ie_e || greset  || ejt_ejtagbrk || ej_fdc_int;
	mvp_register #(1) _wakeup_reg(wakeup_reg, gfclk, wakeup);
	
	// #################################################################
        // Instn valid pipe for bds_x updates
	// #################################################################
	assign ie_pipe_in[`M14K_CPZ_IE_IV] = mpc_run_ie && !mpc_squash_i;
	assign instn_vld_e = ie_pipe_out[`M14K_CPZ_IE_IV];

	assign m_pipe_in[`M14K_CPZ_M_IV] = instn_vld_e && mpc_run_ie;
	assign instn_vld_m = m_pipe_out[`M14K_CPZ_M_IV];
	
	mvp_cregister #(1) _instn_vld_w(instn_vld_w,mpc_run_w, gclk, instn_vld_m);
   
	// #################################################################
	// Exception PC stack
	// #################################################################
	// Bus epc_m[31:0]: exception pc stack
	mvp_cregister_wide #(32) _epc_m_31_0_(epc_m[31:0],gscanenable, mpc_run_m, gclk, edp_epc_e);
	mvp_cregister #(1) _eisa_m(eisa_m,mpc_run_m, gclk, edp_eisa_e);

	// Bus epc_w[31:0]: exception pc stack
	mvp_cregister_wide #(32) _epc_w_31_0_(epc_w[31:0],gscanenable, mpc_run_w, gclk, epc_m);
	assign cpz_epc_w [31:0] = epc_w_with_iap;
	mvp_cregister #(1) _eisa_w(eisa_w,mpc_run_w, gclk, eisa_m);
	assign cpz_eisa_w = eisa_w;
	mvp_register #(1) _cpz_eisa_x(cpz_eisa_x, gclk,eisa_w);

	// BDS: Instn has branch delay slot
	assign m_pipe_in[`M14K_CPZ_M_BDS] = mpc_bds_m & ~((mpc_lsdc1_m & mpc_lsdc1_w) & mpc_run_ie);
	assign bds_w = m_pipe_out[`M14K_CPZ_M_BDS];
	
	mvp_cregister #(1) _bds_x(bds_x,mpc_run_w || greset, gclk, bds_w);
	assign cpz_bds_x = bds_x;

	// Bus epc[31:0]: exception PC
	assign wr_epc = mpc_jamepc_w & ~(cpz_exl & ~mpc_atepi_w) | mpc_hw_load_done & ~cpz_gm_w;

	assign epc0_ld = mtcp0_m && (mpc_cp0r_m == 5'd14) && !(mpc_cp0sr_m[2]);	
	assign epc6_ld = mtcp0_m && (mpc_cp0r_m == 5'd14) && (mpc_cp0sr_m[2] && !mpc_cp0sr_m[0]);	
	assign epc7_ld = mtcp0_m && (mpc_cp0r_m == 5'd14) && (mpc_cp0sr_m[2] && mpc_cp0sr_m[0]);	
	// epc_rd: read epc onto cpz line
	assign epc_rd =	mfcp0_m && (mpc_cp0r_m == 5'd14);
	assign epc6_rd =	mfcp0_m && (mpc_cp0r_m == 5'd14) && (mpc_cp0sr_m[2] && !mpc_cp0sr_m[0]);

	// epc_cnxt is also used for ErrorEPC and depc
        assign epc_cnxt [31:0] = (mpc_jamepc_w || mpc_jamdepc_w || mpc_jamerror_w) ? 
			  mpc_atpro_w ? {epc_w[31:1], mpc_isamode_i} :  // bypass isamode when exception is happening w/ iap
			  epc_w[31:0] :
                          mpc_hw_load_done ? {mpc_buf_epc[31:1], (icc_umipspresent | mpc_umipspresent) ? 1'b0 : mpc_buf_epc[0]} :
                          {cpz[31:1], ( (icc_umipspresent | mpc_umipspresent) && !(mpc_cp0sr_m[2])) ? 1'b0 : cpz[0]};
        assign epc_w_with_iap [31:0] = mpc_atpro_w ? epc :  epc_w[31:0]; 


	assign eisa_cnxt =  (mpc_jamepc_w || mpc_jamdepc_w || mpc_jamerror_w) ? 
			mpc_atpro_w ? eisa : // bypass isamode when exception is happening w/ iap
			eisa_w : 
			mpc_hw_load_done ? mpc_buf_epc[0] :
			{ (icc_umipspresent | mpc_umipspresent) ? cpz[0] : 1'b0};

	assign epc_cond = wr_epc || epc0_ld || epc6_ld;
	mvp_cregister_wide #(32) _epc_31_0_(epc[31:0],gscanenable, epc_cond, gclk, epc_cnxt);

	assign eisa_cond = wr_epc || epc0_ld || epc7_ld;
	mvp_cregister #(1) _eisa(eisa,eisa_cond, gclk, eisa_cnxt);

	mvp_cregister #(1) _mpc_ld_causeap_w(mpc_ld_causeap_w,greset|mpc_ld_causeap|mpc_qual_auexc_x, gclk, mpc_ld_causeap & ~mpc_qual_auexc_x);
	assign epc_rd_data [31:0] = {epc[31:1], (epc6_rd || !(icc_umipspresent|mpc_umipspresent)) ? epc[0] : eisa};
	assign nest_wr_epc = mpc_jamepc_w & !mpc_ld_causeap_w | mpc_hw_load_done & ~cpz_gm_w;
	assign epc2_ld = mtcp0_m && (mpc_cp0r_m == 5'd14) && (mpc_cp0sr_m[2:0] == 5'd2);
	assign nestepc_cond = nest_wr_epc || epc2_ld ;
	mvp_cregister_wide #(32) _nestepc_31_0_(nestepc[31:0],gscanenable, nestepc_cond, gclk, epc_cnxt);

	assign nesteisa_cond = nest_wr_epc || epc2_ld;
	mvp_cregister #(1) _nesteisa(nesteisa,nesteisa_cond, gclk, eisa_cnxt);

	assign nestepc_rd_data [31:0] = {nestepc[31:1], !(icc_umipspresent|mpc_umipspresent) ? nestepc[0] : nesteisa};
	mvp_mux2 #(32) _epc_rd_data_nestepc_31_0_(epc_rd_data_nestepc[31:0],mpc_cp0sr_m[1], epc_rd_data, nestepc_rd_data);
	
	//EPC data for HW sequence
        assign cpz_epc_rd_data[31:0] = epc_rd_data;

	// #################################################################
	// depc register
	// #################################################################
	// Bus depc[31:0]: debug exception PC
	assign depc0_ld = mtcp0_m && (mpc_cp0r_m == 5'd24) && !(mpc_cp0sr_m[2] | mpc_cp0sr_m[1] | mpc_cp0sr_m[0]);
	assign depc6_ld = mtcp0_m && (mpc_cp0r_m == 5'd24) && (mpc_cp0sr_m[2] && !mpc_cp0sr_m[0]);
	assign depc7_ld = mtcp0_m && (mpc_cp0r_m == 5'd24) && (mpc_cp0sr_m[2] && mpc_cp0sr_m[0]);

	// depc_rd: read depc register onto cpz line
	assign depc_rd = mfcp0_m && (mpc_cp0r_m == 5'd24) && (mpc_cp0sr_m == 3'h0);	
	assign depc6_rd = mfcp0_m && (mpc_cp0r_m == 5'd24) && (mpc_cp0sr_m[2] && !mpc_cp0sr_m[0]);

	assign wr_depc = mpc_jamdepc_w;

	assign depc_cond = wr_depc || depc0_ld || depc6_ld;

	mvp_cregister_wide #(32) _depc_31_0_(depc[31:0],gscanenable, depc_cond, gclk, (mpc_atpro_w ? epc : epc_cnxt) );

	assign deisa_cond = wr_depc || depc0_ld || depc7_ld;
	mvp_cregister #(1) _deisa(deisa,deisa_cond, gclk, eisa_cnxt);
	
	assign depc_rd_data [31:0] = {depc[31:1], (depc6_rd || !(icc_umipspresent|mpc_umipspresent)) ? depc[0] : deisa};

	// #################################################################
	// epc register
	// #################################################################
	// Bus ErrorPC[31:0]: Error PC
	assign wr_errpc = mpc_jamerror_w;
	assign errpc0_ld = mtcp0_m && (mpc_cp0r_m == 5'd30) && !(mpc_cp0sr_m[2]);	
	assign errpc6_ld = mtcp0_m && (mpc_cp0r_m == 5'd30) && (mpc_cp0sr_m[2] && !mpc_cp0sr_m[0]);	
	assign errpc7_ld = mtcp0_m && (mpc_cp0r_m == 5'd30) && (mpc_cp0sr_m[2] && mpc_cp0sr_m[0]);	
	assign errpc_rd = mfcp0_m && (mpc_cp0r_m == 5'd30);	
	assign errpc6_rd = mfcp0_m && (mpc_cp0r_m == 5'd30) && (mpc_cp0sr_m[2] && !mpc_cp0sr_m[0]);	

	assign errpc_cond = wr_errpc || errpc0_ld || errpc6_ld;
	mvp_cregister_wide #(32) _errpc_31_0_(errpc[31:0],gscanenable, errpc_cond, gclk, (mpc_atpro_w ? epc : epc_cnxt));

	assign errisa_cond = wr_errpc || errpc0_ld || errpc7_ld;
	mvp_cregister #(1) _errisa(errisa,errisa_cond, gclk, eisa_cnxt);
				   

	assign errpc_rd_data [31:0] = {errpc[31:1], (errpc6_rd || !(icc_umipspresent|mpc_umipspresent)) ? errpc[0] : errisa};

	// Bus cpz_eretpc[31:0]: Target PC for ERET or DERET (epc or ErrorPC or depc)
	assign r_eretpc [31:0] = {(mpc_deretval_e ? depc[31:0] : cpz_erl ? errpc[31:0] : epc[31:0])};
	assign cpz_eretpc[31:0] = cpz_gm_e ? g_eretpc : r_eretpc;
	
        assign cpz_iretpc[31:0] = epc[31:0];

	// Target ISA for ERET or DERET
	assign cpz_eretisa = mpc_deretval_e ? deisa : cpz_erl ? errisa : eisa;

	// #################################################################
	// DESAVE register
	// #################################################################
	// wr_desave: write to DESAVE register via MTC0
	assign wr_desave = mtcp0_m & (mpc_cp0r_m == 5'd31) & (mpc_cp0sr_m == 3'd0);

	// desave_rd: read DESAVE register onto cpz line
	assign desave_rd = mfcp0_m & (mpc_cp0r_m == 5'd31);	

	// DESAVE: EJTAG debug mode scratch reg
 	mvp_cregister_wide #(32) _desave_31_0_(desave[31:0],gscanenable, wr_desave, gclk, cpz[31:0]);

	mvp_mux4 #(32) _desave_kscratch_31_0_(desave_kscratch[31:0],mpc_cp0sr_m[1:0], desave, 32'b0, kscratch1, 
					      kscratch2);

	// #################################################################
	// prid register
	// #################################################################
	// prid_ebase_rd: read PRId/ebase onto cpz line
	assign prid_ebase_rd =  mfcp0_m & (mpc_cp0r_m == 5'd15);
	assign ebase_ld = mtcp0_m & (mpc_cp0r_m == 5'd15) & mpc_cp0sr_m[0] & ~mpc_cp0sr_m[1] & ~cdmm_mmulock ;
	assign cdmm_ld = mtcp0_m & (mpc_cp0r_m == 5'd15) & ~mpc_cp0sr_m[0] & mpc_cp0sr_m[1] ;

	wire [31:0] prid32;
	assign cpz_prid16[15:0] = prid32[15:0];
	`M14K_PRID_MODULE cpz_prid (
				.cpz_mmutype(cpz_mmutype),
				.prid32(prid32)
				  );
				
	// ebase: exception vector base and read-only CPU number
	mvp_cregister_wide #(18) _ebase_29_12_(ebase[29:12],gscanenable, greset | ebase_ld, gclk, (greset) ? 18'h0 : cpz[29:12]);

	assign csize_tmp[8:0] = {6'h00, cdmm_mpu_numregion[3:1]} + 9'h03;
	mvp_mux4 #(9) _cdmmsize_8_0_(cdmmsize[8:0],
		{cdmm_mpu_present,fdc_present},
		9'h0,
		9'h02,
		{6'h00, cdmm_mpu_numregion[3:1]},
		csize_tmp
		);			
	mvp_cregister_wide #(32) _cdmmbase_31_0_(cdmmbase[31:0],gscanenable, greset | cdmm_ld, gclk, (greset) ? 
		{21'b000000011111110000010, 1'b0, 1'b0, cdmmsize} : 
		{4'b0, cpz[27:10], 1'b0, cdmmsize});
        assign cpz_cdmmbase [31:15] = cdmmbase [27:11] ;
	assign cpz_cdmm_enable = cdmmbase[10] ; 

	assign cpz_ebase [31:12] = { 2'b10, ebase};
	assign ebase32 [31:0] = {cpz_ebase, 2'b00, siu_cpunum};

	assign prid_ebase [31:0] = mpc_cp0sr_m[1] ? cdmmbase [31:0] :
				mpc_cp0sr_m[0] ? ebase32 : prid32;



	// #################################################################
	// debug:  debug register
	// #################################################################

	// wr_debug: write to debug register via MTC0
	assign wr_debug = mtcp0_m & (mpc_cp0r_m == 5'd23) & (mpc_cp0sr_m == 3'h0) & ~greset;
	assign hot_wr_debug = hot_mtcp0_m & (mpc_cp0r_m == 5'd23) & (mpc_cp0sr_m == 3'h0);

	// debug_rd: read debug register onto cpz line
	assign debug_rd = mfcp0_m & ( (mpc_cp0r_m == 5'd23) | (mpc_cp0r_m == 5'd24) & (mpc_cp0sr_m == 3'h3));	

	assign debug_cnxt [27:0] = wr_debug ? ({ debug2_32[3:0],	     // dbg2 reg
					  debug32[31:30],            // DBD, DM,
					  cpz[28],                   // lsnm
					  debug32[27:26],            // Doze, Halt 
					  cpz[25],                   // countdm
					  mpc_pendibe,               // IBusEP
					  mpc_penddbe,               // DBusEP      
					  cpz[20],                   // iexi
					  debug32[19:18],            // DDBS/L Impr
					  debug32[14:10],            // DExcCode
					  cpz[8],                    // sst,
					  debug32[6:0] }) :      
		     { mpc_jamdepc_w ? cdexc_type_s[3:0] : debug2_32[3:0],		      // dbg2
		       greset ? 1'b0 : mpc_jamdepc_w ? bds_x : debug32[31],                   // DBD
		       (greset | cp0_deret_m) ? 1'b0 : mpc_jamdepc_w ? 1'b1 : debug32[30],    // DM
		       greset ? 1'b0 : debug32[28],                                           // lsnm
		       mpc_jamdepc_w ? dexc_type_s[4] : debug32[27],                          // Doze
		       mpc_jamdepc_w ? dexc_type_s[3] : debug32[26],                          // Halt
		       greset ? 1'b1 : debug32[25],                                           // countdm
		       mpc_pendibe,                                                           // IBusEP
		       mpc_penddbe,                                                           // DBusEP
		       (greset | cp0_deret_m) ? 1'b0 : mpc_jamdepc_w ? 1'b1 : debug32[20] ,   // iexi
		       greset ? 1'b0 : mpc_jamdepc_w ? cdexc_type_s[6] : debug32[19],         // DDBS Impr
		       greset ? 1'b0 : mpc_jamdepc_w ? cdexc_type_s[5] : debug32[18],         // DDBL Impr
		       mpc_jamdepc_w ? cause_s[4:0] : debug32[14:10],                         // Exception Code
		       greset ? 1'b0 : debug32[8],                                            // sst
		       greset ? 1'b0 : mpc_jamdepc_w ? cdexc_type_s[4] : debug32[6],          // DIB Impr
		       mpc_jamdepc_w ? (dexc_type_s[2:0] == 3'h3) : debug32[5],               // DInt
		       mpc_jamdepc_w ? (dexc_type_s[2:0] == 3'h6) : debug32[4],               // DIB
		       mpc_jamdepc_w ? (dexc_type_s[2:0] == 3'h5) : debug32[3],               // DDBS
		       mpc_jamdepc_w ? (dexc_type_s[2:0] == 3'h4) : debug32[2],               // DDBL
		       mpc_jamdepc_w ? (dexc_type_s[2:0] == 3'h2) : debug32[1],               // DBp
		       mpc_jamdepc_w ? (dexc_type_s[2:0] == 3'h1) : debug32[0]                // DSS
		       };
	mvp_ucregister_wide #(28) _debug_27_0_(debug[27:0],gscanenable, debug_cond, gclk, debug_cnxt);
	
	assign be_pend_change = (mpc_pendibe != debug32[24]) || (mpc_penddbe != debug32[21]);
	assign debug_cond = wr_debug || greset || mpc_jamdepc_w || cp0_deret_m || be_pend_change;

	// Uncompressed register
	assign debug32 [31:0] = {debug[23:22], 1'b0, debug[21:17], 2'b0, debug[16:13], `M14K_EJTAG_VER,
			debug[12:8], 1'b0, debug[7], 1'b0, debug[6:0]};
	assign debug2_32 [31:0] = {28'h0, debug[27:24]};

	// Select which debug register to read, either debug32 or pdtrace_cpzout
	assign sel_dbg_m = (mpc_cp0sr_m == 3'h0);
	assign sel_dbg2_m = (mpc_cp0sr_m == 3'h6);
	assign sel_pdt_m = (mpc_cp0sr_m > 3'h0) & (mpc_cp0sr_m < 3'h5);
	mvp_mux1hot_3 #(32) _debugall32_31_0_(debugall32[31:0],sel_dbg_m, debug32,
				    sel_dbg2_m, debug2_32,
				    sel_pdt_m, pdtrace_cpzout);


	assign dexc_type_s [4:0] = mpc_ldcause ? {ej_doze_nxt, ej_halt_nxt, dexc_type} : dexc_type_h;
	mvp_ucregister_wide #(5) _dexc_type_h_4_0_(dexc_type_h[4:0],gscanenable, mpc_ldcause, gclk, dexc_type_s);

	// complex exception type
	assign cdexc_type_s [6:0] = mpc_ldcause ? (ejt_cbrk_type_m | {mpc_atomic_impr, 6'b0})  : cdexc_type_h;
	mvp_ucregister_wide #(7) _cdexc_type_h_6_0_(cdexc_type_h[6:0],gscanenable, mpc_ldcause, gclk, cdexc_type_s);

	assign ej_doze_nxt = cpz_rp || biu_shutdown;
	assign ej_halt_nxt = biu_shutdown;
	mvp_register #(1) _r_doze(r_doze, gfclk, ej_doze_nxt);
	assign cpz_doze = cpz_gm_i ? g_doze : r_doze;
	mvp_register #(1) _cpz_halt(cpz_halt, gfclk, ej_halt_nxt);
	
	assign cpz_dm      = debug32[30];
	assign cpz_lsnm       = debug32[28];

	// Disable Single Step trapping when we are in debug Mode
	assign cpz_sst        = debug32[8] && !cpz_hotdm_i;

	// countdm: Does counter increment in debug mode
	assign countdm = debug32[25];
	
	// cpz_iexi: Imprecise Exception Inhibit - block bus errors in DebugMode
	assign cpz_hotiexi = hot_wr_debug ? cpz[20] : (hot_deret_m) ? 1'b0 : debug32[20];
	assign cpz_iexi = debug32[20];
	mvp_register #(1) _cpz_setibep(cpz_setibep, gclk, wr_debug && cpz[24]);
	mvp_register #(1) _cpz_setdbep(cpz_setdbep, gclk, wr_debug && cpz[21]);

	assign new_nmi = siu_nmi && !nmi_reg;
	mvp_register #(1) _nmi_reg(nmi_reg, gfclk, siu_nmi);
	
	assign pend_nmi = new_nmi || pend_nmi_reg;
	mvp_register #(1) _pend_nmi_reg(pend_nmi_reg, gfclk, pend_nmi && !greset && !mpc_nmitaken);

	assign cpz_nmipend = pend_nmi_reg;

	assign cpz_nmi_e = pend_nmi && ejt_dcrnmie && !cpz_dm_e;
	assign cpz_nmi_mw = pend_nmi && ejt_dcrnmie && !cpz_dm_m;
	
	// #################################################################
        // cpz read bus
	// #################################################################

	// Bus cpz_out[31:0]: stuff driven onto cpz bus 
	// 
	  
 //VCS coverage off 
wire [31:0] 		SelectCount;
                assign SelectCount[31:0] = prid_ebase_rd + epc_rd + badva_badi_badip_rd + status_int_srs_view_ipl_rd + debug_rd + depc_rd + desave_rd +
                              cause_view_ripl_rd + cntxt_rd + count_rd + compare_rd + watch_rd +
                              sec_rd +
                              errctl_rd + taglo_rd + lladdr_rd +
			      cacheerr_rd +
                              xn_rd +
			      config_rd + hwrena_rd + errpc_rd + llbit_rd + perfcnt_rd;

     //VCS coverage on  
  
   // 

	assign guestctl_rd = mfcp0_m & (mpc_cp0r_m == 5'd10) & mpc_cp0sr_m[2];
	mvp_mux4 #(32) _guestctl_123_31_0_(guestctl_123[31:0],mpc_cp0sr_m[1:0], guestctl1_32, eic_mode ? guestctl2_eic : guestctl2_noneic, 
		guestctl3_32, 32'b0);
	assign guestctl0ext_rd = mfcp0_m & (mpc_cp0r_m == 5'd11) & mpc_cp0sr_m[2];

	mvp_mux1hot_24 #(32) _cpz_out_31_0_(cpz_out[31:0],prid_ebase_rd, prid_ebase, 
				epc_rd, epc_rd_data_nestepc,
				 badva_badi_badip_rd, badva_instr_instrp,
				xn_rd, xn,
				guestctl_rd, guestctl_123,
                                status_int_srs_view_ipl_rd, status_int_srs_view_ipl,

				debug_rd, debugall32,
				depc_rd, depc_rd_data,
				desave_rd, desave_kscratch,
                                cause_view_ripl_rd, cause_view_ripl_nestexc32,

				cntxt_rd, cntxt_rd_data,
				count_rd, count,
				compare_rd, compare_guestctl0ext,
				sec_rd, secReg,

				cacheerr_rd, cacheerr_reg,
				
				taglo_rd, taglo32, 
			        lladdr_rd, lladdr32, 
         		        errctl_rd, errctl32, 
				llbit_rd,llbit32,
				watch_rd, watch32,
				config_rd, config_mux,
				hwrena_rd, hwrena32,
                                errpc_rd, errpc_rd_data,
                                perfcnt_rd, perfcnt_rdata);

//VCS coverage off

//VCS coverage on

	// Bus cpz[31:0]: local coprocessor write bus
	assign cpz [31:0] = edp_alu_m;	


	assign cpy2_out = (mpc_cp0r_m[4:2] == 3'b0 | mpc_cp0r_m == 5'd5 | mpc_cp0r_m == 5'd6 | 
		mpc_cp0r_m == 5'd10 & ~mpc_cp0sr_m[2]);


	assign ill_cp0r_m_watch = !watch_present && ((mpc_cp0r_m == 5'd18) || (mpc_cp0r_m == 5'd19));
 
		assign ill_cp0r_m = (mpc_cp0r_m == 5'd20) | (mpc_cp0r_m == 5'd21) | 
					(mpc_cp0r_m == 5'd22) & ~antitamper_present |
					((mpc_cp0r_m == 5'd25) & ~pc_present) | (mpc_cp0r_m == 5'd29) | 
					ill_cp0r_m_watch; 

	// #################################################################
        // cpz_cp0read_m [31:0] which combines CPY and cpz
	// #################################################################
	// cpy_rd: enable CPY cpz_cp0read_m for MFC0
	assign cpy_rd =	mfcp0_m & cpy2_out;

	// Bus cpz_cp0read_m: Munge CPY/cpz buses together
	assign r_cp0read_m [31:0] = cpy_rd ? mmu_r_cpyout : cpz_out;
	assign cpz_cp0read_m[31:0] = r_cp0read_m | g_cp0read_m;

	// #################################################################
	// Watch registers and comparators
	// #################################################################
	assign hot_delay_watch = cpz_hotexl | cpz_hoterl;
	assign hot_ignore_watch = cpz_hotdm_i;
	assign delay_watch = cpz_exl | cpz_erl;
	assign ignore_watch = cpz_dm_m;

	assign watch_rd = watch_present & mfcp0_m & ((mpc_cp0r_m == 5'd18) | (mpc_cp0r_m == 5'd19));
	
	`M14K_CPZ_WATCH_MODULE watch(
			      .gscanenable(gscanenable),	
			      .greset(greset),
			      .gclk( gclk), 
			      .mpc_atomic_m(mpc_atomic_m),		
			      .dcc_dvastrobe(dcc_dvastrobe),
			      .mtcp0_m(mtcp0_m),
			      .mfcp0_m(mfcp0_m),
			      .mpc_cp0r_m(mpc_cp0r_m),
			      .mpc_cp0sr_m(mpc_cp0sr_m),
			      .cpz(cpz),
			      .mmu_asid(mmu_r_asid),
			      .mmu_dva_m(mmu_dva_m),
			      .mpc_squash_i(mpc_squash_i),
			      .mpc_pexc_i(mpc_pexc_i),
			      .hot_ignore_watch(hot_ignore_watch),
			      .mpc_ivaval_i(mpc_ivaval_i),
			      .edp_iva_i(edp_iva_i),
			      .edp_alu_m(edp_alu_m),
			      .mpc_busty_m(mpc_busty_m),
			      .hot_delay_watch(hot_delay_watch),
			      .delay_watch(delay_watch),
			      .ignore_watch(ignore_watch),
			      .cpz_mmutype(cpz_mmutype),
			      .mpc_fixup_m(mpc_fixup_m),
			      .mpc_run_i(mpc_run_i),
			      .mpc_run_ie(mpc_run_ie),
			      .mpc_run_m(mpc_run_m),
			      .mpc_exc_e(mpc_exc_e),
			      .mpc_exc_m(mpc_exc_m),
			      .mpc_exc_w(mpc_exc_w),
			      .watch32(watch32),
			      .cpz_iwatchhit(cpz_iwatchhit),
			      .cpz_dwatchhit(cpz_dwatchhit),
			      .set_watch_pend_w(set_watch_pend_w),
			      .cpz_watch_present__1(watch_present_1),
			      .cpz_watch_present__2(watch_present_2),
			      .cpz_watch_present__3(watch_present_3),
			      .cpz_watch_present__4(watch_present_4),
			      .cpz_watch_present__5(watch_present_5),
			      .cpz_watch_present__6(watch_present_6),
			      .cpz_watch_present__7(watch_present_7),
			      .watch_present(watch_present)
			      );

	assign cpz_wpexc_m = (watch_pend & ~mpc_squash_m & ~ignore_watch) & ~delay_watch; 

	// #################################################################
	// cpz_taglo register and shadowed DataLo register
	// #################################################################
	// cpz_taglo: Used for cacheops
        // Compressed cpz_taglo = {PA[31:10] or LRU[15:10], Valid, Dirty, Lock}
        // Real 32b   cpz_taglo = {PA[31:10] or LRU[15:10], 2'b0, Valid, Dirty, Lock, 5'b0}

        // compressed cpz_taglo[25:0]   PA      WSDP    WSD     LRU     V   D   L   P
        //                             25:4     17:14   13:10   9:4     3   2   1   0
        
        assign taglo_rd = mfcp0_m & (mpc_cp0r_m == 5'd28);
	
	mvp_mux2 #(32) _taglo32_31_0_(taglo32[31:0],mpc_cp0sr_m[0], {cpz_taglo[25:4], 2'b0, cpz_taglo[3:1], 4'b0,cpz_taglo[0]}, cpz_datalo);   

	assign taglo_ld = mtcp0_m & (mpc_cp0r_m == 5'd28) & ~(mpc_cp0sr_m[0]);
	
	assign taglo_cnxt [25:0] = (taglo_ld & ~dmbinvoke) ? {cpz[31:10], cpz[7:5],cpz[0]} :
			    ((icc_icopld | (cpz_wst & icc_icopld_d)) & ~dmbinvoke)  ? 
			    icc_icoptag : dcc_dcoptag_m;

        mvp_register #(1) _dcc_dcopld_md(dcc_dcopld_md, gclk, dcc_dcopld_m);
        mvp_register #(1) _icc_icopld_d(icc_icopld_d, gclk, icc_icopld);

	mvp_cregister_wide #(8) _cpz_taglo_25_18_(cpz_taglo[25:18],gscanenable, taglo_ld | icc_icopld | dcc_dcopld_m , gclk, taglo_cnxt[25:18]);
	mvp_cregister_wide #(8) _cpz_taglo_17_10_(cpz_taglo[17:10],gscanenable, taglo_ld | icc_icopld | dcc_dcopld_m |
					   (dcc_dcopld_md & cpz_wst & ~cpz_spram), gclk, taglo_cnxt[17:10]);

	mvp_cregister_wide #(6) _cpz_taglo_9_4_(cpz_taglo[9:4],gscanenable, taglo_ld | icc_icopld | dcc_dcopld_m | 
					 ((dcc_dcopld_md | icc_icopld_d) & cpz_wst & ~cpz_spram), gclk, 
					 taglo_cnxt[9:4]);  

	mvp_cregister #(1) _cpz_taglo_3_3_(cpz_taglo[3],taglo_ld | icc_icopld | dcc_dcopld_m | dmbinvoke, gclk, taglo_cnxt[3]);
        assign cpz_mbtag[0] = cpz_taglo[3];

   	mvp_cregister #(1) _cpz_taglo_2_2_(cpz_taglo[2],taglo_ld | icc_icopld | dcc_dcopld_md, gclk, cpz_spram ? 1'b0 : taglo_cnxt[2]);
	mvp_cregister #(1) _cpz_taglo_1_1_(cpz_taglo[1],taglo_ld | icc_icopld | dcc_dcopld_m | dmbinvoke, gclk, taglo_cnxt[1]);
	assign cpz_mbtag[1] = cpz_taglo[1];

        mvp_cregister #(1) _cpz_taglo_0_0_(cpz_taglo[0],taglo_ld | icc_icopld | dcc_dcopld_m, gclk, cpz_spram ? 1'b0 : 
		taglo_cnxt[0] & ica_parity_present & dca_parity_present);


	// DataLo: Written on Idx_Ld_Tag cacheops
	assign datalo_ld = mtcp0_m & (mpc_cp0r_m == 5'd28) & (mpc_cp0sr_m[0]);
	
	assign datald_cnxt [31:0] = datalo_ld ? cpz[31:0] :
			   icc_icopld  ? icc_icopdata : dcc_dcopdata_m;

	mvp_cregister_wide #(32) _cpz_datalo_31_0_(cpz_datalo[31:0],gscanenable, datalo_ld | icc_icopld | dcc_dcopld_m, gclk, datald_cnxt);



	// #################################################################
	// errctl:  Cacheop control bits
	// #################################################################
	assign errctl_rd = mfcp0_m & (mpc_cp0r_m == 5'd26);
        assign errctl_ld = mtcp0_m & (mpc_cp0r_m == 5'd26);

	assign errctl_cnxt[3:0] = errctl_ld ? cpz[3:0] : dcc_dcoppar_m;
        assign errctl_cnxt[7:4] = errctl_ld ? cpz[7:4] : icc_icoppar;
	assign errctl_cnxt[11] = cpz[31] & ica_parity_present & dca_parity_present & ~greset;	
	assign errctl_cnxt[10:8] = cpz[30:28] & {3{~greset}};

	mvp_cregister_wide #(4) _errctl_11_8_(errctl[11:8],gscanenable, errctl_ld | greset, gclk,errctl_cnxt[11:8]);
        mvp_cregister_wide #(4) _errctl_7_4_(errctl[7:4],gscanenable, errctl_ld | greset | icc_icopld, gclk, errctl_cnxt[7:4] & {4{~greset}});
        mvp_cregister_wide #(4) _errctl_3_0_(errctl[3:0],gscanenable, errctl_ld | greset | dcc_dcopld_m, gclk, errctl_cnxt[3:0] & {4{~greset}});
        assign errctl32[31:0] = {errctl[11:8], 20'b0, errctl[7:0]};
	
	// parity related control signals
        assign cpz_wst = errctl[9];
        assign cpz_spram = errctl[8];
        assign cpz_pe = errctl[11];
        assign cpz_po = errctl[10];
        assign cpz_pd[3:0] = errctl[3:0];
        assign cpz_pi[3:0] = errctl[7:4];

	
	mvp_cregister #(1) _cpz_kuc_w(cpz_kuc_w,mpc_run_m, gclk, cpz_kuc_m);
	
	// #################################################################
	// config register and shadowed config1 register
	// #################################################################
	assign config_ld  = 	mtcp0_m & (mpc_cp0r_m == 5'd16) & (mpc_cp0sr_m[2:0] == 3'b0);
	assign cpz_config_ld = config_ld;
	assign config1_ld = 	mtcp0_m & (mpc_cp0r_m == 5'd16) & (mpc_cp0sr_m[2:0] == 3'b001);

        assign config3_ld =    mtcp0_m & (mpc_cp0r_m == 5'd16) & (mpc_cp0sr_m[2:0] == 3'b011);

        assign config5_ld =    mtcp0_m & (mpc_cp0r_m == 5'd16) & (mpc_cp0sr_m[2:0] == 3'b101);

        assign config6_ld =    mtcp0_m & (mpc_cp0r_m == 5'd16) & (mpc_cp0sr_m[2:0] == 3'b110) & cp1_coppresent;

	assign config_rd =	mfcp0_m & (mpc_cp0r_m == 5'd16);

	// Static cache configuration inputs driven from cache module
	mvp_cregister_wide #(14) _config7_hci_udi_present_reg_ic_present_reg_dc_present_reg_ic_ssize_reg_1_0_dc_ssize_reg_1_0_ic_nsets_reg_2_0_dc_nsets_reg_2_0({config7_hci,
	 udi_present_reg,
	 ic_present_reg,
	 dc_present_reg,
	 ic_ssize_reg[1:0],
	 dc_ssize_reg[1:0],
	 ic_nsets_reg[2:0],
	 dc_nsets_reg[2:0]}, gscanenable, greset, gclk, {dc_hci & ic_hci,   
									edp_udi_present, 	
									ic_present,     	
									dc_present,     	
									ic_ssize[1:0],     
									dc_ssize[1:0],     
									ic_nsets[2:0],     
	  								dc_nsets[2:0]});   

			  
	// Write-able bits in config0
	//  K23 [30:28]: cache coherence attributes for kseg2/3 regions in fixed mmu mode
	//  KU  [27:25]: cache coherence attributes for useg/kuseg regions in fixed mmu mode
	//  WC  [19]: indicates that cache configuration bits in config1 are writeable
	//  K0 [2:0]: cache coherence attributes for kseg0 region
	//  mmu_r_type[1]  [8]: mmu_r_type is writeable if WC bit is set
	// greset initializes WC to 0 and K23/KU/K0 bits to uncached
        assign config0w_cnxt [9:0] =	greset ? {(mmu_r_type ? {3'h2, 3'h2} : {6'h0}), 1'b0, 3'h2} :
			   {cpz_mmutype ? cpz[30:25] : 6'h0, cpz[19], cpz[2:0]} ;
   
	mvp_cregister_wide #(10) _config0w_9_0_(config0w[9:0],gscanenable, greset | config_ld, gclk, config0w_cnxt);

	assign mmutypec_nxt = greset ? mmu_r_type :
		       config_ld & config0[19] ? cpz[8] :
		       cpz_mmutype;

	mvp_register #(1) _cpz_mmutype(cpz_mmutype, gclk, mmutypec_nxt);
	
	// Static bits in config0
	assign config0static_m		= 1'b1;
	assign siu_lamebus = 1'b1;

	assign config0static_hi [24:20] = {
				    icc_sp_pres,                  // ISPRAM is present
				    dcc_sp_pres,                  // DSPRAM is present
				    udi_present_reg,    // UDI Present
				    siu_lamebus,         // simplebe mode
				    mdu_type};            // mdu_type: 1 - Lite, 0 - Full

	assign biu_sblock = 1'b0;

	assign config0static_lo [18:3] = {
				   biu_merging, 1'b0,  	// [18:17] write-through buffer merging mode:
							//    (2: full merging, 0: no merging)
				biu_sblock,		// [16] burst mode (1: subblock, 0: sequential)
				siu_bigend,		// [15] BE bit1'b
				2'h0,			// AT field, forced to MIPS32
				`M14K_ARCHREV,		// AR field
				{1'h0, cpz_mmutype, 1'h1},	// MT field FIXED=011, TLB=001
				4'b0};			// bits [6:3]

	assign config0 [31:0] = {config0static_m,              // [31] - M bit
			  config0w[9:4],                // [30:25] - K23/KU
			  config0static_hi,             // [24:20]
			  config0w[3],                  // [19] - WC
			  config0static_lo,             // [18:3] 
			  config0w[2:0]};               // [2:0] - K0
	assign cpz_isppresent = config0[24];
	assign cpz_dsppresent = config0[23];

        // KSeg cache attributes
        assign cpz_k0cca[2:0] = config0[2:0];
        assign cpz_k23cca[2:0] = config0[30:28];
        assign cpz_kucca[2:0] = config0[27:25];
   
   
	// cpz_enm: BE bit, (Big-Endian Memory)
	assign cpz_enm = config0[15];

	// config1 register (shadow register behind config).

	assign config1w_cnxt [13:0] = 	greset ? {
					        mmu_r_size,               // MMUSize[4:3]
						ic_nsets_reg,	        // IS: Icache sets per way
						ic_present_reg,         // IL: Icache line size (16b)
						ic_ssize_reg,		// IA: Icache associativity
						dc_nsets_reg,		// DS: Dcache sets per way
						dc_present_reg,         // DL: Dcache line size (16b)
						dc_ssize_reg } :	// DA: Dcache associativity
			     			{ cpz[29:28],              // MMUSize[4:3]
						  cpz[24:22],		// IS: Icache sets per way
			       			cpz[19],                // IL: Icache line size (16b)
			       			cpz[17:16],		// IA: Icache associativity
			      			cpz[15:13],		// DS: Dcache sets per way
			       			cpz[10],                // DL: Dcache line size (16b)
						  cpz[8:7] }; 		// DA: Dcache associativity
	mvp_cregister_wide #(14) _config1w_13_0_(config1w[13:0],gscanenable, greset | (config1_ld & config0[19]), gclk, config1w_cnxt);

	assign config1 [31:0] = {
			  1'b1,                        // config2 present
			  cpz_mmutype & ~cpz_vz ? 6'h0 : 
			  {1'b0, config1w[13:12], 3'h7},  // No of MMU entries - 1
			  config1w[11:9],              // IS: Icache sets per way
			  1'b0, {2{config1w[8]}},      // IL: Icache line size 16b/No $
			  1'b0, config1w[7:6],         // IA: Icache associativity
			  config1w[5:3],               // DS: Dcache sets per way
			  1'b0, {2{config1w[2]}},      // DL: Dcache line size 16b/No $
			  1'b0, config1w[1:0],         // DA: Dcache associativity
			  cp2_coppresent,              // C2: Co-Processor 2 is pressent
			  1'h0,	                       // MD: No MDMX support
			  pc_present,		       // PC: Is Preformance Counters implemented	
			  watch_present,               // WR: Is watch register implemented
                          1'b0,                        // CA: m16 code compression

			  1'h1,	                       // EP: Ejtag present
			  cp1_coppresent};	       // FP: fpu present
			  
	// Cache configuration control from config1
	assign cpz_icnsets [2:0] = config1[24:22];
	assign cpz_icpresent = config1[20:19] == 2'b11;
	assign cpz_icssize [1:0] = config1[17:16];
	assign cpz_dcnsets [2:0] = config1[15:13];
	assign cpz_dcpresent = config1[11:10] == 2'b11;
	assign cpz_dcssize [1:0] = config1[8:7];
	assign cpz_mmusize[1:0] = config1[29:28];
	
	assign config2[31:0] = {
			 1'b1,                         // config3 present
			 31'h00000000
			 };

        assign config3_bootisa = mpc_umipspresent | icc_umipspresent & siu_bootexcisamode;
        assign config3_excisa_cnxt = greset ? config3_bootisa : cpz[16];
	mvp_cregister #(1) _config3_excisa_disa(config3_excisa_disa,greset | config3_ld & icc_umipspresent, 
		gclk, config3_excisa_cnxt);
	assign config3_excisa = mpc_umipspresent || (config3_excisa_disa && icc_umipspresent);
	assign config3_dual_isa = icc_umipspresent;

	assign config3[31:0] = {
			 1'b1,                         // config4 is present
			 3'b0,				
			 cpz_vz,                         // BP
			 cpz_vz,                         // BI
			 2'b0,
			 vz_present,			// virtualization present
			 2'b1,				//width of IPL/RIPL fields
                         3'b0,
			  1'b1,				// MuCon ASE
                         config3_excisa,                // external input defines what isamode on execeptions. writeable by software.
			 config3_dual_isa,		// ISA: 1'b1 if both M32 and umips are present.
                         config3_bootisa,               // if both M32 and umips are present, ISA for boot based on external input, else, based on either M32 or umips, whichever is implemented
                         1'b1,                          // ULRI: UserLocal Register Implemented
			~cpz_mmutype | cpz_vz,		// RIXI: RIE and XIE are implemented in PageGrain
			edp_dsp_present_xx,
			edp_dsp_present_xx,
			1'b0,

			 ejt_pdt_present[1],		// ITLP: Insttruction Tracing logic present
			 1'b0,
			 siu_eicpresent, 1'b1,		// VEIC, VInt
			 cpz_smallpage,			// Small (1KB) page support
			 cdmm_mpu_present|fdc_present,	// CDMM implemented
			 1'b0,

			 1'b0,

			 ejt_pdt_present[0]            // TLP: Tracing logic present
			 };

	assign cpz_vz = config3[23];
        assign cpz_excisamode = config3[16];
        assign cpz_bootisamode = config3[14];

	assign config4[31:0] = {
			 1'b1,                         // config5 present
			 1'b0,				// IE
			 cpz_vz,			// IE
			 9'b0,
			 cpz_vz,			// kscratch2 present
			 cpz_vz,			// kscratch1 present
			 18'b0
			 };

	mvp_cregister #(1) _cpz_ufr(cpz_ufr,greset | config5_ld, gclk, greset ? 1'b0 : cp1_ufrp & cpz[2]);
	assign config5[31:0] = {
			29'b0, 
			cpz_ufr,
			1'b0,
			1'b1				// Nested exception feature implemented
			};


	assign config6[31:0] = {
			3'b0,
			cpz_mnan,
			28'b0
			} & {32{cp1_coppresent}};

	mvp_cregister #(1) _cpz_mnan(cpz_mnan,greset | config6_ld, gclk, greset ? 1'b0 : cpz[28]);

	// Small (1KB) page support

	wire	smallpage;
	`M14K_MMU_SMALLPAGE_SUPPORT sps(.smallpage(smallpage));
	assign cpz_smallpage = smallpage & (~cpz_mmutype | cpz_vz);


	// Mux between the config registers for move from instruction.
	mvp_mux8 #(32) _config_mux_31_0_(config_mux[31:0],mpc_cp0sr_m[2:0], config0, config1, config2, config3, 
						   config4, config5, config6, config7);

	assign config7[31:0] = {
			 1'b1,            // 31: WII
			 12'b0,
			 config7_hci,     // 18: Hardware Cache Init
			 18'b0
			 };

	// #################################################################
	// hardware enable register
	// #################################################################

	assign hwrena_rd =  mfcp0_m & (mpc_cp0r_m == 5'd7);
	assign hwrena_ld =  mtcp0_m & (mpc_cp0r_m == 5'd7);

	mvp_cregister_wide #(5) _cpz_hwrena_29_cpz_hwrena_3_0({cpz_hwrena_29,
	 cpz_hwrena[3:0]}, gscanenable, greset | hwrena_ld, 
					   gclk, (greset) ? 5'h0 : {cpz[29],cpz[3:0]});

	mvp_mux4 #(32) _hwrena32_31_0_(hwrena32[31:0],mpc_cp0sr_m[1:0], { 2'b0, cpz_hwrena_29, 25'h0, cpz_hwrena }, 
			                         count_resolution, 
			                         {22'b0, ebase32[9:0]},  
                                                 synci_step);

	assign synci_step [31:0] = ((config1[21:19] == 3'b000) & (config1[12:10] == 3'b000)) ? 32'd0 : 32'd16;


	// #################################################################
	// LL address register
	// #################################################################
	mvp_cregister #(1) _ll_w(ll_w,mpc_run_w, gclk, mpc_ll_m & mpc_run_m & ~cpz_gm_m);
	assign setll_w = ll_w & ~mpc_exc_w & mpc_run_w;
	
	assign llbit_rd = (~movefcp0_m | cpy2_out & ~mpc_g_cp0move_m | ill_cp0r_m) & ~cpz_gm_m;  

	assign llbit32 [31:0] = {31'h0, cpz_llbit};
	
        assign cpz_llbit = mpc_ll_m & ~cpz_gm_m | (arch_llbit & ~cpz_eret_m & ~cp0_eret_w & ~cpz_iret_m & ~cp0_iret_w)
                    | (ll_w & ~cpz_eret_m & ~cpz_iret_m);

        assign arch_llbit_nxt = setll_w | (arch_llbit & ~((cp0_eret_w | cp0_iret_w) & ~mpc_exc_w));
        mvp_register #(1) _arch_llbit(arch_llbit, gclk, arch_llbit_nxt);


	assign lladdr_rd = mfcp0_m & (mpc_cp0r_m == 5'd17);

	mvp_cregister_wide #(28) _lladdr_27_0_(lladdr[27:0],gscanenable, setll_w, gclk, lladdr_s[27:0]);
	mvp_cregister_wide #(28) _lladdr_s_27_0_(lladdr_s[27:0],gscanenable, mpc_ll1_m, gclk, mmu_r_cpyout[27:0]);

	assign lladdr32 [31:0] = {4'h0, lladdr};



	assign cacheerr_rd = mfcp0_m && (mpc_cp0r_m == 5'd27);
	
	assign dcc_error   = (dcc_parerr_cpz_w | dcc_parerr_m & ~icc_parerr_cpz_w);
	assign cacheerr_er = dcc_error ? 1'b1 : 1'b0;
	assign cacheerr_ec = 1'b0;

	assign cacheerr_ed = (icc_parerr_data & !dcc_error) | dcc_parerr_data;	// D$ error has higher priority
	assign cacheerr_et = (icc_parerr_tag & !dcc_error) | dcc_parerr_tag;	// D$ error has higher priority
	assign cacheerr_es = 1'b0;	// Error source, always internal request
	assign cacheerr_ee = 1'b0;	// Error external, not supported
	assign cacheerr_eb = (dcc_parerr_cpz_w | dcc_parerr_m) && (qual_iparerr_i | qual_iparerr_w);
	assign cacheerr_ef = dcc_parerr_ev;
	assign cacheerr_sp = (dsp_data_parerr | isp_data_parerr);
	assign cacheerr_ew = dcc_parerr_ws;  
	assign cacheerr_way[1:0] = dcc_error ? dcc_derr_way : icc_derr_way;
	assign cacheerr_idx[19:0] = dcc_error? dcc_parerr_idx : icc_parerr_idx;
	
	assign cache_err = qual_iparerr_i | qual_iparerr_w | dcc_parerr_m | dcc_parerr_cpz_w;

	mvp_cregister_wide #(32) _cacheerr_reg_31_0_(cacheerr_reg[31:0],gscanenable, cache_err, gclk, {cacheerr_er, cacheerr_ec,
									  cacheerr_ed, cacheerr_et,
                                                                          cacheerr_es, cacheerr_ee,
                                                                          cacheerr_eb, cacheerr_ef,
                                                                          cacheerr_sp, cacheerr_ew,
                                                                          cacheerr_way[1:0],
                                                                          cacheerr_idx[19:0]});

	


	// #################################################################
	//view_ipl:  view_ipl register
	// #################################################################
	mvp_register #(1) _eic_mode_reg(eic_mode_reg, gclk, hot_eic_mode);
	assign enter_eic_mode = hot_eic_mode & ~eic_mode_reg;
	assign exit_eic_mode = ~hot_eic_mode & eic_mode_reg;

	assign wr_view_ipl = status_int_srs_view_ipl_ld & (mpc_cp0sr_m[2:0] == 3'h4) & ~greset;
	assign hot_wr_view_ipl = mpc_wr_view_ipl_m & mpc_cp0move_m & ~cpz_gm_m & (mpc_cp0sr_m[2:0] == 3'h4);

	assign view_ipl_raw[9:0] = wr_view_ipl ? cpz[9:0] : 
			    wr_status ? {cpz[18], cpz[16:8]} :
	                    mpc_hw_load_done | mpc_load_status_done & mpc_chain_take ? 
				{mpc_buf_status[18], mpc_buf_status[16:8]} :  
			    {mpc_hw_save_done ? cpz_ipl : iret_tailchain ? int_pend_ed : 
			    view_ipl[9:2], view_ipl[1:0]}; 
	assign hot_eic_mode = siu_eicpresent & ~hot_bev & hot_iv_w & (hot_vs[4:0] != 5'b0);
	assign view_ipl_nxt[9:0] = {view_ipl_raw[9:2], hot_eic_mode ? 2'b0 : exit_eic_mode ? status32[9:8] 
		: view_ipl_raw[1:0]};

	assign view_ipl_cond = wr_view_ipl | (mpc_hw_save_done | mpc_hw_load_done | mpc_load_status_done) & 
		~cpz_gm_w | wr_status | iret_tailchain | enter_eic_mode | exit_eic_mode;

	mvp_cregister_wide #(10) _view_ipl_9_0_(view_ipl[9:0],gscanenable, view_ipl_cond, gclk, view_ipl_nxt);

	assign view_ipl32[31:0] = {22'b0, view_ipl};


	// #################################################################
	//view_ripl:  view_ripl register
	// #################################################################
	assign wr_view_ripl = mtcp0_m & (mpc_cp0r_m == 5'd13) & (mpc_cp0sr_m[2:0] == 3'h4); 

	assign view_ripl_nxt[1:0] = wr_view_ripl ? cpz[1:0] : wr_cause ? cpz[9:8] : view_ripl32[1:0];

	assign view_ripl_cond = wr_view_ripl | wr_cause;

	mvp_cregister #(2) _view_ripl_1_0_(view_ripl[1:0],view_ripl_cond, gclk, view_ripl_nxt);

	assign view_ripl32[31:0] = {22'b0, causeip, view_ripl};


	mvp_cregister #(1) _cpz_takeint(cpz_takeint,greset | mpc_jamepc_w | mpc_qual_auexc_x, gclk, ~greset &
	                             (mpc_jamepc_w ? (cause_s[4:0] == 5'd0) :
	                             mpc_qual_auexc_x ? 1'b0 : cpz_takeint));

	assign at_pro_en = mpc_jamepc_w & (cause_s[4:0] == 5'd0) & eic_mode & intctl_ap
                        & (r_srsctl[29:26] > 4'b0);
	assign at_epi_en = intctl_ap & eic_mode & (r_srsctl[29:26] > 4'b0);
	mvp_register #(1) _cpz_at_epi_en(cpz_at_epi_en, gclk, at_epi_en);
	mvp_register #(1) _at_pro_en_reg(at_pro_en_reg, gclk, at_pro_en | at_pro_en);
	mvp_register #(1) _hold_at_pro_en(hold_at_pro_en, gclk, (at_pro_en_reg | hold_at_pro_en) & ~mpc_qual_auexc_x);
        assign cpz_at_pro_start_i = (at_pro_en_reg | hold_at_pro_en) & mpc_qual_auexc_x;
        assign cpz_at_pro_start_val = at_pro_en_reg | hold_at_pro_en;

	mvp_register #(1) _load_status_done_reg(load_status_done_reg, gclk, mpc_load_status_done & ~cpz_gm_m);
	assign iret_tailchain = mpc_chain_take & load_status_done_reg;
	assign iret_tailchain_pre = mpc_chain_take & mpc_load_status_done;
	mvp_register #(1) _cpz_iret_chain_reg(cpz_iret_chain_reg, gclk, iret_tailchain | g_iret_tailchain);

	mvp_register #(1) _iret_ret_start_reg(iret_ret_start_reg, gclk, mpc_iret_ret_start);
	assign iret_ret = iret_ret_start_reg | hold_iret_ret;
	mvp_register #(1) _hold_iret_ret(hold_iret_ret, gclk, iret_ret & ~mpc_run_m);

	// #################################################################
	//kscratch1:  kscratch1 register
	// #################################################################
	assign wr_kscratch1 = mtcp0_m & (mpc_cp0r_m == 5'd31) & (mpc_cp0sr_m[2:0] == 3'h2); 

	assign kscratch1_nxt[31:0] = greset ? 31'b0 : wr_kscratch1 ? cpz : kscratch1;
	assign kscratch1_cond = greset | wr_kscratch1;
	mvp_cregister_wide #(32) _raw_kscratch1_31_0_(raw_kscratch1[31:0],gscanenable, kscratch1_cond, gclk, kscratch1_nxt);
	assign kscratch1[31:0] = cpz_vz ? raw_kscratch1 : 32'b0;

	// #################################################################
	//kscratch2:  kscratch2 register
	// #################################################################
	assign wr_kscratch2 = mtcp0_m & (mpc_cp0r_m == 5'd31) & (mpc_cp0sr_m[2:0] == 3'h3); 

	assign kscratch2_nxt[31:0] = greset ? 31'b0 : wr_kscratch2 ? cpz : kscratch2;
	assign kscratch2_cond = greset | wr_kscratch2;
	mvp_cregister_wide #(32) _raw_kscratch2_31_0_(raw_kscratch2[31:0],gscanenable, kscratch2_cond, gclk, kscratch2_nxt);
	assign kscratch2[31:0] = cpz_vz ? raw_kscratch2 : 32'b0;

	assign perfcnt_rd = mfcp0_m && (mpc_cp0r_m == 5'd25) && pc_present;
	//scfail_e = mpc_sc_e & ~cpz_llbit; // PerfCnt1.Event[19]
	assign scfail_e_root = mpc_sc_e & ~cpz_llbit; 
	assign scfail_e_guest = mpc_sc_e & ~cpz_g_llbit;
	assign scfail_e = cpz_vz & cpz_gm_e ? scfail_e_guest : scfail_e_root; // PerfCnt1.Event[19]
	assign dcc_pm_dcmiss = dcc_pm_dcmiss_pc; // PerfCnt0/1.Event[11]
	assign cpz_gm = guestctl0_32[31];

//mpc_eret_w = register(gclk, mpc_eret_m);
//mpc_g_eret_w =  register(gclk, mpc_g_eret_m); 
//cpz_g_status_reg[31:0] = register(gclk, cpz_g_status);
//status32_reg[31:0] = register(gclk, status32);
//cpz_g_status_pc[31:0] = mpc_g_eret_w ? cpz_g_status_reg : cpz_g_status;
//status32_pc[31:0] = mpc_eret_w ? status32_reg : status32; 
	
/*hookup*/
`M14K_PC_MODULE  cpz_pc(
	.badva(badva),
	.biu_pm_wr_buf_b(biu_pm_wr_buf_b),
	.biu_pm_wr_buf_f(biu_pm_wr_buf_f),
	.biu_wtbf(biu_wtbf),
	.brk_d_trig(brk_d_trig),
	.brk_i_trig(brk_i_trig),
	.bstall_ie(bstall_ie),
	.cause_s(cause_s),
	.cp2_coppresent(cp2_coppresent),
	.cp2_stall_e(cp2_stall_e),
	.cpz(cpz),
	.cpz_cause_pci(cpz_cause_pci),
	.cpz_dm(cpz_dm),
	.cpz_eisa_x(cpz_eisa_x),
	.cpz_g_status(cpz_g_status),
	.cpz_gm(cpz_gm),
	.cpz_gm_e(cpz_gm_e),
	.cpz_gm_i(cpz_gm_i),
	.cpz_gm_m(cpz_gm_m),
	.cpz_gm_w(cpz_gm_w),
	.cpz_gm_x(cpz_gm_x),
	.cpz_goodnight(cpz_goodnight),
	.cpz_pc_ctl0_ec1(cpz_pc_ctl0_ec1),
	.cpz_pc_ctl1_ec1(cpz_pc_ctl1_ec1),
	.cpz_vz(cpz_vz),
	.dcc_dcached_m(dcc_dcached_m),
	.dcc_dcop_stall(dcc_dcop_stall),
	.dcc_dmiss_m(dcc_dmiss_m),
	.dcc_dspram_stall(dcc_dspram_stall),
	.dcc_lscacheread_m(dcc_lscacheread_m),
	.dcc_pm_dcmiss(dcc_pm_dcmiss),
	.dcc_pm_dhit_m(dcc_pm_dhit_m),
	.dcc_pm_fb_active(dcc_pm_fb_active),
	.dcc_pm_fbfull(dcc_pm_fbfull),
	.dcc_sp_pres(dcc_sp_pres),
	.dcc_stall_m(dcc_stall_m),
	.dcc_trstb(dcc_trstb),
	.dcc_twstb(dcc_twstb),
	.dcc_uncache_load(dcc_uncache_load),
	.dcc_uncached_store(dcc_uncached_store),
	.dcc_wb(dcc_wb),
	.edp_udi_stall_m(edp_udi_stall_m),
	.g_badva(g_badva),
	.g_cause_pci(g_cause_pci),
	.g_cause_s(g_cause_s),
	.g_eic_mode(g_eic_mode),
	.g_pc_present(cpz_g_pc_present),
	.gclk(gclk),
	.gfclk(gfclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.icc_drstb(icc_drstb),
	.icc_fb_vld(icc_fb_vld),
	.icc_icopstall(icc_icopstall),
	.icc_imiss_i(icc_imiss_i),
	.icc_sp_pres(icc_sp_pres),
	.icc_spram_stall(icc_spram_stall),
	.icc_stall_i(icc_stall_i),
	.icc_trstb(icc_trstb),
	.icc_twstb(icc_twstb),
	.icc_umipsfifo_null_w(icc_umipsfifo_null_w),
	.mdu_busy(mdu_busy),
	.mdu_result_done(mdu_result_done),
	.mdu_stall(mdu_stall),
	.mfcp0_m(mfcp0_m),
	.mmu_asid(mmu_asid),
	.mmu_dcmode0(mmu_dcmode0),
	.mmu_icacabl(mmu_icacabl),
	.mmu_pm_dthit(mmu_pm_dthit),
	.mmu_pm_dtlb_miss_qual(mmu_pm_dtlb_miss_qual),
	.mmu_pm_dtmiss(mmu_pm_dtmiss),
	.mmu_pm_ithit(mmu_pm_ithit),
	.mmu_pm_itmiss(mmu_pm_itmiss),
	.mmu_pm_jthit_d(mmu_pm_jthit_d),
	.mmu_pm_jthit_i(mmu_pm_jthit_i),
	.mmu_pm_jtmiss_d(mmu_pm_jtmiss_d),
	.mmu_pm_jtmiss_i(mmu_pm_jtmiss_i),
	.mmu_r_asid(mmu_r_asid),
	.mmu_r_dtexc_m(mmu_r_dtexc_m),
	.mmu_r_dtriexc_m(mmu_r_dtriexc_m),
	.mmu_r_itexc_i(mmu_r_itexc_i),
	.mmu_r_itxiexc_i(mmu_r_itxiexc_i),
	.mmu_r_pm_jthit_d(mmu_r_pm_jthit_d),
	.mmu_r_pm_jthit_i(mmu_r_pm_jthit_i),
	.mmu_r_pm_jtmiss_d(mmu_r_pm_jtmiss_d),
	.mmu_r_pm_jtmiss_i(mmu_r_pm_jtmiss_i),
	.mpc_alu_w(mpc_alu_w),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_auexc_on(mpc_auexc_on),
	.mpc_br_e(mpc_br_e),
	.mpc_bubble_e(mpc_bubble_e),
	.mpc_cp0move_m(mpc_cp0move_m),
	.mpc_cp0r_m(mpc_cp0r_m),
	.mpc_cp0sr_m(mpc_cp0sr_m[1:0]),
	.mpc_cp2a_e(mpc_cp2a_e),
	.mpc_cp2tf_e(mpc_cp2tf_e),
	.mpc_dec_nop_w(mpc_dec_nop_w),
	.mpc_deret_m(mpc_deret_m),
	.mpc_dmsquash_m(mpc_dmsquash_m),
	.mpc_eret_m(mpc_eret_m),
	.mpc_exc_type_w(mpc_exc_type_w),
	.mpc_exc_w(mpc_exc_w),
	.mpc_fixupd(mpc_fixupd),
	.mpc_fixupi(mpc_fixupi),
	.mpc_g_auexc_x(mpc_g_auexc_x),
	.mpc_g_cp0move_m(mpc_g_cp0move_m),
	.mpc_gpsi_perfcnt(mpc_gpsi_perfcnt),
	.mpc_iret_m(mpc_iret_m),
	.mpc_jimm_e(mpc_jimm_e),
	.mpc_jreg31_e(mpc_jreg31_e),
	.mpc_jreg31non_e(mpc_jreg31non_e),
	.mpc_ld_m(mpc_ld_m),
	.mpc_ldst_e(mpc_ldst_e),
	.mpc_load_m(mpc_load_m),
	.mpc_ltu_e(mpc_ltu_e),
	.mpc_mcp0stall_e(mpc_mcp0stall_e),
	.mpc_pm_complete(mpc_pm_complete),
	.mpc_pm_muldiv_e(mpc_pm_muldiv_e),
	.mpc_pref_m(mpc_pref_m),
	.mpc_pref_w(mpc_pref_w),
	.mpc_r_auexc_x(mpc_r_auexc_x),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_run_w(mpc_run_w),
	.mpc_sc_m(mpc_sc_m),
	.mpc_st_m(mpc_st_m),
	.mpc_stall_ie(mpc_stall_ie),
	.mpc_stall_m(mpc_stall_m),
	.mpc_stall_w(mpc_stall_w),
	.mpc_strobe_e(mpc_strobe_e),
	.mpc_strobe_m(mpc_strobe_m),
	.mpc_strobe_w(mpc_strobe_w),
	.mpc_tlb_d_side(mpc_tlb_d_side),
	.mpc_tlb_i_side(mpc_tlb_i_side),
	.mtcp0_m(mtcp0_m),
	.pc_present(pc_present),
	.perfcnt_rdata(perfcnt_rdata),
	.scfail_e(scfail_e),
	.status32(status32));

/*hookup*/
`M14K_CPZ_ROOT_MODULE cpz_vz_root(
	.cause_s(cause_s),
	.cpz(cpz),
	.cpz_at(cpz_at),
	.cpz_bg(cpz_bg),
	.cpz_cf(cpz_cf),
	.cpz_cg(cpz_cg),
	.cpz_cgi(cpz_cgi),
	.cpz_cp0(cpz_cp0),
	.cpz_drg(cpz_drg),
	.cpz_eic_offset(cpz_eic_offset),
	.cpz_gid(cpz_gid),
	.cpz_gm_m(cpz_gm_m),
	.cpz_gt(cpz_gt),
	.cpz_mg(cpz_mg),
	.cpz_og(cpz_og),
	.cpz_ri(cpz_ri),
	.cpz_rid(cpz_rid),
	.eic_mode(eic_mode),
	.fcd(fcd),
	.gclk(gclk),
	.geicss(geicss),
	.glss(glss),
	.greset(greset),
	.gripl(gripl),
	.gripl_clr(gripl_clr),
	.gscanenable(gscanenable),
	.gtoffset(gtoffset),
	.guestctl0_32(guestctl0_32),
	.guestctl0_mc(guestctl0_mc),
	.guestctl0ext_32(guestctl0ext_32),
	.guestctl1_32(guestctl1_32),
	.guestctl2_eic(guestctl2_eic),
	.guestctl2_noneic(guestctl2_noneic),
	.guestctl3_32(guestctl3_32),
	.gvec(gvec),
	.hc_vip(hc_vip),
	.hc_vip_e(hc_vip_e),
	.hot_drg(hot_drg),
	.hot_wr_guestctl0(hot_wr_guestctl0),
	.hot_wr_guestctl2_noneic(hot_wr_guestctl2_noneic),
	.int_gid_ed(int_gid_ed),
	.int_offset_ed(int_offset_ed),
	.int_pend_e(int_pend_e),
	.int_pend_ed(int_pend_ed),
	.int_ss_ed(int_ss_ed),
	.int_vector_ed(int_vector_ed),
	.mmu_gid(mmu_gid),
	.mmu_r_read_m(mmu_r_read_m),
	.mmu_r_type(mmu_r_type),
	.mmu_read_m(mmu_read_m),
	.mmu_rid(mmu_rid),
	.mpc_cp0move_m(mpc_cp0move_m),
	.mpc_cp0r_m(mpc_cp0r_m),
	.mpc_cp0sr_m(mpc_cp0sr_m),
	.mpc_ge_exc(mpc_ge_exc),
	.mpc_jamepc_w(mpc_jamepc_w),
	.mpc_wr_guestctl0_m(mpc_wr_guestctl0_m),
	.mpc_wr_guestctl2_m(mpc_wr_guestctl2_m),
	.mtcp0_m(mtcp0_m),
	.r_gtoffset(r_gtoffset),
	.r_pip(r_pip),
	.r_pip_e(r_pip_e),
	.sfc1(sfc1),
	.sfc2(sfc2),
	.siu_srsdisable(siu_srsdisable),
	.srsctl_vec2css_w(srsctl_vec2css_w),
	.vip(vip),
	.vip_e(vip_e));

assign cpz_guestid[7:0] = {{8-GW{1'b0}}, cpz_gm_w | trace_gm_w ? cpz_gid : {GW{1'b0}}};
assign cpz_guestid_m[7:0] = {{8-GW{1'b0}}, cpz_gm_m ? cpz_gid : {GW{1'b0}}};
assign cpz_guestid_i[7:0] = {{8-GW{1'b0}}, cpz_gm_i ? cpz_gid : {GW{1'b0}}};

assign cpz_g_eret_m = hot_eret_m & enable_cp0_m & cpz_gm_m;
assign cpz_g_iret_m = mpc_iret_m & enable_cp0_m & cpz_gm_m;
mvp_cregister #(1) _cp0_g_eret_w(cp0_g_eret_w,mpc_run_m, gclk, cpz_g_eret_m);
mvp_cregister #(1) _cp0_g_iret_w(cp0_g_iret_w,mpc_run_m, gclk, cpz_g_iret_m);
assign cpz_g_iret_ret = iret_ret & mpc_run_m & cpz_gm_m;
assign mpc_g_iret_ret = mpc_iret_ret & cpz_gm_m;
assign mpc_g_iretval_e = mpc_iretval_e & cpz_gm_e;
assign mpc_g_eret_m = mpc_eret_m & cpz_gm_m;
assign hot_g_eret_m = hot_eret_m & cpz_gm_m;

/*hookup*/
`M14K_CPZ_GUEST_MODULE cpz_vz_guest(
	.badva(g_badva),
	.badva_jump(badva_jump),
	.bds_x(bds_x),
	.biu_merging(biu_merging),
	.biu_shutdown(biu_shutdown),
	.cause_s(g_cause_s),
	.count_ld(count_ld),
	.cp0_eret_w(cp0_g_eret_w),
	.cp0_iret_w(cp0_g_iret_w),
	.cp1_coppresent(cp1_coppresent),
	.cp1_seen_nodmiss_m(cp1_seen_nodmiss_m),
	.cp1_ufrp(cp1_ufrp),
	.cp2_coppresent(cp2_coppresent),
	.cpz_eret_m(cpz_g_eret_m),
	.cpz_g_at_epi_en(cpz_g_at_epi_en),
	.cpz_g_at_pro_start_i(cpz_g_at_pro_start_i),
	.cpz_g_at_pro_start_val(cpz_g_at_pro_start_val),
	.cpz_g_bev(cpz_g_bev),
	.cpz_g_bootisamode(cpz_g_bootisamode),
	.cpz_g_cause_pci(cpz_g_cause_pci),
	.cpz_g_causeap(cpz_g_causeap),
	.cpz_g_cdmm(cpz_g_cdmm),
	.cpz_g_cee(cpz_g_cee),
	.cpz_g_config_ld(cpz_g_config_ld),
	.cpz_g_copusable(cpz_g_copusable),
	.cpz_g_dwatchhit(cpz_g_dwatchhit),
	.cpz_g_ebase(cpz_g_ebase),
	.cpz_g_epc_rd_data(cpz_g_epc_rd_data),
	.cpz_g_eretisa(cpz_g_eretisa),
	.cpz_g_erl(cpz_g_erl),
	.cpz_g_erl_e(cpz_g_erl_e),
	.cpz_g_excisamode(cpz_g_excisamode),
	.cpz_g_exl(cpz_g_exl),
	.cpz_g_ext_int(cpz_g_ext_int),
	.cpz_g_hoterl(cpz_g_hoterl),
	.cpz_g_hotexl(cpz_g_hotexl),
	.cpz_g_hss(cpz_g_hss),
	.cpz_g_hwrena(cpz_g_hwrena),
	.cpz_g_hwrena_29(cpz_g_hwrena_29),
	.cpz_g_iack(cpz_g_iack),
	.cpz_g_iap_um(cpz_g_iap_um),
	.cpz_g_ice(cpz_g_ice),
	.cpz_g_int_e(cpz_g_int_e),
	.cpz_g_int_enable(cpz_g_int_enable),
	.cpz_g_int_excl_ie_e(cpz_g_int_excl_ie_e),
	.cpz_g_int_mw(cpz_g_int_mw),
	.cpz_g_int_pend_ed(cpz_g_int_pend_ed),
	.cpz_g_ion(cpz_g_ion),
	.cpz_g_ipl(cpz_g_ipl),
	.cpz_g_iretpc(cpz_g_iretpc),
	.cpz_g_iv(cpz_g_iv),
	.cpz_g_ivn(cpz_g_ivn),
	.cpz_g_iwatchhit(cpz_g_iwatchhit),
	.cpz_g_k0cca(cpz_g_k0cca),
	.cpz_g_k23cca(cpz_g_k23cca),
	.cpz_g_kuc_e(cpz_g_kuc_e),
	.cpz_g_kuc_i(cpz_g_kuc_i),
	.cpz_g_kuc_m(cpz_g_kuc_m),
	.cpz_g_kuc_w(cpz_g_kuc_w),
	.cpz_g_kucca(cpz_g_kucca),
	.cpz_g_llbit(cpz_g_llbit),
	.cpz_g_mmusize(cpz_g_mmusize),
	.cpz_g_mmutype(cpz_g_mmutype),
	.cpz_g_mx(cpz_g_mx),
	.cpz_g_pc_present(cpz_g_pc_present),
	.cpz_g_pf(cpz_g_pf),
	.cpz_g_rbigend_e(cpz_g_rbigend_e),
	.cpz_g_rbigend_i(cpz_g_rbigend_i),
	.cpz_g_rp(cpz_g_rp),
	.cpz_g_smallpage(cpz_g_smallpage),
	.cpz_g_srsctl(cpz_g_srsctl),
	.cpz_g_srsctl_css(cpz_g_srsctl_css),
	.cpz_g_srsctl_pss(cpz_g_srsctl_pss),
	.cpz_g_srsctl_pss2css_m(cpz_g_srsctl_pss2css_m),
	.cpz_g_status(cpz_g_status),
	.cpz_g_stkdec(cpz_g_stkdec),
	.cpz_g_swint(cpz_g_swint),
	.cpz_g_takeint(cpz_g_takeint),
	.cpz_g_timerint(cpz_g_timerint),
	.cpz_g_ufr(cpz_g_ufr),
	.cpz_g_ulri(cpz_g_ulri),
	.cpz_g_um(cpz_g_um),
	.cpz_g_um_vld(cpz_g_um_vld),
	.cpz_g_usekstk(cpz_g_usekstk),
	.cpz_g_vectoroffset(cpz_g_vectoroffset),
	.cpz_g_watch_present(cpz_g_watch_present),
	.cpz_g_watch_present__1(cpz_g_watch_present__1),
	.cpz_g_watch_present__2(cpz_g_watch_present__2),
	.cpz_g_watch_present__3(cpz_g_watch_present__3),
	.cpz_g_watch_present__4(cpz_g_watch_present__4),
	.cpz_g_watch_present__5(cpz_g_watch_present__5),
	.cpz_g_watch_present__6(cpz_g_watch_present__6),
	.cpz_g_watch_present__7(cpz_g_watch_present__7),
	.cpz_g_wpexc_m(cpz_g_wpexc_m),
	.cpz_ghfc_i(cpz_ghfc_i),
	.cpz_ghfc_w(cpz_ghfc_w),
	.cpz_gm_e(cpz_gm_e),
	.cpz_gm_i(cpz_gm_i),
	.cpz_gm_m(cpz_gm_m),
	.cpz_gm_w(cpz_gm_w),
	.cpz_gsfc_m(cpz_gsfc_m),
	.cpz_iret_m(cpz_g_iret_m),
	.cpz_iret_ret(cpz_g_iret_ret),
	.dc_nsets(dc_nsets),
	.dc_present(dc_present),
	.dc_ssize(dc_ssize),
	.dcc_dvastrobe(dcc_dvastrobe),
	.dcc_intkill_m(dcc_intkill_m),
	.dcc_intkill_w(dcc_intkill_w),
	.dcc_sp_pres(dcc_sp_pres),
	.edp_alu_m(edp_alu_m),
	.edp_cacheiva_i(edp_cacheiva_i),
	.edp_dsp_present_xx(edp_dsp_present_xx),
	.edp_eisa_e(edp_eisa_e),
	.edp_epc_e(edp_epc_e),
	.edp_iva_i(edp_iva_i),
	.edp_udi_present(edp_udi_present),
	.eisa_w(eisa_w),
	.ej_fdc_int(ej_fdc_int),
	.ejt_dcrinte(ejt_dcrinte),
	.ejt_pdt_present(ejt_pdt_present),
	.epc_w(epc_w),
	.fcd(fcd),
	.fdc_present(fdc_present),
	.g_cause_pci(g_cause_pci),
	.g_cp0read_m(g_cp0read_m),
	.g_doze(g_doze),
	.g_eretpc(g_eretpc),
	.g_fr(g_fr),
	.g_iap_exce_handler_trace(g_iap_exce_handler_trace),
	.g_iret_tailchain(g_iret_tailchain),
	.g_nest_erl(g_nest_erl),
	.g_nest_exl(g_nest_exl),
	.gclk(gclk),
	.geicss(geicss),
	.gfclk(gfclk),
	.glss(glss),
	.greset(greset),
	.gripl(gripl),
	.gripl_clr(gripl_clr),
	.gscanenable(gscanenable),
	.guestctl0_mc(guestctl0_mc),
	.gvec(gvec),
	.hold_count_ld(hold_count_ld),
	.hot_eret_m(hot_g_eret_m),
	.hot_ignore_watch(hot_ignore_watch),
	.hot_wr_guestctl2_noneic(hot_wr_guestctl2_noneic),
	.ic_nsets(ic_nsets),
	.ic_present(ic_present),
	.ic_ssize(ic_ssize),
	.icc_imiss_i(icc_imiss_i),
	.icc_sp_pres(icc_sp_pres),
	.icc_umipsfifo_null_i(icc_umipsfifo_null_i),
	.icc_umipspresent(icc_umipspresent),
	.ignore_watch(ignore_watch),
	.instn_slip_e(instn_slip_e),
	.int_pend_e(int_pend_e),
	.ir_w(ir_w),
	.ir_x(ir_x),
	.mdu_stall(mdu_stall),
	.mdu_type(mdu_type),
	.mmu_asid(mmu_asid),
	.mmu_cpyout(mmu_cpyout),
	.mmu_dva_m(mmu_dva_m),
	.mmu_it_segerr(mmu_it_segerr),
	.mmu_size(mmu_size),
	.mmu_tlbshutdown(mmu_tlbshutdown),
	.mmu_transexc(mmu_transexc),
	.mmu_type(mmu_type),
	.mmu_vafromi(mmu_vafromi),
	.mpc_atepi_m(mpc_atepi_m),
	.mpc_atepi_w(mpc_atepi_w),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_atpro_w(mpc_atpro_w),
	.mpc_auexc_on(mpc_auexc_on),
	.mpc_badins_type(mpc_badins_type),
	.mpc_buf_epc(mpc_buf_epc),
	.mpc_buf_srsctl(mpc_buf_srsctl),
	.mpc_buf_status(mpc_buf_status),
	.mpc_busty_m(mpc_busty_m),
	.mpc_cfc1_fr_m(mpc_cfc1_fr_m),
	.mpc_chain_take(mpc_chain_take),
	.mpc_chain_vec(mpc_chain_vec),
	.mpc_cp0diei_m(mpc_cp0diei_m),
	.mpc_cp0move_m(mpc_cp0move_m),
	.mpc_cp0r_m(mpc_cp0r_m),
	.mpc_cp0sc_m(mpc_cp0sc_m),
	.mpc_cp0sr_m(mpc_cp0sr_m),
	.mpc_cpnm_e(mpc_cpnm_e),
	.mpc_ctc1_fr0_m(mpc_ctc1_fr0_m),
	.mpc_ctc1_fr1_m(mpc_ctc1_fr1_m),
	.mpc_dis_int_e(mpc_dis_int_e),
	.mpc_dmsquash_m(mpc_dmsquash_m),
	.mpc_eret_m(mpc_g_eret_m),
	.mpc_exc_e(mpc_exc_e),
	.mpc_exc_m(mpc_exc_m),
	.mpc_exc_w(mpc_exc_w),
	.mpc_exccode(mpc_exccode),
	.mpc_excisamode_i(mpc_excisamode_i),
	.mpc_first_det_int(mpc_first_det_int),
	.mpc_fixup_m(mpc_fixup_m),
	.mpc_fixupi(mpc_fixupi),
	.mpc_g_cp0move_m(mpc_g_cp0move_m),
	.mpc_g_int_pf(mpc_g_int_pf),
	.mpc_g_jamepc_w(mpc_g_jamepc_w),
	.mpc_g_jamtlb_w(mpc_g_jamtlb_w),
	.mpc_g_ld_causeap(mpc_g_ld_causeap),
	.mpc_g_ldcause(mpc_g_ldcause),
	.mpc_hold_hwintn(mpc_hold_hwintn),
	.mpc_hw_load_done(mpc_hw_load_done),
	.mpc_hw_load_e(mpc_hw_load_e),
	.mpc_hw_save_done(mpc_hw_save_done),
	.mpc_iae_done_exc(mpc_iae_done_exc),
	.mpc_int_pf_phase1_reg(mpc_int_pf_phase1_reg),
	.mpc_int_pref_phase1(mpc_int_pref_phase1),
	.mpc_iret_ret(mpc_g_iret_ret),
	.mpc_iretval_e(mpc_g_iretval_e),
	.mpc_isamode_i(mpc_isamode_i),
	.mpc_ivaval_i(mpc_ivaval_i),
	.mpc_ll1_m(mpc_ll1_m),
	.mpc_ll_m(mpc_ll_m),
	.mpc_load_m(mpc_load_m),
	.mpc_load_status_done(mpc_load_status_done),
	.mpc_lsdc1_m(mpc_lsdc1_m),
	.mpc_lsdc1_w(mpc_lsdc1_w),
	.mpc_nonseq_e(mpc_nonseq_e),
	.mpc_pdstrobe_w(mpc_pdstrobe_w),
	.mpc_pexc_i(mpc_pexc_i),
	.mpc_pexc_m(mpc_pexc_m),
	.mpc_pexc_w(mpc_pexc_w),
	.mpc_qual_auexc_x(mpc_qual_auexc_x),
	.mpc_rdhwr_m(mpc_rdhwr_m),
	.mpc_run_i(mpc_run_i),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_run_w(mpc_run_w),
	.mpc_squash_e(mpc_squash_e),
	.mpc_squash_i(mpc_squash_i),
	.mpc_squash_m(mpc_squash_m),
	.mpc_tint(mpc_tint),
	.mpc_umipsfifosupport_i(mpc_umipsfifosupport_i),
	.mpc_umipspresent(mpc_umipspresent),
	.mpc_wr_intctl_m(mpc_wr_intctl_m),
	.mpc_wr_status_m(mpc_wr_status_m),
	.mpc_wr_view_ipl_m(mpc_wr_view_ipl_m),
	.pc_present(pc_present),
	.perfcnt_rdata_ex(perfcnt_rdata),
	.r_count(r_count),
	.r_gtoffset(r_gtoffset),
	.r_internal_int(internal_int),
	.r_pip(r_pip),
	.r_pip_e(r_pip_e),
	.r_srsctl(r_srsctl),
	.sfc1(sfc1),
	.sfc2(sfc2),
	.siu_bigend(siu_bigend),
	.siu_bootexcisamode(siu_bootexcisamode),
	.siu_coldreset(siu_coldreset),
	.siu_cpunum(siu_cpunum),
	.siu_eicpresent(siu_eicpresent),
	.siu_g_eicvector(siu_g_eicvector),
	.siu_g_eiss(siu_g_eiss),
	.siu_g_int(siu_g_int),
	.siu_g_offset(siu_g_offset),
	.siu_ifdci(siu_ifdci),
	.siu_int(siu_int),
	.siu_ippci(siu_ippci),
	.siu_ipti(siu_ipti),
	.siu_srsdisable(siu_srsdisable),
	.vip(vip),
	.vip_e(vip_e),
	.vz_present(vz_present));

endmodule	// m14k_cpz
