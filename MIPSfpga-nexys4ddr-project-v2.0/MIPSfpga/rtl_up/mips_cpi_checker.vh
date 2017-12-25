// ###########################################################################
//
// COP interface protocol checker - Error codes.
//
// $Id: \$
// mips_repository_id: mips_cpi_checker.vh, v 2.0 
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


`define MIPS_CPI_ERRCODE_NO_ERROR        8'h00

// Error codes for the checker.
`define MIPS_CPI_ERRCODE_3_1_1_A1_0      8'h01
`define MIPS_CPI_ERRCODE_3_1_1_A1_1      8'h02
`define MIPS_CPI_ERRCODE_3_1_1_A1A_0     8'h03
`define MIPS_CPI_ERRCODE_3_1_1_A1A_1     8'h04
`define MIPS_CPI_ERRCODE_3_1_1_A2_0      8'h05
`define MIPS_CPI_ERRCODE_3_1_1_A2_1      8'h06
`define MIPS_CPI_ERRCODE_3_1_1_A2A_0     8'h07
`define MIPS_CPI_ERRCODE_3_1_1_A2A_1     8'h08
`define MIPS_CPI_ERRCODE_3_1_1_A2B_0     8'h09
`define MIPS_CPI_ERRCODE_3_1_1_A2B_1     8'h0a
`define MIPS_CPI_ERRCODE_3_1_1_A2C_0     8'h0b
`define MIPS_CPI_ERRCODE_3_1_1_A2C_1     8'h0c
`define MIPS_CPI_ERRCODE_3_1_1_A2D_0     8'h0d
`define MIPS_CPI_ERRCODE_3_1_1_A2D_1     8'h0e
`define MIPS_CPI_ERRCODE_3_1_1_A3_0      8'h0f
`define MIPS_CPI_ERRCODE_3_1_1_A3_1      8'h10
`define MIPS_CPI_ERRCODE_3_1_1_A3A_0     8'h11
`define MIPS_CPI_ERRCODE_3_1_1_A3A_1     8'h12
`define MIPS_CPI_ERRCODE_3_1_1_A4_0      8'h13
`define MIPS_CPI_ERRCODE_3_1_1_A4_1      8'h14
`define MIPS_CPI_ERRCODE_3_1_1_A4A_0     8'h15
`define MIPS_CPI_ERRCODE_3_1_1_A4A_1     8'h16
`define MIPS_CPI_ERRCODE_3_1_1_A4B_0     8'h17
`define MIPS_CPI_ERRCODE_3_1_1_A4B_1     8'h18
`define MIPS_CPI_ERRCODE_3_1_1_A5_0      8'h19
`define MIPS_CPI_ERRCODE_3_1_1_A5_1      8'h1a
`define MIPS_CPI_ERRCODE_3_1_1_A6_0      8'h1b
`define MIPS_CPI_ERRCODE_3_1_1_A6_1      8'h1c
`define MIPS_CPI_ERRCODE_3_1_1_T1_0      8'h1d
`define MIPS_CPI_ERRCODE_3_1_1_T1_1      8'h1e
`define MIPS_CPI_ERRCODE_3_1_1_T1A_0     8'h1f
`define MIPS_CPI_ERRCODE_3_1_1_T1A_1     8'h20
`define MIPS_CPI_ERRCODE_3_1_1_T2_0      8'h21
`define MIPS_CPI_ERRCODE_3_1_1_T2_1      8'h22
`define MIPS_CPI_ERRCODE_3_1_1_T2A_0     8'h23
`define MIPS_CPI_ERRCODE_3_1_1_T2A_1     8'h24
`define MIPS_CPI_ERRCODE_3_1_1_T2B_0     8'h25
`define MIPS_CPI_ERRCODE_3_1_1_T2B_1     8'h26
`define MIPS_CPI_ERRCODE_3_1_1_T2C_0     8'h27
`define MIPS_CPI_ERRCODE_3_1_1_T2C_1     8'h28
`define MIPS_CPI_ERRCODE_3_1_1_T2D_0     8'h29
`define MIPS_CPI_ERRCODE_3_1_1_T2D_1     8'h2a
`define MIPS_CPI_ERRCODE_3_1_1_T3_0      8'h2b
`define MIPS_CPI_ERRCODE_3_1_1_T3_1      8'h2c
`define MIPS_CPI_ERRCODE_3_1_1_T3A_0     8'h2d
`define MIPS_CPI_ERRCODE_3_1_1_T3A_1     8'h2e
`define MIPS_CPI_ERRCODE_3_1_1_T4_0      8'h2f
`define MIPS_CPI_ERRCODE_3_1_1_T4_1      8'h30
`define MIPS_CPI_ERRCODE_3_1_1_T5_0      8'h31
`define MIPS_CPI_ERRCODE_3_1_1_T5_1      8'h32
`define MIPS_CPI_ERRCODE_3_1_1_T5A_0     8'h33
`define MIPS_CPI_ERRCODE_3_1_1_T5A_1     8'h34
`define MIPS_CPI_ERRCODE_3_1_1_T5B_0     8'h35
`define MIPS_CPI_ERRCODE_3_1_1_T5B_1     8'h36
`define MIPS_CPI_ERRCODE_3_1_1_T6_0      8'h37
`define MIPS_CPI_ERRCODE_3_1_1_T6_1      8'h38
`define MIPS_CPI_ERRCODE_3_1_1_T7_0      8'h39
`define MIPS_CPI_ERRCODE_3_1_1_T7_1      8'h3a
`define MIPS_CPI_ERRCODE_3_1_1_T9A_0     8'h3b
`define MIPS_CPI_ERRCODE_3_1_1_T9A_1     8'h3c
`define MIPS_CPI_ERRCODE_3_1_1_T10_0     8'h3d
`define MIPS_CPI_ERRCODE_3_1_1_T10_1     8'h3e
`define MIPS_CPI_ERRCODE_3_1_1_F1_0      8'h3f
`define MIPS_CPI_ERRCODE_3_1_1_F1_1      8'h40
`define MIPS_CPI_ERRCODE_3_1_1_F1A_0     8'h41
`define MIPS_CPI_ERRCODE_3_1_1_F1A_1     8'h42
`define MIPS_CPI_ERRCODE_3_1_1_F2_0      8'h43
`define MIPS_CPI_ERRCODE_3_1_1_F2_1      8'h44
`define MIPS_CPI_ERRCODE_3_1_1_F2A_0     8'h45
`define MIPS_CPI_ERRCODE_3_1_1_F2A_1     8'h46
`define MIPS_CPI_ERRCODE_3_1_1_F2B_0     8'h47
`define MIPS_CPI_ERRCODE_3_1_1_F2B_1     8'h48
`define MIPS_CPI_ERRCODE_3_1_1_F2C_0     8'h49
`define MIPS_CPI_ERRCODE_3_1_1_F2C_1     8'h4a
`define MIPS_CPI_ERRCODE_3_1_1_F2D_0     8'h4b
`define MIPS_CPI_ERRCODE_3_1_1_F2D_1     8'h4c
`define MIPS_CPI_ERRCODE_3_1_1_F3_0      8'h4d
`define MIPS_CPI_ERRCODE_3_1_1_F3_1      8'h4e
`define MIPS_CPI_ERRCODE_3_1_1_F3A_0     8'h4f
`define MIPS_CPI_ERRCODE_3_1_1_F3A_1     8'h50
`define MIPS_CPI_ERRCODE_3_1_1_F4_0      8'h51
`define MIPS_CPI_ERRCODE_3_1_1_F4_1      8'h52
`define MIPS_CPI_ERRCODE_3_1_1_F5_0      8'h53
`define MIPS_CPI_ERRCODE_3_1_1_F5_1      8'h54
`define MIPS_CPI_ERRCODE_3_1_1_F5A_0     8'h55
`define MIPS_CPI_ERRCODE_3_1_1_F5A_1     8'h56
`define MIPS_CPI_ERRCODE_3_1_1_F5B_0     8'h57
`define MIPS_CPI_ERRCODE_3_1_1_F5B_1     8'h58
`define MIPS_CPI_ERRCODE_3_1_1_F6_0      8'h59
`define MIPS_CPI_ERRCODE_3_1_1_F6_1      8'h5a
`define MIPS_CPI_ERRCODE_3_1_1_F7_0      8'h5b
`define MIPS_CPI_ERRCODE_3_1_1_F7_1      8'h5c
`define MIPS_CPI_ERRCODE_3_1_1_F9A_0     8'h5d
`define MIPS_CPI_ERRCODE_3_1_1_F9A_1     8'h5e
`define MIPS_CPI_ERRCODE_3_1_1_F10_0     8'h5f
`define MIPS_CPI_ERRCODE_3_1_1_F10_1     8'h60
`define MIPS_CPI_ERRCODE_3_1_1_C1_0      8'h61
`define MIPS_CPI_ERRCODE_3_1_1_C1_1      8'h62
`define MIPS_CPI_ERRCODE_3_1_1_C1A_0     8'h63
`define MIPS_CPI_ERRCODE_3_1_1_C1A_1     8'h64
`define MIPS_CPI_ERRCODE_3_1_1_C2_0      8'h65
`define MIPS_CPI_ERRCODE_3_1_1_C2_1      8'h66
`define MIPS_CPI_ERRCODE_3_1_1_C2A_0     8'h67
`define MIPS_CPI_ERRCODE_3_1_1_C2A_1     8'h68
`define MIPS_CPI_ERRCODE_3_1_1_C3_0      8'h69
`define MIPS_CPI_ERRCODE_3_1_1_C3_1      8'h6a
`define MIPS_CPI_ERRCODE_3_1_1_C3A_0     8'h6b
`define MIPS_CPI_ERRCODE_3_1_1_C3A_1     8'h6c
`define MIPS_CPI_ERRCODE_3_1_1_C4_0      8'h6d
`define MIPS_CPI_ERRCODE_3_1_1_C4_1      8'h6e
`define MIPS_CPI_ERRCODE_3_1_1_C4A_0     8'h6f
`define MIPS_CPI_ERRCODE_3_1_1_C4A_1     8'h70
`define MIPS_CPI_ERRCODE_3_1_1_C4B_0     8'h71
`define MIPS_CPI_ERRCODE_3_1_1_C4B_1     8'h72
`define MIPS_CPI_ERRCODE_3_1_1_C5A_0     8'h73
`define MIPS_CPI_ERRCODE_3_1_1_C5A_1     8'h74
`define MIPS_CPI_ERRCODE_3_1_1_C7        8'h75
`define MIPS_CPI_ERRCODE_3_1_1_C8        8'h76
`define MIPS_CPI_ERRCODE_3_1_1_C8A       8'h77
`define MIPS_CPI_ERRCODE_3_1_1_C9        8'h78
`define MIPS_CPI_ERRCODE_3_1_1_C9A       8'h79
`define MIPS_CPI_ERRCODE_3_1_1_C10       8'h7a
`define MIPS_CPI_ERRCODE_3_1_1_C10A      8'h7b
`define MIPS_CPI_ERRCODE_3_1_1_C12_0     8'h7c
`define MIPS_CPI_ERRCODE_3_1_1_C12_1     8'h7d
`define MIPS_CPI_ERRCODE_3_1_1_C12A_0    8'h7e
`define MIPS_CPI_ERRCODE_3_1_1_C12A_1    8'h7f
`define MIPS_CPI_ERRCODE_3_1_1_C15       8'h80
`define MIPS_CPI_ERRCODE_3_1_1_C15A      8'h81
`define MIPS_CPI_ERRCODE_3_1_1_C16       8'h82
`define MIPS_CPI_ERRCODE_3_1_1_C17       8'h83
`define MIPS_CPI_ERRCODE_3_1_1_C19_0     8'h84
`define MIPS_CPI_ERRCODE_3_1_1_C19_1     8'h85
`define MIPS_CPI_ERRCODE_3_1_1_C21_0     8'h86
`define MIPS_CPI_ERRCODE_3_1_1_C21_1     8'h87
`define MIPS_CPI_ERRCODE_3_1_1_C22_0     8'ha3
`define MIPS_CPI_ERRCODE_3_1_1_C22_1     8'ha4
`define MIPS_CPI_ERRCODE_3_1_1_I1        8'h88
`define MIPS_CPI_ERRCODE_3_2_1_1_0       8'h89
`define MIPS_CPI_ERRCODE_3_2_1_1_1       8'h8a
`define MIPS_CPI_ERRCODE_3_2_1_4_0       8'h8b
`define MIPS_CPI_ERRCODE_3_2_1_4_1       8'h8c
`define MIPS_CPI_ERRCODE_3_2_1_5_0       8'h8d
`define MIPS_CPI_ERRCODE_3_2_1_5_1       8'h8e
`define MIPS_CPI_ERRCODE_3_2_1_6_0       8'h8f
`define MIPS_CPI_ERRCODE_3_2_1_6_1       8'h90
`define MIPS_CPI_ERRCODE_3_2_1_7_0       8'h91
`define MIPS_CPI_ERRCODE_3_2_1_7_1       8'h92
`define MIPS_CPI_ERRCODE_3_2_1_8_0       8'h93
`define MIPS_CPI_ERRCODE_3_2_1_8_1       8'h94
`define MIPS_CPI_ERRCODE_3_2_1_9_0       8'h95
`define MIPS_CPI_ERRCODE_3_2_1_9_1       8'h96
`define MIPS_CPI_ERRCODE_3_2_1_10_0      8'h97
`define MIPS_CPI_ERRCODE_3_2_1_10_1      8'h98
`define MIPS_CPI_ERRCODE_3_2_1_12_0      8'h99
`define MIPS_CPI_ERRCODE_3_2_1_12_1      8'h9a
`define MIPS_CPI_ERRCODE_3_2_1_13_0      8'ha1
`define MIPS_CPI_ERRCODE_3_2_1_13_1      8'ha2
`define MIPS_CPI_ERRCODE_4_1_1_1_0       8'h9b
`define MIPS_CPI_ERRCODE_4_1_1_1_1       8'h9c
`define MIPS_CPI_ERRCODE_4_1_1_5_0       8'ha5
`define MIPS_CPI_ERRCODE_4_1_1_5_1       8'ha6
`define MIPS_CPI_ERRCODE_4_2_1_1_0       8'h9d
`define MIPS_CPI_ERRCODE_4_2_1_1_1       8'h9e
`define MIPS_CPI_ERRCODE_4_2_1_2_0       8'h9f
`define MIPS_CPI_ERRCODE_4_2_1_2_1       8'ha0

// Error codes for Opal personality 
`define MIPS_CPI_ERRCODE_5_1_1_1_0_OPAL  8'hd0
`define MIPS_CPI_ERRCODE_5_1_1_1_1_OPAL  8'hd0
`define MIPS_CPI_ERRCODE_5_2_1_1_OPAL    8'hd1

// Error codes for Emerald personality 
`define MIPS_CPI_ERRCODE_5_1_1_1_EMERALD 8'he0




                               
                                        
                                        
                                        
