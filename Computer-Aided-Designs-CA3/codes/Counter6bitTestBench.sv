module Counter6bitTestBench;
    reg clk, clr, en, init;
    wire [5:0] cnt6Out;
    
    Counter6bit dut(.clk(clk), .clr(clr), .en(en), .init(init), .cnt6Out(cnt6Out));
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; clr = 0; en = 0; init = 0;
        #10;
        clr = 1; #10; clr = 0; #10;
        en = 1; #200;
        init = 1; #10; init = 0; #60;
        $stop;
    end
endmodule