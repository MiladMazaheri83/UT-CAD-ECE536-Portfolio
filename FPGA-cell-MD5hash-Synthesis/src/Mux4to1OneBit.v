module Mux4to1oneBit(
    s0,
    s1,
    d00,
    d01,
    d10,
    d11,
    out
);
    input wire s0, s1;
    input wire d00, d01, d10, d11;
    output wire out; 
    

    c1 Mux1BitBlock(
        .A0(d00),
        .A1(d01), 
        .SA(s0),
        .B0(d10),
        .B1(d11),
        .SB(s0),
        .S0(s1),
        .S1(1'b0),
        .f(out)
    );

endmodule