module Histogram(
    input wire [7:0] t,
    input wire mode,

    input wire [7:0] p11, p12, p13, p14, p15,
    input wire [7:0] p21, p22, p23, p24, p25,
    input wire [7:0] p31, p32, p33, p34, p35,
    input wire [7:0] p41, p42, p43, p44, p45,
    input wire [7:0] p51, p52, p53, p54, p55,

    output reg [4:0] count
);
    always @(*) begin
        if(mode == 0) begin
            count = (p11 == t) + (p12 == t) + (p13 == t) +
                    (p21 == t) + (p22 == t) + (p23 == t) + 
                    (p31 == t) + (p32 == t) + (p33 == t);
        end
        else if(mode == 1) begin
            count = (p11 == t) + (p12 == t) + (p13 == t) + (p14 == t) + (p15 == t) +
                    (p21 == t) + (p22 == t) + (p23 == t) + (p24 == t) + (p25 == t) +
                    (p31 == t) + (p32 == t) + (p33 == t) + (p34 == t) + (p35 == t) +
                    (p41 == t) + (p42 == t) + (p43 == t) + (p44 == t) + (p45 == t) +
                    (p51 == t) + (p52 == t) + (p53 == t) + (p54 == t) + (p55 == t);
        end
    end 
endmodule