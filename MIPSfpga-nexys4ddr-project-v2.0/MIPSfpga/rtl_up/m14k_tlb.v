// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	m14k_tlb
//
//	$Id: \$
//	mips_repository_id: m14k_tlb.hook, v 1.32 
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
module m14k_tlb(
	edp_alu_m,
	mmu_dva_m,
	mmu_dva_mapped_m,
	mpc_ctlen_noe_e,
	mpc_irval_e,
	mpc_cp0func_e,
	mpc_cp0move_m,
	mpc_cp0r_m,
	mpc_cp0sr_m,
	mpc_load_m,
	mpc_pcrel_m,
	mpc_ll1_m,
	mpc_annulds_e,
	mpc_nobds_e,
	mpc_busty_m,
	mpc_busty_raw_e,
	mpc_bussize_m,
	edp_dva_e,
	edp_dva_mapped_e,
	dcc_newdaddr,
	mpc_lsdc1_m,
	edp_iva_p,
	edp_iva_i,
	edp_cacheiva_p,
	edp_cacheiva_i,
	mpc_itqualcond_i,
	mpc_continue_squash_i,
	icc_umipsfifo_stat,
	icc_halfworddethigh_fifo_i,
	icc_slip_n_nhalf,
	mpc_newiaddr,
	mpc_atomic_m,
	cpz_dm_m,
	cpz_erl,
	cpz_hotdm_i,
	cpz_hoterl,
	cpz_k0cca,
	cpz_k23cca,
	cpz_kucca,
	cpz_kuc_i,
	cpz_kuc_m,
	cpz_lsnm,
	cpz_smallpage,
	cpz_g_erl,
	cpz_g_hoterl,
	cpz_g_k0cca,
	cpz_g_k23cca,
	cpz_g_kucca,
	cpz_g_kuc_i,
	cpz_g_kuc_m,
	cpz_g_smallpage,
	mpc_dmsquash_m,
	mpc_eexc_e,
	mpc_exc_e,
	mpc_exc_m,
	mpc_jamtlb_w,
	mpc_pexc_i,
	mpc_pexc_m,
	mpc_squash_i,
	mpc_fixupi,
	mpc_fixup_m,
	gclk,
	mpc_run_ie,
	mpc_run_m,
	greset,
	gscanenable,
	cpz_mmutype,
	cpz_mmusize,
	cpz_g_mmutype,
	cpz_g_mmusize,
	mmu_asid,
	mmu_asid_valid,
	mmu_cpyout,
	mmu_ivastrobe,
	mmu_itmack_i,
	mmu_itmres_nxt_i,
	mmu_dtmack_m,
	mmu_type,
	mmu_size,
	mmu_dcmode,
	mmu_dpah,
	mmu_icacabl,
	mmu_imagicl,
	mmu_ipah,
	mpc_isamode_i,
	mpc_excisamode_i,
	mmu_adrerr,
	mmu_dtexc_m,
	mmu_dtriexc_m,
	mmu_itexc_i,
	mmu_itxiexc_i,
	mmu_rawdtexc_m,
	mmu_rawitexc_i,
	mmu_tlbbusy,
	mmu_tlbinv,
	mmu_tlbmod,
	mmu_tlbrefill,
	mmu_tlbshutdown,
	mmu_iec,
	mmu_transexc,
	mmu_vafromi,
	asid_update,
	mmu_it_segerr,
	mmu_pm_ithit,
	mmu_pm_itmiss,
	mmu_pm_dthit,
	mmu_pm_dtmiss,
	mmu_pm_dtlb_miss_qual,
	mmu_pm_jthit,
	mmu_pm_jtmiss,
	mmu_pm_jthit_i,
	mmu_pm_jthit_d,
	mmu_pm_jtmiss_i,
	mmu_pm_jtmiss_d,
	mmu_r_pm_jthit_i,
	mmu_r_pm_jthit_d,
	mmu_r_pm_jtmiss_i,
	mmu_r_pm_jtmiss_d,
	ejt_disableprobedebug,
	gtlbclk,
	r_gtlbclk,
	jtlb_wr,
	cpz_cdmmbase,
	fdc_present,
	cpz_cdmm_enable,
	cdmm_mpu_present,
	mmu_cdmm_kuc_m,
	mpc_g_cp0move_m,
	cpz_vz,
	mpc_g_jamtlb_w,
	cpz_gm_m,
	cpz_gm_i,
	cpz_gm_e,
	cpz_gm_p,
	cpz_gid,
	cpz_rid,
	mpc_g_eexc_e,
	mpc_g_cp0func_e,
	cpz_drg,
	cpz_drgmode_i,
	cpz_drgmode_m,
	mmu_r_asid,
	mmu_r_asid_valid,
	mmu_r_cpyout,
	mmu_r_type,
	mmu_r_size,
	mmu_r_adrerr,
	mmu_r_dtexc_m,
	mmu_r_dtriexc_m,
	mmu_r_itexc_i,
	mmu_r_itxiexc_i,
	mmu_r_rawdtexc_m,
	mmu_r_rawitexc_i,
	mmu_r_tlbbusy,
	mmu_r_tlbinv,
	mmu_r_tlbmod,
	mmu_r_tlbrefill,
	mmu_r_tlbshutdown,
	mmu_r_iec,
	mmu_r_transexc,
	mmu_r_vafromi,
	r_asid_update,
	mmu_r_it_segerr,
	mmu_gid,
	mmu_rid,
	mmu_r_read_m,
	mmu_read_m,
	r_jtlb_wr,
	mmu_vat_hi);

