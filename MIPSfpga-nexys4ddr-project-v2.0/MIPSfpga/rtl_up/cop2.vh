// ###########################################################################
//
// Header file for cop2 testbench files
//
// $Id: \$
// mips_repository_id: cop2.vh, v 2.2 
//
// mips_start_of_legal_notice
// ***************************************************************************
// Unpublished work (c) MIPS Technologies, Inc.  All rights reserved. 
// Unpublished rights reserved under the copyright laws of the United States
// of America and other countries.
// 
// MIPS TECHNOLOGIES PROPRIETARY / RESTRICTED CONFIDENTIAL - HEIGHTENED
// STANDARD OF CARE REQUIRED AS PER CONTRACT
// 
// This code is confidential and proprietary to MIPS Technologies, Inc. ("MIPS
// Technologies") and may be disclosed only as permitted in writing by MIPS
// Technologies.  Any copying, reproducing, modifying, use or disclosure of
// this code (in whole or in part) that is not expressly permitted in writing
// by MIPS Technologies is strictly prohibited.  At a minimum, this code is
// protected under trade secret, unfair competition and copyright laws. 
// Violations thereof may result in criminal penalties and fines.
// 
// MIPS Technologies reserves the right to change the code to improve
// function, design or otherwise.	MIPS Technologies does not assume any
// liability arising out of the application or use of this code, or of any
// error or omission in such code.  Any warranties, whether express,
// statutory, implied or otherwise, including but not limited to the implied
// warranties of merchantability or fitness for a particular purpose, are
// excluded.  Except as expressly provided in any written license agreement
// from MIPS Technologies, the furnishing of this code does not give recipient
// any license to any intellectual property rights, including any patent
// rights, that cover this code.
// 
// This code shall not be exported, reexported, transferred, or released,
// directly or indirectly, in violation of the law of any country or
// international law, regulation, treaty, Executive Order, statute, amendments
// or supplements thereto.  Should a conflict arise regarding the export,
// reexport, transfer, or release of this code, the laws of the United States
// of America shall be the governing law.
// 
// This code may only be disclosed to the United States government
// ("Government"), or to Government users, with prior written consent from
// MIPS Technologies.  This code constitutes one or more of the following:
// commercial computer software, commercial computer software documentation or
// other commercial items.  If the user of this code, or any related
// documentation of any kind, including related technical data or manuals, is
// an agency, department, or other entity of the Government, the use,
// duplication, reproduction, release, modification, disclosure, or transfer
// of this code, or any related documentation of any kind, is restricted in
// accordance with Federal Acquisition Regulation 12.212 for civilian agencies
// and Defense Federal Acquisition Regulation Supplement 227.7202 for military
// agencies.  The use of this code by the Government is further restricted in
// accordance with the terms of the license agreement(s) and/or applicable
// contract terms and conditions covering this code from MIPS Technologies.
// 
// 
// 
// ***************************************************************************
// mips_end_of_legal_notice
//
// ###########################################################################

// Internal data bus width
`define M14K_DATA_WIDTH_INT	64
// Data bus width
`ifdef COP2_TB_64BIT
  `define M14K_DATA_WIDTH	64
`else
  `define M14K_DATA_WIDTH	32
`endif

// Pipeline depth

