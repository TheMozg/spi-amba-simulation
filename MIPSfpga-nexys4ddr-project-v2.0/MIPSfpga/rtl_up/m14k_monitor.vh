//
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

`include "tb_config.vh"
`include "m14k_const.vh"

`ifdef M14K_USE_SMODULES
  `define M14K_UMIPS_DSP `M14K_CPU.core.edp.edp_nativeumips.dsp.alu_dsp
  `define M14K_M32_DSP `M14K_CPU.core.edp.edp.dsp.alu_dsp
  `define M14K_MDU `M14K_CPU.core.mdunit.mdu
  `define M14K_PDTRACE_TCB    `M14K_CPU.core.ejt.ejt_pdttcb_wrapper
  `define M14K_IPDTRACE_TCB   `M14K_CPU.core.ejt.ejt_pdttcb_wrapper.ejt_ipdttcb_wrapper
  `define M14K_TAP_FDC_TCK    `M14K_CPU.core.ejt.ejt_tap.ejt_tap.ejt_tap_fdc.ejt_tap_fdc
  `define M14K_TAP_EJTCK      `M14K_CPU.core.ejt.ejt_tap.ejt_tap.ejt_tck
  `define M14K_WATCH_TOP      `M14K_CPU.core.cpz.watch.cpz_watch_top
  `define M14K_GUEST_WATCH	`M14K_CPU.core.cpz.cpz_vz_guest.cpz_guest.watch
  `define M14K_GUEST_SRS 	`M14K_CPU.core.cpz.cpz_vz_guest.cpz_guest.cpz_srs
//  `define M14K_SRAM_UMIPS_POSTWS `M14K_CPU.core.sram.sram_wrapper.umips_recoder.icc_umips_top
  `define M14K_SRAM_UMIPS_POSTWS `M14K_CPU.core.sram.sram_wrapper.sram_wrapper.umips_recoder.icc_umips_top
  `define M14K_SRAM_NUMIPS_POSTWS `M14K_CPU.core.sram.sram_wrapper.sram_wrapper_umips.umips_recoder
    `define M14K_ICC_P_UMIPS_PREWS  `M14K_CPU.core.icc.icc_P.umips_prews.icc_umips_top
    `define M14K_ICC_P_NUMIPS_PREWS  `M14K_CPU.core.icc.icc_numips_P.umips_prews
    `define M14K_ICC_P_UMIPS_POSTWS `M14K_CPU.core.icc.icc_P.umips_postws.icc_umips_top
    `define M14K_ICC_P_NUMIPS_POSTWS  `M14K_CPU.core.icc.icc_numips_P.umips_postws
    `define M14K_ICC_P_SPRAM `M14K_CPU.core.icc.icc_P.spram
    `define M14K_DCC_P_SPRAM `M14K_CPU.core.dcc.dcc_P.spram
    `define M14K_ICC_P_ICCMB `M14K_PATH.core.icc.icc_P.iccmb
    `define M14K_DCC_P_DCCMB `M14K_PATH.core.dcc.dcc_P.dccmb
    `define M14K_ICC_P_ISPMB `M14K_PATH.core.icc.icc_P.ispmb
    `define M14K_DCC_P_DSPMB `M14K_PATH.core.dcc.dcc_P.dspmb
    `define M14K_ICC_N_UMIPS_PREWS  `M14K_CPU.core.icc.icc_N.umips_prews.icc_umips_top
    `define M14K_ICC_N_NUMIPS_PREWS  `M14K_CPU.core.icc.icc_numips_N.umips_prews
    `define M14K_ICC_N_UMIPS_POSTWS `M14K_CPU.core.icc.icc_N.umips_postws.icc_umips_top
    `define M14K_ICC_N_NUMIPS_POSTWS  `M14K_CPU.core.icc.icc_numips_N.umips_postws
    `define M14K_ICC_N_SPRAM `M14K_CPU.core.icc.icc_N.spram
    `define M14K_DCC_N_SPRAM `M14K_CPU.core.dcc.dcc_N.spram
    `define M14K_ICC_N_ICCMB `M14K_PATH.core.icc.icc_N.iccmb
    `define M14K_DCC_N_DCCMB `M14K_PATH.core.dcc.dcc_N.dccmb
    `define M14K_ICC_N_ISPMB `M14K_PATH.core.icc.icc_N.ispmb
    `define M14K_DCC_N_DSPMB `M14K_PATH.core.dcc.dcc_N.dspmb
  `define M14K_FPU `M14K_CPU.fpu.fpu_wrapper
`else
  `define M14K_UMIPS_DSP `M14K_CPU.core.edp.dsp
  `define M14K_M32_DSP `M14K_CPU.core.edp.dsp
  `define M14K_MDU `M14K_CPU.core.mdunit
  `define M14K_PDTRACE_TCB    `M14K_CPU.core.ejt.ejt_pdttcb_wrapper
  `define M14K_IPDTRACE_TCB   `M14K_CPU.core.ejt.ejt_pdttcb_wrapper
  `define M14K_TAP_FDC_TCK    `M14K_CPU.core.ejt.ejt_tap.ejt_tap_fdc
  `define M14K_TAP_EJTCK      `M14K_CPU.core.ejt.ejt_tap.ejt_tck
  `define M14K_WATCH_TOP      `M14K_CPU.core.cpz.watch
  `define M14K_GUEST_WATCH	`M14K_CPU.core.cpz.cpz_vz_guest.watch
  `define M14K_GUEST_SRS 	`M14K_CPU.core.cpz.cpz_vz_guest.cpz_srs
  `define M14K_SRAM_UMIPS_POSTWS `M14K_CPU.core.sram.sram_wrapper.umips_recoder
  `define M14K_SRAM_NUMIPS_POSTWS `M14K_CPU.core.sram.sram_wrapper.umips_recoder
    `define M14K_ICC_UMIPS_PREWS  `M14K_CPU.core.icc.umips_prews
    `define M14K_ICC_P_UMIPS_PREWS  `M14K_CPU.core.icc.umips_prews
    `define M14K_ICC_P_NUMIPS_PREWS  `M14K_CPU.core.icc.umips_prews
    `define M14K_ICC_N_UMIPS_PREWS  `M14K_CPU.core.icc.umips_prews
    `define M14K_ICC_N_NUMIPS_PREWS  `M14K_CPU.core.icc.umips_prews
    `define M14K_ICC_UMIPS_POSTWS `M14K_CPU.core.icc.umips_postws
    `define M14K_ICC_P_UMIPS_POSTWS `M14K_CPU.core.icc.umips_postws
    `define M14K_ICC_P_NUMIPS_POSTWS `M14K_CPU.core.icc.umips_postws
    `define M14K_ICC_N_UMIPS_POSTWS `M14K_CPU.core.icc.umips_postws
    `define M14K_ICC_N_NUMIPS_POSTWS `M14K_CPU.core.icc.umips_postws
  `define M14K_ICC_SPRAM `M14K_CPU.core.icc.spram
  `define M14K_DCC_SPRAM `M14K_CPU.core.dcc.spram
  `define M14K_ICC_P_SPRAM `M14K_CPU.core.icc.spram
  `define M14K_DCC_P_SPRAM `M14K_CPU.core.dcc.spram
  `define M14K_ICC_N_SPRAM `M14K_CPU.core.icc.spram
  `define M14K_DCC_N_SPRAM `M14K_CPU.core.dcc.spram
  `define M14K_ICC_P_ICCMB `M14K_PATH.core.icc.iccmb
  `define M14K_ICC_N_ICCMB `M14K_PATH.core.icc.iccmb
  `define M14K_DCC_P_DCCMB `M14K_PATH.core.dcc.dccmb
  `define M14K_DCC_N_DCCMB `M14K_PATH.core.dcc.dccmb
  `define M14K_ICC_P_ISPMB `M14K_PATH.core.icc.ispmb
  `define M14K_ICC_N_ISPMB `M14K_PATH.core.icc.ispmb
  `define M14K_DCC_P_DSPMB `M14K_PATH.core.dcc.dspmb
  `define M14K_DCC_N_DSPMB `M14K_PATH.core.dcc.dspmb
  `define M14K_FPU `M14K_CPU.fpu
`endif

