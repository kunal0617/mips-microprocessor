module register_file(input clk, reset, input reg_write, input [2:0]write_to_reg, input [15:0]write_data, input[2:0] read_address1, read_address2,
			output[15:0] read_data1, read_data2);

reg[15:0] reg_array[7:0];

always @(posedge clk or posedge reset)
begin
if(reset)
begin
reg_array[0] = 16'b0;
reg_array[1] = 16'b0;
reg_array[2] = 16'b0;
reg_array[3] = 16'b0;
reg_array[4] = 16'b0;
reg_array[5] = 16'b0;
reg_array[6] = 16'b0;
reg_array[7] = 16'b0;
end
else 
begin
if(reg_write)
begin
reg_array[write_to_reg] <= write_data;
end
end
end

assign read_data1 = (read_address1 == 0)? 16'b0 : reg_array[read_address1];
assign read_data2 = (read_address2 == 0)? 16'b0 : reg_array[read_address2];

endmodule 