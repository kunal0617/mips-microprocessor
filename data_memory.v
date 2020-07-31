module data_memory(input clk, input [15:0] address, input [15:0] write_data, input mem_write, input mem_read, output [15:0] read_data_mem);

reg[15:0] ram[255:0];
integer i;
wire[7:0] ram_address = address[8:1];
initial begin
for(i=0; i<256; i=i+1)
ram[i] <= 16'd0;
end

always @(posedge clk)
begin
if(mem_write)
ram[ram_address] <= write_data;
end

assign read_data_mem = (mem_read==1'b1) ? ram[ram_address]: 16'd0;

endmodule 
