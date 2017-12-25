// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// 	m14k_tlb_ctl: TLB control module
//
//	$Id: \$
//	mips_repository_id: m14k_tlb_ctl.mv, v 1.8 
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
module m14k_tlb_ctl(
	gscanenable,
	gclk,
	greset,
	mpc_run_ie,
	mpc_run_m,
	mpc_pcrel_m,
	mpc_dmsquash_m,
	mmu_dva_m,
	edp_iva_i,
	edp_cacheiva_i,
	mpc_busty_raw_e,
	mpc_busty_m,
	mpc_eexc_e,
	mpc_exc_e,
	mpc_exc_m,
	mpc_atomic_m,
	mpc_cp0func_e,
	mpc_ctlen_noe_e,
	mpc_irval_e,
	ixp,
	enhi,
	itlb_miss,
	dtlb_miss,
	dtlb_ri,
	dtlb_xi,
	tlb_match,
	jtlb_lo,
	iadr_err_i,
	mpc_newiaddr,
	dcc_newdaddr,
	dadr_err_m,
	dmap,
	imap,
	mmu_vat_hi,
	tlb_vpn,
	mmu_index,
	tlb_enable,
	tlb_wr_cmp,
	tlb_rd_0,
	tlb_rd_1,
	tlb_wr_0,
	tlb_wr_1,
	jtlb_wr,
	mmu_tlbshutdown,
	mmu_itmack_i,
	mmu_itmres_nxt_i,
	itmack_id,
	itmack_idd,
	mmu_dtmack_m,
	update_dtlb,
	tlb_squash_i,
	mmu_dtexc_m,
	mmu_dtriexc_m,
	itlb_exc,
	itlb_xi_exc,
	dtlb_exc,
	dtlb_ri_exc,
	store_trans_m,
	mmu_tlbrefill,
	mmu_tlbinv,
	mmu_tlbmod,
	cp0_read_m,
	cp0_probe_m,
	cp0random_val_e,
	mmu_tlbbusy,
	mmu_pm_itmiss,
	mmu_pm_ithit,
	mmu_pm_dtmiss,
	mmu_pm_dtlb_miss_qual,
	mmu_pm_dthit,
	mmu_pm_jthit,
	mmu_pm_jtmiss,
	mmu_pm_jthit_i,
	mmu_pm_jthit_d,
	mmu_pm_jtmiss_i,
	mmu_pm_jtmiss_d,
	mmu_r_pm_jthit_i,
	mmu_r_pm_jthit_d,
	mmu_r_pm_jtmiss_i,
	mmu_r_pm_jtmiss_d,
	lookupi,
	lookupd);

