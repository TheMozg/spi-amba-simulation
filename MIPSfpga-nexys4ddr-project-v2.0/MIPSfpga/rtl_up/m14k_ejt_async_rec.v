// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
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

module m14k_ejt_async_rec(
	gscanenable,
	gclk,
	gfclk,
	reset,
	reset_unsync,
	sync_data_enable,
	sync_data_out,
	sync_data_vld,
	sync_data_pnd,
	sync_wakeup,
	async_data_in,
	async_data_rdy,
	async_data_ack);


   parameter WIDTH=32;
   parameter TRIPSYNC=1;       // =1 for Triple flop synchronizers (used in gclk)
                               // =0 for Double (in TCK)
   
  /*hookios*/
  
// i/f with receiving logic -----------------------------------------------
   input     gscanenable;      // Scan Enable

   input     gclk;              // module used for both gclk and tck 
   input     gfclk;             // Free-running clock - gfclk or tck


   input     reset;            // Synchronous reset
   input     reset_unsync;     // Asynchronous reset - gate off outputs
                               //   to clear i/f even if clock is stopped
                               //   Only used for TCK

   input 	      sync_data_enable; // Enable update of capture register

   output [WIDTH-1:0] sync_data_out; // synchronized data value
   output 	      sync_data_vld; // captured data is ready to be read
   output 	      sync_data_pnd; // additional data is pending on i/f
   
   output 	      sync_wakeup;   // Start clocks to receive data
   


   // i/f with sending logic -----------------------------------------------
   input [WIDTH-1:0]   async_data_in;   // Sent data
   input 	       async_data_rdy;  // data_in is valid 
   output 	       async_data_ack;  // data has been accepted

// BEGIN Wire declarations made by MVP
wire data_rdy_synced;
wire data_rdy_sync2;
wire sync_sample_en_reset;
wire sync_data_vld;
wire data_rdy_sync1;
wire sync_sample_en;
wire data_ack;
wire sync_wakeup;
wire data_rdy_sync0;
wire sync_data_pnd;
// END Wire declarations made by MVP

   
   // This module should be paired with tpz_biu_async_snd to form the
   // two sides of an asynchronous data transfer
   
   //--------------------------
   // Handshake protocol for async transfer:
   //   A) steady state is when async_data_rdy and async_data_ack are both deasserted.
   //   B) When sending domain wants to send a new sample, it drives async_data_out and asserts
   //      async_data_rdy in the same cycle
   //   C) The receiving domain synchronizes (2x or 3x) async_data_rdy and knows that a new value 
   //      can be latched
   //   D) When receiving domain accepts the data, it asserts async_data_ack
   //   E) The sending domain synchronizes (3x or 2x) async_data_ack and deasserts async_data_rdy
   //   F) The receiving domain deasserts async_data_ack after it recognizes the deassertion of 
   //      async_data_rdy
   // Thus, the rules are:
   //   sending domain cannot change async_data_out when async_data_rdy is asserted.
   //   sending domain can only assert async_data_rdy when async_data_ack is deasserted.
   //   sending domain can only deassert async_data_rdy when async_data_ack is asserted.
   //   receiving domain can only assert async_data_ack when async_data_rdy is asserted.
   //   receiving domain can only deassert async_data_ack when async_data_rdy is deasserted.

   // Wakeup terms: synchronize data ready strobe with a free-running clock
   // Ask for a wakeup if: (data_rdy, data_ack)
   //       data is ready and has not been accepted. (1,0) and space is available
   //       Or to complete the handshake and allow more data in (0,1)
   // Allow shutdown when:
   //       idle (0,0)  
   //       or when waiting for handshake completion (1,1)
   //       (allows shutdown even if TCK stops at this point)
   // Not used in TCK modules - connect tck to both gfclk and gclk

   
   // Double or triple flop synchronizers
   mvp_register #(1) _data_rdy_sync0(data_rdy_sync0, gfclk, async_data_rdy);
   mvp_register #(1) _data_rdy_sync1(data_rdy_sync1, gfclk, data_rdy_sync0);
   mvp_register #(1) _data_rdy_sync2(data_rdy_sync2, gfclk, TRIPSYNC ? data_rdy_sync1 : 1'b0);

   assign data_rdy_synced = TRIPSYNC ? data_rdy_sync2 : data_rdy_sync1;

   // wakeup logic
   assign sync_wakeup = (~data_rdy_synced & data_ack) |    // Complete handshake to allow next x-fer
		 (data_rdy_synced & ~data_ack & ~sync_data_vld);  // Or to advance data

   
   // Sample the incoming data if: 
   assign sync_sample_en = ~reset &             // Not in reset and
		    data_rdy_synced &    // data is available and
		     ~data_ack &         // we have not already sampled it and
		     (~sync_data_vld |   // Sample register is free or 
		      sync_data_enable);    // can be overwritten
   
   // sampled data value
   wire [WIDTH-1:0] sync_data_out;

   wire [WIDTH-1:0] async_data_reset;  
   assign sync_sample_en_reset = sync_sample_en | reset;
   assign async_data_reset = {WIDTH{~reset}} & async_data_in;
 
   mvp_cregister_wide #(WIDTH) sync_data_out_(sync_data_out,
					       gscanenable, sync_sample_en_reset,
					       gclk, async_data_reset);

   // Mark data valid when sampled, clear when enable has been seen
   mvp_register #(1) _sync_data_vld(sync_data_vld, gclk, sync_sample_en | (sync_data_vld & ~sync_data_enable));

   // Indication that there is another piece of data waiting on async bus
   mvp_register #(1) _sync_data_pnd(sync_data_pnd, gclk, data_rdy_synced &     // data available and
			         ~data_ack &     // we haven't taken it and 
			         ~sync_sample_en);     // we aren't taking it now
 
   // Acknowledge once the data has been sampled and hold until data_rdy goes away
   mvp_register #(1) _data_ack(data_ack, gclk, ~reset & (sync_sample_en | (data_ack & data_rdy_synced)));

   wire 	    async_data_ack;
   
   m14k_ejt_and2 async_data_ack_(.y(async_data_ack), 
				      .a(data_ack), 
				      .b(~reset_unsync));
   
endmodule
