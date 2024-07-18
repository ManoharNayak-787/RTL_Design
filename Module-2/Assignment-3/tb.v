module axi_4096_fifo_tb;
parameter DEPTH = 4096;
    parameter PTR_WIDTH=12;
    
    reg clk,rst,w_en,r_en;
    wire full, empty;
    wire [7:0]data_out_1;
    wire [7:0]data_out_2;
    
    reg [7:0]s_tdata_in;
    reg s_tvalid_in;
    wire s_tready_out;
    reg  s_last_in;
    
    //master
    wire  [7:0]m_tdata_out;
    wire  m_tvalid_out;
    reg m_tready_in;
    wire  m_last_out;

    // Instantiate DUT
   axi_4096_fifo DUT(
       // .data_in(data_in),
        .clk(clk),
        .rst(rst),
        .r_en(r_en),
        .w_en(w_en),
        .empty(empty),
        .data_out_1(data_out_1),
        .full(full),
        .data_out_2(data_out_2),
        .s_tdata_in(s_tdata_in),
        .s_tvalid_in(s_tvalid_in),
        .s_tready_out(s_tready_out),
        .s_last_in(s_last_in),
        .m_tdata_out(m_tdata_out),
        .m_tvalid_out(m_tvalid_out),
        .m_tready_in(m_tready_in),
        .m_last_out(m_last_out)
        
       );
 
   
 initial 
    begin
        clk = 0;
        forever #10 clk = ~clk;
    end
     
initial begin
      rst = 1'b1;
      #30;
      rst = 1'b0;
      
end

initial begin
   forever begin
       repeat(40)@(posedge clk)s_last_in = 1'b0;
       s_last_in =1'b1;
       @(posedge clk) s_last_in =1'b0;
   end
end


initial begin
     s_tdata_in = 0;
    forever begin
        @(posedge clk);
        s_tdata_in = s_tdata_in + 1;
    end
end

     
initial begin
    r_en = 1'b0;
    repeat(4300)@(posedge clk) w_en = 1'b1;
    w_en =1'b0;
    r_en = 1'b1;
end

initial begin
    repeat(4)@(posedge clk) s_tvalid_in=1'b1; 
    repeat(5)@(posedge clk) s_tvalid_in=1'b0; 
    repeat(5)@(posedge clk) s_tvalid_in=1'b1;
    repeat(4)@(posedge clk) s_tvalid_in=1'b0; 
    repeat(4)@(posedge clk) s_tvalid_in=1'b1;
    repeat(4)@(posedge clk) s_tvalid_in=1'b1; 
    repeat(5)@(posedge clk) s_tvalid_in=1'b0; 
    repeat(5)@(posedge clk) s_tvalid_in=1'b1;
    repeat(4)@(posedge clk) s_tvalid_in=1'b0; 
    repeat(4)@(posedge clk) s_tvalid_in=1'b1;
end

/*initial begin
    s_tvalid_in = 1'b1;
end*/

initial begin
    @(posedge clk) m_tready_in=1'b0;
    @(posedge clk) m_tready_in=1'b1;
    repeat(5)@(posedge clk) m_tready_in = 1'b1;
    repeat(2)@(posedge clk) m_tready_in = 1'b0;
    repeat(5)@(posedge clk) m_tready_in = 1'b1;
    repeat(3)@(posedge clk) m_tready_in = 1'b0;
    repeat(8)@(posedge clk) m_tready_in = 1'b1;
    repeat(2)@(posedge clk) m_tready_in = 1'b0; 
    repeat(8)@(posedge clk) m_tready_in = 1'b1;
    repeat(4)@(posedge clk) m_tready_in = 1'b0;
    repeat(6)@(posedge clk) m_tready_in = 1'b1;
    repeat(4)@(posedge clk) m_tready_in = 1'b0;
    repeat(4)@(posedge clk) m_tready_in = 1'b1;
end

endmodule
