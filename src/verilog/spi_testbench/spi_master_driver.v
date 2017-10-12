`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Simple SPI master controller with CPOL=0, CPHA=0
//////////////////////////////////////////////////////////////////////////////////

module spi_master_driver(
    input             clk_i,
    input             rst_i,
    
    // system interface
    input             start_i,     // signal to start transaction
    input       [7:0] data_in_bi,  // data that master will write to slave
    output reg        ready_o,     // transaction is not processed now
    output reg  [7:0] data_out_bo, // data recevied from slave in last transaction
    
    // SPI interface
    input             spi_miso_i,
    output reg        spi_mosi_o,
    output reg        spi_sclk_o,
    output reg        spi_cs_o
    );
    

    // SPI master controller logic
    
endmodule
