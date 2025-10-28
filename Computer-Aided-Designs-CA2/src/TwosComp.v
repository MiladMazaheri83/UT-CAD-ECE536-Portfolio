module TwosComplement #(
    parameter WIDTH = 16
) (
    data_in,
    data_out
);
    input wire [WIDTH-1:0] data_in;
    output wire [WIDTH-1:0] data_out;
    
    assign data_out = ~data_in + 1'b1;
    
endmodule