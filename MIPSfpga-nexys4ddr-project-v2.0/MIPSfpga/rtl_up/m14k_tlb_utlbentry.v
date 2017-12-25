// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// 	Description: m14k_tlb_utlbentry 
//           Micro tlb entry. Register based.
//
//	$Id: \$
//	mips_repository_id: m14k_tlb_utlbentry.mv, v 1.7 
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
module m14k_tlb_utlbentry(
	gclk,
	greset,
	gscanenable,
	va,
	mmu_asid,
	load_utlb,
	pah_wr_data,
	att_wr_data,
	vpn_wr_data,
	asid_wr_data,
	gbit_wr_data,
	idx_wr_data,
	r_idx_wr_data,
	jtlb_wr,
	r_jtlb_wr,
	jtlb_wr_idx,
	jtlb_grain,
	gid_wr_data,
	cpz_guestid,
	utlb_att,
	utlb_pah,
	match,
	utlb_val);

`include "m14k_mmu.vh"
   parameter AW = 9; // Width of Attribute field

   parameter M14K_TLB_UTLB_ASID	= `M14K_ASIDWIDTH;
   parameter M14K_TLB_UTLB_VPN	= `M14K_VPNWIDTH+`M14K_ASIDWIDTH;
   parameter M14K_TLB_UTLB_PAH	= `M14K_PAHWIDTH+`M14K_VPNWIDTH+`M14K_ASIDWIDTH;
   parameter M14K_TLB_UTLB_PAHE	= `M14K_VPNWIDTH+`M14K_ASIDWIDTH;
   parameter M14K_TLB_UTLB_G	= `M14K_PAHWIDTH+`M14K_VPNWIDTH+`M14K_ASIDWIDTH;
   parameter M14K_TLB_UTLB_GRAIN	= `M14K_PAHWIDTH+`M14K_VPNWIDTH+`M14K_ASIDWIDTH+1;
   parameter M14K_TLB_UTLB_IDX	= `M14K_PAHWIDTH+`M14K_VPNWIDTH+`M14K_ASIDWIDTH+6;
   parameter M14K_TLB_UTLB_IDXE	= `M14K_PAHWIDTH+`M14K_VPNWIDTH+`M14K_ASIDWIDTH+2;
   parameter M14K_TLB_UTLB_R_IDX	= `M14K_PAHWIDTH+`M14K_VPNWIDTH+`M14K_ASIDWIDTH+11;
   parameter M14K_TLB_UTLB_R_IDXE	= `M14K_PAHWIDTH+`M14K_VPNWIDTH+`M14K_ASIDWIDTH+7;
   parameter M14K_TLB_UTLB_GID	= `M14K_PAHWIDTH+`M14K_VPNWIDTH+`M14K_ASIDWIDTH+`M14K_GIDWIDTH+11;
   parameter M14K_TLB_UTLB_GIDE	= `M14K_PAHWIDTH+`M14K_VPNWIDTH+`M14K_ASIDWIDTH+12;
   parameter M14K_TLB_UTLB_MSB	= `M14K_PAHWIDTH+`M14K_VPNWIDTH+`M14K_ASIDWIDTH+`M14K_GIDWIDTH+11;

   /* Inputs */
   input 	 gclk;		// Clock
   input 		greset;		// greset
   input 		gscanenable;	// gscanenable
   input [`M14K_VPNRANGE]	va;		// Virtual address for translation
   input [`M14K_ASID] 	mmu_asid;		// Address Space ID
   input 		load_utlb;		// Load uTLB entry
   input [`M14K_PAH]    pah_wr_data;         // PAH to uTLB entry
   input [AW-1:0]       att_wr_data;         // Attributes to uTLB entry
   input [`M14K_VPNRANGE]	vpn_wr_data;		// Virtual address to store
   input [`M14K_ASID] 	asid_wr_data;	// Address Space ID to store
   input 	 	gbit_wr_data;	// Global bit to store
   input [4:0] 		idx_wr_data;		// JTLB index to uTLB entry to store
   input [4:0] 		r_idx_wr_data;		// JTLB index to uTLB entry to store
   input 		jtlb_wr;	// An Entry in the JTLB is written (flush signal)
   input 		r_jtlb_wr;	// An Entry in the JTLB is written (flush signal)
   input [4:0] 		jtlb_wr_idx;	// JTLB index which is written
   input 		jtlb_grain;      // pagesize = 4KB+/1KB (1/0)
   input [`M14K_GID] 		gid_wr_data;
   input [`M14K_GID] 		cpz_guestid;

   /* Outputs */
   output [AW-1:0]      utlb_att;        // Attributes from uTLB entry
   output [`M14K_PAH]   utlb_pah;        // PAH from uTLB entry
   output 		match;		// match in uTLB entry
   output 		utlb_val;	// uTLB entry is valid

