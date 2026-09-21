module Counter2bit(
    clk,
    clr,
    en,
    init,
    cnt2Out
);
    input wire clk, clr, en, init;
    output wire [1:0] cnt2Out;
    
    s2 CounterBit0(
        .D00(1'b0),
        .D01(init),
        .D10(init),
        .D11(1'b0),
        .A1(cnt2Out[0]),
        .B1(1'b0),
        .A0(en),
        .B0(1'b1),
        .clr(clr),
        .clk(clk),
        .out(cnt2Out[0])
    );
    
    s2 CounterBit1(
        .D00(1'b0),
        .D01(init),
        .D10(init),
        .D11(1'b0),
        .A1(cnt2Out[1]),
        .B1(1'b0),
        .A0(cnt2Out[0]),
        .B0(en),
        .clr(clr),
        .clk(clk),
        .out(cnt2Out[1])
    );
endmodule