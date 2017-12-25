// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//      Description: m14k_siu 
//           system interface unit
//      
//      $Id: \$
//      mips_repository_id: m14k_siu.mv, v 1.18 
//

//      mips_start_of_legal_notice
//      **********************************************************************
//      Unpublished work (c) MIPS Technologies, Inc.  All rights reserved. 
//      Unpublished rights reserved under the copyright laws of the United
//      States of America and other countries.
//      
//      MIPS TECHNOLOGIES PROPRIETARY / RESTRICTED CONFIDENTIAL - HEIGHTENED
//      STANDARD OF CARE REQUIRED AS PER CONTRACT
//      
//      This code is confidential and proprietary to MIPS Technologies, Inc.
//      ("MIPS Technologies") and may be disclosed only as permitted in
//      writing by MIPS Technologies.  Any copying, reproducing, modifying,
//      use or disclosure of this code (in whole or in part) that is not
//      expressly permitted in writing by MIPS Technologies is strictly
//      prohibited.  At a minimum, this code is protected under trade secret,
//      unfair competition and copyright laws.	Violations thereof may result
//      in criminal penalties and fines.
//      
//      MIPS Technologies reserves the right to change the code to improve
//      function, design or otherwise.	MIPS Technologies does not assume any
//      liability arising out of the application or use of this code, or of
//      any error or omission in such code.  Any warranties, whether express,
//      statutory, implied or otherwise, including but not limited to the
//      implied warranties of merchantability or fitness for a particular
//      purpose, are excluded.	Except as expressly provided in any written
//      license agreement from MIPS Technologies, the furnishing of this code
//      does not give recipient any license to any intellectual property
//      rights, including any patent rights, that cover this code.
//      
//      This code shall not be exported, reexported, transferred, or released,
//      directly or indirectly, in violation of the law of any country or
//      international law, regulation, treaty, Executive Order, statute,
//      amendments or supplements thereto.  Should a conflict arise regarding
//      the export, reexport, transfer, or release of this code, the laws of
//      the United States of America shall be the governing law.
//      
//      This code may only be disclosed to the United States government
//      ("Government"), or to Government users, with prior written consent
//      from MIPS Technologies.  This code constitutes one or more of the
//      following: commercial computer software, commercial computer software
//      documentation or other commercial items.  If the user of this code, or
//      any related documentation of any kind, including related technical
//      data or manuals, is an agency, department, or other entity of the
//      Government, the use, duplication, reproduction, release, modification,
//      disclosure, or transfer of this code, or any related documentation of
//      any kind, is restricted in accordance with Federal Acquisition
//      Regulation 12.212 for civilian agencies and Defense Federal
//      Acquisition Regulation Supplement 227.7202 for military agencies.  The
//      use of this code by the Government is further restricted in accordance
//      with the terms of the license agreement(s) and/or applicable contract
//      terms and conditions covering this code from MIPS Technologies.
//      
//      
//      
//      **********************************************************************
//      mips_end_of_legal_notice
//      

