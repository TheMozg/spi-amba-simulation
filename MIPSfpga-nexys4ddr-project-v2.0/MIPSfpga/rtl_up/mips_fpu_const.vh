//	mips_start_of_internal_header
//	Unpublished work (c) MIPS Technologies, Inc. All rights reserved.
//	
// $Id: mips_fpu_const.vh,v 1.1 2012/07/30 05:59:01 bo Exp $
//
//	Unpublished rights reserved under U.S. copyright law.
//	
//	PROPRIETARY/SECRET CONFIDENTIAL INFORMATION OF MIPS TECHNOLOGIES,
//	INC. FOR INTERNAL USE ONLY.
//	
//	Under no circumstances (contract or otherwise) may this information be
//	disclosed to, or copied, modified or used by anyone other than employees
//	or contractors of MIPS Technologies having a need to know.
//	mips_end_of_internal_header
//	

`include "m14k_const.vh"

// FPU CTRL defines
`define MIPS_FC_FIR_PR		8'h00		// FPU Revision

`define MIPS_FPU_EXTERNAL_CLOCKGATING	1

`define MIPS_HAS_RELEASE2		1

`define MIPS_RB_TO_FRF_RAM_WIDTH	1
`define MIPS_RB_FROM_FRF_RAM_WIDTH	1
