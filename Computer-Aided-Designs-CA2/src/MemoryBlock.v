module MemoryBlock #(
    parameter WIDTH = 16,
    parameter HEIGHT = 16,
    parameter FILE_PATH = "file.txt"
) (
    clk,
    read,
    write,
    addr,
    dataOut,
    dataIn
);

    localparam ADDR_H = $clog2(HEIGHT);
    
    input wire clk;
    input wire read;
    input wire write;
    input wire [ADDR_H-1:0] addr;
    input wire [WIDTH-1:0] dataIn;
    output reg [WIDTH-1:0] dataOut;
    
    reg [0:WIDTH - 1] mem [0:HEIGHT - 1];

    initial begin
        $readmemh(FILE_PATH, mem);
    end

    always @(*) begin
        if (read) begin
            dataOut = mem[addr];
        end
    end

    always @(posedge clk, posedge read) begin
        if(write) begin
            mem[addr] <= dataIn;            
        end
    end

endmodule