// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// Description: m14k_mdl_ctl 
//      MDU_lite Control Module
//
// $Id: \$
// mips_repository_id: m14k_mdl_ctl.mv, v 1.7 
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
    
// Comments for verilint...Since the ports on this module need to match others,
//  some inputs are unused.   mpc_ekillmd_m signal is not used by lite mdu
//verilint 240 off

`include "m14k_const.vh"
module m14k_mdl_ctl(
	gscanenable,
	gclk,
	greset,
	mpc_ekillmd_m,
	mpc_irval_e,
	mpc_ir_e,
	mpc_predec_e,
	mpc_umipspresent,
	mpc_killmd_m,
	mpc_run_ie,
	mpc_run_m,
	mpc_srcvld_e,
	carry_out,
	rp_sum_sgn,
	shift_out,
	dm_sgn,
	qp_sgn,
	qp_lsb,
	qp_lsb_early,
	mdu_busy,
	mdu_stall,
	mdu_type,
	mdu_active,
	dm_cond,
	hi_cond,
	lo_cond,
	b_inv_sel,
	c_in,
	shft_in,
	up_dwn_sel,
	rp_dm_qp_sel,
	hilo_rp_zero_sel,
	sum_qp_sel,
	zero_rp_sum_sel,
	shift_rp_sel,
	shift_qp_sel,
	qpnxt_abus_sel,
	qpnxt_qp_sel,
	qp_rpnxt_rp_sel,
	hi_lo_sel,
	mdu_result_done);



   /* Inputs */
   
   // External inputs
   input         gscanenable;		// Scan Enable
   input 	 gclk;			// Global clock
   input 	 greset;		// Global reset
   input 	 mpc_ekillmd_m;		// Early Kill (MTxx commands only). As mpc_killmd_m
   input 	 mpc_irval_e;		// Instruction on mpc_ir_e is valid
   input [31:0]  mpc_ir_e;		// Instruction in E stage
   input [22:0]  mpc_predec_e;
   input	 mpc_umipspresent;
   input 	 mpc_killmd_m;		// Kill all E and M stage commands
   input 	 mpc_run_ie;		// Stage E (And M) is moving to next stage
   input 	 mpc_run_m;		// Stage M is moving to next stage.
   input 	 mpc_srcvld_e;		// Operands on edp_abus_e(RS) and edp_bbus_e(RT) are valid
   
   // state machine result inputs from DataPath
   input 	 carry_out;		// Carry out from adder
   input 	 rp_sum_sgn; 	 	// MSB of rp before shift
   input 	 shift_out;		// Drop out from shifter on down shift
   input 	 dm_sgn;		// dm sign bit
   input 	 qp_sgn;		// qp sign bit
   input 	 qp_lsb;		// qp LSB bit (for Booth)
   input 	 qp_lsb_early;		// qp LSB bit (for Booth)
   
   /* Outputs */
   
   // External outputs
   output 	 mdu_busy;		// MDU busy. All MDU commands must stall in E.
   // 					   Except MFHI and MFLO.
   output 	 mdu_stall;		// MDU stalling. All commands must stall in E.
   output 	 mdu_type;		// Static config output: 1 -> LiteMDU
	

   // All xxxUpdate input are active high.
   // All Select signals for multiplexer's select first one on 1 and second on 0.
   // 3-wayu select user bit 1 for first, and bit 0 for next two.

   // Register update controls
   output 	 mdu_active;		// Gating signal for ucregisters
   output 	 dm_cond;		// Register Update to dm.
   output 	 hi_cond;		// Register Update to hi
   output 	 lo_cond;		// Register Update to lo

   // Logic block controls
   output 	 b_inv_sel;		// Invert all bits on B input to adder
   output 	 c_in;			// Carry in to adder
   output 	 shft_in;		// Bit to shift in on Up/Down shift
   output 	 up_dwn_sel;		// Shift direction selecter

   // Multiplexer controls
   output [1:0]  rp_dm_qp_sel;		// B input selector
   output [1:0]  hilo_rp_zero_sel;	// A input selector
   output 	 sum_qp_sel;		// qp_sum selector
   output [1:0]  zero_rp_sum_sel;	// rp_sum selector
   output 	 shift_rp_sel;		// rp_nxt selector
   output 	 shift_qp_sel;		// qp_nxt selector
   output 	 qpnxt_abus_sel;	// qp_abus_nxt selector
   output 	 qpnxt_qp_sel;		// lo_nxt selector
   output [1:0]  qp_rpnxt_rp_sel;	// hi_nxt selector
   output 	 hi_lo_sel;		// hilo selector

   output      mdu_result_done;

// BEGIN Wire declarations made by MVP
wire [1:0] /*[1:0]*/ mf_cmd_m;
wire md_madd;
wire md_mfhi;
wire post_m;
wire valid_div_umips;
wire md_msubu;
wire dec_poolAxf;
wire [3:0] /*[3:0]*/ state_nxt;
wire [5:0] /*[5:0]*/ op_code;
wire booth_nthng;
wire md_mult;
wire [5:0] /*[5:0]*/ func_code;
wire mfhi_cmd_w_nxt;
wire c_out_reg;
wire [4:0] /*[4:0]*/ loop_cnt;
wire valid_move_mips32;
wire shift_rp_sel;
wire clear_loop_cnt;
wire divdnt_sgn;
wire post_m_nxt;
wire state_mul_loop;
wire mdu_result_done;
wire [5:0] /*[5:0]*/ cmd_e;
wire sub_2;
wire b_inv_sel;
wire valid_mul;
wire md_mthi;
wire md_multu;
wire mdu_type;
wire [20:0] /*[20:0]*/ uc_reg_out;
wire hi_lo_sel;
wire valid_mul_mips32;
wire shft_in;
wire valid_mul_umips;
wire md_div;
wire [4:0] /*[4:0]*/ cmd_m;
wire [1:0] /*[1:0]*/ hilo_rp_zero_sel;
wire valid_div_mips32;
wire valid_move;
wire dm_cond;
wire [1:0] /*[1:0]*/ zero_rp_sum_sel;
wire [5:0] /*[5:0]*/ cmd_e_mips32;
wire [3:0] /*[3:0]*/ state;
wire booth_sub;
wire kill_calc;
wire md_divu;
wire mdu_stall_reg;
wire md_maddu;
wire sub_3;
wire shift_qp_sel;
wire qpnxt_abus_sel;
wire [1:0] /*[1:0]*/ qp_rpnxt_rp_sel;
wire hi_cond;
wire state_mul_acc;
wire [1:0] /*[1:0]*/ rp_dm_qp_sel;
wire [5:0] /*[5:0]*/ cmd_e_umips;
wire mdu_busy;
wire mdu_busy_reg;
wire [4:0] /*[4:0]*/ loop_cnt_nxt;
wire mdu_stall;
wire mfhi_cmd_w;
wire sub;
wire up_dwn_sel;
wire valid_div;
wire loop_cnt_is_31;
wire md_mul;
wire sum_qp_sel;
wire lo_cond;
wire valid_move_umips;
wire qpnxt_qp_sel;
wire write_res_ok_reg;
wire sub_1;
wire c_in;
wire md_msub;
wire dec_5;
wire write_res_ok;
wire md_mflo;
wire mdu_active;
wire md_mtlo;
wire dec_pool32a;
// END Wire declarations made by MVP

   
   /* Inouts */

   /* End I/O's */

   /* Wires */

   // opcodes for opcodep
   // parameters not allowed by MVP
   //
   parameter 	 SPECIAL =  6'b000000;
   parameter 	 SPECIAL2 = 6'b011100;

   //
   

   // opcodes for functp
   // parameters not allowed by MVP
   //
   // SPECIAL2
   parameter 	 MADD =  6'b000000;
   parameter 	 MADDU = 6'b000001;
   parameter 	 MUL =   6'b000010;
   parameter 	 MSUB =  6'b000100;
   parameter 	 MSUBU = 6'b000101;
   // SPECIAL
   parameter 	 MFHI =  6'b010000;
   parameter 	 MTHI =  6'b010001;
   parameter 	 MFLO =  6'b010010;
   parameter 	 MTLO =  6'b010011;
   parameter 	 MULT =  6'b011000;
   parameter 	 MULTU = 6'b011001;
   parameter 	 DIV =   6'b011010;
   parameter 	 DIVU =  6'b011011;
   //
   
   // state Machine stages
   // parameters not allowed by MVP
   //
   parameter 	 IDLE =			4'b0000;
   parameter 	 MOVE_TO =		4'b0001;
   parameter 	 DIV_DIVI_SIGN =	4'b0011;
   parameter 	 DIV_LOOP =		4'b1000;
   parameter 	 DIV_QUOT_SIGN =	4'b1001;
   parameter 	 DIV_REM_SIGN =		4'b1010;
   parameter 	 MULT_LOOP_1ST =	4'b0101;
   parameter 	 MULT_LOOP =		4'b1011;
   parameter 	 MULT_ACC1 =		4'b1100;
   parameter 	 MULT_ACC2 =		4'b1101;
   parameter 	 WAIT_HILO =	        4'b1110;
   //
   
   // Command save bit locations
   // parameters not allowed by MVP
   //
   parameter 	 CMD_MUL_DIR =	5;
   parameter 	 CMD_MUL_ADD =	4;
   parameter 	 CMD_MUL_SUB =	3;
   parameter 	 CMD_MOVE_TO_HI =	2;
   parameter 	 CMD_MOVE_TO_LO =	1;
   parameter 	 CMD_SIGNED =	0;
   //

	assign dec_pool32a = mpc_predec_e[10];
	assign dec_poolAxf = mpc_predec_e[15];
	assign dec_5 = mpc_predec_e[17];
   assign mdu_active = greset | mpc_killmd_m | (state != IDLE) | mdu_busy_reg |
		(mpc_run_ie & (valid_mul | valid_div | valid_move)) |
		mf_cmd_m[1];
   /* Unconditional Active registers */
   wire [20:0] 	 uc_reg_in;
   mvp_ucregister_wide #(21) _uc_reg_out_20_0_(uc_reg_out[20:0],gscanenable, mdu_active, gclk, uc_reg_in);
`define M14K_WRRESOKL    0
`define M14K_STATE       4:1
`define M14K_MDBL        5
`define M14K_MDSL        6
`define M14K_MFCMDS      8:7
`define M14K_BSUB        9
`define M14K_BNOT        10
`define M14K_SUBT1       11
`define M14K_STATEMLOO   12
`define M14K_STATEMAC    13
`define M14K_COSAVE      14
`define M14K_RPDMQPS     16:15
`define M14K_HILORPZS    18:17
`define M14K_HILOS       19
`define M14K_MFHICMD       20
     
   // Decode valid operation in E-stage.
   // MFHI, MFLO and MUL are run even if RD is register zero
   assign op_code [5:0] = mpc_ir_e[31:26];
   assign func_code [5:0] = mpc_ir_e[5:0];
   assign valid_mul_mips32 = (mpc_srcvld_e & mpc_irval_e &
		    ((op_code == SPECIAL2 & 
		      (func_code == MADD  |
		       func_code == MADDU |
		       (func_code == MUL) |
		       func_code == MSUB  |
		       func_code == MSUBU)) |
		     (op_code == SPECIAL &
		      (func_code == MULT |
		       func_code == MULTU))));
   assign valid_div_mips32   = (mpc_srcvld_e & mpc_irval_e & 
		    (op_code == SPECIAL &
		     (func_code == DIV | 
		      func_code == DIVU)));
   assign valid_move_mips32     = (mpc_srcvld_e & mpc_irval_e & 
		    (op_code == SPECIAL &
		     (func_code == MFHI | 
		      func_code == MFLO | 
		      func_code == MTHI | 
		      func_code == MTLO)));
  
   // Decode in native micromips
	assign md_madd =  dec_poolAxf & mpc_ir_e[8:6]==3'o4 & mpc_ir_e[11:9]==3'o5 & mpc_ir_e[15:12]==4'hc;
	assign md_maddu = dec_poolAxf & mpc_ir_e[8:6]==3'o4 & mpc_ir_e[11:9]==3'o5 & mpc_ir_e[15:12]==4'hd;
	assign md_mul   = dec_pool32a & mpc_ir_e[2:0]==3'o0 & mpc_ir_e[5:3]==3'o2  & mpc_ir_e[9:6]==4'h8;
	assign md_msub  = dec_poolAxf & mpc_ir_e[8:6]==3'o4 & mpc_ir_e[11:9]==3'o5 & mpc_ir_e[15:12]==4'he;
	assign md_msubu = dec_poolAxf & mpc_ir_e[8:6]==3'o4 & mpc_ir_e[11:9]==3'o5 & mpc_ir_e[15:12]==4'hf;
	assign md_mult  = dec_poolAxf & mpc_ir_e[8:6]==3'o4 & mpc_ir_e[11:9]==3'o5 & mpc_ir_e[15:12]==4'h8;
	assign md_multu = dec_poolAxf & mpc_ir_e[8:6]==3'o4 & mpc_ir_e[11:9]==3'o5 & mpc_ir_e[15:12]==4'h9;
	assign md_div   = dec_poolAxf & mpc_ir_e[8:6]==3'o4 & mpc_ir_e[11:9]==3'o5 & mpc_ir_e[15:12]==4'ha;
	assign md_divu  = dec_poolAxf & mpc_ir_e[8:6]==3'o4 & mpc_ir_e[11:9]==3'o5 & mpc_ir_e[15:12]==4'hb;
	assign md_mthi  = dec_poolAxf &  dec_5 & mpc_ir_e[11:9]==3'o6 & mpc_ir_e[15:12]==4'h2;
	assign md_mtlo  = dec_poolAxf &  dec_5 & mpc_ir_e[11:9]==3'o6 & mpc_ir_e[15:12]==4'h3;
	assign md_mfhi  = dec_poolAxf &  dec_5 & mpc_ir_e[11:9]==3'o6 & mpc_ir_e[15:12]==4'h0;
	assign md_mflo  = dec_poolAxf &  dec_5 & mpc_ir_e[11:9]==3'o6 & mpc_ir_e[15:12]==4'h1;

   assign valid_mul_umips  = mpc_srcvld_e & mpc_irval_e & (md_madd|md_maddu|md_mul|md_msub|md_msubu|md_mult|md_multu);
   assign valid_div_umips  = mpc_srcvld_e & mpc_irval_e & (md_div|md_divu);
   assign valid_move_umips = mpc_srcvld_e & mpc_irval_e & (md_mfhi|md_mflo|md_mtlo|md_mthi);

   assign valid_mul = mpc_umipspresent ? valid_mul_umips : valid_mul_mips32;
   assign valid_div = mpc_umipspresent ? valid_div_umips : valid_div_mips32;
   assign valid_move = mpc_umipspresent ? valid_move_umips : valid_move_mips32;

   // Generate and save command signals to state machine.
   // state machine will ignore Valid and Cmd until mpc_run_ie.
   assign cmd_e_mips32 [5:0] = {(valid_mul & func_code == MUL), 			// CMD_MUL_DIR
		 (valid_mul & (func_code == MADD | func_code == MADDU)), 	// CMD_MUL_ADD
		 (valid_mul & (func_code == MSUB | func_code == MSUBU)), 	// CMD_MUL_SUB
		 (valid_move & func_code == MTHI), 				// CMD_MOVE_TO_HI
		 (valid_move & func_code == MTLO), 				// CMD_MOVE_TO_LO
		 ~func_code[0]}; 	 					// CMD_SIGNED
   assign cmd_e_umips [5:0] = {(valid_mul & md_mul), 			// CMD_MUL_DIR
		 (valid_mul & (md_madd | md_maddu)), 	// CMD_MUL_ADD
		 (valid_mul & (md_msub | md_msubu)), 	// CMD_MUL_SUB
		 (valid_move & md_mthi), 				// CMD_MOVE_TO_HI
		 (valid_move & md_mtlo), 				// CMD_MOVE_TO_LO
		 md_mul | ~mpc_ir_e[12] };		// CMD_SIGNED
   assign cmd_e [5:0] = mpc_umipspresent ? cmd_e_umips : cmd_e_mips32;

   // Save command decode for M-staga.
   // Keep if this is a multicycle command, or if command is stalled
   // because mpc_run_m is low.
   mvp_cregister_wide #(5) _cmd_m_4_0_(cmd_m[4:0],gscanenable, (mpc_run_m & ~mdu_busy),
			  gclk,
			  ({5{mpc_run_ie & ~mpc_killmd_m}} & cmd_e[4:0]));

   // Generat write_res_ok signal. Indicating that the MDU can finish.
   // The MDU WILL run out of M stage even if mpc_run_m is low.
   // We will need to detect that registers updates are allowed, from
   // An assertion of mpc_run_m during the calculation.
   assign write_res_ok = ((write_res_ok_reg & post_m) | (mpc_run_m));
   assign uc_reg_in[`M14K_WRRESOKL] = ((write_res_ok_reg & post_m) | (mpc_run_m & ~mpc_killmd_m));
   assign write_res_ok_reg = uc_reg_out[`M14K_WRRESOKL];


   assign mdu_result_done = write_res_ok;

   // loop_cnt
   // Counter is reset each time a new multiply or divide loop is started.
   assign clear_loop_cnt = (state_nxt == MULT_LOOP_1ST) |
		    (state_nxt == DIV_LOOP & state == DIV_DIVI_SIGN);
   assign loop_cnt_nxt [4:0] = clear_loop_cnt ? 5'd0 : loop_cnt + 5'd1;
   assign loop_cnt_is_31 = (loop_cnt == 5'd31);
   mvp_ucregister_wide #(5) _loop_cnt_4_0_(loop_cnt[4:0],gscanenable, (clear_loop_cnt | ~loop_cnt_is_31), gclk, 
				     loop_cnt_nxt);
   
   // Save Dividend sign bit
   // This register saves the Dividend (RS) sign bit. The information is
   // used later when Quotint or Remainder might need sign-conversion.
   mvp_cregister #(1) _divdnt_sgn(divdnt_sgn,(state == DIV_DIVI_SIGN),
			    gclk,
			    qp_sgn);
   
   // kill_calc is an internal mpc_killmd_m signal to the MDU
   // It will be set on mpc_killmd_m, but only if the current Multicycle command
   // has not already been committed by a high mpc_run_m in the M-stage of that
   // command.
   assign kill_calc = (mpc_killmd_m & (~post_m | (post_m & ~write_res_ok_reg)));

   // state machine
   // Each new state is generated by the function m14k_mdl_state_nxt_gen.
   assign state_nxt [3:0] = m14k_mdl_state_nxt_gen
		     (state,
		      greset,
		      mpc_run_ie,
		      mpc_run_m,
		      valid_mul,
		      valid_div,
		      valid_move,
		      cmd_m,
		      loop_cnt_is_31,
		      divdnt_sgn,
		      dm_sgn,
		      write_res_ok);

   assign uc_reg_in[`M14K_STATE] = (kill_calc ? IDLE : state_nxt);
   assign state [3:0] = uc_reg_out[`M14K_STATE];
   
   // post_m signal. Indicates multicycle operation has passed first M-stage cycle.
   // This is encoded in bit 3 of the state variable.
   assign post_m = state[3];
   assign post_m_nxt = state_nxt[3];

   // m14k_mdl_start_state function generates the next state based on an E-stage
   // instruction decode.
   // MOVE_TO stage is selected on all move commands, to create correct
   // stall functionallity. Move from command execution is handled by
   // mf_cmd_m.
	//
   function [3:0] m14k_mdl_start_state;
      input mpc_run_ie;
      input valid_mul;
      input valid_div;
      input valid_move;

      begin
	 if (mpc_run_ie) begin
	    if (valid_mul) begin
	       m14k_mdl_start_state = MULT_LOOP_1ST;
	    end else if (valid_div) begin // if (valid_mul)
	       m14k_mdl_start_state = DIV_DIVI_SIGN;
	    end else if (valid_move) begin // if (valid_div)
	       m14k_mdl_start_state = MOVE_TO;
	    end else begin // if (valid_move)
	       m14k_mdl_start_state = IDLE;
	    end // else: !if(valid_move)
	 end else begin // if (mpc_run_ie)
	    m14k_mdl_start_state = IDLE;
	 end // else: !if(mpc_run_ie)
      end
   endfunction // m14k_mdl_start_state
	//

   // m14k_mdl_state_nxt_gen returns the next state of the statemachine.
   // This is also where greset is sampled synchronusly and produce
   // IDLE as the reset stage.
   // The behaviour is described in the MDU Lite documentation.
	//
   function [3:0] m14k_mdl_state_nxt_gen;
      input [3:0] curr_state;
      input greset;
      input mpc_run_ie;
      input mpc_run_m;
      input valid_mul;
      input valid_div;
      input valid_move;
      input [4:0] cmd_m;
      input loop_cnt_is_31;
      input divdnt_sgn;
      input dm_sgn;
      input write_res_ok;      
      
      begin

	 if (greset) begin
	    m14k_mdl_state_nxt_gen = IDLE;
	 end else begin // if (greset)
	    case (curr_state)		// synopsys parallel_case
					// ambit synthesis case = parallel
	      IDLE: begin
		 m14k_mdl_state_nxt_gen = m14k_mdl_start_state(mpc_run_ie, valid_mul, valid_div, valid_move);
	      end // case: IDLE
	      
	      MOVE_TO: begin
		 if (mpc_run_m) begin
		    m14k_mdl_state_nxt_gen = m14k_mdl_start_state(mpc_run_ie, valid_mul, valid_div, valid_move);
		 end else begin // if (mpc_run_m)
		    m14k_mdl_state_nxt_gen = curr_state;
		 end // else: !if(mpc_run_m)
	      end // case: MOVE_TO
	      
	      DIV_DIVI_SIGN: begin
		 m14k_mdl_state_nxt_gen = DIV_LOOP;
	      end // case: DIV_DIVI_SIGN
	      
	      DIV_LOOP: begin
		 if (loop_cnt_is_31) begin
		    if (cmd_m[CMD_SIGNED] & (divdnt_sgn != dm_sgn)) begin
		       m14k_mdl_state_nxt_gen = DIV_QUOT_SIGN;
		    end else if (cmd_m[CMD_SIGNED] & (divdnt_sgn)) begin // if (cmd_m[CMD_SIGNED] & (divdnt_sgn != dm_sgn))
		       m14k_mdl_state_nxt_gen = DIV_REM_SIGN;
		    end else begin // if (cmd_m[CMD_SIGNED] & (divdnt_sgn))
		       if (write_res_ok) begin
			  m14k_mdl_state_nxt_gen = m14k_mdl_start_state(mpc_run_ie, valid_mul, valid_div, valid_move);
		       end else begin // if (write_res_ok)
			  m14k_mdl_state_nxt_gen = WAIT_HILO;
		       end // else: !if(write_res_ok)
		    end // else: !if(cmd_m[CMD_SIGNED] & (divdnt_sgn))
		 end else begin // if (loop_cnt_is_31)
		    m14k_mdl_state_nxt_gen = curr_state;
		 end // else: !if(loop_cnt_is_31)
	      end // case: DIV_LOOP
	      
	      DIV_QUOT_SIGN: begin
		 if (divdnt_sgn) begin
		    m14k_mdl_state_nxt_gen = DIV_REM_SIGN;
		 end else begin // if (divdnt_sgn)
		    if (write_res_ok) begin
		       m14k_mdl_state_nxt_gen = m14k_mdl_start_state(mpc_run_ie, valid_mul, valid_div, valid_move);
		    end else begin // if (write_res_ok)
		       m14k_mdl_state_nxt_gen = WAIT_HILO;
		    end // else: !if(write_res_ok)
		 end // else: !if(divdnt_sgn)
	      end // case: DIV_QUOT_SIGN
	      
	      DIV_REM_SIGN: begin
		 if (write_res_ok) begin
		    m14k_mdl_state_nxt_gen = m14k_mdl_start_state(mpc_run_ie, valid_mul, valid_div, valid_move);
		 end else begin // if (write_res_ok)
		    m14k_mdl_state_nxt_gen = WAIT_HILO;
		 end // else: !if(write_res_ok)
	      end // case: DIV_REM_SIGN
	      
	      MULT_LOOP_1ST: begin
		 m14k_mdl_state_nxt_gen = MULT_LOOP;
	      end // case: MULT_LOOP_1ST
	      
	      MULT_LOOP: begin
		 if (loop_cnt_is_31) begin
		    if (write_res_ok) begin
		       if (cmd_m[CMD_MUL_ADD] | cmd_m[CMD_MUL_SUB]) begin
		          m14k_mdl_state_nxt_gen = MULT_ACC1;
		       end else begin // if (cmd_m[CMD_MUL_ADD] | cmd_m[CMD_MUL_SUB])
		          m14k_mdl_state_nxt_gen = m14k_mdl_start_state(mpc_run_ie, valid_mul, valid_div, valid_move);
		       end 
		    end else begin
		       m14k_mdl_state_nxt_gen = WAIT_HILO;
		    end // else: !if(write_res_ok)
		 end else begin // if (loop_cnt_is_31)
		    m14k_mdl_state_nxt_gen = curr_state;
		 end // else: !if(loop_cnt_is_31)
	      end // case: MULT_LOOP


	    // Do not enter the accumulate stage until we enter the W-stage
	    // A preceding MF register needs control of the hilo bus
	      WAIT_HILO: begin
		 if (write_res_ok) begin
		    if (cmd_m[CMD_MUL_ADD] | cmd_m[CMD_MUL_SUB]) begin
		       m14k_mdl_state_nxt_gen = MULT_ACC1;
		    end else begin
		       m14k_mdl_state_nxt_gen = m14k_mdl_start_state(mpc_run_ie, valid_mul, valid_div, valid_move);
		    end
		 end else begin // if (write_res_ok)
		    m14k_mdl_state_nxt_gen = curr_state;
		 end // else: !if(write_res_ok)
	      end // case: WAIT_HILO
	      
	      MULT_ACC1: begin
		 m14k_mdl_state_nxt_gen = MULT_ACC2;
	      end // case: MULT_ACC1
	      
	      MULT_ACC2: begin
		    m14k_mdl_state_nxt_gen = m14k_mdl_start_state(mpc_run_ie, valid_mul, valid_div, valid_move);
	      end // case: MULT_ACC2
	      
	      default: begin
		 m14k_mdl_state_nxt_gen = IDLE;
	      end // case: default

	    endcase // case(curr_state)
	 end // else: !if(greset)
      end
   endfunction // m14k_mdl_state_nxt_gen
	//
   
   

   
   // mdu_busy is set when a multicylce command is in M-stage, except for
   // the last cycle. This will indicate, that data is ready in the next
   // stage.
   // When set the controller will stall all MDU commands in E-stage, except
   // for MFHI and MFLO. 
   assign uc_reg_in[`M14K_MDBL] = (~greset & ~kill_calc &
		       (((~mpc_killmd_m) & mpc_run_ie & (valid_mul | valid_div)) |
			mdu_busy));
   assign mdu_busy_reg = uc_reg_out[`M14K_MDBL];
   assign mdu_busy = (mdu_busy_reg &
	     (state == DIV_DIVI_SIGN |
	      state == MULT_LOOP_1ST |
	      (post_m &
	       ~((state == DIV_LOOP & loop_cnt_is_31 & (~cmd_m[CMD_SIGNED] | ~(divdnt_sgn | dm_sgn))) |
		 (state == DIV_QUOT_SIGN & ~divdnt_sgn) |
		 (state == DIV_REM_SIGN) |
		 (state == MULT_LOOP & loop_cnt_is_31 & ~(cmd_m[CMD_MUL_ADD] | cmd_m[CMD_MUL_SUB])) |
		 (state == MULT_ACC2)))));

   // mdu_stall is set when a MFHI, MFLO or MUL command is in the M-stage in
   // the Lite MDU.
   // When set the controller will stall all other commands in E-Stage
   assign uc_reg_in[`M14K_MDSL] = (~greset & (mdu_stall | 
				 (~mpc_killmd_m & mpc_run_ie & 
				  ((mdu_busy & valid_move & (cmd_e[CMD_SIGNED] & ~mpc_umipspresent | mpc_umipspresent & (md_mfhi | md_mflo | md_mul))) |
				   (cmd_e[CMD_MUL_DIR])))));
   assign mdu_stall_reg = uc_reg_out[`M14K_MDSL];
   assign mdu_stall = (mdu_stall_reg & mdu_busy);

   // mdu_type: Static output saying what type of MDU I am
   assign mdu_type = 1'b1;

   // mf_cmd_m help register to capture and save Move from commands
   assign uc_reg_in[`M14K_MFCMDS] = (~mpc_killmd_m & mpc_run_ie &
			 valid_move & cmd_e[CMD_SIGNED]) ? {1'b1, mpc_umipspresent ? md_mfhi : (func_code == MFHI)} :
			(~mpc_killmd_m & (~mpc_run_m | post_m_nxt)) ? mf_cmd_m : 2'b00;
   assign mf_cmd_m [1:0] = uc_reg_out[`M14K_MFCMDS];

   assign mfhi_cmd_w_nxt = mpc_run_m ? (mf_cmd_m == 2'b11) : mfhi_cmd_w;
   assign uc_reg_in[`M14K_MFHICMD] = mfhi_cmd_w_nxt;
   assign mfhi_cmd_w = uc_reg_out[`M14K_MFHICMD];
	
   // Generate control signals for Data Path.

   // dm_cond is set when MDU captures edp_bbus_e (RT).
   assign dm_cond = ~mdu_busy;
   
   // hi_cond is set when the HI register is updated with a new value.
   assign hi_cond = ((post_m & ~post_m_nxt & write_res_ok_reg) |	// Write has been committed
	       (~mpc_killmd_m & mpc_run_m & 				// Make sure we are not killed
		(cmd_m[CMD_MOVE_TO_HI] |				// MTHI
		 (post_m & ~post_m_nxt) |				// LastMinute Write commit
		 ((state == WAIT_HILO) & ~(cmd_m[CMD_MUL_ADD] | cmd_m[CMD_MUL_SUB])))));	// Waiting for write commit.

   // lo_cond is set when the LO register is updated with a new value.
   assign lo_cond = ((post_m & ~post_m_nxt & write_res_ok_reg) |	// Write has been committed
	       (~mpc_killmd_m & mpc_run_m & 				// Make sure we are not killed
		(cmd_m[CMD_MOVE_TO_LO] |				// MTLO
		 (post_m & ~post_m_nxt) |				// LastMinute Write commit
		 ((state == WAIT_HILO) & ~(cmd_m[CMD_MUL_ADD] | cmd_m[CMD_MUL_SUB])))));	// Waiting for write commit.

   // booth_sub and booth_nthng help signals
   // Used to indicate sub or addition in booth algoritme.
   assign uc_reg_in[`M14K_BSUB] =  qp_lsb_early & ~(shift_out & (state_nxt != MULT_LOOP_1ST));
   assign booth_sub = uc_reg_out[`M14K_BSUB];
   assign uc_reg_in[`M14K_BNOT] = qp_lsb_early == (shift_out & (state_nxt != MULT_LOOP_1ST));
   assign booth_nthng = uc_reg_out[`M14K_BNOT];

   // sub help signal
   // Divide: 	Set on all sign convertions. Also set during loop.
   //		Exception during loop if this is a signed divide and Dividend was negative.
   // Multiply:	Set on signed multiply if booth kode says so.
   // Accumulate: Set on multiply subtract, commands.
   assign uc_reg_in[`M14K_SUBT1] = (state_nxt == DIV_DIVI_SIGN | 
			((state_nxt == DIV_LOOP) & (~dm_sgn | ~cmd_m[CMD_SIGNED])) |
			state_nxt == DIV_QUOT_SIGN | state_nxt == DIV_REM_SIGN);
   assign sub_1 = uc_reg_out[`M14K_SUBT1];
   assign uc_reg_in[`M14K_STATEMLOO] = (state_nxt == MULT_LOOP_1ST | state_nxt == MULT_LOOP);
   assign state_mul_loop = uc_reg_out[`M14K_STATEMLOO];
   assign sub_2 = (state_mul_loop & cmd_m[CMD_SIGNED] & booth_sub);
   assign uc_reg_in[`M14K_STATEMAC] = (state_nxt == MULT_ACC1 | state_nxt == MULT_ACC2);
   assign state_mul_acc = uc_reg_out[`M14K_STATEMAC];
   assign sub_3 = (state_mul_acc & cmd_m[CMD_MUL_SUB]);
   assign sub = (sub_1 | sub_2 | sub_3);

   // b_inv_sel
   // Always and only set during subtracts.
   assign b_inv_sel = sub;

   // c_out_reg capture register
   // Captures the carry_out output from the Adder. Used for Accumulate commands.
   assign uc_reg_in[`M14K_COSAVE] = carry_out;
   assign c_out_reg = uc_reg_out[`M14K_COSAVE];

   // c_in 
   // Set on subtract, otherwise zero.
   // Exception is in second cycle of accumulate, where previous carry_out is used.
   assign c_in = (state == MULT_ACC2) ? c_out_reg : sub;

   // shft_in 
   // Divide:	The Adder (used to subtract) carry_out.
   // Multiply:	If signed (booth) : aritmetric down shift except if Dividend
   //              is negative and we are subtracting (first of 1's) then use zero.
   // 		If unsigned and add control set then use carry_out, else zero.
   assign shft_in = (state == DIV_LOOP) ? carry_out :
	     ((state == MULT_LOOP_1ST | state == MULT_LOOP) &
	      cmd_m[CMD_SIGNED] & ~(dm_sgn & booth_sub)) ? rp_sum_sgn :
	     ((state == MULT_LOOP_1ST | state == MULT_LOOP) &
	      ~cmd_m[CMD_SIGNED] & qp_lsb) ? carry_out : 1'b0;
   
   // up_dwn_sel
   // Divide:	Up shift. Also during Signconvert of Dividend for alligment.
   // Multiply:	Down shift.
   assign up_dwn_sel = (state == DIV_DIVI_SIGN | state == DIV_LOOP);
   
   // Following is the Selectors for the multiplexers in the DataPath.
   // They are tightly coupled to the current state of the statemachine.
   // The 

   // Select the b input to the adder
   // rp_dm_qp_sel
   assign uc_reg_in[`M14K_RPDMQPS] = (state_nxt == DIV_REM_SIGN | state_nxt == MULT_ACC2) ? 2'd2 :
			 (state_nxt == DIV_DIVI_SIGN |
			  state_nxt == DIV_QUOT_SIGN |
			  state_nxt == MULT_ACC1) ? 2'd0 : 2'd1;
   assign rp_dm_qp_sel [1:0] = uc_reg_out[`M14K_RPDMQPS];
   // Select the a input to the adder
   // hilo_rp_zero_sel
   assign uc_reg_in[`M14K_HILORPZS] = (state_nxt == MULT_ACC1 | state_nxt == MULT_ACC2) ? 2'd2 :
			  (state_nxt == DIV_LOOP | state_nxt == MULT_LOOP) ? 2'd1 : 2'd0;
   assign hilo_rp_zero_sel [1:0] = uc_reg_out[`M14K_HILORPZS];
   
   // sum_qp_sel
   assign sum_qp_sel = (state == DIV_QUOT_SIGN | state == MULT_ACC1 |
		  (state == DIV_DIVI_SIGN & cmd_m[CMD_SIGNED] & qp_sgn));

   // zero_rp_sum_sel
   assign zero_rp_sum_sel [1:0] = ((state == DIV_DIVI_SIGN) | 
			    (state == MULT_LOOP_1ST &
			     ((cmd_m[CMD_SIGNED] & booth_nthng) |
			      (~cmd_m[CMD_SIGNED] & ~qp_lsb)))) ? 2'd2 :
			   ((state == DIV_LOOP & ~carry_out) |
			    (state == MULT_LOOP &
			     ((cmd_m[CMD_SIGNED] & booth_nthng) |
			      (~cmd_m[CMD_SIGNED] & ~qp_lsb))) |
			    (state == MULT_ACC1) |
			    (state == DIV_QUOT_SIGN) |
			    (state == WAIT_HILO)) ? 2'd1 : 2'd0;

   // shift_rp_sel
   assign shift_rp_sel = (state == DIV_DIVI_SIGN |
			    (state == DIV_LOOP & ~loop_cnt_is_31) |
			    state == MULT_LOOP_1ST | state == MULT_LOOP);

   // shift_qp_sel
   assign shift_qp_sel = (state == DIV_DIVI_SIGN | state == DIV_LOOP |
			    state == MULT_LOOP_1ST | state == MULT_LOOP);

   // Select the next value for qp
   // qpnxt_abus_sel
   assign qpnxt_abus_sel = (mdu_busy | state_nxt == WAIT_HILO | (state == MOVE_TO & ~mpc_run_m));
   
   // Select the next value for the lo register
   // qpnxt_qp_sel
   assign qpnxt_qp_sel = ~(state == MULT_ACC2 | state == MOVE_TO | state == DIV_REM_SIGN);

   // Select the next value for the hi register
   // qp_rpnxt_rp_sel
   assign qp_rpnxt_rp_sel [1:0] = (state == MOVE_TO) ? 2'd2 :
			   (state == WAIT_HILO) ? 2'd0 : 2'd1;
   
   // hi_lo_sel
   assign uc_reg_in[`M14K_HILOS] = (state_nxt == MULT_ACC2) | mfhi_cmd_w_nxt;
   assign hi_lo_sel = uc_reg_out[`M14K_HILOS];

  
//verilint 240 on
endmodule // m14k_mdl_ctl
