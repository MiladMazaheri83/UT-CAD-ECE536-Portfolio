module Or1bit(
    a,
    b,
    out
);
    input wire a, b;
    output wire out;
    
    c1 Or1Block(
        .A0(1'b0),
        .A1(1'b1),
        .SA(b),
        .B0(1'b1),
        .B1(1'b1),
        .SB(b),
        .S0(a),
        .S1(1'b0),
        .f(out)
    );
endmodule