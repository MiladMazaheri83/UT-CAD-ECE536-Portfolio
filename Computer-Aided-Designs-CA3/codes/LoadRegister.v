module LoadRegister(
    clk,
    clr,
    dataIn,
    en,
    loadData,
    load,
    out
);
    input wire clk, clr;
    input wire [7:0] dataIn;
    input wire en;
    input wire [7:0] loadData;
    input wire load;
    output wire [7:0] out;
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            s2 NormalRegisterBlock(
                .D00(out[i]),
                .D01(1'b0),
                .D10(dataIn[i]),
                .D11(loadData[i]),
                .A1(en),
                .B1(load),
                .A0(load),
                .B0(1'b0),
                .clr(clr),
                .clk(clk),
                .out(out[i])
            );
        end
    endgenerate
endmodule