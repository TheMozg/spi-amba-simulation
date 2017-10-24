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
    output reg        busy_o,      // transaction is being processed
    output reg  [7:0] data_out_bo, // data recevied from slave in last transaction
    
    // SPI interface
    input             spi_miso_i,
    output reg        spi_mosi_o,
    output reg        spi_sclk_o,
    output reg        spi_cs_o
    );

    reg   [3:0] counter;
    reg   clk_div2;
    reg   mosi_enable;
    reg   [7:0] shiftreg;
    reg         bit_buffer;
    
    localparam STATE_IDLE              = 0; // wait for transaction begin
    localparam STATE_WAIT_SCLK_1       = 1; // wait for SCLK to become 1
    localparam STATE_WAIT_SCLK_0       = 2; // wait for SCLK to become 0
    localparam STATE_WAIT_SCLK_0_START = 3; // wait for SCLK to become 0, no shift

    
    reg   [2:0] state;
    
    always @(posedge clk_i) begin
        if (clk_div2) begin
            spi_sclk_o = !spi_sclk_o;
        end
        clk_div2 <= !clk_div2;
        if (rst_i) begin
            spi_sclk_o  <= 0;
            counter     <= 0;
            clk_div2    <= 1;
            shiftreg    <= 0;
            bit_buffer  <= 0;
            data_out_bo <= 0;    
            spi_mosi_o  <= 0;    
            state       <= STATE_IDLE; 
            mosi_enable <= 0;
        end 
        else begin
            if (counter == 8) begin
                state <= STATE_IDLE;
                counter <= 0;
                mosi_enable <= 0;
            end
            else begin
                case (state)
                    STATE_IDLE: begin
                        if (start_i) begin
                            shiftreg <= data_in_bi;
                            mosi_enable <= 0;
                            state <= STATE_WAIT_SCLK_0_START;
                        end
                    end
                    STATE_WAIT_SCLK_1: begin
                        if (spi_sclk_o == 1) begin
                            bit_buffer <= spi_miso_i;
                            state <= STATE_WAIT_SCLK_0;
                        end
                    end
                    STATE_WAIT_SCLK_0: begin
                        if (spi_sclk_o == 0) begin
                            shiftreg <= { shiftreg[6:0], bit_buffer };
                            state <= STATE_WAIT_SCLK_1;
                            if (counter == 7)
                                mosi_enable <= 0;
                            counter <= counter + 1;
                        end
                    end
                    STATE_WAIT_SCLK_0_START: begin
                        if (spi_sclk_o == 0) begin
                            mosi_enable <= 1;
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
        busy_o = (state != STATE_IDLE);
        spi_cs_o = (state == STATE_IDLE);

        data_out_bo = shiftreg;
        
        spi_mosi_o = shiftreg[7] && mosi_enable;
    end

endmodule
