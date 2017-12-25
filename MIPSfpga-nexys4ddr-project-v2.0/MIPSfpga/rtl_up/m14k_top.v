// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE

//	Description: m14k_top 
//          hierarchy level- includes core and TCB
//         as well as the cache modules
//
//	$Id: \$
//	mips_repository_id: m14k_top.hook, v 3.28 
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

module m14k_top(
	HRDATA,
	HREADY,
	HRESP,
	SI_AHBStb,
	HCLK,
	HRESETn,
	HADDR,
	HBURST,
	HPROT,
	HMASTLOCK,
	HSIZE,
	HTRANS,
	HWRITE,
	HWDATA,
	SI_ClkIn,
	SI_ColdReset,
	SI_Endian,
	SI_Int,
	SI_NMI,
	SI_Reset,
	SI_MergeMode,
	SI_CPUNum,
	SI_IPTI,
	SI_EICPresent,
	SI_EICVector,
	SI_Offset,
	SI_EISS,
	SI_BootExcISAMode,
	SI_SRSDisable,
	SI_TraceDisable,
	SI_ClkOut,
	SI_ERL,
	SI_EXL,
	SI_NMITaken,
	SI_NESTERL,
	SI_NESTEXL,
	SI_RP,
	SI_Sleep,
	SI_TimerInt,
	SI_SWInt,
	SI_IAck,
	SI_IPL,
	SI_IVN,
	SI_ION,
	SI_Ibs,
	SI_Dbs,
	PM_InstnComplete,
	gscanmode,
	gscanenable,
	gscanin,
	gscanout,
	gscanramwr,
	gmbinvoke,
	gmbdone,
	gmbddfail,
	gmbtdfail,
	gmbwdfail,
	gmbspfail,
	gmbdifail,
	gmbtifail,
	gmbwifail,
	gmbispfail,
	gmb_ic_algorithm,
	gmb_dc_algorithm,
	gmb_isp_algorithm,
	gmb_sp_algorithm,
	BistIn,
	BistOut,
	EJ_TCK,
	EJ_TDO,
	EJ_TDI,
	EJ_TMS,
	EJ_TRST_N,
	EJ_TDOzstate,
	EJ_ECREjtagBrk,
	EJ_ManufID,
	EJ_PartNumber,
	EJ_Version,
	EJ_DINTsup,
	EJ_DINT,
	EJ_DisableProbeDebug,
	EJ_PerRst,
	EJ_PrRst,
	EJ_SRstE,
	EJ_DebugM,
	TC_ClockRatio,
	TC_Valid,
	TC_Data,
	TC_Stall,
	TC_PibPresent,
	UDI_toudi,
	UDI_fromudi,
	CP2_tocp2,
	CP2_fromcp2,
	ISP_toisp,
	ISP_fromisp,
	DSP_todsp,
	DSP_fromdsp,
	SI_IPFDCI,
	SI_FDCInt,
	SI_IPPCI,
	SI_PCInt);


