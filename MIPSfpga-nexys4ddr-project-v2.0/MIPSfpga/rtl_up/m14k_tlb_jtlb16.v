// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_tlb_jtlb
//          Synthesizable JTLB Array Model, with registers in array
//
//      $Id: \$
//      mips_repository_id: m14k_tlb_jtlb16.mv, v 1.10 
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
// verilint 191 off
module m14k_tlb_jtlb16(
	gclk,
	gtlbclk,
	gscanenable,
	greset,
	enhi,
	gid,
	entrylo,
	gbit,
	inv,
	mmu_index,
	pagemask,
	pagegrain,
	tlb_enable,
	tlb_wr_cmp,
	tlb_rd_0,
	tlb_rd_1,
	tlb_wr_0,
	tlb_wr_1,
	is_root,
	guest_mode,
	cp0random_val_e,
	tlb_vpn,
	mmu_size,
	mmu_type,
	enc,
	jtlb_lo,
	jtlb_pah,
	jtlb_grain,
	tag_array_out,
	tlb_match,
	mmu_gid);

`include "m14k_mmu.vh"

	input		gclk;
	input		gtlbclk;
	input		gscanenable;	// Test Mode

	input		greset;		// Processor greset
	input [`M14K_ASID]	enhi;		// Contents of Entry HI Register
	input [`M14K_GID]	gid;
	input [`M14K_JTLBDATA] entrylo;	// Contents of Entry LO0 or LO1
	input		gbit;		// Combined Global bit form LO0 and LO1
	input		inv;
	input [4:0]	mmu_index;	// Write index
	input [`M14K_CMASK]	pagemask;	// Compressed Page mask Value
        input           pagegrain;      // Smallest pagesize = 1KB/4KB (0/1)
	input		tlb_enable;	// General Enable
        input           tlb_wr_cmp;       // Probe Enable for Write Comp
        input           tlb_rd_0;         // TLB Read Even + Tag
        input           tlb_rd_1;         // TLB Read Odd
        input           tlb_wr_0;         // TLB Write Even + Tag
        input           tlb_wr_1;         // TLB Write Odd
        input           is_root;
        input           guest_mode;
	input 		cp0random_val_e;        // Early indication of TLBWR

	input [`M14K_VPN]	tlb_vpn;		// Virtual Address for Translation

	output	[1:0]	mmu_size;	        // Indicate size of JTLB array
	output		mmu_type;	// Static Output indication type of MMU
	output [4:0]	enc;		// Encoded index of matching entry
	output [`M14K_JTLBL]	jtlb_lo;		// Low bits of TLB (for the cpy)
	output [`M14K_PAH]	jtlb_pah;		// Translated Physical address for the uTLBs
	output			jtlb_grain;      // pagesize = 4KB+/1KB (1/0)
	output [`M14K_JTLBH]	tag_array_out;	// Hi bits of matching TLB entry
	output		tlb_match;	// match indication
	output [`M14K_GID]	mmu_gid;

