`timescale 1ns/1ns

module TopTestBench;
    parameter N = 8;
    parameter MP = 16;
    parameter W = 16;
    parameter MEM_SIZE = 128;
    parameter ROWS = 8;
    parameter MEM_PATH = "test.mem";

    localparam CLK_PERIOD = 10;
    
    reg clk;
    reg rst;
    reg start;
    wire done;
    
    MatrixAccelerator #(
        .N(N),
        .MP(MP),
        .W(W),
        .MEM_SIZE(MEM_SIZE),
        .ROWS(ROWS),
        .MEM_PATH(MEM_PATH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done)
    );
    
    always #(CLK_PERIOD/2) clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        
        #(CLK_PERIOD * 2);
        rst = 0;
        #(CLK_PERIOD * 2);
        
        start = 1;
        #(CLK_PERIOD);
        start = 0;
        
        wait(done);
        
        #(CLK_PERIOD * 5);
        
        
        $stop;
    end

endmodule