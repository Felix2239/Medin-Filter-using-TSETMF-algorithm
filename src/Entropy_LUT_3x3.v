module Entropy_LUT_3x3(
    input wire [3:0] count,
    output reg [8:0] En3_res
);
    always @(*) begin
        case(count)
            4'd0:   En3_res = 9'd0;
            4'd1:   En3_res = 9'd250;
            4'd2:   En3_res = 9'd342;
            4'd3:   En3_res = 9'd375;
            4'd4:   En3_res = 9'd369;
            4'd5:   En3_res = 9'd334;
            4'd6:   En3_res = 9'd277;
            4'd7:   En3_res = 9'd200;
            4'd8:   En3_res = 9'd107;
            4'd9:   En3_res = 9'd0;
            
            default: En3_res = 9'd0;
            endcase 
        end
    endmodule