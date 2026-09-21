`timescale 1ns / 1ps

module tb_RandomGeneratorController;

    reg clk;
    reg clr;
    reg startRnd;
    reg co3;

    wire ldCnt3;
    wire enCnt3;
    wire shiftP1;
    wire loadP1;
    wire doneRnd;

    RandomGeneratorController dut (
        .clk(clk),
        .clr(clr),
        .startRnd(startRnd),
        .co3(co3),
        .ldCnt3(ldCnt3),
        .enCnt3(enCnt3),
        .shiftP1(shiftP1),
        .loadP1(loadP1),
        .doneRnd(doneRnd)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        clr = 1;
        startRnd = 0;
        co3 = 0;
        

        #20;

        clr = 0;
        #20;

        @(negedge clk);
        startRnd = 1;
        @(negedge clk);
        startRnd = 0;

        #50;

        
        @(negedge clk);
        co3 = 1;
        @(negedge clk);
        co3 = 0;

        #50;

        @(negedge clk);
        startRnd = 1;
        @(negedge clk);
        startRnd = 0;

        #70;

        @(negedge clk);
        co3 = 1;
        @(negedge clk);
        co3 = 0;

        #50;

        $finish;
    end

endmodule
