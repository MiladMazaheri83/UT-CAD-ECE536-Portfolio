module RandomGeneratorController(
    clk,
    rst,
    startRnd,
    ldCnt3,
    enCnt3,
    co3,
    shiftP1,
    loadP1,
    doneRnd
);

    input clk, rst, co3, startRnd;
    output reg doneRnd;
    output reg ldCnt3, enCnt3, shiftP1, loadP1;

    localparam [2:0]
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4;

    reg [2:0] ps, ns;

    always @(posedge clk) begin
        if (rst)
            ps <= S0;
        else
            ps <= ns;
    end

    always @(posedge clk) begin
        // default outputs
        ldCnt3  <= 1'b0;
        enCnt3  <= 1'b0;
        shiftP1 <= 1'b0;
        loadP1  <= 1'b0;
        doneRnd <= 1'b0;

        case (ns)
            S0: begin
            end

            S1: begin
            end

            S2: begin
                ldCnt3 <= 1'b1;
                loadP1 <= 1'b1;
            end

            S3: begin
                shiftP1 <= 1'b1;
                enCnt3  <= 1'b1;
            end

            S4: begin
                doneRnd <= 1'b1;
            end
        endcase
    end


    always @(*) begin
        ns = ps;
        case (ps)

            S0: ns = startRnd ? S1 : S0;
                
            S1: ns = startRnd ? S1 : S2;

            S2: ns = S3;

            S3: ns = co3 ? S4 : S3;

            S4: ns = S0;

            default: ns = S0;

        endcase
    end
endmodule