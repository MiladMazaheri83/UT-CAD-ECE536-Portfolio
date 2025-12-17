module Multiplier
#(
    parameter WIDTH = 4,
) (
    dataIn,
    dataOut
);

    input [WIDTH-1:0] dataIn;
    output [WIDTH-1:0] dataOut;

    assign dataOut =
        dataIn[(WIDTH/2)-1:0] * dataIn[WIDTH-1:WIDTH/2];

endmodule