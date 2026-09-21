module Accumulator #(
    parameter SIZE = 34
) (
    clk,
    rst,
    init,
    en,
    inp,
    out
);
    input wire clk, rst, init, en;
    input wire [SIZE-1:0] inp;
    output wire [SIZE-1:0] out;

    wire [SIZE-1:0] adderOut;

    Register #(.SIZE(SIZE)) accumulatorReg(
        .clk(clk),
        .rst(rst),
        .init(init),
        .inp(adderOut),
        .out(out),
        .en(en)
    );

    Adder #(.SIZE(SIZE)) accumulatorAdder(
        .a(inp),
        .b(out),
        .out(adderOut)
    );
endmodule