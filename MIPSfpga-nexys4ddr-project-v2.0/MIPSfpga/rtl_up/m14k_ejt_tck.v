// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_ejt_tck
//            EJTAG TAP TCK domain part
//
//	$Id: \$
//	mips_repository_id: m14k_ejt_tck.mv, v 1.17 
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
module m14k_ejt_tck(
	gscanenable,
	greset,
	cpz_enm,
	cpz_vz,
	gscanmode,
	mpc_umipspresent,
	ej_eagaddr,
	ej_eagbe,
	ej_eagdataout,
	ej_dcr_override,
	paacc_real,
	padone_real,
	padone_real_sync,
	pa_data_reg_done,
	EJ_TCK,
	EJ_TMS,
	EJ_TDI,
	EJ_TDO,
	EJ_TDOzstate,
	EJ_ECREjtagBrk,
	EJ_TRST_N,
	EJ_ManufID,
	EJ_PartNumber,
	EJ_Version,
	EJ_DisableProbeDebug,
	cpz_mmutype,
	EJ_DINTsup,
	tck_softreset,
	tck_capture,
	tck_shift,
	tck_update,
	tck_inst,
	pdt_tcbdata,
	pdt_present_tck,
	cpz_dm,
	EJ_DebugM,
	ejtagbrk,
	probtrap,
	ej_probtrap,
	proben,
	ej_proben,
	prrst,
	EJ_PrRst,
	ej_eagwrite,
	perrst,
	EJ_PerRst,
	cpz_halt,
	cpz_doze,
	ej_disableprobedebug,
	isaondebug_read,
	fdc_rxdata_tck,
	fdc_rxdata_rdy_tck,
	fdc_rxdata_ack_gclk,
	fdc_txdata_gclk,
	fdc_txdata_rdy_gclk,
	fdc_txdata_ack_tck,
	fdc_txtck_used_tck,
	fdc_rxint_tck,
	fdc_rxint_ack_gclk,
	fdc_present,
	new_pcs_gclk,
	new_das_gclk,
	new_pcs_ack_tck,
	new_das_ack_tck,
	pcsam_val,
	dasam_val,
	pc_noasid,
	pc_noguestid,
	pcse,
	dase,
	pcs_present,
	das_present,
	cdmm_ej_override);


// Signals between TAP and Core
input           gscanenable;     // Scan Enable
input 	        greset;          // reset
input		cpz_enm;	 // Endian mode for kernal and debug mode
input		cpz_vz;	 
input		gscanmode;       // ScanMode Control of gating logic and EJ_TCK inversion
input 	        mpc_umipspresent;  // UMIPS block is present

// Signals between TAP and EJTAG Area 
input	[19:2]	ej_eagaddr;	// Gated PA Address
input	[3:0]	ej_eagbe;	// Gated PA Byte enables
input	[31:0]	ej_eagdataout;	// Gated PA Data for store
input           ej_dcr_override;
input		paacc_real;	// Indication for real PA to probe
output		padone_real;	// Indication for real PA done
input		padone_real_sync;//padone_real sync. to gclk domain
output	[31:0]	pa_data_reg_done;// PA data from fetch/load, pre ej_padone gate

// Signals between TAP and core boundary
input		EJ_TCK;		// TCK
input		EJ_TMS;		// TMS
input		EJ_TDI;		// TDI
output		EJ_TDO;		// TDO
output		EJ_TDOzstate;	// TDO tri-state
output          EJ_ECREjtagBrk; // State of ECR.EjtagBrk
input		EJ_TRST_N;	// TRST*
input	[10:0]	EJ_ManufID;	// For ManufID in Device ID reg
input	[15:0]	EJ_PartNumber;	// For PartNumber in Device ID reg
input	[3:0]	EJ_Version;	// For Version in Device ID reg
input		EJ_DisableProbeDebug;
input		cpz_mmutype;	// For generation of ASIDsize in Impl. reg
input		EJ_DINTsup;	// For generation of DINTsup in Impl. reg

// Signals between PDTrace and EJTAG TAP controller
output 		tck_softreset;	// TAP Control State is Test-Logic-greset
output 		tck_capture;	// TAP Control State is Capture-DR
output 		tck_shift;	// TAP Control State is Shift-DR
output 		tck_update;	// TAP Control State is Update-DR
output [4:0] 	tck_inst;	// Current contents of TAP Instruction Register
input 		pdt_tcbdata;	// Data from TCB shift register(s)
input 		pdt_present_tck;// EJ_TCK synchronous version of PDI_TCBPresent
  
// Signal used for EJTAG Control register
input		cpz_dm;		// Debug mode indication
input 	        EJ_DebugM;         // Earlier in the pipe DebugMode indication
output		ejtagbrk;	// EjtagBrk from EJ_TCK domain
output		probtrap;	// ProbTrap from EJ_TCK domain
input		ej_probtrap;	// ProbTrap from gclk domain
output		proben;		// ProbEn from EJ_TCK domain
input		ej_proben;	// ProbEn from gclk domain
output		prrst;		// PrRst from EJ_TCK domain
input		EJ_PrRst;	// PrRst from gfclk domain
input		ej_eagwrite;	// Gated PA Write
output		perrst;		// PerRst from EJ_TCK domain
input		EJ_PerRst;	// PerRst from gfclk domain
input		cpz_halt;	// Halt indication
input		cpz_doze;	// Doze indication
output		ej_disableprobedebug;  // disable probe debug unregistered

output		isaondebug_read; 

// Async signals for Fast Debug channel
output [35:0]   fdc_rxdata_tck;       // Data value
output          fdc_rxdata_rdy_tck;   // Data is ready
input           fdc_rxdata_ack_gclk;  // Data has been accepted

input [35:0]    fdc_txdata_gclk;      // Data value
input           fdc_txdata_rdy_gclk;  // Data is ready
output          fdc_txdata_ack_tck;   // Data has been accepted

output          fdc_txtck_used_tck;   // TX TCK receive buffer occupied (for status)
output          fdc_rxint_tck;        // Interrupt requested
input           fdc_rxint_ack_gclk;   // Int request seen

input		fdc_present;

   input        new_pcs_gclk;    // gclk domain has a new pcsam_val
   input        new_das_gclk;
   output       new_pcs_ack_tck; // tck domain accepts the new pcsam_val
   output	new_das_ack_tck;
   input [55:0] pcsam_val;       // Sampled PC value from the core
   input [55:0] dasam_val;	 // Sampled Data Addr from the core
   input         pc_noasid;          // whether the PCsample chain includes ot omit the ASID field
   input         pc_noguestid;          // whether the PCsample chain includes ot omit the ASID field
   input	pcse;
   input 	dase;
   input	pcs_present;
   input	das_present;

//CDMM related
   input	cdmm_ej_override;

