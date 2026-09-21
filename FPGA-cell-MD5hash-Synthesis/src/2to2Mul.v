module Mul2to2 (
    A,
    B,
    out
);

    input wire [1:0] A;
    input wire [1:0] B;
    output wire [5:0] out;
    wire xorOut;

    And1bit And0 (
        .a(A[0]),
        .b(B[0]),
        .out(out[0])
    );

    Xor2 xor1(
        .a(A[0]),
        .b(A[1]),
        .out(xorOut)
    );

    Mux4to1oneBit Mux1BitBlock(
        .s0(B[1]),
        .s1(B[0]),
        .d00(1'b0),
        .d01(A[0]),
        .d10(A[1]),
        .d11(xorOut),
        .out(out[1])
    );

    Mux4to1oneBit Mux2BitBlock(
        .s0(B[1]),
        .s1(out[0]),
        .d00(1'b0),
        .d01(A[1]),
        .d10(1'b0),
        .d11(1'b0),
        .out(out[2])
    );

    Mux4to1oneBit Mux3BitBlock(
        .s0(B[1]),
        .s1(out[0]),
        .d00(1'b0),
        .d01(1'b0),
        .d10(1'b0),
        .d11(A[1]),
        .out(out[3])
    );

endmodule