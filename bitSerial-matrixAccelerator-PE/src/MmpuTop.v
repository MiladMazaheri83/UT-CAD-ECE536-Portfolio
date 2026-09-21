module MmpuTop #(
    parameter N = 8,
    parameter MP = 16,
    parameter W = 16,
    parameter MEM_SIZE = 128,
    parameter ROWS = 8
) (
    clk,
    rst,
    write,
    start,
    done,
    rData,
    wData,
    address
);
    localparam ADD_W = $clog2(MEM_SIZE);
    localparam SUM_W = MP + W + $clog2(N);

    input wire clk, rst, start;
    input wire [SUM_W-1:0] rData;
    output wire write, done;
    output wire [ADD_W-1:0] address;
    output wire [SUM_W-1:0] wData;

    wire bEn, aEn, loadA, shiftA, initZero, iIsMsb, iIsLsb1, iIsLsb2, iValid1, iValid2, shiftCntEn,
         nCntEn, rowCntEn, shiftCntLoad, nCntLoad, rowCntLoad, addressCntEn, nCntOut, rowCntOut, shiftCntOut;

    MmpuDatapath #(.N(N), .MP(MP), .W(W), .MEM_SIZE(MEM_SIZE), .ROWS(ROWS)) MmpuDp(
        .clk(clk),
        .rst(rst),
        .bEn(bEn),
        .aEn(aEn),
        .loadA(loadA),
        .shiftA(shiftA),
        .initZero(initZero),
        .iIsMsb(iIsMsb),
        .iIsLsb1(iIsLsb1),
        .iIsLsb2(iIsLsb2),
        .iValid1(iValid1),
        .iValid2(iValid2),
        .shiftCntEn(shiftCntEn),
        .nCntEn(nCntEn),
        .rowCntEn(rowCntEn),
        .shiftCntLoad(shiftCntLoad),
        .nCntLoad(nCntLoad),
        .rowCntLoad(rowCntLoad),
        .addressCntEn(addressCntEn),
        .write(write),
        .address(address),
        .nCntOut(nCntOut),
        .rowCntOut(rowCntOut),
        .shiftCntOut(shiftCntOut),
        .rData(rData),
        .wData(wData)
    );

    MmpuController MmpuCont(
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .bEn(bEn),
        .aEn(aEn),
        .loadA(loadA),
        .shiftA(shiftA),
        .initZero(initZero),
        .iIsMsb(iIsMsb),
        .iIsLsb1(iIsLsb1),
        .iIsLsb2(iIsLsb2),
        .iValid1(iValid1),
        .iValid2(iValid2),
        .shiftCntEn(shiftCntEn),
        .nCntEn(nCntEn),
        .rowCntEn(rowCntEn),
        .shiftCntLoad(shiftCntLoad),
        .nCntLoad(nCntLoad),
        .rowCntLoad(rowCntLoad),
        .addressCntEn(addressCntEn),
        .write(write),
        .nCntOut(nCntOut),
        .rowCntOut(rowCntOut),
        .shiftCntOut(shiftCntOut)
    );
    
endmodule