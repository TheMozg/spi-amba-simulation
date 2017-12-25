//----------------------------------------------------------------------------
//
// Module:
//   mips_tcb_cfg.vh
//
// Description:
//   Configuration defines for MIPS Trace Control Block
//
//
// $Id: \$
// mips_repository_id: mips_tcb_cfg.vh, v 3.2 
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

//----------------------------------------------------------------------------

`ifdef SIMULATION
   // Configuration items +defined on command line
`else

// Width in bits of PDO_AD bus from PDTrace to TCB (16 or 32)
`define MIPS_TCB_PDOADWIDTH       16

// *******************************************************************************
// The following 4 TCB options have moved to m14k_config.vh and will be configurable
// through the GUI for Emerald. However, these options need to be defined if this
// TCB block are used for any other processors.
// Include circuitry to interface to PIB to send trace data offchip
//`define MIPS_TCB_OFFCHIP 1

// Include on-chip trace memory and TCB interface to it
//`define MIPS_TCB_ONCHIP 1

// Number of Triggers
//   0:    Do not define
//   1-8:  Define
//`define MIPS_TCB_TRIGGERS 2

// On-chip trace memory depth in 64-bit words (2^5 to 2^20)
//`define MIPS_TCB_ONCHIP_SIZE      8     // 2^8 = 256 trace words
// *******************************************************************************

`endif

`define MIPS_TCB_REVISION         4'h0


//****************************************************************************
//
//  Internal definitions.
//
//****************************************************************************
`define MIPS_TCB_EJT_TCBCONTROLA  5'h10
`define MIPS_TCB_EJT_TCBCONTROLB  5'h11
`define MIPS_TCB_EJT_TCBDATA      5'h12

`define MIPS_TCB_EJT_TCBCONFIG    5'h00
`define MIPS_TCB_EJT_TCBTW        5'h04
`define MIPS_TCB_EJT_TCBRDP       5'h05
`define MIPS_TCB_EJT_TCBWRP       5'h06
`define MIPS_TCB_EJT_TCBSTP       5'h07
`define MIPS_TCB_EJT_TCBTRIG0     5'h10
`define MIPS_TCB_EJT_TCBTRIG1     5'h11
`define MIPS_TCB_EJT_TCBTRIG2     5'h12
`define MIPS_TCB_EJT_TCBTRIG3     5'h13
`define MIPS_TCB_EJT_TCBTRIG4     5'h14
`define MIPS_TCB_EJT_TCBTRIG5     5'h15
`define MIPS_TCB_EJT_TCBTRIG6     5'h16
`define MIPS_TCB_EJT_TCBTRIG7     5'h17
`define MIPS_TCB_EJT_TCBPDCH      5'h18

`define MIPS_TCB_CONTROLA_ON_BITS   0
`define MIPS_TCB_CONTROLA_MODE_BITS 3:1
`define MIPS_TCB_CONTROLA_G_BITS    4
`define MIPS_TCB_CONTROLA_ASID_BITS 12:5
`define MIPS_TCB_CONTROLA_U_BITS    13
`define MIPS_TCB_CONTROLA_K_BITS    14
`define MIPS_TCB_CONTROLA_S_BITS    15
`define MIPS_TCB_CONTROLA_X_BITS    16
`define MIPS_TCB_CONTROLA_D_BITS    17
`define MIPS_TCB_CONTROLA_IO_BITS   18
`define MIPS_TCB_CONTROLA_AB_BITS   19
`define MIPS_TCB_CONTROLA_SYP_BITS  22:20
`define MIPS_TCB_CONTROLA_ADW_BITS  23

`define MIPS_TCB_CONTROLB_EN_BITS   0
`define MIPS_TCB_CONTROLB_OFC_BITS  1
`define MIPS_TCB_CONTROLB_CA_BITS   2
`define MIPS_TCB_CONTROLB_CAL_BITS  7
`define MIPS_TCB_CONTROLB_CR_BITS   10:8
`define MIPS_TCB_CONTROLB_TM_BITS   13:12
`define MIPS_TCB_CONTROLB_BF_BITS   14
`define MIPS_TCB_CONTROLB_TR_BITS   15
`define MIPS_TCB_CONTROLB_RM_BITS   16
`define MIPS_TCB_CONTROLB_WR_BITS   20
`define MIPS_TCB_CONTROLB_REG_BITS  25:21
`define MIPS_TCB_CONTROLB_WE_BITS   31

`define MIPS_TCB_TRIG_TCBINFO_BITS  31:24
`define MIPS_TCB_TRIG_TRACE_BITS    23
`define MIPS_TCB_TRIG_IMPL1_BITS    22:17
`define MIPS_TCB_TRIG_CTATRG_BITS   16
`define MIPS_TCB_TRIG_CHTRO_BITS    15
`define MIPS_TCB_TRIG_PDTRO_BITS    14
`define MIPS_TCB_TRIG_IMPL0_BITS    13:7
`define MIPS_TCB_TRIG_DM_BITS       6
`define MIPS_TCB_TRIG_CHTRI_BITS    5
`define MIPS_TCB_TRIG_PDTRI_BITS    4
`define MIPS_TCB_TRIG_TYPE_BITS     3:2
`define MIPS_TCB_TRIG_TYPE1_BIT     3
`define MIPS_TCB_TRIG_TYPE0_BIT     2
`define MIPS_TCB_TRIG_FO_BITS       1
`define MIPS_TCB_TRIG_TR_BITS       0

//`define MIPS_TCB_MAX_TRIGGERS 8
//`define MIPS_TCB_TRIGGER_BITS (32*`MIPS_TCB_MAX_TRIGGERS)-1 : 0