`include "m14k_mmu.vh"


/*hookios*//* IO declarations added by hookup */
/* End of hookup IO declarations */
/* Wire declarations added by hookup */
wire cp0_probe_m;		// TLBP instn
wire cp0_read_m;		// TLBR instn
wire cp0random_val_e;		// Early indication of TLBWR
wire dadr_err_m;		// Data address error
wire dmap;		// D ref is mapped
wire [`M14K_CCA] dpa_cca;
wire dtlb_bypass;
wire dtlb_exc;		// D-translation exception
wire dtlb_miss;		// uTLB Miss indication
wire dtlb_ri;		// Read inhibit from dTLB
wire dtlb_ri_exc;		// D-translation RI exception
wire dtlb_xi;		// Execute inhibit from dTLB
wire [4:0] enc;		// TLB encoder output
wire [29:0] enhi;		// entry hi register (output of phase mux)
wire [`M14K_JTLBDATA] entrylo;		// entry lo0/1 bus for tlb write
wire gbit;		// Global bit anded from enlo0/1
wire guest_mode;
wire iadr_err_i;		// Instruction address error
wire imap;		// I ref is mapped
wire inv;
wire [`M14K_CCA] ipa_cca;
wire is_root;
wire itlb_bypass;
wire itlb_exc;		// I-translation exception
wire itlb_miss;		// uTLB Miss indication
wire itlb_xi_exc;		// I-translation XI exception
wire itmack_id;		// ITLB Miss is accessing JTLB
wire itmack_idd;		// ITLB Miss is accessing JTLB
wire [4:0] ixp;		// index for tlb read/write
wire jtlb_grain;		// Smallest pagesize = 1KB/4KB (0/1)
wire [`M14K_JTLBL] jtlb_lo;		// JTLB LO output
wire [`M14K_PAH] jtlb_pah;		// Translated Physical address from JTLB
wire lookupd;		// Enable D translation
wire lookupi;		// Enable I translation
wire [4:0] mmu_index;		// JTLB Index
wire pagegrain;		// Smallest pagesize = 1KB/4KB (0/1)
wire [`M14K_CMASK] pagemask;		// compressed Page mask register
wire [`M14K_PAH] pre_dpah;
wire [`M14K_PAH] pre_ipah;
wire rjtlb_idx;
wire store_trans_m;		// Store 
wire [`M14K_JTLBH] tag_array_out;		// JTLB HI output
wire tlb_enable;		// TLB CAM enable
wire tlb_match;		// TLB match
wire tlb_rd_0;		// TLB Read Even + Tag
wire tlb_rd_1;		// TLB Read Odd
wire tlb_squash_i;		// I-stage instn is being killed
wire [`M14K_VPN] tlb_vpn;		// virtual address to jtlb
wire tlb_wr_0;		// TLB Write Even + Tag
wire tlb_wr_1;		// TLB Write Odd
wire tlb_wr_cmp;		// TLB Write Compare
wire update_dtlb;		// Write DTLB with JTLB output
/* End of hookup wire declarations */


// Cp0 Op inputs
input [`M14K_BUS] 	edp_alu_m;		// ALU result bus -> cpy write data
output [`M14K_BUS] mmu_dva_m; 	                // Data virtual address, M-stage register
output [31:29]  mmu_dva_mapped_m; 	        // Data virtual address mapped, M-stage register
input 		mpc_ctlen_noe_e;		// Early enable signal, not qualified with Exc_E
input 		mpc_irval_e;		        // Earlier enable signal, not qualified with Exc_E or Run_E
input [5:0] 	mpc_cp0func_e;                  // Cop0 function field
input 		mpc_cp0move_m;		        // MT/F C0
input [4:0] 	mpc_cp0r_m;			// coprocessor zero register specifier
input [2:0]     mpc_cp0sr_m;                    // coprocessor zero shadow register specifier
input 		mpc_load_m;		        // xfer direction for load/store/cpmv - 0:=to proc; 1:=from proc
input 		mpc_pcrel_m;	                // A PCrelative instruction is in the M stage
input 		mpc_ll1_m;		        // Load linked in first clock of M -> drive LLAddr on mmu_cpyout
input		mpc_annulds_e;			// registered delay-slot in e stage. annul e-stage effects
input		mpc_nobds_e;			// delay-slot in e stage. annul e-stage effects

// DTrans Inputs
input [2:0] 	mpc_busty_m;		        // Bus operation type: 0-nil, 1-load, 2-store, 3-pref, 4-sync, 5-ICacheOp, 6-DCacheOp
input [2:0] 	mpc_busty_raw_e;		// Bus operation type: 0-nil, 1-load, 2-store, 3-pref, 4-sync, 5-ICacheOp, 6-DCacheOp
input [1:0] 	mpc_bussize_m;                  // Bus size (00-byte, 01-half, 10-unaligned, 11-word)
input [`M14K_BUS] 	edp_dva_e;		// Next data virtual address, feeding mmu_dva_m and dva_trans register
input [31:29] 	edp_dva_mapped_e;		// Next data virtual address mapped
input        	dcc_newdaddr;		        // Data address valid
input        	mpc_lsdc1_m;

