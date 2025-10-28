module StripesPE #(
    parameter W = 16,
    parameter MP = 16,
    parameter N = 4,
    parameter SUM_W = 34
) (
    clk,
    rst,
    iIsMsb,
    iIsLsb,
    iValid,
    initZero,
    iVecB,
    iVecABits,
    initialSum,
    oDotProduct
);
    localparam ADDER_TREE_WIDTH = W + $clog2(N);

    input wire clk, rst, iIsMsb, iIsLsb, iValid, initZero;
    input wire [W*N-1:0] iVecB;
    input wire [N-1:0] iVecABits;
    input wire [SUM_W-1:0] initialSum;
    output wire [SUM_W-1:0] oDotProduct;

    wire [W-1:0] products [0:N-1];
    wire [W-1:0] productTwosComps [0:N-1];
    wire [W-1:0] muxOuts [0:N-1];
    wire [ADDER_TREE_WIDTH-1:0] adderTreeSum;
    wire [SUM_W-1:0] extendedSum, mux1Out, accumulatorInp, adder1Out;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : AND_GATES
            assign products[i] = iVecB[W*(i+1)-1:W*i] & {W{iVecABits[i]}};
        end
    endgenerate

    generate
        for (i = 0; i < N; i = i + 1) begin : TWOS_COMPS
            TwosComplement #(.WIDTH(W)) TwosComplementLayer(
                .dataIn(products[i]),
                .dataOut(productTwosComps[i])
            );
        end
    endgenerate

    generate
        for (i = 0; i < N; i = i + 1) begin : MUX_LAYER
            Multiplexer #(.INP_NUMBER(2), .SIZE(W)) MuxLayer(
                .inp({productTwosComps[i], products[i]}),
                .sel(iIsMsb),
                .out(muxOuts[i])
            );
        end
    endgenerate

    AdderTree #(.N(N), .W(16)) AdderTreeBlock(
        .in(muxOuts),
        .sum(adderTreeSum)
    );

    SignExtend #(.INP_SIZE(ADDER_TREE_WIDTH), .OUT_SIZE(SUM_W)) SignExtendSum(
        .inp(adderTreeSum),
        .out(extendedSum)
    );

    Adder #(.SIZE(SUM_W)) Adder1(
        .a(extendedSum),
        .b(initialSum),
        .out(adder1Out)
    );

    Multiplexer #(.INP_NUMBER(2), .SIZE(SUM_W)) Mux1(
        .inp({adder1Out, extendedSum}),
        .sel(iIsLsb),
        .out(mux1Out)
    );

    Adder #(.SIZE(SUM_W)) Adder2(
        .a(mux1Out),
        .b(oDotProduct),
        .out(accumulatorInp)
    );

    Accumulator #(.SIZE(SUM_W)) AccumulatorBlock(
        .clk(clk),
        .rst(rst),
        .init(initZero),
        .en(iValid),
        .inp(accumulatorInp),
        .out(oDotProduct)
    );

endmodule