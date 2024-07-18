module axi_4096_fifo#(parameter DATA_WIDTH=8,
                  parameter DEPTH = 4096,
                  parameter PTR_WIDTH=12)( 
        input clk,rst,w_en,r_en,
        output [DATA_WIDTH-1:0] data_out_2,
        output  full,
        output empty,
        output [DATA_WIDTH-1:0]data_out_1,
        
        
    //slave
    input [DATA_WIDTH-1:0]s_tdata_in,
    input s_tvalid_in,
    output reg s_tready_out,
    input  s_last_in,
    
    
    //master
    output reg [DATA_WIDTH-1:0]m_tdata_out,
    output reg m_tvalid_out,
    input m_tready_in,
    output reg  m_last_out
             );
             
        reg [DATA_WIDTH-1:0]data_in;
        reg f_w_en,f_r_en;
        reg last_reg;
        
        wire ready;
        assign ready = m_tready_in;
        
        always@(posedge clk) begin
            s_tready_out <= ready;
        end
        reg valid;
       
        always@(posedge clk) begin
            
            if(rst) begin
                data_in <= 8'd0;
                valid <= 1'b0;
                m_last_out <= 1'b0;
            end
            else begin
                 if(s_tvalid_in && ready) begin
                    f_w_en <= w_en;
                    f_r_en <= r_en;
                    data_in <= s_tdata_in;
                 end
                 else begin
                    f_w_en <= 1'b0;
                    f_r_en <= 1'b0;
                 end
            end  
        end
           
             
             
wire full_1,full_2,empty_1,empty_2;
reg wr_1,wr_2,rd_1,rd_2;

always@(posedge clk) begin
    m_tvalid_out = valid;
    if (rst) begin
        rd_1 <= 1'b0;
        wr_1 <= 1'b0;
        rd_2 <= 1'b0;
        wr_2 <= 1'b0;
    end 
    else begin
        rd_1 = (~empty_1 && f_r_en) ? 1'b1 : 1'b0;
        wr_1 = (~full_1 && f_w_en) ? 1'b1 : 1'b0;
        rd_2 = (empty_1 && ~empty_2 && f_r_en) ? 1'b1 : 1'b0 ;
        wr_2 = (full_1 && ~full_2 && f_w_en) ? 1'b1 : 1'b0 ; 
    end
end

axi_2048_fifo f1( .data_in(data_in), .clk(clk), .rst(rst), .rd_enb(rd_1), .wr_enb(wr_1), .empty(empty_1), .full(full_1),.data_out(data_out_1));

axi_2048_fifo f2( .data_in(data_in), .clk(clk), .rst(rst), .rd_enb(rd_2), .wr_enb(wr_2), .empty(empty_2), .full(full_2),.data_out(data_out_2));


//full and empty conditions
reg f_1,e_1;
always @(posedge clk,posedge rst) begin
    if (rst) begin
        f_1 <= 1'b0;
        e_1 <= 1'b1;
    end else begin
        f_1 <= full_1 && full_2;
        e_1 <= empty_1 && empty_2;
    end
end

assign full = f_1;
assign empty = e_1;

//delaying the e1 signal by one clock cycle
reg e;
always@(posedge clk) begin
    e <=empty_1;
end

always@(*)begin
    if(valid && s_tvalid_in && ready)
        m_last_out <= 1'b0;
end

always@(*)begin
    if(r_en) begin
        if(e) m_tdata_out <= data_out_2;
        else m_tdata_out <= data_out_1;
        valid <= ~empty?(r_en?s_tvalid_in:0):0;
    end
end
endmodule

module axi_2048_fifo#(parameter DATA_WIDTH=8,PTR_WIDTH=11,DEPTH=2048)(
clk,
rst,
rd_enb,
wr_enb,
full,
empty,
data_in,
data_out
    );
  input clk,rst,rd_enb,wr_enb;
  input [(DATA_WIDTH-1):0]data_in;
  output full,empty;
  output reg [(DATA_WIDTH-1):0]data_out;
  reg [(DATA_WIDTH-1):0]mem[(DEPTH-1):0];
  reg [PTR_WIDTH:0]wr_ptr,rd_ptr;
  integer i;
   //synchronous fifo
  always@(posedge clk)
    if(rst)
      begin
        data_out<=0;
        rd_ptr<=0;
        wr_ptr<=0;
        for(i=0;i < DEPTH;i=i+1)
          mem[i]<=8'b0;
      end
    else
        begin
         //writing data into the memory
        if (wr_enb && ~full)
            begin
            mem[wr_ptr] <= data_in;
            wr_ptr = wr_ptr + 1;
            end
        //reading data from the memory
        if(rd_enb && ~empty)
            begin
            rd_ptr <= rd_ptr + 1;
            data_out <= mem[rd_ptr];
            end
        end
  assign empty = (rd_ptr==wr_ptr);
  assign full =((wr_ptr[(PTR_WIDTH-1):0]==rd_ptr[(PTR_WIDTH-1):0])&&(wr_ptr[PTR_WIDTH]!=rd_ptr[PTR_WIDTH]));
endmodule
