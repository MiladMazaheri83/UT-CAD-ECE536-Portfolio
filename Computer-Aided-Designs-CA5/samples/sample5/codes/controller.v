module Controller (
    input clk,
    input rst,
    input start,
    output reg [2:0] state,
    output reg done
);
    parameter IDLE = 0;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
        end else begin
            if (state == IDLE) begin
                if (start) begin
                    state <= 1;
                    done <= 0;
                end
            end else if (state < 4) begin
                state <= state + 1;
                done <= 0;
            end else begin
                state <= IDLE;
                done <= 1;
            end
        end
    end
endmodule
