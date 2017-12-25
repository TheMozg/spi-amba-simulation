// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE

// Description:    m14k_clock_nogate
//       This is a replacement module for the normal toplevel clock
//       clock-gating module. Use this module for FPGA implementations.
//
//  $Id: \$
//  mips_repository_id: m14k_clock_nogate.mv, v 1.6 
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
// This is a stub module so most of the inputs are unused
//verilint 240 off  // Unused input
//verilint 528 off        // Variable set but not used

`include "m14k_const.vh"
module m14k_clock_nogate(
	gclk,
	gfclk,
	cpz_goodnight,
	SI_ClkIn,
	gscanmode,
	grfclk,
	r_gtlbclk,
	mpc_rfwrite_w,
	r_jtlb_wr,
	greset,
	jtlb_wr,
	gtlbclk);


   output 	 gclk;
   output 	 gfclk;		// Free running core clock - cannot be gated off
   input 	 cpz_goodnight;	// When Asserted, gate off the clock
   input 	 SI_ClkIn;	// Core input Clock
   input 	 gscanmode;	// When asserted, ignore cpz_goodnight and keep clock running

   output        grfclk;        // gated clock to GPRs
   output        r_gtlbclk;        // gated clock to GPRs
   input         mpc_rfwrite_w; // register write enable
   input         r_jtlb_wr;       // Write entrylo1 into the JTLB
   input	 greset;		// reset/coldreset signal
   input         jtlb_wr;       // Write entrylo1 into the JTLB
   output        gtlbclk;        // gated clock to GPRs

// BEGIN Wire declarations made by MVP
wire tracer_cg_on;
// END Wire declarations made by MVP

      
//   
   // gfclk is a buffered version of SysClk
   `M14K_CLK_BUF_CLOCK_GATE buff_fclk (	.y	(gfclk),
					.a	(SI_ClkIn)
				      );

   // gclk is also a buffered version of SysClk when no gated clocks
   `M14K_CLK_BUF_CLOCK_GATE buff_gclk (	.y	(gclk),
					.a	(SI_ClkIn)
				      );

   `M14K_CLK_BUF_CLOCK_GATE buff_gtlbclk (	.y	(gtlbclk),
					.a	(SI_ClkIn)
				      );
   `M14K_CLK_BUF_CLOCK_GATE r_buff_gtlbclk (	.y	(r_gtlbclk),
					.a	(SI_ClkIn)
				      );

    `M14K_CLK_BUF_CLOCK_GATE buff_grfclk (	.y	(grfclk),
					.a	(SI_ClkIn)
				      );

//

//verilint 599 off
//verilint 239 off
	
	assign tracer_cg_on = 1'b0;

//verilint 599 on
//verilint 239 on
//verilint 528 on        // Variable set but not used



//verilint 240 on  // Unused input

endmodule
