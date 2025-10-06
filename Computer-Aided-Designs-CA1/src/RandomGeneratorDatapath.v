`include "../lib/lib.v"

module RandomGeneratorDatapath(clk, rst, inp, ldCnt3, enCnt3, co3, shiftP1, loadP1, randNum);
    input clk, rst, ldCnt3, enCnt3, shiftP1, loadP1;
    input [5:0] inp;
    output co3;
    output [1:0] randNum;

    wire x;
    reg [5:0] dataReg;

    Counter #3 Cnt3(clk, rst, ldCnt3, enCnt3, 3'b001, cnt3Out, co3);


    always @(posedge clk, posedge rst) begin
        if (rst)
            dataReg <= 0;

        else if (loadP1)
            dataReg <= inp;

        else if (shiftP1) begin
            dataReg <= {dataReg[4:0], x};
        end
    end


    assign randNum = dataReg[5:4];
    assign x = (dataReg[5] ^ dataReg[3]) ^ dataReg[1];
endmodule