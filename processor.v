// Code your design here
// Code your design here
module i_mem(
input [7:0] PC,
output [7:0] inst_code,
input rst
);
reg [7:0] Mem [7:0];
always @ (negedge rst)
	begin
		if (rst==0)
Mem[0]=8'b00100001;
Mem[1]=8'b00100010;
Mem[2]=8'b11100100;
Mem[3]=8'b11101100;

	end
assign inst_code = {Mem[PC]};




endmodule

module in_fetch(input clk,
input rst,
output [7:0] inst_code
);
reg [7:0] PC;
i_mem m(PC,inst_code, rst);
always @ (posedge clk, negedge rst)
begin

if (rst==0)
PC<=0;

else 
PC<=PC +1;
end


endmodule


module if_id(input clk,input rst,output [2:0] Rs,output [2:0] Rd
    );
wire [7:0] inst_code;
reg [1:0]if_id_reg[2:0];
in_fetch f1(clk,rst,inst_code);	 
always @(posedge clk,rst)
if(rst == 0)
begin
if_id_reg[0] = 0;
if_id_reg[1] = 0;
end
else
begin
if_id_reg[0] = inst_code[2:0];
if_id_reg[1] = inst_code[5:3];
end
assign Rs = if_id_reg[0];
assign Rd = if_id_reg[1];
endmodule


module regfile(
input [2:0] read_reg1,
input [2:0] read_reg2,
input [2:0] write_reg,
input [7:0] write_data,
output [7:0] read_data1,
output [7:0] read_data2,
input rst
);
reg [7:0]Reg[7:0];

assign read_data1 = Reg[read_reg1];
assign read_data2 = Reg[read_reg2];
always @ (rst)
if(rst == 0)
begin
Reg[0]=8'b00000001;
Reg[1]=8'b00000010;
Reg[2]=8'b00000011;
Reg[3]=8'b00000100;
Reg[4]=8'b00000101;
Reg[5]=8'b00000110;
Reg[6]=8'b00000111;
Reg[7]=8'b00001000;
end
else
begin
Reg[write_reg]=write_data;
end
endmodule

module control(
input clk,
input rst,
output reg[1:0]op,
output reg[2:0]Rs,
output reg[2:0]Rd
);

wire [7:0] inst_code;
in_fetch i(clk, rst, inst_code);
always @ (posedge clk, negedge rst)
begin
op = inst_code [7:6];
Rd = inst_code[5:3];
Rs = inst_code[2:0];
end

endmodule

module ALU(
input [7:0] read_data1,
input [7:0] read_data2,
input [2:0] Rd,
output reg[7:0] result,
output reg[2:0] write_reg,
input [1:0] op);

assign write_reg = Rd;
always @ (op)
begin
if (op == 2'b00)
begin
result = read_data1+read_data2;
end
else
begin
 result = read_data1 >> read_data2;
end
end
endmodule

module id_exwb(input [2:0] Rd,input [7:0] result,input clk,input rst,output [2:0] write_reg, output [7:0] write_data
 );
 reg id_exwb_reg1[2:0];
 reg id_exwb_reg2[7:0];

always@(posedge clk,rst)
if (rst == 0)
begin
id_exwb_reg1[0] = 0;
id_exwb_reg2[0] = 0;
end
else
begin
id_exwb_reg1[0] = Rd;
id_exwb_reg2[0] = result;
end
assign write_reg = id_exwb_reg1[0];
assign write_reg = id_exwb_reg2[0];

endmodule
   
   
module processor(
input clk,
input rst
    );
wire [2:0]read_reg1;
wire [2:0]read_reg2;
wire [2:0]write_reg;
wire [7:0]read_data1;
wire [7:0]read_data2;
reg [7:0]write_data;
wire [2:0] Rd;
wire [1:0]op;
wire [7:0] result;
if_id p1(clk,rst,read_reg1,read_reg2);
control c(clk,rst,op,read_reg1,read_reg2);
regfile r(read_reg1, read_reg2, write_reg, write_data,read_data1, read_data2,rst);
ALU a(read_data1,read_data2,Rd,result,op);
id_exwb p2(read_reg2,result,clk,rst,write_reg,write_data);
 always @(result)
begin
	
end
  
endmodule