`include "m14k_const.vh"
module m14k_siu(
	gclk,
	gfclk,
	gscanenable,
	SI_Int,
	SI_NMI,
	SI_Reset,
	SI_ColdReset,
	SI_Slip,
	SI_Endian,
	SI_CPUNum,
	SI_IPTI,
	SI_IPFDCI,
	SI_EICPresent,
	SI_IPPCI,
	SI_EICVector,
	SI_Offset,
	SI_EISS,
	SI_SRSDisable,
	SI_TraceDisable,
	SI_BootExcISAMode,
	SI_GInt,
	SI_GEICVector,
	SI_GOffset,
	SI_GEISS,
	SI_EICGID,
	cpz_goodnight,
	cpz_timerint,
	cpz_g_timerint,
	cpz_fdcint,
	cpz_cause_pci,
	cpz_g_cause_pci,
	cpz_rp,
	cpz_erl,
	cpz_exl,
	cpz_nmi,
	cpz_nest_erl,
	cpz_nest_exl,
	cpz_swint,
	cpz_iack,
	cpz_ipl,
	cpz_ivn,
	cpz_ion,
	cpz_g_swint,
	cpz_g_iack,
	cpz_g_ipl,
	cpz_g_ivn,
	cpz_g_ion,
	cpz_gid,
	brk_ibs_bs,
	brk_dbs_bs,
	SI_ClkOut,
	SI_TimerInt,
	SI_GTimerInt,
	SI_FDCInt,
	SI_PCInt,
	SI_GPCInt,
	SI_RP,
	SI_Sleep,
	SI_EXL,
	SI_ERL,
	SI_NESTERL,
	SI_NESTEXL,
	SI_NMITaken,
	SI_SWInt,
	SI_IAck,
	SI_IPL,
	SI_IVN,
	SI_ION,
	SI_GSWInt,
	SI_GIAck,
	SI_GIPL,
	SI_GIVN,
	SI_GION,
	SI_GID,
	SI_Ibs,
	SI_Dbs,
	siu_int,
	siu_eicvector,
	siu_offset,
	siu_nmi,
	greset,
	siu_coldreset,
	siu_slip,
	siu_bigend,
	siu_cpunum,
	siu_ipti,
	siu_ifdci,
	siu_ippci,
	siu_eicpresent,
	siu_eiss,
	siu_srsdisable,
	siu_tracedisable,
	siu_bootexcisamode,
	siu_g_int,
	siu_g_eicvector,
	siu_g_offset,
	siu_eicgid,
	siu_g_eiss);


// INPUTS 
   input gclk;            // Clock
   input gfclk;		// Free running clock
   input gscanenable;
	
   input [7:0] SI_Int;          // Ext. Interrupt pins

   input       SI_NMI;         // Non-maskable interrupt pin
   input       SI_Reset;       // warm/soft reset pin
   input       SI_ColdReset;   // cold reset pin
   input       SI_Slip;	// Inject security slip into pipeline
   input       SI_Endian;
   input [9:0]	SI_CPUNum;	// EBase CPU number
   input [2:0]	SI_IPTI;	// TimerInt connection
   input [2:0]  SI_IPFDCI;	// FDC connection
   input	SI_EICPresent;	// External Interrupt cpntroller present
   input [2:0]  SI_IPPCI;       // PC connection
   input [5:0]	SI_EICVector;	// Vector number for EIC interrupt

   input [17:1] SI_Offset;	// Vector offset for EIC interrupt

   input [3:0]	SI_EISS;	// Shadow set, comes with the requested interrupt
   input [3:0]  SI_SRSDisable;  // Disable banks of shadow sets

				// 000 - use all implemented register sets
				// 100 - only use 4 register sets
				// 110 - only use 2 register sets
				// 111 - only use 1 register set	
   input	SI_TraceDisable; // Disables trace hardware
   input        SI_BootExcISAMode;      // static set the ISA mode during interrupts, exceptions and boot
	
   input [7:0] SI_GInt;          // Ext. Interrupt pins
   input [5:0]	SI_GEICVector;	// Vector number for EIC interrupt
   input [17:1] SI_GOffset;	// Vector offset for EIC interrupt
   input [3:0]	SI_GEISS;	// Shadow set, comes with the requested interrupt
   input [7:0] SI_EICGID; 
   
   // Internal processor state signals made available at the pins	
   input       cpz_goodnight;	// Signal gclk module to shut down main clock
   input       cpz_timerint; // count==compare interrupt
   input       cpz_g_timerint; // count==compare interrupt
   input       cpz_fdcint;    // FDC receive FIFO full interrupt
   input       cpz_cause_pci;  // PC is full interrupt
   input       cpz_g_cause_pci;  // PC is full interrupt

   input       cpz_rp;             // Reduce Power bit 
   input       cpz_erl;            // Error Level
   input       cpz_exl;            // Exception Level   
   input       cpz_nmi;		// nmi taken
   input       cpz_nest_erl;	// nested error level
   input       cpz_nest_exl;	// nested exception level

   input [1:0]	cpz_swint;	// Software interrupt requests to external interrupt controller
   input	cpz_iack;	// Interrupt Acknowledge
   input [7:0]  cpz_ipl;        // Current IPL, contains information of which int SI_IAck ack.
   input [5:0]  cpz_ivn;        // Current IVN, contains information of which int SI_IACK ack.
   input [17:1] cpz_ion;        // Current ION, contains information of which int SI_IACK ack.
   input [1:0]	cpz_g_swint;	// Software interrupt requests to external interrupt controller
   input	cpz_g_iack;	// Interrupt Acknowledge
   input [7:0]  cpz_g_ipl;        // Current IPL, contains information of which int SI_IAck ack.
   input [5:0]  cpz_g_ivn;        // Current IVN, contains information of which int SI_IACK ack.
   input [17:1] cpz_g_ion;        // Current ION, contains information of which int SI_IACK ack.
   input [`M14K_GID] cpz_gid;

   input [7:0] brk_ibs_bs;      // Instruction break status
   input [3:0] brk_dbs_bs;      // Data break status

