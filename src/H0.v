module H0( // Tinh Entropy cho phần foreground
    input wire clk,
    input wire rst_n,
    input wire en,

    input wire [4:0] count,
    input wire clear,
    input wire mode, //mode 0 -> 3x3, mode 1 -> 5x5
    output reg [15:0] H0_res
);
    wire [8:0] En3_res;
    wire [11:0] En5_res;

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
            H0_res <= 16'd0;
        end
        else if(clear) begin
            H0_res <= 16'd0;
        end
        else begin
            if(en) begin
                if(count > 0) begin
                    H0_res <= H0_res + ((mode) ? En5_res : En3_res);
                end
            end
        end
    end
endmodule