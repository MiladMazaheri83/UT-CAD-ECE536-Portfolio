`timescale 1ns/1ns

module TopTestBench;
    logic clk;
    logic rst;
    logic start;
    logic [127:0] inp;
    logic done;
    logic [127:0] out;
    logic [31:0]aInit;
    logic [31:0]bInit;
    logic [31:0]cInit;
    logic [31:0]dInit;
    
    HashGenerator #(.SIZE(128)) dut (
        .clk(clk),
        .rst(rst),
        .aInit(aInit),
        .bInit(bInit),
        .cInit(cInit),
        .dInit(dInit),
        .inp(inp),
        .out(out),
        .start(start),
        .done(done)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        inp = 128'h0;
        aInit = 32'h67452301;
        bInit = 32'hefcdab89;
        cInit = 32'h98badcfe;
        dInit = 32'h10325476;
        
        // Reset sequence
        #20;
        rst = 0;
        #20;
        
        // Apply test input
        inp = 128'h41a801a8e81df62b14a661b85c97bf45;
        start = 1;
        @(posedge clk);
        start = 0;
        
        // Wait for completion
        wait (done == 1);
        #2000;
        $display("Final Hash: %32h", out);
        $display("Expected:   c6f6c75d2bbbb9a586cf3291347acdce");
        
        if (out === 128'hc6f6c75d2bbbb9a586cf3291347acdce) begin
            $display("TEST PASSED - Hash matches expected value!");
        end else begin
            $display("TEST FAILED - Hash mismatch!");
        end
        
        #100;
        $display("Simulation completed.");
        
        $stop;
    end

endmodule