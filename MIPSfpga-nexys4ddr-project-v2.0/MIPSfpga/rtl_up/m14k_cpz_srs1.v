// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_cpz_srs1
//           Coprocessor Zero Shadow Register Set control
//
//	$Id: \$
//	mips_repository_id: m14k_cpz_srs1.mv, v 1.8 
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
//	
//	

`include "m14k_const.vh"

module m14k_cpz_srs1(
	gscanenable,
	greset,
	gclk,
	srsctl_rd,
	srsctl_ld,
	srsmap_rd,
	srsmap_ld,
	srsmap2_rd,
	srsmap2_ld,
	cpz_srsctl_pss2css_m,
	srsctl_css2pss_w,
	srsctl_vec2css_w,
	srsctl_ess2css_w,
	eic_present,
	srsdisable,
	eiss,
	vectornumber,
	cpz,
	int_gid_ed,
	srsctl,
	srsmap,
	srsmap2,
	hot_srsctl_pss);


	/* Inputs */
	input		gscanenable;	// Scan Enable
	input		greset;		// Power on and reset for chip
	input	 gclk;		// Clock

	input		srsctl_rd;	// Read srsctl onto cpz line
	input		srsctl_ld;	// Load srsctl register via MTC0
	input		srsmap_rd;	// Read srsmap onto cpz line
	input		srsmap_ld;	// Load srsmap register via MTC0
	input		srsmap2_rd;	// Read srsmap onto cpz line
	input		srsmap2_ld;	// Load srsmap register via MTC0

	input		cpz_srsctl_pss2css_m;	// Copy PSS to CSS
	input		srsctl_css2pss_w;	// Copy CSS to PSS
	input		srsctl_vec2css_w;	// Copy VEC to CSS
	input		srsctl_ess2css_w;	// Copy ESS to CSS

	input		eic_present;		// External Interrupt cpntroller present
        input [3:0]     srsdisable;             // Disable some shadow sets

	input [3:0]	eiss;		// Shadow set, comes with the requested interrupt
	input [5:0]	vectornumber;	// Interrupt vektor number
	input [31:0]	cpz;		// local coprocessor write bus

	input [2:0]	int_gid_ed;

	/* Outputs */
	output [31:0]	srsctl;		// SRS Control rergister
	output [31:0]	srsmap;		// SRS Mapping register
	output [31:0]	srsmap2;	// SRS Mapping register 2
	output [3:0]	hot_srsctl_pss;

// BEGIN Wire declarations made by MVP
wire [31:0] /*[31:0]*/ srsctl;
wire [3:0] /*[3:0]*/ hot_srsctl_pss;
wire [31:0] /*[31:0]*/ srsmap2;
wire [31:0] /*[31:0]*/ srsmap;
// END Wire declarations made by MVP



	assign srsctl [31:0] = 32'h0;
	assign srsmap [31:0] = 32'h0;
	assign srsmap2 [31:0] = 32'h0;
	assign hot_srsctl_pss [3:0] = 4'h0;

// Artifact code to give the testbench a cannonical reference point independent of 
// how watch is configured
  
 //VCS coverage off 
//
//

wire [31:0] next_srs_srsctl = 32'h0;
wire [31:0] next_srs_srsmap = 32'h0;

wire [31:0] next_srs_srsmap2 = 32'h0;

//
 //VCS coverage on  
  
//

endmodule	// m14k_cpz_srs1

