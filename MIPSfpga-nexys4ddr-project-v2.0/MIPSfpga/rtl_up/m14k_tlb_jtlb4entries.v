// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_tlb_jtlb4entries
//         TLB Entry Model
//         Models 4 register-based tlb entries
//
//      $Id: \$
//      mips_repository_id: m14k_tlb_jtlb4entries.mv, v 1.8 
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
module m14k_tlb_jtlb4entries(
	greset,
	gscanenable,
	asid_in,
	gid_in,
	gbit_in,
	inv_in,
	vpn_in,
	cmask_in,
	rindex,
	data_in,
	clk,
	tagwrclken_4,
	datawrclken0_4,
	datawrclken1_4,
	tag_rd_str,
	rd_str0,
	rd_str1,
	cmp_str,
	cmp_idx_dis,
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
	match_enc,
	mmu_type);

`include "m14k_mmu.vh"

	input		greset;		// Processor greset
	input		gscanenable;	// Test Mode

	input [`M14K_ASID]	asid_in;		// asid For Writes and compare
	input [`M14K_GID]	gid_in;		// gid For Writes and compare
	input		gbit_in;		// gbit Bit For Writes and compare
	input		inv_in;
	input [`M14K_VPN]	vpn_in;		// Virt Page Num For Write and Compare
	input [`M14K_CMASK]	cmask_in;	// Compressed Page mask
	input [1:0]	rindex;		// index Qualifier for Read Enables

	input [`M14K_JTLBDATA] data_in;	// Data word for write
	input		clk;		// Clock - to be gated by enables below
	input [3:0]	tagwrclken_4;	// Clock to write tag entry
	input [3:0]	datawrclken0_4;	// Clock to write data entry
	input [3:0]	datawrclken1_4;	// Clock to write data entry

	input		tag_rd_str;	// Read Enable for tag value
	input		rd_str0;		// Read Enable
	input		rd_str1;		// Read Enable
	input		cmp_str;		// Compare Enable
	input		cmp_idx_dis;	// Disable index entry for comparison
	input		is_root;
	input		guest_mode;
	input		cp0random_val_e;

	output [`M14K_ASID]	asid_out;	// asid Value read
	output [`M14K_GID]	gid_out;	// gid Value read
	output		gbit_out;		// gbit bit read
	output		inv_out;
	output [`M14K_VPN2]	vpn2_out;	// vpn2 read
	output [`M14K_CMASK]	cmask_out;	// cmask read/compare

	output [`M14K_JTLBDATA] data_out;	// Data word read
	output		match;		// match output
	output [1:0]	match_enc;	// Encoded match Value
	output		mmu_type;

// BEGIN Wire declarations made by MVP
wire [`M14K_JTLBDATA] /*[31:5]*/ data_out;
wire [3:0] /*[3:0]*/ read_str0;
wire [3:0] /*[3:0]*/ comp_str;
wire match;
wire [3:0] /*[3:0]*/ tag_read_str;
wire inv_out;
wire gbit_out;
wire [3:0] /*[3:0]*/ idx_dec_4;
wire [3:0] /*[3:0]*/ read_str1;
wire [`M14K_VPN2] /*[31:11]*/ vpn2_out;
wire [`M14K_ASID] /*[7:0]*/ asid_out;
wire [1:0] /*[1:0]*/ match_enc;
wire mmu_type;
wire [`M14K_GID] /*[2:0]*/ gid_out;
wire [`M14K_CMASK] /*[9:0]*/ cmask_out;
// END Wire declarations made by MVP


	//
	function [3:0] dec2to4;
		input [1:0]	index;

		dec2to4 = 4'b0001 << index;
	endfunction
	//

	// Declare intermediate buses
	wire [`M14K_ASID]	 asid_out0,  asid_out1,  asid_out2,  asid_out3;
	wire [`M14K_GID]	 gid_out0,  gid_out1,  gid_out2,  gid_out3;
	wire [`M14K_VPN2]	 vpn2_out0,  vpn2_out1,  vpn2_out2,  vpn2_out3;
	wire [`M14K_CMASK]	 cmask_out0, cmask_out1, cmask_out2, cmask_out3;
	wire [`M14K_JTLBDATA] data_out0,  data_out1,  data_out2,  data_out3; 
	wire 		 gbit_out0,     gbit_out1,     gbit_out2,     gbit_out3;
	wire 		 inv_out0,     inv_out1,     inv_out2,     inv_out3;
	wire 		 utlb0_match,    utlb1_match,    utlb2_match,    utlb3_match;
	wire 		 mmu_type0,     mmu_type1,     mmu_type2,     mmu_type3;

	assign idx_dec_4 [3:0]	 = dec2to4(rindex);
	assign read_str0 [3:0]	 = {4{rd_str0}} & idx_dec_4;
	assign read_str1 [3:0]	 = {4{rd_str1}} & idx_dec_4;
	assign comp_str [3:0]	 = {4{cmp_str}} & ~({4{cmp_idx_dis}} & idx_dec_4);
	assign tag_read_str [3:0] = {4{tag_rd_str}} & idx_dec_4;

	m14k_tlb_jtlb1entry tlbentry0 (
		/* Inputs */
		.is_root        (is_root), 
		.guest_mode        (guest_mode), 
		.cp0random_val_e        (cp0random_val_e), 
		.greset        (greset), 
		.gscanenable	(gscanenable),
		.asid_in       (asid_in), 
		.gid_in       (gid_in), 
		.gbit_in          (gbit_in), 
		.inv_in          (inv_in), 
		.vpn_in        (vpn_in),
		.cmask_in      (cmask_in), 
		.tagwrclken   (tagwrclken_4[0]),
		.data_in       (data_in), 
		.clk          (clk), 
		.datawrclken0 (datawrclken0_4[0]),
		.datawrclken1 (datawrclken1_4[0]), 
		.tag_rd_str     (tag_read_str[0]),
		.rd_str0       (read_str0[0]), 
		.rd_str1       (read_str1[0]),
		.cmp_str       (comp_str[0]),
		/* Outputs */
		.asid_out      (asid_out0), 
		.gid_out      (gid_out0), 
                .mmu_type        (mmu_type0),
		.gbit_out         (gbit_out0), 
		.inv_out         (inv_out0), 
		.vpn2_out      (vpn2_out0),
		.cmask_out     (cmask_out0), 
		.data_out      (data_out0), 
		.match        (utlb0_match)
	);

	m14k_tlb_jtlb1entry tlbentry1 (
		/* Inputs */
		.is_root        (is_root), 
		.guest_mode        (guest_mode), 
		.cp0random_val_e        (cp0random_val_e), 
		.greset        (greset), 
		.gscanenable	(gscanenable),
		.asid_in       (asid_in), 
		.gid_in       (gid_in), 
		.gbit_in          (gbit_in), 
		.inv_in          (inv_in), 
		.vpn_in        (vpn_in),
		.cmask_in      (cmask_in), 
		.tagwrclken   (tagwrclken_4[1]),
		.data_in       (data_in), 
		.clk          (clk), 
		.datawrclken0 (datawrclken0_4[1]),
		.datawrclken1 (datawrclken1_4[1]), 
		.tag_rd_str     (tag_read_str[1]),
		.rd_str0       (read_str0[1]), 
		.rd_str1       (read_str1[1]),
		.cmp_str       (comp_str[1]),
		/* Outputs */
		.asid_out      (asid_out1), 
		.gid_out      (gid_out1), 
                .mmu_type        (mmu_type1),
		.gbit_out         (gbit_out1), 
		.inv_out         (inv_out1), 
		.vpn2_out      (vpn2_out1),
		.cmask_out     (cmask_out1), 
		.data_out      (data_out1), 
		.match        (utlb1_match)
	);

	m14k_tlb_jtlb1entry tlbentry2 (
		/* Inputs */
		.is_root        (is_root), 
		.guest_mode        (guest_mode), 
		.cp0random_val_e        (cp0random_val_e), 
		.greset        (greset), 
		.gscanenable	(gscanenable),
		.asid_in       (asid_in), 
		.gid_in       (gid_in), 
		.gbit_in          (gbit_in), 
		.inv_in          (inv_in), 
		.vpn_in        (vpn_in),
		.cmask_in      (cmask_in), 
		.tagwrclken   (tagwrclken_4[2]),
		.data_in       (data_in), 
		.clk          (clk), 
		.datawrclken0 (datawrclken0_4[2]),
		.datawrclken1 (datawrclken1_4[2]), 
		.tag_rd_str     (tag_read_str[2]),
		.rd_str0       (read_str0[2]), 
		.rd_str1       (read_str1[2]),
		.cmp_str       (comp_str[2]),
		/* Outputs */
		.asid_out      (asid_out2), 
		.gid_out      (gid_out2), 
                .mmu_type        (mmu_type2),
		.gbit_out         (gbit_out2), 
		.inv_out         (inv_out2), 
		.vpn2_out      (vpn2_out2),
		.cmask_out     (cmask_out2), 
		.data_out      (data_out2), 
		.match        (utlb2_match)
	);

	m14k_tlb_jtlb1entry tlbentry3 (
		/* Inputs */
		.is_root        (is_root), 
		.guest_mode        (guest_mode), 
		.cp0random_val_e        (cp0random_val_e), 
		.greset        (greset), 
		.gscanenable	(gscanenable),
		.asid_in       (asid_in), 
		.gid_in       (gid_in), 
		.gbit_in          (gbit_in), 
		.inv_in          (inv_in), 
		.vpn_in        (vpn_in),
		.cmask_in      (cmask_in), 
		.tagwrclken   (tagwrclken_4[3]),
		.data_in       (data_in), 
		.clk          (clk), 
		.datawrclken0 (datawrclken0_4[3]),
		.datawrclken1 (datawrclken1_4[3]), 
		.tag_rd_str     (tag_read_str[3]),
		.rd_str0       (read_str0[3]), 
		.rd_str1       (read_str1[3]),
		.cmp_str       (comp_str[3]),
		/* Outputs */
		.asid_out      (asid_out3), 
		.gid_out      (gid_out3), 
                .mmu_type        (mmu_type3),
		.gbit_out         (gbit_out3), 
		.inv_out         (inv_out3), 
		.vpn2_out      (vpn2_out3),
		.cmask_out     (cmask_out3), 
		.data_out      (data_out3), 
		.match        (utlb3_match)
	);

	// Output Generation
	assign asid_out [`M14K_ASID]	    = asid_out0  | asid_out1  | asid_out2  | asid_out3;
	assign gid_out [`M14K_GID]	    = gid_out0  | gid_out1  | gid_out2  | gid_out3;
	assign gbit_out		    = gbit_out0     | gbit_out1     | gbit_out2     | gbit_out3;
	assign inv_out		    = inv_out0     | inv_out1     | inv_out2     | inv_out3;
	assign vpn2_out [`M14K_VPN2]	    = vpn2_out0  | vpn2_out1  | vpn2_out2  | vpn2_out3;
	assign cmask_out [`M14K_CMASK]   = cmask_out0 | cmask_out1 | cmask_out2 | cmask_out3;
	assign data_out [`M14K_JTLBDATA] = data_out0  | data_out1  | data_out2  | data_out3; 
	assign mmu_type		    = mmu_type0     | mmu_type1     | mmu_type2     | mmu_type3;
	
	// match Generation
	assign match		= utlb0_match | utlb1_match | utlb2_match | utlb3_match;
	assign match_enc [1:0]	= { utlb3_match | utlb2_match, utlb1_match | utlb3_match };

	  
 //VCS coverage off 
	// 
	
	wire tlb_death = ({3'h0, utlb0_match} + utlb1_match + utlb2_match + utlb3_match) > 4'h1;
	
	  //VCS coverage on  
  
	// 

endmodule

