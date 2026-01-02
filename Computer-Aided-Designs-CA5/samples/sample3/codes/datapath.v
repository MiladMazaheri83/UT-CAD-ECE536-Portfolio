module Datapath (
                        input clk,
                        input rst,
                        input [2:0] state,
                        input [31:0] i1,
    input [31:0] i2,
                        output [31:0] result
                    );

                        reg [31:0] w2;
    reg [31:0] w3;
    reg [31:0] w4;
    reg [31:0] w5;
    reg [31:0] w6;
    reg [31:0] w7;
    reg [31:0] w8;

                        assign result = w8;

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

    reg [31:0] LOG_1_in1;
    reg [31:0] LOG_1_in2;
    wire [31:0] LOG_1_out;
    always @(*) begin
        case (state)
            1: begin LOG_1_in1 = i1; LOG_1_in2 = i2; end
            2: begin LOG_1_in1 = i1; LOG_1_in2 = i2; end
            default: begin LOG_1_in1 = 0; LOG_1_in2 = 0; end
        endcase
    end
    assign LOG_1_out = 
(state == 1) ? (LOG_1_in1 & LOG_1_in2) : 
(state == 2) ? (LOG_1_in1 | LOG_1_in2) : 0;
    always @(posedge clk) begin
        if (state == 1) w3 <= LOG_1_out;
        if (state == 2) w7 <= LOG_1_out;
    end

    reg [31:0] ALU_1_in1;
    reg [31:0] ALU_1_in2;
    wire [31:0] ALU_1_out;
    always @(*) begin
        case (state)
            2: begin ALU_1_in1 = w2; ALU_1_in2 = w3; end
            1: begin ALU_1_in1 = i1; ALU_1_in2 = i2; end
            3: begin ALU_1_in1 = w4; ALU_1_in2 = w5; end
            4: begin ALU_1_in1 = w6; ALU_1_in2 = w7; end
            default: begin ALU_1_in1 = 0; ALU_1_in2 = 0; end
        endcase
    end
    assign ALU_1_out = 
(state == 2) ? (ALU_1_in1 + ALU_1_in2) : 
(state == 1) ? (ALU_1_in1 - ALU_1_in2) : 
(state == 3) ? (ALU_1_in1 + ALU_1_in2) : 
(state == 4) ? (ALU_1_in1 + ALU_1_in2) : 0;
    always @(posedge clk) begin
        if (state == 2) w4 <= ALU_1_out;
        if (state == 1) w5 <= ALU_1_out;
        if (state == 3) w6 <= ALU_1_out;
        if (state == 4) w8 <= ALU_1_out;
    end

endmodule