// BEGIN Wire declarations made by MVP
wire EJ_DINTsup_buf;
wire [97:0] /*[97:0]*/ pcs_shift_next;
wire [4:0] /*[4:0]*/ inst_reg_next;
wire tap_state_capturedrpcsamp;
wire [37:0] /*[37:0]*/ fdc_shift;
wire proben_read;
wire [3:0] /*[3:0]*/ tap_ctrl;
wire rocc;
wire [5:0] /*[5:0]*/ fdc_rbf_bit_in;
wire fdc_rxint_tck;
wire tap_state_capturedr;
wire fdc_rxint;
wire pracc_str;
wire reset_ff2;
wire [97:0] /*[97:0]*/ pcs_shift_val;
wire das_shift_bit_0;
wire [4:1] /*[4:1]*/ inst_reg41;
wire fdc_tx_rec_en;
wire [2:0] /*[2:0]*/ pcs_newbit_st_xx;
wire EJ_TDI_buf;
wire reset_unsync;
wire [31:0] /*[31:0]*/ pa_data_reg_shift;
wire prrst_str;
wire tap_state_shiftdr;
wire tap_state_shiftdrpcsamp;
wire tap_state_updatedrfdc;
wire halt;
wire [2:0] /*[2:0]*/ das_newbit_st_xx;
wire [31:0] /*[31:0]*/ shift_through_reg_next;
wire ejtagbrk_read;
wire [31:0] /*[31:0]*/ dev_id_reg;
wire [31:0] /*[31:0]*/ pa_addr_reg_load;
wire brkst;
wire prrst_pre;
wire fastdata_reg;
wire fdc_rxint_ack_1;
wire pcs_shift_bit_0;
wire fdc_rx_vld;
wire EJ_TDOzstate;
wire [15:0] /*[15:0]*/ EJ_PartNumber_buf;
wire ej_disableprobedebug;
wire reset_detect_b;
wire das_newbit;
wire rocc_str;
wire isaondebug_read;
wire [31:0] /*[31:0]*/ pa_data_reg_done;
wire [33:0] /*[33:0]*/ scan_flop_out;
wire ejtagbrk_pre;
wire proben_pre;
wire perrst_read;
wire EJ_TMS_buf;
wire ejtagboot;
wire tap_state_updatedr;
wire [1:0] /*[1:0]*/ psz_pre;
wire EJ_ECREjtagBrk;
wire fdc_tx_rec_en_reg;
wire rocc_pre;
wire fastdata_addr;
wire fdc_rxint_ack_tck;
wire pcs_newbit;
wire with_pcs;
wire sampled_rx_full;
wire fdc_tx_new;
wire tck_shift;
wire wait_mode_r1;
wire reset_tck_pre;
wire [5:0] /*[5:0]*/ fdc_rbf_bit;
wire pracc;
wire new_load_fdc;
wire [31:0] /*[31:0]*/ shift_through_reg;
wire tap_capturedr;
wire tck_capture;
wire bypass_reg;
wire ejtag_ctrl_upd;
wire [3:0] /*[3:0]*/ EJ_Version_buf;
wire fdc_rx_full;
wire with_das;
wire rbf_inject;
wire [10:0] /*[10:0]*/ EJ_ManufID_buf;
wire saved_spracc_for_fastdata;
wire EJ_TDO;
wire [31:0] /*[31:0]*/ pa_addr_reg;
wire [31:0] /*[31:0]*/ impl_reg;
wire tck_update;
wire tck_softreset;
wire proben_str;
wire [97:0] /*[97:0]*/ pcs_shift;
wire reset_unsynca;
wire prrst_read;
wire padone_real;
wire [31:0] /*[31:0]*/ ejtag_ctrl_reg;
wire probtrap_str;
wire [4:0] /*[4:0]*/ tck_inst;
wire doze;
wire reset_ff1;
wire [31:0] /*[31:0]*/ pa_addr_reg_shift;
wire tap_state_capturedrfdc;
wire EJ_TRST_N_control;
wire [1:0] /*[1:0]*/ pa_addr;
wire [31:0] /*[31:0]*/ pa_data_reg;
wire [4:0] /*[4:0]*/ inst_reg;
wire ejtagbrk_str;
wire [   0:   0] /*[0]*/ inst_reg0;
wire [37:0] /*[37:0]*/ fdc_shift_in;
wire ejtag_fastdata_upd;
wire probtrap_read;
wire ejt_disableprobedebug;
wire perrst_pre;
wire reset_tck;
wire [2:0] /*[2:0]*/ fdc_tx_newbit_st_xx;
wire wait_mode;
wire tdo_next;
wire probtrap_pre;
wire perrst_str;
// END Wire declarations made by MVP


   // MVP does not allow parameters
   //
   parameter OLD          = 0,
             NEW          = 1,
             SHIFTING_NEW = 2;
   //verilint 175 off   Unused parameter
   parameter // /* VCS enum fb_st_xx_FSM */
             CM_OLD          = 1,
             CM_NEW          = 2,
             CM_SHIFTING_NEW = 4;
   //verilint 175 on
   //

// Wire declarations 
wire		prnw;		// Processor Access read/write
wire	[1:0]	psz;		// Processor Access size
wire	[31:0]	pa_data_reg_next;// Processor Access data reg next value
wire	[31:0]	pa_addr_reg_next;//Processor Access next address
wire 	        pracc_tmp;
wire 	        pracc_pre;
	
wire 	EJ_TCK, EJ_TCK_n;

wire  [55:0] pcs;
wire  [55:0] das;	

// EJ_TCK clock is used to control both posedge and negedge flops, hence the
//  suppression of the verilint warning: W391 Wrong clock polarity
//verilint 391 off  // Wrong clock polarity

// Create an inverted clock for Normal mode, but Non-inverted for gscanmode
m14k_clockxnorgate tck_clockinv (.gclk_inv(EJ_TCK_n), .gclk(EJ_TCK), .not_inv(gscanmode));
   
	

// TAP Controller

// Define value for TAP Controller states
`define M14K_EJT_Exit2DR		4'h0
`define M14K_EJT_Exit1DR		4'h1
`define M14K_EJT_ShiftDR		4'h2
`define M14K_EJT_PauseDR		4'h3
`define M14K_EJT_SelectIRScan	4'h4
`define M14K_EJT_UpdateDR		4'h5
`define	M14K_EJT_CaptureDR		4'h6
`define M14K_EJT_SelectDRScan	4'h7
`define M14K_EJT_Exit2IR		4'h8
`define M14K_EJT_Exit1IR		4'h9
`define M14K_EJT_ShiftIR		4'hA
`define M14K_EJT_PauseIR		4'hB
`define M14K_EJT_RunTestIdle		4'hC
`define M14K_EJT_UpdateIR		4'hD
`define	M14K_EJT_CaptureIR		4'hE
// Test-Logic-greset must be 4'hF = 4'b1111 due to use of set FF for EJ_TRST_N
`define	M14K_EJT_TestLogicReset	4'hF

// Determine next state of TAP when just update of state
	//
   function [3:0] tap_ctrl_next;
      input [3:0] tap_ctrl;
      input EJ_TMS;
       `ifdef MIPS_SIMULATION 
 //VCS coverage off 
      // 
      // pessimistic X-detection
      if(^{tap_ctrl,EJ_TMS} === 1'bx) begin
	 tap_ctrl_next = 4'bxxxx;
      end else 
        //VCS coverage on  
 `endif 
      // 
      begin
	 case(tap_ctrl)
	   `M14K_EJT_Exit2DR 	: tap_ctrl_next = (EJ_TMS ? `M14K_EJT_UpdateDR : `M14K_EJT_ShiftDR);
	   `M14K_EJT_Exit1DR 	: tap_ctrl_next = (EJ_TMS ? `M14K_EJT_UpdateDR : `M14K_EJT_PauseDR);
	   `M14K_EJT_ShiftDR 	: tap_ctrl_next = (EJ_TMS ? `M14K_EJT_Exit1DR : `M14K_EJT_ShiftDR);
	   `M14K_EJT_PauseDR 	: tap_ctrl_next = (EJ_TMS ? `M14K_EJT_Exit2DR : `M14K_EJT_PauseDR);
	   `M14K_EJT_SelectIRScan 	: tap_ctrl_next = (EJ_TMS ? `M14K_EJT_TestLogicReset : `M14K_EJT_CaptureIR);
	   `M14K_EJT_UpdateDR 	: tap_ctrl_next = (EJ_TMS ? `M14K_EJT_SelectDRScan : `M14K_EJT_RunTestIdle);
	   `M14K_EJT_CaptureDR 	: tap_ctrl_next = (EJ_TMS ? `M14K_EJT_Exit1DR : `M14K_EJT_ShiftDR);
	   `M14K_EJT_SelectDRScan 	: tap_ctrl_next = (EJ_TMS ? `M14K_EJT_SelectIRScan : `M14K_EJT_CaptureDR);
	   `M14K_EJT_Exit2IR 	: tap_ctrl_next = (EJ_TMS ? `M14K_EJT_UpdateIR : `M14K_EJT_ShiftIR);
	   `M14K_EJT_Exit1IR 	: tap_ctrl_next = (EJ_TMS ? `M14K_EJT_UpdateIR : `M14K_EJT_PauseIR);
	   `M14K_EJT_ShiftIR 	: tap_ctrl_next = (EJ_TMS ? `M14K_EJT_Exit1IR : `M14K_EJT_ShiftIR);
	   `M14K_EJT_PauseIR 	: tap_ctrl_next = (EJ_TMS ? `M14K_EJT_Exit2IR : `M14K_EJT_PauseIR);
	   `M14K_EJT_RunTestIdle 	: tap_ctrl_next = (EJ_TMS ? `M14K_EJT_SelectDRScan : `M14K_EJT_RunTestIdle);
	   `M14K_EJT_UpdateIR 	: tap_ctrl_next = (EJ_TMS ? `M14K_EJT_SelectDRScan : `M14K_EJT_RunTestIdle);
	   `M14K_EJT_CaptureIR 	: tap_ctrl_next = (EJ_TMS ? `M14K_EJT_Exit1IR : `M14K_EJT_ShiftIR);
	   default 		: tap_ctrl_next = (EJ_TMS ? `M14K_EJT_TestLogicReset : `M14K_EJT_RunTestIdle);
	 endcase
      end
   endfunction // tap_ctrl_next
	//

// TAP Controller state set to Test-Logic-Reset (4'hF) at EJ_TRST_N asserted
// Otherwise state updated on rising edge of EJ_TCK
assign EJ_TRST_N_control = EJ_TRST_N || gscanmode;
mvp_register_s #(4) _tap_ctrl_3_0_(tap_ctrl[3:0],EJ_TRST_N_control, EJ_TCK, tap_ctrl_next(tap_ctrl, EJ_TMS));


// Indicate that specific states are active
assign tap_capturedr = (`M14K_EJT_CaptureDR == tap_ctrl[3:0]);



