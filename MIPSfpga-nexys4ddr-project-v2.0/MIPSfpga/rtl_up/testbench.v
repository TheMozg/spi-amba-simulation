// testbench.v
// 31 May 2014
//
// Drive the mipsfpga_sys module for simulation testing

`timescale 100ps/1ps

module testbench;

    reg  SI_Reset_N, SI_ClkIn;
    wire [31:0] HADDR, HRDATA, HWDATA;
    wire        HWRITE;
    reg         EJ_TRST_N_probe, EJ_TDI; 
    wire        EJ_TDO;
    reg         SI_ColdReset_N;
    reg         EJ_TMS, EJ_TCK, EJ_DINT;
    wire [17:0] IO_Switch;
    wire [ 4:0] IO_PB;
    wire [17:0] IO_LEDR;
    wire [ 8:0] IO_LEDG;


    mipsfpga_sys sys(SI_Reset_N,
                 SI_ClkIn,
                 HADDR, HRDATA, HWDATA, HWRITE, 
                 EJ_TRST_N_probe, EJ_TDI, EJ_TDO, EJ_TMS, 
                 EJ_TCK, 
                 SI_ColdReset_N, 
                 EJ_DINT,
                 IO_Switch, IO_PB, IO_LEDR, IO_LEDG);

    initial
    begin
        SI_ClkIn = 0;
        EJ_TRST_N_probe = 0; EJ_TDI = 0; EJ_TMS = 0; EJ_TCK = 0; EJ_DINT = 0;
        SI_ColdReset_N = 1;

        forever
            #50 SI_ClkIn = ~ SI_ClkIn;
    end

    initial
    begin
        SI_Reset_N  <= 0;
        repeat (100)  @(posedge SI_ClkIn);
        SI_Reset_N  <= 1;
        repeat (1000) @(posedge SI_ClkIn);
        $stop;
    end

    initial
    begin
        $dumpvars;
        $timeformat (-9, 1, "ns", 10);
    end
    
endmodule


