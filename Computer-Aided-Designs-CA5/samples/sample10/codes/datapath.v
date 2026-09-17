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
    output signed [31:0] result
);
    reg signed [31:0] w2;
    reg signed [31:0] w5;
    reg signed [31:0] w6;
    reg signed [31:0] w7;
    reg signed [31:0] w10;
    reg signed [31:0] w11;
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
            default: begin
                MUL_1_in1 = 0;
                MUL_1_in2 = 0;
            end
        endcase
    end

    assign MUL_1_temp =
        (state == 1) ? ($signed(MUL_1_in1) * $signed(MUL_1_in2)) : 64'sd0;

    assign MUL_1_out = MUL_1_temp[31:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w2 <= 32'sd0;
        end else begin
            if (state == 1)
                w2 <= MUL_1_out;
        end
    end

    // Resource: MUL_2
    reg signed [31:0] MUL_2_in1;
    reg signed [31:0] MUL_2_in2;
    wire signed [63:0] MUL_2_temp;
    wire signed [31:0] MUL_2_out;

    always @(*) begin
        case (state)
            1: begin
                MUL_2_in1 = i3;
                MUL_2_in2 = i4;
            end
            default: begin
                MUL_2_in1 = 0;
                MUL_2_in2 = 0;
            end
        endcase
    end

    assign MUL_2_temp =
        (state == 1) ? ($signed(MUL_2_in1) * $signed(MUL_2_in2)) : 64'sd0;

    assign MUL_2_out = MUL_2_temp[31:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w5 <= 32'sd0;
        end else begin
            if (state == 1)
                w5 <= MUL_2_out;
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
                ALU_1_in2 = w5;
            end
            3: begin
                ALU_1_in1 = w6;
                ALU_1_in2 = w11;
            end
            default: begin
                ALU_1_in1 = 0;
                ALU_1_in2 = 0;
            end
        endcase
    end

    assign ALU_1_out =
        (state == 2) ? ($signed(ALU_1_in1) + $signed(ALU_1_in2)) :
        (state == 3) ? ($signed(ALU_1_in1) + $signed(ALU_1_in2)) : 32'sd0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w6 <= 32'sd0;
            w12 <= 32'sd0;
        end else begin
            if (state == 2)
                w6 <= ALU_1_out;
            if (state == 3)
                w12 <= ALU_1_out;
        end
    end

    // Resource: MUL_3
    reg signed [31:0] MUL_3_in1;
    reg signed [31:0] MUL_3_in2;
    wire signed [63:0] MUL_3_temp;
    wire signed [31:0] MUL_3_out;

    always @(*) begin
        case (state)
            1: begin
                MUL_3_in1 = i1;
                MUL_3_in2 = i2;
            end
            default: begin
                MUL_3_in1 = 0;
                MUL_3_in2 = 0;
            end
        endcase
    end

    assign MUL_3_temp =
        (state == 1) ? ($signed(MUL_3_in1) * $signed(MUL_3_in2)) : 64'sd0;

    assign MUL_3_out = MUL_3_temp[31:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w7 <= 32'sd0;
        end else begin
            if (state == 1)
                w7 <= MUL_3_out;
        end
    end

    // Resource: MUL_4
    reg signed [31:0] MUL_4_in1;
    reg signed [31:0] MUL_4_in2;
    wire signed [63:0] MUL_4_temp;
    wire signed [31:0] MUL_4_out;

    always @(*) begin
        case (state)
            1: begin
                MUL_4_in1 = i5;
                MUL_4_in2 = i6;
            end
            default: begin
                MUL_4_in1 = 0;
                MUL_4_in2 = 0;
            end
        endcase
    end

    assign MUL_4_temp =
        (state == 1) ? ($signed(MUL_4_in1) * $signed(MUL_4_in2)) : 64'sd0;

    assign MUL_4_out = MUL_4_temp[31:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w10 <= 32'sd0;
        end else begin
            if (state == 1)
                w10 <= MUL_4_out;
        end
    end

    // Resource: LOG_1
    reg signed [31:0] LOG_1_in1;
    reg signed [31:0] LOG_1_in2;
    wire signed [31:0] LOG_1_out;

    always @(*) begin
        case (state)
            2: begin
                LOG_1_in1 = w7;
                LOG_1_in2 = w10;
            end
            default: begin
                LOG_1_in1 = 0;
                LOG_1_in2 = 0;
            end
        endcase
    end

    assign LOG_1_out =
        (state == 2) ? ($signed(LOG_1_in1) & $signed(LOG_1_in2)) : 32'sd0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w11 <= 32'sd0;
        end else begin
            if (state == 2)
                w11 <= LOG_1_out;
        end
    end

endmodule
