// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
// mvp Version 2.24
// cmd line +define: MIPS_VMC_DUAL_INST
////////////////////////////////////////////////////////////////////////////////
//
//	Description: cpz_pc
//		ALU cp0 performance counter logic
//
//	$Id: \$
//	mips_repository_id: m14k_cpz_pc.mv, v 1.15 
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
////////////////////////////////////////////////////////////////////////////////

module m14k_cpz_pc(
	gclk,
	gfclk,
	greset,
	gscanenable,
	cpz_goodnight,
	cpz_vz,
	cpz_gm,
	cpz_dm,
	status,
	g_status,
	pc_ctl_we,
	pc_cnt_we,
	cpz,
	pc_cnt_evt,
	pc_ctl_reg,
	pc_cnt_reg,
	pc_ctl_ec,
	r_pc_int,
	g_pc_int);


input gclk;
input gfclk;
input greset;
input gscanenable;
input cpz_goodnight;
//input tc_in_erldm;
//input tc_in_exl;
//input tc_in_kernel;
//input tc_in_super;
//input tc_in_user;
input cpz_vz;
input cpz_gm; // Root.GuestCtl0[31], GM
input cpz_dm; // Root.Debug[30], DM
input [4:1] status; // Root.Status[4:1], {KSU[1:0], ERL, EXL}
input [4:1] g_status; // Guest.Status[4:1], {KSU[1:0], ERL, EXL}
//input cp0_pc_ctl_wr_en; // instruction based write enable for pc ctl reg
//input cp0_pc_cnt_wr_en; // instruction based write enable for pc count reg
//input [31:0] alu_cp0_wdata_er; // write data
input pc_ctl_we; // instruction based write enable for pc ctl reg
input pc_cnt_we; // instruction based write enable for pc count reg
input [31:0] cpz; // write data
input [255:0] pc_cnt_evt;
output [31:0] pc_ctl_reg;
output [31:0] pc_cnt_reg;
output [1:0] pc_ctl_ec;
//output pc_en_mask_xx;
output r_pc_int;
output g_pc_int;

// BEGIN Wire declarations made by MVP
wire [10:0] /*[10:0]*/ pc_ctl_rega;
wire pc_cnt_evt_inc_en;
wire pc_ctl_ie;
wire pc_ctl_u;
wire pc_ctl_exl;
wire pc_cnt_mod_en0;
wire r_pc_int;
wire pc_ctl_k;
wire pc_en_mask_xx_nxt;
wire pc_cnt_mod_en1;
wire [1:0] /*[1:0]*/ pc_ctl_ec;
wire pc_cnt_mod_en2;
wire [7:0] /*[7:0]*/ pc_ctl_evt;
wire pc_en_mask_xx;
wire pc_cnt_mod_en3;
wire [31:0] /*[31:0]*/ pc_ctl_reg;
wire vz_visible;
wire [31:0] /*[31:0]*/ pc_cnt_inc;
wire ignor_mode;
wire g_pc_int;
wire hw_pc_cnt_wr_en;
wire pc_ctl_s;
wire any_tc_enabled;
wire [2:0] /*[2:0]*/ pc_ctl_regb;
wire [7:0] /*[7:0]*/ pc_ctl_evt_reg;
wire [255:0] /*[255:0]*/ pc_cnt_evt_reg;
wire [31:0] /*[31:0]*/ pc_cnt_reg;
wire cntgate;
wire enabled_1_hot;
// END Wire declarations made by MVP


parameter NXT_COUNTER=1'b1;
parameter ERL=2; 
parameter EXL=1;

//------------------------------------------------------------------------------
//performance counter register (reg 25, sel even)
//------------------------------------------------------------------------------
//  3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
//  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
// +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
// | |           | E |                   |               |I| | | |E|
// |M|           | C |                   |     Event     |E|U|S|K|X| PerfCnt
// | |           |   |                   |               | | | | |L|
// +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

/*
	pc_ctl_wr_en         = cp0_pc_ctl_wr_en | greset;


	// Lower 5b are reset to disable the counter
	pc_ctl_reg_nxt[10:0] = pc_ctl_wr_en ? alu_cp0_wdata_er[10:0] :
			                      pc_ctl_reg[10:0];
	
	pc_ctl_reg[10:0]	= cregister_wide(gscanenable,pc_ctl_wr_en,gclk,
					      pc_ctl_reg_nxt[10:0]);

	mt_ctl_vpeowner = 1'b0;
	
	mt_ctl_reg[6:0] = 7'b0;

	pc_ctl_reg_xx[31:0]  = {
				NXT_COUNTER,
				5'b0,
				mt_ctl_reg[6:1],
				3'b0,
				mt_ctl_reg[0],
				5'b0,
				pc_ctl_reg[10:0]
				};
*/

