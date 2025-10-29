module MmpuDatapath #(
    parameter N = 8,
    parameter MP = 16,
    parameter W = 16,
    parameter MEM_SIZE = 128,
    parameter ROWS = 8
) (
    clk,
    rst,
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
    address,
    nCntOut,
    rowCntOut,
    shiftCntOut,
    initialSum,
    rData,
    wData,
);
    localparam FIRST_PE_N = N /2;
    localparam SECOND_PE_N = N - FIRST_PE_N;
    localparam SUM_W = $clog2(N) + MP + W;
    localparam ADD_W = $clog2(MEM_SIZE);
    localparam SHIFT_COUNTER_BITS = $clog2(MP);
    localparam [SHIFT_COUNTER_BITS-1:0] SHIFT_LOAD_NUM = (1 << SHIFT_COUNTER_BITS) - MP;


    input wire clk, rst, bEn, aEn, loadA, shiftA, initZero, iIsMsb, iIsLsb1, iIsLsb2, iValid1, iValid2,
                shiftCntEn, nCntEn, rowCntEn, shiftCntLoad, nCntLoad, rowCntLoad, addressCntEn, write;
    input wire [SUM_W-1:0] rData, initialSum;
    output wire nCntOut, rowCntOut, shiftCntOut;
    output wire [ADD_W-1:0] address;
    output wire [SUM_W-1:0] wData;

    wire [W*N-1:0] bReg;
    wire [W*N-1:0] aReg;
    wire [N-1:0] iVecABits;
    wire [SUM_W-1:0] oDotProduct1;

    Counter #(.SIZE(SHIFT_COUNTER_BITS)) ShiftCounter(
        .clk(clk),
        .rst(rst),
        .load(shiftCntLoad),
        .enCnt(shiftCntEn),
        .pin(SHIFT_LOAD_NUM),
        .cntOut(),
        .co(shiftCntOut)
    );

    AddressGenerator #(.N(N), .MEM_SIZE(MEM_SIZE), .ROWS(ROWS)) AddressGeneratorBlock(
        .clk(clk),
        .rst(rst),
        .nCntEn(nCntEn),
        .rowCntEn(rowCntEn),
        .addressCntEn(addressCntEn),
        .nCntLoad(nCntLoad),
        .rowCntLoad(rowCntLoad),
        .write(write),
        .address(address),
        .nCntOut(nCntOut),
        .rowCntOut(rowCntOut)
    );

    Register #(.SIZE(W)) LastBReg(
        .clk(clk),
        .rst(rst),
        .init(1'b0),
        .inp(rData[W-1:0]),
        .out(bReg[N*W-1:(N-1)*W]),
        .en(bEn)
    );

    genvar i;
    generate
        for (i = N - 1; i > 0; i = i -1) begin : B_REGISTERS
            Register #(.SIZE(W)) BRegLayer(
                .clk(clk),
                .rst(rst),
                .init(1'b0),
                .inp(bReg[(i+1)*W-1:i*W]),
                .out(bReg[i*W-1:(i-1)*W]),
                .en(bEn)
            );
        end
    endgenerate

    ShiftLeftRegister #(.SIZE(W)) LastAShiftReg(
        .clk(clk),
        .rst(rst),
        .shQ(shiftA),
        .loadQ(loadA),
        .sIn(1'bz),
        .qIn(rData[W-1:0]),
        .qOut(aReg[N*W-1:(N-1)*W]),
        .sOut(iVecABits[N-1])
    );

    generate
        for (i = N - 1; i > 0; i = i -1) begin : A_SHIFT_REGISTERS
            ShiftLeftRegister #(.SIZE(W)) AShiftRegLayer(
                .clk(clk),
                .rst(rst),
                .shQ(shiftA),
                .loadQ(loadA),
                .sIn(1'bz),
                .qIn(aReg[(i+1)*W-1:i*W]),
                .qOut(aReg[i*W-1:(i-1)*W]),
                .sOut(iVecABits[i-1])
            );
        end
    endgenerate

    StripesPE #(.W(W), .N(FIRST_PE_N), .SUM_W(SUM_W)) PE1(
        .clk(clk),
        .rst(rst),
        .iIsMsb(iIsMsb),
        .iIsLsb(iIsLsb1),
        .iValid(iValid1),
        .initZero(initZero),
        .iVecB(bReg[(FIRST_PE_N)*W-1:0]),
        .iVecABits(iVecABits[FIRST_PE_N-1:0]),
        .initialSum(initialSum),
        .oDotProduct(oDotProduct1)
    );

    StripesPE #(.W(W), .N(SECOND_PE_N), .SUM_W(SUM_W)) PE2(
        .clk(clk),
        .rst(rst),
        .iIsMsb(iIsMsb),
        .iIsLsb(iIsLsb2),
        .iValid(iValid2),
        .initZero(initZero),
        .iVecB(bReg[N*W-1:FIRST_PE_N*W]),
        .iVecABits(iVecABits[N-1:FIRST_PE_N]),
        .initialSum(oDotProduct1),
        .oDotProduct(wData)
    );

endmodule