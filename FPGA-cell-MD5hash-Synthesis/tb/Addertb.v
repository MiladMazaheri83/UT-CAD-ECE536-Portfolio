`timescale 1ns / 1ps

module RippleCarryAdder8bit_tb;

    // Inputs to the DUT
    reg  [7:0] tb_A;
    reg  [7:0] tb_B;

    // Output from the DUT
    wire [7:0] tb_SUM;

    // Instantiate the 8-bit adder
    RippleCarryAdder8bit dut (
        .A(tb_A),
        .B(tb_B),
        .SUM(tb_SUM)
    );

    // Test sequence focusing on corner cases
    initial begin
        $display("--- Starting Test for RippleCarryAdder8bit ---");
        $dumpfile("adder.vcd");
        $dumpvars(0, RippleCarryAdder8bit_tb);

        // Test Case 1: Zero test
        tb_A = 8'd0;   tb_B = 8'd0;   #10; // Expected: 0

        // Test Case 2: Simple addition
        tb_A = 8'd25;  tb_B = 8'd17;  #10; // Expected: 42

        // Test Case 3: Max carry propagation
        // Tests the ripple effect across all bits
        tb_A = 8'b0111_1111; tb_B = 8'b0000_0001; #10; // 127 + 1 = 128

        // Test Case 4: No carry propagation
        // Each column adds to 1 without generating carry
        tb_A = 8'hA5; tb_B = 8'h5A; #10; // Expected: 255 (0xFF)

        // Test Case 5: Overflow test (most important)
        // 255 + 1 should wrap around to 0 in 8 bits
        tb_A = 8'd255; tb_B = 8'd1;   #10; // Expected: 0

        $display("--- Test for RippleCarryAdder8bit Finished ---");
        $finish;
    end
    
    // Monitor for easy debugging
    initial begin
        $monitor("Time=%0t | A=%3d, B=%3d | SUM=%3d (0x%h)", 
                 $time, tb_A, tb_B, tb_SUM, tb_SUM);
    end

endmodule
