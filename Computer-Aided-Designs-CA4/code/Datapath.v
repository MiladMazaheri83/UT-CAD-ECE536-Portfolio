module HashGeneratorDatapath #(
    parameter SIZE = 16
) (
    clk,
    rst,
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
    localparam WORD = (SIZE / 4);

    input wire clk, rst, hashEn, initReg, enM, romRead, initCnt6, enCnt6, enCnt2, initCnt2;
    input wire enF, addSl, sl, fSel;
    input wire [WORD-1:0] aInit, bInit, cInit, dInit;
    input [1:0] randIn;
    input [SIZE-1:0] inp;
    output [SIZE-1:0] out;
    output [5:0] cnt6Out;
    output wire co6;
    output wire co2;

    wire [WORD-1:0] m00Out, m01Out, m10Out, m11Out, mux1Out, inpA, inpB, inpC, inpD, aOut, bOut, cOut, dOut;
    wire [WORD-1:0] romOut, fOut, mux4Out, rotateOut, mux2Out, mux3Out, muxSlOut, adderOut, fInp;
    wire [WORD*4-1:0] mux1Inp;
    wire [WORD*4-1:0] mux2Inp;
    wire [WORD*4-1:0] mux4Inp;
    wire [WORD*2-1:0] mux3Inp;
    wire [WORD*2-1:0] mux5Inp;
    wire [WORD*2-1:0] mux6Inp;
    wire [WORD*2-1:0] mux7Inp;
    wire [WORD*2-1:0] mux8Inp;
    wire [WORD*2-1:0] muxFInp;
    wire [WORD*2-1:0] muxSlInp;
    wire [1:0] cnt2Out;


    // All constants are stored in a ROM for the calculation of F.
    MemoryBlock #(.WIDTH(WORD), .HEIGHT(64), .FILE_PATH("./src/constant.mem")) Rom(
        .read(romRead),
        .addr(cnt6Out),
        .dataOut(romOut)
    );

    // In this part, we separate the input into four parts and store them in the M_i registers.
    // Register File
    Register #(.SIZE(WORD)) M00(
        .clk(clk),
        .rst(rst),
        .inp(inp[(WORD*4)-1:WORD*3]),
        .out(m00Out),
        .en(enM)
    );

    Register #(.SIZE(WORD)) M01(
        .clk(clk),
        .rst(rst),
        .inp(inp[(WORD*3)-1:WORD*2]),
        .out(m01Out),
        .en(enM)
    );

    Register #(.SIZE(WORD)) M10(
        .clk(clk),
        .rst(rst),
        .inp(inp[(WORD*2)-1:WORD*1]),
        .out(m10Out),
        .en(enM)
    );

    Register #(.SIZE(WORD)) M11(
        .clk(clk),
        .rst(rst),
        .inp(inp[(WORD*1)-1:WORD*0]),
        .out(m11Out),
        .en(enM)
    );

    // This multiplexer selects the word m based on two bits from the random generator module.
    Multiplexer #(.INP_NUMBER(4), .SIZE(WORD)) Mux1(
        .inp(mux1Inp),
        .sel(randIn),
        .out(mux1Out)
    );

    // This counter counts 64 times to run the main for loop.
    Counter #(.SIZE(6)) Cnt6(
        .clk(clk),
        .rst(rst),
        .load(initCnt6),
        .enCnt(enCnt6),
        .pin(6'b0),
        .cntOut(cnt6Out),
        .co(co6)
    );

    // Register F : it use B, C, D and A to update B
    Register #(.SIZE(WORD)) F(
        .clk(clk),
        .rst(rst),
        .inp(fInp),
        .out(fOut),
        .en(enF)
    );

    Multiplexer #(.INP_NUMBER(2), .SIZE(WORD)) Muxf(
        .inp(muxFInp),
        .sel(fSel),
        .out(fInp)    
    );

    // A module that rotates F based on the step selected by the level of the main loop.
    Multiplier #(.WIDTH(WORD)) Multiplier_(
        .dataIn(fOut),
        .index(cnt6Out),
        .dataOut(rotateOut)
    );

    // This counter is used to calculate F = F + A + constant[i] + M[rnd] in four steps.
    Counter #(.SIZE(2)) Cnt2(
        .clk(clk),
        .rst(rst),
        .load(initCnt2),
        .enCnt(enCnt2),
        .pin(2'b0),
        .cntOut(cnt2Out),
        .co(co2)
    );

    // It has four Input: 0: constant[i], 1: M[rnd], 2: 0, 3: A .
    Multiplexer #(.INP_NUMBER(4), .SIZE(WORD)) Mux2(
        .inp(mux2Inp),
        .sel(cnt2Out),
        .out(mux2Out)
    );

    // We need the adder twice — once for F and once for B. We use this multiplexer to achieve that.
    Multiplexer #(.INP_NUMBER(2), .SIZE(WORD)) Mux3(
        .inp(mux3Inp),
        .sel(addSl),
        .out(mux3Out)
    );

    // This multiplexer is used to choose between the Multiplierd to be added with B, or  Mux2 to be added with F.
    Multiplexer #(.INP_NUMBER(2), .SIZE(WORD)) Muxsl(
        .inp(muxSlInp),
        .sel(sl),
        .out(muxSlOut)
    );

    Adder #(.SIZE(WORD)) Adder_(
        .a(mux3Out),
        .b(muxSlOut),
        .out(adderOut)
    );

    // A, B, C, D Registers that always keep hash value.
    Register #(WORD) A(
        .clk(clk),
        .rst(rst),
        .inp(inpA),
        .out(aOut),
        .en(hashEn)
    );

    Register #(WORD) B(
        .clk(clk),
        .rst(rst),
        .inp(inpB),
        .out(bOut),
        .en(hashEn)
    );

    Register #(WORD) C(
        .clk(clk),
        .rst(rst),
        .inp(inpC),
        .out(cOut),
        .en(hashEn)
    );

    Register #(WORD) D(
        .clk(clk),
        .rst(rst),
        .inp(inpD),
        .out(dOut),
        .en(hashEn)
    );

    // This multiplexer select which logic will update the F register.
    Multiplexer #(.INP_NUMBER(4), .SIZE(WORD)) Mux4(
        .inp(mux4Inp),
        .sel(cnt6Out[5:4]),
        .out(mux4Out)
    );

    // These multiplexers select between the initial value and the updated value of A, B, C, D.
    Multiplexer #(.INP_NUMBER(2), .SIZE(WORD)) Mux5(
        .inp(mux5Inp),
        .sel(initReg),
        .out(inpA)    
    );

    Multiplexer #(.INP_NUMBER(2), .SIZE(WORD)) Mux6(
        .inp(mux6Inp),
        .sel(initReg),
        .out(inpB)
    );

    Multiplexer #(.INP_NUMBER(2), .SIZE(WORD)) Mux7(
        .inp(mux7Inp),
        .sel(initReg),
        .out(inpC)
    );

    Multiplexer #(.INP_NUMBER(2), .SIZE(WORD)) Mux8(
        .inp(mux8Inp),
        .sel(initReg),
        .out(inpD)
    );


    assign mux1Inp = {m11Out, m10Out, m01Out, m00Out};

    assign mux2Inp = {aOut, {WORD{1'b0}}, mux1Out, romOut};

    assign mux3Inp = {rotateOut, mux2Out};

    // Logical gates definition
    assign mux4Inp = {(cOut ^ (bOut | (~dOut))), (bOut ^ cOut ^ dOut), ((dOut & bOut) | ((~dOut) & cOut)), ((bOut & cOut) | ((~bOut) & dOut))};

    assign mux5Inp = {aInit, dOut};

    assign mux6Inp = {bInit, adderOut};

    assign mux7Inp = {cInit, bOut};

    assign mux8Inp = {dInit, cOut};

    assign muxSlInp = {bOut, fOut};

    assign muxFInp = {adderOut, mux4Out};

    // Concat A, B, C, D to produce Hash value of Input
    assign out = {aOut,bOut,cOut,dOut};

endmodule