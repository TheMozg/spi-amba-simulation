// ###########################################################################
//
// EJTAG testbench configuration file.
//
// $Id: \$
// mips_repository_id: ejtag_tb_cfg.vh, v 3.2 
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

// Enable EJTAG testbench. If not enabled the EJTAG BIST module (ejtag_bist.mv)
// is instantiated

`define EJTB_ENABLE	1

// Configure the EJTAG TB for Jade
// It necessary to set one of TB_JADE, TB_OPAL or TB_RUBY.

`define EJTB_JADE 1
`define EJTB_EMERALD 1
`define EJTB_MIPS32 1
`define EJTB_PDTRACE 1
`define EJTB_COND_REG mvp_cregister
`define EJTB_COND_REG_CLOCK clk
`define EJTB_NORM_REG mvp_register
`define EJTB_NORM_REG_CLOCK clk
`define EJTB_CONTROL_WIDTH 32
`define EJTB_DATA_WIDTH 32
`define EJTB_ADDRESS_WIDTH 32

`define EJTB_MEM_INFO 1
`define EJTB_SEQ_INFO 1
`define EJTB_CMD_INFO 1
`define EJTB_PA_INFO 1
//`define EJTB_DEBUG 1

// Least significant bit in the physical address, when reading/writing from/to
// main memory:
//
// byte memory:       lsb=0
// halfword memory:   lsb=1
// word memory:       lsb=2
// doubleword memory: lsb=3

`define EJTB_PA_LSB	 2

// Width of trick box registers

//`define TB_REG_WIDTH	32
`define EJTB_REG_WIDTH	32

// Width of data words in main memory

//`define TB_MEMORY_WIDTH	32
`define EJTB_MEMORY_WIDTH	32

// Clock definition margin

`define	EJTB_TCK_SETUP_SYSCLK `MIPS_TB_TCK_SETUP_SYSCLK
`define	EJTB_TCK_HOLD_SYSCLK `MIPS_TB_TCK_HOLD_SYSCLK

// Path declarations

`define PROC_PATH `M14K_PATH
`ifdef MIPS_GATESIM
`define GATE_PROC_PATH `PROC_PATH
`endif
