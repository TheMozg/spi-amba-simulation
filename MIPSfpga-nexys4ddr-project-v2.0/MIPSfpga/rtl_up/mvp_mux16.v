//
//	mvp_mux16
//      Description: 16-1 encode select mux Model parameterized by width
//
//	$Id: \$
//	mips_repository_id: mvp_mux16.v, v 3.2 
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

// Comments for verilint
//verilint 550 off  // Mux is inferred

`include "m14k_const.vh"
module mvp_mux16(
	z,
	sel,
	d0,
	d1,
	d2,
	d3,
	d4,
	d5,
	d6,
	d7,
	d8,
	d9,
	d10,
	d11,
	d12,
	d13,
	d14,
	d15
);
// synopsys template
parameter WIDTH = 1;

output	[WIDTH-1:0]	z;

input	[3:0]		sel;
input	[WIDTH-1:0]	d0;
input	[WIDTH-1:0]	d1;
input	[WIDTH-1:0]	d2;
input	[WIDTH-1:0]	d3;
input	[WIDTH-1:0]	d4;
input	[WIDTH-1:0]	d5;
input	[WIDTH-1:0]	d6;
input	[WIDTH-1:0]	d7;
input	[WIDTH-1:0]	d8;
input	[WIDTH-1:0]	d9;
input	[WIDTH-1:0]	d10;
input	[WIDTH-1:0]	d11;
input	[WIDTH-1:0]	d12;
input	[WIDTH-1:0]	d13;
input	[WIDTH-1:0]	d14;
input	[WIDTH-1:0]	d15;

wire	[WIDTH-1:0]	z10;
wire	[WIDTH-1:0]	z11;
wire	[WIDTH-1:0]	z12;
wire	[WIDTH-1:0]	z13;

mvp_mux4 #(WIDTH) mux10 ( .y(z10), .sel(sel[1:0]), .a(d0),  .b(d1),  .c(d2),  .d(d3));
mvp_mux4 #(WIDTH) mux11 ( .y(z11), .sel(sel[1:0]), .a(d4),  .b(d5),  .c(d6),  .d(d7));
mvp_mux4 #(WIDTH) mux12 ( .y(z12), .sel(sel[1:0]), .a(d8),  .b(d9),  .c(d10), .d(d11));
mvp_mux4 #(WIDTH) mux13 ( .y(z13), .sel(sel[1:0]), .a(d12), .b(d13), .c(d14), .d(d15));

mvp_mux4 #(WIDTH) mux14 ( .y(z), .sel(sel[3:2]), .a(z10), .b(z11), .c(z12), .d(z13));

endmodule

// Comments for verilint
//verilint 550 on
