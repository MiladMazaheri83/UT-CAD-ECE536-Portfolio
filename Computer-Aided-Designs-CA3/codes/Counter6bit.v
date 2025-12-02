module Counter6bit(
    clk,
    clr,
    en,
    init,
    cnt6Out
);
    input wire clk, clr, en, init;
    output wire [5:0] cnt6Out;
    
    wire [4:0] andChain;
    
    assign andChain[0] = en;
    
    genvar i;
    generate
        for (i = 1; i < 5; i = i + 1) begin
            And1bit And1bitBlock(
                .A(andChain[i-1]),
                .B(cnt6Out[i-1]),
                .out(andChain[i])
            );
        end
    endgenerate
    
    s2 CounterBit0(
        .D00(1'b0),
        .D01(init),
        .D10(init),
        .D11(1'b0),
        .A1(cnt6Out[0]),
        .B1(1'b0),
        .A0(en),
        .B0(1'b1),
        .clr(clr),
        .clk(clk),
        .out(cnt6Out[0])
    );
    
    generate
        for (i = 1; i < 6; i = i + 1) begin
            s2 CounterBit(
                .D00(1'b0),
                .D01(init),
                .D10(init),
                .D11(1'b0),
                .A1(cnt6Out[i]),
                .B1(1'b0),
                .A0(cnt6Out[i-1]),
                .B0(andChain[i-1]),
                .clr(clr),
                .clk(clk),
                .out(cnt6Out[i])
            );
        end
    endgenerate
endmodule