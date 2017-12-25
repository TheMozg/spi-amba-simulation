// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//      Description: m14k_ejt
//           EJTAG Toplevel module
//
//      $Id: \$
//      mips_repository_id: m14k_ejt.hook, v 1.30 
//
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

module m14k_ejt(
	AHB_EAddr,
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
	HWDATA,
	HWRITE,
	TC_ClockRatio,
	TC_Data,
	TC_PibPresent,
	TC_Stall,
	TC_Valid,
	mpc_strobe_w,
	mpc_atomic_e,
	mpc_lsdc1_e,
	mpc_lsdc1_m,
	mpc_lsdc1_w,
	mpc_atomic_m,
	mpc_atomic_w,
	bc_tcbbistto,
	biu_be_ej,
	biu_eaaccess,
	biu_if_enable,
	brk_d_trig,
	brk_dbs_bs,
	brk_i_trig,
	brk_ibs_bs,
	cp2_data_w,
	cp2_ldst_m,
	cp2_storeissued_m,
	cp1_data_w,
	cp1_storeissued_m,
	cp1_ldst_m,
	CP1_endian_0,
	cdmm_area,
	cdmm_sel,
	cdmm_hit,
	cdmm_fdcread,
	cdmm_fdcgwrite,
	cdmm_fdc_hit,
	mmu_cdmm_kuc_m,
	cdmm_rdata_xx,
	cpz_bds_x,
	cpz_bootisamode,
	cpz_cdmmbase,
	cpz_vz,
	cpz_dm,
	cpz_dm_w,
	cpz_doze,
	cpz_eisa_w,
	cpz_enm,
	cpz_epc_w,
	cpz_erl,
	cpz_exl,
	cpz_halt,
	cpz_hotdm_i,
	cpz_kuc_m,
	cpz_mmutype,
	cpz_nmipend,
	cpz_um,
	cpz_um_vld,
	dcc_dvastrobe,
	dcc_ejdata,
	dcc_lddatastr_w,
	dcc_ldst_m,
	dcc_sc_ack_m,
	dcc_stdstrobe,
	edp_alu_m,
	edp_iva_i,
	edp_ldcpdata_w,
	edp_res_w,
	ej_fdc_busy_xx,
	ej_fdc_int,
	ej_isaondebug_read,
	ej_probtrap,
	ej_rdvec,
	ej_rdvec_read,
	ejt_cbrk_m,
	ejt_cbrk_type_m,
	ejt_dbrk_m,
	ejt_dbrk_w,
	ejt_dcrinte,
	ejt_dcrnmie,
	ejt_dvabrk,
	ejt_eadata,
	ejt_eadone,
	fdc_rdata_nxt,
	ejt_predonenxt,
	cdmm_wdata_xx,
	ejt_disableprobedebug,
	ejt_ejtagbrk,
	ejt_ivabrk,
	ejt_pdt_fifo_empty,
	ejt_pdt_present,
	ejt_pdt_stall_w,
	ejt_stall_st_e,
	fdc_present,
	gclk,
	gfclk,
	greset,
	gscanenable,
	gscanmode,
	cpz_iap_exce_handler_trace,
	icc_imiss_i,
	icc_umipspresent,
	mpc_umipspresent,
	mpc_macro_e,
	mpc_macro_m,
	mpc_macro_w,
	mpc_nobds_e,
	icc_macro_e,
	icc_nobds_e,
	icc_pm_icmiss,
	mmu_asid_valid,
	mmu_asid,
	mmu_asid_m,
	icc_umipsfifo_null_i,
	icc_umipsfifo_null_w,
	icc_halfworddethigh_i,
	icc_isachange0_i_reg,
	icc_isachange1_i_reg,
	mmu_dva_m,
	mmu_ivastrobe,
	mpc_auexc_x,
	mpc_bds_m,
	mpc_be_w,
	mpc_cbstrobe_w,
	mpc_cleard_strobe,
	mpc_cp0move_m,
	mpc_cp0r_m,
	mpc_cp0sr_m,
	mpc_dmsquash_m,
	mpc_eqcond_e,
	mpc_exc_w,
	mpc_fixup_m,
	mpc_fixupd,
	mpc_fixupi,
	mpc_ireton_e,
	mpc_bussize_m,
	mpc_irval_e,
	mpc_isamode_i,
	mpc_jimm_e,
	mpc_jimm_e_fc,
	mpc_jreg_e,
	mpc_jreg_e_jalr,
	mpc_load_m,
	mpc_lsbe_m,
	mpc_pdstrobe_w,
	cdmm_mpuipdt_w,
	cdmm_ej_override,
	mpc_ret_e,
	mpc_ret_e_ndg,
	mpc_run_ie,
	mpc_run_m,
	mpc_run_w,
	mpc_sbstrobe_w,
	mpc_sbdstrobe_w,
	mpc_sbtake_w,
	mpc_sc_m,
	mpc_wait_w,
	mpc_noseq_16bit_w,
	pdtrace_cpzout,
	pdva_load,
	siu_tracedisable,
	mpc_tail_chain_1st_seen,
	tcb_bistfrom,
	mpc_trace_iap_iae_e,
	cpz_guestid,
	cpz_guestid_i,
	cpz_guestid_m,
	cpz_kuc_w,
	mpc_jamdepc_w);



