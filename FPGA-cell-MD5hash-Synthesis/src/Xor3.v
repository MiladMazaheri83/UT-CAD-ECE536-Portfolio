module Xor3(
    a,
    b,
    c,
    out
);
    input wire a, b, c;
    output wire out;

    wire xorAB;

    Xor2 Xor2Block1(
        .a(a),
        .b(b),
        .out(xorAB)
    );

    Xor2 Xor2Block2(
        .a(xorAB),
        .b(c),
        .out(out)
    );
endmodule