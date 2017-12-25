
/*    Constants File    */

// $Id: \$
// mips_repository_id: m14k_const.vh, v 3.27.4.10 

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

`define MICROAPTIV 1
`define MICROAPTIVUPF 1

`define M14K_TOP  m14k_top
`define M14K_CPU  m14k_cpu
`define M14K_CORE m14k_core

`ifdef BFM_CONNECT
`define M14K_SCONFIG `M14K_TOP.smodule_config
`else
`ifdef MIPS_SWIFT
`define M14K_SCONFIG `M14K_CPU.smodule_config
`else
`define M14K_SCONFIG `M14K_TOP.cpu.smodule_config
  `endif
`endif

`ifdef AHB_OCP_BRIDGE
   `define TOP_SMODULE_CFG toplevel.wrapper.mips_soc.mips_css.ahb_ocp.core.cpu.smodule_config
`else
   `define TOP_SMODULE_CFG toplevel.wrapper.mips_soc.mips_css.core.cpu.smodule_config
`endif   

`define M14K_DISPLAY `M14K_CPU.testbench.display
`define M14K_PATH_MINITB minitb_toplevel.m14k_top.cpu

// include Configuration option file for user-definable build options
`include "m14k_config.vh"

  `define M14K_SMOD_CONFIG_FILE "memory.m14k_vconfig"

  `define M14K_SRAM_DISPLAY `M14K_CPU.testbench.display


// Clock attributes
`define  M14K_CYCLETIME	100
`define  M14K_PHASETIME	`M14K_CYCLETIME / 2

// Processor ID register constant value
`define M14K_PRID_COMPANYOPT_MSB 1'h0

//`ifdef M14K_ENABLE_DSP
`define M14K_QPRID {`M14K_PRID_COMPANYOPT_MSB, `M14K_PRID_COMPANYOPT, 16'h019d, 3'd6, 3'd0, 2'd0}
`define M14K_CPRID {`M14K_PRID_COMPANYOPT_MSB, `M14K_PRID_COMPANYOPT, 16'h019e, 3'd3, 3'd0, 2'd0}
//`else
//`define M14K_QPRID {`M14K_PRID_COMPANYOPT_MSB, `M14K_PRID_COMPANYOPT, 16'h019b, 3'd1, 3'd3, 2'd0}
//`define M14K_CPRID {`M14K_PRID_COMPANYOPT_MSB, `M14K_PRID_COMPANYOPT, 16'h019c, 3'd1, 3'd3, 2'd0}
//`endif

// Config constants
`define M14K_ARCHREV	3'h1
`define M14K_EJTAG_VER	3'b101

`define MIPS_M32_ONLY 1

// EJTAG Break DRSEG addresses

`define	M14K_EJS_IBS	16'h1000
`define M14K_EJS_DBS	16'h2000

`define M14K_EJS_DBLD	16'h2ff0

`define	M14K_EJS_IBA0	16'h1100
`define	M14K_EJS_IBM0	16'h1108
`define	M14K_EJS_IBASID0	16'h1110
`define	M14K_EJS_IBC0	16'h1118
`define	M14K_EJS_IBCC0	16'h1120
`define	M14K_EJS_IBPC0	16'h1128

`define	M14K_EJS_IBA1	16'h1200
`define	M14K_EJS_IBM1	16'h1208
`define	M14K_EJS_IBASID1	16'h1210
`define	M14K_EJS_IBC1	16'h1218
`define	M14K_EJS_IBCC1	16'h1220
`define	M14K_EJS_IBPC1	16'h1228

`define	M14K_EJS_IBA2	16'h1300
`define	M14K_EJS_IBM2	16'h1308
`define	M14K_EJS_IBASID2	16'h1310
`define	M14K_EJS_IBC2	16'h1318
`define	M14K_EJS_IBCC2	16'h1320
`define	M14K_EJS_IBPC2	16'h1328

`define	M14K_EJS_IBA3	16'h1400
`define	M14K_EJS_IBM3	16'h1408
`define	M14K_EJS_IBASID3	16'h1410
`define	M14K_EJS_IBC3	16'h1418
`define	M14K_EJS_IBCC3	16'h1420
`define	M14K_EJS_IBPC3	16'h1428

