module MemoryBlock #(
    parameter WIDTH = 16,
    parameter HEIGHT = 16,
    parameter FILE_PATH = "map.txt"
) (
    read,
    write,
    addr,
    dataOut,
    dataIn
);

    localparam ADDR_H = $clog2(HEIGHT);
    input wire read;
    input wire write;
    input wire [ADDR_H-1:0] addr;
    input wire [WIDTH-1:0] dataIn;
    output reg [WIDTH-1:0] dataOut;
    
    reg [WIDTH-1:0] mem [0:HEIGHT-1];

    initial begin
        $readmemh(FILE_PATH, mem);
    end

    always @(*) begin
        if (read) begin
            dataOut = mem[addr];
        end
        else if(write) begin
            mem[addr] = dataIn;            
        end
    end

endmodule