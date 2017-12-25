// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//      Description: m14k_siu_int_sync 
//           Double flop synchronizers for Interrupt pins
//      
//      $Id: \$
//      mips_repository_id: m14k_siu_int_sync.mv, v 1.10 
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

`include "m14k_const.vh"
module m14k_siu_int_sync(
	gfclk,
	SI_Int,
	SI_EISS,
	SI_EICVector,
	SI_Offset,
	SI_GInt,
	SI_GEICVector,
	SI_GOffset,
	SI_GEISS,
	SI_EICGID,
	siu_int,
	siu_eiss,
	siu_eicvector,
	siu_offset,
	siu_g_int,
	siu_g_eicvector,
	siu_g_offset,
	siu_eicgid,
	siu_g_eiss);


//verilint 423 off        // A port with a range is re-declared with a different range

   input gfclk;			// Free running clock
   input [7:0] SI_Int;          // Ext. Interrupt pins

   input [3:0] SI_EISS;		// Shadow set, comes with the requested interrupt
   input [5:0] SI_EICVector;	// Vector number for EIC interrupt request

   input [17:1] SI_Offset;	// Vector offset for EIC interrupt request
	
   input [7:0] SI_GInt;          // Ext. Interrupt pins
   input [5:0]	SI_GEICVector;	// Vector number for EIC interrupt
   input [17:1] SI_GOffset;	// Vector offset for EIC interrupt
   input [3:0]	SI_GEISS;	// Shadow set, comes with the requested interrupt
   input [7:0] SI_EICGID; 
   
   output [7:0] siu_int;        // registered interrupt pins

   output [3:0]	siu_eiss;	// Shadow set, comes with the requested interrupt
   output [5:0] siu_eicvector;	// Vector number for EIC interrupt request

   output [17:1] siu_offset;	// Vector offset for EIC interrupt request

   output [7:0] siu_g_int;            // registered interrupt pins

   output [5:0] siu_g_eicvector;      // registered vector pins

   output [17:1] siu_g_offset;		// registered offset pins

   output [2:0] siu_eicgid;

   output [3:0]	siu_g_eiss;	// Shadow set, comes with the requested interrupt

// BEGIN Wire declarations made by MVP
wire [5:0] /*[5:0]*/ siu_g_eicvector;
wire [3:0] /*[3:0]*/ siu_g_eiss;
wire [7:0] /*[7:0]*/ siu_eicgid_pre;
wire [5:0] /*[5:0]*/ siu_g_eicvector_pre;
wire [7:0] /*[7:0]*/ siu_g_int;
wire [17:1] /*[17:1]*/ siu_g_offset;
wire [7:0] /*[7:0]*/ siu_int_pre;
wire [17:1] /*[17:1]*/ siu_g_offset_pre;
wire [3:0] /*[3:0]*/ siu_eiss;
wire [17:1] /*[17:1]*/ siu_offset;
wire [17:1] /*[17:1]*/ siu_offset_pre;
wire [7:0] /*[7:0]*/ siu_int;
wire [`M14K_GID] /*[2:0]*/ siu_eicgid;
wire [7:0] /*[7:0]*/ siu_g_int_pre;
wire [5:0] /*[5:0]*/ siu_eicvector;
wire [3:0] /*[3:0]*/ siu_g_eiss_pre;
wire [5:0] /*[5:0]*/ siu_eicvector_pre;
wire [3:0] /*[3:0]*/ siu_eiss_pre;
// END Wire declarations made by MVP


   mvp_register #(8) _siu_int_pre_7_0_(siu_int_pre[7:0], gfclk, SI_Int);
   mvp_register #(8) _siu_int_7_0_(siu_int[7:0], gfclk, siu_int_pre);

   mvp_register #(4) _siu_eiss_pre_3_0_(siu_eiss_pre[3:0], gfclk, SI_EISS);
   mvp_register #(4) _siu_eiss_3_0_(siu_eiss[3:0], gfclk, siu_eiss_pre);        

   mvp_register #(6) _siu_eicvector_pre_5_0_(siu_eicvector_pre[5:0], gfclk, SI_EICVector);
   mvp_register #(6) _siu_eicvector_5_0_(siu_eicvector[5:0], gfclk, siu_eicvector_pre);

   mvp_register #(17) _siu_offset_pre_17_1_(siu_offset_pre[17:1], gfclk, SI_Offset);
   mvp_register #(17) _siu_offset_17_1_(siu_offset[17:1], gfclk, siu_offset_pre);

   mvp_register #(8) _siu_g_int_pre_7_0_(siu_g_int_pre[7:0], gfclk, SI_GInt);
   mvp_register #(8) _siu_g_int_7_0_(siu_g_int[7:0], gfclk, siu_g_int_pre);

   mvp_register #(4) _siu_g_eiss_pre_3_0_(siu_g_eiss_pre[3:0], gfclk, SI_GEISS);
   mvp_register #(4) _siu_g_eiss_3_0_(siu_g_eiss[3:0], gfclk, siu_g_eiss_pre);        

   mvp_register #(6) _siu_g_eicvector_pre_5_0_(siu_g_eicvector_pre[5:0], gfclk, SI_GEICVector);
   mvp_register #(6) _siu_g_eicvector_5_0_(siu_g_eicvector[5:0], gfclk, siu_g_eicvector_pre);

   mvp_register #(17) _siu_g_offset_pre_17_1_(siu_g_offset_pre[17:1], gfclk, SI_GOffset);
   mvp_register #(17) _siu_g_offset_17_1_(siu_g_offset[17:1], gfclk, siu_g_offset_pre);

   mvp_register #(8) _siu_eicgid_pre_7_0_(siu_eicgid_pre[7:0], gfclk, SI_EICGID);
   mvp_register #(3) _siu_eicgid_2_0_(siu_eicgid[`M14K_GID], gfclk, siu_eicgid_pre[`M14K_GID]);

//verilint 423 on        // A port with a range is re-declared with a different range

endmodule       // m14k_siu_int_sync

