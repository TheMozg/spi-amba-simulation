// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_ejt_area
//            EJTAG Area Controller - controls access to different
//            regions in EJTAG dseg and handles general EJTAG functions
//
//
//	$Id: \$
//	mips_repository_id: m14k_ejt_area.mv, v 1.18.2.1 
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
module m14k_ejt_area(
	gscanenable,
	gfclk,
	gclk,
	greset,
	biu_eaaccess,
	biu_if_enable,
	ejt_eadone,
	ejt_predonenxt,
	HWRITE,
	AHB_EAddr,
	biu_be_ej,
	HWDATA,
	ejt_eadata,
	EJ_SRstE,
	ejt_dcrnmie,
	ejt_dcrinte,
	ejt_ejtagbrk,
	cpz_nmipend,
	EJ_DebugM,
	cpz_enm,
	ej_disableprobedebug,
	EJ_DINT,
	ej_paaccess,
	ej_padone,
	ej_sbwrite,
	ej_dcr_override,
	ej_eagwrite,
	ej_eagaddr,
	ej_eagbe,
	ej_eagdataout,
	ej_padatain,
	ej_sbdatain,
	pdt_datain,
	ej_proben,
	ej_tap_brk,
	ej_noinstbrk,
	ej_nodatabrk,
	ej_cbrk_present,
	area_itcb_twh,
	area_itcb_tw,
	itcbtw_sel,
	itcbtwh_sel,
	itcb_tw_rd,
	pcs_present,
	das_present,
	pc_sync_period,
	pcse,
	pc_sync_period_diff,
	pc_im,
	pc_noasid,
	pc_noguestid,
	dasq,
	dase,
	fdc_present,
	cdmm_area,
	cdmm_hit,
	cdmm_sel,
	cdmm_fdc_hit,
	cdmm_rdata_xx,
	cdmm_ej_override,
	cdmm_wdata_xx,
	ejt_disableprobedebug,
	cpz_cdmmbase,
	cpz_vz,
	mpc_umipspresent,
	cpz_bootisamode,
	ej_rdvec_read,
	ej_rdvec);


// Signals between EJTAG Area and Core 
        input           gscanenable;     // Scan Enable
input		gfclk;		// Free running clock
input		gclk;		// Clock turned off by WAIT
input		greset;	        // reset
input		biu_eaaccess;	// EJTAG Area transaction ongoing
input		biu_if_enable;	
output		ejt_eadone;	// EJTAG Area/Cdmm transaction done
output		ejt_predonenxt; // EJTAG Area/Cdmm transaction ongoing
input		HWRITE;		// EJTAG Area write indication
input	[31:2]	AHB_EAddr;	// EJTAG Area address 
input	[3:0]	biu_be_ej;	// EJTAG Area byte enable indication
input	[31:0]	HWDATA;		// EJTAG Area data output
output	[31:0]	ejt_eadata;	// EJTAG Area data input	
output		EJ_SRstE;	// SRstE bit from DCR
output		ejt_dcrnmie;	// NMIE bit from DCR
output		ejt_dcrinte;	// IntE bit from DCR
output		ejt_ejtagbrk;	// EjtagBrk indication
input		cpz_nmipend;	// NMIpend indication
input		EJ_DebugM;		// Early Debug mode indication
input		cpz_enm;		// Endian mode for kernal and debug mode
input		ej_disableprobedebug; // unregistered disable debug probe

// Signals between EJTAG Area and Core boundary 
input		EJ_DINT;	// Debug mode request

// Signals between EJTAG Area, TAP and Simple Break
output		ej_paaccess;	// PA access transaction ongoing
input		ej_padone;	// PA access done
output		ej_sbwrite;	// Simple Break write indication
output		ej_dcr_override;
output		ej_eagwrite;	// Gated write indication 
output	[19:2]	ej_eagaddr;	// Gated address
output	[3:0]	ej_eagbe;	// Gated byte enables
output	[31:0]	ej_eagdataout;	// Gated data out
input	[31:0]	ej_padatain;	// PA data in
input	[31:0]	ej_sbdatain;	// Simple Break data in
input [31:0]	pdt_datain;	// Outdata of register bus
input		ej_proben;	// Probe Enable indication
input		ej_tap_brk;	// EJTAG break from EJTAG Control register

