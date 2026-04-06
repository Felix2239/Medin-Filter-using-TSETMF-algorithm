module Threshold_T(
    input wire clk,
    input wire rst_n,
    input wire en,

    input wire [15:0] H0_res,
    input wire [15:0] H1_res,
    input wire [7:0] t,
    input wire [4:0] count,
    input wire full,
    
    output reg [7:0] Thres_val
);
    reg [17:0] min_En;
    wire [16:0] abs_diff_val;
    parameter L = 8'd255;

    assign abs_diff_val = (H0_res > H1_res) ? (H0_res - H1_res) : (H1_res < H0_res);

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            min_En <= 18'd262143;
            Thres_val <= 8'd0;
        end

        else if (en) begin
            if(full) begin
                min_En <= 18'd262143;
            end
            else if((t > 0) && (t < L - 1) && (count > 0) && (min_En > abs_diff_val)) begin
                min_En <= abs_diff_val;
                Thres_val <= t;
            end
        end
    end
endmodule