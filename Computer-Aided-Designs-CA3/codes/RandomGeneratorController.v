module RandomGeneratorController (
    clk,
    rst,
    start_rnd,
    done_rnd,
    co3,
    ldCnt3,
    enCnt3,
    shiftP1,
    loadP1
);

    input wire clk, rst, start_rnd, co3;
    output wire ldCnt3, enCnt3, shiftP1, loadP1, done_rnd;
    wire S00Out, S01Out, S10Out;
    wire S00in0, S00in1;
    wire S01in0, S01in1;
    wire S10in0, S10in1;
    wire S0;

    s2 S00 (
        .D00(1'b1),
        .D01(1'b0),
        .D10(1'b0),
        .D11(1'b0),
        .A1(S00in0),
        .B1(1'b0),
        .A0(S00in1),
        .B0(1'b1),
        .clr(rst),
        .clk(clk),
        .out(S0)
    );

    s2 S01 (
        .D00(1'b0),
        .D01(1'b1),
        .D10(1'b1),
        .D11(1'b1),
        .A1(S01in0),
        .B1(1'b0),
        .A0(S01in1),
        .B0(1'b1),
        .clr(rst),
        .clk(clk),
        .out(S01Out)
    );

    s2 S10 (
        .D00(1'b0),
        .D01(1'b1),
        .D10(1'b1),
        .D11(1'b1),
        .A1(S10in0),
        .B1(1'b0),
        .A0(S10in1),
        .B0(1'b1),
        .clr(rst),
        .clk(clk),
        .out(S10Out)
    );

    Not1bit notS00 (
        .a(S0),
        .out(S00Out)
    );

    And1bit And1 (
        .a(start_rnd),
        .b(S00Out),
        .out(S01in0)
    );

    And1bit And2 (
        .a(start_rnd),
        .b(S01Out),
        .out(S01in1)
    );
    
    And1bit And3 (
        .a(co3),
        .b(S10Out),
        .out(S00in1)
    );

    And1bitBubble And1b (
        .abubble(start_rnd),
        .b(S00Out),
        .out(S00in0)
    );

    And1bitBubble And2b (
        .abubble(start_rnd),
        .b(S01Out),
        .out(S10in0)
    );

    And1bitBubble And3b (
        .abubble(co3),
        .b(S10Out),
        .out(S10in1)
    );

    assign done_rnd = S00in1;
    assign shiftP1 = S10Out;
    assign loadP1 = S10in0;
    assign enCnt3 = S10Out;
    assign ldCnt3 = S10in0;

endmodule