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

    reg   [2:0] counter;
    reg   clk_div4;
    reg   [7:0] shiftreg;
    reg         bit_buffer;
    
    localparam STATE_IDLE              = 0; // wait for transaction begin
    localparam STATE_WAIT_SCLK_1       = 1; // wait for SCLK to become 1
    localparam STATE_WAIT_SCLK_0       = 2; // wait for SCLK to become 0
    localparam STATE_NOP_0             = 3; // skip half sclk
    localparam STATE_NOP_1             = 4; // skip half sclk
    localparam STATE_NOP_IDLE          = 5; // skip half sclk
    
    reg   [2:0] state;
    
    always @(posedge clk_i) begin
        if (rst_i) begin
            spi_sclk_o  <= 0;
            counter     <= 0;
            shiftreg    <= 0;
            bit_buffer  <= 0;
            data_out_bo <= 0;    
            spi_mosi_o  <= 0;    
            state       <= STATE_IDLE; 
        end 
        else begin
            case (state)
                STATE_IDLE: begin
                    if (start_i) begin
                        shiftreg <= data_in_bi;
                        state <= STATE_NOP_1;
                        clk_div4 <= 0;
                    end
                end
                STATE_WAIT_SCLK_1: begin
                    clk_div4 <= 1;
                    bit_buffer <= spi_miso_i;
                    state <= STATE_NOP_0;
                end
                STATE_WAIT_SCLK_0: begin
                    clk_div4 <= 0;
                    shiftreg <= { bit_buffer, shiftreg[7:1] };
                    state <= STATE_NOP_1;
                    if (counter == 7) begin
                        state <= STATE_NOP_IDLE;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                STATE_NOP_1: begin
                    state <= STATE_WAIT_SCLK_1;
                end
                STATE_NOP_0: begin
                    state <= STATE_WAIT_SCLK_0;
                end
                STATE_NOP_IDLE: begin
                    state <= STATE_IDLE;
                end
                default: begin
                    state <= STATE_IDLE;
                end
            endcase
        end
    end
        
    always @* begin
        busy_o      = (state != STATE_IDLE);
        spi_cs_o    = (state == STATE_IDLE);
        data_out_bo = shiftreg;
        spi_sclk_o  = clk_div4 && !spi_cs_o;
        spi_mosi_o  = shiftreg[0] && !spi_cs_o;
    end

endmodule