`define M14K_SidCp2   11
`define M14K_SidCp2B  12
`define M14K_SidCp2C  13
`define M14K_SidCp2D  14
`define M14K_SidCp2E  15
`define M14K_SidC2Gpr 23
`define M14K_SidC2Exc1 45
`define M14K_SidC2Exc2 46
`define M14K_SidC2Exc3 47
`define M14K_SidC2Exc4 48

                               
// Opcode for opcodep
`define M14K_COP2_OP        6'b010010       // IR[31:26]: Coprocessor 2 instruction
`define M14K_LWC2           6'b110010       // IR[31:26]: Load Word to COP2 register
`define M14K_SWC2           6'b111010       // IR[31:26]: Store Word from COP2 register
`define M14K_LDC2 	        6'b110110	// IR[31:26]: Double Load Word to COP2 register
`define M14K_SDC2 	        6'b111110	// IR[31:26]: Double Store Word from COP2 register
   
// COPz encoding of rs field
`define M14K_COP_BC		3'b01		// IR[25:24]: Branch on COP2 condition code check
`define M14K_COP_MFC 	5'b00000	// IR[25:21]: Move register from COP
`define M14K_COP_CFC 	5'b00010	// IR[25:21]: Move control from COP2 
`define M14K_COP_MFHC   5'b00011	// IR[25:21]: Move upper 32 bits of register from COP2 
`define M14K_COP_MTC 	5'b00100	// IR[25:21]: Move to COP2 register
`define M14K_COP_CTC 	5'b00110	// IR[25:21]: Move to COP2 control
`define M14K_COP_MTHC   5'b00111	// IR[25:21]: Move upper 32 bits of register to COP2 
`define M14K_COP_ARITHM 	1'b1		// IR[25]: Coprocessor Arithmetric instruction
`define M14K_COP_DMFC 	5'b00001	// IR[25:21]: Double Move register from COP
`define M14K_COP_DMTC 	5'b00101	// IR[25:21]: Double Move to COP2 register

// Exception field encodeings
//`define M14K_COP_EXC_C2E 	5'b10010	// COP2 Exception
`define M14K_COP_EXC_RI 	5'b01010	// Reserved Instruction Exception
//`define M14K_COP_EXC_IS1 	5'b10000	// Impl. Specific Exception 1
//`define M14K_COP_EXC_IS2 	5'b10001	// Impl/ Specific Exception 2
   
// decode bits
`define 	 DEC_WIDTH 	18

`define M14K_DEC_HALFWORD 	17
`define M14K_DEC_EXCCODE 	16:12
`define M14K_DEC_EXC 	11
`define M14K_DEC_CREG	10
`define M14K_DEC_CCC	9
`define M14K_DEC_MF 	8
`define M14K_DEC_MT 	7
`define M14K_DEC_AR 	6
`define M14K_DEC_BR 	5
`define M14K_DEC_REG 	4:0

// Record bits
`define          RECORD_WIDTH 		(`M14K_DATA_WIDTH_INT*2)+266

`define M14K_RECORD_UPPER_DATA  (`M14K_DATA_WIDTH_INT*2)+265
`define M14K_RECORD_EXCCOUNT    (`M14K_DATA_WIDTH_INT*2)+264:`M14K_DATA_WIDTH_INT+233
`define M14K_RECORD_INST32 		(`M14K_DATA_WIDTH_INT*2)+232
`define M14K_RECORD_ENDIAN 		(`M14K_DATA_WIDTH_INT*2)+231
`define M14K_RECORD_FDATA 		(`M14K_DATA_WIDTH_INT*2)+230:`M14K_DATA_WIDTH_INT+231
`define M14K_RECORD_TDATA		`M14K_DATA_WIDTH_INT+230:231
`define M14K_RECORD_FORDER		230:228
`define M14K_RECORD_MACTAG		227:196
`define M14K_RECORD_ITAG		195:164
`define M14K_RECORD_IR		163:132
`define M14K_RECORD_NEED_NULLS	131
`define M14K_RECORD_NULLS  	 	130
`define M14K_RECORD_NULL  	 	129
`define M14K_RECORD_NEED_KILLS  	128
`define M14K_RECORD_KILLS  	 	127
`define M14K_RECORD_KILL  	 	126:125
`define M14K_RECORD_NEED_EXCS  	124
`define M14K_RECORD_DELAY_EXCS  	123:92
`define M14K_RECORD_EXCS  	 	91
`define M14K_RECORD_EXC  	 	90
`define M14K_RECORD_EXCCODE  	89:85
`define M14K_RECORD_NEED_CCCS  	84
`define M14K_RECORD_DELAY_CCCS  	83:52
`define M14K_RECORD_CCCS  	 	51
`define M14K_RECORD_CCC  	 	50
`define M14K_RECORD_NEED_FDS  	49
`define M14K_RECORD_DELAY_FDS  	48:17
`define M14K_RECORD_FDS  	 	16
`define M14K_RECORD_FDATA_VALID  	15
`define M14K_RECORD_FDATA_CREG  	14
`define M14K_RECORD_FDATA_REG  	13:9
`define M14K_RECORD_NEED_TDS  	8
`define M14K_RECORD_TDS  	 	7
`define M14K_RECORD_TDATA_CREG  	6
`define M14K_RECORD_TDATA_REG  	5:1
`define M14K_RECORD_USED 		0

`define M14K_GPR 			1'b0
`define M14K_CPR 			1'b1

// GPR registers.
`define M14K_CP2_NUM_GPR_FILES	1
`define M14K_CP2_GPR_MAX_REG	((`M14K_CP2_NUM_GPR_FILES*32)-1)

