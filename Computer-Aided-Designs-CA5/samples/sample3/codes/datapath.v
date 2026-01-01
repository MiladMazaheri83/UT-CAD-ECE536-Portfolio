module datapath(
    input clk,
    input rst,
    input [2:0] state,
    input [31:0] i1, input [31:0] i2,
    output [31:0] result
);

    reg [31:0] r_2;
    reg [31:0] r_3;
    reg [31:0] r_4;
    reg [31:0] r_5;
    reg [31:0] r_6;
    reg [31:0] r_7;
    reg [31:0] r_8;

    wire [31:0] MUL_1_left;
    wire [31:0] MUL_1_right;
    wire [31:0] MUL_1_res;
    assign MUL_1_left = (state == 1) ? i1 : 32'd0;
    assign MUL_1_right = (state == 1) ? i2 : 32'd0;
    assign MUL_1_res = (state == 1) ? (MUL_1_left * MUL_1_right) : 32'd0;

    wire [31:0] LOG_1_left;
    wire [31:0] LOG_1_right;
    wire [31:0] LOG_1_res;
    assign LOG_1_left = (state == 1) ? i1 : (state == 2) ? i1 : 32'd0;
    assign LOG_1_right = (state == 1) ? i2 : (state == 2) ? i2 : 32'd0;
    assign LOG_1_res = (state == 1) ? (LOG_1_left & LOG_1_right) : (state == 2) ? (LOG_1_left | LOG_1_right) : 32'd0;

    wire [31:0] ALU_1_left;
    wire [31:0] ALU_1_right;
    wire [31:0] ALU_1_res;
    assign ALU_1_left = (state == 2) ? r_2 : (state == 1) ? i1 : (state == 3) ? r_4 : (state == 4) ? r_6 : 32'd0;
    assign ALU_1_right = (state == 2) ? r_3 : (state == 1) ? i2 : (state == 3) ? r_5 : (state == 4) ? r_7 : 32'd0;
    assign ALU_1_res = (state == 2) ? (ALU_1_left + ALU_1_right) : (state == 1) ? (ALU_1_left - ALU_1_right) : (state == 3) ? (ALU_1_left + ALU_1_right) : (state == 4) ? (ALU_1_left + ALU_1_right) : 32'd0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            r_2 <= 0;
            r_3 <= 0;
            r_4 <= 0;
            r_5 <= 0;
            r_6 <= 0;
            r_7 <= 0;
            r_8 <= 0;
        end else begin
            if (state == 1) r_2 <= MUL_1_res;
            if (state == 1) r_3 <= LOG_1_res;
            if (state == 2) r_4 <= ALU_1_res;
            if (state == 1) r_5 <= ALU_1_res;
            if (state == 3) r_6 <= ALU_1_res;
            if (state == 2) r_7 <= LOG_1_res;
            if (state == 4) r_8 <= ALU_1_res;
        end
    end

    assign result = r_8;
endmodule