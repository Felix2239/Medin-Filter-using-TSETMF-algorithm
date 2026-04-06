`timescale 1ns / 1ps

module tb_D1();
    // Inputs
    reg clk;
    reg rst_n;
    reg en;
    reg [7:0] p11, p12, p13, p21, p22, p23, p31, p32, p33;
    reg [7:0] T_entro;

    // Outputs
    wire is_noise;

    // Instantiate Unit Under Test (UUT)
    D1 uut (
        .clk(clk), .rst_n(rst_n), .en(en),
        .p11(p11), .p12(p12), .p13(p13),
        .p21(p21), .p22(p22), .p23(p23),
        .p31(p31), .p32(p32), .p33(p33),
        .T_entro(T_entro),
        .is_noise(is_noise)
    );

    // Clock generation (100MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0; rst_n = 0; en = 0;
        T_entro = 8'd10; // Threshold = 90
        p11=0; p12=0; p13=0; p21=0; p22=0; p23=0; p31=0; p32=0; p33=0;

        // Reset
        #20 rst_n = 1;
        #10 en = 1;

        // Case 1: All pixels same (Sum = 0). Should be NOISE (0 < 90)
        p11=50; p12=50; p13=50; p21=50; p22=50; p23=50; p31=50; p32=50; p33=50;
        #10;
        $display("Time: %t | Sum: 0 | Noise: %b (Expected: 1)", $time, is_noise);

        // Case 2: High variation (Sum = 160). Should NOT be noise (160 > 90)
        // Diff per neighbor = 20. 20 * 8 = 160.
        p22=50;
        p11=70; p12=70; p13=70; p21=70; p23=70; p31=70; p32=70; p33=70;
        #10;
        $display("Time: %t | Sum: 160 | Noise: %b (Expected: 0)", $time, is_noise);

        // Case 3: Low variation (Sum = 40). Should be NOISE (40 < 90)
        // Diff per neighbor = 5. 5 * 8 = 40.
        p22=50;
        p11=55; p12=55; p13=55; p21=55; p23=55; p31=55; p32=55; p33=55;
        #10;
        $display("Time: %t | Sum: 40 | Noise: %b (Expected: 1)", $time, is_noise);

        #20 $finish;
    end
endmodule