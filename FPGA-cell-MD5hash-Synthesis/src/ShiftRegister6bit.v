module ShiftRegister6bit(
    clk,
    clr,
    serIn,
    en,
    loadData,
    load,
    out
);
    input wire clk, clr;
    input wire serIn;
    input wire en;
    input wire [5:0] loadData;
    input wire load;
    output wire [5:0] out;

    s2 LoadRegisterBit0(
        .D00(out[0]),
        .D01(1'b0),
        .D10(serIn),
        .D11(loadData[0]),
        .A1(en),
        .B1(load),
        .A0(load),
        .B0(1'b1),
        .clr(clr),
        .clk(clk),
        .out(out[0])
    );
    
    genvar i;
    generate
        for (i = 1; i < 6; i = i + 1) begin
            s2 LoadRegisterBlock(
                .D00(out[i]),
                .D01(1'b0),
                .D10(out[i-1]),
                .D11(loadData[i]),
                .A1(en),
                .B1(load),
                .A0(load),
                .B0(1'b1),
                .clr(clr),
                .clk(clk),
                .out(out[i])
            );
        end
    endgenerate
endmodule