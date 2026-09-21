module Mul4to4 (
    A,
    B,
    out
);

    input wire [3:0] A;
    input wire [3:0] B;
    output wire [7:0] out;
    wire [3:0] S1, S2, S3, S4;
    wire c1, c2, c3, c4, c5, c6, c7, c8;
    wire sum1, sum2, sum3;


    Mul2to2 Mul1 (
        .A(A[1:0]),
        .B(B[1:0]),
        .out(S1[3:0])
    );

    Mul2to2 Mul2 (
        .A(A[3:2]),
        .B(B[1:0]),
        .out(S2[3:0])
    );

    Mul2to2 Mul3 (
        .A(A[1:0]),
        .B(B[3:2]),
        .out(S3[3:0])
    );

    Mul2to2 Mul4 (
        .A(A[3:2]),
        .B(B[3:2]),
        .out(S4[3:0])
    );

    assign out[0] = S1[0];
    assign out[1] = S1[1];

    FullAdder FA1 (
        .a(S1[2]),
        .b(S2[0]),
        .cin(S3[0]),
        .sum(out[2]),
        .cout(c1)
    );

    HalfAdder HA1 (
        .a(S1[3]),
        .b(c1),
        .sum(sum1),
        .cout(c2)
    );

    FullAdder FA2 (
        .a(S2[1]),
        .b(S3[1]),
        .cin(sum1),
        .sum(out[3]),
        .cout(c3)
    );
    
    FullAdder FA3 (
        .a(S4[0]),
        .b(c2),
        .cin(c3),
        .sum(sum2),
        .cout(c4)
    );

    FullAdder FA4 (
        .a(S2[2]),
        .b(S3[2]),
        .cin(sum2),
        .sum(out[4]),
        .cout(c5)
    );

    FullAdder FA5 (
        .a(c4),
        .b(c5),
        .cin(S2[3]),
        .sum(sum3),
        .cout(c6)
    );

    FullAdder FA6 (
        .a(S3[3]),
        .b(S4[1]),
        .cin(sum3),
        .sum(out[5]),
        .cout(c7)
    );

    FullAdder FA7 (
        .a(c6),
        .b(S4[2]),
        .cin(c7),
        .sum(out[6]),
        .cout(c8)
    );

    Xor2 Xor1 (
        .a(c8),
        .b(S4[3]),
        .out(out[7])
    );

endmodule