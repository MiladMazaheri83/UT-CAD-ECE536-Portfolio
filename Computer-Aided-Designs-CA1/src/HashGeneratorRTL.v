module Top(clk, rst, inp, out, start, done);
    input clk, rst, start;
    input [127:0] inp;
    output done;
    output [127:0] out;

    wire doneRnd, co2, co3, co6, enM, initCnt6, initReg, hashEn, initCnt2, enF, 
            enCnt2, sl, addsl, enCnt6, romRead, fSel, startRnd, ldCnt3, enCnt3;
    wire [1:0] randIn;

    Datapath TopDatapath(clk, rst, inp, randIn, out, hashEn, enM, romRead, initCnt6, enCnt6, 
                co6, enF, addsl, sl, fSel);
    
    Controller TopController(clk, rst, start, enM, initCnt6, initReg, hashEn, startRnd, 
            doneRnd, initCnt2, enF, enCnt2, sl, co2, co6, addsl, enCnt6, 
            done, romRead, fSel, startRnd);

    
endmodule