`define	M14K_EJS_IBA4	16'h1500
`define	M14K_EJS_IBM4	16'h1508
`define	M14K_EJS_IBASID4	16'h1510
`define	M14K_EJS_IBC4	16'h1518
`define	M14K_EJS_IBCC4	16'h1520
`define	M14K_EJS_IBPC4	16'h1528

`define	M14K_EJS_IBA5	16'h1600
`define	M14K_EJS_IBM5	16'h1608
`define	M14K_EJS_IBASID5	16'h1610
`define	M14K_EJS_IBC5	16'h1618
`define	M14K_EJS_IBCC5	16'h1620
`define	M14K_EJS_IBPC5	16'h1628
`define M14K_EJS_IBA6    16'h1700
`define M14K_EJS_IBM6    16'h1708
`define M14K_EJS_IBASID6 16'h1710
`define M14K_EJS_IBC6    16'h1718
`define M14K_EJS_IBCC6   16'h1720
`define M14K_EJS_IBPC6   16'h1728
`define M14K_EJS_IBA7    16'h1800
`define M14K_EJS_IBM7    16'h1808
`define M14K_EJS_IBASID7 16'h1810
`define M14K_EJS_IBC7    16'h1818
`define M14K_EJS_IBCC7   16'h1820
`define M14K_EJS_IBPC7   16'h1828

`define	M14K_EJS_DBA0	16'h2100
`define	M14K_EJS_DBM0	16'h2108
`define	M14K_EJS_DBASID0	16'h2110
`define	M14K_EJS_DBC0	16'h2118
`define	M14K_EJS_DBV0	16'h2120
`define	M14K_EJS_DBCC0	16'h2128
`define	M14K_EJS_DBPC0	16'h2130

`define	M14K_EJS_DBA1	16'h2200
`define	M14K_EJS_DBM1	16'h2208
`define	M14K_EJS_DBASID1	16'h2210
`define	M14K_EJS_DBC1	16'h2218
`define	M14K_EJS_DBV1	16'h2220
`define	M14K_EJS_DBCC1	16'h2228
`define	M14K_EJS_DBPC1	16'h2230
`define M14K_EJS_DBA2    16'h2300
`define M14K_EJS_DBM2    16'h2308
`define M14K_EJS_DBASID2 16'h2310
`define M14K_EJS_DBC2    16'h2318
`define M14K_EJS_DBV2    16'h2320
`define M14K_EJS_DBCC2   16'h2328
`define M14K_EJS_DBPC2   16'h2330
`define M14K_EJS_DBA3    16'h2400
`define M14K_EJS_DBM3    16'h2408
`define M14K_EJS_DBASID3 16'h2410
`define M14K_EJS_DBC3    16'h2418
`define M14K_EJS_DBV3    16'h2420
`define M14K_EJS_DBCC3   16'h2428
`define M14K_EJS_DBPC3   16'h2430


`define	M14K_ITCB_CTL	16'h3fc0
`define	M14K_ITCB_CTL2	16'h3fe0
`define	M14K_ITCB_TWH	16'h3f84
`define	M14K_ITCB_TW     16'h3f80
`define	M14K_ITCB_RDP    16'h3f88
`define	M14K_ITCB_WRP	16'h3f90

`define M14K_IPDT_ITE	16'h3fd0
`define M14K_IPDT_DTE	16'h3fd8

`define M14K_EJC_CBTC	16'h8000

`define M14K_EJC_CNDI0	16'h8300
`define M14K_EJC_CNDI1	16'h8320
`define M14K_EJC_CNDI2	16'h8340
`define M14K_EJC_CNDI3	16'h8360
`define M14K_EJC_CNDI4	16'h8380
`define M14K_EJC_CNDI5	16'h83a0
`define M14K_EJC_CNDI6   16'h83c0
`define M14K_EJC_CNDI7   16'h83e0

`define M14K_EJC_CNDD0	16'h84e0
`define M14K_EJC_CNDD1	16'h8500
`define M14K_EJC_CNDD2   16'h8520
`define M14K_EJC_CNDD3   16'h8540

`define M14K_EJC_SWCTL	16'h8900
`define M14K_EJC_SWCNT	16'h8908

// Undefined value 
//   - use 0 rather than x to limit x state
`define MIPS_UNDEF_VAL 1'b0

// Exception vector bases (upper 12 bits)
`define  M14K_RESET_BASE    12'hbfc
`define  M14K_NORMAL_BASE   12'h800
`define  M14K_DEBUG_BASE    12'hbfc
`define  M14K_DEBUGPRB_BASE 12'hff2

