module HashGeneratorController (
    clk,
    rst,
    start,
    enM,
    initCnt6,
    initReg,
    hashEn,
    startRnd,
    doneRnd,
    initCnt2,
    enF,
    enCnt2,
    sl,
    co2,
    co6,
    addSl,
    enCnt6,
    done,
    romRead,
    fSel
);
    
    input clk, rst, start, doneRnd, co2, co6;
    output reg enCnt6, done, romRead, fSel, startRnd;
    output reg enM, initCnt6, initReg, hashEn, initCnt2, enF, enCnt2, sl, addSl;
    localparam [3:0] 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4,
        S5 = 5,
        S6 = 6,
        S7 = 7,
        S8 = 8,
        S9 = 9;

    reg [3:0] ps, ns;


    always @(posedge clk or posedge rst) begin
        if (rst)
            ps = S0;
        else
            ps <= ns;
        
    end


    always @(*) begin
        {enM, initCnt6, initReg, hashEn, initCnt2, enF, enCnt2, sl,
        addSl, enCnt6, done, romRead, fSel, startRnd} = 14'b0;

        case (ps)
            S0: ;

            S1: ;

            S2: {enM ,initCnt6} = 2'b11;

            S3: {initReg, hashEn} = 2'b11;

            S4: {startRnd} = 1'b1;

            S5: ;

            S6: {initCnt2, enF} = 2'b11;

            S7: {enF, fSel, enCnt2, romRead} = 4'b1111;

            S8: {sl, addSl, enCnt6, hashEn} = 4'b1111;

            S9: {done} = 1'b1;

        endcase
    end


    always @(*) begin
        case (ps)
            S0: ns = start ? S1 : S0;
                
            S1: ns = start ? S1 : S2;

            S2: ns = S3;

            S3: ns = S4;

            S4: ns = S5;

            S5: ns = doneRnd ? S6 : S5;

            S6: ns = S7;

            S7: ns = co2 ? S8 : S7;

            S8: ns = co6 ? S9 : S4;

            S9: ns = S0;

        endcase
    end
endmodule