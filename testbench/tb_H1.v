`timescale 1ns/1ps

module tb_H1;
    reg clk, rst_n, en, clear, mode;
    reg [4:0] count;
    wire [15:0] H1_res;
    reg [15:0] expected;
    integer errors;

    H1 uut (
        .clk(clk), .rst_n(rst_n), .en(en),
        .count(count), .clear(clear), .mode(mode),
        .H1_res(H1_res)
    );

    always #5 clk = ~clk;

    task apply_and_check;
        input [4:0] i_count;
        input i_mode;
        begin
            mode  = i_mode;
            count = i_count;
            clear = 1'b0;

            @(posedge clk);
            #1;

            if (mode == 1'b0)
                expected = expected + lut3(count[3:0]);
            else
                expected = expected + lut5(count);

            if (H1_res !== expected) begin
                errors = errors + 1;
                $display("[FAIL] t=%0t mode=%0d count=%0d H1_res=%0d expected=%0d",
                         $time, mode, count, H1_res, expected);
            end
            else begin
                $display("[PASS] t=%0t mode=%0d count=%0d H1_res=%0d",
                         $time, mode, count, H1_res);
            end
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
        $dumpfile("vcd/tb_H1.vcd");
        $dumpvars(0, tb_H1);

        clk = 1'b0;
        rst_n = 1'b0;
        en = 1'b0;
        clear = 1'b0;
        mode = 1'b0;
        count = 5'd0;
        expected = 16'd0;
        errors = 0;

        $display("\n==================== TB_H1 START ====================");

        repeat (2) @(posedge clk);
        rst_n = 1'b1;
        en   = 1'b1;

        // 3x3 mode checks
        apply_and_check(5'd3, 1'b0); // +375
        apply_and_check(5'd1, 1'b0); // +250 => 625
        apply_and_check(5'd0, 1'b0); // +0   => 625

        // clear behavior check
        clear = 1'b1;
        @(posedge clk);
        #1;
        expected = 16'd0;
        if (H1_res !== expected) begin
            errors = errors + 1;
            $display("[FAIL] t=%0t clear asserted H1_res=%0d expected=%0d", $time, H1_res, expected);
        end else begin
            $display("[PASS] t=%0t clear asserted H1_res=%0d", $time, H1_res);
        end
        clear = 1'b0;

        // 5x5 mode checks
        apply_and_check(5'd10, 1'b1); // +375
        apply_and_check(5'd2,  1'b1); // +207 => 582
        apply_and_check(5'd25, 1'b1); // +0   => 582

        if (errors == 0)
            $display("[RESULT] TB_H1 PASSED (no mismatches)");
        else
            $display("[RESULT] TB_H1 FAILED with %0d mismatch(es)", errors);

        $display("===================== TB_H1 END =====================\n");
        #10 $finish;
    end
endmodule