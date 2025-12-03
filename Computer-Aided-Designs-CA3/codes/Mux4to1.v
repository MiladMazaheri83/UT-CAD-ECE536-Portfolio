module Mux4to1(
    s0,
    s1,
    d00,
    d01,
    d10,
    d11,
    out
);
    input wire s0, s1;
    input wire [7:0] d00, d01, d10, d11;
    output wire [7:0] out; 
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            Mux4to1oneBit Mux1BitBlock(
                .s0(s0),
                .s1(s1),
                .d00(d00[i]),
                .d01(d01[i]),
                .d10(d10[i]),
                .d11(d11[i]),
                .out(out[i])
            );

        end
    endgenerate
endmodule