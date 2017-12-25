// ###########################################################################
//
// Common testbench defines.
//
// $Id: \$
// mips_repository_id: tb_defs.vh, v 2.31 
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

`include "tb_config.vh"


`define ADDR_WS_SEED	 	    0
`define READ_WS_SEED	 	    1
`define WRITE_WS_SEED		    2

`define RANDOM_INT0_SEED    	    10
`define RANDOM_INT1_SEED    	    11
`define RANDOM_INT2_SEED    	    12
`define RANDOM_INT3_SEED    	    13
`define RANDOM_INT4_SEED    	    14
`define RANDOM_INT5_SEED    	    15
`define RANDOM_INT6_SEED    	    16
`define RANDOM_INT7_SEED    	    17
`define FIXED_INT_SEED	    	    18

`define RANDOM_COLD_RESET_SEED	    20
`define RANDOM_RESET_SEED   	    21
`define RANDOM_NMI_SEED     	    22
`define RANDOM_DINT_SEED     	    23

`define RANDOM_EIC_DELAY_SEED	    30
`define RANDOM_EIC_VALUE_SEED	    31

`define READ_FIFO_ADDR_WIDTH        (`ADDRBUS_WIDTH + `BE_WIDTH + 1 + 8)
`define WRITE_FIFO_ADDR_WIDTH	    (`ADDRBUS_WIDTH + `BE_WIDTH + 8)
`define WRITE_FIFO_DATA_WIDTH	    (`DATABUS_WIDTH + 1)

`ifdef LV
`define WRAPPER     	    	    lv_wrapper
`else
	`define WRAPPER             mips_soc_wrapper
`endif

`define IntDataAddr 		    (36'h1ffffff8)
`define IntCtlAddr  		    (36'h1ffffff0)
`define IntClrCmd   		    (32'h1)
`define IntSetCmd   		    (32'h2)
`define FireNmiCmd   	   	    (32'h3)
`define FireWarmResetCmd   	    (32'h4)
`define FireColdResetCmd   	    (32'h5)
`define SetBErr1AddrCmd             (32'h6)
`define SetBErr1MaskCmd             (32'h7)
`define SetBErr2AddrCmd             (32'h8)
`define SetBErr2MaskCmd             (32'h9)
`define SetWriteAroundAddrCmd       (32'ha)
`define WriteAroundCmd		    (32'hb)
`define SetIBErr1AddrCmd             (32'hc)
`define SetIBErr1MaskCmd             (32'hd)
//`define PM_ClearCmd 	    	    (32'h10)
//`define PM_ReadCmd  	    	    (32'h11)
`define SetTrigCmd                  (32'h12)
`define ClrTrigCntCmd               (32'h13)
`define RdTrigCntCmd                (32'h14)
`define EIC_ShadowSetCmd            (32'h23)

`define EIC_IntSetCmd	    	    (32'h16)
`define EIC_AckGetCmd	    	    (32'h17)
`define EIC_IPLGetCmd	    	    (32'h18)
`define CPUNumSetCmd    	    (32'h19)
`define IPTISetCmd  	    	    (32'h20)
`define IPPCISetCmd 	    	    (32'h21)
`define EICPresentSetCmd 	    (32'h22)
`define BootExcISAModeCmd           (32'h24)
`define UseEICCtlCmd           (32'h25)
`define	SetDSpramError		    (32'h26)
`define	ClearDSpramError	    (32'h27)
`define	SetISpramError		    (32'h28)
`define	ClearISpramError	    (32'h29)
`define IPFDCISetCmd 	    	    (32'h2a)
`define EIC_OffsetSetCmd           (32'h2b)
`define RandomBEEnSetCmd	   (32'h2c)
`define RandomBEEnClrCmd	   (32'h2d)
`define AHB_WTB_SetCmd             (32'h2e)
`define RandomDINTSetCmd	   (32'h2f)
`define RandomDINTClrCmd	   (32'h30)
`define PM_ClearCmd 	    	   (32'h31)
`define PM_ReadCmd  	    	   (32'h32)
`define RandomNMISetCmd	   	(32'h33)
`define RandomNMIClrCmd	   	(32'h34)

`define	SetDSramError		    (32'h35)
`define	ClearDSramError		    (32'h36)
`define	SetISramError		    (32'h37)
`define	ClearISramError		    (32'h38)
`define	SetISramErrorAddr	    (32'h39)
`define	SetDSramErrorAddr	    (32'h3a)
`define EIC_IVNGetCmd	    	    (32'h3b)
`define EIC_IONGetCmd	    	    (32'h3c)
`define DisableProbeDebugCmd 	(32'h3d)

`define RANDOMTBMASKWR0		(32'h50)
`define RANDOMTBMASKWR1		(32'h51)
`define RANDOMTBMASKWR2		(32'h52)
`define RANDOMTBMASKWR3		(32'h53)
`define RANDOMTBMASKRD0		(32'h54)
`define RANDOMTBMASKRD1		(32'h55)
`define RANDOMTBMASKRD2		(32'h56)
`define RANDOMTBMASKRD3		(32'h57)
`define RANDOMTBMODCOUNT	(32'h58)
`define RANDOMTBFREQ		(32'h59)
`define RANDOMTBFORCED0		(32'h5a)
`define RANDOMTBFORCED1		(32'h5b)
`define RANDOMTBFORCED2		(32'h5c)
`define RANDOMTBFORCED3		(32'h5d)
`define RANDOMTBEXPCTERREPC	(32'h5e)
`define RANDOMTBEXPCTEPC	(32'h5f)
`define RANDOMTB_RELDTAGPAR	(32'h60) 
`define RANDOMTB_RELDDATAPAR	(32'h61) 
`define RANDOMTB_RELITAGPAR	(32'h62) 
`define RANDOMTB_RELIDATAPAR	(32'h63) 
`define RANDOMTB_RELINT0	(32'h80) 
`define RANDOMTB_RELINT1	(32'h81) 
`define RANDOMTB_RELINT2	(32'h82) 
`define RANDOMTB_RELINT3	(32'h83) 
`define RANDOMTB_RELINT4	(32'h84) 
`define RANDOMTB_RELINT5	(32'h85) 
`define RANDOMTB_RELDINT	(32'h88) 
`define RANDOMTB_RELIBUSERR	(32'h89) 
`define RANDOMTB_BRKSTART	(32'he0)
`define RANDOMTB_BRKREAD	(32'he1)
`define M14K_SWMAIN_OPENCOUNT  (32'h64)
`define M14K_SWMAIN_CLOSECOUNT  (32'hc8)
`define M14K_USE_VTB            (32'hf0)
//reserve all numbers from 60 - 200