// ITrans Inputs
input [`M14K_BUS] 	edp_iva_p;		// Next instr. virtual address, feeding the local iva_trans fast path register
input [`M14K_BUS] 	edp_iva_i;		// Instr virtual address, source resident I-stage register
input [`M14K_BUS]	edp_cacheiva_p;
input [`M14K_BUS]	edp_cacheiva_i;
	input mpc_itqualcond_i;
	input mpc_continue_squash_i;
	input [3:0]  icc_umipsfifo_stat;
	input        icc_halfworddethigh_fifo_i;
	input	     icc_slip_n_nhalf;

input        	mpc_newiaddr;		// Instruction address valid
input		mpc_atomic_m;		// Atomic instrucionn is in M stage

// Cp0 state inputs
input 		cpz_dm_m;		// A debug Exception has been taken
input 		cpz_erl;		// cpz_erl bit from status
input 		cpz_hotdm_i;		// A debug Exception has been taken
input 		cpz_hoterl;		// Early version of cpz_erl
input [2:0]     cpz_k0cca;		// kseg0 cache attributes
input [2:0]     cpz_k23cca;		// kseg2/3 cache attributes
input [2:0]     cpz_kucca;		// kuseg cache attributes
input 		cpz_kuc_i;		// Kernel/user bit - 0:=>kernel; 1:=>user
input 		cpz_kuc_m;		// Kernel/user bit - 0:=>kernel; 1:=>user
input 		cpz_lsnm;		// Load/Store Normal Memory from DEBUG
input		cpz_smallpage;		// Small (1KB) page support

// Guest Cp0 state inputs
input 		cpz_g_erl;		// cpz_erl bit from status
input 		cpz_g_hoterl;		// Early version of cpz_erl
input [2:0]     cpz_g_k0cca;		// kseg0 cache attributes
input [2:0]     cpz_g_k23cca;		// kseg2/3 cache attributes
input [2:0]     cpz_g_kucca;		// kuseg cache attributes
input 		cpz_g_kuc_i;		// Kernel/user bit - 0:=>kernel; 1:=>user
input 		cpz_g_kuc_m;		// Kernel/user bit - 0:=>kernel; 1:=>user
input		cpz_g_smallpage;		// Small (1KB) page support

// Exception information
input 		mpc_dmsquash_m;		// Exc_M without translation exceptions or interrupts
input 		mpc_eexc_e;		// early exception detectedin E-stage
input 		mpc_exc_e;		// E-stage instn killed by exception
input 		mpc_exc_m;		// M-stage instn killed by exception
input 		mpc_jamtlb_w;		// load translation related registers from shadow regs
input 		mpc_pexc_i;		// Exception
input 		mpc_pexc_m;		// Exception
input 		mpc_squash_i;		// Squash init-stage instruction by faking an Exception

// Pipeline control
input 		mpc_fixupi;	        // I$ Miss previous cycle
input 		mpc_fixup_m;	        // D$ Miss previous cycle
input 		gclk;		        // main clock
input 		mpc_run_ie;		// I/E-stage Run signal
input 		mpc_run_m;		// M-stage Run

input 		greset;		        // greset input
input 		gscanenable;		// Test Mode

input 		cpz_mmutype;	        // mmu_type from Config register
input 	[1:0]	cpz_mmusize;	        // mmu_type from Config register

input 		cpz_g_mmutype;	        // mmu_type from Config register
input 	[1:0]	cpz_g_mmusize;	        // mmu_type from Config register


// Misc. Outputs
output [`M14K_ASID] 	mmu_asid;	// Load/store Normal Memory from DEBUG
output 			mmu_asid_valid; //
output [`M14K_BUS] 	mmu_cpyout;	// Read data for MFC0 & SC register updates
output 		mmu_ivastrobe;		// Strobe new Fetch PC into EJTAG
output 		mmu_itmack_i;		// ITLB Miss used by the mpc to stall the i and e stages
output		mmu_itmres_nxt_i;
output 		mmu_dtmack_m;		// DTLB Miss used by the mpc to stall the m stage
output 		mmu_type;		// MMU type: 1->BAT, 0->TLB
output 	[1:0]	mmu_size;		// MMU size: 0->16, 1->32

// DTranslation outputs
output [2:0]    mmu_dcmode;             // Data cache reference mode (x01=UC x11=magic x00=writeback 010=WT-WA, 110=WT-NWA)
output [`M14K_PAH] 	mmu_dpah;	// Physical address to dcache

// ITranslation outputs
output 		mmu_icacabl;            // Instn ref is cacheable
output 		mmu_imagicl;            // Instn ref is to EJTAG 
output [`M14K_PAH] 	mmu_ipah;	// Physical address to icache
input     mpc_isamode_i;                // I-stage instn is UMIPS
input		mpc_excisamode_i; // changing isa mode without proper isa


// Translation/Address Error Outputs
output 		mmu_adrerr;		// Address error (init or D)
output 		mmu_dtexc_m;		// data reference translation error
output 		mmu_dtriexc_m;		// D-addr RI exception
output 		mmu_itexc_i;		// instruction reference translation error
output 		mmu_itxiexc_i;		// itlb execution inhibit exception
output 		mmu_rawdtexc_m;		// Raw translation exception (includes PREFS)
output 		mmu_rawitexc_i;		// Raw ITranslation exception
output 		mmu_tlbbusy;		// TLB is in midst of multi-cycle operation
output 		mmu_tlbinv;		// TLB Invalid exception
output 		mmu_tlbmod;		// TLB modified exception
output 		mmu_tlbrefill;		// TLB Refill exception
output 		mmu_tlbshutdown;	// conflict detected on TLB write
output 		mmu_iec;		// enable unique ri/xi exception code
output 		mmu_transexc;		// Translation exception - load shadow registers
output 		mmu_vafromi;		// Use ITLBH instead of JTLBH to load CP0 regs

