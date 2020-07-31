module alu(input[15:0] op_a, op_b, input[2:0] alu_control, output reg[15:0] result, output zero_flag);

always @(*)
begin
case(alu_control)
3'b000: result = op_a + op_b; //add
3'b001: result = op_a - op_b; //sub
3'b010: result = op_a & op_b; //and
3'b011: result = op_a | op_b; //or
3'b100: begin                 //slti
	if(op_a < op_b)
	result = 16'd1;
	else result = 16'd0;
	end
default: result = op_a + op_b;
endcase
end

assign zero_flag = (result==16'd0) ? 1'b1 : 1'b0;

endmodule
