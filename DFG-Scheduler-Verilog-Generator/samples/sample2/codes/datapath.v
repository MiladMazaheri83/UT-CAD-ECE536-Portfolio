module Datapath (
    input clk,
    input rst,
    input [3:0] state,
    input signed [31:0] i1,
    input signed [31:0] i2,
    input signed [31:0] i3,
    output signed [31:0] result
);
    reg signed [31:0] w2;
    reg signed [31:0] w4;
    reg signed [31:0] w5;
    reg signed [31:0] w6;
    reg signed [31:0] w7;
    reg signed [31:0] w8;
    reg signed [31:0] w9;
    reg signed [31:0] w10;
    reg signed [31:0] w11;
    reg signed [31:0] w12;

    assign result = w12;

    // Resource: ALU_1
    reg signed [31:0] ALU_1_in1;
    reg signed [31:0] ALU_1_in2;
    wire signed [31:0] ALU_1_out;

    always @(*) begin
        case (state)
            5: begin
                ALU_1_in1 = i1;
                ALU_1_in2 = i2;
            end
            3: begin
                ALU_1_in1 = i2;
                ALU_1_in2 = i3;
            end
            4: begin
                ALU_1_in1 = w4;
                ALU_1_in2 = w5;
            end
            2: begin
                ALU_1_in1 = i1;
                ALU_1_in2 = w9;
            end
            6: begin
                ALU_1_in1 = w8;
                ALU_1_in2 = w10;
            end
            7: begin
                ALU_1_in1 = w7;
                ALU_1_in2 = w11;
            end
            default: begin
                ALU_1_in1 = 0;
                ALU_1_in2 = 0;
            end
        endcase
    end

    assign ALU_1_out =
        (state == 5) ? ($signed(ALU_1_in1) - $signed(ALU_1_in2)) :
        (state == 3) ? ($signed(ALU_1_in1) + $signed(ALU_1_in2)) :
        (state == 4) ? ($signed(ALU_1_in1) - $signed(ALU_1_in2)) :
        (state == 2) ? ($signed(ALU_1_in1) - $signed(ALU_1_in2)) :
        (state == 6) ? ($signed(ALU_1_in1) + $signed(ALU_1_in2)) :
        (state == 7) ? ($signed(ALU_1_in1) + $signed(ALU_1_in2)) : 32'sd0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w2 <= 32'sd0;
            w4 <= 32'sd0;
            w6 <= 32'sd0;
            w10 <= 32'sd0;
            w11 <= 32'sd0;
            w12 <= 32'sd0;
        end else begin
            if (state == 5)
                w2 <= ALU_1_out;
            if (state == 3)
                w4 <= ALU_1_out;
            if (state == 4)
                w6 <= ALU_1_out;
            if (state == 2)
                w10 <= ALU_1_out;
            if (state == 6)
                w11 <= ALU_1_out;
            if (state == 7)
                w12 <= ALU_1_out;
        end
    end

    // Resource: LOG_1
    reg signed [31:0] LOG_1_in1;
    reg signed [31:0] LOG_1_in2;
    wire signed [31:0] LOG_1_out;

    always @(*) begin
        case (state)
            3: begin
                LOG_1_in1 = i3;
                LOG_1_in2 = i1;
            end
            1: begin
                LOG_1_in1 = i2;
                LOG_1_in2 = i3;
            end
            default: begin
                LOG_1_in1 = 0;
                LOG_1_in2 = 0;
            end
        endcase
    end

    assign LOG_1_out =
        (state == 3) ? ($signed(LOG_1_in1) | $signed(LOG_1_in2)) :
        (state == 1) ? ($signed(LOG_1_in1) & $signed(LOG_1_in2)) : 32'sd0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w5 <= 32'sd0;
            w9 <= 32'sd0;
        end else begin
            if (state == 3)
                w5 <= LOG_1_out;
            if (state == 1)
                w9 <= LOG_1_out;
        end
    end

    // Resource: MUL_1
    reg signed [31:0] MUL_1_in1;
    reg signed [31:0] MUL_1_in2;
    wire signed [31:0] MUL_1_out;

    always @(*) begin
        case (state)
            6: begin
                MUL_1_in1 = w2;
                MUL_1_in2 = w6;
            end
            5: begin
                MUL_1_in1 = i3;
                MUL_1_in2 = i2;
            end
            default: begin
                MUL_1_in1 = 0;
                MUL_1_in2 = 0;
            end
        endcase
    end

    assign MUL_1_out =
        (state == 6) ? ($signed(MUL_1_in1) / $signed(MUL_1_in2)) :
        (state == 5) ? ($signed(MUL_1_in1) / $signed(MUL_1_in2)) : 32'sd0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w7 <= 32'sd0;
            w8 <= 32'sd0;
        end else begin
            if (state == 6)
                w7 <= MUL_1_out;
            if (state == 5)
                w8 <= MUL_1_out;
        end
    end

endmodule
