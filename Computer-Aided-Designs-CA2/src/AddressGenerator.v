module AddressGenerator #(
    parameter N = 8,
    parameter MEM_SIZE = 128,
    parameter ROWS = 8
) (
    clk,
    rst,
    nCntEn,
    rowCntEn,
    addressCntEn,
    nCntLoad,
    rowCntLoad,
    write,
    address,
    nCntOut,
    rowCntOut
);
    localparam ADD_W = $clog2(MEM_SIZE);
    localparam N_COUNTER = $clog2(N);
    localparam [N_COUNTER-1:0] N_LOAD_NUM = (1 << N_COUNTER) - N;
    localparam ROWS_COUNTER = $clog2(ROWS);
    localparam [ROWS_COUNTER-1:0] ROWS_LOAD_NUM = (1 << ROWS_COUNTER) - ROWS;
    localparam [ADD_W-1:0] MEM_WRITE_ADDR = MEM_SIZE - (1 << ROWS_COUNTER);

    input wire clk, rst, nCntEn, rowCntEn, addressCntEn, nCntLoad, rowCntLoad, write;
    output wire nCntOut, rowCntOut;
    output wire [ADD_W-1:0] address;

    wire [ADD_W-1:0] addressCntOut, extendedRow, addressAdderOut;
    wire [ROWS_COUNTER-1:0] rowOut;


    Counter #(.SIZE(ADD_W)) addressCounter(
        .clk(clk),
        .rst(rst),
        .load(1'b0),
        .enCnt(addressCntEn),
        .pin(),
        .cntOut(addressCntOut),
        .co()
    );

    Counter #(.SIZE(N_COUNTER)) nCounter(
        .clk(clk),
        .rst(rst),
        .load(nCntLoad),
        .enCnt(nCntEn),
        .pin(N_LOAD_NUM),
        .cntOut(),
        .co(nCntOut)
    );

    Counter #(.SIZE(ROWS_COUNTER)) rowCounter(
        .clk(clk),
        .rst(rst),
        .load(rowCntLoad),
        .enCnt(rowCntEn),
        .pin(ROWS_LOAD_NUM),
        .cntOut(rowOut),
        .co(rowCntOut)
    ); 

    assign extendedRow = {{(ADD_W-ROWS_COUNTER){1'b0}}, rowOut};

    Adder #(.SIZE(ADD_W)) AddressAdder(
        .a(extendedRow),
        .b(MEM_WRITE_ADDR),
        .out(addressAdderOut)
    );

    Multiplexer #(.INP_NUMBER(2), .SIZE(ADD_W)) AddressMux(
        .inp({addressAdderOut, addressCntOut}),
        .sel(write),
        .out(address)
    );



endmodule