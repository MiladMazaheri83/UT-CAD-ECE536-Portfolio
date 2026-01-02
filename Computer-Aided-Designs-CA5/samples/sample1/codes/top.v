module TopModule (
    input clk,
    input rst,
    input start,
    input signed [31:0] i1,
    input signed [31:0] i2,
    input signed [31:0] i3,
    output signed [31:0] result,
    output done
);
    wire [2:0] state;

    Controller ctrl_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .state(state),
        .done(done)
    );

    Datapath dp_inst (
        .clk(clk),
        .rst(rst),
        .state(state),
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .result(result)
    );
endmodule
