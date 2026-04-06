module D1(
    input wire clk,
    input wire rst_n,
    input wire en,

    input wire [7:0] p11, p12, p13, 
    input wire [7:0] p21, p22, p23, 
    input wire [7:0] p31, p32, p33, 

    input wire [7:0] T_entro,
    output reg is_noise
);
    wire [7:0] w1, w2, w3, w4, w5, w6, w7, w8;
    wire [11:0] res;

    abs_diff inst1(p11, p22, w1);
    abs_diff inst2(p12, p22, w2);
    abs_diff inst3(p13, p22, w3);

    abs_diff inst4(p21, p22, w4);
    //abs_diff inst5(p22, p22, w5); = 0
    abs_diff inst5(p23, p22, w5);
    
    abs_diff inst6(p31, p22, w6);
    abs_diff inst7(p32, p22, w7);
    abs_diff inst8(p33, p22, w8);

    assign res = w1 + w2 + w3 + w4 + w5 + w6 + w7 + w8;

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            is_noise <= 0;
        end

        else if(en) begin
            if(res < ((T_entro << 3) + T_entro)) 
                is_noise <= 1;
            else 
                is_noise <= 0; 
        end
        else 
            is_noise <= 0;
    end
endmodule