module Multiplier
#(
    parameter WIDTH = 4,
) (
    dataIn,
    dataOut
);

    input [WIDTH-1:0] dataIn;
    output [WIDTH-1:0] dataOut;

    assign dataOut = dataIn[WIDTH/2:0] * dataIn[WIDTH:WIDTH/2];

endmodule