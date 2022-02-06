//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-02-06 19:42:35
//  LastEditTime: 2022-02-06 20:46:53
//  LastEditors: YiBo Zhang
//  Description: this is firebird cu
//  input is instruction's opcode and output is control signal
//  
/////////////////////////////////////

module firebird_cu (
  input [6:0] opcode,
  output branch,
  output mem_read,
  output mem_to_reg,
  output [1:0] alu_op,
  output mem_write,
  output alu_src,
  output reg_write
);
  
//////////////////////////////////////
// referance from computer organizaion and design p183
// output branch : instruction is the branch(b type) instruction
// output mem_read : memory read
// output mem_to_reg : where is register write data from  1: from memory 0: from alu 
// output [1:0] alu_op: generate aluop used by alu_ctrl
// output mem_write: the memory write signal
// output alu_src: where is alu data from 1:from imm_gen 0:from register
// output reg_write: the register write signal
/////////////////////////////////////

wire r_type_ctrl;
wire b_type_ctrl;
wire i_type_ctrl;
wire s_type_ctrl;

// what type instruction
assign r_type_ctrl = (opcode[6:0] == 7'b0110011);
assign b_type_ctrl = (opcode[6:0] == 7'b1100011);
assign i_type_ctrl = (opcode[6:0] == 7'b0000011);
assign s_type_ctrl = (opcode[6:0] == 7'b0100011);

assign alu_src = i_type_ctrl || s_type_ctrl;
assign mem_to_reg = i_type_ctrl;
assign reg_write = r_type_ctrl || s_type_ctrl;
assign mem_read = i_type_ctrl;
assign mem_write = s_type_ctrl;
assign branch = b_type_ctrl;
assign alu_op = ({2{r_type_ctrl}} & 2'b10)
              | ({2{b_type_ctrl}} & 2'b01)
              | ({2{i_type_ctrl || s_type_ctrl}} & 2'b00);

endmodule