// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_edp_buf_misc
//            execution data path
//
//	$Id: \$
//	mips_repository_id: m14k_edp_buf_misc.mv, v 1.1 
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

`include "m14k_const.vh"

module m14k_edp_buf_misc(
	mpc_udisel_m,
	mpc_ir_e,
	mpc_irval_e,
	edp_abus_e,
	edp_bbus_e,
	cpz_rbigend_e,
	cpz_kuc_e,
	mpc_killmd_m,
	mpc_run_ie,
	mpc_run_m,
	mpc_udislt_sel_m,
	asp_m,
	greset,
	gclk,
	gscanenable,
	gscanmode,
	UDI_rd_m,
	UDI_wrreg_e,
	UDI_ri_e,
	UDI_stall_m,
	UDI_present,
	UDI_honor_cee,
	bit0_m,
	UDI_ir_e,
	UDI_irvalid_e,
	UDI_rs_e,
	UDI_rt_e,
	UDI_endianb_e,
	UDI_kd_mode_e,
	UDI_kill_m,
	UDI_start_e,
	UDI_run_m,
	UDI_greset,
	UDI_gscanenable,
	UDI_gclk,
	edp_udi_wrreg_e,
	edp_udi_ri_e,
	edp_udi_stall_m,
	edp_udi_present,
	edp_udi_honor_cee,
	res_m);

	
      /* Inputs */
    input               mpc_udisel_m;
    input [31:0]	mpc_ir_e;		// Full instn
    input               mpc_irval_e;            // IR is valid
    input [31:0]        edp_abus_e;		        
    input [31:0]        edp_bbus_e;		        
    input               cpz_rbigend_e;
    input               cpz_kuc_e;
    input               mpc_killmd_m;
    input               mpc_run_ie;
    input               mpc_run_m;
    input               mpc_udislt_sel_m;
    input [31:0]        asp_m;
    input               greset;
    input               gclk;
    input               gscanenable;
    input               gscanmode;
    input [31:0]        UDI_rd_m;    
    input [4:0]         UDI_wrreg_e;
    input               UDI_ri_e;
    input               UDI_stall_m;
    input               UDI_present;
    input               UDI_honor_cee;
    input               bit0_m;

        
        /* Outputs */
    output [31:0]       UDI_ir_e;		// Full instn
    output              UDI_irvalid_e;          // IR is valid
    output [31:0]       UDI_rs_e;               
    output [31:0]       UDI_rt_e;
    output              UDI_endianb_e;
    output              UDI_kd_mode_e;
    output              UDI_kill_m;
    output              UDI_start_e;
    output              UDI_run_m;
    output              UDI_greset;
    output              UDI_gscanenable;
    output              UDI_gclk;     
    output [4:0]        edp_udi_wrreg_e;
    output              edp_udi_ri_e;
    output              edp_udi_stall_m;
    output              edp_udi_present;
    output              edp_udi_honor_cee;
    output [31:0]       res_m;

// BEGIN Wire declarations made by MVP
wire [31:0] /*[31:0]*/ UDI_rs_e;
wire [31:0] /*[31:0]*/ res_m;
wire edp_udi_stall_m;
wire UDI_kd_mode_e;
wire UDI_greset;
wire UDI_irvalid_e;
wire UDI_kill_m;
wire [4:0] /*[4:0]*/ edp_udi_wrreg_e;
wire UDI_gclk;
wire [31:0] /*[31:0]*/ UDI_ir_e;
wire edp_udi_ri_e;
wire UDI_start_e;
wire edp_udi_honor_cee;
wire [31:0] /*[31:0]*/ UDI_rt_e;
wire edp_udi_present;
wire UDI_gscanenable;
wire UDI_endianb_e;
wire UDI_run_m;
// END Wire declarations made by MVP




        assign UDI_ir_e[31:0] = 32'h0;
	assign UDI_irvalid_e = 1'b0;
	assign UDI_rs_e[31:0] = 32'b0;
	assign UDI_rt_e[31:0] = 32'b0;
	assign UDI_endianb_e = 1'b0;
	assign UDI_kd_mode_e = 1'b0;
	assign UDI_kill_m = 1'b0;
	assign UDI_start_e = 1'b0;
	assign UDI_run_m = 1'b0;
	assign UDI_greset = 1'b0;
	assign UDI_gscanenable = 1'b0;
	assign UDI_gclk = 1'b0;
	
        assign edp_udi_wrreg_e[4:0] = 5'b00000;
        assign edp_udi_ri_e = 1'b1;
        assign edp_udi_stall_m = 1'b0;
        assign edp_udi_present = 1'b0;
        assign edp_udi_honor_cee = 1'b0;
        mvp_mux2 #(32) _res_m_31_0_(res_m[31:0],mpc_udislt_sel_m, asp_m, {31'h0, bit0_m});

        

endmodule	// m14k_edp_buf_misc





