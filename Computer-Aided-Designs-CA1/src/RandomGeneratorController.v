module RandomGeneratorController(clk, rst, startRnd, ldCnt3, enCnt3, co3, shiftP1, loadP1, doneRnd);
    input clk, rst, co3, startRnd;
    output reg doneRnd;
    output reg ldCnt3, enCnt3, shiftP1, loadP1;

    parameter [2:0] IDLE = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;
    reg [2:0] ps, ns;

    always @(posedge clk, posedge rst) begin
        if (rst)
            ps = IDLE;
        else
            ps <= ns;
    end

    always @(*) begin
        ldCnt3 = 0; enCnt3 = 0; shiftP1 = 0; loadP1 = 0;

        case (ps)
            IDLE: begin
            end

            S1: begin
            end

            S2: begin
                ldCnt3 = 1;
                loadP1 = 1;
            end

            S3: begin
                shiftP1 = 1;
                enCnt3 = 1;
            end

            S4:
                doneRnd = 1;

        endcase
    end


    always @(*) begin
        case (ps)
            IDLE:
                ns = startRnd ? S1 : IDLE;
                
            S1:
                ns = startRnd ? S1 : S2;

            S2:
                ns = S3;

            S3:
                ns = co3 ? S4 : S3;

            S4:
                ns = IDLE;

        endcase
    end
endmodule