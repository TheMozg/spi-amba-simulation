// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_tlb_jtlb1entry
//         TLB Entry Model
//         Models a single register-based tlb entry.
//
//      $Id: \$
//      mips_repository_id: m14k_tlb_jtlb1entry.mv, v 1.13 
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


`include "m14k_const.vh"
module m14k_tlb_jtlb1entry(
	greset,
	gscanenable,
	asid_in,
	gbit_in,
	inv_in,
	gid_in,
	vpn_in,
	cmask_in,
	data_in,
	clk,
	datawrclken0,
	datawrclken1,
	tagwrclken,
	tag_rd_str,
	rd_str0,
	rd_str1,
	cmp_str,
	is_root,
	guest_mode,
	cp0random_val_e,
	asid_out,
	gid_out,
	gbit_out,
	inv_out,
	vpn2_out,
	cmask_out,
	data_out,
	match,
	mmu_type);

`include "m14k_mmu.vh"

        parameter M14K_TLB_JTLB_ASID	= `M14K_ASIDWIDTH;
        parameter M14K_TLB_JTLB_VPN2	= `M14K_VPN2WIDTH+`M14K_ASIDWIDTH;
        parameter M14K_TLB_JTLB_CMASK	= `M14K_CMASKWIDTH+`M14K_VPN2WIDTH+`M14K_ASIDWIDTH;
        parameter M14K_TLB_JTLB_CMASKE	= `M14K_VPN2WIDTH+`M14K_ASIDWIDTH;
        parameter M14K_TLB_JTLB_INIT	= `M14K_CMASKWIDTH+`M14K_VPN2WIDTH+`M14K_ASIDWIDTH;
        parameter M14K_TLB_JTLB_G	= `M14K_CMASKWIDTH+`M14K_VPN2WIDTH+`M14K_ASIDWIDTH+1;
        parameter M14K_TLB_JTLB_GID	= `M14K_CMASKWIDTH+`M14K_VPN2WIDTH+`M14K_ASIDWIDTH+`M14K_GIDWIDTH+1;
        parameter M14K_TLB_JTLB_ENHIINV	= `M14K_CMASKWIDTH+`M14K_VPN2WIDTH+`M14K_ASIDWIDTH+`M14K_GIDWIDTH+`M14K_ENHIINVWIDTH+1;
        parameter M14K_TLB_JTLB_MSB	= `M14K_CMASKWIDTH+`M14K_VPN2WIDTH+`M14K_ASIDWIDTH+`M14K_GIDWIDTH+`M14K_ENHIINVWIDTH+1;

	input		greset;		// Processor greset
	input		gscanenable;	// Test Mode

	input [`M14K_ASID]	asid_in;		// asid For Writes and compare
	input		gbit_in;		// gbit Bit For Writes and compare
	input		inv_in;
	input	[`M14K_GID]	gid_in;		// Guest ID For Writes and compare
	input [`M14K_VPN]	vpn_in;		// Virt Page Num For Write and Compare
	input [`M14K_CMASK]	cmask_in;	// Compressed Page mask

	input [`M14K_JTLBDATA] data_in;	// Data word for write
	input		clk;
	input		datawrclken0;	// Clock to write even data entry
	input		datawrclken1;	// Clock to write odd data entry
	input		tagwrclken;	// Clock to write tag entry
	input		tag_rd_str;	// Read Enable for Tag
	input		rd_str0;		// Read Enable for even entry
	input		rd_str1;		// Read Enable for odd entry
	input		cmp_str;		// Compare Enable
	input		is_root;
	input		guest_mode;
	input		cp0random_val_e;

	output [`M14K_ASID]	asid_out;	// asid Value read
	output [`M14K_GID]	gid_out;	// GuestID read
	output		gbit_out;		// gbit bit read
	output		inv_out;		// gbit bit read
	output [`M14K_VPN2]	vpn2_out;	// vpn2 read
	output [`M14K_CMASK]	cmask_out;	// cmask read/compare

	output [`M14K_JTLBDATA] data_out;	// Data word read

	output		match;		// match output
	output		mmu_type;