`include "m14k_mmu.vh"

        input           gscanenable;             // Scan Enable
	input		gclk;		         // clock input
	input		greset;		         // reset

	input		mpc_run_ie;		// I-stage pipeline control
	input		mpc_run_m;		// M-stage pipeline control

        input		mpc_pcrel_m;                // A PC-relative instr. in the M-stage

        input 		mpc_dmsquash_m;	        // Kill Dcache miss due to M-stage Exception
   
	input [`M14K_BUS]	mmu_dva_m;	// Data virtual address
	
	input [`M14K_BUS]	edp_iva_i;	// for vat_hi and writing to tlb_cpy
	input [`M14K_BUS]	edp_cacheiva_i; // Instr virtual address, source resident I-stage register

	input [2:0]	mpc_busty_raw_e;	// Bus operation type: (nil, load, store, pref, sync, init$Op, D$Op)
	input [2:0]	mpc_busty_m;	        // Bus operation type: (nil, load, store, pref, sync, init$Op, D$Op)
	input		mpc_eexc_e;		// early exception detected in E-stage
	input		mpc_exc_e;		// E-stage instn killed by exception 
	input		mpc_exc_m;		// M-stage instn killed by exception 
	input		mpc_atomic_m;		// atomic instn in M stage

	input [5:0] 	mpc_cp0func_e;          // C0 Function field
	input 		mpc_ctlen_noe_e;        // Early enable signal, not qualified with Exc_E
	input 		mpc_irval_e;            // Earlier enable signal, not qualified with Exc_E or Run_E
	
	// CPY inputs
	input [4:0]	ixp;		        // index for cp0 operation to MMU
	input [`M14K_VPN2RANGEENHI]	enhi;	// CP0 enhi register

	
	// ITLB inputs
	input 		itlb_miss;	        // ITLB miss indication

	// DTLB inputs
	input 		dtlb_miss;	        // DTLB miss indication
        input		dtlb_ri;		// The Read Inhibit bit is set
        input		dtlb_xi;		// The Execite Inhibit bit is set

	// JTLB inputs
	
	input		tlb_match;	        // Joint TLB match indication
	input [`M14K_JTLBL]	jtlb_lo;	// Lo bits of matching TLB entry

	// MMUC inputs
	input 		iadr_err_i;             // I address error detected
	input 		mpc_newiaddr;           // New I-stage address
	input 		dcc_newdaddr;           // New M-stage address
	input 		dadr_err_m;             // D address error detected
	input 		dmap;                   // D ref is mapped
	input 		imap;                   // I ref is mapped
	
	// CPY outputs
	output [`M14K_VPN2RANGE] mmu_vat_hi;	        // Hi bits of translated address

	// JTLB outputs
	output [`M14K_VPNRANGE] tlb_vpn;	        // virtual address to jtlb
	output [4:0]	mmu_index;              // JTLB Index
	output 		tlb_enable;             // TLB CAM enable
	output 		tlb_wr_cmp;             // TLB Write Compare
	output 		tlb_rd_0;               // TLB Read Even + Tag
	output 		tlb_rd_1;               // TLB Read Odd
	output 		tlb_wr_0;               // TLB Write Even + Tag
	output 		tlb_wr_1;               // TLB Write Odd

	output		jtlb_wr;	        // Write entrylo1 into the JTLB
	
	// Misc outputs
	output		mmu_tlbshutdown;	// conflict detected on TLB write
	output		mmu_itmack_i;	        // ITLB Miss
	output		mmu_itmres_nxt_i;
	output		itmack_id;	        // ITLB Miss is accessing JTLB
	output		itmack_idd;	        // ITLB Miss is accessing JTLB
	output		mmu_dtmack_m;	        // DTLB Miss
	output 		update_dtlb;            // Write DTLB with JTLB output
	input 		tlb_squash_i;           // I-stage instn is being killed
	
	
	input		mmu_dtexc_m;	        // data reference translation error
	input 		mmu_dtriexc_m;		// D-addr RI exception
	output 		itlb_exc;               // I-translation exception
	output 		itlb_xi_exc;            // I-translation XI exception
	output 		dtlb_exc;               // D-translation exception
	output 		dtlb_ri_exc;            // D-translation RI exception
	output 		store_trans_m;          // Store 
	output 		mmu_tlbrefill;	        // TLB Refill exception
	output 		mmu_tlbinv;	        // TLB Invalid exception
	output 		mmu_tlbmod;		// TLB modified exception

	output 		cp0_read_m;             // TLBR instn
	output 		cp0_probe_m;            // TLBP instn
	output 		cp0random_val_e;        // Early indication of TLBWR

	output 		mmu_tlbbusy;            // TLB is in midst of multi-cycle operation

	output		mmu_pm_itmiss;	        // ITLB miss performance monitoring signal
	output		mmu_pm_ithit;	        // ITLB hit performance monitoring signal
	output		mmu_pm_dtmiss;	        // DTLB miss performance monitoring signal
	output		mmu_pm_dtlb_miss_qual;
	output		mmu_pm_dthit;	        // DTLB hit performance monitoring signal
	output		mmu_pm_jthit;	        // JITLB hit performance monitoring signal
	output		mmu_pm_jtmiss;	        // JITLB miss performance monitoring signal
	output		mmu_pm_jthit_i;
	output		mmu_pm_jthit_d;
	output		mmu_pm_jtmiss_i;
	output		mmu_pm_jtmiss_d;
	output		mmu_r_pm_jthit_i;
	output		mmu_r_pm_jthit_d;
	output		mmu_r_pm_jtmiss_i;
	output		mmu_r_pm_jtmiss_d;

	output 		lookupi;                // Enable I translation
	output 		lookupd;                // Enable D translation

