module Register #(
    parameter SIZE = 32
) (
    clk,
    rst,
    init,
    inp,
    out,
    en
);
    
    input wire clk, rst, en, init;
    input wire [SIZE - 1:0] inp;
    output reg [SIZE - 1:0] out;

    always @(posedge clk, posedge rst) begin
        if (rst)
            out <= 0;
        else if (init)
            out <= 0;
        else if(en)
            out <= inp;
    end

endmodule