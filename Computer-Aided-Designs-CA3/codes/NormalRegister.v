module NormalRegister(
    clk,
    clr,
    dataIn,
    en,
    out
);
    input wire clk, clr, dataIn, en;
    output wire out;
    
    s1 NormalRegisterBlock(
        .D00(out),
        .D01(1'b0),
        .D10(dataIn),
        .D11(1'b0),
        .A1(en),
        .B1(1'b0),
        .A0(1'b0),
        .clr(clr),
        .clk(clk),
        .out(out)
    );
endmodule