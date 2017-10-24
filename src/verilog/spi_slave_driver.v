`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Simple SPI slave controller with CPOL=0 CPHA=0
//////////////////////////////////////////////////////////////////////////////////

module spi_slave_driver(
    input            clk_i,
    input            rst_i,
    
    // system interface
    input      [7:0] data_in_bi,  // data that master can read from slave
    output reg       ready_o,     // transaction is not processed now 
    output reg [7:0] data_out_bo, // data written to slave in last transaction
    
    // SPI iterface
    output reg       spi_miso_o,
    input            spi_mosi_i,
    input            spi_sclk_i,
    input            spi_cs_i
    );

    reg   [3:0] counter;
    reg   [7:0] shiftreg;
    reg         bit_buffer;
    reg         miso_enable;
    localparam STATE_IDLE = 0; // wait for transaction begin
    localparam STATE_WAIT_SCLK_1 = 1; // wait for SCLK to become 1
    localparam STATE_WAIT_SCLK_0 = 2; // wait for SCLK to become 0
    localparam STATE_WAIT_SCLK_0_START = 3; // wait for SCLK to become 0

    reg   [2:0] state;
    
    always @(posedge rst_i, posedge clk_i) begin
        if (rst_i == 1) begin
            shiftreg <= 0;
            bit_buffer <= 0;
        
            data_out_bo <= 0;
            counter     <= 0;
            spi_miso_o <= 0;
            miso_enable <= 0;
            state <= STATE_IDLE; 
        end 
        else begin
            if (spi_cs_i) begin
                state <= STATE_IDLE;
            end
            else begin
                case (state)
                    STATE_IDLE: begin
                        if (!spi_cs_i) begin
                            shiftreg <= data_in_bi;
                            miso_enable <= 0;
                            counter     <= 0;
                            state <= STATE_WAIT_SCLK_0_START;
                        end
                    end
                    STATE_WAIT_SCLK_1: begin
                        if (spi_sclk_i) begin
                            bit_buffer <= spi_mosi_i;
                            
                            state <= STATE_WAIT_SCLK_0;
                        end
                    end
                    STATE_WAIT_SCLK_0: begin
                        if (spi_sclk_i == 0) begin
                            shiftreg <= { shiftreg[6:0], bit_buffer };
                            miso_enable <= 1;
                            state <= STATE_WAIT_SCLK_1;
                            if (counter == 7)
                                miso_enable <= 0;
                            counter <= counter + 1;
                        end
                    end
                    STATE_WAIT_SCLK_0_START: begin
                        if (spi_sclk_i == 0) begin
                            miso_enable <= 1;
                            state <= STATE_WAIT_SCLK_1;
                        end
                    end
                    default: begin
                        state <= STATE_IDLE;
                    end
                endcase
            end
        end
    end
        
    always @* begin
        ready_o = (state == STATE_IDLE);
        data_out_bo = shiftreg;
        
        spi_miso_o = shiftreg[7] && miso_enable && !spi_cs_i;
    end
    
endmodule