// BEGIN Wire declarations made by MVP
wire gbit_in;
wire tlb_match;
wire jtlb_grain;
wire [`M14K_PFN] /*[31:12]*/ pfn;
wire [15:0] /*[15:0]*/ tagwrclken_16;
wire [`M14K_JTLBH] /*[40:0]*/ tag_array_out;
wire [15:0] /*[15:0]*/ datawrclken1_16;
wire [3:0] /*[3:0]*/ index_dis_bus;
wire cmp_en;
wire [4:0] /*[4:0]*/ enc;
wire cmp_mask_en;
wire data_rd_en0;
wire [1:0] /*[1:0]*/ index_reg;
wire tag_rd_en;
wire [3:0] /*[3:0]*/ idx_dec_4;
wire [`M14K_GID] /*[2:0]*/ mmu_gid;
wire cmp_idx_dis;
wire [3:0] /*[3:0]*/ tag_rd_str;
wire [1:0] /*[1:0]*/ mmu_size;
wire data_wr_en0;
wire tag_wr_en;
wire [15:0] /*[15:0]*/ idx_dec16;
wire [31:0] /*[31:0]*/ cmp_str32;
wire [`M14K_GID] /*[2:0]*/ gid_in;
wire [3:0] /*[3:0]*/ rd_str0;
wire [`M14K_PMUXRANGE] /*[27:10]*/ sel_mask;
wire data_rd_en1;
wire [`M14K_JTLBL] /*[31:4]*/ jtlb_lo;
wire [31:0] /*[31:0]*/ long_mask;
wire data_wr_en1;
wire gpm_en;
wire [`M14K_PFNLO-1:`M14K_VPNLO] /*[11:10]*/ fill;
wire [4:0] /*[4:0]*/ index;
wire inv_in;
wire cmp_str;
wire [`M14K_PAH] /*[31:10]*/ raw_pah;
wire [`M14K_VPN] /*[31:10]*/ vpn_in;
wire [`M14K_PAH] /*[31:10]*/ jtlb_pah;
wire [15:0] /*[15:0]*/ datawrclken0_16;
wire [3:0] /*[3:0]*/ rd_str1;
wire [`M14K_JTLBDATA] /*[31:5]*/ data_in;
wire [`M14K_CMASK] /*[9:0]*/ cmask_in;
wire [`M14K_ASID] /*[7:0]*/ asid_in;
// END Wire declarations made by MVP


/************************************************************************
#########################################################################
General TLB operation
#########################################################################
The main TLB (jtlb) performs the following operations:

  1. Translation of instruction virtual references on an itlb miss.
     Refill of the itlb from the jtlb on a jtlb hit is handled automatically
     by hardware.

  2. Translation of data load/store addresses.

  3. TLB probe operation (TLBP instruction).

  4. TLB read operation (TLBR instruction).

  5. TLB write operation (TLBWI and TLBWR instructions).


The implementation of the TLB read and write operations are discussed
further below...

#########################################################################
TLB Read operation (TLBR instruction)
#########################################################################
TLB reads require two cycles to complete, because there is only one set
of read bitlines for the EntryLo0/1 information stored in DatArray0/1.

Cycle 1 (M stage of TLBR):
  TagArray and DatArray0 information is read from array, and written to
  EntryHi and EntryLo0 cp0 registers.

Cycle 2 (W stage [M+1]of TLBR):
  DatArray1 information is read from array, and written to EntryLo1
  cp0 register.

#########################################################################
TLB Write operation (TLBWI, TLBWR instructions)
#########################################################################
TLB write operations require 3 consecutive cycles to access the array.

Cycle 1 (M stage of TLBWx):
  A write comparison is performed, where the entry to be written is
  checked against existing TLB entries to check for a possible conflict
  where the incoming virtual address is already resident in the TLB
  (at a different entry than the one to be written).  Note that this
  write comparison requires some different functionality than a normal
  compare:

	1. A hardware reset bit is implemented in the tag field to prevent
	   power up tag values from causing false write compare matches.
	2. The incoming pagemask must qualify the per-entry address comparison.
	   (For example, if a 16M page is to be written and a 4k page within
	   the 16M page is already in the tlb, then the write comparison must
	   match for this case.)
	3. The incoming global bit must be or'd with the per-entry global bit,
	   since an incoming entry with global enable must compare to an
	   existing entry with global disable.
	4. The entry to be written is excluded from the compare, since it's
	   ok to overwrite the same entry.

  If the write comparison matches, then the TS bit is set in the DS field
  of the Status register, and a machine check exception is flagged.  The
  write to the tlb is not performed if the write comparison matches.

  Note that it is possible for multiple entries to match in the TLB during
  the write compare.  (For example imagine that 4k pages are resident in the
  tlb and a write is attempted with a 16M page that encompasses all the
  resident 4k pages.  Then we will match on all the 4k entries, except the
  entry to be written, since it's excluded.)  Depending on the implementation
  details, the match-line selection of pte wordlines may need to be
  suppressed during the write compare cycle since more than one could
  turn on.

Cycle 2 (W stage [M+1] of TLBWx):
  TagArray and DatArray0 information is written to array from the
  EntryHi and EntryLo0 cp0 registers.
  
Cycle 3 (X stage [M+2] of TLBWx):
  DatArray1 information is written to array from the EntryLo1 cp0 register.
  
************************************************************************/


