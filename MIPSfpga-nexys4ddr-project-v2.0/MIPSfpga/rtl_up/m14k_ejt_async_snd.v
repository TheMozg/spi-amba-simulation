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

module m14k_ejt_async_snd(
	gscanenable,
	gclk,
	gfclk,
	reset,
	reset_unsync,
	sync_data_in,
	sync_sample,
	sync_sample_st_send,
	sync_sample_st_pend,
	sync_wakeup,
	async_data_out,
	async_data_rdy,
	async_data_ack);


   parameter WIDTH=32;
   parameter TRIPSYNC=1;       // =1 for Triple flop synchronizers (used in gclk)
                               // =0 for Double (in TCK)
   
  /*hookios*/
  
// i/f with sending logic 
   input     gscanenable;      // Scan Enable
   input     gclk;              // can be either gclk or tck
   input     gfclk;             // can be gclk, gfclk, or tck
                               // gfclk if handshake logic needs to wakeup core
                               // gclk/tck if it does not

   input     reset;            // reset
   input     reset_unsync;     // Asynchronous reset - gate off outputs
                               //   to clear i/f even if clock is stopped
                               //   Only used for TCK
   

   input [WIDTH-1:0] sync_data_in;  // synchronous data value to be sampled
   input 	     sync_sample;   // synchronous enable to sample data

   output 	     sync_sample_st_send;   // Sending logic in SEND state - no new sample will be taken
   output            sync_sample_st_pend;   // Sending logic in PEND state - outside logic can
                                             //    enable a sample if overwriting data is ok on this
                                             //    i/f.
                                             // If neither, in IDLE or ACK where new data can always be
                                             //    sampled.

   output 	     sync_wakeup;   // i/f available - wakeup to send
   
// i/f with receiving logic 
   output [WIDTH-1:0]  async_data_out;  // Sent data
   output 	       async_data_rdy;  // data_out is valid 
   input 	       async_data_ack;  // data has been accepted

