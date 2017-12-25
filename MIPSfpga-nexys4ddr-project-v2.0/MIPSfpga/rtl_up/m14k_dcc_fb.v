// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
// 	Description: m14k_dcc_fb
//            Data Cache Controller Fill Buffer Module
//
//	$Id: \$
//	mips_repository_id: m14k_dcc_fb.mv, v 1.7 
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
module m14k_dcc_fb(
	gclk,
	biu_datain,
	biu_ddataval,
	biu_datawd,
	biu_lastwd,
	biu_dbe,
	biu_dbe_pre,
	gscanenable,
	req_out,
	req_out_reg,
	mmu_dpah,
	dcc_dval_m,
	cachewrite_m,
	greset,
	dcop_access_m,
	dcop_fandl,
	dcached,
	repl_way,
	held_dtmack,
	index_mask,
	dstore_m,
	dcc_dmiss_m,
	no_way,
	dcc_exbe,
	storebuff_data,
	sb_to_fb_stb,
	store_hit_fb,
	wb_reg,
	wt_nwa,
	raw_ldfb,
	fill_data,
	fb_taglo,
	hit_fb,
	fill_done,
	repl_wway,
	fb_repl_inf,
	fill_addr_lo,
	fill_tag,
	fill_data_ready,
	block_hit_fb,
	fb_repl_inf_mx,
	idx_match_fb,
	fb_data,
	fb_full,
	fb_trans_btof_reg,
	fb_trans_btof_active_entry,
	ld_tag_reg,
	fb_fill_way,
	fb_update_tag,
	fb_active_entry,
	fb_trans_btof,
	fb_dirty,
	fb_dirty_b,
	fb_replinf_init_b,
	idx_match_fb_b,
	bus_err_line,
	last_word_fill,
	dcc_pm_fb_active,
	dcc_uncache_load);


   /* Inputs */
   input           gclk;	       
   input [31:0]    biu_datain;      // External Data In
   input 	   biu_ddataval;    // biu_datain contains valid Instn
   input [1:0] 	   biu_datawd;      // Which word is being returned
   input 	   biu_lastwd;      // Last word of this request
   input 	   biu_dbe;         // Data bus error
   input 	   biu_dbe_pre;     // Previous Data bus error
   input 	   gscanenable;
   input 	   req_out;         // There is an outstanding Data Request (BIU)
   input 	   req_out_reg;     // req_out cycle later basically...
   input [`M14K_PAH] mmu_dpah;       // Data PA High
   input [19:2]    dcc_dval_m;      // Lower bits of PA for ICOp
   input 	   cachewrite_m;  
   input 	   greset;
   input 	   dcop_access_m;
   input 	   dcop_fandl;      // CacheOp - Fetch & Lock
   input 	   dcached;         // Cached
   input [3:0] 	   repl_way;        // Real replacement way
   input 	   held_dtmack;     // TLB Miss
   input [13:10]   index_mask;
   input 	   dstore_m;        // Store
   input 	   dcc_dmiss_m;     // Instn ref. missed
   input 	   no_way;          // All legal ways locked & valid. Can't write to index.

   input [3:0] 	   dcc_exbe;        // Byte enables  
   input [31:0]    storebuff_data;  // Store buffer data  
   input 	   sb_to_fb_stb;    // Store buffer to Fill buffer strobe
   input 	   store_hit_fb;    // a WB store hit in the FB
   input 	   wb_reg;          // Write Back
   input 	   wt_nwa;          // WT-NWA
   
   /* Outputs */
   output [3:0]    raw_ldfb;        // which word is being returned..and is it valid
   output [31:0]   fill_data;       // Data to be written into the cache
   output [3:0]    fb_taglo;        // Data Fill Buffer tag
   output 	   hit_fb;          // Detected hit in FB
   output 	   fill_done;       // FB filled into cache
   output [3:0]    repl_wway;       // Way to be replaced
   output [12:0]   fb_repl_inf;     // Replacement info for FB
   output [19:2]   fill_addr_lo; 
   output [23:0]   fill_tag;        // Tag to be written on fill
   output 	   fill_data_ready; // There are words in the FB that need to be 
                                    //     written to the cache
   output 	   block_hit_fb;    // Line hit
   output [12:0]   fb_repl_inf_mx;  // Front fill buffer replacement info
   output 	   idx_match_fb;    // Front fill buffer index match
   output [31:0]   fb_data;         // Bypass data
   output 	   fb_full;         // Both entries in the FB are in use
   output 	   fb_trans_btof_reg;
   output	   fb_trans_btof_active_entry;
   output 	   ld_tag_reg;
   output [3:0]    fb_fill_way;
   output 	   fb_update_tag;   // Update of first or last word in line, so write tag array
   output 	   fb_active_entry; // Front FB =0 : Back = 1 
   output 	   fb_trans_btof;   // Transfer Back FB to Front
   output 	   fb_dirty;        // Front fill buffer is dirty
   output 	   fb_dirty_b;      // Back fill buffer is dirty
   output [12:0]   fb_replinf_init_b;
   output 	   idx_match_fb_b;  // Index match in back buffer
   output 	   bus_err_line;    // Bus error
   output 	   last_word_fill;  // Last word being filled
   
   output	   dcc_pm_fb_active;
   output          dcc_uncache_load;

// BEGIN Wire declarations made by MVP
wire [19:4] /*[19:4]*/ fb_index;
wire first_word_fill;
wire [3:0] /*[3:0]*/ store_active_word;
wire last_word_fill;
wire fb_dirty_reg;
wire fb_trans_btof_reg;
wire [3:0] /*[3:0]*/ raw_fill_dword_reg;
wire three_word_fill;
wire idx_13_10_match_f;
wire back_active;
wire [31:0] /*[31:0]*/ fb_data_back0;
wire [12:0] /*[12:0]*/ dmiss_replinf_sel;
wire fb_dirty;
wire [12:0] /*[12:0]*/ replinf_fill_done;
wire front_active;
wire [31:0] /*[31:0]*/ trans_fb_data0;
wire [12:0] /*[12:0]*/ dmiss_replinfo;
wire idx_match_fb_low;
wire [31:0] /*[31:0]*/ trans_fb_data3;
wire [12:0] /*[12:0]*/ dmiss_replinf;
wire dcc_uncache_load;
wire ld_mtag;
wire [12:0] /*[12:0]*/ raw_fb_replinf;
wire read_sent;
wire fb_active_entry_reg;
wire biu_dbe_reg;
wire [15:0] /*[15:0]*/ back_dirty_bits;
wire [`M14K_PAH] /*[31:10]*/ dmiss_tag;
wire [19:4] /*[19:4]*/ fb_index_back;
wire idx_match_fb_b;
wire [31:0] /*[31:0]*/ fb_data1;
wire [31:0] /*[31:0]*/ fb_data3;
wire back_idx_match_fb_high;
wire [3:0] /*[3:0]*/ ex_be_reg;
wire front_data_nofill;
wire [3:0] /*[3:0]*/ fb_fill_way;
wire [3:0] /*[3:0]*/ raw_fb_tag_l;
wire [15:0] /*[15:0]*/ front_dirty_bits;
wire fb_dirty_b_reg;
wire fill_done;
wire check_hit;
wire fill_data_ready;
wire [`M14K_PAH] /*[31:10]*/ fb_tag_back_h;
wire [3:0] /*[3:0]*/ raw_fb_valid;
wire [3:2] /*[3:2]*/ dval_m_reg;
wire dcc_pm_fb_active;
wire get_dirty_bits;
wire [12:0] /*[12:0]*/ fb_replinf_init_b;
wire [31:0] /*[31:0]*/ fb_data_back3;
wire ld_tag;
wire back_data_nofill;
wire fb_replinf0_reg;
wire idx_9_4_match_n;
wire [31:4] /*[31:4]*/ fb_tag;
wire [12:0] /*[12:0]*/ fb_repl_inf_mx;
wire [`M14K_PAH] /*[31:10]*/ trans_fb_tag_h;
wire [3:0] /*[3:0]*/ valid_word_here_reg;
wire idx_9_4_match_f;
wire data_nofill;
wire [3:0] /*[3:0]*/ valid_bits;
wire [3:0] /*[3:0]*/ fb_raw_ld;
wire [3:0] /*[3:0]*/ fb_tag_l_mx;
wire [31:0] /*[31:0]*/ trans_fb_data2;
wire [3:0] /*[3:0]*/ raw_fb_tag_l_back_mx;
wire [12:0] /*[12:0]*/ trans_raw_fb_replinf;
wire [3:0] /*[3:0]*/ raw_ldfb;
wire fb_active_entry;
wire [23:0] /*[23:0]*/ fill_tag;
wire [12:0] /*[12:0]*/ raw_fb_replinf_back;
wire [`M14K_PAH] /*[31:10]*/ dmiss_tag_sel;
wire [31:0] /*[31:0]*/ fb_data_back1;
wire rd_req_sent;
wire flush_fb;
wire [3:0] /*[3:0]*/ fill_data_rdy;
wire bus_err_line_trans;
wire front_empty;
wire [3:0] /*[3:0]*/ valid_word_here;
wire update_fb;
wire fb_update_tag;
wire [15:0] /*[15:0]*/ sb_to_fb_dirty_reg;
wire [19:2] /*[19:2]*/ dval_m_sel;
wire rd_req_sent_reg;
wire [3:0] /*[3:0]*/ b_active;
wire ld_mtag_reg;
wire fb_full;
wire bus_err_line_b;
wire [31:0] /*[31:0]*/ fb_data0;
wire [19:4] /*[19:4]*/ dmiss_index;
wire block_hit_fb;
wire load_data_nofill;
wire [31:0] /*[31:0]*/ fill_data;
wire [31:0] /*[31:0]*/ fb_data2;
wire last_word_received;
wire ld_tag_reg;
wire [3:0] /*[3:0]*/ fb_taglo;
wire [`M14K_PAH] /*[31:10]*/ fb_tag_h_mx;
wire fb_trans_btof_active_entry;
wire idx_9_4_match_b;
wire [3:0] /*[3:0]*/ raw_fb_tag_l_back;
wire [3:0] /*[3:0]*/ raw_active;
wire [31:0] /*[31:0]*/ trans_fb_data1;
wire [15:0] /*[15:0]*/ back_dirty_bits_reg;
wire [3:0] /*[3:0]*/ trans_fb_tag_l;
wire [19:4] /*[19:4]*/ trans_fb_index;
wire fb_trans_btof;
wire back_idx_match_fb_low;
wire idx_13_10_match_b;
wire [3:0] /*[3:0]*/ ldfb;
wire [12:0] /*[12:0]*/ fb_replinf_reset;
wire [12:0] /*[12:0]*/ fb_repl_inf;
wire [31:0] /*[31:0]*/ fb_data_next3;
wire [31:0] /*[31:0]*/ fb_data_next2;
wire [31:0] /*[31:0]*/ fb_data_next1;
wire dpah_match;
wire [31:0] /*[31:0]*/ fb_data_next0;
wire [3:0] /*[3:0]*/ repl_wway;
wire [15:0] /*[15:0]*/ front_dirty_bits_reg;
wire bus_err_line;
wire [15:0] /*[15:0]*/ sb_to_fb_dirty;
wire update_fb_back;
wire [31:0] /*[31:0]*/ fb_data;
wire idx_match_fb_high;
wire valid_word_here_c;
wire fb_dirty_b;
wire [31:0] /*[31:0]*/ fb_data_back2;
wire sb_to_fb_stb_reg;
wire idx_13_10_match_n;
wire [3:0] /*[3:0]*/ raw_fill_dword;
wire check_hit_low;
wire [3:0] /*[3:0]*/ f_active;
wire fb_tag_back_h_cond;
wire idx_match_fb;
wire [31:0] /*[31:0]*/ new_data;
wire [3:0] /*[3:0]*/ active_word;
wire [3:0] /*[3:0]*/ fill_dword_reg;
wire [`M14K_PAH] /*[31:10]*/ fb_tag_h;
wire [19:2] /*[19:2]*/ fill_addr_lo;
wire poss_hit_fb;
wire hit_fb;
// END Wire declarations made by MVP


   /* End of I/O */

   //
   function [3:0] decode2_4; input [1:0] i;
     decode2_4 = { i[1] &  i[0],
                   i[1] & ~i[0],
                  ~i[1] &  i[0],
                  ~i[1] & ~i[0]};
   endfunction
   //
   
   //****************
   // Validity of incoming data (which word valid, bus error)
   //****************
   // Since incoming data is registered at pads, should be available early in cycle so we can 
   // use the data before it is loaded into the local register
   assign raw_ldfb [3:0] = decode2_4( biu_datawd[1:0]) & {4{biu_ddataval}};

   assign ldfb[3:0] = raw_ldfb[3:0] & {4{~biu_dbe}};    // check on bus error
   //biu_dbe_reg: once bus error occur, the instruction is finished with invalid data back. 
   //data invalid in FB; if following instruction is last seq, biu_dbe_reg replace the last ddataval in procedure
   assign biu_dbe_reg = biu_dbe_pre;

   // bus errors : track for data coming into front or back fill buffers
   mvp_cregister #(1) _bus_err_line(bus_err_line,(biu_dbe && !fb_active_entry) || fill_done || fb_trans_btof || greset, gclk, 
			    bus_err_line_trans);
   assign bus_err_line_trans = fb_trans_btof ? bus_err_line_b : (biu_dbe && !fill_done);
   mvp_cregister #(1) _bus_err_line_b(bus_err_line_b,(biu_dbe && fb_active_entry) || fb_trans_btof || greset, gclk, 
			      biu_dbe && !fb_trans_btof);

   // only update cache on first and last word of fill
   assign fb_update_tag = first_word_fill || last_word_fill; 

   assign last_word_fill = fb_repl_inf[`M14K_FBR_LAST] && three_word_fill ;  
   // at least 3 words have been filled
   assign three_word_fill = (fb_repl_inf[4] && fb_repl_inf[3] && fb_repl_inf[2]) ||
		     (fb_repl_inf[3] && fb_repl_inf[2] && fb_repl_inf[1]) ||
		     (fb_repl_inf[4] && fb_repl_inf[3] && fb_repl_inf[1]) ||
		     (fb_repl_inf[4] && fb_repl_inf[2] && fb_repl_inf[1]);
   
   assign first_word_fill = ~(|fb_repl_inf[`M14K_FBR_FILLED]);

   // Stall signal (on next biu read request) when both front and back entries are in use
   assign fb_full = fb_active_entry || fb_trans_btof;   
   
   // FB entry to be filled. 0 = Front, 1 = Back.
   assign fb_active_entry = ((rd_req_sent | fb_active_entry_reg) & ~front_empty) |
		     ((biu_ddataval | biu_dbe_reg & biu_lastwd) & update_fb_back);
		     //(biu_ddataval & update_fb_back);
   mvp_register #(1) _fb_active_entry_reg(fb_active_entry_reg, gclk, fb_active_entry && !greset);

   assign dcc_pm_fb_active = fb_active_entry;

   // "Active" bits for Data registers, tag & replinf registers
   assign f_active[3:0] = (active_word & {4{~fb_active_entry}}) | {4{fb_trans_btof}};
   assign b_active[3:0] = active_word & {4{fb_active_entry}};
   assign raw_active[3:0] = (raw_ldfb | store_active_word) & {4{~fb_active_entry}};

   assign active_word [3:0] = ldfb | store_active_word;

   assign dval_m_sel[19:2] = dcc_dval_m[19:2];
   
   mvp_register #(2) _dval_m_reg_3_2_(dval_m_reg[3:2], gclk, dval_m_sel[3:2]);
  
   assign store_active_word [3:0] = {4{sb_to_fb_stb}} & decode2_4(dval_m_reg[3:2]);

   assign front_active = ~fb_active_entry | greset;
   assign back_active = fb_active_entry | greset;

   // Dirty Bytes : 1 = data in FB is dirty (don't overwrite)
   // these will be set as data from the SB is written to the FB
   assign front_dirty_bits [15:0]   = sb_to_fb_stb ? ~sb_to_fb_dirty[15:0] : (last_word_received | biu_dbe) ? 16'b0 :  
			     sb_to_fb_stb_reg ? sb_to_fb_dirty_reg[15:0] : fb_trans_btof ? back_dirty_bits_reg :   
			     greset ? 16'b0 : front_dirty_bits_reg;
   mvp_cregister_wide #(16) _front_dirty_bits_reg_15_0_(front_dirty_bits_reg[15:0],gscanenable, 
						(get_dirty_bits && front_active) || fb_trans_btof || greset, 
					 gclk, front_dirty_bits);
   
   assign back_dirty_bits [15:0]    = sb_to_fb_stb ? ~sb_to_fb_dirty[15:0] : (fb_trans_btof | biu_dbe) ? 16'b0 : 
			     last_word_received ? 16'b0 : sb_to_fb_stb_reg ? sb_to_fb_dirty_reg[15:0] : 
			     greset ? 16'b0 : back_dirty_bits_reg;
   mvp_cregister_wide #(16) _back_dirty_bits_reg_15_0_(back_dirty_bits_reg[15:0],gscanenable, 
					   (get_dirty_bits && back_active) || fb_trans_btof || greset, 
					   gclk, back_dirty_bits);
   mvp_register #(1) _last_word_received(last_word_received, gclk, biu_lastwd && (biu_ddataval || biu_dbe_reg) && !biu_dbe);
   assign get_dirty_bits = sb_to_fb_stb_reg || last_word_received || biu_dbe;

   mvp_register #(4) _ex_be_reg_3_0_(ex_be_reg[3:0], gclk,dcc_exbe[3:0]); 
   
   assign sb_to_fb_dirty [15:0] = { {4{store_active_word[3]}} & ex_be_reg[3:0],
			  {4{store_active_word[2]}} & ex_be_reg[3:0],
			  {4{store_active_word[1]}} & ex_be_reg[3:0],
			  {4{store_active_word[0]}} & ex_be_reg[3:0] };

   mvp_register #(16) _sb_to_fb_dirty_reg_15_0_(sb_to_fb_dirty_reg[15:0], gclk, sb_to_fb_dirty[15:0]);

   mvp_register #(1) _sb_to_fb_stb_reg(sb_to_fb_stb_reg, gclk, sb_to_fb_stb);

   // contents in the FB are dirty.
   assign fb_dirty = fb_trans_btof ? fb_dirty_b_reg : (front_active && read_sent) ? sb_to_fb_stb : fill_done ? 1'b0 :
	      store_hit_fb ? 1'b1 : greset ? 1'b0 : fb_dirty_reg;
   mvp_register #(1) _fb_dirty_reg(fb_dirty_reg, gclk, fb_dirty);

   assign fb_dirty_b = fb_trans_btof ? 1'b0 : (back_active && read_sent) ? sb_to_fb_stb : 
		  greset ? 1'b0 : fb_dirty_b_reg;
   mvp_register #(1) _fb_dirty_b_reg(fb_dirty_b_reg, gclk, fb_dirty_b);

   mvp_register #(1) _ld_mtag_reg(ld_mtag_reg, gclk, ld_mtag);
   assign read_sent = rd_req_sent && wb_reg;   
   assign rd_req_sent = ld_mtag_reg && req_out;  
   mvp_register #(1) _rd_req_sent_reg(rd_req_sent_reg, gclk, rd_req_sent);
   
   // Transfer back to front when front empty (transfer data, tag, replinfo) and 
   //     back in use, and no incoming data from the BIU (or switch "active" before).
   assign fb_trans_btof = fb_active_entry_reg && !fb_active_entry && front_empty && update_fb_back;
   mvp_register #(1) _fb_trans_btof_reg(fb_trans_btof_reg, gclk, fb_trans_btof);

   assign fb_trans_btof_active_entry = fb_active_entry | (fb_active_entry_reg & front_empty & update_fb_back);

   // New Data from SB or BIU
   assign new_data [31:0] = sb_to_fb_stb ? storebuff_data[31:0] : biu_datain[31:0];

   //****************
   // Stored FB data - two entries (front and back)
   //    fb_data_next used for bypasses to loads (only comes from Entry0)
   //****************
   // Word 0
   mvp_cregister_wide #(32) _fb_data0_31_0_(fb_data0[31:0],gscanenable, f_active[0], gclk, trans_fb_data0);
   assign trans_fb_data0 [31:0] = fb_trans_btof ? fb_data_back0[31:0] : fb_data_next0[31:0];
   
   mvp_cregister_wide #(8) _fb_data_back0_7_0_(fb_data_back0[7:0],gscanenable, b_active[0] & ~back_dirty_bits[0], 
					  gclk, new_data[7:0]);
   mvp_cregister_wide #(8) _fb_data_back0_15_8_(fb_data_back0[15:8],gscanenable, b_active[0] & ~back_dirty_bits[1], 
					  gclk, new_data[15:8]);
   mvp_cregister_wide #(8) _fb_data_back0_23_16_(fb_data_back0[23:16],gscanenable, b_active[0] & ~back_dirty_bits[2], 
					  gclk, new_data[23:16]);
   mvp_cregister_wide #(8) _fb_data_back0_31_24_(fb_data_back0[31:24],gscanenable, b_active[0] & ~back_dirty_bits[3], 
					  gclk, new_data[31:24]);
   
   assign fb_data_next0 [7:0]   = (raw_active[0] & ~front_dirty_bits[0]) ? new_data[7:0]   : fb_data0[7:0];
   assign fb_data_next0 [15:8]  = (raw_active[0] & ~front_dirty_bits[1]) ? new_data[15:8]  : fb_data0[15:8];
   assign fb_data_next0 [23:16] = (raw_active[0] & ~front_dirty_bits[2]) ? new_data[23:16] : fb_data0[23:16];
   assign fb_data_next0 [31:24] = (raw_active[0] & ~front_dirty_bits[3]) ? new_data[31:24] : fb_data0[31:24];

   // Word 1
   mvp_cregister_wide #(32) _fb_data1_31_0_(fb_data1[31:0],gscanenable,f_active[1], gclk, trans_fb_data1);
   assign trans_fb_data1 [31:0] = fb_trans_btof ? fb_data_back1[31:0] : fb_data_next1[31:0];

   mvp_cregister_wide #(8) _fb_data_back1_7_0_(fb_data_back1[7:0],gscanenable,b_active[1] & ~back_dirty_bits[4], 
					  gclk, new_data[7:0]);
   mvp_cregister_wide #(8) _fb_data_back1_15_8_(fb_data_back1[15:8],gscanenable,b_active[1] & ~back_dirty_bits[5], 
					  gclk, new_data[15:8]);
   mvp_cregister_wide #(8) _fb_data_back1_23_16_(fb_data_back1[23:16],gscanenable,b_active[1] & ~back_dirty_bits[6], 
					  gclk, new_data[23:16]);
   mvp_cregister_wide #(8) _fb_data_back1_31_24_(fb_data_back1[31:24],gscanenable,b_active[1] & ~back_dirty_bits[7], 
					  gclk, new_data[31:24]);
   
   assign fb_data_next1 [7:0]   = (raw_active[1] & ~front_dirty_bits[4]) ? new_data[7:0]   : fb_data1[7:0];
   assign fb_data_next1 [15:8]  = (raw_active[1] & ~front_dirty_bits[5]) ? new_data[15:8]  : fb_data1[15:8];
   assign fb_data_next1 [23:16] = (raw_active[1] & ~front_dirty_bits[6]) ? new_data[23:16] : fb_data1[23:16];
   assign fb_data_next1 [31:24] = (raw_active[1] & ~front_dirty_bits[7]) ? new_data[31:24] : fb_data1[31:24];

   // Word 2				
   mvp_cregister_wide #(32) _fb_data2_31_0_(fb_data2[31:0],gscanenable, f_active[2], gclk, trans_fb_data2);
   assign trans_fb_data2 [31:0] = fb_trans_btof ? fb_data_back2[31:0] : fb_data_next2[31:0];

   mvp_cregister_wide #(8) _fb_data_back2_7_0_(fb_data_back2[7:0],gscanenable, b_active[2] & ~back_dirty_bits[8], 
					  gclk, new_data[7:0]);
   mvp_cregister_wide #(8) _fb_data_back2_15_8_(fb_data_back2[15:8],gscanenable, b_active[2] & ~back_dirty_bits[9], 
					  gclk, new_data[15:8]);
   mvp_cregister_wide #(8) _fb_data_back2_23_16_(fb_data_back2[23:16],gscanenable, b_active[2] & ~back_dirty_bits[10], 
					  gclk, new_data[23:16]);
   mvp_cregister_wide #(8) _fb_data_back2_31_24_(fb_data_back2[31:24],gscanenable, b_active[2] & ~back_dirty_bits[11], 
					  gclk, new_data[31:24]);
   
   assign fb_data_next2 [7:0]   = (raw_active[2] & ~front_dirty_bits[8]) ? new_data[7:0]   : fb_data2[7:0];
   assign fb_data_next2 [15:8]  = (raw_active[2] & ~front_dirty_bits[9]) ? new_data[15:8]  : fb_data2[15:8];
   assign fb_data_next2 [23:16] = (raw_active[2] & ~front_dirty_bits[10]) ? new_data[23:16] : fb_data2[23:16];
   assign fb_data_next2 [31:24] = (raw_active[2] & ~front_dirty_bits[11]) ? new_data[31:24] : fb_data2[31:24];

   // Word 3
   mvp_cregister_wide #(32) _fb_data3_31_0_(fb_data3[31:0],gscanenable, f_active[3], gclk, trans_fb_data3);
   assign trans_fb_data3 [31:0] = fb_trans_btof ? fb_data_back3[31:0] : fb_data_next3[31:0];

   mvp_cregister_wide #(8) _fb_data_back3_7_0_(fb_data_back3[7:0],gscanenable, b_active[3] & ~back_dirty_bits[12], 
					  gclk, new_data[7:0]);
   mvp_cregister_wide #(8) _fb_data_back3_15_8_(fb_data_back3[15:8],gscanenable, b_active[3] & ~back_dirty_bits[13], 
					  gclk, new_data[15:8]);
   mvp_cregister_wide #(8) _fb_data_back3_23_16_(fb_data_back3[23:16],gscanenable, b_active[3] & ~back_dirty_bits[14], 
					  gclk, new_data[23:16]);
   mvp_cregister_wide #(8) _fb_data_back3_31_24_(fb_data_back3[31:24],gscanenable, b_active[3] & ~back_dirty_bits[15], 
					  gclk, new_data[31:24]);
   
   assign fb_data_next3 [7:0]   = (raw_active[3] & ~front_dirty_bits[12]) ? new_data[7:0]   : fb_data3[7:0];
   assign fb_data_next3 [15:8]  = (raw_active[3] & ~front_dirty_bits[13]) ? new_data[15:8]  : fb_data3[15:8];
   assign fb_data_next3 [23:16] = (raw_active[3] & ~front_dirty_bits[14]) ? new_data[23:16] : fb_data3[23:16];
   assign fb_data_next3 [31:24] = (raw_active[3] & ~front_dirty_bits[15]) ? new_data[31:24] : fb_data3[31:24];

   //*****************
   // Manage updates of tag, index, replacement info, etc.
   //*****************
   // ld_mtag - Load tag information for new miss
   assign ld_mtag = !req_out;

   // ld_tag - Move outstanding miss tag to DFB tag
   assign ld_tag = req_out && biu_ddataval;     // Data returned from miss
   

   mvp_register #(1) _ld_tag_reg(ld_tag_reg, gclk, ld_tag && front_active);

   //*****************
   // Data Fill Buffer Tag & Index
   //*****************
   // Tag High
   mvp_cregister_wide #(22) _fb_tag_h_31_10_(fb_tag_h[`M14K_PAH],gscanenable, (ld_tag && front_active) || fb_trans_btof, gclk, 
					    trans_fb_tag_h);
   assign fb_tag_back_h_cond = (ld_tag || rd_req_sent) && back_active;
   mvp_cregister_wide #(22) _fb_tag_back_h_31_10_(fb_tag_back_h[`M14K_PAH],gscanenable, fb_tag_back_h_cond, gclk, dmiss_tag);
   assign trans_fb_tag_h [`M14K_PAH] = fb_trans_btof ? fb_tag_back_h : dmiss_tag;

   // Tag Low
   assign fb_taglo [3:0] = raw_fb_tag_l & ~fill_dword_reg;

   mvp_cregister_wide #(4) _raw_fb_tag_l_3_0_(raw_fb_tag_l[3:0],gscanenable,
                          ((update_fb || flush_fb) && front_active) || cachewrite_m || fb_trans_btof, 
			  gclk, valid_bits);
   assign valid_bits[3:0] = (cachewrite_m & back_active) ? ((fb_taglo | ldfb) & ~{4{flush_fb}}): 
		     trans_fb_tag_l;
				      
   mvp_cregister_wide #(4) _raw_fb_tag_l_back_3_0_(raw_fb_tag_l_back[3:0],gscanenable, 
					    (update_fb && back_active) || fb_trans_btof, gclk, 
					    fb_trans_btof ? 4'b0 : raw_fb_tag_l_back_mx);

   assign raw_fb_tag_l_back_mx[3:0] = (ld_tag | rd_req_sent) ? ldfb : (raw_fb_tag_l_back | ldfb);
   
   assign trans_fb_tag_l [3:0] = fb_trans_btof ? raw_fb_tag_l_back : fb_raw_ld;

   assign fb_raw_ld  [3:0]      = (fb_tag_l_mx | ldfb) & ~{4{flush_fb}};
   assign fb_tag_h_mx [`M14K_PAH] = (req_out && front_active) ? dmiss_tag : fb_tag_h;
   assign fb_tag_l_mx [3:0]      = (req_out && front_active) ? ldfb :
			    (greset || rd_req_sent) ? 4'b0 : fb_taglo;

   // Words valid in fill buffer (for store and load hits when filling)
   assign valid_word_here [3:0] = (front_active & ld_tag) ? ldfb : 
			   greset                   ? 4'b0 : 			 
			   fb_trans_btof            ? raw_fb_tag_l_back : 
			   (fill_done) ? 4'b0 : 			   
			                         valid_word_here_reg | ldfb;

   assign back_data_nofill = raw_fb_replinf_back[`M14K_FBR_UNCACHED] || raw_fb_replinf_back[`M14K_FBR_NOFILL];
   assign front_data_nofill = fb_repl_inf       [`M14K_FBR_UNCACHED] || fb_repl_inf       [`M14K_FBR_NOFILL];
   assign load_data_nofill = dmiss_replinf     [`M14K_FBR_UNCACHED] || dmiss_replinf     [`M14K_FBR_NOFILL];
   assign data_nofill = ld_tag ? load_data_nofill : fb_trans_btof ? back_data_nofill : front_data_nofill;
     
   assign valid_word_here_c = update_fb || flush_fb || fb_trans_btof || (fill_done);      
   mvp_cregister_wide #(4) _valid_word_here_reg_3_0_(valid_word_here_reg[3:0],gscanenable, valid_word_here_c, 
					      gclk, valid_word_here & {4{~data_nofill}});

   // Index
   mvp_cregister_wide #(16) _fb_index_19_4_(fb_index[19:4],gscanenable, 
				    (ld_tag && front_active) || fb_trans_btof, gclk, trans_fb_index);
   mvp_cregister_wide #(16) _fb_index_back_19_4_(fb_index_back[19:4],gscanenable, 
					 (ld_tag || rd_req_sent) && back_active, gclk, dmiss_index);
   assign trans_fb_index [19:4] = fb_trans_btof ? fb_index_back[19:4] : dmiss_index[19:4];

   // Outstanding miss tag
   assign dmiss_tag_sel[`M14K_PAH] = mmu_dpah;
   mvp_cregister_wide #(22) _dmiss_tag_31_10_(dmiss_tag[`M14K_PAH],gscanenable, ld_mtag, gclk, dmiss_tag_sel);

   mvp_cregister_wide #(16) _dmiss_index_19_4_(dmiss_index[19:4],gscanenable, ld_mtag, gclk, dval_m_sel[19:4]);

   // update fill buffer
   assign update_fb = ld_tag || greset || biu_ddataval || rd_req_sent || (biu_dbe_reg && biu_lastwd); 
   mvp_cregister #(1) _update_fb_back(update_fb_back,update_fb || fb_trans_btof, gclk, back_active && !greset); 

   //****************
   // Data Fill Buffer Replacement Information
   //****************
   assign fb_repl_inf [12:0] = raw_fb_replinf | {8'b0, fill_dword_reg, 1'b0};

   mvp_cregister_wide #(13) _raw_fb_replinf_12_0_(raw_fb_replinf[12:0],gscanenable, 
				  ((update_fb || flush_fb || rd_req_sent_reg) && front_active)
				  || cachewrite_m || fb_trans_btof, 
				  gclk, replinf_fill_done[12:0]);
   assign replinf_fill_done [12:0] = (cachewrite_m & back_active) ? (fb_repl_inf[12:0] | fb_replinf_reset[12:0]) : 
			      trans_raw_fb_replinf [12:0];

   mvp_cregister_wide #(13) _raw_fb_replinf_back_12_0_(raw_fb_replinf_back[12:0],gscanenable, (update_fb | rd_req_sent_reg) 
					       & back_active, gclk,
					       fb_replinf_init_b[12:0] | fb_replinf_reset[12:0]);

   assign fb_replinf_init_b [12:0] = (ld_tag || rd_req_sent_reg) ? dmiss_replinf[12:0] :
			      rd_req_sent ? {dmiss_replinf[12:10], dmiss_replinf_sel[9:6], dmiss_replinf[5:0]} :
			      raw_fb_replinf_back[12:0];   
   
   assign trans_raw_fb_replinf [12:0] = fb_trans_btof ? raw_fb_replinf_back[12:0] : fb_repl_inf_mx[12:0];

   assign fb_repl_inf_mx [12:0] = (((ld_tag | rd_req_sent_reg) & front_active) ? dmiss_replinf :
			    (rd_req_sent & front_active) ? 
			    {dmiss_replinf[12:10], dmiss_replinf_sel[9:6], dmiss_replinf[5:0]} :
			    fb_repl_inf) | fb_replinf_reset[12:0];	 
   assign fb_replinf_reset [12:0] = {1'b0, {2{greset}}, 9'b0, (biu_lastwd & (biu_ddataval || biu_dbe_reg)) | greset};
   
   assign dmiss_replinfo [12:0] = {dcop_access_m & dcop_fandl, ~dcached, (no_way | ~dcached), 
			   repl_way[3:0], 1'b0, 4'b0, 1'b0};   
   assign dmiss_replinf_sel[12:0] = dmiss_replinfo[12:0];

   mvp_cregister #(3) _dmiss_replinf_12_10_(dmiss_replinf[12:10],ld_mtag, gclk, dmiss_replinf_sel[12:10]);
   mvp_cregister_wide #(4) _dmiss_replinf_9_6_(dmiss_replinf[9:6],gscanenable, rd_req_sent, gclk, dmiss_replinf_sel[9:6]);
   mvp_cregister_wide #(6) _dmiss_replinf_5_0_(dmiss_replinf[5:0],gscanenable, ld_mtag, gclk, dmiss_replinf_sel[5:0]);   

   //****************
   // Fill Buffer Hit Detection
   // compare against front entry only
   //****************

   assign hit_fb = check_hit && (raw_fb_valid[dval_m_sel[3:2]] || valid_word_here_reg[dval_m_sel[3:2]]);   

   assign check_hit = check_hit_low && dpah_match && !(fill_done || front_empty);

   assign check_hit_low = poss_hit_fb;   

   assign poss_hit_fb = idx_match_fb_low && idx_match_fb_high;
   
   assign idx_match_fb_high = idx_13_10_match_f || (idx_13_10_match_n && front_active);
   assign idx_13_10_match_f = ((fb_index[13:10] & index_mask)    == (dval_m_sel[13:10] & index_mask)) & 
                       ~(req_out & front_active);
   assign idx_13_10_match_n = ((dmiss_index[13:10] & index_mask) == (dval_m_sel[13:10] & index_mask)) & 
                       req_out;
   
   assign idx_match_fb_low = idx_9_4_match_f || (idx_9_4_match_n && front_active);
   assign idx_9_4_match_f = (dval_m_sel[9:4] == fb_index[9:4])    && !(req_out && front_active);
   assign idx_9_4_match_n = (dval_m_sel[9:4] == dmiss_index[9:4]) && req_out;
   
   assign idx_match_fb = idx_match_fb_low && idx_match_fb_high && !fb_trans_btof;

   // Raw because it does not include DBE, but we can signal hit anyway if DBE 
   assign raw_fb_valid[3:0] = fb_tag_l_mx | raw_ldfb;

   // High Address match and same coherency	
   assign dpah_match = (mmu_dpah == fb_tag_h_mx) & (dcached ^ fb_repl_inf_mx[`M14K_FBR_UNCACHED]);
	
   assign fb_fill_way[3:0] = {4{check_hit_low}} & {4{|valid_word_here[3:0]}} & fb_repl_inf[`M14K_FBR_REPLWAY];

   // Back fill buffer index compares
   assign back_idx_match_fb_low = idx_9_4_match_b || (idx_9_4_match_n && back_active);
   assign idx_9_4_match_b = (dval_m_sel[9:4] == fb_index_back[9:4]) && !(req_out && back_active);

   assign back_idx_match_fb_high = idx_13_10_match_b || (idx_13_10_match_n && back_active);
   assign idx_13_10_match_b = ((fb_index_back[13:10] & index_mask) == (dval_m_sel[13:10] & index_mask)) & ~(req_out & back_active);
   
   assign idx_match_fb_b = back_idx_match_fb_low && back_idx_match_fb_high;

   assign block_hit_fb = check_hit_low && dpah_match && (!(fill_done || front_empty) || 
						  (rd_req_sent && wt_nwa)) && !held_dtmack;

   //****************
   // fb_data:  Data from the appropriate word of the fill buffer 
   //              (including possible bypass from ext_data)
   //****************
   assign fb_data [31:0] = (dval_m_sel[3:2] == 2'h0) ? fb_data_next0[31:0] :
		       (dval_m_sel[3:2] == 2'h1) ? fb_data_next1[31:0] :
		       (dval_m_sel[3:2] == 2'h2) ? fb_data_next2[31:0] :
		       fb_data_next3[31:0];

   //****************
   // Determine when/what to fill into Array
   //****************
   // FillDataRdy:  Words that are in DFB, but not cache
   assign fill_data_rdy [3:0] = fb_taglo & ~(fb_repl_inf[`M14K_FBR_FILLED]);

   assign fill_data_ready = |(fill_data_rdy[3:0]) & ~(fb_repl_inf[`M14K_FBR_NOFILL]);

   assign front_empty = fb_repl_inf[`M14K_FBR_LAST] && fb_replinf0_reg && !fill_data_ready && !fb_trans_btof_reg;

   mvp_register #(1) _fb_replinf0_reg(fb_replinf0_reg, gclk, fb_repl_inf[`M14K_FBR_LAST]);

   assign fill_done = !req_out_reg && front_empty;   

   // FillDWord: Determine which word will be filled if any
   assign fill_dword_reg [3:0] = {4{cachewrite_m & ~ld_tag_reg}} & raw_fill_dword_reg;

   mvp_register #(4) _raw_fill_dword_reg_3_0_(raw_fill_dword_reg[3:0], gclk, raw_fill_dword);

   //
   function [3:0] rightmost_bit; input [3:0] i;
     rightmost_bit = { i[3] & ~|i[2:0],
                       i[2] & ~|i[1:0],
                       i[1] & ~ i[0],
                       i[0]};
   endfunction
   //

   assign raw_fill_dword [3:0] = rightmost_bit(fill_data_rdy[3:0]); 

   //*****************
   // Actual fill data & tag
   //*****************
   // FillData:  Data to be written into the cache
   assign fill_data [31:0] = fill_data_rdy[0] ? fb_data0[31:0] :
		      fill_data_rdy[1] ? fb_data1[31:0] :
		      fill_data_rdy[2] ? fb_data2[31:0] :
		      fb_data3[31:0];

   // fill_tag: Tag to be written on the fill
   assign fb_tag [31:4] = {fb_tag_h, fb_index[`M14K_PALHI:4]}; // The 6 rightmost bits are not used
   assign fill_tag [23:0] = {fb_tag[31:10],
		      fb_repl_inf[`M14K_FBR_LOCK] && last_word_fill && !bus_err_line,		      
		      last_word_fill && !bus_err_line};   
   
   // fill_addr_lo: FillD Buffer Address Low-- Create word address for writing into cache
   assign fill_addr_lo [19:2] = {fb_index[19:4], |(raw_fill_dword[3:2]), 
			raw_fill_dword[3] | raw_fill_dword[1]};
   
   assign repl_wway[3:0] = fb_repl_inf[`M14K_FBR_REPLWAY];

   //*****************
   // Flush the fill buffer if this was an uncached load, or if we aren't 
   //     filling and a store hits in the FB
   //*****************
   assign flush_fb = (fb_repl_inf_mx[`M14K_FBR_UNCACHED] && !dcc_dmiss_m) || 
	      (fb_repl_inf_mx[`M14K_FBR_NOFILL] && dstore_m && block_hit_fb) ||
	      (fill_done && dcop_access_m);
   assign dcc_uncache_load = fb_repl_inf_mx[`M14K_FBR_UNCACHED] && !dcc_dmiss_m;
endmodule
