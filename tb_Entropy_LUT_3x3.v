`timescale 1ns / 1ps

module tb_Entropy_LUT_3x3;

    // Tín hiệu kết nối
    reg [3:0] count;      
    wire [8:0] En3_res;

    // Khởi tạo DUT
    Entropy_LUT_3x3 uut (
        .count(count),
        .En3_res(En3_res)
    );

    integer i;

    initial begin
        $display("--- KIỂM TRA BẢNG ENTROPY LUT 3x3 (N=9) ---");
        $display("Count | Kết quả (1024) | Giá trị thực xấp xỉ");
        $display("--------------------------------------------");

        // Quét từ 0 đến 10 (để kiểm tra cả trường hợp default)
        for (i = 0; i <= 10; i = i + 1) begin
            count = i;
            #10; // Đợi logic tổ hợp ổn định
            
            $display("  %d   |      %d       |     %f", 
                     count, En3_res, En3_res/1024.0);
        end

        // Kiểm tra ngẫu nhiên các giá trị quan trọng
        #10 count = 4'd3; // Điểm cực đại
        #10 count = 4'd9; // Điểm kết thúc (phải bằng 0)

        #20;
        $display("--------------------------------------------");
        $display("MÔ PHỎNG HOÀN TẤT");
        $finish;
    end

endmodule