wire [`M14K_CMASK] 	cmask_out;
wire [`M14K_VPN2] 	vpn2_out;
wire [`M14K_ASID] 	asid_out;
wire [`M14K_GID] 	gid_out;
wire 			gbit_out;
wire 			inv_out;
wire 			match_out;
wire [`M14K_JTLBDATA] 	data_out;
wire [3:0] 		match_enc_out;
	
	/* Block-level Clock Buffer */

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

	//
	//	Input signals are mapped and in some cases modified from core-
	//	centric structre to TLB-centric structure.
	//
        // Only enable gbit and pagemask inputs when writing or doing compare
        mvp_register #(1) _gpm_en(gpm_en,gclk, tag_wr_en || cmp_mask_en);
        assign long_mask [31:0] = {32{gpm_en}};

	assign asid_in [`M14K_ASID]   = enhi[`M14K_ASID];
	assign gid_in [`M14K_GID]   = gid;
	assign gbit_in              = gbit && gpm_en;
	assign inv_in              = inv;
	assign vpn_in [`M14K_VPN]    = tlb_vpn;
	assign cmask_in [`M14K_CMASK] = pagemask & long_mask[`M14K_CMASK];
	assign index [4:0]      = mmu_index;

	assign data_in [`M14K_JTLBDATA] = entrylo;



        assign tag_wr_en   = tlb_wr_0; // Tag is written in first clock of TLBW
        assign data_wr_en0 = tlb_wr_0; // Even Data is written in 1st clock or TLBW
        assign data_wr_en1 = tlb_wr_1; // Odd Data is written in 2nd clock of TLBW

        assign cmp_en      = tlb_enable;        // Enable for tag comparison
        assign cmp_mask_en  = tlb_wr_cmp; // Enable use of incoming gbit and cmask in compare
        assign cmp_idx_dis = tlb_wr_cmp; // Disables indexed entry from comparison

        assign tag_rd_en =  tlb_rd_0; // Tag Array Indexed Read
        assign data_rd_en0   =  tlb_rd_0; // Even Data Array Indexed Read
        assign data_rd_en1   =  tlb_rd_1; // Odd Data Array Indexed Read

	//
	//	Map Outputs also
	//

	assign mmu_size [1:0] = 2'b01;

	assign enc [4:0] = match_enc_out; // Encoded match Output
	assign tag_array_out [`M14K_JTLBH] = { cmask_out, vpn2_out, asid_out, inv_out, gbit_out };
	assign mmu_gid[`M14K_GID] = gid_out;
	assign tlb_match = match_out;

	// Physical Address Mux
        // Changes done to avoid hardcoding of bit numbers and field widths (PKA)
	// A problem may be, the replacement of MUXes with AND-ORs, and the
	// associated change in delay

	// Do a "compatibility shift"
	assign fill[`M14K_PFNLO-1:`M14K_VPNLO] = { `M14K_PFNLO-`M14K_VPNLO { 1'b0 }};
	assign raw_pah [`M14K_PAH]  = pagegrain ? {data_out[`M14K_PFN], fill} : { fill, data_out[`M14K_PFN]};
	// And - back again
	assign pfn    [`M14K_PFN]  = pagegrain ? jtlb_pah[`M14K_PFN] : jtlb_pah[`M14K_PAHHI-`M14K_PFNLO+`M14K_VPNLO:`M14K_PAHLO];

	// Use the PAH for the uTLBs
        assign cmp_str32 [31:0] = {32{cmp_str}};
        assign sel_mask[`M14K_PMUXRANGE] = expand(cmask_out & cmp_str32[`M14K_CMASK]);
	assign jtlb_pah   [`M14K_PAH]  = { raw_pah[`M14K_PFNNONMUXED],
                           ( sel_mask & vpn_in[`M14K_PMUXRANGE]) |
                           (~sel_mask & raw_pah[`M14K_PMUXRANGE])};

	// Use the jtlb_grain for the uTLBs
	assign jtlb_grain = cmask_out [`M14K_CMASKLO+1];	// pagesize = 4KB+/1KB (1/0) (maske sure that 2k page are mapped as 1k)

	// Use the jtlb_lo for the cpy
        assign jtlb_lo [`M14K_JTLBL] = { pfn, data_out[`M14K_JTLBATTXG], gbit_out };

	//
	// 2-to-4 Decoder
	function [3:0] dec2to4; input [1:0] enc;
		dec2to4 = 4'b0001 << enc;
	endfunction

	// 3-to-8 Decoder
	function [7:0] dec3to8; input [2:0] enc;
		dec3to8 = 8'h01 << enc;
	endfunction

	// 4-to-16 Decoder
	function [15:0] dec4to16; input [3:0] enc;
		dec4to16 = 16'h0001 << enc;
	endfunction

	// 5-to-32 Decoder
	function [31:0] dec5to32; input [4:0] enc;
		dec5to32 = 32'h00000001 << enc;
	endfunction
	//

        mvp_register #(2) _index_reg_1_0_(index_reg[1:0],gclk, index[1:0]);

        // Generate clock enable signals instead of gating at this level.
        assign idx_dec16      [15:0] = dec4to16(index[3:0]); // Save two decoders
        assign tagwrclken_16   [15:0] = ({16{greset}} | {16{tag_wr_en}} & idx_dec16);
        assign datawrclken0_16 [15:0] = {16{data_wr_en0}} & idx_dec16;
        assign datawrclken1_16 [15:0] = {16{data_wr_en1}} & idx_dec16;

        assign idx_dec_4       [3:0]  = dec2to4(index[3:2]); // Save three decoders
        mvp_register #(4) _tag_rd_str_3_0_(tag_rd_str[3:0],gclk, {4{tag_rd_en}} & idx_dec_4);
        mvp_register #(4) _rd_str0_3_0_(rd_str0[3:0],gclk, {4{data_rd_en0}} & idx_dec_4);
        mvp_register #(4) _rd_str1_3_0_(rd_str1[3:0],gclk, {4{data_rd_en1}} & idx_dec_4);
        mvp_register #(1) _cmp_str(cmp_str,gclk, cmp_en);
        mvp_register #(4) _index_dis_bus_3_0_(index_dis_bus[3:0],gclk, {4{cmp_idx_dis}} & idx_dec_4);

	m14k_tlb_jtlb16entries tlb0to15 (
                /* Inputs */
                .is_root        (is_root),
                .guest_mode        (guest_mode),
                .greset        (greset),
		.gscanenable	(gscanenable),
                .asid_in       (asid_in),
                .gid_in       (gid_in),
                .gbit_in          (gbit_in),
                .inv_in          (inv_in),
                .cp0random_val_e          (cp0random_val_e),
                .vpn_in        (vpn_in),
                .cmask_in      (cmask_in),
                .data_in       (data_in),
		.clk          (gtlbclk),
                .tagwrclken_16   (tagwrclken_16[15:0]),
                .datawrclken0_16 (datawrclken0_16[15:0]),
                .datawrclken1_16 (datawrclken1_16[15:0]),
                .rindex       (index_reg[1:0]),
                .tag_rd_str     (tag_rd_str[3:0]),
                .rd_str0       (rd_str0[3:0]),
                .rd_str1       (rd_str1[3:0]),
                .cmp_str       (cmp_str),
                .cmp_idx_dis  (index_dis_bus[3:0]),
                /* Outputs */
                .asid_out      (asid_out),
                .gid_out      (gid_out),
                .mmu_type        (mmu_type),
                .gbit_out         (gbit_out),
                .inv_out         (inv_out),
                .vpn2_out      (vpn2_out),
                .cmask_out     (cmask_out),
                .data_out      (data_out),
                .match        (match_out),
                .match_enc     (match_enc_out)
	);




// verilint 191 on
endmodule

