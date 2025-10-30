module MmpuController (
    clk,
    rst,
    start,
    done,
    bEn,
    aEn,
    loadA,
    shiftA,
    initZero,
    iIsMsb,
    iIsLsb1,
    iIsLsb2,
    iValid1,
    iValid2,
    shiftCntEn,
    nCntEn,
    rowCntEn,
    shiftCntLoad,
    nCntLoad,
    rowCntLoad,
    addressCntEn,
    write,
    nCntOut,
    rowCntOut,
    shiftCntOut
);
    input wire clk, rst, start, nCntOut, rowCntOut, shiftCntOut;
    output reg done, bEn, aEn, loadA, shiftA, initZero, iIsMsb, iIsLsb1, iIsLsb2, iValid1, iValid2, shiftCntEn, 
    nCntEn, rowCntEn, shiftCntLoad, nCntLoad, rowCntLoad, addressCntEn, write;

    localparam [3:0] 
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4,
        S5 = 5,
        S6 = 6,
        S7 = 7,
        S8 = 8;

    reg [3:0] ps, ns;


    always @(posedge clk or posedge rst) begin
        if (rst)
            ps = S0;
        else
            ps <= ns;
        
    end


    always @(*) begin
        {done, bEn, aEn, loadA, shiftA, initZero, iIsMsb, iIsLsb1, iIsLsb2, iValid1, iValid2, shiftCntEn, nCntEn, 
        rowCntEn, shiftCntLoad, nCntLoad, rowCntLoad, addressCntEn, write} = 19'b0;

        case (ps)
            S0: ;

            S1: begin
                if (start == 0) begin
                    rowCntEn = 1;
                    nCntLoad = 1;
                end
            end

            S2: begin
                if (nCntOut) begin
                    nCntLoad = 1;
                end else begin
                    nCntEn = 1;
                end

                {addressCntEn, bEn} = 2'b1;
            end

            S3: begin
                if (nCntOut) begin
                    {shiftCntLoad, nCntLoad, initZero} = 3'b1;
                end else begin
                    nCntEn = 1;
                end

                {aEn, loadA, addressCntEn} = 3'b1;
            end

            S4: {shiftCntEn, iIsMsb, shiftA, aEn, iValid1, iValid2} = 6'b1;

            S5: begin
                if (shiftCntOut) begin
                    iIsLsb1 = 1;
                end else begin
                    {iValid2, shiftA, aEn, shiftCntEn} = 4'b1;
                end

                iValid1 = 1;
            end

            S6: {iIsLsb2, iValid2} = 2'b1;

            S7: begin
                if (rowCntOut == 0) begin
                    rowCntEn = 1;
                end

                {write, shiftCntLoad} = 2'b1;
            end

            S8: done = 1;

        endcase
    end


    always @(*) begin
        case (ps)
            S0: ns = start ? S1 : S0;
                
            S1: ns = start ? S1 : S2;

            S2: ns = nCntOut ? S3 : S2;

            S3: ns = nCntOut ? S4 : S3;

            S4: ns = S5;

            S5: ns = shiftCntOut ? S6 : S5;

            S6: ns = S7;

            S7: ns = rowCntOut ? S8 : S3;

            S8: ns = S0;

        endcase
    end
    
endmodule