//
//	generic_dataram
//
//	This module is a generic sram wrapper. While instantiating
//      a simulation only ssram_sp_bw it can be used as a template
//      for an implementation specific sram wrapper.  
//		
//	$Id: \$
//	mips_repository_id: m14k_generic_dataram.v, v 1.6 
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

module m14k_generic_dataram (clk, line_idx, rd_mask, wr_mask, rd_str, wr_str, wr_data, bist_to, 
                        early_ce, rd_data, bist_from);
	// synopsys template

	// Parameters expected to be overriden per instance
	parameter	ASSOC = 2;		// Default to 2 Way Set Assoc
	parameter	WAYSIZE = 3;	// Default to 3KB Size per way
	parameter	BITS_PER_BYTE = 8;		// Minumum Write-selectable unit
	parameter	BIST_TO_WIDTH = 1;	// Bist input width
	parameter	BIST_FROM_WIDTH = 1;	// Bist output width

	// Cache specific calculated parameters
	parameter	DATA_SIZE = WAYSIZE * 1024 * ASSOC;
	parameter 	DATA_DEPTH = 8 + ((WAYSIZE==16) ? 4 :
					      (WAYSIZE==8) ? 3 :
					      (WAYSIZE==4) ? 2 : 
					      (WAYSIZE==2) ? 1 : 0 );

	// Cache specific parameters By definition
	parameter	BYTES = DATA_SIZE;		// Total bytes in Sram
	parameter	BYTES_PER_WORD = 4;		// Word size in write units
	parameter	WORDS_PER_LINE = ASSOC;	// Line is read unit
	parameter 	WORD_IDX_SIZE = 2;                  // Number of address bits to select word
	parameter	LINE_IDX_SIZE = DATA_DEPTH;	// Number of address bits needed

	// Computed parameters
	parameter	BITS_PER_WORD = BITS_PER_BYTE * BYTES_PER_WORD;
	parameter	WORD_WIDTH = BITS_PER_BYTE * BYTES_PER_WORD;
	parameter 	BYTES_PER_LINE = BYTES_PER_WORD * WORDS_PER_LINE;
	parameter	LINE_WIDTH = WORD_WIDTH * WORDS_PER_LINE;

	/* Inputs */
	input 					clk;		// Clock
	input [LINE_IDX_SIZE-1:0]		line_idx;	// Read/Write Array Index
	input [ASSOC-1:0]			rd_mask;	// Read Mask
	input [BYTES_PER_LINE-1:0]		wr_mask;	// Byte Write Mask

	input 					rd_str;		// Read Strobe
	input 					wr_str;	        // Write Strobe

	input [WORD_WIDTH-1:0] 			wr_data;		// Data for Write
	input [BIST_TO_WIDTH-1:0] 		bist_to;		// Bist input bus

        input                                   early_ce;

	/* Outputs */
	output [LINE_WIDTH-1:0] 			rd_data;		// Output from read
	output [BIST_FROM_WIDTH-1:0] 		bist_from;	// Bist output bus

	// workaround for verilint bug
	wire [4*WORD_WIDTH:0]			foo_mask;
	wire [4*WORD_WIDTH-1:0]			foo_pre;
	reg [4:0]				rd_mask_5;

	wire [LINE_WIDTH-1:0] 			foo;
	wire [LINE_WIDTH-1:0] 			rd_data = foo_mask[LINE_WIDTH-1:0];

	always@(posedge clk)
	begin
		rd_mask_5 <= {{5-WORDS_PER_LINE{1'b0}}, rd_mask};
	end

	assign foo_pre[4*WORD_WIDTH-1:0] = foo[LINE_WIDTH-1:0];
	assign foo_mask[WORD_WIDTH-1:0] = foo_pre[WORD_WIDTH-1:0] & {WORD_WIDTH{rd_mask_5[0]}};
	assign foo_mask[2*WORD_WIDTH-1:WORD_WIDTH] = foo_pre[2*WORD_WIDTH-1:WORD_WIDTH] & {WORD_WIDTH{rd_mask_5[1]}};
	assign foo_mask[3*WORD_WIDTH-1:2*WORD_WIDTH] = foo_pre[3*WORD_WIDTH-1:2*WORD_WIDTH] & {WORD_WIDTH{rd_mask_5[2]}};

	assign foo_mask[4*WORD_WIDTH-1:3*WORD_WIDTH] = foo_pre[4*WORD_WIDTH-1:3*WORD_WIDTH] & {WORD_WIDTH{rd_mask_5[3]}};

   //
   //  Ram Arrays
   //  Here the cache implementor should instatiate his/her own srams and possibly ram bist logic
   //
   m14k_ssram_sp_bw #(BYTES, BITS_PER_BYTE, BYTES_PER_WORD, WORDS_PER_LINE, LINE_IDX_SIZE) dataram 
     (
      .clk( clk ),
      .line_idx( line_idx ),
      .wr_mask( wr_mask ),
      .rd_str( rd_str ),
      .wr_str( wr_str ),
      .wr_data( wr_data ),
      .rd_data( foo )
      );

   // Drive bist output to static value...
   // It would really be connected if bist was present.
   wire [BIST_FROM_WIDTH-1:0] 			bist_from = {BIST_FROM_WIDTH{1'b0}};	

 `ifdef MIPS_SIMULATION 
 //VCS coverage off 
//

    reg InitCaches;
    initial begin
`ifdef MIPS_VMC_BUILD
      InitCaches = 1'b1;
`else
      InitCaches = 1'b0;
      InitCaches = $test$plusargs("InitCaches");
`endif
      #1;
      if (InitCaches == 1'b1) begin
        Init;
        $display ("%m: Magic Cache DATA RAM initialization @ %0t",$time);
      end
   end

   task Init;
      integer   i, j;

      begin
         for(i = 0; i < (BYTES / BYTES_PER_WORD); i = i + 1) begin
            for(j = 0; j < ASSOC; j = j + 1) begin
               dataram.Write(i, j, {WORD_WIDTH{1'b0}});
            end
         end
      end
   endtask // Init

	task Read;
		input [LINE_IDX_SIZE-1:0] line_idx;
		output [LINE_WIDTH-1:0] rd_data;
		
		begin
		dataram.Read(line_idx, rd_data);
		end
	endtask // Read
	
	task Write;
		input [LINE_IDX_SIZE-1:0] line_idx;
		input [WORD_IDX_SIZE-1:0] WordIdx;
		input [WORD_WIDTH-1:0] wr_data;
		
		begin
		dataram.Write(line_idx, WordIdx, wr_data);
		end
	endtask // Read
 //VCS coverage on  
 `endif 
//
	
 
endmodule 