/*hookios*//* IO declarations added by hookup */
/* End of hookup IO declarations */
/* Wire declarations added by hookup */
wire CP2_abusy_0;		// COP2 Arithmetric instruction busy
wire CP2_as_0;		// COP2 Arithmetric instruction strobe
wire CP2_ccc_0;		// COP2 Condition Code Check
wire CP2_cccs_0;		// COP2 Condition Code Check Strobe
wire CP2_endian_0;		// COP2 Big Endian used in instruction/To/From
wire CP2_exc_0;		// COP2 Exception
wire [4:0] CP2_exccode_0;		// COP2 Exception Code (Valid if CP2_exc_0 == 1)
wire CP2_excs_0;		// COP2 Exceptions strobe
wire CP2_fbusy_0;		// COP2 From data busy
wire [31:0] CP2_fdata_0;		// COP2 From data
wire CP2_fds_0;		// COP2 From data Data strobe
wire [2:0] CP2_forder_0;		// COP2 From data ordering. CP2_forder_0[2:1] not used in this design
wire [2:0] CP2_fordlim_0;		// COP2 From data ordering limit
wire CP2_fs_0;		// COP2 From data instruction strobe
wire CP2_idle;		// COP2 Coprocessor is idle
wire CP2_inst32_0;		// COP2 MIPS32 compatible instruction
wire [31:0] CP2_ir_0;		// COP2 Arithmich and To/From instruction
wire CP2_irenable_0;		// COP2 Enable Instruction registering
wire CP2_kd_mode_0;		// COP2 Instn executing in kernel or debug mode
wire [1:0] CP2_kill_0;		// COP2 Kill (00, 01=NoKill, 10=KillNotCP, 11=KillCP)
wire CP2_kills_0;		// COP2 Kill strobe
wire CP2_null_0;		// COP2 Nullify
wire CP2_nulls_0;		// COP2 Nullify strobe
wire CP2_present;		// COP2 is present (1=present)
wire CP2_reset;		// COP2 greset signal
wire CP2_tbusy_0;		// COP2 To data busy
wire [31:0] CP2_tdata_0;		// COP2 To data
wire CP2_tds_0;		// COP2 To data Data strobe
wire [2:0] CP2_torder_0;		// COP2 To data ordering
wire [2:0] CP2_tordlim_0;		// COP2 To data ordering limit. Not used in this design
wire CP2_ts_0;		// COP2 To data instruction strobe
wire [19:2] DSP_DataAddr;		// DSPRAM Data index
wire DSP_DataRdStr;		// DSPRAM Data Read Strobe
wire [31:0] DSP_DataRdValue;		// DSPRAM Data Read Value
wire [3:0] DSP_DataWrMask;		// DSPRAM Data Write Mask
wire DSP_DataWrStr;		// DSPRAM Data Write Strobe
wire [31:0] DSP_DataWrValue;		// DSPRAM Data Write Value
wire DSP_Hit;		// DSPRAM Hit indication
wire DSP_Lock;		// Start a RMW sequence for DSPRAM
wire DSP_ParPresent;		// DSPRAM has parity support
wire DSP_ParityEn;		// Parity enable for DSPRAM 
wire DSP_Present;		// DSPRAM Present
wire [3:0] DSP_RPar;		// Parity bits read from DSPRAM
wire DSP_Stall;		// DSPRAM access stalled
wire [19:2] DSP_TagAddr;		// DSPRAM Tag Index 
wire [23:0] DSP_TagCmpValue;		// DSPRAM Tag Compare Value
wire DSP_TagRdStr;		// DSPRAM Tag Read Strobe
wire [23:0] DSP_TagRdValue;		// DSPRAM Tag Read Value
wire DSP_TagWrStr;		// DSPRAM Tag Write Strobe
wire [3:0] DSP_WPar;		// Parity bit for DSPRAM write data 
wire [19:2] ISP_Addr;		// ISPRAM Tag/Data index
wire [31:0] ISP_DataRdValue;		// ISPRAM Data Read Value
wire [31:0] ISP_DataTagValue;		// ISPRAM Data Write Value
wire ISP_DataWrStr;		// ISPRAM Data Write Strobe
wire ISP_Hit;		// ISPRAM Hit indication
wire ISP_ParPresent;		// ISPRAM has parity support
wire ISP_ParityEn;		// Parity enable for ISPRAM 
wire ISP_Present;		// ISPRAM Present
wire [3:0] ISP_RPar;		// Parity bits read from ISPRAM
wire ISP_RdStr;		// ISPRAM Tag/Data Read Strobe
wire ISP_Stall;		// ISPRAM access stalled
wire [23:0] ISP_TagCmpValue;		// ISPRAM Data Write Value
wire [23:0] ISP_TagRdValue;		// ISPRAM Tag Read Value
wire ISP_TagWrStr;		// ISPRAM Tag Write Strobe
wire [3:0] ISP_WPar;		// Parity bit for ISPRAM write data 
wire SI_gClkOut;
wire UDI_endianb_e;		// Endian - 0=little, 1=big
wire UDI_gclk;		// Clock
wire UDI_greset;		// greset signal to reset state machine.
wire UDI_gscanenable;
wire UDI_honor_cee;		// Indicate whether UDI has local storage
wire [31:0] UDI_ir_e;		// full 32 bit Spec2 Instruction
wire UDI_irvalid_e;		// Instruction reg. valid signal.
wire UDI_kd_mode_e;		// Mode - 0=user, 1=kernel or debug
wire UDI_kill_m;		// Kill signal
wire UDI_present;		// Indicate whether UDI is implemented
wire [31:0] UDI_rd_m;		// Result of the UDI in M stage
wire UDI_ri_e;		// Illegal Spec2 Instn.
wire [31:0] UDI_rs_e;		// edp_abus_e data from register file
wire [31:0] UDI_rt_e;		// edp_bbus_e data from register file
wire UDI_run_m;		// mpc_run_m signal to qualify kill_m.
wire UDI_stall_m;		// Stall the pipeline. E stage signal
wire UDI_start_e;		// mpc_run_ie signal to start the UDI.
wire [4:0] UDI_wrreg_e;		// Register File address written to
/* End of hookup wire declarations */


	parameter M14K_INSTNUM = 0;              // instance number. 




                input   [31:0]  HRDATA;         //AHB: Read Data Bus
                input           HREADY;         //AHB: Indicate the previous transfer is complete
                input           HRESP;          //AHB: 0 is OKAY, 1 is ERROR
		input 		SI_AHBStb;     //AHB: Signal indicating phase and frequency relationship between clk and hclk. 
                output          HCLK;           //AHB: The bus clock times all bus transfer.
                output          HRESETn;        //AHB: The bus reset signal is active LOW and resets the system and the bus.
                output [31:0]   HADDR;          //AHB: The 32-bit system address bus.
                output [2:0]    HBURST;         //AHB: Burst type; Only Two types:
                                                //                      3'b000  ---     Single; 3'b10  --- 4-beat Wrapping;
                output [3:0]    HPROT;          //AHB: The single indicate the transfer type; Tie to 4'b0011, no significant meaning;
                output          HMASTLOCK;      //AHB: Indicates the current transfer is part of a locked sequence; Tie to 0.
                output [2:0]    HSIZE;          //AHB: Indicates the size of transfer; Only Three types:
                                                //              3'b000 --- Byte; 3'b001 --- Halfword; 3'b010 --- Word;
                output  [1:0]  HTRANS;          //AHB: Indicates the transfer type; Three Types
                                                // 2'b00 --- IDLE, 2'b10 --- NONSEQUENTIAL, 2'b11 --- SEQUENTIAL.
                output        HWRITE;           //AHB: Indicates the transfer direction, Read or Write.
                output  [31:0] HWDATA;          //AHB: Write data bus.


