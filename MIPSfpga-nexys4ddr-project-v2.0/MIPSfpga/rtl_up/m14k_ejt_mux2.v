// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_ejt_mux2 
//           Glitch free mux
//	      
//
//	$Id: \$
//	mips_repository_id: m14k_ejt_mux2.mv, v 1.1 
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

module m14k_ejt_mux2(
	y,
	s,
	a,
	b);

	

output		y;			// Output

input		s;			// Select input
input		a;			// s==0
input		b;			// s==1

// BEGIN Wire declarations made by MVP
wire y;
wire bterm;
wire sela;
wire naterm2;
wire aterm2;
wire aterm;
wire a_b;
// END Wire declarations made by MVP




//---------------------------------------------------------------------------
// Code
//---------------------------------------------------------------------------

// This is simulation code of a glitch-free mux built out of NAND gates
// For synthesis, NAND gates from the library should be hand-instantiated here
// and this module should be 'don't touched' wherever it is instantiated.
// It is important that this mux is glitch-free even when select input
// changes and both input are the same.

	assign a_b = !(a && b);
// NAND2X2 a_bi (.y(a_b), .a(a), .b(b));	
	
	assign sela = !(s && s);
// NAND2X2 selai (.y(sela), .a(s), .b(s));

	assign aterm = !(a && sela);
// NAND2X2 atermi (.y(aterm), .a(sela), .b(a));

	assign aterm2 = !(aterm && a_b);
// NAND2X2 aterm2i (.y(aterm2), .a(aterm), .b(a_b));

	assign naterm2 = !(aterm2 && aterm2);
// NAND2X2 natermi (.y(naterm2), .a(aterm2), .b(aterm2)); 	

	assign bterm = !(s && b);
// NAND2X2 btermi (.y(bterm), .a(s), .b(b));	

	assign y = !(naterm2 && bterm);
// NAND2X2 yi (.y(y), .a(naterm2), .b(bterm));	
	


endmodule
