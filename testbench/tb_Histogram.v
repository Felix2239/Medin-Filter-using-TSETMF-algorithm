`timescale 1ns/1ps

module tb_Histogram;
    reg [7:0] t;
    reg mode;

    reg [7:0] p [1:5][1:5];
    wire [4:0] count;

    integer total_tc;
    integer pass_tc;
    integer fail_tc;

    Histogram uut (
        .t(t),
        .mode(mode),
        .p11(p[1][1]), .p12(p[1][2]), .p13(p[1][3]), .p14(p[1][4]), .p15(p[1][5]),
        .p21(p[2][1]), .p22(p[2][2]), .p23(p[2][3]), .p24(p[2][4]), .p25(p[2][5]),
        .p31(p[3][1]), .p32(p[3][2]), .p33(p[3][3]), .p34(p[3][4]), .p35(p[3][5]),
        .p41(p[4][1]), .p42(p[4][2]), .p43(p[4][3]), .p44(p[4][4]), .p45(p[4][5]),
        .p51(p[5][1]), .p52(p[5][2]), .p53(p[5][3]), .p54(p[5][4]), .p55(p[5][5]),
        .count(count)
    );

    task set_all;
        input [7:0] value;
        integer i, j;
        begin
            for (i = 1; i <= 5; i = i + 1)
                for (j = 1; j <= 5; j = j + 1)
                    p[i][j] = value;
        end
    endtask

    task print_window;
        begin
            $display("      [%0d %0d %0d %0d %0d]", p[1][1], p[1][2], p[1][3], p[1][4], p[1][5]);
            $display("      [%0d %0d %0d %0d %0d]", p[2][1], p[2][2], p[2][3], p[2][4], p[2][5]);
            $display("      [%0d %0d %0d %0d %0d]", p[3][1], p[3][2], p[3][3], p[3][4], p[3][5]);
            $display("      [%0d %0d %0d %0d %0d]", p[4][1], p[4][2], p[4][3], p[4][4], p[4][5]);
            $display("      [%0d %0d %0d %0d %0d]", p[5][1], p[5][2], p[5][3], p[5][4], p[5][5]);
        end
    endtask

    task run_case;
        input integer tc_id;
        input [8*40-1:0] tc_name;
        input in_mode;
        input [7:0] in_t;
        input [4:0] expected;
        begin
            mode = in_mode;
            t    = in_t;
            #1;

            total_tc = total_tc + 1;
            $display("\nTC%0d - %0s", tc_id, tc_name);
            $display("  Input : mode=%0d t=%0d", mode, t);
            $display("  Window:");
            print_window();
            $display("  Output: count=%0d | Expected=%0d", count, expected);

            if (count === expected) begin
                pass_tc = pass_tc + 1;
                $display("  ==> PASS");
            end else begin
                fail_tc = fail_tc + 1;
                $display("  ==> FAIL");
            end
        end
    endtask

    initial begin
        total_tc = 0;
        pass_tc  = 0;
        fail_tc  = 0;
        mode     = 1'b0;
        t        = 8'd0;

        $display("\n============================================================");
        $display("TB_Histogram - Hien thi ro input/output va tong so PASS/FAIL");
        $display("============================================================");

        // TC1: mode=0, chỉ đếm vùng 3x3 đầu tiên, expected = 4
        set_all(8'd9);
        p[1][1] = 8'd7;
        p[1][2] = 8'd7;
        p[2][2] = 8'd7;
        p[3][3] = 8'd7;
        p[5][5] = 8'd7; // ngoài 3x3, mode=0 phải bỏ qua
        run_case(1, "mode0_count_3x3_only", 1'b0, 8'd7, 5'd4);

        // TC2: mode=0, không có phần tử nào bằng t trong 3x3, expected = 0
        set_all(8'd1);
        p[4][4] = 8'd8; // ngoài 3x3, không ảnh hưởng
        run_case(2, "mode0_no_match", 1'b0, 8'd8, 5'd0);

        // TC3: mode=0, 3x3 đều bằng t, expected = 9
        set_all(8'd0);
        p[1][1] = 8'd3; p[1][2] = 8'd3; p[1][3] = 8'd3;
        p[2][1] = 8'd3; p[2][2] = 8'd3; p[2][3] = 8'd3;
        p[3][1] = 8'd3; p[3][2] = 8'd3; p[3][3] = 8'd3;
        run_case(3, "mode0_all_3x3_match", 1'b0, 8'd3, 5'd9);

        // TC4: mode=1, đếm toàn bộ 5x5, expected = 7
        set_all(8'd2);
        p[1][1] = 8'd5;
        p[1][5] = 8'd5;
        p[2][3] = 8'd5;
        p[3][2] = 8'd5;
        p[3][4] = 8'd5;
        p[4][4] = 8'd5;
        p[5][1] = 8'd5;
        run_case(4, "mode1_count_5x5", 1'b1, 8'd5, 5'd7);

        // TC5: mode=1, toàn bộ 25 phần tử đều match, expected = 25
        set_all(8'd11);
        run_case(5, "mode1_all_match", 1'b1, 8'd11, 5'd25);

        // TC6: mode=1, không có phần tử nào match, expected = 0
        set_all(8'd4);
        run_case(6, "mode1_no_match", 1'b1, 8'd10, 5'd0);

        $display("\n------------------------------------------------------------");
        $display("SUMMARY: TOTAL=%0d | PASS=%0d | FAIL=%0d", total_tc, pass_tc, fail_tc);
        $display("------------------------------------------------------------\n");

        #5;
        $finish;
    end
endmodule