/*hookios*//* IO declarations added by hookup */
/* End of hookup IO declarations */
/* Wire declarations added by hookup */
wire area_itcb_tw;		// Read ITCB register ITCBTW(0x3F80)
wire area_itcb_twh;		// Read ITCB register ITCBTWh(0x3F84)
wire [3:0] brk_dbs_bcn;
wire [3:0] brk_ibs_bcn;
wire das_present;
wire dase;		// enables data address sampling
wire dasq;		// qualifies Data Address Sampling using a data breakpoint
wire ej_cbrk_present;		// For CBT in DCR reg
wire ej_dcr_override;
wire ej_disableprobedebug;		// unregistered disable debug probe
wire [19:2] ej_eagaddr;		// Gated address
wire [3:0] ej_eagbe;		// Gated byte enables
wire [31:0] ej_eagdataout;		// Gated data out
wire ej_eagwrite;		// Gated write indication 
wire ej_nodatabrk;		// For DataBrk in DCR reg
wire ej_noinstbrk;		// For InstBrk in DCR reg
wire ej_paaccess;		// PA access transaction ongoing
wire [31:0] ej_padatain;		// PA data in
wire ej_padone;		// PA access done
wire ej_proben;		// Probe Enable indication
wire [31:0] ej_sbdatain;		// Simple Break data in
wire ej_sbwrite;		// Simple Break write indication
wire ej_tap_brk;		// EJTAG break from EJTAG Control register
wire itcb_cap_extra_code;
wire itcb_tw_rd;		// ITCBTW is valid
wire itcbtw_sel;		// Select ITCBTW
wire itcbtwh_sel;		// Select ITCBTWH
wire pc_im;		// config PC sampling to capture all excuted addresses or only those that miss the instruction cache
wire pc_noasid;		// whether the PCsample chain includes ot omit the ASID field
wire pc_noguestid;		// whether the PCsample chain includes ot omit the ASID field
wire [2:0] pc_sync_period;		// sync period for PC sampling
wire pc_sync_period_diff;		// indicates that a new value of pc sync period was writteb
wire pcs_present;
wire pcse;		// PC sample enable
wire [31:0] pdt_datain;		// Outdata of register bus
wire pdt_present_tck;
wire pdt_tcbdata;
wire tck_capture;
wire [4:0] tck_inst;
wire tck_shift;
wire tck_softreset;
wire tck_update;
/* End of hookup wire declarations */

