// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
// 	Description:  m14k_core 
//            Core level of hierarchy = m4k without caches
//
//    $Id: \$
//    mips_repository_id: m14k_core.hook, v 1.64 
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

module m14k_core(
	cpz_mnan,
	cpz_prid16,
	CP2_abusy_0,
	CP2_as_0,
	CP2_ccc_0,
	CP2_cccs_0,
	CP2_endian_0,
	CP2_exc_0,
	CP2_exccode_0,
	CP2_excs_0,
	CP2_fbusy_0,
	CP2_fdata_0,
	CP2_fds_0,
	CP2_forder_0,
	CP2_fordlim_0,
	CP2_fs_0,
	CP2_idle,
	CP2_inst32_0,
	CP2_ir_0,
	CP2_irenable_0,
	CP2_kd_mode_0,
	CP2_kill_0,
	CP2_kills_0,
	CP2_null_0,
	CP2_nulls_0,
	CP2_present,
	CP2_reset,
	CP2_tbusy_0,
	CP2_tdata_0,
	CP2_tds_0,
	CP2_torder_0,
	CP2_tordlim_0,
	CP2_ts_0,
	CP1_abusy_0,
	CP1_as_0,
	CP1_ccc_0,
	CP1_cccs_0,
	CP1_endian_0,
	CP1_exc_0,
	CP1_exccode_0,
	CP1_excs_0,
	CP1_exc_1,
	CP1_exccode_1,
	CP1_excs_1,
	CP1_fbusy_0,
	CP1_fdata_0,
	CP1_fds_0,
	CP1_forder_0,
	CP1_fordlim_0,
	CP1_fs_0,
	CP1_fppresent,
	CP1_mdmxpresent,
	CP1_ufrpresent,
	CP1_idle,
	CP1_inst31_0,
	CP1_ir_0,
	CP1_irenable_0,
	CP1_kill_0,
	CP1_kills_0,
	CP1_kill_1,
	CP1_kills_1,
	CP1_null_0,
	CP1_nulls_0,
	CP1_gprs_0,
	CP1_gpr_0,
	CP1_reset,
	CP1_tbusy_0,
	CP1_tdata_0,
	CP1_tds_0,
	CP1_torder_0,
	CP1_tordlim_0,
	CP1_ts_0,
	CP1_fr32_0,
	mpc_disable_gclk_xx,
	DSP_GuestID,
	DSP_Lock,
	DSP_DataAddr,
	DSP_DataRdStr,
	DSP_DataRdValue,
	DSP_DataWrMask,
	DSP_DataWrStr,
	DSP_DataWrValue,
	DSP_Hit,
	DSP_ParPresent,
	DSP_ParityEn,
	DSP_Present,
	DSP_RPar,
	DSP_Stall,
	DSP_TagAddr,
	DSP_TagCmpValue,
	DSP_TagRdStr,
	DSP_TagRdValue,
	DSP_TagWrStr,
	DSP_WPar,
	EJ_DINT,
	EJ_DINTsup,
	EJ_DebugM,
	EJ_ECREjtagBrk,
	EJ_ManufID,
	EJ_PartNumber,
	EJ_PerRst,
	EJ_PrRst,
	EJ_SRstE,
	EJ_TCK,
	EJ_TDI,
	EJ_TDO,
	EJ_TDOzstate,
	EJ_TMS,
	EJ_TRST_N,
	EJ_Version,
	EJ_DisableProbeDebug,
	PM_InstnComplete,
	HADDR,
	HBURST,
	HCLK,
	HMASTLOCK,
	HPROT,
	HRDATA,
	HREADY,
	HRESETn,
	HRESP,
	SI_AHBStb,
	HSIZE,
	HTRANS,
	HWDATA,
	HWRITE,
	ISP_GuestID,
	ISP_Addr,
	isp_dataaddr_scr,
	ISP_DataRdValue,
	ISP_DataTagValue,
	ISP_DataWrStr,
	ISP_Hit,
	ISP_ParPresent,
	ISP_ParityEn,
	ISP_Present,
	ISP_RPar,
	ISP_RdStr,
	ISP_Stall,
	ISP_TagRdValue,
	ISP_TagWrStr,
	ISP_WPar,
	icc_spwr_active,
	SI_BootExcISAMode,
	SI_CPUNum,
	SI_ClkIn,
	SI_ClkOut,
	SI_ColdReset,
	SI_Dbs,
	SI_EICPresent,
	SI_EICVector,
	SI_EISS,
	SI_ERL,
	SI_EXL,
	SI_NMITaken,
	SI_NESTERL,
	SI_NESTEXL,
	SI_Endian,
	SI_FDCInt,
	SI_IAck,
	SI_IPFDCI,
	SI_IPL,
	SI_IVN,
	SI_ION,
	SI_IPPCI,
	SI_IPTI,
	SI_Ibs,
	SI_Int,
	SI_MergeMode,
	SI_NMI,
	SI_Offset,
	SI_PCInt,
	SI_RP,
	SI_Reset,
	SI_SRSDisable,
	SI_SWInt,
	SI_Sleep,
	SI_TimerInt,
	SI_TraceDisable,
	TC_ClockRatio,
	TC_Data,
	TC_PibPresent,
	TC_Stall,
	TC_Valid,
	UDI_endianb_e,
	UDI_gclk,
	UDI_greset,
	UDI_gscanenable,
	UDI_honor_cee,
	UDI_ir_e,
	UDI_irvalid_e,
	UDI_kd_mode_e,
	UDI_kill_m,
	UDI_present,
	UDI_rd_m,
	UDI_ri_e,
	UDI_rs_e,
	UDI_rt_e,
	UDI_run_m,
	UDI_stall_m,
	UDI_start_e,
	UDI_wrreg_e,
	bc_rfbistto,
	bc_tcbbistto,
	gclk,
	gscanenable,
	gscanmode,
	greset,
	dc_datain,
	dc_nsets,
	dc_present,
	dc_hci,
	dc_ssize,
	dc_tagin,
	dc_wsin,
	dca_parity_present,
	dcc_data,
	dcc_dataaddr,
	dcc_drstb,
	dcc_dwstb,
	dcc_tagaddr,
	dcc_tagwrdata,
	dcc_tagwren,
	dcc_trstb,
	dcc_twstb,
	dcc_writemask,
	dcc_wsaddr,
	dcc_wsrstb,
	dcc_wswrdata,
	dcc_wswren,
	dcc_wswstb,
	gmb_dc_algorithm,
	gmb_ic_algorithm,
	gmb_isp_algorithm,
	gmb_sp_algorithm,
	gmbddfail,
	gmbdifail,
	gmbspfail,
	gmbispfail,
	gmbdone,
	gmbinvoke,
	gmbtdfail,
	gmbtifail,
	gmbwdfail,
	gmbwifail,
	gscanramwr,
	ic_datain,
	ic_nsets,
	ic_present,
	ic_hci,
	ic_ssize,
	ic_tagin,
	ic_wsin,
	ica_parity_present,
	icc_data,
	icc_dataaddr,
	icc_drstb,
	icc_dwstb,
	icc_readmask,
	icc_tagaddr,
	icc_tagwrdata,
	icc_tagwren,
	icc_trstb,
	icc_twstb,
	icc_writemask,
	icc_wsaddr,
	icc_wsrstb,
	icc_wswrdata,
	icc_wswren,
	icc_wswstb,
	icc_early_data_ce,
	icc_early_tag_ce,
	icc_early_ws_ce,
	dcc_early_data_ce,
	dcc_early_tag_ce,
	dcc_early_ws_ce,
	rf_bistfrom,
	tcb_bistfrom,
	SI_GSWInt,
	SI_GTimerInt,
	SI_GPCInt,
	SI_GIAck,
	SI_GIPL,
	SI_GIVN,
	SI_GION,
	SI_GID,
	SI_GInt,
	SI_GEICVector,
	SI_GOffset,
	SI_GEISS,
	SI_EICGID,
	SI_Slip,
	cpz_scramblecfg_write,
	cpz_scramblecfg_sel,
	cpz_scramblecfg_data,
	antitamper_present);


