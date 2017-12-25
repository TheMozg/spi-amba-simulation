// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// 	m14k_tlb_dtlb: Data Micro tlb.
//
//	$Id: \$
//	mips_repository_id: m14k_tlb_dtlb.mv, v 1.5 
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
module m14k_tlb_dtlb(
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
	cpz_guestid,
	pre_pah,
	jtlb_pah,
	utlb_bypass,
	store,
	cpz_gm_m,
	cpz_vz,
	dmap,
	mmu_dpah,
	pa_cca,
	dtlb_ri,
	dtlb_xi,
	rdtlb_ri,
	rdtlb_xi,
	dtlb_miss);

`include "m14k_mmu.vh"
   parameter AW = `M14K_CCAWIDTH + 6;

   /* Inputs */
   input 		gclk;		// Clock
   input 		greset;		// greset
   input 		gscanenable;	// gscanenable
   input 		lookup;		// Control signal that the uTLB is used
   input [`M14K_VPNRANGE]	va;		// Virtual address for translation
   input [`M14K_ASID] 	mmu_asid;		// Address Space ID
   input 		jtlb_wr;	// An Entry in the JTLB is written (flush signal)
   input 		r_jtlb_wr;	// An Entry in the JTLB is written (flush signal)
   input [4:0]		jtlb_wr_idx;	// index of the Entry written in the JTLB
   input 		update_utlb;	// uTLB Write strobe signal.
   input [4:0] 		jtlb_idx;	// index in JTLB of the jtlb_lo entry.
   input [4:0] 		rjtlb_idx;	// index in JTLB of the jtlb_lo entry.
   input [`M14K_JTLBL] 	jtlb_lo;		// JTLB Lo output for uTLB write
   input [`M14K_JTLBL] 	r_jtlb_lo;		// JTLB Lo output for uTLB write
   input 		jtlb_grain;	// Smallest pagesize = 1KB/4KB (0/1) 
   input [`M14K_GID] 	cpz_guestid;

   input [`M14K_PAH] 	pre_pah;		// Fixed translation or Previous address
   input [`M14K_PAH] 	jtlb_pah;		// Translated Physical address from JTLB
   input 		utlb_bypass;	// Bypass uTLB translate. = use pre_pah
   input 		store;          // Is this translation for a store?
   input 		cpz_gm_m;
   input 		cpz_vz;
   input 		dmap;

   /* Outputs */
   output [`M14K_PAH] 	mmu_dpah;		// Translated Physical address
   output [`M14K_CCA]	pa_cca;		// cca bit for PAH

   output 		dtlb_ri;		// Read inhibit from dTLB
   output 		dtlb_xi;		// Execute inhibit from dTLB
   output 		rdtlb_ri;		// Read inhibit from dTLB
   output 		rdtlb_xi;		// Execute inhibit from dTLB
   output 		dtlb_miss;	// uTLB Miss indication

// BEGIN Wire declarations made by MVP
wire rdbit;
wire [AW-1:0] /*[8:0]*/ att_wr_data;
wire [`M14K_CCA] /*[2:0]*/ pa_cca;
wire dtlb_miss;
wire dtlb_ri;
wire dtlb_xi;
wire rdtlb_xi;
wire rdtlb_ri;
// END Wire declarations made by MVP


   // End of init/O

   wire dbit;
   wire miss;

   // Need to miss if this will generate a mmu_tlbmod exception
   assign dtlb_miss = store & ((~cpz_vz | cpz_gm_m & dmap) & ~dbit | cpz_vz & ~rdbit) | miss;

   wire [AW-1:0] Att;
   assign att_wr_data [AW-1:0] = {r_jtlb_lo[`M14K_DIRTYBIT], r_jtlb_lo[`M14K_RINHBIT], r_jtlb_lo[`M14K_XINHBIT], 
		(cpz_gm_m | ~cpz_vz) ? jtlb_lo[`M14K_COHERENCYRANGE] : r_jtlb_lo[`M14K_COHERENCYRANGE], 
		jtlb_lo[`M14K_DIRTYBIT], jtlb_lo[`M14K_RINHBIT], 
		jtlb_lo[`M14K_XINHBIT]};
   assign {rdbit, rdtlb_ri, rdtlb_xi, pa_cca[`M14K_CCA], dbit, dtlb_ri, dtlb_xi} = Att;

   m14k_tlb_utlb #(AW) utlb (
   	/* Inputs */
   	.gclk		( gclk),
   	.greset		( greset),
   	.gscanenable	( gscanenable),
   	.lookup		( lookup),
   	.va		( va),	
   	.mmu_asid	( mmu_asid),
   	.cpz_guestid	( cpz_guestid),
   	.jtlb_wr	( jtlb_wr),
   	.r_jtlb_wr	( r_jtlb_wr),
   	.jtlb_wr_idx	( jtlb_wr_idx),
   	.update_utlb	( update_utlb),
   	.jtlb_idx	( jtlb_idx),
   	.rjtlb_idx	( rjtlb_idx),
   	.jtlb_lo	( jtlb_lo),
   	.r_jtlb_lo	( r_jtlb_lo),
   	.jtlb_pah	( jtlb_pah),
	.jtlb_grain	( jtlb_grain),
   	.att_wr_data	( att_wr_data),
   	.cpz_vz		( cpz_vz),

   	.pre_pah	( pre_pah),
   	.utlb_bypass	( utlb_bypass),

   	/* Outputs */
   	.utlb_pah	( mmu_dpah),
   	.utlb_patt	( Att),
   	.utlb_miss	( miss)
   );



endmodule	// m14k_tlb_dtlb