// OUTPUTS   

   // Outputs to External Bus
   output 	SI_ClkOut;	// External bus reference clock
   // Processor state made available at the core boundary
   output 	SI_TimerInt;	// count==compare interrupt
   output 	SI_GTimerInt;	// count==compare interrupt
   output       SI_FDCInt;	// FDC receive FIFO full interrupt
   output       SI_PCInt;
   output       SI_GPCInt;
   output 	SI_RP;          // Reduce Power pinned out
   output 	SI_Sleep;       // Processor is in sleep mode
   output 	SI_EXL;         // Exception Level pinned out
   output 	SI_ERL;         // Error Level pinned out   
   output       SI_NESTERL;	// nested error level pinned out
   output       SI_NESTEXL;	// nested exception level pinned out
   output       SI_NMITaken;    // nmi pinned out

   output [1:0]	SI_SWInt;	// Software interrupt requests to external interrupt controller
   output	SI_IAck;	// Interrupt Acknowledge
   output [7:0] SI_IPL;         // Cuurent IPL, contains information of which int SI_IAck ack.
   output [5:0] SI_IVN;         // Cuurent IVN, contains information of which int SI_IAck ack.
   output [17:1] SI_ION;        // Cuurent ION, contains information of which int SI_IAck ack.
   output [1:0]	SI_GSWInt;	// Software interrupt requests to external interrupt controller
   output	SI_GIAck;	// Interrupt Acknowledge
   output [7:0] SI_GIPL;         // Cuurent IPL, contains information of which int SI_IAck ack.
   output [5:0] SI_GIVN;         // Cuurent IVN, contains information of which int SI_IAck ack.
   output [17:1] SI_GION;        // Cuurent ION, contains information of which int SI_IAck ack.
   output [7:0] SI_GID; 

   output [7:0] SI_Ibs;         // Instruction break status
   output [3:0] SI_Dbs;         // Data break status
      
   output [7:0] siu_int;            // registered interrupt pins

   output [5:0] siu_eicvector;      // registered vector pins

   output [17:1] siu_offset;		// registered offset pins

   output 	siu_nmi;            // Non-maskable interrupt
   output 	greset;          // reset/coldreset signal
   output 	siu_coldreset;      // coldreset
   output 	siu_slip;	// External signal to inject security slip
   output 	siu_bigend;
   output [9:0]	siu_cpunum;	// EBase CPU number
   output [2:0]	siu_ipti;	// TimerInt connection
   output [2:0] siu_ifdci;      // FDCInt connection
   output [2:0] siu_ippci;      //PCInt connection
   output	siu_eicpresent;	// External Interrupt cpntroller present
   output [3:0]	siu_eiss;	// Shadow set, comes with the requested interrupt
   output [3:0] siu_srsdisable; // Disable banks of shadow sets

				// 000 - use all implemented register sets
				// 100 - only use 4 register sets
				// 110 - only use 2 register sets
				// 111 - only use 1 register set	
   output 	siu_tracedisable; // Disables trace hardware
   output       siu_bootexcisamode;     // external signal set isa mode for interrupt,exception,boot

   output [7:0] siu_g_int;            // registered interrupt pins

   output [5:0] siu_g_eicvector;      // registered vector pins

   output [17:1] siu_g_offset;		// registered offset pins

   output [`M14K_GID] siu_eicgid;

   output [3:0]	siu_g_eiss;	// Shadow set, comes with the requested interrupt

// BEGIN Wire declarations made by MVP
wire wmreset;
wire [2:0] /*[2:0]*/ siu_ippci;
wire SI_ClkOut;
wire siu_slip;
wire cdreset;
wire SI_ERL;
wire [3:0] /*[3:0]*/ siu_srsdisable;
wire SI_EXL;
wire [5:0] /*[5:0]*/ SI_GIVN;
wire siu_tracedisable;
wire SI_Sleep;
wire SI_NMITaken;
wire [1:0] /*[1:0]*/ SI_GSWInt;
wire [17:1] /*[17:1]*/ SI_ION;
wire SI_NESTERL;
wire SI_PCInt;
wire [17:1] /*[17:1]*/ SI_GION;
wire siu_bigend;
wire SI_GIAck;
wire SI_GTimerInt;
wire [5:0] /*[5:0]*/ SI_IVN;
wire [2:0] /*[2:0]*/ siu_ifdci;
wire [7:0] /*[7:0]*/ SI_Ibs;
wire siu_nmi;
wire SI_TimerInt;
wire siu_softreset;
wire siu_nmi_int;
wire [7:0] /*[7:0]*/ SI_IPL;
wire [`M14K_GID] /*[2:0]*/ si_gid_t1;
wire [1:0] /*[1:0]*/ SI_SWInt;
wire SI_NESTEXL;
wire [7:0] /*[7:0]*/ SI_GID;
wire SI_RP;
wire [3:0] /*[3:0]*/ SI_Dbs;
wire greset;
wire SI_IAck;
wire siu_bootexcisamode;
wire [7:0] /*[7:0]*/ SI_GIPL;
wire siu_eicpresent;
wire SI_FDCInt;
wire [2:0] /*[2:0]*/ siu_ipti;
wire SI_GPCInt;
wire [9:0] /*[9:0]*/ siu_cpunum;
wire siu_coldreset;
// END Wire declarations made by MVP


