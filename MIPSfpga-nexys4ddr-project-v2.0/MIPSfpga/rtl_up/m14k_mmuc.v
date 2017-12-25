// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// 	Description: m14k_mmuc 
//          MMU control module
//
//	$Id: \$
//	mips_repository_id: m14k_mmuc.mv, v 1.16 
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
module m14k_mmuc(
	gclk,
	gscanenable,
	mpc_run_ie,
	mpc_fixupi,
	mpc_fixup_m,
	mpc_newiaddr,
	mpc_pexc_i,
	mpc_pexc_m,
	mpc_squash_i,
	mpc_annulds_e,
	mpc_nobds_e,
	dcc_newdaddr,
	lookupi,
	lookupd,
	mmu_type,
	cpz_mmutype,
	tlb_squash_i,
	imap,
	dmap,
	itlb_exc,
	itlb_xi_exc,
	dtlb_exc,
	dtlb_ri_exc,
	iva_trans,
	cacheiva_trans,
	mpc_itqualcond_i,
	mpc_continue_squash_i,
	icc_umipsfifo_stat,
	icc_slip_n_nhalf,
	edp_cacheiva_i,
	ivat_lo,
	mmu_dva_m,
	mmu_dva_mapped_m,
	edp_dva_e,
	edp_dva_mapped_e,
	dva_trans,
	dva_trans_mapped,
	mpc_busty_m,
	mpc_bussize_m,
	mpc_isamode_i,
	mpc_excisamode_i,
	mpc_lsdc1_m,
	cpz_hoterl,
	cpz_erl,
	cpz_k0cca,
	cpz_k23cca,
	cpz_kucca,
	cpz_kuc_i,
	cpz_kuc_m,
	itmack_idd,
	cpz_hotdm_i,
	cpz_dm_m,
	cpz_lsnm,
	ejt_disableprobedebug,
	mmu_dpah,
	mmu_ipah,
	ipa_cca,
	dpa_cca,
	itlb_bypass,
	dtlb_bypass,
	pre_dpah,
	pre_ipah,
	mmu_dcmode,
	mmu_icacabl,
	mmu_imagicl,
	mmu_it_segerr,
	mmu_adrerr,
	iadr_err_i,
	dadr_err_m,
	mmu_transexc,
	mmu_vafromi,
	mmu_itexc_i,
	mmu_itxiexc_i,
	mmu_rawitexc_i,
	mmu_dtexc_m,
	mmu_dtriexc_m,
	mmu_rawdtexc_m,
	mmu_ivastrobe,
	edp_iva_i,
	cpz_cdmmbase,
	cpz_cdmm_enable,
	fdc_present,
	cdmm_mpu_present,
	mmu_cdmm_kuc_m);

