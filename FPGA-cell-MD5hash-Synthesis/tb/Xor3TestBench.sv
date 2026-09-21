module Xor3TestBench;
    reg a, b, c;
    wire out;
    
    Xor3 dut(.a(a), .b(b), .c(c), .out(out));
    
    initial begin
        a = 0; b = 0; c = 0; #10;
        a = 0; b = 1; c = 0; #10;
        a = 1; b = 0; c = 1; #10;
        a = 1; b = 1; c = 1; #10;
        $stop;
    end
endmodule