// Control registers
`define M14K_CP2_CTL_EXC 		0
`define M14K_CP2_CTL_CC 		1
`define M14K_CP2_CTL_COMPL 		2
`define M14K_CP2_CTL_CTRL		3
`define M14K_CP2_CTL_BUSY		10
`define M14K_CP2_CTL_DELAY		11

// Above `defines with 5'd included for vxl support
`define M14K_CP2_CTL_EXC5 		5'd0
`define M14K_CP2_CTL_CC5 		5'd1
`define M14K_CP2_CTL_COMPL5		5'd2
`define M14K_CP2_CTL_CTRL5		5'd3
`define M14K_CP2_CTL_BUSY5		5'd10
`define M14K_CP2_CTL_DELAY5		5'd11

`define M14K_CP2_CTL_EXC_NAME 	"C2EXC"
`define M14K_CP2_CTL_CC_NAME 	"C2CC"
`define M14K_CP2_CTL_COMPL_NAME 	"C2COMPL"
`define M14K_CP2_CTL_CTRL_NAME 	"C2CTRL"
`define M14K_CP2_CTL_BUSY_NAME 	"C2BUSY"
`define M14K_CP2_CTL_DELAY_NAME 	"C2DELAY"
`define M14K_CP2_CTL_UNKNOWN_NAME 	"UNK C2REG"

// C2_EXC fields
`define M14K_CP2_CTL_EXC_ENABLE 	32'h00000001
`define M14K_CP2_CTL_EXC_EXCEN 	32'h00000002
`define M14K_CP2_CTL_EXC_DELCNT 	32'h000003fc
`define M14K_CP2_CTL_EXC_CODE 	32'h00007c00
`define M14K_CP2_CTL_EXC_KILL 	32'h00030000
`define M14K_CP2_CTL_EXC_SENT 	32'h00040000
`define M14K_CP2_CTL_EXC_ENABLE_SHF	0
`define M14K_CP2_CTL_EXC_EXCEN_SHF	1
`define M14K_CP2_CTL_EXC_DELCNT_SHF	2
`define M14K_CP2_CTL_EXC_CODE_SHF	10
`define M14K_CP2_CTL_EXC_KILL_SHF	16
`define M14K_CP2_CTL_EXC_SENT_SHF	18
`define M14K_CP2_CTL_EXC_VALID_BITS (`M14K_CP2_CTL_EXC_ENABLE | `M14K_CP2_CTL_EXC_EXCEN | `M14K_CP2_CTL_EXC_DELCNT | `M14K_CP2_CTL_EXC_CODE | `M14K_CP2_CTL_EXC_KILL | `M14K_CP2_CTL_EXC_SENT)

