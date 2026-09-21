module Counter3bit(
    clk,
    clr,
    en,
    load,
    cnt3Out
);
    input wire clk, clr, en, load;
    output wire [2:0] cnt3Out;
    
    wire enAndQ0;
    wire notLoad;
    
    And1bit And1bitBlock(
        .a(en),
        .b(cnt3Out[0]),
        .out(enAndQ0)
    );

    Not1bit Not1bitBlock(
        .a(load),
        .out(notLoad)
    );
    
    s2 CounterBit0(
        .D00(1'b0),
        .D01(notLoad),
        .D10(notLoad),
        .D11(1'b0),
        .A1(cnt3Out[0]),
        .B1(1'b0),
        .A0(en),
        .B0(1'b1),
        .clr(clr),
        .clk(clk),
        .out(cnt3Out[0])
    );
    
    s2 CounterBit1(
        .D00(load),
        .D01(1'b1),
        .D10(1'b1),
        .D11(load),
        .A1(cnt3Out[1]),
        .B1(1'b0),
        .A0(cnt3Out[0]),
        .B0(en),
        .clr(clr),
        .clk(clk),
        .out(cnt3Out[1])
    );
    
    s2 CounterBit2(
        .D00(1'b0),
        .D01(notLoad),
        .D10(notLoad),
        .D11(1'b0),
        .A1(cnt3Out[2]),
        .B1(1'b0),
        .A0(enAndQ0),
        .B0(cnt3Out[1]),
        .clr(clr),
        .clk(clk),
        .out(cnt3Out[2])
    );
endmodule