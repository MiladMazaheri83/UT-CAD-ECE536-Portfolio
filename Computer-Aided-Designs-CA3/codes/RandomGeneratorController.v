// module RandomGeneratorController (
//     clk,
//     rst,
//     start_rnd,
//     done_rnd,
//     co3,
//     ldCnt3,
//     enCnt3,
//     shiftP1,
//     loadP1
// );

//     input wire clk, rst, start_rnd, co3;
//     output wire ldCnt3, enCnt3, shiftP1, loadP1, done_rnd;
//     wire S00Out, S01Out, S10Out;
//     wire S00in0, S00in1;
//     wire S01in0, S01in1;
//     wire S10in0, S10in1;

//     s2 S00 (
//         .D00(1'b0),
//         .D01(1'b0),
//         .D10(1'b1),
//         .D11(1'b1),
//         .A1(start_rnd),
//         .B1(done_rnd),
//         .A0(co3),
//         .B0(1'b1),
//         .clr(rst),
//         .clk(clk),
//         .out(ldCnt3)
//     );

//     s1 S01 (
//         .D00(1'b0),
//         .D01(1'b1),
//         .D10(1'b1),
//         .D11(1'b1),
//         .A1(start_rnd),
//         .B1(done_rnd),
//         .A0(co3),
//         .clr(rst),
//         .clk(clk),
//         .out(enCnt3)
//     );

//     s1 S10 (
//         .D00(1'b0),
//         .D01(1'b0),
//         .D10(1'b1),
//         .D11(1'b1),
//         .A1(start_rnd),
//         .B1(done_rnd),
//         .A0(co3),
//         .clr(rst),
//         .clk(clk),
//         .out(shiftP1)
//     );

//     And1bit LoadP1And (
//             .a(start_rnd),
//             .b(S00Out),
//             .out(S00in0)
//         );

//     And1bit StartAnd (
//         .a(start_rnd),
//         .b(rst),
//         .out()
//     );
    
//     And1bit ResetAnd (
//         .a(rst),
//         .b(done_rnd),
//         .out()
//     );

//     And1bitBubble Co3And (
//         .abubble(co3),
//         .b(done_rnd),
//         .out()
//     );

//     And1bitBubble DoneAnd (
//         .abubble(done_rnd),
//         .b(rst),
//         .out()
//     );

//     And1bitBubble StartRstAnd (
//         .abubble(start_rnd),
//         .b(rst),
//         .out()
//     );

// endmodule