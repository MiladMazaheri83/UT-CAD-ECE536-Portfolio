module LeftRotate(dataIn, dataOut, index);
    parameter WIDTH = 32
    input [WIDTH-1:0] dataIn,
    input [5:0] index;
    output [WIDTH-1:0] dataOut

    localparam STEPS = {};
    wire [$clog2(WIDTH)-1:0] rotateAmount;


    assign dataOut = (data_in << rotate_amount) | (data_in >> (WIDTH - rotate_amount));
endmodule