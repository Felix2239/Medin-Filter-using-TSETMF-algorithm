module abs_diff(
    input wire [7:0] a,
    input wire [7:0] b,
    output [7:0] res
);
    assign res = (a > b) ? (a - b) : (b - a);
endmodule