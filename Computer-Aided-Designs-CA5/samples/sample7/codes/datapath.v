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
    reg [31:0] w4;
    reg [31:0] w6;
    reg [31:0] w9;
    reg [31:0] w10;
    reg [31:0] w13;
    reg [31:0] w14;

                        assign result = w14;

                        reg [31:0] MUL_1_in1;
    reg [31:0] MUL_1_in2;
    wire [31:0] MUL_1_out;
    always @(*) begin
        case (state)
            1: begin MUL_1_in1 = i1; MUL_1_in2 = i2; end
            2: begin MUL_1_in1 = w2; MUL_1_in2 = i3; end
            3: begin MUL_1_in1 = w4; MUL_1_in2 = i4; end
            default: begin MUL_1_in1 = 0; MUL_1_in2 = 0; end
        endcase
    end
    assign MUL_1_out = 
(state == 1) ? (MUL_1_in1 * MUL_1_in2) : 
(state == 2) ? (MUL_1_in1 * MUL_1_in2) : 
(state == 3) ? (MUL_1_in1 * MUL_1_in2) : 0;
    always @(posedge clk) begin
        if (state == 1) w2 <= MUL_1_out;
        if (state == 2) w4 <= MUL_1_out;
        if (state == 3) w6 <= MUL_1_out;
    end

    reg [31:0] LOG_1_in1;
    reg [31:0] LOG_1_in2;
    wire [31:0] LOG_1_out;
    always @(*) begin
        case (state)
            3: begin LOG_1_in1 = i5; LOG_1_in2 = i6; end
            4: begin LOG_1_in1 = w6; LOG_1_in2 = w9; end
            5: begin LOG_1_in1 = w10; LOG_1_in2 = w13; end
            default: begin LOG_1_in1 = 0; LOG_1_in2 = 0; end
        endcase
    end
    assign LOG_1_out = 
(state == 3) ? (LOG_1_in1 & LOG_1_in2) : 
(state == 4) ? (LOG_1_in1 | LOG_1_in2) : 
(state == 5) ? (LOG_1_in1 | LOG_1_in2) : 0;
    always @(posedge clk) begin
        if (state == 3) w9 <= LOG_1_out;
        if (state == 4) w10 <= LOG_1_out;
        if (state == 5) w14 <= LOG_1_out;
    end

    reg [31:0] LOG_2_in1;
    reg [31:0] LOG_2_in2;
    wire [31:0] LOG_2_out;
    always @(*) begin
        case (state)
            4: begin LOG_2_in1 = i7; LOG_2_in2 = i8; end
            default: begin LOG_2_in1 = 0; LOG_2_in2 = 0; end
        endcase
    end
    assign LOG_2_out = 
(state == 4) ? (LOG_2_in1 & LOG_2_in2) : 0;
    always @(posedge clk) begin
        if (state == 4) w13 <= LOG_2_out;
    end

endmodule
