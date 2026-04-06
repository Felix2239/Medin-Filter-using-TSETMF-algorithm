module D2(
    input wire clk, 
    input wire rst_n,
    input wire en,

    input wire [7:0] p11, p12, p13, p14, p15,
    input wire [7:0] p21, p22, p23, p24, p25,
    input wire [7:0] p31, p32, p33, p34, p35,
    input wire [7:0] p41, p42, p43, p44, p45,
    input wire [7:0] p51, p52, p53, p54, p55,

    input wire [7:0] T_entro,
    output reg is_noise
);

    wire [7:0] w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13;
    wire [7:0] w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24;

    wire [12:0] res;

    abs_diff inst1(p11, p33, w1);
    abs_diff inst2(p12, p33, w2);
    abs_diff inst3(p13, p33, w3);
    abs_diff inst4(p14, p33, w4);
    abs_diff inst5(p15, p33, w5);

    abs_diff inst6(p21, p33, w6);
    abs_diff inst7(p22, p33, w7);
    abs_diff inst8(p23, p33, w8);
    abs_diff inst9(p24, p33, w9);
    abs_diff inst10(p25, p33, w10);

    abs_diff inst11(p31, p33, w11);
    abs_diff inst12(p32, p33, w12);
    //abs_diff inst13(p33, p33, w13);
    abs_diff inst13(p34, p33, w13);
    abs_diff inst14(p35, p33, w14);

    abs_diff inst15(p41, p33, w15);
    abs_diff inst16(p42, p33, w16);
    abs_diff inst17(p43, p33, w17);
    abs_diff inst18(p44, p33, w18);
    abs_diff inst19(p45, p33, w19);

    abs_diff inst20(p51, p33, w20);
    abs_diff inst21(p52, p33, w21);
    abs_diff inst22(p53, p33, w22);
    abs_diff inst23(p54, p33, w23);
    abs_diff inst24(p55, p33, w24);

    assign res = w1 + w2 + w3 + w4 +w5 + w6 + w7 + w8 + w9 + w10 + w11 + w12 + w13 +
                 w14 + w15 + w16 + w17 + w18 + w19 + w20 + w21 + w22 + w23 + w24;
    
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            is_noise <= 0;
        end
        else if(en) begin
            if(res < ((T_entro << 4) + (T_entro << 3) + T_entro))
                is_noise <= 1;
            else 
                is_noise <= 0; 
        end
        else 
            is_noise <= 0;
    end
endmodule
    