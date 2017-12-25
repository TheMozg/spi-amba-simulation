// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_bistctl
//           Place-holder module for instantiation of bist controller
//
//	$Id: \$
//	mips_repository_id: m14k_bistctl.mv, v 1.1 
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

// Comments for verilint...Since this is a placeholder module for bist,
//  some inputs are unused.
//verilint 240 off // Unused input

`include "m14k_const.vh"
module m14k_bistctl(
	BistIn,
	dc_bistfrom,
	ic_bistfrom,
	tcb_bistfrom,
	rf_bistfrom,
	BistOut,
	bc_dbistto,
	bc_ibistto,
	bc_tcbbistto,
	bc_rfbistto);


	/* Inputs */
	input [`M14K_TOP_BIST_IN-1:0]	BistIn;		// top-level bist input signals
	input [`M14K_DC_BIST_FROM-1:0]	dc_bistfrom;	// bist signals from dcache
	input [`M14K_IC_BIST_FROM-1:0]	ic_bistfrom;	// bist signals from icache
	input [`M14K_TCB_TRMEM_BIST_FROM-1:0]	tcb_bistfrom;	// bist signals from tcb onchip mem
	input [`M14K_RF_BIST_FROM-1:0]	rf_bistfrom;	// bist signals from generator based RF

	/* Outputs */
	output [`M14K_TOP_BIST_OUT-1:0]	BistOut;	// top-level bist output signals
	output [`M14K_DC_BIST_TO-1:0]	bc_dbistto;	// bist signals to dcache
	output [`M14K_IC_BIST_TO-1:0]	bc_ibistto;	// bist signals to icache
	output [`M14K_TCB_TRMEM_BIST_TO-1:0]	bc_tcbbistto;	// bist signals to tcb onchip mem
	output [`M14K_RF_BIST_TO-1:0]	bc_rfbistto;	// bist signals to generator based RF

// BEGIN Wire declarations made by MVP
wire [`M14K_RF_BIST_TO-1:0] /*[0:0]*/ bc_rfbistto;
wire [`M14K_DC_BIST_TO-1:0] /*[0:0]*/ bc_dbistto;
wire [`M14K_TCB_TRMEM_BIST_TO-1:0] /*[0:0]*/ bc_tcbbistto;
wire [`M14K_IC_BIST_TO-1:0] /*[0:0]*/ bc_ibistto;
wire [`M14K_TOP_BIST_OUT-1:0] /*[0:0]*/ BistOut;
// END Wire declarations made by MVP


	/* Inouts */

	// End of I/O


	/* Internal Block Wires */


	assign BistOut [`M14K_TOP_BIST_OUT-1:0] = {`M14K_TOP_BIST_OUT{1'b0}};
	assign bc_dbistto [`M14K_DC_BIST_TO-1:0] = {`M14K_DC_BIST_TO{1'b0}};
	assign bc_ibistto [`M14K_IC_BIST_TO-1:0] = {`M14K_IC_BIST_TO{1'b0}};
	assign bc_tcbbistto [`M14K_TCB_TRMEM_BIST_TO-1:0] = {`M14K_TCB_TRMEM_BIST_TO{1'b0}};
	assign bc_rfbistto [`M14K_RF_BIST_TO-1:0] = {`M14K_RF_BIST_TO{1'b0}};

//verilint 240 on // Unused input

endmodule	// m14k_bistctl