// Signals between EJTAG Area and Simple Break 
input		ej_noinstbrk;	 // For InstBrk in DCR reg
input		ej_nodatabrk;	 // For DataBrk in DCR reg
input		ej_cbrk_present; // For CBT in DCR reg
output 		area_itcb_twh;	// Read ITCB register ITCBTWh(0x3F84)
output 		area_itcb_tw;  	// Read ITCB register ITCBTW(0x3F80)
				// on-chip memory address incremental
input		itcbtw_sel;	// Select ITCBTW
input		itcbtwh_sel;	// Select ITCBTWH
input		itcb_tw_rd;     // ITCBTW is valid

input	       pcs_present;
input	       das_present;
output [2:0]   pc_sync_period;     // sync period for PC sampling
output         pcse;               // PC sample enable
output         pc_sync_period_diff;  // indicates that a new value of pc sync period was writteb
output	       pc_im;		   // config PC sampling to capture all excuted addresses or only those that miss the instruction cache
output	       pc_noasid;	   // whether the PCsample chain includes ot omit the ASID field
output	       pc_noguestid;	   // whether the PCsample chain includes ot omit the ASID field
output         dasq;               // qualifies Data Address Sampling using a data breakpoint
output         dase;               // enables data address sampling

input		fdc_present;
input		cdmm_area;
input		cdmm_hit;
input		cdmm_sel;
input		cdmm_fdc_hit;
input 	[31:0]  cdmm_rdata_xx;
input		cdmm_ej_override;
output  [31:0]  cdmm_wdata_xx;
output		ejt_disableprobedebug; // disable ejtag mem space
input   [31:15] cpz_cdmmbase;
input           cpz_vz;
input		mpc_umipspresent;


input  cpz_bootisamode;
output [31:0] ej_rdvec_read;
output ej_rdvec;

// BEGIN Wire declarations made by MVP
wire rdvec_6;
wire area_simple_break;
wire [31:0] /*[31:0]*/ ej_eagdataout;
wire area_itcb_tw;
wire EJ_SRstE;
wire sync_dint_delay;
wire pre_done;
wire area_itcb;
wire ej_rdvec;
wire ej_dcr_override;
wire ej_padone_sync;
wire [31:0] /*[31:0]*/ ej_eadatain_next;
wire ej_eagwrite;
wire pre_done_next;
wire area_simple_break_vn;
wire ej_area_fdc;
wire [2:0] /*[2:0]*/ pc_sync_period;
wire rdvec_sel;
wire pc_noasid;
wire area_itcb_tw64;
wire area_ejtag_memory;
wire itcb_tw_rd_sync;
wire ejt_dcrnmie;
wire area_ejtag_register;
wire area_dcr;
wire ej_sbwrite;
wire pc_noguestid;
wire pre_sync_dint;
wire ejt_predonenxt;
wire ej_padone_reg;
wire dasq;
wire ejt_ejtagbrk;
wire area_itcb_twh;
wire dase;
wire pc_im;
wire disableprobedebug_sync1;
wire pre_done_next_ex_pa;
wire pcse;
wire [3:0] /*[3:0]*/ ej_eagbe;
wire itcb_tw_rd_reg;
wire [31:0] /*[31:0]*/ ejt_eadata_ej;
wire dint;
wire [31:0] /*[31:0]*/ ej_rdvec_read;
wire pre_done_next_pa;
wire area_sb_vn;
wire ejt_dcrinte;
wire sync_dint;
wire [31:0] /*[31:0]*/ vn_val;
wire area_simple_break_real;
wire dcr_sel;
wire [31:0] /*[31:0]*/ ejt_eadata;
wire [31:0] /*[31:0]*/ dcr_read;
wire ejt_eadone_sync;
wire dint_detect;
wire [29:7] /*[29:7]*/ rdvec;
wire ej_paaccess;
wire ejt_eadone;
wire ejt_disableprobedebug;
wire [19:2] /*[19:2]*/ ej_eagaddr;
wire [31:0] /*[31:0]*/ cdmm_wdata_xx;
// END Wire declarations made by MVP