// System Interface Signals
	input		SI_ClkIn;	// clock input
	input		SI_ColdReset;   // Cold greset
	input		SI_Endian;	// Base endianess: 1=big
        input [7:0]     SI_Int;         // Ext. Interrupt pins


	input		SI_NMI;         // Non-maskable interrupt
	input		SI_Reset;       // greset
	input [1:0]     SI_MergeMode;	// SI_MergeMode[0] not used in this design
					// Merging algorithm: 
					// 00- No sub-word store merging
	                                // X1- Reserved
	                                // 10- Full merging - swiss cheese ok
					// Bus Mode
					// 00- Full ECi - swiss cheese, tribytes
					// 01- Naturally aligned B,H,W's only 	
					// 1X- Reserved


	input [9:0]	SI_CPUNum;	// EBase CPU number
	input [2:0]	SI_IPTI;	// TimerInt connection
	input		SI_EICPresent;	// External Interrupt cpntroller present
	input [5:0]	SI_EICVector;	// Vector number for EIC interrupt


	input [17:1]	SI_Offset;


	input [3:0]	SI_EISS;	// Shadow set, comes with the requested interrupt

        input           SI_BootExcISAMode;



        input [3:0]     SI_SRSDisable;  // Disable banks of shadow sets
	input		SI_TraceDisable; // Disables trace hardware
	
	output		SI_ClkOut;	// External bus reference clock
        output 		SI_ERL;         // Error level pin
        output 		SI_EXL;         // Exception level pin
	output		SI_NMITaken;	// NMI pinned out
	output		SI_NESTERL;	// nested error level pinned out
	output		SI_NESTEXL;	// nested exception level pinned out
        output 		SI_RP;          // Reduce power pin
        output 		SI_Sleep;       // Processor is in sleep mode
	output		SI_TimerInt;    // count==compare interrupt


	output [1:0]	SI_SWInt;	// Software interrupt requests to external interrupt controller
	output		SI_IAck;	// Interrupt Acknowledge
        output [7:0]    SI_IPL;         // Current IPL, contains information of which int SI_IACK ack.
	output [5:0] 	SI_IVN;         // Cuurent IVN, contains information of which int SI_IAck ack.
	output [17:1] 	SI_ION;         // Cuurent ION, contains information of which int SI_IAck ack.


        output [7:0]    SI_Ibs;         // Instruction break status
        output [3:0]    SI_Dbs;         // Data break status

	// Performance monitoring signals
        output          PM_InstnComplete;

	/* Scan I/O's */
	input		gscanmode;
	input		gscanenable;
        input [`M14K_NUM_SCAN_CHAIN-1:0] gscanin;
        output [`M14K_NUM_SCAN_CHAIN-1:0] gscanout;        
        
	input 		gscanramwr;
	input 		gmbinvoke;
	output		gmbdone;	// Asserted to indicate that all mem-BIST test is done
	output		gmbddfail;  	// Asserted to indicate that D$ date test failed
	output		gmbtdfail;  	// Asserted to indicate that D$ tag test failed
	output		gmbwdfail;  	// Asserted to indicate that D$ WS test failed
	output		gmbspfail;  	// Asserted to indicate that D$ date test failed
	output		gmbdifail;  	// Asserted to indicate that I$ date test failed
	output		gmbtifail;  	// Asserted to indicate that I$tag test failed
	output		gmbwifail;  	// Asserted to indicate that I$WS test failed
	output		gmbispfail;  	// Asserted to indicate that D$ date test failed
	input	[7:0]	gmb_ic_algorithm; // Alogrithm selection for I$ BIST controller.
	input	[7:0]	gmb_dc_algorithm; // Alogrithm selection for D$ BIST controller.
	input	[7:0]	gmb_isp_algorithm; // Alogrithm selection for ISPRAM BIST controller.
	input	[7:0]	gmb_sp_algorithm; // Alogrithm selection for DSPRAM BIST controller.

	/* User defined Bist I/O's */
	input  [`M14K_TOP_BIST_IN-1:0]	BistIn;
	output [`M14K_TOP_BIST_OUT-1:0]	BistOut;

	/* EJTAG I/O's */
	input		EJ_TCK;
	output		EJ_TDO;
	input		EJ_TDI;
	input		EJ_TMS;
	input		EJ_TRST_N;
	output 		EJ_TDOzstate;
 	output          EJ_ECREjtagBrk;
	input [10:0] 	EJ_ManufID;
	input [15:0] 	EJ_PartNumber;
	input [3:0] 	EJ_Version;
	input		EJ_DINTsup;
	input		EJ_DINT;
	input		EJ_DisableProbeDebug;
	output		EJ_PerRst;
	output		EJ_PrRst;
	output		EJ_SRstE;
	output 		EJ_DebugM;	// Indication that we are in debug mode

	// TCB PIB signals
	output [2:0]	TC_ClockRatio;  	// User's clock ratio selection.
	output		TC_Valid;             	// Data valid indicator.  Not used in this design.
	output [63:0]	TC_Data;       		// Data from TCB.
	input		TC_Stall;             	// Stall request.  Not used in this design.
        input           TC_PibPresent;          // PIB is present   
  


