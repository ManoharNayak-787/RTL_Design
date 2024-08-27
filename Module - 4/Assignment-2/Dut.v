// Code your design here
module fp_multiplier #(parameter
   INTEGER_WIDTH_A = 3,
   FRACTION_WIDTH_A = 14,
   INTEGER_WIDTH_B = 3,
   FRACTION_WIDTH_B = 14,
   TEMP_INT_WIDTH = 6,
   TEMP_FRAC_WIDTH = 28,
   O_INT_WIDTH = 4,
   O_FRAC_WIDTH = 14
    )(input sign,
      input clk,
      input rst,
      input [((INTEGER_WIDTH_A+FRACTION_WIDTH_A)-1):0]a,
      input [((INTEGER_WIDTH_B+FRACTION_WIDTH_B)-1):0]b,
      output [((O_INT_WIDTH+O_FRAC_WIDTH)-1):0]out, 
      output reg overflow,
      output reg underflow);
      reg [((TEMP_INT_WIDTH+TEMP_FRAC_WIDTH)-1):0]temp_out;
      reg signed [((INTEGER_WIDTH_A+FRACTION_WIDTH_A)-1):0]a_sign;
      reg signed [((INTEGER_WIDTH_A+FRACTION_WIDTH_A)-1):0]b_sign;
      reg [O_INT_WIDTH-1:0]mult_i;
      reg [O_FRAC_WIDTH-1:0]mult_f;
      always@(posedge clk)begin
        a_sign<=a;
        b_sign<=b;
      end
      always@(posedge clk)begin
        if(rst)
            temp_out<=0;
        else begin
            if(sign)
                temp_out<=$signed(a_sign) * $signed(b_sign);
            else
                temp_out<=a*b;
        end
     end
     always@(posedge clk)begin
        if(rst)
            overflow<=0;
        else begin
            if(sign)begin
                if(O_INT_WIDTH>=TEMP_INT_WIDTH)
                    overflow<=0;
                else begin
                    if(temp_out[(TEMP_INT_WIDTH+TEMP_FRAC_WIDTH)-1])
                        overflow<= ~(&temp_out[(TEMP_INT_WIDTH+TEMP_FRAC_WIDTH)-1:(((TEMP_INT_WIDTH+TEMP_FRAC_WIDTH)-1)+(TEMP_INT_WIDTH))-(O_FRAC_WIDTH)]);
                    else
                        overflow <= (|temp_out[(TEMP_INT_WIDTH+TEMP_FRAC_WIDTH)-1:((TEMP_INT_WIDTH+TEMP_FRAC_WIDTH)-(TEMP_INT_WIDTH)-O_INT_WIDTH)]);
                end
           end
           else begin
                if(O_INT_WIDTH>=TEMP_INT_WIDTH)
                    overflow<=0;
                else
                    overflow <= (|temp_out[(TEMP_INT_WIDTH+TEMP_FRAC_WIDTH)-1:((TEMP_INT_WIDTH+TEMP_FRAC_WIDTH)-(TEMP_INT_WIDTH)-O_INT_WIDTH)]);
          end
      end    
   end
   always@(posedge clk) begin
    if(rst)
        underflow<=0;
    else begin
        if(sign)begin
            if(O_FRAC_WIDTH>=TEMP_FRAC_WIDTH)
                underflow<=0;
            else if(temp_out[(TEMP_INT_WIDTH+TEMP_FRAC_WIDTH)-1]==1)
                underflow <= ~(&temp_out[TEMP_FRAC_WIDTH-(O_FRAC_WIDTH-1):0]);
            else if(temp_out[(TEMP_INT_WIDTH+TEMP_FRAC_WIDTH)-1]==0)
                underflow <= |temp_out[TEMP_FRAC_WIDTH-(O_FRAC_WIDTH-1):0];
        end
        else begin
            if(O_FRAC_WIDTH>=TEMP_FRAC_WIDTH)
                underflow<=0;
            else
                underflow <= |temp_out[TEMP_FRAC_WIDTH-(O_FRAC_WIDTH-1):0];
        end
    end
  end
  always@(posedge clk)begin
  if(rst)
    mult_i<=0;
  else begin
    if(sign)begin
        if(O_INT_WIDTH == TEMP_INT_WIDTH)
            mult_i<=temp_out[(TEMP_INT_WIDTH+TEMP_FRAC_WIDTH)-1:TEMP_FRAC_WIDTH];
        else if(O_INT_WIDTH>TEMP_INT_WIDTH)
            mult_i<={{(O_INT_WIDTH-TEMP_INT_WIDTH){temp_out[(TEMP_INT_WIDTH+TEMP_FRAC_WIDTH)-1]}},temp_out[((TEMP_INT_WIDTH+TEMP_FRAC_WIDTH)-1):TEMP_FRAC_WIDTH]};
        else if(O_INT_WIDTH<TEMP_INT_WIDTH)
            mult_i<=temp_out[INTEGER_WIDTH_A+TEMP_FRAC_WIDTH:TEMP_FRAC_WIDTH];
    end
    else begin
        if(O_INT_WIDTH == TEMP_INT_WIDTH)
            mult_i<=temp_out[(TEMP_INT_WIDTH+TEMP_FRAC_WIDTH)-1:TEMP_FRAC_WIDTH];
        else if(O_INT_WIDTH>TEMP_INT_WIDTH)
            mult_i<={{(O_INT_WIDTH-TEMP_INT_WIDTH){1'b0}},temp_out[((TEMP_INT_WIDTH+TEMP_FRAC_WIDTH)-1):TEMP_FRAC_WIDTH]};
        else if(O_INT_WIDTH<TEMP_INT_WIDTH)
            mult_i<=temp_out[INTEGER_WIDTH_A+TEMP_FRAC_WIDTH:TEMP_FRAC_WIDTH];
    end
  end
  end
  always@(posedge clk)begin
    if(rst)
        mult_f<=0;
    else begin
        if(O_FRAC_WIDTH>TEMP_FRAC_WIDTH)
            mult_f = {temp_out[TEMP_FRAC_WIDTH-1:0],{(O_FRAC_WIDTH-TEMP_FRAC_WIDTH){1'b0}}};
        else if(O_FRAC_WIDTH<TEMP_FRAC_WIDTH)
            mult_f = temp_out[(TEMP_FRAC_WIDTH-1):(TEMP_FRAC_WIDTH-O_FRAC_WIDTH)];
        else if(O_FRAC_WIDTH==TEMP_FRAC_WIDTH)
            mult_f = temp_out[TEMP_FRAC_WIDTH-1:0];
    end
 end
 assign out = {mult_i,mult_f};
endmodule
