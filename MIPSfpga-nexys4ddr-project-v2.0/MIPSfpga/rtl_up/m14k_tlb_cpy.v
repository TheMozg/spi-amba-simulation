// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	m14k_tlb_cpy- Coprocessor Zero - TLB registers
//	System control coprocessor
//
//      $Id: \$
//      mips_repository_id: m14k_tlb_cpy.mv, v 1.20 
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
module m14k_tlb_cpy(
	gscanenable,
	edp_alu_m,
	greset,
	mpc_cp0move_m,
	cp0_probe_m,
	cp0_read_m,
	mpc_cp0r_m,
	mpc_cp0sr_m,
	cpz_smallpage,
	cp0random_val_e,
	mpc_dmsquash_m,
	enc,
	mpc_jamtlb_w,
	mpc_load_m,
	mpc_ll1_m,
	mpc_fixup_m,
	mpc_run_m,
	mmu_vat_hi,
	edp_dpal,
	tag_array_out,
	mmu_dpah,
	jtlb_lo,
	tlb_match,
	tlb_wr_1,
	cpz_mmusize,
	mmu_transexc,
	gclk,
	cpz_vz,
	mmu_type,
	is_root,
	cpz_gm_m,
	mmu_cpyout,
	enhi,
	entrylo,
	gbit,
	inv,
	ixp,
	pagemask,
	mmu_asid,
	mmu_asid_valid,
	pagegrain,
	asid_update,
	mmu_iec,
	mmu_read_m);

`include "m14k_mmu.vh"

	/* Inputs */
        input           gscanenable;        // Scan Enable
	input [31:0]	edp_alu_m;  // ALU result bus -> cpz write data
	input		greset;             // global reset
	input		mpc_cp0move_m;	    // MT/F C0
	input		cp0_probe_m;	    // Cp0 probe operation
	input		cp0_read_m;	    // Cp0 read operation
	input [4:0]	mpc_cp0r_m;	    // coprocessor zero register specifier
        input [2:0]     mpc_cp0sr_m;        // coprocessor zero shadow register specifier
	input		cpz_smallpage;		// Small (1KB) page support
	input		cp0random_val_e;    // Cp0 random operation
        input 		mpc_dmsquash_m;     // Exc_M without translation exceptions or interrupts
	input [4:0]	enc;		    // TLB encoder output
	input		mpc_jamtlb_w;       // load translation related registers from shadow regs
	input		mpc_load_m;	    // xfer direction for load/store/cpmv - 0:=to proc; 1:=from proc
	input		mpc_ll1_m;	    // Load linked in first clock of M
	input 		mpc_fixup_m;        // Fixup M-stage
	input 		mpc_run_m;          // Run M-stage
	input [`M14K_VPN2RANGE] mmu_vat_hi;      // High part of virtual address for translation
	input [`M14K_PAL]    edp_dpal;       // Low part of data physical address
	input [`M14K_JTLBH]  tag_array_out;    // JTLB HI output

	input [`M14K_PAH]	mmu_dpah;   // JTLB LO output
	input [`M14K_JTLBL]	jtlb_lo;    // JTLB LO output
	input		tlb_match;	    // TLB match
	input		tlb_wr_1;           // Second clock of writing to TLB (select enlo1)
        input	[1:0]	cpz_mmusize;        // JTLB is 32 entries (0 => 16 entries)
	input		mmu_transexc;       // Translation exception - load shadow registers
	input		gclk;		    // Clock
	input		cpz_vz;
	input	        mmu_type;
	input	        is_root;
	input	        cpz_gm_m;

	/* Outputs */
	output [31:0]	mmu_cpyout;   // Read data for MFC0 & SC register updates
	output [`M14K_ENHIRANGE] enhi;	      // entry hi register (output of phase mux)
	output [`M14K_JTLBDATA]  entrylo;      // entry lo0/1 bus for tlb write
	output		gbit;		      // Global bit anded from enlo0/1
	output		inv;
	output [4:0]	ixp;		      // index for tlb read/write
	output [`M14K_CMASK]	pagemask;     // compressed Page mask register
	output [`M14K_ASID]  mmu_asid;         // Load/store Normal Memory from DEBUG
	output 			mmu_asid_valid;  // Indicates that ASID has been written (for PDTrace)
	output          pagegrain;      // Smallest pagesize = 1KB/4KB (0/1)

	output		asid_update;	      // detect on asid change
   
	output		mmu_iec;		// enable unique exception code for ri/xi
	output		mmu_read_m;

