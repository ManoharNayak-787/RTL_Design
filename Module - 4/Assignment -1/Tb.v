// Code your testbench here
// or browse Examples
module fp_adder_tb;
    parameter INTEGER_WIDTH_A = 5;
    parameter FRACTION_WIDTH_A = 14;
    parameter INTEGER_WIDTH_B = 5;  
    parameter FRACTION_WIDTH_B = 14; 
    parameter O_INTEGER_WIDTH = 6; 
    parameter O_FRACTION_WIDTH = 12;
    reg [((INTEGER_WIDTH_A + FRACTION_WIDTH_A)-1):0] a;
    reg [((INTEGER_WIDTH_B + FRACTION_WIDTH_B)-1):0] b;
    wire [((O_INTEGER_WIDTH+O_FRACTION_WIDTH)-1):0] sum;
    reg sign;
    wire overflow; 
    wire underflow;
    fp_adder fp1 (.a(a),.b(b),.sum(sum),.sign(sign),.overflow(overflow),.underflow(underflow));
always #5 clk=~clk;
initial begin
clk=1;
sign=1;
#10;
for(i=0;i<15;i=i+1)
begin
a=$random;
b=$random;
#20;
end
end
endmodule
