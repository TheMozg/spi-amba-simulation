// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//      Description: m14k_cpz_pc_top
//
//      $Id: \$
//      mips_repository_id: m14k_cpz_pc_top.mv, v 1.31 
//

//      mips_start_of_legal_notice
//      **********************************************************************
//      Unpublished work (c) MIPS Technologies, Inc.  All rights reserved. 
//      Unpublished rights reserved under the copyright laws of the United
//      States of America and other countries.
//      
//      MIPS TECHNOLOGIES PROPRIETARY / RESTRICTED CONFIDENTIAL - HEIGHTENED
//      STANDARD OF CARE REQUIRED AS PER CONTRACT
//      
//      This code is confidential and proprietary to MIPS Technologies, Inc.
//      ("MIPS Technologies") and may be disclosed only as permitted in
//      writing by MIPS Technologies.  Any copying, reproducing, modifying,
//      use or disclosure of this code (in whole or in part) that is not
//      expressly permitted in writing by MIPS Technologies is strictly
//      prohibited.  At a minimum, this code is protected under trade secret,
//      unfair competition and copyright laws.	Violations thereof may result
//      in criminal penalties and fines.
//      
//      MIPS Technologies reserves the right to change the code to improve
//      function, design or otherwise.	MIPS Technologies does not assume any
//      liability arising out of the application or use of this code, or of
//      any error or omission in such code.  Any warranties, whether express,
//      statutory, implied or otherwise, including but not limited to the
//      implied warranties of merchantability or fitness for a particular
//      purpose, are excluded.	Except as expressly provided in any written
//      license agreement from MIPS Technologies, the furnishing of this code
//      does not give recipient any license to any intellectual property
//      rights, including any patent rights, that cover this code.
//      
//      This code shall not be exported, reexported, transferred, or released,
//      directly or indirectly, in violation of the law of any country or
//      international law, regulation, treaty, Executive Order, statute,
//      amendments or supplements thereto.  Should a conflict arise regarding
//      the export, reexport, transfer, or release of this code, the laws of
//      the United States of America shall be the governing law.
//      
//      This code may only be disclosed to the United States government
//      ("Government"), or to Government users, with prior written consent
//      from MIPS Technologies.  This code constitutes one or more of the
//      following: commercial computer software, commercial computer software
//      documentation or other commercial items.  If the user of this code, or
//      any related documentation of any kind, including related technical
//      data or manuals, is an agency, department, or other entity of the
//      Government, the use, duplication, reproduction, release, modification,
//      disclosure, or transfer of this code, or any related documentation of
//      any kind, is restricted in accordance with Federal Acquisition
//      Regulation 12.212 for civilian agencies and Defense Federal
//      Acquisition Regulation Supplement 227.7202 for military agencies.  The
//      use of this code by the Government is further restricted in accordance
//      with the terms of the license agreement(s) and/or applicable contract
//      terms and conditions covering this code from MIPS Technologies.
//      
//      
//      
//      **********************************************************************
//      mips_end_of_legal_notice
//
//
//

