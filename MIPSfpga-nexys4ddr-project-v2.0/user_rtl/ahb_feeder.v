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
    reg         spi_ready_flag;
    
    localparam UART_DATA_ADDR = 32'hbf400000; // register for data to transmit (only one byte is used)
    localparam UART_CTRL_ADDR = 32'hbf400004; // control regster
    localparam UART_DVDR_ADDR = 32'hbf400008; // clock divider register

    localparam SPI_START_ADDR = 32'hbf000000;
    localparam SPI_SS_ADDR    = 32'hbf000004;
    localparam SPI_READY_ADDR = 32'hbf000008;
    localparam SPI_DATA_ADDR  = 32'hbf000012;

    initial begin
        // wait for end of reset
        repeat (35)  @(posedge HCLK);
        
        // Test PMODJSTK controller

        ahb_master.ahb_write(SPI_SS_ADDR, 1'b0);
        
        ahb_master.ahb_write(SPI_DATA_ADDR, 32'b10101010);
        ahb_master.ahb_write(SPI_START_ADDR, 1'b1);
        spi_ready_flag = 1'b0;
        while (spi_ready_flag == 1'b0) begin
            ahb_master.ahb_read(SPI_READY_ADDR, spi_ready_flag);
        end
        ahb_master.ahb_read(SPI_DATA_ADDR, data_buf);

        ahb_master.ahb_write(SPI_DATA_ADDR, 32'b00110011);
        ahb_master.ahb_write(SPI_START_ADDR, 1'b1);
        spi_ready_flag = 1'b0;
        while (spi_ready_flag == 1'b0) begin
            ahb_master.ahb_read(SPI_READY_ADDR, spi_ready_flag);
        end
        ahb_master.ahb_read(SPI_DATA_ADDR, data_buf);

        ahb_master.ahb_write(SPI_DATA_ADDR, 32'b11111111);
        ahb_master.ahb_write(SPI_START_ADDR, 1'b1);
        spi_ready_flag = 1'b0;
        while (spi_ready_flag == 1'b0) begin
            ahb_master.ahb_read(SPI_READY_ADDR, spi_ready_flag);
        end
        ahb_master.ahb_read(SPI_DATA_ADDR, data_buf);
        
        ahb_master.ahb_write(SPI_START_ADDR, 1'b1);
        spi_ready_flag = 1'b0;
        while (spi_ready_flag == 1'b0) begin
            ahb_master.ahb_read(SPI_READY_ADDR, spi_ready_flag);
        end
        ahb_master.ahb_read(SPI_DATA_ADDR, data_buf);
        
        ahb_master.ahb_write(SPI_START_ADDR, 1'b1);
        spi_ready_flag = 1'b0;
        while (spi_ready_flag == 1'b0) begin
            ahb_master.ahb_read(SPI_READY_ADDR, spi_ready_flag);
        end
        ahb_master.ahb_read(SPI_DATA_ADDR, data_buf);
        
        ahb_master.ahb_write(SPI_SS_ADDR, 1'b1);
        
    end

endmodule
