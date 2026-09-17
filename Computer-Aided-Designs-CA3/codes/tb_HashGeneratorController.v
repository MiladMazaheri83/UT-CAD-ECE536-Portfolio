`timescale 1ns / 1ps

module tb_HashGeneratorController;

    reg clk;
    reg rst;
    reg start;
    reg doneRnd;
    reg co2;
    reg co6;

    wire enM, initCnt6, initReg, hashEn, startRnd, initCnt2, enF, enCnt2, sl, addSl, enCnt6, done, romRead, fSel;

    HashGeneratorController dut (
        .clk(clk), .rst(rst), .start(start), .doneRnd(doneRnd), .co2(co2), .co6(co6),
        .enM(enM), .initCnt6(initCnt6), .initReg(initReg), .hashEn(hashEn), .startRnd(startRnd),
        .initCnt2(initCnt2), .enF(enF), .enCnt2(enCnt2), .sl(sl), .addSl(addSl), 
        .enCnt6(enCnt6), .done(done), .romRead(romRead), .fSel(fSel)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        start = 0;
        doneRnd = 0;
        co2 = 0;
        co6 = 0;
        #20;
        rst = 0;
        @(posedge clk);

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        wait (dut.startRnd == 1);
        @(posedge clk);
        doneRnd = 1;
        @(posedge clk);
        doneRnd = 0;

        wait (dut.enCnt2 == 1);
        @(posedge clk);
        co2 = 1;
        @(posedge clk);
        co2 = 0;

        wait (dut.enCnt6 == 1);
        @(posedge clk);
        co6 = 1;
        @(posedge clk);
        co6 = 0;
        
        #100;
        $finish;
    end

endmodule