//
wire [7:`M14K_GIDWIDTH] dummy_zero;
parameter dummy_width = 8 - `M14K_GIDWIDTH;
assign dummy_zero = {(dummy_width){1'b0}};
//

   // synchronize NMI	
   mvp_register #(1) _siu_nmi_int(siu_nmi_int, gfclk, SI_NMI);
   mvp_register #(1) _siu_nmi(siu_nmi, gfclk, siu_nmi_int);

   wire [7:0] siu_int;

   wire [5:0] siu_eicvector;

  wire [17:1] siu_offset; // Vector offset for EIC interrupt

   wire [3:0] siu_eiss;

   wire [7:0] siu_g_int;

   wire [5:0] siu_g_eicvector;

  wire [17:1] siu_g_offset; // Vector offset for EIC interrupt

   wire [3:0] siu_g_eiss;

   wire [`M14K_GID] siu_eicgid;

   `M14K_SIU_INTSYNC intsync (
				.gfclk( gfclk),
				.SI_Int(SI_Int),
				.SI_EISS(SI_EISS),
				.SI_EICVector(SI_EICVector),
				.SI_GInt(SI_GInt),
				.SI_GEISS(SI_GEISS),
				.SI_GEICVector(SI_GEICVector),
				.SI_EICGID(SI_EICGID),
				.siu_int(siu_int),
				.siu_eiss(siu_eiss),
				.siu_eicvector(siu_eicvector),
				.siu_g_int(siu_g_int),
				.siu_g_eiss(siu_g_eiss),
				.siu_g_eicvector(siu_g_eicvector),
				.siu_eicgid(siu_eicgid),
				.SI_Offset(SI_Offset), // Vector offset for EIC interrupt
				.SI_GOffset(SI_GOffset), // Vector offset for EIC interrupt
				.siu_offset(siu_offset), // Vector offset for EIC interrupt
				.siu_g_offset(siu_g_offset) 
			    );

   assign siu_slip = SI_Slip;	// Signal is registered in cpz

      mvp_ucregister_wide #(27) _siu_eicpresent_siu_bigend_siu_cpunum_9_0_siu_ipti_2_0_siu_ippci_2_0_siu_ifdci_2_0_siu_tracedisable_siu_srsdisable_3_0_siu_bootexcisamode({siu_eicpresent,
       siu_bigend,
       siu_cpunum[9:0],
       siu_ipti[2:0],
       siu_ippci[2:0],
	 siu_ifdci[2:0],
       siu_tracedisable,
       siu_srsdisable[3:0],
       siu_bootexcisamode}, gscanenable, greset, gclk,
                                             {SI_EICPresent,
                                              SI_Endian,
                                              SI_CPUNum,
                                              SI_IPTI,
					      SI_IPPCI,
						SI_IPFDCI,
                                              SI_TraceDisable,
                                              SI_SRSDisable,
                                              SI_BootExcISAMode});

        mvp_register #(12) _SI_Ibs_7_0({SI_Ibs[7:0],
         SI_Dbs[3:0] },  gclk, {brk_ibs_bs[7:0],
                                         brk_dbs_bs[3:0]});
	
   // Since this is not just a bus clock, we don't want it to stop
   assign SI_ClkOut = gfclk;

   // Timer interrupt output
   // This needs to be gfclk so that it can wake us up	
   mvp_register #(1) _SI_TimerInt(SI_TimerInt, gfclk, cpz_timerint);
   mvp_register #(1) _SI_GTimerInt(SI_GTimerInt, gfclk, cpz_g_timerint);

   // FDC interrupt output
   mvp_register #(1) _SI_FDCInt(SI_FDCInt, gclk, cpz_fdcint);

   // PC Interrupt output
   mvp_register #(1) _SI_PCInt(SI_PCInt, gclk, cpz_cause_pci);
   mvp_register #(1) _SI_GPCInt(SI_GPCInt, gclk, cpz_g_cause_pci);

   // Software interrupt output
   mvp_register #(2) _SI_SWInt_1_0_(SI_SWInt[1:0], gclk, cpz_swint);
   mvp_register #(2) _SI_GSWInt_1_0_(SI_GSWInt[1:0], gclk, cpz_g_swint);

   // Low-power related outputs
   mvp_register #(1) _SI_ERL(SI_ERL, gclk, cpz_erl);
   mvp_register #(1) _SI_EXL(SI_EXL, gclk, cpz_exl);
   mvp_register #(1) _SI_NESTERL(SI_NESTERL, gclk, cpz_nest_erl);
   mvp_register #(1) _SI_NESTEXL(SI_NESTEXL, gclk, cpz_nest_exl);

   mvp_register #(1) _SI_Sleep(SI_Sleep, gfclk, cpz_goodnight);
   mvp_register #(1) _SI_RP(SI_RP, gclk, cpz_rp);   

   // NMI output
   mvp_register #(1) _SI_NMITaken(SI_NMITaken, gclk, cpz_nmi);

   // interrupt ack. and IPL outputs
   mvp_register #(1) _SI_IAck(SI_IAck, gclk, cpz_iack); 
   mvp_register #(8) _SI_IPL_7_0_(SI_IPL[7:0], gclk, cpz_ipl);
   mvp_register #(6) _SI_IVN_5_0_(SI_IVN[5:0], gclk, cpz_ivn);
   mvp_register #(17) _SI_ION_17_1_(SI_ION[17:1], gclk, cpz_ion);
   mvp_register #(1) _SI_GIAck(SI_GIAck, gclk, cpz_g_iack); 
   mvp_register #(8) _SI_GIPL_7_0_(SI_GIPL[7:0], gclk, cpz_g_ipl);
   mvp_register #(6) _SI_GIVN_5_0_(SI_GIVN[5:0], gclk, cpz_g_ivn);
   mvp_register #(17) _SI_GION_17_1_(SI_GION[17:1], gclk, cpz_g_ion);
   mvp_register #(3) _si_gid_t1_2_0_(si_gid_t1[`M14K_GID], gclk, cpz_gid);
   assign SI_GID [7:0] = {dummy_zero, si_gid_t1};
   

