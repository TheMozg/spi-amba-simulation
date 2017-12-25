
//    ALU specific Constants File

// $Id: \$
// mips_repository_id: m14k_alu_const.vh, v 1.1 

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


//  ----------------------------------------------------------------------------
//  CP0 Register IDs
//  ----------------------------------------------------------------------------

// Defines for ALU cp0 registers
`define M14K_CP0_MVPCON_ID		5'd0
`define M14K_CP0_VPECON_ID		5'd1
`define M14K_CP0_TCSTATUS_ID		5'd2
`define M14K_CP0_CONTEXT_ID		5'd4
`define M14K_CP0_SRSCONF_ID		5'd6
`define	M14K_CP0_HWRENA_ID		5'd7
`define	M14K_CP0_COUNT_ID		5'd9
`define M14K_CP0_ENTRYHI_ID		5'd10
`define	M14K_CP0_COMPARE_ID		5'd11
`define	M14K_CP0_STATUS_ID		5'd12
`define	M14K_CP0_CAUSE_ID		5'd13
`define	M14K_CP0_EPC_ID			5'd14
`define	M14K_CP0_PRID_ID			5'd15
`define	M14K_CP0_CONFIG_ID		5'd16
`define	M14K_CP0_DEBUG_ID		5'd23
`define	M14K_CP0_DEPC_ID			5'd24
`define	M14K_CP0_PERFCOUNT_ID		5'd25
`define	M14K_CP0_ERROREPC_ID		5'd30
`define	M14K_CP0_DESAVE_ID		5'd31

`define	M14K_CP0_CONFIG0_AT		2'b0		// MIPS32
`define	M14K_CP0_CONFIG0_AR		3'b1		// arch revision level - release 2
`define	M14K_CP0_CONFIG0_VI		1'b0		// I$ - Not virtual

`define	M14K_CP0_CONFIG1_C2		1'b0		// no cp2
`define	M14K_CP0_CONFIG1_MD		1'b0		// No MDMX ASE implementation
`define	M14K_CP0_CONFIG1_EP		1'b1		// EJTAG Implemented

`define	M14K_CP0_CONFIG2_TU		3'd0		//
`define	M14K_CP0_CONFIG2_TS		4'd0
`define	M14K_CP0_CONFIG2_TL		4'd0		// No Tertiary $
`define	M14K_CP0_CONFIG2_TA		4'd0
`define	M14K_CP0_CONFIG2_SU		4'd0

`define	M14K_CP0_CONFIG3_LPA		1'b0
`define	M14K_CP0_CONFIG3_VINT		1'b1		// Vectored Intr implemented
`define	M14K_CP0_CONFIG3_SP		1'b0		// Small page size not supported
`define	M14K_CP0_CONFIG3_SM		1'b0		// SmarMIPS ASE is not implemented
`define	M14K_CP0_CONFIG3_TL		1'b0		// Trace Logic is not implemented
`define M14K_CP0_CONFIG3_CDMM            1'b1            // CDMM Implemented
`ifdef M14K_MT
`define M14K_CP0_CONFIG3_MT		1'b1		// MT ASE implemented
`else
`define M14K_CP0_CONFIG3_MT		1'b0		// MT ASE not implemented
`endif

`define M14K_CP0_SRS_INVALID		4'hf		// TC SRS not implemented
`define M14K_CP0_SRS_UNUSED		4'he		// TC SRS implemented but not used
 
`define	M14K_CP0_CCRES			2'd2		// Count resolution
`define	M14K_CP0_SYNCI_STEP		12'd32		// line size used by synci

`define M14K_CP0_DBG_VER  		`M14K_EJTAG_VER
`define M14K_CP0_DBG_NOSST		1'b0		// debug.nosst = 0 => single step feature available
`define M14K_CP0_DBG_NODCR		1'b0		// debug.nodcr = 0 => dseg present

`define M14K_ALU_SS			8:0		// Shadow Set + Register range. Settings: 4:0 - 8:0

// END

