`timescale 1ns / 1ps

module tb_Entropy_LUT_5x5;

    // Tín hiệu kết nối với DUT
    reg [4:0] count;
    wire [11:0] En_res;

    // Khai báo module cần kiểm tra (DUT)
    Entropy_LUT_5x5 uut (
        .count(count),
        .En5_res(En_res)
    );

    // Biến dùng cho vòng lặp kiểm tra
    integer i;

    initial begin
        // --- Bắt đầu mô phỏng ---
        $display("--- KIEM TRA BANG ENTROPY LUT 5x5 (N=25) ---");
        $display("Count | Ket qua (1024) | Gia tri thuc (approx)");
        $display("--------------------------------------------");

        // Quét toàn bộ dải giá trị từ 0 đến 25
        for (i = 0; i <= 25; i = i + 1) begin
            count = i;
            #10; // Đợi một khoảng thời gian nhỏ để logic cập nhật
            
            $display("  %d   |      %d       |     %f", 
                     count, En_res, En_res/1024.0);
        end

        // Kiểm tra trường hợp Default (ví dụ số 31 nằm ngoài dải 0-25)
        #10 count = 5'd31;
        #10;
        $display("  %d  |      %d       | (Default Case)", count, En_res);

        #20;
        $display("--------------------------------------------");
        $display("MO PHONG HOAN TAT");
        $finish;
    end

endmodule