//
// greset chain
//
// greset is spec'ed as a minimum 5 clock external pulse
// such that we have reset our bus state machines by the time
// greset has gone away externally.  Thus we do not need to
// internally generate a wider pulse
	
   // synchronizer chain for reset
   mvp_register #(1) _cdreset(cdreset, gfclk, SI_ColdReset);
   mvp_register #(1) _wmreset(wmreset, gfclk, SI_Reset);

   mvp_register #(1) _siu_softreset(siu_softreset, gfclk, wmreset);
   mvp_register #(1) _siu_coldreset(siu_coldreset, gfclk, cdreset);       
   
   assign greset = siu_softreset || siu_coldreset;   
   

// Assertion checker.  Make sure that reset pulse is sufficiently wide
// Warn if the pulse is too wide (indicating that someone may have wrong polarity)
// Globally disable assertions until reset has been asserted

//VCS coverage off
// NOTE: Do not replace the following mvp escape with mvp assert as this assert code is needed for VMC model build
//
//verilint 528 off  // Variable set but not used.
   `ifdef MIPS_SIMULATION
   reg              AssertOK;
   reg [31:0]       ResetCount;
   initial begin
      AssertOK = 1'b0;
      ResetCount = 0;
   end
   always @(posedge `M14K_CORE.SI_ClkIn) begin
      if (greset) begin
         if (ResetCount == (`M14K_MIN_RESET - 1)) begin
            AssertOK <= 1'b1;
         end
         ResetCount <= ResetCount + 1;
      end else begin
         ResetCount <= 0;
      end
      
      if (greset & (ResetCount == `M14K_MAX_RESET)) begin
         if(`M14K_DISPLAY.dispEn) begin
            $display("Inst:%0d - %s",`M14K_DISPLAY.Inst,`M14K_WARN_IO_STR);
            $display("Inst:%0d - Assertion in module core: greset pulse longer than %0d clock cycles at time %0t", 
                     `M14K_DISPLAY.Inst,`M14K_MAX_RESET, $time);
         end // if (m14k_top.display.dispEn)
         `M14K_DISPLAY.Halt(`M14K_WARNING);
      end

      if (!greset && (ResetCount != 0) && (ResetCount < (`M14K_MIN_RESET))) begin
         if(`M14K_DISPLAY.dispEn) begin
            $display("Inst:%0d - %s",`M14K_DISPLAY.Inst,`M14K_FATAL_IO_STR);
            $display("Inst:%0d - Assertion in module core: greset pulse shorter than %d clock cycles at time %0t", 
                     `M14K_DISPLAY.Inst,`M14K_MIN_RESET, $time);
         end // if (m14k_top.display.dispEn)
         `M14K_DISPLAY.Halt(`M14K_FATAL);
      end
   end
   `endif // MIPS_SIMULATION
//verilint 528 on  // Variable set but not used.
//
//VCS coverage on

endmodule       // m14k_siu

