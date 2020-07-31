module mips_processor(input clk, reset, output[15:0] pc_out, alu_result);
 reg[15:0] pc_current;  
 wire signed[15:0] pc_next,pc2;  
 wire [15:0] instr;  
 wire[1:0] reg_dst,mem_to_reg,alu_op;  
 wire jump,branch,mem_read,mem_write,alu_src,reg_write     ;  
 wire     [2:0]     reg_write_dest;  
 wire     [15:0] reg_write_data;  
 wire     [2:0]     reg_read_addr_1;  
 wire     [15:0] reg_read_data_1;  
 wire     [2:0]     reg_read_addr_2;  
 wire     [15:0] reg_read_data_2;  
 wire [15:0] sign_ext_im,read_data2,zero_ext_im,imm_ext;  
 wire JRControl;  
 wire [2:0] ALU_Control;  
 wire [15:0] ALU_out;  
 wire zero_flag;  
 wire signed[15:0] im_shift_1, PC_j, PC_beq, PC_4beq,PC_4beqj,PC_jr;  
 wire beq_control;  
 wire [14:0] jump_shift_1;  
 wire [15:0]mem_read_data;  
 wire [15:0] no_sign_ext;  
 wire sign_or_zero; 

always @(posedge clk or posedge reset) //pc
begin
if(reset)
pc_current = 16'd0;
else
pc_current <= pc_next;
end 

assign pc2 = pc_current + 16'd2; //pc+2

instr_mem instruction_memory(.pc(pc_current), .instruction(instr)); //instruction memory instantiate

assign jump_shift_1 = {instr[13:0],1'b0}; //jump shift left 1

control_unit ctrl_unit(.opcode(instr[15:13]), .reset(reset), .reg_dst(reg_dst), .mem_to_reg(mem_to_reg), .alu_op(alu_op),
				 .alu_src(alu_src), .reg_write(reg_write), .mem_read(mem_read),.mem_write(mem_write),
				 .branch(branch), .jump(jump), .sign_or_zero(sign_or_zero)); //control unit instantiate

assign reg_write_dest = (reg_dst==2'b10)?3'b111:((reg_dst==2'b01)?instr[6:4]:instr[9:7]); //mux of reg_dst control

assign reg_read_addr_1 = instr[12:10];
assign reg_read_addr_2 = instr[9:7];

register_file reg_file(.clk(clk), .reset(reset), .reg_write(reg_write), .write_to_reg(reg_write_dest), .write_data(reg_write_data),
			 .read_address1(reg_read_addr_1), .read_address2(reg_read_addr_2),
			.read_data1(reg_read_data_1), .read_data2(reg_read_data_2)); //instantiate register file

assign sign_ext_im = {{9{instr[6]}},instr[6:0]};
assign zero_ext_im = {{9{1'b0}},instr[6:0]};
assign imm_ext = (sign_or_zero==1'b1)? sign_ext_im : zero_ext_im;

jr_control JR_ctrl(.alu_op(alu_op), .Function(instr[3:0]), .jr_ctrl(JRControl)); //instantiate JR_control

alu_control_unit alu_ctrl(.alu_op(alu_op), .Function(instr[3:0]), .alu_control(ALU_Control)); //instantiate alu control

assign read_data2 = (alu_src==1'b1) ? imm_ext : reg_read_data_2;

alu ALU(.op_a(reg_read_data_1), .op_b(read_data2), .alu_control(ALU_Control), .result(ALU_out), .zero_flag(zero_flag)); //instantiate alu

assign im_shift_1 = {imm_ext[14:0],1'b0};
assign no_sign_ext = ~(im_shift_1) + 1'b1;
assign PC_beq = (im_shift_1[15]==1'b1) ? pc2-no_sign_ext : pc2+im_shift_1;
assign beq_control = branch & zero_flag;
assign PC_4beq = (beq_control==1'b1) ? PC_beq : pc2;
assign PC_j = {pc2[15], jump_shift_1};
assign PC_4beqj = (jump==1'b1) ? PC_j : PC_4beq;
assign PC_jr =  reg_read_data_1;
assign pc_next = (JRControl==1'b1) ? PC_jr : PC_4beq;

data_memory data_mem(.clk(clk), .address(ALU_out), .write_data(reg_read_data_2),
			 .mem_write(mem_write), .mem_read(mem_read), .read_data_mem(mem_read_data)); //instantiate data memory

assign reg_write_data = (mem_to_reg==2'b10) ? pc2 : ((mem_to_reg == 2'b01) ? mem_read_data : ALU_out);
assign pc_out = pc_current;
assign alu_result = ALU_out;
endmodule


