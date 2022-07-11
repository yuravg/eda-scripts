module example1_tb;

string tb_status = "IDLE";

example1 dut(.*);

`define CLK125 8ns
initial begin
	clk = 0;
	forever #(`CLK125/2) clk = ~clk;
end

initial begin
	rst = 1;
	repeat (10) @(posedge clk);
	rst = 0;
end

endmodule
