module StripesPE #(
    parameter W = 16,
    parameter MP = 16,
    parameter N = 4,
    parameter SUM_W = 34
) (
    clk,
    rst,
    iIsMsn,
    iIsLsb,
    iValid,
    iVecB,
    iVecABits,
    initialSum,
    oDotProduct
);
    input clk, rst;
    input iIs_msn, iIsLsb, iValid;
    input [W*N-1:0] iVecB;
    input [N-1:0] iVecABits;
    input [SUM_W-1:0] initialSum;
    output [SUM_W-1:0] oDotProduct;

    wire ldCnt3, enCnt3, co3, shiftP1, loadP1;
    
    
endmodule