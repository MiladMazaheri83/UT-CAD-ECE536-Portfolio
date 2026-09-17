module RandomGeneratorTestBench;
    reg clk, clr, startRnd;
    reg [5:0] inp;
    wire doneRnd;
    wire [1:0] randOut;
    
    RandomGenerator dut(
        .clk(clk),
        .clr(clr),
        .startRnd(startRnd),
        .inp(inp),
        .doneRnd(doneRnd),
        .randOut(randOut)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; clr = 0; startRnd = 0; inp = 6'b000000;
        #10;
        clr = 1; #10; clr = 0; #10;
        inp = 6'b101010; startRnd = 1; #10; startRnd = 0;
        #100;
        inp = 6'b010101; startRnd = 1; #10; startRnd = 0;
        #100;
        $stop;
    end
endmodule