// BEGIN Wire declarations made by MVP
wire [`M14K_JTLBDATA] /*[31:5]*/ data_out;
wire [31:8] /*[31:8]*/ pah1_31_8;
wire [`M14K_PMASK] /*[17:0]*/ mask_in;
wire match;
wire [`M14K_VPN2] /*[31:11]*/ vpn2;
wire data_out_en0;
wire [`M14K_GID] /*[2:0]*/ gid;
wire [`M14K_CMASK] /*[9:0]*/ cmask;
wire inv_out;
wire gbit_out;
wire odd_sel;
wire data_out_en1;
wire [`M14K_PMASK] /*[17:0]*/ mask;
wire cmask_out_en;
wire [31:0] /*[31:0]*/ vpn_in_31_0;
wire [31:0] /*[31:0]*/ vpn2_31_0;
wire [`M14K_ASID] /*[7:0]*/ asid;
wire inv;
wire [`M14K_VPN2] /*[31:11]*/ vpn2_out;
wire [`M14K_ASID] /*[7:0]*/ asid_out;
wire mmu_type;
wire gbit;
wire [`M14K_GID] /*[2:0]*/ gid_out;
wire [31:8] /*[31:8]*/ pah0_31_8;
wire [`M14K_CMASK] /*[9:0]*/ cmask_out;
wire init;
// END Wire declarations made by MVP


	//
	// Write and Storage Circuitry
	//

/************************************************************************
#########################################################################
TLB Organization:
#########################################################################

Tag Array : Tag information for dual entries (35 bits)
	init	hardware reset bit; cleared on reset, set on tlb write
	vpn2	VPN/2 bits from va[31:13] (19 bits)
	asid	mmu_asid bits (8 bits)
	cmask	Compressed pagemask bits (6 bits)
	gbit	Global bit anded from enlo0/1 (1 bit)
	gid	Guest ID from enlo0/1 (3 bit)
	inv	Invalid bit from enhi (1 bit)

Data Array0 : PTE information for EVEN tlb entry (25 bits)
	PFN0	pfn bits [31:12] (20 bits)
	C0	Coherence attributes (3 bits)
	D0	Dirty bit (1 bit)
	V0	Valid bit (1 bit)

Data Array1 : PTE information for ODD tlb entry (25 bits)
	PFN1	pfn bits [31:12] (20 bits)
	C1	Coherence attributes (3 bits)
	D1	Dirty bit (1 bit)
	V1	Valid bit (1 bit)

************************************************************************/

	// registers concatenated into one ultra wide register
	wire [M14K_TLB_JTLB_MSB:0] jtlb1entry_pipe_in;
	wire [M14K_TLB_JTLB_MSB:0] jtlb1entry_pipe_out;

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
	
	// MMU type: 1->BAT, 0->TLB  Static output
	assign mmu_type = 1'b0;	// Signal that we are a TLB

	// 
	mvp_cregister_wide_tlb #(M14K_TLB_JTLB_MSB+1) _jtlb1entry_pipe_out(jtlb1entry_pipe_out, gscanenable,
									  tagwrclken, clk, jtlb1entry_pipe_in);
	// 

	// init bit
	assign jtlb1entry_pipe_in[M14K_TLB_JTLB_INIT] = !greset;
	assign init = jtlb1entry_pipe_out[M14K_TLB_JTLB_INIT];


	// register-based tlb with no gated clocks

	// Tag Fields
	assign jtlb1entry_pipe_in[M14K_TLB_JTLB_G] = gbit_in | is_root & (|gid_in);
	assign gbit = jtlb1entry_pipe_out[M14K_TLB_JTLB_G];

	assign jtlb1entry_pipe_in[M14K_TLB_JTLB_GID : M14K_TLB_JTLB_G+1] = gid_in;
	assign gid[`M14K_GID] = jtlb1entry_pipe_out[M14K_TLB_JTLB_GID : M14K_TLB_JTLB_G+1];

	assign jtlb1entry_pipe_in[M14K_TLB_JTLB_ENHIINV] = inv_in & ~cp0random_val_e;
	assign inv = jtlb1entry_pipe_out[M14K_TLB_JTLB_ENHIINV];

	assign jtlb1entry_pipe_in[M14K_TLB_JTLB_ASID-1:0] = asid_in;
	assign asid [`M14K_ASID] = jtlb1entry_pipe_out[M14K_TLB_JTLB_ASID-1:0];

	assign jtlb1entry_pipe_in[M14K_TLB_JTLB_VPN2-1:`M14K_ASIDWIDTH] = vpn_in[`M14K_VPN2];
	assign vpn2 [`M14K_VPN2] = jtlb1entry_pipe_out[M14K_TLB_JTLB_VPN2-1:`M14K_ASIDWIDTH];

	assign jtlb1entry_pipe_in[M14K_TLB_JTLB_CMASK-1:M14K_TLB_JTLB_CMASKE] = cmask_in;
	assign cmask [`M14K_CMASK] = jtlb1entry_pipe_out[M14K_TLB_JTLB_CMASK-1:M14K_TLB_JTLB_CMASKE];

	// Data Fields
	wire [`M14K_JTLBDATA] data0;
	wire [`M14K_JTLBDATA] data1;
	// 
	mvp_cregister_wide_tlb #(`M14K_JTLBDATAWIDTH) _data0(data0, gscanenable, datawrclken0, clk, data_in);
	mvp_cregister_wide_tlb #(`M14K_JTLBDATAWIDTH) _data1(data1, gscanenable, datawrclken1, clk, data_in);
	// 

	//
	// match Circuitry
	//
	assign mask [`M14K_PMASK] = expand(cmask);
	assign mask_in [`M14K_PMASK] = expand(cmask_in);
	assign match = cmp_str & init & (gbit | gbit_in | (asid == asid_in)) & ~inv
		& (gid == gid_in) & (&( mask | mask_in | ~(vpn2 ^ vpn_in[`M14K_VPN2])));
	assign odd_sel = |({mask, 1'b1} & ~{1'b0, mask} & vpn_in);

	//
	// Read Circuitry
	//
	assign cmask_out_en = tag_rd_str && !inv && !(guest_mode && (gid != gid_in)) || match;
	assign data_out_en0 = rd_str0 && !inv && !(guest_mode && (gid != gid_in)) || match && !odd_sel;
	assign data_out_en1 = rd_str1 && !inv && !(guest_mode && (gid != gid_in)) || match && odd_sel;

        parameter AW = `M14K_ASIDWIDTH;
        parameter GW = `M14K_GIDWIDTH;
        parameter DW = `M14K_JTLBDATAWIDTH;
        parameter VW = `M14K_VPN2WIDTH;
        parameter CM = `M14K_CMASKWIDTH;
        assign asid_out [`M14K_ASID]     = {AW{rd_str0 & ~inv & ~(guest_mode & (gid != gid_in))}} & asid;
        assign gid_out [`M14K_GID]     = {GW{rd_str0 & ~inv & ~(guest_mode & (gid != gid_in))}} & gid;
	assign inv_out = rd_str0 & (inv | guest_mode & (gid != gid_in));
        assign gbit_out                = (data_out_en0 | data_out_en1) & gbit;
        assign vpn2_out [`M14K_VPN2]     = {VW{tag_rd_str & ~inv & ~(guest_mode && (gid != gid_in))}} & vpn2;
        assign cmask_out [`M14K_CMASK]   = {CM{cmask_out_en}} & cmask;
        assign data_out [`M14K_JTLBDATA] = {DW{data_out_en0}} & data0
                            | {DW{data_out_en1}} & data1;

  
 //VCS coverage off 
// 
   
//VCS coverage off
   
   //verilint 550 off	Mux is inferred: case (1'b1)
   //verilint 226 off 	Case-select expression is constant
   //verilint 225 off 	Case expression is not constant
   //verilint 180 off 	Zero extension of extra bits
   //verilint 528 off 	Variable set but not used
   // Generate a text description of state and next state for debugging
	assign vpn2_31_0[31:0] = {vpn2, 11'b0};
	assign vpn_in_31_0[31:0] = {vpn_in, 10'b0};
	assign pah0_31_8[31:8] = data0[31:8];
	assign pah1_31_8[31:8] = data1[31:8];
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

endmodule

