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
                        output [31:0] result
                    );

                        reg [31:0] w2;
    reg [31:0] w5;
    reg [31:0] w6;
    reg [31:0] w7;
    reg [31:0] w10;
    reg [31:0] w11;
    reg [31:0] w12;

                        assign result = w12;

                        reg [31:0] MUL_1_in1;
    reg [31:0] MUL_1_in2;
    wire [31:0] MUL_1_out;
    always @(*) begin
        case (state)
            1: begin MUL_1_in1 = i1; MUL_1_in2 = i2; end
            default: begin MUL_1_in1 = 0; MUL_1_in2 = 0; end
        endcase
    end
    assign MUL_1_out = 
(state == 1) ? (MUL_1_in1 * MUL_1_in2) : 0;
    always @(posedge clk) begin
        if (state == 1) w2 <= MUL_1_out;
    end

    reg [31:0] MUL_2_in1;
    reg [31:0] MUL_2_in2;
    wire [31:0] MUL_2_out;
    always @(*) begin
        case (state)
            1: begin MUL_2_in1 = i3; MUL_2_in2 = i4; end
            default: begin MUL_2_in1 = 0; MUL_2_in2 = 0; end
        endcase
    end
    assign MUL_2_out = 
(state == 1) ? (MUL_2_in1 * MUL_2_in2) : 0;
    always @(posedge clk) begin
        if (state == 1) w5 <= MUL_2_out;
    end

    reg [31:0] ALU_1_in1;
    reg [31:0] ALU_1_in2;
    wire [31:0] ALU_1_out;
    always @(*) begin
        case (state)
            2: begin ALU_1_in1 = w2; ALU_1_in2 = w5; end
            3: begin ALU_1_in1 = w6; ALU_1_in2 = w11; end
            default: begin ALU_1_in1 = 0; ALU_1_in2 = 0; end
        endcase
    end
    assign ALU_1_out = 
(state == 2) ? (ALU_1_in1 + ALU_1_in2) : 
(state == 3) ? (ALU_1_in1 + ALU_1_in2) : 0;
    always @(posedge clk) begin
        if (state == 2) w6 <= ALU_1_out;
        if (state == 3) w12 <= ALU_1_out;
    end

    reg [31:0] MUL_3_in1;
    reg [31:0] MUL_3_in2;
    wire [31:0] MUL_3_out;
    always @(*) begin
        case (state)
            1: begin MUL_3_in1 = i1; MUL_3_in2 = i2; end
            default: begin MUL_3_in1 = 0; MUL_3_in2 = 0; end
        endcase
    end
    assign MUL_3_out = 
(state == 1) ? (MUL_3_in1 * MUL_3_in2) : 0;
    always @(posedge clk) begin
        if (state == 1) w7 <= MUL_3_out;
    end

    reg [31:0] MUL_4_in1;
    reg [31:0] MUL_4_in2;
    wire [31:0] MUL_4_out;
    always @(*) begin
        case (state)
            1: begin MUL_4_in1 = i5; MUL_4_in2 = i6; end
            default: begin MUL_4_in1 = 0; MUL_4_in2 = 0; end
        endcase
    end
    assign MUL_4_out = 
(state == 1) ? (MUL_4_in1 * MUL_4_in2) : 0;
    always @(posedge clk) begin
        if (state == 1) w10 <= MUL_4_out;
    end

    reg [31:0] LOG_1_in1;
    reg [31:0] LOG_1_in2;
    wire [31:0] LOG_1_out;
    always @(*) begin
        case (state)
            2: begin LOG_1_in1 = w7; LOG_1_in2 = w10; end
            default: begin LOG_1_in1 = 0; LOG_1_in2 = 0; end
        endcase
    end
    assign LOG_1_out = 
(state == 2) ? (LOG_1_in1 & LOG_1_in2) : 0;
    always @(posedge clk) begin
        if (state == 2) w11 <= LOG_1_out;
    end

endmodule
