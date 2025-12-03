`timescale 1ns / 1ps

module Mul4to4_tb;

    // Inputs to the DUT
    reg  [3:0] tb_A;
    reg  [3:0] tb_B;

    // Output from the DUT
    wire [7:0] tb_out;

    // For the loop-based test
    integer i, j;
    integer error_count = 0;

    // Instantiate the multiplier
    Mul4to4 dut (
        .A(tb_A),
        .B(tb_B),
        .out(tb_out)
    );

    // Exhaustive test sequence
    initial begin
        $display("--- Starting Exhaustive Test for 4to4Mul ---");
        $dumpfile("multiplier.vcd");
        $dumpvars(0, Mul4to4_tb);

        // Loop through all 256 possible input combinations
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                tb_A = i;
                tb_B = j;
                #10; // Wait for combinational logic to settle

                // Self-checking logic: Compare DUT output with expected result
                if (tb_out !== (i * j)) begin
                    $display("!!! ERROR at Time=%0t: A=%d, B=%d | Output=%d, Expected=%d",
                             $time, tb_A, tb_B, tb_out, (i*j));
                    error_count = error_count + 1;
                end
            end
        end

        #20;
        if (error_count == 0) begin
            $display("--- SUCCESS: All 256 test cases for 4to4Mul passed! ---");
        end else begin
            $display("--- FAILURE: 4to4Mul failed with %d error(s). ---", error_count);
        end

        $finish;
    end

endmodule
