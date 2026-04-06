module H1( //Tinh phan backgroumd
    input wire clk,
    input wire rst_n,
    input wire en,

    input wire [4:0] count,
    input wire clear,
    input wire mode,
    output reg [15:0] H1_res
);
    wire [3:0] bg_count_3x3;
    wire [4:0] bg_count_5x5;

    wire [8:0] En3_res;
    wire [11:0] En5_res;

    assign bg_count_3x3 = 4'd9 - count[3:0];
    assign bg_count_5x5 = 5'd25 - count;

    Entropy_LUT_3x3 inst1(
        .count(count[3:0]),
        .En3_res(En3_res)
    );

    Entropy_LUT_5x5 inst2(
        .count(count),
        .En5_res(En5_res)
    );

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            H1_res <= 16'd0;
        end
        else if(clear) begin
            H1_res <= 16'd0;
        end
        else begin
            if(en) begin
                H1_res <= H1_res + ((mode) ? En5_res : En3_res);
            end
        end
    end
endmodule