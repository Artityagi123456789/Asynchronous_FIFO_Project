`include "async_fifo.v"

module tb;
parameter DEPTH=16, WIDTH=8, PTR_WIDTH=4;
parameter WR_CLK_TP=10, RD_CLK_TP=8;

reg wr_clk_i,rd_clk_i,rst_i,wr_en_i,rd_en_i;
reg [WIDTH-1:0]wdata_i;
wire [WIDTH-1:0]rdata_o;
wire full_o,empty_o,wr_error_o,rd_error_o;
integer i;

reg [30*8:1]testname;


asyn_fifo #(.WIDTH(WIDTH), .DEPTH(DEPTH), .PTR_WIDTH(PTR_WIDTH)) dut(wr_clk_i,rd_clk_i,rst_i,wdata_i,full_o,wr_en_i,wr_error_o,rdata_o,empty_o,rd_en_i,rd_error_o);

initial begin
	wr_clk_i =0;
	forever #(WR_CLK_TP/2.0) wr_clk_i = ~wr_clk_i;
end	
initial begin
	rd_clk_i =0;
	forever #(RD_CLK_TP/2.0) rd_clk_i = ~rd_clk_i;
end	
initial begin
	$value$plusarg("testcase=%s",testname);
	rst_i = 1;
	wdata_i =0;
	wr_en_i = 0;
	rd_en_i=0;
	@(posedge wr_clk_i);
	rst_i = 0;
	case(testname)
		"test_full":begin
			write_fifo(DEPTH);
		end
		"test_empty_error":begin
			write_fifo(DEPTH);
			read_fifo(DEPTH+1);
		end
			 endcase
   	 write_fifo(DEPTH);
	 read_fifo(DEPTH);
	 #100;
	 $finish;
end
task write_fifo(input integer num_wr);
begin
	for(i=0; i<num_wr;i=i+1)begin
	@(posedge wr_clk_i);
	wdata_i = $random;
	wr_en_i=1;	
	end
	@(posedge wr_clk_i);
	wr_en_i=0;
	wdata_i = 0;
end
endtask
task read_fifo(input integer num_rd);
begin
	for(i=0; i<num_rd;i=i+1)begin
	@(posedge rd_clk_i);
	rd_en_i=1;
	end
	@(posedge rd_clk_i);
	rd_en_i=0;
end
endtask
endmodule


























