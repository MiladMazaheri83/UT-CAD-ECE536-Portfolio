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
    reg [5:0] dataReg;

    Counter3bit Counter3bitBlock(
        .clk(clk),
        .clr(clr),
        .en(enCnt3),
        .load(ldCnt3),
        .cnt3Out(cnt3Out)
    );


    always @(posedge clk, posedge clr) begin
        if (clr)
            dataReg <= 0;

        else if (loadP1)
            dataReg <= inp;

        else if (shiftP1) begin
            dataReg <= {dataReg[4:0], sIn};
        end
    end


    assign randNum = dataReg[5:4];
    assign sIn = (dataReg[5] ^ dataReg[3]) ^ dataReg[1];
endmodule