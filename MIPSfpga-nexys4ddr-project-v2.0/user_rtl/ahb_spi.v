`timescale 100ps/1ps

module ahb_uart_tx
(
    input               HCLK,
    input               HRESETn,
    input      [ 31: 0] HADDR,
    input      [ 31: 0] HWDATA,
    input               HWRITE,
    input               HSEL,
    output reg [ 31: 0] HRDATA,
    output              HREADY,
    output              HRESP,

    output reg          UART_TX
);

    ///////////////////////////////
    
    // for HCLK 50 MHz
    localparam DIVIDER_9600   = 5208;
    localparam DIVIDER_115200 = 434;
    
    
    localparam DATA_REG_ADDR = 4'h0;
    localparam CTRL_REG_ADDR = 4'h1;
    localparam DVDR_REG_ADDR = 4'h2;
    
    localparam FSM_UART_TX_STATE_IDLE  = 3'h0;
    localparam FSM_UART_TX_STATE_START = 3'h1;
    localparam FSM_UART_TX_STATE_DATA  = 3'h2;
    localparam FSM_UART_TX_STATE_STOP  = 3'h3;
    localparam FSM_UART_TX_STATE_WAIT_FINISH = 3'h4;
    
    
    reg  [31:0] divider_value_buf;    
    reg  [ 7:0] tx_data_buf;
    reg         tx_data_buf_flag;
    reg         tx_data_lost_flag;
    
    reg  [ 7:0] tx_data_shift;
    reg         tx_start_pulse;
    reg         tx_finish_pulse;
    reg         tx_busy_flag;
    reg  [ 2:0] tx_count;
    reg  [ 2:0] fsm_uart_tx_state;
    
    reg  [31:0] divider_reg;
    reg  [31:0] divider_value;
    reg         divider_pulse;
    
    ///////////////////////////////
    // AHB bus adapter
    
    reg  [ 3:0] HADDR_dly;
    reg         HWRITE_dly;
    reg         HSEL_dly;
    
    assign HREADY = 1'b1;
    assign HRESP  = 1'b0;
    
    always @(posedge HCLK) begin
        HADDR_dly <= HADDR[5:2];
        HWRITE_dly <= HWRITE;
        HSEL_dly <= HSEL;
    end
    
    wire [ 3:0] reg_addr = HADDR_dly;
    

    always @(posedge HCLK or negedge HRESETn) begin
        if (~HRESETn) begin
            divider_value_buf <= DIVIDER_115200;
            tx_data_buf <= 8'b0;
            
            tx_data_lost_flag <= 1'b0;
            tx_data_buf_flag <= 1'b0;
        end
        else begin
            if (tx_finish_pulse) begin
                tx_data_buf_flag <= 1'b0;
            end
            
            // Bus interface logic, write operation
            if (HSEL_dly & HWRITE_dly) begin
                case (reg_addr)
                DATA_REG_ADDR:
                    // Save new byte if buf is empty, otherwise ignore if
                    if (!tx_data_buf_flag) begin
                        tx_data_buf <= HWDATA[7:0];
                        tx_data_buf_flag <= 1'b1;
                        tx_data_lost_flag <= 1'b0;
                    end
                    else begin
                        tx_data_lost_flag <= 1'b1;
                    end
                DVDR_REG_ADDR:
                    divider_value_buf <= HWDATA;
                endcase
            end
        end
    end
    
    ///////////////////////////////
    // Bus interface logic, data for read operation
    
    always @(*) begin
        case (reg_addr)
            CTRL_REG_ADDR: HRDATA = {16'h55AA, 12'b0, tx_data_lost_flag, 2'b0, tx_busy_flag};
            DVDR_REG_ADDR: HRDATA = divider_value;
            default:       HRDATA = 32'b0;
        endcase
    end
    
    ///////////////////////////////
    // UART transmitter
    
    always @(posedge HCLK or negedge HRESETn) begin
        if (~HRESETn) begin
            tx_data_shift <= 8'h0;
            tx_finish_pulse <= 1'b0;
            tx_start_pulse <= 1'b0;
            tx_busy_flag <= 1'b0;
            
            tx_count <= 3'h0;
            fsm_uart_tx_state <= FSM_UART_TX_STATE_IDLE;
            
            UART_TX <= 1'b1;
        end
        else begin
            // TX FSM logic
            case (fsm_uart_tx_state)
            FSM_UART_TX_STATE_IDLE:
                if (tx_data_buf_flag) begin
                    tx_data_shift <= tx_data_buf;
                    
                    tx_start_pulse <= 1'b1;
                    tx_busy_flag <= 1'b1;
                    
                    fsm_uart_tx_state <= FSM_UART_TX_STATE_START;
                end
            FSM_UART_TX_STATE_START:
                begin
                    tx_start_pulse <= 1'b0;
                    if (divider_pulse) begin
                        UART_TX <= 1'b0; // start bit
                        
                        tx_count <= 3'h7;
                        
                        fsm_uart_tx_state <= FSM_UART_TX_STATE_DATA;
                    end
                end
            FSM_UART_TX_STATE_DATA:
                if (divider_pulse) begin
                    UART_TX <= tx_data_shift[0]; // transmit least significant bit
                    
                    tx_data_shift <= {1'b0, tx_data_shift[7:1]}; // shift transmitted byte
                    
                    if (tx_count != 3'h0) begin
                        tx_count <= tx_count - 3'h1;
                    end
                    else begin
                        fsm_uart_tx_state <= FSM_UART_TX_STATE_STOP;
                    end
                end
            FSM_UART_TX_STATE_STOP:
                if (divider_pulse) begin
                    UART_TX <= 1'b1; // stop bit
                    
                    tx_finish_pulse <= 1'b1;
                    
                    fsm_uart_tx_state <= FSM_UART_TX_STATE_WAIT_FINISH;
                end
            FSM_UART_TX_STATE_WAIT_FINISH:
                begin
                    tx_finish_pulse <= 1'b0;
                    
                    if (divider_pulse) begin
                        tx_busy_flag <= 1'b0;
                        
                        fsm_uart_tx_state <= FSM_UART_TX_STATE_IDLE;
                    end
                end
            default:
                begin
                    tx_busy_flag <= 1'b1;
                    tx_start_pulse <= 1'b0;
                    tx_finish_pulse <= 1'b0;
                    
                    fsm_uart_tx_state <= FSM_UART_TX_STATE_IDLE;
                end
            endcase
        end
    end

    ///////////////////////////////
    // Clock divider
    
    always @(posedge HCLK or negedge HRESETn) begin
        if (~HRESETn) begin
            divider_value <= 32'b0;
            divider_reg <= 32'b0;
            
            divider_pulse <= 32'b0;
        end
        else begin
            if (tx_start_pulse) begin
                divider_value <= divider_value_buf;
                divider_reg <= divider_value_buf - 32'b1;
                divider_pulse <= 32'b1;
            end
            else begin
                if (divider_reg != 32'b0) begin
                    divider_pulse <= 32'b0;
                    divider_reg <= divider_reg - 32'b1;
                end
                else begin
                    divider_pulse <= 32'b1;
                
                    if (divider_value != 32'b1) begin
                        divider_reg <= divider_value - 32'b1;
                    end
                end
            end
        end
    end
    
endmodule
