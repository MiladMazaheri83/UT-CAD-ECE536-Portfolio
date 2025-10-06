module LeftRotate(dataIn, dataOut, rotateAmount);
    parameter WIDTH = 32
    input wire [WIDTH-1:0] dataIn,
    input wire [$clog2(WIDTH)-1:0] rotateAmount,
    output wire [WIDTH-1:0] dataOut
    
    assign dataOut = (data_in << rotate_amount) | (data_in >> (WIDTH - rotate_amount));
endmodule