// Impl specific IOs to cpu external modules
	input  [`M14K_UDI_EXT_TOUDI_WIDTH-1:0] UDI_toudi; // External input to UDI module
        output  [`M14K_UDI_EXT_FROMUDI_WIDTH-1:0] UDI_fromudi; // Output from UDI module to external system    

	input [`M14K_CP2_EXT_TOCP2_WIDTH-1:0]   CP2_tocp2; // External input to COP2
    	output [`M14K_CP2_EXT_FROMCP2_WIDTH-1:0] CP2_fromcp2; // External output from COP2

    	input [`M14K_ISP_EXT_TOISP_WIDTH-1:0]    ISP_toisp;  // External input ISPRAM
    	output [`M14K_ISP_EXT_FROMISP_WIDTH-1:0] ISP_fromisp; // External output from ISPRAM


    	input [`M14K_DSP_EXT_TODSP_WIDTH-1:0]    DSP_todsp;  // External input DSPRAM
    	output [`M14K_DSP_EXT_FROMDSP_WIDTH-1:0] DSP_fromdsp; // External output from DSPRAM

   input [2:0]  SI_IPFDCI;       // FDC connection
   output       SI_FDCInt;      // FDC receive FIFO full interrupt

   input [2:0]  SI_IPPCI;       // PCI connection
   output       SI_PCInt;       // PCI receive full interrupt


