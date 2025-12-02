module And3(
    a,
    b,
    c,
    out
);
    input wire a, b, c;
    output wire out;

    c1 And3Block(
        .A0(1'b0),
        .A1(1'b0),
        .SA(b),
        .B0(1'b0),
        .B1(c),
        .SB(b),
        .S0(a),
        .S1(1'b0),
        .f(out)
    );
endmodule