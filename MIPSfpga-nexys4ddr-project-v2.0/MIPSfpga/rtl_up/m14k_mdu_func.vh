
//    MDU specific Function Definition File

// $Id: \$
// mips_repository_id: m14k_mdu_func.vh, v 1.2 

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

//Verilint 191 off Unused function

// Returns the age of the instruction in the current stage. The age is either 
// from the preceding pipe stage or from the current stage if stall is asserted.
function [1:0] m14k_mdu_stage_age;
input stall_xx;
input [1:0] new_age_a;
input [1:0] new_age_b;

  // Set age to 00 if stage is not alive 
  m14k_mdu_stage_age = stall_xx ? new_age_b[1:0] :
                                 new_age_a[1:0];

endfunction


// Returns the next age of an instruction based on the run_ex, run_ms, and 
// run_er signals.
function [1:0] m14k_mdu_instr_age;
input [1:0] current_age;
input run_ex;
input run_ms;
input run_er;

  m14k_mdu_instr_age = (current_age[1:0] == 2'b00) ?
                        (run_ex ? 2'b01 : 2'b00) :
                        ( (current_age[1:0] == 2'b01) ?
                            (run_ms ? 2'b10 : 2'b01) :
                            ( (current_age[1:0] == 2'b10) ? 
                                (run_er ? 2'b11 : 2'b10 ) :
                                2'b11
                            )
                        );
    
endfunction


// Returns 1'b1 if the age, run, and kill signals indicate that the result
// of an instruction be committed. Otherwise, the function returns 1'b0.
function m14k_mdu_commit;
input [1:0] age;
input run_er;
input kill_er;

  m14k_mdu_commit = age[1] && (age[0] || (run_er && !kill_er));

endfunction


// Returns 1 if instruction with the input age should be cancelled.
function m14k_mdu_nullify;
input [1:0] age;
input MDU_nullify_ex;
input MDU_nullify_ms;
input MDU_nullify_er;

  m14k_mdu_nullify = age[1] ?
                      (age[0] ? 1'b0 : MDU_nullify_er) :
                      (age[0] ? MDU_nullify_ms : MDU_nullify_ex);

endfunction

//Verilint 191 on Unused function




