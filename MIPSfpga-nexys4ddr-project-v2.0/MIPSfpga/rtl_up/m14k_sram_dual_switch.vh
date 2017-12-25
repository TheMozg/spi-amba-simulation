//      mips_start_of_legal_notice
//      **********************************************************************
//      Unpublished work (c) MIPS Technologies, Inc.  All rights reserved. 
//      Unpublished rights reserved under the copyright laws of the United
//      States of America and other countries.
//      
//      MIPS TECHNOLOGIES PROPRIETARY / RESTRICTED CONFIDENTIAL - HEIGHTENED
//      STANDARD OF CARE REQUIRED AS PER CONTRACT
//      
//      This code is confidential and proprietary to MIPS Technologies, Inc.
//      ("MIPS Technologies") and may be disclosed only as permitted in
//      writing by MIPS Technologies.  Any copying, reproducing, modifying,
//      use or disclosure of this code (in whole or in part) that is not
//      expressly permitted in writing by MIPS Technologies is strictly
//      prohibited.  At a minimum, this code is protected under trade secret,
//      unfair competition and copyright laws.	Violations thereof may result
//      in criminal penalties and fines.
//      
//      MIPS Technologies reserves the right to change the code to improve
//      function, design or otherwise.	MIPS Technologies does not assume any
//      liability arising out of the application or use of this code, or of
//      any error or omission in such code.  Any warranties, whether express,
//      statutory, implied or otherwise, including but not limited to the
//      implied warranties of merchantability or fitness for a particular
//      purpose, are excluded.	Except as expressly provided in any written
//      license agreement from MIPS Technologies, the furnishing of this code
//      does not give recipient any license to any intellectual property
//      rights, including any patent rights, that cover this code.
//      
//      This code shall not be exported, reexported, transferred, or released,
//      directly or indirectly, in violation of the law of any country or
//      international law, regulation, treaty, Executive Order, statute,
//      amendments or supplements thereto.  Should a conflict arise regarding
//      the export, reexport, transfer, or release of this code, the laws of
//      the United States of America shall be the governing law.
//      
//      This code may only be disclosed to the United States government
//      ("Government"), or to Government users, with prior written consent
//      from MIPS Technologies.  This code constitutes one or more of the
//      following: commercial computer software, commercial computer software
//      documentation or other commercial items.  If the user of this code, or
//      any related documentation of any kind, including related technical
//      data or manuals, is an agency, department, or other entity of the
//      Government, the use, duplication, reproduction, release, modification,
//      disclosure, or transfer of this code, or any related documentation of
//      any kind, is restricted in accordance with Federal Acquisition
//      Regulation 12.212 for civilian agencies and Defense Federal
//      Acquisition Regulation Supplement 227.7202 for military agencies.  The
//      use of this code by the Government is further restricted in accordance
//      with the terms of the license agreement(s) and/or applicable contract
//      terms and conditions covering this code from MIPS Technologies.
//      
//      
//      
//      **********************************************************************
//      mips_end_of_legal_notice
//

// SRAM modules for m14k_sram_dual_switch reference module
// Xilinx device specific RAM selection
// spram_32k_RAMB16_xilinx - virtex2/4 RAMB16 based
// spram_32k_xilinx - virtexe and lower RAMB4 based
// spram_stub - stub module for fewer arrays 
`define M14K_ISRAM_WRAPPER_MODULE m14k_ssram_sp_bw   /*CREATEMULTICORE_PRESERVE_VALUE*/
`define M14K_ISRAM1_WRAPPER_MODULE m14k_sram_stub
`define M14K_DSRAM_WRAPPER_MODULE m14k_ssram_sp_bw   /*CREATEMULTICORE_PRESERVE_VALUE*/
`define M14K_DSRAM1_WRAPPER_MODULE m14k_sram_stub


  // Base physical address for bank of configuration registers
`define M14K_SRAM_CONFIGURATION_BASE_ADDR    32'h1e00_0000

  // Reset value for SRAM base physical addresses
  // Low order bits include the enables.  See config register
  // definition below
`define M14K_ISRAM_BASE_ADDR 32'h4008_0000
`define M14K_ISRAM1_BASE_ADDR 32'h1fc0_0000
`define M14K_ISRAM2_BASE_ADDR 32'h4019_0000

`define M14K_DSRAM_BASE_ADDR 32'h4009_0000
`define M14K_DSRAM1_BASE_ADDR 32'h4018_0000

  // Standard values for index range and mask values for different
  // sizes.  Mask bit should be 1 for all address bits above the
  // index.
`define M14K_SRAM_INDEX_4KB    11:2
`define M14K_SRAM_INDEX_8KB    12:2
`define M14K_SRAM_INDEX_16KB   13:2
`define M14K_SRAM_INDEX_32KB   14:2
`define M14K_SRAM_INDEX_64KB   15:2
`define M14K_SRAM_INDEX_128KB  16:2
`define M14K_SRAM_INDEXSIZE_4KB   10
`define M14K_SRAM_INDEXSIZE_8KB   11
`define M14K_SRAM_INDEXSIZE_16KB  12
`define M14K_SRAM_INDEXSIZE_32KB  13
`define M14K_SRAM_INDEXSIZE_64KB  14
`define M14K_SRAM_INDEXSIZE_128KB 15
`define M14K_SRAM_MASK_4KB  32'hffff_f000
`define M14K_SRAM_MASK_8KB  32'hffff_e000
`define M14K_SRAM_MASK_16KB 32'hffff_c000
`define M14K_SRAM_MASK_32KB 32'hffff_8000
`define M14K_SRAM_MASK_64KB 32'hffff_0000
`define M14K_SRAM_MASK_128KB 32'hfffe_0000

  // Set to match actual array sizes
`define M14K_ISRAM_INDEX `M14K_SRAM_INDEX_32KB
`define M14K_ISRAM_MASK  `M14K_SRAM_MASK_32KB
`define M14K_ISRAM1_INDEX `M14K_SRAM_INDEX_4KB
`define M14K_ISRAM1_MASK  `M14K_SRAM_MASK_4KB
`define M14K_ISRAM2_MASK  `M14K_SRAM_MASK_4KB

`define M14K_DSRAM_INDEX `M14K_SRAM_INDEX_32KB
`define M14K_DSRAM_MASK  `M14K_SRAM_MASK_32KB
`define M14K_DSRAM1_INDEX `M14K_SRAM_INDEX_4KB
`define M14K_DSRAM1_MASK  `M14K_SRAM_MASK_4KB

// Number of bits for DSRAM index - used for write buffer
// set to largest DSRAM size
`define M14K_DSRAM_INDEXSIZE `M14K_SRAM_INDEXSIZE_32KB
// End of AHB

