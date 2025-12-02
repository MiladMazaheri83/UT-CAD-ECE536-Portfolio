module FullAdder(
    a,
    b,
    cin,
    sum,
    cout
);
    input wire a, b, cin;
    output wire sum, cout;

    Xor3 FullAdderSumBlock(
        .a(a),
        .b(b),
        .c(cin),
        .out(sum)
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