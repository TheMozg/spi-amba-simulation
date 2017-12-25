// ###########################################################################
//
// Verilog include file with EJTAG testbench definitions. This include file
// is used by 'ejtag_tb.mv'.
//
// $Id: \$
// mips_repository_id: ejtag_tb.vh, v 2.1 
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


//--------------------------------------------
// Defines for the EJTAG test bench
//--------------------------------------------

//--------------------------------------------
// TAP Interface
//--------------------------------------------

`define TCK_ClkDiv   		(32'h1020)
`define TCK_Delay   		(32'h1021)
`define TCK_Force   		(32'h1022)
`define TRST_Delay   		(32'h1023)
`define TRST_Length   		(32'h1024)
`define TRST_Go   		(32'h1025)
`define TRST_Done   		(32'h1026)
`define TMS_Init   		(32'h1027)

//--------------------------------------------
// Sequence Controller
//--------------------------------------------

`define SEQ_DataPtr   		(32'h1030)
`define SEQ_RunDelay   		(32'h1031)
`define SEQ_CycDelay   		(32'h1032)
`define SEQ_Go   		(32'h1033)
`define SEQ_Done   		(32'h1034)
`define SEQ_Result   		(32'h1035)

//--------------------------------------------
// Command Controller
//--------------------------------------------

`define CMD_DataPtr   		(32'h1040)
`define CMD_RunDelay   		(32'h1041)
`define CMD_CycDelay   		(32'h1042)
`define CMD_Go   		(32'h1043)
`define CMD_Done   		(32'h1044)
`define CMD_Result_1   		(32'h1045)
`define CMD_Result_2   		(32'h1046)
`define CMD_Result_3   		(32'h1047)
`define CMD_NoMemWrite          (32'h1048)

//--------------------------------------------
// Processor Access
//--------------------------------------------

`define PA_OffsetAddr		(32'h1050)
`define PA_RunDelay   		(32'h1051)
`define PA_CycDelay   		(32'h1052)
`define PA_Number   		(32'h1053)

//--------------------------------------------
// Global
//--------------------------------------------

`define GLOB_ManufID   		(32'h1060)
`define GLOB_PartNumber 	(32'h1061)
`define GLOB_Version   		(32'h1062)
`define GLOB_PerReset 		(32'h1063)
`define GLOB_ProcReset 		(32'h1064)
`define GLOB_ForceAll		(32'h1065)
`define GLOB_ReleaseAll		(32'h1066)
`define GLOB_DINT_RunDelay	(32'h1067)
`define GLOB_DINT_CycDelay	(32'h1068)
`define GLOB_DINT_Go		(32'h1069)
`define GLOB_MemAddress		(32'h106a)
`define GLOB_WriteMem		(32'h106b)
`define GLOB_ReadMem		(32'h106c)
`define GLOB_DINTsup		(32'h106e)
`define GLOB_SRstE		(32'h106f)

//--------------------------------------------
// cJTAG ESCAPE Access
//--------------------------------------------

`define ESCAPE_Length  		(32'h1070)
`define ESCAPE_Go               (32'h1071)
`define ESCAPE_Done             (32'h1072)

//--------------------------------------------
// cJTAG OAC Access
//--------------------------------------------
`define OAC_Val                 (32'h1080)
`define EC_Val                  (32'h1081)
`define CP_Val                  (32'h1082)
`define OAC_Go                  (32'h1083)
`define OAC_Done                (32'h1084)

