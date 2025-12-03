`timescale 1ns / 1ps

module tb_RandomGeneratorController;

    reg clk;
    reg rst;
    reg start_rnd;
    reg co3;

    wire ldCnt3;
    wire enCnt3;
    wire shiftP1;
    wire loadP1;
    wire done_rnd;

    RandomGeneratorController dut (
        .clk(clk),
        .rst(rst),
        .start_rnd(start_rnd),
        .co3(co3),
        .ldCnt3(ldCnt3),
        .enCnt3(enCnt3),
        .shiftP1(shiftP1),
        .loadP1(loadP1),
        .done_rnd(done_rnd)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        start_rnd = 0;
        co3 = 0;
        

        #20;

        rst = 0;
        #20;

        @(negedge clk);
        start_rnd = 1;
        @(negedge clk);
        start_rnd = 0;

        #50;

        
        @(negedge clk);
        co3 = 1;
        @(negedge clk);
        co3 = 0;

        #50;

        @(negedge clk);
        start_rnd = 1;
        @(negedge clk);
        start_rnd = 0;

        #70;

        @(negedge clk);
        co3 = 1;
        @(negedge clk);
        co3 = 0;

        #50;

        $finish;
    end

endmodule
