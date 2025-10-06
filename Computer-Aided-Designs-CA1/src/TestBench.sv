`timescale 1ns/1ps

module tb_Top;
    logic clk;
    logic rst;
    logic start;
    logic [127:0] inp;
    logic done;
    logic [127:0] out;
    
    Top dut (
        .clk(clk),
        .rst(rst),
        .inp(inp),
        .out(out),
        .start(start),
        .done(done)
    );
    
    always #5 clk = ~clk;
    
    
endmodule