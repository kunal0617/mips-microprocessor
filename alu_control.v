module alu_control_unit(alu_control, alu_op, Function );
output reg[2:0]alu_control;
input [1:0]alu_op;
input [3:0]Function;
wire [5:0] alu_enable;
assign alu_enable = {alu_op,Function};
always @(alu_enable)
casex(alu_enable)
6'b11xxxx: alu_control = 3'b000; //add
6'b01xxxx: alu_control = 3'b001; //sub
6'b10xxxx: alu_control = 3'b100; //slt
6'b000000: alu_control = 3'b000; //add
6'b000001: alu_control = 3'b001; //sub
6'b000010: alu_control = 3'b010; //and
6'b000011: alu_control = 3'b011; //or
6'b000100: alu_control = 3'b100; //slt
default: alu_control = 3'b000;
endcase
endmodule 
