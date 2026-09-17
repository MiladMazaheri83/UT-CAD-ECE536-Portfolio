module HalfAdder(
    a,
    b,
    sum,
    cout
);
    input wire a, b;
    output wire sum, cout;

    c1 HalfAdderSumBlock(
        .A0(1'b0), 
        .A1(1'b1), 
        .SA(b),
        .B0(1'b1),
        .B1(1'b0),
        .SB(b),
        .S0(1'b0),
        .S1(a),
        .f(sum)
    );
    
    c1 HalfAdderCarryBlock(
        .A0(1'b0), 
        .A1(1'b0), 
        .SA(b),
        .B0(1'b0),
        .B1(1'b1),
        .SB(b),
        .S0(1'b0),
        .S1(a),
        .f(cout)
    );
endmodule