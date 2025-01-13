/* module tb_clk_div_10hz;
	reg clk_in;
	wire clk_out;
	
	clk_in_10hz dut(
		.clk_in(clk_in),
		.clk_out(clk_out)
	);
	initial begin
		clk_in = 1'b0;
		#10000000 $stop;
	end
	
	always #5 clk_in <= ~clk_in;
endmodule */

module tb_clk_div_10hz;
	reg clk_in;
	reg [3:0] sw;
	wire [3:0] led;
	
	led_sw_shift dut(clk_in,sw,led);
	
	initial begin
		clk_in = 1'b0;
		sw = 4'b0000;
	end
	
	always #20 clk_in <= ~clk_in;
	
	initial begin
		#0  sw = 4'b0000;
		#100 sw = 4'b0001;
		#100 sw = 4'b0000;
		#100 sw = 4'b0001;
		$stop;
	end
	
endmodule