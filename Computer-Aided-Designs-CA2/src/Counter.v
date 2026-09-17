module Counter #(
    parameter SIZE = 2
) (
    clk,
    rst,
    load,
    enCnt,
    pin,
    cntOut,
    co
);

    input wire clk, rst, load, enCnt;
    input wire [(SIZE - 1):0] pin;
    output reg [(SIZE - 1):0] cntOut;
    output wire co;

    always @(posedge clk or posedge rst) begin
        if (rst)
            cntOut <= {SIZE{1'b0}};
        else if (load) begin
            cntOut <= pin;
        end
        else if (enCnt) begin
            cntOut <= cntOut + 1;
        end
    end

    assign co = &cntOut;
    
endmodule