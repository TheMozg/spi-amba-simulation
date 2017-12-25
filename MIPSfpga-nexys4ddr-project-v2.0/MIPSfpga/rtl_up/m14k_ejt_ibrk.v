// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_ejt_ibrk 
//           EJTAG Simple Break I Channel
//
//      $Id: \$
//      mips_repository_id: m14k_ejt_ibrk.mv, v 1.13 
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
module m14k_ejt_ibrk(
	cpz_vz,
	gscanenable,
	ivaddr,
	regbusdatain,
	iba_sel,
	ibm_sel,
	asidsup,
	asid,
	guestid,
	ibasid_sel,
	ibc_sel,
	we,
	mpc_isamode_i,
	icc_halfworddethigh_i,
	umips_present,
	gclk,
	greset,
	i_match,
	regbusdataout,
	ibc_be,
	ibc_te);


	parameter CHANNEL=0 ;
/* Inputs */
	input           cpz_vz;

        input           gscanenable;     // Scan Enable
	input	[31:0]	ivaddr;		// Virtual addr of inst


	input	[31:0]	regbusdatain;	// Data in from register bus
	
	input		iba_sel;	// Select IBA register
	input		ibm_sel;	// Select IBM register

	input 		asidsup;        // mmu_asid supported
	input [7:0] 	asid;		// Current mmu_asid
	input [7:0]     guestid;
	input		ibasid_sel;	// Select IBASID register
	input		ibc_sel;	// Select IBC register
	input		we;		// Write enable for register bus
	input		mpc_isamode_i;
	input		icc_halfworddethigh_i;
	input		umips_present;	// umips is supported

	input		gclk;		// gclk
	input		greset;		// reset

/* Outputs */	

	output		i_match;	// I channel match

	output	[31:0]	regbusdataout;	// Data out from register bus

	output		ibc_be;		// BE bit
	output		ibc_te;		// TE bit

// BEGIN Wire declarations made by MVP
wire [2:0] /*[2:0]*/ ibasid_guestid;
wire [7:0] /*[7:0]*/ ibasid_asid;
wire guestid_match;
wire ibc_te_in;
wire ibasid_we_sel;
wire iba_we_sel;
wire ibc_te;
wire addr_match;
wire [31:0] /*[31:0]*/ regbusdataout;
wire ibc_asiduse;
wire [31:0] /*[31:0]*/ ibm;
wire [31:0] /*[31:0]*/ iba_out;
wire ibc_be_in;
wire ibc_be;
wire [31:0] /*[31:0]*/ iba;
wire ibm_we_sel;
wire [31:0] /*[31:0]*/ ibm_out;
wire [31:0] /*[31:0]*/ ibasid_out;
wire [31:0] /*[31:0]*/ ibc_out;
wire i_match;
wire ibasid_guestiduse;
wire ibc_reset_we_sel;
wire ibc_asiduse_in;
wire asid_match;
// END Wire declarations made by MVP



/* Code */

// IBA Register

	assign iba_we_sel	= we & iba_sel;

	mvp_cregister_wide #(32) _iba_31_0_(iba[31:0],gscanenable, iba_we_sel, gclk, regbusdatain);


// IBM Register

	assign ibm_we_sel	= we & ibm_sel;

	mvp_cregister_wide #(32) _ibm_31_0_(ibm[31:0],gscanenable, ibm_we_sel, gclk, regbusdatain);

// IBASID Register


	assign ibasid_we_sel	= we & ibasid_sel;
	mvp_cregister_wide #(8) _ibasid_asid_7_0_(ibasid_asid[7:0],gscanenable, ibasid_we_sel, gclk, {8{asidsup}} & regbusdatain[7:0]);

	mvp_cregister #(3) _ibasid_guestid_2_0_(ibasid_guestid[2:0],ibasid_sel & we, gclk, {3{cpz_vz}} & regbusdatain[26:24]);
	mvp_cregister #(1) _ibasid_guestiduse(ibasid_guestiduse,ibasid_sel & we | greset, gclk, greset ? 1'b0 : cpz_vz & regbusdatain[23]);

// IBC Register

	assign ibc_be_in	= greset ? 1'b0 : regbusdatain[0];
	assign ibc_te_in	= greset ? 1'b0 : regbusdatain[2];

	assign ibc_reset_we_sel= greset | (we & ibc_sel);

	mvp_cregister #(1) _ibc_be(ibc_be,ibc_reset_we_sel, gclk, ibc_be_in);
	mvp_cregister #(1) _ibc_te(ibc_te,ibc_reset_we_sel, gclk, ibc_te_in);
	assign ibc_asiduse_in	= asidsup && regbusdatain[23];
	mvp_cregister #(1) _ibc_asiduse(ibc_asiduse,ibc_reset_we_sel, gclk, ibc_asiduse_in);

// Mux out register values

	assign iba_out	[31:0]	= iba;
	assign ibm_out [31:0]	= ibm;

	assign ibasid_out[31:0]= {(cpz_vz ? {5'b0, ibasid_guestid[2:0],ibasid_guestiduse} : 9'b0) , 2'b0, 1'b0, 12'b0, ibasid_asid};
	assign ibc_out	[31:0]	= {8'b0, ibc_asiduse, 20'b0, ibc_te, 1'b0, ibc_be};

	mvp_mux1hot_4 #(32) _regbusdataout_31_0_(regbusdataout[31:0],iba_sel, iba_out, ibm_sel, ibm_out,
				ibasid_sel, ibasid_out, ibc_sel, ibc_out);




// I channel match condition:
	assign asid_match = ~ibc_asiduse | (asid == ibasid_asid);
	assign guestid_match = ~ibasid_guestiduse | (guestid[2:0] == ibasid_guestid[2:0]);

	assign addr_match = (ivaddr | ibm) == (iba | ibm);
	assign i_match = addr_match & asid_match & (guestid_match | ~cpz_vz);


// The End !

endmodule