// Instruction register

// Define value for instructions in 5 bit instruction register
// IDCODE must be 5'h01 = 5'b00001 due to setting of FFs
`define	M14K_EJT_IDCODE		5'h01
`define	M14K_EJT_IMPCODE		5'h03
`define	M14K_EJT_ADDRESS		5'h08
`define	M14K_EJT_DATA		5'h09
`define	M14K_EJT_CONTROL		5'h0A
`define	M14K_EJT_ALL			5'h0B
`define	M14K_EJT_EJTAGBOOT		5'h0C
`define	M14K_EJT_NORMALBOOT		5'h0D
`define M14K_EJT_FASTDATA		5'h0E
`define M14K_EJT_TCBTRACECONTROL	5'h10
`define M14K_EJT_TCBCONTROL		5'h11
`define M14K_EJT_TCBDATA		5'h12
`define M14K_EJT_PCSAMPLE        5'h14
`define M14K_EJT_FDC 		5'h17
`define	M14K_EJT_BYPASS		5'h1F




// scan flops for controllability
mvp_cregister_wide #(34) _scan_flop_out_33_0_(scan_flop_out[33:0],gscanenable, gscanmode, EJ_TCK, 34'b0);
mvp_mux2 #(34) _EJ_TDI_buf_EJ_TMS_buf_EJ_ManufID_buf_10_0_EJ_PartNumber_buf_15_0_EJ_Version_buf_3_0_EJ_DINTsup_buf({EJ_TDI_buf,
 EJ_TMS_buf,
 EJ_ManufID_buf[10:0],
 EJ_PartNumber_buf[15:0],
 EJ_Version_buf[3:0],
 EJ_DINTsup_buf}, gscanmode, {EJ_TDI,
                                EJ_TMS,
                                EJ_ManufID[10:0],
                                EJ_PartNumber[15:0],
                                EJ_Version[3:0],
                                    EJ_DINTsup},  
                        scan_flop_out[33:0]);
mvp_register #(1) _ejt_disableprobedebug(ejt_disableprobedebug,EJ_TCK, EJ_DisableProbeDebug);
assign ej_disableprobedebug = EJ_DisableProbeDebug;

    
// Instruction register set to IDCODE (5'h01) when EJ_TRST_N asserted.
// Otherwise instruction register set to IDCODE when in Test-Logic-Reset state,
// and register loaded with 0x01 when in Capture-IR state and rising edge 
// of EJ_TCK.
mvp_cregister_c #(4) _inst_reg41_4_1_(inst_reg41[4:1],(tap_ctrl[3:0] == `M14K_EJT_TestLogicReset) |
                              (tap_ctrl[3:0] == `M14K_EJT_CaptureIR) |
                              (tap_ctrl[3:0] == `M14K_EJT_ShiftIR), 
                             EJ_TRST_N_control, EJ_TCK, inst_reg_next[4:1]);
mvp_cregister_s #(1) _inst_reg0_0_0_(inst_reg0[   0],(tap_ctrl[3:0] == `M14K_EJT_TestLogicReset) | 
                              (tap_ctrl[3:0] == `M14K_EJT_CaptureIR) |
                              (tap_ctrl[3:0] == `M14K_EJT_ShiftIR), 
                              EJ_TRST_N_control, EJ_TCK, inst_reg_next[0]);
assign inst_reg[4:0] = {inst_reg41[4:1], inst_reg0[0]};