// verilint 528 off
//	wire	DSP_Lock;
// verilint 528 on


//
  `ifdef MIPS_VMC_SYSTEM
    `include "m14k_vmc_sys.inc"
  `else
    `ifdef MIPS_MINI_SYSTEM_VMC
      `include "m14k_vmc_sys.inc"
    `else
//
/*hookup*/
    m14k_cpu cpu (
	.BistIn(BistIn),
	.BistOut(BistOut),
	.CP2_abusy_0(CP2_abusy_0),
	.CP2_as_0(CP2_as_0),
	.CP2_ccc_0(CP2_ccc_0),
	.CP2_cccs_0(CP2_cccs_0),
	.CP2_endian_0(CP2_endian_0),
	.CP2_exc_0(CP2_exc_0),
	.CP2_exccode_0(CP2_exccode_0),
	.CP2_excs_0(CP2_excs_0),
	.CP2_fbusy_0(CP2_fbusy_0),
	.CP2_fdata_0(CP2_fdata_0),
	.CP2_fds_0(CP2_fds_0),
	.CP2_forder_0(CP2_forder_0),
	.CP2_fordlim_0(CP2_fordlim_0),
	.CP2_fs_0(CP2_fs_0),
	.CP2_idle(CP2_idle),
	.CP2_inst32_0(CP2_inst32_0),
	.CP2_ir_0(CP2_ir_0),
	.CP2_irenable_0(CP2_irenable_0),
	.CP2_kd_mode_0(CP2_kd_mode_0),
	.CP2_kill_0(CP2_kill_0),
	.CP2_kills_0(CP2_kills_0),
	.CP2_null_0(CP2_null_0),
	.CP2_nulls_0(CP2_nulls_0),
	.CP2_present(CP2_present),
	.CP2_reset(CP2_reset),
	.CP2_tbusy_0(CP2_tbusy_0),
	.CP2_tdata_0(CP2_tdata_0),
	.CP2_tds_0(CP2_tds_0),
	.CP2_torder_0(CP2_torder_0),
	.CP2_tordlim_0(CP2_tordlim_0),
	.CP2_ts_0(CP2_ts_0),
	.DSP_DataAddr(DSP_DataAddr),
	.DSP_DataRdStr(DSP_DataRdStr),
	.DSP_DataRdValue(DSP_DataRdValue),
	.DSP_DataWrMask(DSP_DataWrMask),
	.DSP_DataWrStr(DSP_DataWrStr),
	.DSP_DataWrValue(DSP_DataWrValue),
	.DSP_Hit(DSP_Hit),
	.DSP_Lock(DSP_Lock),
	.DSP_ParPresent(DSP_ParPresent),
	.DSP_ParityEn(DSP_ParityEn),
	.DSP_Present(DSP_Present),
	.DSP_RPar(DSP_RPar),
	.DSP_Stall(DSP_Stall),
	.DSP_TagAddr(DSP_TagAddr),
	.DSP_TagCmpValue(DSP_TagCmpValue),
	.DSP_TagRdStr(DSP_TagRdStr),
	.DSP_TagRdValue(DSP_TagRdValue),
	.DSP_TagWrStr(DSP_TagWrStr),
	.DSP_WPar(DSP_WPar),
	.EJ_DINT(EJ_DINT),
	.EJ_DINTsup(EJ_DINTsup),
	.EJ_DebugM(EJ_DebugM),
	.EJ_DisableProbeDebug(EJ_DisableProbeDebug),
	.EJ_ECREjtagBrk(EJ_ECREjtagBrk),
	.EJ_ManufID(EJ_ManufID),
	.EJ_PartNumber(EJ_PartNumber),
	.EJ_PerRst(EJ_PerRst),
	.EJ_PrRst(EJ_PrRst),
	.EJ_SRstE(EJ_SRstE),
	.EJ_TCK(EJ_TCK),
	.EJ_TDI(EJ_TDI),
	.EJ_TDO(EJ_TDO),
	.EJ_TDOzstate(EJ_TDOzstate),
	.EJ_TMS(EJ_TMS),
	.EJ_TRST_N(EJ_TRST_N),
	.EJ_Version(EJ_Version),
	.HADDR(HADDR),
	.HBURST(HBURST),
	.HCLK(HCLK),
	.HMASTLOCK(HMASTLOCK),
	.HPROT(HPROT),
	.HRDATA(HRDATA),
	.HREADY(HREADY),
	.HRESETn(HRESETn),
	.HRESP(HRESP),
	.HSIZE(HSIZE),
	.HTRANS(HTRANS),
	.HWDATA(HWDATA),
	.HWRITE(HWRITE),
	.ISP_Addr(ISP_Addr),
	.ISP_DataRdValue(ISP_DataRdValue),
	.ISP_DataTagValue(ISP_DataTagValue),
	.ISP_DataWrStr(ISP_DataWrStr),
	.ISP_Hit(ISP_Hit),
	.ISP_ParPresent(ISP_ParPresent),
	.ISP_ParityEn(ISP_ParityEn),
	.ISP_Present(ISP_Present),
	.ISP_RPar(ISP_RPar),
	.ISP_RdStr(ISP_RdStr),
	.ISP_Stall(ISP_Stall),
	.ISP_TagCmpValue(ISP_TagCmpValue),
	.ISP_TagRdValue(ISP_TagRdValue),
	.ISP_TagWrStr(ISP_TagWrStr),
	.ISP_WPar(ISP_WPar),
	.PM_InstnComplete(PM_InstnComplete),
	.SI_AHBStb(SI_AHBStb),
	.SI_BootExcISAMode(SI_BootExcISAMode),
	.SI_CPUNum(SI_CPUNum),
	.SI_ClkIn(SI_ClkIn),
	.SI_ClkOut(SI_ClkOut),
	.SI_ColdReset(SI_ColdReset),
	.SI_Dbs(SI_Dbs),
	.SI_EICPresent(SI_EICPresent),
	.SI_EICVector(SI_EICVector),
	.SI_EISS(SI_EISS),
	.SI_ERL(SI_ERL),
	.SI_EXL(SI_EXL),
	.SI_Endian(SI_Endian),
	.SI_FDCInt(SI_FDCInt),
	.SI_IAck(SI_IAck),
	.SI_ION(SI_ION),
	.SI_IPFDCI(SI_IPFDCI),
	.SI_IPL(SI_IPL),
	.SI_IPPCI(SI_IPPCI),
	.SI_IPTI(SI_IPTI),
	.SI_IVN(SI_IVN),
	.SI_Ibs(SI_Ibs),
	.SI_Int(SI_Int),
	.SI_MergeMode(SI_MergeMode),
	.SI_NESTERL(SI_NESTERL),
	.SI_NESTEXL(SI_NESTEXL),
	.SI_NMI(SI_NMI),
	.SI_NMITaken(SI_NMITaken),
	.SI_Offset(SI_Offset),
	.SI_PCInt(SI_PCInt),
	.SI_RP(SI_RP),
	.SI_Reset(SI_Reset),
	.SI_SRSDisable(SI_SRSDisable),
	.SI_SWInt(SI_SWInt),
	.SI_Sleep(SI_Sleep),
	.SI_TimerInt(SI_TimerInt),
	.SI_TraceDisable(SI_TraceDisable),
	.SI_gClkOut(SI_gClkOut),
	.TC_ClockRatio(TC_ClockRatio),
	.TC_Data(TC_Data),
	.TC_PibPresent(TC_PibPresent),
	.TC_Stall(TC_Stall),
	.TC_Valid(TC_Valid),
	.UDI_endianb_e(UDI_endianb_e),
	.UDI_gclk(UDI_gclk),
	.UDI_greset(UDI_greset),
	.UDI_gscanenable(UDI_gscanenable),
	.UDI_honor_cee(UDI_honor_cee),
	.UDI_ir_e(UDI_ir_e),
	.UDI_irvalid_e(UDI_irvalid_e),
	.UDI_kd_mode_e(UDI_kd_mode_e),
	.UDI_kill_m(UDI_kill_m),
	.UDI_present(UDI_present),
	.UDI_rd_m(UDI_rd_m),
	.UDI_ri_e(UDI_ri_e),
	.UDI_rs_e(UDI_rs_e),
	.UDI_rt_e(UDI_rt_e),
	.UDI_run_m(UDI_run_m),
	.UDI_stall_m(UDI_stall_m),
	.UDI_start_e(UDI_start_e),
	.UDI_wrreg_e(UDI_wrreg_e),
	.gmb_dc_algorithm(gmb_dc_algorithm),
	.gmb_ic_algorithm(gmb_ic_algorithm),
	.gmb_isp_algorithm(gmb_isp_algorithm),
	.gmb_sp_algorithm(gmb_sp_algorithm),
	.gmbddfail(gmbddfail),
	.gmbdifail(gmbdifail),
	.gmbdone(gmbdone),
	.gmbinvoke(gmbinvoke),
	.gmbispfail(gmbispfail),
	.gmbspfail(gmbspfail),
	.gmbtdfail(gmbtdfail),
	.gmbtifail(gmbtifail),
	.gmbwdfail(gmbwdfail),
	.gmbwifail(gmbwifail),
	.gscanenable(gscanenable),
	.gscanin(gscanin),
	.gscanmode(gscanmode),
	.gscanout(gscanout),
	.gscanramwr(gscanramwr));
