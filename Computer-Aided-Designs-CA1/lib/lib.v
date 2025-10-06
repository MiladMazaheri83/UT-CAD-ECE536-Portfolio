module MemoryBlock #(
    parameter WIDTH = 16,
    parameter HEIGHT = 16,
    parameter FILE_PATH = "map.txt"
) (
    clk,
    read,
    addr_y,
    data_out
);

    localparam ADDR_H = $clog2(HEIGHT);
    input clk, read;
    input [ADDR_H-1:0] addr_y;
    output reg [WIDTH-1:0] data_out;
    
    reg [0:WIDTH - 1] mem [0:HEIGHT - 1];

    initial begin
        $readmemh(FILE_PATH, mem);
    end

    always @(*) begin
        if (read) begin
            data_out = mem[addr_y];
        end
    end

endmodule


module Counter #(
    parameter m = 2
) (
    input wire clk,
    input wire rst,
    input wire load,
    input wire encnt,
    input wire [(m - 1):0] pin,
    output reg [(m - 1):0] cntout,
    output wire co
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            cntout <= {m{1'b0}};
        else if (load) begin
            cntout <= pin;
        end
        else if (encnt) begin
            cntout <= cntout + 1;
        end
    end

    assign co = &{cntout};
    
endmodule


module UpDownCounter #(
    parameter m = 8
) (
    input wire clk,
    input wire rst,
    input wire load,
    input wire encnt,
    input wire init,
    input wire countUp,
    input wire countDown,
    input wire [(m - 1):0] pin,
    output reg [(m - 1):0] cntout,
    output wire overflow,
    output wire underflow
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cntout <= {m{1'b0}};
        end 
        else if (encnt) begin
            if (load) begin
                cntout <= pin;
            end 
            else if (init) begin
                cntout <= {m{1'b0}};
            end 
            else begin
                if (countUp) begin
                    cntout <= cntout + 1;
                end 
                if (countDown) begin
                    cntout <= cntout - 1;
                end
            end
        end
    end

    assign overflow = encnt & countUp & (cntout == {m{1'b1}});
    assign underflow = encnt & countDown & (cntout == {m{1'b0}});

endmodule


module Register(clk, rst, inp, out, en);
    parameter N = 32;
    
    input clk, rst, en;
    input [N - 1:0] inp;
    output reg [N - 1:0] out;

    always @(posedge clk) begin
        if (rst)
            out <= 0;
        else if(en)
            out <= inp;
    end

endmodule


module Decoder #(  
    parameter WIDTH = 4  
) (  
    input wire en,  
    input wire [WIDTH-1:0] in,  
    output reg [(2**WIDTH)-1:0] out  
);  
    always @(*) begin   
        out <= 0; 
        if (en) begin  
            out[in] <= 1'b1; 
        end 
    end 

endmodule  


module ShiftRegister #(parameter n = 5) (
    input wire clk,
    input wire clk_en,
    input wire rst,
    input wire shQ,
    input wire loadQ,
    input wire sin,
    input wire [(n - 1):0] qin,
    output reg [(n - 1):0] qout,
    output wire sout
    );

    always @(posedge clk) begin
        if (rst) 
            qout <= {n{1'b0}};

        else if (clk_en) begin
            if (loadQ) begin
                qout <= qin;
            end else if (shQ) begin
                qout <= {qout[(n - 2):0], sin};
            end
        end
    end

    assign sout = qout[0];

endmodule


module Adder(a, b, out);
    parameter N = 32;

    input [N - 1:0] a, b;
    output [N - 1:0] out;

    assign out = a + b;
endmodule


module Alu(srcA, srcB, opCode, aluResult, zero);
    parameter N = 32;

    input [N - 1:0] srcA, srcB;
    input [2:0] opCode;
    output reg [N - 1:0] aluResult;
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


module Mux(inp, sel, out);
    parameter N = 4;
    parameter M = 32;
    localparam S = $clog2(N);

    input [M - 1:0] inp [0:N - 1];
    input [S - 1:0] sel;
    output [M - 1:0] out;

    assign out = inp[sel];
    
endmodule

