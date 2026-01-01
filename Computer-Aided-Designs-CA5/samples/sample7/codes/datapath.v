module datapath(
    input clk,
    input rst,
    input [2:0] state,
    input [31:0] i1, input [31:0] i2, input [31:0] i3, input [31:0] i4, input [31:0] i5, input [31:0] i6, input [31:0] i7, input [31:0] i8,
    output [31:0] result
);

    reg [31:0] r_2;
    reg [31:0] r_4;
    reg [31:0] r_6;
    reg [31:0] r_9;
    reg [31:0] r_10;
    reg [31:0] r_13;
    reg [31:0] r_14;

    wire [31:0] MUL_1_left;
    wire [31:0] MUL_1_right;
    wire [31:0] MUL_1_res;
    assign MUL_1_left = (state == 1) ? i1 : (state == 2) ? r_2 : (state == 3) ? r_4 : 32'd0;
    assign MUL_1_right = (state == 1) ? i2 : (state == 2) ? i3 : (state == 3) ? i4 : 32'd0;
    assign MUL_1_res = (state == 1) ? (MUL_1_left * MUL_1_right) : (state == 2) ? (MUL_1_left * MUL_1_right) : (state == 3) ? (MUL_1_left * MUL_1_right) : 32'd0;

    wire [31:0] LOG_1_left;
    wire [31:0] LOG_1_right;
    wire [31:0] LOG_1_res;
    assign LOG_1_left = (state == 1) ? i5 : (state == 4) ? r_6 : (state == 2) ? i7 : (state == 5) ? r_10 : 32'd0;
    assign LOG_1_right = (state == 1) ? i6 : (state == 4) ? r_9 : (state == 2) ? i8 : (state == 5) ? r_13 : 32'd0;
    assign LOG_1_res = (state == 1) ? (LOG_1_left & LOG_1_right) : (state == 4) ? (LOG_1_left | LOG_1_right) : (state == 2) ? (LOG_1_left & LOG_1_right) : (state == 5) ? (LOG_1_left | LOG_1_right) : 32'd0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            r_2 <= 0;
            r_4 <= 0;
            r_6 <= 0;
            r_9 <= 0;
            r_10 <= 0;
            r_13 <= 0;
            r_14 <= 0;
        end else begin
            if (state == 1) r_2 <= MUL_1_res;
            if (state == 2) r_4 <= MUL_1_res;
            if (state == 3) r_6 <= MUL_1_res;
            if (state == 1) r_9 <= LOG_1_res;
            if (state == 4) r_10 <= LOG_1_res;
            if (state == 2) r_13 <= LOG_1_res;
            if (state == 5) r_14 <= LOG_1_res;
        end
    end

    assign result = r_14;
endmodule