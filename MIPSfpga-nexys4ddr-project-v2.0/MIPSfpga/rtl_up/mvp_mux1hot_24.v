//	Description: mvp_mux1hot_23
//		23-1 one hot mux Model parameterized by width
//
//      $Id: \$
//      mips_repository_id: mvp_mux1hot_24.v, v 1.1 
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
module mvp_mux1hot_24(
	y,
	sel0,
	d0,
	sel1,
	d1,
	sel2,
	d2,
	sel3,
	d3,
	sel4,
	d4,
	sel5,
	d5,
	sel6,
	d6,
	sel7,
	d7,
	sel8,
	d8,
	sel9,
	d9,
	sel10,
	d10,
	sel11,
	d11,
	sel12,
	d12,
	sel13,
	d13,
	sel14,
	d14,
	sel15,
	d15,
	sel16,
	d16,
	sel17,
	d17,
	sel18,
	d18,
	sel19,
	d19,
	sel20,
	d20,
	sel21,
	d21,
	sel22,
	d22,
	sel23,
	d23
);
// synopsys template
parameter WIDTH = 1;

output [WIDTH-1:0]	y;

input			sel0;
input			sel1;
input			sel2;
input			sel3;
input			sel4;
input			sel5;
input			sel6;
input			sel7;
input			sel8;
input			sel9;
input			sel10;
input			sel11;
input			sel12;
input			sel13;
input			sel14;
input			sel15;
input			sel16;
input			sel17;
input			sel18;
input			sel19;
input			sel20;
input			sel21;
input			sel22;
input			sel23;
input  [WIDTH-1:0]	d0;
input  [WIDTH-1:0]	d1;
input  [WIDTH-1:0]	d2;
input  [WIDTH-1:0]	d3;
input  [WIDTH-1:0]	d4;
input  [WIDTH-1:0]	d5;
input  [WIDTH-1:0]	d6;
input  [WIDTH-1:0]	d7;
input  [WIDTH-1:0]	d8;
input  [WIDTH-1:0]	d9;
input  [WIDTH-1:0]	d10;
input  [WIDTH-1:0]	d11;
input  [WIDTH-1:0]	d12;
input  [WIDTH-1:0]	d13;
input  [WIDTH-1:0]	d14;
input  [WIDTH-1:0]	d15;
input  [WIDTH-1:0]	d16;
input  [WIDTH-1:0]	d17;
input  [WIDTH-1:0]	d18;
input  [WIDTH-1:0]	d19;
input  [WIDTH-1:0]	d20;
input  [WIDTH-1:0]	d21;
input  [WIDTH-1:0]	d22;
input  [WIDTH-1:0]	d23;


 assign y = 
	{WIDTH{sel0}} & d0 |
	{WIDTH{sel1}} & d1 |
	{WIDTH{sel2}} & d2 |
	{WIDTH{sel3}} & d3 |
	{WIDTH{sel4}} & d4 |
	{WIDTH{sel5}} & d5 |
	{WIDTH{sel6}} & d6 |
	{WIDTH{sel7}} & d7 |
	{WIDTH{sel8}} & d8 |
	{WIDTH{sel9}} & d9 |
	{WIDTH{sel10}} & d10 |
	{WIDTH{sel11}} & d11 |
	{WIDTH{sel12}} & d12 |
	{WIDTH{sel13}} & d13 |
	{WIDTH{sel14}} & d14 |
	{WIDTH{sel15}} & d15 |
	{WIDTH{sel16}} & d16 |
	{WIDTH{sel17}} & d17 |
	{WIDTH{sel18}} & d18 |
	{WIDTH{sel19}} & d19 |
	{WIDTH{sel20}} & d20 |
	{WIDTH{sel21}} & d21 |
	{WIDTH{sel22}} & d22 |
	{WIDTH{sel23}} & d23 ;


endmodule

