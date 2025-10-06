module RandomGenerator(clk, rst, startRnd, doneRnd, inp, randOut);
    input clk, rst, startRnd;
    input [5:0] inp;
    output doneRnd;
    output [1:0] randOut;

    wire ldCnt3, enCnt3, co3, shiftP1, loadP1;
    
    RandomGeneratorDatapath RGDatapath(clk, rst, inp, ldCnt3, enCnt3, co3, shiftP1, loadP1, randOut);

    RandomGeneratorController RGController(clk, rst, startRnd, ldCnt3, enCnt3, co3, shiftP1, loadP1, doneRnd);
    
endmodule