`include "m14k_const.vh"

module m14k_cpz_pc_top(
	mpc_pm_complete,
	g_eic_mode,
	mpc_gpsi_perfcnt,
	mpc_auexc_on,
	mpc_exc_type_w,
	mpc_jreg31non_e,
	mpc_dec_nop_w,
	mpc_sc_m,
	mpc_pref_w,
	mpc_pref_m,
	mpc_strobe_e,
	mpc_strobe_m,
	mpc_strobe_w,
	mpc_ltu_e,
	mpc_mcp0stall_e,
	mpc_bubble_e,
	mpc_exc_w,
	mdu_stall,
	mdu_busy,
	bstall_ie,
	mpc_ldst_e,
	mpc_fixupi,
	mpc_fixupd,
	mpc_ld_m,
	mpc_st_m,
	mpc_atomic_m,
	mdu_result_done,
	mpc_pm_muldiv_e,
	cp2_stall_e,
	brk_i_trig,
	brk_d_trig,
	mpc_jreg31_e,
	mpc_jimm_e,
	mpc_br_e,
	mpc_alu_w,
	edp_udi_stall_m,
	mpc_stall_ie,
	mpc_stall_m,
	mpc_stall_w,
	mpc_cp2tf_e,
	mpc_cp2a_e,
	icc_umipsfifo_null_w,
	cp2_coppresent,
	dcc_dmiss_m,
	scfail_e,
	mmu_dcmode0,
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
	mmu_r_pm_jthit_d,
	mmu_r_pm_jtmiss_i,
	mmu_r_pm_jtmiss_d,
	mpc_tlb_i_side,
	mpc_tlb_d_side,
	mmu_icacabl,
	icc_trstb,
	icc_twstb,
	icc_drstb,
	icc_imiss_i,
	icc_stall_i,
	icc_spram_stall,
	icc_fb_vld,
	dcc_dcached_m,
	dcc_lscacheread_m,
	dcc_trstb,
	dcc_twstb,
	dcc_pm_dcmiss,
	dcc_pm_dhit_m,
	dcc_stall_m,
	dcc_wb,
	dcc_dspram_stall,
	dcc_pm_fb_active,
	dcc_pm_fbfull,
	biu_pm_wr_buf_b,
	biu_pm_wr_buf_f,
	biu_wtbf,
	icc_sp_pres,
	dcc_sp_pres,
	icc_icopstall,
	dcc_dcop_stall,
	dcc_uncache_load,
	dcc_uncached_store,
	gclk,
	gfclk,
	greset,
	gscanenable,
	cpz_goodnight,
	mtcp0_m,
	mfcp0_m,
	mpc_cp0r_m,
	mpc_cp0sr_m,
	status32,
	cpz_g_status,
	cpz_vz,
	cpz_gm,
	cpz_gm_i,
	cpz_gm_e,
	cpz_gm_m,
	cpz_gm_w,
	cpz_gm_x,
	cpz_dm,
	cpz,
	cause_s,
	g_cause_s,
	mmu_r_asid,
	mmu_asid,
	badva,
	g_badva,
	mpc_cp0move_m,
	mpc_g_cp0move_m,
	mpc_load_m,
	mpc_dmsquash_m,
	mpc_r_auexc_x,
	mpc_g_auexc_x,
	cpz_eisa_x,
	mpc_run_ie,
	mpc_run_m,
	mpc_run_w,
	mpc_eret_m,
	mpc_deret_m,
	mpc_iret_m,
	g_pc_present,
	pc_present,
	g_cause_pci,
	cpz_cause_pci,
	cpz_pc_ctl0_ec1,
	cpz_pc_ctl1_ec1,
	perfcnt_rdata);

	input mpc_pm_complete;
	input g_eic_mode;
	input mpc_gpsi_perfcnt;
	input mpc_auexc_on;
//	input mpc_r_auexc_x_qual;	//not use
//	input mpc_g_auexc_x_qual;	//not use
	input mpc_exc_type_w;	//for performance counter use(indicate dss or ibrk or dbrk or dint or sdbbp exception).
	input mpc_jreg31non_e;
	input mpc_dec_nop_w;
	input mpc_sc_m;
	input mpc_pref_w;
	input mpc_pref_m;
	input mpc_strobe_e;
	input mpc_strobe_m;
	input mpc_strobe_w;
	input mpc_ltu_e; // stall due to load-to-use. (for loads only)
	input mpc_mcp0stall_e; // stall due to cp0 return data.
	input mpc_bubble_e; // stalls e-stage due to arithmetic/deadlock/return data reasons
	input mpc_exc_w;
	input mdu_stall;
	input mdu_busy;	
	input bstall_ie; 
	input mpc_ldst_e;
	input mpc_fixupi;
	input mpc_fixupd;
	input mpc_ld_m;
	input mpc_st_m;
	input mpc_atomic_m;
	input mdu_result_done;
	input mpc_pm_muldiv_e;
	input cp2_stall_e;
	input [7:0] brk_i_trig;
	input [3:0] brk_d_trig;
	input mpc_jreg31_e;
	input mpc_jimm_e;
	input mpc_br_e;
	input mpc_alu_w;
	input edp_udi_stall_m;
	input mpc_stall_ie;
	input mpc_stall_m;
	input mpc_stall_w;
	input mpc_cp2tf_e;
	input mpc_cp2a_e;
	input icc_umipsfifo_null_w;	// instn slip propagated to w-stage
	input cp2_coppresent;
	input dcc_dmiss_m;
	input scfail_e;
	input mmu_dcmode0;
	input mmu_r_itexc_i;
        input mmu_r_itxiexc_i;
        input mmu_r_dtexc_m;
        input mmu_r_dtriexc_m;
	input mmu_pm_ithit;
	input mmu_pm_itmiss;
	input mmu_pm_dthit;
	input mmu_pm_dtmiss;
	input mmu_pm_dtlb_miss_qual;
//	input mmu_pm_jthit;
//	input mmu_pm_jtmiss;
	input mmu_pm_jthit_i;
	input mmu_pm_jthit_d;
	input mmu_pm_jtmiss_i;
	input mmu_pm_jtmiss_d;
	input mmu_r_pm_jthit_i; 
	input mmu_r_pm_jthit_d; 
	input mmu_r_pm_jtmiss_i; 
	input mmu_r_pm_jtmiss_d; 
	input mpc_tlb_i_side;
	input mpc_tlb_d_side;
	input mmu_icacabl;
	input icc_trstb;
	input icc_twstb;
	input icc_drstb;
	input icc_imiss_i;
	input icc_stall_i;
	input icc_spram_stall;
	input [3:0] icc_fb_vld;
	input dcc_dcached_m;
	input dcc_lscacheread_m; // cacheread includes tag/data/way
	input dcc_trstb;
	input dcc_twstb;
	input dcc_pm_dcmiss;
	input dcc_pm_dhit_m; // pm data ref. hit
	input dcc_stall_m;
	input dcc_wb;
	input dcc_dspram_stall;
	input dcc_pm_fb_active;
	input dcc_pm_fbfull;
	input biu_pm_wr_buf_b;
	input biu_pm_wr_buf_f;
	input biu_wtbf;
	input icc_sp_pres;
	input dcc_sp_pres;
	input icc_icopstall; 
	input dcc_dcop_stall;
	input dcc_uncache_load;
	input dcc_uncached_store;
	input gclk;
	input gfclk;
	input greset;
	input gscanenable;
	input cpz_goodnight;
	input mtcp0_m;
	input mfcp0_m;
	input [4:0] mpc_cp0r_m;
	input [1:0] mpc_cp0sr_m;
	input [31:0] status32;
	input [31:0] cpz_g_status;
	input cpz_vz;
	input cpz_gm;
	input cpz_gm_i;
	input cpz_gm_e;
	input cpz_gm_m;
	input cpz_gm_w;
	input cpz_gm_x;
	input cpz_dm;
	input [31:0] cpz;
	input [11:0] cause_s;
	input [6:0] g_cause_s;
	input [7:0] mmu_r_asid;
	input [7:0] mmu_asid;
	input [31:0] badva;
	input [31:0] g_badva;
	input mpc_cp0move_m;
	input mpc_g_cp0move_m;
	input mpc_load_m;
	input mpc_dmsquash_m;
	//input mpc_ndauexc_x;
	input mpc_r_auexc_x;
	input mpc_g_auexc_x;
	input cpz_eisa_x;
	input mpc_run_ie;
	input mpc_run_m;
	input mpc_run_w;
	input mpc_eret_m;
	input mpc_deret_m;
	input mpc_iret_m;
	input g_pc_present;
	output pc_present;
	output g_cause_pci;
	output cpz_cause_pci;
	output cpz_pc_ctl0_ec1;
	output cpz_pc_ctl1_ec1;
	output [31:0] perfcnt_rdata;

// BEGIN Wire declarations made by MVP
wire scfail_w_qual;
wire mmu_pm_jtacc_d;
wire cp2tf_w_qual;
wire ucld_w;
wire [4:0] /*[4:0]*/ cause_s_pm;
wire pc_cnt0_evt8_md;
wire same_dtmiss;
wire pc_cnt0_evt7_id;
wire mpc_r_auexc_x_reg;
wire ld_w;
wire [31:0] /*[31:0]*/ perfcnt_rdata;
wire pc_cnt0_evt5_idd;
wire [7:0] /*[7:0]*/ mmu_asid_pm;
wire same_dtmiss_g;
wire mpc_g_auexc_x_reg;
wire same_dtmiss_r;
wire pc_cnt1_evt7_i;
wire pc_cnt1_evt7_vz_idd;
wire cp2tf_m;
wire br_w;
wire st_w_qual;
wire cpz_pc_ctl0_ec1;
wire iqual_49;
wire scfail_m;
wire pc_cnt0_evt7_i;
wire pc_cnt0_evt8_vz;
wire cpz_cause_pci;
wire pc_cnt0_evt7_vz_idd;
wire pc_cnt1_evt8_md;
wire pc_ctl0_we;
wire jreg31non_w;
wire br_m;
wire jimm_w_qual;
wire br_w_qual;
wire mpc_g_ret_w;
wire pc_cnt1_evt7_idd;
wire [4:1] /*[4:1]*/ status32_reg;
wire pc_atomic_disqualify_d;
wire [31:11] /*[31:11]*/ g_badva_pm;
wire jimm_w;
wire scfail_w;
wire pc_ctl1_we;
wire [4:1] /*[4:1]*/ cpz_g_status_x;
wire pc_cnt1_evt7_vz_i;
wire cp2a_w;
wire pc_cnt0_evt8_vz_mdd;
wire sc_w_qual;
wire pc_cnt1_evt5_idd;
wire jimm_m;
wire cp2a_w_qual;
wire st_w;
wire pc_cnt0_evt7_vz_i;
wire cpz_pc_rd;
wire muldiv_w_qual;
wire mmu_pm_jtacc_i;
wire mpc_ret_w;
wire pc_cnt0_evt7_idd;
wire pc_cnt1_we;
wire ucld_w_qual;
wire jreg31_w;
wire ucst_w_qual;
wire ucst_w;
wire same_dtmiss_novz;
wire cp2a_m;
wire pc_cnt0_evt5_id;
wire jreg31_w_qual;
wire pc_cnt1_evt8_vz;
wire cpz_pc_we;
wire pc_cnt0_we;
wire pc_cnt1_evt7_vz_id;
wire g_cause_pci;
wire pc_cnt1_evt8_mdd;
wire pc_cnt1_evt8_vz_mdd;
wire mpc_g_auexc_x_pos;
wire mpc_exc_type_x;
wire ld_w_qual;
wire pc_cnt1_evt5_i;
wire [31:11] /*[31:11]*/ badva_pm;
wire cp2tf_w;
wire pc_present;
wire [4:1] /*[4:1]*/ cpz_g_status_reg;
wire [7:0] /*[7:0]*/ mmu_r_asid_pm;
wire cpz_pc_ctl1_ec1;
wire pc_cnt0_evt8_mdd;
wire mmu_r_pm_jtacc_d;
wire mmu_pm_dtacc;
wire mpc_all_ret_m;
wire jreg31non_w_qual;
wire jreg31_m;
wire pc_atomic_disqualify;
wire pc_cnt1_evt7_id;
wire mpc_r_auexc_x_pos;
wire pc_cnt0_evt7_vz_id;
wire pc_cnt1_evt5_id;
wire pc_cnt0_evt5_i;
wire muldiv_m;
wire mmu_r_pm_jtacc_i;
wire mmu_pm_itacc;
wire [4:0] /*[4:0]*/ g_cause_s_pm;
wire pc_cnt0_evt8;
wire pc_cnt0_evt8_vz_md;
wire [4:1] /*[4:1]*/ status32_x;
wire muldiv_w;
wire pc_cnt1_evt8_vz_md;
wire nop_w_qual;
wire jreg31non_m;
wire sc_w;
wire dqual_49;
wire pc_cnt1_evt8;
// END Wire declarations made by MVP



	wire alu_cp0_pc0_tcen_xx;
	wire alu_cp0_pc1_tcen_xx;
	wire [31:0] pc_ctl1_reg;
	wire [31:0] pc_ctl0_reg;
	wire [31:0] pc_cnt1_reg;
	wire [31:0] pc_cnt0_reg;
	wire [255:0] pc_cnt0_evt;
	wire [255:0] pc_cnt1_evt;
	wire [1:0] pc_ctl0_ec;
	wire [1:0] pc_ctl1_ec;
	wire r_pc_int0;
	wire r_pc_int1;
	wire g_pc_int0;
	wire g_pc_int1;
	
//	Root CPZ Access
//	mfcp0_m 	=  mpc_load_m && (mpc_cp0move_m && !cpz_gm_m) && !mpc_fixup_m;
//	hot_mtcp0_m = !mpc_load_m && (mpc_cp0move_m && !cpz_gm_m);
//	mtcp0_m 	= hot_mtcp0_m && !mpc_dmsquash_m && mpc_run_m;
//	Guest CPZ Access
//	mfcp0_m     =  mpc_load_m && (mpc_cp0move_m && cpz_gm_m || mpc_g_cp0move_m) && !mpc_fixup_m;
//	hot_mtcp0_m = !mpc_load_m && (mpc_cp0move_m && cpz_gm_m || mpc_g_cp0move_m);
//	mtcp0_m     = hot_mtcp0_m && !mpc_dmsquash_m && mpc_run_m;
	
	assign cpz_pc_we = (~cpz_gm_m ? mpc_cp0move_m | mpc_g_cp0move_m : mpc_cp0move_m & g_pc_present) & 
		!mpc_load_m & !mpc_dmsquash_m & mpc_run_m & mpc_cp0r_m == 5'd25;

	assign cpz_pc_rd= (~cpz_gm_m ? mpc_cp0move_m | mpc_g_cp0move_m : mpc_cp0move_m & g_pc_present) & 
		mpc_load_m & !mpc_dmsquash_m & mpc_run_m & mpc_cp0r_m == 5'd25;

	assign pc_ctl0_we = cpz_pc_we & (mpc_cp0sr_m==0);
	assign pc_cnt0_we = cpz_pc_we & (mpc_cp0sr_m==1);
	assign pc_ctl1_we = cpz_pc_we & (mpc_cp0sr_m==2);
	assign pc_cnt1_we = cpz_pc_we & (mpc_cp0sr_m==3);

	mvp_mux1hot_4 #(32) _perfcnt_rdata_31_0_(perfcnt_rdata[31:0],
		mpc_cp0sr_m == 2'd2, pc_ctl1_reg,
		mpc_cp0sr_m == 2'd3, pc_cnt1_reg,
		mpc_cp0sr_m == 2'd0, pc_ctl0_reg,
		mpc_cp0sr_m == 2'd1, pc_cnt0_reg);

	assign cpz_pc_ctl0_ec1 = pc_ctl0_ec[1];
	assign cpz_pc_ctl1_ec1 = pc_ctl1_ec[1];
	mvp_register #(1) _cpz_cause_pci(cpz_cause_pci,gclk, r_pc_int0 | r_pc_int1);
	mvp_register #(1) _g_cause_pci(g_cause_pci,gclk, g_pc_int0 | g_pc_int1);
	assign pc_present    = 1'b1;
/*
	wire tc_in_erldm, tc_in_exl, tc_in_kernel, tc_in_super, tc_in_user;
	tc_in_erldm = status32[2] | cpz_dm;
	tc_in_exl = status32[1];
	tc_in_kernel = (status32[4] == 1'b0) | (status32[2] == 1'b1) | (status32[1] == 1'b1);
	tc_in_super  =  1'b1;
	tc_in_user   = (status32[4] == 1'b1) & (status32[2] == 1'b0) & (status32[1] == 1'b0);
*/
assign mpc_all_ret_m = mpc_eret_m | mpc_deret_m | mpc_iret_m;
mvp_cregister #(1) _mpc_ret_w(mpc_ret_w,mpc_run_m, gclk, mpc_all_ret_m & mpc_strobe_m);
mvp_cregister #(1) _mpc_g_ret_w(mpc_g_ret_w,mpc_run_m, gclk, mpc_all_ret_m & cpz_gm_m & mpc_strobe_m);
mvp_cregister_wide #(4) _cpz_g_status_reg_4_1_(cpz_g_status_reg[4:1],gscanenable, mpc_run_m, gclk, cpz_g_status[4:1]);
mvp_cregister_wide #(4) _status32_reg_4_1_(status32_reg[4:1],gscanenable, mpc_run_m, gclk, status32[4:1]);
assign cpz_g_status_x[4:1] = mpc_g_ret_w ? cpz_g_status_reg[4:1] : cpz_g_status[4:1];
assign status32_x[4:1] = mpc_ret_w ? status32_reg[4:1] : status32[4:1];
mvp_cregister #(1) _mpc_exc_type_x(mpc_exc_type_x,mpc_run_w, gclk, mpc_exc_type_w & mpc_strobe_w);
mvp_register #(1) _mpc_r_auexc_x_reg(mpc_r_auexc_x_reg,gclk, mpc_r_auexc_x);
assign mpc_r_auexc_x_pos = mpc_r_auexc_x & !mpc_r_auexc_x_reg;
mvp_register #(1) _mpc_g_auexc_x_reg(mpc_g_auexc_x_reg,gclk, mpc_g_auexc_x);
assign mpc_g_auexc_x_pos = (mpc_g_auexc_x & !mpc_g_auexc_x_reg) | (cpz_gm_x & mpc_r_auexc_x_pos & mpc_exc_type_x);
//	alu_cp0_pc0_tcen_xx=1'b1;
	m14k_cpz_pc #(1'b1) alu_cp0_pc0 (
		.gclk(gclk),
		.gfclk(gfclk),
		.greset(greset),
		.gscanenable(gscanenable),
		.cpz_goodnight(cpz_goodnight),
		.cpz_vz(cpz_vz),
		.cpz_gm(cpz_gm),
		.cpz_dm(cpz_dm),
		.status(status32_x[4:1]),
		.g_status(cpz_g_status_x[4:1]),
		.cpz(cpz),
		.pc_ctl_we(pc_ctl0_we),
		.pc_cnt_we(pc_cnt0_we),
		.pc_cnt_evt(pc_cnt0_evt),
		.pc_ctl_reg(pc_ctl0_reg),
		.pc_cnt_reg(pc_cnt0_reg),
		.pc_ctl_ec(pc_ctl0_ec),
		//.pc_en_mask_xx(alu_cp0_pc0_tcen_xx),
		.r_pc_int(r_pc_int0),
		.g_pc_int(g_pc_int0));

//	alu_cp0_pc1_tcen_xx=1'b1;
	m14k_cpz_pc #(1'b0) alu_cp0_pc1 (
		.gclk(gclk),
		.gfclk(gfclk),
		.greset(greset),
		.gscanenable(gscanenable),
		.cpz_goodnight(cpz_goodnight),
		.cpz_vz(cpz_vz),
		.cpz_gm(cpz_gm),
		.cpz_dm(cpz_dm),
		.status(status32_x[4:1]),
		.g_status(cpz_g_status_x[4:1]),
		.cpz(cpz),
		.pc_ctl_we(pc_ctl1_we),
		.pc_cnt_we(pc_cnt1_we),
		.pc_cnt_evt(pc_cnt1_evt),
		.pc_ctl_reg(pc_ctl1_reg),
		.pc_cnt_reg(pc_cnt1_reg),
		.pc_ctl_ec(pc_ctl1_ec),
		//.pc_en_mask_xx(alu_cp0_pc1_tcen_xx),
		.r_pc_int(r_pc_int1),
		.g_pc_int(g_pc_int1));

	mvp_cregister #(1) _br_m(br_m,mpc_run_ie, gclk, mpc_br_e & mpc_strobe_e);
	mvp_cregister #(1) _br_w(br_w,mpc_run_m, gclk, br_m & mpc_run_m & mpc_strobe_m);
	mvp_register #(1) _br_w_qual(br_w_qual, gclk, br_w & mpc_run_w & !mpc_exc_w & mpc_strobe_w);
	mvp_cregister #(1) _jimm_m(jimm_m,mpc_run_ie, gclk, mpc_jimm_e & mpc_strobe_e);
	mvp_cregister #(1) _jimm_w(jimm_w,mpc_run_m, gclk, jimm_m & mpc_run_m & mpc_strobe_m);
	mvp_register #(1) _jimm_w_qual(jimm_w_qual, gclk, jimm_w & mpc_run_w & !mpc_exc_w & mpc_strobe_w);
	mvp_cregister #(1) _jreg31_m(jreg31_m,mpc_run_ie, gclk, mpc_jreg31_e & mpc_strobe_e);
	mvp_cregister #(1) _jreg31_w(jreg31_w,mpc_run_m, gclk, jreg31_m & mpc_run_m & mpc_strobe_m);
	mvp_register #(1) _jreg31_w_qual(jreg31_w_qual, gclk, jreg31_w & mpc_run_w & !mpc_exc_w & mpc_strobe_w);
	mvp_cregister #(1) _jreg31non_m(jreg31non_m,mpc_run_ie, gclk, mpc_jreg31non_e & mpc_strobe_e);
	mvp_cregister #(1) _jreg31non_w(jreg31non_w,mpc_run_m, gclk, jreg31non_m & mpc_run_m & mpc_strobe_m);
	mvp_register #(1) _jreg31non_w_qual(jreg31non_w_qual, gclk, jreg31non_w & mpc_run_w & !mpc_exc_w & mpc_strobe_w);
	mvp_cregister #(1) _muldiv_m(muldiv_m,mpc_run_ie, gclk, mpc_pm_muldiv_e & mpc_strobe_e);
	mvp_cregister #(1) _muldiv_w(muldiv_w,mpc_run_m,  gclk, muldiv_m & mpc_strobe_m);
	mvp_register #(1) _muldiv_w_qual(muldiv_w_qual, gclk, muldiv_w & mpc_run_w & !mpc_exc_w & mpc_strobe_w);
	mvp_register #(1) _nop_w_qual(nop_w_qual, gclk, mpc_dec_nop_w & mpc_run_w & !mpc_exc_w & mpc_strobe_w);
	mvp_cregister #(1) _sc_w(sc_w,mpc_run_m,  gclk, mpc_sc_m & mpc_strobe_m);
	mvp_register #(1) _sc_w_qual(sc_w_qual, gclk, sc_w & mpc_run_w & !mpc_exc_w & mpc_strobe_w);
	mvp_cregister #(1) _scfail_m(scfail_m,mpc_run_ie, gclk, scfail_e & mpc_strobe_e);
	mvp_cregister #(1) _scfail_w(scfail_w,mpc_run_m,  gclk, scfail_m & mpc_strobe_m);
	mvp_register #(1) _scfail_w_qual(scfail_w_qual, gclk, scfail_w & mpc_run_w & !mpc_exc_w & mpc_strobe_w);
	mvp_cregister #(1) _cp2a_m(cp2a_m,mpc_run_ie, gclk, mpc_cp2a_e & mpc_strobe_e);
	mvp_cregister #(1) _cp2a_w(cp2a_w,mpc_run_m,  gclk, cp2a_m & mpc_strobe_m);
	mvp_register #(1) _cp2a_w_qual(cp2a_w_qual, gclk, cp2a_w & mpc_run_w & !mpc_exc_w & mpc_strobe_w);
	mvp_cregister #(1) _cp2tf_m(cp2tf_m,mpc_run_ie, gclk, mpc_cp2tf_e & mpc_strobe_e);
	mvp_cregister #(1) _cp2tf_w(cp2tf_w,mpc_run_m,  gclk, cp2tf_m & mpc_strobe_m);
	mvp_register #(1) _cp2tf_w_qual(cp2tf_w_qual, gclk, cp2tf_w & mpc_run_w & !mpc_exc_w & mpc_strobe_w);
	mvp_cregister #(1) _ld_w(ld_w,mpc_run_m, gclk, mpc_ld_m & mpc_run_m & mpc_strobe_m);
	mvp_register #(1) _ld_w_qual(ld_w_qual, gclk, ld_w & mpc_run_w & !mpc_exc_w & mpc_strobe_w);
	mvp_cregister #(1) _st_w(st_w,mpc_run_m, gclk, mpc_st_m & mpc_run_m & mpc_strobe_m);
	mvp_register #(1) _st_w_qual(st_w_qual, gclk, st_w & mpc_run_w & !mpc_exc_w & mpc_strobe_w);
	mvp_cregister #(1) _ucld_w(ucld_w,mpc_run_m, gclk, mpc_ld_m & ~dcc_dcached_m & mpc_run_m & mpc_strobe_m);
        mvp_register #(1) _ucld_w_qual(ucld_w_qual, gclk, ucld_w & mpc_run_w & !mpc_exc_w & mpc_strobe_w);
        mvp_cregister #(1) _ucst_w(ucst_w,mpc_run_m, gclk, mpc_st_m & ~dcc_dcached_m & mpc_run_m & mpc_strobe_m);
        mvp_register #(1) _ucst_w_qual(ucst_w_qual, gclk, ucst_w & mpc_run_w & !mpc_exc_w & mpc_strobe_w);
	// back to back misses (ie: refill + modified) should only count ONCE
	mvp_cregister_wide #(21) _badva_pm_31_11_(badva_pm[31:11],gscanenable, mpc_auexc_on, gclk, badva[31:11]);
	mvp_cregister_wide #(21) _g_badva_pm_31_11_(g_badva_pm[31:11],gscanenable, mpc_auexc_on, gclk, g_badva[31:11]);
	mvp_cregister_wide #(8) _mmu_asid_pm_7_0_(mmu_asid_pm[7:0],gscanenable, mpc_auexc_on, gclk, mmu_asid);
	mvp_cregister_wide #(8) _mmu_r_asid_pm_7_0_(mmu_r_asid_pm[7:0],gscanenable, mpc_auexc_on, gclk, mmu_r_asid);
	mvp_cregister_wide #(5) _cause_s_pm_4_0_(cause_s_pm[4:0],gscanenable, mpc_auexc_on, gclk, cause_s[4:0]);
	mvp_cregister_wide #(5) _g_cause_s_pm_4_0_(g_cause_s_pm[4:0],gscanenable, mpc_auexc_on, gclk, g_cause_s[4:0]);
	assign same_dtmiss_novz = (badva_pm == badva[31:11]) & (mmu_asid_pm == mmu_asid) & (cause_s_pm == 5'h03) & (cause_s[4:0] == 5'h01);
	assign same_dtmiss_r = (badva_pm == badva[31:11]) & (mmu_r_asid_pm == mmu_r_asid) & (cause_s_pm == 5'h03) & (cause_s[4:0] == 5'h01);
	assign same_dtmiss_g = (g_badva_pm == g_badva[31:11]) & (mmu_asid_pm == mmu_asid) & (((g_cause_s_pm == 5'h03) & (g_cause_s[4:0] == 5'h01))||((g_cause_s_pm == 5'h01) & (cause_s[4:0] == 5'h03))||((cause_s_pm == 5'h03) & (cause_s[4:0] == 5'h01)));
	assign same_dtmiss = cpz_vz ? (cpz_gm_m ? same_dtmiss_g : same_dtmiss_r) : same_dtmiss_novz;
	mvp_register #(1) _iqual_49(iqual_49,gclk, (|brk_i_trig) & mpc_run_w & mpc_strobe_w & ~icc_umipsfifo_null_w);
	mvp_register #(1) _dqual_49(dqual_49,gclk, (|brk_d_trig) & mpc_run_w & mpc_strobe_w & ~icc_umipsfifo_null_w);
	//iqual_49 = (|brk_i_trig) & mpc_run_w & mpc_strobe_w & ~icc_umipsfifo_null_w;
	//dqual_49 = (|brk_d_trig) & mpc_run_w & mpc_strobe_w & ~icc_umipsfifo_null_w;
	assign pc_atomic_disqualify = mpc_atomic_m & mpc_ld_m;
	mvp_cregister #(1) _pc_atomic_disqualify_d(pc_atomic_disqualify_d,mpc_run_m, gclk, mpc_atomic_m & mpc_ld_m);

	assign mmu_pm_itacc     = mmu_pm_itmiss     | mmu_pm_ithit;
	assign mmu_pm_dtacc     = mmu_pm_dtmiss     | mmu_pm_dthit;
	assign mmu_pm_jtacc_i   = mmu_pm_jtmiss_i   | mmu_pm_jthit_i;
	assign mmu_pm_jtacc_d   = mmu_pm_jtmiss_d   | mmu_pm_jthit_d;
	assign mmu_r_pm_jtacc_i = mmu_r_pm_jtmiss_i | mmu_r_pm_jthit_i;
	assign mmu_r_pm_jtacc_d = mmu_r_pm_jtmiss_d | mmu_r_pm_jthit_d;

	assign pc_cnt0_evt[0] = 1'b1; // cycles 
	assign pc_cnt1_evt[0] = 1'b1; // cycles
	//pc_cnt0_evt[1] = mpc_pm_complete & (alu_cp0_pc0_tcen_xx); // instructions completed
	assign pc_cnt0_evt[1] = mpc_pm_complete; // instructions completed
	//pc_cnt1_evt[1] = mpc_pm_complete & (alu_cp0_pc1_tcen_xx); // instructions completed
	assign pc_cnt1_evt[1] = mpc_pm_complete; // instructions completed
	//pc_cnt0_evt[2] = mpc_pm_complete & br_w_qual & (alu_cp0_pc0_tcen_xx); // branch completed
	assign pc_cnt0_evt[2] = mpc_pm_complete & br_w_qual; // branch completed
	assign pc_cnt1_evt[2] = 1'b0; // branch mispredicts
	//pc_cnt0_evt[3] = mpc_pm_complete & jreg31_w_qual & (alu_cp0_pc0_tcen_xx); // JR R31
	assign pc_cnt0_evt[3] = mpc_pm_complete & jreg31_w_qual; // JR R31
	assign pc_cnt1_evt[3] = 1'b0; // JR R31 mispredicts
	//pc_cnt0_evt[4] = mpc_pm_complete & jreg31non_w_qual & (alu_cp0_pc0_tcen_xx); // JR not R31
	assign pc_cnt0_evt[4] = mpc_pm_complete & jreg31non_w_qual; // JR not R31
	assign pc_cnt1_evt[4] = 1'b0; // JR R31 not predicted
	assign pc_cnt0_evt5_i = pc_ctl0_ec[1]==cpz_gm_i & mmu_pm_itacc;
	mvp_register #(1) _pc_cnt0_evt5_id(pc_cnt0_evt5_id,gclk, pc_cnt0_evt5_i);
	mvp_register #(1) _pc_cnt0_evt5_idd(pc_cnt0_evt5_idd,gclk, pc_cnt0_evt5_id);
	assign pc_cnt0_evt[5] = pc_cnt0_evt5_idd & ((cpz_gm_i & ~mmu_r_itexc_i & ~mmu_r_itxiexc_i) | !cpz_gm_i);	//delay two cycles for special scene of root eret to guest mode 
	assign pc_cnt1_evt5_i = pc_ctl1_ec[1]==cpz_gm_i & mmu_pm_itmiss;
	mvp_register #(1) _pc_cnt1_evt5_id(pc_cnt1_evt5_id,gclk, pc_cnt1_evt5_i);
	mvp_register #(1) _pc_cnt1_evt5_idd(pc_cnt1_evt5_idd,gclk, pc_cnt1_evt5_id);
	assign pc_cnt1_evt[5] = pc_cnt1_evt5_idd & ((cpz_gm_i & ~mmu_r_itexc_i & ~mmu_r_itxiexc_i) | !cpz_gm_i);   	//deley two cycles for special scene of root eret to guest mode
	//pc_cnt0_evt[5] = pc_ctl0_ec[1]==cpz_gm_i & mmu_pm_itacc;  // ITLB access
	//pc_cnt1_evt[5] = pc_ctl1_ec[1]==cpz_gm_i & mmu_pm_itmiss; // ITLB miss
	assign pc_cnt0_evt[6] = pc_ctl0_ec[1]==cpz_gm_m & mmu_pm_dtacc & ((cpz_gm_m & ~mmu_r_dtexc_m & ~mmu_r_dtriexc_m) | !cpz_gm_m);  // DTLB access
	assign pc_cnt1_evt[6] = pc_ctl1_ec[1]==cpz_gm_m & mmu_pm_dtmiss & mmu_pm_dtlb_miss_qual & ~same_dtmiss & ((cpz_gm_m & ~mmu_r_dtexc_m & ~mmu_r_dtriexc_m) | !cpz_gm_m); // DTLB miss

	assign pc_cnt0_evt7_i = mmu_pm_jtacc_i; // JTLB I access (=== itlb miss)
	mvp_mux4 #(1) _pc_cnt0_evt7_vz_i(pc_cnt0_evt7_vz_i,pc_ctl0_ec,
	(mmu_r_pm_jtacc_i) & ~cpz_gm,
	(mmu_r_pm_jtacc_i) & ~cpz_gm_i & cpz_gm,
	(mmu_pm_jtacc_i) & cpz_gm_i, 
	(mmu_pm_jtacc_i) & cpz_gm_i | (mmu_r_pm_jtacc_i) & ~cpz_gm_i & cpz_gm);
	mvp_register #(1) _pc_cnt0_evt7_vz_id(pc_cnt0_evt7_vz_id,gclk, pc_cnt0_evt7_vz_i);
	mvp_register #(1) _pc_cnt0_evt7_id(pc_cnt0_evt7_id,gclk, pc_cnt0_evt7_i);
	mvp_register #(1) _pc_cnt0_evt7_vz_idd(pc_cnt0_evt7_vz_idd,gclk, pc_cnt0_evt7_vz_id);
	mvp_register #(1) _pc_cnt0_evt7_idd(pc_cnt0_evt7_idd,gclk, pc_cnt0_evt7_id);
	assign pc_cnt0_evt[7] = cpz_vz ? (pc_cnt0_evt7_vz_idd & ((cpz_gm_i & ~mmu_r_itexc_i & ~mmu_r_itxiexc_i) | !cpz_gm_i)) : pc_cnt0_evt7_idd;	//deley two cycles for special scene of root eret to guest mode

	assign pc_cnt1_evt7_i = mmu_pm_jtmiss_i; // JTLB I miss
	mvp_mux4 #(1) _pc_cnt1_evt7_vz_i(pc_cnt1_evt7_vz_i,pc_ctl1_ec,
	(mmu_r_pm_jtmiss_i) & ~cpz_gm,
	(mmu_r_pm_jtmiss_i) & ~cpz_gm_i & cpz_gm,
	(mmu_pm_jtmiss_i) & cpz_gm_i, 
	(mmu_pm_jtmiss_i) & cpz_gm_i | (mmu_r_pm_jtmiss_i) & ~cpz_gm_i & cpz_gm);
	mvp_register #(1) _pc_cnt1_evt7_vz_id(pc_cnt1_evt7_vz_id,gclk, pc_cnt1_evt7_vz_i);
	mvp_register #(1) _pc_cnt1_evt7_id(pc_cnt1_evt7_id,gclk, pc_cnt1_evt7_i);
	mvp_register #(1) _pc_cnt1_evt7_vz_idd(pc_cnt1_evt7_vz_idd,gclk, pc_cnt1_evt7_vz_id);
        mvp_register #(1) _pc_cnt1_evt7_idd(pc_cnt1_evt7_idd,gclk, pc_cnt1_evt7_id);
	assign pc_cnt1_evt[7] = cpz_vz ? (pc_cnt1_evt7_vz_idd & ((cpz_gm_m & ~mmu_r_dtexc_m & ~mmu_r_dtriexc_m) | !cpz_gm_m)) : pc_cnt1_evt7_idd;	//deley two cycles for special scene of root eret to guest mode

	assign pc_cnt0_evt8 = mmu_pm_jtacc_d; // JTLB D access
	mvp_mux4 #(1) _pc_cnt0_evt8_vz(pc_cnt0_evt8_vz,pc_ctl0_ec,
	(mmu_r_pm_jtacc_d) & ~cpz_gm,
	(mmu_r_pm_jtacc_d) & ~cpz_gm_m & cpz_gm,
	(mmu_pm_jtacc_d) & cpz_gm_m, 
	(mmu_pm_jtacc_d) & cpz_gm_m | (mmu_r_pm_jtacc_d) & ~cpz_gm_m & cpz_gm);
	mvp_register #(1) _pc_cnt0_evt8_vz_md(pc_cnt0_evt8_vz_md,gclk, pc_cnt0_evt8_vz);
	mvp_register #(1) _pc_cnt0_evt8_md(pc_cnt0_evt8_md,gclk, pc_cnt0_evt8);
	mvp_register #(1) _pc_cnt0_evt8_vz_mdd(pc_cnt0_evt8_vz_mdd,gclk, pc_cnt0_evt8_vz_md);
        mvp_register #(1) _pc_cnt0_evt8_mdd(pc_cnt0_evt8_mdd,gclk, pc_cnt0_evt8_md);
	assign pc_cnt0_evt[8] = cpz_vz ? (pc_cnt0_evt8_vz_mdd & & ((cpz_gm_m & ~mmu_r_dtexc_m & ~mmu_r_dtriexc_m) | !cpz_gm_m)) : pc_cnt0_evt8_mdd;

	assign pc_cnt1_evt8 = mmu_pm_jtmiss_d; // JTLB D miss
	mvp_mux4 #(1) _pc_cnt1_evt8_vz(pc_cnt1_evt8_vz,pc_ctl1_ec,
	(mmu_r_pm_jtmiss_d) & ~cpz_gm,
	(mmu_r_pm_jtmiss_d) & ~cpz_gm_m & cpz_gm,
	(mmu_pm_jtmiss_d) & cpz_gm_m, 
	(mmu_pm_jtmiss_d) & cpz_gm_m | (mmu_r_pm_jtmiss_d) & ~cpz_gm_m & cpz_gm);
	mvp_register #(1) _pc_cnt1_evt8_vz_md(pc_cnt1_evt8_vz_md,gclk, pc_cnt1_evt8_vz);
	mvp_register #(1) _pc_cnt1_evt8_md(pc_cnt1_evt8_md,gclk, pc_cnt1_evt8);
	mvp_register #(1) _pc_cnt1_evt8_vz_mdd(pc_cnt1_evt8_vz_mdd,gclk, pc_cnt1_evt8_vz_md);
        mvp_register #(1) _pc_cnt1_evt8_mdd(pc_cnt1_evt8_mdd,gclk, pc_cnt1_evt8_md);
	assign pc_cnt1_evt[8] = cpz_vz ? (pc_cnt1_evt8_vz_mdd & ((cpz_gm_m & ~mmu_r_dtexc_m & ~mmu_r_dtriexc_m) | !cpz_gm_m)) : pc_cnt1_evt8_mdd;

	assign pc_cnt0_evt[9] = icc_trstb | icc_twstb | icc_drstb; // I$ access
	assign pc_cnt1_evt[9] = icc_imiss_i & mpc_run_ie; // I$ miss
	assign pc_cnt0_evt[10] = dcc_lscacheread_m & dcc_dcached_m; // D$ access
	assign pc_cnt1_evt[10] = dcc_wb; // D$ writeback
	assign pc_cnt0_evt[11] = dcc_pm_dcmiss; // D$ miss
	assign pc_cnt1_evt[11] = dcc_pm_dcmiss; // D$ miss
	assign pc_cnt0_evt[12] = 1'b0;// Reserved(External Intervention Request)
	assign pc_cnt1_evt[12] = 1'b0;// Reserved(Ext. Intervention request)
	assign pc_cnt0_evt[13] = 1'b0;//
	assign pc_cnt1_evt[13] = 1'b0;// LD access missed in the cache
	//pc_cnt0_evt[14] = mpc_pm_complete & mpc_alu_w & (alu_cp0_pc0_tcen_xx);// Integer (non fp) instn completed
	assign pc_cnt0_evt[14] = mpc_pm_complete & mpc_alu_w;// Integer (non fp) instn completed
	assign pc_cnt1_evt[14] = 1'b0;// FP instns completed
	//pc_cnt0_evt[15] = ld_w_qual & mpc_pm_complete & (alu_cp0_pc0_tcen_xx);// Loads completed
	assign pc_cnt0_evt[15] = ld_w_qual & mpc_pm_complete;// Loads completed
	//pc_cnt1_evt[15] = mpc_pm_complete & st_w_qual & (alu_cp0_pc1_tcen_xx);// Stores completed
	assign pc_cnt1_evt[15] = mpc_pm_complete & st_w_qual;// Stores completed
	//pc_cnt0_evt[16] = mpc_pm_complete & jimm_w_qual & (alu_cp0_pc0_tcen_xx);// J/JAL completed
	assign pc_cnt0_evt[16] = mpc_pm_complete & jimm_w_qual;// J/JAL completed
	//pc_cnt1_evt[16] = mpc_pm_complete & cpz_eisa_x & (alu_cp0_pc1_tcen_xx);
	assign pc_cnt1_evt[16] = mpc_pm_complete & cpz_eisa_x;
	//pc_cnt0_evt[17] = nop_w_qual & mpc_pm_complete & (alu_cp0_pc0_tcen_xx);// NOPs
	assign pc_cnt0_evt[17] = nop_w_qual & mpc_pm_complete;// NOPs
	//pc_cnt1_evt[17] = muldiv_w_qual & mpc_pm_complete & (alu_cp0_pc1_tcen_xx);// Integer MDU instns completed
	assign pc_cnt1_evt[17] = muldiv_w_qual & mpc_pm_complete;// Integer MDU instns completed
	//pc_cnt0_evt[18] = mpc_bubble_e | mpc_fixupi;// General stalls
	assign pc_cnt0_evt[18] = bstall_ie;// General stalls,
	assign pc_cnt1_evt[18] = 1'b0;// replay traps
	//pc_cnt0_evt[19] = mpc_pm_complete & sc_w_qual & (alu_cp0_pc0_tcen_xx);// SC completed
	assign pc_cnt0_evt[19] = mpc_pm_complete & sc_w_qual;// SC completed
	//pc_cnt1_evt[19] = scfail_w_qual & mpc_pm_complete & (alu_cp0_pc1_tcen_xx);// SC failed
	assign pc_cnt1_evt[19] = scfail_w_qual & mpc_pm_complete;// SC failed
	//pc_cnt0_evt[20] = mpc_pm_complete & mpc_pref_w & (alu_cp0_pc0_tcen_xx);// PREF completed
	assign pc_cnt0_evt[20] = mpc_pm_complete & mpc_pref_w;// PREF completed
	assign pc_cnt1_evt[20] = mpc_pref_m & dcc_pm_dhit_m;// PREF hit
	assign pc_cnt0_evt[21] = 1'b0;// L2 writebacks
	assign pc_cnt1_evt[21] = 1'b0;// L2 Access
	assign pc_cnt0_evt[22] = 1'b0;// L2 Miss
	assign pc_cnt1_evt[22] = 1'b0;// L2 single bit error
	//pc_cnt0_evt[23] = ~cpz_vz ? mpc_auexc_on : pc_ctl0_ec[1] ? mpc_g_auexc_x_qual : mpc_r_auexc_x_qual;
	assign pc_cnt0_evt[23] = ~cpz_vz ? mpc_auexc_on : pc_ctl0_ec[1] ? mpc_g_auexc_x_pos : mpc_r_auexc_x_pos;
	assign pc_cnt1_evt[23] = 1'b0;// unused
	//pc_cnt0_evt[24] = mpc_fixupd & (alu_cp0_pc0_tcen_xx);// Cache Fixups
	assign pc_cnt0_evt[24] = mpc_fixupd;// Cache Fixups
	assign pc_cnt1_evt[24] = 1'b0;// refetches
	assign pc_cnt0_evt[25] = mpc_fixupi;// IFU stalls
	assign pc_cnt1_evt[25] = mpc_bubble_e;// ALU stalls
	assign pc_cnt0_evt[26] = 1'b0;// DSP instns
	assign pc_cnt1_evt[26] = 1'b0;// Saturations in ALU part of the DSP
	assign pc_cnt0_evt[27] = 1'b0;// unused
	assign pc_cnt1_evt[27] = 1'b0;// Saturations in MDU part of the DSP
	assign pc_cnt0_evt[28] = 1'b0;// unused
	//pc_cnt1_evt[28] = cp2_coppresent & (alu_cp0_pc1_tcen_xx);// Impl specific cop2
	assign pc_cnt1_evt[28] = cp2_coppresent;// Impl specific cop2
	//pc_cnt0_evt[29] = icc_sp_pres & (alu_cp0_pc0_tcen_xx);// Impl specific ISPRAM
	assign pc_cnt0_evt[29] = icc_sp_pres;// Impl specific ISPRAM
	//pc_cnt1_evt[29] = dcc_sp_pres & (alu_cp0_pc1_tcen_xx);// Impl specific DSPRAM
	assign pc_cnt1_evt[29] = dcc_sp_pres;// Impl specific DSPRAM
	assign pc_cnt0_evt[30] = 1'b0;// Impl Specific CorExtend
	assign pc_cnt1_evt[30] = 1'b0;// Reserved
	assign pc_cnt0_evt[31] = 1'b0;// unused
	assign pc_cnt1_evt[31] = 1'b0;// unused
	assign pc_cnt0_evt[32] = 1'b0;// ITC Loads
	assign pc_cnt1_evt[32] = 1'b0;// ITC stores
	//pc_cnt0_evt[33] = ucld_w_qual & mpc_pm_complete & (alu_cp0_pc0_tcen_xx);// Uncached Loads
	assign pc_cnt0_evt[33] = ucld_w_qual & mpc_pm_complete;// Uncached Loads
	//pc_cnt1_evt[33] = ucst_w_qual & mpc_pm_complete & (alu_cp0_pc0_tcen_xx);// Uncached stores, unliked dcc_uncached_load, dcc_uncached_store is wrong
	assign pc_cnt1_evt[33] = ucst_w_qual & mpc_pm_complete;// Uncached stores, unliked dcc_uncached_load, dcc_uncached_store is wrong
	assign pc_cnt0_evt[34] = 1'b0;// FORK instns
	assign pc_cnt1_evt[34] = 1'b0;// YIELDs
	//pc_cnt0_evt[35] = cp2a_w_qual & mpc_pm_complete & (alu_cp0_pc1_tcen_xx);// cop2 arithmetic instns
	assign pc_cnt0_evt[35] = cp2a_w_qual & mpc_pm_complete;// cop2 arithmetic instns
	//pc_cnt1_evt[35] = cp2tf_w_qual & mpc_pm_complete & (alu_cp0_pc1_tcen_xx); // cop2 to/from
	assign pc_cnt1_evt[35] = cp2tf_w_qual & mpc_pm_complete; // cop2 to/from
	assign pc_cnt0_evt[36] = 1'b0;// Pipe stall to process an intervention
	assign pc_cnt1_evt[36] = 1'b0;// Intervention response delay due to a hit on a pending read
	//pc_cnt0_evt[37] = icc_imiss_i & (alu_cp0_pc0_tcen_xx); // I$ miss stall cycles
	assign pc_cnt0_evt[37] = icc_imiss_i; // I$ miss stall cycles
	//pc_cnt1_evt[37] = dcc_dmiss_m & ~(pc_atomic_disqualify | pc_atomic_disqualify_d) & (alu_cp0_pc1_tcen_xx);// D$ miss stall cycles
	assign pc_cnt1_evt[37] = dcc_dmiss_m & ~(pc_atomic_disqualify | pc_atomic_disqualify_d);// D$ miss stall cycles
	assign pc_cnt0_evt[38] = 1'b0;// 
	assign pc_cnt1_evt[38] = 1'b0;// FSB index conflict stall cycles
	assign pc_cnt0_evt[39] = dcc_stall_m;// D$ miss cycles
	assign pc_cnt1_evt[39] = 1'b0;// L2 miss cycles
	//pc_cnt0_evt[40] = ((~mmu_icacabl & mpc_fixupi) | (mmu_dcmode0 & mpc_fixupd)) & (alu_cp0_pc0_tcen_xx);// Uncached stall cycles
	assign pc_cnt0_evt[40] = (~mmu_icacabl & mpc_fixupi) | (mmu_dcmode0 & mpc_fixupd);// Uncached stall cycles
	assign pc_cnt1_evt[40] = 1'b0;// outstanding ITC cycles
	//pc_cnt0_evt[41] = mdu_stall & (alu_cp0_pc0_tcen_xx);// MDU stall cycles
	//pc_cnt0_evt[41] = (mdu_stall|mdu_busy) & (alu_cp0_pc0_tcen_xx);
	assign pc_cnt0_evt[41] = mdu_stall|mdu_busy;
	assign pc_cnt1_evt[41] = 1'b0;// FPU stall cycles
	//pc_cnt0_evt[42] = cp2_stall_e & (alu_cp0_pc0_tcen_xx);// CP2 stall cycles
	assign pc_cnt0_evt[42] = cp2_stall_e;// CP2 stall cycles
	//pc_cnt1_evt[42] = edp_udi_stall_m & (alu_cp0_pc1_tcen_xx);// CorExtend stall cycles
	assign pc_cnt1_evt[42] = edp_udi_stall_m;// CorExtend stall cycles
	//pc_cnt0_evt[43] = icc_spram_stall & (alu_cp0_pc0_tcen_xx);// ISPRAM stall cycles
	assign pc_cnt0_evt[43] = icc_spram_stall;// ISPRAM stall cycles
	//pc_cnt1_evt[43] = dcc_dspram_stall & (alu_cp0_pc1_tcen_xx);// DSPRAM stall cycles
	assign pc_cnt1_evt[43] = dcc_dspram_stall;// DSPRAM stall cycles
	//pc_cnt0_evt[44] = (icc_icopstall | dcc_dcop_stall) & (alu_cp0_pc0_tcen_xx); // CACHE stall cycles
	assign pc_cnt0_evt[44] = icc_icopstall | dcc_dcop_stall; // CACHE stall cycles
	assign pc_cnt1_evt[44] = 1'b0;// Longstalls that could be flushed given runable TCs
	//pc_cnt0_evt[45] = ((mpc_ld_m & dcc_dmiss_m) | (mpc_ltu_e) ) & (alu_cp0_pc0_tcen_xx);// load to use stalls
	assign pc_cnt0_evt[45] = (mpc_ld_m & dcc_dmiss_m) | (mpc_ltu_e);// load to use stalls
	assign pc_cnt1_evt[45] = 1'b0;// ALU to AGEN stalls
	assign pc_cnt0_evt[46] = mpc_mcp0stall_e; // Other interlocks
	assign pc_cnt1_evt[46] = 1'b0;// Branch mispredict stalls
	assign pc_cnt0_evt[47] = 1'b0;// Relax bubbles
	assign pc_cnt1_evt[47] = 1'b0;// unused
	assign pc_cnt0_evt[48] = 1'b0;// IFU FB full refetches
	assign pc_cnt1_evt[48] = 1'b0;// FB entry allocated
	//pc_cnt0_evt[49] = iqual_49 & alu_cp0_pc0_tcen_xx;// Hardware inst trigger
	assign pc_cnt0_evt[49] = iqual_49;// Hardware inst trigger
	//pc_cnt1_evt[49] = dqual_49 & alu_cp0_pc1_tcen_xx;// Hardware data trigger
	assign pc_cnt1_evt[49] = dqual_49;// Hardware data trigger
	assign pc_cnt0_evt[50] = 1'b0;// FSB < 1/4 full
	assign pc_cnt1_evt[50] = 1'b0;// FSB 1/4-1/2 full
	assign pc_cnt0_evt[51] = 1'b0;// FSB > 1/2 full
	assign pc_cnt1_evt[51] = 1'b0;// FSB full stalls
	assign pc_cnt0_evt[52] = ~dcc_pm_fb_active; // LDQ < 1/4 full
	assign pc_cnt1_evt[52] = ~dcc_pm_fb_active; // LDQ 1/4-1/2 full
	assign pc_cnt0_evt[53] = dcc_pm_fb_active; // LDQ > 1/2 full
	assign pc_cnt1_evt[53] = dcc_pm_fbfull & ~mpc_run_m; // LDQ full
	assign pc_cnt0_evt[54] = ~biu_pm_wr_buf_b & ~biu_pm_wr_buf_f; // WBB < 1/4 full
	assign pc_cnt1_evt[54] = biu_pm_wr_buf_b ^ biu_pm_wr_buf_f; // WBB 1/4-1/2 full
	assign pc_cnt0_evt[55] = biu_pm_wr_buf_b & biu_pm_wr_buf_b; // WBB > 1/2 full
	assign pc_cnt1_evt[55] = biu_wtbf & ~mpc_run_m; // WBB full
	assign pc_cnt0_evt[127:56] = 0;// unused
	assign pc_cnt1_evt[127:56] = 0;// unused
	assign pc_cnt0_evt[128] = cpz_vz & mpc_r_auexc_x_pos & cpz_gm_x; // root exc in guest mode
	assign pc_cnt1_evt[128] = cpz_vz & ~cpz_gm_w & cpz_gm_x; // Guest exit (guest to root transition)
	assign pc_cnt0_evt[129] = cpz_vz & mpc_r_auexc_x_pos & cause_s[4:0]==5'h1b & cause_s[11:7]==5'h1; // GSFC
	assign pc_cnt1_evt[129] = cpz_vz & mpc_r_auexc_x_pos & cause_s[4:0]==5'h1b & cause_s[11:7]==5'h9; // GHFC
	assign pc_cnt0_evt[130] = cpz_vz & mpc_r_auexc_x_pos & cause_s[4:0]==5'h1b & cause_s[11:7]==5'h0; // GPSI
	assign pc_cnt1_evt[130] = cpz_vz & mpc_r_auexc_x_pos & cause_s[4:0]==5'h1b & cause_s[11:7]==5'h3; // GRR
	assign pc_cnt0_evt[131] = cpz_vz & mpc_r_auexc_x_pos & cause_s[4:0]==5'h1b & cause_s[11:7]==5'h2; // HyperCall
	assign pc_cnt1_evt[131] = 1'b0; // guest related Root TLB exc taken with GExcCode=GVA
	assign pc_cnt0_evt[132] = cpz_vz & mpc_r_auexc_x_pos & cpz_gm_x & mpc_tlb_i_side; // root TLB exc by I side guest access
	assign pc_cnt1_evt[132] = cpz_vz & mpc_r_auexc_x_pos & cpz_gm_x & mpc_tlb_d_side; // root TLB exc by D side guest access 
	assign pc_cnt0_evt[133] = cpz_vz & ~mpc_dmsquash_m & mpc_run_m & mpc_g_cp0move_m & ~mpc_load_m & mpc_cp0r_m==13 & cpz[30]==1; // root set Guest.Cause.TI
	assign pc_cnt1_evt[133] = cpz_vz & ~mpc_dmsquash_m & mpc_run_m & mpc_g_cp0move_m & ~mpc_load_m & mpc_cp0r_m==25 & (mpc_cp0sr_m[0]==1'h1) & cpz[31]==1; // root write to Guest.Count that cause Guest.Cause.PCI to be set
	assign pc_cnt0_evt[134] = 1'b0; // guest access to Watch Reg that cause GPSI when shared
	assign pc_cnt1_evt[134] = cpz_vz & mpc_r_auexc_x_pos & cpz_gm_x & mpc_gpsi_perfcnt; // guest access PerfCnt register that cause GPSI when virtually shared
	assign pc_cnt0_evt[135] = cpz_vz & mpc_r_auexc_x_pos & cpz_gm_x & cause_s[4:0]==5'b0 &  g_eic_mode; // interrupt that cause guest exit in EIC mode
	assign pc_cnt1_evt[135] = cpz_vz & mpc_r_auexc_x_pos & cpz_gm_x & cause_s[4:0]==5'b0 & ~g_eic_mode; // interrupt that cause guest exit in non-EIC mode
	assign pc_cnt0_evt[255:136] = 0;
	assign pc_cnt1_evt[255:136] = 0;

endmodule	// m14k_cpz_pc_top

