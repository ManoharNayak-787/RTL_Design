module axis_8bit_reg(
input clk,
input rst,
input [7:0]s_tdata_in,
input s_tvalid_in,
output reg s_tready_out,
input s_last_in,
output [7:0]m_tdata_out,
output m_tvalid_out,
input  m_tready_in,
output m_last_out
    );
    integer cnt;
    reg [7:0]reg_data;
    reg reg_valid;
    reg reg_ready;
    reg reg_last;
    always@(posedge clk)
    begin
    if(!rst)
    begin
    reg_data<=1'b0;
    reg_valid<=1'b0;
    reg_last<=1'b0;
    end
    else
    begin
    if(s_tvalid_in && s_tready_out)
    begin
    reg_data<=s_tdata_in;
    reg_valid<=s_tvalid_in;
    reg_last<=s_last_in;
    end
    else
    begin
    reg_data<=reg_data;
    reg_valid<=1'b0;
    reg_last<=1'b0;
    end
    end
    end
    always@(posedge clk) begin
    if(!rst) begin
        s_tready_out <= 1'b0;
        cnt <= 1'b0;
    end
    else begin
        if(cnt <= 2)begin
            s_tready_out <= 1'b1;
            cnt <= cnt + 1'b1; 
        end
        else if( cnt <= 4 ) begin
            s_tready_out <= 1'b0;
            cnt <= cnt + 1'b1;
        end 
        else cnt <= 1'b0;
    end
    end
   assign m_tdata_out = reg_data;
   assign m_tvalid_out = reg_valid;
   assign m_last_out = reg_last;
endmodule