//
    `endif // !MIPS_MINI_SYSTEM_VMC
  `endif // !MIPS_VMC_SYSTEM
//


/*hookup*/
`M14K_UDI_MODULE udi (
	.UDI_endianb_e(UDI_endianb_e),
	.UDI_fromudi(UDI_fromudi),
	.UDI_gclk(UDI_gclk),
	.UDI_greset(UDI_greset),
	.UDI_gscanenable(UDI_gscanenable),
	.UDI_honor_cee(UDI_honor_cee),
	.UDI_ir_e(UDI_ir_e),
	.UDI_irvalid_e(UDI_irvalid_e),
	.UDI_kd_mode_e(UDI_kd_mode_e),
	.UDI_kill_m(UDI_kill_m),
	.UDI_present(UDI_present),
	.UDI_rd_m(UDI_rd_m),
	.UDI_ri_e(UDI_ri_e),
	.UDI_rs_e(UDI_rs_e),
	.UDI_rt_e(UDI_rt_e),
	.UDI_run_m(UDI_run_m),
	.UDI_stall_m(UDI_stall_m),
	.UDI_start_e(UDI_start_e),
	.UDI_toudi(UDI_toudi),
	.UDI_wrreg_e(UDI_wrreg_e));        

/*hookup*/
`M14K_COP2_MODULE cop (
	.CP2_abusy_0(CP2_abusy_0),
	.CP2_as_0(CP2_as_0),
	.CP2_ccc_0(CP2_ccc_0),
	.CP2_cccs_0(CP2_cccs_0),
	.CP2_endian_0(CP2_endian_0),
	.CP2_exc_0(CP2_exc_0),
	.CP2_exccode_0(CP2_exccode_0),
	.CP2_excs_0(CP2_excs_0),
	.CP2_fbusy_0(CP2_fbusy_0),
	.CP2_fdata_0(CP2_fdata_0),
	.CP2_fds_0(CP2_fds_0),
	.CP2_forder_0(CP2_forder_0),
	.CP2_fordlim_0(CP2_fordlim_0),
	.CP2_fromcp2(CP2_fromcp2),
	.CP2_fs_0(CP2_fs_0),
	.CP2_idle(CP2_idle),
	.CP2_inst32_0(CP2_inst32_0),
	.CP2_ir_0(CP2_ir_0),
	.CP2_irenable_0(CP2_irenable_0),
	.CP2_kd_mode_0(CP2_kd_mode_0),
	.CP2_kill_0(CP2_kill_0),
	.CP2_kills_0(CP2_kills_0),
	.CP2_null_0(CP2_null_0),
	.CP2_nulls_0(CP2_nulls_0),
	.CP2_present(CP2_present),
	.CP2_reset(CP2_reset),
	.CP2_tbusy_0(CP2_tbusy_0),
	.CP2_tdata_0(CP2_tdata_0),
	.CP2_tds_0(CP2_tds_0),
	.CP2_tocp2(CP2_tocp2),
	.CP2_torder_0(CP2_torder_0),
	.CP2_tordlim_0(CP2_tordlim_0),
	.CP2_ts_0(CP2_ts_0),
	.SI_ClkIn(SI_ClkIn),
	.SI_Reset(SI_Reset));