// Instruction register set to IDCODE when in Test-Logic-Reset state, and 
// register loaded with 0x01 when in Capture-IR state and rising edge of 
// EJ_TCK. Shifting from MSB to LSB when in Shift-IR state at rising edge of 
// EJ_TCK.
assign inst_reg_next[4:0] = 
	(`M14K_EJT_TestLogicReset == tap_ctrl[3:0]) ? `M14K_EJT_IDCODE :
	(`M14K_EJT_CaptureIR == tap_ctrl[3:0]) ? 5'h01 :
	{EJ_TDI_buf, inst_reg[4:1]};

// This FF indicates if the EJTAGBOOT instruction is active. 
// It is async cleared when EJ_TRST_N is asserted.
// It is also cleared on rising TCK when *entering* Test-Logic-Reset state. 
// It is updated when in Update-IR state as follows:
// - Set if the EJTAGBOOT instruction is in the Instruction register.
// - Cleared if the NORMALBOOT instruction is in the Instruction register.
// - Unchanged for other instructions in the Instructions register

mvp_cregister_c #(1) _ejtagboot(ejtagboot,
	((tap_ctrl[3:0] == `M14K_EJT_SelectIRScan) & (EJ_TMS_buf == 1'b1)) | (tap_ctrl[3:0] == `M14K_EJT_UpdateIR),
		EJ_TRST_N_control, 
		EJ_TCK,
	(~ejt_disableprobedebug ) &
	(tap_ctrl[3:0] == `M14K_EJT_UpdateIR) & 
		( (`M14K_EJT_EJTAGBOOT == inst_reg[4:0]) | (ejtagboot & ~(`M14K_EJT_NORMALBOOT == inst_reg[4:0])))
	);



// Bypass register

// Bypass register, with Capture-DR update to 1'b0, and shift in of EJ_TDI_buf
mvp_cregister #(1) _bypass_reg(bypass_reg,(`M14K_EJT_CaptureDR == tap_ctrl[3:0]) | 
                       (`M14K_EJT_ShiftDR == tap_ctrl[3:0]), EJ_TCK, 
                       (`M14K_EJT_CaptureDR == tap_ctrl[3:0]) ? 1'b0 : EJ_TDI_buf);



// FastData register 
mvp_cregister #(1) _fastdata_reg(fastdata_reg,(`M14K_EJT_CaptureDR == tap_ctrl[3:0]) | 
			 (`M14K_EJT_ShiftDR == tap_ctrl[3:0]),
			 EJ_TCK,
			 (`M14K_EJT_CaptureDR == tap_ctrl[3:0]) ? 
			 (pracc && fastdata_addr) : shift_through_reg[0]);			 

// Shift Through Register (STR)

// STR loaded in Capture-DR state and shifted in Shift-DR state
mvp_cregister_wide #(32) _shift_through_reg_31_0_(shift_through_reg[31:0],gscanenable, (`M14K_EJT_CaptureDR == tap_ctrl[3:0]) | 
                                    (`M14K_EJT_ShiftDR == tap_ctrl[3:0]), EJ_TCK,
                                    shift_through_reg_next[31:0]);

// Determine next value of the STR. Only required to cover Capture-DR and 
// other case since register is only updated at this point.
assign shift_through_reg_next[31:0] = 
	((`M14K_EJT_CaptureDR == tap_ctrl[3:0]) ? 
	   ((`M14K_EJT_IDCODE == inst_reg[4:0])  ? dev_id_reg[31:0] :
	    (`M14K_EJT_IMPCODE == inst_reg[4:0]) ? impl_reg[31:0] :
	    ((`M14K_EJT_FASTDATA == inst_reg[4:0]) && pracc) ? pa_data_reg_next[31:0] :
	    ejtag_ctrl_reg[31:0]) :
	 {((inst_reg[4:0] == `M14K_EJT_ALL) ? pa_data_reg[0] : EJ_TDI_buf), 
          shift_through_reg[31:1]});


// Implementation register

// The Implementation register is simply defined by a collection of read-only 
// bits.
assign impl_reg[31:0] = {
	`M14K_EJTAG_VER,			// EJTAGver[2:0] bits
	4'b0,				// Reserved/unused bits
	EJ_DINTsup_buf,			// DINTsup bit
	{1'b0, ~cpz_mmutype, 1'b0},	// ASIDsize[2:0] bits
	4'b0,				// Reserved/unused bits
	1'b0,				// MIPS16 not implemented in M14K
        1'b0,                           // Reserved
	1'b1,				// NoDMA bit indication
	13'b0,				// Reserved/unused bits
	1'b0};				// MIPS32/64 bit



// Device ID register

// The Device ID register is a simply defined by a collection of read-only 
// bits.
assign dev_id_reg[31:0] = {
	EJ_Version_buf[3:0],		// Version[3:0] bits
	EJ_PartNumber_buf[15:0],	// PartNumber[15:0] bits
	EJ_ManufID_buf[10:0],		// ManufID[10:0] bits
	1'b1};				// Fixed bit on 1'b1



// EJTAG Control register EJ_TCK domain parts

// Define the read value of the ECR
assign ejtag_ctrl_reg[31:0] = {
	rocc,				// Rocc bit read value
	psz[1:0],			// Psz[1:0] field
	6'b0,				// Reserved/unused bits
	doze,				// Doze bit
	halt,				// Halt bit
	perrst_read,			// PerRst bit read value
	prnw,				// PRnW bit
	pracc,				// PrAcc bit read value
	1'b0,				// Reserved/unused bits
	prrst_read,			// PrRst bit read value
	proben_read,			// ProbEn bit read value
	probtrap_read,			// ProbTrap bit read value
	isaondebug_read,		// isa on debug exception. in a system where M32 is present, must be driven 0
	ejtagbrk_read,			// EjtagBrk bit read value
	8'b0,				// Reserved/unused bits
	brkst,				// BrkSt bit
	3'b0};				// Reserved/unused bits

	assign isaondebug_read = mpc_umipspresent; //in a system where M32 is present, must be driven 0

// Indication for update of the EJTAG Control register
// Both in Update-DR state for CONTROL and ALL instructions and on reset
assign ejtag_ctrl_upd = ((`M14K_EJT_UpdateDR == tap_ctrl[3:0]) & 
		  ((`M14K_EJT_CONTROL == inst_reg[4:0]) | 
                     (`M14K_EJT_ALL == inst_reg[4:0])) & 
		  (~(rocc & rocc_str)))
	         | reset_tck;

// Condition under which pa_data_reg_done should be updated with value from
// shift_reg is when in Update-DR state and instruction is FASTDATA and 
// saved_pracc is true and rocc is false.
// Disable if reset_tck is asserted.
assign ejtag_fastdata_upd = ((`M14K_EJT_UpdateDR == tap_ctrl[3:0]) & 
		      (`M14K_EJT_FASTDATA == inst_reg[4:0]) & 
		      (saved_spracc_for_fastdata == 1'b1) &
		      (reset_tck == 1'b0) &
		      (fastdata_reg == 1'b0));

// BrkSt bit, sync to EJ_TCK
mvp_register #(1) _brkst(brkst,EJ_TCK, cpz_dm);

// EjtagBrk bit
// Set EjtagBrk reset value at hard reset to ejtagboot FF value.
assign ejtagbrk_str = shift_through_reg[12];	// Update value for EjtagBrk
mvp_cregister_c #(1) _ejtagbrk_pre(ejtagbrk_pre,ejtag_ctrl_upd, (~EJ_DebugM | gscanmode), EJ_TCK, 
                           (reset_tck ? ejtagboot : 
                                       (ejtagbrk_str | ejtagbrk_pre)) &
			  (~ejt_disableprobedebug | ej_dcr_override )  
			  );
                                             // reset value even if no EJ_TCK
m14k_ejt_mux2 ejtagbrk_i(.y(ejtagbrk), .s(reset_unsync), 
                      .b(ejtagboot), .a(ejtagbrk_pre));
mvp_register #(1) _ejtagbrk_read(ejtagbrk_read,EJ_TCK, ejtagbrk); // Sync to EJ_TCK domain

// Core output with value of ejtagbrk bit.  Allows probe wakeup 
// from a deep sleep state where core clock is stopped
mvp_register_c #(1) _EJ_ECREjtagBrk(EJ_ECREjtagBrk,EJ_TRST_N_control, EJ_TCK_n, 
			 ejtagbrk);
   
// Rocc bit, capture greset through reset_unsync
assign rocc_str = shift_through_reg[31];	// Update value for Rocc
mvp_cregister_s #(1) _rocc_pre(rocc_pre,ejtag_ctrl_upd, (~reset_unsync | gscanmode), 
                       EJ_TCK, (rocc_str & rocc) | reset_tck);
mvp_register #(1) _rocc(rocc,EJ_TCK, rocc_pre); // Sync to EJ_TCK

// ProbTrap bit, generate and sync back to EJ_TCK
// Set ProbTrap reset value at hard reset to ejtagboot FF value.
assign probtrap_str = shift_through_reg[14];	// Update value for ProbTrap
mvp_cregister #(1) _probtrap_pre(probtrap_pre,ejtag_ctrl_upd, EJ_TCK, 
               (reset_tck ? ejtagboot : probtrap_str) & ~ejt_disableprobedebug); // Write and reset update
                                         // reset value even if no EJ_TCK clock
m14k_ejt_mux2 probtrap_i(.y(probtrap), .s(reset_unsync), 
                      .b(ejtagboot), .a(probtrap_pre));
mvp_register #(1) _probtrap_read(probtrap_read,EJ_TCK, ej_probtrap); // Sync to EJ_TCK

// ProbEn bit, generate and sync back to EJ_TCK
// Set ProbEn reset value at hard reset to ejtagboot FF value.
assign proben_str = shift_through_reg[15];	// Update value for ProbEn
mvp_cregister #(1) _proben_pre(proben_pre,ejtag_ctrl_upd, EJ_TCK, 
             (reset_tck ? ejtagboot : proben_str) & ~ejt_disableprobedebug); // Write and reset update
                                        // reset value even if no EJ_TCK clock
m14k_ejt_mux2 proben_i(.y(proben), .s(reset_unsync), 
                    .b(ejtagboot), .a(proben_pre));
mvp_register #(1) _proben_read(proben_read,EJ_TCK, ej_proben); // Sync to EJ_TCK

