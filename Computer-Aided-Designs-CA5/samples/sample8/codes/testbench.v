`timescale 1ns/1ps

module TopModule_tb;
    // Clock and control signals
    reg clk;
    reg rst;
    reg start;
    
    // Input signals
    reg [31:0] i1;
    reg [31:0] i2;
    reg [31:0] i3;
    reg [31:0] i4;
    reg [31:0] i5;
    reg [31:0] i6;
    reg [31:0] i7;
    reg [31:0] i8;
    
    // Output signals
    wire [31:0] result;
    wire done;

    // Instantiate DUT
    TopModule uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .i4(i4),
        .i5(i5),
        .i6(i6),
        .i7(i7),
        .i8(i8),
        .result(result),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        start = 0;
        i1 = 32'd1;
        i2 = 32'd2;
        i3 = 32'd3;
        i4 = 32'd4;
        i5 = 32'd5;
        i6 = 32'd6;
        i7 = 32'd7;
        i8 = 32'd8;

        #20;
        rst = 0;
        #10;
        
        // Start computation
        start = 1;
        #10;
        start = 0;
        
        // Wait for completion
        wait(done == 1);
        
        // Display results
        #60;

        $stop;
    end

    // Timeout protection
    initial begin
        #140;
        $display("ERROR: Simulation timeout!");
        $stop;
    end
endmodule