// Generate gated versions of signals 

// Gated address
assign ej_eagaddr[19:2] = {18{biu_eaaccess}} & AHB_EAddr[19:2];
assign ej_eagwrite = biu_eaaccess & HWRITE & (!ej_area_fdc);

assign area_itcb_tw = area_itcb & itcbtw_sel & !HWRITE;
assign area_itcb_twh = area_itcb & itcbtwh_sel & !HWRITE;

// Gated byte enables
assign ej_eagbe[3:0] = {4{biu_eaaccess}} & biu_be_ej[3:0];

// Gated data out
assign ej_eagdataout[31:0] = {32{biu_eaaccess}} & HWDATA[31:0];

assign cdmm_wdata_xx[31:0] = ej_eagdataout[31:0];


// Address range detection, and data muxing 

// Detect access to EJTAG Memory, DCR or Simple Break areas. One hot.
assign ej_area_fdc = cdmm_fdc_hit;
assign area_ejtag_memory = biu_eaaccess & ~AHB_EAddr[20] & ~cdmm_hit;
assign area_ejtag_register = biu_eaaccess & AHB_EAddr[20] & ~cdmm_hit;
assign area_dcr = area_ejtag_register & (AHB_EAddr[19:2] == 18'h00000);
assign area_simple_break = area_ejtag_register & (AHB_EAddr[19:2] != 18'h00000);
assign area_itcb = area_ejtag_register & (AHB_EAddr[20:12] == 9'h103);
assign rdvec_sel = area_ejtag_register & (AHB_EAddr[19:2] == 18'h00008);

assign area_sb_vn = (AHB_EAddr[13:3] == 11'h234);
assign vn_val[31:0] = {20'b0, 12'hcae};

// control signals for mux   
assign area_simple_break_real = area_simple_break
			 && !area_itcb
			 && !area_sb_vn
			 && !rdvec_sel
			 ;
assign area_simple_break_vn = area_simple_break && area_sb_vn;

assign dcr_sel  = ~(area_ejtag_memory 
	     | area_simple_break_real
	     | area_itcb
	     | area_simple_break_vn
	     | rdvec_sel
	     );

// Generate pre_done_next indication for capture of data in, and for done
// Cleared on greset, on done indication by ejt_eadone to ensure that done
// is not signaled twice for EJTAG register transactions, or when no 
// biu_eaaccess
// ej_padone, itcb_tw_rd, ej_padatain is  one cycle valid signal

mvp_register #(1) _ej_padone_reg(ej_padone_reg,gclk, (ej_padone || ej_padone_reg) & !biu_if_enable);
assign ej_padone_sync = (ej_padone || ej_padone_reg) & biu_if_enable; 

mvp_register #(1) _itcb_tw_rd_reg(itcb_tw_rd_reg,gclk, (itcb_tw_rd || itcb_tw_rd_reg) & !biu_if_enable);
assign itcb_tw_rd_sync = (itcb_tw_rd || itcb_tw_rd_reg) & biu_if_enable; 

assign area_itcb_tw64 = area_itcb_twh | area_itcb_tw;
assign pre_done_next = ~greset & ~ejt_eadone & biu_eaaccess &
                (area_ejtag_register & ~area_itcb_tw64 | ej_padone_sync | area_itcb_tw64 & itcb_tw_rd_sync | cdmm_area);
assign pre_done_next_ex_pa = ~greset & ~ejt_eadone & biu_eaaccess &
                (area_ejtag_register & ~area_itcb_tw64 | area_itcb_tw64 & itcb_tw_rd | cdmm_area);
//ej_padone is used to capture the ej_padatain(one cycle valid). For sync with biu, use ej_padone_sync;
assign pre_done_next_pa =  ~greset & ~ejt_eadone & biu_eaaccess & ej_padone;


// Make pre_done signal, which goes to ejt_eadone just after ANDing with
// biu_eaaccess to be sure that done is only signalled for ongoing transaction
mvp_cregister #(1) _pre_done(pre_done,biu_if_enable, gclk, pre_done_next);
//pre_done_sync = pre_done & biu_if_enable; 
assign ejt_eadone = pre_done & biu_eaaccess; 
assign ejt_eadone_sync = ejt_eadone & biu_if_enable;
assign ejt_predonenxt = pre_done_next & biu_eaaccess;

// Mux and capture the data for ejt_eadata[31:0] due to timing
// Capture register only updated when done is expected and on read
mvp_mux1hot_6 #(32) _ej_eadatain_next_31_0_(ej_eadatain_next[31:0],
	area_ejtag_memory, ej_padatain[31:0],
	area_simple_break_real, ej_sbdatain[31:0],
	area_itcb , pdt_datain[31:0],
	area_simple_break_vn, vn_val[31:0],
	dcr_sel, dcr_read[31:0],
	rdvec_sel, ej_rdvec_read[31:0]
	);


mvp_cregister_wide #(32) _ejt_eadata_ej_31_0_(ejt_eadata_ej[31:0],gscanenable, (pre_done_next_ex_pa | pre_done_next_pa) & ~HWRITE, gclk,
				ej_eadatain_next[31:0]);
assign ejt_eadata[31:0] = cdmm_sel ? cdmm_rdata_xx[31:0] : ejt_eadata_ej[31:0];



assign ej_rdvec_read[31:0] = {2'b10, rdvec[29:7], 6'b00_0000, rdvec_6};
mvp_cregister_wide #(23) _rdvec_29_7_(rdvec[29:7],gscanenable, (ej_eagwrite & rdvec_sel) | greset, gclk, 
				!greset ? {ej_eagdataout[29:7]}
					: {23'h7f8009});
mvp_cregister #(1) _rdvec_6(rdvec_6,(ej_eagwrite & rdvec_sel) | greset | mpc_umipspresent, gclk, 
				!greset ? (ej_eagdataout[0] | mpc_umipspresent)
					: cpz_bootisamode | mpc_umipspresent);

// Debug Control Register 
// Generate read value of the DCR

assign dcr_read[31:0] = {
	cpz_vz ? ej_dcr_override : 1'b0,
	1'b0,			// Reserved bits
	cpz_enm,			// ENM bit
	pc_noguestid,
	1'b0,			// Reserved bits
	pc_im,			// All PC sample or I$ miss
	pc_noasid,		// include or omit ASID
	dasq,			// qualifies Data Address Sampling using a data breakpoint
	dase,			// enables data address sampling
	das_present,			// Data addr sampling is implemented
 	1'b0,		
	1'b0,	
	1'b0,
	fdc_present,			// FDC is present
	~ej_nodatabrk,		// DataBrk bit
	~ej_noinstbrk,		// InstBrk bit
	~ej_nodatabrk,		// Inverted Match Support (if breakpoints are implemented, these are too)
	~ej_nodatabrk,		// Load Data Value Register Support (if breakpoints are implemented, these are too)
	2'b0,			// Reserved bits
	ej_rdvec,		// debug address redirect vector control
	ej_cbrk_present,	// Complex Break/Trigger present
        pcs_present,                   // PC Sampling is present
        pc_sync_period[2:0],    // sync period for PC Sampling
        pcse,                   // PC Sampling enable
	ejt_dcrinte,		// IntE bit
	ejt_dcrnmie,		// NMIE bit
	cpz_nmipend,		// NMIpend bit
	EJ_SRstE,		// SRstE bit
	ej_proben};		// ProbEn bit


// Bits for SRstE, NMIE and IntE both set on greset, and update with R/W 
// on DCR write
mvp_cregister #(1) _EJ_SRstE(EJ_SRstE,ej_eagwrite & area_dcr & ejt_eadone_sync | greset, gclk, 
                       HWDATA[1] | greset);
mvp_cregister #(1) _ejt_dcrnmie(ejt_dcrnmie,ej_eagwrite & area_dcr & ejt_eadone_sync | greset, gclk, 
                       HWDATA[3] | greset);
mvp_cregister #(1) _ejt_dcrinte(ejt_dcrinte,ej_eagwrite & area_dcr & ejt_eadone_sync | greset, gclk, 
                       HWDATA[4] | greset);

