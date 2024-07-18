module axis_2_1_mux_tb;
    reg clk =0;
    reg rst;
    reg sel;
    reg [7:0] s_tdata_1_in;
    reg s_tvalid_1_in;
    wire s_tready_1_out;
    reg s_last_1_in;
    reg [7:0] s_tdata_2_in;
    reg s_tvalid_2_in;
    wire s_tready_2_out;
    reg s_last_2_in;
    wire [7:0] m_tdata_out;
    wire m_tvalid_out;
    reg m_tready_in;
    wire m_last_out;

    // Instantiate the module
    axis_2_1_mux dut (
        .clk(clk),
        .rst(rst),
        .s_tdata_1_in(s_tdata_1_in),
        .s_tvalid_1_in(s_tvalid_1_in),
        .s_tready_1_out(s_tready_1_out),
        .s_last_1_in(s_last_1_in),
        .s_tdata_2_in(s_tdata_2_in),
        .s_tvalid_2_in(s_tvalid_2_in),
        .s_tready_2_out(s_tready_2_out),
        .s_last_2_in(s_last_2_in),
        .m_tdata_out(m_tdata_out),
        .m_tvalid_out(m_tvalid_out),
        .m_tready_in(m_tready_in),
        .m_last_out(m_last_out),
        .sel(sel)
    );
    initial begin
        rst = 0;
        #5;
        rst = 1;
    end
    initial begin
    @(posedge clk)
    rst<=1'b0;
    @(posedge clk)
    rst<=1'b1;
    end
    //select signal
    initial begin
    repeat(15)@(posedge clk)
    sel<=1'b0;
    repeat(15)@(posedge clk)
    sel<=1'b1;
    end
    //valid signal for slave 1
    initial begin
    repeat(5)@(posedge clk)begin
    s_tvalid_1_in<=1'b1;
    end
    repeat(4)@(posedge clk)begin
    s_tvalid_1_in<=1'b0;
    end
    repeat(6)@(posedge clk)begin
    s_tvalid_1_in<=1'b1;
    end
     repeat(2)@(posedge clk)begin
    s_tvalid_1_in<=1'b0;
    end
    repeat(5)@(posedge clk)begin
    s_tvalid_1_in<=1'b1;
    end
    repeat(3)@(posedge clk)begin
    s_tvalid_1_in<=1'b0;
    end
    repeat(8)@(posedge clk)begin
    s_tvalid_1_in<=1'b1;
    end
    /*repeat(30)@(posedge clk)begin
    s_tvalid_1_in<=1'b1;
    end*/
    end
    //valid signal for slave 2
    initial begin
    repeat(5)@(posedge clk)begin
    s_tvalid_2_in<=1'b0;
    end
    repeat(4)@(posedge clk)begin
    s_tvalid_2_in<=1'b1;
    end
    repeat(6)@(posedge clk)begin
    s_tvalid_2_in<=1'b0;
    end
    repeat(5)@(posedge clk)begin
    s_tvalid_2_in<=1'b1;
    end
    repeat(5)@(posedge clk)begin
    s_tvalid_2_in<=1'b0;
    end
    /*repeat(30)@(posedge clk)begin
    s_tvalid_2_in<=1'b1;
    end*/
    end
    //data for 1st slave
    initial begin
    repeat(33)@(posedge clk)
    begin
    s_tdata_1_in<=$random;
    end
    end
    //data for 2nd slave
    initial begin
    repeat(33)@(posedge clk)
    begin
    s_tdata_2_in<=$random;
    end
    end
    //slave 1 last signal
    initial begin
    repeat(4)@(posedge clk)begin
    s_last_1_in<=1'b0;
    end
    @(posedge clk)
    s_last_1_in=1'b1;
    repeat(15)@(posedge clk)begin
    s_last_1_in<=1'b0;
    end
    @(posedge clk)
    s_last_1_in=1'b1;
    repeat(6)@(posedge clk)begin
    s_last_1_in<=1'b0;
    end
    @(posedge clk)
    s_last_1_in=1'b1;
    repeat(4)@(posedge clk)begin
    s_last_1_in<=1'b0;
    end
    end
    //slave 2 last signal
    initial begin
    repeat(8)@(posedge clk)begin
    s_last_2_in<=1'b0;
    end
    @(posedge clk)
    s_last_2_in=1'b1;
    repeat(6)@(posedge clk)begin
    s_last_2_in<=1'b0;
    end
    @(posedge clk)
    s_last_2_in=1'b1;
    repeat(9)@(posedge clk)begin
    s_last_2_in<=1'b0;
    end
    end
    //m_ready signal
    initial begin
    repeat(12)@(posedge clk)begin
    m_tready_in<=1'b1;
    end
    repeat(4)@(posedge clk)
    m_tready_in<=1'b0;
    repeat(5)@(posedge clk)begin
    m_tready_in<=1'b1;
    end
    repeat(5)@(posedge clk)
    m_tready_in<=1'b0;
    repeat(7)@(posedge clk)begin
    m_tready_in<=1'b1;
    end
    /*repeat(30)@(posedge clk)begin
    m_tready_in<=1'b0;
    end*/
   $finish;
    end
	always
		#5  clk = ! clk ;
endmodule
