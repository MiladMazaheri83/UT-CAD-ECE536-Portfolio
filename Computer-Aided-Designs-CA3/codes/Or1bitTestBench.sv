module Or1bitTestBench;
    reg a, b;
    wire out;
    
    Or1bit dut(.a(a), .b(b), .out(out));
    
    initial begin
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;
        $stop;
    end
endmodule