mvp_cregister #(1) _ej_dcr_override(ej_dcr_override,ej_eagwrite & area_dcr & ejt_eadone_sync | greset, gclk, 
                       HWDATA[31] & ~greset & cpz_vz);
			
// PC Sampling, sync control
mvp_cregister #(1) _pc_im(pc_im,ej_eagwrite & area_dcr & ejt_eadone_sync | greset, gclk, HWDATA[26] & ~greset);
mvp_cregister #(1) _pc_noasid(pc_noasid,ej_eagwrite & area_dcr & ejt_eadone_sync | greset, gclk, HWDATA[25] & ~greset);
assign pc_noguestid = 1'b0;
mvp_cregister #(1) _dasq(dasq,ej_eagwrite & area_dcr & ejt_eadone_sync | greset, gclk, HWDATA[24] & ~greset);
mvp_cregister #(1) _dase(dase,ej_eagwrite & area_dcr & ejt_eadone_sync | greset, gclk, HWDATA[23] & ~greset & ~ejt_disableprobedebug);
mvp_cregister #(3) _pc_sync_period_2_0_(pc_sync_period[2:0],ej_eagwrite & area_dcr & ejt_eadone_sync | greset, gclk, HWDATA[8:6] & {3{~greset}});
mvp_cregister #(1) _pcse(pcse,ej_eagwrite & area_dcr & ejt_eadone_sync | greset, gclk, HWDATA[5] & ~greset & ~ejt_disableprobedebug);

