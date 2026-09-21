module ShiftRegister6bitTestBench;
    reg clk, clr, serIn, en, load;
    reg [5:0] loadData;
    wire [5:0] out;
    
    ShiftRegister6bit dut(
        .clk(clk),
        .clr(clr),
        .serIn(serIn),
        .en(en),
        .loadData(loadData),
        .load(load),
        .out(out)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; clr = 0; serIn = 0; en = 0; load = 0; loadData = 6'b000000;
        
        clr = 1; #10; clr = 0; #10;
        
        loadData = 6'b101010; load = 1; #10; load = 0; #10;
        
        en = 1; serIn = 1; #10; serIn = 0; #10; serIn = 1; #10;
        en = 0; #20;
        
        en = 1; serIn = 0; #10; serIn = 1; #10; serIn = 0; #10;
        
        $stop;
    end
endmodule