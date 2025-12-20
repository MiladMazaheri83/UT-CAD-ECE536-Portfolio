`timescale 1ns/1ns

module HashGeneratorTestBench;
    logic clk, clr, start;
    logic [31:0] inp;
    logic [7:0] aInit, bInit, cInit, dInit;
    logic done;
    logic [31:0] out;
    
    HashGenerator dut (
        .clk(clk),
        .rst(clr),
        .aInit(aInit),
        .bInit(bInit),
        .cInit(cInit),
        .dInit(dInit),
        .inp(inp),
        .out(out),
        .start(start),
        .done(done)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; clr = 0; start = 0;
        inp = 32'h00000000;
        aInit = 8'h01; bInit = 8'h89; cInit = 8'hfe; dInit = 8'h76;
        
        #10;
        clr = 1; #10; clr = 0; #10;
        
        inp = 32'h3761eded;
        start = 1; #10; start = 0;
        
        #10000;

        $stop;
    end
endmodule