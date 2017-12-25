// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//      Description: m14k_ejt_tap_pcsam
//      EJTAG TAP PC SAMPLE module 
//
//      $Id: \$
//      mips_repository_id: m14k_ejt_tap_pcsamstub.mv, v 1.3 
//
//      mips_start_of_legal_notice
//      **********************************************************************
//      Unpublished work (c) MIPS Technologies, Inc.  All rights reserved. 
//      Unpublished rights reserved under the copyright laws of the United
//      States of America and other countries.
//      
//      MIPS TECHNOLOGIES PROPRIETARY / RESTRICTED CONFIDENTIAL - HEIGHTENED
//      STANDARD OF CARE REQUIRED AS PER CONTRACT
//      
//      This code is confidential and proprietary to MIPS Technologies, Inc.
//      ("MIPS Technologies") and may be disclosed only as permitted in
//      writing by MIPS Technologies.  Any copying, reproducing, modifying,
//      use or disclosure of this code (in whole or in part) that is not
//      expressly permitted in writing by MIPS Technologies is strictly
//      prohibited.  At a minimum, this code is protected under trade secret,
//      unfair competition and copyright laws.	Violations thereof may result
//      in criminal penalties and fines.
//      
//      MIPS Technologies reserves the right to change the code to improve
//      function, design or otherwise.	MIPS Technologies does not assume any
//      liability arising out of the application or use of this code, or of
//      any error or omission in such code.  Any warranties, whether express,
//      statutory, implied or otherwise, including but not limited to the
//      implied warranties of merchantability or fitness for a particular
//      purpose, are excluded.	Except as expressly provided in any written
//      license agreement from MIPS Technologies, the furnishing of this code
//      does not give recipient any license to any intellectual property
//      rights, including any patent rights, that cover this code.
//      
//      This code shall not be exported, reexported, transferred, or released,
//      directly or indirectly, in violation of the law of any country or
//      international law, regulation, treaty, Executive Order, statute,
//      amendments or supplements thereto.  Should a conflict arise regarding
//      the export, reexport, transfer, or release of this code, the laws of
//      the United States of America shall be the governing law.
//      
//      This code may only be disclosed to the United States government
//      ("Government"), or to Government users, with prior written consent
//      from MIPS Technologies.  This code constitutes one or more of the
//      following: commercial computer software, commercial computer software
//      documentation or other commercial items.  If the user of this code, or
//      any related documentation of any kind, including related technical
//      data or manuals, is an agency, department, or other entity of the
//      Government, the use, duplication, reproduction, release, modification,
//      disclosure, or transfer of this code, or any related documentation of
//      any kind, is restricted in accordance with Federal Acquisition
//      Regulation 12.212 for civilian agencies and Defense Federal
//      Acquisition Regulation Supplement 227.7202 for military agencies.  The
//      use of this code by the Government is further restricted in accordance
//      with the terms of the license agreement(s) and/or applicable contract
//      terms and conditions covering this code from MIPS Technologies.
//      
//      
//      
//      **********************************************************************
//      mips_end_of_legal_notice
//

//verilint 240 off  // Unused input
`include "m14k_const.vh"


module m14k_ejt_tap_pcsamstub(
	gclk,
	greset,
	gscanenable,
	cpz_guestid,
	cpz_epc_w,
	mpc_cleard_strobe,
	mpc_exc_w,
	mmu_asid,
	icc_pm_icmiss,
	edp_iva_i,
	pc_sync_period,
	pc_sync_period_diff,
	pcse,
	new_pcs_ack_tck,
	pc_im,
	pcsam_val,
	new_pcs_gclk,
	pcs_present);



// Global Signals
  input         gclk;
  input   	greset;         // reset
  input         gscanenable;         

  
// Signals from ALU 
  input [7:0]   cpz_guestid; 
  input [31:0]  cpz_epc_w;      // PC of the graduating instruction from W stage
  input		mpc_cleard_strobe; //monitoring bit for instruction completion
  input		mpc_exc_w;      //Exception in W-stage
  input [7:0]   mmu_asid;
  input         icc_pm_icmiss;  // Perf. monitor I$ miss 
  input  [31:0] edp_iva_i;      // Instn virtual address (I-stage)
  
// Ej Signals  
  input [2:0]   pc_sync_period;       // 3 bits from debug ctl register which 
                                      // specify the sync period
  input         pc_sync_period_diff;  // indicates write to pc sync period 
                                      // used to reset the pc sample counter
  input         pcse;                 // PC Sample Write Enable Bit
  input         new_pcs_ack_tck;      // tck domain accepts the new pcsam_val
  input         pc_im;                // config PC sampling to capture all excuted addresses or only those that miss the instruction cache
  // Outputs  
  output [55:0] pcsam_val; // PC Value which has been sampled
  output        new_pcs_gclk;    // gclk domain has a new pcsam_val
  output	pcs_present;

// BEGIN Wire declarations made by MVP
wire new_pcs_gclk;
wire pcs_present;
wire [55:0] /*[55:0]*/ pcsam_val;
// END Wire declarations made by MVP

 
assign pcsam_val[55:0] = 56'b0;
assign new_pcs_gclk =1'b0;
assign pcs_present =1'b0;

//verilint 240 on  // Unused input
endmodule
