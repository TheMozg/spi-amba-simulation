// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// 	Description:  m14k_cache_cmp
// 	    Cache tag compare logic
//	
//	$Id: \$
//	mips_repository_id: m14k_cache_cmp.mv, v 1.1 
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
module m14k_cache_cmp(
	tag_cmp_data,
	tag_cmp_pa,
	tag_cmp_v,
	spram_support,
	valid,
	line_sel,
	hit_way,
	cachehit);


	/* parameters, overriden per instance */

	// synopsys template
	parameter		WIDTH=1;		// WIDTH of PA
	parameter		ASSOC=1;		// Cache Associativity


	/* Inputs */
	input [WIDTH-1:0]	tag_cmp_data;		// PA from TLB
	input [ASSOC*WIDTH-1:0]	tag_cmp_pa;	// PA's coming out of tagram
	input [(ASSOC)-1:0]	tag_cmp_v;		// Valid Bits per line

	input 			spram_support;     // Last way is really SPRAM disable comparison

	/* Outputs */
	output [3:0]		valid;	// Valid bit per line
	output [3:0]		line_sel;	// Line Matched and was valid
	output [3:0]		hit_way;		// Match Lines
	output			cachehit;	// Hit Flag on Specifie

// BEGIN Wire declarations made by MVP
wire [3:0] /*[3:0]*/ valid;
wire cachehit;
wire [3:0] /*[3:0]*/ hit_way;
wire [3:0] /*[3:0]*/ line_sel;
wire [3:0] /*[3:0]*/ spram;
// END Wire declarations made by MVP


	/* End of I/O */

	// Any word valid on each line??
	assign valid [3:0] = tag_cmp_v;

	// Disable comparison on SPRAM way
	// spram_support is statically tied off in spram logic module
	// this logic should be optimized away
	assign spram[3:0] = spram_support ? {(ASSOC==4), (ASSOC==3), (ASSOC==2), (ASSOC==1)} : 4'b0;
	
   
	wire [4*WIDTH-1:0] wide_tag_cmp_pa = {tag_cmp_pa};
 
	wire [WIDTH-1:0]	cache_pa_0 = wide_tag_cmp_pa[WIDTH-1:0];
	wire [WIDTH-1:0]	cache_pa_1 = wide_tag_cmp_pa[2*WIDTH-1:WIDTH];
	wire [WIDTH-1:0]	cache_pa_2 = wide_tag_cmp_pa[3*WIDTH-1:2*WIDTH];
	wire [WIDTH-1:0]	cache_pa_3 = wide_tag_cmp_pa[4*WIDTH-1:3*WIDTH];

	wire [3:0] compare;	
	assign	compare[0] = valid[0] && !spram[0] && (tag_cmp_data == cache_pa_0);
	assign	compare[1] = (ASSOC > 1) && valid[1] && !spram[1] && (tag_cmp_data == cache_pa_1);
	assign	compare[2] = (ASSOC > 2) && valid[2] && !spram[2] && (tag_cmp_data == cache_pa_2);
	assign	compare[3] = (ASSOC > 3) && valid[3] && !spram[3] && (tag_cmp_data == cache_pa_3);

   

	assign line_sel [3:0] = compare;

	// Hit way is a bit earlier than line_sel because it
	// doesn't include the cacheop forcing of the way
	assign hit_way [3:0] = compare;

	assign cachehit = | compare;

endmodule // m14k_cache_cmp

