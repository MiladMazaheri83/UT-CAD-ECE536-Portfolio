module Mul4to2 (
    A,
    B,
    out
);

    input wire [3:0] A;
    input wire [1:0] B;
    output wire [5:0] out;
    wire [5:0] partials;
    wire c1, c2, c3, c4;

    assign partials[0] = A[0];

    HalfAdder HA1 (
        .a(A[1]),
        .b(A[0]),
        .sum(partials[1]),
        .carry(c1)
    );

    FullAdder FA1 (
        .a(A[2]),
        .b(A[1]),
        .cin(c1),
        .sum(partials[2]),
        .carry(c2)
    );

    FullAdder FA2 (
        .a(A[3]),
        .b(A[2]),
        .cin(c2),
        .sum(partials[3]),
        .carry(c3)
    );

    HalfAdder HA2 (
        .a(A[3]),
        .b(c3),
        .sum(partials[4]),
        .carry(c4)
    );

    assign partials[5] = c4;

    And1bit And0 (
        .a(B[0]),
        .b(partials[0]),
        .out(out[0])
    );

    Mux4to1oneBit Mux1BitBlock(
        .s0(B[0]),
        .s1(B[1]),
        .d00(1'b0),
        .d01(A[1]),
        .d10(A[0]),
        .d11(partials[1]),
        .out(out[1])
    );

    Mux4to1oneBit Mux2BitBlock(
        .s0(B[0]),
        .s1(B[1]),
        .d00(1'b0),
        .d01(A[2]),
        .d10(A[1]),
        .d11(partials[2]),
        .out(out[2])
    );

    Mux4to1oneBit Mux3BitBlock(
        .s0(B[0]),
        .s1(B[1]),
        .d00(1'b0),
        .d01(A[3]),
        .d10(A[2]),
        .d11(partials[3]),
        .out(out[3])
    );

    Mux4to1oneBit Mux4BitBlock(
        .s0(B[0]),
        .s1(B[1]),
        .d00(1'b0),
        .d01(1'b0),
        .d10(A[3]),
        .d11(partials[4]),
        .out(out[4])
    );

    Mux4to1oneBit Mux5BitBlock(
        .s0(B[0]),
        .s1(B[1]),
        .d00(1'b0),
        .d01(1'b0),
        .d10(1'b0),
        .d11(partials[5]),
        .out(out[5])
    );
endmodule