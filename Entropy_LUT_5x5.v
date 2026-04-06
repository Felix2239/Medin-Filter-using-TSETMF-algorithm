module Entropy_LUT_5x5(
    input [4:0] count,
    output reg [11:0] En5_res
);
    always @(*) begin
        case(count)
            5'd0  : En5_res = 12'd0;
            5'd1  : En5_res = 12'd132;
            5'd2  : En5_res = 12'd207;
            5'd3  : En5_res = 12'd261;
            5'd4  : En5_res = 12'd300;
            5'd5  : En5_res = 12'd330;
            5'd6  : En5_res = 12'd351;
            5'd7  : En5_res = 12'd365;
            5'd8  : En5_res = 12'd373;
            5'd9  : En5_res = 12'd377;
            5'd10 : En5_res = 12'd375;
            5'd11 : En5_res = 12'd370;
            5'd12 : En5_res = 12'd361;
            5'd13 : En5_res = 12'd348;
            5'd14 : En5_res = 12'd333;
            5'd15 : En5_res = 12'd314;
            5'd16 : En5_res = 12'd292;
            5'd17 : En5_res = 12'd269;
            5'd18 : En5_res = 12'd242;
            5'd19 : En5_res = 12'd214;
            5'd20 : En5_res = 12'd183;
            5'd21 : En5_res = 12'd150;
            5'd22 : En5_res = 12'd115;
            5'd23 : En5_res = 12'd79;
            5'd24 : En5_res = 12'd40;
            5'd25 : En5_res = 12'd0;
            
            default: En5_res = 12'd0;
        endcase
    end
endmodule