module NormalRegister(
    clk,
    clr,
    dataIn,
    en,
    loadData,
    load,
    out
);
    input wire clk, clr, dataIn, en, loadData, load;
    output wire out;
    
    s2 NormalRegisterBlock(
        .D00(out),
        .D01(1'b0),
        .D10(dataIn),
        .D11(loadData),
        .A1(en),
        .B1(load),
        .A0(load),
        .B0(1'b0),
        .clr(clr),
        .clk(clk),
        .out(out)
    );
endmodule