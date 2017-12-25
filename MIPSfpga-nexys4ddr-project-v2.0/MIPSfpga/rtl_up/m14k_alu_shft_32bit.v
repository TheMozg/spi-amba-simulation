// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_alu_shft_32bit
//            32bit shifter module for dsp
//
//	$Id: \$
//	mips_repository_id: m14k_alu_shft_32bit.mv, v 1.2 
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

module m14k_alu_shft_32bit(
	dp_apipe_e,
	dp_bpipe_e,
	dp_cpipe_e,
	sh_subst_ctl_e,
	sh_high_sel_e,
	sh_high_index_e,
	sh_low_sel_e,
	sh_low_index_4_e,
	sh_shright_e,
	append_e,
	dp_shift_e,
	dp_bshift_e,
	dp_shft_rnd_e);

	
	/*hookios*/
	input	[4:0]	dp_apipe_e;
	input	[31:0]	dp_bpipe_e;
	input	[31:0]	dp_cpipe_e;
	input		sh_subst_ctl_e;
	input		sh_high_sel_e;
	input	[4:0]	sh_high_index_e;
	input		sh_low_sel_e;
	input		sh_low_index_4_e;
	input		sh_shright_e;
	input		append_e;

	output	[31:0]	dp_shift_e;
	output	[31:0]	dp_bshift_e;
	output		dp_shft_rnd_e;