// C2_CC fields
`define M14K_CP2_CTL_CC_COND	32'h000000ff
`define M14K_CP2_CTL_CC_ENABLE	32'h00007f00
`define M14K_CP2_CTL_CC_COND_SHF	0
`define M14K_CP2_CTL_CC_ENABLE_SHF	8
`define M14K_CP2_CTL_CC_VALID_BITS	(`M14K_CP2_CTL_CC_COND | `M14K_CP2_CTL_CC_ENABLE)

// C2_COMPL fields
`define M14K_CP2_CTL_COMPL_OPCODE	32'hffffffff
`define M14K_CP2_CTL_COMPL_OPCODE_SHF	0
`define M14K_CP2_CTL_COMPL_VALID_BITS `M14K_CP2_CTL_COMPL_OPCODE

// C2_CTRL fields
`define M14K_CP2_CTL_CTRL_COMPLEN 	32'h00000001
`define M14K_CP2_CTL_CTRL_ENDIAN0 	32'h00000002
`define M14K_CP2_CTL_CTRL_INST320 	32'h00000004
`define M14K_CP2_CTL_CTRL_ENDIAN1 	32'h00000008
`define M14K_CP2_CTL_CTRL_INST321 	32'h00000010
`define M14K_CP2_CTL_CTRL_COMPLEN_SHF	0
`define M14K_CP2_CTL_CTRL_ENDIAN0_SHF	1
`define M14K_CP2_CTL_CTRL_INST320_SHF	2
`define M14K_CP2_CTL_CTRL_ENDIAN1_SHF	3
`define M14K_CP2_CTL_CTRL_INST321_SHF	4
`define M14K_CP2_CTL_CTRL_VALID_BITS (`M14K_CP2_CTL_CTRL_COMPLEN | `M14K_CP2_CTL_CTRL_ENDIAN0 | `M14K_CP2_CTL_CTRL_INST320 | `M14K_CP2_CTL_CTRL_ENDIAN1 | `M14K_CP2_CTL_CTRL_INST321)

// C2_BUSY fields
`define M14K_CP2_CTL_BUSY_FIXEDDLY	32'h00000001
`define M14K_CP2_CTL_BUSY_ADELAY	32'h0000ff00
`define M14K_CP2_CTL_BUSY_TDELAY	32'h00ff0000
`define M14K_CP2_CTL_BUSY_FDELAY	32'hff000000
`define M14K_CP2_CTL_BUSY_FIXEDDLY_SHF	0
`define M14K_CP2_CTL_BUSY_ADELAY_SHF	8
`define M14K_CP2_CTL_BUSY_TDELAY_SHF	16
`define M14K_CP2_CTL_BUSY_FDELAY_SHF	24
`define M14K_CP2_CTL_BUSY_VALID_BITS (`M14K_CP2_CTL_BUSY_FDELAY | `M14K_CP2_CTL_BUSY_ADELAY | `M14K_CP2_CTL_BUSY_TDELAY | `M14K_CP2_CTL_BUSY_FIXEDDLY)

// C2_DELAY fields
`define M14K_CP2_CTL_DELAY_FIXEDDLY	32'h00000001
`define M14K_CP2_CTL_DELAY_OOO	32'h0000001c
`define M14K_CP2_CTL_DELAY_EDELAY	32'h0000ff00
`define M14K_CP2_CTL_DELAY_CDELAY	32'h00ff0000
`define M14K_CP2_CTL_DELAY_FDELAY	32'hff000000
`define M14K_CP2_CTL_DELAY_FIXEDDLY_SHF	0
`define M14K_CP2_CTL_DELAY_OOO_SHF		2
`define M14K_CP2_CTL_DELAY_EDELAY_SHF	8
`define M14K_CP2_CTL_DELAY_CDELAY_SHF	16
`define M14K_CP2_CTL_DELAY_FDELAY_SHF	24
`define M14K_CP2_CTL_DELAY_VALID_BITS (`M14K_CP2_CTL_DELAY_FDELAY | `M14K_CP2_CTL_DELAY_CDELAY | `M14K_CP2_CTL_DELAY_EDELAY | `M14K_CP2_CTL_DELAY_OOO | `M14K_CP2_CTL_DELAY_FIXEDDLY)

