// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE

//	Description: m14k_cpu 
//          hierarchy level- includes core and TCB
//         as well as the cache modules
//
//      $Id: \$
//      mips_repository_id: m14k_cpu.hook, v 3.44 
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


`include "m14k_const.vh"

module m14k_cpu(
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
	SI_gClkOut,
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
	CP2_abusy_0,
	CP2_tbusy_0,
	CP2_fbusy_0,
	CP2_cccs_0,
	CP2_ccc_0,
	CP2_present,
	CP2_idle,
	CP2_excs_0,
	CP2_exc_0,
	CP2_exccode_0,
	CP2_fds_0,
	CP2_forder_0,
	CP2_fdata_0,
	CP2_tordlim_0,
	CP2_as_0,
	CP2_ts_0,
	CP2_fs_0,
	CP2_irenable_0,
	CP2_ir_0,
	CP2_endian_0,
	CP2_inst32_0,
	CP2_kd_mode_0,
	CP2_nulls_0,
	CP2_null_0,
	CP2_reset,
	CP2_kills_0,
	CP2_kill_0,
	CP2_tds_0,
	CP2_tdata_0,
	CP2_torder_0,
	CP2_fordlim_0,
	ISP_TagWrStr,
	ISP_Addr,
	ISP_DataTagValue,
	ISP_TagCmpValue,
	ISP_RdStr,
	ISP_DataWrStr,
	ISP_DataRdValue,
	ISP_TagRdValue,
	ISP_Hit,
	ISP_Stall,
	ISP_Present,
	DSP_Lock,
	DSP_TagAddr,
	DSP_TagRdStr,
	DSP_TagWrStr,
	DSP_TagCmpValue,
	DSP_DataAddr,
	DSP_DataWrValue,
	DSP_DataRdStr,
	DSP_DataWrStr,
	DSP_DataWrMask,
	DSP_DataRdValue,
	DSP_TagRdValue,
	DSP_Hit,
	DSP_Stall,
	DSP_Present,
	DSP_ParityEn,
	ISP_ParityEn,
	DSP_WPar,
	ISP_WPar,
	DSP_ParPresent,
	ISP_ParPresent,
	DSP_RPar,
	ISP_RPar,
	PM_InstnComplete,
	gscanmode,
	gscanenable,
	gscanin,
	gscanout,
	gscanramwr,
	BistIn,
	BistOut,
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
	EJ_DisableProbeDebug,
	EJ_DINTsup,
	EJ_DINT,
	EJ_PerRst,
	EJ_PrRst,
	EJ_SRstE,
	EJ_DebugM,
	TC_ClockRatio,
	TC_Valid,
	TC_Data,
	TC_Stall,
	TC_PibPresent,
	UDI_ir_e,
	UDI_irvalid_e,
	UDI_rs_e,
	UDI_rt_e,
	UDI_endianb_e,
	UDI_kd_mode_e,
	UDI_kill_m,
	UDI_start_e,
	UDI_run_m,
	UDI_greset,
	UDI_gclk,
	UDI_gscanenable,
	UDI_rd_m,
	UDI_wrreg_e,
	UDI_ri_e,
	UDI_stall_m,
	UDI_present,
	UDI_honor_cee,
	SI_IPFDCI,
	SI_FDCInt,
	SI_IPPCI,
	SI_PCInt);

  
/*hookios*//* IO declarations added by hookup */
/* End of hookup IO declarations */
/* Wire declarations added by hookup */
wire CP1_abusy_0;
wire CP1_as_0;
wire CP1_ccc_0;
wire CP1_cccs_0;
wire CP1_endian_0;
wire CP1_exc_0;
wire CP1_exc_1;
wire [4:0] CP1_exccode_0;
wire [4:0] CP1_exccode_1;
wire CP1_excs_0;
wire CP1_excs_1;
wire CP1_fbusy_0;
wire [63:0] CP1_fdata_0;
wire CP1_fds_0;
wire [2:0] CP1_forder_0;
wire [2:0] CP1_fordlim_0;
wire CP1_fppresent;		// COP1 is present (1=present)
wire CP1_fr32_0;
wire CP1_fs_0;
wire [3:0] CP1_gpr_0;
wire CP1_gprs_0;
wire CP1_idle;
wire CP1_inst31_0;
wire CP1_inst32_0;
wire [31:0] CP1_ir_0;
wire CP1_irenable_0;
wire [1:0] CP1_kill_0;
wire [1:0] CP1_kill_1;
wire CP1_kills_0;
wire CP1_kills_1;
wire CP1_mdmxpresent;		// COP1 is present (1=present)
wire CP1_null_0;
wire CP1_nulls_0;
wire CP1_reset;
wire CP1_tbusy_0;
wire [63:0] CP1_tdata_0;
wire CP1_tds_0;
wire [2:0] CP1_torder_0;
wire [2:0] CP1_tordlim_0;
wire CP1_ts_0;
wire CP1_ufrpresent;
wire [7:0] DSP_GuestID;
wire [7:0] ISP_GuestID;
wire [7:0] SI_EICGID;
wire [5:0] SI_GEICVector;		// Vector number for EIC interrupt
wire [3:0] SI_GEISS;		// Shadow set, comes with the requested interrupt
wire SI_GIAck;		// Interrupt Acknowledge
wire [7:0] SI_GID;
wire [17:1] SI_GION;		// Cuurent ION, contains information of which int SI_IAck ack.
wire [7:0] SI_GIPL;		// Cuurent IPL, contains information of which int SI_IAck ack.
wire [5:0] SI_GIVN;		// Cuurent IVN, contains information of which int SI_IAck ack.
wire [7:0] SI_GInt;		// Ext. Interrupt pins
wire [17:1] SI_GOffset;		// Vector offset for EIC interrupt
wire SI_GPCInt;
wire [1:0] SI_GSWInt;		// Software interrupt requests to external interrupt controller
wire SI_GTimerInt;		// count==compare interrupt
wire antitamper_present;
wire [`M14K_DC_BIST_TO-1:0] bc_dbistto;		// bist signals to dcache
wire [`M14K_IC_BIST_TO-1:0] bc_ibistto;		// bist signals to icache
wire [`M14K_RF_BIST_TO-1:0] bc_rfbistto;		// bist signals to generator based RF
wire [`M14K_TCB_TRMEM_BIST_TO-1:0] bc_tcbbistto;		// bist signals to tcb onchip mem
wire cpz_mnan;		// Address of inst in W
wire [15:0] cpz_prid16;
wire [31:0] cpz_scramblecfg_data;
wire [7:0] cpz_scramblecfg_sel;
wire cpz_scramblecfg_write;
wire [`M14K_DC_BIST_FROM-1:0] dc_bistfrom;		// bist signals from dcache
wire [13:2] dc_data_addr_scr;
wire [(`M14K_D_BITS*`M14K_MAX_DC_ASSOC-1):0] dc_datain;		// D$ Data
wire dc_hci;		// Hardware D$ init
wire [2:0] dc_nsets;		// Number of sets   - static
wire dc_present;		// D$ is present
wire [(`M14K_D_BITS*`M14K_MAX_DC_ASSOC-1):0] dc_rd_data_scr;
wire [1:0] dc_ssize;		// D$ associativity - static
wire [13:4] dc_tag_addr_scr;
wire [(`M14K_T_BITS*`M14K_MAX_DC_ASSOC-1):0] dc_tag_rd_data_scr;
wire [(`M14K_T_BITS-1):0] dc_tag_wr_data_scr;
wire [(`M14K_MAX_DC_ASSOC-1):0] dc_tag_wr_en_scr;
wire [(`M14K_T_BITS*`M14K_MAX_DC_ASSOC-1):0] dc_tagin;		// D$ Tag
wire [(`M14K_D_BITS-1):0] dc_wr_data_scr;
wire [(4*`M14K_MAX_DC_ASSOC-1):0] dc_wr_mask_scr;
wire [13:4] dc_ws_addr_scr;
wire [13:0] dc_ws_rd_data_scr;
wire [13:0] dc_ws_wr_data_scr;
wire [13:0] dc_ws_wr_mask_scr;
wire [13:0] dc_wsin;		// D$ WS
wire dca_parity_present;		// D$ supports parity
wire [`M14K_D_BITS-1:0] dcc_data;		// Write Data
wire dcc_drstb;		// Data read strobe
wire dcc_dwstb;		// Data write Strobe
wire [`M14K_T_BITS-1:0] dcc_tagwrdata;		// Tag write data
wire [(`M14K_MAX_DC_ASSOC-1):0] dcc_tagwren;		// Write way
wire dcc_trstb;		// Tag Read Strobe
wire dcc_twstb;		// Tag write strobe
wire [(4*`M14K_MAX_DC_ASSOC-1):0] dcc_writemask;		// Write mask
wire [13:4] dcc_wsaddr;		// Index into WS array
wire dcc_wsrstb;		// WS Read Strobe
wire [13:0] dcc_wswrdata;		// WS write data
wire [13:0] dcc_wswren;		// WS write mask
wire dcc_wswstb;		// WS write strobe
wire [19:2] dsp_data_addr;
wire [31:0] dsp_rd_data;
wire [3:0] dsp_rd_par;
wire [31:0] dsp_wr_data;
wire [3:0] dsp_wr_mask;
wire [3:0] dsp_wr_par;
wire fpu_gclk;
wire fpu_gclk_ratio;
wire gclk;		// Clock
wire greset;
wire [`M14K_IC_BIST_FROM-1:0] ic_bistfrom;		// bist signals from icache
wire [13:2] ic_data_addr_scr;
wire [(`M14K_D_BITS*`M14K_MAX_IC_ASSOC-1):0] ic_datain;		// I$ Data						
wire ic_hci;		// Hardware I$ init
wire [2:0] ic_nsets;		// Number of sets   - static
wire ic_present;		// I$ is presenti
wire [(`M14K_D_BITS*`M14K_MAX_IC_ASSOC-1):0] ic_rd_data_scr;
wire [(`M14K_MAX_IC_ASSOC-1):0] ic_rd_mask_scr;
wire [1:0] ic_ssize;		// I$ associativity - static
wire [13:4] ic_tag_addr_scr;
wire [(`M14K_T_BITS*`M14K_MAX_IC_ASSOC-1):0] ic_tag_rd_data_scr;
wire [(`M14K_T_BITS-1):0] ic_tag_wr_data_scr;
wire [(`M14K_MAX_IC_ASSOC-1):0] ic_tag_wr_en_scr;
wire [(`M14K_T_BITS*`M14K_MAX_IC_ASSOC-1):0] ic_tagin;		// I$ Tag
wire [(`M14K_D_BITS-1):0] ic_wr_data_scr;
wire [(4*`M14K_MAX_IC_ASSOC-1):0] ic_wr_mask_scr;
wire [13:4] ic_ws_addr_scr;
wire [(`M14K_MAX_IC_WS-1):0] ic_ws_rd_data_scr;
wire [(`M14K_MAX_IC_WS-1):0] ic_ws_wr_data_scr;
wire [(`M14K_MAX_IC_WS-1):0] ic_ws_wr_mask_scr;
wire [(`M14K_MAX_IC_WS-1):0] ic_wsin;		// I$ WS
wire ica_parity_present;		// I$ support parity or not
wire [`M14K_D_BITS-1:0] icc_data;		// Write Data						
wire icc_drstb;		// Tied to TRStb					
wire icc_dwstb;		// Data write Strobe					
wire [`M14K_MAX_IC_ASSOC-1:0] icc_readmask;
wire icc_spwr_active;
wire [`M14K_T_BITS-1:0] icc_tagwrdata;		// tag write data
wire [(`M14K_MAX_IC_ASSOC-1):0] icc_tagwren;		// Write way/ Access way (Cacheop)			
wire icc_trstb;		// Tag Read Strobe					
wire icc_twstb;		// Tag write strobe					
wire [(4*`M14K_MAX_IC_ASSOC-1):0] icc_writemask;		// Data write Byte Mask
wire [13:4] icc_wsaddr;		// Index into WS array
wire icc_wsrstb;		// WS Read Strobe
wire [(`M14K_MAX_IC_WS-1):0] icc_wswrdata;		// WS write data
wire [(`M14K_MAX_IC_WS-1):0] icc_wswren;		// WS write mask
wire icc_wswstb;		// WS write strobe
wire [19:2] isp_data_addr;
wire [19:2] isp_dataaddr_scr;
wire [31:0] isp_rd_data;
wire [3:0] isp_rd_par;
wire [31:0] isp_wr_data;
wire [3:0] isp_wr_par;
wire mpc_disable_gclk_xx;
wire [`M14K_RF_BIST_FROM-1:0] rf_bistfrom;		// bist signals from generator based RF
wire [`M14K_TCB_TRMEM_BIST_FROM-1:0] tcb_bistfrom;		// bist signals from tcb onchip mem
/* End of hookup wire declarations */


	parameter M14K_INSTNUM = 0;              // instance number. 





		input   [31:0]  HRDATA;         //AHB: Read Data Bus
                input           HREADY;         //AHB: Indicate the previous transfer is complete
                input           HRESP;          //AHB: 0 is OKAY, 1 is ERROR
		input           SI_AHBStb;     //AHB: Signal indicating phase and frequency relationship between clk and hclk. 
		output          HCLK;           //AHB: The bus clock times all bus transfer.
                output          HRESETn;        //AHB: The bus reset signal is active LOW and resets the system and the bus.
                output [31:0]   HADDR;          //AHB: The 32-bit system address bus.
                output [2:0]    HBURST;         //AHB: Burst type; Only Two types:
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
	output		SI_gClkOut;
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

//add SI_Offset for EIC Supplies Offset
	input [17:1]	SI_Offset;	// Vector offset for EIC interrupt


	input [3:0]	SI_EISS;	// Shadow set, comes with the requested interrupt

        input           SI_BootExcISAMode;



        input [3:0]     SI_SRSDisable;  // Disable banks of shadow sets
					// 000 - use all implemented register sets
					// 100 - only use 4 register sets
					// 110 - only use 2 register sets
					// 111 - only use 1 register set	
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

	// Cop2 I/F signals
	input		CP2_abusy_0;	// COP2 Arithmetric instruction busy
	input		CP2_tbusy_0;	// COP2 To data busy
	input		CP2_fbusy_0;	// COP2 From data busy
	input		CP2_cccs_0;	// COP2 Condition Code Check Strobe
	input		CP2_ccc_0;	// COP2 Condition Code Check
	input		CP2_present;	// COP2 is present (1=present)
	input		CP2_idle;	// COP2 Coprocessor is idle
	input		CP2_excs_0;	// COP2 Exceptions strobe
	input		CP2_exc_0;	// COP2 Exception
	input [4:0]	CP2_exccode_0;	// COP2 Exception Code (Valid if CP2_exc_0 == 1)
	input		CP2_fds_0;	// COP2 From data Data strobe
	input [2:0]	CP2_forder_0;	// COP2 From data ordering. CP2_forder_0[2:1] not used in this design
	input [31:0]	CP2_fdata_0;	// COP2 From data
   	input [2:0]	CP2_tordlim_0;	// COP2 To data ordering limit. Not used in this design
	output		CP2_as_0;	// COP2 Arithmetric instruction strobe
	output		CP2_ts_0;	// COP2 To data instruction strobe
	output		CP2_fs_0;	// COP2 From data instruction strobe
   	output 	 	CP2_irenable_0;	// COP2 Enable Instruction registering
	output [31:0] 	CP2_ir_0;	// COP2 Arithmich and To/From instruction
	output		CP2_endian_0;	// COP2 Big Endian used in instruction/To/From
	output		CP2_inst32_0;	// COP2 MIPS32 compatible instruction
	output		CP2_kd_mode_0;	// COP2 Instn executing in kernel or debug mode
	output		CP2_nulls_0;	// COP2 Nullify strobe
	output		CP2_null_0;	// COP2 Nullify
	output		CP2_reset;	// COP2 greset signal
	output		CP2_kills_0;	// COP2 Kill strobe
	output [1:0]  	CP2_kill_0;	// COP2 Kill (00, 01=NoKill, 10=KillNotCP, 11=KillCP)
	output		CP2_tds_0;	// COP2 To data Data strobe
	output [31:0] 	CP2_tdata_0;	// COP2 To data
   	output [2:0]  	CP2_torder_0;	// COP2 To data ordering
   	output [2:0]  	CP2_fordlim_0;	// COP2 From data ordering limit

// Spram I/F signals

	output 		ISP_TagWrStr;		// ISPRAM Tag Write Strobe
	output [19:2] 	ISP_Addr;		// ISPRAM Tag/Data index
	output [31:0]	ISP_DataTagValue;	// ISPRAM Data Write Value
	output [23:0]	ISP_TagCmpValue;	// ISPRAM Data Write Value
	output 		ISP_RdStr;		// ISPRAM Tag/Data Read Strobe
	output 		ISP_DataWrStr;		// ISPRAM Data Write Strobe
	
	input [31:0]	ISP_DataRdValue;	// ISPRAM Data Read Value
	input [23:0] 	ISP_TagRdValue;		// ISPRAM Tag Read Value
	input 		ISP_Hit;		// ISPRAM Hit indication
	input 		ISP_Stall;		// ISPRAM access stalled
	input 		ISP_Present;		// ISPRAM Present

	output		DSP_Lock;		// Start a RMW sequence for DSPRAM
	output [19:2] 	DSP_TagAddr;		// DSPRAM Tag Index 
	output 		DSP_TagRdStr;		// DSPRAM Tag Read Strobe
	output 		DSP_TagWrStr;		// DSPRAM Tag Write Strobe
	output [23:0]	DSP_TagCmpValue;	// DSPRAM Tag Compare Value
	output [19:2] 	DSP_DataAddr;		// DSPRAM Data index
	output [31:0]	DSP_DataWrValue;	// DSPRAM Data Write Value
	output 		DSP_DataRdStr;		// DSPRAM Data Read Strobe
	output 		DSP_DataWrStr;		// DSPRAM Data Write Strobe
	output [3:0]	DSP_DataWrMask;		// DSPRAM Data Write Mask
	
	input [31:0]	DSP_DataRdValue;	// DSPRAM Data Read Value
	input [23:0] 	DSP_TagRdValue;		// DSPRAM Tag Read Value
	input 		DSP_Hit;		// DSPRAM Hit indication
	input 		DSP_Stall;		// DSPRAM access stalled
	input 		DSP_Present;		// DSPRAM Present
	output		DSP_ParityEn;		// Parity enable for DSPRAM 
	output		ISP_ParityEn;		// Parity enable for ISPRAM 
	output	[3:0]	DSP_WPar;		// Parity bit for DSPRAM write data 
	output	[3:0]	ISP_WPar;		// Parity bit for ISPRAM write data 
	input		DSP_ParPresent;		// DSPRAM has parity support
	input		ISP_ParPresent;		// ISPRAM has parity support
	input	[3:0]	DSP_RPar;		// Parity bits read from DSPRAM
	input	[3:0]	ISP_RPar;		// Parity bits read from ISPRAM
 
// Performance monitoring signals
	output          PM_InstnComplete;

	/* Scan I/O's */
	input		gscanmode;
	input		gscanenable;
        input [`M14K_NUM_SCAN_CHAIN-1:0] gscanin;
        output [`M14K_NUM_SCAN_CHAIN-1:0] gscanout;        
        
	input 		gscanramwr;
	// Scan in and Scan out pins are auto inserted
	// by the DFT Tool.
   
	/* Bist I/O's */
	input  [`M14K_TOP_BIST_IN-1:0]	BistIn;
	output [`M14K_TOP_BIST_OUT-1:0]	BistOut;
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
        input   [7:0]   gmb_ic_algorithm; // Alogrithm selection for I$ BIST controller.
        input   [7:0]   gmb_dc_algorithm; // Alogrithm selection for D$ BIST controller.
        input   [7:0]   gmb_isp_algorithm; // Alogrithm selection for ISPRAM BIST controller.
        input   [7:0]   gmb_sp_algorithm; // Alogrithm selection for DSPRAM BIST controller.

	/* EJTAG I/O's */
	input		EJ_TCK;
	output		EJ_TDO;
	input		EJ_TDI;
	input		EJ_TMS;
	input		EJ_TRST_N;
	output 		EJ_TDOzstate;
	output		EJ_ECREjtagBrk;
	input [10:0] 	EJ_ManufID;
	input [15:0] 	EJ_PartNumber;
	input [3:0] 	EJ_Version;
	input		EJ_DisableProbeDebug;
	input		EJ_DINTsup;
	input		EJ_DINT;
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

        // UDI SIGNALS
        /* Outputs */
        output [31:0]    UDI_ir_e;           // full 32 bit Spec2 Instruction
        output           UDI_irvalid_e;      // Instruction reg. valid signal.

        output [31:0]    UDI_rs_e;           // edp_abus_e data from register file
        output [31:0]    UDI_rt_e;           // edp_bbus_e data from register file

	output  	 UDI_endianb_e;      // Endian - 0=little, 1=big
	output 		 UDI_kd_mode_e;      // Mode - 0=user, 1=kernel or debug

        output           UDI_kill_m;         // Kill signal
        output           UDI_start_e;        // mpc_run_ie signal to start the UDI.
        output 		 UDI_run_m;          // mpc_run_m signal to qualify kill_m.

        output           UDI_greset;         // greset signal to reset state machine.
        output           UDI_gclk;           // Clock
        output 		 UDI_gscanenable;

        /* Inputs */
        input [31:0]     UDI_rd_m;           // Result of the UDI in M stage
        input [4:0]      UDI_wrreg_e;        // Register File address written to
                                        // 5'b0 indicates not writing to 
                                        // register file.
        input            UDI_ri_e;           // Illegal Spec2 Instn.
        input            UDI_stall_m;        // Stall the pipeline. E stage signal
	input   	 UDI_present;        // Indicate whether UDI is implemented
        input            UDI_honor_cee;      // Indicate whether UDI has local storage

   input [2:0]  SI_IPFDCI;       // FDC connection
   output       SI_FDCInt;      // FDC receive FIFO full interrupt

   input [2:0]  SI_IPPCI;       // PCI connection
   output       SI_PCInt;       // PCI receive full interrupt

// BEGIN Wire declarations made by MVP
wire SI_gClkOut;
wire SI_Slip;
// END Wire declarations made by MVP



//
assign ISP_TagCmpValue[23:0] = isp_wr_data[23:0];
//

        /* Internal Block Wires */
	wire [13:4] icc_tagaddr, dcc_tagaddr;
	wire [13:2] icc_dataaddr, dcc_dataaddr;
	wire	icc_early_tag_ce;
        wire	icc_early_ws_ce;
        wire	icc_early_data_ce;
	wire	dcc_early_tag_ce;
        wire	dcc_early_ws_ce;
        wire	dcc_early_data_ce;


assign SI_Slip=1'b0;	// Inject security slip into pipeline


//
assign SI_GEICVector[5:0] = 6'd0;
assign SI_GOffset[17:1] = 17'd0;
assign SI_GEISS[3:0]  = 4'd0;
assign SI_EICGID[7:0] = 8'd0;
assign SI_GInt[7:0] = 8'd0;
//


/*hookup*/
m14k_core core (
	.CP1_abusy_0(CP1_abusy_0),
	.CP1_as_0(CP1_as_0),
	.CP1_ccc_0(CP1_ccc_0),
	.CP1_cccs_0(CP1_cccs_0),
	.CP1_endian_0(CP1_endian_0),
	.CP1_exc_0(CP1_exc_0),
	.CP1_exc_1(CP1_exc_1),
	.CP1_exccode_0(CP1_exccode_0),
	.CP1_exccode_1(CP1_exccode_1),
	.CP1_excs_0(CP1_excs_0),
	.CP1_excs_1(CP1_excs_1),
	.CP1_fbusy_0(CP1_fbusy_0),
	.CP1_fdata_0(CP1_fdata_0),
	.CP1_fds_0(CP1_fds_0),
	.CP1_forder_0(CP1_forder_0),
	.CP1_fordlim_0(CP1_fordlim_0),
	.CP1_fppresent(CP1_fppresent),
	.CP1_fr32_0(CP1_fr32_0),
	.CP1_fs_0(CP1_fs_0),
	.CP1_gpr_0(CP1_gpr_0),
	.CP1_gprs_0(CP1_gprs_0),
	.CP1_idle(CP1_idle),
	.CP1_inst31_0(CP1_inst31_0),
	.CP1_ir_0(CP1_ir_0),
	.CP1_irenable_0(CP1_irenable_0),
	.CP1_kill_0(CP1_kill_0),
	.CP1_kill_1(CP1_kill_1),
	.CP1_kills_0(CP1_kills_0),
	.CP1_kills_1(CP1_kills_1),
	.CP1_mdmxpresent(CP1_mdmxpresent),
	.CP1_null_0(CP1_null_0),
	.CP1_nulls_0(CP1_nulls_0),
	.CP1_reset(CP1_reset),
	.CP1_tbusy_0(CP1_tbusy_0),
	.CP1_tdata_0(CP1_tdata_0),
	.CP1_tds_0(CP1_tds_0),
	.CP1_torder_0(CP1_torder_0),
	.CP1_tordlim_0(CP1_tordlim_0),
	.CP1_ts_0(CP1_ts_0),
	.CP1_ufrpresent(CP1_ufrpresent),
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
	.DSP_DataAddr(dsp_data_addr),
	.DSP_DataRdStr(DSP_DataRdStr),
	.DSP_DataRdValue(dsp_rd_data),
	.DSP_DataWrMask(dsp_wr_mask),
	.DSP_DataWrStr(DSP_DataWrStr),
	.DSP_DataWrValue(dsp_wr_data),
	.DSP_GuestID(DSP_GuestID),
	.DSP_Hit(DSP_Hit),
	.DSP_Lock(DSP_Lock),
	.DSP_ParPresent(DSP_ParPresent),
	.DSP_ParityEn(DSP_ParityEn),
	.DSP_Present(DSP_Present),
	.DSP_RPar(dsp_rd_par),
	.DSP_Stall(DSP_Stall),
	.DSP_TagAddr(DSP_TagAddr),
	.DSP_TagCmpValue(DSP_TagCmpValue),
	.DSP_TagRdStr(DSP_TagRdStr),
	.DSP_TagRdValue(DSP_TagRdValue),
	.DSP_TagWrStr(DSP_TagWrStr),
	.DSP_WPar(dsp_wr_par),
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
	.ISP_Addr(isp_data_addr),
	.ISP_DataRdValue(isp_rd_data),
	.ISP_DataTagValue(isp_wr_data),
	.ISP_DataWrStr(ISP_DataWrStr),
	.ISP_GuestID(ISP_GuestID),
	.ISP_Hit(ISP_Hit),
	.ISP_ParPresent(ISP_ParPresent),
	.ISP_ParityEn(ISP_ParityEn),
	.ISP_Present(ISP_Present),
	.ISP_RPar(isp_rd_par),
	.ISP_RdStr(ISP_RdStr),
	.ISP_Stall(ISP_Stall),
	.ISP_TagRdValue(ISP_TagRdValue),
	.ISP_TagWrStr(ISP_TagWrStr),
	.ISP_WPar(isp_wr_par),
	.PM_InstnComplete(PM_InstnComplete),
	.SI_AHBStb(SI_AHBStb),
	.SI_BootExcISAMode(SI_BootExcISAMode),
	.SI_CPUNum(SI_CPUNum),
	.SI_ClkIn(SI_ClkIn),
	.SI_ClkOut(SI_ClkOut),
	.SI_ColdReset(SI_ColdReset),
	.SI_Dbs(SI_Dbs),
	.SI_EICGID(SI_EICGID),
	.SI_EICPresent(SI_EICPresent),
	.SI_EICVector(SI_EICVector),
	.SI_EISS(SI_EISS),
	.SI_ERL(SI_ERL),
	.SI_EXL(SI_EXL),
	.SI_Endian(SI_Endian),
	.SI_FDCInt(SI_FDCInt),
	.SI_GEICVector(SI_GEICVector),
	.SI_GEISS(SI_GEISS),
	.SI_GIAck(SI_GIAck),
	.SI_GID(SI_GID),
	.SI_GION(SI_GION),
	.SI_GIPL(SI_GIPL),
	.SI_GIVN(SI_GIVN),
	.SI_GInt(SI_GInt),
	.SI_GOffset(SI_GOffset),
	.SI_GPCInt(SI_GPCInt),
	.SI_GSWInt(SI_GSWInt),
	.SI_GTimerInt(SI_GTimerInt),
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
	.SI_Slip(SI_Slip),
	.SI_TimerInt(SI_TimerInt),
	.SI_TraceDisable(SI_TraceDisable),
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
	.antitamper_present(antitamper_present),
	.bc_rfbistto(bc_rfbistto),
	.bc_tcbbistto(bc_tcbbistto),
	.cpz_mnan(cpz_mnan),
	.cpz_prid16(cpz_prid16),
	.cpz_scramblecfg_data(cpz_scramblecfg_data),
	.cpz_scramblecfg_sel(cpz_scramblecfg_sel),
	.cpz_scramblecfg_write(cpz_scramblecfg_write),
	.dc_datain(dc_datain),
	.dc_hci(dc_hci),
	.dc_nsets(dc_nsets),
	.dc_present(dc_present),
	.dc_ssize(dc_ssize),
	.dc_tagin(dc_tagin),
	.dc_wsin(dc_wsin),
	.dca_parity_present(dca_parity_present),
	.dcc_data(dcc_data),
	.dcc_dataaddr(dcc_dataaddr),
	.dcc_drstb(dcc_drstb),
	.dcc_dwstb(dcc_dwstb),
	.dcc_early_data_ce(dcc_early_data_ce),
	.dcc_early_tag_ce(dcc_early_tag_ce),
	.dcc_early_ws_ce(dcc_early_ws_ce),
	.dcc_tagaddr(dcc_tagaddr),
	.dcc_tagwrdata(dcc_tagwrdata),
	.dcc_tagwren(dcc_tagwren),
	.dcc_trstb(dcc_trstb),
	.dcc_twstb(dcc_twstb),
	.dcc_writemask(dcc_writemask),
	.dcc_wsaddr(dcc_wsaddr),
	.dcc_wsrstb(dcc_wsrstb),
	.dcc_wswrdata(dcc_wswrdata),
	.dcc_wswren(dcc_wswren),
	.dcc_wswstb(dcc_wswstb),
	.gclk(gclk),
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
	.greset(greset),
	.gscanenable(gscanenable),
	.gscanmode(gscanmode),
	.gscanramwr(gscanramwr),
	.ic_datain(ic_datain),
	.ic_hci(ic_hci),
	.ic_nsets(ic_nsets),
	.ic_present(ic_present),
	.ic_ssize(ic_ssize),
	.ic_tagin(ic_tagin),
	.ic_wsin(ic_wsin),
	.ica_parity_present(ica_parity_present),
	.icc_data(icc_data),
	.icc_dataaddr(icc_dataaddr),
	.icc_drstb(icc_drstb),
	.icc_dwstb(icc_dwstb),
	.icc_early_data_ce(icc_early_data_ce),
	.icc_early_tag_ce(icc_early_tag_ce),
	.icc_early_ws_ce(icc_early_ws_ce),
	.icc_readmask(icc_readmask),
	.icc_spwr_active(icc_spwr_active),
	.icc_tagaddr(icc_tagaddr),
	.icc_tagwrdata(icc_tagwrdata),
	.icc_tagwren(icc_tagwren),
	.icc_trstb(icc_trstb),
	.icc_twstb(icc_twstb),
	.icc_writemask(icc_writemask),
	.icc_wsaddr(icc_wsaddr),
	.icc_wsrstb(icc_wsrstb),
	.icc_wswrdata(icc_wswrdata),
	.icc_wswren(icc_wswren),
	.icc_wswstb(icc_wswstb),
	.isp_dataaddr_scr(isp_dataaddr_scr),
	.mpc_disable_gclk_xx(mpc_disable_gclk_xx),
	.rf_bistfrom(rf_bistfrom),
	.tcb_bistfrom(tcb_bistfrom));

	assign SI_gClkOut = gclk;

/*hookup*/
m14k_cscramble_tpl cscramble_tpl (
	.cfg_data(cpz_scramblecfg_data),
	.cfg_sel(cpz_scramblecfg_sel),
	.cfg_write(cpz_scramblecfg_write),
	.dc_data_addr(dcc_dataaddr[13:2]),
	.dc_data_addr_scr(dc_data_addr_scr),
	.dc_data_rd_str(dcc_drstb),
	.dc_data_wr_str(dcc_dwstb),
	.dc_rd_data(dc_datain),
	.dc_rd_data_scr(dc_rd_data_scr),
	.dc_tag_addr(dcc_tagaddr[13:4]),
	.dc_tag_addr_scr(dc_tag_addr_scr),
	.dc_tag_rd_data(dc_tagin),
	.dc_tag_rd_data_scr(dc_tag_rd_data_scr),
	.dc_tag_rd_str(dcc_trstb),
	.dc_tag_wr_data(dcc_tagwrdata),
	.dc_tag_wr_data_scr(dc_tag_wr_data_scr),
	.dc_tag_wr_en(dcc_tagwren),
	.dc_tag_wr_en_scr(dc_tag_wr_en_scr),
	.dc_tag_wr_str(dcc_twstb),
	.dc_wr_data(dcc_data),
	.dc_wr_data_scr(dc_wr_data_scr),
	.dc_wr_mask(dcc_writemask),
	.dc_wr_mask_scr(dc_wr_mask_scr),
	.dc_ws_addr(dcc_wsaddr),
	.dc_ws_addr_scr(dc_ws_addr_scr),
	.dc_ws_rd_data(dc_wsin),
	.dc_ws_rd_data_scr(dc_ws_rd_data_scr),
	.dc_ws_rd_str(dcc_wsrstb),
	.dc_ws_wr_data(dcc_wswrdata),
	.dc_ws_wr_data_scr(dc_ws_wr_data_scr),
	.dc_ws_wr_mask(dcc_wswren),
	.dc_ws_wr_mask_scr(dc_ws_wr_mask_scr),
	.dc_ws_wr_str(dcc_wswstb),
	.dsp_data_addr(dsp_data_addr),
	.dsp_data_addr_scr(DSP_DataAddr),
	.dsp_data_rd_str(DSP_DataRdStr),
	.dsp_data_wr_str(DSP_DataWrStr),
	.dsp_rd_data(dsp_rd_data),
	.dsp_rd_data_scr(DSP_DataRdValue),
	.dsp_rd_par(dsp_rd_par),
	.dsp_rd_par_scr(DSP_RPar),
	.dsp_wr_data(dsp_wr_data),
	.dsp_wr_data_scr(DSP_DataWrValue),
	.dsp_wr_mask(dsp_wr_mask),
	.dsp_wr_mask_scr(DSP_DataWrMask),
	.dsp_wr_par(dsp_wr_par),
	.dsp_wr_par_scr(DSP_WPar),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.gscanmode(gscanmode),
	.ic_data_addr(icc_dataaddr[13:2]),
	.ic_data_addr_scr(ic_data_addr_scr),
	.ic_data_rd_str(icc_drstb),
	.ic_data_wr_str(icc_dwstb),
	.ic_rd_data(ic_datain),
	.ic_rd_data_scr(ic_rd_data_scr),
	.ic_rd_mask(icc_readmask),
	.ic_rd_mask_scr(ic_rd_mask_scr),
	.ic_tag_addr(icc_tagaddr[13:4]),
	.ic_tag_addr_scr(ic_tag_addr_scr),
	.ic_tag_rd_data(ic_tagin),
	.ic_tag_rd_data_scr(ic_tag_rd_data_scr),
	.ic_tag_rd_str(icc_trstb),
	.ic_tag_wr_data(icc_tagwrdata),
	.ic_tag_wr_data_scr(ic_tag_wr_data_scr),
	.ic_tag_wr_en(icc_tagwren),
	.ic_tag_wr_en_scr(ic_tag_wr_en_scr),
	.ic_tag_wr_str(icc_twstb),
	.ic_wr_data(icc_data),
	.ic_wr_data_scr(ic_wr_data_scr),
	.ic_wr_mask(icc_writemask),
	.ic_wr_mask_scr(ic_wr_mask_scr),
	.ic_ws_addr(icc_wsaddr),
	.ic_ws_addr_scr(ic_ws_addr_scr),
	.ic_ws_rd_data(ic_wsin),
	.ic_ws_rd_data_scr(ic_ws_rd_data_scr),
	.ic_ws_rd_str(icc_wsrstb),
	.ic_ws_wr_data(icc_wswrdata),
	.ic_ws_wr_data_scr(ic_ws_wr_data_scr),
	.ic_ws_wr_mask(icc_wswren),
	.ic_ws_wr_mask_scr(ic_ws_wr_mask_scr),
	.ic_ws_wr_str(icc_wswstb),
	.icc_spwr_active(icc_spwr_active),
	.isp_data_addr(isp_data_addr),
	.isp_data_addr_scr(ISP_Addr),
	.isp_data_rd_str(icc_drstb),
	.isp_data_wr_str(icc_dwstb),
	.isp_dataaddr_scr(isp_dataaddr_scr),
	.isp_rd_data(isp_rd_data),
	.isp_rd_data_scr(ISP_DataRdValue),
	.isp_rd_par(isp_rd_par),
	.isp_rd_par_scr(ISP_RPar),
	.isp_wr_data(isp_wr_data),
	.isp_wr_data_scr(ISP_DataTagValue),
	.isp_wr_par(isp_wr_par),
	.isp_wr_par_scr(ISP_WPar));

/*hookup*/
`M14K_ICACHE_MODULE icache(
	.bist_from(ic_bistfrom),
	.bist_to(bc_ibistto),
	.cache_present(ic_present),
	.data_addr(ic_data_addr_scr),
	.data_rd_mask(ic_rd_mask_scr),
	.data_rd_str(icc_drstb),
	.data_wr_str(icc_dwstb),
	.early_data_ce(icc_early_data_ce),
	.early_tag_ce(icc_early_tag_ce),
	.early_ws_ce(icc_early_ws_ce),
	.gclk(gclk),
	.greset(greset),
	.hci(ic_hci),
	.ica_parity_present(ica_parity_present),
	.num_sets(ic_nsets),
	.rd_data(ic_rd_data_scr),
	.set_size(ic_ssize),
	.tag_addr(ic_tag_addr_scr),
	.tag_rd_data(ic_tag_rd_data_scr),
	.tag_rd_str(icc_trstb),
	.tag_wr_data(ic_tag_wr_data_scr),
	.tag_wr_en(ic_tag_wr_en_scr),
	.tag_wr_str(icc_twstb),
	.wr_data(ic_wr_data_scr),
	.wr_mask(ic_wr_mask_scr),
	.ws_addr(ic_ws_addr_scr),
	.ws_rd_data(ic_ws_rd_data_scr),
	.ws_rd_str(icc_wsrstb),
	.ws_wr_data(ic_ws_wr_data_scr),
	.ws_wr_mask(ic_ws_wr_mask_scr),
	.ws_wr_str(icc_wswstb));

/*hookup*/
`M14K_DCACHE_MODULE dcache(
	.bist_from(dc_bistfrom),
	.bist_to(bc_dbistto),
	.cache_present(dc_present),
	.data_addr(dc_data_addr_scr),
	.data_rd_str(dcc_drstb),
	.data_wr_str(dcc_dwstb),
	.dca_parity_present(dca_parity_present),
	.early_data_ce(dcc_early_data_ce),
	.early_tag_ce(dcc_early_tag_ce),
	.early_ws_ce(dcc_early_ws_ce),
	.gclk(gclk),
	.greset(greset),
	.hci(dc_hci),
	.num_sets(dc_nsets),
	.rd_data(dc_rd_data_scr),
	.set_size(dc_ssize),
	.tag_addr(dc_tag_addr_scr),
	.tag_rd_data(dc_tag_rd_data_scr),
	.tag_rd_str(dcc_trstb),
	.tag_wr_data(dc_tag_wr_data_scr),
	.tag_wr_en(dc_tag_wr_en_scr),
	.tag_wr_str(dcc_twstb),
	.wr_data(dc_wr_data_scr),
	.wr_mask(dc_wr_mask_scr),
	.ws_addr(dc_ws_addr_scr),
	.ws_rd_data(dc_ws_rd_data_scr),
	.ws_rd_str(dcc_wsrstb),
	.ws_wr_data(dc_ws_wr_data_scr),
	.ws_wr_mask(dc_ws_wr_mask_scr),
	.ws_wr_str(dcc_wswstb));

/*hookup*/
m14k_bistctl bistctl(
	.BistIn(BistIn),
	.BistOut(BistOut),
	.bc_dbistto(bc_dbistto),
	.bc_ibistto(bc_ibistto),
	.bc_rfbistto(bc_rfbistto),
	.bc_tcbbistto(bc_tcbbistto),
	.dc_bistfrom(dc_bistfrom),
	.ic_bistfrom(ic_bistfrom),
	.rf_bistfrom(rf_bistfrom),
	.tcb_bistfrom(tcb_bistfrom));

// -----------------------------------------------------------------------------
//  FPU CLOCK GATER
// -----------------------------------------------------------------------------
  /*hookup*/
  `M14K_FPUCLK_MODULE fpuclock_gate(
	.fpu_gclk(fpu_gclk),
	.fpu_gclk_ratio(fpu_gclk_ratio),
	.gfclk(SI_ClkIn),
	.gscanenable(gscanenable),
	.mpc_disable_gclk_xx(mpc_disable_gclk_xx));

/*hookup*/
`M14K_COP1_MODULE fpu (
	.CP1_abusy_0(CP1_abusy_0),
	.CP1_as_0(CP1_as_0),
	.CP1_ccc_0(CP1_ccc_0),
	.CP1_cccs_0(CP1_cccs_0),
	.CP1_endian_0(CP1_endian_0),
	.CP1_exc_0(CP1_exc_0),
	.CP1_exc_1(CP1_exc_1),
	.CP1_exccode_0(CP1_exccode_0),
	.CP1_exccode_1(CP1_exccode_1),
	.CP1_excs_0(CP1_excs_0),
	.CP1_excs_1(CP1_excs_1),
	.CP1_fbusy_0(CP1_fbusy_0),
	.CP1_fdata_0(CP1_fdata_0),
	.CP1_fds_0(CP1_fds_0),
	.CP1_forder_0(CP1_forder_0),
	.CP1_fordlim_0(CP1_fordlim_0),
	.CP1_fppresent(CP1_fppresent),
	.CP1_fr32_0(CP1_fr32_0),
	.CP1_fs_0(CP1_fs_0),
	.CP1_gpr_0(CP1_gpr_0),
	.CP1_gprs_0(CP1_gprs_0),
	.CP1_idle(CP1_idle),
	.CP1_inst32_0(CP1_inst32_0),
	.CP1_ir_0(CP1_ir_0),
	.CP1_irenable_0(CP1_irenable_0),
	.CP1_kill_0(CP1_kill_0),
	.CP1_kill_1(CP1_kill_1),
	.CP1_kills_0(CP1_kills_0),
	.CP1_kills_1(CP1_kills_1),
	.CP1_mdmxpresent(CP1_mdmxpresent),
	.CP1_null_0(CP1_null_0),
	.CP1_nulls_0(CP1_nulls_0),
	.CP1_reset(CP1_reset),
	.CP1_tbusy_0(CP1_tbusy_0),
	.CP1_tdata_0(CP1_tdata_0),
	.CP1_tds_0(CP1_tds_0),
	.CP1_torder_0(CP1_torder_0),
	.CP1_tordlim_0(CP1_tordlim_0),
	.CP1_ts_0(CP1_ts_0),
	.CP1_ufrpresent(CP1_ufrpresent),
	.cpz_mnan(cpz_mnan),
	.cpz_prid16(cpz_prid16),
	.fpu_gclk(fpu_gclk),
	.fpu_gfclk(SI_ClkIn),
	.gfclk(SI_ClkIn),
	.gscanenable(gscanenable));

//
 `ifdef MIPS_SIMULATION 
//
 //VCS coverage off    
//

//
`ifdef M14K_USE_SMODULES
//
m14k_smodule_config smodule_config();
//
`endif
//

m14k_testbench #(M14K_INSTNUM) testbench();

 //VCS coverage on  
//
 `endif    
//
//

//
`ifdef MIPS_SIMULATION

  `ifdef MIPS_VMC_BUILD
    `ifdef VMC_DEBUG
      initial begin
        #3; // Wait for smodule_config initial block setting VmcDump reading from config_mem.
        if (smodule_config.VmcDump == 1'b1) begin
          $display ("%m: Enabled VMC dumpvars @ %0t",$time);
          $dumpvars;
        end
      end
    `endif // VMC_DEBUG
  `endif // MIPS_VMC_BUILD
`endif // MIPS_SIMULATION
//



endmodule	// m14k_cpu