// BEGIN Wire declarations made by MVP
wire [31:0] /*[31:0]*/ utlb_pah_31_0;
wire [`M14K_VPNRANGE] /*[31:10]*/ ugrain_mask;
wire gid_match;
wire match;
wire [`M14K_GID] /*[2:0]*/ utlb_gid;
wire [4:0] /*[4:0]*/ utlb_r_idx;
wire [`M14K_VPNRANGE] /*[31:10]*/ utlb_vpn;
wire [`M14K_ASID] /*[7:0]*/ utlb_asid;
wire [`M14K_PAH] /*[31:10]*/ utlb_pah;
wire utlb_val_nxt;
wire [31:0] /*[31:0]*/ ugrain_mask32;
wire [31:0] /*[31:0]*/ utlb_vpn_31_0;
wire [`M14K_PAH] /*[31:10]*/ utlb_pah_tmp;
wire [`M14K_VPNRANGE] /*[31:10]*/ va_cmp;
wire utlb_grain;
wire utlb_val;
wire asid_or_global;
wire [4:0] /*[4:0]*/ utlb_idx;
wire utlb_gbit;
// END Wire declarations made by MVP


   // End of init/O
   
   // utlb_att: attribute portion of uTLB data
   wire [AW-1:0] utlb_att;
   mvp_cregister #(AW) dataregister (utlb_att, load_utlb, gclk, att_wr_data);

   // registers concatenated into one ultra wide register
   wire [M14K_TLB_UTLB_MSB:0] utlbentry_pipe_in;
   wire [M14K_TLB_UTLB_MSB:0] utlbentry_pipe_out;
   // 
   mvp_cregister_wide_utlb #(M14K_TLB_UTLB_MSB+1) _utlbentry_pipe_out(utlbentry_pipe_out, gscanenable,
								      load_utlb, gclk, utlbentry_pipe_in);
   // 

   // utlb_pah: PAH portion of uTLB data
   assign utlbentry_pipe_in [M14K_TLB_UTLB_PAH-1:M14K_TLB_UTLB_PAHE] = pah_wr_data;
   assign utlb_pah_tmp [`M14K_PAH] = utlbentry_pipe_out [M14K_TLB_UTLB_PAH-1:M14K_TLB_UTLB_PAHE];

   // if 4K page the 2 rightmost bits come from virtual address. Otherwise from the uTLB entry
   assign utlb_pah [`M14K_PAH] = (utlb_pah_tmp & ~ugrain_mask) | (va & ugrain_mask);

   // uTLBHi: Hi portion of uTLB entry 
   assign utlbentry_pipe_in [M14K_TLB_UTLB_ASID-1:0] = asid_wr_data;
   assign utlb_asid [`M14K_ASID] = utlbentry_pipe_out [M14K_TLB_UTLB_ASID-1:0];

   assign utlbentry_pipe_in [M14K_TLB_UTLB_VPN-1:`M14K_ASIDWIDTH] = vpn_wr_data;
   assign utlb_vpn  [`M14K_VPNRANGE] = utlbentry_pipe_out [M14K_TLB_UTLB_VPN-1:`M14K_ASIDWIDTH];

   assign utlbentry_pipe_in [M14K_TLB_UTLB_G] = gbit_wr_data;
   assign utlb_gbit = utlbentry_pipe_out [M14K_TLB_UTLB_G];

   // grain bit = 4KB/1KB (1/0)
   assign utlbentry_pipe_in [M14K_TLB_UTLB_GRAIN] = jtlb_grain;
   assign utlb_grain = utlbentry_pipe_out [M14K_TLB_UTLB_GRAIN];

   // Create grain mask to mask out low bits if 4K page
   assign ugrain_mask32[31:0] = {32{utlb_grain}};
   // ugrain_mask[`M14K_VPNRANGE] = ugrain_mask32[`M14K_PFNLO-1:`M14K_VPNLO];  // pads with zeros on left 
   assign ugrain_mask[`M14K_VPNRANGE] = {20'b0, ugrain_mask32[`M14K_PFNLO-1:`M14K_VPNLO]};  // pads with zeros on left 

   // utlb_idx: index from the JTLB which is in entry 
   assign utlbentry_pipe_in [M14K_TLB_UTLB_IDX:M14K_TLB_UTLB_IDXE] = idx_wr_data;
   assign utlb_idx [4:0] = utlbentry_pipe_out [M14K_TLB_UTLB_IDX:M14K_TLB_UTLB_IDXE];
   assign utlbentry_pipe_in [M14K_TLB_UTLB_R_IDX:M14K_TLB_UTLB_R_IDXE] = r_idx_wr_data;
   assign utlb_r_idx [4:0] = utlbentry_pipe_out [M14K_TLB_UTLB_R_IDX:M14K_TLB_UTLB_R_IDXE];

   assign utlbentry_pipe_in [M14K_TLB_UTLB_GID:M14K_TLB_UTLB_GIDE] = gid_wr_data;
   assign utlb_gid[`M14K_GID] = utlbentry_pipe_out [M14K_TLB_UTLB_GID:M14K_TLB_UTLB_GIDE];

   // utlb_val: Entry  is valid
   assign utlb_val_nxt = (utlb_val || load_utlb) &&
		!((jtlb_wr && (jtlb_wr_idx == utlb_idx)) || 
		(r_jtlb_wr && (jtlb_wr_idx == utlb_r_idx)) || greset);

   mvp_register #(1) _utlb_val(utlb_val, gclk, utlb_val_nxt);

   // asid_or_global: Precomputed mmu_asid match Or Global bit set.
   mvp_register #(1) _asid_or_global(asid_or_global, gclk,           // Precomputed mmu_asid match
   ((utlb_asid == mmu_asid) || // mmu_asid match
    utlb_gbit ||           // or Global bit
    load_utlb));    // If we're loading it, we know we had an mmu_asid match

   mvp_register #(1) _gid_match(gid_match, gclk, (utlb_gid == cpz_guestid) | load_utlb);

   // create va for match
   assign va_cmp  [`M14K_VPNRANGE]  = va & ~ugrain_mask;

   // match: Entry hit signal
   assign match = utlb_val & asid_or_global & gid_match & // Valid and mmu_asid/Global match
	   (utlb_vpn == va_cmp);         // VPN match

  
 //VCS coverage off 
// 
   
//VCS coverage off
   
   //verilint 550 off	Mux is inferred: case (1'b1)
   //verilint 226 off 	Case-select expression is constant
   //verilint 225 off 	Case expression is not constant
   //verilint 180 off 	Zero extension of extra bits
   //verilint 528 off 	Variable set but not used
   // Generate a text description of state and next state for debugging
	assign utlb_vpn_31_0[31:0] = {utlb_vpn, 10'b0};
	assign utlb_pah_31_0[31:0] = {utlb_pah, 10'b0};
   //verilint 550 on	Mux is inferred: case (1'b1)
   //verilint 226 on 	Case-select expression is constant
   //verilint 225 on 	Case expression is not constant
   //verilint 180 on 	Zero extension of extra bits
   //verilint 528 on 	Variable set but not used
    // else MIPS_ACCELERATION_BUILD
//VCS coverage on
    // MIPS_SIMULATION
  //VCS coverage on  
  
// 

endmodule	// m14k_tlb_utlbentry