//	root_mode = ~cpz_gm | cpz_dm | status[ERL] | status[EXL]; // if VZ=0, cpz_gm always 0
	assign vz_visible = cpz_vz & (~cpz_gm | cpz_dm | status[ERL] | status[EXL]);

	// {Event[10:5], IE, U, S, K, EXL}, both root and guest accessable
	mvp_cregister_wide #(11) _pc_ctl_rega_10_0_(pc_ctl_rega[10:0],gscanenable, pc_ctl_we | greset, gclk, greset ? 11'b0 : cpz[10:0]);

	// {EC[24:23], Event[12]}, only root accessable, guest write ignored
	mvp_cregister #(3) _pc_ctl_regb_2_0_(pc_ctl_regb[2:0],vz_visible & pc_ctl_we | greset, gclk, greset ? 3'b0 : {cpz[24:23], cpz[12]});

	assign pc_ctl_exl = pc_ctl_rega[0];
	assign pc_ctl_k = pc_ctl_rega[1];
	assign pc_ctl_s = pc_ctl_rega[2];
	assign pc_ctl_u = pc_ctl_rega[3];
	assign pc_ctl_ie = pc_ctl_rega[4];
	assign pc_ctl_evt[7:0] = {pc_ctl_regb[0], 1'b0, pc_ctl_rega[10:5]};
	assign pc_ctl_ec[1:0] = pc_ctl_regb[2:1];

	assign pc_ctl_reg[31:0] = {
		NXT_COUNTER, // 31
		6'b0, // 30:25
		vz_visible ? pc_ctl_regb[2:1] : 2'b0, // 24:23, only root accessable, guest read 0
		10'b0, // 22:13
		vz_visible ? pc_ctl_regb[0] : 1'b0, // 12, only root accessable, guest read 0
		1'b0, // 11
		pc_ctl_rega[10:0] // 10:0, {Event[10:5], IE, U, S, K, EXL}
		};
/*	
	cnt_active = |(pc_ctl_reg_xx[3:0]) | ignore_mode;
	ignore_mode = (pc_ctl_reg[10:5] == 6'b0)  |
			(pc_ctl_reg[10:5] == 6'd18) |
			(pc_ctl_reg[10:5] == 6'd25) |
			(pc_ctl_reg[10:5] == 6'd39) |
			(pc_ctl_reg[10:5] == 6'd44) |
			((pc_ctl_reg[10:5] >= 6'd50) & (pc_ctl_reg[10:5] <= 6'd54));
*/	
	assign ignor_mode = 
		(pc_ctl_evt==0)  | // cycles / cycles
		(pc_ctl_evt==18) | // stall cycles / RSVD
		(pc_ctl_evt==25) | // IFU stall cycles / ALU stall cycles
		(pc_ctl_evt==39) | // DC miss cycles / RSVD
		(pc_ctl_evt==44) | // CACHE insn stall cycles / RSVD
		(pc_ctl_evt>=50 & pc_ctl_reg<=55); // LDQ/WBB
/*
//------------------------------------------------------------------------------
//performance counter register (reg 25, sel odd)
//------------------------------------------------------------------------------
// Identify which TCs are in countable modes.  Never count for ERL/DM.  Others based on
	// control reg bits
	tc_in_countmode_nxt  = ~tc_in_erldm &                                               
				(tc_in_exl & pc_ctl_reg_nxt[0] |
				 tc_in_kernel & ~tc_in_exl & pc_ctl_reg_nxt[1] |
				 tc_in_super  & ~tc_in_exl & pc_ctl_reg_nxt[2] |
				 tc_in_user   & ~tc_in_exl & pc_ctl_reg_nxt[3] |
				 ignore_mode); 
	
	tc_mten_mask_nxt = tc_in_countmode_nxt ;

	// Mask of which TCs,VPEs counting is enabled for
	// Mask must be updated while counter is active.  wr_en enables clearing it when 
	// the counter is being disabled
	pc_en_mask_xx = ucregister_wide(gscanenable, (cnt_active | pc_ctl_wr_en), 
				gclk, {tc_mten_mask_nxt} );
	any_tc_enabled	= register( gclk, pc_en_mask_xx);
*/
	assign pc_cnt_mod_en0 = ~cpz_dm & ~status[ERL] & ~cpz_gm & ( // EC=0, GuestCtl0.GM==0
		ignor_mode | pc_ctl_exl & status[EXL] |
		pc_ctl_k & status[4:3]==0 & ~status[EXL] |
		pc_ctl_s & status[4:3]==1 & ~status[EXL] |
		pc_ctl_u & status[4:3]==2 & ~status[EXL]);

	assign pc_cnt_mod_en1 = ~cpz_dm & ~status[ERL] & status[EXL] & cpz_gm; // EC=1, GuestCtl0.GM==1 & Root.Status.EXL==1
	
	assign pc_cnt_mod_en2 = ~cpz_dm & ~status[ERL] & ~status[EXL] & cpz_gm & ~g_status[ERL] & ( // EC=2, GuestCtl0.GM==1 & Root.Status.EXL==0
		ignor_mode | pc_ctl_exl & g_status[EXL] |
		pc_ctl_k & g_status[4:3]==0 & ~g_status[EXL] |
		pc_ctl_s & g_status[4:3]==1 & ~g_status[EXL] |
		pc_ctl_u & g_status[4:3]==2 & ~g_status[EXL]);
	
	assign pc_cnt_mod_en3 = pc_cnt_mod_en1 | pc_cnt_mod_en2; // EC=3, GuestCtl0.GM==1

	mvp_mux4 #(1) _pc_en_mask_xx_nxt(pc_en_mask_xx_nxt,pc_ctl_ec, pc_cnt_mod_en0, pc_cnt_mod_en1, pc_cnt_mod_en2, pc_cnt_mod_en3);
	mvp_register #(1) _pc_en_mask_xx(pc_en_mask_xx,gclk, pc_en_mask_xx_nxt & ~greset);
	mvp_register #(1) _any_tc_enabled(any_tc_enabled, gclk, pc_en_mask_xx);

/*
	// Register the events before the mux and count for timing reasons
	evt_en[7:0] = {8{cnt_active}} &
		      {(pc_ctl_reg[10:8] == 3'b111),
		       (pc_ctl_reg[10:8] == 3'b110),
		       (pc_ctl_reg[10:8] == 3'b101),
		       (pc_ctl_reg[10:8] == 3'b100),
		       (pc_ctl_reg[10:8] == 3'b011),
		       (pc_ctl_reg[10:8] == 3'b010),
		       (pc_ctl_reg[10:8] == 3'b001),
		       (pc_ctl_reg[10:8] == 3'b000)};

	evt_reg[63:56]	= ucregister_wide(gscanenable,evt_en[7],gclk, pc_cnt_evt[63:56]);
	evt_reg[55:48]	= ucregister_wide(gscanenable,evt_en[6],gclk, pc_cnt_evt[55:48]);
	evt_reg[47:40]	= ucregister_wide(gscanenable,evt_en[5],gclk, pc_cnt_evt[47:40]);
	evt_reg[39:32]	= ucregister_wide(gscanenable,evt_en[4],gclk, pc_cnt_evt[39:32]);
	evt_reg[31:24]	= ucregister_wide(gscanenable,evt_en[3],gclk, pc_cnt_evt[31:24]);
	evt_reg[23:16]	= ucregister_wide(gscanenable,evt_en[2],gclk, pc_cnt_evt[23:16]);
	evt_reg[15:8]	= ucregister_wide(gscanenable,evt_en[1],gclk, pc_cnt_evt[15:8]);
	evt_reg[7:0]	= ucregister_wide(gscanenable,evt_en[0],gclk, pc_cnt_evt[7:0]);
*/
mvp_ucregister_wide #(256) _pc_cnt_evt_reg_255_0_(pc_cnt_evt_reg[255:0],gscanenable,1'b1,gclk, pc_cnt_evt);

/*
	// Delay the event mux selects to synchronize with event timing 
	// helps initialization and odd startup events
	pc_ctl_wr_en_reg	= register( gclk, pc_ctl_wr_en);
	evt_sel[10:5]	= ucregister_wide(gscanenable, pc_ctl_wr_en_reg, gclk, 
					pc_ctl_reg[10:5]);
*/
mvp_ucregister_wide #(8) _pc_ctl_evt_reg_7_0_(pc_ctl_evt_reg[7:0],gscanenable,1'b1,gclk, pc_ctl_evt);

/*
	evt0_15	= mux16(evt_sel[8:5],
			evt_reg[0] , evt_reg[1] , evt_reg[2] , evt_reg[3],
			evt_reg[4] , evt_reg[5] , evt_reg[6] , evt_reg[7],
			evt_reg[8] , evt_reg[9] , evt_reg[10], evt_reg[11],
			evt_reg[12], evt_reg[13], evt_reg[14], evt_reg[15]);

	// Reverse order of muxxing to balance load on selects
	evt16_31	= mux16({evt_sel[6:5], evt_sel[8:7]},
			evt_reg[16], evt_reg[20], evt_reg[24], evt_reg[28],
			evt_reg[17], evt_reg[21], evt_reg[25], evt_reg[29],
			evt_reg[18], evt_reg[22], evt_reg[26], evt_reg[30],
			evt_reg[19], evt_reg[23], evt_reg[27], evt_reg[31]
			);

	evt32_47	= mux16(evt_sel[8:5],
			 evt_reg[32], evt_reg[33], evt_reg[34], evt_reg[35], 
			 evt_reg[36], evt_reg[37], evt_reg[38], evt_reg[39],
			 evt_reg[40], evt_reg[41], evt_reg[42], evt_reg[43],
			 evt_reg[44], evt_reg[45], evt_reg[46], evt_reg[47]
			 );

	evt48_63	= mux16({evt_sel[6:5], evt_sel[8:7]},
			evt_reg[48], evt_reg[52], evt_reg[56], evt_reg[60],
			evt_reg[49], evt_reg[53], evt_reg[57], evt_reg[61],
			evt_reg[50], evt_reg[54], evt_reg[58], evt_reg[62],
			evt_reg[51], evt_reg[55], evt_reg[59], evt_reg[63]
			);

	pc_cnt_evt_inc_en	= mux4(evt_sel[10:9],
				 evt0_15, evt16_31, evt32_47, evt48_63);
	*/
	assign pc_cnt_evt_inc_en = pc_cnt_evt_reg [pc_ctl_evt_reg];
	
	assign enabled_1_hot = pc_ctl_we;
	mvp_cregister #(1) _cntgate(cntgate,greset | enabled_1_hot, gclk, ~greset);
	assign hw_pc_cnt_wr_en     = cntgate & pc_cnt_evt_inc_en & any_tc_enabled &
				(~cpz_goodnight | (pc_ctl_evt_reg == 0));
/*
	//incrementor : byte partition
	{b0_carry_out,pc_cnt_inc[ 7: 0]}  = pc_cnt_reg_xx[ 7: 0] + 8'b1;
	{b1_carry_out,pc_cnt_inc[15: 8]}  = pc_cnt_reg_xx[15: 8] + 8'b1;
	{b2_carry_out,pc_cnt_inc[23:16]}  = pc_cnt_reg_xx[23:16] + 8'b1;
	{             pc_cnt_inc[31:24]}  = pc_cnt_reg_xx[31:24] + 8'b1;
	
	pc_cnt_wr_b0_en = cp0_pc_cnt_wr_en |  hw_pc_cnt_wr_en;			//byte 0 wr enable
	pc_cnt_wr_b1_en = cp0_pc_cnt_wr_en | (hw_pc_cnt_wr_en & b0_carry_out);	//byte 1 wr enable
	pc_cnt_wr_b2_en = cp0_pc_cnt_wr_en | (hw_pc_cnt_wr_en & b0_carry_out &	//byte 2 wr enable 
					      b1_carry_out);		
	pc_cnt_wr_b3_en = cp0_pc_cnt_wr_en | (hw_pc_cnt_wr_en & b0_carry_out &	//byte 3 wr enable 
					      b1_carry_out    & b2_carry_out);
	
	pc_cnt_reg_nxt[31:0] = cp0_pc_cnt_wr_en  ? alu_cp0_wdata_er[31:0] :
			       evt_sel[10:5]==6'd28 ? {31'b0, evt_reg[28]} :
			       evt_sel[10:5]==6'd29 ? {31'b0, evt_reg[29]} :
			       pc_cnt_inc[31:0];
	
	pc_cnt_reg_xx[ 7: 0]	= cregister_wide(gscanenable,pc_cnt_wr_b0_en,gfclk,pc_cnt_reg_nxt[ 7: 0]);
	pc_cnt_reg_xx[15: 8]	= cregister_wide(gscanenable,pc_cnt_wr_b1_en,gfclk,pc_cnt_reg_nxt[15: 8]);
	pc_cnt_reg_xx[23:16]	= cregister_wide(gscanenable,pc_cnt_wr_b2_en,gfclk,pc_cnt_reg_nxt[23:16]);
	pc_cnt_reg_xx[31:24]	= cregister_wide(gscanenable,pc_cnt_wr_b3_en,gfclk,pc_cnt_reg_nxt[31:24]);
*/
	assign pc_cnt_inc[31:0] = pc_ctl_evt_reg==28 || pc_ctl_evt_reg==29 ? 32'b1 : pc_cnt_reg + 1;
	mvp_cregister_wide #(32) _pc_cnt_reg_31_0_(pc_cnt_reg[31:0],gscanenable, pc_cnt_we | hw_pc_cnt_wr_en, gfclk, pc_cnt_we ? cpz : pc_cnt_inc);
/*
	// Detect interrupt condition
	pc_vpe0_pci_req_xx = pc_ctl_reg_xx[4] & pc_cnt_reg_xx[31];
*/
	assign r_pc_int = pc_cnt_reg[31] & pc_ctl_ie & ~pc_ctl_ec[1];
	assign g_pc_int = pc_cnt_reg[31] & pc_ctl_ie &  pc_ctl_ec[1];
	
endmodule

