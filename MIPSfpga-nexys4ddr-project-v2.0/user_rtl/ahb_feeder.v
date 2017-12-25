`timescale 100ps/1ps

module ahb_feeder
(
    input                HCLK,
    output reg           HRESETn,
    output      [ 31: 0] HADDR,
    output      [  2: 0] HBURST,
    output               HMASTLOCK,
    output      [  3: 0] HPROT,
    output      [  2: 0] HSIZE,
    output      [  1: 0] HTRANS,
    output      [ 31: 0] HWDATA,
    output               HWRITE,
    input       [ 31: 0] HRDATA,
    input                HREADY,
    input                HRESP
);

    ahb_master ahb_master (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .HADDR(HADDR),
        .HBURST(HBURST),
        .HMASTLOCK(HMASTLOCK),
        .HPROT(HPROT),
        .HSIZE(HSIZE),
        .HTRANS(HTRANS),
        .HWDATA(HWDATA),
        .HWRITE(HWRITE),
        .HRDATA(HRDATA),
        .HREADY(HREADY),
        .HRESP(HRESP)
    );
    
    reg  [31:0] data_buf;
    
    localparam UART_DATA_ADDR = 32'hbf400000; // register for data to transmit (only one byte is used)
    localparam UART_CTRL_ADDR = 32'hbf400004; // control regster
    localparam UART_DVDR_ADDR = 32'hbf400008; // clock divider register
    
    initial begin
        // wait for end of reset
        repeat (35)  @(posedge HCLK);
        
        // Test UART transmitter
        
        // Write value small divider for simulation
        ahb_master.ahb_write(UART_DVDR_ADDR, 32'h2);
        
        // Write 1st byte to transmit
        data_buf[0] = 1'b1;
        while (data_buf[0] == 1'b1) begin // wait for end of current transmission
            ahb_master.ahb_read(UART_CTRL_ADDR, data_buf);
        end
        ahb_master.ahb_write(UART_DATA_ADDR, 32'hAA); // write 0xAA to transmit register

        // Write 2nd byte to transmit
        data_buf[0] = 1'b1;
        while (data_buf[0] == 1'b1) begin // wait for end of current transmission
            ahb_master.ahb_read(UART_CTRL_ADDR, data_buf);
        end
        ahb_master.ahb_write(UART_DATA_ADDR, 32'hCC); // write 0xСС to transmit register

        // Write 3rd byte to transmit
        data_buf[0] = 1'b1;
        while (data_buf[0] == 1'b1) begin // wait for end of current transmission
            ahb_master.ahb_read(UART_CTRL_ADDR, data_buf);
        end
        ahb_master.ahb_write(UART_DATA_ADDR, 32'h99); // write 0x99 to transmit register        
        
    end

endmodule
