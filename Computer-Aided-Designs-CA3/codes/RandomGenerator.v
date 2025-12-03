module RandomGenerator(
    clk,
    clr,
    startRnd,
    doneRnd,
    inp,
    randOut
);
    input clk, clr, startRnd;
    input [5:0] inp;
    output doneRnd;
    output [1:0] randOut;

    wire ldCnt3, enCnt3, co3, shiftP1, loadP1;
    
    RandomGeneratorDatapath RG_dp(
        .clk(clk),
        .clr(clr), 
        .inp(inp),
        .ldCnt3(ldCnt3),
        .enCnt3(enCnt3),
        .co3(co3),
        .shiftP1(shiftP1),
        .loadP1(loadP1),
        .randNum(randOut)
    );

    RandomGeneratorController RG_ctl(
        .clk(clk),
        .clr(clr),
        .startRnd(startRnd),
        .ldCnt3(ldCnt3),
        .enCnt3(enCnt3),
        .co3(co3),
        .shiftP1(shiftP1),
        .loadP1(loadP1),
        .doneRnd(doneRnd)
    );
    
endmodule