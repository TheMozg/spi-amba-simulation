// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description:  bistctl_cache 
//            Place-holder module for instantiation of cache bist controller
//
//	$Id: \$
//	mips_repository_id: m14k_dc_bistctl.mv, v 1.1 
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
module m14k_dc_bistctl(
	cbist_to,
	tag_bist_from,
	ws_bist_from,
	data_bist_from,
	cbist_from,
	tag_bist_to,
	ws_bist_to,
	data_bist_to);


	parameter	BIST_TO_WIDTH = 1;		// top-level cache bist input width
	parameter	BIST_FROM_WIDTH = 1;		// top-level cache bist output width
	parameter	TAG_BIST_TO_WIDTH = 1;	// bist width to cache tag array
	parameter	TAG_BIST_FROM_WIDTH = 1;	// bist width from cache tag array
   	parameter	WS_BIST_TO_WIDTH = 1;
        parameter 	WS_BIST_FROM_WIDTH = 1;
	parameter	DATA_BIST_TO_WIDTH = 1;	// bist width to cache data aray
	parameter	DATA_BIST_FROM_WIDTH = 1;	// bist width from cache data aray

	/* Inputs */
	input [BIST_TO_WIDTH-1:0]		cbist_to;	// top-level cache bist input signals
	input [TAG_BIST_FROM_WIDTH-1:0]	tag_bist_from;	// bist signals from cache tag
        input [WS_BIST_FROM_WIDTH-1:0] 	ws_bist_from;
	input [DATA_BIST_FROM_WIDTH-1:0]	data_bist_from;	// bist signals from cache data

	/* Outputs */
	output [BIST_FROM_WIDTH-1:0]		cbist_from;	// top-level cache bist output signals
	output [TAG_BIST_TO_WIDTH-1:0]	tag_bist_to;	// bist signals to cache tag
	output [WS_BIST_TO_WIDTH-1:0]	        ws_bist_to;
	output [DATA_BIST_TO_WIDTH-1:0]	data_bist_to;	// bist signals to cache data

// BEGIN Wire declarations made by MVP
wire [TAG_BIST_TO_WIDTH-1:0] /*[0:0]*/ tag_bist_to;
wire [DATA_BIST_TO_WIDTH-1:0] /*[0:0]*/ data_bist_to;
wire [BIST_FROM_WIDTH-1:0] /*[0:0]*/ cbist_from;
wire [WS_BIST_TO_WIDTH-1:0] /*[0:0]*/ ws_bist_to;
// END Wire declarations made by MVP


	/* Inouts */

	// End of I/O


	/* Internal Block Wires */



	assign cbist_from [BIST_FROM_WIDTH-1:0] = {BIST_FROM_WIDTH{1'b0}};
	assign tag_bist_to [TAG_BIST_TO_WIDTH-1:0] = {BIST_FROM_WIDTH{1'b0}};
	assign ws_bist_to [WS_BIST_TO_WIDTH-1:0] = {BIST_FROM_WIDTH{1'b0}};   
	assign data_bist_to [DATA_BIST_TO_WIDTH-1:0] = {BIST_FROM_WIDTH{1'b0}};

//verilint 240 on  // Unused input
endmodule	// bistctl_cache
