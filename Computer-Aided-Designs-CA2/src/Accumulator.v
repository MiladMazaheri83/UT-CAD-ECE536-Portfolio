module Accumulator #(
    parameter SIZE = 34
) (
    clk,
    rst,
    init,
    inp,
    out
);
    input wire clk, rst, init;
    input wire [SIZE-1:0] inp;
    output reg [SIZE-1:0] out;

    wire [SIZE-1:0] regOut, adderOut;

    Register #(.SIZE(SIZE)) accumulatorReg(
        .clk(clk),
        .rst(rst),
        .init(init),
        .inp(adderOut),
        .out(regOut),
        .en(1)
    );

    Adder #(.SIZE(SIZE)) accumulatorAdder(
        .a(inp),
        .b(regOut),
        .out(adderOut)
    );
endmodule