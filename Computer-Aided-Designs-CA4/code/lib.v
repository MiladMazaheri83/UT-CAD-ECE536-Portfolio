module MemoryBlock #(
    parameter WIDTH  = 8,
    parameter HEIGHT = 64
) (
    input  wire        read,
    input  wire [5:0]  addr,
    output reg  [WIDTH-1:0] dataOut
);

    reg [WIDTH-1:0] rom [0:HEIGHT-1];

    initial begin
        rom[0]  = 8'h78;
        rom[1]  = 8'h56;
        rom[2]  = 8'hdb;
        rom[3]  = 8'hee;
        rom[4]  = 8'haf;
        rom[5]  = 8'h2a;
        rom[6]  = 8'h13;
        rom[7]  = 8'h01;
        rom[8]  = 8'hd8;
        rom[9]  = 8'haf;
        rom[10] = 8'hb1;
        rom[11] = 8'hbe;
        rom[12] = 8'h22;
        rom[13] = 8'h93;
        rom[14] = 8'h8e;
        rom[15] = 8'h21;
        rom[16] = 8'h62;
        rom[17] = 8'h40;
        rom[18] = 8'h51;
        rom[19] = 8'haa;
        rom[20] = 8'h5d;
        rom[21] = 8'h53;
        rom[22] = 8'h81;
        rom[23] = 8'hc8;
        rom[24] = 8'he6;
        rom[25] = 8'hd6;
        rom[26] = 8'h87;
        rom[27] = 8'hed;
        rom[28] = 8'h05;
        rom[29] = 8'hf8;
        rom[30] = 8'hd9;
        rom[31] = 8'h8a;
        rom[32] = 8'h42;
        rom[33] = 8'h81;
        rom[34] = 8'h22;
        rom[35] = 8'h0c;
        rom[36] = 8'h44;
        rom[37] = 8'ha9;
        rom[38] = 8'h60;
        rom[39] = 8'h70;
        rom[40] = 8'hc6;
        rom[41] = 8'hfa;
        rom[42] = 8'h85;
        rom[43] = 8'h05;
        rom[44] = 8'h39;
        rom[45] = 8'he5;
        rom[46] = 8'hf8;
        rom[47] = 8'h65;
        rom[48] = 8'h44;
        rom[49] = 8'h97;
        rom[50] = 8'ha7;
        rom[51] = 8'h39;
        rom[52] = 8'hc3;
        rom[53] = 8'h92;
        rom[54] = 8'h7d;
        rom[55] = 8'hd1;
        rom[56] = 8'h4f;
        rom[57] = 8'he0;
        rom[58] = 8'h14;
        rom[59] = 8'ha1;
        rom[60] = 8'h82;
        rom[61] = 8'h35;
        rom[62] = 8'hbb;
        rom[63] = 8'h91;
    end

    always @(*) begin
        if (read)
            dataOut = rom[addr];
        else
            dataOut = {WIDTH{1'b0}};
    end
endmodule


module Counter6 #(
    parameter SIZE = 6
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

    // Synchronous reset
    always @(posedge clk) begin
        if (rst)
            cntOut <= {SIZE{1'b0}};
        else if (load) begin
            cntOut <= pin;
        end
        else if (enCnt) begin
            cntOut <= cntOut + 1;
        end else begin
        // hold state
        cntOut <= cntOut;
        end
    end

    assign co = &{cntOut};
    
endmodule

module Counter2 #(
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

    // Synchronous reset
    always @(posedge clk) begin
        if (rst)
            cntOut <= {SIZE{1'b0}};
        else if (load) begin
            cntOut <= pin;
        end
        else if (enCnt) begin
            cntOut <= cntOut + 1;
        end else begin
        // hold state
        cntOut <= cntOut;
        end
    end

    assign co = &{cntOut};
    
endmodule

module Counter3 #(
    parameter SIZE = 3
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

    // Synchronous reset
    always @(posedge clk) begin
        if (rst)
            cntOut <= {SIZE{1'b0}};
        else if (load) begin
            cntOut <= pin;
        end
        else if (enCnt) begin
            cntOut <= cntOut + 1;
        end
        else begin
        // hold state
        cntOut <= cntOut;
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
    parameter SIZE = 8
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
    parameter SIZE = 8
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


module Multiplexer4 #(
    parameter INP_NUMBER = 4,
    parameter SIZE = 8
) (
    input  [INP_NUMBER*SIZE-1:0] inp,
    input  [$clog2(INP_NUMBER)-1:0] sel,
    output [SIZE-1:0] out
);

    assign out = inp[sel*SIZE +: SIZE];

endmodule

module Multiplexer2 #(
    parameter INP_NUMBER = 2,
    parameter SIZE = 8
) (
    input  [INP_NUMBER*SIZE-1:0] inp,
    input  [$clog2(INP_NUMBER)-1:0] sel,
    output [SIZE-1:0] out
);

    assign out = inp[sel*SIZE +: SIZE];

endmodule