`timescale 1ns/1ps

module tb_Threshold_T;
    reg clk;
    reg rst_n;
    reg en;
    reg [15:0] H0;
    reg [15:0] H1;
    reg [7:0] t;
    reg [4:0] count;
    reg full;

    wire [7:0] T_res;

    integer total_tc;
    integer pass_tc;
    integer fail_tc;

    Threshold_T uut (
        .clk(clk), .rst_n(rst_n), .en(en),
        .H0_res(H0), .H1_res(H1), .t(t),
        .count(count),
        .full(full), .Thres_val(T_res)
    );

    always #5 clk = ~clk;

    task run_case;
        input integer tc_id;
        input in_en;
        input in_full;
        input [7:0] in_t;
        input [4:0] in_count;
        input [15:0] in_h0;
        input [15:0] in_h1;
        input [7:0] expected_t;
        begin
            en    = in_en;
            full  = in_full;
            t     = in_t;
            count = in_count;
            H0    = in_h0;
            H1    = in_h1;

            @(posedge clk);
            #1;

            total_tc = total_tc + 1;
            if (T_res === expected_t) begin
                pass_tc = pass_tc + 1;
                $display("TC%0d | IN: en=%0b full=%0b t=%0d count=%0d H0=%0d H1=%0d | OUT=%0d EXP=%0d => PASS",
                         tc_id, en, full, t, count, H0, H1, T_res, expected_t);
            end else begin
                fail_tc = fail_tc + 1;
                $display("TC%0d | IN: en=%0b full=%0b t=%0d count=%0d H0=%0d H1=%0d | OUT=%0d EXP=%0d => FAIL",
                         tc_id, en, full, t, count, H0, H1, T_res, expected_t);
            end
        end
    endtask

    initial begin
        clk      = 0;
        rst_n    = 0;
        en       = 0;
        H0       = 0;
        H1       = 0;
        t        = 0;
        count    = 0;
        full     = 0;
        total_tc = 0;
        pass_tc  = 0;
        fail_tc  = 0;

        $display("\n==============================================================");
        $display("TESTBENCH Threshold_T - Hien thi INPUT/OUTPUT va tong ket PASS");
        $display("==============================================================");

        @(posedge clk);
        #1;
        total_tc = total_tc + 1;
        if (T_res === 8'd0) begin
            pass_tc = pass_tc + 1;
            $display("TC0 | RESET | IN: rst_n=0 en=%0b full=%0b t=%0d count=%0d H0=%0d H1=%0d | OUT=%0d EXP=0 => PASS",
                     en, full, t, count, H0, H1, T_res);
        end else begin
            fail_tc = fail_tc + 1;
            $display("TC0 | RESET | IN: rst_n=0 en=%0b full=%0b t=%0d count=%0d H0=%0d H1=%0d | OUT=%0d EXP=0 => FAIL",
                     en, full, t, count, H0, H1, T_res);
        end

        rst_n = 1;

        // min_En = max sau reset, valid case dau tien => cap nhat T_res = 10
        run_case(1, 1'b1, 1'b0, 8'd10, 5'd1, 16'd200, 16'd150, 8'd10);

        // abs_diff nho hon tiep => update T_res = 20
        run_case(2, 1'b1, 1'b0, 8'd20, 5'd1, 16'd170, 16'd150, 8'd20);

        // abs_diff lon hon min hien tai => khong update
        run_case(3, 1'b1, 1'b0, 8'd30, 5'd1, 16'd300, 16'd180, 8'd20);

        // t = 0 khong hop le => khong update
        run_case(4, 1'b1, 1'b0, 8'd0, 5'd1, 16'd151, 16'd150, 8'd20);

        // t = 254 (L-1) khong hop le theo dieu kien t < L-1
        run_case(5, 1'b1, 1'b0, 8'd254, 5'd1, 16'd151, 16'd150, 8'd20);

        // count = 0 => khong update
        run_case(6, 1'b1, 1'b0, 8'd25, 5'd0, 16'd151, 16'd150, 8'd20);

        // full = 1 => reset min_En, khong doi T_res trong chu ky nay
        run_case(7, 1'b1, 1'b1, 8'd35, 5'd1, 16'd151, 16'd150, 8'd20);

        // sau khi full reset min_En, abs_diff=60 hop le => update T_res = 40
        run_case(8, 1'b1, 1'b0, 8'd40, 5'd1, 16'd260, 16'd200, 8'd40);

        // en = 0 => khong update
        run_case(9, 1'b0, 1'b0, 8'd60, 5'd1, 16'd201, 16'd200, 8'd40);

        $display("--------------------------------------------------------------");
        $display("SUMMARY: TOTAL=%0d | PASS=%0d | FAIL=%0d", total_tc, pass_tc, fail_tc);
        $display("==============================================================\n");

        #10;
        $finish;
    end
endmodule