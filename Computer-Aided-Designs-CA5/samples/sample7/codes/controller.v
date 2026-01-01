module controller(
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
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) state <= 1;
                end
                5: begin
                    state <= IDLE;
                    done <= 1;
                end
                default: state <= state + 1;
            endcase
        end
    end
endmodule