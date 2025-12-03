module Mul4to4 (
    A,
    B,
    out
);

    input wire [3:0] A;
    input wire [3:0] B;
    output wire [7:0] out;
    wire [5:0] S1, S2;
    wire c1, c2, c3, c4, c5;


    Mul4to2 Mul1 (
        .A(A[3:0]),
        .B(B[1:0]),
        .out(S1[5:0])
    );

    Mul4to2 Mul2 (
        .A(A[3:0]),
        .B(B[3:2]),
        .out(S2[5:0])
    );

    assign out[0] = S1[0];
    assign out[1] = S1[1];

    HalfAdder HA1 (
        .a(S1[2]),
        .b(S2[0]),
        .sum(out[2]),
        .carry(c1)
    );

    FullAdder FA1 (
        .a(S1[3]),
        .b(S2[1]),
        .cin(c1),
        .sum(out[3]),
        .carry(c2)
    );

    FullAdder FA2 (
        .a(S1[4]),
        .b(S2[2]),
        .cin(c2),
        .sum(out[4]),
        .carry(c3)
    );

    FullAdder FA3 (
        .a(S1[5]),
        .b(S2[3]),
        .cin(c3),
        .sum(out[5]),
        .carry(c4)
    );

    HalfAdder HA2 (
        .a(c4),
        .b(S2[4]),
        .sum(out[6]),
        .carry(c5)
    );

    xor2 Xor1 (
        .a(S2[5]),
        .b(c5),
        .out(out[7])
    );

endmodule