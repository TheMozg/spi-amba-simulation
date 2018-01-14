`timescale 100ps/1ps
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
    input             spi_cs_i,
    input             spi_miso_i,
    output reg        spi_mosi_o,
    output reg        spi_sclk_o
    );

    localparam CLK_NOPS = 1;

    reg   in_progress;
    reg   [2:0] counter;
    reg   [7:0] clk_div;
    reg   clk_div_pulse;
    reg   [7:0] shiftreg;
    reg         bit_buffer;
    
    localparam STATE_IDLE              = 0; // wait for transaction begin
    localparam STATE_WAIT_SCLK_1       = 1; // wait for SCLK to become 1
    localparam STATE_WAIT_SCLK_0       = 2; // wait for SCLK to become 0
    localparam STATE_WAIT_IDLE         = 3; // wait one SCLK and swith to idle
    
    reg   [2:0] state;
    
    always @(posedge clk_i) begin
        if (rst_i) begin
            counter     <= 0;
            shiftreg    <= 0;
            bit_buffer  <= 0;
            in_progress <= 0;
            clk_div     <= 0;
            clk_div_pulse <= 0;
            state       <= STATE_IDLE; 
        end 
        else begin
            case (state)
                STATE_IDLE: begin
                    if (start_i) begin
                        in_progress = 1;
                        shiftreg <= data_in_bi;
                        state <= STATE_WAIT_SCLK_1;
                        clk_div <= 0;
                    end else begin 
                        in_progress = 0;
                    end
                end
                STATE_WAIT_SCLK_1: begin
                    if (clk_div == CLK_NOPS) begin
                        bit_buffer <= spi_miso_i;
                        state <= STATE_WAIT_SCLK_0;
                        clk_div <= 0;
                        clk_div_pulse <= ~clk_div_pulse;
                    end else begin
                        clk_div <= clk_div + 1;
                    end
                end
                STATE_WAIT_SCLK_0: begin
                    if (clk_div == CLK_NOPS) begin
                        shiftreg <= { bit_buffer, shiftreg[7:1] };
                        if (counter == 7) begin
                            in_progress <= 0;
                            state <= STATE_WAIT_IDLE;
                            counter <= 0;
                        end else begin
                            state <= STATE_WAIT_SCLK_1;
                            counter <= counter + 1;
                        end
                        clk_div <= 0;
                        clk_div_pulse <= ~clk_div_pulse;
                    end else begin
                        clk_div <= clk_div + 1;
                    end
                end
                STATE_WAIT_IDLE: begin
                    if (clk_div == CLK_NOPS) begin
                        state <= STATE_IDLE;
                        clk_div <= 0;
                        clk_div_pulse <= 0;
                    end else begin
                        clk_div <= clk_div + 1;
                    end
                end
                default: begin
                    state <= STATE_IDLE;
                end
            endcase
        end
    end
        
    always @* begin
        busy_o      = (state != STATE_IDLE);
        data_out_bo = shiftreg;
        spi_sclk_o  = clk_div_pulse && !spi_cs_i;
        if (in_progress)
            spi_mosi_o  = shiftreg[0] && !spi_cs_i;
        else
            spi_mosi_o  = 0;
    end

endmodule