// BEGIN Wire declarations made by MVP
wire jtlb_wr;
wire tlb_matchc;
wire update_dtlb;
wire cp0_probe_m;
wire cp0write_m;
wire mmu_pm_dthit;
wire mmu_tlbmod;
wire dtmack_md;
wire mmu_r_pm_jtmiss_d;
wire dtlbmiss_inh;
wire cp0read_noe_e;
wire tlb_rd_0;
wire load_trans_m;
wire tlb_ri;
wire iexc_i;
wire lookupi;
wire fxcp0read_noe_ed;
wire mmu_pm_jthit_i;
wire cp0write_e;
wire sel_enhi_m;
wire dtlb_exc;
wire mmu_pm_jtmiss;
wire fxcp0write_noe_e;
wire mmu_tlbbusy;
wire tlb_wr_0;
wire lookupd;
wire [4:0] /*[4:0]*/ ixphold;
wire tlb_valid;
wire cp0_read_m;
wire dtpm_strobed;
wire mmu_r_pm_jthit_d;
wire tlb_rd_1;
wire itlb_xi_exc;
wire itrefill_i;
wire dtinv_m;
wire mmuinstref;
wire [4:0] /*[4:0]*/ mmu_index;
wire itlb_exc;
wire mmu_pm_jthit;
wire mmu_r_pm_jtmiss_i;
wire cp0random_val_e;
wire mmu_pm_jthit_d;
wire dtmod_m;
wire raw_cp0_read_m;
wire cp0probe_noe_e;
wire fxexc_e;
wire [`M14K_VPNRANGE] /*[31:10]*/ tlb_vpn;
wire raw_dtinv;
wire fxexc_ed;
wire cp0write_noe_e;
wire tlb_enable;
wire dtlb_ri_exc;
wire tlb_xi;
wire raw_dtlb_exc;
wire tlb_wr_1;
wire raw_dtri_exc;
wire mmu_pm_dtlb_miss_qual;
wire tlb_dirty;
wire mmu_itmres_nxt_i;
wire rwfirstcycle;
wire itmack_idd;
wire fxcp0write_noe_ed;
wire store_trans_m;
wire mmu_tlbshutdown;
wire mmu_pm_itmiss;
wire mmu_pm_ithit;
wire cp0read_e;
wire mmu_pm_dtmiss;
wire itinv_i;
wire raw_itinv;
wire tlb_enable_noi;
wire mmu_pm_jtmiss_i;
wire tlb_wr_cmp;
wire mmu_r_pm_jthit_i;
wire mmu_itmack_i;
wire fx_cp0_probe_noe_ed;
wire mmu_pm_jtmiss_d;
wire rawcp0write_m;
wire mmu_dtmack_m;
wire mmu_tlbrefill;
wire itmack_id;
wire raw_cp0_probe_m;
wire dtrefill_m;
wire rwhold;
wire [`M14K_VPN2RANGE] /*[31:11]*/ mmu_vat_hi;
wire mmu_tlbinv;
wire fxcp0read_noe_e;
wire fx_cp0_probe_noe_e;
wire holditmack_i;
wire cp0write_md;
// END Wire declarations made by MVP

	

	// Decode Cp0 ops
	// Cp0Probe_E: Cp0 probe operation
	assign cp0probe_noe_e = ~mpc_cp0func_e[5] & mpc_cp0func_e[3] & ~mpc_cp0func_e[4] & mpc_ctlen_noe_e;

	// cp0write_e: Cp0 write operation
	assign cp0write_noe_e = ~mpc_cp0func_e[5] & mpc_cp0func_e[1] & ~mpc_cp0func_e[0] & mpc_ctlen_noe_e;

	// cp0read_e: Cp0 read operation
	assign cp0read_noe_e =	 ~mpc_cp0func_e[5] & mpc_cp0func_e[0] & ~mpc_cp0func_e[4] & mpc_ctlen_noe_e;

	// Cp0Random_E: Cp0 random operation
	assign cp0random_val_e = ~mpc_cp0func_e[5] & mpc_cp0func_e[2] & ~mpc_cp0func_e[0] && mpc_irval_e;

	// Signal MPC to stall any new L/S or Cp0 ops while TLB is busy
	// Probe is included to make TLBR immediately after TLBP work
	mvp_register #(1) _mmu_tlbbusy(mmu_tlbbusy, gclk, (fxcp0read_noe_e || fxcp0write_noe_e || fx_cp0_probe_noe_e) && !fxexc_e ||
			          cp0write_m);

	// Recirculate CP0 TLB instns across E-M border if M-stage is not running
	// 
	// Disable CP0 TLB accesses during fixup cycles
	assign fxcp0read_noe_e  = mpc_run_m ? cp0read_noe_e : fxcp0read_noe_ed;
	mvp_register #(1) _fxcp0read_noe_ed(fxcp0read_noe_ed, gclk, fxcp0read_noe_e);

	assign fxcp0write_noe_e  = mpc_run_m ? cp0write_noe_e : fxcp0write_noe_ed;
	mvp_register #(1) _fxcp0write_noe_ed(fxcp0write_noe_ed, gclk, fxcp0write_noe_e);

	assign fx_cp0_probe_noe_e  = mpc_run_m ? cp0probe_noe_e : fx_cp0_probe_noe_ed;
	mvp_register #(1) _fx_cp0_probe_noe_ed(fx_cp0_probe_noe_ed, gclk, fx_cp0_probe_noe_e);

	mvp_cregister #(1) _raw_cp0_probe_m(raw_cp0_probe_m,mpc_run_m, gclk, fx_cp0_probe_noe_e && !fxexc_e);
	assign cp0_probe_m = raw_cp0_probe_m && mpc_run_m;

	assign fxexc_e = mpc_run_m ? mpc_exc_e : (fxexc_ed || mpc_exc_m);
	mvp_register #(1) _fxexc_ed(fxexc_ed, gclk, fxexc_e);
	
	// local versions of tlb-related Cp0 op signals
	assign cp0read_e = fxcp0read_noe_e && !fxexc_e;
	assign cp0write_e = fxcp0write_noe_e && !fxexc_e;

	// mmu_index:  MMU entry to read or write for cp0 indexed ops
	// Hold the index for the duration of the TLB op
	assign rwhold = raw_cp0_read_m || rawcp0write_m || cp0write_md;
	assign mmu_index [4:0] = rwhold ? ixphold : ixp;
	// Conditionally latch the index on first clock of TLB read or write
	assign rwfirstcycle = (cp0read_noe_e || cp0write_noe_e);
	mvp_ucregister_wide #(5) _ixphold_4_0_(ixphold[4:0],gscanenable, rwfirstcycle, gclk, mmu_index);

	// mmu_tlbshutdown: 
	//  Flag a "shutdown" collision if matching tlb entry index
	//  is not the same as the one which will be written.
	//  Hardware in jtlb array disables match for the entry to
	//  be written during the write compare, so any tlb_match which
	//  occurs is indicative of a multiple-match condition.
	mvp_register #(1) _mmu_tlbshutdown(mmu_tlbshutdown, gclk, (cp0write_m && tlb_match));

	// mmuinstref: MMU operation is for an instruction reference
	assign mmuinstref = mmu_itmack_i && !itmack_id && !tlb_enable_noi && 
		     !(fx_cp0_probe_noe_e || fxcp0read_noe_e || fxcp0write_noe_e || raw_cp0_read_m) && 
		     !(rawcp0write_m || cp0write_md);

	// Bus tlb_vpn[31:12]: TLB tag to compare against for content-addressable access
	// Select enhi as source for all TLB cp0 ops that use tlb comparators, as well
	//  as write to tlb tags
	assign tlb_vpn [`M14K_VPNRANGE] = sel_enhi_m ? {enhi[`M14K_VPN2RANGEENHI], 1'b0} :
				itmack_id ? edp_cacheiva_i[`M14K_VPNRANGE] :
				mmu_dva_m[`M14K_VPNRANGE];
	
	mvp_register #(1) _sel_enhi_m(sel_enhi_m, gclk, tlb_matchc || rawcp0write_m);

	assign mmu_vat_hi [`M14K_VPN2RANGE] = mmu_dtexc_m | mmu_dtriexc_m ? mmu_dva_m[`M14K_VPN2RANGE] : 
				edp_cacheiva_i[`M14K_VPN2RANGE];

	// iexc_i: Qualify ITLB Miss with early exceptions
	assign iexc_i = iadr_err_i | mpc_eexc_e | tlb_squash_i;

	mvp_register #(1) _rawcp0write_m(rawcp0write_m, gclk, cp0write_e);

	assign cp0write_m = rawcp0write_m && mpc_run_m && !mpc_exc_m;
	
	mvp_register #(1) _cp0write_md(cp0write_md, gclk, cp0write_m);

	// Itlb Miss Indicator:  Kill consecutive Miss indicators unless
	// TLB R/W is still going on so we can't get access to JTLB
	assign mmu_itmack_i =  (itlb_miss && mpc_newiaddr || holditmack_i) && 
		    imap && !iexc_i;

	// Indication to ICC that ITLB miss has accessed JTLB and
	// translation will be available in the next cycle
	assign mmu_itmres_nxt_i = itmack_id;

	// ITMAck2R:
	mvp_register #(1) _holditmack_i(holditmack_i, gclk, mmu_itmack_i && !itmack_id);
	
	mvp_register #(1) _itmack_id(itmack_id, gclk, mmuinstref);
	mvp_register #(1) _itmack_idd(itmack_idd, gclk, itmack_id);

	assign load_trans_m = (mpc_busty_m == 3'h1) & !mpc_atomic_m; 
	assign dtlbmiss_inh = dtlb_miss 
		 | (dtlb_ri & load_trans_m & (~mpc_pcrel_m | dtlb_xi)); 

	assign mmu_dtmack_m = dtlbmiss_inh && dcc_newdaddr && !dtmack_md && dmap;

	assign update_dtlb = mmu_dtmack_m && !(dadr_err_m || raw_dtlb_exc || raw_dtri_exc);
	
	mvp_register #(1) _dtmack_md(dtmack_md, gclk, mmu_dtmack_m);


	assign lookupi = mpc_newiaddr || itmack_idd;
	assign lookupd = dcc_newdaddr || dtmack_md;
	
	// store_trans_m 
	assign store_trans_m = (mpc_busty_m == 3'h2) | mpc_atomic_m;

	// DTMiss_M: data reference missed in ITLB
        assign raw_dtinv = !tlb_valid;
	assign raw_dtlb_exc = ~dadr_err_m & dcc_newdaddr & dmap & ( ~tlb_match | raw_dtinv | (~tlb_dirty & store_trans_m));
	assign raw_dtri_exc = (tlb_ri & tlb_valid & load_trans_m & (~mpc_pcrel_m | tlb_xi))  
		& ~dadr_err_m & dcc_newdaddr & dmap; 

	mvp_register #(1) _dtlb_exc(dtlb_exc, gclk, raw_dtlb_exc);
	mvp_register #(1) _dtlb_ri_exc(dtlb_ri_exc, gclk, raw_dtri_exc);

	mvp_register #(1) _dtinv_m(dtinv_m, gclk, dmap && tlb_match && raw_dtinv && !dadr_err_m && dcc_newdaddr);

	// DRefill_M: TLB Refill Exception
	mvp_register #(1) _dtrefill_m(dtrefill_m, gclk, dmap && !tlb_match && !dadr_err_m && dcc_newdaddr);

	// DMod_M: TLB modified exception

	mvp_register #(1) _dtmod_m(dtmod_m, gclk, dmap && tlb_valid && !dadr_err_m && !tlb_dirty && store_trans_m && dcc_newdaddr);


//*******************************************
// Performance monitoring outputs
//*******************************************
	// mmu_pm_ithit:  Performance signal indicating that itlb reference hit
	assign mmu_pm_ithit =	(!itlb_miss && mpc_newiaddr) && 
			imap && !iexc_i && !itmack_id;

	assign mmu_pm_itmiss = itmack_id;

	// mmu_pm_dthit:  Performance signal indicating that dtlb reference hit
	mvp_register #(1) _mmu_pm_dthit(mmu_pm_dthit, gclk, (!dtlb_miss && dcc_newdaddr) && !(dadr_err_m || dtlb_exc || dtlb_ri_exc) &&
			dmap && !dtpm_strobed);

	assign mmu_pm_dtmiss = dtmack_md;

	assign mmu_pm_dtlb_miss_qual = dtlb_miss;
	// Only signal one hit/miss per instruction
	mvp_register #(1) _dtpm_strobed(dtpm_strobed, gclk, (dcc_newdaddr || dtpm_strobed) && !mpc_run_m);
	

	// mmu_pm_jthit:  Performance signal indicating that jtlb reference hit
	assign mmu_pm_jthit =	!tlb_squash_i & tlb_match & !raw_itinv & itmack_id |
			dmap & dcc_newdaddr & !dtpm_strobed & (!raw_dtinv & tlb_match & (mpc_busty_m[0] | (tlb_dirty & store_trans_m)));
	assign mmu_pm_jthit_i = !tlb_squash_i & tlb_match & !raw_itinv & itmack_id; 
	assign mmu_pm_jthit_d = dmap & dcc_newdaddr & !dtpm_strobed & (!raw_dtinv & tlb_match & (mpc_busty_m[0] | (tlb_dirty & store_trans_m)));

	// mmu_pm_jtmiss:  Performance signal indicating that jtlb reference missed
	assign mmu_pm_jtmiss =	~tlb_squash_i & (~tlb_match | raw_itinv) & itmack_id |
			dmap & dcc_newdaddr & ~dtpm_strobed & (raw_dtinv | ~tlb_match | (~tlb_dirty & store_trans_m));
	assign mmu_pm_jtmiss_i =	~tlb_squash_i & (~tlb_match | raw_itinv) & itmack_id; 
	assign mmu_pm_jtmiss_d =	dmap & dcc_newdaddr & ~dtpm_strobed & (raw_dtinv | ~tlb_match | (~tlb_dirty & store_trans_m));

	assign mmu_r_pm_jthit_i = 1'b0;
	assign mmu_r_pm_jthit_d = 1'b0;
	assign mmu_r_pm_jtmiss_i = 1'b0;
	assign mmu_r_pm_jtmiss_d = 1'b0;

	
	assign raw_itinv = ~tlb_valid;

	mvp_register #(1) _itlb_exc(itlb_exc, gclk, itmack_id & (~tlb_match | raw_itinv));
	mvp_register #(1) _itlb_xi_exc(itlb_xi_exc, gclk, itmack_id & tlb_match & tlb_xi & tlb_valid);

	// IRefill: instruction TLB refill exception
	mvp_register #(1) _itrefill_i(itrefill_i, gclk, !tlb_squash_i && !tlb_match && itmack_id);

	// itinv_i: instn TLB invalid exception
	mvp_register #(1) _itinv_i(itinv_i, gclk, ~tlb_squash_i & itmack_id & tlb_match & raw_itinv);

	assign mmu_tlbrefill = mmu_dtexc_m ? dtrefill_m : itrefill_i;

	assign mmu_tlbinv = mmu_dtexc_m ? dtinv_m : itinv_i;
	assign mmu_tlbmod = dtmod_m;

	// cp0_read_m: 
	mvp_register #(1) _raw_cp0_read_m(raw_cp0_read_m, gclk, cp0read_e);
	assign cp0_read_m = raw_cp0_read_m && mpc_run_m;
	
	assign tlb_rd_0 = cp0read_e;
	assign tlb_rd_1 = cp0_read_m;

	// tlb_matchc: Cp0 op requires match lines to leave precharge
	assign tlb_matchc =	(fx_cp0_probe_noe_e || fxcp0read_noe_e || fxcp0write_noe_e) && !fxexc_e || raw_cp0_read_m;

	// tlb_enable: Do a TLB lookup
	assign tlb_enable =	(tlb_enable_noi ? 1'b1 : mmu_itmack_i) && !greset;

	// Remove dmap from tlb_enable_noi, and move equivalent dmap effect to following clock
	assign tlb_enable_noi = (mpc_busty_raw_e[0] | mpc_busty_raw_e[1]) | ((fx_cp0_probe_noe_e |  fxcp0write_noe_e) & !fxexc_e);

	// Read the tlb with incoming write data to check for conflicts
	assign tlb_wr_cmp =	cp0write_e;
	// Write the tlb in 2 consecutive clocks, if the write compare did not hit.
	assign tlb_wr_0 =	cp0write_m && !(tlb_match) && !mpc_dmsquash_m;
	mvp_register #(1) _tlb_wr_1(tlb_wr_1, gclk, tlb_wr_0);

	assign jtlb_wr = tlb_wr_0 || tlb_wr_1;

	// tlb_dirty: dirty bit
	assign tlb_dirty =	jtlb_lo[`M14K_DIRTYBIT];

	// tlb_valid: valid bit
	assign tlb_valid =	jtlb_lo[`M14K_VALIDBIT];

	// tlb_ri: read inhibit bit
	assign tlb_ri =	jtlb_lo[`M14K_RINHBIT];

	// tlb_xi: execute inhibit bit
	assign tlb_xi =	jtlb_lo[`M14K_XINHBIT];
	

endmodule	// m14k_tlb_ctl
