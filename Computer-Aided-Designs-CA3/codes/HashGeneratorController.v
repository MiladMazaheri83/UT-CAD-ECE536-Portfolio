module HashGeneratorController (
    clk,
    clr,
    start,
    enM,
    initCnt6,
    initReg,
    hashEn,
    startRnd,
    doneRnd,
    initCnt2,
    enF,
    enCnt2,
    sl,
    co2,
    co6,
    addSl,
    enCnt6,
    done,
    romRead,
    fSel
);

    input clk, clr, start, doneRnd, co2, co6;
    output wire enCnt6, done, romRead, fSel, startRnd;
    output wire enM, initCnt6, initReg, hashEn, initCnt2, enF, enCnt2, sl, addSl;

    wire S000Out, S001Out, S010Out, S011Out, S100Out, S101Out;
    wire S000in0, S000in1;
    wire S001in0, S001in1;
    wire S010in0, S010in1;
    wire S011in0;
    wire S100in0, S100in1;
    wire S101in0;
    wire S0;

    s2 S000 (
        .D00(1'b1),
        .D01(1'b0),
        .D10(1'b0),
        .D11(1'b0),
        .A1(S000in0),
        .B1(1'b0),
        .A0(S000in1),
        .B0(1'b1),
        .clr(clr),
        .clk(clk),
        .out(S0)
    );

    s2 S001 (
        .D00(1'b0),
        .D01(1'b1),
        .D10(1'b1),
        .D11(1'b1),
        .A1(S001in0),
        .B1(1'b0),
        .A0(S001in1),
        .B0(1'b1),
        .clr(clr),
        .clk(clk),
        .out(S001Out)
    );

    s2 S010 (
        .D00(1'b0),
        .D01(1'b1),
        .D10(1'b1),
        .D11(1'b1),
        .A1(S010in0),
        .B1(1'b0),
        .A0(S010in1),
        .B0(1'b1),
        .clr(clr),
        .clk(clk),
        .out(S010Out)
    );

    s2 S011 (
        .D00(1'b0),
        .D01(1'b1),
        .D10(1'b1),
        .D11(1'b1),
        .A1(S010Out),
        .B1(1'b0),
        .A0(S011in0),
        .B0(1'b1),
        .clr(clr),
        .clk(clk),
        .out(S011Out)
    );

    s2 S100 (
        .D00(1'b0),
        .D01(1'b1),
        .D10(1'b1),
        .D11(1'b1),
        .A1(S100in0),
        .B1(1'b0),
        .A0(S100in1),
        .B0(1'b1),
        .clr(clr),
        .clk(clk),
        .out(S100Out)
    );

    s2 S101 (
        .D00(1'b0),
        .D01(1'b1),
        .D10(1'b1),
        .D11(1'b1),
        .A1(S101in0),
        .B1(1'b0),
        .A0(1'b0),
        .B0(1'b1),
        .clr(clr),
        .clk(clk),
        .out(S101Out)
    );

    Not1bit notS000 (
        .a(S0),
        .out(S000Out)
    );

    And1bit And1 (
        .a(start),
        .b(S000Out),
        .out(S001in1)
    );

    And1bit And2 (
        .a(start),
        .b(S001Out),
        .out(S001in0)
    );

    And1bit And3 (
        .a(doneRnd),
        .b(S011Out),
        .out(S100in0)
    );

    And1bit And4 (
        .a(co2),
        .b(S100Out),
        .out(S101in0)
    );

    And1bit And5 (
        .a(co6),
        .b(S101Out),
        .out(S000in1)
    ); //

    And1bitBubble And1b (
        .abubble(start),
        .b(S000Out),
        .out(S000in0)
    ); //

    And1bitBubble And2b (
        .abubble(start),
        .b(S001Out),
        .out(S010in0)
    );

    And1bitBubble And3b (
        .abubble(doneRnd),
        .b(S011Out),
        .out(S011in0)
    );

    And1bitBubble And4b (
        .abubble(co2),
        .b(S100Out),
        .out(S100in1)
    );

    And1bitBubble And5b (
        .abubble(co6),
        .b(S101Out),
        .out(S010in1)
    );

    Or1bit Or1 (
        .a(S100in0),
        .b(S100Out),
        .out(enF)
    );

    Or1bit Or2 (
        .a(S010in0),
        .b(S101Out),
        .out(hashEn)
    );

    Not1bit notInitCnt6 (
        .a(S010in0),
        .out(initCnt6)
    );

    Not1bit notInitCnt2 (
        .a(S100in0),
        .out(initCnt2)
    );

    assign enM = S010in0;
    assign initReg = S010in0;
    assign startRnd = S010Out;
    assign enCnt2 = S100Out;
    assign fSel = S100Out;
    assign romRead = S100Out;
    assign sl = S101Out;
    assign addSl = S101Out;
    assign enCnt6 = S101Out;
    assign done = S000in1;

endmodule