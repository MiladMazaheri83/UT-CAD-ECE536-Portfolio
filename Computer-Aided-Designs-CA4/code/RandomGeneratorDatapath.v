module RandomGeneratorDatapath(
    clk,
    rst, 
    inp,
    ldCnt3,
    enCnt3,
    co3,
    shiftP1,
    loadP1,
    randNum
);
    input wire clk, rst, ldCnt3, enCnt3, shiftP1, loadP1;
    input wire[5:0] inp;
    output wire [1:0] randNum;
    output wire co3;

    wire sIn;
    wire [2:0] cnt3Out;
    reg [5:0] dataReg;

    Counter3 Cnt3 (
        .clk(clk),
        .rst(rst),
        .load(ldCnt3),
        .enCnt(enCnt3),
        .pin(3'b010),
        .cntOut(cnt3Out),
        .co(co3)
    );


    always @(posedge clk) begin
        if (rst)
            dataReg <= 0;

        else if (loadP1)
            dataReg <= inp;

        else if (shiftP1) begin
            dataReg <= {dataReg[4:0], sIn};
        end
        // hold state
        dataReg <= dataReg;
    end


    assign randNum = dataReg[5:4];
    assign sIn = (dataReg[5] ^ dataReg[3]) ^ dataReg[1];
endmodule