//----------------------------------------------------------------------------
//
// Module:
//   mips_pib_stub
//
// Description:
//   Stub-Module for MIPS Probe Interface Block
//
//
// $Id: \$
// mips_repository_id: mips_pib_stub.v, v 3.1 
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

//----------------------------------------------------------------------------

`include "mips_pib_cfg.vh"

                             //---------------------------//
                             //                           //
                             //     Module Definition     //
                             //                           //
                             //---------------------------//

module mips_pib_stub (
   gclk,
   gscanenable,
   greset,
   test_reset,
   
   TC_ClockRatio,
   TC_Valid,
   TC_Data,
   TC_TrEnable,
   TC_Calibrate,
   TC_ProbeTrigOut,

   TC_CRMax,
   TC_CRMin,
   TC_ProbeWidth,
   TC_DataBits,
   TC_Stall,
   TC_PibPresent,		      
   TC_ProbeTrigIn,
   
   TR_TRIGIN,
   TR_PROBE_N,

   TR_CLK,
   TR_DATA,
   TR_TRIGOUT,

   EJ_DebugM,
   TR_DM

);

parameter TRDATAWIDTH = `MIPS_PIB_TRDATAWIDTH;

input    gclk;                 // System clock
input    gscanenable;          // global scan enable
input    greset;               // global reset
input    test_reset;           // Simulation reset signal.   Hardware should tie this low.

input    [2:0] TC_ClockRatio;  // User's clock ratio selection.
input    TC_Valid;             // Data valid indicator.  Not used in this design.
input    [63:0] TC_Data;       // Data from TCB.
input    TC_TrEnable;           // Trace Enable. PIB start TR_Clk
input    TC_Calibrate;          // Calibrate bit in ControlB set.

output   [2:0] TC_CRMax;       // Static output.  Maximum clock ratio supported.
output   [2:0] TC_CRMin;       // Static output.  Minimum clock ratio supported.
output   [1:0] TC_ProbeWidth;  // Static output.  
output   [2:0] TC_DataBits;    // Number of TC_Data bits used per clock
output   TC_Stall;             // Stall request.  Not used in this design.
output   TC_PibPresent;         // PIB is present   

input    TR_TRIGIN;            // Probe Trigger input coming from probe
output   TC_ProbeTrigIn;       // Probe Trigger input going to TCB
input    TC_ProbeTrigOut;      // Probe Trigger output coming from TCB
output   TR_TRIGOUT;           // Probe Trigger output going to probe
   
input    TR_PROBE_N;             // PIB enable signal from probe

output   TR_CLK;               // Trace clock output to probe
output   [TRDATAWIDTH-1:0] TR_DATA;   // Trace data output to probe

input		EJ_DebugM;
output		TR_DM;




  assign TC_ProbeTrigIn = 1'b0;

  assign TC_CRMax = 3'h0;
  assign TC_CRMin = 3'h0;
  assign TC_ProbeWidth = 2'h0;
  assign TC_DataBits = 3'h0;
  assign TC_Stall = 1'b0;
  assign TC_PibPresent = 1'b0;

  assign TC_ProbeTrigIn = 1'b0;
  assign TR_TRIGOUT = 1'b0;
  assign TR_CLK = 1'b0;
  assign TR_DATA = { TRDATAWIDTH {1'b0}};

  assign TR_DM = EJ_DebugM;

endmodule
