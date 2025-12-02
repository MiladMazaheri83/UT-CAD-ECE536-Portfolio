module FullAdder(
    a,
    b,
    cin,
    sum,
    cout
);
    input wire a, b, cin;
    output wire sum, cout;

    wire xorAB;

    c1 FullAdderXorBlock(
        .A0(1'b0), 
        .A1(1'b1), 
        .SA(b),
        .B0(1'b1),
        .B1(1'b0),
        .SB(b),
        .S0(1'b0),
        .S1(a),
        .f(xorAB)
    );

    c1 FullAdderSumBlock(
        .A0(1'b0), 
        .A1(1'b1), 
        .SA(cin),
        .B0(1'b1),
        .B1(1'b0),
        .SB(cin),
        .S0(1'b0),
        .S1(xorAB),
        .f(sum)
    );
    
    c1 FullAdderCarryBlock(
        .A0(1'b0), 
        .A1(cin), 
        .SA(b),
        .B0(cin),
        .B1(1'b1),
        .SB(b),
        .S0(1'b0),
        .S1(a),
        .f(cout)
    );
endmodule