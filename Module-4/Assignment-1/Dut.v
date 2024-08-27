// Code your design here
module fp_adder #(
    parameter INTEGER_WIDTH_A = 5,  // Width of the integer part of a
    parameter FRACTION_WIDTH_A = 14, // Width of the fractional part of a
    parameter INTEGER_WIDTH_B = 5,  // Width of the integer part of b
    parameter FRACTION_WIDTH_B = 14, // Width of the fractional part of b
    parameter O_INTEGER_WIDTH = 6,  // Width of the integer part of the output 
    parameter O_FRACTION_WIDTH = 12 // Width of the fractional part of the output
    //parameter SIGNED = 1             // 1 for signed, 0 for unsigned
)(
    input [((INTEGER_WIDTH_A + FRACTION_WIDTH_A)-1):0] a,    // First Qm.n number
    input [((INTEGER_WIDTH_B + FRACTION_WIDTH_B)-1):0] b,    // Second Qm.n number
    output [((O_INTEGER_WIDTH+O_FRACTION_WIDTH)-1):0] sum, // Sum of a and b
    input sign, //indicates the sign of the inputs
    output reg overflow,          // Overflow flag
    output reg underflow          // Underflow flag
);

    // Calculate the maximum widths for integer and fractional parts
    localparam MAX_INTEGER_WIDTH = (INTEGER_WIDTH_A >= INTEGER_WIDTH_B) ? INTEGER_WIDTH_A : INTEGER_WIDTH_B;
    localparam MAX_FRACTION_WIDTH = (FRACTION_WIDTH_A >= FRACTION_WIDTH_B) ? FRACTION_WIDTH_A : FRACTION_WIDTH_B;
    //localparam TOTAL_WIDTH = MAX_INTEGER_WIDTH + MAX_FRACTION_WIDTH + 1;

    reg [((INTEGER_WIDTH_A+FRACTION_WIDTH_A)-1):FRACTION_WIDTH_A] a_i;
    reg [((INTEGER_WIDTH_B+FRACTION_WIDTH_B)-1):FRACTION_WIDTH_B] b_i;
    reg [((FRACTION_WIDTH_A)-1):0] a_f;
    reg [((FRACTION_WIDTH_B)-1):0] b_f;
    reg [((MAX_INTEGER_WIDTH + MAX_FRACTION_WIDTH)-1):MAX_FRACTION_WIDTH]a_i_max;
    reg [(MAX_FRACTION_WIDTH-1):0]a_f_max;
    reg [((MAX_INTEGER_WIDTH + MAX_FRACTION_WIDTH)-1):MAX_FRACTION_WIDTH]b_i_max;
    reg [(MAX_FRACTION_WIDTH-1):0]b_f_max;
    reg signed [(MAX_INTEGER_WIDTH + MAX_FRACTION_WIDTH)-1:0]a_extend;
    reg signed [(MAX_INTEGER_WIDTH + MAX_FRACTION_WIDTH)-1:0]b_extend;
    reg [(MAX_INTEGER_WIDTH + MAX_FRACTION_WIDTH)-1:0]a_extended;
    reg [(MAX_INTEGER_WIDTH + MAX_FRACTION_WIDTH)-1:0]b_extended;
    reg [O_INTEGER_WIDTH-1:0]out_i;
    reg [O_FRACTION_WIDTH-1:0]out_f;
    
    //separation of integer & fraction parts
    always@(*)begin
        a_i = a[((INTEGER_WIDTH_A + FRACTION_WIDTH_A)-1):FRACTION_WIDTH_A];
        a_f = a[(FRACTION_WIDTH_A-1):0];
        b_i = b[((INTEGER_WIDTH_B + FRACTION_WIDTH_B)-1):FRACTION_WIDTH_B];
        b_f = b[(FRACTION_WIDTH_B-1):0];
    end
    
    // Sign extension of a and b to match the maximum integer width
    always@(*) begin
        if(sign) begin
            if(INTEGER_WIDTH_A > INTEGER_WIDTH_B) begin
                a_i_max = a_i;
                b_i_max = {{(INTEGER_WIDTH_A - INTEGER_WIDTH_B){b_i[INTEGER_WIDTH_B+FRACTION_WIDTH_B-1]}},b_i};
            end
            else if(INTEGER_WIDTH_A == INTEGER_WIDTH_B) begin
                a_i_max = a_i;
                b_i_max = b_i;
            end
            else begin
                a_i_max = {{(INTEGER_WIDTH_B - INTEGER_WIDTH_A){a_i[INTEGER_WIDTH_B+FRACTION_WIDTH_B-1]}},a_i};
                b_i_max = b_i;
             end
        end
        else begin
            if(INTEGER_WIDTH_A > INTEGER_WIDTH_B) begin
                a_i_max = a_i;
                b_i_max = {{(INTEGER_WIDTH_A - INTEGER_WIDTH_B){1'b0}},b_i};
            end
            else if(INTEGER_WIDTH_A == INTEGER_WIDTH_B)begin
                a_i_max = a_i;
                b_i_max = b_i;
            end
            else begin
                a_i_max = {{(INTEGER_WIDTH_B - INTEGER_WIDTH_A){1'b0}},b};
                b_i_max = b_i;
            end
        end
     end
     
     // Sign extension of a and b to match the maximum fraction width
     always@(*) begin
            if(FRACTION_WIDTH_A > FRACTION_WIDTH_B) begin
                a_f_max = a_f;
                b_f_max = {b_f,{(FRACTION_WIDTH_A - FRACTION_WIDTH_B){1'b0}}};
            end
            else begin
               a_f_max = {a_f,{(FRACTION_WIDTH_B - FRACTION_WIDTH_A){1'b0}}};
               b_f_max = b_f;
            end
        end
     
     //assigning the extension bits to a_extend & b_extend
     always@(*)begin
        if(sign) begin
            a_extend = {a_i_max,a_f_max};
            b_extend = {b_i_max,b_f_max};
        end
        else begin
            a_extended = {a_i_max,a_f_max};
            b_extended = {b_i_max,b_f_max};
        end
    end
                 
    // Intermediate sum
    reg [(MAX_INTEGER_WIDTH+MAX_FRACTION_WIDTH):0] full_sum;
    
    // Perform addition
    always@(*) begin
        if(sign)
            full_sum = $signed(a_extend) + $signed(b_extend);
        else
            full_sum = a_extended + b_extended;
    end
    
    //adjusting the bit widths of the output fractional part
    always@(*)begin
        if(O_FRACTION_WIDTH>=MAX_FRACTION_WIDTH)
            out_f = {full_sum[MAX_FRACTION_WIDTH-1:0],{(O_FRACTION_WIDTH-MAX_FRACTION_WIDTH){1'b0}}};
        else
            out_f = full_sum[(MAX_FRACTION_WIDTH-1):(MAX_FRACTION_WIDTH-O_FRACTION_WIDTH)];
    end
    
    //adjusting the bit widths of the output integer part
    always@(*)begin
        if(sign)begin
           if(O_INTEGER_WIDTH>=MAX_INTEGER_WIDTH) begin
                if(full_sum[MAX_INTEGER_WIDTH+1]==0)
                    out_i = {{(O_INTEGER_WIDTH-MAX_INTEGER_WIDTH){1'b0}},full_sum[((MAX_INTEGER_WIDTH+MAX_FRACTION_WIDTH)-1):MAX_FRACTION_WIDTH]};
                else
                    out_i = {{(O_INTEGER_WIDTH-MAX_INTEGER_WIDTH){1'b1}},full_sum[((MAX_INTEGER_WIDTH+MAX_FRACTION_WIDTH)-1):MAX_FRACTION_WIDTH]};
            end
            else
                out_i = full_sum[(O_INTEGER_WIDTH+O_FRACTION_WIDTH-1):O_FRACTION_WIDTH];
        end
        else begin
            if(O_INTEGER_WIDTH>=MAX_INTEGER_WIDTH)
                out_i = full_sum[(MAX_INTEGER_WIDTH+MAX_FRACTION_WIDTH): MAX_FRACTION_WIDTH];
            else
                out_i = full_sum[(O_INTEGER_WIDTH+O_FRACTION_WIDTH-1):O_FRACTION_WIDTH];
        end
   end
   
   //checking the overflow condition
   always@(*)begin
    if(sign)begin
        if(MAX_INTEGER_WIDTH>=O_INTEGER_WIDTH)begin
            if(full_sum[MAX_INTEGER_WIDTH+MAX_FRACTION_WIDTH])
                overflow = ~(&full_sum[MAX_INTEGER_WIDTH+MAX_FRACTION_WIDTH:((MAX_INTEGER_WIDTH+MAX_FRACTION_WIDTH)-(MAX_INTEGER_WIDTH)-O_INTEGER_WIDTH)]);
            else
                overflow = (|full_sum[MAX_INTEGER_WIDTH+MAX_FRACTION_WIDTH-1:((MAX_INTEGER_WIDTH+MAX_FRACTION_WIDTH)-(MAX_INTEGER_WIDTH)-O_INTEGER_WIDTH)]);
        end
        else
            overflow = 0;
        end
    else
        if(O_INTEGER_WIDTH>=MAX_INTEGER_WIDTH)
            overflow = 0;
        else
            overflow = (|full_sum[MAX_INTEGER_WIDTH+MAX_FRACTION_WIDTH-1:((MAX_INTEGER_WIDTH+MAX_FRACTION_WIDTH)-(MAX_INTEGER_WIDTH)-O_INTEGER_WIDTH)]);
    end
    
    //checking the underflow condition
    always@(*)begin
    if(sign)begin
        if(O_FRACTION_WIDTH>=MAX_FRACTION_WIDTH)
            underflow=0;
        else if(full_sum[MAX_INTEGER_WIDTH+MAX_FRACTION_WIDTH]==1)
            underflow = ~(&full_sum[MAX_FRACTION_WIDTH-(O_FRACTION_WIDTH-1):0]);
        else if(full_sum[MAX_INTEGER_WIDTH+MAX_FRACTION_WIDTH]==0)
            underflow = |full_sum[MAX_FRACTION_WIDTH-(O_FRACTION_WIDTH-1):0];
    end
    else begin
        if(O_FRACTION_WIDTH>=MAX_FRACTION_WIDTH)
           underflow=0;
        else
            underflow = |full_sum[MAX_FRACTION_WIDTH-(O_FRACTION_WIDTH-1):0];
   end
   end
    assign sum = {out_i,out_f};
endmodule
