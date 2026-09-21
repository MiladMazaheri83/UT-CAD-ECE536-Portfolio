`timescale 1ns / 1ps

module And1bitBubble_tb;

    // Inputs to the DUT (Device Under Test)
    reg  tb_abubble;
    reg  tb_b;

    // Output from the DUT
    wire tb_out;

    // Instantiate the module you want to test
    And1bitBubble dut (
        .abubble(tb_abubble),
        .b(tb_b),
        .out(tb_out)
    );

    // Test sequence
    initial begin
        $display("--- Starting Test for And1bitBubble ---");
        $dumpfile("and_bubble.vcd");
        $dumpvars(0, And1bitBubble_tb);

        // Test Case 1: Both inputs are 0
        tb_abubble = 0; tb_b = 0; #10;
        
        // Test Case 2: abubble=0, b=1
        tb_abubble = 0; tb_b = 1; #10;

        // Test Case 3: abubble=1, b=0
        tb_abubble = 1; tb_b = 0; #10;

        // Test Case 4: Both inputs are 1
        tb_abubble = 1; tb_b = 1; #10;

        $display("--- Test for And1bitBubble Finished ---");
        $finish;
    end

    // Monitor to print changes as they happen
    initial begin
        $monitor("Time=%0t | Inputs: abubble=%b, b=%b | Output: out=%b", 
                 $time, tb_abubble, tb_b, tb_out);
    end

endmodule