output          asid_update;          // detect on asid change

output		mmu_it_segerr;

// PerfMonitor outputs
output 		mmu_pm_ithit;		// ITLB hit performance monitoring signal
output 		mmu_pm_itmiss;		// ITLB miss performance monitoring signal
output 		mmu_pm_dthit;		// DTLB hit performance monitoring signal
output 		mmu_pm_dtmiss;		// DTLB miss performance monitoring signal
output		mmu_pm_dtlb_miss_qual;
output 		mmu_pm_jthit;		// JITLB hit performance monitoring signal
output 		mmu_pm_jtmiss;		// JITLB miss performance monitoring signal
output		mmu_pm_jthit_i;
output		mmu_pm_jthit_d;
output		mmu_pm_jtmiss_i;
output		mmu_pm_jtmiss_d;
output		mmu_r_pm_jthit_i;
output		mmu_r_pm_jthit_d;
output		mmu_r_pm_jtmiss_i;
output		mmu_r_pm_jtmiss_d;

input		ejt_disableprobedebug; // disable ejtag mem space
input           gtlbclk;                // gated clock for JTLB
input           r_gtlbclk;                // gated clock for JTLB
output		jtlb_wr;

        input [31:15]   cpz_cdmmbase;
        input           fdc_present;
	input		cpz_cdmm_enable;
	input		cdmm_mpu_present;
        output          mmu_cdmm_kuc_m;

input           mpc_g_cp0move_m;
input		cpz_vz;
input 		mpc_g_jamtlb_w;		
input 		cpz_gm_m;		
input 		cpz_gm_i;		
input 		cpz_gm_e;		
input 		cpz_gm_p;		
input [`M14K_GID] 	cpz_gid;
input [`M14K_GID] 	cpz_rid;
input 		mpc_g_eexc_e;		// E-stage instn killed by exception
input [5:0]	mpc_g_cp0func_e;
input 		cpz_drg;		
input 		cpz_drgmode_i;		
input 		cpz_drgmode_m;		

// Misc. Outputs
output [`M14K_ASID] 	mmu_r_asid;		// Load/Store Normal Memory from DEBUG
output 			mmu_r_asid_valid; 
output [`M14K_BUS] 	mmu_r_cpyout;		// Read data for MFC0 & SC register updates
output 		mmu_r_type;		// MMU type: 1->BAT, 0->TLB
output 	[1:0]	mmu_r_size;		// MMU size: 0->16, 1->32

// Translation/Address Error Outputs
output 		mmu_r_adrerr;
output 		mmu_r_dtexc_m;		// data reference translation error
output 		mmu_r_dtriexc_m;		// D-addr RI exception
output 		mmu_r_itexc_i;		// instruction reference translation error
output 		mmu_r_itxiexc_i;		// itlb execution inhibit exception
output 		mmu_r_rawdtexc_m;		// Raw translation exception (includes PREFS)
output 		mmu_r_rawitexc_i;		// Raw ITranslation exception
output 		mmu_r_tlbbusy;		// TLB is in midst of multi-cycle operation
output 		mmu_r_tlbinv;		// TLB Invalid exception
output 		mmu_r_tlbmod;			// TLB modified exception
output 		mmu_r_tlbrefill;		// TLB Refill exception
output 		mmu_r_tlbshutdown;		// conflict detected on TLB write
output 		mmu_r_iec;		// enable unique ri/xi exception code
output 		mmu_r_transexc;		// Translation exception - load shadow registers
output 		mmu_r_vafromi;		// Use ITLBH instead of JTLBH to load CP0 regs


output		r_asid_update;		// enhi register updated

