module Not1bit(
    a,
    out
);
    input wire a;
    output wire out;
    
    c1 NotBlock(
        .A0(1'b1),
        .A1(1'b1),
        .SA(1'b0),
        .B0(1'b0),
        .B1(1'b0),
        .SB(1'b0),
        .S0(a),
        .S1(1'b0),
        .f(out)
    );
endmodule