module jr_control(input [1:0]alu_op, input [3:0]Function, output jr_ctrl);
assign jr_ctrl = ({alu_op,Function}==6'b001000) ? 1'b1 : 1'b0;
endmodule
