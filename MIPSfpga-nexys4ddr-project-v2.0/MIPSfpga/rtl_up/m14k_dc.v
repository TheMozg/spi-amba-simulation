// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_dc
//            Data Cache module
//
//	$Id: \$
//	mips_repository_id: m14k_dc.mv, v 1.6 
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
module m14k_dc(
	gclk,
	greset,
	tag_addr,
	tag_wr_en,
	tag_rd_str,
	tag_wr_str,
	tag_wr_data,
	tag_rd_data,
	ws_addr,
	ws_wr_mask,
	ws_rd_str,
	ws_wr_str,
	ws_wr_data,
	ws_rd_data,
	data_addr,
	wr_mask,
	data_rd_str,
	data_wr_str,
	wr_data,
	rd_data,
	num_sets,
	set_size,
	hci,
	cache_present,
	bist_to,
	bist_from,
	dca_parity_present,
	early_tag_ce,
	early_data_ce,
	early_ws_ce);

	// Instance Overridden Parameters

	parameter	ASSOC = `M14K_DCACHE_ASSOC;	// Set Assoc
	parameter	WAYSIZE = `M14K_DCACHE_WAYSIZE;	// Size in KB
	parameter	PARITY = `M14K_PARITY_ENABLE;
	
	// calculated parameters

	parameter T_BITS = (PARITY == 1) ? `M14K_T_PAR_BITS : `M14K_T_NOPAR_BITS;
	parameter D_BITS = (PARITY == 1) ? `M14K_D_PAR_BITS : `M14K_D_NOPAR_BITS;
	parameter D_BYTES = (PARITY == 1) ? `M14K_D_PAR_BYTES : `M14K_D_NOPAR_BYTES;
	parameter M14K_MAX_DC_WS = (PARITY == 1) ? `M14K_MAX_DC_WS_PAR : `M14K_MAX_DC_WS_NOPAR;

	parameter	BITS_PER_BYTE_TAG = T_BITS;
	parameter	BITS_PER_BYTE_DATA = D_BYTES; 

	parameter	TAG_DEPTH = 6+((WAYSIZE==16) ? 4 :
					      (WAYSIZE==8) ? 3 :
					      (WAYSIZE==4) ? 2 : 
					      (WAYSIZE==2) ? 1 : 0 );

	parameter 	DATA_DEPTH = 8 + ((WAYSIZE==16) ? 4 :
					      (WAYSIZE==8) ? 3 :
					      (WAYSIZE==4) ? 2 : 
					      (WAYSIZE==2) ? 1 : 0 );

        parameter 	WS_WIDTH = (ASSOC == 4) ? ((PARITY == 1) ? 14 : 10):
			           (ASSOC == 3) ? ((PARITY == 1) ? 9 : 6) :
    			           (ASSOC == 2) ? ((PARITY == 1) ? 5 : 3) : 
						  ((PARITY == 1) ? 2 : 1);
      
	input		gclk;
	input		greset;

// tag array port
	input [13:4]	tag_addr;	// Index into tag array
	input [(`M14K_MAX_DC_ASSOC-1):0] 	tag_wr_en;
	input		tag_rd_str;	// Tag Read Strobe
	input		tag_wr_str;	// Tag Write Strobe
	input [T_BITS-1:0]	tag_wr_data;	// Data for Tag write 

	output [(T_BITS*`M14K_MAX_DC_ASSOC-1):0]	tag_rd_data;	// read tag // ws array port
        input [13:4]	ws_addr;         // Index into WS array
        input [13:0]	ws_wr_mask;       // Write mask to write dirty bit & LRU
        input 		ws_rd_str;        // WS Read Strobe
        input 		ws_wr_str;        // WS Write Strobe
        input [13:0]	ws_wr_data;       // Data for WS write
       
        output [13:0] ws_rd_data; 

// data array port	
	input [13:2]	data_addr;
	input [(4*`M14K_MAX_DC_ASSOC-1):0]	wr_mask;	// Byte Mask for writes
	input		data_rd_str;	// Data Read Strobe
	input 		data_wr_str;	// Data Write Strobe 
	input [D_BITS-1:0]	wr_data;		// Data in
	output [(D_BITS*`M14K_MAX_DC_ASSOC-1):0] rd_data;   // Read data for N ways of cache

	// Static outputs to tell core what cache looks like;
	output [2:0]	num_sets;		// Way Size:  0=1KB, 1=2KB, 2=4KB, 3=8KB, 4=16KB
	output [1:0]	set_size;		// Associativity: 
					//   0=DM, 1=2WSA, 2=3WSA, 3=4WSA
        output 		hci;             // hardware cache init?
        output 		cache_present;   // Do we have a cache?
	
	
	// Bist-related signals
	input [`M14K_DC_BIST_TO-1:0]	bist_to;		// bist signals from toplevel bistctl
	output [`M14K_DC_BIST_FROM-1:0]	bist_from;	// bist signals to toplevel bistctl

	output				dca_parity_present;

        input           early_tag_ce;
        input           early_data_ce;
        input           early_ws_ce;

// BEGIN Wire declarations made by MVP
wire [(WS_WIDTH-1):0] /*[4:0]*/ ws_wr_mask_short;
wire [143:0] /*[143:0]*/ data_rd_data_128;
wire [13:0] /*[13:0]*/ ws_wr_mask_full;
wire [2:0] /*[2:0]*/ num_sets;
wire [(WS_WIDTH-1):0] /*[4:0]*/ ws_wr_data_short;
wire [13:0] /*[13:0]*/ ws_wr_mask_adj;
wire [31:0] /*[31:0]*/ num_sets32;
wire [1:0] /*[1:0]*/ set_size;
wire [31:0] /*[31:0]*/ set_size32;
wire [13:0] /*[13:0]*/ ws_wr_data_adj;
wire cache_present;
wire [13:0] /*[13:0]*/ ws_wr_data_full;
wire [(D_BITS*`M14K_MAX_DC_ASSOC-1):0] /*[143:0]*/ rd_data;
wire [13:0] /*[13:0]*/ ws_rd_data_adj;
wire [(T_BITS*`M14K_MAX_DC_ASSOC-1):0] /*[99:0]*/ tag_rd_data;
wire [99:0] /*[99:0]*/ tag_rd_int96;
wire dca_parity_present;
wire [13:0] /*[13:0]*/ ws_rd_data_full;
wire [13:0] /*[13:0]*/ ws_rd_data;
// END Wire declarations made by MVP



	/* Inouts */
	/*hookios*/

	/* End of I/O */

	// Static Outputs
        assign set_size32 [31:0] = ASSOC - 1;                                // 0=DM, 1=2way, 2=3way, 3=4way
        assign set_size [1:0] = set_size32[1:0];     
        assign num_sets32 [31:0] = (WAYSIZE == 16) ? 4 :
			 (WAYSIZE == 8) ? 3 :
			 (WAYSIZE == 4) ? 2 : (WAYSIZE-1);    // 0-1K, 1-2K, 2-4K, 3-8K, 4-16K
        assign num_sets [2:0] = num_sets32[2:0];
        assign cache_present = 1'b1;       // Use nullcache module if there is not a cache

	/* Internal Block Wires */
	wire [`M14K_DC_BIST_TAG_TO-1:0]		tag_bist_to;
	wire [`M14K_DC_BIST_TAG_FROM-1:0]	tag_bist_from;
	wire [`M14K_DC_BIST_WS_TO-1:0]		ws_bist_to;
	wire [`M14K_DC_BIST_WS_FROM-1:0]	ws_bist_from;      
	wire [`M14K_DC_BIST_DATA_TO-1:0]		data_bist_to;
	wire [`M14K_DC_BIST_DATA_FROM-1:0]	data_bist_from;

	m14k_dc_bistctl #(`M14K_DC_BIST_TO, `M14K_DC_BIST_FROM, `M14K_DC_BIST_TAG_TO, `M14K_DC_BIST_TAG_FROM, `M14K_DC_BIST_WS_TO, `M14K_DC_BIST_WS_FROM,				`M14K_DC_BIST_DATA_TO, `M14K_DC_BIST_DATA_FROM) bistctl_cache (
		.cbist_to(bist_to),
		.cbist_from(bist_from),
		.tag_bist_to(tag_bist_to),
		.tag_bist_from(tag_bist_from),
		.ws_bist_to(ws_bist_to),
                .ws_bist_from(ws_bist_from),					 
		.data_bist_to(data_bist_to),
		.data_bist_from(data_bist_from)
	);

	//	Tag Array
	//
	//	CacheTag Format
	//		27-6		5 	4	3-0
	//		PA[31:10]	LRF	Lock	Valid[3:0]
	//
	// BYTES/Tag * (Data BYTES in Cache) / (Data BYTES / Line)
	wire [(T_BITS*ASSOC)-1:0]	tag_rd_int;	// Tag Read Output Wires

	`M14K_DC_TAGRAM tagram (
		.clk( gclk ),
		.greset( greset),
		.line_idx( tag_addr[(4+TAG_DEPTH)-1:4] ),
		.wr_mask( tag_wr_en[(ASSOC)-1:0] ),
		.rd_str( tag_rd_str ),
		.wr_str( tag_wr_str ),

		.wr_data( tag_wr_data ),
		.rd_data( tag_rd_int[T_BITS*ASSOC-1:0] ),

		.early_ce(early_tag_ce),

		.hci( hci),			       
		.bist_to( tag_bist_to ),
		.bist_from( tag_bist_from )
	);

	//
	//	Data Array
	//

	//	data_rd_data:  Data Array Output Before Way Muxing
	
	wire [ASSOC*D_BITS-1:0] data_rd_data;
      
	`M14K_DC_DATARAM dataram (
		.clk( gclk ),
		.line_idx( data_addr[(2 + DATA_DEPTH -1):2] ),
		.rd_mask({ASSOC{1'b1}}),
		.wr_mask( wr_mask[(4*ASSOC)-1:0] ),
		.rd_str( data_rd_str ),
		.wr_str( data_wr_str ),

		.wr_data(wr_data),
		.rd_data( data_rd_data ),

                .early_ce(early_data_ce),

		.bist_to( data_bist_to ),
		.bist_from( data_bist_from )
	);

        //      WS Array
        //

        parameter 	TESTTEST = M14K_MAX_DC_WS;

        // Max Assoc (M14K_MAX_DC_WS) is bus width from this module to the core.
        // Assoc (WS_WIDTH) is bus width from this module to ram.
        //*******
        //      core / 10 bit signal interface
	// Description: parity - 10 bit signal interface to 14-bit interface to support parity
        //*******
        // 10 bit signal <- core(max)
        assign ws_wr_data_full[13:0] = {ws_wr_data};

        assign ws_wr_mask_full[13:0] = {ws_wr_mask};

	// the format is:
	// 13 	12	11	10	9	8	7	6	5:0
	// P3	D3	P2	D2	P1	D1	P0	D0	LRU[5:0]
        assign ws_rd_data[13:0] = ws_rd_data_adj[13:0];
	assign ws_rd_data_adj [13:0] = 
		(WS_WIDTH == 14) ? ws_rd_data_full[13:0] :	// 4-way with parity
		(WS_WIDTH == 10) ? 				// 4-way without parity
			{1'b0,ws_rd_data_full[9], 1'b0, ws_rd_data_full[8],
			 1'b0, ws_rd_data_full[7], 1'b0, ws_rd_data_full[6], // insert parity bits
			 ws_rd_data_full[5:0]} : 		// LRU bits
		(WS_WIDTH == 9) ? 				// 3-way with parity
			{2'b0,ws_rd_data_full[8:3],		// parity & dirty bits
			 ws_rd_data_full[2], 2'b0, ws_rd_data_full[1:0], 1'b0} : // LRU bits
		(WS_WIDTH == 6) ? 				// 3-way without parity
			{3'b0,ws_rd_data_full[5], 1'b0, ws_rd_data_full[4],1'b0, ws_rd_data_full[3], // insert parity bits
			 ws_rd_data_full[2], 2'b0, ws_rd_data_full[1:0], 1'b0} : // LRU bits
		(WS_WIDTH == 5) ? 				// 2-way with parity bits
			{4'b0,ws_rd_data_full[4:1],		// parity & dirty bits
			 3'b0, ws_rd_data_full[0], 2'b0} : 	// LRU bits
		(WS_WIDTH == 3) ? 				// 2-way without parity
			{5'b0,ws_rd_data_full[2], 1'b0, ws_rd_data_full[1], // insert parity bits
			 3'b0, ws_rd_data_full[0], 2'b0} : 	// LRU bits
		(WS_WIDTH == 2) ?				// 1-way with parity
			{6'b0, ws_rd_data_full[1:0],		// parity & dirty bits
			 6'b0} :				// LRU bits
			{7'b0, ws_rd_data_full[0], 6'b0};	// 1-way without parity


        //*******
        //      14 bit signal / ram interface
        //*******
        assign ws_wr_data_short[(WS_WIDTH-1):0] = ws_wr_data_adj[(WS_WIDTH-1):0];

	// Note: the bus width from module to core is fixed to 13bit, core already arranged the bits, so 
	// we do not need to re-arrange it here
	assign ws_wr_data_adj[13:0] = 
              (WS_WIDTH == 14) ? ws_wr_data_full[13:0] :
              (WS_WIDTH == 10) ? 		// 4-way without parity
			{4'b0,ws_wr_data_full[12], ws_wr_data_full[10], ws_wr_data_full[8], ws_wr_data_full[6:0]} :
	      (WS_WIDTH == 9) ? 		// 3-way with parity
		    	{5'b0,ws_wr_data_full[11:6],ws_wr_data_full[5],ws_wr_data_full[2:1]} : // 6 bit
	      (WS_WIDTH == 6) ?			// 3-way without parity 
		   	{8'b0,ws_wr_data_full[10], ws_wr_data_full[8], ws_wr_data_full[6:5], ws_wr_data_full[2:1]} : 
	      (WS_WIDTH == 5) ?			// 2-way with parity 
			{9'b0, ws_wr_data_full[9:6], ws_wr_data_full[2]} :
	      (WS_WIDTH == 3) ?			// 2-way without parity 
			{11'b0, ws_wr_data_full[8], ws_wr_data_full[6], ws_wr_data_full[2]} :
	      (WS_WIDTH == 2) ?			// 1-way with parity 
			{12'b0, ws_wr_data_full[7:6]} :
              // else				// 1-way without parity
		    {13'b0,ws_wr_data_full[6]} ;
	

        assign ws_wr_mask_short[(WS_WIDTH-1):0] = ws_wr_mask_adj[(WS_WIDTH-1):0];
   
	
   	assign ws_wr_mask_adj[13:0] = 
              (WS_WIDTH == 14) ? ws_wr_mask_full[13:0] :
              (WS_WIDTH == 10) ? 		// 4-way without parity
			{4'b0,ws_wr_mask_full[12], ws_wr_mask_full[10], ws_wr_mask_full[8], ws_wr_mask_full[6:0]} :
	      (WS_WIDTH == 9) ? 		// 3-way with parity
		    	{5'b0,ws_wr_mask_full[11:6],ws_wr_mask_full[5],ws_wr_mask_full[2:1]} : // 6 bit
	      (WS_WIDTH == 6) ?			// 3-way without parity 
		   	{8'b0,ws_wr_mask_full[10], ws_wr_mask_full[8], ws_wr_mask_full[6:5], ws_wr_mask_full[2:1]} : 
	      (WS_WIDTH == 5) ?			// 2-way with parity 
			{9'b0, ws_wr_mask_full[9:6], ws_wr_mask_full[2]} :
	      (WS_WIDTH == 3) ?			// 2-way without parity 
			{11'b0, ws_wr_mask_full[8], ws_wr_mask_full[6], ws_wr_mask_full[2]} :
	      (WS_WIDTH == 2) ?			// 1-way with parity 
			{12'b0, ws_wr_mask_full[7:6]} :
              // else				// 1-way without parity
		    {13'b0,ws_wr_mask_full[6]} ;
	
   
        // 10 bit signal <- ram(assoc)
        wire [(WS_WIDTH-1):0] ws_rd_data_short;
        assign ws_rd_data_full [13:0] = {ws_rd_data_short};   
					   
   	`M14K_DC_WSRAM wsram (
		.clk( gclk ),
		.greset( greset),
		.line_idx( ws_addr[(4+TAG_DEPTH)-1:4] ),
		.wr_mask( ws_wr_mask_short ),
		.rd_str( ws_rd_str ),
		.wr_str( ws_wr_str ),
		.wr_data( ws_wr_data_short ),
		.rd_data( ws_rd_data_short ),

                .early_ce(early_ws_ce),

		.bist_to( ws_bist_to ),
		.bist_from( ws_bist_from )
	);

	assign data_rd_data_128[143:0] = {data_rd_data};
	assign rd_data [(D_BITS*`M14K_MAX_DC_ASSOC-1):0] = data_rd_data_128[(D_BITS*`M14K_MAX_DC_ASSOC-1):0];

	assign tag_rd_int96[99:0] = {tag_rd_int};
	
	assign tag_rd_data [(T_BITS*`M14K_MAX_DC_ASSOC-1):0] = tag_rd_int96[(T_BITS*`M14K_MAX_DC_ASSOC-1):0];

	assign dca_parity_present = (PARITY ==1) ? 1'b1 : 1'b0;
//	
`ifdef MIPS_SIMULATION 
//VCS coverage off 
// Testbench routines for reading or writing SRAM arrays
`ifdef M14K_FLUSH_DC_SUP
	task ReadTag;
		input [9:0] line_idx;
		output [4*24-1:0] trd_data;

		reg	[ASSOC*T_BITS-1:0]	rd_data_tag;
		begin
		tagram.Read(line_idx[TAG_DEPTH-1:0], rd_data_tag[ASSOC*T_BITS-1:0]);
		trd_data[4*24-1:0] = {rd_data_tag[3*T_BITS+23:3*T_BITS],rd_data_tag[2*T_BITS+23:2*T_BITS],
			   rd_data_tag[T_BITS+23 : T_BITS],rd_data_tag[23:0]};
		end
	endtask // ReadTag

	task ReadData;
		input [11:0] line_idx;
		output [4*32-1:0] trd_data;
		reg	[D_BITS-1:0]		rd_data_tmp0;
		reg	[D_BITS-1:0]		rd_data_tmp1;
		reg	[D_BITS-1:0]		rd_data_tmp2;
		reg	[D_BITS-1:0]		rd_data_tmp3;
	
		reg	[ASSOC*D_BITS-1:0]	rd_data_tmp;

		begin
		dataram.Read(line_idx[DATA_DEPTH-1:0], rd_data_tmp[ASSOC*D_BITS-1:0]);
		rd_data_tmp0[D_BITS-1:0] = rd_data_tmp[D_BITS-1:0];
		rd_data_tmp1[D_BITS-1:0] = rd_data_tmp[2*D_BITS-1:D_BITS];
		rd_data_tmp2[D_BITS-1:0] = rd_data_tmp[3*D_BITS-1:2*D_BITS];
		rd_data_tmp3[D_BITS-1:0] = rd_data_tmp[4*D_BITS-1:3*D_BITS];
		trd_data[4*32-1:0] = {rd_data_tmp3[3*D_BYTES+7:3*D_BYTES],rd_data_tmp3[2*D_BYTES+7 : 2*D_BYTES],
			   rd_data_tmp3[D_BYTES+7:D_BYTES], rd_data_tmp3[7:0],
			   rd_data_tmp2[3*D_BYTES+7:3*D_BYTES],rd_data_tmp2[2*D_BYTES+7 : 2*D_BYTES],
			   rd_data_tmp2[D_BYTES+7:D_BYTES], rd_data_tmp2[7:0],
			   rd_data_tmp1[3*D_BYTES+7:3*D_BYTES],rd_data_tmp1[2*D_BYTES+7 : 2*D_BYTES],
			   rd_data_tmp1[D_BYTES+7:D_BYTES], rd_data_tmp1[7:0],
			   rd_data_tmp0[3*D_BYTES+7:3*D_BYTES],rd_data_tmp0[2*D_BYTES+7 : 2*D_BYTES],
			   rd_data_tmp0[D_BYTES+7:D_BYTES], rd_data_tmp0[7:0]};

		end
	endtask // ReadData

	task ReadWS;
		input [9:0] line_idx;
		output [9:0] trd_data;

                reg [13:0] wstsk_rd_data;
      
		begin

		wsram.Read(line_idx[TAG_DEPTH-1:0], wstsk_rd_data[WS_WIDTH-1:0]);
		if (WS_WIDTH == 14)
		  trd_data[9:0] = {wstsk_rd_data[12], wstsk_rd_data[10], wstsk_rd_data[8], wstsk_rd_data[6:0]};
		else if(WS_WIDTH == 10)
		  trd_data[9:0] = wstsk_rd_data[9:0];
		else if(WS_WIDTH == 9)
		  trd_data[9:0] = {1'b0,wstsk_rd_data[7], wstsk_rd_data[5], wstsk_rd_data[3],
				  wstsk_rd_data[2],2'b0,wstsk_rd_data[1:0],1'b0};
		else if(WS_WIDTH == 6)
		  trd_data[9:0] = {1'b0,wstsk_rd_data[5:3],wstsk_rd_data[2],2'b0,wstsk_rd_data[1:0],1'b0};
		else if(WS_WIDTH == 5)
		  trd_data[9:0] = {2'b0,wstsk_rd_data[3], wstsk_rd_data[1], 3'b0,wstsk_rd_data[0],2'b0};
		else if(WS_WIDTH == 3)
		  trd_data[9:0] = {2'b0,wstsk_rd_data[2:1],3'b0,wstsk_rd_data[0],2'b0};
		else			// 1-way with or without parity, bit 0 is always dirty bit.
		  trd_data[9:0] = {3'b0,wstsk_rd_data[0],6'b0};

		end

	endtask // ReadWS

	task WriteWS;
		input [9:0] line_idx;
		input [1:0] WordIdx;
		input [(M14K_MAX_DC_WS-1):0] twr_data;

		begin
		wsram.Write(line_idx[TAG_DEPTH-1:0], WordIdx, twr_data[(M14K_MAX_DC_WS-1):0]);
		end
	endtask // ReadWS

	task WriteData;
		input [11:0] line_idx;
		input [1:0] WordIdx;
		input [31:0] twr_data;

		begin
		dataram.Write(line_idx[DATA_DEPTH-1:0], WordIdx, twr_data);
		end
	endtask // WriteData

	task WriteTag;
		input [9:0] line_idx;
		input [1:0] WordIdx;
		input [31:0] twr_data;

		begin
		tagram.Write(line_idx[TAG_DEPTH-1:0], WordIdx, twr_data);
		end
	endtask // WriteTag

`endif
//VCS coverage on  
`endif 
//
	
endmodule // dcache

