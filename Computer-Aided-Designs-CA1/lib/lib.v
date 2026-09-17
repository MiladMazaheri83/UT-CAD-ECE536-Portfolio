module MemoryBlock #(
    parameter WIDTH = 16,
    parameter HEIGHT = 16,
    parameter FILE_PATH = "map.txt"
) (
    read,
    addr,
    dataOut
);

    localparam ADDR_H = $clog2(HEIGHT);
    input wire read;
    input wire [ADDR_H-1:0] addr;
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

endmodule


module Counter #(
    parameter SIZE = 2
) (
    clk,
    rst,
    load,
    enCnt,
    pin,
    cntOut,
    co
);

    input wire clk, rst, load, enCnt;
    input wire [(SIZE - 1):0] pin;
    output reg [(SIZE - 1):0] cntOut;
    output wire co;

    always @(posedge clk or posedge rst) begin
        if (rst)
            cntOut <= {SIZE{1'b0}};
        else if (load) begin
            cntOut <= pin;
        end
        else if (enCnt) begin
            cntOut <= cntOut + 1;
        end
    end

    assign co = &{cntOut};
    
endmodule


module UpDownCounter #(
    parameter SIZE = 8
) (
    clk,
    rst,
    load,
    enCnt,
    init,
    countUp,
    countDown,
    pin,
    cntOut,
    overFlow,
    underFlow
);

    input wire clk, rst, load, enCnt, init, countUp, countDown;
    input wire [(SIZE - 1):0] pin;
    output reg [(SIZE - 1):0] cntOut;
    output wire overFlow, underFlow;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cntOut <= {SIZE{1'b0}};
        end 
        else if (enCnt) begin
            if (load) begin
                cntOut <= pin;
            end 
            else if (init) begin
                cntOut <= {SIZE{1'b0}};
            end 
            else begin
                if (countUp) begin
                    cntOut <= cntOut + 1;
                end 
                if (countDown) begin
                    cntOut <= cntOut - 1;
                end
            end
        end
    end

    assign overFlow = enCnt & countUp & (cntOut == {SIZE{1'b1}});
    assign underFlow = enCnt & countDown & (cntOut == {SIZE{1'b0}});

endmodule


module Register #(
    parameter SIZE = 32
) (
    clk,
    rst,
    inp,
    out,
    en
);
    
    input wire clk, rst, en;
    input wire [SIZE - 1:0] inp;
    output reg [SIZE - 1:0] out;

    always @(posedge clk) begin
        if (rst)
            out <= 0;
        else if(en)
            out <= inp;
    end

endmodule


module Decoder #(  
    parameter SIZE = 4  
) (  
    en,  
    in,  
    out  
);  
    input wire en;
    input wire [SIZE-1:0] in;
    output reg [(2**SIZE)-1:0] out;

    always @(*) begin   
        out <= 0; 
        if (en) begin  
            out[in] <= 1'b1; 
        end 
    end 

endmodule  


module ShiftRegister #(
    parameter SIZE = 5
) (
    clk,
    rst,
    shQ,
    loadQ,
    sIn,
    qIn,
    qOut,
    sOut
);
    input wire clk, rst, shQ, loadQ, sIn;
    input wire [(SIZE - 1):0] qIn;
    output reg [(SIZE - 1):0] qOut;
    output wire sOut;

    always @(posedge clk) begin
        if (rst) 
            qOut <= {SIZE{1'b0}};

        else if (loadQ) begin
            qOut <= qIn;
        end else if (shQ) begin
            qOut <= {qOut[(SIZE - 2):0], sIn};
        end
    end

    assign sOut = qOut[0];

endmodule


module Adder #(
    parameter SIZE = 32
) (
    a,
    b,
    out
);
    input [SIZE - 1:0] a, b;
    output [SIZE - 1:0] out;

    assign out = a + b;
endmodule


module Alu #(
    parameter SIZE = 32
) (
    srcA,
    srcB,
    opCode,
    aluResult,
    zero
);

    input [SIZE - 1:0] srcA, srcB;
    input [2:0] opCode;
    output reg [SIZE - 1:0] aluResult;
    output zero;

    assign zero = ~|aluResult;

    always @(*) begin
        case (opCode)
            3'b000: aluResult = srcA + srcB;
            3'b001: aluResult = srcA - srcB;
            3'b010: aluResult = srcA & srcB;
            3'b011: aluResult = srcA | srcB;
            3'b101: aluResult = ($signed(srcA) < $signed(srcB)) ? 1 : 0;

            default: aluResult = 0;
        endcase
    end
    
    
endmodule


module Multiplexer #(
    parameter INP_NUMBER = 4,
    parameter SIZE = 32
) (
    input  [INP_NUMBER*SIZE-1:0] inp,
    input  [$clog2(INP_NUMBER)-1:0] sel,
    output [SIZE-1:0] out
);

    assign out = inp[sel*SIZE +: SIZE];

endmodule