module MatrixAccelerator #(
    parameter N = 8,
    parameter MP = 16,
    parameter W = 16,
    parameter MEM_SIZE = 128,
    parameter ROWS = 8
) (
    clk,
    rst,
    start,
    done
);
    localparam SUM_W = MP + W + $clog2(N);
    localparam ADD_W = $clog2(MEM_SIZE);

    input wire clk, rst, start;
    output wire done;

    wire [SUM_W-1:0] rData, wData;
    wire [ADD_W-1:0] address;
    wire write;

    MmpuTop #(.N(N), .MP(MP), .W(W), .MEM_SIZE(MEM_SIZE), .ROWS(ROWS)) Mmpu(
        .clk(clk),
        .rst(rst),
        .write(write),
        .start(start),
        .done(done),
        .rData(rData),
        .wData(wData),
        .address(address)
    );

    MemoryBlock #(.WIDTH(SUM_W), .HEIGHT(MEM_SIZE), .FILE_PATH("test.mem")) Mem(
        .clk(clk),
        .read(1'b1),
        .addr(address),
        .dataOut(rData),
        .dataIn(wData),
        .write(write)
    );
    
endmodule