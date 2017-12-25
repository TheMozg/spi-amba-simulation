// mipsfpga_sys.v
//
// This module is an add-on to the MIPS core, m14k_top. It instantiates // the MIPS core (m14k_top) and an AHB module of memories and I/Os on 
// the AHB-Lite bus. It also taps out the interface signals and 
// initializes signals required by the core.

`include "m14k_const.vh"

module mipsfpga_sys(input         SI_Reset_N,
                    input         SI_ClkIn,
                    output [31:0] HADDR,
                    output [31:0] HRDATA,
                    output [31:0] HWDATA,
                    output        HWRITE,
                    input         EJ_TRST_N_probe,
                    input         EJ_TDI,
                    output        EJ_TDO,
                    input         EJ_TMS,
                    input         EJ_TCK,
                    input         SI_ColdReset_N,
                    input         EJ_DINT,
                    input  [17:0] IO_Switch,
                    input  [ 4:0] IO_PB,
                    output [17:0] IO_LEDR,
                    output [ 8:0] IO_LEDG);



    
	wire           HREADY;         //AHB: Indicate the previous transfer is complete
	wire           HRESP;          //AHB: 0 is OKAY, 1 is ERROR
	wire 		SI_AHBStb;     //AHB: Signal indicating phase and frequency relationship between clk and hclk. 
	wire          HCLK;           //AHB: The bus clock times all bus transfer.
	wire          HRESETn;        //AHB: The bus reset signal is active LOW and resets the system and the bus.
	wire [2:0]    HBURST;         //AHB: Burst type; Only Two types:
                                                //                      3'b000  ---     Single; 3'b10  --- 4-beat Wrapping;
	wire [3:0]    HPROT;          //AHB: The single indicate the transfer type; Tie to 4'b0011, no significant meaning;
	wire          HMASTLOCK;      //AHB: Indicates the current transfer is part of a locked sequence; Tie to 0.
	wire [2:0]    HSIZE;          //AHB: Indicates the size of transfer; Only Three types:
                                                //              3'b000 --- Byte; 3'b001 --- Halfword; 3'b010 --- Word;
	wire  [1:0]  HTRANS;          //AHB: Indicates the transfer type; Three Types
                                                // 2'b00 --- IDLE, 2'b10 --- NONSEQUENTIAL, 2'b11 --- SEQUENTIAL.


// System Interface Signals
	wire		SI_Endian;	// Base endianess: 1=big
	wire [7:0]     SI_Int;         // Ext. Interrupt pins


	wire		SI_NMI;         // Non-maskable interrupt
	wire		SI_Reset;       // greset
	wire		SI_ColdReset;
	wire [1:0]     SI_MergeMode;	// SI_MergeMode[0] not used in this design
					// Merging algorithm: 
					// 00- No sub-word store merging
	                                // X1- Reserved
	                                // 10- Full merging - swiss cheese ok
					// Bus Mode
					// 00- Full ECi - swiss cheese, tribytes
					// 01- Naturally aligned B,H,W's only 	
					// 1X- Reserved


	wire [9:0]	SI_CPUNum;	// EBase CPU number
	wire [2:0]	SI_IPTI;	// TimerInt connection
	wire		SI_EICPresent;	// External Interrupt cpntroller present
	wire [5:0]	SI_EICVector;	// Vector number for EIC interrupt


	wire [17:1]	SI_Offset;


	wire [3:0]	SI_EISS;	// Shadow set, comes with the requested interrupt

	wire           SI_BootExcISAMode;



	wire [3:0]     SI_SRSDisable;  // Disable banks of shadow sets
	wire		SI_TraceDisable; // Disables trace hardware
	
	wire		SI_ClkOut;	// External bus reference clock
	wire 		SI_ERL;         // Error level pin
	wire 		SI_EXL;         // Exception level pin
	wire		SI_NMITaken;	// NMI pinned out
	wire		SI_NESTERL;	// nested error level pinned out
	wire		SI_NESTEXL;	// nested exception level pinned out
	wire 		SI_RP;          // Reduce power pin
	wire 		SI_Sleep;       // Processor is in sleep mode
	wire		SI_TimerInt;    // count==compare interrupt


	wire [1:0]	SI_SWInt;	// Software interrupt requests to external interrupt controller
	wire		SI_IAck;	// Interrupt Acknowledge
	wire [7:0]    SI_IPL;         // Current IPL, contains information of which int SI_IACK ack.
	wire [5:0] 	SI_IVN;         // Cuurent IVN, contains information of which int SI_IAck ack.
	wire [17:1] 	SI_ION;         // Cuurent ION, contains information of which int SI_IAck ack.


	wire [7:0]    SI_Ibs;         // Instruction break status
	wire [3:0]    SI_Dbs;         // Data break status

	// Performance monitoring signals
        wire          PM_InstnComplete;

	/* Scan I/O's */
	wire		gscanmode;
	wire		gscanenable;
	wire [`M14K_NUM_SCAN_CHAIN-1:0] gscanin;
	wire [`M14K_NUM_SCAN_CHAIN-1:0] gscanout;        
        
	wire 		gscanramwr;
	wire 		gmbinvoke;
	wire		gmbdone;	// Asserted to indicate that all mem-BIST test is done
	wire		gmbddfail;  	// Asserted to indicate that D$ date test failed
	wire		gmbtdfail;  	// Asserted to indicate that D$ tag test failed
	wire		gmbwdfail;  	// Asserted to indicate that D$ WS test failed
	wire		gmbspfail;  	// Asserted to indicate that D$ date test failed
	wire		gmbdifail;  	// Asserted to indicate that I$ date test failed
	wire		gmbtifail;  	// Asserted to indicate that I$tag test failed
	wire		gmbwifail;  	// Asserted to indicate that I$WS test failed
	wire		gmbispfail;  	// Asserted to indicate that D$ date test failed
	wire	[7:0]	gmb_ic_algorithm; // Alogrithm selection for I$ BIST controller.
	wire	[7:0]	gmb_dc_algorithm; // Alogrithm selection for D$ BIST controller.
	wire	[7:0]	gmb_isp_algorithm; // Alogrithm selection for ISPRAM BIST controller.
	wire	[7:0]	gmb_sp_algorithm; // Alogrithm selection for DSPRAM BIST controller.

	/* User defined Bist I/O's */
	wire  [`M14K_TOP_BIST_IN-1:0]	BistIn;
	wire [`M14K_TOP_BIST_OUT-1:0]	BistOut;

	/* EJTAG I/O's */
	wire 		EJ_TDOzstate;
 	wire          EJ_ECREjtagBrk;
	wire [10:0] 	EJ_ManufID;
	wire [15:0] 	EJ_PartNumber;
	wire [3:0] 	EJ_Version;
	wire		EJ_DINTsup;
	wire		EJ_DisableProbeDebug;
	wire		EJ_PerRst;
	wire		EJ_PrRst;
	wire		EJ_SRstE;
	wire 		EJ_DebugM;	// Indication that we are in debug mode

	// TCB PIB signals
	wire [2:0]	TC_ClockRatio;  	// User's clock ratio selection.
	wire		TC_Valid;             	// Data valid indicator.  Not used in this design.
	wire [63:0]	TC_Data;       		// Data from TCB.
	wire		TC_Stall;             	// Stall request.  Not used in this design.
	wire           TC_PibPresent;          // PIB is present   
  


// Impl specific IOs to cpu external modules
	wire  [`M14K_UDI_EXT_TOUDI_WIDTH-1:0] UDI_toudi; // External input to UDI module
	wire  [`M14K_UDI_EXT_FROMUDI_WIDTH-1:0] UDI_fromudi; // Output from UDI module to external system    

	wire [`M14K_CP2_EXT_TOCP2_WIDTH-1:0]   CP2_tocp2; // External input to COP2
	wire [`M14K_CP2_EXT_FROMCP2_WIDTH-1:0] CP2_fromcp2; // External output from COP2

	wire [`M14K_ISP_EXT_TOISP_WIDTH-1:0]    ISP_toisp;  // External input ISPRAM
	wire [`M14K_ISP_EXT_FROMISP_WIDTH-1:0] ISP_fromisp; // External output from ISPRAM


	wire [`M14K_DSP_EXT_TODSP_WIDTH-1:0]    DSP_todsp;  // External input DSPRAM
	wire [`M14K_DSP_EXT_FROMDSP_WIDTH-1:0] DSP_fromdsp; // External output from DSPRAM

	wire [2:0]  SI_IPFDCI;       // FDC connection
	wire       SI_FDCInt;      // FDC receive FIFO full interrupt

	wire [2:0]  SI_IPPCI;       // PCI connection
	wire       SI_PCInt;       // PCI receive full interrupt

    
      wire trst_n, EJ_TRST_N;    // Reset core at EJTAG initialization

    m14k_top top (
			HRDATA,
			HREADY,
			HRESP,
			SI_AHBStb,
			HCLK,
			HRESETn,
			HADDR,
			HBURST,
			HPROT,
			HMASTLOCK,
			HSIZE,
			HTRANS,
			HWRITE,
			HWDATA,
			SI_ClkIn,
			SI_ColdReset,
			SI_Endian,
			SI_Int,
			SI_NMI,
			SI_Reset,
			SI_MergeMode,
			SI_CPUNum,
			SI_IPTI,
			SI_EICPresent,
			SI_EICVector,
			SI_Offset,
			SI_EISS,
			SI_BootExcISAMode,
			SI_SRSDisable,
			SI_TraceDisable,
			SI_ClkOut,
			SI_ERL,
			SI_EXL,
			SI_NMITaken,
			SI_NESTERL,
			SI_NESTEXL,
			SI_RP,
			SI_Sleep,
			SI_TimerInt,
			SI_SWInt,
			SI_IAck,
			SI_IPL,
			SI_IVN,
			SI_ION,
			SI_Ibs,
			SI_Dbs,
			PM_InstnComplete,
			gscanmode,
			gscanenable,
			gscanin,
			gscanout,
			gscanramwr,
			gmbinvoke,
			gmbdone,
			gmbddfail,
			gmbtdfail,
			gmbwdfail,
			gmbspfail,
			gmbdifail,
			gmbtifail,
			gmbwifail,
			gmbispfail,
			gmb_ic_algorithm,
			gmb_dc_algorithm,
			gmb_isp_algorithm,
			gmb_sp_algorithm,
			BistIn,
			BistOut,
			EJ_TCK,
			EJ_TDO,
			EJ_TDI,
			EJ_TMS,
			EJ_TRST_N,
			EJ_TDOzstate,
			EJ_ECREjtagBrk,
			EJ_ManufID,
			EJ_PartNumber,
			EJ_Version,
			EJ_DINTsup,
			EJ_DINT,
			EJ_DisableProbeDebug,
			EJ_PerRst,
			EJ_PrRst,
			EJ_SRstE,
			EJ_DebugM,
			TC_ClockRatio,
			TC_Valid,
			TC_Data,
			TC_Stall,
			TC_PibPresent,
			UDI_toudi,
			UDI_fromudi,
			CP2_tocp2,
			CP2_fromcp2,
			ISP_toisp,
			ISP_fromisp,
			DSP_todsp,
			DSP_fromdsp,
			SI_IPFDCI,
			SI_FDCInt,
			SI_IPPCI,
			SI_PCInt);


// AHB module that sits on AHB-Lite bus

    mipsfpga_ahb mipsfpga_ahb(HCLK, HRESETn, HADDR, HBURST, HMASTLOCK, HPROT, HSIZE, HTRANS, HWDATA, HWRITE, HRDATA, HREADY, HRESP, SI_Endian, IO_Switch, IO_PB, IO_LEDR, IO_LEDG);

// Module for hardware reset of EJTAG just after FPGA configuration
// It pulses EJ_TRST_N low for 16 clock cycles.
      ejtag_reset ejtag_reset(.clk(SI_ClkIn), .trst_n(trst_n));

      assign EJ_TRST_N = trst_n & EJ_TRST_N_probe;


    	assign SI_ColdReset = ~SI_ColdReset_N;
    	assign SI_Reset = ~SI_Reset_N;

    // the following signals need to be tied to something
    	assign SI_NMI = 0;
    	assign SI_EICPresent = 0;
    	assign SI_EICVector = 0;
      assign SI_EISS = 0;
	assign SI_Int = 0;         // Ext. Interrupt pins
	assign SI_Offset = 0;
	assign SI_IPTI = 0;	// TimerInt connection
	assign SI_CPUNum = 0;	// EBase CPU number
	assign SI_Endian = 0;	// Base endianess: 1=big
	assign SI_MergeMode = 0;	
	assign SI_SRSDisable = 4'b1111;  // Disable banks of shadow sets
	assign SI_TraceDisable = 1; // Disables trace hardware
	assign SI_IPFDCI = 0;       // FDC connection
	assign SI_IPPCI = 0;       // PCI connection
	assign SI_AHBStb = 1;     //AHB: Signal indicating phase and frequency relationship between clk and hclk. 
	assign SI_BootExcISAMode = 0;  

	/* EJTAG I/O's */
	assign EJ_ManufID = 0;
	assign EJ_PartNumber = 0;
	assign EJ_Version = 0;
	assign EJ_DINTsup = 0;
	assign EJ_DisableProbeDebug = 0; // Must be 0 to enable EJTAG debug

	assign TC_Stall = 0;             	// Stall request.  Not used in this design.
	assign TC_PibPresent = 0;          // PIB is present   

	assign gscanmode = 0;
	assign gscanenable = 0;
	assign gmbinvoke = 0;
	assign gscanramwr = 0;
	
	assign gmb_ic_algorithm = 0;
	assign gmb_dc_algorithm = 0;
	assign gmb_isp_algorithm = 0;
	assign gmb_sp_algorithm = 0;

	assign UDI_toudi = 0; // External input to UDI module
	assign CP2_tocp2 = 0; // External input to COP2
	assign ISP_toisp = 0;  // External input ISPRAM
	assign DSP_todsp = 0;  // External input DSPRAM

endmodule
