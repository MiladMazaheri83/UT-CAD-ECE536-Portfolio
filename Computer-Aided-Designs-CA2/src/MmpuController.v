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
    input wire clk, rst, start;
    output wire done, bEn, aEn, loadA, shiftA, initZero, iIsMsb, iIsLsb1, iIsLsb2, iValid1, iValid2, shiftCntEn, 
    nCntEn, rowCntEn, shiftCntLoad, nCntLoad, rowCntLoad, addressCntEn, write, nCntOut, rowCntOut, shiftCntOut;

    
    
endmodule