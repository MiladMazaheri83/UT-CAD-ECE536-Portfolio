module Counter3bitTestBench;
    reg clk, clr, en, load;
    wire [2:0] cnt3Out;
    
    Counter3bit dut(.clk(clk), .clr(clr), .en(en), .load(load), .cnt3Out(cnt3Out));
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; clr = 0; en = 0; load = 0;
        #10;
        clr = 1; #10; clr = 0; #10;
        en = 1; #80;
        load = 1; #10; load = 0; #40;
        $stop;
    end
endmodule