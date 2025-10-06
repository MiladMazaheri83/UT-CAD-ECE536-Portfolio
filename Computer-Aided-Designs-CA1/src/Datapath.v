`include "../lib/lib.v"


module Datapath(clk, rst, inp, randIn, out);
    input clk, rst;
    input [1:0] randIn;
    input [127:0] inp;

    output [127:0] out;


    wire enM;
    wire [31:0] m00Out, m01Out, m10Out, m11Out, mux1Out; 
    wire [31:0] mux1Inp [0:3];

    Register #32 m00(clk, rst, inp[31:0], m00Out, enM);
    Register #32 m01(clk, rst, inp[63:32], m01Out, enM);
    Register #32 m10(clk, rst, inp[95:64], m10Out, enM);
    Register #32 m11(clk, rst, inp[127:96], m11Out, enM);


    Mux #(4, 32) mux1(mux1Inp, randIn, mux1Out);
    
    




    assign mux1Inp[0] = m00Out;
    assign mux1Inp[1] = m01Out;
    assign mux1Inp[2] = m10Out;
    assign mux1Inp[3] = m11Out;
endmodule