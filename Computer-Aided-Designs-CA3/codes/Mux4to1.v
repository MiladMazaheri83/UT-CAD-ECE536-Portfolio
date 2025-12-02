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
    generate;
        for (i = 0; i < 8; i++) begin
            c1 Mux1BitBlock(
                .A0(d00[i]), 
                .A1(d01[i]), 
                .SA(s0),
                .B0(d10[i]),
                .B1(d11[i]),
                .SB(s0),
                .S0(s1),
                .S1(1'b0),
                .f(out[i])
            );
        end
    endgenerate
endmodule