input [31:2] AHB_EAddr;		// EJTAG Area address 
input EJ_DINT;		// Debug mode request
input EJ_DINTsup;
input EJ_DebugM;		// Early Debug mode indication
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
input [31:0] HWDATA;		// EJTAG Area data output
input HWRITE;		// EJTAG Area write indication
output [2:0] TC_ClockRatio;
output [63:0] TC_Data;
input TC_PibPresent;
input TC_Stall;
output TC_Valid;
input mpc_strobe_w;
input mpc_atomic_e;
input mpc_lsdc1_e;
input mpc_lsdc1_m;
input mpc_lsdc1_w;
input mpc_atomic_m;
input mpc_atomic_w;
input [`M14K_TCB_TRMEM_BIST_TO-1:0] bc_tcbbistto;
input [3:0] biu_be_ej;		// EJTAG Area byte enable indication
input biu_eaaccess;		// EJTAG Area transaction ongoing
input biu_if_enable;
output [3:0] brk_d_trig;
output [3:0] brk_dbs_bs;
output [7:0] brk_i_trig;
output [7:0] brk_ibs_bs;
input [31:0] cp2_data_w;
input cp2_ldst_m;
input cp2_storeissued_m;
input [63:0] cp1_data_w;
input cp1_storeissued_m;
input cp1_ldst_m;
input CP1_endian_0;		// COP1 Big Endian used in instruction/To/From

input	cdmm_area;
input	cdmm_sel;
input	cdmm_hit;
input 	cdmm_fdcread;
input	cdmm_fdcgwrite;
input	cdmm_fdc_hit;
input mmu_cdmm_kuc_m;
input [31:0] cdmm_rdata_xx;

input cpz_bds_x;
input cpz_bootisamode;
input [31:15] cpz_cdmmbase;
input cpz_vz;
input cpz_dm;
input cpz_dm_w;
input cpz_doze;
input cpz_eisa_w;
input cpz_enm;		// Endian mode for kernal and debug mode
input [31:0] cpz_epc_w;
input cpz_erl;
input cpz_exl;
input cpz_halt;
input cpz_hotdm_i;
input cpz_kuc_m;
input cpz_mmutype;
input cpz_nmipend;		// NMIpend indication
input cpz_um;
input cpz_um_vld;
input dcc_dvastrobe;
input [31:0] dcc_ejdata;
input dcc_lddatastr_w;
input dcc_ldst_m;
input dcc_sc_ack_m;
input dcc_stdstrobe;
input [31:0] edp_alu_m;
input [31:0] edp_iva_i;
input [31:0] edp_ldcpdata_w;
input [31:0] edp_res_w;
output ej_fdc_busy_xx;
output ej_fdc_int;
output ej_isaondebug_read;
output ej_probtrap;
output ej_rdvec;
output [31:0] ej_rdvec_read;
output ejt_cbrk_m;
output [6:0] ejt_cbrk_type_m;
output ejt_dbrk_m;
output ejt_dbrk_w;
output ejt_dcrinte;		// IntE bit from DCR
output ejt_dcrnmie;		// NMIE bit from DCR
output ejt_dvabrk;
output [31:0] ejt_eadata;		// EJTAG Area data input	
output ejt_eadone;		// EJTAG Area transaction done
output [31:0] fdc_rdata_nxt;
output ejt_predonenxt;
output  [31:0]  cdmm_wdata_xx;
output		ejt_disableprobedebug;
output ejt_ejtagbrk;		// EjtagBrk indication
output ejt_ivabrk;
output ejt_pdt_fifo_empty;
output [1:0] ejt_pdt_present;
output ejt_pdt_stall_w;
output ejt_stall_st_e;
output fdc_present;
input gclk;		// Clock turned off by WAIT
input gfclk;		// Free running clock
input greset;		// reset
input gscanenable;		// Scan Enable
input gscanmode;
input cpz_iap_exce_handler_trace;
input icc_imiss_i;
input icc_umipspresent;
input mpc_umipspresent;
input mpc_macro_e;
input		mpc_macro_m;
input		mpc_macro_w;
input mpc_nobds_e;
input icc_macro_e;
input icc_nobds_e;
  input icc_pm_icmiss;
  input mmu_asid_valid;
input [7:0] mmu_asid;
input [7:0] mmu_asid_m;
input icc_umipsfifo_null_i;
input icc_umipsfifo_null_w;
input		icc_halfworddethigh_i;
input icc_isachange0_i_reg;
input icc_isachange1_i_reg;
input [31:0] mmu_dva_m;
input mmu_ivastrobe;
input mpc_auexc_x;
input mpc_bds_m;
input [3:0] mpc_be_w;
input mpc_cbstrobe_w;
input mpc_cleard_strobe;
input mpc_cp0move_m;
input [4:0] mpc_cp0r_m;
input [2:0] mpc_cp0sr_m;
input mpc_dmsquash_m;
input mpc_eqcond_e;
input mpc_exc_w;
input mpc_fixup_m;
input mpc_fixupd;
input mpc_fixupi;
input mpc_ireton_e;
input [1:0] mpc_bussize_m;
input mpc_irval_e;
input mpc_isamode_i;
input mpc_jimm_e;
input mpc_jimm_e_fc;
input mpc_jreg_e;
input mpc_jreg_e_jalr;
input mpc_load_m;
input [3:0] mpc_lsbe_m;
input mpc_pdstrobe_w;
input cdmm_mpuipdt_w;
input	cdmm_ej_override;
input mpc_ret_e;
input mpc_ret_e_ndg;
input mpc_run_ie;
input mpc_run_m;
input mpc_run_w;
input mpc_sbstrobe_w;
input mpc_sbdstrobe_w;  // ejtag simple break strobe for d channels
input mpc_sbtake_w;
input mpc_sc_m;
input mpc_wait_w;
input mpc_noseq_16bit_w;
output [31:0] pdtrace_cpzout;
input pdva_load;
input siu_tracedisable;
input mpc_tail_chain_1st_seen;
output [`M14K_TCB_TRMEM_BIST_FROM-1:0] tcb_bistfrom;
input mpc_trace_iap_iae_e;

