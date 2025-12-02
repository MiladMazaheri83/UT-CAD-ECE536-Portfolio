module Counter3bit(
    clk,
    clr,
    en,
    init,
    cnt3Out
);
    input wire clk, clr, en, init;
    output wire [2:0] cnt3Out;
    
    wire [2:0] andChain; 
    
    assign andChain[0] = en;
    
    And1bit And(
        .A(en),
        .B(cnt3Out[0]),
        .out(andChain[1])
    );
    
    s2 CounterBit0(
        .D00(1'b0),
        .D01(init),
        .D10(init),
        .D11(1'b0),
        .A1(cnt3Out[0]),
        .B1(1'b0),
        .A0(en),
        .B0(1'b1),
        .clr(clr),
        .clk(clk),
        .out(cnt3Out[0])
    );
    
    genvar i;
    generate
        for (i = 1; i < 3; i = i + 1) begin
            s2 CounterBit(
                .D00(1'b0),
                .D01(init),
                .D10(init),
                .D11(1'b0),
                .A1(cnt3Out[i]),
                .B1(1'b0),
                .A0(cnt3Out[i-1]),
                .B0(andChain[i-1]),
                .clr(clr),
                .clk(clk),
                .out(cnt3Out[i])
            );
        end
    endgenerate
endmodule