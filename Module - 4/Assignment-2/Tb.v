// Code your testbench here
// or browse Examples
module fp_multiplier tb(

); localparam INTEGER_WIDTH_A=3,FRACTION_WIDTH_A=14;
localparam INTEGER_WIDTH_B=3,FRACTION_WIDTH_B=14;
localparam O_INT_WIDTH=6,O_FRAC_WIDTH =28;
reg clk;
reg rst;
reg [INTEGER_WIDTH_A+FRACTION_WIDTH_A-1:0]a;
reg[INTEGER_WIDTH_B+FRACTION_WIDTH_B-1:0]b;
reg sign;
wire overflow,underflow;
wire[ O_INT_WIDTH+ O_FRAC_WIDTH-1:0]out;integer i;
fp_multiplier#(INTEGER_WIDTH_A,FRACTION_WIDTH_A,INTEGER_WIDTH_B,FRACTION_WIDTH_B,O_INT_WIDTH,O_FRAC_WIDTH) a1(.clk(clk),.rst(rst),.a(a),.b(b),.sign(sign),.out(out),.overflow(overflow),.underflow(underflow));
always #5 clk=~clk;
initial begin
clk=1;
sign=1;
rst = 1;
#5 rst = 0;
#10;
for(i=0;i<15;i=i+1)
begin
a=$urandom;
b=$urandom;
end
endmodule
