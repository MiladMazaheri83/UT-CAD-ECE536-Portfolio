module RippleCarryAdder8bit (
    A,
    B,
    SUM,
);

    input  wire [7:0] A, B;
    output wire [7:0] SUM;
    wire [7:0] C;

    HalfAdder HA0 (.a(A[0]), .b(B[0]), .sum(SUM[0]), .cout(C[0]));

    FullAdder FA1 (.a(A[1]), .b(B[1]), .cin(C[0]), .sum(SUM[1]), .cout(C[1]));
    FullAdder FA2 (.a(A[2]), .b(B[2]), .cin(C[1]), .sum(SUM[2]), .cout(C[2]));
    FullAdder FA3 (.a(A[3]), .b(B[3]), .cin(C[2]), .sum(SUM[3]), .cout(C[3]));
    FullAdder FA4 (.a(A[4]), .b(B[4]), .cin(C[3]), .sum(SUM[4]), .cout(C[4]));
    FullAdder FA5 (.a(A[5]), .b(B[5]), .cin(C[4]), .sum(SUM[5]), .cout(C[5]));
    FullAdder FA6 (.a(A[6]), .b(B[6]), .cin(C[5]), .sum(SUM[6]), .cout(C[6]));
    FullAdder FA7 (.a(A[7]), .b(B[7]), .cin(C[6]), .sum(SUM[7]), .cout(C[7]));
    

endmodule
