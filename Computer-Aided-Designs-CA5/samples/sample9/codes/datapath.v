module datapath(
    input clk,
    input rst,
    input [2:0] state,
    input [31:0] i1, input [31:0] i2, input [31:0] i3, input [31:0] i4, input [31:0] i5, input [31:0] i6,
    output [31:0] result
);

    reg [31:0] r_2;
    reg [31:0] r_4;
    reg [31:0] r_7;
    reg [31:0] r_8;
    reg [31:0] r_10;

    wire [31:0] MUL_1_left;
    wire [31:0] MUL_1_right;
    wire [31:0] MUL_1_res;
    assign MUL_1_left = (state == 1) ? i1 : (state == 4) ? r_8 : 32'd0;
    assign MUL_1_right = (state == 1) ? i2 : (state == 4) ? i6 : 32'd0;
    assign MUL_1_res = (state == 1) ? (MUL_1_left * MUL_1_right) : (state == 4) ? (MUL_1_left * MUL_1_right) : 32'd0;

    wire [31:0] ALU_1_left;
    wire [31:0] ALU_1_right;
    wire [31:0] ALU_1_res;
    assign ALU_1_left = (state == 2) ? r_2 : (state == 1) ? i4 : 32'd0;
    assign ALU_1_right = (state == 2) ? i3 : (state == 1) ? i5 : 32'd0;
    assign ALU_1_res = (state == 2) ? (ALU_1_left + ALU_1_right) : (state == 1) ? (ALU_1_left + ALU_1_right) : 32'd0;

    wire [31:0] LOG_1_left;
    wire [31:0] LOG_1_right;
    wire [31:0] LOG_1_res;
    assign LOG_1_left = (state == 3) ? r_4 : 32'd0;
    assign LOG_1_right = (state == 3) ? r_7 : 32'd0;
    assign LOG_1_res = (state == 3) ? (LOG_1_left & LOG_1_right) : 32'd0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            r_2 <= 0;
            r_4 <= 0;
            r_7 <= 0;
            r_8 <= 0;
            r_10 <= 0;
        end else begin
            if (state == 1) r_2 <= MUL_1_res;
            if (state == 2) r_4 <= ALU_1_res;
            if (state == 1) r_7 <= ALU_1_res;
            if (state == 3) r_8 <= LOG_1_res;
            if (state == 4) r_10 <= MUL_1_res;
        end
    end

    assign result = r_10;
endmodule