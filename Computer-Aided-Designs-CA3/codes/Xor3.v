module Xor3(
    a,
    b,
    c,
    out
);
    input wire a, b, c;
    output wire out;

    wire xorAB;

    c1 Xor1Block(
        .A0(1'b0), 
        .A1(1'b1), 
        .SA(b),
        .B0(1'b1),
        .B1(1'b0),
        .SB(b),
        .S0(1'b0),
        .S1(a),
        .f(xorAB)
    );

    c1 Xor2Block(
        .A0(1'b0), 
        .A1(1'b1), 
        .SA(c),
        .B0(1'b1),
        .B1(1'b0),
        .SB(c),
        .S0(1'b0),
        .S1(xorAB),
        .f(out)
    );
endmodule