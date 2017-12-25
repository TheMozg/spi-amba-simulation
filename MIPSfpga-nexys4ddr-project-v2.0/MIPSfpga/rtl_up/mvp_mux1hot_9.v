//	Description: mvp_mux1hot_9
//		9-1 one hot mux Model parameterized by width
//
//      $Id: \$
//      mips_repository_id: mvp_mux1hot_9.v, v 3.2 
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
module mvp_mux1hot_9(
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
	d8
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
input  [WIDTH-1:0]	d0;
input  [WIDTH-1:0]	d1;
input  [WIDTH-1:0]	d2;
input  [WIDTH-1:0]	d3;
input  [WIDTH-1:0]	d4;
input  [WIDTH-1:0]	d5;
input  [WIDTH-1:0]	d6;
input  [WIDTH-1:0]	d7;
input  [WIDTH-1:0]	d8;


 assign y = 
	{WIDTH{sel0}} & d0 |
	{WIDTH{sel1}} & d1 |
	{WIDTH{sel2}} & d2 |
	{WIDTH{sel3}} & d3 |
	{WIDTH{sel4}} & d4 |
	{WIDTH{sel5}} & d5 |
	{WIDTH{sel6}} & d6 |
	{WIDTH{sel7}} & d7 |
	{WIDTH{sel8}} & d8 ;


endmodule
