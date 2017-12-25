// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_udi_stub
//             stub module if UDI not implemented
//
//	$Id: \$
//	mips_repository_id: m14k_udi_stub.mv, v 1.1 
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

// Comments for verilint
// This is a stub module so most of the inputs are unused
//verilint 240 off  // Unused input

`include "m14k_const.vh"
module m14k_udi_stub(
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
	UDI_gclk,
	UDI_gscanenable,
	UDI_rd_m,
	UDI_wrreg_e,
	UDI_ri_e,
	UDI_stall_m,
	UDI_present,
	UDI_honor_cee,
	UDI_toudi,
	UDI_fromudi);


        /* Inputs */
        input [31:0]    UDI_ir_e;           // full 32 bit Spec2 Instruction
        input           UDI_irvalid_e;      // Instruction reg. valid signal.

        input [31:0]    UDI_rs_e;           // edp_abus_e data from register file
        input [31:0]    UDI_rt_e;           // edp_bbus_e data from register file

	input 		UDI_endianb_e;      // Endian - 0=little, 1=big
	input 		UDI_kd_mode_e;      // Mode - 0=user, 1=kernel or debug

        input           UDI_kill_m;         // Kill signal
        input           UDI_start_e;        // mpc_run_ie signal to start the UDI.
        input 		UDI_run_m;          // mpc_run_m signal to qualify kill_m.

        input           UDI_greset;         // greset signal to reset state machine.
        input           UDI_gclk;           // Clock
        input 		UDI_gscanenable;

        /* Outputs */
        output [31:0]   UDI_rd_m;           // Result of the UDI in M stage
        output [4:0]    UDI_wrreg_e;        // Register File address written to
                                        // 5'b0 indicates not writing to 
                                        // register file.
        output          UDI_ri_e;           // Illegal Spec2 Instn.
        output          UDI_stall_m;        // Stall the pipeline. E stage signal
	output 		UDI_present;        // Indicate whether UDI is implemented
	output 		UDI_honor_cee;        // Indicate whether UDI has local state


    // external UDI signals
  input  [`M14K_UDI_EXT_TOUDI_WIDTH-1:0] UDI_toudi; // External input to UDI module
  output  [`M14K_UDI_EXT_FROMUDI_WIDTH-1:0] UDI_fromudi; // Output from UDI module to external system    

// BEGIN Wire declarations made by MVP
wire [`M14K_UDI_EXT_FROMUDI_WIDTH-1:0] /*[0:0]*/ UDI_fromudi;
// END Wire declarations made by MVP

    
assign UDI_fromudi[`M14K_UDI_EXT_FROMUDI_WIDTH-1:0] = {`M14K_UDI_EXT_FROMUDI_WIDTH{1'b0}};
    
// This module is a dummy module which reflects that no user defined SPEC2 
// instructions have been implemented. So it just sets ri_e to 1
// to signal that any spec2 instn is illegal. 

// Inactive value for outputs and no connect for inputs

assign UDI_ri_e = 1'b1;           // Illegal Spec2 Instn.
assign UDI_rd_m = 32'b0;                // Result = 0
assign UDI_wrreg_e = 5'b0;         // No writing into register.
assign UDI_stall_m = 1'b0;
assign UDI_present = 1'b0;
assign UDI_honor_cee = 1'b0;

//verilint 240 on  // Unused input
endmodule       // m14k_udi_stub

