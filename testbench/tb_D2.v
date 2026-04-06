`timescale 1ns / 1ps

module tb_D2();
    // Inputs
    reg clk;
    reg rst_n;
    reg en;
    reg [7:0] p [1:5][1:5]; // Array for easier stimulus generation
    reg [7:0] T_entro;

    // Output
    wire is_noise;

    // Instantiate UUT
    D2 uut (
        .clk(clk), .rst_n(rst_n), .en(en),
        .p11(p[1][1]), .p12(p[1][2]), .p13(p[1][3]), .p14(p[1][4]), .p15(p[1][5]),
        .p21(p[2][1]), .p22(p[2][2]), .p23(p[2][3]), .p24(p[2][4]), .p25(p[2][5]),
        .p31(p[3][1]), .p32(p[3][2]), .p33(p[3][3]), .p34(p[3][4]), .p35(p[3][5]),
        .p41(p[4][1]), .p42(p[4][2]), .p43(p[4][3]), .p44(p[4][4]), .p45(p[4][5]),
        .p51(p[5][1]), .p52(p[5][2]), .p53(p[5][3]), .p54(p[5][4]), .p55(p[5][5]),
        .T_entro(T_entro), .is_noise(is_noise)
    );

    // Clock Generation
    always #5 clk = ~clk;

    // Task to fill the window
    task set_window(input [7:0] center, input [7:0] neighbor);
        integer i, j;
        begin
            for(i=1; i<=5; i=i+1)
                for(j=1; j<=5; j=j+1)
                    p[i][j] = neighbor;
            p[3][3] = center; // Overwrite center
        end
    endtask

    initial begin
        // Initialize
        clk = 0; rst_n = 0; en = 0;
        T_entro = 8'd10; // Threshold = 10 * 25 = 250
        set_window(8'd0, 8'd0);

        #20 rst_n = 1; 
        #10 en = 1;

        // TEST CASE 1: Flat region (No difference)
        // Sum = 0. 0 < 250 -> is_noise should be 1
        set_window(8'd100, 8'd100);
        #10; // Wait for clock edge
        $display("Time: %t | Sum: 0 | Noise: %b (Expected: 1)", $time, is_noise);

        // TEST CASE 2: Low contrast / Noise (Small difference)
        // Center=100, Neighbors=105. Diff per pixel = 5. Total = 5 * 24 = 120.
        // 120 < 250 -> is_noise should be 1
        set_window(8'd100, 8'd105);
        #10;
        $display("Time: %t | Sum: 120 | Noise: %b (Expected: 1)", $time, is_noise);

        // TEST CASE 3: High contrast / Edge (Large difference)
        // Center=100, Neighbors=120. Diff per pixel = 20. Total = 20 * 24 = 480.
        // 480 > 250 -> is_noise should be 0
        set_window(8'd100, 8'd120);
        #10;
        $display("Time: %t | Sum: 480 | Noise: %b (Expected: 0)", $time, is_noise);

        #20 $finish;
    end
endmodule