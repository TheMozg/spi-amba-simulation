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

    reg clk_div2;
    reg [2:0] counter;
    reg do_cold_start;
    localparam STATE_IDLE = 0;
    localparam STATE_BUSY = 1;
    
    reg   [2:0] state;
    always @(posedge clk_i) begin
        clk_div2 <= !clk_div2;
        if (clk_div2) begin
            spi_sclk_o <= !spi_sclk_o;
        end
        if (rst_i) begin
            clk_div2 <= 0;
            counter <= 0;
            ready_o <= 1;
            data_out_bo <= 0;
            spi_mosi_o <= 0; 
            spi_sclk_o <= 0;
            spi_cs_o <= 1;
            do_cold_start <= 0;
            state <= STATE_IDLE;
        end
        if (start_i && ready_o) begin
            do_cold_start = 1;
            state <= STATE_BUSY;
        end 
    end

    always @(posedge spi_sclk_o) begin
        if (!rst_i) begin
            case (state)
                STATE_IDLE: begin
                    ready_o <= 1;
                    counter <= 0;
                    spi_mosi_o <= 0;
                    spi_cs_o <= 1;
                end
                STATE_BUSY: begin
                    if (do_cold_start) begin
                        counter = 0;
                        do_cold_start = 0;
                    end else begin
                        counter = counter + 1;
                    end
                    ready_o <= 0;
                    spi_cs_o <= 0;
                    spi_mosi_o <= data_in_bi[counter];
                    data_out_bo[counter] <= spi_miso_i;
                    if (counter == 7) begin
                        state <= STATE_IDLE;
                    end
                end
                default: begin
                    state <= STATE_IDLE;
                end
            endcase
        end
    end
    
endmodule
