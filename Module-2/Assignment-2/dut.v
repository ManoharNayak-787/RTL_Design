module axis_2_1_mux(
input clk,
input rst,
input sel,
input [7:0]s_tdata_1_in,
input s_tvalid_1_in,
output reg s_tready_1_out,
input s_last_1_in,
input [7:0]s_tdata_2_in,
input s_tvalid_2_in,
output reg s_tready_2_out,
input s_last_2_in,
output reg [7:0]m_tdata_out,
output reg m_tvalid_out,
input m_tready_in,
output reg m_last_out
    );
always @(*) begin
    if (!rst) begin
       m_tdata_out <= 8'b0;
       m_tvalid_out <= 1'b0;
       m_last_out <= 1'b0;
       //s_tready_1_out<=1'b0;
       //s_tready_1_out<=1'b0;
    end
    else begin
        if (sel) begin
            //s_tready_1_out<=m_tready_in;
            if (s_tvalid_1_in && s_tready_1_out) begin
                m_tdata_out <= s_tdata_1_in;
                m_tvalid_out <= s_tvalid_1_in;
                m_last_out  <= s_last_1_in;
            end
            else begin
                m_tvalid_out <= 1'b0;
                m_last_out <= 1'b0;
            end
        end
        else begin
            //s_tready_2_out<=m_tready_in;
            if (s_tvalid_2_in && s_tready_2_out) begin
                m_tdata_out <= s_tdata_2_in;
                m_tvalid_out <= s_tvalid_2_in;
                m_last_out <= s_last_2_in;
            end
            else begin
                m_tvalid_out<= 1'b0;
                m_last_out <= 1'b0;
            end
        end  
    end
end
 
    always@(posedge clk) begin
        if(!rst) begin
            s_tready_1_out<=1'b0;
            s_tready_1_out<=1'b0;
        end
        else begin
            if(sel) begin
                s_tready_1_out<=m_tready_in;
                s_tready_2_out<=1'b0;
            end
            else begin
                s_tready_2_out<=m_tready_in;
                s_tready_1_out<=1'b0;
            end
        end
    end
    
    
endmodule
