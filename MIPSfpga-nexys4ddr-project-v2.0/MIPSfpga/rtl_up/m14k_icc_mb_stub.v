// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//	Description: m14k_icc_mb_stub
//             Instruction Cache Controller Memory BIST stub module.
//
//	$Id: \$
//	mips_repository_id: m14k_icc_mb_stub.mv, v 1.3 
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
//  some inputs are unused.
//verilint 240 off  // Unused input

`include "m14k_const.vh"
module m14k_icc_mb_stub(
	gclk,
	greset,
	gmbinvoke,
	gscanenable,
	cpz_icpresent,
	cpz_icnsets,
	cpz_icssize,
	mbdidatain,
	mbtitagin,
	mbwiwsin,
	mbdiwayselect,
	mbtiwayselect,
	imbinvoke,
	mbdiaddr,
	mbtiaddr,
	mbwiaddr,
	mbdiread,
	mbtiread,
	mbwiread,
	mbdiwrite,
	mbtiwrite,
	mbwiwrite,
	mbdidata,
	mbtidata,
	mbwidata,
	gmbdifail,
	gmbtifail,
	gmbwifail,
	icc_mbdone,
	gmb_ic_algorithm);


parameter PARITY =  `M14K_PARITY_ENABLE;

// Calculated parameter

parameter T_BITS = (PARITY == 1) ? `M14K_T_PAR_BITS : `M14K_T_NOPAR_BITS;
parameter D_BITS = (PARITY == 1) ? `M14K_D_PAR_BITS : `M14K_D_NOPAR_BITS;

//Define inputs
	input 		gclk;
	input 		greset;
	input		gmbinvoke;
	input		gscanenable;	// Scan control signal for delay registers
	input   	cpz_icpresent;	// I-cahce is present
	input [2:0]	cpz_icnsets;	// I-cache:  number of sets
	input [1:0]	cpz_icssize;	// I-cache associativity 
					// {0,1,2,3} = Direct-mapped, 2,3,4-way 

	input [D_BITS-1:0]	mbdidatain;	// 32 bit data from way select mux (data RAM)
	input [T_BITS-1:0]	mbtitagin;	// 24 bit tag from way select mux (tag RAM)
	input [5:0]	mbwiwsin;	// 10 bit WS from way select mux (WS RAM)

//Define outputs
	output [3:0]	mbdiwayselect;	// select signal for 4 to 1 mux: select 32 out of 
						// 128 bits data from I-Cahce to be compared
	output [3:0]	mbtiwayselect;	// select signal for 4 to 1 mux: select 32 out of 
						// 128 bits data from I-Cahce to be compared
	
	output		imbinvoke;
	output [13:2]   mbdiaddr;	        // High group of address for BIST
	output [13:4]	mbtiaddr;		// High group of address for BIST
	output [13:4]	mbwiaddr;		// High group of address for BIST
	
	output		mbdiread;		// readstrb for data RAM
	output		mbtiread;		// readstrb for tag RAM
	output		mbwiread;		// readstrb for WS RAM
	
	output		mbdiwrite;		// writestrb for data RAM
	output		mbtiwrite;		// writestrb for tag RAM
	output		mbwiwrite;		// writestrb for WS RAM
	
	output [D_BITS-1:0] 	mbdidata;		// 32bit data for write in I-cache
	output [T_BITS-1:0] 	mbtidata;		// 24bit tag for write in I-cache
	output [5:0] 	mbwidata;		// 6bit WS for write in I-cache
	
	output		gmbdifail;  		// Asserted to indicate that date test failed
	output		gmbtifail;  		// Asserted to indicate that tag test failed
	output		gmbwifail;  		// Asserted to indicate that WS test failed
	output		icc_mbdone;		// Asserted to indicate that all test is done
        input   [7:0]   gmb_ic_algorithm; // Alogrithm selection for I$ BIST controller

// BEGIN Wire declarations made by MVP
wire [3:0] /*[3:0]*/ mbdiwayselect;
wire mbdiwrite;
wire gmbtifail;
wire mbtiwrite;
wire icc_mbdone;
wire [13:2] /*[13:2]*/ mbdiaddr;
wire mbwiwrite;
wire [13:4] /*[13:4]*/ mbwiaddr;
wire [T_BITS-1:0] /*[24:0]*/ mbtidata;
wire mbwiread;
wire [D_BITS-1:0] /*[35:0]*/ mbdidata;
wire gmbwifail;
wire [5:0] /*[5:0]*/ mbwidata;
wire gmbdifail;
wire mbtiread;
wire [13:4] /*[13:4]*/ mbtiaddr;
wire mbdiread;
wire imbinvoke;
wire [3:0] /*[3:0]*/ mbtiwayselect;
// END Wire declarations made by MVP




   // tie off outputs
   assign mbdiwayselect [3:0]	= 4'd0;
   assign mbtiwayselect [3:0]	= 4'd0;
   assign mbdiaddr [13:2]	= 12'd0;
   assign mbtiaddr [13:4]	= 10'd0;
   assign mbwiaddr [13:4]	= 10'd0;
   assign mbdiread		= 1'd0;
   assign mbtiread		= 1'd0;
   assign mbwiread		= 1'd0;
   assign mbdiwrite		= 1'd0;
   assign mbtiwrite		= 1'd0;
   assign mbwiwrite		= 1'd0;
   assign mbdidata [D_BITS-1:0] 	= {D_BITS{1'b0}};
   assign mbtidata [T_BITS-1:0] 	= {T_BITS{1'b0}};
   assign mbwidata [5:0] 	= 6'd0;
   assign gmbdifail		= 1'd0;
   assign gmbtifail		= 1'd0;
   assign gmbwifail		= 1'd0;
   assign icc_mbdone		= 1'd1;
   assign imbinvoke		= 1'd0;

  
 //VCS coverage off 
// 
	// Wire used by TB to determine whether MBIST module is present
	wire SelectIccmb;
   assign SelectIccmb		= 1'b0;
  //VCS coverage on  
  
// 

//verilint 240 on  // Unused input
endmodule