//
  `ifdef MIPS_MINI_SYSTEM
  `else
//
/*hookup*/
  `M14K_SPRAMTOP_EXT_MODULE spram (
	.DSP_DataAddr(DSP_DataAddr),
	.DSP_DataRdStr(DSP_DataRdStr),
	.DSP_DataRdValue(DSP_DataRdValue),
	.DSP_DataWrMask(DSP_DataWrMask),
	.DSP_DataWrStr(DSP_DataWrStr),
	.DSP_DataWrValue(DSP_DataWrValue),
	.DSP_Hit(DSP_Hit),
	.DSP_Lock(DSP_Lock),
	.DSP_ParPresent(DSP_ParPresent),
	.DSP_ParityEn(DSP_ParityEn),
	.DSP_Present(DSP_Present),
	.DSP_RPar(DSP_RPar),
	.DSP_Stall(DSP_Stall),
	.DSP_TagAddr(DSP_TagAddr),
	.DSP_TagCmpValue(DSP_TagCmpValue),
	.DSP_TagRdStr(DSP_TagRdStr),
	.DSP_TagRdValue(DSP_TagRdValue),
	.DSP_TagWrStr(DSP_TagWrStr),
	.DSP_WPar(DSP_WPar),
	.DSP_fromdsp(DSP_fromdsp),
	.DSP_todsp(DSP_todsp),
	.ISP_Addr(ISP_Addr),
	.ISP_DataRdValue(ISP_DataRdValue),
	.ISP_DataTagValue(ISP_DataTagValue),
	.ISP_DataWrStr(ISP_DataWrStr),
	.ISP_Hit(ISP_Hit),
	.ISP_ParPresent(ISP_ParPresent),
	.ISP_ParityEn(ISP_ParityEn),
	.ISP_Present(ISP_Present),
	.ISP_RPar(ISP_RPar),
	.ISP_RdStr(ISP_RdStr),
	.ISP_Stall(ISP_Stall),
	.ISP_TagCmpValue(ISP_TagCmpValue),
	.ISP_TagRdValue(ISP_TagRdValue),
	.ISP_TagWrStr(ISP_TagWrStr),
	.ISP_WPar(ISP_WPar),
	.ISP_fromisp(ISP_fromisp),
	.ISP_toisp(ISP_toisp),
	.SI_ClkIn(SI_ClkIn),
	.SI_ColdReset(SI_ColdReset),
	.SI_Sleep(SI_Sleep),
	.SI_gClkOut(SI_gClkOut),
	.gmbinvoke(gmbinvoke),
	.gscanenable(gscanenable));
//
  `endif