// PrRst bit, generate and sync back to EJ_TCK
assign prrst_str = shift_through_reg[16];	// Update value for PrRst
mvp_cregister #(1) _prrst_pre(prrst_pre,ejtag_ctrl_upd, EJ_TCK, prrst_str & ~reset_tck); // Write
// Ensure real AND function: prrst = prrst_pre & ~reset_unsync; 
                                 // Ensure reset value even if no EJ_TCK clock
m14k_ejt_and2 prrst_i(.y(prrst), .a(prrst_pre), .b(~reset_unsync));

mvp_register #(1) _prrst_read(prrst_read,EJ_TCK, EJ_PrRst); // Sync to EJ_TCK

// PrAcc indication
assign pracc_str = (`M14K_EJT_FASTDATA == inst_reg[4:0]) ? 
			1'b0 : shift_through_reg[18];	// Update value for PrAcc
mvp_cregister_c #(1) _padone_real(padone_real,( ejtag_ctrl_upd | ejtag_fastdata_upd), 
                          (~(reset_unsync | ~paacc_real) | gscanmode), EJ_TCK, 
                          (padone_real | ~pracc_str) & ~reset_tck);
// The above expression for pracc_pre is made in a spikefree way below
m14k_ejt_and2 pracc_tmp_i(.y(pracc_tmp), .a(paacc_real), .b(~padone_real));
m14k_ejt_and2 pracc_pre_i(.y(pracc_pre), .a(pracc_tmp), .b(~padone_real_sync));

mvp_register #(1) _pracc(pracc,EJ_TCK, pracc_pre); // Sync to EJ_TCK

// fastdata_addr: Indicated, that the processor access match the fastdata address
// range. 12 MSB are implicit h'FF2. 
assign fastdata_addr = (pa_addr_reg_next[19:4] == 16'h0000);

// Save the value of pracc and fastdata_addr for later use in UpdateDR stage
// In UpdateDR, data reg should be updated only if spracc was 1 when
// FASTDATA started.
// A reset durring FASTDATA scan, will clear this bit.
mvp_cregister #(1) _saved_spracc_for_fastdata(saved_spracc_for_fastdata,((`M14K_EJT_FASTDATA == inst_reg[4:0]) & 
				     (`M14K_EJT_CaptureDR == tap_ctrl[3:0])) |
				      reset_tck, 
				     EJ_TCK, pracc && fastdata_addr && !reset_tck);	

// PRnW bit, masked ej_eagwrite with PrAcc bit
m14k_ejt_and2 prnw_i(.y(prnw), .a(pracc), .b(ej_eagwrite));

// PerRst bit, generate and sync back to EJ_TCK
assign perrst_str = shift_through_reg[20];	// Update value for PerRst
mvp_cregister #(1) _perrst_pre(perrst_pre,ejtag_ctrl_upd, EJ_TCK, perrst_str & ~reset_tck); 
                                                                      // Write
// Ensure use of real AND: perrst = perrst_pre & ~reset_unsync; 
                                 // Ensure reset value even if no EJ_TCK clock
m14k_ejt_and2 perrst_i(.y(perrst), .a(perrst_pre), .b(~reset_unsync));
mvp_register #(1) _perrst_read(perrst_read,EJ_TCK, EJ_PerRst); // Sync to EJ_TCK

// Halt bit, sync to EJ_TCK
mvp_register #(1) _halt(halt,EJ_TCK, cpz_halt);

// Doze bit, sync to EJ_TCK
mvp_register #(1) _doze(doze,EJ_TCK, cpz_doze);

// Psz[1:0] field
assign psz_pre[1:0] = 	(ej_eagbe[3:0] == 4'b0001) ? 2'b00 :
		(ej_eagbe[3:0] == 4'b0010) ? 2'b00 :
		(ej_eagbe[3:0] == 4'b0100) ? 2'b00 :
		(ej_eagbe[3:0] == 4'b1000) ? 2'b00 :
		(ej_eagbe[3:0] == 4'b0011) ? 2'b01 :
		(ej_eagbe[3:0] == 4'b1100) ? 2'b01 :
		(ej_eagbe[3:0] == 4'b0111) ? 2'b11 :
		(ej_eagbe[3:0] == 4'b1110) ? 2'b11 :
		                             2'b10;
m14k_ejt_and2 psz_0i(.y(psz[0]), .a(pracc), .b(psz_pre[0]));
m14k_ejt_and2 psz_1i(.y(psz[1]), .a(pracc), .b(psz_pre[1]));


// PC Sample Register
   wire        load_pcs, new_pcs_ack_tck, pcs_data_pnd, pcs_wakeup;
   wire        load_das, new_das_ack_tck, das_data_pnd, das_wakeup;
   // The newbit is set as long as we are not in the OLD state.
   assign pcs_newbit = !pcs_newbit_st_xx[OLD];
   assign das_newbit = !das_newbit_st_xx[OLD];

   // double-flop to synchronize wait_mode
   mvp_register #(1) _wait_mode_r1(wait_mode_r1,EJ_TCK, cpz_halt);
   mvp_register #(1) _wait_mode(wait_mode,EJ_TCK, wait_mode_r1);

   // TAP controller states
   assign tap_state_updatedr = (tap_ctrl[3:0] == `M14K_EJT_UpdateDR);
   assign tap_state_capturedr = (tap_ctrl[3:0] == `M14K_EJT_CaptureDR);
   assign tap_state_shiftdr = (tap_ctrl[3:0] == `M14K_EJT_ShiftDR);

   // Asserted when TAP is in CaptureDR state and capturing pcsample reg.
   assign tap_state_capturedrpcsamp = tap_state_capturedr && (inst_reg[4:0] == `M14K_EJT_PCSAMPLE);
   assign tap_state_shiftdrpcsamp = tap_state_shiftdr && (inst_reg[4:0] == `M14K_EJT_PCSAMPLE);

   m14k_ejt_async_rec #(56,0) pcsam_async_rec (
                                              .gscanenable(gscanenable),
                                              .gclk(EJ_TCK),
                                              .gfclk(EJ_TCK),
                                              .reset(reset_tck),
                                              .reset_unsync(reset_unsync),
                                              .sync_data_out(pcs[55:0]),
                                              .sync_data_vld(load_pcs),
                                              .sync_data_pnd(pcs_data_pnd),
                                              .sync_data_enable(1'b1),
                                              .sync_wakeup(pcs_wakeup),
                                              .async_data_in(pcsam_val),
                                              .async_data_rdy(new_pcs_gclk),
                                              .async_data_ack(new_pcs_ack_tck)
                                              );

   m14k_ejt_async_rec #(56,0) dasam_async_rec (
                                              .gscanenable(gscanenable),
                                              .gclk(EJ_TCK),
                                              .gfclk(EJ_TCK),
                                              .reset(reset_tck),
                                              .reset_unsync(reset_unsync),
                                              .sync_data_out(das[55:0]),
                                              .sync_data_vld(load_das),
                                              .sync_data_pnd(das_data_pnd),
                                              .sync_data_enable(1'b1),
                                              .sync_wakeup(das_wakeup),
                                              .async_data_in(dasam_val),
                                              .async_data_rdy(new_das_gclk),
                                              .async_data_ack(new_das_ack_tck)
                                              );

