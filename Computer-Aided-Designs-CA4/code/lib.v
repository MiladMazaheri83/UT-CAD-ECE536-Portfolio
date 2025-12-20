module MemoryBlock #(
    parameter WIDTH = 8,
    parameter HEIGHT = 64
) (
    input  wire        read,
    input  wire [5:0]  addr,
    output reg  [WIDTH-1:0] dataOut
);

    reg [WIDTH-1:0] rom [0:HEIGHT-1];

    initial begin
        rom[0]  = 16'ha478;
        rom[1]  = 16'hb756;
        rom[2]  = 16'h70db;
        rom[3]  = 16'hceee;
        rom[4]  = 16'h0faf;
        rom[5]  = 16'hc62a;
        rom[6]  = 16'h4613;
        rom[7]  = 16'h9501;
        rom[8]  = 16'h98d8;
        rom[9]  = 16'hf7af;
        rom[10] = 16'h5bb1;
        rom[11] = 16'hd7be;
        rom[12] = 16'h1122;
        rom[13] = 16'h7193;
        rom[14] = 16'h438e;
        rom[15] = 16'h0821;
        rom[16] = 16'h2562;
        rom[17] = 16'hb340;
        rom[18] = 16'h5a51;
        rom[19] = 16'hc7aa;
        rom[20] = 16'h105d;
        rom[21] = 16'h1453;
        rom[22] = 16'he681;
        rom[23] = 16'hfbc8;
        rom[24] = 16'hcde6;
        rom[25] = 16'h07d6;
        rom[26] = 16'h0d87;
        rom[27] = 16'h14ed;
        rom[28] = 16'he905;
        rom[29] = 16'ha3f8;
        rom[30] = 16'h02d9;
        rom[31] = 16'h4c8a;
        rom[32] = 16'h3942;
        rom[33] = 16'hf681;
        rom[34] = 16'h6122;
        rom[35] = 16'h380c;
        rom[36] = 16'hea44;
        rom[37] = 16'hcfa9;
        rom[38] = 16'h4b60;
        rom[39] = 16'hbc70;
        rom[40] = 16'h7ec6;
        rom[41] = 16'h27fa;
        rom[42] = 16'h3085;
        rom[43] = 16'h1d05;
        rom[44] = 16'hd039;
        rom[45] = 16'h99e5;
        rom[46] = 16'h7cf8;
        rom[47] = 16'h5665;
        rom[48] = 16'h2244;
        rom[49] = 16'hff97;
        rom[50] = 16'h23a7;
        rom[51] = 16'ha039;
        rom[52] = 16'h59c3;
        rom[53] = 16'hcc92;
        rom[54] = 16'hf47d;
        rom[55] = 16'h5dd1;
        rom[56] = 16'h7e4f;
        rom[57] = 16'he6e0;
        rom[58] = 16'h4314;
        rom[59] = 16'h11a1;
        rom[60] = 16'h7e82;
        rom[61] = 16'hf235;
        rom[62] = 16'hd2bb;
        rom[63] = 16'hd391;
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
        end
        // hold state
        cntOut <= cntOut;
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
        end
        // hold state
        cntOut <= cntOut;
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
        // hold state
        cntOut <= cntOut;
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