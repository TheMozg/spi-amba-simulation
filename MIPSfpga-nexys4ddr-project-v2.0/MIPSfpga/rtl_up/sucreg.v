// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: sucreg
//            Register Model parameterized by width
//            unconditional register - Has condtion which is logically
//            not needed.  The condition can be used for to reduce
//            power if cregisters are implemented with gated clocks.
//            Otherwise, it can be implemented as a regular register
//            for area savings (over a cregister)
//
//	$Id: \$
//	mips_repository_id: sucreg.mv, v 3.5 
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

// Since much of module is in translate off blocks
// disable a couple Verilint warnings 
//verilint 240 off  // Unused input
//verilint 241 off  // Output never gets set

`include "m14k_const.vh"
module sucreg(
	q,
	scanenable,
	cond,
	gclk,
	d);

// synopsys template
parameter WIDTH = 1;

output [WIDTH-1:0] q;

input  scanenable;
input  cond;
input  gclk;
input  [WIDTH-1:0] d;

  
 //VCS coverage off 
//
//	
reg [7:0] configmem [0:`M14K_CFG_MEM_CNT-1];
reg SelectGC;
wire [WIDTH-1:0] q;
wire [WIDTH-1:0] q_gc;
wire [WIDTH-1:0] q_ngc;

// simulation code
// Make the switch between enabling and disabling gated clocks here
// be dynamically configurable so the VMC model can exactly model the
// customers RTL	

	initial
		begin
`ifdef MIPS_SWIFT
        	$swift_readmem("U:vmc_config", configmem);
`else
		$readmemh(`M14K_SMOD_CONFIG_FILE, configmem);
`endif
		if (configmem[20] === 8'bx)
        	        SelectGC =     1;              // Select gated clock by default
        	else
        	        SelectGC = configmem[20];
        	end 

	mvp_cregister_gc #(WIDTH) cregister(q_gc, scanenable, cond, gclk, d);
	mvp_register_ngc #(WIDTH) register(q_ngc, scanenable, cond, gclk, d);

	assign q = SelectGC ? q_gc : q_ngc;

//
//
 //VCS coverage on  
  

//verilint 240 on  // Unused input
//verilint 241 on  // Output never gets set
endmodule