// BEGIN Wire declarations made by MVP
wire [31:0] /*[31:0]*/ shift_3_e;
wire [31:0] /*[31:0]*/ shift_4_e;
wire [31:0] /*[31:0]*/ dp_bshift_e;
wire [31:0] /*[31:0]*/ shift_subst_e;
wire [31:0] /*[31:0]*/ shift_0_e;
wire [4:0] /*[4:0]*/ shift_low_e;
wire [31:0] /*[31:0]*/ shift_e;
wire [4:0] /*[4:0]*/ shift_amt_e;
wire [31:0] /*[31:0]*/ shift_1_e;
wire [31:0] /*[31:0]*/ dp_shift_e;
wire dp_shft_rnd_e;
wire [4:0] /*[4:0]*/ shift_high_e;
wire [31:0] /*[31:0]*/ shift_2_e;
// END Wire declarations made by MVP



	// Shift/Rotate/Insert/Extract ----------------------------------------

	// If shift left operation then shift 32-dp_apipe_e
	mvp_mux2 #(4) _shift_amt_e_4_1_(shift_amt_e[4:1],sh_shright_e, { (dp_apipe_e[4] ^ (|dp_apipe_e[3:0])),
							  (dp_apipe_e[3] ^ (|dp_apipe_e[2:0])),
							  (dp_apipe_e[2] ^ (|dp_apipe_e[1:0])),
							  (dp_apipe_e[1] ^ (dp_apipe_e[0])) },
						     dp_apipe_e [4:1]);
	assign shift_amt_e [0] = dp_apipe_e[0];


	// barrel shifter, first bits then bytes
	mvp_mux2 #(32) _shift_0_e_31_0_(shift_0_e[31:0],shift_amt_e[0], dp_bpipe_e, { dp_bpipe_e[0], dp_bpipe_e[31:1] });
	mvp_mux2 #(32) _shift_1_e_31_0_(shift_1_e[31:0],shift_amt_e[1], shift_0_e, { shift_0_e[1:0], shift_0_e[31:2] });
	mvp_mux2 #(32) _shift_2_e_31_0_(shift_2_e[31:0],shift_amt_e[2], shift_1_e, { shift_1_e[3:0], shift_1_e[31:4] });
	mvp_mux2 #(32) _shift_3_e_31_0_(shift_3_e[31:0],shift_amt_e[3], shift_2_e, { shift_2_e[7:0], shift_2_e[31:8] });
	mvp_mux2 #(32) _shift_4_e_31_0_(shift_4_e[31:0],shift_amt_e[4], shift_3_e, { shift_3_e[15:0], shift_3_e[31:16] });

	assign dp_shift_e [31:0] = shift_e[31:0];
	assign dp_bshift_e [31:0] = shift_4_e[31:0];


	assign dp_shft_rnd_e = shift_4_e[31] ;

	// Substitude word
	assign shift_subst_e [31:0] = { 32 {sh_subst_ctl_e & dp_bpipe_e[31]}} | 
			{32{append_e}} & dp_cpipe_e;

	// High range index
	// High Select: 0: dec_sh_high_index_ag, 1: 31-Apipe
	mvp_mux2 #(5) _shift_high_e_4_0_(shift_high_e[4:0],sh_high_sel_e, sh_high_index_e, ~dp_apipe_e[4:0]); 

	// Low range index, [3:0] = 4'b0
	// Low Select: 1: dec_sh_low_index_ag, 1: Apipe
	mvp_mux2 #(5) _shift_low_e_4_0_(shift_low_e[4:0],sh_low_sel_e, { sh_low_index_4_e, 4'b0 }, dp_apipe_e[4:0]);


	// Substitute part of rotated word with signextension, zeroes, insert into word
	// Or entire word with swap
	// if (shift_high_e < shift_low_e) entire word is substituted, used by swap instruction
	mvp_mux2 #(1) _shift_e_0_0_(shift_e[0],(shift_high_e >= 5'd0) & (5'd0 >= shift_low_e),
		      shift_subst_e[0], shift_4_e[0]);
	mvp_mux2 #(1) _shift_e_1_1_(shift_e[1],(shift_high_e >= 5'd1) & (5'd1 >= shift_low_e),
		      shift_subst_e[1], shift_4_e[1]);
	mvp_mux2 #(1) _shift_e_2_2_(shift_e[2],(shift_high_e >= 5'd2) & (5'd2 >= shift_low_e),
		      shift_subst_e[2], shift_4_e[2]);
	mvp_mux2 #(1) _shift_e_3_3_(shift_e[3],(shift_high_e >= 5'd3) & (5'd3 >= shift_low_e),
		      shift_subst_e[3], shift_4_e[3]);
	mvp_mux2 #(1) _shift_e_4_4_(shift_e[4],(shift_high_e >= 5'd4) & (5'd4 >= shift_low_e),
		      shift_subst_e[4], shift_4_e[4]);
	mvp_mux2 #(1) _shift_e_5_5_(shift_e[5],(shift_high_e >= 5'd5) & (5'd5 >= shift_low_e),
		      shift_subst_e[5], shift_4_e[5]);
	mvp_mux2 #(1) _shift_e_6_6_(shift_e[6],(shift_high_e >= 5'd6) & (5'd6 >= shift_low_e),
		      shift_subst_e[6], shift_4_e[6]);
	mvp_mux2 #(1) _shift_e_7_7_(shift_e[7],(shift_high_e >= 5'd7) & (5'd7 >= shift_low_e),
		      shift_subst_e[7], shift_4_e[7]);
	mvp_mux2 #(1) _shift_e_8_8_(shift_e[8],(shift_high_e >= 5'd8) & (5'd8 >= shift_low_e),
		      shift_subst_e[8], shift_4_e[8]);
	mvp_mux2 #(1) _shift_e_9_9_(shift_e[9],(shift_high_e >= 5'd9) & (5'd9 >= shift_low_e),
		      shift_subst_e[9], shift_4_e[9]);
	mvp_mux2 #(1) _shift_e_10_10_(shift_e[10],(shift_high_e >= 5'd10) & (5'd10 >= shift_low_e),
		       shift_subst_e[10], shift_4_e[10]);
	mvp_mux2 #(1) _shift_e_11_11_(shift_e[11],(shift_high_e >= 5'd11) & (5'd11 >= shift_low_e),
		       shift_subst_e[11], shift_4_e[11]);
	mvp_mux2 #(1) _shift_e_12_12_(shift_e[12],(shift_high_e >= 5'd12) & (5'd12 >= shift_low_e),
		       shift_subst_e[12], shift_4_e[12]);
	mvp_mux2 #(1) _shift_e_13_13_(shift_e[13],(shift_high_e >= 5'd13) & (5'd13 >= shift_low_e),
		       shift_subst_e[13], shift_4_e[13]);
	mvp_mux2 #(1) _shift_e_14_14_(shift_e[14],(shift_high_e >= 5'd14) & (5'd14 >= shift_low_e),
		       shift_subst_e[14], shift_4_e[14]);
	mvp_mux2 #(1) _shift_e_15_15_(shift_e[15],(shift_high_e >= 5'd15) & (5'd15 >= shift_low_e),
		       shift_subst_e[15], shift_4_e[15]);
	mvp_mux2 #(1) _shift_e_16_16_(shift_e[16],(shift_high_e >= 5'd16) & (5'd16 >= shift_low_e),
		       shift_subst_e[16], shift_4_e[16]);
	mvp_mux2 #(1) _shift_e_17_17_(shift_e[17],(shift_high_e >= 5'd17) & (5'd17 >= shift_low_e),
		       shift_subst_e[17], shift_4_e[17]);
	mvp_mux2 #(1) _shift_e_18_18_(shift_e[18],(shift_high_e >= 5'd18) & (5'd18 >= shift_low_e),
		       shift_subst_e[18], shift_4_e[18]);
	mvp_mux2 #(1) _shift_e_19_19_(shift_e[19],(shift_high_e >= 5'd19) & (5'd19 >= shift_low_e),
		       shift_subst_e[19], shift_4_e[19]);
	mvp_mux2 #(1) _shift_e_20_20_(shift_e[20],(shift_high_e >= 5'd20) & (5'd20 >= shift_low_e),
		       shift_subst_e[20], shift_4_e[20]);
	mvp_mux2 #(1) _shift_e_21_21_(shift_e[21],(shift_high_e >= 5'd21) & (5'd21 >= shift_low_e),
		       shift_subst_e[21], shift_4_e[21]);
	mvp_mux2 #(1) _shift_e_22_22_(shift_e[22],(shift_high_e >= 5'd22) & (5'd22 >= shift_low_e),
		       shift_subst_e[22], shift_4_e[22]);
	mvp_mux2 #(1) _shift_e_23_23_(shift_e[23],(shift_high_e >= 5'd23) & (5'd23 >= shift_low_e),
		       shift_subst_e[23], shift_4_e[23]);
	mvp_mux2 #(1) _shift_e_24_24_(shift_e[24],(shift_high_e >= 5'd24) & (5'd24 >= shift_low_e),
		       shift_subst_e[24], shift_4_e[24]);
	mvp_mux2 #(1) _shift_e_25_25_(shift_e[25],(shift_high_e >= 5'd25) & (5'd25 >= shift_low_e),
		       shift_subst_e[25], shift_4_e[25]);
	mvp_mux2 #(1) _shift_e_26_26_(shift_e[26],(shift_high_e >= 5'd26) & (5'd26 >= shift_low_e),
		       shift_subst_e[26], shift_4_e[26]);
	mvp_mux2 #(1) _shift_e_27_27_(shift_e[27],(shift_high_e >= 5'd27) & (5'd27 >= shift_low_e),
		       shift_subst_e[27], shift_4_e[27]);
	mvp_mux2 #(1) _shift_e_28_28_(shift_e[28],(shift_high_e >= 5'd28) & (5'd28 >= shift_low_e),
		       shift_subst_e[28], shift_4_e[28]);
	mvp_mux2 #(1) _shift_e_29_29_(shift_e[29],(shift_high_e >= 5'd29) & (5'd29 >= shift_low_e),
		       shift_subst_e[29], shift_4_e[29]);
	mvp_mux2 #(1) _shift_e_30_30_(shift_e[30],(shift_high_e >= 5'd30) & (5'd30 >= shift_low_e),
		       shift_subst_e[30], shift_4_e[30]);
	mvp_mux2 #(1) _shift_e_31_31_(shift_e[31],(shift_high_e >= 5'd31) & (5'd31 >= shift_low_e),
		       shift_subst_e[31], shift_4_e[31]);
	

endmodule
