module LeftRotate(dataIn, dataOut, index);
    parameter WIDTH = 32;
    input [WIDTH-1:0] dataIn;
    input [5:0] index;
    output [WIDTH-1:0] dataOut;

    localparam ADDR_WIDTH = $clog2(WIDTH);
    
    reg [ADDR_WIDTH-1:0] STEPS [0:63];
    
    integer i;
    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            case (i % 4)
                0: STEPS[i] = 7;
                1: STEPS[i] = 12;
                2: STEPS[i] = 17;
                3: STEPS[i] = 22;
            endcase
        end
        
        for (i = 16; i < 32; i = i + 1) begin
            case (i % 4)
                0: STEPS[i] = 5;
                1: STEPS[i] = 9;
                2: STEPS[i] = 14;
                3: STEPS[i] = 20;
            endcase
        end
        
        for (i = 32; i < 48; i = i + 1) begin
            case (i % 4)
                0: STEPS[i] = 4;
                1: STEPS[i] = 11;
                2: STEPS[i] = 16;
                3: STEPS[i] = 23;
            endcase
        end
        
        for (i = 48; i < 64; i = i + 1) begin
            case (i % 4)
                0: STEPS[i] = 6;
                1: STEPS[i] = 10;
                2: STEPS[i] = 15;
                3: STEPS[i] = 21;
            endcase
        end
    end

    wire [ADDR_WIDTH-1:0] rotateAmount;
    assign rotateAmount = STEPS[index];

    assign dataOut = (dataIn << rotateAmount) | (dataIn >> (WIDTH - rotateAmount));
endmodule