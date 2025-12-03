module HashGenerator (
    clk,
    clr,
    inp,
    out,
    aInit,
    bInit,
    cInit,
    dInit,
    start,
    done
);

    input wire clk, clr, start;
    input wire [31:0] inp;
    input wire [7:0] aInit, bInit, cInit, dInit;
    output done;
    output wire [31:0] out;

    wire doneRnd, co2, co6, enM, initCnt6, initReg, hashEn, initCnt2, enF;
    wire enCnt2, sl, addSl, enCnt6, romRead, fSel, startRnd;
    wire [1:0] randIn;
    wire [5:0] cnt6Out;

    HashGeneratorDatapath HG_dp(
        .clk(clk),
        .clr(clr),
        .aInit(aInit),
        .bInit(bInit),
        .cInit(cInit),
        .dInit(dInit),
        .hashEn(hashEn),
        .initReg(initReg),
        .enM(enM),
        .romRead(romRead),
        .initCnt6(initCnt6),
        .enCnt6(enCnt6),
        .enCnt2(enCnt2),
        .initCnt2(initCnt2),
        .enF(enF),
        .addSl(addSl),
        .sl(sl),
        .fSel(fSel),
        .randIn(randIn),
        .inp(inp),
        .out(out),
        .cnt6Out(cnt6Out),
        .co6(co6),
        .co2(co2)
    );


    HashGeneratorController HG_ctl(
        .clk(clk),
        .clr(clr),
        .start(start),
        .enM(enM),
        .initCnt6(initCnt6),
        .initReg(initReg),
        .hashEn(hashEn),
        .startRnd(startRnd),
        .doneRnd(doneRnd),
        .initCnt2(initCnt2),
        .enF(enF),
        .enCnt2(enCnt2),
        .sl(sl),
        .co2(co2),
        .co6(co6),
        .addSl(addSl),
        .enCnt6(enCnt6),
        .done(done),
        .romRead(romRead),
        .fSel(fSel)
    );

    RandomGenerator RG(
        .clk(clk),
        .clr(clr),
        .startRnd(startRnd),
        .doneRnd(doneRnd),
        .inp(cnt6Out),
        .randOut(randIn)
    );
    
endmodule