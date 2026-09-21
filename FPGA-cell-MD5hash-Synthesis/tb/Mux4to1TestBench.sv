module Mux4to1TestBench;
    reg s0, s1;
    reg [7:0] d00, d01, d10, d11;
    wire [7:0] out;
    
    Mux4to1 dut(.s0(s0), .s1(s1), .d00(d00), .d01(d01), .d10(d10), .d11(d11), .out(out));
    
    initial begin
        d00 = 8'hAA; d01 = 8'hBB; d10 = 8'hCC; d11 = 8'hDD;
        s0 = 0; s1 = 0; #10;
        s0 = 1; s1 = 0; #10;
        s0 = 0; s1 = 1; #10;
        s0 = 1; s1 = 1; #10;
        $stop;
    end
endmodule