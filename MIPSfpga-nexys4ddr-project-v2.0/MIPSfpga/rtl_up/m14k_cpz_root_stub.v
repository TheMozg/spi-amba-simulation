// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_cpz_root_stub 
//           Coprocessor Zero System control coprocessor
//
//      $Id: \$
//      mips_repository_id: m14k_cpz_root_stub.mv, v 1.14 
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
//	
//	

`include "m14k_const.vh"

module m14k_cpz_root_stub(
	greset,
	gscanenable,
	gclk,
	mtcp0_m,
	mpc_cp0r_m,
	mpc_wr_guestctl0_m,
	mpc_wr_guestctl2_m,
	mpc_cp0move_m,
	cpz_gm_m,
	mpc_cp0sr_m,
	cpz,
	mpc_jamepc_w,
	mpc_ge_exc,
	cause_s,
	mmu_r_read_m,
	mmu_read_m,
	mmu_gid,
	mmu_rid,
	int_gid_ed,
	eic_mode,
	srsctl_vec2css_w,
	int_pend_e,
	int_pend_ed,
	int_ss_ed,
	siu_srsdisable,
	int_offset_ed,
	int_vector_ed,
	cpz_eic_offset,
	mmu_r_type,
	gripl_clr,
	cpz_ri,
	cpz_cp0,
	cpz_at,
	cpz_gt,
	cpz_cg,
	cpz_cf,
	cpz_drg,
	hot_drg,
	sfc2,
	sfc1,
	r_pip,
	r_pip_e,
	hc_vip,
	hc_vip_e,
	vip,
	vip_e,
	fcd,
	guestctl0_mc,
	cpz_gid,
	cpz_rid,
	r_gtoffset,
	guestctl0_32,
	guestctl0ext_32,
	guestctl1_32,
	guestctl2_noneic,
	guestctl2_eic,
	guestctl3_32,
	gtoffset,
	hot_wr_guestctl0,
	hot_wr_guestctl2_noneic,
	glss,
	gripl,
	geicss,
	gvec,
	cpz_cgi,
	cpz_og,
	cpz_bg,
	cpz_mg);


/*hookios*/

//verilint 423 off        // A port with a range is re-declared with a different range

	/* Inputs */
	input		greset;		    // Power on and reset for chip
        input           gscanenable;        // Scan Enable
	input		gclk;		    // Clock
	input		mtcp0_m;
	input [4:0]	mpc_cp0r_m;	    // coprocessor zero register specifier
	input		mpc_wr_guestctl0_m;
	input		mpc_wr_guestctl2_m;
	input		mpc_cp0move_m;
	input		cpz_gm_m;
	input [2:0]	mpc_cp0sr_m;	    // coprocessor zero shadow register specifier
	input [31:0]	cpz;
	input		mpc_jamepc_w;
	input		mpc_ge_exc;
	input [11:0]	cause_s;
	input		mmu_r_read_m;
	input		mmu_read_m;
	input [2:0] 	mmu_gid;
	input [2:0] 	mmu_rid;
	input [2:0] 	int_gid_ed;
	input		eic_mode;
	input		srsctl_vec2css_w;
	input	[7:0]	int_pend_e;
	input [7:0]	int_pend_ed;
	input [3:0]	int_ss_ed;
        input [3:0]     siu_srsdisable;      // Disable some shadow sets
        input [17:1]     int_offset_ed;
        input [5:0]     int_vector_ed;
	input		cpz_eic_offset;
	input		mmu_r_type;
	input		gripl_clr;

	/* Outputs */
	output		cpz_ri;
	output		cpz_cp0;
	output	[1:0]	cpz_at;
	output		cpz_gt;
	output		cpz_cg;
	output		cpz_cf;
	output		cpz_drg;
	output		hot_drg;
	output		sfc2;
	output		sfc1;
	output [7:0]     r_pip;
	output [7:0]     r_pip_e;
	output	[7:0]	hc_vip;
	output	[7:0]	hc_vip_e;
	output	[7:0]	vip;
	output	[7:0]	vip_e;
	output		fcd;
	output		guestctl0_mc;
	output [2:0] 	cpz_gid;
	output [2:0] 	cpz_rid;
	output [31:0]    r_gtoffset;
	output [31:0]    guestctl0_32;
	output	[31:0]	guestctl0ext_32;
	output [31:0]    guestctl1_32;
	output [31:0]    guestctl2_noneic;
	output [31:0]    guestctl2_eic;
	output [31:0]    guestctl3_32;
	output [31:0]    gtoffset;
	output		hot_wr_guestctl0;
	output		hot_wr_guestctl2_noneic;
	output	[3:0]	glss;
	output	[7:0]	gripl;
	output	[3:0]	geicss;
	output	[15:0]	gvec;
	output		cpz_cgi;
	output		cpz_og;
	output		cpz_bg;
	output		cpz_mg;

// BEGIN Wire declarations made by MVP
wire [7:0] /*[7:0]*/ vip_e;
wire [7:0] /*[7:0]*/ vip;
wire [`M14K_GID] /*[2:0]*/ cpz_gid;
wire cpz_ri;
wire [`M14K_GID] /*[2:0]*/ cpz_rid;
wire [31:0] /*[31:0]*/ gtoffset;
wire [31:0] /*[31:0]*/ guestctl2_eic;
wire hot_wr_guestctl2_noneic;
wire [31:0] /*[31:0]*/ r_gtoffset;
wire cpz_cp0;
wire [15:0] /*[15:0]*/ gvec;
wire [31:0] /*[31:0]*/ guestctl1_32;
wire hot_wr_guestctl0;
wire [7:0] /*[7:0]*/ r_pip_e;
wire cpz_drg;
wire [7:0] /*[7:0]*/ hc_vip_e;
wire cpz_mg;
wire [31:0] /*[31:0]*/ guestctl0ext_32;
wire [7:0] /*[7:0]*/ r_pip;
wire hot_drg;
wire [7:0] /*[7:0]*/ hc_vip;
wire cpz_cg;
wire guestctl0_mc;
wire sfc1;
wire cpz_bg;
wire cpz_cgi;
wire [7:0] /*[7:0]*/ gripl;
wire [31:0] /*[31:0]*/ guestctl3_32;
wire cpz_cf;
wire cpz_gt;
wire fcd;
wire sfc2;
wire [3:0] /*[3:0]*/ geicss;
wire [31:0] /*[31:0]*/ guestctl2_noneic;
wire [3:0] /*[3:0]*/ glss;
wire [31:0] /*[31:0]*/ guestctl0_32;
wire [1:0] /*[1:0]*/ cpz_at;
wire cpz_og;
// END Wire declarations made by MVP


	parameter	GW = `M14K_GIDWIDTH;

	assign cpz_ri		= 1'b0;
	assign cpz_cp0		= 1'b0;
	assign cpz_at	[1:0]	= 2'b0;
	assign cpz_gt		= 1'b0;
	assign cpz_cg		= 1'b0;
	assign cpz_cf		= 1'b0;
	assign cpz_drg		= 1'b0;
	assign hot_drg		= 1'b0;
	assign sfc2		= 1'b0;
	assign sfc1		= 1'b0;
	assign cpz_cgi		= 1'b0;
	assign cpz_og		= 1'b0;
	assign cpz_bg		= 1'b0;
	assign cpz_mg		= 1'b0;
	assign r_pip [7:0]     = 8'b0;
	assign r_pip_e [7:0]     = 8'b0;
	assign fcd		= 1'b0;
	assign guestctl0_mc		= 1'b0;
	assign cpz_gid [`M14K_GID] 	= {GW{1'b0}};
	assign cpz_rid [`M14K_GID] 	= {GW{1'b0}};
	assign r_gtoffset [31:0]    = 32'b0;
	assign guestctl0_32 [31:0]    = 32'b0;
	assign guestctl0ext_32 [31:0]    = 32'b0;
	assign guestctl1_32 [31:0]    = 32'b0;
	assign guestctl2_noneic [31:0]    = 32'b0;
	assign guestctl2_eic [31:0]    = 32'b0;
	assign guestctl3_32 [31:0]    = 32'b0;
	assign gtoffset [31:0]    = 32'b0;
	assign hot_wr_guestctl0		= 1'b0;
	assign hot_wr_guestctl2_noneic		= 1'b0;
	assign glss [3:0]    = 4'b0;
	assign gripl [7:0]    = 8'b0;
	assign geicss [3:0]    = 4'b0;
	assign gvec [15:0]    = 8'b0;
	assign hc_vip [7:0] = 8'b0;
	assign hc_vip_e [7:0] = 8'b0;
	assign vip [7:0] = 8'b0;
	assign vip_e [7:0] = 8'b0;

// 
 `ifdef MIPS_SIMULATION 
 //VCS coverage off 
//
//verilint 528 off        // Variable set but not used

	wire [7:0] eid_nxt = 8'b0;
	wire [7:0] rid_nxt = 8'b0;
	wire [7:0] gid_nxt = 8'b0;
	wire [7:0] gripl_nxt = 8'b0;
	wire [7:0] hc_nxt = 8'b0;
	wire [7:0] vip_nxt = 8'b0;
	wire [3:0] geicss_nxt = 4'b0;
	wire [15:0] gvec_nxt = 16'b0;
	wire [3:0] glss_nxt = 4'b0;
	wire [27:0] guestctl0_nxt = 28'b0;
	wire [31:0] gtoffset_nxt = 32'b0;
	wire cgi_nxt = 1'b0;
	wire fcd_nxt = 1'b0;
	wire og_nxt = 1'b0;
	wire bg_nxt = 1'b0;
	wire mg_nxt = 1'b0;

 //VCS coverage on  
 `endif 
//
//
//verilint 528 on        // Variable set but not used

//verilint 423 on        // A port with a range is re-declared with a different range

endmodule	// m14k_cpz_root_stub
