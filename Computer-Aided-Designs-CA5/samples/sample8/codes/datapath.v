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
    input [31:0] i8,
                        output [31:0] result
                    );

                        reg [31:0] w2;
    reg [31:0] w5;
    reg [31:0] w6;
    reg [31:0] w9;
    reg [31:0] w12;
    reg [31:0] w13;
    reg [31:0] w14;

                        assign result = w14;

                        reg [31:0] ALU_1_in1;
    reg [31:0] ALU_1_in2;
    wire [31:0] ALU_1_out;
    always @(*) begin
        case (state)
            1: begin ALU_1_in1 = i1; ALU_1_in2 = i2; end
            default: begin ALU_1_in1 = 0; ALU_1_in2 = 0; end
        endcase
    end
    assign ALU_1_out = 
(state == 1) ? (ALU_1_in1 + ALU_1_in2) : 0;
    always @(posedge clk) begin
        if (state == 1) w2 <= ALU_1_out;
    end

    reg [31:0] ALU_2_in1;
    reg [31:0] ALU_2_in2;
    wire [31:0] ALU_2_out;
    always @(*) begin
        case (state)
            1: begin ALU_2_in1 = i3; ALU_2_in2 = i4; end
            default: begin ALU_2_in1 = 0; ALU_2_in2 = 0; end
        endcase
    end
    assign ALU_2_out = 
(state == 1) ? (ALU_2_in1 + ALU_2_in2) : 0;
    always @(posedge clk) begin
        if (state == 1) w5 <= ALU_2_out;
    end

    reg [31:0] MUL_1_in1;
    reg [31:0] MUL_1_in2;
    wire [31:0] MUL_1_out;
    always @(*) begin
        case (state)
            2: begin MUL_1_in1 = w2; MUL_1_in2 = w5; end
            default: begin MUL_1_in1 = 0; MUL_1_in2 = 0; end
        endcase
    end
    assign MUL_1_out = 
(state == 2) ? (MUL_1_in1 * MUL_1_in2) : 0;
    always @(posedge clk) begin
        if (state == 2) w6 <= MUL_1_out;
    end

    reg [31:0] ALU_3_in1;
    reg [31:0] ALU_3_in2;
    wire [31:0] ALU_3_out;
    always @(*) begin
        case (state)
            1: begin ALU_3_in1 = i5; ALU_3_in2 = i6; end
            default: begin ALU_3_in1 = 0; ALU_3_in2 = 0; end
        endcase
    end
    assign ALU_3_out = 
(state == 1) ? (ALU_3_in1 + ALU_3_in2) : 0;
    always @(posedge clk) begin
        if (state == 1) w9 <= ALU_3_out;
    end

    reg [31:0] ALU_4_in1;
    reg [31:0] ALU_4_in2;
    wire [31:0] ALU_4_out;
    always @(*) begin
        case (state)
            1: begin ALU_4_in1 = i7; ALU_4_in2 = i8; end
            default: begin ALU_4_in1 = 0; ALU_4_in2 = 0; end
        endcase
    end
    assign ALU_4_out = 
(state == 1) ? (ALU_4_in1 + ALU_4_in2) : 0;
    always @(posedge clk) begin
        if (state == 1) w12 <= ALU_4_out;
    end

    reg [31:0] MUL_2_in1;
    reg [31:0] MUL_2_in2;
    wire [31:0] MUL_2_out;
    always @(*) begin
        case (state)
            2: begin MUL_2_in1 = w9; MUL_2_in2 = w12; end
            default: begin MUL_2_in1 = 0; MUL_2_in2 = 0; end
        endcase
    end
    assign MUL_2_out = 
(state == 2) ? (MUL_2_in1 * MUL_2_in2) : 0;
    always @(posedge clk) begin
        if (state == 2) w13 <= MUL_2_out;
    end

    reg [31:0] LOG_1_in1;
    reg [31:0] LOG_1_in2;
    wire [31:0] LOG_1_out;
    always @(*) begin
        case (state)
            3: begin LOG_1_in1 = w6; LOG_1_in2 = w13; end
            default: begin LOG_1_in1 = 0; LOG_1_in2 = 0; end
        endcase
    end
    assign LOG_1_out = 
(state == 3) ? (LOG_1_in1 & LOG_1_in2) : 0;
    always @(posedge clk) begin
        if (state == 3) w14 <= LOG_1_out;
    end

endmodule
