module NormalRegister(
    clk,
    clr,
    dataIn,
    en,
    out
);
    input wire clk, clr;
    input wire [7:0] dataIn;
    input wire en;
    output wire [7:0] out;
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            s1 NormalRegisterBlock(
                .D00(out[i]),
                .D01(1'b0),
                .D10(dataIn[i]),
                .D11(1'b0),
                .A1(en),
                .B1(1'b0),
                .A0(1'b0),
                .clr(clr),
                .clk(clk),
                .out(out[i])
            );
        end
    endgenerate
endmodule