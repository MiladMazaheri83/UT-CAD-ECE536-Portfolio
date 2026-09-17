module TwosComplement #(
    parameter WIDTH = 16
) (
    dataIn,
    dataOut
);
    input wire [WIDTH-1:0] dataIn;
    output wire [WIDTH-1:0] dataOut;
    
    assign dataOut = ~dataIn + 1'b1;
    
endmodule