// Exception vector offsets
`define M14K_BEVCACHEERR_OFF   12'h300
`define M14K_CACHEERR_OFF    12'h100
`define M14K_GEN_OFF   12'h180
`define M14K_INT_OFF  16'h200
`define M14K_BEV_OFF  12'h200
`define M14K_BEVINT_OFF  12'h400
`define M14K_DEBUG_OFF    12'h480
`define M14K_DEBUGPRB_OFF 12'h200

// Exception vector bit ids
`define M14K_EVEC_RDVEC 7
`define M14K_EVEC_DEBUG 6
`define M14K_EVEC_PROBE 5
`define M14K_EVEC_RESET 4
`define M14K_EVEC_BEV 3
`define M14K_EVEC_TLB 2
`define M14K_EVEC_CACHEERR 1
`define M14K_EVEC_INT 0


`define M14K_FBR_HE 15:14
`define M14K_FBR_MAGICL 13
`define M14K_FBR_LOCK 12
`define M14K_FBR_UNCACHED 11
`define M14K_FBR_NOFILL 10
`define M14K_FBR_REPLWAY 9:6
`define M14K_FBR_WRLRF 5
`define M14K_FBR_FILLED 4:1
`define M14K_FBR_LAST 0

`define M14K_BUSHI 	31
`define M14K_BUSLO 	0
`define M14K_BUS 	`M14K_BUSHI : `M14K_BUSLO
`define M14K_BUSWIDTH	(`M14K_BUSHI - `M14K_BUSLO + 1)

`define  M14K_PABITS     32

// Configure the maximum page size
`ifdef M14K_SMARTMIPS
`define  M14K_PAGESIZE16M	1
`else
`define  M14K_PAGESIZE256M	1
`endif


//VPNLO sets width of PA busses.  This is always [31:10]
//PFNLO is setting width of JTLB fields.  This field is always 
//20b.  Set as 31:12 although will be 29:10 if small pages
//are enabled
`define  M14K_VPNLO		10
`define  M14K_PFNLO		12

// The PFN is always stored as ranging `PFN,
// but it can be used in a shifted version `PFNShifted for PA
`define  M14K_PFNHI		(`M14K_PABITS - 1)
`define	 M14K_PFNWIDTH	(`M14K_PFNHI - `M14K_PFNLO + 1)
`define  M14K_PFN		 `M14K_PFNHI : `M14K_PFNLO
`define  M14K_PFNSSHIFTE	 `M14K_VPNLO + `M14K_PFNWIDTH - 1 : `M14K_VPNLO

// PA aligns with VPN and PABITS -1
`define  M14K_PAHLO		 `M14K_VPNLO
`define  M14K_PAHHI		(`M14K_PABITS - 1)
`define  M14K_PAH		 `M14K_PAHHI : `M14K_PAHLO
`define  M14K_PAHWIDTH           (`M14K_PAHHI - `M14K_PAHLO + 1)
`define  M14K_PALHI		(`M14K_PAHLO - 1)
`define  M14K_PAL		 `M14K_PALHI : 4

// Virtual Page Number type
`define  M14K_VPNHI           `M14K_BUSHI
`define	 M14K_VPNWIDTH	(`M14K_VPNHI - `M14K_VPNLO + 1)
`define  M14K_VPN		 `M14K_VPNHI : `M14K_VPNLO
`define  M14K_VPNRANGE        `M14K_VPN
// Part of VPN used for associative look up
`define  M14K_VPN2LO         (`M14K_VPNLO + 1)
`define  M14K_VPN2HI          `M14K_VPNHI
`define  M14K_VPN2WIDTH      (`M14K_VPN2HI - `M14K_VPN2LO + 1)
`define  M14K_VPN2            `M14K_VPN2HI : `M14K_VPN2LO
`define  M14K_VPN2RANGE       `M14K_VPN2

// COHERENCY type
`define  M14K_CCAWIDTH	3
`define  M14K_CCA		`M14K_CCAWIDTH - 1 : 0

// ENHI.INV
`define M14K_ENHIINVWIDTH	1
`define M14K_ENHIINV	`M14K_VPNLO 