assign with_pcs = pcse && pcs_present;
assign with_das = dase && das_present;
mvp_mux1hot_13 #(98) _pcs_shift_val_97_0_(pcs_shift_val[97:0],
			~with_pcs & ~with_das, 98'b0,
			~with_pcs & with_das &  pc_noasid &  pc_noguestid, {65'b0, das[31:0], das_newbit},
			~with_pcs & with_das &  pc_noasid & ~pc_noguestid, {57'b0, {das[55:48],das[31:0]}, das_newbit},
			~with_pcs & with_das & ~pc_noasid &  pc_noguestid, {57'b0, das[39:0], das_newbit},
			~with_pcs & with_das & ~pc_noasid & ~pc_noguestid, {49'b0, {das[55:48],das[39:0]}, das_newbit},

			 with_pcs & ~with_das &  pc_noasid &  pc_noguestid, {65'b0, pcs[31:0],pcs_newbit},
			 with_pcs &  with_das &  pc_noasid & ~pc_noguestid, {57'b0, {pcs[55:48],pcs[31:0]}, pcs_newbit},
			 with_pcs & ~with_das & ~pc_noasid &  pc_noguestid, {57'b0, pcs[39:0],pcs_newbit},
			 with_pcs & ~with_das & ~pc_noasid & ~pc_noguestid, {49'b0, {pcs[55:48],pcs[39:0]},pcs_newbit},

			 with_pcs & with_das &  pc_noasid &  pc_noguestid, {32'b0,  das[31:0], das_newbit, pcs[31:0],pcs_newbit},
			 with_pcs & with_das &  pc_noasid & ~pc_noguestid, {16'b0, {das[55:48],das[31:0]}, das_newbit, {pcs[55:48],pcs[31:0]}, pcs_newbit},
			 with_pcs & with_das & ~pc_noasid &  pc_noguestid, {16'b0,  das[39:0], das_newbit, pcs[39:0],pcs_newbit},
			 with_pcs & with_das & ~pc_noasid & ~pc_noguestid, { {das[55:48],das[39:0]}, das_newbit, {pcs[55:48],pcs[39:0]},pcs_newbit});

mvp_mux1hot_9 #(98) _pcs_shift_next_97_0_(pcs_shift_next[97:0],
                        ~with_pcs & ~with_das, 98'b0,

                        (with_pcs ^ with_das) &  pc_noasid &  pc_noguestid, {65'b0, EJ_TDI_buf, pcs_shift[32:1]},
                        (with_pcs ^ with_das) &  pc_noasid & ~pc_noguestid, {57'b0, EJ_TDI_buf, pcs_shift[40:1]},
                        (with_pcs ^ with_das) & ~pc_noasid &  pc_noguestid, {57'b0, EJ_TDI_buf, pcs_shift[40:1]},
                        (with_pcs ^ with_das) & ~pc_noasid & ~pc_noguestid, {49'b0, EJ_TDI_buf, pcs_shift[48:1]},

                         with_pcs & with_das &  pc_noasid &  pc_noguestid, {32'b0, EJ_TDI_buf, pcs_shift[65:1]},
                         with_pcs & with_das & ~pc_noasid &  pc_noguestid, {16'b0, EJ_TDI_buf, pcs_shift[81:1]},
                         with_pcs & with_das &  pc_noasid & ~pc_noguestid, {16'b0, EJ_TDI_buf, pcs_shift[81:1]},
                         with_pcs & with_das & ~pc_noasid & ~pc_noguestid, {EJ_TDI_buf, pcs_shift[97:1]}           );

mvp_cregister_wide #(98) _pcs_shift_97_0_(pcs_shift[97:0],gscanenable, tap_state_capturedrpcsamp || tap_state_shiftdrpcsamp, EJ_TCK,
					tap_state_shiftdrpcsamp ? pcs_shift_next[97:0] : pcs_shift_val[97:0] );
assign pcs_shift_bit_0 = pcse & pcs_shift[0];
assign das_shift_bit_0 = (~pcse & dase & pcs_shift[0]) | (pcse & dase &  pc_noasid &  pc_noguestid & pcs_shift[33]) 
                                                | (pcse & dase & ~pc_noasid &  pc_noguestid & pcs_shift[41]) 
                                                | (pcse & dase & ~pc_noasid & ~pc_noguestid & pcs_shift[48]);

   // Newbit states - used for PCSample and FDC
   //
   // State descriptions
   //
   // OLD -- The bit is 0 as cleared by the probe
   // NEW -- the bit is 1 as set by the CPU
   // SHIFTING_NEW -- The probe is currently shifting the pcsample register.
   //    The value when the shift started was 1.
   // NOTE: We dont need a SHIFTING_OLD state, because we dont care when we are shifting
   //   an old value - the probe cant do anything to change it to a new value, so we just stay
   //   in the OLD state.
   //
   function [2:0] newbit_nst;
      input [2:0] newbit_st_xx;
      input wait_mode;
      input load_value;
      input tap_state_updatedr;
      input tap_state_capture_this_dr;
      input shift_bit0;
      begin
         newbit_nst = 3'b000; // First reset next state.
         // The below directives are necessary because Verilint doesnt like
         // this state machine coding style
         //verilint 226 off    Case-select expression is constant
         //verilint 225 off    Case expression is not constant
         //verilint 526 off    Nested ifs
         case (1'b1)  // synopsys parallel_case
                      // ambit synthesis case = parallel

           // CMX fdc_newbit_st_xx TRANSITIONS_NEVER CM_FDC_OLD->CM_FDC_SHIFTING_NEW
           // CMX pcs_newbit_st_xx TRANSITIONS_NEVER CM_PCS_OLD->CM_PCS_SHIFTING_NEW
           newbit_st_xx[OLD] : begin
              // Set the newbit if we go into wait mode or we get a new sample
              if(load_value || wait_mode)
                 newbit_nst[NEW] = 1'b1;
              else
                 newbit_nst[OLD] = 1'b1;
           end

           // CMX fdc_newbit_st_xx TRANSITIONS_NEVER CM_FDC_NEW->CM_FDC_OLD
           // CMX pcs_newbit_st_xx TRANSITIONS_NEVER CM_PCS_NEW->CM_PCS_OLD
           newbit_st_xx[NEW] : begin
              // If we get load_value in same cycle as capturedr, we stay in new since the capture will get the old value
              if(!load_value && !wait_mode && tap_state_capture_this_dr)
                 newbit_nst[SHIFTING_NEW] = 1'b1;
              else
                 newbit_nst[NEW] = 1'b1;
           end

           // Never in SHIFTING_NEW unless this instruction was captured so
           // we do not need to qualify updatedr with the instruction register
           newbit_st_xx[SHIFTING_NEW] : begin
              if(load_value || wait_mode)
                 newbit_nst[NEW] = 1'b1;
              else if(tap_state_updatedr) begin
                 if(shift_bit0)
                   // Only look at shift_bit0 when in updatedr state
                   newbit_nst[NEW] = 1'b1;
                 else
                   newbit_nst[OLD] = 1'b1;
              end else
                 newbit_nst[SHIFTING_NEW] = 1'b1;
           end
           default : newbit_nst = 3'bxxx;
         endcase
         //verilint 226 on
         //verilint 225 on
         //verilint 526 on
      end
   endfunction
   //

   mvp_register #(3) _pcs_newbit_st_xx_2_0_(pcs_newbit_st_xx[2:0],EJ_TCK, reset_unsync ? 1'b1 << OLD :
                            newbit_nst(pcs_newbit_st_xx,
                                           wait_mode,
                                           load_pcs,
                                           tap_state_updatedr,
                                           tap_state_capturedrpcsamp,
                                           pcs_shift_bit_0));
   mvp_register #(3) _das_newbit_st_xx_2_0_(das_newbit_st_xx[2:0],EJ_TCK, reset_unsync ? 1'b1 << OLD :
			    newbit_nst(das_newbit_st_xx,
					   wait_mode,
					   load_das,
					   tap_state_updatedr,
					   tap_state_capturedrpcsamp,
					   das_shift_bit_0));


// Fast Debug Channel register
   wire [35:0] fdc_txdata;
   wire [35:0] fdc_rxdata_tck;

   wire        fdc_txdata_ack_tck;
   wire        fdc_rxdata_rdy_tck;
   wire        fdc_rx_sample_st_pend, fdc_rx_sample_st_send, fdc_rx_wakeup;
   wire        load_fdc, fdc_data_pnd, fdc_tx_wakeup;

   // Asserted when TAP is in CaptureDR state and capturing FDC reg.
   assign tap_state_capturedrfdc = tap_state_capturedr && (inst_reg[4:0] == `M14K_EJT_FDC);
   assign tap_state_updatedrfdc = tap_state_updatedr && (inst_reg[4:0] == `M14K_EJT_FDC);

   // In order to minimize the likelihood of wasting a long shift
   // cycle, we dynamically track the RxBuffer Full bit through the
   // shift chain and set the value as it is shifted to bit 0
   assign fdc_rbf_bit_in[5:0] = tap_state_capturedr ? 6'd37 : (fdc_rbf_bit - 6'b1);
   assign rbf_inject = (fdc_rbf_bit == 6'd01);


   assign fdc_shift_in[37:0] = tap_state_capturedr ? {1'b0, fdc_tx_new, fdc_txdata[35:0]} :
                         {EJ_TDI, fdc_shift[37:2],
                          rbf_inject ? fdc_rx_full : fdc_shift[1]};

   mvp_cregister_wide #(44) _fdc_rbf_bit_5_0({fdc_rbf_bit[5:0],
    fdc_shift[37:0]}, gscanenable, tap_state_capturedr || tap_state_shiftdr,
                                    EJ_TCK, ({fdc_rbf_bit_in, fdc_shift_in}) & {44{fdc_present}});

   // FDC tx newbit state machine
   //    Use same state machine as for new bit in pcsample
   // Connection differences:
   //    FDC does not use the wait_mode override
   //    Probe indicates data was accepted by setting bit 37 (vs clearing 0 in PCS)

   mvp_register #(3) _fdc_tx_newbit_st_xx_2_0_(fdc_tx_newbit_st_xx[2:0],EJ_TCK, reset_unsync ? 1'b1 << OLD :
                              newbit_nst(fdc_tx_newbit_st_xx,
                                         1'b0,
                                         new_load_fdc,
                                         tap_state_updatedr,
                                         tap_state_capturedrfdc,
                                         ~fdc_shift[37]));
   assign fdc_tx_new = !fdc_tx_newbit_st_xx[OLD];

   // Need to detect the first cycle where data is available
   assign new_load_fdc = load_fdc & fdc_tx_rec_en_reg;

   // Enable receive module if we are in the OLD state and we
   // did not just take data in the last cycle
   assign fdc_tx_rec_en = fdc_tx_newbit_st_xx[OLD] & ~new_load_fdc;

   mvp_register #(1) _fdc_tx_rec_en_reg(fdc_tx_rec_en_reg,EJ_TCK, fdc_tx_rec_en & ~reset_unsync);

   // Need to remember what value of the full bit was captured for the
   // last scan and update our states in sync with probe
   mvp_cregister #(1) _sampled_rx_full(sampled_rx_full,reset_tck | (tap_state_shiftdr & rbf_inject),
                               EJ_TCK, reset_tck ? 1'b0 : fdc_rx_full);

   // Receive buffer is full if we are in the PEND or SEND state
   assign fdc_rx_full = fdc_rx_sample_st_send | fdc_rx_sample_st_pend;

   // Accept incoming receive data if marked valid and we indicated !full
   assign fdc_rx_vld = ~sampled_rx_full & tap_state_updatedrfdc & fdc_shift[36];


   m14k_ejt_async_rec #(36,0) fdctx_async_rec (
                                              .gscanenable(gscanenable),
                                              .gclk(EJ_TCK),
                                              .gfclk(EJ_TCK),
                                              .reset(reset_tck),
                                              .reset_unsync(reset_unsync),
                                              .sync_data_out(fdc_txdata[35:0]),
                                              .sync_data_vld(load_fdc),
                                              .sync_data_pnd(fdc_data_pnd),
                                              .sync_data_enable(fdc_tx_rec_en),
                                              .sync_wakeup(fdc_tx_wakeup),
                                              .async_data_in(fdc_txdata_gclk),
                                              .async_data_rdy(fdc_txdata_rdy_gclk),
                                              .async_data_ack(fdc_txdata_ack_tck)
                                              );



   m14k_ejt_async_snd #(36,0) fdcrx_async_snd (
                                              .gscanenable(gscanenable),
                                              .gclk(EJ_TCK),
                                              .gfclk(EJ_TCK),
                                              .reset(reset_tck),
                                              .reset_unsync(reset_unsync),
                                              .sync_data_in(fdc_shift[35:0]),
                                              .sync_sample(fdc_rx_vld),
                                              .sync_sample_st_send(fdc_rx_sample_st_send),
                                              .sync_sample_st_pend(fdc_rx_sample_st_pend),
                                              .sync_wakeup(fdc_rx_wakeup),
                                              .async_data_out(fdc_rxdata_tck),
                                              .async_data_rdy(fdc_rxdata_rdy_tck),
                                              .async_data_ack(fdc_rxdata_ack_gclk)
                                              );


   // Separate Indication that Tx receive buffer is in use
   // Note: this is only used for status and is not part of
   // the handshaked i/f
   // Reset of async_snd/rec logic only happens once TCK is toggling
   // Clear signals going back to gclk to allow a clean reset there in
   // case TCK is not toggling yet.  This signal is synchronized in
   // gclk domain.  and2 module prevents a glitch when reset_unsync
   // deasserts
   m14k_ejt_and2 fdc_txtck_used_tck_(.y(fdc_txtck_used_tck),
                                         .a(load_fdc),
                                         .b(~reset_unsync));

   // FDC Interrupt
   // Probe can also request an interrupt by scanning in FDC data with
   // valid=0 and channel=0xd.  This is not qualified by the full indication.
   assign fdc_rxint = tap_state_updatedrfdc & ~fdc_shift[36] &
                (fdc_shift[35:32] == 4'hd);

   // Keep this asserted until acknowledged by gclk logic
   mvp_register_c #(1) _fdc_rxint_tck(fdc_rxint_tck,~reset_unsync | gscanmode, EJ_TCK, (fdc_rxint | fdc_rxint_tck) &
                            ~reset_unsync & ~fdc_rxint_ack_tck);

   // Double-flop synchronize ack signal
   mvp_register #(1) _fdc_rxint_ack_1(fdc_rxint_ack_1,EJ_TCK, fdc_rxint_ack_gclk);
   mvp_register #(1) _fdc_rxint_ack_tck(fdc_rxint_ack_tck,EJ_TCK, fdc_rxint_ack_1);



// PA Data register

// Make register used for shift through update when required
mvp_cregister_wide #(32) _pa_data_reg_31_0_(pa_data_reg[31:0],gscanenable, 
			((`M14K_EJT_DATA == inst_reg[4:0]) | 
			 (`M14K_EJT_ALL  == inst_reg[4:0])) &
			(((`M14K_EJT_CaptureDR == tap_ctrl[3:0]) & 
			  (pracc == 1'b1) & (prnw == 1'b1)) | 
			 (`M14K_EJT_ShiftDR == tap_ctrl[3:0])), 
			EJ_TCK, pa_data_reg_next[31:0]);

// Generate shift value for PA Data register
assign pa_data_reg_shift[31:0] = {((`M14K_EJT_ALL == inst_reg[4:0]) ? 
                            pa_addr_reg[0] : EJ_TDI_buf), 
                           pa_data_reg[31:1]};

m14k_ejt_bus32mux2 pa_data_reg_next_i(.y(pa_data_reg_next[31:0]),
              .s(tap_capturedr), .b(ej_eagdataout[31:0]), 
              .a(pa_data_reg_shift[31:0]));

// Make Data register output update only when finishing processor access
// Or on FASTDATA when the shift_through_reg is selected.
mvp_cregister_wide #(32) _pa_data_reg_done_31_0_(pa_data_reg_done[31:0],gscanenable, 
					((ejtag_ctrl_upd & ~pracc_str) | ejtag_fastdata_upd),
					EJ_TCK, ((`M14K_EJT_FASTDATA == inst_reg[4:0]) ?
					       shift_through_reg[31:0] : pa_data_reg[31:0]));


   
// PA Address register

// Make register update when required 
mvp_cregister_wide #(32) _pa_addr_reg_31_0_(pa_addr_reg[31:0],gscanenable, 
			((`M14K_EJT_ADDRESS == inst_reg[4:0]) | 
			 (`M14K_EJT_ALL  == inst_reg[4:0])) &
			(((`M14K_EJT_CaptureDR == tap_ctrl[3:0]) & (pracc == 1'b1))|
			 (`M14K_EJT_ShiftDR == tap_ctrl[3:0])), 
			EJ_TCK, pa_addr_reg_next[31:0]);

// Generate two lowest bits for PA Address 
assign pa_addr[1:0] = 
	(cpz_enm == 1'b0) ? // Little endian
		(ej_eagbe[3:0] == 4'b0001) ? 2'b00 : 
		(ej_eagbe[3:0] == 4'b0010) ? 2'b01 : 
		(ej_eagbe[3:0] == 4'b0100) ? 2'b10 : 
		(ej_eagbe[3:0] == 4'b1000) ? 2'b11 : 
		(ej_eagbe[3:0] == 4'b0011) ? 2'b00 : 
		(ej_eagbe[3:0] == 4'b1100) ? 2'b10 : 
		(ej_eagbe[3:0] == 4'b0111) ? 2'b00 : 
		(ej_eagbe[3:0] == 4'b1110) ? 2'b01 : 
		 2'b00
	: // Big endian
		(ej_eagbe[3:0] == 4'b1000) ? 2'b00 : 
		(ej_eagbe[3:0] == 4'b0100) ? 2'b01 : 
		(ej_eagbe[3:0] == 4'b0010) ? 2'b10 : 
		(ej_eagbe[3:0] == 4'b0001) ? 2'b11 : 
		(ej_eagbe[3:0] == 4'b1100) ? 2'b00 : 
		(ej_eagbe[3:0] == 4'b0011) ? 2'b10 : 
		(ej_eagbe[3:0] == 4'b1110) ? 2'b00 : 
		(ej_eagbe[3:0] == 4'b0111) ? 2'b01 : 
		 2'b00;

// Load and shift values of Processor Access address
assign pa_addr_reg_load[31:0] = {12'hFF2, ej_eagaddr[19:2], pa_addr[1:0]};
assign pa_addr_reg_shift[31:0] = {EJ_TDI_buf, pa_addr_reg[31:1]};

// Generate next value for PA Address register
m14k_ejt_bus32mux2 pa_addr_reg_next_i(.y(pa_addr_reg_next[31:0]), 
              .s(tap_capturedr), .b(pa_addr_reg_load[31:0]), 
              .a(pa_addr_reg_shift[31:0]));


// TCB TAP interface
   
   assign tck_softreset 	= ( EJ_TMS_buf & (tap_ctrl[3:0] == `M14K_EJT_SelectIRScan)) |
			  ( EJ_TMS_buf & (tap_ctrl[3:0] == `M14K_EJT_TestLogicReset)) |
			  ~EJ_TRST_N;
   assign tck_shift 		= (!EJ_TMS_buf && (tap_ctrl[3:0] == `M14K_EJT_ShiftDR)) ||
			  (!EJ_TMS_buf && (tap_ctrl[3:0] == `M14K_EJT_CaptureDR));
   assign tck_capture 		= (!EJ_TMS_buf && (tap_ctrl[3:0] == `M14K_EJT_SelectDRScan));
   assign tck_update 		= ( EJ_TMS_buf && (tap_ctrl[3:0] == `M14K_EJT_Exit1DR)) ||
			  ( EJ_TMS_buf && (tap_ctrl[3:0] == `M14K_EJT_Exit2DR));
   assign tck_inst [4:0] 	= inst_reg[4:0];

// Control of TDO

// Generate EJ_TDOzstate indication

mvp_register_s #(1) _EJ_TDOzstate(EJ_TDOzstate,EJ_TRST_N_control, EJ_TCK_n, 
			  ~((`M14K_EJT_ShiftDR == tap_ctrl[3:0]) | 
			    (`M14K_EJT_ShiftIR == tap_ctrl[3:0])));


//
   function tdo_select;
      input [4:0] inst;
      input shift_through;
      input pa_addr;
      input pa_data;
      input pc_sample;
      input fdc_out;
      input fastdata;
      input bypass;
      input tcb_data;
      input tcb_present;

       `ifdef MIPS_SIMULATION 
 //VCS coverage off 
      // 
      // pessimistic X-detection
      if(^inst === 1'bx) begin
	 tdo_select = 1'bx;
      end else 
        //VCS coverage on  
 `endif 
      // 
      begin
	 case(inst)
	   `M14K_EJT_IDCODE, `M14K_EJT_IMPCODE, `M14K_EJT_CONTROL, `M14K_EJT_ALL : begin
	      tdo_select = shift_through;
	   end
           `M14K_EJT_PCSAMPLE: begin 
             tdo_select = pc_sample;
	   end
	   `M14K_EJT_FDC: begin
	     tdo_select = fdc_out;
           end
	   `M14K_EJT_FASTDATA : begin
	      tdo_select = fastdata;
	   end
	   `M14K_EJT_ADDRESS : begin
	      tdo_select = pa_addr;
	   end
	   `M14K_EJT_DATA : begin
	      tdo_select = pa_data;
	   end
	   `M14K_EJT_TCBTRACECONTROL, `M14K_EJT_TCBCONTROL, `M14K_EJT_TCBDATA : begin
	      if (tcb_present) begin
		 tdo_select = tcb_data;
	      end else begin
		 tdo_select = bypass;
	      end
	   end
	   `M14K_EJT_BYPASS : begin
	      tdo_select = bypass;
	   end
	   default : begin
	      tdo_select = bypass;
	   end
	 endcase
      end
   endfunction // tdo_select
//
	
// Generate  
mvp_register #(1) _EJ_TDO(EJ_TDO,EJ_TCK_n, tdo_next);
 
//verilint 391 on

assign tdo_next = (`M14K_EJT_ShiftIR == tap_ctrl[3:0]) ? inst_reg[0] : 
	   tdo_select(inst_reg, 
		      shift_through_reg[0], 
		      pa_addr_reg[0],
		      pa_data_reg[0],
                      pcs_shift[0],
		      fdc_shift[0],
		      fastdata_reg,
		      bypass_reg,
		      pdt_tcbdata,
		      pdt_present_tck);

   
// Reset Handling

// reset indicated by greset is held through 3 TCK cycles
// by 3 FF with async. set, and indicated on reset_unsync immediately. 
// The FF are cleared by TCK when not hard or soft reset.
// The reset_unsync is synchronized to TCK domain, and output on reset_tck.

assign reset_detect_b = ~greset || gscanmode;
mvp_register_s #(1) _reset_ff1(reset_ff1,reset_detect_b, EJ_TCK, 1'b0);
mvp_register_s #(1) _reset_ff2(reset_ff2,reset_detect_b, EJ_TCK, reset_ff1);
mvp_register #(1) _reset_tck(reset_tck,EJ_TCK, reset_tck_pre);

mvp_register_s #(1) _reset_unsynca(reset_unsynca,(reset_detect_b| gscanmode), EJ_TCK, reset_ff2);
mvp_register_s #(1) _reset_unsync(reset_unsync,(reset_detect_b| gscanmode), EJ_TCK, reset_unsynca);
mvp_register #(1) _reset_tck_pre(reset_tck_pre,EJ_TCK, reset_unsynca);


//verilint 528 off  // Variable set but not used
wire unused_ok;
assign unused_ok = &{1'b0,
              pcs_wakeup,
	      das_wakeup,
              pcs_data_pnd,
	      das_data_pnd,
              fdc_tx_wakeup,
              fdc_rx_wakeup,
              fdc_data_pnd};
//verilint 528 on  // Variable set but not used





endmodule
