module RandomGeneratorController(
    clk,
    rst,
    startRnd,
    ldCnt3,
    enCnt3,
    co3,
    shiftP1,
    loadP1,
    doneRnd
);

    input clk, rst, co3, startRnd;
    output reg doneRnd;
    output reg ldCnt3, enCnt3, shiftP1, loadP1;

    localparam [2:0]
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4;

    reg [2:0] ps, ns;

    always @(posedge clk or posedge rst) begin
        if (rst)
            ps = S0;
        else
            ps <= ns;
    end

    always @(*) begin
        {ldCnt3, enCnt3, shiftP1, loadP1, doneRnd} = 5'b0;

        case (ps)
        
            S0: ;

            S1: ;

            S2: {ldCnt3, loadP1} = 2'b11;

            S3: {shiftP1, enCnt3} = 2'b11;

            S4: {doneRnd} = 1'b1;

        endcase
    end


    always @(*) begin
        case (ps)

            S0: ns = startRnd ? S1 : S0;
                
            S1: ns = startRnd ? S1 : S2;

            S2: ns = S3;

            S3: ns = co3 ? S4 : S3;

            S4: ns = S0;

        endcase
    end
endmodule