/*hookios*//* IO declarations added by hookup */
/* End of hookup IO declarations */
/* Wire declarations added by hookup */
wire CP1_inst32_0;
wire [3:0] MDU_count_sat_tcid_xx;
wire MDU_count_sat_xx;
wire MDU_data_ack_m;		//Data accept from MPC on MDU data
wire MDU_data_val_e;
wire MDU_data_valid_e;
wire MDU_dec_e;
wire [39:0] MDU_info_e;
wire MDU_opcode_issue_e;
wire [1:0] MDU_ouflag_age_xx;
wire MDU_ouflag_extl_extr_xx;		// ouflag value for EXTL/R
wire [3:0] MDU_ouflag_hilo_xx;
wire MDU_ouflag_mulq_muleq_xx;		// ouflag value for MULQ/MULEQ
wire [3:0] MDU_ouflag_tcid_xx;
wire MDU_ouflag_vld_xx;		// ouflag value for EXTL/R
wire [8:0] MDU_pend_ouflag_wr_xx;
wire [31:0] MDU_rs_ex;
wire [31:0] MDU_rt_ex;
wire MDU_run_e;
wire MDU_stallreq_e;
wire [8:0] alu_cp0_rtc_ex;
wire asid_update;		// enhi register updated
wire [3:0] biu_be_ej;		// Byte enable to EJTAG module
wire [31:0] biu_datain;		// Data into the cache control blocks
wire [1:0] biu_datawd;		// Which wd within the line is being returned
wire biu_dbe;		// Bus Error on Data Read 
wire biu_dbe_exc;		// Bus Error on Data Read 
wire biu_dbe_pre;		// Previous Bus Error on Data Read 
wire biu_ddataval;		// Returning D Data
wire biu_dreqsdone;		// sync request is done
wire biu_eaaccess;		// Signal that this is an EJTAG area access
wire biu_ibe;		// Bus Error on Instn reference
wire biu_ibe_exc;		// Bus Error on Instn reference
wire biu_ibe_pre;		// Previous Bus Error on Instrn reference 
wire biu_idataval;		// Returning I Data
wire biu_if_enable;		// SYNC bus
wire biu_lastwd;		// This is the last word to be returned
wire biu_lock;		// Bus is locked by atomic instruction
wire [31:0] biu_mbdata;		// MBIST data		 
wire [23:2] biu_mbtag;		// MBIST Tag	 
wire biu_merging;		// Merging enabled in WTB
wire biu_nofreebuff;		// No free WTB enties, stall writeback flushes 
wire biu_pm_wr_buf_b;		// used by performance counter to trace wbb status
wire biu_pm_wr_buf_f;		// used by performance counter to trace wbb status
wire biu_shutdown;		// Bus is idle, shutdown main clock
wire biu_wbe;		// Bus Error on a Data write
wire biu_wtbf;		// Write Thru buffer is full
wire [3:0] brk_d_trig;
wire [3:0] brk_dbs_bs;		// Data break status
wire [7:0] brk_i_trig;
wire [7:0] brk_ibs_bs;		// Instruction break status
wire bstall_ie;		//for performance counter
wire cdmm_area;
wire cdmm_ej_override;
wire cdmm_fdc_hit;
wire cdmm_fdcgwrite;
wire cdmm_fdcread;
wire cdmm_hit;
wire cdmm_mmulock;
wire [3:0] cdmm_mpu_numregion;		// number of MPU regions implemented
wire cdmm_mpu_present;		// MPU is implemented
wire cdmm_mpuipdt_w;
wire cdmm_mputriggered_i;		// i-access in protected region
wire cdmm_mputriggered_m;		// r/w-access in protected region
wire cdmm_mputrigresraw_i;
wire [31:0] cdmm_rdata_xx;
wire cdmm_sel;
wire [31:0] cdmm_wdata_xx;
wire cp1_bstall_e;		// Stall to resolve Cop1 branch
wire cp1_btaken;		// Cop1 branch taken
wire cp1_bvalid;		// Cop1 Branch detected
wire cp1_copidle;		// COP 1 is Idle, biu_shutdown is OK for COP 1
wire cp1_coppresent;		// COP 1 is present on the interface.
wire cp1_data_missing;
wire [63:0] cp1_data_w;		// Return Data from COP1
wire cp1_datasel;		// Select cp1_data_w in store buffer.
wire cp1_exc_w;		// W-stage Cop1 exception
wire [4:0] cp1_exccode_w;		// Exception code returned from Cop1
wire cp1_fixup_i;		// Fixup I-stage for Cop1 instn
wire cp1_fixup_m;		// Fixup M-stage for Cop1 op
wire cp1_fixup_w;		// Fixup W-stage for Cop1 instn
wire cp1_fixup_w_nolsdc1;
wire cp1_ldst_m;		// CP1 Ld/St instruction in M-stage
wire cp1_missexc_w;		// Waiting for valid exception
wire cp1_movefrom_m;		// Coprocessor Move
wire cp1_moveto_m;		// Coprocessor Move
wire cp1_seen_nodmiss_m;
wire cp1_stall_e;		// Stall for Cop1 dispatch
wire cp1_stall_m;
wire cp1_storealloc_reg;		// Control input from CP1
wire cp1_storeissued_m;		// Indicate that a SWC1 is issued to CP1
wire cp1_storekill_w;		// Invalidate COP1 store data in SB
wire cp1_ufrp;
wire cp2_bstall_e;		// Stall to resolve Cop2 branch
wire cp2_btaken;		// Cop2 branch taken
wire cp2_bvalid;		// Cop2 Branch detected
wire cp2_copidle;		// COP 2 is Idle, biu_shutdown is OK for COP 2
wire cp2_coppresent;		// COP 2 is present on the interface.
wire [31:0] cp2_data_w;		// Return Data from COP2
wire cp2_datasel;		// Select cp2_data_w in store buffer.
wire cp2_exc_w;		// W-stage Cop2 exception
wire [4:0] cp2_exccode_w;		// Exception code returned from Cop2
wire cp2_fixup_m;		// Fixup M-stage for Cop2 op
wire cp2_fixup_w;		// Fixup W-stage for Cop2 instn
wire cp2_ldst_m;		// CP2 Ld/St instruction in M-stage
wire cp2_missexc_w;		// Waiting for valid exception
wire cp2_movefrom_m;		// Coprocessor Move
wire cp2_moveto_m;		// Coprocessor Move
wire cp2_stall_e;		// Stall for Cop2 dispatch
wire cp2_storealloc_reg;		// Control input from CP2
wire cp2_storeissued_m;		// Indicate that a SWC2 is issued to CP2
wire cp2_storekill_w;		// Invalidate COP2 store data in SB
wire [1:0] cpz_at;
wire cpz_at_epi_en;		//enable iae
wire cpz_at_pro_start_i;		//start cycle of HW auto prologue
wire cpz_at_pro_start_val;		//valid start of HW auto prologue
wire cpz_bds_x;		// Current value on cpz_epc_w is from previous inst
wire cpz_bev;		// Bootstrap exception vectors
wire cpz_bg;
wire cpz_bootisamode;		// isamode for boot
wire cpz_cause_pci;		// PC is full interrupt
wire cpz_causeap;		//exception happened during auto-prologue
wire cpz_cdmm_enable;
wire [31:15] cpz_cdmmbase;		// CDMM base
wire cpz_cee;		// corextend enable
wire cpz_cf;
wire cpz_cg;
wire cpz_cgi;
wire cpz_config_ld;
wire [3:0] cpz_copusable;		// coprocessor usable bits
wire cpz_cp0;
wire [31:0] cpz_cp0read_m;		// Read data for MFC0 & SC register updates
wire [31:0] cpz_datalo;		// Data for cacheops
wire [2:0] cpz_dcnsets;		// Number of sets   - from config1
wire cpz_dcpresent;		// D$ is present  - from config1
wire [1:0] cpz_dcssize;		// D$ associativity - from config1
wire cpz_debugmode_i;
wire cpz_dm;		// Copy of cpz_dm bit from DEBUG reg.
wire cpz_dm_m;		// A debug Exception has been taken
wire cpz_dm_w;		// A debug Exception has been taken
wire cpz_doze;		// Processor is in low-power mode
wire cpz_drg;
wire cpz_drgmode_i;
wire cpz_drgmode_m;
wire cpz_dsppresent;		// D SPRAM is present  - from config0
wire cpz_dwatchhit;		// data Watch comparison matched
wire [31:12] cpz_ebase;		// Exception base
wire cpz_eisa_w;		// ISA mode of inst in W (1=UMIPS, 0=MIPS32)
wire cpz_enm;		// BE bit, (Big-Endian Memory)
wire [31:0] cpz_epc_rd_data;		//EPC data for HW saving operation
wire [31:0] cpz_epc_w;		// Address of inst in W
wire cpz_eret_m;		//active eret for writing registers (m stage)
wire cpz_eretisa;		// Target ISA for ERET or DERET (from epc or ErrorPC or depc)
wire [31:0] cpz_eretpc;		// Target PC for ERET or DERET (epc or ErrorPC or depc)
wire cpz_erl;		// cpz_erl bit from status
wire cpz_erl_e;
wire cpz_excisamode;		// isamode for exception
wire cpz_exl;		// cpz_exl bit from status
wire cpz_ext_int;		//external interrupt
wire cpz_fdcint;		// FDC receive FIFO full
wire cpz_fr;
wire cpz_g_at_epi_en;		//enable iae
wire cpz_g_at_pro_start_i;
wire cpz_g_at_pro_start_val;
wire cpz_g_bev;		// Bootstrap exception vectors
wire cpz_g_bootisamode;		// isamode for boot
wire cpz_g_cause_pci;		// PC is full interrupt
wire cpz_g_causeap;		//exception happened during auto-prologue
wire cpz_g_cdmm;
wire cpz_g_cee;		// corextend enable
wire cpz_g_config_ld;
wire [3:0] cpz_g_copusable;		// coprocessor usable bits
wire cpz_g_dwatchhit;		// data Watch comparison matched
wire [31:12] cpz_g_ebase;		// Exception base
wire [31:0] cpz_g_epc_rd_data;		//EPC data for HW saving operation
wire cpz_g_eretisa;		// Target ISA for ERET or DERET (from epc or ErrorPC or depc)
wire cpz_g_erl;		// cpz_erl bit from status
wire cpz_g_erl_e;
wire cpz_g_excisamode;		// isamode for exception
wire cpz_g_exl;		// cpz_g_exl bit from status
wire cpz_g_ext_int;		//external interrupt
wire cpz_g_hoterl;		// Early version of cpz_g_erl
wire cpz_g_hotexl;		// cpz_g_exl bit from status
wire [3:0] cpz_g_hss;
wire [3:0] cpz_g_hwrena;		// HWRENA CP0 register
wire cpz_g_hwrena_29;		// Bit 29 of HWRENA CP0 register
wire cpz_g_iack;		// interrupt acknowledge
wire cpz_g_iap_um;
wire cpz_g_ice;		//enable tail chain
wire cpz_g_int_e;		// external, software, and non-maskable interrupts
wire cpz_g_int_enable;		//interrupt enable
wire cpz_g_int_excl_ie_e;
wire cpz_g_int_mw;		// Interrupt in M/W stage
wire [7:0] cpz_g_int_pend_ed;		//pending iterrupt
wire [17:1] cpz_g_ion;		// Current ION, contains information of which int SI_IACK ack.
wire [7:0] cpz_g_ipl;		// Current IPL, contains information of which int SI_IACK ack.
wire cpz_g_iret_m;		//active version of M-stage IRET instn
wire [31:0] cpz_g_iretpc;		//return to the original epc on IRET if tail chain not happen
wire cpz_g_iv;		// cpz_g_iv bit from cause
wire [5:0] cpz_g_ivn;		// Current IVN, contains information of which int SI_IACK ack.
wire cpz_g_iwatchhit;		// instruction Watch comparison matched
wire [2:0] cpz_g_k0cca;		// kseg0 cache attributes
wire [2:0] cpz_g_k23cca;		// kseg2/3 cache attributes
wire cpz_g_kuc_e;		// Kernel/user bit - 0:=>kernel; 1:=>user
wire cpz_g_kuc_i;		// Kernel/user bit - 0:=>kernel; 1:=>user
wire cpz_g_kuc_m;		// Kernel/user bit - 0:=>kernel; 1:=>user
wire cpz_g_kuc_w;		// Kernel/user bit - 0:=>kernel; 1:=>user
wire [2:0] cpz_g_kucca;		// kuseg cache attributes
wire cpz_g_llbit;		// Load linked bit - enables SC
wire [1:0] cpz_g_mmusize;		// mmu_size from config
wire cpz_g_mmutype;		// mmu_type from Config register
wire cpz_g_mx;
wire cpz_g_pc_present;
wire cpz_g_pf;		//speculative prefetch enable
wire cpz_g_rbigend_e;		// reverse Endianess from state of bigend mode bit in user mode
wire cpz_g_rbigend_i;		// reverse Endianess from state of bigend mode bit in user mode
wire cpz_g_smallpage;		// Small (1KB) page support
wire [31:0] cpz_g_srsctl;		//SRSCTL data for HW entry sequence
wire [3:0] cpz_g_srsctl_css;		// Current SRS
wire [3:0] cpz_g_srsctl_pss;		// Previous SRS
wire cpz_g_srsctl_pss2css_m;		// Copy PSS back to CSS on eret
wire [31:0] cpz_g_status;		//Status data for HW sequence
wire [4:0] cpz_g_stkdec;		//number of words for the decremented value of sp
wire [1:0] cpz_g_swint;		// Software interrupt requests to external interrupt controller
wire cpz_g_takeint;		//interrupt recognized finally
wire cpz_g_timerint;		// count==compare interrupt
wire cpz_g_ufr;
wire cpz_g_ulri;
wire cpz_g_um;
wire cpz_g_um_vld;
wire cpz_g_usekstk;		//Use kernel stack during IAP
wire [17:1] cpz_g_vectoroffset;		// Interrupt vector offset
wire cpz_g_watch_present;
wire cpz_g_watch_present__1;
wire cpz_g_watch_present__2;
wire cpz_g_watch_present__3;
wire cpz_g_watch_present__4;
wire cpz_g_watch_present__5;
wire cpz_g_watch_present__6;
wire cpz_g_watch_present__7;
wire cpz_g_wpexc_m;		// Deferred watch exception
wire cpz_ghfc_i;
wire cpz_ghfc_w;
wire [`M14K_GID] cpz_gid;
wire cpz_gm_e;
wire cpz_gm_i;
wire cpz_gm_m;
wire cpz_gm_p;
wire cpz_gm_w;
wire cpz_goodnight;		// indicates sleep mode. do not start core until core is fully awake
wire cpz_gsfc_m;
wire cpz_gt;
wire [7:0] cpz_guestid;
wire [7:0] cpz_guestid_i;
wire [7:0] cpz_guestid_m;
wire cpz_halt;		// Processor clocks are stopped
wire cpz_hotdm_i;		// A debug Exception has been taken
wire cpz_hoterl;		// Early version of cpz_erl
wire cpz_hotexl;		// cpz_exl bit from status
wire cpz_hotiexi;		// Hot version of cpz_iexi bit from debug
wire [3:0] cpz_hwrena;		// HWRENA CP0 register
wire cpz_hwrena_29;		// Bit 29 of HWRENA CP0 register
wire cpz_iack;		// interrupt acknowledge
wire cpz_iap_exce_handler_trace;		// Instruction is under exception processing of IAP	
wire cpz_iap_um;		//user mode when iap
wire cpz_ice;		//enable tail chain
wire [2:0] cpz_icnsets;		// Number of sets   - from config1
wire cpz_icpresent;		// I$ is present  - from config1
wire [1:0] cpz_icssize;		// I$ associativity - from config1
wire cpz_iexi;		// cpz_iexi bit from debug
wire cpz_int_e;		// external, software, and non-maskable interrupts
wire cpz_int_enable;		//interrupt enable
wire cpz_int_excl_ie_e;
wire cpz_int_mw;		// external, software, and non-maskable interrupts
wire [7:0] cpz_int_pend_ed;		//pending iterrupt
wire [17:1] cpz_ion;		// Current ION, contains information of which int SI_IACK ack.
wire [7:0] cpz_ipl;		// Current IPL, contains information of which int SI_IACK ack.
wire cpz_iret_chain_reg;		//reg version of iret_tailchain 
wire cpz_iret_m;		//active version of M-stage IRET instn
wire cpz_iret_ret;		//active iret for writing registers
wire [31:0] cpz_iretpc;		//return to the original epc on IRET if tail chain not happen
wire cpz_isppresent;		// I SPRAM is present  - from config0
wire cpz_iv;		// cpz_iv bit from cause
wire [5:0] cpz_ivn;		// Current IVN, contains information of which int SI_IACK ack.
wire cpz_iwatchhit;		// instruction Watch comparison matched
wire [2:0] cpz_k0cca;		// kseg0 cache attributes
wire [2:0] cpz_k23cca;		// kseg2/3 cache attributes
wire cpz_kuc_e;		// Kernel/user bit - 0:=>kernel; 1:=>user
wire cpz_kuc_i;		// Kernel/user bit - 0:=>kernel; 1:=>user
wire cpz_kuc_m;		// Kernel/user bit - 0:=>kernel; 1:=>user
wire cpz_kuc_w;		// Kernel/user bit - 0:=>kernel; 1:=>user
wire [2:0] cpz_kucca;		// kuseg cache attributes
wire cpz_llbit;		// Load linked bit - enables SC
wire cpz_lsnm;		// Load/Store Normal Memory from DEBUG
wire [1:0] cpz_mbtag;		// BIST read TAG Data
wire cpz_mg;
wire [1:0] cpz_mmusize;		// mmu_r_size from config
wire cpz_mmutype;		// mmu_r_type from config
wire cpz_mx;		// indicates dsp sw enable
wire cpz_nest_erl;		// nested error level
wire cpz_nest_exl;		// nested exception level
wire cpz_nmi;		// NMI from status register
wire cpz_nmi_e;		// Interrupt is really an nmi
wire cpz_nmi_mw;		// Interrupt is really an nmi
wire cpz_nmipend;		// Signal that an nmi is pending
wire cpz_og;
wire cpz_pc_ctl0_ec1;
wire cpz_pc_ctl1_ec1;
wire [3:0] cpz_pd;		//parity bits of D$ data array 
wire cpz_pe;		//parity enable bit 
wire cpz_pf;		//speculative prefetch enable
wire [3:0] cpz_pi;		//parity bits of I$ data array 
wire cpz_po;		//parity overwrite bit 
wire cpz_rbigend_e;		// reverse Endianess from state of bigend mode bit in user mode
wire cpz_rbigend_i;		// reverse Endianess from state of bigend mode bit in user mode
wire cpz_rclen;		// Random cache line refill order enable
wire [1:0] cpz_rclval;		// Random value for RCL
wire cpz_ri;
wire [`M14K_GID] cpz_rid;
wire cpz_rp;		// Reduce Power bit from status register
wire cpz_rslip_e;		// Random slip
wire cpz_setdbep;		// Set dbe Pending
wire cpz_setibep;		// Set ibe Pending
wire cpz_smallpage;		// Small (1KB) page support
wire cpz_spram;		// write to SPRAM on indxed cacheops
wire [31:0] cpz_srsctl;		//SRSCTL data for HW entry sequence
wire [3:0] cpz_srsctl_css;		// Current SRS
wire [3:0] cpz_srsctl_pss;		// Previous SRS
wire cpz_srsctl_pss2css_m;		// Copy PSS back to CSS on eret
wire cpz_sst;		// Enable Single-Step Mode
wire [31:0] cpz_status;		//Status data for HW sequence
wire [4:0] cpz_stkdec;		//number of words for the decremented value of sp
wire [1:0] cpz_swint;		// Software interrupt requests to external interrupt controller
wire [25:0] cpz_taglo;		// Tag for cacheops
wire cpz_takeint;		//interrupt recognized finally
wire cpz_timerint;		// count==compare interrupt
wire cpz_ufr;
wire cpz_um;		// cpz_um bit from status
wire cpz_um_vld;		// cpz_um bit from status is valid
wire cpz_usekstk;		//Use kernel stack during IAP
wire [17:1] cpz_vectoroffset;		// Interrupt vector offset
wire cpz_wpexc_m;		// Deferred watch exception
wire cpz_wst;		// write to WS RAM on cacheop store
wire dcc_advance_m;		// Advance $op
wire dcc_copsync_m;		// Tell ic_ctl that sync for $op is not done yet 
wire dcc_dbe_killfixup_w;		// dcc_dmiss_m is going away because of DBE
wire dcc_dcached_m;		// indicates whether access is cached or in uncached region
wire dcc_dcop_stall;
wire dcc_dcopaccess_m;		// D cache op
wire [31:0] dcc_dcopdata_m;		// Cacheop Data Value
wire dcc_dcopld_m;		// Cacheop cpz_taglo write strobe
wire [3:0] dcc_dcoppar_m;		// Cacheop Parity bits to be stored to ErrCtl register
wire [25:0] dcc_dcoptag_m;		// Cacheop Tag Value (includes Dirty bit and Parity bit)
wire [31:0] dcc_ddata_m;		// Data bus to core
wire [1:0] dcc_derr_way;		// indicate which way detected parity error
wire dcc_dmiss_m;		// Data ref. missed
wire dcc_dspram_stall;
wire [19:2] dcc_dval_m;		// Lower bits of PA for ICOp
wire dcc_dvastrobe;		// Data Virtual Address strobe for EJTAG
wire [31:0] dcc_ejdata;		// Read or Write value for EJTAG data match
wire dcc_ev;		// Eviction taking place
wire dcc_ev_kill;		// Kill entire line of eviction
wire [31:2] dcc_exaddr;		// Addr for D$ miss, write,  or uncached D ref
wire [31:2] dcc_exaddr_ev;		// Addr for eviction
wire dcc_exaddr_sel;		// Select address to use
wire [3:0] dcc_exbe;		// Byte Enables for Write
wire dcc_exc_nokill_m;		// atomic load is already in fixup w stage
wire dcc_excached;		// D Request is cacheable
wire [31:0] dcc_exdata;		// Write Data
wire dcc_exmagicl;		// D Request is to Probe Space
wire dcc_exnewaddr;		// Valid L/S/P/$ instn in M-stage
wire dcc_exrdreqval;		// D Request is valid
wire dcc_exsyncreq;		// Sync request
wire dcc_exwrreqval;		// D Request is valid
wire dcc_fixup_w;		// Fixup W-stage for dcc
wire dcc_g_intkill_w;		// Interrupt killed W-stage L/S instn
wire dcc_intkill_m;		// M-stage op is being killed by interrupt
wire dcc_intkill_w;		// dcc_dmiss_m is going away because of interrupt
wire dcc_lddatastr_w;		// EJTAG Data strobe for dcc_ejdata
wire dcc_ldst_m;		// Data is Load (1) or Store (0)
wire dcc_lscacheread_m;		// cacheread includes tag/data/way
wire dcc_mbdone;		// D$ MBIST done
wire dcc_newdaddr;
wire dcc_par_kill_mw;
wire dcc_parerr_cpz_w;		// parity error detected at W stage for cpz update
wire dcc_parerr_data;		// parity error detected at data ram
wire dcc_parerr_ev;		// parity error detected on eviction
wire [19:0] dcc_parerr_idx;
wire dcc_parerr_m;		// parity error detected at M stage
wire dcc_parerr_tag;		// parity error detected at tag ram
wire dcc_parerr_w;		// parity error detected at W stage
wire dcc_parerr_ws;		// parity error detected at WS ram
wire dcc_pm_dcmiss_pc;		// Perf. monitor D$ miss
wire dcc_pm_dhit_m;		// pm data ref. hit
wire dcc_pm_fb_active;
wire dcc_pm_fbfull;
wire dcc_precisedbe_w;		// Precise DBE on W-stage instn
wire dcc_sc_ack_m;
wire dcc_sp_pres;		// DSPRAM is present
wire dcc_spmbdone;		// DSPRAM MBIST done
wire dcc_spram_write;
wire dcc_stall_m;		// Force M-stage stall (spram stall)
wire dcc_stalloc;		// Write allocate, don't flush the WTB
wire dcc_stdstrobe;		// Store data ready to be checked
wire dcc_store_allocate;		// Control output to CP2
wire dcc_uncache_load;
wire dcc_uncached_store;
wire dcc_valid_d_access;
wire dcc_wb;
wire [2:0] dexc_type;		// Encoded values for debug exceptions
wire dmbinvoke;		// Invoke D Memory BIST
wire dsp_data_parerr;		// parity error detected on DSPRAM
wire [31:0] edp_abus_e;		// SrcA bus (rs)
wire [31:0] edp_alu_m;		// ALU result bus -> cpz write data
wire [31:0] edp_bbus_e;
wire [31:0] edp_cacheiva_i;		// cache iva
wire [31:0] edp_cacheiva_p;
wire edp_cndeq_e;		// Result of Equality compare
wire edp_dsp_add_e;		// Add instruction from DSP
wire edp_dsp_alu_sat_xx;
wire edp_dsp_dspc_ou_wren_e;
wire edp_dsp_mdu_valid_e;
wire edp_dsp_modsub_e;
wire edp_dsp_pos_ge32_e;
wire [5:0] edp_dsp_pos_r_m;
wire edp_dsp_present_xx;
wire edp_dsp_stallreq_e;
wire edp_dsp_sub_e;		// Sub instruction from DSP
wire edp_dsp_valid_e;
wire [31:0] edp_dva_e;		// Data virtual address
wire [31:29] edp_dva_mapped_e;		// Data virtual address mapped
wire edp_eisa_e;		// Exception ISA mode - E-stage
wire [31:0] edp_epc_e;		// Exception PC - E-stage
wire [31:0] edp_iva_i;		// Instruction Virtual Address - I-stage
wire [31:0] edp_iva_p;		// Next instr. virtual address, feeding the local iva_trans fast path register
wire [31:0] edp_ldcpdata_w;		//Load data for HW auto epilogue
wire edp_povf_m;		// Addition overflow
wire [31:0] edp_res_w;
wire [1:0] edp_stalign_byteoffset_e;		// Data virtual address[1:0] used for store align byte
wire [31:0] edp_stdata_iap_m;		// Store Data mux with interrupt auto prologue store
wire [31:0] edp_stdata_m;		// Store Data
wire edp_trapeq_m;		// Trap Equality
wire edp_udi_honor_cee;		// Look at CEE bit
wire edp_udi_present;		// UDI block is implemented
wire edp_udi_ri_e;		// UDI reserved instn indication
wire edp_udi_stall_m;		// Stall for UDI result
wire [4:0] edp_udi_wrreg_e;		// UDI destination register
wire [31:0] edp_wrdata_w;		// regfile write data
wire ej_fdc_busy_xx;		// Wakeup to transfer fast debug channel data
wire ej_fdc_int;		// Int req from fdc
wire ej_isaondebug_read;
wire ej_probtrap;		// EJTAG exceptions should go to Probe
wire ej_rdvec;
wire [31:0] ej_rdvec_read;		// DebugVectorAddr
wire ejt_cbrk_m;		// EJTAG complex break
wire [6:0] ejt_cbrk_type_m;		// Complex break exception type
wire ejt_dbrk_m;		// EJTAG Data breakpoint
wire ejt_dbrk_w;		// EJTAG Data breakpoint
wire ejt_dcrinte;		// IntE bit from DCR
wire ejt_dcrnmie;		// NMIE bit from DCR
wire ejt_disableprobedebug;		// disable ejtag mem space
wire ejt_dvabrk;		// EJTAG DVA breakpoint
wire [31:0] ejt_eadata;		// EJTAG Area data input	
wire ejt_eadone;		// EJTAG Area transaction done
wire ejt_ejtagbrk;		// EjtagBrk indication
wire ejt_ivabrk;		// EJTAG IVA breakpoint
wire ejt_pdt_fifo_empty;		// OK to gate off gclk in clock_gate
wire [1:0] ejt_pdt_present;		// PDTrace module is implemented. 01 : PDT/TCB, 10 : IPDT/ITCB
wire ejt_pdt_stall_w;		// Stall in W stage
wire ejt_predonenxt;
wire ejt_stall_st_e;		// Indicates simple break needs to check load data
wire fdc_present;		// FDC is implemented
wire [31:0] fdc_rdata_nxt;
wire gfclk;		// Free running clock
wire gopt;
wire grfclk;		// gated clock on cache miss
wire gtlbclk;		// gated clock on D-cache miss
wire [1:0] icc_addiupc_22_21_e;
wire [1:0] icc_derr_way;		// indicate which way detected parity error
wire icc_dspver_i;		// identify dsp version of mf/mt/hi/lo/madd/u/msub/u/mult/u
wire [31:2] icc_exaddr;		// Addr for I$ miss or uncached I
wire icc_excached;		// I Request is cacheable
wire [1:0] icc_exhe;		// Half enables for read request
wire icc_exmagicl;		// I Request is to Probe Space
wire icc_exreqval;		// I Request is valid
wire [3:0] icc_fb_vld;
wire icc_halfworddethigh_fifo_i;		// instn in fifo is 16b
wire icc_halfworddethigh_i;		// high half instn is 16b
wire [31:0] icc_icopdata;		// Cacheop data result from cache			
wire icc_icopld;		// Load Tag/Data in cpz_taglo/DataLo
wire [3:0] icc_icoppar;		// Cacheop Parity bits to be stored to ErrCtl register for idx_ld
wire icc_icopstall;		// I$op is not done (stall W)
wire [25:0] icc_icoptag;		// Cacheop Tag Value (includes 1'b0 for dirty bit)
wire [31:0] icc_idata_i;		// Instn bus to core					
wire icc_imiss_i;		// Instn ref. missed
wire icc_isachange0_i_reg;		//isa change speed fix
wire icc_isachange1_i_reg;		//isa change speed fix
wire icc_macro_e;		// executing macro
wire icc_macro_jr;		// executing macro jump
wire icc_macrobds_e;		// macro form of bds
wire icc_macroend_e;
wire icc_mbdone;		// I$ MBIST done
wire icc_nobds_e;		// jump has no bds
wire icc_parerr_cpz_w;		// parity error detected at W stage for cpz update
wire icc_parerr_data;		// parity error detected on data ram
wire icc_parerr_i;		// parity error detected at I stage
wire [19:0] icc_parerr_idx;
wire icc_parerr_tag;		// parity error detected on tag ram
wire icc_parerr_w;		// parity error detected at W stage
wire icc_parerrint_i;		// parity error on i-stage
wire icc_pcrel_e;		// PC relative instn
wire icc_pm_icmiss;		// Perf. monitor $ miss
wire icc_poten_be;
wire icc_preciseibe_e;		// E-stage instn being killed by IBE
wire icc_preciseibe_i;		// I-stage instn being killed by IBE
wire [22:0] icc_predec_i;		//Native umips decoder only
wire icc_rdpgpr_i;		// Early decode for SRS selection for RDPGPR instruction
wire icc_slip_n_nhalf;		// early prepared version for imm PC detection
wire icc_sp_pres;		// ISPRAM is present
wire icc_spmbdone;		// ISPRAM MBIST done
wire icc_spram_stall;		// ispram stall
wire icc_stall_i;		// Stall in i-stage (for SPRAM)
wire icc_umips_16bit_needed;
wire [31:0] icc_umips_instn_i;
wire icc_umips_sds;		// short delay slot
wire [1:0] icc_umipsconfig;		// umips positioning	
wire icc_umipsfifo_ieip2;		// incr. PC by 2
wire icc_umipsfifo_ieip4;		// incr. PC by 4
wire icc_umipsfifo_imip;		// incr. memory counter
wire icc_umipsfifo_null_i;		// instn. slip
wire icc_umipsfifo_null_w;		// instn slip propagated to w-stage
wire [3:0] icc_umipsfifo_stat;		// fifo fullness
wire icc_umipsmode_i;		// umips in i-stage + interrupt cases
wire icc_umipspresent;		// UMIPS implemented
wire icc_umipsri_e;		// micromips ri
wire isp_data_parerr;		// parity error detected on ISPRA
wire jtlb_wr;
wire mdu_alive_gpr_a;
wire mdu_alive_gpr_m1;
wire mdu_alive_gpr_m2;
wire mdu_alive_gpr_m3;
wire mdu_busy;		//for performance counter
wire [4:0] mdu_dest_m1;
wire [4:0] mdu_dest_m2;
wire [4:0] mdu_dest_m3;
wire [4:0] mdu_dest_w;
wire mdu_mf_a;
wire mdu_mf_m1;
wire mdu_mf_m2;
wire mdu_mf_m3;
wire mdu_nullify_m2;
wire [31:0] mdu_res_w;
wire mdu_result_done;
wire mdu_rfwrite_w;
wire mdu_stall;		// MDU stall
wire mdu_stall_issue_xx;
wire mdu_type;		// MDU type: 1->Lite, 0->Full - Static
wire mmu_adrerr;		// TransExc was Address error
wire mmu_asid_valid;
wire mmu_cdmm_kuc_m;
wire [2:0] mmu_dcmode;		// Cache mode: 001=UC 011=magic 
wire [`M14K_PAH] mmu_dpah;		// Data Physical Address High
wire mmu_dtexc_m;		// data reference translation error
wire mmu_dtmack_m;		// ITLB Miss
wire mmu_dtriexc_m;		// D-addr RI exception
wire [31:0] mmu_dva_m;		// M-stage version of Data Virtual Address
wire [31:29] mmu_dva_mapped_m;		// M-stage version of Data Virtual Address mapped
wire [`M14K_GID] mmu_gid;
wire mmu_icacabl;		// i$ CCA
wire mmu_iec;		// enable unique ri/xi exception code
wire mmu_imagicl;		// Reference to Probe Space
wire [`M14K_PAH] mmu_ipah;		// Instruction Physical Address High
wire mmu_itexc_i;		// instruction reference translation error
wire mmu_itmack_i;		// ITLB Miss
wire mmu_itmres_nxt_i;		// ITLB Miss resolving next cycle
wire mmu_itxiexc_i;		// itlb execution inhibit exception
wire mmu_ivastrobe;		// Strobe new Fetch PC into EJTAG
wire mmu_pm_dthit;		// DTLB hit performance monitoring signal
wire mmu_pm_dtlb_miss_qual;
wire mmu_pm_dtmiss;		// DTLB miss performance monitoring signal
wire mmu_pm_ithit;		// ITLB hit performance monitoring signal
wire mmu_pm_itmiss;		// ITLB miss performance monitoring signal
wire mmu_pm_jthit;		// JITLB hit performance monitoring signal
wire mmu_pm_jthit_d;
wire mmu_pm_jthit_i;
wire mmu_pm_jtmiss;		// JITLB miss performance monitoring signal
wire mmu_pm_jtmiss_d;
wire mmu_pm_jtmiss_i;
wire mmu_r_adrerr;		// TransExc was Address error
wire mmu_r_asid_valid;
wire mmu_r_dtexc_m;		// data reference translation error
wire mmu_r_dtriexc_m;		// D-addr RI exception
wire mmu_r_iec;		// enable unique ri/xi exception code
wire mmu_r_itexc_i;		// instruction reference translation error
wire mmu_r_itxiexc_i;		// itlb execution inhibit exception
wire mmu_r_pm_jthit_d;
wire mmu_r_pm_jthit_i;
wire mmu_r_pm_jtmiss_d;
wire mmu_r_pm_jtmiss_i;
wire mmu_r_rawdtexc_m;		// Raw translation exception (includes PREFS)
wire mmu_r_rawitexc_i;		// Raw ITranslation exception
wire mmu_r_read_m;
wire mmu_r_tlbbusy;		// TLB is in midst of multi-cycle operation
wire mmu_r_tlbinv;		// TLB Invalid exception
wire mmu_r_tlbmod;		// TLB modified exception
wire mmu_r_tlbrefill;		// TLB Refill exception
wire mmu_r_vafromi;		// Use ITLBH instead of JTLBH to load CP0 regs
wire mmu_rawdtexc_m;		// Raw translation exception (includes PREFS)
wire mmu_rawitexc_i;		// Raw ITranslation exception
wire mmu_read_m;
wire [`M14K_GID] mmu_rid;
wire mmu_tlbbusy;		// TLB is in midst of multi-cycle operation
wire mmu_tlbinv;		// TLB Invalid exception
wire mmu_tlbmod;		// TLB modified exception
wire mmu_tlbrefill;		// TLB Refill exception
wire mmu_vafromi;		// Use ITLBH instead of JTLBH to load CP0 regs
wire [`M14K_VPN2RANGE] mmu_vat_hi;
wire mpc_abs_e;		// umips operand swapped
wire mpc_addui_e;		// Add Upper Immediate
wire mpc_alu_w;
wire mpc_aluasrc_e;		// A Source for ALU - 0:edp_abus_e 1:BBusOrImm
wire mpc_alubsrc_e;		// B Source for ALU - 0:edp_abus_e 1:BBusOrImm
wire [1:0] mpc_alufunc_e;		// ALU Function - 00:and 01:or 10:xor 11:nor
wire mpc_alusel_m;		// Select ALU
wire mpc_annulds_e;		// Annulled Delay Slot in E-stage
wire mpc_apcsel_e;		// Select PC as src A
wire mpc_append_e;
wire mpc_append_m;
wire mpc_aselres_e;		// Bypass res_m as src A
wire mpc_aselwr_e;		// Bypass res_w as src A
wire mpc_atepi_m;		// auto-epilogue in M-stage
wire mpc_atepi_w;		// auto-epilogue in W-stage
wire [2:0] mpc_atomic_bit_dest_w;		// which bit set/clr by atomic instn
wire mpc_atomic_clrorset_w;		// set or clear by atomic bit operation
wire mpc_atomic_e;		//Atomic enable 
wire mpc_atomic_impr;		// atomic lead imprecise data breakpoint 
wire mpc_atomic_load_e;
wire mpc_atomic_m;		// Atomic instruction entered into M stage for load
wire mpc_atomic_store_w;		// Atomic instruction in store operation
wire mpc_atomic_w;		// Atomic instruction entered into W stage for store 
wire mpc_atpro_w;		// auto-prologue in W-stage
wire mpc_auexc_on;
wire mpc_auexc_x;		// Exception has reached end of pipe, redirect fetch
wire mpc_badins_type;
wire mpc_balign_e;
wire mpc_balign_m;
wire mpc_bds_m;		// Instn in M-stage has branch delay slot
wire [3:0] mpc_be_w;		// Byte enables for L/S
wire mpc_br16_e;		// UMIPS branch
wire mpc_br32_e;		// MIPS32 branch
wire mpc_br_e;		// branch in e-stage
wire mpc_brrun_ie;		// Stage I,E  is moving to next stage. 
wire mpc_bselall_e;		// Bypass res_w as src B
wire mpc_bselres_e;		// Bypass res_m as src B
wire mpc_bsign_w;		// Sign extend to fill byte B
wire mpc_bubble_e;		// stalls e-stage due to arithmetic/deadlock/return data reasons
wire [31:0] mpc_buf_epc;		// EPC saved to stack during HW sequence
wire [31:0] mpc_buf_srsctl;		// SRSCTL saved to stack during HW sequence
wire [31:0] mpc_buf_status;		// Status saved to stack during HW sequence
wire [1:0] mpc_bussize_m;		// load/store data size 
wire [2:0] mpc_busty_e;		// Bus operation type - 0-nil, 1-load, 2-store, 3-pref, 4-sync, 5-ICacheOp, 6-DCacheOp
wire [2:0] mpc_busty_m;		// Bus operation type - 0-nil, 1-load, 2-store, 3-pref, 4-sync, 5-ICacheOp, 6-DCacheOp
wire [2:0] mpc_busty_raw_e;		// Bus operation type not qualified with exc_e or dcc_dmiss_m
wire mpc_cbstrobe_w;		// ejtag complex break strobe - not strobed on exception
wire mpc_cdsign_w;		// Sign extend to fill upper half 
wire mpc_cfc1_fr_m;
wire mpc_chain_hold;
wire mpc_chain_strobe;		//tail chain happen strobe
wire mpc_chain_take;		// tail chain happened
wire mpc_chain_vec;		// hold tail chain jump
wire mpc_cleard_strobe;		// Clear EJTAG Dbits
wire mpc_clinvert_e;		// Count leading 1s
wire mpc_clsel_e;		// Select CL output
wire mpc_clvl_e;		// Count extension
wire mpc_cmov_e;		// conditional move
wire mpc_cnvt_e;		// Convert/Swap Operations: SEB/SEH/WSBH
wire mpc_cnvts_e;		// Convert signextension operations: SEB/SEH
wire mpc_cnvtsh_e;		// Convert signextension operations: SEH
wire mpc_compact_e;		// Compact branch instruction
wire mpc_cont_pf_phase1;		// continue phase1 of interrupt prefetch
wire mpc_continue_squash_i;
wire mpc_cop_e;		// instn is a cache op
wire [3:0] mpc_coptype_m;		// CacheOp type: Raw bits from Instn
wire mpc_cp0diei_m;		// DI/EI
wire [5:0] mpc_cp0func_e;		// cop0 function field
wire mpc_cp0move_m;		// MT/MF C0
wire [4:0] mpc_cp0r_m;		// coprocessor zero register specifier
wire mpc_cp0sc_m;		// set/clear bit in C0
wire [2:0] mpc_cp0sr_m;		// coprocessor zero shadow register specifier
wire mpc_cp1exc;		// cp1 exc was taken
wire mpc_cp2a_e;
wire mpc_cp2exc;		// cp2 exc was taken
wire mpc_cp2tf_e;
wire [1:0] mpc_cpnm_e;		// coprocessor number
wire mpc_ctc1_fr0_m;
wire mpc_ctc1_fr1_m;
wire mpc_ctl_dsp_valid_m;
wire mpc_ctlen_noe_e;		// Early enable signal, not qualified with exc_e
wire mpc_dcba_w;		// Select all bytes from D$
wire [15:0] mpc_dec_imm_apipe_sh_e;
wire mpc_dec_imm_rsimm_e;
wire mpc_dec_insv_e;
wire [3:0] mpc_dec_logic_func_e;
wire [3:0] mpc_dec_logic_func_m;
wire mpc_dec_nop_w;
wire mpc_dec_rt_bsel_e;
wire mpc_dec_rt_csel_e;
wire [4:0] mpc_dec_sh_high_index_e;
wire [4:0] mpc_dec_sh_high_index_m;
wire mpc_dec_sh_high_sel_e;
wire mpc_dec_sh_high_sel_m;
wire mpc_dec_sh_low_index_4_e;
wire mpc_dec_sh_low_index_4_m;
wire mpc_dec_sh_low_sel_e;
wire mpc_dec_sh_low_sel_m;
wire mpc_dec_sh_shright_e;
wire mpc_dec_sh_shright_m;
wire mpc_dec_sh_subst_ctl_e;
wire mpc_dec_sh_subst_ctl_m;
wire mpc_defivasel_e;		// Use PC+2/4 as next PC
wire mpc_deret_m;		// DERet instn
wire mpc_deretval_e;		// DERet instn
wire [4:0] mpc_dest_e;
wire [8:0] mpc_dest_w;		// destination register (phase one WRB)
wire mpc_dis_int_e;		//disable interrupt in E-stage
wire mpc_dmsquash_m;		// Kill D$ miss due to M-stage exceptions.
wire mpc_dmsquash_w;		// Kill D$ Miss if Fixup instn is killable
wire mpc_dparerr_for_eviction;		// t_dperr
wire [22:0] mpc_dspinfo_e;
wire mpc_ebexc_w;		// ebase exception in w stage
wire mpc_ebld_e;		// ebase write in e stage
wire mpc_eexc_e;		// early exceptions detected in E-stage
wire mpc_ekillmd_m;		// Early Kill MDU instn
wire mpc_epi_vec;		// hold pc during auto epilogue until normal return or jump to next interrupt
wire mpc_eqcond_e;		// Branch condition met
wire mpc_eret_m;		// ERet instn
wire mpc_eretval_e;		// ERet instn
wire [7:0] mpc_evecsel;		// Exception Vector Selection bits
wire mpc_exc_e;		// E-stage killed by exception
wire mpc_exc_iae;		// exceptions happened during IAE
wire mpc_exc_m;		// M-stage killed by exception 
wire mpc_exc_type_w;
wire mpc_exc_w;		// W-stage killed by exception 
wire mpc_exc_w_org;		// W-stage killed by exception 
wire [4:0] mpc_exccode;		// cause PLA to encode exceptions into a 5 bit field
wire mpc_excisamode_i;		// changing isa when isa is not available
wire mpc_expect_isa;
wire mpc_ext_e;		// EXT instruction
wire mpc_first_det_int;		// first cycle interrupt detected
wire mpc_fixup_m;		// D$ Miss previous cycle
wire mpc_fixupd;		// D$ Miss previous cycle
wire mpc_fixupi;		// I$ Miss previous cycle
wire mpc_fixupi_wascall;		// I$ Miss previous cycle
wire mpc_g_auexc_x;		// Exception has reached end of pipe, redirect fetch
wire mpc_g_auexc_x_qual;
wire [5:0] mpc_g_cp0func_e;
wire mpc_g_cp0move_m;		// MT/F C0
wire mpc_g_eexc_e;
wire mpc_g_exc_e;
wire mpc_g_int_pf;
wire mpc_g_jamepc_w;		// load EPC register from EPC timing chain
wire mpc_g_jamtlb_w;		// load translation registers from shadow values
wire mpc_g_ld_causeap;
wire mpc_g_ldcause;
wire mpc_ge_exc;
wire [4:0] mpc_gexccode;		// cause PLA to encode exceptions into a 5 bit field
wire mpc_gpsi_perfcnt;
wire mpc_hold_epi_vec;		// register version of mpc_epi_vec
wire mpc_hold_hwintn;		// Hold hwint pins until exception taken
wire mpc_hold_int_pref_phase1_val;
wire mpc_hw_load_done;		// HW load operation done
wire mpc_hw_load_e;		//HW load epc or srsctl in E-stage
wire mpc_hw_load_epc_e;		// E-stage HW load EPC operation
wire mpc_hw_load_epc_m;		// M-stage HW load EPC operation
wire mpc_hw_load_srsctl_e;		// E-stage HW load SRSCTL operation
wire mpc_hw_load_srsctl_m;		// M-stage HW load SRSCTL operation
wire mpc_hw_load_status_e;		// E-stage HW load Status operation
wire mpc_hw_ls_e;
wire mpc_hw_ls_i;		// HW operation in I-stage
wire mpc_hw_save_done;		// HW sequence done
wire mpc_hw_save_epc_e;		// E-stage HW save EPC operation
wire mpc_hw_save_epc_m;		// M-stage HW save EPC operation
wire mpc_hw_save_srsctl_e;		// E-stage HW save SRSCTL operation
wire mpc_hw_save_srsctl_i;		//select HW save operation for icc_idata_i
wire mpc_hw_save_srsctl_m;		// M-stage HW save SRSCTL operation
wire mpc_hw_save_status_e;		// E-stage HW save Status operation
wire mpc_hw_save_status_m;		// M-stage HW save Status operation
wire [31:0] mpc_hw_sp;		// sp saved to GPR during HW sequence
wire mpc_iae_done_exc;		// HW load done due to exception
wire mpc_ibrk_qual;		// ibrk exception
wire mpc_iccop_m;		// I-side cache op
wire mpc_icop_m;		// I-side cache op
wire mpc_idx_cop_e;
wire mpc_imsgn_e;		// Sign of the Immediate field
wire mpc_imsquash_e;		// Kill I$ Miss due to E-stage exceptions
wire mpc_imsquash_i;		// Kill I$ miss due to I-stage exceptions.
wire mpc_insext_e;		// INS/EXT instruction
wire [4:0] mpc_insext_size_e;		// INS/EXT filed size
wire mpc_int_pf_phase1_reg;		//reg version of phase1 of interrupt prefetch
wire mpc_int_pref;		//PC held for interrupt vector prefetch during pipeline flush or auto-prologue seqence
wire mpc_int_pref_phase1;		//phase1 of interrupt prefetch
wire [31:0] mpc_ir_e;		// Instruction register
wire mpc_iret_m;		// M-stage IRET instruction done
wire mpc_iret_ret;		// PC redirect due to IRET return
wire mpc_iret_ret_start;		// start cycle of mpc_iret_ret
wire mpc_ireton_e;
wire mpc_iretval_e;		// E-stage IRET instruction
wire mpc_irval_e;		// Instn register is valid
wire mpc_irval_m;		// Instn register is valid
wire mpc_irval_w;		// Instn register is valid
wire mpc_isachange0_i;		// Indicates isa change happening during abnormal pipeline process
wire mpc_isachange1_i;		// Indicates isa change happening during abnormal pipeline process
wire mpc_isamode_e;		// E-stage instn is UMIPS
wire mpc_isamode_i;		// I-stage instn is UMIPS
wire mpc_isamode_m;		// M-stage isntn is UMIPS
wire mpc_itqualcond_i;		// itlb exception
wire mpc_ivaval_i;		// Instn VA is valid
wire mpc_jalx_e;		// JALX instn
wire mpc_jamdepc_w;		// load DEPC register from EPC timing chain
wire mpc_jamepc_w;		// load EPC register from EPC timing chain
wire mpc_jamerror_w;		// load ErrorPC register from EPC timing chain
wire mpc_jamtlb_w;		// load translation registers from shadow values
wire mpc_jimm_e;		// jump or jump & link
wire mpc_jimm_e_fc;
wire mpc_jreg31_e;
wire mpc_jreg31non_e;
wire mpc_jreg_e;
wire mpc_jreg_e_jalr;
wire mpc_killcp1_w;		// Kill cp1 instn
wire mpc_killcp2_w;		// Kill cp2 instn
wire mpc_killmd_m;		// Kill MDU instn
wire mpc_ld_causeap;		//load Cause.AP when detect exception during auto prologue
wire mpc_ld_m;
wire [1:0] mpc_lda15_8sel_w;		// Mux select of ld_algn_w[15:8]
wire [1:0] mpc_lda23_16sel_w;		// Mux select of ld_algn_w[23:16]
wire [1:0] mpc_lda31_24sel_w;		// Mux select of ld_algn_w[31:24]
wire [1:0] mpc_lda7_0sel_w;		// Mux select of ld_algn_w[7:7]
wire mpc_ldc1_m;
wire mpc_ldc1_w;
wire mpc_ldcause;		// load cause register for exception
wire mpc_ldst_e;
wire mpc_ll1_m;		// Load linked in first clock of M
wire mpc_ll_e;		// Load linked in E
wire mpc_ll_m;		// Load linked in M
wire mpc_lnksel_e;		// Select Link address
wire mpc_lnksel_m;		// Select pc_hold for JAL/BAL/JALR
wire mpc_load_m;		// Load or MFC0
wire mpc_load_status_done;		//HW load status is done
wire [3:0] mpc_lsbe_m;		// Byte enables for L/S
wire mpc_lsdc1_e;
wire mpc_lsdc1_m;
wire mpc_lsdc1_w;
wire mpc_lsuxc1_e;
wire mpc_lsuxc1_m;
wire mpc_ltu_e;		// stall due to load-to-use. (for loads only)
wire mpc_lxs_e;		// Load index scaled
wire mpc_macro_e;		// macros in native umips
wire mpc_macro_end_e;		// macro end
wire mpc_macro_m;
wire mpc_macro_w;
wire mpc_mcp0stall_e;		// stall due to cp0 return data.
wire mpc_mdu_m;
wire mpc_mf_m2_w;
wire mpc_movci_e;
wire mpc_mpustrobe_w;		// mpu region access strobe
wire mpc_mputake_w;		// MPU exception being taken
wire mpc_mputriggeredres_i;
wire mpc_muldiv_w;		// MDU op in W-stage
wire mpc_ndauexc_x;		// performance counter signal. not-debug-mode exception
wire mpc_newiaddr;		// New Instn Address
wire mpc_nmitaken;		// biu_nmi exception is being taken
wire mpc_nobds_e;		// This instruction has no delay slot
wire mpc_nonseq_e;		// nonsequential instn stream
wire mpc_nonseq_ep;		// nonsequential pulse
wire mpc_noseq_16bit_w;		// The instruction in W stage is 16bit size
wire mpc_nullify_e;
wire mpc_nullify_m;
wire mpc_nullify_w;
wire mpc_pcrel_e;		// PC relative instn
wire mpc_pcrel_m;		// PC relative instn in M stage
wire mpc_pdstrobe_w;		// Instn Valid in W
wire mpc_penddbe;		// DBE is pending
wire mpc_pendibe;		// IBE is pending
wire mpc_pexc_e;		// prior exception
wire mpc_pexc_i;		// prior exception
wire mpc_pexc_m;		// prior exception
wire mpc_pexc_w;		// prior exception
wire mpc_pf_phase2_done;		//phase2 of prefetch is done
wire mpc_pm_complete;		// Instn. successfully completed
wire mpc_pm_muldiv_e;		// Multiply/Divide (excludes mflo and xf2 instns)
wire mpc_prealu_cond_e;		//  cregister condition for edp.prealu_e->m
wire [22:0] mpc_predec_e;		// predecoded instructions propagated to e-stage
wire mpc_pref_m;
wire mpc_pref_w;
wire mpc_prepend_e;
wire mpc_prepend_m;
wire mpc_qual_auexc_x;		// final cycle of mpc_auexc_x
wire mpc_r_auexc_x;		// Exception has reached end of pipe, redirect fetch
wire mpc_r_auexc_x_qual;
wire mpc_rdhwr_m;
wire mpc_rega_cond_i;		// condition for rs field of instruction
wire [8:0] mpc_rega_i;		// rs field of instruction
wire mpc_regb_cond_i;		// condition for rt field of instruction
wire [8:0] mpc_regb_i;		// rt field of instruction
wire mpc_ret_e;		// ERet or DERet instn
wire mpc_ret_e_ndg;		// IRET or ERET is valid in E stage
wire mpc_rfwrite_w;		// Reg. File write enable
wire mpc_run_i;		// I-stage Run (used for exc processing)
wire mpc_run_ie;		// E-stage Run
wire mpc_run_m;		// M-stage Run
wire mpc_run_w;		// W-stage Run
wire mpc_sbdstrobe_w;		// ejtag simple break strobe for d channels
wire mpc_sbstrobe_w;		// ejtag simple break strobe
wire mpc_sbtake_w;		// Simple Break exception is being taken
wire mpc_sc_e;		// Store Conditional in E
wire mpc_sc_m;		// Store Conditional in M
wire mpc_scop1_m;
wire mpc_sdbreak_w;		// ejtag SB D-break taken (kill store)
wire mpc_sdc1_w;
wire mpc_sds_e;		// short delay slot instn in native umips
wire mpc_sel_hw_e;		// select HW operation
wire mpc_selcp0_m;		// Select Cp0 read data (MFC0 or SC)
wire mpc_selcp1from_m;		// Select Cp1 To data
wire mpc_selcp1from_w;		// Select Cp1 From data
wire mpc_selcp1to_m;		// Select Cp1 To data
wire mpc_selcp2from_m;		// Select Cp2 To data
wire mpc_selcp2from_w;		// Select Cp2 From data
wire mpc_selcp2to_m;		// Select Cp2 To data
wire mpc_selcp_m;		// Select Cp0 read data or Cp2 To data 
wire mpc_selimm_e;		// Select immediate value for srcB
wire mpc_sellogic_m;		// Select Logic Function output
wire mpc_selrot_e;		// Select rotate instead of shift
wire mpc_sequential_e;		// Next PC is sequential
wire [4:0] mpc_shamt_e;		// 1st stage shift amount
wire mpc_sharith_e;		// Shift arithmetic
wire mpc_shf_rot_cond_e;		// cregister condition for edp.shf_rot_e->m
wire mpc_shright_e;		// Shift is to the right
wire mpc_shvar_e;		// instn is shift variable 
wire mpc_signa_w;		// Use sign bit of byte A
wire mpc_signb_w;		// Use sign bit of byte B
wire mpc_signc_w;		// Use sign bit of byte C
wire mpc_signd_w;		// Use sign bit of byte D
wire mpc_signed_m;		// This is a signed operation
wire mpc_squash_e;		//Squash E-stage exception
wire mpc_squash_i;		// Squash the instn in _I by faking an Exception
wire mpc_squash_m;		// Instn in M was squashed
wire mpc_srcvld_e;		// Src registers are valid (for MDU)
wire mpc_st_m;
wire mpc_stall_ie;
wire mpc_stall_m;
wire mpc_stall_w;
wire [6:0] mpc_stkdec_in_bytes;
wire mpc_strobe_e;
wire mpc_strobe_m;
wire mpc_strobe_w;
wire mpc_subtract_e;		// Force AGEN to do A-B
wire mpc_swaph_e;		// Swap operations: WSBH
wire mpc_tail_chain_1st_seen;		// The instruction in W stage is IRET itself only for tailchain
wire mpc_tint;		//interrupt is taken
wire mpc_tlb_d_side;
wire mpc_tlb_exc_type;		// i stage exception type
wire mpc_tlb_i_side;
wire mpc_trace_iap_iae_e;		// iap and iae in E stage,data breakpoint could be traced out
wire mpc_udisel_m;		// Select the result of UDI in M stage
wire mpc_udislt_sel_m;		// Select UDI or SLT
wire mpc_umips_defivasel_e;
wire mpc_umips_mirrordefivasel_e;
wire mpc_umipsfifosupport_i;		// Indicates fifo is ready and we do not stall on i-cache miss. not available in umips recoder
wire mpc_umipspresent;		// Indicates a native micromips decoder
wire mpc_updateepc_e;		// Capture a new EPC for the E-stage instn
wire mpc_updateldcp_m;		// Capture Load or CP0 data
wire mpc_usesrca_e;		// Instn in _E uses the srcB (rt) register
wire mpc_usesrcb_e;		// Instn in _E uses the srcA (rs) register
wire mpc_vd_m;
wire mpc_wait_m;		// Cp0 wait operation
wire mpc_wait_w;		// Cp0 wait operation
wire mpc_wr_guestctl0_m;
wire mpc_wr_guestctl2_m;
wire mpc_wr_intctl_m;
wire mpc_wr_sp2gpr;		// write stobe to update sp to GPR during HW sequence
wire mpc_wr_status_m;
wire mpc_wr_view_ipl_m;		// write view_ipl register
wire mpc_wrdsp_e;
wire pc0_ctl_ec1;		//CX: if 0, generate GPSI on guest access PC0 register
wire pc1_ctl_ec1;		//CX: if 0, generate GPSI on guest access PC1 register
wire [`M14K_BUS] pdtrace_cpzout;		// Read data for MFC0 register updates
wire pdva_load;		//indicate valid load data is in W stage;
wire qual_iparerr_i;		// Qualified I$ parity exception
wire qual_iparerr_w;		// Qualified I$ parity exception
wire r_asid_update;		// enhi register updated
wire r_gtlbclk;		// gated clock on D-cache miss
wire r_jtlb_wr;
wire [31:0] rf_adt_e;		// regfile A read port
wire [31:0] rf_bdt_e;		// regfile B read port
wire rf_init_done;
wire siu_bigend;		// Number bytes starting from the big end of the word
wire siu_bootexcisamode;		// external signal set isa mode for interrupt,exception,boot
wire siu_coldreset;		// coldreset
wire [9:0] siu_cpunum;		// EBase CPU number
wire [`M14K_GID] siu_eicgid;
wire siu_eicpresent;		// External Interrupt cpntroller present
wire [5:0] siu_eicvector;		// registered vector pins
wire [3:0] siu_eiss;		// Shadow set, comes with the requested interrupt
wire [5:0] siu_g_eicvector;		// registered vector pins
wire [3:0] siu_g_eiss;		// Shadow set, comes with the requested interrupt
wire [7:0] siu_g_int;		// registered interrupt pins
wire [17:1] siu_g_offset;		// registered offset pins
wire [2:0] siu_ifdci;		// FDCInt connection
wire [7:0] siu_int;		// registered interrupt pins
wire [2:0] siu_ippci;		//PCInt connection
wire [2:0] siu_ipti;		// TimerInt connection
wire siu_nmi;		// Non-maskable interrupt
wire [17:1] siu_offset;		// registered offset pins
wire siu_slip;		// External signal to inject security slip
wire [3:0] siu_srsdisable;		// Disable banks of shadow sets
wire siu_tracedisable;		// Disables trace hardware
wire x3_trig;
/* End of hookup wire declarations */

output cpz_mnan;      // Address of inst in W
output [15:0] cpz_prid16;

input CP2_abusy_0;
output CP2_as_0;
input CP2_ccc_0;
input CP2_cccs_0;
output CP2_endian_0;
input CP2_exc_0;
input [4:0] CP2_exccode_0;
input CP2_excs_0;
input CP2_fbusy_0;
input [31:0] CP2_fdata_0;
input CP2_fds_0;
input [2:0] CP2_forder_0;
output [2:0] CP2_fordlim_0;
output CP2_fs_0;
input CP2_idle;
output CP2_inst32_0;
output [31:0] CP2_ir_0;
output CP2_irenable_0;
output CP2_kd_mode_0;
output [1:0] CP2_kill_0;
output CP2_kills_0;
output CP2_null_0;
output CP2_nulls_0;
input CP2_present;
output CP2_reset;
input CP2_tbusy_0;
output [31:0] CP2_tdata_0;
output CP2_tds_0;
output [2:0] CP2_torder_0;
input [2:0] CP2_tordlim_0;
output CP2_ts_0;
input CP1_abusy_0;
output CP1_as_0;
input CP1_ccc_0;
input CP1_cccs_0;
output CP1_endian_0;
input CP1_exc_0;
input [4:0] CP1_exccode_0;
input CP1_excs_0;
input CP1_exc_1;
input [4:0] CP1_exccode_1;
input CP1_excs_1;
input CP1_fbusy_0;
input [63:0] CP1_fdata_0;
input CP1_fds_0;
input [2:0] CP1_forder_0;
output [2:0] CP1_fordlim_0;
output CP1_fs_0;
input 	 CP1_fppresent;		// COP1 is present (1=present)
input 	 CP1_mdmxpresent;		// COP1 is present (1=present)
input 	 CP1_ufrpresent;
input CP1_idle;
output CP1_inst31_0;
output [31:0] CP1_ir_0;
output CP1_irenable_0;
output [1:0] CP1_kill_0;
output CP1_kills_0;
output [1:0] CP1_kill_1;
output CP1_kills_1;
output CP1_null_0;
output CP1_nulls_0;
output	 CP1_gprs_0;
output [3:0]	 CP1_gpr_0;
output CP1_reset;
input CP1_tbusy_0;
output [63:0] CP1_tdata_0;
output CP1_tds_0;
output [2:0] CP1_torder_0;
input [2:0] CP1_tordlim_0;
output CP1_ts_0;
output CP1_fr32_0;
output		mpc_disable_gclk_xx;
output [7:0]  DSP_GuestID;
output		DSP_Lock;	// Start a RMW sequence for DSPRAM
output [19:2] DSP_DataAddr;		// Additional index bits for SPRAM
output DSP_DataRdStr;		// Data Read strobe
input [31:0] DSP_DataRdValue;		// dspram data value
output [3:0] DSP_DataWrMask;		// SP write mask
output DSP_DataWrStr;		// Data write strobe
output [31:0] DSP_DataWrValue;
input DSP_Hit;		// dspram hit
input DSP_ParPresent;		// DSPRAM has parity support
output DSP_ParityEn;		// Parity enable for DSPRAM 
input DSP_Present;
input [3:0] DSP_RPar;		// Parity bits read from DSPRAM
input DSP_Stall;		// dspram not ready
output [19:2] DSP_TagAddr;		// Additional index bits for SPRAM
output [23:0] DSP_TagCmpValue;		// tag compare data
output DSP_TagRdStr;		// Tag Read strobe
input [23:0] DSP_TagRdValue;		// dspram tag value
output DSP_TagWrStr;		// SP tag write strobe
output [3:0] DSP_WPar;		// Parity bit for DSPRAM write data 
input EJ_DINT;		// Debug mode request
input EJ_DINTsup;
output EJ_DebugM;		// A debug Exception has been taken
output EJ_ECREjtagBrk;
input [10:0] EJ_ManufID;
input [15:0] EJ_PartNumber;
output EJ_PerRst;
output EJ_PrRst;
output EJ_SRstE;		// SRstE bit from DCR
input EJ_TCK;
input EJ_TDI;
output EJ_TDO;
output EJ_TDOzstate;
input EJ_TMS;
input EJ_TRST_N;
input [3:0] EJ_Version;
input		EJ_DisableProbeDebug;
output	PM_InstnComplete;       
output [31:0] HADDR;		//AHB: The 32-bit system address bus.
output [2:0] HBURST;		//AHB: Burst type; Only Two types:
output HCLK;			//AHB: The bus clock times all bus transfer. 
output HMASTLOCK;		//AHB: Indicates the current transfer is part of a locked sequence; Tie to 0.
output [3:0] HPROT;		//AHB: The single indicate the transfer type; Tie to 4'b0011, no significant meaning;
input [31:0] HRDATA;		//AHB: Read Data Bus
input HREADY;			//AHB: Indicate the previous transfer is complete
output HRESETn;			//AHB: The bus reset signal is active LOW and resets the system and the bus.
input HRESP;			//AHB: 0 is OKAY, 1 is ERROR
input SI_AHBStb;               //AHB: Signal indicating phase and frequency relationship between clk and hclk. 
output [2:0] HSIZE;		//AHB: Indicates the size of transfer; Only Three types:
output [1:0] HTRANS;		//AHB: Indicates the transfer type; Three Types
output [31:0] HWDATA;		//AHB: Write data bus.
output HWRITE;			//AHB: Indicates the transfer direction, Read or Write. 
output [7:0]  ISP_GuestID;
output [19:2] ISP_Addr;		// Additional index bits for SPRAM
output [19:2] isp_dataaddr_scr;
input [31:0] ISP_DataRdValue;		// data in
output [31:0] ISP_DataTagValue;
output ISP_DataWrStr;
input ISP_Hit;		// SPRAM hit
input ISP_ParPresent;		// ISPRAM has parity support
output ISP_ParityEn;		// Parity enable for ISPRAM 
input ISP_Present;
input [3:0] ISP_RPar;		// Parity bits read from ISPRAM
output ISP_RdStr;
input ISP_Stall;		// SPRAM stall
input [23:0] ISP_TagRdValue;		// tag in
output ISP_TagWrStr;		// scratchpad tag write strobe
output [3:0] ISP_WPar;		// Parity bit for ISPRAM write data 
output icc_spwr_active;
input SI_BootExcISAMode;		// static set the ISA mode during interrupts, exceptions and boot
input [9:0] SI_CPUNum;		// EBase CPU number
input SI_ClkIn;
output SI_ClkOut;		// External bus reference clock
input SI_ColdReset;		// cold reset pin
output [3:0] SI_Dbs;		// Data break status
input SI_EICPresent;		// External Interrupt cpntroller present
input [5:0] SI_EICVector;		// Vector number for EIC interrupt
input [3:0] SI_EISS;		// Shadow set, comes with the requested interrupt
output SI_ERL;		// Error Level pinned out   
output SI_EXL;		// Exception Level pinned out
output SI_NMITaken;	// NMI pinned out
output       SI_NESTERL;	// nested error level pinned out
output       SI_NESTEXL;	// nested exception level pinned out
input SI_Endian;
output SI_FDCInt;		// FDC receive FIFO full interrupt
output SI_IAck;		// Interrupt Acknowledge
input [2:0] SI_IPFDCI;		// FDC connection
output [7:0] SI_IPL;		// Cuurent IPL, contains information of which int SI_IAck ack.
output [5:0] SI_IVN;         // Cuurent IVN, contains information of which int SI_IAck ack.
output [17:1] SI_ION;        // Cuurent ION, contains information of which int SI_IAck ack.
input [2:0] SI_IPPCI;		// PC connection
input [2:0] SI_IPTI;		// TimerInt connection
output [7:0] SI_Ibs;		// Instruction break status
input [7:0] SI_Int;		// Ext. Interrupt pins
input [1:0] SI_MergeMode;		// merging algorithm:  0X- No merging
input SI_NMI;		// Non-maskable interrupt pin
input [17:1] SI_Offset;		// m14k_Int - Vector offset for EIC interrupt
output SI_PCInt;
output SI_RP;		// Reduce Power pinned out
input SI_Reset;		// warm/soft reset pin
input [3:0] SI_SRSDisable;		// Disable banks of shadow sets
output [1:0] SI_SWInt;		// Software interrupt requests to external interrupt controller
output SI_Sleep;		// Processor is in sleep mode
output SI_TimerInt;		// count==compare interrupt
input SI_TraceDisable;		// Disables trace hardware
output [2:0] TC_ClockRatio;
output [63:0] TC_Data;
input TC_PibPresent;
input TC_Stall;
output TC_Valid;
output UDI_endianb_e;
output UDI_gclk;
output UDI_greset;
output UDI_gscanenable;
input UDI_honor_cee;
output [31:0] UDI_ir_e;		// Full instn
output UDI_irvalid_e;		// IR is valid
output UDI_kd_mode_e;
output UDI_kill_m;
input UDI_present;
input [31:0] UDI_rd_m;
input UDI_ri_e;
output [31:0] UDI_rs_e;
output [31:0] UDI_rt_e;
output UDI_run_m;
input UDI_stall_m;
output UDI_start_e;
input [4:0] UDI_wrreg_e;
input [`M14K_RF_BIST_TO-1:0] bc_rfbistto;		// bist signals to generator based RF
input [`M14K_TCB_TRMEM_BIST_TO-1:0] bc_tcbbistto;
output gclk;		// Clock
input gscanenable;		// Scan Enable
input gscanmode;
output greset;
input [(`M14K_D_BITS*`M14K_MAX_DC_ASSOC-1):0] dc_datain;		// D$ Data
input [2:0] dc_nsets;		// Number of sets   - static
input dc_present;		// D$ is present
input dc_hci;		        // Hardware D$ init
input [1:0] dc_ssize;		// D$ associativity - static
input [(`M14K_T_BITS*`M14K_MAX_DC_ASSOC-1):0] dc_tagin;		// D$ Tag
input [13:0] dc_wsin;		// D$ WS
input dca_parity_present;		// D$ supports parity
output [`M14K_D_BITS-1:0] dcc_data;		// Write Data
output [13:2] dcc_dataaddr;		// Index into data array
output dcc_drstb;		// Data read strobe
output dcc_dwstb;		// Data write Strobe
output [13:4] dcc_tagaddr;		// Index into tag array
output [`M14K_T_BITS-1:0] dcc_tagwrdata;		// Tag write data
output [(`M14K_MAX_DC_ASSOC-1):0] dcc_tagwren;		// Write way
output dcc_trstb;		// Tag Read Strobe
output dcc_twstb;		// Tag write strobe
output [(4*`M14K_MAX_DC_ASSOC-1):0] dcc_writemask;		// Write mask
output [13:4] dcc_wsaddr;		// Index into WS array
output dcc_wsrstb;		// WS Read Strobe
output [13:0] dcc_wswrdata;		// WS write data
output [13:0] dcc_wswren;		// WS write mask
output dcc_wswstb;		// WS write strobe
input [7:0] gmb_dc_algorithm;		// Alogrithm selection for I$ BIST controller.
input [7:0] gmb_ic_algorithm;		// Alogrithm selection for D$ BIST controller.
input [7:0] gmb_isp_algorithm;		// Alogrithm selection for ISPRAM BIST controller.
input [7:0] gmb_sp_algorithm;		// Alogrithm selection for DSPRAM BIST controller.
output gmbddfail;
output gmbdifail;
output gmbspfail;
output gmbispfail;
output gmbdone;		// Global MBIST done
input gmbinvoke;
output gmbtdfail;
output gmbtifail;
output gmbwdfail;
output gmbwifail;
input gscanramwr;
input [(`M14K_D_BITS*`M14K_MAX_IC_ASSOC-1):0] ic_datain;		// I$ Data						
input [2:0] ic_nsets;		// Number of sets   - static
input ic_present;		// I$ is presenti
input ic_hci;		        // Hardware I$ init
input [1:0] ic_ssize;		// I$ associativity - static
input [(`M14K_T_BITS*`M14K_MAX_IC_ASSOC-1):0] ic_tagin;		// I$ Tag
input [(`M14K_MAX_IC_WS-1):0] ic_wsin;		// I$ WS
input ica_parity_present;		// I$ supports parity
output [`M14K_D_BITS-1:0] icc_data;		// Write Data						
output [13:2] icc_dataaddr;		// Tied to TagAddr
output icc_drstb;		// Tied to TRStb					
output icc_dwstb;		// Data write Strobe					
output [`M14K_MAX_IC_ASSOC-1:0] icc_readmask;
output [13:4] icc_tagaddr;		// Index to Tag array	
output [`M14K_T_BITS-1:0] icc_tagwrdata;		// tag write data
output [(`M14K_MAX_IC_ASSOC-1):0] icc_tagwren;		// Write way/ Access way (Cacheop)			
output icc_trstb;		// Tag Read Strobe					
output icc_twstb;		// Tag write strobe					
output [(4*`M14K_MAX_IC_ASSOC-1):0] icc_writemask;		// Data write Byte Mask
output [13:4] icc_wsaddr;		// Index into WS array
output icc_wsrstb;		// WS Read Strobe
output [(`M14K_MAX_IC_WS-1):0] icc_wswrdata;		// WS write data
output [(`M14K_MAX_IC_WS-1):0] icc_wswren;		// WS write mask
output icc_wswstb;		// WS write strobe
output          icc_early_data_ce;
output          icc_early_tag_ce;
output          icc_early_ws_ce;
output          dcc_early_data_ce;
output          dcc_early_tag_ce;
output          dcc_early_ws_ce;
output [`M14K_RF_BIST_FROM-1:0] rf_bistfrom;		// bist signals from generator based RF
output [`M14K_TCB_TRMEM_BIST_FROM-1:0] tcb_bistfrom;

// VZ guest ports
output [1:0]	SI_GSWInt;	// Software interrupt requests to external interrupt controller
output 		SI_GTimerInt;	// count==compare interrupt
output       SI_GPCInt;
output	SI_GIAck;	// Interrupt Acknowledge
output [7:0] SI_GIPL;         // Cuurent IPL, contains information of which int SI_IAck ack.
output [5:0] SI_GIVN;         // Cuurent IVN, contains information of which int SI_IAck ack.
output [17:1] SI_GION;        // Cuurent ION, contains information of which int SI_IAck ack.
output [7:0] SI_GID; 
input [7:0] SI_GInt;          // Ext. Interrupt pins
input [5:0]	SI_GEICVector;	// Vector number for EIC interrupt
input [17:1] SI_GOffset;	// Vector offset for EIC interrupt
input [3:0]	SI_GEISS;	// Shadow set, comes with the requested interrupt
input [7:0] SI_EICGID; 

input SI_Slip; // Inject security slip into pipeline
output cpz_scramblecfg_write;
output [7:0] cpz_scramblecfg_sel;
output [31:0] cpz_scramblecfg_data;
output antitamper_present;

// BEGIN Wire declarations made by MVP
wire cpz_cu1;
wire mmu_r_tlbshutdown_cpz;
wire [`M14K_ASID] /*[7:0]*/ mmu_r_asid_cpz;
wire [7:0] /*[7:0]*/ DSP_GuestID;
wire cpz_cu2;
wire mmu_r_it_segerr_cpz;
wire [31:0] /*[31:0]*/ mmu_r_cpyout_cpz;
wire [1:0] /*[1:0]*/ mmu_r_size_cpz;
wire mmu_r_transexc_cpz;
wire [7:0] /*[7:0]*/ ISP_GuestID;
wire mmu_r_type_cpz;
// END Wire declarations made by MVP



//verilint 528 off  //variable not used. specific for tracing
wire icc_umipsfifo_null_raw;
wire icc_umips_active;
//verilint 528 on   //variable not used. specific for tracing

wire		mmu_it_segerr;
wire		mmu_tlbshutdown;
wire		mmu_transexc;
wire	[31:0]	mmu_cpyout;
wire	[`M14K_ASID]	mmu_asid;
wire		mmu_type;
wire	[1:0]	mmu_size;

wire		cpz_vz;
wire		mmu_r_it_segerr;
wire		mmu_r_tlbshutdown;
wire		mmu_r_transexc;
wire	[31:0]	mmu_r_cpyout;
wire	[`M14K_ASID]	mmu_r_asid;
wire	[`M14K_ASID]	mmu_ejt_asid;
wire	[`M14K_ASID]	mmu_ejt_asid_m;
wire	cpz_ejt_mmutype;
wire		mmu_r_type;
wire	[1:0]	mmu_r_size;

wire cpz_ejt_um;
wire cpz_ejt_um_vld;
wire cpz_ejt_kuc_m;
wire cpz_ejt_kuc_w;
wire cpz_ejt_erl;
wire cpz_ejt_exl;

wire icc_icop_m;
assign cpz_ejt_um = (cpz_guestid_m == 8'b0) ? cpz_um : cpz_g_um;
assign cpz_ejt_um_vld = (cpz_guestid_m == 8'b0) ? cpz_um_vld : cpz_g_um_vld;
assign cpz_ejt_kuc_m = (cpz_guestid_m == 8'b0) ? cpz_kuc_m : cpz_g_kuc_m;
assign cpz_ejt_kuc_w = (cpz_guestid_m == 8'b0) ? cpz_kuc_w : cpz_g_kuc_w;
assign cpz_ejt_erl = (cpz_guestid_m == 8'b0) ? cpz_erl : cpz_g_erl;

assign cpz_ejt_exl = (cpz_guestid_m == 8'b0) ? cpz_exl : cpz_g_exl;

assign mmu_r_it_segerr_cpz = cpz_vz ? mmu_r_it_segerr : mmu_it_segerr;
assign mmu_r_tlbshutdown_cpz = cpz_vz ? mmu_r_tlbshutdown : mmu_tlbshutdown;
assign mmu_r_transexc_cpz = cpz_vz ? mmu_r_transexc : mmu_transexc;
assign mmu_r_cpyout_cpz[31:0] = cpz_vz ? mmu_r_cpyout : mmu_cpyout;
assign mmu_r_asid_cpz[`M14K_ASID] = cpz_vz ? mmu_r_asid : mmu_asid;
assign ISP_GuestID[7:0] = icc_icop_m ? cpz_guestid_m : cpz_guestid_i;
assign DSP_GuestID[7:0] = cpz_guestid_m;
assign mmu_r_type_cpz = cpz_vz ? mmu_r_type : mmu_type;
assign mmu_r_size_cpz[1:0] = cpz_vz ? mmu_r_size : mmu_size;

assign mmu_ejt_asid = !cpz_vz ? mmu_asid :
               (cpz_guestid == `M14K_ASIDWIDTH 'b0) ? mmu_r_asid :
                mmu_asid;
assign mmu_ejt_asid_m = !cpz_vz ? mmu_asid :

               (cpz_guestid_m == `M14K_ASIDWIDTH 'b0) ? mmu_r_asid :
                mmu_asid;

//cpz_ejt_mmutype = (cpz_guestid == `M14K_ASIDWIDTH 'b0) ? cpz_mmutype :
//                cpz_g_mmutype;

assign cpz_ejt_mmutype = cpz_vz ?  (cpz_mmutype && cpz_g_mmutype) : cpz_mmutype;
/*hookup*/
`M14K_CLKGATE_MODULE clock_gate(
	.SI_ClkIn(SI_ClkIn),
	.cpz_goodnight(cpz_goodnight),
	.gclk(gclk),
	.gfclk(gfclk),
	.greset(greset),
	.grfclk(grfclk),
	.gscanmode(gscanmode),
	.gtlbclk(gtlbclk),
	.jtlb_wr(jtlb_wr),
	.mpc_rfwrite_w(mpc_rfwrite_w),
	.r_gtlbclk(r_gtlbclk),
	.r_jtlb_wr(r_jtlb_wr));

/*hookup*/
m14k_cpz cpz (
	.EJ_DebugM(EJ_DebugM),
	.MDU_count_sat_tcid_xx(MDU_count_sat_tcid_xx),
	.MDU_count_sat_xx(MDU_count_sat_xx),
	.antitamper_present(antitamper_present),
	.biu_merging(biu_merging),
	.biu_pm_wr_buf_b(biu_pm_wr_buf_b),
	.biu_pm_wr_buf_f(biu_pm_wr_buf_f),
	.biu_shutdown(biu_shutdown),
	.biu_wtbf(biu_wtbf),
	.brk_d_trig(brk_d_trig),
	.brk_i_trig(brk_i_trig),
	.bstall_ie(bstall_ie),
	.cdmm_mmulock(cdmm_mmulock),
	.cdmm_mpu_numregion(cdmm_mpu_numregion),
	.cdmm_mpu_present(cdmm_mpu_present),
	.cp1_coppresent(cp1_coppresent),
	.cp1_seen_nodmiss_m(cp1_seen_nodmiss_m),
	.cp1_ufrp(cp1_ufrp),
	.cp2_coppresent(cp2_coppresent),
	.cp2_stall_e(cp2_stall_e),
	.cpz_at(cpz_at),
	.cpz_at_epi_en(cpz_at_epi_en),
	.cpz_at_pro_start_i(cpz_at_pro_start_i),
	.cpz_at_pro_start_val(cpz_at_pro_start_val),
	.cpz_bds_x(cpz_bds_x),
	.cpz_bev(cpz_bev),
	.cpz_bg(cpz_bg),
	.cpz_bootisamode(cpz_bootisamode),
	.cpz_cause_pci(cpz_cause_pci),
	.cpz_causeap(cpz_causeap),
	.cpz_cdmm_enable(cpz_cdmm_enable),
	.cpz_cdmmbase(cpz_cdmmbase),
	.cpz_cee(cpz_cee),
	.cpz_cf(cpz_cf),
	.cpz_cg(cpz_cg),
	.cpz_cgi(cpz_cgi),
	.cpz_config_ld(cpz_config_ld),
	.cpz_copusable(cpz_copusable),
	.cpz_cp0(cpz_cp0),
	.cpz_cp0read_m(cpz_cp0read_m),
	.cpz_datalo(cpz_datalo),
	.cpz_dcnsets(cpz_dcnsets),
	.cpz_dcpresent(cpz_dcpresent),
	.cpz_dcssize(cpz_dcssize),
	.cpz_debugmode_i(cpz_debugmode_i),
	.cpz_dm(cpz_dm),
	.cpz_dm_m(cpz_dm_m),
	.cpz_dm_w(cpz_dm_w),
	.cpz_doze(cpz_doze),
	.cpz_drg(cpz_drg),
	.cpz_drgmode_i(cpz_drgmode_i),
	.cpz_drgmode_m(cpz_drgmode_m),
	.cpz_dsppresent(cpz_dsppresent),
	.cpz_dwatchhit(cpz_dwatchhit),
	.cpz_ebase(cpz_ebase),
	.cpz_eisa_w(cpz_eisa_w),
	.cpz_enm(cpz_enm),
	.cpz_epc_rd_data(cpz_epc_rd_data),
	.cpz_epc_w(cpz_epc_w),
	.cpz_eret_m(cpz_eret_m),
	.cpz_eretisa(cpz_eretisa),
	.cpz_eretpc(cpz_eretpc),
	.cpz_erl(cpz_erl),
	.cpz_erl_e(cpz_erl_e),
	.cpz_excisamode(cpz_excisamode),
	.cpz_exl(cpz_exl),
	.cpz_ext_int(cpz_ext_int),
	.cpz_fdcint(cpz_fdcint),
	.cpz_fr(cpz_fr),
	.cpz_g_at_epi_en(cpz_g_at_epi_en),
	.cpz_g_at_pro_start_i(cpz_g_at_pro_start_i),
	.cpz_g_at_pro_start_val(cpz_g_at_pro_start_val),
	.cpz_g_bev(cpz_g_bev),
	.cpz_g_bootisamode(cpz_g_bootisamode),
	.cpz_g_cause_pci(cpz_g_cause_pci),
	.cpz_g_causeap(cpz_g_causeap),
	.cpz_g_cdmm(cpz_g_cdmm),
	.cpz_g_cee(cpz_g_cee),
	.cpz_g_config_ld(cpz_g_config_ld),
	.cpz_g_copusable(cpz_g_copusable),
	.cpz_g_dwatchhit(cpz_g_dwatchhit),
	.cpz_g_ebase(cpz_g_ebase),
	.cpz_g_epc_rd_data(cpz_g_epc_rd_data),
	.cpz_g_eretisa(cpz_g_eretisa),
	.cpz_g_erl(cpz_g_erl),
	.cpz_g_erl_e(cpz_g_erl_e),
	.cpz_g_excisamode(cpz_g_excisamode),
	.cpz_g_exl(cpz_g_exl),
	.cpz_g_ext_int(cpz_g_ext_int),
	.cpz_g_hoterl(cpz_g_hoterl),
	.cpz_g_hotexl(cpz_g_hotexl),
	.cpz_g_hss(cpz_g_hss),
	.cpz_g_hwrena(cpz_g_hwrena),
	.cpz_g_hwrena_29(cpz_g_hwrena_29),
	.cpz_g_iack(cpz_g_iack),
	.cpz_g_ice(cpz_g_ice),
	.cpz_g_int_e(cpz_g_int_e),
	.cpz_g_int_enable(cpz_g_int_enable),
	.cpz_g_int_excl_ie_e(cpz_g_int_excl_ie_e),
	.cpz_g_int_mw(cpz_g_int_mw),
	.cpz_g_int_pend_ed(cpz_g_int_pend_ed),
	.cpz_g_ion(cpz_g_ion),
	.cpz_g_ipl(cpz_g_ipl),
	.cpz_g_iret_m(cpz_g_iret_m),
	.cpz_g_iretpc(cpz_g_iretpc),
	.cpz_g_iv(cpz_g_iv),
	.cpz_g_ivn(cpz_g_ivn),
	.cpz_g_iwatchhit(cpz_g_iwatchhit),
	.cpz_g_k0cca(cpz_g_k0cca),
	.cpz_g_k23cca(cpz_g_k23cca),
	.cpz_g_kuc_e(cpz_g_kuc_e),
	.cpz_g_kuc_i(cpz_g_kuc_i),
	.cpz_g_kuc_m(cpz_g_kuc_m),
	.cpz_g_kuc_w(cpz_g_kuc_w),
	.cpz_g_kucca(cpz_g_kucca),
	.cpz_g_llbit(cpz_g_llbit),
	.cpz_g_mmusize(cpz_g_mmusize),
	.cpz_g_mmutype(cpz_g_mmutype),
	.cpz_g_mx(cpz_g_mx),
	.cpz_g_pc_present(cpz_g_pc_present),
	.cpz_g_pf(cpz_g_pf),
	.cpz_g_rbigend_e(cpz_g_rbigend_e),
	.cpz_g_rbigend_i(cpz_g_rbigend_i),
	.cpz_g_smallpage(cpz_g_smallpage),
	.cpz_g_srsctl(cpz_g_srsctl),
	.cpz_g_srsctl_css(cpz_g_srsctl_css),
	.cpz_g_srsctl_pss(cpz_g_srsctl_pss),
	.cpz_g_srsctl_pss2css_m(cpz_g_srsctl_pss2css_m),
	.cpz_g_status(cpz_g_status),
	.cpz_g_stkdec(cpz_g_stkdec),
	.cpz_g_swint(cpz_g_swint),
	.cpz_g_takeint(cpz_g_takeint),
	.cpz_g_timerint(cpz_g_timerint),
	.cpz_g_ufr(cpz_g_ufr),
	.cpz_g_ulri(cpz_g_ulri),
	.cpz_g_um(cpz_g_um),
	.cpz_g_um_vld(cpz_g_um_vld),
	.cpz_g_usekstk(cpz_g_usekstk),
	.cpz_g_vectoroffset(cpz_g_vectoroffset),
	.cpz_g_watch_present(cpz_g_watch_present),
	.cpz_g_watch_present__1(cpz_g_watch_present__1),
	.cpz_g_watch_present__2(cpz_g_watch_present__2),
	.cpz_g_watch_present__3(cpz_g_watch_present__3),
	.cpz_g_watch_present__4(cpz_g_watch_present__4),
	.cpz_g_watch_present__5(cpz_g_watch_present__5),
	.cpz_g_watch_present__6(cpz_g_watch_present__6),
	.cpz_g_watch_present__7(cpz_g_watch_present__7),
	.cpz_g_wpexc_m(cpz_g_wpexc_m),
	.cpz_ghfc_i(cpz_ghfc_i),
	.cpz_ghfc_w(cpz_ghfc_w),
	.cpz_gid(cpz_gid),
	.cpz_gm_e(cpz_gm_e),
	.cpz_gm_i(cpz_gm_i),
	.cpz_gm_m(cpz_gm_m),
	.cpz_gm_p(cpz_gm_p),
	.cpz_gm_w(cpz_gm_w),
	.cpz_goodnight(cpz_goodnight),
	.cpz_gsfc_m(cpz_gsfc_m),
	.cpz_gt(cpz_gt),
	.cpz_guestid(cpz_guestid),
	.cpz_guestid_i(cpz_guestid_i),
	.cpz_guestid_m(cpz_guestid_m),
	.cpz_halt(cpz_halt),
	.cpz_hotdm_i(cpz_hotdm_i),
	.cpz_hoterl(cpz_hoterl),
	.cpz_hotexl(cpz_hotexl),
	.cpz_hotiexi(cpz_hotiexi),
	.cpz_hwrena(cpz_hwrena),
	.cpz_hwrena_29(cpz_hwrena_29),
	.cpz_iack(cpz_iack),
	.cpz_iap_exce_handler_trace(cpz_iap_exce_handler_trace),
	.cpz_iap_um(cpz_iap_um),
	.cpz_ice(cpz_ice),
	.cpz_icnsets(cpz_icnsets),
	.cpz_icpresent(cpz_icpresent),
	.cpz_icssize(cpz_icssize),
	.cpz_iexi(cpz_iexi),
	.cpz_int_e(cpz_int_e),
	.cpz_int_enable(cpz_int_enable),
	.cpz_int_excl_ie_e(cpz_int_excl_ie_e),
	.cpz_int_mw(cpz_int_mw),
	.cpz_int_pend_ed(cpz_int_pend_ed),
	.cpz_ion(cpz_ion),
	.cpz_ipl(cpz_ipl),
	.cpz_iret_chain_reg(cpz_iret_chain_reg),
	.cpz_iret_m(cpz_iret_m),
	.cpz_iret_ret(cpz_iret_ret),
	.cpz_iretpc(cpz_iretpc),
	.cpz_isppresent(cpz_isppresent),
	.cpz_iv(cpz_iv),
	.cpz_ivn(cpz_ivn),
	.cpz_iwatchhit(cpz_iwatchhit),
	.cpz_k0cca(cpz_k0cca),
	.cpz_k23cca(cpz_k23cca),
	.cpz_kuc_e(cpz_kuc_e),
	.cpz_kuc_i(cpz_kuc_i),
	.cpz_kuc_m(cpz_kuc_m),
	.cpz_kuc_w(cpz_kuc_w),
	.cpz_kucca(cpz_kucca),
	.cpz_llbit(cpz_llbit),
	.cpz_lsnm(cpz_lsnm),
	.cpz_mbtag(cpz_mbtag),
	.cpz_mg(cpz_mg),
	.cpz_mmusize(cpz_mmusize),
	.cpz_mmutype(cpz_mmutype),
	.cpz_mnan(cpz_mnan),
	.cpz_mx(cpz_mx),
	.cpz_nest_erl(cpz_nest_erl),
	.cpz_nest_exl(cpz_nest_exl),
	.cpz_nmi(cpz_nmi),
	.cpz_nmi_e(cpz_nmi_e),
	.cpz_nmi_mw(cpz_nmi_mw),
	.cpz_nmipend(cpz_nmipend),
	.cpz_og(cpz_og),
	.cpz_pc_ctl0_ec1(cpz_pc_ctl0_ec1),
	.cpz_pc_ctl1_ec1(cpz_pc_ctl1_ec1),
	.cpz_pd(cpz_pd),
	.cpz_pe(cpz_pe),
	.cpz_pf(cpz_pf),
	.cpz_pi(cpz_pi),
	.cpz_po(cpz_po),
	.cpz_prid16(cpz_prid16),
	.cpz_rbigend_e(cpz_rbigend_e),
	.cpz_rbigend_i(cpz_rbigend_i),
	.cpz_rclen(cpz_rclen),
	.cpz_rclval(cpz_rclval),
	.cpz_ri(cpz_ri),
	.cpz_rid(cpz_rid),
	.cpz_rp(cpz_rp),
	.cpz_rslip_e(cpz_rslip_e),
	.cpz_scramblecfg_data(cpz_scramblecfg_data),
	.cpz_scramblecfg_sel(cpz_scramblecfg_sel),
	.cpz_scramblecfg_write(cpz_scramblecfg_write),
	.cpz_setdbep(cpz_setdbep),
	.cpz_setibep(cpz_setibep),
	.cpz_smallpage(cpz_smallpage),
	.cpz_spram(cpz_spram),
	.cpz_srsctl(cpz_srsctl),
	.cpz_srsctl_css(cpz_srsctl_css),
	.cpz_srsctl_pss(cpz_srsctl_pss),
	.cpz_srsctl_pss2css_m(cpz_srsctl_pss2css_m),
	.cpz_sst(cpz_sst),
	.cpz_status(cpz_status),
	.cpz_stkdec(cpz_stkdec),
	.cpz_swint(cpz_swint),
	.cpz_taglo(cpz_taglo),
	.cpz_takeint(cpz_takeint),
	.cpz_timerint(cpz_timerint),
	.cpz_ufr(cpz_ufr),
	.cpz_um(cpz_um),
	.cpz_um_vld(cpz_um_vld),
	.cpz_usekstk(cpz_usekstk),
	.cpz_vectoroffset(cpz_vectoroffset),
	.cpz_vz(cpz_vz),
	.cpz_wpexc_m(cpz_wpexc_m),
	.cpz_wst(cpz_wst),
	.dc_hci(dc_hci),
	.dc_nsets(dc_nsets),
	.dc_present(dc_present),
	.dc_ssize(dc_ssize),
	.dca_parity_present(dca_parity_present),
	.dcc_dcached_m(dcc_dcached_m),
	.dcc_dcop_stall(dcc_dcop_stall),
	.dcc_dcopdata_m(dcc_dcopdata_m),
	.dcc_dcopld_m(dcc_dcopld_m),
	.dcc_dcoppar_m(dcc_dcoppar_m),
	.dcc_dcoptag_m(dcc_dcoptag_m),
	.dcc_derr_way(dcc_derr_way),
	.dcc_dmiss_m(dcc_dmiss_m),
	.dcc_dspram_stall(dcc_dspram_stall),
	.dcc_dvastrobe(dcc_dvastrobe),
	.dcc_intkill_m(dcc_intkill_m),
	.dcc_intkill_w(dcc_intkill_w),
	.dcc_lscacheread_m(dcc_lscacheread_m),
	.dcc_parerr_cpz_w(dcc_parerr_cpz_w),
	.dcc_parerr_data(dcc_parerr_data),
	.dcc_parerr_ev(dcc_parerr_ev),
	.dcc_parerr_idx(dcc_parerr_idx),
	.dcc_parerr_m(dcc_parerr_m),
	.dcc_parerr_tag(dcc_parerr_tag),
	.dcc_parerr_ws(dcc_parerr_ws),
	.dcc_pm_dcmiss_pc(dcc_pm_dcmiss_pc),
	.dcc_pm_dhit_m(dcc_pm_dhit_m),
	.dcc_pm_fb_active(dcc_pm_fb_active),
	.dcc_pm_fbfull(dcc_pm_fbfull),
	.dcc_sp_pres(dcc_sp_pres),
	.dcc_stall_m(dcc_stall_m),
	.dcc_trstb(dcc_trstb),
	.dcc_twstb(dcc_twstb),
	.dcc_uncache_load(dcc_uncache_load),
	.dcc_uncached_store(dcc_uncached_store),
	.dcc_wb(dcc_wb),
	.dexc_type(dexc_type),
	.dmbinvoke(dmbinvoke),
	.dsp_data_parerr(dsp_data_parerr),
	.edp_alu_m(edp_alu_m),
	.edp_cacheiva_i(edp_cacheiva_i),
	.edp_dsp_alu_sat_xx(edp_dsp_alu_sat_xx),
	.edp_dsp_present_xx(edp_dsp_present_xx),
	.edp_eisa_e(edp_eisa_e),
	.edp_epc_e(edp_epc_e),
	.edp_iva_i(edp_iva_i),
	.edp_ldcpdata_w(edp_ldcpdata_w),
	.edp_udi_present(edp_udi_present),
	.edp_udi_stall_m(edp_udi_stall_m),
	.ej_fdc_busy_xx(ej_fdc_busy_xx),
	.ej_fdc_int(ej_fdc_int),
	.ejt_cbrk_type_m(ejt_cbrk_type_m),
	.ejt_dcrinte(ejt_dcrinte),
	.ejt_dcrnmie(ejt_dcrnmie),
	.ejt_ejtagbrk(ejt_ejtagbrk),
	.ejt_pdt_present(ejt_pdt_present),
	.fdc_present(fdc_present),
	.gclk(gclk),
	.gfclk(gfclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.ic_hci(ic_hci),
	.ic_nsets(ic_nsets),
	.ic_present(ic_present),
	.ic_ssize(ic_ssize),
	.ica_parity_present(ica_parity_present),
	.icc_derr_way(icc_derr_way),
	.icc_drstb(icc_drstb),
	.icc_fb_vld(icc_fb_vld),
	.icc_icopdata(icc_icopdata),
	.icc_icopld(icc_icopld),
	.icc_icoppar(icc_icoppar),
	.icc_icopstall(icc_icopstall),
	.icc_icoptag(icc_icoptag),
	.icc_imiss_i(icc_imiss_i),
	.icc_parerr_cpz_w(icc_parerr_cpz_w),
	.icc_parerr_data(icc_parerr_data),
	.icc_parerr_i(icc_parerr_i),
	.icc_parerr_idx(icc_parerr_idx),
	.icc_parerr_tag(icc_parerr_tag),
	.icc_sp_pres(icc_sp_pres),
	.icc_spram_stall(icc_spram_stall),
	.icc_stall_i(icc_stall_i),
	.icc_trstb(icc_trstb),
	.icc_twstb(icc_twstb),
	.icc_umips_instn_i(icc_umips_instn_i),
	.icc_umipsfifo_null_i(icc_umipsfifo_null_i),
	.icc_umipsfifo_null_w(icc_umipsfifo_null_w),
	.icc_umipspresent(icc_umipspresent),
	.isp_data_parerr(isp_data_parerr),
	.mdu_busy(mdu_busy),
	.mdu_result_done(mdu_result_done),
	.mdu_stall(mdu_stall),
	.mdu_type(mdu_type),
	.mmu_asid(mmu_asid),
	.mmu_cpyout(mmu_cpyout),
	.mmu_dcmode0(mmu_dcmode[0]),
	.mmu_dva_m(mmu_dva_m),
	.mmu_gid(mmu_gid),
	.mmu_icacabl(mmu_icacabl),
	.mmu_it_segerr(mmu_it_segerr),
	.mmu_pm_dthit(mmu_pm_dthit),
	.mmu_pm_dtlb_miss_qual(mmu_pm_dtlb_miss_qual),
	.mmu_pm_dtmiss(mmu_pm_dtmiss),
	.mmu_pm_ithit(mmu_pm_ithit),
	.mmu_pm_itmiss(mmu_pm_itmiss),
	.mmu_pm_jthit_d(mmu_pm_jthit_d),
	.mmu_pm_jthit_i(mmu_pm_jthit_i),
	.mmu_pm_jtmiss_d(mmu_pm_jtmiss_d),
	.mmu_pm_jtmiss_i(mmu_pm_jtmiss_i),
	.mmu_r_asid(mmu_r_asid_cpz),
	.mmu_r_cpyout(mmu_r_cpyout_cpz),
	.mmu_r_dtexc_m(mmu_r_dtexc_m),
	.mmu_r_dtriexc_m(mmu_r_dtriexc_m),
	.mmu_r_it_segerr(mmu_r_it_segerr_cpz),
	.mmu_r_itexc_i(mmu_r_itexc_i),
	.mmu_r_itxiexc_i(mmu_r_itxiexc_i),
	.mmu_r_pm_jthit_d(mmu_r_pm_jthit_d),
	.mmu_r_pm_jthit_i(mmu_r_pm_jthit_i),
	.mmu_r_pm_jtmiss_d(mmu_r_pm_jtmiss_d),
	.mmu_r_pm_jtmiss_i(mmu_r_pm_jtmiss_i),
	.mmu_r_read_m(mmu_r_read_m),
	.mmu_r_size(mmu_r_size_cpz),
	.mmu_r_tlbshutdown(mmu_r_tlbshutdown_cpz),
	.mmu_r_transexc(mmu_r_transexc_cpz),
	.mmu_r_type(mmu_r_type_cpz),
	.mmu_read_m(mmu_read_m),
	.mmu_rid(mmu_rid),
	.mmu_size(mmu_size),
	.mmu_tlbshutdown(mmu_tlbshutdown),
	.mmu_transexc(mmu_transexc),
	.mmu_type(mmu_type),
	.mmu_vafromi(mmu_vafromi),
	.mmu_vat_hi(mmu_vat_hi),
	.mpc_alu_w(mpc_alu_w),
	.mpc_atepi_m(mpc_atepi_m),
	.mpc_atepi_w(mpc_atepi_w),
	.mpc_atomic_e(mpc_atomic_e),
	.mpc_atomic_impr(mpc_atomic_impr),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_atpro_w(mpc_atpro_w),
	.mpc_auexc_on(mpc_auexc_on),
	.mpc_badins_type(mpc_badins_type),
	.mpc_bds_m(mpc_bds_m),
	.mpc_br_e(mpc_br_e),
	.mpc_bubble_e(mpc_bubble_e),
	.mpc_buf_epc(mpc_buf_epc),
	.mpc_buf_srsctl(mpc_buf_srsctl),
	.mpc_buf_status(mpc_buf_status),
	.mpc_busty_m(mpc_busty_m),
	.mpc_cfc1_fr_m(mpc_cfc1_fr_m),
	.mpc_chain_take(mpc_chain_take),
	.mpc_chain_vec(mpc_chain_vec),
	.mpc_cp0diei_m(mpc_cp0diei_m),
	.mpc_cp0move_m(mpc_cp0move_m),
	.mpc_cp0r_m(mpc_cp0r_m),
	.mpc_cp0sc_m(mpc_cp0sc_m),
	.mpc_cp0sr_m(mpc_cp0sr_m),
	.mpc_cp2a_e(mpc_cp2a_e),
	.mpc_cp2tf_e(mpc_cp2tf_e),
	.mpc_cpnm_e(mpc_cpnm_e),
	.mpc_ctc1_fr0_m(mpc_ctc1_fr0_m),
	.mpc_ctc1_fr1_m(mpc_ctc1_fr1_m),
	.mpc_dec_nop_w(mpc_dec_nop_w),
	.mpc_deret_m(mpc_deret_m),
	.mpc_deretval_e(mpc_deretval_e),
	.mpc_dis_int_e(mpc_dis_int_e),
	.mpc_dmsquash_m(mpc_dmsquash_m),
	.mpc_eret_m(mpc_eret_m),
	.mpc_eretval_e(mpc_eretval_e),
	.mpc_exc_e(mpc_exc_e),
	.mpc_exc_m(mpc_exc_m),
	.mpc_exc_type_w(mpc_exc_type_w),
	.mpc_exc_w(mpc_exc_w),
	.mpc_exccode(mpc_exccode),
	.mpc_excisamode_i(mpc_excisamode_i),
	.mpc_first_det_int(mpc_first_det_int),
	.mpc_fixup_m(mpc_fixup_m),
	.mpc_fixupd(mpc_fixupd),
	.mpc_fixupi(mpc_fixupi),
	.mpc_g_auexc_x(mpc_g_auexc_x),
	.mpc_g_auexc_x_qual(mpc_g_auexc_x_qual),
	.mpc_g_cp0move_m(mpc_g_cp0move_m),
	.mpc_g_int_pf(mpc_g_int_pf),
	.mpc_g_jamepc_w(mpc_g_jamepc_w),
	.mpc_g_jamtlb_w(mpc_g_jamtlb_w),
	.mpc_g_ld_causeap(mpc_g_ld_causeap),
	.mpc_g_ldcause(mpc_g_ldcause),
	.mpc_ge_exc(mpc_ge_exc),
	.mpc_gexccode(mpc_gexccode),
	.mpc_gpsi_perfcnt(mpc_gpsi_perfcnt),
	.mpc_hold_hwintn(mpc_hold_hwintn),
	.mpc_hw_load_done(mpc_hw_load_done),
	.mpc_hw_load_e(mpc_hw_load_e),
	.mpc_hw_save_done(mpc_hw_save_done),
	.mpc_hw_save_srsctl_i(mpc_hw_save_srsctl_i),
	.mpc_iae_done_exc(mpc_iae_done_exc),
	.mpc_int_pf_phase1_reg(mpc_int_pf_phase1_reg),
	.mpc_int_pref_phase1(mpc_int_pref_phase1),
	.mpc_ir_e(mpc_ir_e),
	.mpc_iret_m(mpc_iret_m),
	.mpc_iret_ret(mpc_iret_ret),
	.mpc_iret_ret_start(mpc_iret_ret_start),
	.mpc_iretval_e(mpc_iretval_e),
	.mpc_isamode_e(mpc_isamode_e),
	.mpc_isamode_i(mpc_isamode_i),
	.mpc_ivaval_i(mpc_ivaval_i),
	.mpc_jamdepc_w(mpc_jamdepc_w),
	.mpc_jamepc_w(mpc_jamepc_w),
	.mpc_jamerror_w(mpc_jamerror_w),
	.mpc_jamtlb_w(mpc_jamtlb_w),
	.mpc_jimm_e(mpc_jimm_e),
	.mpc_jreg31_e(mpc_jreg31_e),
	.mpc_jreg31non_e(mpc_jreg31non_e),
	.mpc_ld_causeap(mpc_ld_causeap),
	.mpc_ld_m(mpc_ld_m),
	.mpc_ldcause(mpc_ldcause),
	.mpc_ldst_e(mpc_ldst_e),
	.mpc_ll1_m(mpc_ll1_m),
	.mpc_ll_m(mpc_ll_m),
	.mpc_load_m(mpc_load_m),
	.mpc_load_status_done(mpc_load_status_done),
	.mpc_lsdc1_e(mpc_lsdc1_e),
	.mpc_lsdc1_m(mpc_lsdc1_m),
	.mpc_lsdc1_w(mpc_lsdc1_w),
	.mpc_ltu_e(mpc_ltu_e),
	.mpc_mcp0stall_e(mpc_mcp0stall_e),
	.mpc_ndauexc_x(mpc_ndauexc_x),
	.mpc_nmitaken(mpc_nmitaken),
	.mpc_nonseq_e(mpc_nonseq_e),
	.mpc_pdstrobe_w(mpc_pdstrobe_w),
	.mpc_penddbe(mpc_penddbe),
	.mpc_pendibe(mpc_pendibe),
	.mpc_pexc_i(mpc_pexc_i),
	.mpc_pexc_m(mpc_pexc_m),
	.mpc_pexc_w(mpc_pexc_w),
	.mpc_pm_complete(mpc_pm_complete),
	.mpc_pm_muldiv_e(mpc_pm_muldiv_e),
	.mpc_pref_m(mpc_pref_m),
	.mpc_pref_w(mpc_pref_w),
	.mpc_qual_auexc_x(mpc_qual_auexc_x),
	.mpc_r_auexc_x(mpc_r_auexc_x),
	.mpc_r_auexc_x_qual(mpc_r_auexc_x_qual),
	.mpc_rdhwr_m(mpc_rdhwr_m),
	.mpc_run_i(mpc_run_i),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_run_w(mpc_run_w),
	.mpc_sc_e(mpc_sc_e),
	.mpc_sc_m(mpc_sc_m),
	.mpc_squash_e(mpc_squash_e),
	.mpc_squash_i(mpc_squash_i),
	.mpc_squash_m(mpc_squash_m),
	.mpc_st_m(mpc_st_m),
	.mpc_stall_ie(mpc_stall_ie),
	.mpc_stall_m(mpc_stall_m),
	.mpc_stall_w(mpc_stall_w),
	.mpc_strobe_e(mpc_strobe_e),
	.mpc_strobe_m(mpc_strobe_m),
	.mpc_strobe_w(mpc_strobe_w),
	.mpc_tint(mpc_tint),
	.mpc_umipsfifosupport_i(mpc_umipsfifosupport_i),
	.mpc_umipspresent(mpc_umipspresent),
	.mpc_wr_guestctl0_m(mpc_wr_guestctl0_m),
	.mpc_wr_guestctl2_m(mpc_wr_guestctl2_m),
	.mpc_wr_intctl_m(mpc_wr_intctl_m),
	.mpc_wr_status_m(mpc_wr_status_m),
	.mpc_wr_view_ipl_m(mpc_wr_view_ipl_m),
	.pc0_ctl_ec1(pc0_ctl_ec1),
	.pc1_ctl_ec1(pc1_ctl_ec1),
	.pdtrace_cpzout(pdtrace_cpzout),
	.qual_iparerr_i(qual_iparerr_i),
	.qual_iparerr_w(qual_iparerr_w),
	.siu_bigend(siu_bigend),
	.siu_bootexcisamode(siu_bootexcisamode),
	.siu_coldreset(siu_coldreset),
	.siu_cpunum(siu_cpunum),
	.siu_eicgid(siu_eicgid),
	.siu_eicpresent(siu_eicpresent),
	.siu_eicvector(siu_eicvector),
	.siu_eiss(siu_eiss),
	.siu_g_eicvector(siu_g_eicvector),
	.siu_g_eiss(siu_g_eiss),
	.siu_g_int(siu_g_int),
	.siu_g_offset(siu_g_offset),
	.siu_ifdci(siu_ifdci),
	.siu_int(siu_int),
	.siu_ippci(siu_ippci),
	.siu_ipti(siu_ipti),
	.siu_nmi(siu_nmi),
	.siu_offset(siu_offset),
	.siu_slip(siu_slip),
	.siu_srsdisable(siu_srsdisable));

/*hookup*/
`M14K_CDMM_MODULE cdmm (
	.AHB_EAddr(HADDR[31:2]),
	.HWRITE(HWRITE),
	.biu_if_enable(biu_if_enable),
	.cdmm_area(cdmm_area),
	.cdmm_ej_override(cdmm_ej_override),
	.cdmm_fdc_hit(cdmm_fdc_hit),
	.cdmm_fdcgwrite(cdmm_fdcgwrite),
	.cdmm_fdcread(cdmm_fdcread),
	.cdmm_hit(cdmm_hit),
	.cdmm_mmulock(cdmm_mmulock),
	.cdmm_mpu_numregion(cdmm_mpu_numregion),
	.cdmm_mpu_present(cdmm_mpu_present),
	.cdmm_mpuipdt_w(cdmm_mpuipdt_w),
	.cdmm_mputriggered_i(cdmm_mputriggered_i),
	.cdmm_mputriggered_m(cdmm_mputriggered_m),
	.cdmm_mputrigresraw_i(cdmm_mputrigresraw_i),
	.cdmm_rdata_xx(cdmm_rdata_xx),
	.cdmm_sel(cdmm_sel),
	.cdmm_wdata_xx(cdmm_wdata_xx),
	.cpz_cdmmbase(cpz_cdmmbase),
	.cpz_dm_m(cpz_dm_m),
	.cpz_eret_m(cpz_eret_m),
	.cpz_gm_m(cpz_gm_m),
	.cpz_hotdm_i(cpz_hotdm_i),
	.cpz_iret_ret(cpz_iret_ret),
	.cpz_kuc_i(cpz_kuc_i),
	.cpz_kuc_m(cpz_kuc_m),
	.cpz_vz(cpz_vz),
	.dcc_dcopaccess_m(dcc_dcopaccess_m),
	.dcc_dvastrobe(dcc_dvastrobe),
	.edp_cacheiva_i(edp_cacheiva_i),
	.edp_iva_i(edp_iva_i),
	.ejt_eadone(ejt_eadone),
	.ejt_predonenxt(ejt_predonenxt),
	.fdc_present(fdc_present),
	.fdc_rdata_nxt(fdc_rdata_nxt),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.icc_macro_e(icc_macro_e),
	.icc_macroend_e(icc_macroend_e),
	.icc_slip_n_nhalf(icc_slip_n_nhalf),
	.icc_umipsfifo_stat(icc_umipsfifo_stat),
	.mmu_cdmm_kuc_m(mmu_cdmm_kuc_m),
	.mmu_dva_m(mmu_dva_m),
	.mmu_ivastrobe(mmu_ivastrobe),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_busty_m(mpc_busty_m),
	.mpc_cleard_strobe(mpc_cleard_strobe),
	.mpc_ebexc_w(mpc_ebexc_w),
	.mpc_ebld_e(mpc_ebld_e),
	.mpc_fixup_m(mpc_fixup_m),
	.mpc_icop_m(mpc_icop_m),
	.mpc_isamode_i(mpc_isamode_i),
	.mpc_macro_e(mpc_macro_e),
	.mpc_macro_end_e(mpc_macro_end_e),
	.mpc_mpustrobe_w(mpc_mpustrobe_w),
	.mpc_mputake_w(mpc_mputake_w),
	.mpc_mputriggeredres_i(mpc_mputriggeredres_i),
	.mpc_newiaddr(mpc_newiaddr),
	.mpc_pexc_e(mpc_pexc_e),
	.mpc_pexc_i(mpc_pexc_i),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_squash_i(mpc_squash_i));

assign cpz_cu2 = cpz_gm_e ? cpz_g_copusable[2] : cpz_copusable[2];
assign cpz_cu1 = cpz_gm_e ? cpz_g_copusable[1] : cpz_copusable[1];

/*hookup*/
`M14K_CP2_MODULE cp2 (
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
	.cp2_bstall_e(cp2_bstall_e),
	.cp2_btaken(cp2_btaken),
	.cp2_bvalid(cp2_bvalid),
	.cp2_copidle(cp2_copidle),
	.cp2_coppresent(cp2_coppresent),
	.cp2_data_w(cp2_data_w),
	.cp2_datasel(cp2_datasel),
	.cp2_exc_w(cp2_exc_w),
	.cp2_exccode_w(cp2_exccode_w),
	.cp2_fixup_m(cp2_fixup_m),
	.cp2_fixup_w(cp2_fixup_w),
	.cp2_ldst_m(cp2_ldst_m),
	.cp2_missexc_w(cp2_missexc_w),
	.cp2_movefrom_m(cp2_movefrom_m),
	.cp2_moveto_m(cp2_moveto_m),
	.cp2_stall_e(cp2_stall_e),
	.cp2_storealloc_reg(cp2_storealloc_reg),
	.cp2_storeissued_m(cp2_storeissued_m),
	.cp2_storekill_w(cp2_storekill_w),
	.cpz_cu2(cpz_cu2),
	.cpz_kuc_e(cpz_kuc_e),
	.cpz_rbigend_e(cpz_rbigend_e),
	.dcc_dmiss_m(dcc_dmiss_m),
	.dcc_par_kill_mw(dcc_par_kill_mw),
	.dcc_store_allocate(dcc_store_allocate),
	.edp_ldcpdata_w(edp_ldcpdata_w[31:0]),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.gscanmode(gscanmode),
	.mpc_brrun_ie(mpc_brrun_ie),
	.mpc_cp2exc(mpc_cp2exc),
	.mpc_fixupd(mpc_fixupd),
	.mpc_ir_e(mpc_ir_e),
	.mpc_irval_e(mpc_irval_e),
	.mpc_killcp2_w(mpc_killcp2_w),
	.mpc_predec_e(mpc_predec_e),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_run_w(mpc_run_w),
	.mpc_srcvld_e(mpc_srcvld_e),
	.mpc_tlb_exc_type(mpc_tlb_exc_type),
	.mpc_umipspresent(mpc_umipspresent),
	.mpc_wait_m(mpc_wait_m));

/*hookup*/
`M14K_CP1_MODULE cp1 (
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
	.cp1_bstall_e(cp1_bstall_e),
	.cp1_btaken(cp1_btaken),
	.cp1_bvalid(cp1_bvalid),
	.cp1_copidle(cp1_copidle),
	.cp1_coppresent(cp1_coppresent),
	.cp1_data_missing(cp1_data_missing),
	.cp1_data_w(cp1_data_w),
	.cp1_datasel(cp1_datasel),
	.cp1_exc_w(cp1_exc_w),
	.cp1_exccode_w(cp1_exccode_w),
	.cp1_fixup_i(cp1_fixup_i),
	.cp1_fixup_m(cp1_fixup_m),
	.cp1_fixup_w(cp1_fixup_w),
	.cp1_fixup_w_nolsdc1(cp1_fixup_w_nolsdc1),
	.cp1_ldst_m(cp1_ldst_m),
	.cp1_missexc_w(cp1_missexc_w),
	.cp1_movefrom_m(cp1_movefrom_m),
	.cp1_moveto_m(cp1_moveto_m),
	.cp1_seen_nodmiss_m(cp1_seen_nodmiss_m),
	.cp1_stall_e(cp1_stall_e),
	.cp1_stall_m(cp1_stall_m),
	.cp1_storealloc_reg(cp1_storealloc_reg),
	.cp1_storeissued_m(cp1_storeissued_m),
	.cp1_storekill_w(cp1_storekill_w),
	.cp1_ufrp(cp1_ufrp),
	.cpz_cu1(cpz_cu1),
	.cpz_fr(cpz_fr),
	.cpz_kuc_e(cpz_kuc_e),
	.cpz_rbigend_e(cpz_rbigend_e),
	.dcc_dmiss_m(dcc_dmiss_m),
	.dcc_par_kill_mw(dcc_par_kill_mw),
	.dcc_store_allocate(dcc_store_allocate),
	.dcc_valid_d_access(dcc_valid_d_access),
	.edp_bbus_e(edp_bbus_e),
	.edp_ldcpdata_w(edp_ldcpdata_w),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.gscanmode(gscanmode),
	.mpc_auexc_x(mpc_auexc_x),
	.mpc_brrun_ie(mpc_brrun_ie),
	.mpc_cp1exc(mpc_cp1exc),
	.mpc_fixupd(mpc_fixupd),
	.mpc_ir_e(mpc_ir_e),
	.mpc_irval_e(mpc_irval_e),
	.mpc_killcp1_w(mpc_killcp1_w),
	.mpc_ldc1_m(mpc_ldc1_m),
	.mpc_ldc1_w(mpc_ldc1_w),
	.mpc_lsdc1_e(mpc_lsdc1_e),
	.mpc_lsdc1_m(mpc_lsdc1_m),
	.mpc_lsdc1_w(mpc_lsdc1_w),
	.mpc_predec_e(mpc_predec_e),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_run_w(mpc_run_w),
	.mpc_sdc1_w(mpc_sdc1_w),
	.mpc_srcvld_e(mpc_srcvld_e),
	.mpc_umipspresent(mpc_umipspresent),
	.mpc_wait_m(mpc_wait_m));

/*hookup*/
`M14K_EDP_MODULE edp(
	.CP1_endian_0(CP1_endian_0),
	.MDU_data_ack_ms(MDU_data_ack_m),
	.MDU_info_e(MDU_info_e),
	.MDU_ouflag_age_xx(MDU_ouflag_age_xx),
	.MDU_ouflag_extl_extr_xx(MDU_ouflag_extl_extr_xx),
	.MDU_ouflag_hilo_xx(MDU_ouflag_hilo_xx),
	.MDU_ouflag_mulq_muleq_xx(MDU_ouflag_mulq_muleq_xx),
	.MDU_ouflag_tcid_xx(MDU_ouflag_tcid_xx),
	.MDU_ouflag_vld_xx(MDU_ouflag_vld_xx),
	.MDU_pend_ouflag_wr_xx(MDU_pend_ouflag_wr_xx),
	.MDU_rs_ex(MDU_rs_ex),
	.MDU_rt_ex(MDU_rt_ex),
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
	.alu_cp0_rtc_ex(alu_cp0_rtc_ex),
	.cp1_data_w(cp1_data_w),
	.cp2_data_w(cp2_data_w),
	.cpz_cp0read_m(cpz_cp0read_m),
	.cpz_ebase(cpz_ebase),
	.cpz_epc_rd_data(cpz_epc_rd_data),
	.cpz_eretpc(cpz_eretpc),
	.cpz_erl_e(cpz_erl_e),
	.cpz_g_ebase(cpz_g_ebase),
	.cpz_g_epc_rd_data(cpz_g_epc_rd_data),
	.cpz_g_erl_e(cpz_g_erl_e),
	.cpz_g_iretpc(cpz_g_iretpc),
	.cpz_g_iv(cpz_g_iv),
	.cpz_g_kuc_e(cpz_g_kuc_e),
	.cpz_g_rbigend_e(cpz_g_rbigend_e),
	.cpz_g_srsctl(cpz_g_srsctl),
	.cpz_g_status(cpz_g_status),
	.cpz_g_vectoroffset(cpz_g_vectoroffset),
	.cpz_gm_e(cpz_gm_e),
	.cpz_gm_m(cpz_gm_m),
	.cpz_iack(cpz_iack),
	.cpz_iretpc(cpz_iretpc),
	.cpz_iv(cpz_iv),
	.cpz_kuc_e(cpz_kuc_e),
	.cpz_rbigend_e(cpz_rbigend_e),
	.cpz_srsctl(cpz_srsctl),
	.cpz_status(cpz_status),
	.cpz_vectoroffset(cpz_vectoroffset),
	.dcc_ddata_m(dcc_ddata_m),
	.edp_abus_e(edp_abus_e),
	.edp_alu_m(edp_alu_m),
	.edp_bbus_e(edp_bbus_e),
	.edp_cacheiva_i(edp_cacheiva_i),
	.edp_cacheiva_p(edp_cacheiva_p),
	.edp_cndeq_e(edp_cndeq_e),
	.edp_dsp_add_e(edp_dsp_add_e),
	.edp_dsp_alu_sat_xx(edp_dsp_alu_sat_xx),
	.edp_dsp_dspc_ou_wren_e(edp_dsp_dspc_ou_wren_e),
	.edp_dsp_mdu_valid_e(edp_dsp_mdu_valid_e),
	.edp_dsp_modsub_e(edp_dsp_modsub_e),
	.edp_dsp_pos_ge32_e(edp_dsp_pos_ge32_e),
	.edp_dsp_pos_r_m(edp_dsp_pos_r_m),
	.edp_dsp_present_xx(edp_dsp_present_xx),
	.edp_dsp_stallreq_e(edp_dsp_stallreq_e),
	.edp_dsp_sub_e(edp_dsp_sub_e),
	.edp_dsp_valid_e(edp_dsp_valid_e),
	.edp_dva_e(edp_dva_e),
	.edp_dva_mapped_e(edp_dva_mapped_e),
	.edp_eisa_e(edp_eisa_e),
	.edp_epc_e(edp_epc_e),
	.edp_iva_i(edp_iva_i),
	.edp_iva_p(edp_iva_p),
	.edp_ldcpdata_w(edp_ldcpdata_w),
	.edp_povf_m(edp_povf_m),
	.edp_res_w(edp_res_w),
	.edp_stalign_byteoffset_e(edp_stalign_byteoffset_e),
	.edp_stdata_iap_m(edp_stdata_iap_m),
	.edp_stdata_m(edp_stdata_m),
	.edp_trapeq_m(edp_trapeq_m),
	.edp_udi_honor_cee(edp_udi_honor_cee),
	.edp_udi_present(edp_udi_present),
	.edp_udi_ri_e(edp_udi_ri_e),
	.edp_udi_stall_m(edp_udi_stall_m),
	.edp_udi_wrreg_e(edp_udi_wrreg_e),
	.edp_wrdata_w(edp_wrdata_w),
	.ej_rdvec_read(ej_rdvec_read),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.gscanmode(gscanmode),
	.icc_addiupc_22_21_e(icc_addiupc_22_21_e),
	.icc_halfworddethigh_i(icc_halfworddethigh_i),
	.icc_imiss_i(icc_imiss_i),
	.icc_macro_e(icc_macro_e),
	.icc_pcrel_e(icc_pcrel_e),
	.icc_umips_sds(icc_umips_sds),
	.icc_umipsconfig(icc_umipsconfig),
	.icc_umipsfifo_ieip2(icc_umipsfifo_ieip2),
	.icc_umipsfifo_ieip4(icc_umipsfifo_ieip4),
	.icc_umipsfifo_imip(icc_umipsfifo_imip),
	.icc_umipsfifo_stat(icc_umipsfifo_stat),
	.icc_umipsmode_i(icc_umipsmode_i),
	.icc_umipspresent(icc_umipspresent),
	.mdu_alive_gpr_a(mdu_alive_gpr_a),
	.mdu_res_w(mdu_res_w),
	.mmu_dva_m(mmu_dva_m),
	.mmu_dva_mapped_m(mmu_dva_mapped_m),
	.mpc_abs_e(mpc_abs_e),
	.mpc_addui_e(mpc_addui_e),
	.mpc_aluasrc_e(mpc_aluasrc_e),
	.mpc_alubsrc_e(mpc_alubsrc_e),
	.mpc_alufunc_e(mpc_alufunc_e),
	.mpc_alusel_m(mpc_alusel_m),
	.mpc_apcsel_e(mpc_apcsel_e),
	.mpc_append_e(mpc_append_e),
	.mpc_append_m(mpc_append_m),
	.mpc_aselres_e(mpc_aselres_e),
	.mpc_aselwr_e(mpc_aselwr_e),
	.mpc_atomic_bit_dest_w(mpc_atomic_bit_dest_w),
	.mpc_atomic_clrorset_w(mpc_atomic_clrorset_w),
	.mpc_atomic_e(mpc_atomic_e),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_atomic_w(mpc_atomic_w),
	.mpc_auexc_x(mpc_auexc_x),
	.mpc_balign_e(mpc_balign_e),
	.mpc_balign_m(mpc_balign_m),
	.mpc_be_w(mpc_be_w),
	.mpc_br16_e(mpc_br16_e),
	.mpc_br32_e(mpc_br32_e),
	.mpc_bselall_e(mpc_bselall_e),
	.mpc_bselres_e(mpc_bselres_e),
	.mpc_bsign_w(mpc_bsign_w),
	.mpc_busty_e(mpc_busty_e),
	.mpc_cdsign_w(mpc_cdsign_w),
	.mpc_chain_hold(mpc_chain_hold),
	.mpc_chain_strobe(mpc_chain_strobe),
	.mpc_chain_take(mpc_chain_take),
	.mpc_chain_vec(mpc_chain_vec),
	.mpc_clinvert_e(mpc_clinvert_e),
	.mpc_clsel_e(mpc_clsel_e),
	.mpc_clvl_e(mpc_clvl_e),
	.mpc_cmov_e(mpc_cmov_e),
	.mpc_cnvt_e(mpc_cnvt_e),
	.mpc_cnvts_e(mpc_cnvts_e),
	.mpc_cnvtsh_e(mpc_cnvtsh_e),
	.mpc_compact_e(mpc_compact_e),
	.mpc_cont_pf_phase1(mpc_cont_pf_phase1),
	.mpc_cop_e(mpc_cop_e),
	.mpc_ctl_dsp_valid_m(mpc_ctl_dsp_valid_m),
	.mpc_dcba_w(mpc_dcba_w),
	.mpc_dec_imm_apipe_sh_e(mpc_dec_imm_apipe_sh_e),
	.mpc_dec_imm_rsimm_e(mpc_dec_imm_rsimm_e),
	.mpc_dec_insv_e(mpc_dec_insv_e),
	.mpc_dec_logic_func_e(mpc_dec_logic_func_e),
	.mpc_dec_logic_func_m(mpc_dec_logic_func_m),
	.mpc_dec_rt_bsel_e(mpc_dec_rt_bsel_e),
	.mpc_dec_rt_csel_e(mpc_dec_rt_csel_e),
	.mpc_dec_sh_high_index_e(mpc_dec_sh_high_index_e),
	.mpc_dec_sh_high_index_m(mpc_dec_sh_high_index_m),
	.mpc_dec_sh_high_sel_e(mpc_dec_sh_high_sel_e),
	.mpc_dec_sh_high_sel_m(mpc_dec_sh_high_sel_m),
	.mpc_dec_sh_low_index_4_e(mpc_dec_sh_low_index_4_e),
	.mpc_dec_sh_low_index_4_m(mpc_dec_sh_low_index_4_m),
	.mpc_dec_sh_low_sel_e(mpc_dec_sh_low_sel_e),
	.mpc_dec_sh_low_sel_m(mpc_dec_sh_low_sel_m),
	.mpc_dec_sh_shright_e(mpc_dec_sh_shright_e),
	.mpc_dec_sh_shright_m(mpc_dec_sh_shright_m),
	.mpc_dec_sh_subst_ctl_e(mpc_dec_sh_subst_ctl_e),
	.mpc_dec_sh_subst_ctl_m(mpc_dec_sh_subst_ctl_m),
	.mpc_defivasel_e(mpc_defivasel_e),
	.mpc_dspinfo_e(mpc_dspinfo_e),
	.mpc_epi_vec(mpc_epi_vec),
	.mpc_eqcond_e(mpc_eqcond_e),
	.mpc_evecsel(mpc_evecsel),
	.mpc_excisamode_i(mpc_excisamode_i),
	.mpc_expect_isa(mpc_expect_isa),
	.mpc_ext_e(mpc_ext_e),
	.mpc_first_det_int(mpc_first_det_int),
	.mpc_fixupi(mpc_fixupi),
	.mpc_g_auexc_x(mpc_g_auexc_x),
	.mpc_g_int_pf(mpc_g_int_pf),
	.mpc_hw_load_e(mpc_hw_load_e),
	.mpc_hw_load_epc_e(mpc_hw_load_epc_e),
	.mpc_hw_load_srsctl_e(mpc_hw_load_srsctl_e),
	.mpc_hw_load_status_e(mpc_hw_load_status_e),
	.mpc_hw_ls_e(mpc_hw_ls_e),
	.mpc_hw_ls_i(mpc_hw_ls_i),
	.mpc_hw_save_epc_e(mpc_hw_save_epc_e),
	.mpc_hw_save_epc_m(mpc_hw_save_epc_m),
	.mpc_hw_save_srsctl_e(mpc_hw_save_srsctl_e),
	.mpc_hw_save_srsctl_m(mpc_hw_save_srsctl_m),
	.mpc_hw_save_status_e(mpc_hw_save_status_e),
	.mpc_hw_save_status_m(mpc_hw_save_status_m),
	.mpc_hw_sp(mpc_hw_sp),
	.mpc_imsgn_e(mpc_imsgn_e),
	.mpc_insext_e(mpc_insext_e),
	.mpc_insext_size_e(mpc_insext_size_e),
	.mpc_int_pref(mpc_int_pref),
	.mpc_ir_e(mpc_ir_e),
	.mpc_iret_ret(mpc_iret_ret),
	.mpc_iretval_e(mpc_iretval_e),
	.mpc_irval_e(mpc_irval_e),
	.mpc_irval_m(mpc_irval_m),
	.mpc_irval_w(mpc_irval_w),
	.mpc_isamode_e(mpc_isamode_e),
	.mpc_isamode_i(mpc_isamode_i),
	.mpc_isamode_m(mpc_isamode_m),
	.mpc_jalx_e(mpc_jalx_e),
	.mpc_jimm_e(mpc_jimm_e),
	.mpc_jreg_e(mpc_jreg_e),
	.mpc_killmd_m(mpc_killmd_m),
	.mpc_lda15_8sel_w(mpc_lda15_8sel_w),
	.mpc_lda23_16sel_w(mpc_lda23_16sel_w),
	.mpc_lda31_24sel_w(mpc_lda31_24sel_w),
	.mpc_lda7_0sel_w(mpc_lda7_0sel_w),
	.mpc_ll_e(mpc_ll_e),
	.mpc_lnksel_e(mpc_lnksel_e),
	.mpc_lnksel_m(mpc_lnksel_m),
	.mpc_lsdc1_e(mpc_lsdc1_e),
	.mpc_lsdc1_m(mpc_lsdc1_m),
	.mpc_lsdc1_w(mpc_lsdc1_w),
	.mpc_lsuxc1_e(mpc_lsuxc1_e),
	.mpc_lxs_e(mpc_lxs_e),
	.mpc_macro_e(mpc_macro_e),
	.mpc_mdu_m(mpc_mdu_m),
	.mpc_mf_m2_w(mpc_mf_m2_w),
	.mpc_movci_e(mpc_movci_e),
	.mpc_muldiv_w(mpc_muldiv_w),
	.mpc_nullify_e(mpc_nullify_e),
	.mpc_nullify_m(mpc_nullify_m),
	.mpc_nullify_w(mpc_nullify_w),
	.mpc_pcrel_e(mpc_pcrel_e),
	.mpc_pf_phase2_done(mpc_pf_phase2_done),
	.mpc_prealu_cond_e(mpc_prealu_cond_e),
	.mpc_predec_e(mpc_predec_e),
	.mpc_prepend_e(mpc_prepend_e),
	.mpc_prepend_m(mpc_prepend_m),
	.mpc_ret_e(mpc_ret_e),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_run_w(mpc_run_w),
	.mpc_sc_e(mpc_sc_e),
	.mpc_scop1_m(mpc_scop1_m),
	.mpc_sdc1_w(mpc_sdc1_w),
	.mpc_sds_e(mpc_sds_e),
	.mpc_selcp0_m(mpc_selcp0_m),
	.mpc_selcp1from_m(mpc_selcp1from_m),
	.mpc_selcp1from_w(mpc_selcp1from_w),
	.mpc_selcp1to_m(mpc_selcp1to_m),
	.mpc_selcp2from_m(mpc_selcp2from_m),
	.mpc_selcp2from_w(mpc_selcp2from_w),
	.mpc_selcp2to_m(mpc_selcp2to_m),
	.mpc_selcp_m(mpc_selcp_m),
	.mpc_selimm_e(mpc_selimm_e),
	.mpc_sellogic_m(mpc_sellogic_m),
	.mpc_selrot_e(mpc_selrot_e),
	.mpc_sequential_e(mpc_sequential_e),
	.mpc_shamt_e(mpc_shamt_e),
	.mpc_sharith_e(mpc_sharith_e),
	.mpc_shf_rot_cond_e(mpc_shf_rot_cond_e),
	.mpc_shright_e(mpc_shright_e),
	.mpc_shvar_e(mpc_shvar_e),
	.mpc_signa_w(mpc_signa_w),
	.mpc_signb_w(mpc_signb_w),
	.mpc_signc_w(mpc_signc_w),
	.mpc_signd_w(mpc_signd_w),
	.mpc_signed_m(mpc_signed_m),
	.mpc_stall_m(mpc_stall_m),
	.mpc_stkdec_in_bytes(mpc_stkdec_in_bytes),
	.mpc_subtract_e(mpc_subtract_e),
	.mpc_swaph_e(mpc_swaph_e),
	.mpc_tint(mpc_tint),
	.mpc_udisel_m(mpc_udisel_m),
	.mpc_udislt_sel_m(mpc_udislt_sel_m),
	.mpc_umips_defivasel_e(mpc_umips_defivasel_e),
	.mpc_umips_mirrordefivasel_e(mpc_umips_mirrordefivasel_e),
	.mpc_umipsfifosupport_i(mpc_umipsfifosupport_i),
	.mpc_updateepc_e(mpc_updateepc_e),
	.mpc_updateldcp_m(mpc_updateldcp_m),
	.mpc_usesrca_e(mpc_usesrca_e),
	.mpc_usesrcb_e(mpc_usesrcb_e),
	.mpc_vd_m(mpc_vd_m),
	.mpc_wr_sp2gpr(mpc_wr_sp2gpr),
	.rf_adt_e(rf_adt_e),
	.rf_bdt_e(rf_bdt_e),
	.x3_trig(x3_trig));

/*hookup*/
`M14K_MDU_MODULE mdunit (
	.MDU_count_sat_tcid_xx(MDU_count_sat_tcid_xx),
	.MDU_count_sat_xx(MDU_count_sat_xx),
	.MDU_data_ack_ms(MDU_data_ack_m),
	.MDU_data_val_ex(MDU_data_val_e),
	.MDU_data_valid_ex(MDU_data_valid_e),
	.MDU_dec_ag(MDU_dec_e),
	.MDU_dest_ms(mdu_dest_w),
	.MDU_info_e(MDU_info_e),
	.MDU_ir_ag(mpc_ir_e),
	.MDU_kill_er(mpc_nullify_w),
	.MDU_nullify_er(mpc_nullify_w),
	.MDU_nullify_ex(mpc_nullify_e),
	.MDU_nullify_ms(mpc_nullify_m),
	.MDU_opcode_issue_ag(MDU_opcode_issue_e),
	.MDU_ouflag_age_xx(MDU_ouflag_age_xx),
	.MDU_ouflag_extl_extr_xx(MDU_ouflag_extl_extr_xx),
	.MDU_ouflag_hilo_xx(MDU_ouflag_hilo_xx),
	.MDU_ouflag_mulq_muleq_xx(MDU_ouflag_mulq_muleq_xx),
	.MDU_ouflag_tcid_xx(MDU_ouflag_tcid_xx),
	.MDU_ouflag_vld_xx(MDU_ouflag_vld_xx),
	.MDU_pend_ouflag_wr_xx(MDU_pend_ouflag_wr_xx),
	.MDU_rfwrite_ms(mdu_rfwrite_w),
	.MDU_rs_ex(MDU_rs_ex),
	.MDU_rt_ex(MDU_rt_ex),
	.MDU_run_ag(MDU_run_e),
	.MDU_run_er(mpc_run_w),
	.MDU_run_ex(mpc_run_ie),
	.MDU_run_ms(mpc_run_m),
	.MDU_stallreq_ag(MDU_stallreq_e),
	.alu_cp0_rtc_ex(alu_cp0_rtc_ex),
	.alu_dsp_pos_r_ex(edp_dsp_pos_r_m),
	.edp_abus_e(edp_abus_e),
	.edp_bbus_e(edp_bbus_e),
	.edp_dsp_present_xx(edp_dsp_present_xx),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.mdu_alive_gpr_a(mdu_alive_gpr_a),
	.mdu_alive_gpr_m1(mdu_alive_gpr_m1),
	.mdu_alive_gpr_m2(mdu_alive_gpr_m2),
	.mdu_alive_gpr_m3(mdu_alive_gpr_m3),
	.mdu_busy(mdu_busy),
	.mdu_dest_m1(mdu_dest_m1),
	.mdu_dest_m2(mdu_dest_m2),
	.mdu_dest_m3(mdu_dest_m3),
	.mdu_mf_a(mdu_mf_a),
	.mdu_mf_m1(mdu_mf_m1),
	.mdu_mf_m2(mdu_mf_m2),
	.mdu_mf_m3(mdu_mf_m3),
	.mdu_nullify_m2(mdu_nullify_m2),
	.mdu_res_w(mdu_res_w),
	.mdu_result_done(mdu_result_done),
	.mdu_stall(mdu_stall),
	.mdu_stall_issue_xx(mdu_stall_issue_xx),
	.mdu_type(mdu_type),
	.mpc_dest_e(mpc_dest_e),
	.mpc_ekillmd_m(mpc_ekillmd_m),
	.mpc_ir_e(mpc_ir_e),
	.mpc_irval_e(mpc_irval_e),
	.mpc_killmd_m(mpc_exc_m),
	.mpc_predec_e(mpc_predec_e),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_srcvld_e(mpc_srcvld_e),
	.mpc_umipspresent(mpc_umipspresent),
	.mpc_wrdsp_e(mpc_wrdsp_e));

/*hookup*/
m14k_mpc mpc (
	.MDU_data_ack_m(MDU_data_ack_m),
	.MDU_data_val_e(MDU_data_val_e),
	.MDU_data_valid_e(MDU_data_valid_e),
	.MDU_dec_e(MDU_dec_e),
	.MDU_info_e(MDU_info_e),
	.MDU_opcode_issue_e(MDU_opcode_issue_e),
	.MDU_ouflag_extl_extr_xx(MDU_ouflag_extl_extr_xx),
	.MDU_ouflag_mulq_muleq_xx(MDU_ouflag_mulq_muleq_xx),
	.MDU_ouflag_vld_xx(MDU_ouflag_vld_xx),
	.MDU_run_e(MDU_run_e),
	.MDU_stallreq_e(MDU_stallreq_e),
	.PM_InstnComplete(PM_InstnComplete),
	.biu_dbe_exc(biu_dbe_exc),
	.biu_ibe_exc(biu_ibe_exc),
	.biu_lock(biu_lock),
	.biu_wbe(biu_wbe),
	.bstall_ie(bstall_ie),
	.cdmm_mmulock(cdmm_mmulock),
	.cdmm_mputriggered_i(cdmm_mputriggered_i),
	.cdmm_mputriggered_m(cdmm_mputriggered_m),
	.cp1_bstall_e(cp1_bstall_e),
	.cp1_btaken(cp1_btaken),
	.cp1_bvalid(cp1_bvalid),
	.cp1_copidle(cp1_copidle),
	.cp1_coppresent(cp1_coppresent),
	.cp1_exc_w(cp1_exc_w),
	.cp1_exccode_w(cp1_exccode_w),
	.cp1_fixup_i(cp1_fixup_i),
	.cp1_fixup_m(cp1_fixup_m),
	.cp1_fixup_w(cp1_fixup_w),
	.cp1_missexc_w(cp1_missexc_w),
	.cp1_movefrom_m(cp1_movefrom_m),
	.cp1_moveto_m(cp1_moveto_m),
	.cp1_seen_nodmiss_m(cp1_seen_nodmiss_m),
	.cp1_stall_e(cp1_stall_e),
	.cp1_stall_m(cp1_stall_m),
	.cp1_ufrp(cp1_ufrp),
	.cp2_bstall_e(cp2_bstall_e),
	.cp2_btaken(cp2_btaken),
	.cp2_bvalid(cp2_bvalid),
	.cp2_exc_w(cp2_exc_w),
	.cp2_exccode_w(cp2_exccode_w),
	.cp2_fixup_m(cp2_fixup_m),
	.cp2_fixup_w(cp2_fixup_w),
	.cp2_missexc_w(cp2_missexc_w),
	.cp2_movefrom_m(cp2_movefrom_m),
	.cp2_moveto_m(cp2_moveto_m),
	.cp2_stall_e(cp2_stall_e),
	.cpz_at(cpz_at),
	.cpz_at_epi_en(cpz_at_epi_en),
	.cpz_at_pro_start_i(cpz_at_pro_start_i),
	.cpz_at_pro_start_val(cpz_at_pro_start_val),
	.cpz_bev(cpz_bev),
	.cpz_bg(cpz_bg),
	.cpz_bootisamode(cpz_bootisamode),
	.cpz_causeap(cpz_causeap),
	.cpz_cee(cpz_cee),
	.cpz_cf(cpz_cf),
	.cpz_cg(cpz_cg),
	.cpz_cgi(cpz_cgi),
	.cpz_copusable(cpz_copusable),
	.cpz_cp0(cpz_cp0),
	.cpz_debugmode_i(cpz_debugmode_i),
	.cpz_dm_m(cpz_dm_m),
	.cpz_dm_w(cpz_dm_w),
	.cpz_dwatchhit(cpz_dwatchhit),
	.cpz_eretisa(cpz_eretisa),
	.cpz_erl(cpz_erl),
	.cpz_excisamode(cpz_excisamode),
	.cpz_exl(cpz_exl),
	.cpz_ext_int(cpz_ext_int),
	.cpz_fr(cpz_fr),
	.cpz_g_at_epi_en(cpz_g_at_epi_en),
	.cpz_g_at_pro_start_i(cpz_g_at_pro_start_i),
	.cpz_g_at_pro_start_val(cpz_g_at_pro_start_val),
	.cpz_g_bev(cpz_g_bev),
	.cpz_g_bootisamode(cpz_g_bootisamode),
	.cpz_g_causeap(cpz_g_causeap),
	.cpz_g_cdmm(cpz_g_cdmm),
	.cpz_g_cee(cpz_g_cee),
	.cpz_g_copusable(cpz_g_copusable),
	.cpz_g_dwatchhit(cpz_g_dwatchhit),
	.cpz_g_eretisa(cpz_g_eretisa),
	.cpz_g_erl(cpz_g_erl),
	.cpz_g_excisamode(cpz_g_excisamode),
	.cpz_g_exl(cpz_g_exl),
	.cpz_g_ext_int(cpz_g_ext_int),
	.cpz_g_hotexl(cpz_g_hotexl),
	.cpz_g_hss(cpz_g_hss),
	.cpz_g_hwrena(cpz_g_hwrena),
	.cpz_g_hwrena_29(cpz_g_hwrena_29),
	.cpz_g_iap_um(cpz_g_iap_um),
	.cpz_g_ice(cpz_g_ice),
	.cpz_g_int_e(cpz_g_int_e),
	.cpz_g_int_enable(cpz_g_int_enable),
	.cpz_g_int_excl_ie_e(cpz_g_int_excl_ie_e),
	.cpz_g_int_mw(cpz_g_int_mw),
	.cpz_g_int_pend_ed(cpz_g_int_pend_ed),
	.cpz_g_iret_m(cpz_g_iret_m),
	.cpz_g_iv(cpz_g_iv),
	.cpz_g_iwatchhit(cpz_g_iwatchhit),
	.cpz_g_kuc_e(cpz_g_kuc_e),
	.cpz_g_mmutype(cpz_g_mmutype),
	.cpz_g_mx(cpz_g_mx),
	.cpz_g_pc_present(cpz_g_pc_present),
	.cpz_g_pf(cpz_g_pf),
	.cpz_g_rbigend_e(cpz_g_rbigend_e),
	.cpz_g_srsctl_css(cpz_g_srsctl_css),
	.cpz_g_srsctl_pss(cpz_g_srsctl_pss),
	.cpz_g_srsctl_pss2css_m(cpz_g_srsctl_pss2css_m),
	.cpz_g_stkdec(cpz_g_stkdec),
	.cpz_g_takeint(cpz_g_takeint),
	.cpz_g_ufr(cpz_g_ufr),
	.cpz_g_ulri(cpz_g_ulri),
	.cpz_g_usekstk(cpz_g_usekstk),
	.cpz_g_watch_present(cpz_g_watch_present),
	.cpz_g_watch_present__1(cpz_g_watch_present__1),
	.cpz_g_watch_present__2(cpz_g_watch_present__2),
	.cpz_g_watch_present__3(cpz_g_watch_present__3),
	.cpz_g_watch_present__4(cpz_g_watch_present__4),
	.cpz_g_watch_present__5(cpz_g_watch_present__5),
	.cpz_g_watch_present__6(cpz_g_watch_present__6),
	.cpz_g_watch_present__7(cpz_g_watch_present__7),
	.cpz_g_wpexc_m(cpz_g_wpexc_m),
	.cpz_ghfc_i(cpz_ghfc_i),
	.cpz_ghfc_w(cpz_ghfc_w),
	.cpz_gm_e(cpz_gm_e),
	.cpz_gm_i(cpz_gm_i),
	.cpz_gm_m(cpz_gm_m),
	.cpz_gm_w(cpz_gm_w),
	.cpz_gsfc_m(cpz_gsfc_m),
	.cpz_gt(cpz_gt),
	.cpz_hotdm_i(cpz_hotdm_i),
	.cpz_hotexl(cpz_hotexl),
	.cpz_hotiexi(cpz_hotiexi),
	.cpz_hwrena(cpz_hwrena),
	.cpz_hwrena_29(cpz_hwrena_29),
	.cpz_iap_um(cpz_iap_um),
	.cpz_ice(cpz_ice),
	.cpz_iexi(cpz_iexi),
	.cpz_int_e(cpz_int_e),
	.cpz_int_enable(cpz_int_enable),
	.cpz_int_excl_ie_e(cpz_int_excl_ie_e),
	.cpz_int_mw(cpz_int_mw),
	.cpz_int_pend_ed(cpz_int_pend_ed),
	.cpz_iret_chain_reg(cpz_iret_chain_reg),
	.cpz_iret_m(cpz_iret_m),
	.cpz_iv(cpz_iv),
	.cpz_iwatchhit(cpz_iwatchhit),
	.cpz_kuc_e(cpz_kuc_e),
	.cpz_mg(cpz_mg),
	.cpz_mmutype(cpz_mmutype),
	.cpz_mx(cpz_mx),
	.cpz_nmi_e(cpz_nmi_e),
	.cpz_nmi_mw(cpz_nmi_mw),
	.cpz_og(cpz_og),
	.cpz_pc_ctl0_ec1(cpz_pc_ctl0_ec1),
	.cpz_pc_ctl1_ec1(cpz_pc_ctl1_ec1),
	.cpz_pf(cpz_pf),
	.cpz_rbigend_e(cpz_rbigend_e),
	.cpz_ri(cpz_ri),
	.cpz_rslip_e(cpz_rslip_e),
	.cpz_setdbep(cpz_setdbep),
	.cpz_setibep(cpz_setibep),
	.cpz_srsctl_css(cpz_srsctl_css),
	.cpz_srsctl_pss(cpz_srsctl_pss),
	.cpz_srsctl_pss2css_m(cpz_srsctl_pss2css_m),
	.cpz_sst(cpz_sst),
	.cpz_stkdec(cpz_stkdec),
	.cpz_takeint(cpz_takeint),
	.cpz_ufr(cpz_ufr),
	.cpz_usekstk(cpz_usekstk),
	.cpz_vz(cpz_vz),
	.cpz_wpexc_m(cpz_wpexc_m),
	.dcc_dbe_killfixup_w(dcc_dbe_killfixup_w),
	.dcc_ddata_m(dcc_ddata_m),
	.dcc_dmiss_m(dcc_dmiss_m),
	.dcc_ev(dcc_ev),
	.dcc_exc_nokill_m(dcc_exc_nokill_m),
	.dcc_fixup_w(dcc_fixup_w),
	.dcc_g_intkill_w(dcc_g_intkill_w),
	.dcc_intkill_m(dcc_intkill_m),
	.dcc_intkill_w(dcc_intkill_w),
	.dcc_ldst_m(dcc_ldst_m),
	.dcc_parerr_m(dcc_parerr_m),
	.dcc_parerr_w(dcc_parerr_w),
	.dcc_precisedbe_w(dcc_precisedbe_w),
	.dcc_spram_write(dcc_spram_write),
	.dcc_stall_m(dcc_stall_m),
	.debug_mode_e(EJ_DebugM),
	.dexc_type(dexc_type),
	.edp_abus_e(edp_abus_e),
	.edp_cndeq_e(edp_cndeq_e),
	.edp_dsp_add_e(edp_dsp_add_e),
	.edp_dsp_dspc_ou_wren_e(edp_dsp_dspc_ou_wren_e),
	.edp_dsp_mdu_valid_e(edp_dsp_mdu_valid_e),
	.edp_dsp_modsub_e(edp_dsp_modsub_e),
	.edp_dsp_pos_ge32_e(edp_dsp_pos_ge32_e),
	.edp_dsp_present_xx(edp_dsp_present_xx),
	.edp_dsp_stallreq_e(edp_dsp_stallreq_e),
	.edp_dsp_sub_e(edp_dsp_sub_e),
	.edp_dsp_valid_e(edp_dsp_valid_e),
	.edp_dva_1_0_e(edp_dva_e[1:0]),
	.edp_povf_m(edp_povf_m),
	.edp_stalign_byteoffset_e(edp_stalign_byteoffset_e),
	.edp_trapeq_m(edp_trapeq_m),
	.edp_udi_honor_cee(edp_udi_honor_cee),
	.edp_udi_ri_e(edp_udi_ri_e),
	.edp_udi_stall_m(edp_udi_stall_m),
	.edp_udi_wrreg_e(edp_udi_wrreg_e),
	.ej_fdc_busy_xx(ej_fdc_busy_xx),
	.ej_fdc_int(ej_fdc_int),
	.ej_isaondebug_read(ej_isaondebug_read),
	.ej_probtrap(ej_probtrap),
	.ej_rdvec(ej_rdvec),
	.ej_rdvec_read(ej_rdvec_read),
	.ejt_cbrk_m(ejt_cbrk_m),
	.ejt_dbrk_m(ejt_dbrk_m),
	.ejt_dbrk_w(ejt_dbrk_w),
	.ejt_dcrinte(ejt_dcrinte),
	.ejt_disableprobedebug(ejt_disableprobedebug),
	.ejt_dvabrk(ejt_dvabrk),
	.ejt_ejtagbrk(ejt_ejtagbrk),
	.ejt_ivabrk(ejt_ivabrk),
	.ejt_pdt_stall_w(ejt_pdt_stall_w),
	.ejt_stall_st_e(ejt_stall_st_e),
	.gclk(gclk),
	.gfclk(gfclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.icc_dspver_i(icc_dspver_i),
	.icc_halfworddethigh_fifo_i(icc_halfworddethigh_fifo_i),
	.icc_halfworddethigh_i(icc_halfworddethigh_i),
	.icc_idata_i(icc_idata_i),
	.icc_imiss_i(icc_imiss_i),
	.icc_macro_e(icc_macro_e),
	.icc_macro_jr(icc_macro_jr),
	.icc_macrobds_e(icc_macrobds_e),
	.icc_nobds_e(icc_nobds_e),
	.icc_parerr_i(icc_parerr_i),
	.icc_parerr_w(icc_parerr_w),
	.icc_parerrint_i(icc_parerrint_i),
	.icc_pcrel_e(icc_pcrel_e),
	.icc_poten_be(icc_poten_be),
	.icc_preciseibe_e(icc_preciseibe_e),
	.icc_preciseibe_i(icc_preciseibe_i),
	.icc_predec_i(icc_predec_i),
	.icc_rdpgpr_i(icc_rdpgpr_i),
	.icc_slip_n_nhalf(icc_slip_n_nhalf),
	.icc_stall_i(icc_stall_i),
	.icc_umips_16bit_needed(icc_umips_16bit_needed),
	.icc_umips_active(icc_umips_active),
	.icc_umips_sds(icc_umips_sds),
	.icc_umipsfifo_ieip2(icc_umipsfifo_ieip2),
	.icc_umipsfifo_ieip4(icc_umipsfifo_ieip4),
	.icc_umipsfifo_imip(icc_umipsfifo_imip),
	.icc_umipsfifo_null_i(icc_umipsfifo_null_i),
	.icc_umipsfifo_null_w(icc_umipsfifo_null_w),
	.icc_umipsfifo_stat(icc_umipsfifo_stat),
	.icc_umipspresent(icc_umipspresent),
	.icc_umipsri_e(icc_umipsri_e),
	.mdu_alive_gpr_a(mdu_alive_gpr_a),
	.mdu_alive_gpr_m1(mdu_alive_gpr_m1),
	.mdu_alive_gpr_m2(mdu_alive_gpr_m2),
	.mdu_alive_gpr_m3(mdu_alive_gpr_m3),
	.mdu_busy(mdu_busy),
	.mdu_dest_m1(mdu_dest_m1),
	.mdu_dest_m2(mdu_dest_m2),
	.mdu_dest_m3(mdu_dest_m3),
	.mdu_dest_w(mdu_dest_w),
	.mdu_mf_a(mdu_mf_a),
	.mdu_mf_m1(mdu_mf_m1),
	.mdu_mf_m2(mdu_mf_m2),
	.mdu_mf_m3(mdu_mf_m3),
	.mdu_nullify_m2(mdu_nullify_m2),
	.mdu_rfwrite_w(mdu_rfwrite_w),
	.mdu_stall(mdu_stall),
	.mdu_stall_issue_xx(mdu_stall_issue_xx),
	.mmu_adrerr(mmu_adrerr),
	.mmu_dtexc_m(mmu_dtexc_m),
	.mmu_dtmack_m(mmu_dtmack_m),
	.mmu_dtriexc_m(mmu_dtriexc_m),
	.mmu_iec(mmu_iec),
	.mmu_itexc_i(mmu_itexc_i),
	.mmu_itmack_i(mmu_itmack_i),
	.mmu_itxiexc_i(mmu_itxiexc_i),
	.mmu_r_adrerr(mmu_r_adrerr),
	.mmu_r_dtexc_m(mmu_r_dtexc_m),
	.mmu_r_dtriexc_m(mmu_r_dtriexc_m),
	.mmu_r_iec(mmu_r_iec),
	.mmu_r_itexc_i(mmu_r_itexc_i),
	.mmu_r_itxiexc_i(mmu_r_itxiexc_i),
	.mmu_r_tlbinv(mmu_r_tlbinv),
	.mmu_r_tlbmod(mmu_r_tlbmod),
	.mmu_r_tlbrefill(mmu_r_tlbrefill),
	.mmu_r_tlbshutdown(mmu_r_tlbshutdown),
	.mmu_tlbbusy(mmu_tlbbusy),
	.mmu_tlbinv(mmu_tlbinv),
	.mmu_tlbmod(mmu_tlbmod),
	.mmu_tlbrefill(mmu_tlbrefill),
	.mmu_tlbshutdown(mmu_tlbshutdown),
	.mpc_abs_e(mpc_abs_e),
	.mpc_addui_e(mpc_addui_e),
	.mpc_alu_w(mpc_alu_w),
	.mpc_aluasrc_e(mpc_aluasrc_e),
	.mpc_alubsrc_e(mpc_alubsrc_e),
	.mpc_alufunc_e(mpc_alufunc_e),
	.mpc_alusel_m(mpc_alusel_m),
	.mpc_annulds_e(mpc_annulds_e),
	.mpc_apcsel_e(mpc_apcsel_e),
	.mpc_append_e(mpc_append_e),
	.mpc_append_m(mpc_append_m),
	.mpc_aselres_e(mpc_aselres_e),
	.mpc_aselwr_e(mpc_aselwr_e),
	.mpc_atepi_m(mpc_atepi_m),
	.mpc_atepi_w(mpc_atepi_w),
	.mpc_atomic_bit_dest_w(mpc_atomic_bit_dest_w),
	.mpc_atomic_clrorset_w(mpc_atomic_clrorset_w),
	.mpc_atomic_e(mpc_atomic_e),
	.mpc_atomic_impr(mpc_atomic_impr),
	.mpc_atomic_load_e(mpc_atomic_load_e),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_atomic_store_w(mpc_atomic_store_w),
	.mpc_atomic_w(mpc_atomic_w),
	.mpc_atpro_w(mpc_atpro_w),
	.mpc_auexc_on(mpc_auexc_on),
	.mpc_auexc_x(mpc_auexc_x),
	.mpc_badins_type(mpc_badins_type),
	.mpc_balign_e(mpc_balign_e),
	.mpc_balign_m(mpc_balign_m),
	.mpc_bds_m(mpc_bds_m),
	.mpc_be_w(mpc_be_w),
	.mpc_br16_e(mpc_br16_e),
	.mpc_br32_e(mpc_br32_e),
	.mpc_br_e(mpc_br_e),
	.mpc_brrun_ie(mpc_brrun_ie),
	.mpc_bselall_e(mpc_bselall_e),
	.mpc_bselres_e(mpc_bselres_e),
	.mpc_bsign_w(mpc_bsign_w),
	.mpc_bubble_e(mpc_bubble_e),
	.mpc_buf_epc(mpc_buf_epc),
	.mpc_buf_srsctl(mpc_buf_srsctl),
	.mpc_buf_status(mpc_buf_status),
	.mpc_bussize_m(mpc_bussize_m),
	.mpc_busty_e(mpc_busty_e),
	.mpc_busty_m(mpc_busty_m),
	.mpc_busty_raw_e(mpc_busty_raw_e),
	.mpc_cbstrobe_w(mpc_cbstrobe_w),
	.mpc_cdsign_w(mpc_cdsign_w),
	.mpc_cfc1_fr_m(mpc_cfc1_fr_m),
	.mpc_chain_hold(mpc_chain_hold),
	.mpc_chain_strobe(mpc_chain_strobe),
	.mpc_chain_take(mpc_chain_take),
	.mpc_chain_vec(mpc_chain_vec),
	.mpc_cleard_strobe(mpc_cleard_strobe),
	.mpc_clinvert_e(mpc_clinvert_e),
	.mpc_clsel_e(mpc_clsel_e),
	.mpc_clvl_e(mpc_clvl_e),
	.mpc_cmov_e(mpc_cmov_e),
	.mpc_cnvt_e(mpc_cnvt_e),
	.mpc_cnvts_e(mpc_cnvts_e),
	.mpc_cnvtsh_e(mpc_cnvtsh_e),
	.mpc_compact_e(mpc_compact_e),
	.mpc_cont_pf_phase1(mpc_cont_pf_phase1),
	.mpc_continue_squash_i(mpc_continue_squash_i),
	.mpc_cop_e(mpc_cop_e),
	.mpc_coptype_m(mpc_coptype_m),
	.mpc_cp0diei_m(mpc_cp0diei_m),
	.mpc_cp0func_e(mpc_cp0func_e),
	.mpc_cp0move_m(mpc_cp0move_m),
	.mpc_cp0r_m(mpc_cp0r_m),
	.mpc_cp0sc_m(mpc_cp0sc_m),
	.mpc_cp0sr_m(mpc_cp0sr_m),
	.mpc_cp1exc(mpc_cp1exc),
	.mpc_cp2a_e(mpc_cp2a_e),
	.mpc_cp2exc(mpc_cp2exc),
	.mpc_cp2tf_e(mpc_cp2tf_e),
	.mpc_cpnm_e(mpc_cpnm_e),
	.mpc_ctc1_fr0_m(mpc_ctc1_fr0_m),
	.mpc_ctc1_fr1_m(mpc_ctc1_fr1_m),
	.mpc_ctl_dsp_valid_m(mpc_ctl_dsp_valid_m),
	.mpc_ctlen_noe_e(mpc_ctlen_noe_e),
	.mpc_dcba_w(mpc_dcba_w),
	.mpc_dec_imm_apipe_sh_e(mpc_dec_imm_apipe_sh_e),
	.mpc_dec_imm_rsimm_e(mpc_dec_imm_rsimm_e),
	.mpc_dec_insv_e(mpc_dec_insv_e),
	.mpc_dec_logic_func_e(mpc_dec_logic_func_e),
	.mpc_dec_logic_func_m(mpc_dec_logic_func_m),
	.mpc_dec_nop_w(mpc_dec_nop_w),
	.mpc_dec_rt_bsel_e(mpc_dec_rt_bsel_e),
	.mpc_dec_rt_csel_e(mpc_dec_rt_csel_e),
	.mpc_dec_sh_high_index_e(mpc_dec_sh_high_index_e),
	.mpc_dec_sh_high_index_m(mpc_dec_sh_high_index_m),
	.mpc_dec_sh_high_sel_e(mpc_dec_sh_high_sel_e),
	.mpc_dec_sh_high_sel_m(mpc_dec_sh_high_sel_m),
	.mpc_dec_sh_low_index_4_e(mpc_dec_sh_low_index_4_e),
	.mpc_dec_sh_low_index_4_m(mpc_dec_sh_low_index_4_m),
	.mpc_dec_sh_low_sel_e(mpc_dec_sh_low_sel_e),
	.mpc_dec_sh_low_sel_m(mpc_dec_sh_low_sel_m),
	.mpc_dec_sh_shright_e(mpc_dec_sh_shright_e),
	.mpc_dec_sh_shright_m(mpc_dec_sh_shright_m),
	.mpc_dec_sh_subst_ctl_e(mpc_dec_sh_subst_ctl_e),
	.mpc_dec_sh_subst_ctl_m(mpc_dec_sh_subst_ctl_m),
	.mpc_defivasel_e(mpc_defivasel_e),
	.mpc_deret_m(mpc_deret_m),
	.mpc_deretval_e(mpc_deretval_e),
	.mpc_dest_e(mpc_dest_e),
	.mpc_dest_w(mpc_dest_w),
	.mpc_dis_int_e(mpc_dis_int_e),
	.mpc_disable_gclk_xx(mpc_disable_gclk_xx),
	.mpc_dmsquash_m(mpc_dmsquash_m),
	.mpc_dmsquash_w(mpc_dmsquash_w),
	.mpc_dparerr_for_eviction(mpc_dparerr_for_eviction),
	.mpc_dspinfo_e(mpc_dspinfo_e),
	.mpc_ebexc_w(mpc_ebexc_w),
	.mpc_ebld_e(mpc_ebld_e),
	.mpc_eexc_e(mpc_eexc_e),
	.mpc_ekillmd_m(mpc_ekillmd_m),
	.mpc_epi_vec(mpc_epi_vec),
	.mpc_eqcond_e(mpc_eqcond_e),
	.mpc_eret_m(mpc_eret_m),
	.mpc_eretval_e(mpc_eretval_e),
	.mpc_evecsel(mpc_evecsel),
	.mpc_exc_e(mpc_exc_e),
	.mpc_exc_iae(mpc_exc_iae),
	.mpc_exc_m(mpc_exc_m),
	.mpc_exc_type_w(mpc_exc_type_w),
	.mpc_exc_w(mpc_exc_w),
	.mpc_exc_w_org(mpc_exc_w_org),
	.mpc_exccode(mpc_exccode),
	.mpc_excisamode_i(mpc_excisamode_i),
	.mpc_expect_isa(mpc_expect_isa),
	.mpc_ext_e(mpc_ext_e),
	.mpc_first_det_int(mpc_first_det_int),
	.mpc_fixup_m(mpc_fixup_m),
	.mpc_fixupd(mpc_fixupd),
	.mpc_fixupi(mpc_fixupi),
	.mpc_fixupi_wascall(mpc_fixupi_wascall),
	.mpc_g_auexc_x(mpc_g_auexc_x),
	.mpc_g_auexc_x_qual(mpc_g_auexc_x_qual),
	.mpc_g_cp0func_e(mpc_g_cp0func_e),
	.mpc_g_cp0move_m(mpc_g_cp0move_m),
	.mpc_g_eexc_e(mpc_g_eexc_e),
	.mpc_g_exc_e(mpc_g_exc_e),
	.mpc_g_int_pf(mpc_g_int_pf),
	.mpc_g_jamepc_w(mpc_g_jamepc_w),
	.mpc_g_jamtlb_w(mpc_g_jamtlb_w),
	.mpc_g_ld_causeap(mpc_g_ld_causeap),
	.mpc_g_ldcause(mpc_g_ldcause),
	.mpc_ge_exc(mpc_ge_exc),
	.mpc_gexccode(mpc_gexccode),
	.mpc_gpsi_perfcnt(mpc_gpsi_perfcnt),
	.mpc_hold_epi_vec(mpc_hold_epi_vec),
	.mpc_hold_hwintn(mpc_hold_hwintn),
	.mpc_hold_int_pref_phase1_val(mpc_hold_int_pref_phase1_val),
	.mpc_hw_load_done(mpc_hw_load_done),
	.mpc_hw_load_e(mpc_hw_load_e),
	.mpc_hw_load_epc_e(mpc_hw_load_epc_e),
	.mpc_hw_load_epc_m(mpc_hw_load_epc_m),
	.mpc_hw_load_srsctl_e(mpc_hw_load_srsctl_e),
	.mpc_hw_load_srsctl_m(mpc_hw_load_srsctl_m),
	.mpc_hw_load_status_e(mpc_hw_load_status_e),
	.mpc_hw_ls_e(mpc_hw_ls_e),
	.mpc_hw_ls_i(mpc_hw_ls_i),
	.mpc_hw_save_done(mpc_hw_save_done),
	.mpc_hw_save_epc_e(mpc_hw_save_epc_e),
	.mpc_hw_save_epc_m(mpc_hw_save_epc_m),
	.mpc_hw_save_srsctl_e(mpc_hw_save_srsctl_e),
	.mpc_hw_save_srsctl_i(mpc_hw_save_srsctl_i),
	.mpc_hw_save_srsctl_m(mpc_hw_save_srsctl_m),
	.mpc_hw_save_status_e(mpc_hw_save_status_e),
	.mpc_hw_save_status_m(mpc_hw_save_status_m),
	.mpc_hw_sp(mpc_hw_sp),
	.mpc_iae_done_exc(mpc_iae_done_exc),
	.mpc_ibrk_qual(mpc_ibrk_qual),
	.mpc_iccop_m(mpc_iccop_m),
	.mpc_icop_m(mpc_icop_m),
	.mpc_idx_cop_e(mpc_idx_cop_e),
	.mpc_imsgn_e(mpc_imsgn_e),
	.mpc_imsquash_e(mpc_imsquash_e),
	.mpc_imsquash_i(mpc_imsquash_i),
	.mpc_insext_e(mpc_insext_e),
	.mpc_insext_size_e(mpc_insext_size_e),
	.mpc_int_pf_phase1_reg(mpc_int_pf_phase1_reg),
	.mpc_int_pref(mpc_int_pref),
	.mpc_int_pref_phase1(mpc_int_pref_phase1),
	.mpc_ir_e(mpc_ir_e),
	.mpc_iret_m(mpc_iret_m),
	.mpc_iret_ret(mpc_iret_ret),
	.mpc_iret_ret_start(mpc_iret_ret_start),
	.mpc_ireton_e(mpc_ireton_e),
	.mpc_iretval_e(mpc_iretval_e),
	.mpc_irval_e(mpc_irval_e),
	.mpc_irval_m(mpc_irval_m),
	.mpc_irval_w(mpc_irval_w),
	.mpc_isachange0_i(mpc_isachange0_i),
	.mpc_isachange1_i(mpc_isachange1_i),
	.mpc_isamode_e(mpc_isamode_e),
	.mpc_isamode_i(mpc_isamode_i),
	.mpc_isamode_m(mpc_isamode_m),
	.mpc_itqualcond_i(mpc_itqualcond_i),
	.mpc_ivaval_i(mpc_ivaval_i),
	.mpc_jalx_e(mpc_jalx_e),
	.mpc_jamdepc_w(mpc_jamdepc_w),
	.mpc_jamepc_w(mpc_jamepc_w),
	.mpc_jamerror_w(mpc_jamerror_w),
	.mpc_jamtlb_w(mpc_jamtlb_w),
	.mpc_jimm_e(mpc_jimm_e),
	.mpc_jimm_e_fc(mpc_jimm_e_fc),
	.mpc_jreg31_e(mpc_jreg31_e),
	.mpc_jreg31non_e(mpc_jreg31non_e),
	.mpc_jreg_e(mpc_jreg_e),
	.mpc_jreg_e_jalr(mpc_jreg_e_jalr),
	.mpc_killcp1_w(mpc_killcp1_w),
	.mpc_killcp2_w(mpc_killcp2_w),
	.mpc_killmd_m(mpc_killmd_m),
	.mpc_ld_causeap(mpc_ld_causeap),
	.mpc_ld_m(mpc_ld_m),
	.mpc_lda15_8sel_w(mpc_lda15_8sel_w),
	.mpc_lda23_16sel_w(mpc_lda23_16sel_w),
	.mpc_lda31_24sel_w(mpc_lda31_24sel_w),
	.mpc_lda7_0sel_w(mpc_lda7_0sel_w),
	.mpc_ldc1_m(mpc_ldc1_m),
	.mpc_ldc1_w(mpc_ldc1_w),
	.mpc_ldcause(mpc_ldcause),
	.mpc_ldst_e(mpc_ldst_e),
	.mpc_ll1_m(mpc_ll1_m),
	.mpc_ll_e(mpc_ll_e),
	.mpc_ll_m(mpc_ll_m),
	.mpc_lnksel_e(mpc_lnksel_e),
	.mpc_lnksel_m(mpc_lnksel_m),
	.mpc_load_m(mpc_load_m),
	.mpc_load_status_done(mpc_load_status_done),
	.mpc_lsbe_m(mpc_lsbe_m),
	.mpc_lsdc1_e(mpc_lsdc1_e),
	.mpc_lsdc1_m(mpc_lsdc1_m),
	.mpc_lsdc1_w(mpc_lsdc1_w),
	.mpc_lsuxc1_e(mpc_lsuxc1_e),
	.mpc_lsuxc1_m(mpc_lsuxc1_m),
	.mpc_ltu_e(mpc_ltu_e),
	.mpc_lxs_e(mpc_lxs_e),
	.mpc_macro_e(mpc_macro_e),
	.mpc_macro_end_e(mpc_macro_end_e),
	.mpc_macro_m(mpc_macro_m),
	.mpc_macro_w(mpc_macro_w),
	.mpc_mcp0stall_e(mpc_mcp0stall_e),
	.mpc_mdu_m(mpc_mdu_m),
	.mpc_mf_m2_w(mpc_mf_m2_w),
	.mpc_movci_e(mpc_movci_e),
	.mpc_mpustrobe_w(mpc_mpustrobe_w),
	.mpc_mputake_w(mpc_mputake_w),
	.mpc_mputriggeredres_i(mpc_mputriggeredres_i),
	.mpc_muldiv_w(mpc_muldiv_w),
	.mpc_ndauexc_x(mpc_ndauexc_x),
	.mpc_newiaddr(mpc_newiaddr),
	.mpc_nmitaken(mpc_nmitaken),
	.mpc_nobds_e(mpc_nobds_e),
	.mpc_nonseq_e(mpc_nonseq_e),
	.mpc_nonseq_ep(mpc_nonseq_ep),
	.mpc_noseq_16bit_w(mpc_noseq_16bit_w),
	.mpc_nullify_e(mpc_nullify_e),
	.mpc_nullify_m(mpc_nullify_m),
	.mpc_nullify_w(mpc_nullify_w),
	.mpc_pcrel_e(mpc_pcrel_e),
	.mpc_pcrel_m(mpc_pcrel_m),
	.mpc_pdstrobe_w(mpc_pdstrobe_w),
	.mpc_penddbe(mpc_penddbe),
	.mpc_pendibe(mpc_pendibe),
	.mpc_pexc_e(mpc_pexc_e),
	.mpc_pexc_i(mpc_pexc_i),
	.mpc_pexc_m(mpc_pexc_m),
	.mpc_pexc_w(mpc_pexc_w),
	.mpc_pf_phase2_done(mpc_pf_phase2_done),
	.mpc_pm_complete(mpc_pm_complete),
	.mpc_pm_muldiv_e(mpc_pm_muldiv_e),
	.mpc_prealu_cond_e(mpc_prealu_cond_e),
	.mpc_predec_e(mpc_predec_e),
	.mpc_pref_m(mpc_pref_m),
	.mpc_pref_w(mpc_pref_w),
	.mpc_prepend_e(mpc_prepend_e),
	.mpc_prepend_m(mpc_prepend_m),
	.mpc_qual_auexc_x(mpc_qual_auexc_x),
	.mpc_r_auexc_x(mpc_r_auexc_x),
	.mpc_r_auexc_x_qual(mpc_r_auexc_x_qual),
	.mpc_rdhwr_m(mpc_rdhwr_m),
	.mpc_rega_cond_i(mpc_rega_cond_i),
	.mpc_rega_i(mpc_rega_i),
	.mpc_regb_cond_i(mpc_regb_cond_i),
	.mpc_regb_i(mpc_regb_i),
	.mpc_ret_e(mpc_ret_e),
	.mpc_ret_e_ndg(mpc_ret_e_ndg),
	.mpc_rfwrite_w(mpc_rfwrite_w),
	.mpc_run_i(mpc_run_i),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_run_w(mpc_run_w),
	.mpc_sbdstrobe_w(mpc_sbdstrobe_w),
	.mpc_sbstrobe_w(mpc_sbstrobe_w),
	.mpc_sbtake_w(mpc_sbtake_w),
	.mpc_sc_e(mpc_sc_e),
	.mpc_sc_m(mpc_sc_m),
	.mpc_scop1_m(mpc_scop1_m),
	.mpc_sdbreak_w(mpc_sdbreak_w),
	.mpc_sdc1_w(mpc_sdc1_w),
	.mpc_sds_e(mpc_sds_e),
	.mpc_sel_hw_e(mpc_sel_hw_e),
	.mpc_selcp0_m(mpc_selcp0_m),
	.mpc_selcp1from_m(mpc_selcp1from_m),
	.mpc_selcp1from_w(mpc_selcp1from_w),
	.mpc_selcp1to_m(mpc_selcp1to_m),
	.mpc_selcp2from_m(mpc_selcp2from_m),
	.mpc_selcp2from_w(mpc_selcp2from_w),
	.mpc_selcp2to_m(mpc_selcp2to_m),
	.mpc_selcp_m(mpc_selcp_m),
	.mpc_selimm_e(mpc_selimm_e),
	.mpc_sellogic_m(mpc_sellogic_m),
	.mpc_selrot_e(mpc_selrot_e),
	.mpc_sequential_e(mpc_sequential_e),
	.mpc_shamt_e(mpc_shamt_e),
	.mpc_sharith_e(mpc_sharith_e),
	.mpc_shf_rot_cond_e(mpc_shf_rot_cond_e),
	.mpc_shright_e(mpc_shright_e),
	.mpc_shvar_e(mpc_shvar_e),
	.mpc_signa_w(mpc_signa_w),
	.mpc_signb_w(mpc_signb_w),
	.mpc_signc_w(mpc_signc_w),
	.mpc_signd_w(mpc_signd_w),
	.mpc_signed_m(mpc_signed_m),
	.mpc_squash_e(mpc_squash_e),
	.mpc_squash_i(mpc_squash_i),
	.mpc_squash_m(mpc_squash_m),
	.mpc_srcvld_e(mpc_srcvld_e),
	.mpc_st_m(mpc_st_m),
	.mpc_stall_ie(mpc_stall_ie),
	.mpc_stall_m(mpc_stall_m),
	.mpc_stall_w(mpc_stall_w),
	.mpc_stkdec_in_bytes(mpc_stkdec_in_bytes),
	.mpc_strobe_e(mpc_strobe_e),
	.mpc_strobe_m(mpc_strobe_m),
	.mpc_strobe_w(mpc_strobe_w),
	.mpc_subtract_e(mpc_subtract_e),
	.mpc_swaph_e(mpc_swaph_e),
	.mpc_tail_chain_1st_seen(mpc_tail_chain_1st_seen),
	.mpc_tint(mpc_tint),
	.mpc_tlb_d_side(mpc_tlb_d_side),
	.mpc_tlb_exc_type(mpc_tlb_exc_type),
	.mpc_tlb_i_side(mpc_tlb_i_side),
	.mpc_trace_iap_iae_e(mpc_trace_iap_iae_e),
	.mpc_udisel_m(mpc_udisel_m),
	.mpc_udislt_sel_m(mpc_udislt_sel_m),
	.mpc_umips_defivasel_e(mpc_umips_defivasel_e),
	.mpc_umips_mirrordefivasel_e(mpc_umips_mirrordefivasel_e),
	.mpc_umipsfifosupport_i(mpc_umipsfifosupport_i),
	.mpc_umipspresent(mpc_umipspresent),
	.mpc_updateepc_e(mpc_updateepc_e),
	.mpc_updateldcp_m(mpc_updateldcp_m),
	.mpc_usesrca_e(mpc_usesrca_e),
	.mpc_usesrcb_e(mpc_usesrcb_e),
	.mpc_vd_m(mpc_vd_m),
	.mpc_wait_m(mpc_wait_m),
	.mpc_wait_w(mpc_wait_w),
	.mpc_wr_guestctl0_m(mpc_wr_guestctl0_m),
	.mpc_wr_guestctl2_m(mpc_wr_guestctl2_m),
	.mpc_wr_intctl_m(mpc_wr_intctl_m),
	.mpc_wr_sp2gpr(mpc_wr_sp2gpr),
	.mpc_wr_status_m(mpc_wr_status_m),
	.mpc_wr_view_ipl_m(mpc_wr_view_ipl_m),
	.mpc_wrdsp_e(mpc_wrdsp_e),
	.qual_iparerr_i(qual_iparerr_i),
	.qual_iparerr_w(qual_iparerr_w),
	.rf_adt_e(rf_adt_e),
	.rf_bdt_e(rf_bdt_e),
	.rf_init_done(rf_init_done),
	.x3_trig(x3_trig));

/*hookup*/
`M14K_RF_MODULE rf (
	.bc_rfbistto(bc_rfbistto),
	.edp_wrdata_w(edp_wrdata_w),
	.gclk(gclk),
	.greset(greset),
	.grfclk(grfclk),
	.gscanenable(gscanenable),
	.mpc_dest_w(mpc_dest_w),
	.mpc_rega_cond_i(mpc_rega_cond_i),
	.mpc_rega_i(mpc_rega_i),
	.mpc_regb_cond_i(mpc_regb_cond_i),
	.mpc_regb_i(mpc_regb_i),
	.mpc_rfwrite_w(mpc_rfwrite_w),
	.rf_adt_e(rf_adt_e),
	.rf_bdt_e(rf_bdt_e),
	.rf_bistfrom(rf_bistfrom),
	.rf_init_done(rf_init_done));


/*hookup*/
`M14K_MMU_MODULE mmu (
	.asid_update(asid_update),
	.cdmm_mpu_present(cdmm_mpu_present),
	.cpz_cdmm_enable(cpz_cdmm_enable),
	.cpz_cdmmbase(cpz_cdmmbase),
	.cpz_dm_m(cpz_dm_m),
	.cpz_drg(cpz_drg),
	.cpz_drgmode_i(cpz_drgmode_i),
	.cpz_drgmode_m(cpz_drgmode_m),
	.cpz_erl(cpz_erl),
	.cpz_g_erl(cpz_g_erl),
	.cpz_g_hoterl(cpz_g_hoterl),
	.cpz_g_k0cca(cpz_g_k0cca),
	.cpz_g_k23cca(cpz_g_k23cca),
	.cpz_g_kuc_i(cpz_g_kuc_i),
	.cpz_g_kuc_m(cpz_g_kuc_m),
	.cpz_g_kucca(cpz_g_kucca),
	.cpz_g_mmusize(cpz_g_mmusize),
	.cpz_g_mmutype(cpz_g_mmutype),
	.cpz_g_smallpage(cpz_g_smallpage),
	.cpz_gid(cpz_gid),
	.cpz_gm_e(cpz_gm_e),
	.cpz_gm_i(cpz_gm_i),
	.cpz_gm_m(cpz_gm_m),
	.cpz_gm_p(cpz_gm_p),
	.cpz_hotdm_i(cpz_hotdm_i),
	.cpz_hoterl(cpz_hoterl),
	.cpz_k0cca(cpz_k0cca),
	.cpz_k23cca(cpz_k23cca),
	.cpz_kuc_i(cpz_kuc_i),
	.cpz_kuc_m(cpz_kuc_m),
	.cpz_kucca(cpz_kucca),
	.cpz_lsnm(cpz_lsnm),
	.cpz_mmusize(cpz_mmusize),
	.cpz_mmutype(cpz_mmutype),
	.cpz_rid(cpz_rid),
	.cpz_smallpage(cpz_smallpage),
	.cpz_vz(cpz_vz),
	.dcc_newdaddr(dcc_newdaddr),
	.edp_alu_m(edp_alu_m),
	.edp_cacheiva_i(edp_cacheiva_i),
	.edp_cacheiva_p(edp_cacheiva_p),
	.edp_dva_e(edp_dva_e),
	.edp_dva_mapped_e(edp_dva_mapped_e),
	.edp_iva_i(edp_iva_i),
	.edp_iva_p(edp_iva_p),
	.ejt_disableprobedebug(ejt_disableprobedebug),
	.fdc_present(fdc_present),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.gtlbclk(gtlbclk),
	.icc_halfworddethigh_fifo_i(icc_halfworddethigh_fifo_i),
	.icc_slip_n_nhalf(icc_slip_n_nhalf),
	.icc_umipsfifo_stat(icc_umipsfifo_stat),
	.jtlb_wr(jtlb_wr),
	.mmu_adrerr(mmu_adrerr),
	.mmu_asid(mmu_asid),
	.mmu_asid_valid(mmu_asid_valid),
	.mmu_cdmm_kuc_m(mmu_cdmm_kuc_m),
	.mmu_cpyout(mmu_cpyout),
	.mmu_dcmode(mmu_dcmode),
	.mmu_dpah(mmu_dpah),
	.mmu_dtexc_m(mmu_dtexc_m),
	.mmu_dtmack_m(mmu_dtmack_m),
	.mmu_dtriexc_m(mmu_dtriexc_m),
	.mmu_dva_m(mmu_dva_m),
	.mmu_dva_mapped_m(mmu_dva_mapped_m),
	.mmu_gid(mmu_gid),
	.mmu_icacabl(mmu_icacabl),
	.mmu_iec(mmu_iec),
	.mmu_imagicl(mmu_imagicl),
	.mmu_ipah(mmu_ipah),
	.mmu_it_segerr(mmu_it_segerr),
	.mmu_itexc_i(mmu_itexc_i),
	.mmu_itmack_i(mmu_itmack_i),
	.mmu_itmres_nxt_i(mmu_itmres_nxt_i),
	.mmu_itxiexc_i(mmu_itxiexc_i),
	.mmu_ivastrobe(mmu_ivastrobe),
	.mmu_pm_dthit(mmu_pm_dthit),
	.mmu_pm_dtlb_miss_qual(mmu_pm_dtlb_miss_qual),
	.mmu_pm_dtmiss(mmu_pm_dtmiss),
	.mmu_pm_ithit(mmu_pm_ithit),
	.mmu_pm_itmiss(mmu_pm_itmiss),
	.mmu_pm_jthit(mmu_pm_jthit),
	.mmu_pm_jthit_d(mmu_pm_jthit_d),
	.mmu_pm_jthit_i(mmu_pm_jthit_i),
	.mmu_pm_jtmiss(mmu_pm_jtmiss),
	.mmu_pm_jtmiss_d(mmu_pm_jtmiss_d),
	.mmu_pm_jtmiss_i(mmu_pm_jtmiss_i),
	.mmu_r_adrerr(mmu_r_adrerr),
	.mmu_r_asid(mmu_r_asid),
	.mmu_r_asid_valid(mmu_r_asid_valid),
	.mmu_r_cpyout(mmu_r_cpyout),
	.mmu_r_dtexc_m(mmu_r_dtexc_m),
	.mmu_r_dtriexc_m(mmu_r_dtriexc_m),
	.mmu_r_iec(mmu_r_iec),
	.mmu_r_it_segerr(mmu_r_it_segerr),
	.mmu_r_itexc_i(mmu_r_itexc_i),
	.mmu_r_itxiexc_i(mmu_r_itxiexc_i),
	.mmu_r_pm_jthit_d(mmu_r_pm_jthit_d),
	.mmu_r_pm_jthit_i(mmu_r_pm_jthit_i),
	.mmu_r_pm_jtmiss_d(mmu_r_pm_jtmiss_d),
	.mmu_r_pm_jtmiss_i(mmu_r_pm_jtmiss_i),
	.mmu_r_rawdtexc_m(mmu_r_rawdtexc_m),
	.mmu_r_rawitexc_i(mmu_r_rawitexc_i),
	.mmu_r_read_m(mmu_r_read_m),
	.mmu_r_size(mmu_r_size),
	.mmu_r_tlbbusy(mmu_r_tlbbusy),
	.mmu_r_tlbinv(mmu_r_tlbinv),
	.mmu_r_tlbmod(mmu_r_tlbmod),
	.mmu_r_tlbrefill(mmu_r_tlbrefill),
	.mmu_r_tlbshutdown(mmu_r_tlbshutdown),
	.mmu_r_transexc(mmu_r_transexc),
	.mmu_r_type(mmu_r_type),
	.mmu_r_vafromi(mmu_r_vafromi),
	.mmu_rawdtexc_m(mmu_rawdtexc_m),
	.mmu_rawitexc_i(mmu_rawitexc_i),
	.mmu_read_m(mmu_read_m),
	.mmu_rid(mmu_rid),
	.mmu_size(mmu_size),
	.mmu_tlbbusy(mmu_tlbbusy),
	.mmu_tlbinv(mmu_tlbinv),
	.mmu_tlbmod(mmu_tlbmod),
	.mmu_tlbrefill(mmu_tlbrefill),
	.mmu_tlbshutdown(mmu_tlbshutdown),
	.mmu_transexc(mmu_transexc),
	.mmu_type(mmu_type),
	.mmu_vafromi(mmu_vafromi),
	.mmu_vat_hi(mmu_vat_hi),
	.mpc_annulds_e(mpc_annulds_e),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_bussize_m(mpc_bussize_m),
	.mpc_busty_m(mpc_busty_m),
	.mpc_busty_raw_e(mpc_busty_raw_e),
	.mpc_continue_squash_i(mpc_continue_squash_i),
	.mpc_cp0func_e(mpc_cp0func_e),
	.mpc_cp0move_m(mpc_cp0move_m),
	.mpc_cp0r_m(mpc_cp0r_m),
	.mpc_cp0sr_m(mpc_cp0sr_m),
	.mpc_ctlen_noe_e(mpc_ctlen_noe_e),
	.mpc_dmsquash_m(mpc_dmsquash_m),
	.mpc_eexc_e(mpc_eexc_e),
	.mpc_exc_e(mpc_exc_e),
	.mpc_exc_m(mpc_exc_m),
	.mpc_excisamode_i(mpc_excisamode_i),
	.mpc_fixup_m(mpc_fixup_m),
	.mpc_fixupi(mpc_fixupi),
	.mpc_g_cp0func_e(mpc_g_cp0func_e),
	.mpc_g_cp0move_m(mpc_g_cp0move_m),
	.mpc_g_eexc_e(mpc_g_eexc_e),
	.mpc_g_jamtlb_w(mpc_g_jamtlb_w),
	.mpc_irval_e(mpc_irval_e),
	.mpc_isamode_i(mpc_isamode_i),
	.mpc_itqualcond_i(mpc_itqualcond_i),
	.mpc_jamtlb_w(mpc_jamtlb_w),
	.mpc_ll1_m(mpc_ll1_m),
	.mpc_load_m(mpc_load_m),
	.mpc_lsdc1_m(mpc_lsdc1_m),
	.mpc_newiaddr(mpc_newiaddr),
	.mpc_nobds_e(mpc_nobds_e),
	.mpc_pcrel_m(mpc_pcrel_m),
	.mpc_pexc_i(mpc_pexc_i),
	.mpc_pexc_m(mpc_pexc_m),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_squash_i(mpc_squash_i),
	.r_asid_update(r_asid_update),
	.r_gtlbclk(r_gtlbclk),
	.r_jtlb_wr(r_jtlb_wr));

/*hookup*/
`M14K_ICC_MODULE icc (
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
	.ISP_TagRdValue(ISP_TagRdValue),
	.ISP_TagWrStr(ISP_TagWrStr),
	.ISP_WPar(ISP_WPar),
	.asid_update(asid_update),
	.biu_datain(biu_datain),
	.biu_datawd(biu_datawd),
	.biu_ibe(biu_ibe),
	.biu_ibe_pre(biu_ibe_pre),
	.biu_idataval(biu_idataval),
	.biu_if_enable(biu_if_enable),
	.biu_lastwd(biu_lastwd),
	.cdmm_mputrigresraw_i(cdmm_mputrigresraw_i),
	.cpz_config_ld(cpz_config_ld),
	.cpz_datalo(cpz_datalo),
	.cpz_g_config_ld(cpz_g_config_ld),
	.cpz_g_mx(cpz_g_mx),
	.cpz_g_rbigend_i(cpz_g_rbigend_i),
	.cpz_gm_i(cpz_gm_i),
	.cpz_goodnight(cpz_goodnight),
	.cpz_icnsets(cpz_icnsets),
	.cpz_icpresent(cpz_icpresent),
	.cpz_icssize(cpz_icssize),
	.cpz_isppresent(cpz_isppresent),
	.cpz_mx(cpz_mx),
	.cpz_pe(cpz_pe),
	.cpz_pi(cpz_pi),
	.cpz_po(cpz_po),
	.cpz_rbigend_i(cpz_rbigend_i),
	.cpz_spram(cpz_spram),
	.cpz_taglo(cpz_taglo),
	.cpz_vz(cpz_vz),
	.cpz_wst(cpz_wst),
	.dcc_advance_m(dcc_advance_m),
	.dcc_copsync_m(dcc_copsync_m),
	.dcc_dval_m(dcc_dval_m),
	.edp_iva_i(edp_iva_i),
	.edp_ival_exe_p(edp_iva_p[19:1]),
	.edp_ival_p(edp_cacheiva_p[19:1]),
	.gclk(gclk),
	.gmb_ic_algorithm(gmb_ic_algorithm),
	.gmb_isp_algorithm(gmb_isp_algorithm),
	.gmbdifail(gmbdifail),
	.gmbinvoke(gmbinvoke),
	.gmbispfail(gmbispfail),
	.gmbtifail(gmbtifail),
	.gmbwifail(gmbwifail),
	.greset(greset),
	.gscanenable(gscanenable),
	.gscanmode(gscanmode),
	.gscanramwr(gscanramwr),
	.ic_datain(ic_datain),
	.ic_tagin(ic_tagin),
	.ic_wsin(ic_wsin),
	.ica_parity_present(ica_parity_present),
	.icc_addiupc_22_21_e(icc_addiupc_22_21_e),
	.icc_data(icc_data),
	.icc_dataaddr(icc_dataaddr),
	.icc_derr_way(icc_derr_way),
	.icc_drstb(icc_drstb),
	.icc_dspver_i(icc_dspver_i),
	.icc_dwstb(icc_dwstb),
	.icc_early_data_ce(icc_early_data_ce),
	.icc_early_tag_ce(icc_early_tag_ce),
	.icc_early_ws_ce(icc_early_ws_ce),
	.icc_exaddr(icc_exaddr),
	.icc_excached(icc_excached),
	.icc_exhe(icc_exhe),
	.icc_exmagicl(icc_exmagicl),
	.icc_exreqval(icc_exreqval),
	.icc_fb_vld(icc_fb_vld),
	.icc_halfworddethigh_fifo_i(icc_halfworddethigh_fifo_i),
	.icc_halfworddethigh_i(icc_halfworddethigh_i),
	.icc_icop_m(icc_icop_m),
	.icc_icopdata(icc_icopdata),
	.icc_icopld(icc_icopld),
	.icc_icoppar(icc_icoppar),
	.icc_icopstall(icc_icopstall),
	.icc_icoptag(icc_icoptag),
	.icc_idata_i(icc_idata_i),
	.icc_imiss_i(icc_imiss_i),
	.icc_isachange0_i_reg(icc_isachange0_i_reg),
	.icc_isachange1_i_reg(icc_isachange1_i_reg),
	.icc_macro_e(icc_macro_e),
	.icc_macro_jr(icc_macro_jr),
	.icc_macrobds_e(icc_macrobds_e),
	.icc_macroend_e(icc_macroend_e),
	.icc_mbdone(icc_mbdone),
	.icc_nobds_e(icc_nobds_e),
	.icc_parerr_cpz_w(icc_parerr_cpz_w),
	.icc_parerr_data(icc_parerr_data),
	.icc_parerr_i(icc_parerr_i),
	.icc_parerr_idx(icc_parerr_idx),
	.icc_parerr_tag(icc_parerr_tag),
	.icc_parerr_w(icc_parerr_w),
	.icc_parerrint_i(icc_parerrint_i),
	.icc_pcrel_e(icc_pcrel_e),
	.icc_pm_icmiss(icc_pm_icmiss),
	.icc_poten_be(icc_poten_be),
	.icc_preciseibe_e(icc_preciseibe_e),
	.icc_preciseibe_i(icc_preciseibe_i),
	.icc_predec_i(icc_predec_i),
	.icc_rdpgpr_i(icc_rdpgpr_i),
	.icc_readmask(icc_readmask),
	.icc_slip_n_nhalf(icc_slip_n_nhalf),
	.icc_sp_pres(icc_sp_pres),
	.icc_spmbdone(icc_spmbdone),
	.icc_spram_stall(icc_spram_stall),
	.icc_spwr_active(icc_spwr_active),
	.icc_stall_i(icc_stall_i),
	.icc_tagaddr(icc_tagaddr),
	.icc_tagwrdata(icc_tagwrdata),
	.icc_tagwren(icc_tagwren),
	.icc_trstb(icc_trstb),
	.icc_twstb(icc_twstb),
	.icc_umips_16bit_needed(icc_umips_16bit_needed),
	.icc_umips_active(icc_umips_active),
	.icc_umips_instn_i(icc_umips_instn_i),
	.icc_umips_sds(icc_umips_sds),
	.icc_umipsconfig(icc_umipsconfig),
	.icc_umipsfifo_ieip2(icc_umipsfifo_ieip2),
	.icc_umipsfifo_ieip4(icc_umipsfifo_ieip4),
	.icc_umipsfifo_imip(icc_umipsfifo_imip),
	.icc_umipsfifo_null_i(icc_umipsfifo_null_i),
	.icc_umipsfifo_null_raw(icc_umipsfifo_null_raw),
	.icc_umipsfifo_stat(icc_umipsfifo_stat),
	.icc_umipsmode_i(icc_umipsmode_i),
	.icc_umipspresent(icc_umipspresent),
	.icc_umipsri_e(icc_umipsri_e),
	.icc_writemask(icc_writemask),
	.icc_wsaddr(icc_wsaddr),
	.icc_wsrstb(icc_wsrstb),
	.icc_wswrdata(icc_wswrdata),
	.icc_wswren(icc_wswren),
	.icc_wswstb(icc_wswstb),
	.isp_data_parerr(isp_data_parerr),
	.isp_dataaddr_scr(isp_dataaddr_scr),
	.mmu_dcmode0(mmu_dcmode[0]),
	.mmu_dpah(mmu_dpah),
	.mmu_icacabl(mmu_icacabl),
	.mmu_imagicl(mmu_imagicl),
	.mmu_ipah(mmu_ipah),
	.mmu_itmack_i(mmu_itmack_i),
	.mmu_itmres_nxt_i(mmu_itmres_nxt_i),
	.mmu_r_rawitexc_i(mmu_r_rawitexc_i),
	.mmu_rawitexc_i(mmu_rawitexc_i),
	.mpc_annulds_e(mpc_annulds_e),
	.mpc_atomic_e(mpc_atomic_e),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_auexc_x(mpc_auexc_x),
	.mpc_chain_take(mpc_chain_take),
	.mpc_cont_pf_phase1(mpc_cont_pf_phase1),
	.mpc_coptype_m(mpc_coptype_m),
	.mpc_epi_vec(mpc_epi_vec),
	.mpc_fixupd(mpc_fixupd),
	.mpc_fixupi(mpc_fixupi),
	.mpc_hold_epi_vec(mpc_hold_epi_vec),
	.mpc_hold_int_pref_phase1_val(mpc_hold_int_pref_phase1_val),
	.mpc_hw_ls_i(mpc_hw_ls_i),
	.mpc_ibrk_qual(mpc_ibrk_qual),
	.mpc_iccop_m(mpc_iccop_m),
	.mpc_icop_m(mpc_icop_m),
	.mpc_imsquash_e(mpc_imsquash_e),
	.mpc_imsquash_i(mpc_imsquash_i),
	.mpc_int_pref(mpc_int_pref),
	.mpc_isachange0_i(mpc_isachange0_i),
	.mpc_isachange1_i(mpc_isachange1_i),
	.mpc_isamode_i(mpc_isamode_i),
	.mpc_itqualcond_i(mpc_itqualcond_i),
	.mpc_lsdc1_e(mpc_lsdc1_e),
	.mpc_macro_e(mpc_macro_e),
	.mpc_nonseq_e(mpc_nonseq_e),
	.mpc_nonseq_ep(mpc_nonseq_ep),
	.mpc_run_ie(mpc_run_ie),
	.mpc_sel_hw_e(mpc_sel_hw_e),
	.mpc_sequential_e(mpc_sequential_e),
	.mpc_squash_i(mpc_squash_i),
	.mpc_tint(mpc_tint),
	.mpc_umipsfifosupport_i(mpc_umipsfifosupport_i),
	.mpc_umipspresent(mpc_umipspresent),
	.r_asid_update(r_asid_update));



/*hookup*/
`M14K_DCC_MODULE dcc (
	.CP1_endian_0(CP1_endian_0),
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
	.biu_datain(biu_datain),
	.biu_datawd(biu_datawd),
	.biu_dbe(biu_dbe),
	.biu_dbe_pre(biu_dbe_pre),
	.biu_ddataval(biu_ddataval),
	.biu_dreqsdone(biu_dreqsdone),
	.biu_lastwd(biu_lastwd),
	.biu_mbdata(biu_mbdata),
	.biu_mbtag(biu_mbtag),
	.biu_nofreebuff(biu_nofreebuff),
	.biu_wtbf(biu_wtbf),
	.cp1_data_missing(cp1_data_missing),
	.cp1_data_w(cp1_data_w),
	.cp1_datasel(cp1_datasel),
	.cp1_exc_w(cp1_exc_w),
	.cp1_fixup_m(cp1_fixup_m),
	.cp1_fixup_w(cp1_fixup_w),
	.cp1_fixup_w_nolsdc1(cp1_fixup_w_nolsdc1),
	.cp1_ldst_m(cp1_ldst_m),
	.cp1_missexc_w(cp1_missexc_w),
	.cp1_seen_nodmiss_m(cp1_seen_nodmiss_m),
	.cp1_storealloc_reg(cp1_storealloc_reg),
	.cp1_storeissued_m(cp1_storeissued_m),
	.cp1_storekill_w(cp1_storekill_w),
	.cp2_data_w(cp2_data_w),
	.cp2_datasel(cp2_datasel),
	.cp2_exc_w(cp2_exc_w),
	.cp2_fixup_m(cp2_fixup_m),
	.cp2_fixup_w(cp2_fixup_w),
	.cp2_ldst_m(cp2_ldst_m),
	.cp2_missexc_w(cp2_missexc_w),
	.cp2_storealloc_reg(cp2_storealloc_reg),
	.cp2_storeissued_m(cp2_storeissued_m),
	.cp2_storekill_w(cp2_storekill_w),
	.cpz_causeap(cpz_causeap),
	.cpz_datalo(cpz_datalo),
	.cpz_dcnsets(cpz_dcnsets),
	.cpz_dcpresent(cpz_dcpresent),
	.cpz_dcssize(cpz_dcssize),
	.cpz_dsppresent(cpz_dsppresent),
	.cpz_g_causeap(cpz_g_causeap),
	.cpz_g_int_mw(cpz_g_int_mw),
	.cpz_g_llbit(cpz_g_llbit),
	.cpz_gm_e(cpz_gm_e),
	.cpz_gm_m(cpz_gm_m),
	.cpz_int_mw(cpz_int_mw),
	.cpz_llbit(cpz_llbit),
	.cpz_mbtag(cpz_mbtag),
	.cpz_pd(cpz_pd),
	.cpz_pe(cpz_pe),
	.cpz_po(cpz_po),
	.cpz_spram(cpz_spram),
	.cpz_taglo(cpz_taglo),
	.cpz_wst(cpz_wst),
	.dc_datain(dc_datain),
	.dc_tagin(dc_tagin),
	.dc_wsin(dc_wsin),
	.dca_parity_present(dca_parity_present),
	.dcc_advance_m(dcc_advance_m),
	.dcc_copsync_m(dcc_copsync_m),
	.dcc_data(dcc_data),
	.dcc_dataaddr(dcc_dataaddr),
	.dcc_dbe_killfixup_w(dcc_dbe_killfixup_w),
	.dcc_dcached_m(dcc_dcached_m),
	.dcc_dcop_stall(dcc_dcop_stall),
	.dcc_dcopaccess_m(dcc_dcopaccess_m),
	.dcc_dcopdata_m(dcc_dcopdata_m),
	.dcc_dcopld_m(dcc_dcopld_m),
	.dcc_dcoppar_m(dcc_dcoppar_m),
	.dcc_dcoptag_m(dcc_dcoptag_m),
	.dcc_ddata_m(dcc_ddata_m),
	.dcc_derr_way(dcc_derr_way),
	.dcc_dmiss_m(dcc_dmiss_m),
	.dcc_drstb(dcc_drstb),
	.dcc_dspram_stall(dcc_dspram_stall),
	.dcc_dval_m(dcc_dval_m),
	.dcc_dvastrobe(dcc_dvastrobe),
	.dcc_dwstb(dcc_dwstb),
	.dcc_early_data_ce(dcc_early_data_ce),
	.dcc_early_tag_ce(dcc_early_tag_ce),
	.dcc_early_ws_ce(dcc_early_ws_ce),
	.dcc_ejdata(dcc_ejdata),
	.dcc_ev(dcc_ev),
	.dcc_ev_kill(dcc_ev_kill),
	.dcc_exaddr(dcc_exaddr),
	.dcc_exaddr_ev(dcc_exaddr_ev),
	.dcc_exaddr_sel(dcc_exaddr_sel),
	.dcc_exbe(dcc_exbe),
	.dcc_exc_nokill_m(dcc_exc_nokill_m),
	.dcc_excached(dcc_excached),
	.dcc_exdata(dcc_exdata),
	.dcc_exmagicl(dcc_exmagicl),
	.dcc_exnewaddr(dcc_exnewaddr),
	.dcc_exrdreqval(dcc_exrdreqval),
	.dcc_exsyncreq(dcc_exsyncreq),
	.dcc_exwrreqval(dcc_exwrreqval),
	.dcc_fixup_w(dcc_fixup_w),
	.dcc_intkill_m(dcc_intkill_m),
	.dcc_intkill_w(dcc_intkill_w),
	.dcc_lddatastr_w(dcc_lddatastr_w),
	.dcc_ldst_m(dcc_ldst_m),
	.dcc_lscacheread_m(dcc_lscacheread_m),
	.dcc_mbdone(dcc_mbdone),
	.dcc_newdaddr(dcc_newdaddr),
	.dcc_par_kill_mw(dcc_par_kill_mw),
	.dcc_parerr_cpz_w(dcc_parerr_cpz_w),
	.dcc_parerr_data(dcc_parerr_data),
	.dcc_parerr_ev(dcc_parerr_ev),
	.dcc_parerr_idx(dcc_parerr_idx),
	.dcc_parerr_m(dcc_parerr_m),
	.dcc_parerr_tag(dcc_parerr_tag),
	.dcc_parerr_w(dcc_parerr_w),
	.dcc_parerr_ws(dcc_parerr_ws),
	.dcc_pm_dcmiss_pc(dcc_pm_dcmiss_pc),
	.dcc_pm_dhit_m(dcc_pm_dhit_m),
	.dcc_pm_fb_active(dcc_pm_fb_active),
	.dcc_pm_fbfull(dcc_pm_fbfull),
	.dcc_precisedbe_w(dcc_precisedbe_w),
	.dcc_sc_ack_m(dcc_sc_ack_m),
	.dcc_sp_pres(dcc_sp_pres),
	.dcc_spmbdone(dcc_spmbdone),
	.dcc_spram_write(dcc_spram_write),
	.dcc_stall_m(dcc_stall_m),
	.dcc_stalloc(dcc_stalloc),
	.dcc_stdstrobe(dcc_stdstrobe),
	.dcc_store_allocate(dcc_store_allocate),
	.dcc_tagaddr(dcc_tagaddr),
	.dcc_tagwrdata(dcc_tagwrdata),
	.dcc_tagwren(dcc_tagwren),
	.dcc_trstb(dcc_trstb),
	.dcc_twstb(dcc_twstb),
	.dcc_uncache_load(dcc_uncache_load),
	.dcc_uncached_store(dcc_uncached_store),
	.dcc_valid_d_access(dcc_valid_d_access),
	.dcc_wb(dcc_wb),
	.dcc_writemask(dcc_writemask),
	.dcc_wsaddr(dcc_wsaddr),
	.dcc_wsrstb(dcc_wsrstb),
	.dcc_wswrdata(dcc_wswrdata),
	.dcc_wswren(dcc_wswren),
	.dcc_wswstb(dcc_wswstb),
	.dmbinvoke(dmbinvoke),
	.dsp_data_parerr(dsp_data_parerr),
	.edp_dval_e(edp_dva_e[19:2]),
	.edp_ldcpdata_w(edp_ldcpdata_w),
	.edp_stdata_iap_m(edp_stdata_iap_m),
	.edp_stdata_m(edp_stdata_m),
	.ejt_stall_st_e(ejt_stall_st_e),
	.gclk(gclk),
	.gmb_dc_algorithm(gmb_dc_algorithm),
	.gmb_sp_algorithm(gmb_sp_algorithm),
	.gmbddfail(gmbddfail),
	.gmbinvoke(gmbinvoke),
	.gmbspfail(gmbspfail),
	.gmbtdfail(gmbtdfail),
	.gmbwdfail(gmbwdfail),
	.greset(greset),
	.gscanenable(gscanenable),
	.gscanmode(gscanmode),
	.gscanramwr(gscanramwr),
	.icc_icopstall(icc_icopstall),
	.icc_parerr_w(icc_parerr_w),
	.mmu_dcmode(mmu_dcmode),
	.mmu_dpah(mmu_dpah),
	.mmu_dtmack_m(mmu_dtmack_m),
	.mmu_r_rawdtexc_m(mmu_r_rawdtexc_m),
	.mmu_rawdtexc_m(mmu_rawdtexc_m),
	.mpc_atomic_load_e(mpc_atomic_load_e),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_atomic_store_w(mpc_atomic_store_w),
	.mpc_atomic_w(mpc_atomic_w),
	.mpc_busty_e(mpc_busty_e),
	.mpc_busty_raw_e(mpc_busty_raw_e),
	.mpc_chain_take(mpc_chain_take),
	.mpc_coptype_m(mpc_coptype_m),
	.mpc_dmsquash_m(mpc_dmsquash_m),
	.mpc_dmsquash_w(mpc_dmsquash_w),
	.mpc_dparerr_for_eviction(mpc_dparerr_for_eviction),
	.mpc_exc_e(mpc_exc_e),
	.mpc_exc_iae(mpc_exc_iae),
	.mpc_exc_m(mpc_exc_m),
	.mpc_exc_w(mpc_exc_w),
	.mpc_fixup_m(mpc_fixup_m),
	.mpc_fixupd(mpc_fixupd),
	.mpc_hw_load_epc_m(mpc_hw_load_epc_m),
	.mpc_hw_load_srsctl_m(mpc_hw_load_srsctl_m),
	.mpc_hw_save_srsctl_m(mpc_hw_save_srsctl_m),
	.mpc_hw_save_status_m(mpc_hw_save_status_m),
	.mpc_idx_cop_e(mpc_idx_cop_e),
	.mpc_lsbe_m(mpc_lsbe_m),
	.mpc_lsdc1_m(mpc_lsdc1_m),
	.mpc_lsdc1_w(mpc_lsdc1_w),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_run_w(mpc_run_w),
	.mpc_sbstrobe_w(mpc_sbstrobe_w),
	.mpc_sc_e(mpc_sc_e),
	.mpc_sdbreak_w(mpc_sdbreak_w),
	.mpc_sdc1_w(mpc_sdc1_w),
	.pdva_load(pdva_load));

/*hookup*/ 
m14k_biu biu (
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
	.SI_AHBStb(SI_AHBStb),
	.SI_MergeMode(SI_MergeMode),
	.biu_be_ej(biu_be_ej),
	.biu_datain(biu_datain),
	.biu_datawd(biu_datawd),
	.biu_dbe(biu_dbe),
	.biu_dbe_exc(biu_dbe_exc),
	.biu_dbe_pre(biu_dbe_pre),
	.biu_ddataval(biu_ddataval),
	.biu_dreqsdone(biu_dreqsdone),
	.biu_eaaccess(biu_eaaccess),
	.biu_ibe(biu_ibe),
	.biu_ibe_exc(biu_ibe_exc),
	.biu_ibe_pre(biu_ibe_pre),
	.biu_idataval(biu_idataval),
	.biu_if_enable(biu_if_enable),
	.biu_lastwd(biu_lastwd),
	.biu_lock(biu_lock),
	.biu_mbdata(biu_mbdata),
	.biu_mbtag(biu_mbtag),
	.biu_merging(biu_merging),
	.biu_nofreebuff(biu_nofreebuff),
	.biu_pm_wr_buf_b(biu_pm_wr_buf_b),
	.biu_pm_wr_buf_f(biu_pm_wr_buf_f),
	.biu_shutdown(biu_shutdown),
	.biu_wbe(biu_wbe),
	.biu_wtbf(biu_wtbf),
	.cp1_copidle(cp1_copidle),
	.cp2_copidle(cp2_copidle),
	.cpz_rbigend_e(cpz_rbigend_e),
	.dcc_ev_kill(dcc_ev_kill),
	.dcc_exaddr(dcc_exaddr),
	.dcc_exaddr_ev(dcc_exaddr_ev),
	.dcc_exaddr_sel(dcc_exaddr_sel),
	.dcc_exbe(dcc_exbe),
	.dcc_excached(dcc_excached),
	.dcc_exdata(dcc_exdata),
	.dcc_exmagicl(dcc_exmagicl),
	.dcc_exnewaddr(dcc_exnewaddr),
	.dcc_exrdreqval(dcc_exrdreqval),
	.dcc_exsyncreq(dcc_exsyncreq),
	.dcc_exwrreqval(dcc_exwrreqval),
	.dcc_mbdone(dcc_mbdone),
	.dcc_spmbdone(dcc_spmbdone),
	.dcc_stalloc(dcc_stalloc),
	.dmbinvoke(dmbinvoke),
	.ejt_eadata(ejt_eadata),
	.ejt_eadone(ejt_eadone),
	.ejt_pdt_fifo_empty(ejt_pdt_fifo_empty),
	.gclk(gclk),
	.gfclk(gfclk),
	.gmbdone(gmbdone),
	.greset(greset),
	.gscanenable(gscanenable),
	.icc_exaddr(icc_exaddr),
	.icc_excached(icc_excached),
	.icc_exhe(icc_exhe),
	.icc_exmagicl(icc_exmagicl),
	.icc_exreqval(icc_exreqval),
	.icc_mbdone(icc_mbdone),
	.icc_spmbdone(icc_spmbdone),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_atomic_w(mpc_atomic_w),
	.mpc_exc_m(mpc_exc_m),
	.mpc_wait_w(mpc_wait_w));


/*hookup*/
m14k_siu siu (
	.SI_BootExcISAMode(SI_BootExcISAMode),
	.SI_CPUNum(SI_CPUNum),
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
	.brk_dbs_bs(brk_dbs_bs),
	.brk_ibs_bs(brk_ibs_bs),
	.cpz_cause_pci(cpz_cause_pci),
	.cpz_erl(cpz_erl),
	.cpz_exl(cpz_exl),
	.cpz_fdcint(cpz_fdcint),
	.cpz_g_cause_pci(cpz_g_cause_pci),
	.cpz_g_iack(cpz_g_iack),
	.cpz_g_ion(cpz_g_ion),
	.cpz_g_ipl(cpz_g_ipl),
	.cpz_g_ivn(cpz_g_ivn),
	.cpz_g_swint(cpz_g_swint),
	.cpz_g_timerint(cpz_g_timerint),
	.cpz_gid(cpz_gid),
	.cpz_goodnight(cpz_goodnight),
	.cpz_iack(cpz_iack),
	.cpz_ion(cpz_ion),
	.cpz_ipl(cpz_ipl),
	.cpz_ivn(cpz_ivn),
	.cpz_nest_erl(cpz_nest_erl),
	.cpz_nest_exl(cpz_nest_exl),
	.cpz_nmi(cpz_nmi),
	.cpz_rp(cpz_rp),
	.cpz_swint(cpz_swint),
	.cpz_timerint(cpz_timerint),
	.gclk(gclk),
	.gfclk(gfclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.siu_bigend(siu_bigend),
	.siu_bootexcisamode(siu_bootexcisamode),
	.siu_coldreset(siu_coldreset),
	.siu_cpunum(siu_cpunum),
	.siu_eicgid(siu_eicgid),
	.siu_eicpresent(siu_eicpresent),
	.siu_eicvector(siu_eicvector),
	.siu_eiss(siu_eiss),
	.siu_g_eicvector(siu_g_eicvector),
	.siu_g_eiss(siu_g_eiss),
	.siu_g_int(siu_g_int),
	.siu_g_offset(siu_g_offset),
	.siu_ifdci(siu_ifdci),
	.siu_int(siu_int),
	.siu_ippci(siu_ippci),
	.siu_ipti(siu_ipti),
	.siu_nmi(siu_nmi),
	.siu_offset(siu_offset),
	.siu_slip(siu_slip),
	.siu_srsdisable(siu_srsdisable),
	.siu_tracedisable(siu_tracedisable));

/*hookup*/
m14k_ejt ejt(
	.AHB_EAddr(HADDR[31:2]),
	.CP1_endian_0(CP1_endian_0),
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
	.HWDATA(HWDATA),
	.HWRITE(HWRITE),
	.TC_ClockRatio(TC_ClockRatio),
	.TC_Data(TC_Data),
	.TC_PibPresent(TC_PibPresent),
	.TC_Stall(TC_Stall),
	.TC_Valid(TC_Valid),
	.bc_tcbbistto(bc_tcbbistto),
	.biu_be_ej(biu_be_ej),
	.biu_eaaccess(biu_eaaccess),
	.biu_if_enable(biu_if_enable),
	.brk_d_trig(brk_d_trig),
	.brk_dbs_bs(brk_dbs_bs),
	.brk_i_trig(brk_i_trig),
	.brk_ibs_bs(brk_ibs_bs),
	.cdmm_area(cdmm_area),
	.cdmm_ej_override(cdmm_ej_override),
	.cdmm_fdc_hit(cdmm_fdc_hit),
	.cdmm_fdcgwrite(cdmm_fdcgwrite),
	.cdmm_fdcread(cdmm_fdcread),
	.cdmm_hit(cdmm_hit),
	.cdmm_mpuipdt_w(cdmm_mpuipdt_w),
	.cdmm_rdata_xx(cdmm_rdata_xx),
	.cdmm_sel(cdmm_sel),
	.cdmm_wdata_xx(cdmm_wdata_xx),
	.cp1_data_w(cp1_data_w),
	.cp1_ldst_m(cp1_ldst_m),
	.cp1_storeissued_m(cp1_storeissued_m),
	.cp2_data_w(cp2_data_w),
	.cp2_ldst_m(cp2_ldst_m),
	.cp2_storeissued_m(cp2_storeissued_m),
	.cpz_bds_x(cpz_bds_x),
	.cpz_bootisamode(cpz_bootisamode),
	.cpz_cdmmbase(cpz_cdmmbase),
	.cpz_dm(cpz_dm),
	.cpz_dm_w(cpz_dm_w),
	.cpz_doze(cpz_doze),
	.cpz_eisa_w(cpz_eisa_w),
	.cpz_enm(cpz_enm),
	.cpz_epc_w(cpz_epc_w),
	.cpz_erl(cpz_ejt_erl),
	.cpz_exl(cpz_ejt_exl),
	.cpz_guestid(cpz_guestid),
	.cpz_guestid_i(cpz_guestid_i),
	.cpz_guestid_m(cpz_guestid_m),
	.cpz_halt(cpz_halt),
	.cpz_hotdm_i(cpz_hotdm_i),
	.cpz_iap_exce_handler_trace(cpz_iap_exce_handler_trace),
	.cpz_kuc_m(cpz_ejt_kuc_m),
	.cpz_kuc_w(cpz_ejt_kuc_w),
	.cpz_mmutype(cpz_ejt_mmutype),
	.cpz_nmipend(cpz_nmipend),
	.cpz_um(cpz_ejt_um),
	.cpz_um_vld(cpz_ejt_um_vld),
	.cpz_vz(cpz_vz),
	.dcc_dvastrobe(dcc_dvastrobe),
	.dcc_ejdata(dcc_ejdata),
	.dcc_lddatastr_w(dcc_lddatastr_w),
	.dcc_ldst_m(dcc_ldst_m),
	.dcc_sc_ack_m(dcc_sc_ack_m),
	.dcc_stdstrobe(dcc_stdstrobe),
	.edp_alu_m(edp_alu_m),
	.edp_iva_i(edp_iva_i),
	.edp_ldcpdata_w(edp_ldcpdata_w),
	.edp_res_w(edp_res_w),
	.ej_fdc_busy_xx(ej_fdc_busy_xx),
	.ej_fdc_int(ej_fdc_int),
	.ej_isaondebug_read(ej_isaondebug_read),
	.ej_probtrap(ej_probtrap),
	.ej_rdvec(ej_rdvec),
	.ej_rdvec_read(ej_rdvec_read),
	.ejt_cbrk_m(ejt_cbrk_m),
	.ejt_cbrk_type_m(ejt_cbrk_type_m),
	.ejt_dbrk_m(ejt_dbrk_m),
	.ejt_dbrk_w(ejt_dbrk_w),
	.ejt_dcrinte(ejt_dcrinte),
	.ejt_dcrnmie(ejt_dcrnmie),
	.ejt_disableprobedebug(ejt_disableprobedebug),
	.ejt_dvabrk(ejt_dvabrk),
	.ejt_eadata(ejt_eadata),
	.ejt_eadone(ejt_eadone),
	.ejt_ejtagbrk(ejt_ejtagbrk),
	.ejt_ivabrk(ejt_ivabrk),
	.ejt_pdt_fifo_empty(ejt_pdt_fifo_empty),
	.ejt_pdt_present(ejt_pdt_present),
	.ejt_pdt_stall_w(ejt_pdt_stall_w),
	.ejt_predonenxt(ejt_predonenxt),
	.ejt_stall_st_e(ejt_stall_st_e),
	.fdc_present(fdc_present),
	.fdc_rdata_nxt(fdc_rdata_nxt),
	.gclk(gclk),
	.gfclk(gfclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.gscanmode(gscanmode),
	.icc_halfworddethigh_i(icc_halfworddethigh_i),
	.icc_imiss_i(icc_imiss_i),
	.icc_isachange0_i_reg(icc_isachange0_i_reg),
	.icc_isachange1_i_reg(icc_isachange1_i_reg),
	.icc_macro_e(icc_macro_e),
	.icc_nobds_e(icc_nobds_e),
	.icc_pm_icmiss(icc_pm_icmiss),
	.icc_umipsfifo_null_i(icc_umipsfifo_null_i),
	.icc_umipsfifo_null_w(icc_umipsfifo_null_w),
	.icc_umipspresent(icc_umipspresent),
	.mmu_asid(mmu_ejt_asid),
	.mmu_asid_m(mmu_ejt_asid_m),
	.mmu_asid_valid(mmu_asid_valid),
	.mmu_cdmm_kuc_m(mmu_cdmm_kuc_m),
	.mmu_dva_m(mmu_dva_m),
	.mmu_ivastrobe(mmu_ivastrobe),
	.mpc_atomic_e(mpc_atomic_e),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_atomic_w(mpc_atomic_w),
	.mpc_auexc_x(mpc_auexc_x),
	.mpc_bds_m(mpc_bds_m),
	.mpc_be_w(mpc_be_w),
	.mpc_bussize_m(mpc_bussize_m),
	.mpc_cbstrobe_w(mpc_cbstrobe_w),
	.mpc_cleard_strobe(mpc_cleard_strobe),
	.mpc_cp0move_m(mpc_cp0move_m),
	.mpc_cp0r_m(mpc_cp0r_m),
	.mpc_cp0sr_m(mpc_cp0sr_m),
	.mpc_dmsquash_m(mpc_dmsquash_m),
	.mpc_eqcond_e(mpc_eqcond_e),
	.mpc_exc_w(mpc_exc_w_org),
	.mpc_fixup_m(mpc_fixup_m),
	.mpc_fixupd(mpc_fixupd),
	.mpc_fixupi(mpc_fixupi),
	.mpc_ireton_e(mpc_ireton_e),
	.mpc_irval_e(mpc_irval_e),
	.mpc_isamode_i(mpc_isamode_i),
	.mpc_jamdepc_w(mpc_jamdepc_w),
	.mpc_jimm_e(mpc_jimm_e),
	.mpc_jimm_e_fc(mpc_jimm_e_fc),
	.mpc_jreg_e(mpc_jreg_e),
	.mpc_jreg_e_jalr(mpc_jreg_e_jalr),
	.mpc_load_m(mpc_load_m),
	.mpc_lsbe_m(mpc_lsbe_m),
	.mpc_lsdc1_e(mpc_lsdc1_e),
	.mpc_lsdc1_m(mpc_lsdc1_m),
	.mpc_lsdc1_w(mpc_lsdc1_w),
	.mpc_macro_e(mpc_macro_e),
	.mpc_macro_m(mpc_macro_m),
	.mpc_macro_w(mpc_macro_w),
	.mpc_nobds_e(mpc_nobds_e),
	.mpc_noseq_16bit_w(mpc_noseq_16bit_w),
	.mpc_pdstrobe_w(mpc_pdstrobe_w),
	.mpc_ret_e(mpc_ret_e),
	.mpc_ret_e_ndg(mpc_ret_e_ndg),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_run_w(mpc_run_w),
	.mpc_sbdstrobe_w(mpc_sbdstrobe_w),
	.mpc_sbstrobe_w(mpc_sbstrobe_w),
	.mpc_sbtake_w(mpc_sbtake_w),
	.mpc_sc_m(mpc_sc_m),
	.mpc_strobe_w(mpc_strobe_w),
	.mpc_tail_chain_1st_seen(mpc_tail_chain_1st_seen),
	.mpc_trace_iap_iae_e(mpc_trace_iap_iae_e),
	.mpc_umipspresent(mpc_umipspresent),
	.mpc_wait_w(mpc_wait_w),
	.pdtrace_cpzout(pdtrace_cpzout),
	.pdva_load(pdva_load),
	.siu_tracedisable(siu_tracedisable),
	.tcb_bistfrom(tcb_bistfrom));

/*hookup*/
`M14K_GLU_MODULE glue(
	.gopt(gopt));

endmodule	// m14k_core

