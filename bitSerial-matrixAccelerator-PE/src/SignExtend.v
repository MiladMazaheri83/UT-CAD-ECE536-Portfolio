module SignExtend #(
    parameter INP_SIZE,
    parameter OUT_SIZE
) (
    inp,
    out
);

    input wire [INP_SIZE-1:0] inp;
    output wire [OUT_SIZE-1:0] out;

    assign out = {{(OUT_SIZE-INP_SIZE){inp[INP_SIZE-1]}}, inp};
    
endmodule