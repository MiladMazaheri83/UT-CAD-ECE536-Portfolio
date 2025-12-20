module Multiplier
(
    dataIn,
    dataOut
);

    input [7:0] dataIn;
    output [7:0] dataOut;

    assign dataOut = dataIn[3:0] * dataIn[7:4];

endmodule