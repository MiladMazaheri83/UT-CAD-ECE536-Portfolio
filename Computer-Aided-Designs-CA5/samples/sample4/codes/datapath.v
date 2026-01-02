module Datapath (
                        input clk,
                        input rst,
                        input [2:0] state,
                        input [31:0] i1,
    input [31:0] i2,
    input [31:0] i3,
    input [31:0] i4,
    input [31:0] i5,
    input [31:0] i6,
    input [31:0] i7,
                        output [31:0] result
                    );

                        reg [31:0] w2;
    reg [31:0] w4;
    reg [31:0] w6;
    reg [31:0] w8;
    reg [31:0] w10;
    reg [31:0] w12;

                        assign result = w12;

                        reg [31:0] MUL_1_in1;
    reg [31:0] MUL_1_in2;
    wire [31:0] MUL_1_out;
    always @(*) begin
        case (state)
            1: begin MUL_1_in1 = i1; MUL_1_in2 = i2; end
            3: begin MUL_1_in1 = w4; MUL_1_in2 = i4; end
            5: begin MUL_1_in1 = w8; MUL_1_in2 = i6; end
            default: begin MUL_1_in1 = 0; MUL_1_in2 = 0; end
        endcase
    end
    assign MUL_1_out = 
(state == 1) ? (MUL_1_in1 * MUL_1_in2) : 
(state == 3) ? (MUL_1_in1 * MUL_1_in2) : 
(state == 5) ? (MUL_1_in1 * MUL_1_in2) : 0;
    always @(posedge clk) begin
        if (state == 1) w2 <= MUL_1_out;
        if (state == 3) w6 <= MUL_1_out;
        if (state == 5) w10 <= MUL_1_out;
    end

    reg [31:0] ALU_1_in1;
    reg [31:0] ALU_1_in2;
    wire [31:0] ALU_1_out;
    always @(*) begin
        case (state)
            2: begin ALU_1_in1 = w2; ALU_1_in2 = i3; end
            4: begin ALU_1_in1 = w6; ALU_1_in2 = i5; end
            6: begin ALU_1_in1 = w10; ALU_1_in2 = i7; end
            default: begin ALU_1_in1 = 0; ALU_1_in2 = 0; end
        endcase
    end
    assign ALU_1_out = 
(state == 2) ? (ALU_1_in1 + ALU_1_in2) : 
(state == 4) ? (ALU_1_in1 + ALU_1_in2) : 
(state == 6) ? (ALU_1_in1 + ALU_1_in2) : 0;
    always @(posedge clk) begin
        if (state == 2) w4 <= ALU_1_out;
        if (state == 4) w8 <= ALU_1_out;
        if (state == 6) w12 <= ALU_1_out;
    end

endmodule
