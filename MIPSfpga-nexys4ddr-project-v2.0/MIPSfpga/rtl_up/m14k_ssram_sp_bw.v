//
//	ssram_sp_bw
//
//	This module represents a single ported, byte writable,
//	synchronous SRAM block.
//	The read port can be wider than the write port (power
//	of 2 multiple).
//		
//	$Id: \$
//	mips_repository_id: m14k_ssram_sp_bw.v, v 1.2 
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


// Comments for verilint...Some of this module is encapsulated in synopsys translate
//  directives, so need to disable verilint unused variable warnings
//verilint 175 off   // Unused parameter
//verilint 240 off   // Unused input
//verilint 241 off   // Output never gets set

`include "m14k_const.vh"
module m14k_ssram_sp_bw (	clk, line_idx, wr_mask, rd_str, wr_str, wr_data, rd_data);
	// synopsys template

	// Parameters expected to be overriden per instance
	// Default to 8KB 32bit write word, 4 word read line
	parameter	BYTES = 64; // 8 * 1024;
	parameter 	BITS_PER_BYTE = 8;	// BYTES are write-selectable
	parameter 	BYTES_PER_WORD = 4;	// Word is write unit
	parameter 	WordsPerLine = 4;	// Line is read unit
	parameter 	LIdxSize = 2; //9;

	// Computed parameters
	parameter	BitsPerWord = BITS_PER_BYTE * BYTES_PER_WORD;
	parameter	WORD_WIDTH = BITS_PER_BYTE * BYTES_PER_WORD;
	parameter	LINE_WIDTH = WORD_WIDTH * WordsPerLine;
	parameter 	BYTES_PER_LINE = BYTES_PER_WORD * WordsPerLine;
	parameter	Depth = BYTES / BYTES_PER_WORD / WordsPerLine;
	//parameter	LIdxSize = log2(Depth);

	/* Inputs */
	input 		           clk;		// Clock
	input [LIdxSize-1:0] 	   line_idx;	// Read Array Index
	input [BYTES_PER_LINE-1:0]   wr_mask;	// Write Byte Mask
	input 			   rd_str;		// Read Strobe
	input 			   wr_str;	        // Write Strobe
	input [WORD_WIDTH-1:0] 	   wr_data;		// Data for Tag Write

	/* Outputs */
	output [LINE_WIDTH-1:0] 	   rd_data;		// output from read


	 `ifdef MIPS_SIMULATION 
 //VCS coverage off 
	//

	/* Array Storage */
	reg [LINE_WIDTH-1:0]	Array [Depth-1:0];
	
	/* Read Port */
	reg [LINE_WIDTH-1:0] 	rd_data;
	
	/* Create Static Byte Mask, used by write code */
	reg [LINE_WIDTH-1:0]	WrByteMask;
	initial
		WrByteMask = (1<<BITS_PER_BYTE) - 1;

	/* Write Behavior */
	reg [LINE_WIDTH-1:0]	WrReadReg;	// Temp register for RMW
	reg [LINE_WIDTH-1:0]	WrMask;		// Temp register for RMW
	integer			i;		// temp variable


always @(posedge clk)
	begin
// Read
// New data is available from clock after rd_str until the
// next rd_str or wr_str.  If either strobe is x, x out the
// value.
// Data is x'ed out on wr_str to support various RAM behavior
// on writes
	case ({rd_str, wr_str})
		2'b00: ;                                        // Hold last value if idle
		2'b10: rd_data <= #`M14K_FDELAY Array[line_idx];       // Update on a read
		default: rd_data <= #`M14K_FDELAY {LINE_WIDTH{1'bx}};     // x out on writes or unknown strobes
	endcase

// Write
// Check for x-conditions and invalidate either this cache line or the entire array
// Cases:  

// 1)  x on Index while wr_str and wr_mask are either 1 or x - x-out entire array
// 2)  x on Write Strobe and wr_mask is 1 or x - x-out this cache line
// 3)  Write Strobe is 1 and wr_mask is x - x-out this cache line

// Mips testbench does not assert reset at time 0, so these conditions will be 
// met at the beginning of the simulation.  As a hack to quiet the simulation 
// warnings, these messages are not displayed until the part has seen the first
// ColdReset for >5 clocks as indicated by the AssertOK signal		
// Additionally, to preserve the 'magic' cache initialization, the cache is
// not flushed

