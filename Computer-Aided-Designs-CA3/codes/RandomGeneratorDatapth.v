module RandomGeneratorDatapath(
    clk,
    clr, 
    inp,
    ldCnt3,
    enCnt3,
    co3,
    shiftP1,
    loadP1,
    randNum
);
    input wire clk, clr, ldCnt3, enCnt3, shiftP1, loadP1;
    input wire[5:0] inp;
    output wire [1:0] randNum;
    output wire co3;

    wire sIn;
    wire [2:0] cnt3Out;
    wire [5:0] dataReg;

    Counter3bit Counter3bitBlock(
        .clk(clk),
        .clr(clr),
        .en(enCnt3),
        .load(ldCnt3),
        .cnt3Out(cnt3Out)
    );

    ShiftRegister6bit ShiftRegisterBlock(
        .clk(clk),
        .clr(clr),
        .serIn(sIn),
        .en(shiftP1),
        .loadData(inp),
        .load(loadP1),
        .out(dataReg)
    );

    Xor3 Xor3Block(
        .a(dataReg[5]),
        .b(dataReg[3]),
        .c(dataReg[1]),
        .out(sIn)
    );

    And3 And3Block(
        .a(cnt3Out[0]),
        .b(cnt3Out[1]),
        .c(cnt3Out[2]),
        .out(co3)
    );

    assign randNum = dataReg[5:4];
endmodule