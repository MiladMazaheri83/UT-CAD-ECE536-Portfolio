`include "../lib/lib.v"


module Datapath(clk, rst, inp, randIn, out, hashEn, enM, romRead, initCnt6, enCnt6, 
                co6, co2, enF, addsl, sl, fSel);

    input clk, rst, hashEn, enM, romRead, initCnt6, enCnt6, enF, 
                addsl, sl, fSel;
    input [1:0] randIn;
    input [127:0] inp;

    output [127:0] out;
    output co6, co2;

    wire [31:0] m00Out, m01Out, m10Out, m11Out, mux1Out, inpA, inpB, inpC, inpD, aOut, bOut, cOut, dOut,
                 romOut, fOut, mux4Out, rotateOut, mux2Out, mux3Out, muxslOut, adderOut, fInp; 
    wire [31:0] mux1Inp [0:3];
    wire [31:0] mux2Inp [0:3];
    wire [31:0] mux3Inp [0:1];
    wire [31:0] mux4Inp [0:3];
    wire [31:0] mux5Inp [0:1];
    wire [31:0] mux6Inp [0:1];
    wire [31:0] mux7Inp [0:1];
    wire [31:0] mux8Inp [0:1];
    wire [31:0] muxslInp [0:1];
    wire [31:0] muxfInp [0:1];
    wire [5:0] cnt6Out;
    wire [1:0] cnt2Out;


    Register #32 M00(clk, rst, inp[31:0], m00Out, enM);
    Register #32 M01(clk, rst, inp[63:32], m01Out, enM);
    Register #32 M10(clk, rst, inp[95:64], m10Out, enM);
    Register #32 M11(clk, rst, inp[127:96], m11Out, enM);

    MemoryBlock #(.WIDTH(32), .HEIGHT(64), .FILE_PATH("../data/constant.mem")) Rom(clk, romRead, cnt6Out, romOut);
    Mux #(4, 32) Mux1(mux1Inp, randIn, mux1Out);

    Counter #6 Cnt6(clk, rst, initCnt6, enCnt6, 0, cnt6Out, co6);
    Register #32 F(clk, rst, fInp, fOut, enF);
    Mux #(2, 32) Muxf(muxfInp, fSel, fInp);

    LeftRotate #32 LeftRotate_(fOut, rotateOut, cnt6Out);
    Counter #2 Cnt2(clk, rst, initCnt2, enCnt2, 0, cnt2Out, co2);
    Mux #(4, 32) Mux2(mux2Inp, cnt2Out, mux2Out);

    Mux #(2, 32) Mux3(mux3Inp, addsl, mux3Out);
    Mux #(2, 32) Muxsl(muxslInp, sl, muxslOut)
    Adder #32 Adder_(mux3Out, muxslOut, adderOut);

    Register #32 A(clk, rst, inpA, aOut, hashEn);
    Register #32 B(clk, rst, inpB, bOut, hashEn);
    Register #32 C(clk, rst, inpC, cOut, hashEn);
    Register #32 D(clk, rst, inpD, dOut, hashEn);

    Mux #(4, 32) Mux4(mux4Inp, cnt6Out[5:4], mux4Out);

    Mux #(2, 32) Mux5(mux5Inp, initReg, inpA);
    Mux #(2, 32) Mux6(mux6Inp, initReg, inpB);
    Mux #(2, 32) Mux7(mux7Inp, initReg, inpC);
    Mux #(2, 32) Mux8(mux8Inp, initReg, inpD);


    assign mux1Inp[0] = m00Out;
    assign mux1Inp[1] = m01Out;
    assign mux1Inp[2] = m10Out;
    assign mux1Inp[3] = m11Out;

    assign mux2Inp[0] = romOut;
    assign mux2Inp[1] = mux1Out;
    assign mux2Inp[2] = 0;
    assign mux2Inp[3] = aOut;

    assign mux3Inp[0] = mux2Out;
    assign mux3Inp[1] = rotateOut;

    assign mux4Inp[0] = (bOut & cOut) | ((~bOut) & dOut);
    assign mux4Inp[1] = (dOut & bOut) | ((~dOut) & cOut);
    assign mux4Inp[2] = bOut ^ cOut ^ dOut;
    assign mux4Inp[3] = cOut ^ (bOut | (~dOut));

    assign mux5Inp[0] = m11Out;
    assign mux5Inp[1] = dOut;

    assign mux6Inp[0] = m10Out;
    assign mux6Inp[1] = adderOut;

    assign mux7Inp[0] = m01Out;
    assign mux7Inp[1] = bOut;

    assign mux8Inp[0] = m00Out;
    assign mux8Inp[1] = cOut;

    assign muxslInp[0] = fOut;
    assign muxslInp[1] = bOut;

    assign muxfInp[0] = mux4Out;
    assign muxfInp[1] = adderOut;

endmodule