// ASID type
`define  M14K_ASIDWIDTH      8
`define  M14K_ASID		`M14K_ASIDWIDTH - 1 : 0
`define  M14K_ASIDRANGE	`M14K_ASID

// GuestID type
`define  M14K_GIDWIDTH      3
`define  M14K_GID		`M14K_GIDWIDTH - 1 : 0
`define	 M14K_GUESTIDWIDTH 8

// defines for the cpy ENHI output
`define M14K_ENHIRANGE        `M14K_VPN2WIDTH + `M14K_ASIDWIDTH + `M14K_ENHIINVWIDTH - 1 : 0
`define M14K_VPN2RANGEENHI    `M14K_VPN2WIDTH + `M14K_ASIDWIDTH + `M14K_ENHIINVWIDTH - 1 : `M14K_ASIDWIDTH + `M14K_ENHIINVWIDTH
`define M14K_ENHIZERO		`M14K_VPN2LO - 1 - `M14K_ENHIINVWIDTH : `M14K_ASIDWIDTH 
`define M14K_ENHIZEROWIDTH       `M14K_VPN2LO -`M14K_ENHIINVWIDTH - `M14K_ASIDWIDTH 

// AssertOK signal
`define M14K_ASSERTOK `M14K_CPU.core.siu.AssertOK

  `define M14K_SRAM_ASSERTOK `M14K_CPU.core.siu.AssertOK

// Configuration memory attributes
`define M14K_CFG_MEM_CNT 102

/* Configuration Memory Entries:
	1: I$ Assoc
	2: I$ Way Size
	3: D$ Assoc
	4: D$ Way Size
	5: Init $
	6:  MMU
	7:  MDU
	8:  EJTAG Simple Break
	9:  EJTAG TAP
	10: Instance Number
	11: Display Enable
	12: Halt Control
	13: Bus Trace Enable
	14: Instn Trace Enable
	15: UMIPS PreWS
	16: UMIPS PostWS 
	17: CP2
	18: EJTAG PDT
	19: PRO_ENABLE  
	20: Gated Clocks in mvp_ucregister_wide
	21: ISP Present
	22: DSP Present
	23: PDT tracefile Enable
	24: TCB OnChip Memory
	25: TCB OnChip Memory Size (2^x, valid memory sizes: 2^5 to 2^20)
	26: TCB OffChip Memory
	27: TCB Triggers (valid number of triggers: 0-8)
	28: PIB TRDATA width (4,8,16)
	29: ICC_MBIST
	30: DCC_MBIST
	31: Main Clock gate enable
	32: BFM Script Trace Enable
	33: SRAM I/F Dual or Unified
	34: Watch Channels (0-8)
	35: Shadow register sets (1,2,4)
	36: SmallPageSupport
        37: UDI_SELECT
        38: PRO_ENABLE
	39: TLB32
        40: CP2_CUSTOM
        41: ISPRAM_SELECT
        42: DSPRAM_SELECT
	43: ScanIO
	44: SRAM scanio
	45: PRID override
	46: Interrupt synchronizers
	47: Unified SPRAM Module
        48: SRAM Switch Module
        49: SRAM2EC Module
*/

// WatchLo register attribute bits
`define M14K_INST_WATCH  2
`define M14K_LD_WATCH  1
`define M14K_ST_WATCH 0

// WatchHi register attributes for uncompressed register
`define M14K_GLOBAL_WATCH 30
`define M14K_ASID_WATCH 23:16
`define M14K_MASK_WATCH 11:3

// WatchHi register attributes for compressed register
`define M14K_GLOBAL_WATCHC 17
`define M14K_ASID_WATCHC 16:9
`define M14K_MASK_WATCHC 8:0

//--------------------------------------------
// Defines for Crypto MDU
//--------------------------------------------
`define M14K_ACXWIDTH                8

//--------------------------------------------
// defines for assertion checking and reporting
//--------------------------------------------

// Severity levels for $mips$assert statements
//verilint 34 off   // Unused macro
`define M14K_FATAL     0
`define MIPS_FATAL    0
`define M14K_ERROR    10
`define M14K_WARNING  20
`define M14K_INFO     30
`define M14K_COVERAGE 40

