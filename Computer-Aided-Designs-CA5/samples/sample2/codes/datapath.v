module Datapath (
                        input clk,
                        input rst,
                        input [3:0] state,
                        input [31:0] i1,
    input [31:0] i2,
    input [31:0] i3,
                        output [31:0] result
                    );

                        reg [31:0] w2;
    reg [31:0] w4;
    reg [31:0] w5;
    reg [31:0] w6;
    reg [31:0] w7;
    reg [31:0] w8;
    reg [31:0] w9;
    reg [31:0] w10;
    reg [31:0] w11;
    reg [31:0] w12;

                        assign result = w12;

                        reg [31:0] ALU_1_in1;
    reg [31:0] ALU_1_in2;
    wire [31:0] ALU_1_out;
    always @(*) begin
        case (state)
            5: begin ALU_1_in1 = i1; ALU_1_in2 = i2; end
            3: begin ALU_1_in1 = i2; ALU_1_in2 = i3; end
            4: begin ALU_1_in1 = w4; ALU_1_in2 = w5; end
            2: begin ALU_1_in1 = i1; ALU_1_in2 = w9; end
            6: begin ALU_1_in1 = w8; ALU_1_in2 = w10; end
            7: begin ALU_1_in1 = w7; ALU_1_in2 = w11; end
            default: begin ALU_1_in1 = 0; ALU_1_in2 = 0; end
        endcase
    end
    assign ALU_1_out = 
(state == 5) ? (ALU_1_in1 - ALU_1_in2) : 
(state == 3) ? (ALU_1_in1 + ALU_1_in2) : 
(state == 4) ? (ALU_1_in1 - ALU_1_in2) : 
(state == 2) ? (ALU_1_in1 - ALU_1_in2) : 
(state == 6) ? (ALU_1_in1 + ALU_1_in2) : 
(state == 7) ? (ALU_1_in1 + ALU_1_in2) : 0;
    always @(posedge clk) begin
        if (state == 5) w2 <= ALU_1_out;
        if (state == 3) w4 <= ALU_1_out;
        if (state == 4) w6 <= ALU_1_out;
        if (state == 2) w10 <= ALU_1_out;
        if (state == 6) w11 <= ALU_1_out;
        if (state == 7) w12 <= ALU_1_out;
    end

    reg [31:0] LOG_1_in1;
    reg [31:0] LOG_1_in2;
    wire [31:0] LOG_1_out;
    always @(*) begin
        case (state)
            3: begin LOG_1_in1 = i3; LOG_1_in2 = i1; end
            1: begin LOG_1_in1 = i2; LOG_1_in2 = i3; end
            default: begin LOG_1_in1 = 0; LOG_1_in2 = 0; end
        endcase
    end
    assign LOG_1_out = 
(state == 3) ? (LOG_1_in1 | LOG_1_in2) : 
(state == 1) ? (LOG_1_in1 & LOG_1_in2) : 0;
    always @(posedge clk) begin
        if (state == 3) w5 <= LOG_1_out;
        if (state == 1) w9 <= LOG_1_out;
    end

    reg [31:0] MUL_1_in1;
    reg [31:0] MUL_1_in2;
    wire [31:0] MUL_1_out;
    always @(*) begin
        case (state)
            6: begin MUL_1_in1 = w2; MUL_1_in2 = w6; end
            5: begin MUL_1_in1 = i3; MUL_1_in2 = i2; end
            default: begin MUL_1_in1 = 0; MUL_1_in2 = 0; end
        endcase
    end
    assign MUL_1_out = 
(state == 6) ? (MUL_1_in1 / MUL_1_in2) : 
(state == 5) ? (MUL_1_in1 / MUL_1_in2) : 0;
    always @(posedge clk) begin
        if (state == 6) w7 <= MUL_1_out;
        if (state == 5) w8 <= MUL_1_out;
    end

endmodule
