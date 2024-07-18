module axis_8bit_reg_tb;

    // Signals
    reg clk = 0;
    reg rst = 0;
    reg [7:0] s_tdata_in;
    reg s_tvalid_in;
    wire s_tready_out;
    reg s_last_in;
    wire [7:0] m_tdata_out;
    wire m_tvalid_out;
    reg m_tready_in;
    wire m_last_out;

    // Instantiate the module
    axis_8bit_reg dut (
        .clk(clk),
        .rst(rst),
        .s_tdata_in(s_tdata_in),
        .s_tvalid_in(s_tvalid_in),
        .s_tready_out(s_tready_out),
        .s_last_in(s_last_in),
        .m_tdata_out(m_tdata_out),
        .m_tvalid_out(m_tvalid_out),
        .m_tready_in(m_tready_in),
        .m_last_out(m_last_out)
    );

    /// Clock generation
   //always #5 clk = ~clk;

    // Reset generation
   initial begin
        rst = 0;
        #5;
        rst = 1;
    end
initial begin
		begin
			@(posedge clk) rst = 0;
			@(posedge clk)
				begin
					rst <= 1;
					m_tready_in <= 1;
					s_tvalid_in <= 1;
                    s_tdata_in <= 2;
                    s_last_in  <= 0;
				end
                @(posedge clk) begin
                    m_tready_in <= 1;
                    s_tvalid_in <= 1;
                    s_tdata_in <= 3;
                    s_last_in  <= 0;
                end
                @(posedge clk) begin
                    m_tready_in <= 1;
                    s_tvalid_in <= 0;
                    s_tdata_in <= 4;
                    s_last_in  <= 0;
                end
                @(posedge clk) begin
                    m_tready_in <= 1;
                    s_tvalid_in <= 1;
                    s_tdata_in <= 5;
                    s_last_in  <= 1;
                end

			@(posedge clk) begin
				m_tready_in <= 1;
				s_tvalid_in <= 1;
                s_tdata_in <= 6;
                s_last_in  <= 0;
			end
			@(posedge clk) begin
				m_tready_in <= 1;
				s_tvalid_in <= 0;
                s_tdata_in <= 8;
                s_last_in  <= 0;
			end
			@(posedge clk) begin
				m_tready_in <= 1;
				s_tvalid_in <= 1;
                s_tdata_in <= 9;
                s_last_in  <= 0;
			end
			@(posedge clk) begin
				m_tready_in <= 1;
				s_tvalid_in <= 1;
                s_tdata_in <= 12;
                s_last_in  <= 0;
			end
			@(posedge clk) begin
				m_tready_in <= 1;
				s_tvalid_in <= 1;
                s_tdata_in <= 15;
                s_last_in  <= 0;
			end
			@(posedge clk) begin
				m_tready_in <= 1;
				s_tvalid_in <= 1;
                s_tdata_in <= 16;
                s_last_in  <= 1;
			end
			@(posedge clk) begin
				m_tready_in <= 1;
				s_tvalid_in <= 1;
                s_tdata_in <= 1;
                s_last_in  <= 0;
			end
			//repeat(5) @(posedge clk);
			@(posedge clk) begin
				m_tready_in <= 1;
				s_tvalid_in <= 10;
                s_tdata_in <= 1;
                s_last_in  <= 0;
			end
			$finish;
		end
	end

	always
		#5  clk = ! clk ;

endmodule