input [7:0] cpz_guestid;
input [7:0] cpz_guestid_i;
input [7:0] cpz_guestid_m;
input cpz_kuc_w;
input mpc_jamdepc_w;

// BEGIN Wire declarations made by MVP
// END Wire declarations made by MVP



//verilint 528 off  // Variable set but not used.
//verilint 123 off  // Variable set but not used.
wire [2:0] TC_CRMax;
wire [2:0] TC_CRMin;
wire TC_Calibrate;
wire TC_ChipTrigIn;
wire TC_ChipTrigOut;
wire [2:0] TC_DataBits;
wire TC_ProbeTrigIn;
wire TC_ProbeTrigOut;
wire [1:0] TC_ProbeWidth;
wire TC_TrEnable;
//verilint 123 on  // Variable set but not used.
//verilint 528 on  // Variable set but not used.




// Instantiate REAL modules or their stub (depending on Config.def)
/*hookup*/
`M14K_TAP_MODULE ejt_tap(
	.AHB_EAddr(AHB_EAddr[14:2]),
	.EJ_DINTsup(EJ_DINTsup),
	.EJ_DebugM(EJ_DebugM),
	.EJ_DisableProbeDebug(EJ_DisableProbeDebug),
	.EJ_ECREjtagBrk(EJ_ECREjtagBrk),
	.EJ_ManufID(EJ_ManufID),
	.EJ_PartNumber(EJ_PartNumber),
	.EJ_PerRst(EJ_PerRst),
	.EJ_PrRst(EJ_PrRst),
	.EJ_TCK(EJ_TCK),
	.EJ_TDI(EJ_TDI),
	.EJ_TDO(EJ_TDO),
	.EJ_TDOzstate(EJ_TDOzstate),
	.EJ_TMS(EJ_TMS),
	.EJ_TRST_N(EJ_TRST_N),
	.EJ_Version(EJ_Version),
	.brk_d_trig(brk_d_trig[1:0]),
	.cdmm_ej_override(cdmm_ej_override),
	.cdmm_fdc_hit(cdmm_fdc_hit),
	.cdmm_fdcgwrite(cdmm_fdcgwrite),
	.cdmm_fdcread(cdmm_fdcread),
	.cdmm_wdata_xx(cdmm_wdata_xx),
	.cpz_dm(cpz_dm),
	.cpz_doze(cpz_doze),
	.cpz_enm(cpz_enm),
	.cpz_epc_w(cpz_epc_w),
	.cpz_guestid(cpz_guestid),
	.cpz_halt(cpz_halt),
	.cpz_kuc_m(cpz_kuc_m),
	.cpz_mmutype(cpz_mmutype),
	.cpz_vz(cpz_vz),
	.das_present(das_present),
	.dase(dase),
	.dasq(dasq),
	.dcc_dvastrobe(dcc_dvastrobe),
	.edp_iva_i(edp_iva_i),
	.ej_dcr_override(ej_dcr_override),
	.ej_disableprobedebug(ej_disableprobedebug),
	.ej_eagaddr(ej_eagaddr),
	.ej_eagbe(ej_eagbe),
	.ej_eagdataout(ej_eagdataout),
	.ej_eagwrite(ej_eagwrite),
	.ej_fdc_busy_xx(ej_fdc_busy_xx),
	.ej_fdc_int(ej_fdc_int),
	.ej_isaondebug_read(ej_isaondebug_read),
	.ej_paaccess(ej_paaccess),
	.ej_padatain(ej_padatain),
	.ej_padone(ej_padone),
	.ej_proben(ej_proben),
	.ej_probtrap(ej_probtrap),
	.ej_tap_brk(ej_tap_brk),
	.fdc_present(fdc_present),
	.fdc_rdata_nxt(fdc_rdata_nxt),
	.gclk(gclk),
	.gfclk(gfclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.gscanmode(gscanmode),
	.icc_pm_icmiss(icc_pm_icmiss),
	.mmu_asid(mmu_asid),
	.mmu_cdmm_kuc_m(mmu_cdmm_kuc_m),
	.mmu_dva_m(mmu_dva_m),
	.mpc_cleard_strobe(mpc_cleard_strobe),
	.mpc_exc_w(mpc_exc_w),
	.mpc_umipspresent(mpc_umipspresent),
	.pc_im(pc_im),
	.pc_noasid(pc_noasid),
	.pc_noguestid(pc_noguestid),
	.pc_sync_period(pc_sync_period),
	.pc_sync_period_diff(pc_sync_period_diff),
	.pcs_present(pcs_present),
	.pcse(pcse),
	.pdt_present_tck(pdt_present_tck),
	.pdt_tcbdata(pdt_tcbdata),
	.tck_capture(tck_capture),
	.tck_inst(tck_inst),
	.tck_shift(tck_shift),
	.tck_softreset(tck_softreset),
	.tck_update(tck_update));

/*hookup*/
`M14K_AREA_MODULE ejt_area(
	.AHB_EAddr(AHB_EAddr),
	.EJ_DINT(EJ_DINT),
	.EJ_DebugM(EJ_DebugM),
	.EJ_SRstE(EJ_SRstE),
	.HWDATA(HWDATA),
	.HWRITE(HWRITE),
	.area_itcb_tw(area_itcb_tw),
	.area_itcb_twh(area_itcb_twh),
	.biu_be_ej(biu_be_ej),
	.biu_eaaccess(biu_eaaccess),
	.biu_if_enable(biu_if_enable),
	.cdmm_area(cdmm_area),
	.cdmm_ej_override(cdmm_ej_override),
	.cdmm_fdc_hit(cdmm_fdc_hit),
	.cdmm_hit(cdmm_hit),
	.cdmm_rdata_xx(cdmm_rdata_xx),
	.cdmm_sel(cdmm_sel),
	.cdmm_wdata_xx(cdmm_wdata_xx),
	.cpz_bootisamode(cpz_bootisamode),
	.cpz_cdmmbase(cpz_cdmmbase),
	.cpz_enm(cpz_enm),
	.cpz_nmipend(cpz_nmipend),
	.cpz_vz(cpz_vz),
	.das_present(das_present),
	.dase(dase),
	.dasq(dasq),
	.ej_cbrk_present(ej_cbrk_present),
	.ej_dcr_override(ej_dcr_override),
	.ej_disableprobedebug(ej_disableprobedebug),
	.ej_eagaddr(ej_eagaddr),
	.ej_eagbe(ej_eagbe),
	.ej_eagdataout(ej_eagdataout),
	.ej_eagwrite(ej_eagwrite),
	.ej_nodatabrk(ej_nodatabrk),
	.ej_noinstbrk(ej_noinstbrk),
	.ej_paaccess(ej_paaccess),
	.ej_padatain(ej_padatain),
	.ej_padone(ej_padone),
	.ej_proben(ej_proben),
	.ej_rdvec(ej_rdvec),
	.ej_rdvec_read(ej_rdvec_read),
	.ej_sbdatain(ej_sbdatain),
	.ej_sbwrite(ej_sbwrite),
	.ej_tap_brk(ej_tap_brk),
	.ejt_dcrinte(ejt_dcrinte),
	.ejt_dcrnmie(ejt_dcrnmie),
	.ejt_disableprobedebug(ejt_disableprobedebug),
	.ejt_eadata(ejt_eadata),
	.ejt_eadone(ejt_eadone),
	.ejt_ejtagbrk(ejt_ejtagbrk),
	.ejt_predonenxt(ejt_predonenxt),
	.fdc_present(fdc_present),
	.gclk(gclk),
	.gfclk(gfclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.itcb_tw_rd(itcb_tw_rd),
	.itcbtw_sel(itcbtw_sel),
	.itcbtwh_sel(itcbtwh_sel),
	.mpc_umipspresent(mpc_umipspresent),
	.pc_im(pc_im),
	.pc_noasid(pc_noasid),
	.pc_noguestid(pc_noguestid),
	.pc_sync_period(pc_sync_period),
	.pc_sync_period_diff(pc_sync_period_diff),
	.pcs_present(pcs_present),
	.pcse(pcse),
	.pdt_datain(pdt_datain));

/*hookup*/
`M14K_BREAK_MODULE ejt_brk(
	.brk_d_trig(brk_d_trig),
	.brk_dbs_bcn(brk_dbs_bcn),
	.brk_dbs_bs(brk_dbs_bs),
	.brk_i_trig(brk_i_trig),
	.brk_ibs_bcn(brk_ibs_bcn),
	.brk_ibs_bs(brk_ibs_bs),
	.cp1_ldst_m(cp1_ldst_m),
	.cp2_ldst_m(cp2_ldst_m),
	.cpz_dm(cpz_dm),
	.cpz_guestid(cpz_guestid),
	.cpz_guestid_i(cpz_guestid_i),
	.cpz_guestid_m(cpz_guestid_m),
	.cpz_mmutype(cpz_mmutype),
	.cpz_vz(cpz_vz),
	.dcc_dvastrobe(dcc_dvastrobe),
	.dcc_ejdata(dcc_ejdata),
	.dcc_lddatastr_w(dcc_lddatastr_w),
	.dcc_ldst_m(dcc_ldst_m),
	.dcc_stdstrobe(dcc_stdstrobe),
	.edp_iva_i(edp_iva_i),
	.ej_cbrk_present(ej_cbrk_present),
	.ej_eagaddr_15_3(ej_eagaddr[15:3]),
	.ej_eagdataout(ej_eagdataout),
	.ej_nodatabrk(ej_nodatabrk),
	.ej_noinstbrk(ej_noinstbrk),
	.ej_sbdatain(ej_sbdatain),
	.ej_sbwrite(ej_sbwrite),
	.ejt_cbrk_m(ejt_cbrk_m),
	.ejt_cbrk_type_m(ejt_cbrk_type_m),
	.ejt_dbrk_m(ejt_dbrk_m),
	.ejt_dbrk_w(ejt_dbrk_w),
	.ejt_dvabrk(ejt_dvabrk),
	.ejt_ivabrk(ejt_ivabrk),
	.ejt_stall_st_e(ejt_stall_st_e),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.icc_halfworddethigh_i(icc_halfworddethigh_i),
	.icc_imiss_i(icc_imiss_i),
	.icc_isachange0_i_reg(icc_isachange0_i_reg),
	.icc_isachange1_i_reg(icc_isachange1_i_reg),
	.icc_macro_e(icc_macro_e),
	.icc_umipsfifo_null_i(icc_umipsfifo_null_i),
	.icc_umipsfifo_null_w(icc_umipsfifo_null_w),
	.icc_umipspresent(icc_umipspresent),
	.mmu_asid(mmu_asid),
	.mmu_dva_m(mmu_dva_m),
	.mmu_ivastrobe(mmu_ivastrobe),
	.mpc_atomic_e(mpc_atomic_e),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_be_w(mpc_be_w),
	.mpc_bussize_m(mpc_bussize_m),
	.mpc_cbstrobe_w(mpc_cbstrobe_w),
	.mpc_cleard_strobe(mpc_cleard_strobe),
	.mpc_fixupi(mpc_fixupi),
	.mpc_ireton_e(mpc_ireton_e),
	.mpc_isamode_i(mpc_isamode_i),
	.mpc_lsbe_m(mpc_lsbe_m),
	.mpc_lsdc1_e(mpc_lsdc1_e),
	.mpc_lsdc1_m(mpc_lsdc1_m),
	.mpc_lsdc1_w(mpc_lsdc1_w),
	.mpc_macro_e(mpc_macro_e),
	.mpc_macro_m(mpc_macro_m),
	.mpc_macro_w(mpc_macro_w),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_run_w(mpc_run_w),
	.mpc_sbdstrobe_w(mpc_sbdstrobe_w),
	.mpc_sbstrobe_w(mpc_sbstrobe_w),
	.mpc_sbtake_w(mpc_sbtake_w),
	.mpc_umipspresent(mpc_umipspresent));

 /*hookup*/
`M14K_TRACE_TCB_MODULE ejt_pdttcb_wrapper(
	.CP1_endian_0(CP1_endian_0),
	.EJ_DebugM(EJ_DebugM),
	.EJ_TCK(EJ_TCK),
	.EJ_TDI(EJ_TDI),
	.EJ_TRST_N(EJ_TRST_N),
	.TC_CRMax(TC_CRMax),
	.TC_CRMin(TC_CRMin),
	.TC_Calibrate(TC_Calibrate),
	.TC_ChipTrigIn(TC_ChipTrigIn),
	.TC_ChipTrigOut(TC_ChipTrigOut),
	.TC_ClockRatio(TC_ClockRatio),
	.TC_Data(TC_Data),
	.TC_DataBits(TC_DataBits),
	.TC_PibPresent(TC_PibPresent),
	.TC_ProbeTrigIn(TC_ProbeTrigIn),
	.TC_ProbeTrigOut(TC_ProbeTrigOut),
	.TC_ProbeWidth(TC_ProbeWidth),
	.TC_Stall(TC_Stall),
	.TC_TrEnable(TC_TrEnable),
	.TC_Valid(TC_Valid),
	.area_itcb_tw(area_itcb_tw),
	.area_itcb_twh(area_itcb_twh),
	.bc_tcbbistto(bc_tcbbistto),
	.brk_d_trig(brk_d_trig),
	.brk_dbs_bcn(brk_dbs_bcn),
	.brk_i_trig(brk_i_trig),
	.brk_ibs_bcn(brk_ibs_bcn),
	.cdmm_mpuipdt_w(cdmm_mpuipdt_w),
	.cp1_data_w(cp1_data_w),
	.cp1_storeissued_m(cp1_storeissued_m),
	.cp2_data_w(cp2_data_w),
	.cp2_storeissued_m(cp2_storeissued_m),
	.cpz_bds_x(cpz_bds_x),
	.cpz_dm_w(cpz_dm_w),
	.cpz_eisa_w(cpz_eisa_w),
	.cpz_epc_w(cpz_epc_w),
	.cpz_erl(cpz_erl),
	.cpz_exl(cpz_exl),
	.cpz_guestid(cpz_guestid),
	.cpz_guestid_m(cpz_guestid_m),
	.cpz_hotdm_i(cpz_hotdm_i),
	.cpz_iap_exce_handler_trace(cpz_iap_exce_handler_trace),
	.cpz_kuc_w(cpz_kuc_w),
	.cpz_mmutype(cpz_mmutype),
	.cpz_um(cpz_um),
	.cpz_um_vld(cpz_um_vld),
	.cpz_vz(cpz_vz),
	.dcc_dvastrobe(dcc_dvastrobe),
	.dcc_ejdata(dcc_ejdata),
	.dcc_ldst_m(dcc_ldst_m),
	.dcc_sc_ack_m(dcc_sc_ack_m),
	.edp_alu_m(edp_alu_m),
	.edp_ldcpdata_w(edp_ldcpdata_w),
	.edp_res_w(edp_res_w),
	.ej_eagaddr_15_3(ej_eagaddr[15:3]),
	.ej_eagaddr_2_2(ej_eagaddr[2]),
	.ej_eagdataout(ej_eagdataout),
	.ej_sbwrite(ej_sbwrite),
	.ejt_pdt_fifo_empty(ejt_pdt_fifo_empty),
	.ejt_pdt_present(ejt_pdt_present),
	.ejt_pdt_stall_w(ejt_pdt_stall_w),
	.gclk(gclk),
	.gfclk(gfclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.gscanmode(gscanmode),
	.icc_macro_e(icc_macro_e),
	.icc_nobds_e(icc_nobds_e),
	.itcb_cap_extra_code(itcb_cap_extra_code),
	.itcb_tw_rd(itcb_tw_rd),
	.itcbtw_sel(itcbtw_sel),
	.itcbtwh_sel(itcbtwh_sel),
	.mmu_asid(mmu_asid),
	.mmu_asid_m(mmu_asid_m),
	.mmu_asid_valid(mmu_asid_valid),
	.mmu_dva_m(mmu_dva_m),
	.mpc_atomic_w(mpc_atomic_w),
	.mpc_auexc_x(mpc_auexc_x),
	.mpc_bds_m(mpc_bds_m),
	.mpc_be_w(mpc_be_w),
	.mpc_cp0move_m(mpc_cp0move_m),
	.mpc_cp0r_m(mpc_cp0r_m),
	.mpc_cp0sr_m(mpc_cp0sr_m),
	.mpc_dmsquash_m(mpc_dmsquash_m),
	.mpc_eqcond_e(mpc_eqcond_e),
	.mpc_exc_w(mpc_exc_w),
	.mpc_fixup_m(mpc_fixup_m),
	.mpc_fixupd(mpc_fixupd),
	.mpc_irval_e(mpc_irval_e),
	.mpc_jamdepc_w(mpc_jamdepc_w),
	.mpc_jimm_e(mpc_jimm_e),
	.mpc_jimm_e_fc(mpc_jimm_e_fc),
	.mpc_jreg_e(mpc_jreg_e),
	.mpc_jreg_e_jalr(mpc_jreg_e_jalr),
	.mpc_load_m(mpc_load_m),
	.mpc_lsdc1_e(mpc_lsdc1_e),
	.mpc_macro_e(mpc_macro_e),
	.mpc_nobds_e(mpc_nobds_e),
	.mpc_noseq_16bit_w(mpc_noseq_16bit_w),
	.mpc_pdstrobe_w(mpc_pdstrobe_w),
	.mpc_ret_e(mpc_ret_e),
	.mpc_ret_e_ndg(mpc_ret_e_ndg),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.mpc_run_w(mpc_run_w),
	.mpc_sbstrobe_w(mpc_sbstrobe_w),
	.mpc_sbtake_w(mpc_sbtake_w),
	.mpc_sc_m(mpc_sc_m),
	.mpc_strobe_w(mpc_strobe_w),
	.mpc_tail_chain_1st_seen(mpc_tail_chain_1st_seen),
	.mpc_trace_iap_iae_e(mpc_trace_iap_iae_e),
	.mpc_wait_w(mpc_wait_w),
	.pdt_datain(pdt_datain),
	.pdt_present_tck(pdt_present_tck),
	.pdt_tcbdata(pdt_tcbdata),
	.pdtrace_cpzout(pdtrace_cpzout),
	.pdva_load(pdva_load),
	.siu_tracedisable(siu_tracedisable),
	.tcb_bistfrom(tcb_bistfrom),
	.tck_capture(tck_capture),
	.tck_inst(tck_inst),
	.tck_shift(tck_shift),
	.tck_softreset(tck_softreset),
	.tck_update(tck_update));

endmodule	// ejtag
