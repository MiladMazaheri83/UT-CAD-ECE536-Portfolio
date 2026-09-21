`timescale 1ns/1ns

module StripesTestBench;
    logic clk, rst;
    logic iIsMsb, iIsLsb, iValid, initZero;
    logic [63:0] iVecB;
    logic [3:0] iVecABits;
    logic [33:0] initialSum;
    logic [33:0] oDotProduct;
    
    always #5 clk = ~clk;
    
    StripesPE dut (
        .clk(clk),
        .rst(rst),
        .iIsMsb(iIsMsb),
        .iIsLsb(iIsLsb),
        .iValid(iValid),
        .initZero(initZero),
        .iVecB(iVecB),
        .iVecABits(iVecABits),
        .initialSum(initialSum),
        .oDotProduct(oDotProduct)
    );
    
    task run_test(
        input [15:0] a0, a1, a2, a3,
        input [15:0] b0, b1, b2, b3
    );
        
        iVecB = {b3, b2, b1, b0};
        
        initZero = 1'b1;
        @(posedge clk);
        initZero = 1'b0;
        
        for (int bit_pos = 15; bit_pos >= 0; bit_pos--) begin
            iVecABits[0] = a0[bit_pos];
            iVecABits[1] = a1[bit_pos];
            iVecABits[2] = a2[bit_pos];
            iVecABits[3] = a3[bit_pos];
            
            iIsMsb = (bit_pos == 15);
            iIsLsb = (bit_pos == 0);
            iValid = 1'b1;

            @(posedge clk);
        end
        
        iValid = 1'b0;
        repeat(5) @(posedge clk);
    endtask
    
    initial begin
        clk = 0;
        rst = 1;
        iIsMsb = 0;
        iIsLsb = 0;
        iValid = 0;
        initZero = 0;
        iVecB = 0;
        iVecABits = 0;
        initialSum = 0;
        

        repeat(2) @(posedge clk);
        rst = 0;
        @(posedge clk);
        
        run_test(16'd1, 16'd3, 16'd6, 16'd2,
                 16'd3, 16'd5, 16'd5, 16'd1);
                 
        repeat(5) @(posedge clk);
        
        run_test(16'd1, -16'd4, 16'd6, 16'd3,
                 16'd2, 16'd6, -16'd1, 16'd7);
        
        repeat(5) @(posedge clk);
        $stop;
    end
    
endmodule