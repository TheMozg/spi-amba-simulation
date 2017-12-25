// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
	// mvp Version 2.23
	//
	// 	m14k_biu: bus interface unit
	//	
	//      $Id: \$
	//      mips_repository_id: m14k_biu.mv, v 1.23 
	//


	//	mips_start_of_legal_notice
	//	**************************************************************************
	//	Unpublished work (c) MIPS Technologies, Inc.  All rights reserved. 
	//	Unpublished rights reserved under the copyright laws of the United States
	//	of America and other countries.
	//	
	//	MIPS TECHNOLOGIES PROPRIETARY / RESTRICTED CONFIDENTIAL - HEIGHTENED
	//	STANDARD OF CARE REQUIRED AS PER CONTRACT
	//	
	//	This code is confidential and proprietary to MIPS Technologies, Inc.
	//	("MIPS Technologies") and may be disclosed only as permitted in writing by
	//	MIPS Technologies.  Any copying, reproducing, modifying, use or disclosure
	//	of this code (in whole or in part) that is not expressly permitted in
	//	writing by MIPS Technologies is strictly prohibited.  At a minimum, this
	//	code is protected under trade secret, unfair competition and copyright
	//	laws.  Violations thereof may result in criminal penalties and fines.
	//	
	//	MIPS Technologies reserves the right to change the code to improve
	//	function, design or otherwise.	MIPS Technologies does not assume any
	//	liability arising out of the application or use of this code, or of any
	//	error or omission in such code.  Any warranties, whether express,
	//	statutory, implied or otherwise, including but not limited to the implied
	//	warranties of merchantability or fitness for a particular purpose, are
	//	excluded.  Except as expressly provided in any written license agreement
	//	from MIPS Technologies, the furnishing of this code does not give
	//	recipient any license to any intellectual property rights, including any
	//	patent rights, that cover this code.
	//	
	//	This code shall not be exported, reexported, transferred, or released,
	//	directly or indirectly, in violation of the law of any country or
	//	international law, regulation, treaty, Executive Order, statute,
	//	amendments or supplements thereto.  Should a conflict arise regarding the
	//	export, reexport, transfer, or release of this code, the laws of the
	//	United States of America shall be the governing law.
	//	
	//	This code may only be disclosed to the United States government
	//	("Government"), or to Government users, with prior written consent from
	//	MIPS Technologies.  This code constitutes one or more of the following:
	//	commercial computer software, commercial computer software documentation
	//	or other commercial items.  If the user of this code, or any related
	//	documentation of any kind, including related technical data or manuals, is
	//	an agency, department, or other entity of the Government, the use,
	//	duplication, reproduction, release, modification, disclosure, or transfer
	//	of this code, or any related documentation of any kind, is restricted in
	//	accordance with Federal Acquisition Regulation 12.212 for civilian
	//	agencies and Defense Federal Acquisition Regulation Supplement 227.7202
	//	for military agencies.	The use of this code by the Government is further
	//	restricted in accordance with the terms of the license agreement(s) and/or
	//	applicable contract terms and conditions covering this code from MIPS
	//	Technologies.
	//	
	//	
	//	
	//	**************************************************************************
	//	mips_end_of_legal_notice
	//	

