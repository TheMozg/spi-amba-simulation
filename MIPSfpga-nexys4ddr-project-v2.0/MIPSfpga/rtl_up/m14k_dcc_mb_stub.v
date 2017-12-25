// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_dcc_mb_stub
//            Data Cache Controller Memory BIST stub module. 
//
//	$Id: \$
//	mips_repository_id: m14k_dcc_mb_stub.mv, v 1.3 
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
module m14k_dcc_mb_stub(
	gclk,
	greset,
	gmbinvoke,
	gscanenable,
	cpz_dcpresent,
	cpz_dcnsets,
	cpz_dcssize,
	mbdddatain,
	mbtdtagin,
	mbwdwsin,
	mbddwayselect,
	mbtdwayselect,
	dmbinvoke,
	mbddaddr,
	mbtdaddr,
	mbwdaddr,
	mbddread,
	mbtdread,
	mbwdread,
	mbddwrite,
	mbtdwrite,
	mbwdwrite,
	mbddbytesel,
	mbdddata,
	mbtddata,
	mbwddata,
	gmbddfail,
	gmbtdfail,
	gmbwdfail,
	dcc_mbdone,
	gmb_dc_algorithm);


parameter PARITY =  `M14K_PARITY_ENABLE;

// Calculated parameter

parameter T_BITS = (PARITY == 1) ? `M14K_T_PAR_BITS : `M14K_T_NOPAR_BITS;
parameter D_BITS = (PARITY == 1) ? `M14K_D_PAR_BITS : `M14K_D_NOPAR_BITS;
parameter D_BYTES = (PARITY == 1) ? `M14K_D_PAR_BYTES : `M14K_D_NOPAR_BYTES;

//Define inputs
	input 		gclk;
	input 		greset;
	input		gmbinvoke;
	input		gscanenable;	// Scan control signal for delay registers
	input   	cpz_dcpresent;	// I-cahce is present
	input [2:0]	cpz_dcnsets;	// I-cache:  number of sets<F19>
	input [1:0]	cpz_dcssize;	// I-cache associatdvity 
					// {0,1,2,3} = Direct-mapped, 2,3,4-way 

	input [D_BITS-1:0]	mbdddatain;	// 32 bit data from way select mux (data RAM)
	input [T_BITS-1:0]	mbtdtagin;	// 24 bit tag from way select mux (tag RAM)
	input [13:0]	mbwdwsin;	// 10 bit WS from way select mux (WS RAM)

//Define outputs
	output [3:0]	mbddwayselect;	// select signal for 4 to 1 mux: select 32 out of 
					// 128 bits data from D-Cache to be compared
	output [3:0]	mbtdwayselect;	// select signal for 4 to 1 mux: select 24 out of 
					// 96 bits data from D-Tag to be compared
	output		dmbinvoke;	
	output [13:2]   mbddaddr;	// High group of address for BIST
	output [13:4]	mbtdaddr;	// High group of address for BIST
	output [13:4]	mbwdaddr;	// High group of address for BIST
	
	output		mbddread;	// readstrb for data RAM
	output		mbtdread;	// readstrb for tag RAM
	output		mbwdread;	// readstrb for WS RAM
	
	output		mbddwrite;	// writestrb for data RAM
	output		mbtdwrite;	// writestrb for tag RAM
	output		mbwdwrite;	// writestrb for WS RAM
	
	
	output [3:0]	mbddbytesel;	// One hot byte select for byte write enable
	output [D_BITS-1:0] 	mbdddata;	// 32bit data for write in I-cache
	output [T_BITS-1:0] 	mbtddata;	// 24bit tag for write in I-cache
	output [13:0] 	mbwddata;	// 6bit WS for write in I-cache

	
	output		gmbddfail;  	// Asserted to inddcate that date test failed
	output		gmbtdfail;  	// Asserted to inddcate that tag test failed
	output		gmbwdfail;  	// Asserted to inddcate that WS test failed
	
	output		dcc_mbdone;	// Asserted to inddcate that all test is done

        input   [7:0]   gmb_dc_algorithm; // Alogrithm selection for I$ BIST controller

// BEGIN Wire declarations made by MVP
wire mbwdwrite;
wire [13:4] /*[13:4]*/ mbtdaddr;
wire [13:0] /*[13:0]*/ mbwddata;
wire mbtdwrite;
wire [D_BITS-1:0] /*[35:0]*/ mbdddata;
wire [T_BITS-1:0] /*[24:0]*/ mbtddata;
wire dcc_mbdone;
wire dmbinvoke;
wire gmbtdfail;
wire [3:0] /*[3:0]*/ mbddbytesel;
wire mbddwrite;
wire gmbddfail;
wire mbtdread;
wire mbwdread;
wire [13:4] /*[13:4]*/ mbwdaddr;
wire gmbwdfail;
wire mbddread;
wire [3:0] /*[3:0]*/ mbtdwayselect;
wire [13:2] /*[13:2]*/ mbddaddr;
wire [3:0] /*[3:0]*/ mbddwayselect;
// END Wire declarations made by MVP



   assign mbddwayselect  [3:0]	= 4'd0;
   assign mbtdwayselect  [3:0]	= 4'd0;
   assign mbddaddr  [13:2]     = 12'd0;
   assign mbtdaddr  [13:4]	= 10'd0;
   assign mbwdaddr  [13:4]	= 10'd0;
   assign mbddread 		= 1'd0;
   assign mbtdread 		= 1'd0;
   assign mbwdread 		= 1'd0;
   assign mbddwrite 		= 1'd0;
   assign mbtdwrite 		= 1'd0;
   assign mbwdwrite 		= 1'd0;
   assign mbddbytesel  [3:0]	= 4'd0;
   assign mbdddata  [D_BITS-1:0] 	= {D_BITS{1'b0}};
   assign mbtddata  [T_BITS-1:0] 	= {T_BITS{1'b0}};
   assign mbwddata  [13:0] 	= 14'd0;

   assign gmbddfail 		= 1'd0;
   assign gmbtdfail 		= 1'd0;
   assign gmbwdfail 		= 1'd0;
   assign dcc_mbdone 		= 1'd1;
   assign dmbinvoke		= 1'd0;

	
  
 //VCS coverage off 
// 
	// Wire used by TB to determine whether MBIST module is present
   wire		SelectDccmb;
   assign SelectDccmb		= 1'b0;
  //VCS coverage on  
  
// 


//verilint 240 on  // Unused input
endmodule
