`define MSG(msg) \
	tb_status = msg; \
	$display("%0t, %s", $time, msg);

module example1_tb;

string tb_status;

logic clk;
logic rst;

example1 dut(.*);

`define CLK125 8ns
initial begin
	clk = 0;
	forever #(`CLK125/2) clk = ~clk;
end

initial begin
	rst = 1;
	`MSG("Reset")
	repeat (10) @(posedge clk);
	rst = 0;
	`MSG("Idle")
end

endmodule
