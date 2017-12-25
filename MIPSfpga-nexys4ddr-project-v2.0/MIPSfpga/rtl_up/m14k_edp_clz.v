// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE

//
//  Description:    m14k_edp_clz
//        Counts leading zeros for a 32bit input
//
// $Id: \$
// mips_repository_id: m14k_edp_clz.mv, v 1.1 
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
  module m14k_edp_clz(
	count,
	edp_alu_m,
	cl_vl);
 /*AUTOARG()*/

   output [31:0] count;
   
   input [31:0]  edp_alu_m;

   input 	 cl_vl;

// BEGIN Wire declarations made by MVP
// END Wire declarations made by MVP


   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   // Beginning of automatic wires (for undeclared assign signals)
   wire [31:0]		count;
   wire [5:0]		smallcount;
   // End of automatics
   
   wire [3:0] 	 lscount;
   wire [3:0] 	 mscount;
   wire 	 lszeron;
   wire 	 mszeron;

   // Instantiate 4bit cl0's with lscount unknown - ignore lower 2 bits of their count.
   // For synthesis, this module should be flattened, but not restructured.
   m14k_edp_clz_16b lscounti(
		      // Outputs
		      .count		(lscount[3:0]),
		      .allzeron		(lszeron),
		      // Inputs
		      .a		(edp_alu_m[15:0]));
   
   m14k_edp_clz_16b mscounti(
		      // Outputs
		      .count		(mscount[3:0]),
		      .allzeron		(mszeron),
		      // Inputs
		      .a		(edp_alu_m[31:16]));
   
   assign 	 smallcount[5:0] = (mszeron ? {2'b00,mscount[3:0]} 
				    : (lszeron ? {2'b01,lscount[3:0]}
				       : (cl_vl ? {6'h12}
					  : 6'b100000))
				            )
		                            ;
   
   assign 	 count[31:0] = {26'b0,smallcount};
   
endmodule
