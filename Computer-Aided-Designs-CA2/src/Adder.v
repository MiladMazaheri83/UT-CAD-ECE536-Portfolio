module Adder #(
    parameter SIZE = 32
) (
    a,
    b,
    out
);
    input [SIZE - 1:0] a, b;
    output [SIZE - 1:0] out;

    assign out = a + b;
endmodule