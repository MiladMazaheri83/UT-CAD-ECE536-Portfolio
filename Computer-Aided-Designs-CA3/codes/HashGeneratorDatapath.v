module HashGeneratorDatapath(
    clk,
    clr,
    aInit,
    bInit,
    cInit,
    dInit,
    hashEn,
    initReg,
    enM,
    romRead,
    initCnt6,
    enCnt6,
    enCnt2,
    initCnt2,
    enF,
    addSl,
    sl,
    fSel,
    randIn,
    inp,
    out,
    cnt6Out,
    co6,
    co2
);
    input wire clk, clr, hashEn, initReg, enM, romRead, initCnt6, enCnt6, enCnt2, initCnt2;
    input wire enF, addSl, sl, fSel;
    input wire [7:0] aInit, bInit, cInit, dInit;
    input [1:0] randIn;
    input [31:0] inp;
    output [31:0] out;
    output [5:0] cnt6Out;
    output wire co6;
    output wire co2;

    wire [7:0] m00Out, m01Out, m10Out, m11Out, mux1Out, aOut, bOut, cOut, dOut, notD;
    wire [7:0] romOut, fOut, mux4Out, mux2Out, mux3Out, muxSlOut, adderOut, multOut;
    wire [31:0] mux4Inp;
    wire [1:0] cnt2Out;
    wire co6And, enFin;


    MemoryBlock #(.WIDTH(8), .HEIGHT(64), .FILE_PATH("k.mem")) Rom(
        .read(romRead),
        .addr(cnt6Out),
        .dataOut(romOut),
        .write(1'b0),
        .dataIn()
    );

    NormalRegister M00(
        .clk(clk),
        .clr(clr),
        .dataIn(inp[31:24]),
        .en(enM),
        .out(m00Out)
    );

    NormalRegister M01(
        .clk(clk),
        .clr(clr),
        .dataIn(inp[23:16]),
        .en(enM),
        .out(m01Out)
    );

    NormalRegister M10(
        .clk(clk),
        .clr(clr),
        .dataIn(inp[15:8]),
        .en(enM),
        .out(m10Out)
    );

    NormalRegister M11(
        .clk(clk),
        .clr(clr),
        .dataIn(inp[7:0]),
        .en(enM),
        .out(m11Out)
    );

    Mux4to1 Mux1(
        .s0(randIn[0]),
        .s1(randIn[1]),
        .d00(m00Out),
        .d01(m01Out),
        .d10(m10Out),
        .d11(m11Out),
        .out(mux1Out)
    );

    Counter6bit Cnt6(
        .clk(clk),
        .clr(clr),
        .en(enCnt6),
        .init(initCnt6),
        .cnt6Out(cnt6Out)
    );

    And4 And4Block(
        .a(cnt6Out[0]),
        .b(cnt6Out[1]),
        .c(cnt6Out[2]),
        .d(cnt6Out[3]),
        .out(co6And)
    );

    And3 And3Block(
        .a(cnt6Out[4]),
        .b(cnt6Out[5]),
        .c(co6And),
        .out(co6)
    );

    Mux4to1 Mux4(
        .s0(cnt6Out[4]),
        .s1(cnt6Out[5]),
        .d00(mux4Inp[7:0]),
        .d01(mux4Inp[15:8]),
        .d10(mux4Inp[23:16]),
        .d11(mux4Inp[31:24]),
        .out(mux4Out)
    );

    c1 enf(
        .A0(1'b1),
        .A1(1'b0),
        .SA(fSel),
        .B0(1'b1),
        .B1(1'b1),
        .SB(fSel),
        .S0(cnt2Out[0]),
        .S1(cnt2Out[1]),
        .f(enFin)
    );

    LoadRegister FRegister(
        .clk(clk),
        .clr(clr),
        .dataIn(mux4Out),
        .en(fSel),
        .loadData(adderOut),
        .load(enFin),
        .out(fOut)
    );

    Mul4to4 MultiplierBlock(
        .A(fOut[3:0]),
        .B(fOut[7:4]),
        .out(multOut)
    );

    Counter2bit Cnt2(
        .clk(clk),
        .clr(clr),
        .en(enCnt2),
        .init(initCnt2),
        .cnt2Out(cnt2Out)
    );

    And1bit Co2Block(
        .a(cnt2Out[0]),
        .b(cnt2Out[1]),
        .out(co2)
    );

    Mux4to1 Mux2(
        .s0(cnt2Out[0]),
        .s1(cnt2Out[1]),
        .d00(multOut),
        .d01(romOut),
        .d10(mux1Out),
        .d11(aOut),
        .out(mux2Out)
    );

    Mux4to1 Muxsl(
        .s0(1'b0),
        .s1(sl),
        .d00(fOut),
        .d01(8'b00000000),
        .d10(bOut),
        .d11(8'b00000000),
        .out(muxSlOut)
    );

    RippleCarryAdder8bit AdderBlock(
        .A(mux2Out),
        .B(muxSlOut),
        .SUM(adderOut)
    );

    LoadRegister ARegister(
        .clk(clk),
        .clr(clr),
        .dataIn(dOut),
        .en(hashEn),
        .loadData(aInit),
        .load(initReg),
        .out(aOut)
    );

    LoadRegister BRegister(
        .clk(clk),
        .clr(clr),
        .dataIn(adderOut),
        .en(hashEn),
        .loadData(bInit),
        .load(initReg),
        .out(bOut)
    );

    LoadRegister CRegister(
        .clk(clk),
        .clr(clr),
        .dataIn(bOut),
        .en(hashEn),
        .loadData(cInit),
        .load(initReg),
        .out(cOut)
    );

    LoadRegister DRegister(
        .clk(clk),
        .clr(clr),
        .dataIn(cOut),
        .en(hashEn),
        .loadData(dInit),
        .load(initReg),
        .out(dOut)
    );

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            c1 Mux4Inp00Block(
                .A0(dOut[i]),
                .A1(1'b0),
                .SA(bOut[i]),
                .B0(dOut[i]),
                .B1(1'b1),
                .SB(bOut[i]),
                .S0(cOut[i]),
                .S1(1'b0),
                .f(mux4Inp[i])
            );

            c1 Mux4Inp01Block(
                .A0(cOut[i]),
                .A1(1'b0),
                .SA(dOut[i]),
                .B0(cOut[i]),
                .B1(1'b1),
                .SB(dOut[i]),
                .S0(bOut[i]),
                .S1(1'b0),
                .f(mux4Inp[i + 8])
            );

            Not1bit NotDBlock(
                .a(dOut[i]),
                .out(notD[i])
            );

            c1 Mux4Inp10Block(
                .A0(dOut[i]),
                .A1(notD[i]),
                .SA(bOut[i]),
                .B0(notD[i]),
                .B1(dOut[i]),
                .SB(bOut[i]),
                .S0(cOut[i]),
                .S1(1'b0),
                .f(mux4Inp[i + 16])
            );

            c1 Mux4Inp11Block(
                .A0(1'b0),
                .A1(1'b1),
                .SA(cOut[i]),
                .B0(1'b1),
                .B1(1'b0),
                .SB(cOut[i]),
                .S0(notD[i]),
                .S1(bOut[i]),
                .f(mux4Inp[i + 24])
            );
        end
    endgenerate

    assign out = {aOut,bOut,cOut,dOut};

endmodule