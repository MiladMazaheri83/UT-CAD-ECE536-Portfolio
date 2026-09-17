module Datapath (
    input clk,
    input rst,
    input [2:0] state,
    input signed [31:0] i1,
    input signed [31:0] i2,
    input signed [31:0] i3,
    input signed [31:0] i4,
    input signed [31:0] i5,
    input signed [31:0] i6,
    input signed [31:0] i7,
    input signed [31:0] i8,
    output signed [31:0] result
);
    reg signed [31:0] w2;
    reg signed [31:0] w5;
    reg signed [31:0] w6;
    reg signed [31:0] w9;
    reg signed [31:0] w12;
    reg signed [31:0] w13;
    reg signed [31:0] w14;

    assign result = w14;

    // Resource: ALU_1
    reg signed [31:0] ALU_1_in1;
    reg signed [31:0] ALU_1_in2;
    wire signed [31:0] ALU_1_out;

    always @(*) begin
        case (state)
            1: begin
                ALU_1_in1 = i1;
                ALU_1_in2 = i2;
            end
            2: begin
                ALU_1_in1 = w2;
                ALU_1_in2 = w5;
            end
            3: begin
                ALU_1_in1 = w6;
                ALU_1_in2 = w13;
            end
            default: begin
                ALU_1_in1 = 0;
                ALU_1_in2 = 0;
            end
        endcase
    end

    assign ALU_1_out =
        (state == 1) ? ($signed(ALU_1_in1) + $signed(ALU_1_in2)) :
        (state == 2) ? ($signed(ALU_1_in1) + $signed(ALU_1_in2)) :
        (state == 3) ? ($signed(ALU_1_in1) + $signed(ALU_1_in2)) : 32'sd0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w2 <= 32'sd0;
            w6 <= 32'sd0;
            w14 <= 32'sd0;
        end else begin
            if (state == 1)
                w2 <= ALU_1_out;
            if (state == 2)
                w6 <= ALU_1_out;
            if (state == 3)
                w14 <= ALU_1_out;
        end
    end

    // Resource: ALU_2
    reg signed [31:0] ALU_2_in1;
    reg signed [31:0] ALU_2_in2;
    wire signed [31:0] ALU_2_out;

    always @(*) begin
        case (state)
            1: begin
                ALU_2_in1 = i3;
                ALU_2_in2 = i4;
            end
            2: begin
                ALU_2_in1 = w9;
                ALU_2_in2 = w12;
            end
            default: begin
                ALU_2_in1 = 0;
                ALU_2_in2 = 0;
            end
        endcase
    end

    assign ALU_2_out =
        (state == 1) ? ($signed(ALU_2_in1) + $signed(ALU_2_in2)) :
        (state == 2) ? ($signed(ALU_2_in1) + $signed(ALU_2_in2)) : 32'sd0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w5 <= 32'sd0;
            w13 <= 32'sd0;
        end else begin
            if (state == 1)
                w5 <= ALU_2_out;
            if (state == 2)
                w13 <= ALU_2_out;
        end
    end

    // Resource: ALU_3
    reg signed [31:0] ALU_3_in1;
    reg signed [31:0] ALU_3_in2;
    wire signed [31:0] ALU_3_out;

    always @(*) begin
        case (state)
            1: begin
                ALU_3_in1 = i5;
                ALU_3_in2 = i6;
            end
            default: begin
                ALU_3_in1 = 0;
                ALU_3_in2 = 0;
            end
        endcase
    end

    assign ALU_3_out =
        (state == 1) ? ($signed(ALU_3_in1) + $signed(ALU_3_in2)) : 32'sd0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w9 <= 32'sd0;
        end else begin
            if (state == 1)
                w9 <= ALU_3_out;
        end
    end

    // Resource: ALU_4
    reg signed [31:0] ALU_4_in1;
    reg signed [31:0] ALU_4_in2;
    wire signed [31:0] ALU_4_out;

    always @(*) begin
        case (state)
            1: begin
                ALU_4_in1 = i7;
                ALU_4_in2 = i8;
            end
            default: begin
                ALU_4_in1 = 0;
                ALU_4_in2 = 0;
            end
        endcase
    end

    assign ALU_4_out =
        (state == 1) ? ($signed(ALU_4_in1) + $signed(ALU_4_in2)) : 32'sd0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w12 <= 32'sd0;
        end else begin
            if (state == 1)
                w12 <= ALU_4_out;
        end
    end

endmodule
