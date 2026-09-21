module ShiftLeftRegister #(
    parameter SIZE = 16
) (
    clk,
    rst,
    shQ,
    loadQ,
    sIn,
    qIn,
    qOut,
    sOut
);
    input wire clk, rst, shQ, loadQ, sIn;
    input wire [(SIZE - 1):0] qIn;
    output reg [(SIZE - 1):0] qOut;
    output wire sOut;

    always @(posedge clk) begin
        if (rst) 
            qOut <= {SIZE{1'b0}};
        else if (loadQ) begin
            qOut <= qIn;
        end else if (shQ) begin
            qOut <= {qOut[(SIZE - 2):0], sIn};
        end
    end

    assign sOut = qOut[SIZE-1];

endmodule