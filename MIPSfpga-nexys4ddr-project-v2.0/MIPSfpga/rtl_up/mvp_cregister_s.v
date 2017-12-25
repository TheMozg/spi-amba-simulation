//
//	Description: mvp_cregister_s
//           Register Model with async. low set parameterized by width
//
//	$Id: \$
//	mips_repository_id: mvp_cregister_s.v, v 3.3 
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
//verilint 549 off  // Asynchronous flipflop is inferred
//verilint 257 off  // * Delays ignored by synthesis tools
//verilint 280 off  // * Delay in non blocking assignment

`include "m14k_const.vh"
module mvp_cregister_s (
	q,
	cond,
	set_b,
	clk,
	d
);
// synopsys template
parameter WIDTH = 1;

output [WIDTH-1:0] q;
reg [WIDTH-1:0] q;

input  cond;
input  set_b;
input  clk;
input  [WIDTH-1:0] d;

always @(posedge clk or negedge set_b)
	begin
		if (~set_b)
			q <= #`M14K_FDELAY {WIDTH{1'b1}};
		else if (cond)
			q <= #`M14K_FDELAY d;

	 `ifdef MIPS_SIMULATION 
 //VCS coverage off 
	// 
	`ifdef M14K_XCHECK
		// For simulation purposes, explicitly x out the q output if
		// clock or condition goes to x and d is different than q
		if (((clk === 1'bx || cond === 1'bx) && (q !== d) && (set_b !== 1'b0)) ||
		    ((set_b === 1'bx) && (q !== {WIDTH{1'b1}})))
			q <= #`M14K_FDELAY {WIDTH{1'bx}};
	`endif
	  //VCS coverage on  
 `endif 
	// 

	end // always @ (posedge clk or negedge set_b)

//verilint 549 on  // Asynchronous flipflop is inferred
//verilint 257 on  // * Delays ignored by synthesis tools
//verilint 280 on  // * Delay in non blocking assignment
endmodule
