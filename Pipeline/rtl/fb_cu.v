//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-13 19:18:52
//  LastEditTime: 2022-03-13 19:48:23
//  LastEditors: YiBo Zhang
//  Description: this is cu, generatint different signal for EX/MEM/WB
//  
/////////////////////////////////////
`include "./fb_defines.v"
module fb_cu (
  input [6:0] opcode,
  output [1:0] alu_op,
  output alu_src,
  output alu_res_src,
  output mem_read,
  output mem_write,
  output branch,
  output mem_to_reg,
  output reg_write
);

////////////////////////////////////////
//  output [1:0] alu_op: the alu opcode  
//  output alu_src: decide alu src from (rs2, forwarding unit) or (imm)
//  output alu_res_src: decide alu_result or pc + 1(jalr) write to EX/MEM register
//  output mem_read: memory read
//  output mem_write: memory write
//  output branch: branch instruction
//  output mem_to_reg: register write data from alu result or rs2
//  output reg_write: register write
////////////////////////////////////////

wire r_type_ctrl;
wire b_type_ctrl;
wire i_type_ctrl;
wire s_type_ctrl;
wire jalr_inst;

// judge what type of instruction
assign r_type_ctrl = (opcode[6:0] == 7'b0110011);
assign b_type_ctrl = (opcode[6:0] == 7'b1100011);
assign i_type_ctrl = (opcode[6:0] == 7'b0000011);
assign s_type_ctrl = (opcode[6:0] == 7'b0100011);
assign jalr_inst = (opcode[6:0] == 7'b1100111);

/////////////////////////////////////
//EX
//alu_op r:10 b:01 i & s & jalr(i):00
assign alu_op = ({2{r_type_ctrl}} & 2'b10)
              | ({2{b_type_ctrl}} & 2'b01)
              | ({2{i_type_ctrl || s_type_ctrl || jalr_inst}} & 2'b00);
assign alu_src = i_type_ctrl || s_type_ctrl || jalr_inst;
assign alu_res_src = jalr_inst;
/////////////////////////////////////
//MEM
assign mem_read = i_type_ctrl;
assign mem_write = s_type_ctrl;
assign branch = b_type_ctrl;
/////////////////////////////////////
//WB
assign mem_to_reg = i_type_ctrl;
assign reg_write = r_type_ctrl || s_type_ctrl;
/////////////////////////////////////




  
endmodule