// BEGIN Wire declarations made by MVP
wire [31:0] /*[31:0]*/ random32;
wire tlb_read_d;
wire pagegrain_ld;
wire enlo0_ld;
wire [31:0] /*[31:0]*/ enlo132;
wire enlo_rie;
wire [`M14K_JTLBL] /*[31:4]*/ enlo0;
wire wired_ld;
wire enlo_xie;
wire pagegrain;
wire mmu_iec;
wire pagemask_rd;
wire idx_wr;
wire [31:0] /*[31:0]*/ idx_ran_mux32;
wire enlo1_rd;
wire [`M14K_JTLBL] /*[31:4]*/ next_enlo0;
wire mfcp0_m;
wire mtcp0_m;
wire tlb_read_m;
wire wired_rd;
wire [9:0] /*[9:0]*/ lfsr;
wire asid_update;
wire [`M14K_CMASK] /*[9:0]*/ next_pagemask_mx;
wire [31:0] /*[31:0]*/ index32;
wire enlo1_ld;
wire enhi_rd;
wire [`M14K_CMASK] /*[9:0]*/ pagemask_cp0;
wire [4:0] /*[4:0]*/ ixp;
wire [`M14K_JTLBDATA] /*[31:5]*/ entrylo;
wire inv;
wire [`M14K_JTLBL] /*[31:4]*/ enlo1;
wire [`M14K_CMASK] /*[9:0]*/ tlb_pmc;
wire [31:0] /*[31:0]*/ pagegrain32;
wire [`M14K_ENHIRANGE] /*[29:0]*/ enhi;
wire [4:0] /*[4:0]*/ next_wired;
wire [`M14K_CMASK] /*[9:0]*/ pagemask;
wire [31:0] /*[31:0]*/ mmu_cpyout;
wire [4:0] /*[4:0]*/ next_random;
wire non_cpy_rd;
wire [31:0] /*[31:0]*/ wired32;
wire gbit;
wire idx_rd;
wire [5:0] /*[5:0]*/ index;
wire [`M14K_JTLBL] /*[31:4]*/ next_enlo1;
wire [31:0] /*[31:0]*/ load_pa;
wire idx_ld;
wire enhi_ld;
wire [`M14K_ASID] /*[7:0]*/ mmu_asid;
wire [4:0] /*[4:0]*/ random;
wire pagemask_ld;
wire pagegrain_rd;
wire [4:0] /*[4:0]*/ wired;
wire mmu_read_m;
wire enlo0_rd;
wire [31:0] /*[31:0]*/ pagemask32;
wire [3:0] /*[3:0]*/ pagegrainbits_next;
wire mmu_asid_valid;
wire enablecp0_m;
wire [`M14K_ENHIRANGE] /*[29:0]*/ next_enhi_mx;
wire [31:0] /*[31:0]*/ enhi32;
wire [3:0] /*[3:0]*/ pagegrainbits;
wire [`M14K_VPN2RANGE] /*[31:11]*/ enhi_s;
wire hot_mtcp0_m;
// END Wire declarations made by MVP

	/* Inouts */

	parameter PW = `M14K_PFNWIDTH;

// 
function [`M14K_PMASKHI : `M14K_PMASKLO] expand;
   input [`M14K_CMASKHI : `M14K_CMASKLO] c;
   expand = {`M14K_CM2PM};
endfunction

function [`M14K_CMASKHI : `M14K_CMASKLO] comprs;
   input [`M14K_PMASKHI : `M14K_PMASKLO] p;
   comprs = {`M14K_PM2CM};
endfunction
// 

	// #################################################################
	// General cp0 control 
	// #################################################################
	// move from CP0 register
	assign mfcp0_m =  mpc_load_m && mpc_cp0move_m && !mpc_fixup_m;

        // DMissSquash is all non-JTLB early M/W stage exceptions
        // Need to stop CP0 register update for precise W stage exceptions
        // Hot version of signals are not cleared by that
	assign enablecp0_m = !mpc_dmsquash_m && mpc_run_m;
	
	assign hot_mtcp0_m = !mpc_load_m && mpc_cp0move_m;
	assign mtcp0_m = hot_mtcp0_m && enablecp0_m;

	
	// #################################################################
	// index register
	// #################################################################
	// idx_wr: load index from enc during probe
	assign idx_wr = cp0_probe_m && enablecp0_m;
	
	// idx_ld: load index register via MTC0
	assign idx_ld = mtcp0_m & (mpc_cp0r_m == 5'd0) & (mpc_cp0sr_m == 3'd0);	

	// idx_rd: read index or random onto CPY line
	assign idx_rd =	mfcp0_m && ((mpc_cp0r_m == 5'd0) || (mpc_cp0r_m == 5'd1)) ||
		 non_cpy_rd; // force default selection on mmu_cpyout

	assign non_cpy_rd = (!mfcp0_m || !((mpc_cp0r_m == 5'd0) || (mpc_cp0r_m == 5'd1) || (mpc_cp0r_m == 5'd2) ||
				 (mpc_cp0r_m == 5'd3) || (mpc_cp0r_m == 5'd5) || 
				  (mpc_cp0r_m == 5'd6) || (mpc_cp0r_m == 5'd10))) && !mpc_ll1_m;
	
	// Bus index[5:0]: compressed index register
	mvp_cregister #(1) _index_5_5_(index[5],idx_wr || idx_ld && cpz_vz && !cpz_gm_m && !is_root, gclk, 
		idx_wr ? ~tlb_match : edp_alu_m[31]);
	mvp_cregister_wide #(5) _index_4_0_(index[4:0],gscanenable, idx_wr && (tlb_match || ~cpz_vz) || idx_ld, gclk, 
		idx_wr ? enc[4:0] : (edp_alu_m[4:0] & {cpz_mmusize, 3'h7}));

	// #################################################################
	// Random register
	// #################################################################

	// Add a 10 bit linear-feedback shift register to generate a pseudo-
	//   random count which is partially decoded and used to modulate the
	//   decrement of the Random register.  This reduces the probability of
	//   the pathological livelock case where i and d tlbmisses are competing
	//   for the same tlb entry.

	mvp_register #(10) _lfsr_9_0_(lfsr[9:0], gclk, (greset) ? 10'b0 :
			{lfsr[8:0], !(lfsr[9] ^ lfsr[6])});

	assign next_random [4:0] = (greset | (random == wired) | wired_ld) ? 5'h1f :
				(random - (lfsr[3:0]!=4'h4));

	mvp_register #(5) _random_4_0_(random[4:0], gclk, next_random & {cpz_mmusize, 3'h7});

	// Bus IxRnMux[4:0]: M-stage mux of random/index used for move from's
	assign index32 [31:0] = {index[5], 26'b0, index[4:3] & cpz_mmusize, index[2:0]};
	assign random32 [31:0] = {27'b0, random[4:0]};
	
	assign idx_ran_mux32 [31:0] =	(mfcp0_m & (mpc_cp0r_m == 5'd1)) ? random32 : index32;

	// Bus ixp[4:0]: E-stage mux of random/index for tlb indexed ops
	assign ixp [4:0] =	cp0random_val_e ? random : index[4:0];

	// #################################################################
	// EntryLo0 register
	// #################################################################
	`define M14K_RIFIELD  31
	`define M14K_XIFIELD  30
        `define M14K_ENLOZEROFIELD 29 : 26
	`define M14K_ENLOZEROW 4
	`define M14K_PFNFIELD 25 : `M14K_CFIELDHI + 1
	`define M14K_ATTFIELD `M14K_CFIELDHI : 0

	assign enlo0_rd = mfcp0_m & (mpc_cp0r_m == 5'd2) & (mpc_cp0sr_m == 3'd0);
	assign enlo0_ld = mtcp0_m & (mpc_cp0r_m == 5'd2) & (mpc_cp0sr_m == 3'd0);

	// tlb_read_m
        assign tlb_read_m = cp0_read_m && enablecp0_m;
	mvp_register #(1) _tlb_read_d(tlb_read_d, gclk, tlb_read_m);
	assign mmu_read_m = tlb_read_m;

	// 
        wire [`M14K_JTLBL] cpy_enlo;
	assign cpy_enlo[`M14K_RINHBIT]   = edp_alu_m[`M14K_RIFIELD] & enlo_rie;
	assign cpy_enlo[`M14K_XINHBIT]   = edp_alu_m[`M14K_XIFIELD] & enlo_xie;
	assign cpy_enlo[`M14K_PFN]       = edp_alu_m[`M14K_PFNFIELD] & {PW{~mmu_type}}; 
	assign cpy_enlo[`M14K_JTLBLOATT] = edp_alu_m[`M14K_ATTFIELD]; 
	// 

// 
	function [`M14K_JTLBL] reset_ri_xi;
	// Reset the two protection bits when r
	  input r;
	  input [`M14K_JTLBL] i;
	  begin
	    reset_ri_xi[`M14K_PFN]       = i[`M14K_PFN];
	    reset_ri_xi[`M14K_JTLBLOATT] = i[`M14K_JTLBLOATT];
	    reset_ri_xi[`M14K_RINHBIT]   = i[`M14K_RINHBIT] & ~r; 
	    reset_ri_xi[`M14K_XINHBIT]   = i[`M14K_XINHBIT] & ~r; 
	  end
	endfunction
// 

	assign next_enlo0 [`M14K_JTLBL] = reset_ri_xi(greset, tlb_read_m ? jtlb_lo : enlo0_ld ? cpy_enlo : enlo0);
	mvp_ucregister_wide #(28) _enlo0_31_4_(enlo0[`M14K_JTLBL],gscanenable, tlb_read_m || enlo0_ld || greset, gclk, next_enlo0);

	// 
        wire [31:0] enlo032;
	assign enlo032[`M14K_RIFIELD]  = enlo0[`M14K_RINHBIT]; 
	assign enlo032[`M14K_XIFIELD]  = enlo0[`M14K_XINHBIT]; 
	assign enlo032[`M14K_PFNFIELD] = enlo0[`M14K_PFN];
        assign enlo032[`M14K_ENLOZEROFIELD] = {`M14K_ENLOZEROW{1'b0}};
	assign enlo032[`M14K_ATTFIELD] = enlo0[`M14K_JTLBLOATT]; 
	// 

	// #################################################################
	// EntryLo1 register
	// #################################################################
	assign enlo1_rd = mfcp0_m & (mpc_cp0r_m == 5'd3) & (mpc_cp0sr_m == 3'd0);	
	assign enlo1_ld = mtcp0_m & (mpc_cp0r_m == 5'd3) & (mpc_cp0sr_m == 3'd0);	

	assign next_enlo1 [`M14K_JTLBL] = reset_ri_xi(greset, tlb_read_d ? jtlb_lo : enlo1_ld ? cpy_enlo : enlo1);
	mvp_ucregister_wide #(28) _enlo1_31_4_(enlo1[`M14K_JTLBL],gscanenable, tlb_read_d || enlo1_ld || greset, gclk, next_enlo1);

	assign enlo132[`M14K_RIFIELD]  = enlo1[`M14K_RINHBIT]; 
	assign enlo132[`M14K_XIFIELD]  = enlo1[`M14K_XINHBIT]; 

	assign enlo132[`M14K_PFNFIELD] = enlo1[`M14K_PFN]; 
        assign enlo132[`M14K_ENLOZEROFIELD] = {`M14K_ENLOZEROW{1'b0}};
	assign enlo132[`M14K_ATTFIELD] = enlo1[`M14K_JTLBLOATT]; 

	// ENLO write data for TLB
	assign entrylo [`M14K_JTLBDATA] = tlb_wr_1 ? enlo1[`M14K_JTLBDATA] : enlo0[`M14K_JTLBDATA];

	assign gbit = enlo0[`M14K_GLOBALBIT] & enlo1[`M14K_GLOBALBIT];

	// #################################################################
	// Page mask register
	// #################################################################
        assign pagemask_rd = mfcp0_m & (mpc_cp0r_m == 5'd5) & (mpc_cp0sr_m == 3'd0);
        assign pagemask_ld = mtcp0_m & (mpc_cp0r_m == 5'd5) & (mpc_cp0sr_m == 3'd0);

	assign tlb_pmc [`M14K_CMASK] = tag_array_out[`M14K_PMCRANGETLB];

	assign next_pagemask_mx[`M14K_CMASK] = (tlb_read_m ?  tlb_pmc : comprs(edp_alu_m[`M14K_PMRANGE]));

	mvp_cregister_wide #(10) _pagemask_cp0_9_0_(pagemask_cp0[`M14K_CMASK],gscanenable, tlb_read_m || pagemask_ld, gclk, next_pagemask_mx);
	assign pagemask [`M14K_CMASK] = pagemask_cp0 | {{ `M14K_CMASKWIDTH - 2 { 1'b0 }}, { 2 { pagegrain }}};

	assign pagemask32 [31:`M14K_PMHI + 1] = { (31 - `M14K_PMHI) - 0 { 1'b0 }};
	assign pagemask32 [`M14K_PMRANGE] = expand(pagemask_cp0 & {{ `M14K_CMASKWIDTH - 2 { 1'b1 }}, { 2 { ~pagegrain }}});
	assign pagemask32 [`M14K_PMLO - 1:0] = { `M14K_PMLO - 0 { 1'b0 }};


	// #################################################################
	// Page grain register
	// #################################################################
        assign pagegrain_rd = mfcp0_m & (mpc_cp0r_m == 5'd5) & (mpc_cp0sr_m == 3'd1);
        assign pagegrain_ld = mtcp0_m & (mpc_cp0r_m == 5'd5) & (mpc_cp0sr_m == 3'd1);

	`define M14K_GRAINRIEBIT 31
	`define M14K_GRAINXIEBIT 30
	`define M14K_GRAINESPBIT 28
	`define M14K_GRAINIECBIT 27

        assign pagegrainbits_next[3:0] = greset ? 4'b0 : {edp_alu_m[`M14K_GRAINRIEBIT], edp_alu_m[`M14K_GRAINXIEBIT], cpz_smallpage & edp_alu_m[`M14K_GRAINESPBIT], edp_alu_m[`M14K_GRAINIECBIT]};

        mvp_cregister_wide #(4) _pagegrainbits_3_0_(pagegrainbits[3:0],gscanenable, greset | pagegrain_ld, gclk, pagegrainbits_next);

	assign enlo_rie  = pagegrainbits[3];
	assign enlo_xie  = pagegrainbits[2];
        assign pagegrain = ~(cpz_smallpage & pagegrainbits[1]);   // Smallest pagesize = 1KB/4KB (0/1)
	assign mmu_iec  = pagegrainbits[0];

        assign pagegrain32 [31:0] = {pagegrainbits[3:2], 1'b0, ~pagegrain, pagegrainbits[0], 27'b0};



// 
// verilint 528 off
	wire	[31:0]	pagegrain32_next;
`ifdef M14K_SMARTMIPS
	assign pagegrain32_next[31:0] = {pagegrainbits_next[2:1], 17'b0, {2{pagegrainbits_next[0]}}, 11'b11100000000};
`else
        assign pagegrain32_next[31:0] = {pagegrainbits_next[3:2], 1'b0, pagegrainbits_next[1:0], 27'b0};
`endif
// verilint 528 on
// 
	
	// #################################################################
	// wired register
	// #################################################################
	assign wired_rd = mfcp0_m & (mpc_cp0r_m == 5'd6) & (mpc_cp0sr_m == 3'd0);
	assign wired_ld = mtcp0_m & (mpc_cp0r_m == 5'd6) & (mpc_cp0sr_m == 3'd0);

	assign next_wired [4:0] = greset ? 4'b0 : (edp_alu_m[4:0] & {cpz_mmusize, 3'h7});
	mvp_cregister_wide #(5) _wired_4_0_(wired[4:0],gscanenable, greset || wired_ld, gclk, next_wired);
	assign wired32 [31:0] = {27'h0, wired};

	// #################################################################
	// Entry hi register
	// #################################################################
	// enhi_ld: load entry hi register via MTC0
	assign enhi_ld = mtcp0_m & (mpc_cp0r_m == 5'd10) & (mpc_cp0sr_m == 3'd0);

	// enhi_rd: read EntryHi onto CPZ line
	assign enhi_rd = mfcp0_m & (mpc_cp0r_m == 5'd10) & (mpc_cp0sr_m == 3'd0);

	mvp_cregister_wide #(30) _enhi_29_0_(enhi[`M14K_ENHIRANGE],gscanenable, mpc_jamtlb_w | tlb_read_m | enhi_ld | greset, gclk, next_enhi_mx); 
        assign next_enhi_mx [`M14K_ENHIRANGE] =
	  ( greset ? {enhi[`M14K_VPN2RANGEENHI], { `M14K_ASIDWIDTH + `M14K_ENHIINVWIDTH{ 1'b0}}} :
		mpc_jamtlb_w ? {     enhi_s[`M14K_VPN2RANGE]   ,   enhi[`M14K_ASIDWIDTH] & cpz_vz,   enhi[`M14K_ASID]}
	   : tlb_read_m ? {tag_array_out[`M14K_VPN2RANGETLB], tag_array_out[`M14K_INVRANGETLB], tag_array_out[`M14K_ASIDRANGETLB]}
	   :              {    edp_alu_m[`M14K_VPN2RANGE]   ,   edp_alu_m[`M14K_ENHIINV] & cpz_vz,  edp_alu_m[`M14K_ASID]}) &
	  {{ `M14K_VPN2WIDTH - 2 { 1'b1}}, { 2 { ~pagegrain }}, { `M14K_ASIDWIDTH + `M14K_ENHIINVWIDTH{ 1'b1 }}};
   
	mvp_cregister_wide #(21) _enhi_s_31_11_(enhi_s[`M14K_VPN2RANGE],gscanenable, mmu_transexc, gclk, mmu_vat_hi[`M14K_VPN2RANGE]);

	mvp_cregister #(1) _mmu_asid_valid(mmu_asid_valid,greset || (enhi_ld && !mpc_jamtlb_w), gclk, !greset);

	assign enhi32[`M14K_VPN2] = enhi[`M14K_VPN2RANGEENHI] & {{ `M14K_VPN2WIDTH - 2 { 1'b1}}, { 2 { ~pagegrain }}};
	assign enhi32[`M14K_ENHIINV]  = enhi[`M14K_ASIDWIDTH]; 
        assign enhi32[`M14K_ENHIZERO] = {`M14K_ENHIZEROWIDTH{1'b0}};
	assign enhi32[`M14K_ASID]  = enhi[`M14K_ASID]; 
	assign mmu_asid [`M14K_ASID] = enhi[`M14K_ASID];
	assign inv = enhi32[`M14K_ENHIINV];

	assign asid_update = mpc_jamtlb_w | tlb_read_m | enhi_ld;

	

	assign load_pa[31:0] = {4'h0, mmu_dpah[`M14K_PAH], edp_dpal[`M14K_PAL]};
	
	// #################################################################
        // CPY read bus
	// #################################################################
	// Bus mmu_cpyout[31:0]: stuff driven onto CPY besides EDB
	mvp_mux1hot_8 #(32) _mmu_cpyout_31_0_(mmu_cpyout[31:0],enlo0_rd, enlo032,
				enlo1_rd, enlo132,
				enhi_rd, enhi32,
				wired_rd, wired32,
				pagemask_rd, pagemask32,
				pagegrain_rd, pagegrain32,
				mpc_ll1_m, load_pa,
				idx_rd, idx_ran_mux32 );  // default selection for mmu_cpyout



endmodule	// m14k_tlb_cpy