output		mmu_r_it_segerr;
output [`M14K_GID] 	mmu_gid;
output [`M14K_GID] 	mmu_rid;
output		mmu_r_read_m;
output		mmu_read_m;
output		r_jtlb_wr;
output [`M14K_VPN2RANGE]	mmu_vat_hi;

// BEGIN Wire declarations made by MVP
wire [`M14K_JTLBL] /*[31:4]*/ r_jtlb_lo;
wire [`M14K_GID] /*[2:0]*/ gid;
// END Wire declarations made by MVP


wire 		rdtlb_ri;
wire 		rdtlb_xi;

assign gid[`M14K_GID] = {`M14K_GIDWIDTH{1'b0}};

/*hookup*/
`M14K_TLB_ARRAY tlbarray (
	.cp0random_val_e(cp0random_val_e),
	.enc(enc),
	.enhi(enhi[7:0]),
	.entrylo(entrylo),
	.gbit(gbit),
	.gclk(gclk),
	.gid(gid),
	.greset(greset),
	.gscanenable(gscanenable),
	.gtlbclk(gtlbclk),
	.guest_mode(guest_mode),
	.inv(inv),
	.is_root(1'b0),
	.jtlb_grain(jtlb_grain),
	.jtlb_lo(jtlb_lo),
	.jtlb_pah(jtlb_pah),
	.mmu_gid(mmu_gid),
	.mmu_index(mmu_index),
	.mmu_size(mmu_size),
	.mmu_type(mmu_type),
	.pagegrain(pagegrain),
	.pagemask(pagemask),
	.tag_array_out(tag_array_out),
	.tlb_enable(tlb_enable),
	.tlb_match(tlb_match),
	.tlb_rd_0(tlb_rd_0),
	.tlb_rd_1(tlb_rd_1),
	.tlb_vpn(tlb_vpn),
	.tlb_wr_0(tlb_wr_0),
	.tlb_wr_1(tlb_wr_1),
	.tlb_wr_cmp(tlb_wr_cmp));

/*hookup*/
m14k_tlb_cpy tlb_cpy(
	.asid_update(asid_update),
	.cp0_probe_m(cp0_probe_m),
	.cp0_read_m(cp0_read_m),
	.cp0random_val_e(cp0random_val_e),
	.cpz_gm_m(cpz_gm_m),
	.cpz_mmusize(cpz_mmusize),
	.cpz_smallpage(cpz_smallpage),
	.cpz_vz(cpz_vz),
	.edp_alu_m(edp_alu_m),
	.edp_dpal(mmu_dva_m[`M14K_PAL]),
	.enc(enc),
	.enhi(enhi),
	.entrylo(entrylo),
	.gbit(gbit),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.inv(inv),
	.is_root(1'b0),
	.ixp(ixp),
	.jtlb_lo(jtlb_lo),
	.mmu_asid(mmu_asid),
	.mmu_asid_valid(mmu_asid_valid),
	.mmu_cpyout(mmu_cpyout),
	.mmu_dpah(mmu_dpah),
	.mmu_iec(mmu_iec),
	.mmu_read_m(mmu_read_m),
	.mmu_transexc(mmu_transexc),
	.mmu_type(mmu_type),
	.mmu_vat_hi(mmu_vat_hi),
	.mpc_cp0move_m(mpc_cp0move_m),
	.mpc_cp0r_m(mpc_cp0r_m),
	.mpc_cp0sr_m(mpc_cp0sr_m),
	.mpc_dmsquash_m(mpc_dmsquash_m),
	.mpc_fixup_m(mpc_fixup_m),
	.mpc_jamtlb_w(mpc_jamtlb_w),
	.mpc_ll1_m(mpc_ll1_m),
	.mpc_load_m(mpc_load_m),
	.mpc_run_m(mpc_run_m),
	.pagegrain(pagegrain),
	.pagemask(pagemask),
	.tag_array_out(tag_array_out),
	.tlb_match(tlb_match),
	.tlb_wr_1(tlb_wr_1));

parameter JW = `M14K_JTLBLWIDTH;
assign r_jtlb_lo[`M14K_JTLBL] = {JW{1'b0}};

/*hookup*/
m14k_tlb_itlb tlb_itlb (
	.cpz_gm_i(cpz_gm_i),
	.cpz_guestid(gid),
	.cpz_vz(cpz_vz),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.itlb_miss(itlb_miss),
	.jtlb_grain(jtlb_grain),
	.jtlb_idx(enc),
	.jtlb_lo(jtlb_lo),
	.jtlb_pah(jtlb_pah),
	.jtlb_wr(jtlb_wr),
	.jtlb_wr_idx(mmu_index),
	.lookup(lookupi),
	.mmu_asid(mmu_asid),
	.mmu_ipah(mmu_ipah),
	.pa_cca(ipa_cca),
	.pre_pah(pre_ipah),
	.r_jtlb_lo(r_jtlb_lo),
	.r_jtlb_wr(1'b0),
	.rjtlb_idx(5'b0),
	.update_utlb(itmack_id),
	.utlb_bypass(itlb_bypass),
	.va(edp_cacheiva_i[`M14K_VPNRANGE]));

/*hookup*/
m14k_tlb_dtlb tlb_dtlb (
	.cpz_gm_m(cpz_gm_m),
	.cpz_guestid(gid),
	.cpz_vz(cpz_vz),
	.dmap(dmap),
	.dtlb_miss(dtlb_miss),
	.dtlb_ri(dtlb_ri),
	.dtlb_xi(dtlb_xi),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.jtlb_grain(jtlb_grain),
	.jtlb_idx(enc),
	.jtlb_lo(jtlb_lo),
	.jtlb_pah(jtlb_pah),
	.jtlb_wr(jtlb_wr),
	.jtlb_wr_idx(mmu_index),
	.lookup(lookupd),
	.mmu_asid(mmu_asid),
	.mmu_dpah(mmu_dpah),
	.pa_cca(dpa_cca),
	.pre_pah(pre_dpah),
	.r_jtlb_lo(r_jtlb_lo),
	.r_jtlb_wr(1'b0),
	.rdtlb_ri(rdtlb_ri),
	.rdtlb_xi(rdtlb_xi),
	.rjtlb_idx(5'b0),
	.store(store_trans_m),
	.update_utlb(update_dtlb),
	.utlb_bypass(dtlb_bypass),
	.va(mmu_dva_m[`M14K_VPNRANGE]));

/*hookup*/
m14k_tlb_ctl tlb_ctl (
	.cp0_probe_m(cp0_probe_m),
	.cp0_read_m(cp0_read_m),
	.cp0random_val_e(cp0random_val_e),
	.dadr_err_m(dadr_err_m),
	.dcc_newdaddr(dcc_newdaddr),
	.dmap(dmap),
	.dtlb_exc(dtlb_exc),
	.dtlb_miss(dtlb_miss),
	.dtlb_ri(dtlb_ri),
	.dtlb_ri_exc(dtlb_ri_exc),
	.dtlb_xi(dtlb_xi),
	.edp_cacheiva_i(edp_cacheiva_i),
	.edp_iva_i(edp_iva_i),
	.enhi(enhi[29:9]),
	.gclk(gclk),
	.greset(greset),
	.gscanenable(gscanenable),
	.iadr_err_i(iadr_err_i),
	.imap(imap),
	.itlb_exc(itlb_exc),
	.itlb_miss(itlb_miss),
	.itlb_xi_exc(itlb_xi_exc),
	.itmack_id(itmack_id),
	.itmack_idd(itmack_idd),
	.ixp(ixp),
	.jtlb_lo(jtlb_lo),
	.jtlb_wr(jtlb_wr),
	.lookupd(lookupd),
	.lookupi(lookupi),
	.mmu_dtexc_m(mmu_dtexc_m),
	.mmu_dtmack_m(mmu_dtmack_m),
	.mmu_dtriexc_m(mmu_dtriexc_m),
	.mmu_dva_m(mmu_dva_m),
	.mmu_index(mmu_index),
	.mmu_itmack_i(mmu_itmack_i),
	.mmu_itmres_nxt_i(mmu_itmres_nxt_i),
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
	.mmu_r_pm_jthit_d(mmu_r_pm_jthit_d),
	.mmu_r_pm_jthit_i(mmu_r_pm_jthit_i),
	.mmu_r_pm_jtmiss_d(mmu_r_pm_jtmiss_d),
	.mmu_r_pm_jtmiss_i(mmu_r_pm_jtmiss_i),
	.mmu_tlbbusy(mmu_tlbbusy),
	.mmu_tlbinv(mmu_tlbinv),
	.mmu_tlbmod(mmu_tlbmod),
	.mmu_tlbrefill(mmu_tlbrefill),
	.mmu_tlbshutdown(mmu_tlbshutdown),
	.mmu_vat_hi(mmu_vat_hi),
	.mpc_atomic_m(mpc_atomic_m),
	.mpc_busty_m(mpc_busty_m),
	.mpc_busty_raw_e(mpc_busty_raw_e),
	.mpc_cp0func_e(mpc_cp0func_e),
	.mpc_ctlen_noe_e(mpc_ctlen_noe_e),
	.mpc_dmsquash_m(mpc_dmsquash_m),
	.mpc_eexc_e(mpc_eexc_e),
	.mpc_exc_e(mpc_exc_e),
	.mpc_exc_m(mpc_exc_m),
	.mpc_irval_e(mpc_irval_e),
	.mpc_newiaddr(mpc_newiaddr),
	.mpc_pcrel_m(mpc_pcrel_m),
	.mpc_run_ie(mpc_run_ie),
	.mpc_run_m(mpc_run_m),
	.store_trans_m(store_trans_m),
	.tlb_enable(tlb_enable),
	.tlb_match(tlb_match),
	.tlb_rd_0(tlb_rd_0),
	.tlb_rd_1(tlb_rd_1),
	.tlb_squash_i(tlb_squash_i),
	.tlb_vpn(tlb_vpn),
	.tlb_wr_0(tlb_wr_0),
	.tlb_wr_1(tlb_wr_1),
	.tlb_wr_cmp(tlb_wr_cmp),
	.update_dtlb(update_dtlb));

/*hookup*/
m14k_mmuc mmuc (
	.cacheiva_trans(edp_cacheiva_i[`M14K_VPNRANGE]),
	.cdmm_mpu_present(cdmm_mpu_present),
	.cpz_cdmm_enable(cpz_cdmm_enable),
	.cpz_cdmmbase(cpz_cdmmbase),
	.cpz_dm_m(cpz_dm_m),
	.cpz_erl(cpz_erl),
	.cpz_hotdm_i(cpz_hotdm_i),
	.cpz_hoterl(cpz_hoterl),
	.cpz_k0cca(cpz_k0cca),
	.cpz_k23cca(cpz_k23cca),
	.cpz_kuc_i(cpz_kuc_i),
	.cpz_kuc_m(cpz_kuc_m),
	.cpz_kucca(cpz_kucca),
	.cpz_lsnm(cpz_lsnm),
	.cpz_mmutype(cpz_mmutype),
	.dadr_err_m(dadr_err_m),
	.dcc_newdaddr(dcc_newdaddr),
	.dmap(dmap),
	.dpa_cca(dpa_cca),
	.dtlb_bypass(dtlb_bypass),
	.dtlb_exc(dtlb_exc),
	.dtlb_ri_exc(dtlb_ri_exc),
	.dva_trans(mmu_dva_m[`M14K_VPNRANGE]),
	.dva_trans_mapped(mmu_dva_mapped_m),
	.edp_cacheiva_i(edp_cacheiva_i),
	.edp_dva_e(edp_dva_e),
	.edp_dva_mapped_e(edp_dva_mapped_e),
	.edp_iva_i(edp_iva_i),
	.ejt_disableprobedebug(ejt_disableprobedebug),
	.fdc_present(fdc_present),
	.gclk(gclk),
	.gscanenable(gscanenable),
	.iadr_err_i(iadr_err_i),
	.icc_slip_n_nhalf(icc_slip_n_nhalf),
	.icc_umipsfifo_stat(icc_umipsfifo_stat),
	.imap(imap),
	.ipa_cca(ipa_cca),
	.itlb_bypass(itlb_bypass),
	.itlb_exc(itlb_exc),
	.itlb_xi_exc(itlb_xi_exc),
	.itmack_idd(itmack_idd),
	.iva_trans(edp_iva_i[`M14K_VPNRANGE]),
	.ivat_lo(edp_iva_i[1:0]),
	.lookupd(lookupd),
	.lookupi(lookupi),
	.mmu_adrerr(mmu_adrerr),
	.mmu_cdmm_kuc_m(mmu_cdmm_kuc_m),
	.mmu_dcmode(mmu_dcmode),
	.mmu_dpah(mmu_dpah),
	.mmu_dtexc_m(mmu_dtexc_m),
	.mmu_dtriexc_m(mmu_dtriexc_m),
	.mmu_dva_m(mmu_dva_m),
	.mmu_dva_mapped_m(mmu_dva_mapped_m),
	.mmu_icacabl(mmu_icacabl),
	.mmu_imagicl(mmu_imagicl),
	.mmu_ipah(mmu_ipah),
	.mmu_it_segerr(mmu_it_segerr),
	.mmu_itexc_i(mmu_itexc_i),
	.mmu_itxiexc_i(mmu_itxiexc_i),
	.mmu_ivastrobe(mmu_ivastrobe),
	.mmu_rawdtexc_m(mmu_rawdtexc_m),
	.mmu_rawitexc_i(mmu_rawitexc_i),
	.mmu_transexc(mmu_transexc),
	.mmu_type(mmu_type),
	.mmu_vafromi(mmu_vafromi),
	.mpc_annulds_e(mpc_annulds_e),
	.mpc_bussize_m(mpc_bussize_m),
	.mpc_busty_m(mpc_busty_m),
	.mpc_continue_squash_i(mpc_continue_squash_i),
	.mpc_excisamode_i(mpc_excisamode_i),
	.mpc_fixup_m(mpc_fixup_m),
	.mpc_fixupi(mpc_fixupi),
	.mpc_isamode_i(mpc_isamode_i),
	.mpc_itqualcond_i(mpc_itqualcond_i),
	.mpc_lsdc1_m(mpc_lsdc1_m),
	.mpc_newiaddr(mpc_newiaddr),
	.mpc_nobds_e(mpc_nobds_e),
	.mpc_pexc_i(mpc_pexc_i),
	.mpc_pexc_m(mpc_pexc_m),
	.mpc_run_ie(mpc_run_ie),
	.mpc_squash_i(mpc_squash_i),
	.pre_dpah(pre_dpah),
	.pre_ipah(pre_ipah),
	.tlb_squash_i(tlb_squash_i));

/*hookup*/
m14k_tlb_collector tlb_collector(
	.cpz_drg(cpz_drg),
	.cpz_drgmode_i(cpz_drgmode_i),
	.cpz_drgmode_m(cpz_drgmode_m),
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
	.cpz_gm_i(cpz_gm_i),
	.cpz_gm_m(cpz_gm_m),
	.cpz_rid(cpz_rid),
	.cpz_vz(cpz_vz),
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
	.mmu_rid(mmu_rid),
	.mpc_g_cp0func_e(mpc_g_cp0func_e),
	.mpc_g_cp0move_m(mpc_g_cp0move_m),
	.mpc_g_eexc_e(mpc_g_eexc_e),
	.mpc_g_jamtlb_w(mpc_g_jamtlb_w),
	.r_asid_update(r_asid_update),
	.r_jtlb_wr(r_jtlb_wr));

// 
// Artifact code to give the testbench a cannonical reference point independent of 
// which mmu array is instantiated or selected
 `ifdef MIPS_SIMULATION 
 //VCS coverage off 
//

function [`M14K_PMASKHI : `M14K_PMASKLO] expand;
   input [`M14K_CMASKHI : `M14K_CMASKLO] c;
   expand = {`M14K_CM2PM};
endfunction

function [`M14K_CMASKHI : `M14K_CMASKLO] comprs;
   input [`M14K_PMASKHI : `M14K_PMASKLO] p;
   comprs = {`M14K_PM2CM};
endfunction

wire TB_TLBWr1 = tlb_ctl.tlb_wr_0;
wire [31:0] TB_NextENLO0 = {tlb_cpy.next_enlo0[`M14K_RINHBIT],tlb_cpy.next_enlo0[`M14K_XINHBIT],4'b0,
                            tlb_cpy.next_enlo0[`M14K_PFN],tlb_cpy.next_enlo0[`M14K_JTLBLOATT]};
wire [31:0] TB_NextENLO1 = {tlb_cpy.next_enlo1[`M14K_RINHBIT],tlb_cpy.next_enlo1[`M14K_XINHBIT],4'b0,
                            tlb_cpy.next_enlo1[`M14K_PFN],tlb_cpy.next_enlo1[`M14K_JTLBLOATT]};
wire [`M14K_BUS] TB_NextPageGrain = tlb_cpy.pagegrain32_next;
wire [`M14K_ENHIRANGE] next_enhi =
    tlb_cpy.mpc_jamtlb_w ? {tlb_cpy.enhi_s[`M14K_VPN2RANGE] & {{ `M14K_VPN2WIDTH - 2 { 1'b1}}, { 2 { ~pagegrain }}}, 
	                    tlb_cpy.enhi[`M14K_ASIDWIDTH], tlb_cpy.enhi[`M14K_ASID]}
  : tlb_cpy.tlb_read_m ? {tlb_cpy.tag_array_out[`M14K_VPN2RANGETLB] & {{ `M14K_VPN2WIDTH - 2 { 1'b1}}, { 2 { ~pagegrain }}}, 
                            tlb_cpy.tag_array_out[`M14K_INVRANGETLB], tlb_cpy.tag_array_out[`M14K_ASIDRANGETLB]}
  :    tlb_cpy.enhi_ld ? {tlb_cpy.next_enhi_mx[`M14K_VPN2RANGEENHI] & {{ `M14K_VPN2WIDTH - 2 { 1'b1}}, { 2 { ~pagegrain }}},
                            tlb_cpy.next_enhi_mx[`M14K_ASIDWIDTH], tlb_cpy.next_enhi_mx[`M14K_ASID]}
  : tlb_cpy.enhi;
wire [`M14K_BUS] TB_NextENHI = next_enhi;

wire [`M14K_BUS] TB_ENHI = tlb_cpy.enhi;
wire [5:0] next_index = tlb_cpy.idx_wr ? ({ ~tlb_cpy.tlb_match, tlb_cpy.enc }) :
                        {tlb_cpy.index[5], tlb_cpy.idx_ld ? tlb_cpy.edp_alu_m[4:0] : tlb_cpy.index[4:0]};
wire [5:0]  TB_NextINDEX = next_index & {1'b1, cpz_mmusize, 3'h7};
wire [`M14K_CMASK] next_pagemask = (tlb_cpy.tlb_read_m || tlb_cpy.pagemask_ld) ?
					(tlb_cpy.next_pagemask_mx & {{`M14K_CMASKWIDTH-2{1'b1}}, {2{~pagegrain}}}) : 
					comprs(tlb_cpy.pagemask32[`M14K_PMRANGE]);
wire [`M14K_PMRANGE] TB_NextPageMask = expand(next_pagemask);
wire [4:0]  TB_NextRan = tlb_cpy.next_random & {cpz_mmusize, 3'h7};
wire [4:0]  TB_Ran = tlb_cpy.random & {cpz_mmusize, 3'h7};
wire [4:0]  TB_NextWired  = (tlb_cpy.greset || tlb_cpy.wired_ld) ? tlb_cpy.next_wired : tlb_cpy.wired;
wire        TB_RawDMap = mmuc.raw_dmap;
wire [`M14K_JTLBL] TB_JTLBL = jtlb_lo;
wire        TB_JMemD = mmuc.jmemd;
wire        TB_TLBRd1 = tlb_rd_1;
wire        TB_IxLd = tlb_cpy.idx_wr;
wire [4:0]  TB_MMUIndex = mmu_index;

wire G_TB_TLBWr1 = 1'b0;
wire [31:0] G_TB_NextENLO0 = 32'bx;
wire [31:0] G_TB_NextENLO1 = 32'bx;
wire [`M14K_BUS] G_TB_NextENHI = 32'bx;
wire [`M14K_BUS] G_TB_ENHI = 32'bx;
wire [5:0]  G_TB_NextINDEX = 6'bx;
wire [`M14K_PMASK] G_TB_NextPageMask = 12'bx;
wire [4:0]  G_TB_NextRan = 5'bx;
wire [4:0]  G_TB_Ran = 5'bx;
wire [4:0]  G_TB_NextWired  = 5'b0;
wire        G_TB_RawDMap = 1'b0;
wire [`M14K_JTLBL] G_TB_JTLBL = 26'bx;
wire        G_TB_TLBRd1 = 1'b0;
wire        G_TB_IxLd = 1'b0;
wire [4:0]  G_TB_MMUIndex = 5'b0;
wire [`M14K_BUS] G_TB_NextPageGrain = 32'b0;
wire G_Cp0Random_E = 1'b0;


// Assertion check to verify that TLBWR always writes an index 
// that is >= wired register

wire FxCp0RandomNoE_E;
wire Cp0Random_E;
wire FxCp0RandomNoE_ED, Cp0Random_M, Cp0Random_W;
wire fxexc_e = tlb_ctl.fxexc_e;
wire [4:0] wired = tlb_cpy.wired;
	mvp_register #(1) _FxCp0RandomNoE_ED(FxCp0RandomNoE_ED, gclk, FxCp0RandomNoE_E);
	mvp_register #(1) _Cp0Random_M(Cp0Random_M, gclk,FxCp0RandomNoE_E);
	mvp_register #(1) _Cp0Random_W(Cp0Random_W, gclk, Cp0Random_M);

assign Cp0Random_E = FxCp0RandomNoE_E && !fxexc_e;

assign FxCp0RandomNoE_E = mpc_run_m ? (cp0random_val_e && mpc_ctlen_noe_e) : FxCp0RandomNoE_ED;

wire RandLTWired = ((Cp0Random_E && tlb_wr_cmp) || 
		    (Cp0Random_M && tlb_wr_0) || 
	 	    (Cp0Random_W && tlb_wr_1)) &&
			(mmu_index < wired);
 //VCS coverage on  
 `endif 
//
//



//verilint 528 off        // Variable set but not used
wire unused_ok;
  assign unused_ok = &{1'b0,
		rdtlb_ri, rdtlb_xi};
//verilint 528 on        // Variable set but not used

endmodule	// m14k_tlb
