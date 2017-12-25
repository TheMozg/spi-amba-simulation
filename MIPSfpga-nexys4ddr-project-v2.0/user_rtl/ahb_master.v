`timescale 100ps/1ps

module ahb_master
(
    input               HCLK,
    input               HRESETn,
    output reg [ 31: 0] HADDR,
    output reg [  2: 0] HBURST,
    output reg          HMASTLOCK,
    output reg [  3: 0] HPROT,
    output reg [  2: 0] HSIZE,
    output reg [  1: 0] HTRANS,
    output reg [ 31: 0] HWDATA,
    output reg          HWRITE,
    input      [ 31: 0] HRDATA,
    input               HREADY,
    input               HRESP
);
    // Transactions tasks

    task ahb_transaction (
        input             write,
        input      [31:0] addr,
        input      [31:0] wdata,
        output reg [31:0] rdata
    );
    begin
        //$display("%09d addr phase start", $time);
        HADDR  = addr;
        HWRITE = write;
        @(posedge HCLK);
        
        //$display("%09d data phase start", $time);
        HWRITE = 1'b0;
        if (write == 1'b1) begin
            HWDATA = wdata;
        end
        @(posedge HCLK);
        if (write == 1'b0) begin
            rdata = HRDATA;
        end
        
        //$display("%09d data phase end", $time);
    end
    endtask
    
    task ahb_read (
        input      [31:0] addr,
        output reg [31:0] rdata
    );
    begin
        ahb_transaction(1'b0, addr, 0, rdata);
        $display("READ  addr: 0x%08H, data: 0x%08H", addr, rdata);
    end
    endtask

    task ahb_write (
        input      [31:0] addr,
        input      [31:0] wdata
    );
        reg  [31:0] buffer;
    begin
        ahb_transaction(1'b1, addr, wdata, buffer);
        $display("WRITE addr: 0x%08H, data: 0x%08H", addr, wdata);
    end
    endtask
    
    // Init signals
    
    initial begin
        $display("Start ahb_master!\n");
        HADDR     = 32'b0;
        HBURST    = 3'b0;
        HMASTLOCK = 1'b0;
        HPROT     = 4'b1100;
        HSIZE     = 3'b010;
        HTRANS    = 2'b00;
        HWDATA    = 32'b0;
        HWRITE    = 1'b0;
    end
    
endmodule
