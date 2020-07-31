module mips_tb;
reg clk;
reg reset;
wire [15:0] pc_out;
wire [15:0] alu_result;

mips_processor uut(.clk(clk), .reset(reset), .pc_out(pc_out), .alu_result(alu_result));
initial #200 $finish;
initial begin
clk=0;
forever #10 clk = ~clk;
end
initial begin
$dumpfile("dumpfile1.vcd");
$dumpvars(0,mips_tb);
reset =1;
#100;
reset =0;
end
initial 
$monitor(alu_result);
endmodule
