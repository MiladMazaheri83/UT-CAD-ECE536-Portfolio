module HashGeneratorTestBench;
    reg clk, clr, start;
    reg [31:0] inp;
    reg [7:0] aInit, bInit, cInit, dInit;
    wire done;
    wire [31:0] out;
    
    HashGenerator dut(
        .clk(clk),
        .clr(clr),
        .inp(inp),
        .out(out),
        .aInit(aInit),
        .bInit(bInit),
        .cInit(cInit),
        .dInit(dInit),
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