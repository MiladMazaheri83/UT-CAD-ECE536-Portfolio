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


    always @(posedge clk) begin
        // change to synchronous reset because of _DFFE_PP0P_ library cells and change to use DFFE
        if (rst)
            ps <= S0;
        else
            ps <= ns;
    end

    // Control signal generation removed bus assignments and add posedge clk only
    always @(posedge clk) begin
            enM       <= 1'b0;
            initCnt6  <= 1'b0;
            initReg   <= 1'b0;
            hashEn    <= 1'b0;
            initCnt2  <= 1'b0;
            enF       <= 1'b0;
            enCnt2    <= 1'b0;
            sl        <= 1'b0;
            addSl     <= 1'b0;
            enCnt6    <= 1'b0;
            done      <= 1'b0;
            romRead   <= 1'b0;
            fSel      <= 1'b0;
            startRnd  <= 1'b0;

            case (ns)
                S2: begin
                    enM      <= 1'b1;
                    initCnt6 <= 1'b1;
                end
                S3: begin
                    initReg <= 1'b1;
                    hashEn  <= 1'b1;
                end
                S4: begin
                    startRnd <= 1'b1;
                end
                S6: begin
                    initCnt2 <= 1'b1;
                    enF      <= 1'b1;
                end
                S7: begin
                    enF     <= 1'b1;
                    fSel    <= 1'b1;
                    enCnt2  <= 1'b1;
                    romRead <= 1'b1;
                end
                S8: begin
                    sl      <= 1'b1;
                    addSl   <= 1'b1;
                    enCnt6  <= 1'b1;
                    hashEn  <= 1'b1;
                end
                S9: begin
                    done <= 1'b1;
                end
            endcase
        end



    always @(*) begin
        // Default next state is current state to avoid latches
        ns = ps;
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

            // add default case to avoid latches
            default: ns = S0;

        endcase
    end
endmodule