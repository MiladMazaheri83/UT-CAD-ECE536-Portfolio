module Not1bitTestBench;
    reg a;
    wire out;
    
    Not1bit dut(.a(a), .out(out));
    
    initial begin
        a = 0; #10;
        a = 1; #10;
        $stop;
    end
endmodule