`define M14K_FATAL_HW_STR "Fatal Hardware Error detected in MIPS processor...Contact MIPS Technologies Inc.: support@mips.com"
`define M14K_FATAL_SW_STR "Fatal Error detected in MIPS processor.  Unknown state - aborting simulation"
`define M14K_FATAL_IO_STR "Fatal Error detected in MIPS processor - I/O violation"
`define M14K_FATAL_CFG_STR "Fatal Error detected in processor - Configuration Error"
`define M14K_WARN_IO_STR  "Warning:  Possible I/O violation detected"
`define M14K_WARN_X_STR "Warning:  Unknown state in MIPS processor"
//verilint 34 on

// Count time in clock cycles in which the reset line must be asserted
// After succesfull test of reset periode, some assert statements are active
// first clock cycle after reset is deasserted.
`define M14K_MIN_RESET 15

// Count time in clock cycles in which the reset line is asserted
// If the reset stays on beyond this number of cycles, the user has 
// possibly got the reset polarity wrong.
`define M14K_MAX_RESET 2000

// RAM model path to assert the AssertOK
`define M14K_BIU_PATH m14k_biu

//--------------------------------------------
// m14k_vmc_mod_m14k_cpu
// VMC compare is always done at cpu level
//--------------------------------------------
`define M14K_VMC_MOD_m14k_cpu 1


`ifdef M14K_SMARTMIPS
//--------------------------------------------
// Zero out M16 decompressor inputs when in
// M32 mode to reduce power
//--------------------------------------------

`define M14K_M16_QUIET	1

//--------------------------------------------
// Enable SmartMIPS security features
// this is for debug purposes
// CP0 interface is not affected
//--------------------------------------------

`define M14K_SMARTMIPS_SECURITY 1

//--------------------------------------------
// Security reset parameters
//--------------------------------------------

`define M14K_SMARTMIPS_SEC_CL_RESET	(1'b0)
`define M14K_SMARTMIPS_SEC_RSI_RESET	(3'o0)


//--------------------------------------------
// Random slip power profile features
//--------------------------------------------

`ifdef M14K_SMARTMIPS_SECURITY
`define M14K_SMARTMIPS_SEC_RS_MDU 1
`define M14K_SMARTMIPS_SEC_RS_RFREAD 1
`define M14K_SMARTMIPS_SEC_RS_RFWRITE 1
`define M14K_SMARTMIPS_SEC_RS_ICACHE 1
`define M14K_SMARTMIPS_SEC_RS_CHBYPASS 1
`endif

`endif // M14K_SMARTMIPS

//--------------------------------------------
// Trace related constants
//--------------------------------------------
`define MIPS_TCB_MAX_TRIGGERS 8
`define MIPS_TCB_TRIGGER_BITS (32*`MIPS_TCB_MAX_TRIGGERS)

`define M14K_D_PAR_BITS 36
`define M14K_T_PAR_BITS 25
`define M14K_D_NOPAR_BITS 32
`define M14K_T_NOPAR_BITS 24
`define M14K_D_PAR_BYTES 9 
`define M14K_D_NOPAR_BYTES 8 
`define M14K_MAX_DC_WS_PAR 14
`define M14K_MAX_DC_WS_NOPAR 10

`ifdef	M14K_PARITY
	`define M14K_PARITY_ENABLE	1
	`define M14K_D_BITS  	`M14K_D_PAR_BITS
	`define M14K_T_BITS   	`M14K_T_PAR_BITS
	`define	M14K_D_BYTES	`M14K_D_PAR_BYTES
	`define M14K_MAX_DC_WS   `M14K_MAX_DC_WS_PAR
`else
	`define M14K_PARITY_ENABLE	0
	`define M14K_D_BITS      `M14K_D_NOPAR_BITS
	`define M14K_T_BITS      `M14K_T_NOPAR_BITS
	`define M14K_D_BYTES	`M14K_D_NOPAR_BYTES
	`define M14K_MAX_DC_WS   `M14K_MAX_DC_WS_NOPAR
`endif

`define M14K_FIFO_DEPTH_WIDTH      8

