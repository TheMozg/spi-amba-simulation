`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// SPI controllers testbench
//////////////////////////////////////////////////////////////////////////////////

module spi_drivers_tb(
    );
    
    localparam CLK_HALFPERIOD = 50;
    
    reg         clk, rst;
    
    reg         m_start;
    reg   [7:0] m_data_in;
    wire        m_ready;
    wire  [7:0] m_data_out;
    
    reg   [7:0] s_data_in;
    wire        s_ready;
    wire  [7:0] s_data_out;
    
    wire        spi_miso;
    wire        spi_mosi;
    wire        spi_sclk;
    wire        spi_cs;
    
    spi_master_driver dut_m(
        .clk_i(clk),
        .rst_i(rst),
        
        .start_i(m_start),
        .data_in_bi(m_data_in),
        .ready_o(m_ready),
        .data_out_bo(m_data_out),
        
        .spi_miso_i(spi_miso),
        .spi_mosi_o(spi_mosi),
        .spi_sclk_o(spi_sclk),
        .spi_cs_o(spi_cs)
    );
    
    spi_slave_driver dut_s(
        .clk_i(clk),
        .rst_i(rst),
        
        .data_in_bi(s_data_in),
        .ready_o(s_ready),
        .data_out_bo(s_data_out),
        
        .spi_miso_o(spi_miso),
        .spi_mosi_i(spi_mosi),
        .spi_sclk_i(spi_sclk),
        .spi_cs_i(spi_cs)
    );
    
    always #(CLK_HALFPERIOD) clk = !clk;
    
    initial begin
        clk = 0;
        rst = 1;
        
        m_start = 0;
        m_data_in = 0;
        s_data_in = 0;
        
        //
        
        #500;
        rst = 0;
        
        #500;
        m_data_in = 8'h5A;
        s_data_in = 8'h69;
        m_start = 1;
        
        #200;
        m_start = 0;
    end
    
endmodule
