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
	clk_in_10hz dut1(clk_out,sw,clk_nhz); 
	//sw , led
	led_sw_shift dut2(clk_nhz,sw,led);
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
	

//sw 입력에 따른 변화
module clk_in_10hz(clk_in,sw,clk_out); //clk_in 5Mhz --> clk_out 10hz
	input clk_in; //5Mhz input
	input [3:0] sw;
	output clk_out;
	
	
	reg clk_out; 
	reg [1:0] prv_sw;
	reg [22:0] cnt; //counting 하는 변수
	reg [22:0] cnt_val [3:0]; //어느정도 카운팅을 할지 정하는 배열 -->led출력 시간조절
	
	initial begin
		cnt = 23'd0;
		prv_sw = 2'b00;
		cnt_val[0] = 19'd499_999;  //2'b00 --> 200ms
		cnt_val[1] = 20'd874_999;  //2'b01 --> 300ms
		cnt_val[2] = 21'd1249_999; //2'b10 --> 500ms
		cnt_val[3] = 23'd2499_999; //2'b11 --> 1s
		clk_out = 1'b0;
	end
	
	always @ (posedge clk_in) begin
		//sw값이 순간적으로 달라지면 cnt의 값을 남기지 않고 초기화 해야함
		if(sw[3:2] != prv_sw[1:0]) begin
			clk_out <= 1'b0;
			cnt <= 23'd0;
		end
			
		if(sw[3:2] == 2'b00 && cnt == cnt_val[0]) begin
			clk_out <= ~clk_out;
			cnt <= 23'd0;
		end
		else if(sw[3:2] == 2'b01 && cnt == cnt_val[1]) begin
			clk_out <= ~clk_out;
			cnt <= 23'd0;
		end
		else if(sw[3:2] == 2'b10 && cnt == cnt_val[2]) begin
			clk_out <= ~clk_out;
			cnt <= 23'd0;
		end
		else if(sw[3:2] == 2'b11 && cnt == cnt_val[3]) begin
			clk_out <= ~clk_out;
			cnt <= 23'd0;
		end
		else
			cnt <= cnt + 1;
		
		prv_sw[1:0] <= sw[3:2];
	end
endmodule
