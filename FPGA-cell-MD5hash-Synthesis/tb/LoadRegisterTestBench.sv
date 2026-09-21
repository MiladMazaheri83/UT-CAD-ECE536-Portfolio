module LoadRegisterTestBench;
    reg clk, clr, en, load;
    reg [7:0] dataIn, loadData;
    wire [7:0] out;
    
    LoadRegister dut(.clk(clk), .clr(clr), .dataIn(dataIn), .en(en), .loadData(loadData), .load(load), .out(out));
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; clr = 0; en = 0; load = 0; dataIn = 8'h00; loadData = 8'h00;
        #10;
        clr = 1; #10; clr = 0; #10;
        dataIn = 8'hAA; en = 1; #10; en = 0; #10;
        loadData = 8'h55; load = 1; #10; load = 0; #20;
        $stop;
    end
endmodule