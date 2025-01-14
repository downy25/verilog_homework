module top_led_ctr(clk_in,sw,led);
	input clk_in;
	input [3:0] sw;
	output [3:0] led;
	
	wire [3:0] led;
	wire clk_out;
	wire clk_nhz;
	
	//125Mhz -> 5Mhz ip
	clk_5mhz dut0
   (
        // Clock out ports
        .clk_out1(clk_out),     // output clk_out1
        // Clock in ports
        .clk_in1(clk_in)      // input clk_in1
    );
	//5Mhz -> 10hz
	clk_in_10hz dut1(clk_out,clk_nhz); 
	//sw , led
	led_sw_shift dut2(clk_nhz,sw,led);
endmodule

module clk_in_10hz(clk_in,clk_out); //clk_in 5Mhz --> clk_out 10hz
	input clk_in; //1Mhz input
	output clk_out;
	
	reg clk_out;
	reg [22:0] cnt;
	
	initial begin
		cnt = 23'd0;
		clk_out = 1'b0;
	end
	
	always @ (posedge clk_in) begin
		if(cnt == 22'd249_999) begin
			clk_out = ~clk_out;
			cnt <= 22'd0;
		end
		else
			cnt <= cnt + 1;
	end

endmodule

module led_sw_shift(clk_in,sw,led);
	input clk_in; //5hz
	input [3:0] sw;
	output [3:0] led;
	
	reg [3:0] led;
	
	initial
		led = 4'b0001;
	
	always @ (posedge clk_in) begin
		if(sw[0] == 1'b1)
			led <= {led[0], led[3:1]}; //right shift
		else
			led <= {led[2:0], led[3]};  //left shift
	end
endmodule
	