// Scan covarage register/bus defines
// The bits on the bus will hit flops for scan-coverage
`define M14K_DCCSC_EVDVADDR	 9:0
`define M14K_DCCSC_STOREADDR	21:10
`define M14K_DCCSC_MAX		21

`define M14K_ICCSC_TAGADDR	11:0
`define M14K_ICCSC_IVA		23:12
`define M14K_ICCSC_ICCWAY	(`M14K_MAX_IC_ASSOC+23):24
`define M14K_ICCSC_ICCTWAY	(`M14K_MAX_IC_ASSOC+`M14K_MAX_IC_ASSOC+23):(`M14K_MAX_IC_ASSOC+24)
`define M14K_ICCSC_MAX		(`M14K_MAX_IC_ASSOC+`M14K_MAX_IC_ASSOC+23)


// mpc_ctl defines:

`define M14K_IE_SETISA    0
`define M14K_IE_CLRISA    1
`define M14K_IE_UMIPS     2
`define	M14K_IE_SELLOG    3
`define M14K_IE_LSBE      7:4
`define M14K_IE_SIGNED    8
`define M14K_IE_SHAMT     10:9
`define M14K_IE_SIGN      11
`define M14K_IE_UNAL      12
`define M14K_IE_UNALTYP   13
`define M14K_IE_BUSTY     16:14
`define M14K_IE_BS        18:17
`define	M14K_IE_SC        19
`define M14K_IE_SLTSEL    20
`define M14K_IE_ALUSEL    21
`define M14K_IE_LNK       22
`define M14K_IE_SQUASH    23
`define M14K_IE_ANNUL     24
`define M14K_IE_CPSR      27:25
`define M14K_IE_CPR       32:28
`define M14K_IE_LL	  33
`define M14K_IE_LOAD      34
`define M14K_IE_WR_STATUS 35
`define M14K_IE_MULDIV    36
`define M14K_IE_LDST      37
`define M14K_IE_DEST      43:38
`define M14K_IE_BDS       44
`define M14K_IE_WR_INTCTL 45 

`define M14K_IE_CACHE     49:46
`define M14K_IE_PCREL    50 
`define M14K_IE_RANGE    50:0
`define M14K_IE_UMIPS_RANGE    50:3
	
`define M14K_M_UMIPS        0
`define M14K_M_DEST       6:1
`define M14K_M_VD         7
`define M14K_M_MULDIV     8
`define M14K_M_CPMV       9
`define M14K_M_NEWCPW     10
`define M14K_M_CPW        11
`define M14K_M_SQUASH     12
`define M14K_M_STROBE     13
`define M14K_M_SELCP2FROM 14
`define M14K_M_SELCP0     15
`define M14K_M_LOADRES    16
`define	M14K_M_DCBA       17
`define M14K_M_SIGNA      18
`define M14K_M_SIGNB      19
`define M14K_M_SIGNC      20
`define M14K_M_SIGND      21
`define M14K_M_BSIGN      22
`define M14K_M_CDSIGN     23
`define M14K_M_LDA31      25:24
`define M14K_M_LDA23      27:26
`define M14K_M_LDA15      29:28
`define M14K_M_LDA7       31:30
`define M14K_M_LSBE       35:32
`define M14K_M_LOADIN     36
`define M14K_M_PDSTROBE   37
`define M14K_M_ERET	 38
`define M14K_M_DERET	 39
`define M14K_M_CPSC	 40
`define M14K_M_CPDIEI	 41
`define M14K_M_CP0	 42
`define M14K_M_RET	 43
`define M14K_M_STROBE_PM 44 
`define M14K_M_STROBE_ALL     45 

//`ifdef M14K_SMARTMIPS_SEC_RS_RFWRITE
       `define M14K_M_RSLIP      46
       `define M14K_M_RANGE      46:0
       `define M14K_M_UMIPS_RANGE      46:1
//`else	
//	`define M14K_M_RANGE      45:0
//	`define M14K_M_UMIPS_RANGE     45:1
//`endif	

`define M14K_W_PVD        0
`define	M14K_W_SQUASH     1
`define M14K_W_STROBE     2
`define M14K_W_PDSTROBE   3
`define M14K_W_STROBE_PM  4 
`define M14K_W_STROBE_ALL 5 
`define M14K_W_RANGE      5:0	

// sram module defines:


// dbrk module defines:
`define M14K_EJT_DBC_BE     0
`define M14K_EJT_DBC_TE     1
`define M14K_EJT_DBC_BLM    5:2
`define M14K_EJT_DBC_NOLB   6
`define M14K_EJT_DBC_NOSB   7
`define M14K_EJT_DBC_BAI    11:8
`define M14K_EJT_DBC_ASIDU  12
`define	M14K_EJT_DBC_RANGE  12:0


//CDMM constants
`define M14K_MPU_REGHI 31
`define M14K_MPU_REGLO 5
`define M14K_MPU_HLEN 27
// END