// X - case 1		
	if (((line_idx ^ line_idx) !== {LIdxSize{1'b0}}) &&
	    ((wr_str === 1'bx) || wr_str) &&
	    (((|(wr_mask)) === 1'bx) || wr_mask))
		begin
`ifdef MIPS_WRAPPER_TB
`else  // wrapper tb can't handle reference to core tb
		if (`M14K_SRAM_ASSERTOK)
			begin
			if(`M14K_SRAM_DISPLAY.dispEn) 
				begin	
				$display("Inst:%0d - Warning:  Cache Index unknown while doing cache write",`M14K_SRAM_DISPLAY.Inst);
				$display("Inst:%0d - Invalidating cache array",`M14K_SRAM_DISPLAY.Inst);
				$display("Inst:%0d - Instance: %m   Time: %t", `M14K_SRAM_DISPLAY.Inst,$time);
				$display("Inst:%0d - line_idx: %h   wr_str: %b  wr_mask: %h", 
					 `M14K_SRAM_DISPLAY.Inst,line_idx, wr_str, wr_mask);
				$display();
				end // if (`M14K_SRAM_DISPLAY.dispEn)
			`M14K_SRAM_DISPLAY.Halt(`M14K_WARNING);
			for(i=0; i<Depth; i=i+1)
				Array[i] <= {LINE_WIDTH{1'bx}};
			end // if (m14k_top.core.biu.AssertOK)
`endif
		end // if (((line_idx ^ line_idx) !== {LIdxSize{1'b0}}) &&...

// X - case 2
	else if ((wr_str === 1'bx) && 
		 (((|(wr_mask)) === 1'bx) || wr_mask))
		begin
`ifdef MIPS_WRAPPER_TB
`else  // wrapper tb can't handle reference to core tb
		if (`M14K_SRAM_ASSERTOK)
			begin
			if(`M14K_SRAM_DISPLAY.dispEn) 
				begin
				$display("Inst:%0d - Warning:  Cache write strobe unknown",`M14K_SRAM_DISPLAY.Inst);
				$display("Inst:%0d - Invalidating Cache line",`M14K_SRAM_DISPLAY.Inst);
				$display("Inst:%0d - Instance: %m   Time: %t", `M14K_SRAM_DISPLAY.Inst, $time);
				$display("Inst:%0d - line_idx: %h   wr_str: %b  wr_mask: %h", 
					 `M14K_SRAM_DISPLAY.Inst, line_idx, wr_str, wr_mask);
				$display();
				end // if (`M14K_SRAM_DISPLAY.dispEn)
			`M14K_SRAM_DISPLAY.Halt(`M14K_WARNING);
			Array[line_idx] <= {LINE_WIDTH{1'bx}};
			end // if (m14k_top.core.biu.AssertOK)
`endif
		end // if ((wr_str === 1'bx) &&...
	   
	   // X - case 3
	else if ((wr_str === 1'b1) && ((|wr_mask) === 1'bx))
		begin		// 
`ifdef MIPS_WRAPPER_TB
`else  // wrapper tb can't handle reference to core tb
		if (`M14K_SRAM_ASSERTOK)
			begin
			if(`M14K_SRAM_DISPLAY.dispEn) 
				begin
				$display("Inst:%0d - Warning:  Cache Write Mask unknown",`M14K_SRAM_DISPLAY.Inst);
				$display("Inst:%0d - Invalidating cache line",`M14K_SRAM_DISPLAY.Inst);// 
				$display("Inst:%0d - Instance: %m   Time: %t", `M14K_SRAM_DISPLAY.Inst,$time);
				$display("Inst:%0d - line_idx: %h   wr_str: %b  wr_mask: %h", 
					 `M14K_SRAM_DISPLAY.Inst, line_idx, wr_str, wr_mask);
				$display();//
				end // if (`M14K_SRAM_DISPLAY.dispEn)
			`M14K_SRAM_DISPLAY.Halt(`M14K_WARNING);
			Array[line_idx] <= {LINE_WIDTH{1'bx}};
			end // if (m14k_top.core.biu.AssertOK)
`endif
		end // if ((wr_str === 1'b1) && ((|wr_mask) === 1'bx))
	   
// Actual write		
	else if (wr_str === 1'b1)
		begin
		WrReadReg = Array[line_idx];
		WrMask=0;
		for(i=0; i<BYTES_PER_LINE; i=i+1)
			if(wr_mask[i])
				WrMask = WrMask | (WrByteMask << (BITS_PER_BYTE * i));
		Array[line_idx] <= #`M14K_FDELAY WrReadReg & ~WrMask | {WordsPerLine{wr_data}} & WrMask;
		end
	end // always @ (posedge clk)
	
	task Write;
		input [LIdxSize-1:0]	line_idx;	// Read Array Index
		input [1:0]		WordIdx;	// Write Word Index
		input [WORD_WIDTH-1:0]	wr_data;		// Data for Tag Write

		begin
		WrReadReg = Array[line_idx];
		WrMask = 0;
		for (i = 0; i < BYTES_PER_WORD; i = i + 1)
			if (1)
				WrMask = WrMask | (WrByteMask << (BitsPerWord * WordIdx + BITS_PER_BYTE * i));
		Array[line_idx] = WrReadReg & ~WrMask | WrMask & (wr_data << (BitsPerWord * WordIdx));
		end
	endtask // Write

	task Read;
		input [LIdxSize-1:0] line_idx;
		output [LINE_WIDTH-1:0] rd_data;

		begin
		rd_data = Array[line_idx];
		end
	endtask
	  //VCS coverage on  
 `endif 
	// 
endmodule // ssram_sp_bw

