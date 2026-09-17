module Multiplexer #(
    parameter INP_NUMBER = 4,
    parameter SIZE = 32
) (
    input  [INP_NUMBER*SIZE-1:0] inp,
    input  [$clog2(INP_NUMBER)-1:0] sel,
    output [SIZE-1:0] out
);

    assign out = inp[sel*SIZE +: SIZE];

endmodule