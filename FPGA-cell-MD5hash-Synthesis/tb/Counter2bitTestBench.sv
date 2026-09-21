module Counter2bitTestBench;
    reg clk, clr, en, init;
    wire [1:0] cnt2Out;
    
    Counter2bit dut(.clk(clk), .clr(clr), .en(en), .init(init), .cnt2Out(cnt2Out));
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; clr = 0; en = 0; init = 1;
        #10;
        clr = 1; #10; clr = 0; #10;
        en = 1; #50;
        init = 0; #10; init = 1; #30;
        $stop;
    end
endmodule