//
    
// 
`ifdef MIPS_VMC_INST
  // -----------------------------------------------------------------------
  //  VMC
  // -----------------------------------------------------------------------
  `ifdef MIPS_SIM_TYPE_vcs
    initial begin
      `ifdef MIPS_VMC_SYSTEM
        $swift_window_monitor_on("cpu");
      `else
        $swift_window_monitor_on("vmc_model_m14k_cpu");
      `endif
    end
  `else
    `include "mips_m14k_vmc_window.init.inc"
  `endif
  `ifdef MIPS_VMC_DUAL_INST
    `include "m14k_vmc_dup.inc"
    `include "m14k_vmc_dup_cmp.inc"
  `endif
`endif

`ifdef M14K_GATE_BUILD
  // -----------------------------------------------------------------------
  //  GATES SIM
  // -----------------------------------------------------------------------
  `ifdef M14K_GATE_MOD_CPU
    `include "m14k_gate_dup.inc"

    `ifdef M14K_GATESIM_SDF
      initial begin
        $sdf_annotate("m14k_gate.sdf", gate_model_cpu, ,"sdf_annotate.log");
      end
    `endif // M14K_GATESIM_SDF
  `endif // M14K_GATE_MOD_CPU
`endif // M14K_GATE_BUILD
// 


endmodule	// m14k_top
