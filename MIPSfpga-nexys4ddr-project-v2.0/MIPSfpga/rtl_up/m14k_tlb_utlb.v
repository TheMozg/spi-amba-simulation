// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// 	Description: m14k_tlb_utlb
//          Micro tlb. Register based
//
//	$Id: \$
//	mips_repository_id: m14k_tlb_utlb.mv, v 1.5 
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
module m14k_tlb_utlb(
	gclk,
	greset,
	gscanenable,
	lookup,
	va,
	mmu_asid,
	jtlb_wr,
	r_jtlb_wr,
	jtlb_wr_idx,
	update_utlb,
	jtlb_idx,
	rjtlb_idx,
	jtlb_lo,
	r_jtlb_lo,
	jtlb_grain,
	cpz_vz,
	pre_pah,
	jtlb_pah,
	att_wr_data,
	utlb_bypass,
	cpz_guestid,
	utlb_pah,
	utlb_patt,
	utlb_miss);
 parameter AW = 9; // Width of Attribute field
`include "m14k_mmu.vh"

	// synopsys template
	/* Inputs */
	input 		      gclk;		// Clock
	input 		      greset;		// greset
	input 		      gscanenable;	// gscanenable
	input 		      lookup;		// Control signal that the uTLB is used
	input [`M14K_VPNRANGE] va;		// Virtual address for translation
	input [`M14K_ASID]     mmu_asid;		// Address Space ID
	input 		      jtlb_wr;	// An Entry in the JTLB is written (flush signal)
	input 		      r_jtlb_wr;	// An Entry in the JTLB is written (flush signal)
	input [4:0] 	      jtlb_wr_idx;	// index of the Entry written in the JTLB
	input 		      update_utlb;	// uTLB Write strobe signal.
	input [4:0] 	      jtlb_idx;	// index in JTLB of the jtlb_lo entry.
	input [4:0] 	      rjtlb_idx;	// index in JTLB of the jtlb_lo entry.
	input [`M14K_JTLBL]    jtlb_lo;		// JTLB Lo output for uTLB write
	input [`M14K_JTLBL]    r_jtlb_lo;		// JTLB Lo output for uTLB write
	input 		      jtlb_grain;      // pagesize = 4KB+/1KB (1/0)
	input 		      cpz_vz;

	input [`M14K_PAH]      pre_pah;		// Fixed translation or Previous address
	input [`M14K_PAH]      jtlb_pah;		// Physical Address from JTLB
	input [AW-1:0] 	      att_wr_data;         // Attributes to write
	input 		      utlb_bypass;	// Bypass uTLB translate. = use pre_pah
   	input [`M14K_GID] 		cpz_guestid;
	
	/* Outputs */
	output [`M14K_PAH]     utlb_pah;            // Translated Physical address high part
	output [AW-1:0]       utlb_patt;           // Attributes from matching entry
	output 		      utlb_miss;	// uTLB Miss indication

// BEGIN Wire declarations made by MVP
wire [4:0] /*[4:0]*/ r_idx_wr_data;
wire [`M14K_PAH] /*[31:10]*/ pah_wr_data;
wire [`M14K_ASID] /*[7:0]*/ asid_wr_data;
wire [3:0] /*[3:0]*/ load_utlb;
wire [1:0] /*[1:0]*/ lru3;
wire [`M14K_PAH] /*[31:10]*/ utlb_pah;
wire [(AW-1):0] /*[8:0]*/ utlb_patt;
wire [4:0] /*[4:0]*/ idx_wr_data;
wire jtlb_val;
wire [1:0] /*[1:0]*/ lru3_cnxt;
wire [1:0] /*[1:0]*/ lru1_cnxt;
wire utlb_miss;
wire [1:0] /*[1:0]*/ lru1;
wire gbit_wr_data;
wire [`M14K_VPNRANGE] /*[31:10]*/ grain_mask;
wire [`M14K_GID] /*[2:0]*/ gid_wr_data;
wire [1:0] /*[1:0]*/ mru;
wire [1:0] /*[1:0]*/ lru2_cnxt;
wire [31:0] /*[31:0]*/ grain_mask32;
wire [1:0] /*[1:0]*/ nxt_entry;
wire [`M14K_VPNRANGE] /*[31:10]*/ vpn_wr_data;
wire [1:0] /*[1:0]*/ lru;
wire [1:0] /*[1:0]*/ lru2;
wire lru_update;
// END Wire declarations made by MVP

	
	// End of I/O
	parameter PAHW = `M14K_PAHWIDTH;

	/*
	 * Assumptions:
	 * 1: update_utlb is not set unless utlb_miss is set.
	 * 2: When update_utlb is set, va and mmu_asid are valid and translate into
	 *    the jtlb_idx and jtlb_lo inputs.
	 * 2: mmu_asid is valid one clock earlier than va
	 * 3: If va is invalid. All outputs will be undefined.
	 * 4: When jtlb_wr is set any uTLB entry with the index jtlb_wr_idx is cleared.
	 * 5: lookup is ONLY set when the uTLB is accesed for translation
	 */
	
	
	wire 		      utlb0_val;
	wire 		      utlb1_val;
	wire 		      utlb2_val;
	wire 		      utlb3_val;
	wire 		      utlb0_match;
	wire 		      utlb1_match;
	wire 		      utlb2_match;
	wire 		      utlb3_match;
	wire [AW-1:0] 	      utlb0_att;
	wire [AW-1:0] 	      utlb1_att;
	wire [AW-1:0] 	      utlb2_att;
	wire [`M14K_PAH]       utlb0_pah;
	wire [`M14K_PAH]       utlb1_pah;
	wire [`M14K_PAH]       utlb2_pah;
	
	wire [AW-1:0] 	      utlb3_att;
	wire [`M14K_PAH]       utlb3_pah;


	// 2-to-4 decoder
	//
	function [3:0] dec2to4;
		input [1:0]	enc;
		
		dec2to4 = 4'b0001 << enc;
		
	endfunction
	//
   

	// jtlb_val: jtlb_lo is valid and the uTLB must be updated
	assign jtlb_val = (cpz_vz ? r_jtlb_lo[`M14K_VALIDBIT] : jtlb_lo[`M14K_VALIDBIT]) && update_utlb;
	
	// mru: Most resently used entry. Only valid when lookup is set and utlb_miss is low
	assign mru [1:0] = {(utlb2_match || utlb3_match), (utlb1_match || utlb3_match)};
	
	// lru_update: Update the lru registers
	assign lru_update = greset || (lookup && !utlb_miss && !(mru == lru3));
   
	// lru1-3: Next to Least recently used entries
	
	assign lru1_cnxt [1:0] = (greset ? 2'd3 : ((lru2 == mru) ? lru1 : lru2));
	mvp_cregister #(2) _lru1_1_0_(lru1[1:0],lru_update, gclk, lru1_cnxt);
	
   
	assign lru2_cnxt [1:0] = (greset ? 2'd2 : lru3);
	mvp_cregister #(2) _lru2_1_0_(lru2[1:0],lru_update, gclk, lru2_cnxt);
	
	assign lru3_cnxt [1:0] = (greset ? 2'd1 : mru);
	mvp_cregister #(2) _lru3_1_0_(lru3[1:0],lru_update, gclk, lru3_cnxt);

	// lru: Least recently used entry
	assign lru [1:0] = lru1 ^ lru2 ^ lru3;
   
	// nxt_entry:  Next uTLB entry to update in case of uTLB miss

	assign nxt_entry [1:0] = !utlb0_val ? 2'd0 :	// If any unused entries exists
			  !utlb1_val ? 2'd1 :	// use them first.
			  !utlb2_val ? 2'd2 :
			  !utlb3_val ? 2'd3 :
			  lru;		// Otherwise select lru

	
	assign asid_wr_data [`M14K_ASID] = mmu_asid;

	assign gid_wr_data [`M14K_GID] = cpz_guestid;

	// Create grain mask to mask out low bits if 4K page
	assign grain_mask32[31:0] = {32{jtlb_grain}};
	// grain_mask[`M14K_VPNRANGE] = grain_mask32[`M14K_PFNLO-1:`M14K_VPNLO];  // pads with zeros on left 
	assign grain_mask[`M14K_VPNRANGE] = {20'b0, grain_mask32[`M14K_PFNLO-1:`M14K_VPNLO]};  // pads with zeros on left 

	assign vpn_wr_data  [`M14K_VPNRANGE]  = va & ~grain_mask;
	
	assign gbit_wr_data              = jtlb_lo[`M14K_GLOBALBIT];
	
	assign pah_wr_data [`M14K_PAH]   = jtlb_pah;
   
	// idx_wr_data: Idx write data
	assign idx_wr_data [4:0] = jtlb_idx;
	assign r_idx_wr_data [4:0] = rjtlb_idx;
   
	// load_utlb: Load enable for the 4 entries
	assign load_utlb [3:0] = ({4{jtlb_val}} & dec2to4(nxt_entry));
	


	// Entry 0
	`M14K_UTLBENTRY_MODULE #(AW) utlbentry0 (
					     /* Inputs */
					     .gclk ( gclk),
					     .greset (greset),
				 	     .gscanenable (gscanenable),
					     .va (va),
					     .mmu_asid (mmu_asid),
					     .cpz_guestid (cpz_guestid),
					     .load_utlb (load_utlb[0]),
					     .att_wr_data (att_wr_data),
					     .pah_wr_data (pah_wr_data),
					     .vpn_wr_data (vpn_wr_data),
					     .asid_wr_data (asid_wr_data),
					     .gid_wr_data (gid_wr_data),
					     .gbit_wr_data (gbit_wr_data),
					     .idx_wr_data (idx_wr_data),
					     .r_idx_wr_data (r_idx_wr_data),
					     .jtlb_wr (jtlb_wr),
					     .r_jtlb_wr (r_jtlb_wr),
					     .jtlb_wr_idx (jtlb_wr_idx),
					     .jtlb_grain (jtlb_grain),
					     /* Outputs */
					     .utlb_att (utlb0_att),
					     .utlb_pah (utlb0_pah),
					     .match (utlb0_match),
					     .utlb_val (utlb0_val)
					    );


	// Entry 1
	`M14K_UTLBENTRY_MODULE #(AW) utlbentry1 (
					     /* Inputs */
					     .gclk ( gclk),
					     .greset (greset),
				 	     .gscanenable (gscanenable),
					     .va (va),
					     .mmu_asid (mmu_asid),
					     .cpz_guestid (cpz_guestid),
					     .load_utlb (load_utlb[1]),
					     .att_wr_data (att_wr_data),
					     .pah_wr_data (pah_wr_data),
					     .vpn_wr_data (vpn_wr_data),
					     .asid_wr_data (asid_wr_data),
					     .gid_wr_data (gid_wr_data),
					     .gbit_wr_data (gbit_wr_data),
					     .idx_wr_data (idx_wr_data),
					     .r_idx_wr_data (r_idx_wr_data),
					     .jtlb_wr (jtlb_wr),
					     .r_jtlb_wr (r_jtlb_wr),
					     .jtlb_wr_idx (jtlb_wr_idx),
					     .jtlb_grain (jtlb_grain),
					     /* Outputs */
					     .utlb_att (utlb1_att),
					     .utlb_pah (utlb1_pah),
					     .match (utlb1_match),
					     .utlb_val (utlb1_val)
					    );

	// Entry 2
	`M14K_UTLBENTRY_MODULE #(AW) utlbentry2 (
					      /* Inputs */
					     .gclk ( gclk),
					     .greset (greset),
				 	     .gscanenable (gscanenable),
					     .va (va),
					     .mmu_asid (mmu_asid),
					     .cpz_guestid (cpz_guestid),
					     .load_utlb (load_utlb[2]),
					     .att_wr_data (att_wr_data),
					     .pah_wr_data (pah_wr_data),
					     .vpn_wr_data (vpn_wr_data),
					     .asid_wr_data (asid_wr_data),
					     .gid_wr_data (gid_wr_data),
					     .gbit_wr_data (gbit_wr_data),
					     .idx_wr_data (idx_wr_data),
					     .r_idx_wr_data (r_idx_wr_data),
					     .jtlb_wr (jtlb_wr),
					     .r_jtlb_wr (r_jtlb_wr),
					     .jtlb_wr_idx (jtlb_wr_idx),
					     .jtlb_grain (jtlb_grain),
					     /* Outputs */
					     .utlb_att (utlb2_att),
					     .utlb_pah (utlb2_pah),
					     .match (utlb2_match),
					     .utlb_val (utlb2_val)
					    );


	// Entry 3
	`M14K_UTLBENTRY_MODULE #(AW) utlbentry3 (
					     /* Inputs */
					     .gclk ( gclk),
					     .greset (greset),
				 	     .gscanenable (gscanenable),
					     .va (va),
					     .mmu_asid (mmu_asid),
					     .cpz_guestid (cpz_guestid),
					     .load_utlb (load_utlb[3]),
					     .att_wr_data (att_wr_data),
					     .pah_wr_data (pah_wr_data),
					     .vpn_wr_data (vpn_wr_data),
					     .asid_wr_data (asid_wr_data),
					     .gid_wr_data (gid_wr_data),
					     .gbit_wr_data (gbit_wr_data),
					     .idx_wr_data (idx_wr_data),
					     .r_idx_wr_data (r_idx_wr_data),
					     .jtlb_wr (jtlb_wr),
					     .r_jtlb_wr (r_jtlb_wr),
					     .jtlb_wr_idx (jtlb_wr_idx),
					     .jtlb_grain (jtlb_grain),
					     /* Outputs */
					     .utlb_att (utlb3_att),
					     .utlb_pah (utlb3_pah),
					     .match (utlb3_match),
					     .utlb_val (utlb3_val)
					    );


   
	// utlb_miss

	assign utlb_miss = !(utlb0_match || utlb1_match || utlb2_match || utlb3_match);


	
	// PAH: Muxed Physical address output of uTLB

	assign utlb_pah [`M14K_PAH] = {PAHW{utlb_bypass}} & pre_pah |
			      {PAHW{~utlb_bypass & utlb0_match}} & utlb0_pah | 
			      {PAHW{~utlb_bypass & utlb1_match}} & utlb1_pah | 
			      {PAHW{~utlb_bypass & utlb2_match}} & utlb2_pah | 
			      {PAHW{~utlb_bypass & utlb3_match}} & utlb3_pah;


	// pa_cca: Muxed Attribute bits
	// utlb_bypass is handled externally

	assign utlb_patt [(AW-1):0] = {AW{utlb0_match}} & utlb0_att | 
			       {AW{utlb1_match}} & utlb1_att | 
			       {AW{utlb2_match}} & utlb2_att | 
			       {AW{utlb3_match}} & utlb3_att;


endmodule	// m14k_tlb_utlb
