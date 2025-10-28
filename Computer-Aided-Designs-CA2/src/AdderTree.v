module AdderTree #(
    parameter N = 4,
    parameter W = 16
)(
    in,
    sum
);
    localparam LEVELS = $clog2(N);

    input wire [W-1:0] in [0:N-1];
    output wire [W+LEVELS-1:0] sum;

    wire [W+LEVELS-1:0] levelWire [0:LEVELS][0:N-1];

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1)
            assign levelWire[0][i] = {{LEVELS{in[i][W-1]}}, in[i]};
    endgenerate

    genvar j, level;
    generate
        for (level = 0; level < LEVELS; level = level + 1) begin : LEVELS_GEN
            for (j = 0; j < (N >> (level+1)) + ((N & ((1 << (level+1))-1)) ? 1 : 0); j = j + 1) begin : NODE_GEN
                if (2*j+1 < (N >> level) + ((N & ((1 << level))-1) ? 1 : 0)) begin
                    Adder #(.SIZE(W+LEVELS)) AdderLayer(
                        .a(levelWire[level][2*j]),
                        .b(levelWire[level][2*j+1]),
                        .out(levelWire[level+1][j])
                    );
                end else begin
                    assign levelWire[level+1][j] = levelWire[level][2*j];
                end
            end
        end
    endgenerate

    assign sum = levelWire[LEVELS][0];

endmodule