mvp_register #(1) _disableprobedebug_sync1(disableprobedebug_sync1,gfclk, ej_disableprobedebug);
mvp_register #(1) _ejt_disableprobedebug(ejt_disableprobedebug,gfclk, disableprobedebug_sync1);

assign pc_sync_period_diff = (ej_eagwrite & area_dcr & ejt_eadone_sync | greset) ? ((HWDATA[8] ^ pc_sync_period[2]) |
                                  (HWDATA[7] ^ pc_sync_period[1]) |
                                  (HWDATA[6] ^ pc_sync_period[0])) : 1'b0;

mvp_cregister #(1) _ej_rdvec(ej_rdvec,ej_eagwrite & area_dcr & ejt_eadone_sync | greset, gclk, HWDATA[11] & ~greset);

// Processor Access indication 

// ej_paaccess deasserted when ejt_eadone_sync is asserted, which is used for 
// processor access handshake to ensure one deasserted cycle for each 
// transaction.
assign ej_paaccess = area_ejtag_memory & ~ejt_eadone_sync;



// Simple Break write indication 

// Write indication to simple break when end of transaction
assign ej_sbwrite = ej_eagwrite & area_simple_break & ejt_eadone_sync;



// DINT and EjtagBrk 

// Synchronize the EJ_DINT to gfclk domain
mvp_register #(1) _pre_sync_dint(pre_sync_dint, gfclk, EJ_DINT);
mvp_register #(1) _sync_dint(sync_dint, gfclk, pre_sync_dint & (~ejt_disableprobedebug | (cpz_vz ? ej_dcr_override : cdmm_ej_override) ) );

// Detect rising edge on EJ_DINT only if not while greset asserted
mvp_register #(1) _sync_dint_delay(sync_dint_delay, gfclk, sync_dint | greset);
assign dint_detect = sync_dint & ~sync_dint_delay;

// Capture of DINT indication
mvp_register #(1) _dint(dint, gfclk, (dint_detect | dint) & ~EJ_DebugM & ~greset);

// Combine DINT and EjtagBrk indication
assign ejt_ejtagbrk = dint | ej_tap_brk;



// The End 

endmodule
