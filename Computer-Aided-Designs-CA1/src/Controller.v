module Controller(clk, rst, start, enM, initCnt6, initReg, hashEn, startRnd, 
            doneRnd, initCnt2, enF, enCnt2, sl, co2, co6, addsl, enCnt6, 
            done, romRead, fSel, startRnd);
    
    input clk, rst, start, doneRnd, co2, co6;

    output reg enM, initCnt6, initReg, hashEn, initCnt2, enF, enCnt2, sl, addsl, 
            enCnt6, done, romRead, fSel, startRnd;

    parameter [3:0] IDLE = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9;
    reg [3:0] ps, ns;


    always @(posedge clk, posedge rst) begin
        if (rst)
            ps = IDLE;
        else
            ps <= ns;
        
    end


    always @(*) begin
        enM = 0; initCnt6 = 0; initReg = 0; hashEn = 0; initCnt2 = 0; enF = 0; enCnt2 = 0; sl = 0;
        addsl = 0; enCnt6 = 0; done = 0; romRead = 0; fSel = 0; startRnd = 1;

        case (ps)
            IDLE: begin
            end

            S1: begin
            end

            S2: begin
                enM = 1;
                initCnt6 = 1;
            end

            S3: begin
                initReg = 1;
                hashEn = 1;
            end

            S4:
                startRnd = 1;

            S5: begin
            end

            S6: begin
                initCnt2 = 1;
                enF = 1;
            end

            S7: begin
                enF = 1;
                fSel = 1;
                enCnt2 = 1;
            end

            S8: begin
                sl = 1;
                addsl = 1;
                enCnt6 = 1;
                hashEn = 1;
            end

            S9:
                done = 1;

        endcase
    end


    always @(*) begin
        case (ps)
            IDLE:
                ns = start ? S1 : IDLE;
                
            S1:
                ns = start ? S1 : S2;

            S2:
                ns = S3;

            S3:
                ns = S4;

            S4:
                ns = S5;

            S5:
                ns = doneRnd ? S6 : S5;

            S6:
                ns = S7;

            S7:
                ns = co2 ? S8 : S7;

            S8:
                ns = co6 ? S9 : S4;

            S9:
                ns = IDLE;
                
        endcase
    end
endmodule