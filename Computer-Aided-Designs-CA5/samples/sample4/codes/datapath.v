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
    output signed [31:0] result
);
    reg signed [31:0] w2;
    reg signed [31:0] w4;
    reg signed [31:0] w6;
    reg signed [31:0] w8;
    reg signed [31:0] w10;
    reg signed [31:0] w12;

    assign result = w12;

    // Resource: MUL_1
    reg signed [31:0] MUL_1_in1;
    reg signed [31:0] MUL_1_in2;
    wire signed [63:0] MUL_1_temp;
    wire signed [31:0] MUL_1_out;

    always @(*) begin
        case (state)
            1: begin
                MUL_1_in1 = i1;
                MUL_1_in2 = i2;
            end
            3: begin
                MUL_1_in1 = w4;
                MUL_1_in2 = i4;
            end
            5: begin
                MUL_1_in1 = w8;
                MUL_1_in2 = i6;
            end
            default: begin
                MUL_1_in1 = 0;
                MUL_1_in2 = 0;
            end
        endcase
    end

    assign MUL_1_temp =
        (state == 1) ? ($signed(MUL_1_in1) * $signed(MUL_1_in2)) :
        (state == 3) ? ($signed(MUL_1_in1) * $signed(MUL_1_in2)) :
        (state == 5) ? ($signed(MUL_1_in1) * $signed(MUL_1_in2)) : 64'sd0;

    assign MUL_1_out = MUL_1_temp[31:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w2 <= 32'sd0;
            w6 <= 32'sd0;
            w10 <= 32'sd0;
        end else begin
            if (state == 1)
                w2 <= MUL_1_out;
            if (state == 3)
                w6 <= MUL_1_out;
            if (state == 5)
                w10 <= MUL_1_out;
        end
    end

    // Resource: ALU_1
    reg signed [31:0] ALU_1_in1;
    reg signed [31:0] ALU_1_in2;
    wire signed [31:0] ALU_1_out;

    always @(*) begin
        case (state)
            2: begin
                ALU_1_in1 = w2;
                ALU_1_in2 = i3;
            end
            4: begin
                ALU_1_in1 = w6;
                ALU_1_in2 = i5;
            end
            6: begin
                ALU_1_in1 = w10;
                ALU_1_in2 = i7;
            end
            default: begin
                ALU_1_in1 = 0;
                ALU_1_in2 = 0;
            end
        endcase
    end

    assign ALU_1_out =
        (state == 2) ? ($signed(ALU_1_in1) + $signed(ALU_1_in2)) :
        (state == 4) ? ($signed(ALU_1_in1) + $signed(ALU_1_in2)) :
        (state == 6) ? ($signed(ALU_1_in1) + $signed(ALU_1_in2)) : 32'sd0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w4 <= 32'sd0;
            w8 <= 32'sd0;
            w12 <= 32'sd0;
        end else begin
            if (state == 2)
                w4 <= ALU_1_out;
            if (state == 4)
                w8 <= ALU_1_out;
            if (state == 6)
                w12 <= ALU_1_out;
        end
    end

endmodule