`include "m14k_mmu.vh"

	input		gclk;		// clock input
	input 		gscanenable;
	
	input 		mpc_run_ie;
	input 		mpc_fixupi;
	input 		mpc_fixup_m;
	input 		mpc_newiaddr;
	input 		mpc_pexc_i;
	input 		mpc_pexc_m;
	input 		mpc_squash_i;
	input		mpc_annulds_e;
	input		mpc_nobds_e;
	input 		dcc_newdaddr;

	input 		lookupi;
	input 		lookupd;
	
	input 		mmu_type;       // Raw mmu_type
	input 		cpz_mmutype;      // mmu_type from Config
	output 		tlb_squash_i;

	output 		imap;
	output 		dmap;
	input 		itlb_exc;
	input  		itlb_xi_exc;            // I-translation XI exception
	input 		dtlb_exc;
	input 		dtlb_ri_exc;            // D-translation RI exception

	input [`M14K_VPNRANGE] iva_trans;
	input [`M14K_VPNRANGE] cacheiva_trans; 
	input mpc_itqualcond_i;	
	input mpc_continue_squash_i;
	input [3:0]  icc_umipsfifo_stat;
	input	     icc_slip_n_nhalf;
	input [31:0] edp_cacheiva_i;

	input [1:0] 	ivat_lo;	
	output [`M14K_BUS] 	mmu_dva_m;
	output [31:29] 	mmu_dva_mapped_m;
	input [`M14K_BUS] 	edp_dva_e;
	input [31:29] 	edp_dva_mapped_e;
	input [`M14K_VPNRANGE] dva_trans;
	input [31:29] dva_trans_mapped;
	input [2:0] 	mpc_busty_m;
	input [1:0] 	mpc_bussize_m;
	input 		mpc_isamode_i;  //  I-stage instn is UMIPS
	input		mpc_excisamode_i; // changing isa mode without proper isa
	input		mpc_lsdc1_m;


	input 		cpz_hoterl;
	input 		cpz_erl;
        input [2:0] 	cpz_k0cca;   // kseg 0 cache attributes
        input [2:0] 	cpz_k23cca;  // kseg 2&3 cache attributes
        input [2:0] 	cpz_kucca;   // kuseg cache attributes
	input 		cpz_kuc_i;
	input 		cpz_kuc_m;
	input 		itmack_idd;
 
	input 		cpz_hotdm_i;
	input 		cpz_dm_m;
	input 		cpz_lsnm;
	input		ejt_disableprobedebug;	// disable ejtag mem space
	
	// translation inputs
	input [`M14K_PAH]	mmu_dpah;
	input [`M14K_PAH]	mmu_ipah;
	input [`M14K_CCA]	ipa_cca;
	input [`M14K_CCA]	dpa_cca;
 
	// translation outputs
	output 		itlb_bypass;
	output 		dtlb_bypass;
	output [`M14K_PAH]	pre_dpah;
	output [`M14K_PAH]	pre_ipah;
        output [2:0] 	   mmu_dcmode;  // takes the place of old DCacabl and DMagicl
	output 		mmu_icacabl;
	output 		mmu_imagicl;

	output		mmu_it_segerr;
	
 // Exception (ADEL/S) outputs
	output 		mmu_adrerr;		// Address error (init or D)
	output 		iadr_err_i;	// Instruction address error
	output 		dadr_err_m;	// Data address error
	output 		mmu_transexc;	// Address translation error
	output 		mmu_vafromi;	// Use ITLBH/JTLBH to load CP0 regs
	output 		mmu_itexc_i;	// init-addr translation exception
	output 		mmu_itxiexc_i;	// itlb execution inhibit exception
	output 		mmu_rawitexc_i;
	output 		mmu_dtexc_m;	// D-addr translation exception
	output 		mmu_dtriexc_m;	// D-addr RI exception
	output 		mmu_rawdtexc_m;
	output		mmu_ivastrobe;	// Strobe new Fetch PC into EJTAG

	input [`M14K_BUS] edp_iva_i;
	input [31:15]   cpz_cdmmbase;
	input		cpz_cdmm_enable;
	input		fdc_present;
	input		cdmm_mpu_present;
        output          mmu_cdmm_kuc_m;

// BEGIN Wire declarations made by MVP
wire mmu_rawitexc_i;
wire raw_run_ied;
wire d_wt_wa;
wire dtlb_bypass;
wire [1:0] /*[1:0]*/ icachem_reg;
wire mmu_transexc;
wire itlb_bypass;
wire probe_space_reg;
wire prefetch_m;
wire it_seg_err_i;
wire [`M14K_PAH] /*[31:10]*/ d_kseg_addr;
wire pre_icacabl;
wire it_seg_err_i_mips32;
wire [`M14K_PAH] /*[31:10]*/ ipah_reg;
wire mmu_itxiexc_i;
wire mmu_ivastrobe;
wire raw_dmap;
wire tlb_usable;
wire jmemd_raw;
wire iadr_err_i;
wire mmu_itexc_i;
wire it_kseg_n_i;
wire [`M14K_PAHHI : `M14K_PAHLO-2] /*[31:8]*/ ipah_icachem_reg;
wire [2:0] /*[2:0]*/ new_cache_mode;
wire d_uncacabl;
wire mmu_adrerr;
wire [`M14K_PAH] /*[31:10]*/ dpah_reg;
wire [`M14K_PAH] /*[31:10]*/ pre_dpah;
wire tlb_squash_i;
wire kseg0n;
wire [2:0] /*[2:0]*/ kseg_cca;
wire kseg23n;
wire early_i_cacabl;
wire dmap;
wire run_ied;
wire mmu_dtexc_m;
wire kusegn;
wire [2:0] /*[2:0]*/ dcache_mode_bits;
wire jmemd;
wire mmu_rawdtexc_m;
wire early_d_cacabl;
wire it_seg_err_i_umips;
wire mmu_it_segerr;
wire it_al_err_i;
wire d_wt_nwa;
wire [2:0] /*[2:0]*/ dcachem_reg;
wire imap;
wire [2:0] /*[2:0]*/ mmu_dcmode;
wire probe_space_i;
wire mmu_vafromi;
wire jmemi;
wire [`M14K_BUS] /*[31:0]*/ mmu_dva_m;
wire mmu_cdmm_kuc_m;
wire mmu_dcdmm_e;
wire [31:29] /*[31:29]*/ mmu_dva_mapped_m;
wire mmu_icacabl;
wire mmu_imagicl;
wire mmu_dtriexc_m;
wire [`M14K_PAH] /*[31:10]*/ i_kseg_addr;
wire mmu_rawitexc_i_raw;
wire [`M14K_PAH] /*[31:10]*/ pre_ipah;
wire dadr_err_m;
// END Wire declarations made by MVP

	
 
	mvp_register #(1) _raw_run_ied(raw_run_ied, gclk, (mpc_run_ie || mpc_fixupi));
	assign run_ied = raw_run_ied && !mpc_fixupi;

	mvp_ucregister_wide #(32) _mmu_dva_m_31_0_(mmu_dva_m[`M14K_BUS],gscanenable, mpc_run_ie, gclk, edp_dva_e);
	mvp_cregister #(3) _mmu_dva_mapped_m_31_29_(mmu_dva_mapped_m[31:29],mpc_run_ie, gclk, edp_dva_mapped_e);
	
	assign mmu_icacabl = itlb_bypass ? pre_icacabl : !((ipa_cca == 3'h2) || (ipa_cca == 3'h7));
	
	assign pre_icacabl = run_ied ? early_i_cacabl : icachem_reg[0];

        // KSeg cache attributes broken out
        assign kseg23n = (cpz_k23cca == 3'h2) || (cpz_k23cca == 3'h7);
        assign kseg0n = (cpz_k0cca == 3'h2) || (cpz_k0cca == 3'h7);
        assign kusegn = (cpz_kucca == 3'h2) || (cpz_kucca == 3'h7);

        // cca    0=WTnwa  1=WTwa 2=UC  3,4,5,6=WB 7=UC
        assign kseg_cca[2:0] = (dva_trans[31:30] == 2'b11) ? cpz_k23cca : // kseg2/3
			(dva_trans[31:29] == 3'b100) ? cpz_k0cca : // kseg0
			cpz_kucca;                            // kuseg
   
        // mmu_dcmode[2:0] -> x01=UC x11=magic x00=writeback 010=WT-WA
        //                                                   110=WT-NWA

	assign mmu_dcmode[2:0] =  (!dtlb_bypass) && ~mmu_dcdmm_e ? new_cache_mode : mpc_fixup_m ? dcachem_reg[2:0] : 
			   jmemd|mmu_dcdmm_e ? 3'b011 : early_d_cacabl ? dcache_mode_bits[2:0] : 3'b001;
	assign new_cache_mode[2:0] = d_uncacabl ? 3'b001 : d_wt_wa ? 3'b010 : d_wt_nwa ? 3'b110 : 3'b000;

        assign d_uncacabl = (dpa_cca == 3'h2) || (dpa_cca == 3'h7);
        assign d_wt_wa = (dpa_cca == 3'h1);				
        assign d_wt_nwa = (dpa_cca == 3'h0);

        assign dcache_mode_bits[2:0] = (kseg_cca[2:0] == 3'h0) ? 3'b110 : 
			      (kseg_cca[2:0] == 3'h1) ? 3'b010 : 3'b000; 
	




	assign early_i_cacabl =        !(jmemi ||                              // ejtag probe mem
				(cacheiva_trans[31:30]==2'b11) && kseg23n ||		// kseg2/3
				(cacheiva_trans[31:29]==3'b101) ||         		// kseg1
				(cacheiva_trans[31:29]==3'b100) && kseg0n ||		// kseg0
				!cacheiva_trans[31] && (cpz_hoterl || kusegn));	// kuseg

	assign early_d_cacabl =	!(jmemd ||				// ejtag probe mem
			  mmu_dcdmm_e ||	// cdmm mem
			  (dva_trans[31:30]==2'b11) && kseg23n ||	// kseg2/3
			  (dva_trans[31:29]==3'b101) ||		// kseg1
			  (dva_trans[31:29]==3'b100) && kseg0n ||	// kseg0
			  !dva_trans[31] && (cpz_erl || kusegn));	// kuseg
	assign mmu_imagicl = run_ied ? jmemi : icachem_reg[1];

	// Bus PAH[19:0]: physical address from ITLB, JTLB, or from an unmapped reference
        mvp_mux2 #(22) _pre_ipah_31_10_(pre_ipah[`M14K_PAH],run_ied, ipah_reg, i_kseg_addr);
        mvp_ucregister_wide #(24) _ipah_icachem_reg_31_8_(ipah_icachem_reg[`M14K_PAHHI : `M14K_PAHLO-2],gscanenable, 
			lookupi, gclk, {mmu_ipah, mmu_imagicl, mmu_icacabl});
        assign {ipah_reg [`M14K_PAH], icachem_reg [1:0]} = ipah_icachem_reg;

        assign itlb_bypass   = !imap || (!run_ied && !itmack_idd);
   
        mvp_mux2 #(22) _pre_dpah_31_10_(pre_dpah[`M14K_PAH],mpc_fixup_m, d_kseg_addr, dpah_reg);
        mvp_ucregister_wide #(22) _dpah_reg_31_10_(dpah_reg[`M14K_PAH],gscanenable, lookupd, gclk, mmu_dpah);   
        mvp_ucregister_wide #(3) _dcachem_reg_2_0_(dcachem_reg[2:0],gscanenable, lookupd, gclk, mmu_dcmode);   
        assign dtlb_bypass   = mpc_fixup_m || !dmap;

	// jmemi: Instn reference is to EJTAG Probe Mem
	assign jmemi = probe_space_i & iva_trans[31:20]==12'b111111110011 | 
		probe_space_i & iva_trans[31:20]==12'b111111110010 & ~ejt_disableprobedebug;


        assign jmemd_raw = probe_space_reg & dva_trans[31:20]==12'b111111110011 |
		    probe_space_reg & dva_trans[31:20]==12'b111111110010 & ~ejt_disableprobedebug;
	assign jmemd =  jmemd_raw;
	assign mmu_dcdmm_e = ({mmu_dpah[31:15]} == {cpz_cdmmbase[31:15]}) && (cdmm_mpu_present || fdc_present) && cpz_cdmm_enable;
        mvp_cregister #(1) _mmu_cdmm_kuc_m(mmu_cdmm_kuc_m,mmu_dcdmm_e, gclk, cpz_kuc_m);
	


	assign tlb_usable = !(mmu_type || cpz_mmutype);

	// imap: Instn reference is mapped
	assign imap = ~jmemi & ((~cacheiva_trans[31] & ~cpz_hoterl) | (cacheiva_trans[31:30]==2'b11)) & tlb_usable;

	// dmap: Data reference is mapped
	assign raw_dmap = !jmemd_raw && ((!dva_trans[31] && !cpz_erl) || dva_trans[31:30]==2'b11) && tlb_usable &&
	       (mpc_busty_m[0] || mpc_busty_m[1]);
	assign dmap = raw_dmap;

	// i_kseg_addr: kseg virtual to physical mapping
	assign i_kseg_addr [`M14K_PAH] = {cpz_hoterl ? (cacheiva_trans[31:30] == 2'b11) : cacheiva_trans[30],      // bit 31
				cpz_hoterl ? cacheiva_trans[30] : (cacheiva_trans[31] ^~ cacheiva_trans[30]),    // bit 30
					(cacheiva_trans[31:30] != 2'b10) & cacheiva_trans[29],  // bit 29
				cacheiva_trans[28:`M14K_VPNLO]};

	// d_kseg_addr: kseg virtual to physical mapping
	assign d_kseg_addr [`M14K_PAH] = { dva_trans_mapped, dva_trans[28:`M14K_VPNLO] };

	// Qualify ProbeSpace accesses
	assign probe_space_i = cpz_hotdm_i;
	assign probe_space_reg = cpz_dm_m & ~cpz_lsnm;


	// These are the changes necessary if NoDCR is nonconstant, or it is decided
	//   that we are no longer _required_ to hang when EJ_ProbEn isn't asserted.
	// In the current implementation, we do not need to distinguish between
	//  EJTAG Memory space and EJTAG register space.
	//

	assign it_al_err_i =  mpc_newiaddr && ((ivat_lo[1] && !mpc_isamode_i) ||
				    ivat_lo[0]);
	


	// ITKSeg2RB: save sign bit of VAT for checking on next clock
	assign it_kseg_n_i = ~(iva_trans[31]);  // iva_trans is  edp_ival_i


	// ITSegErr1A: instruction reference segmentation error
	assign it_seg_err_i_mips32 = cpz_kuc_i && !it_kseg_n_i && mpc_newiaddr;
// if state = 1 or 3, and we are at the off-aligned boundary without a half-word-instn, then it doesn't matter if
// the instn is in fifo or coming from fetch, the 2nd half is still a seg-reference
// if state = 0 or 2, we must be at least 4 bytes (aligned) away from the boundary. so we can't have seg error regardless
	assign it_seg_err_i_umips  =   (cpz_kuc_i && edp_cacheiva_i[31] && (&{edp_iva_i[30:1]} & ~edp_iva_i[31]) && 
				!mpc_annulds_e && !mpc_nobds_e &&
				(icc_slip_n_nhalf & ~(icc_umipsfifo_stat[3:0]==4'b0 | icc_umipsfifo_stat[3:0]==4'b0010) ));
// now, can't have edp_iva_i[1]=1 in mips32, so just 'or' these signals, don't need to gate them
	assign it_seg_err_i = it_seg_err_i_mips32 | it_seg_err_i_umips | mpc_excisamode_i;
	assign mmu_it_segerr = it_seg_err_i;



	// ITAdr1A: instruction address error
	assign iadr_err_i = it_al_err_i || it_seg_err_i;	

	assign mmu_adrerr =	mmu_dtexc_m ?	dadr_err_m : iadr_err_i;	

	// dadr_err_m: data reference address error
	assign dadr_err_m =  dcc_newdaddr && ((mpc_busty_m[0] || mpc_busty_m[1]) && 
		      ((mpc_bussize_m[0] && mmu_dva_m[0]) || 
		      (mpc_bussize_m == 3 && mmu_dva_m[1]) || 
		      (mpc_lsdc1_m && mmu_dva_m[2]) || 
		      (dva_trans[31] && cpz_kuc_m)));

// Move the address checking to the E/P stage.

	// prefetch_m
	assign prefetch_m = (mpc_busty_m == 3'h3);
   
	// mmu_dtexc_m: data translation exception
	assign mmu_dtexc_m =	!prefetch_m && !mpc_pexc_m && (dadr_err_m || dtlb_exc);

	// mmu_dtriexc_m: RI exception
	assign mmu_dtriexc_m =	!prefetch_m && !mpc_pexc_m && dtlb_ri_exc; 
	
	// mmu_rawdtexc_m:  Qualify this with !Pref for real exceptions
	assign mmu_rawdtexc_m = dadr_err_m || dtlb_exc || dtlb_ri_exc;

	assign mmu_rawitexc_i_raw = iadr_err_i || itlb_exc;
	assign mmu_rawitexc_i = ((iadr_err_i || itlb_exc || itlb_xi_exc) && mpc_itqualcond_i);

	// ITrExc1A: instruction reference translation error
	assign mmu_itexc_i =	(!tlb_squash_i && mmu_rawitexc_i_raw && mpc_itqualcond_i);

	// itlb execution inhibit exception
	assign mmu_itxiexc_i =	(!tlb_squash_i && itlb_xi_exc && mpc_itqualcond_i);

	assign mmu_transexc = (mmu_itexc_i || mmu_itxiexc_i || mmu_dtexc_m || mmu_dtriexc_m);

	// mmu_vafromi:  Use ITLBH instead of JTLBH to load CP0 regs
        assign mmu_vafromi = !(mmu_dtexc_m | mmu_dtriexc_m);
	
	// tlb_squash_i
	assign tlb_squash_i = (mpc_squash_i & ~mpc_continue_squash_i) || mpc_pexc_i;

	// Note that mmu_ivastrobe will be also be asserted for exceptional instructions
	// This allows us to prioritize edp_iva_e breaks above Address Errors and TLB exceptions.
	// The tlb_squash_i term blocks the strobe for the shadow of the excepting instruction.
	assign mmu_ivastrobe = (mpc_newiaddr || (mpc_continue_squash_i & mpc_run_ie) ) && !tlb_squash_i;


endmodule // m14k_mmuc

