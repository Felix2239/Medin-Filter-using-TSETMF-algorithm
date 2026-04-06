`timescale 1ns/1ps

module tb_H0;
    reg clk, rst_n, en, clear, mode;
    reg [4:0] count;
    wire [15:0] H0_res;
    reg [15:0] expected;
    integer errors;

    // Instance module H0
    H0 uut (
        .clk(clk), .rst_n(rst_n), .en(en),
        .count(count), .clear(clear), .mode(mode),
        .H0_res(H0_res)
    );

    always #5 clk = ~clk;

    task check_equal;
        input [15:0] got;
        input [15:0] exp;
        input [127:0] msg;
        begin
            if (got !== exp) begin
                errors = errors + 1;
                $display("[FAIL] t=%0t %0s | got=%0d expected=%0d", $time, msg, got, exp);
            end else begin
                $display("[PASS] t=%0t %0s | value=%0d", $time, msg, got);
            end
        end
    endtask

    task apply_and_check;
        input [4:0] i_count;
        input i_mode;
        begin
            mode = i_mode;
            count = i_count;
            clear = 1'b0;

            @(posedge clk);
            #1;

            // H0 chỉ cộng khi count > 0
            if (count > 0) begin
                if (mode == 1'b0)
                    expected = expected + lut3(count[3:0]);
                else
                    expected = expected + lut5(count);
            end

            check_equal(H0_res, expected, "apply_and_check");
        end
    endtask

    function [15:0] lut3;
        input [3:0] c;
        begin
            case (c)
                4'd0: lut3 = 16'd0;
                4'd1: lut3 = 16'd250;
                4'd2: lut3 = 16'd342;
                4'd3: lut3 = 16'd375;
                4'd4: lut3 = 16'd369;
                4'd5: lut3 = 16'd334;
                4'd6: lut3 = 16'd277;
                4'd7: lut3 = 16'd200;
                4'd8: lut3 = 16'd107;
                default: lut3 = 16'd0;
            endcase
        end
    endfunction

    function [15:0] lut5;
        input [4:0] c;
        begin
            case (c)
                5'd0 : lut5 = 16'd0;
                5'd1 : lut5 = 16'd132;
                5'd2 : lut5 = 16'd207;
                5'd3 : lut5 = 16'd261;
                5'd4 : lut5 = 16'd300;
                5'd5 : lut5 = 16'd330;
                5'd6 : lut5 = 16'd351;
                5'd7 : lut5 = 16'd365;
                5'd8 : lut5 = 16'd373;
                5'd9 : lut5 = 16'd377;
                5'd10: lut5 = 16'd375;
                5'd11: lut5 = 16'd370;
                5'd12: lut5 = 16'd361;
                5'd13: lut5 = 16'd348;
                5'd14: lut5 = 16'd333;
                5'd15: lut5 = 16'd314;
                5'd16: lut5 = 16'd292;
                5'd17: lut5 = 16'd269;
                5'd18: lut5 = 16'd242;
                5'd19: lut5 = 16'd214;
                5'd20: lut5 = 16'd183;
                5'd21: lut5 = 16'd150;
                5'd22: lut5 = 16'd115;
                5'd23: lut5 = 16'd79;
                5'd24: lut5 = 16'd40;
                5'd25: lut5 = 16'd0;
                default: lut5 = 16'd0;
            endcase
        end
    endfunction

    initial begin
        $dumpfile("tb_H0.vcd");
        $dumpvars(0, tb_H0);

        clk = 1'b0;
        rst_n = 1'b0;
        en = 1'b0;
        clear = 1'b0;
        mode = 1'b0;
        count = 5'd0;
        expected = 16'd0;
        errors = 0;

        $display("\n==================== TB_H0 START ====================");

        // reset check
        repeat (2) @(posedge clk);
        #1;
        check_equal(H0_res, 16'd0, "after reset low");

        rst_n = 1'b1;
        en = 1'b1;

        // 3x3 mode accumulation
        apply_and_check(5'd4, 1'b0); // +369
        apply_and_check(5'd5, 1'b0); // +334 => 703
        apply_and_check(5'd0, 1'b0); // +0   => 703

        // en gating: hold value when en=0
        en = 1'b0;
        count = 5'd3;
        @(posedge clk);
        #1;
        check_equal(H0_res, expected, "en=0 hold value");

        // clear priority (independent from en)
        clear = 1'b1;
        @(posedge clk);
        #1;
        expected = 16'd0;
        check_equal(H0_res, expected, "clear asserted");
        clear = 1'b0;

        // 5x5 mode accumulation
        en = 1'b1;
        apply_and_check(5'd10, 1'b1); // +375
        apply_and_check(5'd2,  1'b1); // +207 => 582
        apply_and_check(5'd25, 1'b1); // +0   => 582

        if (errors == 0)
            $display("[RESULT] TB_H0 PASSED (no mismatches)");
        else
            $display("[RESULT] TB_H0 FAILED with %0d mismatch(es)", errors);

        $display("===================== TB_H0 END =====================\n");
        #10 $finish;
    end

endmodule