`include "m14k_const.vh"
module m14k_biu(
	HRDATA,
	HREADY,
	HRESP,
	mpc_atomic_m,
	mpc_atomic_w,
	mpc_exc_m,
	ejt_eadone,
	ejt_eadata,
	SI_MergeMode,
	icc_exaddr,
	icc_excached,
	icc_exmagicl,
	icc_exreqval,
	icc_exhe,
	dcc_exaddr,
	dcc_exaddr_ev,
	dcc_exaddr_sel,
	dcc_excached,
	dcc_exmagicl,
	dcc_exrdreqval,
	dcc_exwrreqval,
	dcc_exbe,
	dcc_exnewaddr,
	dcc_stalloc,
	dcc_exsyncreq,
	dcc_ev_kill,
	dcc_exdata,
	mpc_wait_w,
	cp2_copidle,
	cp1_copidle,
	ejt_pdt_fifo_empty,
	dmbinvoke,
	cpz_rbigend_e,
	gclk,
	gfclk,
	gscanenable,
	greset,
	SI_AHBStb,
	HCLK,
	HRESETn,
	HADDR,
	HBURST,
	HPROT,
	HMASTLOCK,
	HSIZE,
	HTRANS,
	HWRITE,
	HWDATA,
	biu_datain,
	biu_datawd,
	biu_lastwd,
	biu_dreqsdone,
	biu_idataval,
	biu_ddataval,
	biu_wtbf,
	biu_ibe,
	biu_ibe_exc,
	biu_ibe_pre,
	biu_dbe,
	biu_dbe_exc,
	biu_dbe_pre,
	biu_wbe,
	biu_lock,
	biu_merging,
	biu_shutdown,
	biu_eaaccess,
	biu_nofreebuff,
	biu_pm_wr_buf_b,
	biu_pm_wr_buf_f,
	biu_be_ej,
	biu_if_enable,
	icc_mbdone,
	dcc_mbdone,
	icc_spmbdone,
	dcc_spmbdone,
	gmbdone,
	biu_mbdata,
	biu_mbtag);


	// Inputs from External AHB Bus
	input	[31:0]	HRDATA;		//AHB: Read Data Bus
	input 		HREADY;		//AHB: Indicate the previous transfer is complete
	input   	HRESP;		//AHB: 0 is OKAY, 1 is ERROR
	input		mpc_atomic_m;	//Atomic instruction is in M-stage and Load opertion
	input		mpc_atomic_w;	//Atomic instruction is in W-stage and Store opertion
	input		mpc_exc_m;

	// Inputs from EJTAG
	input 		ejt_eadone;     // EJTAG Area access done
	input [31:0] 	ejt_eadata;    	// EJTAG Area access read data
   
	// Static System configuration Inputs
	input [1:0] 	SI_MergeMode;   // merging algorithm:  0X- No merging
					// 1X - merging allowed

	// Inputs from the core
	input [31:2]	icc_exaddr;	// PA from I$ Ctl
	input		icc_excached;	// I Reference is cached
	input		icc_exmagicl;	// I Reference is to Probe Space
	input		icc_exreqval;	// This is a valid I request
	input [1:0] 	icc_exhe;       // Half enables 
	input [31:2]	dcc_exaddr;	// PA from D$ Ctl
	input [31:2]	dcc_exaddr_ev;	// PA from D$ Ctl for eviction
	input 		dcc_exaddr_sel; // Select which dcc_exaddr to use (1=exaddr_ev : 0=exaddr)
	input		dcc_excached;	// D Reference is cached
	input		dcc_exmagicl;	// D Reference is to Probe Space
	input		dcc_exrdreqval;	// This is a valid D request
	input		dcc_exwrreqval;	// This is a valid D request
	input [3:0]	dcc_exbe;	// Byte enables for D request
	input 		dcc_exnewaddr;  // Valid L/S/P/$ instn in M-stage
	input 		dcc_stalloc;  	// There is a write allocate occuring, don't flush the WTB
	input		dcc_exsyncreq;	// This is a sync instn: flush the write buffers
	input		dcc_ev_kill;	// Eviction was killed for parity check
	input [31:0]	dcc_exdata;	// Data from D$
	input 		mpc_wait_w;     // WAIT instn executed
	input		cp2_copidle;	// COP 2 is Idle, biu_shutdown is OK for COP 2
	input		cp1_copidle;	// COP 1 is Idle, biu_shutdown is OK for COP 1
	input		ejt_pdt_fifo_empty;// OK to gate off gclk in clock_gate
	input		dmbinvoke;
	input 		cpz_rbigend_e; 	// indicate big Endian Mode
	input 		gclk;           // Clock
	input 		gfclk;          // free running clock 
	input 		gscanenable;
	input 		greset;


	input		SI_AHBStb;

	//outputs to AHB Bus
	output 		HCLK;		//AHB: The bus clock times all bus transfer. 
	output		HRESETn;	//AHB: The bus reset signal is active LOW and resets the system and the bus.
	output [31:0]	HADDR;		//AHB: The 32-bit system address bus.
	output [2:0]	HBURST;		//AHB: Burst type; Only Two types:
					//	3'b000	---	Single; 3'b10  --- 4-beat Wrapping;
	output [3:0]	HPROT;		//AHB: The single indicate the transfer type; 
					//AHB: 4'b0011, data access; 4'b0010, opcode fetch ;
	output 		HMASTLOCK;	//AHB: Indicates the current transfer is part of a locked sequence; 
					//AHB: in M14Kc,use HMASTLOCK to maintain the integrity of an atomic inst 
	output [2:0]	HSIZE; 		//AHB: Indicates the size of transfer; Only Three types:
					//	3'b000 --- Byte; 3'b001 --- Halfword; 3'b010 --- Word;	
       	output [1:0]  	HTRANS;		//AHB: Indicates the transfer type; Three Types
					// 	2'b00 --- IDLE, 2'b10 --- NONSEQUENTIAL, 2'b11 --- SEQUENTIAL.
	output        	HWRITE;		//AHB: Indicates the transfer direction, Read or Write. 
	output [31:0] 	HWDATA;		//AHB: Write data bus.

	// Data return signals to core	 
	output [31:0]	biu_datain;	// Data into the cache control blocks
	output [1:0]	biu_datawd;	// Which wd within the line is being returned
	output		biu_lastwd;	// This is the last word to be returned
	output		biu_dreqsdone;	// sync request is done
	output		biu_idataval;	// Returning I Data
	output		biu_ddataval;	// Returning D Data
	output		biu_wtbf;	// Write Thru buffer is full
	output		biu_ibe;      	// Bus Error on Instn reference
	output		biu_ibe_exc;      	// Bus Error on Instn reference
	output		biu_ibe_pre;    // Previous Bus Error on Instrn reference 
	output		biu_dbe;        // Bus Error on Data Read 
	output		biu_dbe_exc;        // Bus Error on Data Read 
	output		biu_dbe_pre;    // Previous Bus Error on Data Read 
	output 		biu_wbe;    	// Bus Error on a Data write
	output		biu_lock;	// Bus is locked by atomic instruction
	output  	biu_merging;   	// Merging enabled in WTB
	output 		biu_shutdown;   // Bus is idle, shutdown main clock
	output 		biu_eaaccess;   // Signal that this is an EJTAG area access
	output 		biu_nofreebuff; // No free WTB enties, stall writeback flushes 
	output		biu_pm_wr_buf_b;// used by performance counter to trace wbb status
	output		biu_pm_wr_buf_f;// used by performance counter to trace wbb status
	output [3:0]	biu_be_ej; 	// Byte enable to EJTAG module
        output          biu_if_enable;

	input 		icc_mbdone;     // I$ MBIST done
	input 		dcc_mbdone;     // D$ MBIST done
	input 		icc_spmbdone;     // ISPRAM MBIST done
	input 		dcc_spmbdone;     // DSPRAM MBIST done
	output 		gmbdone;        // Global MBIST done
	output [31:0]	biu_mbdata;     // MBIST data		 
	output [23:2]	biu_mbtag;	// MBIST Tag	 

// BEGIN Wire declarations made by MVP
wire rd_pend;
wire ireq;
wire ireq_d_st2_reg;
wire wreq_sta1;
wire split_wr_w3;
wire uncached_store;
wire dreq_a_st1;
wire dcc_ev_kill_reg;
wire split_wr_w1_raw;
wire wreq_std3_reg;
wire st_hit_wrb;
wire [3:2] /*[3:2]*/ addr_reg;
wire wreq_stds1;
wire read_lock;
wire wtmagicl_raw;
wire dreq_d_st3;
wire wreq_std_d;
wire sync_retain;
wire wreq_stas1_reg;
wire ireq_d_st1;
wire [15:0] /*[15:0]*/ ld_wr_buf_data;
wire [35:0] /*[35:0]*/ daddr;
wire biu_ibe_reg;
wire wreq_stas2_reg;
wire write_lock;
wire biu_eaaccess;
wire biu_lock;
wire ww;
wire dreq_st0;
wire greset_reg;
wire dcc_exaddr_sel_reg;
wire wr_buf_addr_match;
wire merging;
wire dcc_ev_force_move_reg;
wire ireq_a_st1_reg;
wire dreq_st0_reg;
wire wreq_d_done_sync;
wire dreq_done;
wire dreq_d_st0;
wire wrb_htrans_nxt_reg;
wire wreq_stas3_reg;
wire biu_pm_wr_buf_b;
wire [1:0] /*[1:0]*/ wrb_wd_cnt;
wire dtrans_nxt;
wire ill_merge;
wire new_addr;
wire wreq_redo_single;
wire wreq_done;
wire wreq_stds_d_0_reg;
wire [1:0] /*[1:0]*/ be_nxt_size;
wire [1:0] /*[1:0]*/ dword_nxt;
wire split_wr_w3_raw;
wire split_wr_w1;
wire htrans_idle_reg;
wire wreq_stas0;
wire biu_dbe_reg;
wire hold_flush_wrb;
wire change_transfer_reg;
wire wreq_d_done_sync_qf;
wire wreq_sta2_reg;
wire wreq_d_done;
wire [1:0] /*[1:0]*/ wrb_wd_cnt_nxt;
wire ea_acc_en;
wire dreq_val_reg;
wire biu_ddataval;
wire biu_ibe_pre;
wire [31:0] /*[31:0]*/ wr_buf_tag_f_reg;
wire wtmagicl;
wire wreq_stds_d_3_reg;
wire iburst;
wire ireq_d_st1_reg;
wire greset_active;
wire ireq_d_st0;
wire dreq_a_st0_reg;
wire wreq_sta1_reg;
wire first_error_cycle;
wire dcached_reg;
wire wreq_stds2_reg;
wire ireq_st1;
wire dreq;
wire wreq_stds0;
wire sync_core;
wire [31:0] /*[31:0]*/ biu_mbdata;
wire [37:0] /*[37:0]*/ daddr_w;
wire hready_reg;
wire wreq_sta0_redo;
wire [31:0] /*[31:0]*/ wr_buf_tag_b;
wire wreq_stas1;
wire [15:0] /*[15:0]*/ wr_buf_vld_b;
wire ireq_st3;
wire wreq_sta0_reg;
wire imagicl;
wire if_enable;
wire wreq_stds_d_1_reg;
wire wreq_std_d_0;
wire move2back;
wire ireq_a_st2_reg;
wire uncached_fetch_redo;
wire dreq_st1_reg;
wire wreq_sta0;
wire [1:0] /*[1:0]*/ beat_cnt;
wire biu_ibe;
wire [33:0] /*[33:0]*/ iaddr;
wire ireq_d_st0_reg;
wire dreq_st3_reg;
wire wreq_redo_single_std_d_0_reg;
wire flush_wrb;
wire new_htrans;
wire [15:0] /*[15:0]*/ wr_buf_vld_f_reg;
wire split_wr2;
wire dreq_a_st0;
wire wreq_redo_single_std0_reg;
wire ld_hit_flush;
wire ireq_d_reg;
wire split_wr0;
wire wreq_stas2;
wire wtmagicl_prev;
wire addr_atomic_wr;
wire st_alloc_pairn;
wire biu_dbe;
wire dreq_a_st3_reg;
wire [1:0] /*[1:0]*/ biu_datawd;
wire [3:0] /*[3:0]*/ HPROT;
wire [31:0] /*[31:0]*/ HWDATA;
wire dreq_st1;
wire biu_dbe_pre;
wire wreq_std_d_1_reg;
wire ireq_done;
wire ireq_a_st3;
wire wtburst;
wire [3:0] /*[3:0]*/ be_nxt;
wire itrans_nxt;
wire [1:0] /*[1:0]*/ iword_nxt_reg;
wire [2:0] /*[2:0]*/ HSIZE;
wire change_transfer;
wire HRESETn;
wire sync_hold;
wire biu_wtbf;
wire idle_cycle_follerror;
wire biu_shutdown;
wire wreq_std_d_3_reg;
wire [31:0] /*[31:0]*/ wr_buf_tag_f;
wire gmbdone;
wire dreq_d_st2;
wire dreq_st0_redo;
wire mastlock_deasserted_fr_err;
wire htrans_idle;
wire wreq_stas3;
wire wreq_std2_reg;
wire biu_pm_wr_buf_f;
wire st_hit_wrb_reg;
wire [15:0] /*[15:0]*/ raw_ld_wr_buf_data;
wire biu_shutdown_idle;
wire wreq_stds_d_3;
wire [1:0] /*[1:0]*/ dword_nxt_reg;
wire ireq_a_st0_reg;
wire [1:0] /*[1:0]*/ haddr_3_2_reg_reg;
wire wreq_std_d_1;
wire dreq_a_st3;
wire wreq_std_d_reg;
wire lock_hold_reg;
wire biu_wbe;
wire early_idle;
wire hresp_reg_reg;
wire rd_databack;
wire biu_ibe_exc;
wire wreq_sta3;
wire [15:0] /*[15:0]*/ raw_ld_wr_buf_data_reg;
wire wreq_a;
wire ea_wr_acc_nxt;
wire wreq_std_d_2_reg;
wire full_line_flush;
wire ireq_a_st3_reg;
wire wreq_std1_reg;
wire rd_pend_reg;
wire [127:0] /*[127:0]*/ wr_buf_f;
wire ireq_d_st3_reg;
wire ireq_a_st2;
wire wrreq_val;
wire [31:0] /*[31:0]*/ biu_datain;
wire dreq_a;
wire [127:0] /*[127:0]*/ wr_buf_b;
wire ireq_val_reg;
wire iburst_prev;
wire [31:0] /*[31:0]*/ wr_buf_tag_b_reg;
wire idle_st;
wire [35:0] /*[35:0]*/ daddr_munge_w;
wire [3:0] /*[3:0]*/ wr_be_mask;
wire [1:0] /*[1:0]*/ iword_nxt;
wire dmagicl;
wire [31:2] /*[31:2]*/ dcc_exaddr_mx;
wire dtrans_nxt_reg;
wire dreq_d_reg;
wire ea_read;
wire dreq_a_st2_reg;
wire ireq_st0_redo;
wire sync;
wire split_wr_w2;
wire sync_qf_period;
wire second_error_cycle;
wire [15:0] /*[15:0]*/ wr_buf_vld_f;
wire wreq_stds_d_2;
wire ireq_a;
wire dreq_st2;
wire dreq_d_st1_reg;
wire wreq_stds_d_2_reg;
wire mastlock_deasserted;
wire ireq_st3_reg;
wire wreq_redo_pre;
wire wreq_sta3_reg;
wire [1:0] /*[1:0]*/ HTRANS;
wire read_lock_hold;
wire [3:0] /*[3:0]*/ biu_be_ej;
wire wreq_std_d_2;
wire biu_idataval;
wire ireq_val;
wire hresp_reg;
wire last_addr;
wire ireq_d;
wire wreq_stds3;
wire [31:0] /*[31:0]*/ wr_buf_b2eb_reg;
wire wreq_stas0_reg;
wire split_wr_a2;
wire [1:0] /*[1:0]*/ wrb_addr_wd;
wire ireq_st0;
wire biu_dreqsdone;
wire itrans_nxt_reg;
wire sync_reg;
wire biu_lastwd;
wire HWRITE;
wire uncached_load_redo;
wire split_wr_w0;
wire ireq_a_st1;
wire [3:0] /*[3:0]*/ wrb_wd_vld;
wire wrb_htrans_nxt;
wire ireq_st2;
wire dreq_val;
wire full_line_f;
wire wreq_stds_d_1;
wire dreq_d_st3_reg;
wire dreq_a_st2;
wire [1:0] /*[1:0]*/ wrb_word2;
wire [127:0] /*[127:0]*/ wr_buf_b_reg;
wire last_write_nxt;
wire wreq_sta2;
wire dreq_d_st1;
wire cached_store;
wire wr_buf_addr_match_reg;
wire wreq_std0_reg;
wire ea_ireq;
wire [31:2] /*[31:2]*/ burst_addr_nxt;
wire ireq_st0_reg;
wire split_wr_w0_raw;
wire [3:0] /*[3:0]*/ read_be;
wire ireq_d_st3;
wire greset_n;
wire [1:0] /*[1:0]*/ wrb_word1;
wire wreq_std0;
wire split_wr3;
wire dreq_a_st1_reg;
wire flush_wrb_reg;
wire [35:0] /*[35:0]*/ daddr_reg;
wire ea_rd_acc_nxt;
wire [31:4] /*[31:4]*/ wtaddr;
wire wreq_redo_single_std0;
wire addr_atomic_wr_reg;
wire split_wr_w2_raw;
wire split_wr1;
wire ucs_or_sync;
wire ww_nxt;
wire wreq_std1;
wire wreq_stds0_reg;
wire wreq_d;
wire [1:0] /*[1:0]*/ wrb_word0;
wire wreq_stds1_reg;
wire wreq_std_d_3;
wire [1:0] /*[1:0]*/ haddr_3_2_reg;
wire biu_nofreebuff;
wire [31:0] /*[31:0]*/ wr_buf_b2eb;
wire [15:0] /*[15:0]*/ wr_buf_vld_b_reg;
wire dreq_st3;
wire wreq_redo_single_std_d_0;
wire [1:0] /*[1:0]*/ be_nxt_address;
wire dreq_d_st2_reg;
wire [31:0] /*[31:0]*/ hrdata_reg;
wire wreq_stds2;
wire read_lock_start;
wire wreq_std2;
wire biu_merging;
wire [1:0] /*[1:0]*/ wrb_data_wd;
wire [3:0] /*[3:0]*/ raw_wr_be;
wire opcode_fetch;
wire [1:0] /*[1:0]*/ burst_htrans_nxt;
wire ireq_st2_reg;
wire flush_front;
wire biu_dbe_exc;
wire wreq_stds_d_0;
wire flush_start;
wire wreq_std_d_0_reg;
wire ld_wr_buf_tag;
wire wreq_std3;
wire biu_if_enable;
wire mastlock_deasserted_cond;
wire addr_atomic_wr_acc;
wire wreq_stds3_reg;
wire [23:2] /*[23:2]*/ biu_mbtag;
wire HMASTLOCK;
wire dreq_d_st0_reg;
wire ireq_a_st0;
wire uncached_store_reg;
wire dreq_d;
wire split_wr_a;
wire dcc_ev_force_move;
wire [31:0] /*[31:0]*/ HADDR;
wire [2:0] /*[2:0]*/ HBURST;
wire ireq_d_st2;
wire lock_hold;
wire new_addr_ej;
wire dburst_prev;
wire ireq_st1_reg;
wire wtmagicl_prev_reg;
wire addr_atomic_rd;
wire new_data;
wire addr_atomic_rd_reg;
wire [3:0] /*[3:0]*/ write_be;
wire dreq_st2_reg;
wire burst_nxt;
wire dburst;
wire flush_done;
// END Wire declarations made by MVP


	// Input registers

	mvp_register #(1) _if_enable(if_enable, gfclk, SI_AHBStb);
	assign biu_if_enable = if_enable;
   	m14k_clockandlatch gate_clockgate_hclk (.gclk(HCLK), .clk(gclk), .enable(if_enable), .scanenable(gscanenable));

	mvp_cregister #(1) _hready_reg(hready_reg,if_enable|greset, gclk, ~greset & HREADY);

	mvp_cregister #(1) _hresp_reg(hresp_reg,if_enable, gclk, ~greset && HRESP);
	mvp_cregister #(1) _hresp_reg_reg(hresp_reg_reg,if_enable, gclk, ~greset && hresp_reg);
			
	mvp_cregister_wide #(32) _hrdata_reg_31_0_(hrdata_reg[31:0],gscanenable, rd_databack & if_enable, gclk, HRDATA);

	assign htrans_idle = ~HTRANS[1] && ~HTRANS[0];
	mvp_cregister #(1) _htrans_idle_reg(htrans_idle_reg,if_enable, gclk, htrans_idle);

	assign change_transfer =(HREADY || htrans_idle) && if_enable;
	assign change_transfer_reg = (hready_reg || htrans_idle_reg && !HRESP) && if_enable;

	assign first_error_cycle = HRESP && !hresp_reg;
        assign second_error_cycle = hresp_reg && !hresp_reg_reg;
        assign idle_cycle_follerror = hresp_reg && hresp_reg_reg;

	// SI_MergeMode[0] are not used

       mvp_cregister #(2) _gmbdone_biu_merging({gmbdone, 
	biu_merging}, greset,
			 gclk, {(icc_mbdone & dcc_mbdone & icc_spmbdone & dcc_spmbdone),
					SI_MergeMode[1]});

	// Indication of idle bus - allows us to enter sleep mode
	// Biu shutdown from mpc_wait_w(wait instruction) and take effect when all tranactions are done.
	assign biu_shutdown = ejt_pdt_fifo_empty && cp2_copidle && mpc_wait_w && cp1_copidle && 
			!ireq && !ireq_a && !ireq_d &&
		        !dreq && !dreq_a && !dreq_d && 
			!wreq_a && !wreq_d && !wreq_std_d;
	// Bus turn to IDLE after last tranctions are finished.
	assign biu_shutdown_idle = mpc_wait_w & ! biu_shutdown;

	
// Instn Types: Cached/Uncached Load/Store, sync, atomic RWM sequence
//	CachedLoad = dcc_exrdreqval && dcached_reg;
//	UnCachedLoad = dcc_exrdreqval && !dcached_reg;
	mvp_register #(1) _dcached_reg(dcached_reg, gclk, dcc_excached);
	assign cached_store = dcc_exwrreqval && dcached_reg;
	assign uncached_store = dcc_exwrreqval && !dcached_reg;
	mvp_register #(1) _uncached_store_reg(uncached_store_reg, gclk, uncached_store);
	mvp_register #(1) _sync_core(sync_core, gclk, dcc_exsyncreq);
// Atomic write behavior similar to sync,that is hold the bus until the data is sent out
// Flush the WTB before start the atomic load operation.
        assign sync = sync_core || wr_buf_tag_f_reg[2] &&  wr_buf_tag_f_reg[0]
		|| dreq_val && addr_atomic_rd && idle_st && wr_buf_tag_f_reg[0];
// sync on uncached stores to flush them out of the write thru buffer
	assign ucs_or_sync = uncached_store || uncached_store_reg;

	
	// Write Thru Buffer:  16B x 2 entries.	 Front entry is mergeable and checks for 
	// loads hitting in it.	 Back entry holds the entry until it can get out on the
	// bus.	 WT's have to have higher priority than D$ loads since we don't check for
	// conflicts on the back entry
   
	// WTBufferTag = {PA[31:2], DebugMemory, Valid}
	// WTBuffer = {16x{Data[7:0]}}
	// WTBufferByteValid = {16xValid}
        mvp_cregister_wide #(128) _wr_buf_f_127_0_(wr_buf_f[127:0],gscanenable, dcc_exwrreqval, gclk,
                                      {ld_wr_buf_data[15] ? {dcc_exdata[31:24]} : wr_buf_f[127:120],
                                       ld_wr_buf_data[14] ? {dcc_exdata[23:16]} : wr_buf_f[119:112],
                                       ld_wr_buf_data[13] ? {dcc_exdata[15:8]} : wr_buf_f[111:104],
                                       ld_wr_buf_data[12] ? {dcc_exdata[7:0]} : wr_buf_f[103:96],
                                       ld_wr_buf_data[11] ? {dcc_exdata[31:24]} : wr_buf_f[95:88],
                                       ld_wr_buf_data[10] ? {dcc_exdata[23:16]} : wr_buf_f[87:80],
                                       ld_wr_buf_data[9] ? {dcc_exdata[15:8]} : wr_buf_f[79:72],
                                       ld_wr_buf_data[8] ? {dcc_exdata[7:0]} : wr_buf_f[71:64],
                                       ld_wr_buf_data[7] ? {dcc_exdata[31:24]} : wr_buf_f[63:56],
                                       ld_wr_buf_data[6] ? {dcc_exdata[23:16]} : wr_buf_f[55:48],
                                       ld_wr_buf_data[5] ? {dcc_exdata[15:8]} : wr_buf_f[47:40],
                                       ld_wr_buf_data[4] ? {dcc_exdata[7:0]} : wr_buf_f[39:32],
                                       (ld_wr_buf_data[3] || dmbinvoke) ? {dcc_exdata[31:24]} : wr_buf_f[31:24],
                                       (ld_wr_buf_data[2] || dmbinvoke) ? {dcc_exdata[23:16]} : wr_buf_f[23:16],
                                       (ld_wr_buf_data[1] || dmbinvoke) ? {dcc_exdata[15:8]} : wr_buf_f[15:8],
                                       (ld_wr_buf_data[0] || dmbinvoke) ? {dcc_exdata[7:0]} : wr_buf_f[7:0] });


	assign biu_mbdata[31:0] = wr_buf_f[31:0];
	assign wr_buf_vld_f [15:0] = ld_wr_buf_data[15:0] | wr_buf_vld_f_reg[15:0] & ~{16{move2back}};
	mvp_cregister_wide #(16) _wr_buf_vld_f_reg_15_0_(wr_buf_vld_f_reg[15:0],gscanenable, (dcc_exwrreqval || move2back ||dcc_ev_kill_reg || greset),  gclk, wr_buf_vld_f & {16{~(greset | dcc_ev_kill_reg)}});

	// Detect all bytes valid and move to back if bus is idle
	assign full_line_f = &(wr_buf_vld_f_reg[15:0]);
	assign full_line_flush = full_line_f && early_idle;
	mvp_cregister_wide #(38) _daddr_w_37_0_(daddr_w[37:0],gscanenable, dcc_exnewaddr || greset, gclk, {mpc_atomic_m & !greset, mpc_atomic_w & !mpc_exc_m & !greset, dcc_exbe[3:0], 
									  dcc_exaddr_mx[31:2],
									  dcc_exmagicl, dcc_excached & !greset});

	assign addr_atomic_rd = daddr_w[37] & !daddr_w[0];
       	assign addr_atomic_wr = daddr_w[36] & !daddr_w[0];
        assign biu_lock = addr_atomic_rd && dcc_exrdreqval || addr_atomic_rd_reg || addr_atomic_wr_acc;
        mvp_register #(1) _addr_atomic_rd_reg(addr_atomic_rd_reg, gclk, addr_atomic_rd && (dcc_exrdreqval || addr_atomic_rd_reg));
        mvp_register #(1) _addr_atomic_wr_reg(addr_atomic_wr_reg, gclk, addr_atomic_wr && (dcc_exwrreqval || addr_atomic_wr_reg));
        assign addr_atomic_wr_acc = addr_atomic_wr && !(dcc_exwrreqval || addr_atomic_wr_reg);

        assign read_lock = (read_lock_start || read_lock_hold) && addr_atomic_rd && dreq;
        assign read_lock_start = (addr_atomic_rd_reg | addr_atomic_rd & dcc_exrdreqval) & dreq & idle_st;
        mvp_register #(1) _read_lock_hold(read_lock_hold, gclk, read_lock);
        assign write_lock = wr_buf_tag_b[2] & wreq_a;

	assign dcc_exaddr_mx[31:2] = (dcc_exaddr_sel || dmbinvoke) ? dcc_exaddr_ev[31:2] : dcc_exaddr[31:2];
	
	assign biu_mbtag[23:2] = daddr_w[31:10];
	mvp_register #(1) _dcc_ev_kill_reg(dcc_ev_kill_reg,gclk, dcc_ev_kill);
	//st_hit_wrb, address match phase of dcc_newaddr
	//dcc_ev_kill,data check phase of dcc_exdata/st_hit_wrb_reg and dcc_ev_kill are the same cycle. 

	assign wr_buf_tag_f [31:0] = ld_wr_buf_tag ? {daddr_w[31:4], 1'b0, addr_atomic_wr, daddr_w[1], dcached_reg & dcc_ev_kill_reg? 1'b0 : 1'b1} : 
			      {wr_buf_tag_f_reg[31:1],	move2back || greset ? 1'b0 : wr_buf_tag_f_reg[0] & !dcc_ev_kill_reg}; 

	mvp_cregister_wide #(32) _wr_buf_tag_f_reg_31_0_(wr_buf_tag_f_reg[31:0],gscanenable, (ld_wr_buf_tag || move2back || dcc_ev_kill_reg || greset), 
						  gclk, wr_buf_tag_f);
	mvp_mux2 #(128) _wr_buf_b_127_0_(wr_buf_b[127:0],move2back, wr_buf_b_reg, wr_buf_f);
	mvp_cregister_wide #(128) _wr_buf_b_reg_127_0_(wr_buf_b_reg[127:0],gscanenable, move2back, gclk, wr_buf_b);
	assign wr_buf_tag_b [31:0] = move2back ? {wr_buf_tag_f_reg[31:1], wr_buf_tag_f_reg[0] & !dcc_ev_kill_reg} : {wr_buf_tag_b_reg[31:1], wreq_done ? 1'b0 : wr_buf_tag_b_reg[0]};
	mvp_cregister_wide #(32) _wr_buf_tag_b_reg_31_0_(wr_buf_tag_b_reg[31:0],gscanenable, (move2back || wreq_done), gclk, wr_buf_tag_b[31:0]);
	
	mvp_mux2 #(16) _wr_buf_vld_b_15_0_(wr_buf_vld_b[15:0],move2back, wr_buf_vld_b_reg, wr_buf_vld_f_reg & {16{~dcc_ev_kill_reg}});
	mvp_cregister_wide #(16) _wr_buf_vld_b_reg_15_0_(wr_buf_vld_b_reg[15:0],gscanenable, move2back, gclk, wr_buf_vld_b);
	// WTB Full signal.  Stall dc_ctl because the WTB is full
	assign biu_wtbf = wr_buf_tag_b[0] && wr_buf_tag_f[0] && (!st_hit_wrb || !dcc_excached);
	assign biu_nofreebuff = wr_buf_tag_b[0] && wr_buf_tag_f[0]; // used by dcc to stall an eviction until
							     // there is a free buffer to put it in
  	assign biu_pm_wr_buf_b = wr_buf_tag_b[0];	//used by performance counters
	assign biu_pm_wr_buf_f = wr_buf_tag_f[0];
 
	// Write control lines for WTB
	assign raw_ld_wr_buf_data [15:0] = { {4{  dcc_exaddr_mx[3] &  dcc_exaddr_mx[2] }} & dcc_exbe[3:0],
				      {4{  dcc_exaddr_mx[3] & ~dcc_exaddr_mx[2] }} & dcc_exbe[3:0],
				      {4{ ~dcc_exaddr_mx[3] &  dcc_exaddr_mx[2] }} & dcc_exbe[3:0],
				      {4{ ~dcc_exaddr_mx[3] & ~dcc_exaddr_mx[2] }} & dcc_exbe[3:0] };

	mvp_cregister_wide #(16) _raw_ld_wr_buf_data_reg_15_0_(raw_ld_wr_buf_data_reg[15:0],gscanenable, dcc_exnewaddr, gclk, raw_ld_wr_buf_data);
	
	assign ld_wr_buf_data [15:0] = raw_ld_wr_buf_data_reg & {16{dcc_exwrreqval}};
   
	assign ld_wr_buf_tag = dcc_exwrreqval && !greset;

	// Look at the current byte enables for the word we are writing to
	// to determine if we are merging or not
	mvp_mux4 #(1) _merging(merging,dcc_exaddr[3:2], |wr_buf_vld_f[3:0], |wr_buf_vld_f[7:4],
			    |wr_buf_vld_f[11:8], |wr_buf_vld_f[15:12]);
	assign ill_merge = !biu_merging && merging;
	
	assign wr_buf_addr_match = (wr_buf_tag_f[31:4] == dcc_exaddr[31:4]) && 
			    wr_buf_tag_f[0];
	mvp_register #(1) _wr_buf_addr_match_reg(wr_buf_addr_match_reg, gclk, wr_buf_addr_match);

	assign st_hit_wrb = (wr_buf_addr_match && !ill_merge) && !dcc_exaddr_sel;
	mvp_cregister #(1) _st_hit_wrb_reg(st_hit_wrb_reg,dcc_exnewaddr, gclk, st_hit_wrb);

	assign move2back = ((((cached_store && !dcc_exaddr_sel_reg) && !st_hit_wrb_reg) || 
		      flush_wrb || full_line_flush) && 
		     (!(wr_buf_tag_b_reg[0]) || wreq_done)) || 
		    dcc_ev_force_move_reg || greset_active;
	mvp_register #(1) _dcc_exaddr_sel_reg(dcc_exaddr_sel_reg, gclk, dcc_exaddr_sel);
	// for an eviction, if the front buffer is valid, move2back on the first word evicted
	assign dcc_ev_force_move = wr_buf_tag_f[0] && dcc_exaddr_sel && !dcc_exaddr_sel_reg;
	mvp_register #(1) _dcc_ev_force_move_reg(dcc_ev_force_move_reg, gclk, dcc_ev_force_move);
	// External address selection:
	assign burst_addr_nxt [31:2] = wreq_a ?{wtaddr[31:4], wrb_addr_wd[1:0]} : 
			   	dreq ? 	{daddr[31:4], dword_nxt} : 
			   	ireq ?	{iaddr[31:4], iword_nxt} :
				{30'b0};
	assign burst_htrans_nxt [1:0] = (ea_wr_acc_nxt ||ea_rd_acc_nxt) ? {2'b0} :
				wreq_a ? {1'b1,wrb_htrans_nxt} : 
			   	dreq ? {1'b1,dtrans_nxt} : 
			   	ireq ? {1'b1,itrans_nxt} :
				wreq_redo_single ? {2'b10} :
			   	{2'b0};					

	assign iword_nxt [1:0] = (beat_cnt == 0) ?
		    iaddr[3:2]
		: (change_transfer_reg) ? 
		    (HADDR[3:2] + 2'h1)
		: (
		   iword_nxt_reg [1:0] 
		);

	assign dword_nxt [1:0] = (beat_cnt == 0) ?
		    daddr[3:2]
		: (change_transfer_reg) ? 
		    (HADDR[3:2] + 2'h1)
		: (
		    dword_nxt_reg [1:0] 
		);

	// Reognize the remaining beats of a teminated burst by ERROR response
	// Change it to several single transaction, and most of the last two beats need do it
	// For the first beat of a burst tranaction will automatically resent out
	// So the terminated beat of burst could be No2, No3 and No4.
	assign itrans_nxt = (beat_cnt == 0) ?
		   1'b0 
		: second_error_cycle ?
                   1'b0
                : idle_cycle_follerror && ((beat_cnt == 2'h2) || (beat_cnt == 2'h3)) ?
                   1'b0
		: (change_transfer_reg) ? 
		   1'b1 
		: (
		   itrans_nxt_reg
		);

	assign dtrans_nxt = (beat_cnt == 0) ?
		   1'b0 
		: second_error_cycle ?
                   1'b0
                : idle_cycle_follerror && ((beat_cnt == 2'h2) || (beat_cnt == 2'h3)) ?
                   1'b0
		: (change_transfer_reg) ? 
		   1'b1 
		: (
		   dtrans_nxt_reg
		);

	assign wrb_htrans_nxt = (beat_cnt == 0) ?
		   1'b0 
		 : second_error_cycle ?
                   1'b0
                 : idle_cycle_follerror && ((beat_cnt == 2'h2) || (beat_cnt == 2'h3)) ?
                   1'b0
		: ((change_transfer_reg) & wtburst) ? 
		   1'b1 
		 : (
		   wrb_htrans_nxt_reg
		);

	mvp_cregister #(2) _iword_nxt_reg_1_0_(iword_nxt_reg[1:0],if_enable, gclk, iword_nxt);
	mvp_cregister #(2) _dword_nxt_reg_1_0_(dword_nxt_reg[1:0],if_enable, gclk, dword_nxt);
	mvp_cregister #(1) _itrans_nxt_reg(itrans_nxt_reg,if_enable, gclk, itrans_nxt);
	mvp_cregister #(1) _dtrans_nxt_reg(dtrans_nxt_reg,if_enable, gclk, dtrans_nxt);
	mvp_cregister #(1) _wrb_htrans_nxt_reg(wrb_htrans_nxt_reg,if_enable, gclk, wrb_htrans_nxt);

	assign beat_cnt [1:0] = (ireq_st3 || dreq_st3 || wreq_sta3) ? 2'h3:
			(ireq_st2 || dreq_st2 || wreq_sta2) ? 2'h2:
			(ireq_st1 || dreq_st1 || wreq_sta1) ? 2'h1: 2'h0;

	// Address of I miss
	assign iaddr[33:0] = {icc_exhe, icc_exaddr, icc_exmagicl, icc_excached};

	assign ireq_val = icc_exreqval || uncached_fetch_redo || (ireq_val_reg && !ireq_done);
	mvp_register #(1) _ireq_val_reg(ireq_val_reg, gclk, ireq_val && !greset);

	// Burst all cacheable references
	assign iburst = iaddr[0];
	mvp_register #(1) _iburst_prev(iburst_prev, gclk, iburst);
	// This reference is to EJTAG block rather than memory
	assign imagicl = iaddr[1];
   

	// Address of D load miss
	// {BE[3:0], A[31:2], Magicl, Cacabl}
	// If we are in simple byte enable mode, munge tri-byte cases into full word requests
	assign daddr_munge_w [35:0] = {&{ daddr_w[34:32], ~daddr_w[1]}, 2'b0, 
				&{ daddr_w[35:33], ~daddr_w[1]}, 32'b0} | daddr_w[35:0];
	
	assign daddr[35:0] = dcc_exrdreqval ? daddr_munge_w[35:0] : daddr_reg;
	mvp_cregister_wide #(36) _daddr_reg_35_0_(daddr_reg[35:0],gscanenable, dcc_exrdreqval, gclk, daddr);

	assign dreq_val = dcc_exrdreqval || uncached_load_redo || (dreq_val_reg && !dreq_done);
	mvp_register #(1) _dreq_val_reg(dreq_val_reg, gclk, dreq_val && !greset);
	
	// Burst all cacheable references
	assign dburst = daddr[0];
	mvp_register #(1) _dburst_prev(dburst_prev, gclk, dburst);
	// This reference is to EJTAG block rather than memory
	assign dmagicl = daddr[1];


	assign wtaddr [31:4] = wr_buf_tag_b[31:4];

	// Back WTB entry is valid- write back to memory
	assign wrreq_val = wr_buf_tag_b[0] && (!wreq_done || move2back);

	// Do a bursted write if we have a full line
	assign wtburst = (&(wr_buf_vld_b[15:0]));

	// This write is to EJTAG space
	assign wtmagicl = wr_buf_tag_b[1];

	// wtmagicl_prev: Once new address phase start on bus capture the mmagicl value.
	mvp_cregister #(1) _wtmagicl_raw(wtmagicl_raw,wreq_sta0 && idle_st || ejt_eadone && if_enable ||greset, gclk,
				 greset || ejt_eadone? 1'b0 : wtmagicl);
	mvp_cregister #(1) _wtmagicl_prev(wtmagicl_prev,(wreq_sta0 && idle_st || ejt_eadone || wtmagicl_raw) && change_transfer || greset, 
			 gclk, greset || ejt_eadone? 1'b0 :  wtmagicl);  
	mvp_cregister #(1) _wtmagicl_prev_reg(wtmagicl_prev_reg,if_enable, gclk, wtmagicl_prev);

	// Store Allocate pair - WT-WA store
	//  write portion could happen before read portion. Prevent read from flushing write.

	mvp_cregister #(1) _st_alloc_pairn(st_alloc_pairn,dcc_exwrreqval || dcc_exrdreqval, gclk, 
				   dcc_stalloc && dcc_exwrreqval && !dcc_exrdreqval);

	// WTB Flush control:
	// Flush the WTB buffer on Syncs, Uncached Stores, and loads hitting in the WTB
	// Syncs stall until write is done
	assign ld_hit_flush = wr_buf_addr_match_reg && dcc_exrdreqval && !st_alloc_pairn;
	assign flush_start = ld_hit_flush || (sync) || ucs_or_sync;
	assign flush_wrb = flush_start || hold_flush_wrb;
	assign hold_flush_wrb = (flush_wrb_reg && !flush_done);
	mvp_register #(1) _flush_wrb_reg(flush_wrb_reg, gclk, flush_wrb); 
	mvp_register #(1) _flush_front(flush_front, gclk, ((flush_start || flush_front) && !move2back));

	//sync_reg: write triggered by sync 
	mvp_register #(1) _sync_reg(sync_reg,gclk, greset ? 1'b0 : sync && move2back && wr_buf_tag_b[0] || 
				sync && wr_buf_tag_f[0] ||
				(sync_reg && !flush_done));
	//sync_hold: sync detected write on the bus
        mvp_register #(1) _sync_hold(sync_hold,gclk, greset? 1'b0 : (wrreq_val||wreq_a||wreq_d||wreq_std_d) &&
			(sync || sync_hold));

	assign flush_done = !flush_front && (!wr_buf_tag_b_reg[0] || wreq_done);

	// Waiting for finish write 
	assign ww_nxt = sync || ww && flush_wrb || sync_hold  && (wrreq_val||wreq_a||wreq_d||wreq_std_d) ;
	
	mvp_cregister #(1) _ww(ww,if_enable, gclk, ww_nxt && !greset);
   


	// Address for AHB or EJTAG
	assign new_addr = (ireq || dreq || wreq_a ) && change_transfer || greset_active;
	assign new_addr_ej = ireq || dreq || wreq_a  || greset_active;
	assign new_htrans = (idle_st || ireq || dreq || wreq_a || biu_shutdown_idle ) && 
			change_transfer || HRESP && if_enable || greset_active;

	// AHB outputs		
	//HCLK = gclk;
	mvp_cregister #(1) _greset_reg(greset_reg,if_enable, gclk, greset);
	assign greset_active = greset && greset_reg && if_enable;
	mvp_register #(1) _greset_n(greset_n,gclk, ~greset? 1'b1 : if_enable ? !greset_reg : greset_n);
	assign HRESETn = greset_n; 

	assign HPROT [3:0] = {3'b001, !opcode_fetch};
	mvp_cregister_wide #(32) _HADDR_31_0_(HADDR[31:0],gscanenable, new_addr, gclk, {burst_addr_nxt[31:2], be_nxt_address[1:0]});
	mvp_cregister #(1) _HWRITE(HWRITE,new_addr, gclk, wreq_a);
	mvp_cregister #(1) _opcode_fetch(opcode_fetch,new_addr, gclk, ireq);
	//HMASTLOCK asserted by atomic instruction accessing memory
	//HMASTLOCK deasserted by ERROR response of read part of RMW sequence
	mvp_cregister #(1) _lock_hold(lock_hold,(read_lock || write_lock) && new_addr || mastlock_deasserted_fr_err ||greset, gclk, greset ? 1'b0 : read_lock);
	mvp_cregister #(1) _lock_hold_reg(lock_hold_reg,if_enable, gclk, lock_hold & (HREADY & !HRESP || lock_hold_reg) );
        assign mastlock_deasserted_fr_err = lock_hold_reg && first_error_cycle && if_enable;
	
	assign mastlock_deasserted_cond = mastlock_deasserted_fr_err || new_addr && write_lock;
	mvp_cregister #(1) _mastlock_deasserted(mastlock_deasserted, HREADY && if_enable || mastlock_deasserted_cond || greset, gclk, greset ? 1'b0 : 
				mastlock_deasserted_cond ? 1'b1 : 1'b0);
	mvp_cregister #(1) _HMASTLOCK(HMASTLOCK,new_addr || mastlock_deasserted && if_enable, gclk, 
			greset_active ? 1'b0 
			: mastlock_deasserted ? mastlock_deasserted & !HREADY 
			: ( lock_hold | read_lock ) );

	mvp_cregister #(3) _HBURST_2_0_(HBURST[2:0],new_addr, gclk, {1'b0,burst_nxt,1'b0});
	mvp_cregister #(3) _HSIZE_2_0_(HSIZE[2:0],new_addr, gclk, {1'b0, be_nxt_size});
	mvp_cregister_wide #(4) _biu_be_ej_3_0_(biu_be_ej[3:0],gscanenable, new_addr_ej, gclk, be_nxt[3:0]);

	mvp_cregister #(2) _HTRANS_1_0_(HTRANS[1:0],new_htrans, gclk, {burst_htrans_nxt[1:0] & {2{ ~(first_error_cycle) }}});

	mvp_cregister #(1) _biu_eaaccess(biu_eaaccess,if_enable, gclk, (ea_wr_acc_nxt || ea_rd_acc_nxt) && ea_acc_en);

	assign ea_rd_acc_nxt = ireq && imagicl || dreq && dmagicl;

	assign ea_wr_acc_nxt = wreq_a && wtmagicl;

	// Delay EA access to give spacing between AHB and EJTAG requests
	assign ea_acc_en = !rd_pend_reg && !rd_pend && (!wreq_d || 
			!wreq_std_d && wtmagicl_prev);

	// Reognize the remaining beats of a teminated burst by ERROR response
	// Change the remaing 3rd or 4th beats to single transfer
	assign burst_nxt =  (ireq && iburst  || dreq && dburst || wreq_a && wtburst) && 
		!((HRESP || hresp_reg) && !((beat_cnt == 2'h0) || (beat_cnt == 2'h1)) );

	assign be_nxt [3:0] = wreq_a ? write_be : read_be;
	// HADDR[1:0], HSIZE
	assign be_nxt_address[1:0] =	(&be_nxt)   ? 2'b00 : 
				(be_nxt[3] && be_nxt[2] && cpz_rbigend_e || be_nxt[1] && be_nxt[0] && !cpz_rbigend_e ) ? 2'b00 : 
				(be_nxt[1] && be_nxt[0] && cpz_rbigend_e || be_nxt[3] && be_nxt[2] && !cpz_rbigend_e ) ? 2'b10 :
				(be_nxt[3] && cpz_rbigend_e || be_nxt[0] && !cpz_rbigend_e) ? 2'b00 : 
				(be_nxt[2] && cpz_rbigend_e || be_nxt[1] && !cpz_rbigend_e) ? 2'b01 : 
				(be_nxt[1] && cpz_rbigend_e || be_nxt[2] && !cpz_rbigend_e) ? 2'b10 : 
				(be_nxt[0] && cpz_rbigend_e || be_nxt[3] && !cpz_rbigend_e) ? 2'b11 : 
				2'b00;

	assign be_nxt_size[1:0] = (&be_nxt) ? 2'b10 : (be_nxt[3] && be_nxt[2]) || (be_nxt[1] && be_nxt[0])? 2'b01 :
					|be_nxt ? 2'b00 :
					2'b00;
	// Mask off half of byte enables to ensure a simple BE pattern if in simple byte enable mode
	assign wr_be_mask [3:0] = split_wr_a ? 4'b0011  :
			   split_wr_a2 ? 4'b1100 : 
			   4'b1111;
	assign write_be [3:0] = raw_wr_be & wr_be_mask;
	
	assign raw_wr_be [3:0] =  (wrb_addr_wd == 2'h3) ? wr_buf_vld_b[15:12] :
			(wrb_addr_wd == 2'h2) ? wr_buf_vld_b[11:8]  :
			(wrb_addr_wd == 2'h1) ? wr_buf_vld_b[7:4]   :
					   wr_buf_vld_b[3:0];

	// Only non-cacheable requests can ask for sub-word quanta from bus
	assign read_be [3:0] = (dreq && !dburst) ? daddr[35:32] : 
			(ireq && !iburst) ? {{2{iaddr[33]}}, {2{iaddr[32]}}} : 4'hf;

	// HWDATA only send the data in wreq_d state and triggered by HREADY
	mvp_mux4 #(32) _wr_buf_b2eb_31_0_(wr_buf_b2eb[31:0],wrb_data_wd, wr_buf_b[31:0], wr_buf_b[63:32], wr_buf_b[95:64], wr_buf_b[127:96]);
	mvp_cregister_wide #(32) _wr_buf_b2eb_reg_31_0_(wr_buf_b2eb_reg[31:0],gscanenable, change_transfer, gclk, wr_buf_b2eb);
	//new_data = wreq_d && HREADY ||wreq_std0 && wtmagicl || greset;
	assign new_data = wreq_d && HREADY && if_enable || greset_active;
	mvp_cregister_wide #(32) _HWDATA_31_0_(HWDATA[31:0],gscanenable, new_data, gclk, greset_active? 32'b0 : wr_buf_b2eb_reg);

	// simple byte enable mode: Only allow naturally aligned byte, half, and word accesses
	// If other types are attempted, split into two transactions
	// Illegal BE: 0101, 0110, 0111, 1001, 1010, 1011, 1101, 1110
	// Legal BE: 00xx, xx00, 1111

	assign split_wr0 = |(wr_buf_vld_b[3:2]) & |(wr_buf_vld_b[1:0]) & ~(&(wr_buf_vld_b[3:0]));
	assign split_wr1 = |(wr_buf_vld_b[7:6]) & |(wr_buf_vld_b[5:4]) & ~(&(wr_buf_vld_b[7:4]));
	assign split_wr2 = |(wr_buf_vld_b[11:10]) & |(wr_buf_vld_b[9:8]) & ~(&(wr_buf_vld_b[11:8]));
	assign split_wr3 = |(wr_buf_vld_b[15:14]) & |(wr_buf_vld_b[13:12]) & ~(&(wr_buf_vld_b[15:12]));

	assign split_wr_w0_raw =  ~wtmagicl & (wrb_wd_vld[0] ? split_wr0 :
				      wrb_wd_vld[1] ? split_wr1 :
				      wrb_wd_vld[2] ? split_wr2 :
				      split_wr3);

	mvp_cregister #(1) _split_wr_w0(split_wr_w0,if_enable, gclk, split_wr_w0_raw);
	assign split_wr_w1_raw =  ~wtmagicl & (wrb_wd_vld[0] & wrb_wd_vld[1] ?      split_wr1 :
				       |(wrb_wd_vld[1:0]) & wrb_wd_vld[2] ? split_wr2 :
				       split_wr3);

	mvp_cregister #(1) _split_wr_w1(split_wr_w1,if_enable, gclk, split_wr_w1_raw);
	assign split_wr_w2_raw =  ~wtmagicl & (&(wrb_wd_vld[2:0]) ? split_wr2 :
				       split_wr3);

	mvp_cregister #(1) _split_wr_w2(split_wr_w2,if_enable, gclk, split_wr_w2_raw);
	assign split_wr_w3_raw =  ~wtmagicl & split_wr3;
	mvp_cregister #(1) _split_wr_w3(split_wr_w3,if_enable, gclk, split_wr_w3_raw);
	// Valid words on this write
	assign wrb_wd_vld[3:0] = { |(wr_buf_vld_b[15:12]), 
				    |(wr_buf_vld_b[11:8]),
				    |(wr_buf_vld_b[7:4]),
				    |(wr_buf_vld_b[3:0])} ;

	assign wrb_wd_cnt_nxt [1:0] = wrb_wd_vld[3] + wrb_wd_vld[2] + wrb_wd_vld[1] + wrb_wd_vld[0];
	mvp_cregister #(2) _wrb_wd_cnt_1_0_(wrb_wd_cnt[1:0],if_enable, gclk, wrb_wd_cnt_nxt);
	
	
	assign wrb_word0 [1:0] = wrb_wd_vld[0] ? 2'h0 :
			wrb_wd_vld[1] ? 2'h1 :
			wrb_wd_vld[2] ? 2'h2 :
				     2'h3;

	assign wrb_word1 [1:0] = wrb_wd_vld[0] & wrb_wd_vld[1] ? 2'h1 :
			|(wrb_wd_vld[1:0]) & wrb_wd_vld[2] ? 2'h2 :
			2'h3;

	assign wrb_word2 [1:0] = &(wrb_wd_vld[2:0]) ? 2'h2 :
			2'h3;

	assign wrb_addr_wd [1:0] = (wreq_sta0 | wreq_stas0) ? wrb_word0 :
			 (wreq_sta1 | wreq_stas1) ? wrb_word1 :
			 (wreq_sta2 | wreq_stas2) ? wrb_word2 :
			 2'h3;

	assign wrb_data_wd [1:0] = (wreq_sta0 | wreq_stas0) ? wrb_word0 :
			 (wreq_sta1 | wreq_stas1) ? wrb_word1 :
			 (wreq_sta2 || wreq_stas2) ? wrb_word2 :
			 2'h3;
//
// Request State Machine:
//
	// No requests outstanding.  If WAIT, force it off to prevent any additional reqs
	mvp_cregister #(1) _early_idle(early_idle,if_enable, gclk, !ireq && !dreq && !wreq_a);

	mvp_cregister #(1) _last_addr(last_addr,if_enable, gclk, (ireq_st3 || dreq_st3 || last_write_nxt ||
				  ireq_st0 && !iburst && !imagicl ||
				   dreq_st0 && !dburst && !dmagicl));

	assign last_write_nxt =  (((wreq_sta3 && !split_wr_w3) || wreq_stas3) ||
			  !wtmagicl && 
			  ((wrb_wd_cnt_nxt == 2'h1 && ((wreq_sta0 && !split_wr_w0_raw) || wreq_stas0)) ||
			   (wrb_wd_cnt_nxt == 2'h2 && ((wreq_sta1 && !split_wr_w1_raw) || wreq_stas1)) ||
			   (wrb_wd_cnt_nxt == 2'h3 && ((wreq_sta2 && !split_wr_w2_raw) || wreq_stas2))));
	
	assign idle_st = !mpc_wait_w && (early_idle || (last_addr && (change_transfer_reg))) && !HRESP && if_enable;
	

	// Instruction request states.  Uncached (inc. magical) requests only have 1 beat
	// cacheable always have 4 beats.  Instn fetch is highest priority request type except
	// atomic write operation and sync leading flushing WTB not finish yet
	// ireq_st0 would be restart when it was terminated by ERROR response of prev one 
	
	assign ireq_st0 = (idle_st && ireq_val && ~(wrreq_val && sync_hold) && !sync_retain && !(read_lock || lock_hold) && !wreq_redo_pre) 
			|| ireq_st0_redo ||(ireq_st0_reg && !wreq_redo_pre && 
			(imagicl ? !ejt_eadone : (!change_transfer_reg)) );
	mvp_cregister #(1) _ireq_st0_reg(ireq_st0_reg,if_enable, gclk, ireq_st0 && !greset);

	//ireq_st1 = (hready_reg || htrans_idle_reg && !hresp_reg )? (ireq_st0_reg && iburst) 
	assign ireq_st1 = change_transfer_reg? (ireq_st0_reg && iburst) 
								: ireq_st1_reg && ~hresp_reg;
	mvp_cregister #(1) _ireq_st1_reg(ireq_st1_reg,if_enable, gclk, ireq_st1 && !greset);

	assign ireq_st2 = hready_reg ? ireq_st1_reg : ireq_st2_reg;		
	mvp_cregister #(1) _ireq_st2_reg(ireq_st2_reg,if_enable, gclk, ireq_st2 && !greset);		

	assign ireq_st3 = hready_reg ? ireq_st2_reg : ireq_st3_reg;		
	mvp_cregister #(1) _ireq_st3_reg(ireq_st3_reg,if_enable, gclk, ireq_st3 && !greset);		

	assign ireq = ireq_st0 || ireq_st1 || ireq_st2 || ireq_st3;

	assign ireq_done = (ireq_st3_reg || (ireq_st0_reg && !iburst && !HRESP )) &&
			 (imagicl ? ejt_eadone : change_transfer_reg);
	//ireq_st0_redo = cregister(if_enable, gclk, ireq_st0_reg && first_error_cycle);
	assign ireq_st0_redo = 1'b0;

	assign uncached_fetch_redo = !iburst_prev && ireq_a_st0_reg && !hready_reg && second_error_cycle;

	// Data read request states.  Uncached (inc. magical) requests only have 1 beat
	// cacheable always have 4.  Data read is lowest priority
	// ireq_st0 would be restart when it was terminated by ERROR response of prev one 
	assign dreq_st0 = (idle_st && !ireq_val && !wrreq_val && dreq_val && !(ld_hit_flush || hold_flush_wrb) && !wreq_redo_pre) || 
			dreq_st0_redo || (dreq_st0_reg && !wreq_redo_pre &&  
			(dmagicl ? !ejt_eadone : ( !change_transfer_reg)) );
	mvp_cregister #(1) _dreq_st0_reg(dreq_st0_reg,if_enable, gclk, dreq_st0 && !greset);

	//dreq_st1 = ( hready_reg || htrans_idle_reg && !hresp_reg ) ? (dreq_st0_reg && dburst) 
	assign dreq_st1 = change_transfer_reg ? (dreq_st0_reg && dburst) 
						: dreq_st1_reg && ~hresp_reg;
	mvp_cregister #(1) _dreq_st1_reg(dreq_st1_reg,if_enable, gclk, dreq_st1 && !greset);

	assign dreq_st2 = hready_reg? dreq_st1_reg : dreq_st2_reg;		
	mvp_cregister #(1) _dreq_st2_reg(dreq_st2_reg,if_enable, gclk, dreq_st2 && !greset);		

	assign dreq_st3 = hready_reg? dreq_st2_reg : dreq_st3_reg;		
	mvp_cregister #(1) _dreq_st3_reg(dreq_st3_reg,if_enable, gclk, dreq_st3 && !greset);		

	assign dreq = dreq_st0 || dreq_st1 || dreq_st2 || dreq_st3;

	assign dreq_done = (dreq_st3_reg || (dreq_st0_reg && !dburst && !HRESP)) && 
			(dmagicl ? ejt_eadone && if_enable : change_transfer_reg);

	//dreq_st0_redo = cregister(if_enable, gclk, dreq_st0_reg && first_error_cycle);
	assign dreq_st0_redo = 1'b0;
	assign uncached_load_redo = !dburst_prev && dreq_a_st0_reg && !hready_reg && second_error_cycle;

	// Write request states.  Depending on amount of write gathering 
	// There can be 1-8 write requests.  Address and data states progress
	// wreq_d_done_sync: done signal for sync-like operation, data has been accepted 
	assign wreq_d_done_sync = wtmagicl_prev &&  ejt_eadone && if_enable && wreq_std0 || HREADY && if_enable && 
                             ((wrb_wd_cnt == 2'h1) ? split_wr_w0 ? wreq_stds_d_0 : wreq_std_d_0 :
                              (wrb_wd_cnt == 2'h2) ? split_wr_w1 ? wreq_stds_d_1 : wreq_std_d_1 :
                              (wrb_wd_cnt == 2'h3) ? split_wr_w2 ? wreq_stds_d_2 : wreq_std_d_2 :
                                               split_wr_w3 ? wreq_stds_d_3 : wreq_std_d_3);

	// wreq_d_done: done signal for normal write operation, address would be sent out
	assign wreq_d_done = ejt_eadone  && if_enable && wreq_std0
                                || !wtmagicl_prev && htrans_idle_reg && (wrb_wd_cnt == 2'h1) && !split_wr_w0 && wreq_std0 && if_enable
                                || !wtmagicl_prev && hready_reg && if_enable && 
		     ((wrb_wd_cnt == 2'h1) ? split_wr_w0 ? wreq_stds0 : wreq_std0 :
		      (wrb_wd_cnt == 2'h2) ? split_wr_w1 ? wreq_stds1 : wreq_std1 :
		      (wrb_wd_cnt == 2'h3) ? split_wr_w2 ? wreq_stds2 : wreq_std2 :
				       split_wr_w3 ? wreq_stds3 : wreq_std3);

	// sync operation was waiting for the data sent back
	mvp_cregister #(1) _wreq_d_done_sync_qf(wreq_d_done_sync_qf,if_enable, gclk, greset? 1'b0 : (sync_qf_period && (wreq_d_done || wreq_d_done_sync_qf)));


	// WREQ address phase prepare

	// s states are the 2nd part of split transactions in simple byte enable mode
	// wreq_sta0 would be restart when it was terminated by ERROR response of prev one 
	// wreq_sta0 must assure the transaction would not be sent out again during the period
	// waiting for the data phase sent out for sync-leading writing transaction
	assign wreq_sta0 = (idle_st && !(ireq_val && !sync_retain && !(read_lock || lock_hold) && !sync_hold) && 
			wrreq_val && !(sync_retain && !wreq_done && !wreq_redo_single_std0) ) && 
			!wreq_redo_single || wreq_sta0_redo ||
		   	(wreq_sta0_reg && (wtmagicl_prev ? !ejt_eadone : !change_transfer_reg ) && !wreq_redo_single);
	mvp_cregister #(1) _wreq_sta0_reg(wreq_sta0_reg,if_enable, gclk, wreq_sta0 && !greset);

	mvp_cregister #(1) _sync_retain(sync_retain,if_enable, gclk, greset? 1'b0 : (sync_reg|sync) && wreq_sta0 || (sync_retain & !wreq_done)); 

	assign wreq_stas0 = change_transfer_reg ? (wreq_sta0_reg && split_wr_w0) : wreq_stas0_reg && !hresp_reg;
	mvp_cregister #(1) _wreq_stas0_reg(wreq_stas0_reg,if_enable, gclk, wreq_stas0 && !greset);
		     
	assign wreq_sta1 = change_transfer_reg ? 
				(((wreq_sta0_reg && !split_wr_w0) || wreq_stas0_reg)  && !(wrb_wd_cnt == 2'h1)) :
				 wreq_sta1_reg && !hresp_reg;
	mvp_cregister #(1) _wreq_sta1_reg(wreq_sta1_reg,if_enable, gclk, wreq_sta1 && !greset);

	assign wreq_stas1 = hready_reg ? (wreq_sta1_reg && split_wr_w1) : wreq_stas1_reg;
	mvp_cregister #(1) _wreq_stas1_reg(wreq_stas1_reg,if_enable, gclk, wreq_stas1 && !greset);

	assign wreq_sta2 = hready_reg ? (((wreq_sta1_reg && !split_wr_w1) || wreq_stas1_reg)
				   && !(wrb_wd_cnt == 2'h2)) : wreq_sta2_reg;
	mvp_cregister #(1) _wreq_sta2_reg(wreq_sta2_reg,if_enable, gclk, wreq_sta2 && !greset);

	assign wreq_stas2 = hready_reg ? (wreq_sta2_reg && split_wr_w2) : wreq_stas2_reg;
	mvp_cregister #(1) _wreq_stas2_reg(wreq_stas2_reg,if_enable, gclk, wreq_stas2 && !greset);

	assign wreq_sta3 = hready_reg? (((wreq_sta2_reg && !split_wr_w2) || wreq_stas2_reg)
				   && !(wrb_wd_cnt == 2'h3)) : wreq_sta3_reg;
	mvp_cregister #(1) _wreq_sta3_reg(wreq_sta3_reg,if_enable, gclk, wreq_sta3 && !greset);

	assign wreq_stas3 = hready_reg? (wreq_sta3_reg && split_wr_w3) : wreq_stas3_reg;
	mvp_cregister #(1) _wreq_stas3_reg(wreq_stas3_reg,if_enable, gclk, wreq_stas3 && !greset);

	mvp_cregister #(1) _wreq_sta0_redo(wreq_sta0_redo,if_enable, gclk, (wreq_sta1 || wreq_stas0) && first_error_cycle && !greset);
	assign wreq_redo_pre = wreq_std0_reg && second_error_cycle;	
	assign wreq_redo_single = wreq_redo_pre && !( wreq_stas0_reg || wreq_sta1_reg) && !wtmagicl_prev_reg;
	mvp_cregister #(1) _wreq_redo_single_std0(wreq_redo_single_std0,if_enable,gclk, wreq_redo_single && !greset);
	mvp_cregister #(1) _wreq_redo_single_std0_reg(wreq_redo_single_std0_reg,if_enable,gclk, wreq_redo_single_std0 && !greset);

	assign wreq_redo_single_std_d_0 = hready_reg ? wreq_redo_single_std0_reg :
						wreq_redo_single_std_d_0_reg;

	mvp_cregister #(1) _wreq_redo_single_std_d_0_reg(wreq_redo_single_std_d_0_reg,if_enable,gclk, wreq_redo_single_std_d_0 && !greset);



	//End of wreq_sta
	//WREQ data phase prepare 

	assign wreq_std0 = change_transfer_reg ? wreq_sta0_reg : wreq_std0_reg;
	mvp_cregister #(1) _wreq_std0_reg(wreq_std0_reg,if_enable, gclk, wreq_std0 && !greset);

	assign wreq_stds0 = hready_reg ? wreq_stas0_reg  : wreq_stds0_reg;
	mvp_cregister #(1) _wreq_stds0_reg(wreq_stds0_reg,if_enable, gclk, wreq_stds0 && !greset);
		     
	assign wreq_std1 = hready_reg ? wreq_sta1_reg :  wreq_std1_reg ;
	mvp_cregister #(1) _wreq_std1_reg(wreq_std1_reg,if_enable, gclk, wreq_std1 && !greset);

	assign wreq_stds1 = hready_reg ? wreq_stas1_reg  : wreq_stds1_reg;
	mvp_cregister #(1) _wreq_stds1_reg(wreq_stds1_reg,if_enable, gclk, wreq_stds1 && !greset);

	assign wreq_std2 = hready_reg ? wreq_sta2_reg  : wreq_std2_reg;
	mvp_cregister #(1) _wreq_std2_reg(wreq_std2_reg,if_enable, gclk, wreq_std2 && !greset);

	assign wreq_stds2 = hready_reg ? wreq_stas2_reg : wreq_stds2_reg;
	mvp_cregister #(1) _wreq_stds2_reg(wreq_stds2_reg,if_enable, gclk, wreq_stds2 && !greset);

	assign wreq_std3 = hready_reg ? wreq_sta3_reg : wreq_std3_reg;
	mvp_cregister #(1) _wreq_std3_reg(wreq_std3_reg,if_enable, gclk, wreq_std3 && !greset);

	assign wreq_stds3 = hready_reg? wreq_stas3_reg :  wreq_stds3_reg;
	mvp_cregister #(1) _wreq_stds3_reg(wreq_stds3_reg,if_enable, gclk, wreq_stds3 && !greset);

	// End of wreq_std

	// Real data broadcast period

	assign wreq_std_d_0 = hready_reg && wtmagicl_prev_reg ? 1'b0 :
		       hready_reg && !wtmagicl_prev_reg?  wreq_std0_reg :
							 wreq_std_d_0_reg;

	mvp_cregister #(1) _wreq_std_d_0_reg(wreq_std_d_0_reg,if_enable, gclk, wreq_std_d_0 && !greset);

	assign wreq_stds_d_0 = hready_reg ? wreq_stds0_reg  : wreq_stds_d_0_reg;
	mvp_cregister #(1) _wreq_stds_d_0_reg(wreq_stds_d_0_reg,if_enable, gclk, wreq_stds_d_0 && !greset);
		     
	assign wreq_std_d_1 = hready_reg ? wreq_std1_reg :  wreq_std_d_1_reg;
	mvp_cregister #(1) _wreq_std_d_1_reg(wreq_std_d_1_reg,if_enable, gclk, wreq_std_d_1 && !greset);

	assign wreq_stds_d_1 = hready_reg ? wreq_stds1_reg  : wreq_stds_d_1_reg;
	mvp_cregister #(1) _wreq_stds_d_1_reg(wreq_stds_d_1_reg,if_enable, gclk, wreq_stds_d_1 && !greset);

	assign wreq_std_d_2 = hready_reg ? wreq_std2_reg  : wreq_std_d_2_reg;
	mvp_cregister #(1) _wreq_std_d_2_reg(wreq_std_d_2_reg,if_enable, gclk, wreq_std_d_2 && !greset);

	assign wreq_stds_d_2 = hready_reg ? wreq_stds2_reg : wreq_stds_d_2_reg;
	mvp_cregister #(1) _wreq_stds_d_2_reg(wreq_stds_d_2_reg,if_enable, gclk, wreq_stds_d_2 && !greset);

	assign wreq_std_d_3 = hready_reg ? wreq_std3_reg : wreq_std_d_3_reg;
	mvp_cregister #(1) _wreq_std_d_3_reg(wreq_std_d_3_reg,if_enable, gclk, wreq_std_d_3 && !greset);

	assign wreq_stds_d_3 = hready_reg? wreq_stds3_reg :  wreq_stds_d_3_reg;
	mvp_cregister #(1) _wreq_stds_d_3_reg(wreq_stds_d_3_reg,if_enable, gclk, wreq_stds_d_3 && !greset);

	// End of wreq_std_d

	assign wreq_std_d = wreq_std_d_0 || wreq_std_d_1 ||wreq_std_d_2 ||wreq_std_d_3 ||
			wreq_stds_d_0 || wreq_stds_d_1 ||wreq_stds_d_2 ||wreq_stds_d_3 ;
	assign wreq_std_d_reg = wreq_std_d_0_reg || wreq_std_d_1_reg ||wreq_std_d_2_reg ||wreq_std_d_3_reg ||
			wreq_stds_d_0_reg  ||wreq_stds_d_1_reg  ||wreq_stds_d_2_reg  ||wreq_stds_d_3_reg ; 

	assign wreq_a = wreq_sta0 || wreq_sta1 || wreq_sta2 || wreq_sta3 ||
		 wreq_stas0 || wreq_stas1 || wreq_stas2 || wreq_stas3;

	assign split_wr_a = wreq_sta0 && split_wr_w0_raw || wreq_sta1 && split_wr_w1_raw ||
		     wreq_sta2 && split_wr_w2_raw || wreq_sta3 && split_wr_w3_raw;
	
	assign split_wr_a2 = wreq_stas0 || wreq_stas1 || wreq_stas2 || wreq_stas3;

	assign wreq_d = wreq_std0 || wreq_std1 || wreq_std2 || wreq_std3 ||
		 wreq_stds0 || wreq_stds1 || wreq_stds2 || wreq_stds3;

	assign sync_qf_period =  sync_retain;
	assign wreq_done = sync_qf_period ? wreq_d_done_sync && (wreq_d_done || wreq_d_done_sync_qf) : wreq_d_done ;
	
	// Data Return Loginc
	// ireq_data_std state
	assign ireq_a_st0 = (!imagicl && change_transfer_reg) ? ireq_st0_reg : ireq_a_st0_reg;
	mvp_cregister #(1) _ireq_a_st0_reg(ireq_a_st0_reg,if_enable, gclk, ireq_a_st0 && !greset);

	assign ireq_d_st0 = hready_reg ? ireq_a_st0_reg  : ireq_d_st0_reg;
	mvp_cregister #(1) _ireq_d_st0_reg(ireq_d_st0_reg,if_enable, gclk, ireq_d_st0 && !greset);
		     
	assign ireq_a_st1 = hready_reg ? ireq_st1_reg :  ireq_a_st1_reg;
	mvp_cregister #(1) _ireq_a_st1_reg(ireq_a_st1_reg,if_enable, gclk, ireq_a_st1 && !greset);

	assign ireq_d_st1 = hready_reg ? ireq_a_st1_reg  : ireq_d_st1_reg;
	mvp_cregister #(1) _ireq_d_st1_reg(ireq_d_st1_reg,if_enable, gclk, ireq_d_st1 && !greset);

	assign ireq_a_st2 = hready_reg ? ireq_st2_reg  : ireq_a_st2_reg;
	mvp_cregister #(1) _ireq_a_st2_reg(ireq_a_st2_reg,if_enable, gclk, ireq_a_st2 && !greset);

	assign ireq_d_st2 = hready_reg ? ireq_a_st2_reg : ireq_d_st2_reg;
	mvp_cregister #(1) _ireq_d_st2_reg(ireq_d_st2_reg,if_enable, gclk, ireq_d_st2 && !greset);

	assign ireq_a_st3 = hready_reg ? ireq_st3_reg : ireq_a_st3_reg;
	mvp_cregister #(1) _ireq_a_st3_reg(ireq_a_st3_reg,if_enable, gclk, ireq_a_st3 && !greset);

	assign ireq_d_st3 = hready_reg? ireq_a_st3_reg :  ireq_d_st3_reg;
	mvp_cregister #(1) _ireq_d_st3_reg(ireq_d_st3_reg,if_enable, gclk, ireq_d_st3 && !greset);
	
	// End of ireq_data_std
	// dreq_data_std state

	assign dreq_a_st0 = (!dmagicl && change_transfer_reg) ? dreq_st0_reg : dreq_a_st0_reg;
	mvp_cregister #(1) _dreq_a_st0_reg(dreq_a_st0_reg,if_enable, gclk, dreq_a_st0 && !greset);

	assign dreq_d_st0 = hready_reg ? dreq_a_st0_reg  : dreq_d_st0_reg;
	mvp_cregister #(1) _dreq_d_st0_reg(dreq_d_st0_reg,if_enable, gclk, dreq_d_st0 && !greset);
		     
	assign dreq_a_st1 = hready_reg ? dreq_st1_reg :  dreq_a_st1_reg;
	mvp_cregister #(1) _dreq_a_st1_reg(dreq_a_st1_reg,if_enable, gclk, dreq_a_st1 && !greset);

	assign dreq_d_st1 = hready_reg ? dreq_a_st1_reg  : dreq_d_st1_reg;
	mvp_cregister #(1) _dreq_d_st1_reg(dreq_d_st1_reg,if_enable, gclk, dreq_d_st1 && !greset);

	assign dreq_a_st2 = hready_reg ? dreq_st2_reg  : dreq_a_st2_reg;
	mvp_cregister #(1) _dreq_a_st2_reg(dreq_a_st2_reg,if_enable, gclk, dreq_a_st2 && !greset);

	assign dreq_d_st2 = hready_reg ? dreq_a_st2_reg : dreq_d_st2_reg;
	mvp_cregister #(1) _dreq_d_st2_reg(dreq_d_st2_reg,if_enable, gclk, dreq_d_st2 && !greset);

	assign dreq_a_st3 = hready_reg ? dreq_st3_reg : dreq_a_st3_reg;
	mvp_cregister #(1) _dreq_a_st3_reg(dreq_a_st3_reg,if_enable, gclk, dreq_a_st3 && !greset);

	assign dreq_d_st3 = hready_reg? dreq_a_st3_reg :  dreq_d_st3_reg;
	mvp_cregister #(1) _dreq_d_st3_reg(dreq_d_st3_reg,if_enable, gclk, dreq_d_st3 && !greset);
	
	// End of dreq_data_std

	assign ireq_a =  ireq_a_st0 || ireq_a_st1 || ireq_a_st2 || ireq_a_st3;
	assign ireq_d =  ireq_d_st0 || ireq_d_st1 || ireq_d_st2 || ireq_d_st3;
	assign ireq_d_reg =  ireq_d_st0_reg || ireq_d_st1_reg || ireq_d_st2_reg || ireq_d_st3_reg;
	assign dreq_a =  dreq_a_st0 || dreq_a_st1 || dreq_a_st2 || dreq_a_st3;
	assign dreq_d =  dreq_d_st0 || dreq_d_st1 || dreq_d_st2 || dreq_d_st3;
	assign dreq_d_reg =  dreq_d_st0_reg || dreq_d_st1_reg || dreq_d_st2_reg || dreq_d_st3_reg;
	assign rd_databack = (ireq_d || dreq_d ) && HREADY && !hresp_reg;
	assign rd_pend = ireq_d || dreq_d ;
	mvp_cregister #(1) _rd_pend_reg(rd_pend_reg,if_enable, gclk, rd_pend);

	mvp_cregister #(1) _ea_ireq(ea_ireq,if_enable, gclk, ireq);
	mvp_cregister #(1) _ea_read(ea_read,if_enable || greset, gclk, ~greset && ea_rd_acc_nxt && ea_acc_en);
	mvp_cregister #(2) _haddr_3_2_reg_1_0_(haddr_3_2_reg[1:0],HREADY & if_enable, gclk, HADDR[3:2]);
	mvp_cregister #(2) _haddr_3_2_reg_reg_1_0_(haddr_3_2_reg_reg[1:0],HREADY & if_enable | greset, gclk, {2{~greset}} & haddr_3_2_reg);

	assign biu_datain[31:0] = ea_read ? ejt_eadata : hrdata_reg[31:0];

	mvp_cregister #(2) _addr_reg_3_2_(addr_reg[3:2],if_enable, gclk, burst_addr_nxt[3:2]);
	assign biu_datawd[1:0] =  ea_read ? addr_reg[3:2] : haddr_3_2_reg_reg[1:0];
	// Ignore the data back for the transaction follow with ERROR transaction
	assign biu_idataval = ea_read ? (ea_ireq && ejt_eadone && if_enable) : (ireq_d_reg && hready_reg && (hresp_reg || !hresp_reg_reg) && if_enable); 

	assign biu_ddataval = ea_read ? (!ea_ireq && ejt_eadone && if_enable) : (dreq_d_reg && hready_reg && (hresp_reg || !hresp_reg_reg) && if_enable);

	assign biu_lastwd  = ea_read || ((!iburst_prev && ireq_d_st0_reg) || ireq_d_st3_reg) && hready_reg || 
		((!dburst_prev && dreq_d_st0_reg) || dreq_d_st3_reg) && hready_reg;


	// All D  Requests are done:  Used for releasing a sync
	assign biu_dreqsdone = !dreq_val && !ww_nxt && if_enable;

//
// BusError Reporting
//

	assign biu_ibe = ireq_d_reg && hresp_reg && if_enable;
	assign biu_ibe_exc = biu_ibe && !hresp_reg_reg; 

	mvp_cregister #(1) _biu_ibe_reg(biu_ibe_reg,if_enable, gclk, biu_ibe);
	assign biu_ibe_pre = biu_ibe_reg & if_enable;

	assign biu_wbe = (wreq_std_d_reg || wreq_redo_single_std_d_0_reg) && hresp_reg && !hresp_reg_reg && if_enable;

	assign biu_dbe = dreq_d_reg && hresp_reg && if_enable;
	assign biu_dbe_exc = biu_dbe && !hresp_reg_reg;
	mvp_cregister #(1) _biu_dbe_reg(biu_dbe_reg,if_enable, gclk, biu_dbe);
	assign biu_dbe_pre = biu_dbe_reg & if_enable;

// Assertion check: Monitor on AHB Bus


endmodule	// m14k_biu

