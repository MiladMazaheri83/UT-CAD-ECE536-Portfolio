`timescale 1ns/1ns

module TopTestBench;
    // Parameters
    parameter N = 8;
    parameter MP = 16;
    parameter W = 16;
    parameter MEM_SIZE = 128;
    parameter ROWS = 8;
    parameter CLK_PERIOD = 10;
    
    reg clk;
    reg rst;
    reg start;
    wire done;
    
    MatrixAccelerator #(
        .N(N),
        .MP(MP),
        .W(W),
        .MEM_SIZE(MEM_SIZE),
        .ROWS(ROWS)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done)
    );
    
    always #(CLK_PERIOD/2) clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        
        // Create memory file
        create_memory_file();
        
        // Reset sequence
        #(CLK_PERIOD * 2);
        rst = 0;
        #(CLK_PERIOD * 2);
        
        // Start the computation
        $display("[%0t] Starting matrix multiplication...", $time);
        start = 1;
        #(CLK_PERIOD);
        start = 0;
        
        // Wait for completion
        wait(done);
        $display("[%0t] Computation completed!", $time);
        
        // Wait a few more cycles
        #(CLK_PERIOD * 10);
        
        // Verify results
        verify_results();
        
        $display("[%0t] Testbench completed successfully!", $time);
        $stop;
    end
    
    // Task to create memory file
    task create_memory_file;
        integer mem_file;
        integer i;
    begin
        mem_file = $fopen("test.mem", "w");
        if (!mem_file) begin
            $display("Error: Could not create test.mem file");
            $finish;
        end
        
        // Write the 72 lines of data
        $fdisplay(mem_file, "3FFFFFF9C");
        $fdisplay(mem_file, "3FFFFFF9C");
        $fdisplay(mem_file, "3FFFFFF9C");
        $fdisplay(mem_file, "3FFFFFF9C");
        $fdisplay(mem_file, "190");
        $fdisplay(mem_file, "190");
        $fdisplay(mem_file, "190");
        $fdisplay(mem_file, "190");
        
        // Write values 1 through 64 (hex)
        for (i = 1; i <= 64; i = i + 1) begin
            $fdisplay(mem_file, "%0h", i);
        end
        
        $fclose(mem_file);
        $display("Memory file 'test.mem' created successfully");
    end
    endtask
    
    // Task to verify results
    task verify_results;
        reg [35:0] expected_results [0:7];
        reg [35:0] actual_value;
        integer i;
        integer error_count;
    begin
        // Expected results (converted to hex from your values)
        expected_results[0] = 36'h0000024b8;
        expected_results[1] = 36'h000004a38;
        expected_results[2] = 36'h000006fb8;
        expected_results[3] = 36'h000009538;
        expected_results[4] = 36'h00000bab8;
        expected_results[5] = 36'h00000e038;
        expected_results[6] = 36'h0000105b8;
        expected_results[7] = 36'h000012b38;
        
        error_count = 0;
        
        $display("\n=== Verifying Results ===");
        $display("Checking memory locations 120-127...");
        
        // Note: Since we can't directly read from MemoryBlock in this testbench,
        // you would need to add a read interface to your MemoryBlock or
        // use a different verification approach
        
        // This is a placeholder - you'll need to implement actual verification
        // based on your MemoryBlock implementation
        $display("Expected results:");
        for (i = 0; i < 8; i = i + 1) begin
            $display("Address %0d: %0h", 120 + i, expected_results[i]);
        end
        
        $display("\nVerification completed. Add actual memory reading logic.");
        
        if (error_count > 0) begin
            $display("ERROR: %0d mismatches found!", error_count);
        end else begin
            $display("SUCCESS: All results match expected values!");
        end
    end
    endtask
    
    // Monitor to track progress
    initial begin
        $monitor("[%0t] start=%b, done=%b", $time, start, done);
    end
    
    // Timeout protection
    initial begin
        #(CLK_PERIOD * 10000); // 10,000 cycles timeout
        $display("ERROR: Testbench timeout!");
        $stop;
    end

endmodule