// BEGIN Wire declarations made by MVP
wire data_ack_sync0;
wire data_ack_synced;
wire sync_sample_st_pend;
wire data_ack_sync1;
wire sync_sample_en;
wire sync_wakeup;
wire sync_sample_st_send;
wire [3:0] /*[3:0]*/ sync_sample_st;
wire data_ack_sync2;
// END Wire declarations made by MVP

 	       
   // MVP does not like parameters here
   //
   parameter IDLE = 0,
	     SEND = 1,
	     ACK  = 2,
	     PEND = 3;
   //verilint 175 off	Unused parameter
   parameter // /* VCS enum sample_st_FSM */
	     CM_IDLE = 1,
             CM_SEND = 2,  
             CM_ACK  = 4,
             CM_PEND = 8;
   //verilint 175 on
   //
   
   // This module should be paired with m14k_ejt_async_rec to form the
   // two sides of an asynchronous data transfer
   
   //
   // Handshake protocol for async transfer:
   //   A) steady state is when async_data_rdy and async_data_ack are both deasserted.
   //   B) When sending domain wants to send a new sample, it drives async_data_out and asserts
   //      async_data_rdy in the same cycle
   //   C) The receiving domain synchronizes(2x or 3x) async_data_rdy and knows that a new value 
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
   //
   // Note: 3rd rule is violated at reset (which can lead to violation of 4th rule)

   // Wakeup logic: synchronize ACK with free-running clock.  
   // Ask for a wakeup if: (data_rdy, data_ack)
   //      data on i/f has been accepted (1,1) to complete handshake
   //      or i/f is idle (0,0) and there is more data pending
   // Allow shutdown when:
   //      waiting for Ack (1,0)
   //      waiting for handshake completion (0,1)
   // Not used in TCK modules - connect tck to both gfclk and gclk

   // Double or triple flop synchronizers
   mvp_register #(1) _data_ack_sync0(data_ack_sync0, gfclk, async_data_ack);
   mvp_register #(1) _data_ack_sync1(data_ack_sync1, gfclk, data_ack_sync0);
   mvp_register #(1) _data_ack_sync2(data_ack_sync2, gfclk, TRIPSYNC ? data_ack_sync1 : 1'b0);

   assign data_ack_synced = TRIPSYNC ? data_ack_sync2 : data_ack_sync1;
   
   // Wakeup term:
   assign sync_wakeup = (sync_sample_st[SEND] & data_ack_synced) |    // Wakeup to complete handshake after x-fer
		 (~sync_sample_st[SEND] & ~data_ack_synced &   // Wakeup if i/f idle 
		  (sync_sample | sync_sample_st[PEND]));    // and data pending
   
   
   // To maintain protocol, only allow sampling of new data when not in SEND state
   //    External logic can choose which other states to enable it in
   assign sync_sample_en = sync_sample & ~sync_sample_st[SEND];
   

   // register the data value
   wire [WIDTH-1:0] async_data_out;
   
   mvp_cregister_wide #(WIDTH) async_data_out_(async_data_out,gscanenable, 
						      sync_sample_en, gclk,
						      sync_data_in);

   // Decode state for external logic
   //    SEND state: indicates new data will not be sampled
   //    PEND state: Used to disable sync_sample if data in send buffer 
   //            should not be overwritten  
   assign sync_sample_st_pend = sync_sample_st[PEND];
   assign sync_sample_st_send = sync_sample_st[SEND];

   // data ready indication to receive logic
   wire 	    async_data_rdy;
   
   m14k_ejt_and2 async_data_rdy_(.y(async_data_rdy), 
				      .a(sync_sample_st[SEND]), 
				      .b(~reset_unsync));

   // States - 
   //
   // State descriptions
   // 
   // IDLE -- there is no sample to send
   // SEND - Sending a new sample (not allowed to change the sample)
   // ACK - Receiver has acknowledged receipt of new sample
   // PEND - There is a new sample, but cannot send it yet - waiting on deassertion of ack
   //
   function [3:0] sample_nst;
      input [3:0] sample_st;
      input sample_en;
      input data_ack_synced;
      begin
	 sample_nst = 4'b0000; // First reset next state.
         // The below directives are necessary because Verilint doesnt like 
         // this state machine coding style
	 //verilint 226 off    Case-select expression is constant
	 //verilint 225 off    Case expression is not constant
	 //verilint 526 off    Nested ifs
	 case (1'b1)  // synopsys parallel_case
                      // ambit synthesis case = parallel

	   // CMX sample_st TRANSITIONS_NEVER CM_IDLE->CM_ACK
	   // CMX sample_st TRANSITIONS_NEVER CM_IDLE->CM_PEND
	   sample_st[IDLE] : begin
	      if(sample_en)
		// If we get a sample, send it
		sample_nst[SEND] = 1'b1;
	      else
		sample_nst[IDLE] = 1'b1;
	   end

	   // CMX sample_st TRANSITIONS_NEVER CM_SEND->CM_IDLE
	   // CMX sample_st TRANSITIONS_NEVER CM_SEND->CM_PEND
	   sample_st[SEND] : begin
	      if(data_ack_synced)
		// When we get the ack, remember it
		sample_nst[ACK] = 1'b1;
	      else
		sample_nst[SEND] = 1'b1;
	   end
 
	   sample_st[ACK] : begin
	      if(sample_en && data_ack_synced)
		// If we get a new sample, but havent completed the handshake for the last one yet, 
		// remember that there is a new sample
		sample_nst[PEND] = 1'b1;
	      else if(sample_en && !data_ack_synced)
		// If the ack goes away and we get a new sample in the same cycle, send it (skip the IDLE state)
		sample_nst[SEND] = 1'b1;
	      else if(!data_ack_synced)
		// When ack is deasserted, the protocol is complete
		sample_nst[IDLE] = 1'b1;
	      else
		sample_nst[ACK] = 1'b1;
	   end
      
	   // CMX sample_st TRANSITIONS_NEVER CM_PEND->CM_IDLE
	   // CMX sample_st TRANSITIONS_NEVER CM_PEND->CM_ACK
	   sample_st[PEND] : begin
	      if(!data_ack_synced)
		// When ack is finally deasserted, send the new sample
		sample_nst[SEND] = 1'b1;
	      else
		sample_nst[PEND] = 1'b1;
	   end

           default : sample_nst = 4'bxxxx;
         endcase
         //verilint 226 on
	 //verilint 225 on
	 //verilint 526 on
      end
   endfunction
   //

   mvp_register #(4) _sync_sample_st_3_0_(sync_sample_st[3:0], gclk, reset ? 1'b1 << IDLE : 
			     sample_nst(sync_sample_st,
					sync_sample_en,
					data_ack_synced));
   
endmodule
