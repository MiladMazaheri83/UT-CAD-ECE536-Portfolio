module And4(
    a,
    b,
    c,
    d,
    out
);
    input wire a, b, c, d;
    output wire out;

    c2 And4Block(
        .D00(1'b0), 
        .D01(1'b0),
        .D10(1'b0),
        .D11(d),
        .A1(a),
        .B1(1'b0),
        .A0(b),
        .B0(c),
        .out(out)
    );
endmodule