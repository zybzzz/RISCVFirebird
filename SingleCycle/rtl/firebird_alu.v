//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-01-25 23:56:30
//  LastEditTime: 2022-02-06 20:11:13
//  LastEditors: YiBo Zhang
//  Description: this is firebird alu
//  
//////////////////////////////////////

module firebird_alu (
  input [31:0] alu_data1,
  input [31:0] alu_data2,
  input [3:0] alu_ctrl_signal,
  output [31:0] alu_result,
  output res_zero
);
  
wire op_add;
wire op_sub;
wire op_and;
wire op_or;

// define the operator type
assign op_add = (alu_ctrl_signal == 4'b0010);
assign op_sub = (alu_ctrl_signal == 4'b0110);
assign op_and = (alu_ctrl_signal == 4'b0000);
assign op_or = (alu_ctrl_signal == 4'b0001);

// define mid-cal result 
// use for follow assign
wire [31:0] add_sub_result;
wire [31:0] and_result;
wire [31:0] or_result;

// TODO ignore sub and carry
assign add_sub_result = alu_data1 + alu_data2;
assign and_result = alu_data1 & alu_data2;
assign or_result = alu_data1 | alu_data2;


assign alu_result = ({32{op_add | op_sub}} & add_sub_result)
                  | ({32{op_and}} & and_result)
                  | ({32{op_or}} & or_result);

// output zero for beq and other
assign res_zero = (alu_result == 32'b0);

endmodule