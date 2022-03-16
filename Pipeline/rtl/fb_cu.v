//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-13 19:18:52
//  LastEditTime: 2022-03-16 19:23:30
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
  output reg_write,
  // output pc_src,
  output jalr_en
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
//  output pc_src: decide pc come from increase(0) or control hazard unit(1)
////////////////////////////////////////

wire r_type_ctrl;
wire b_type_ctrl;
wire i_type_ctrl;
wire s_type_ctrl;
wire lw_inst;
wire jalr_inst;
wire j_type_ctrl;

// judge what type of instruction
assign r_type_ctrl = (opcode[6:0] == 7'b0110011);
assign b_type_ctrl = (opcode[6:0] == 7'b1100011);
assign lw_inst = (opcode[6:0] == 7'b0000011);
assign i_type_ctrl = (opcode[6:0] == 7'b0010011);     // * that i-type only includecalculate instruction
assign s_type_ctrl = (opcode[6:0] == 7'b0100011);
assign jalr_inst = (opcode[6:0] == 7'b1100111);
assign j_type_ctrl = (opcode[6:0] == 7'b1101111);

/////////////////////////////////////
//IF
// assign pc_src = b_type_ctrl | jalr_inst | j_type_ctrl;
/////////////////////////////////////
//control hazard unit
assign jalr_en = jalr_inst;
/////////////////////////////////////
//EX
//alu_op r:10 b:01 i & s & jalr(i):00
assign alu_op = ({2{r_type_ctrl}} & 2'b10)
              | ({2{b_type_ctrl}} & 2'b01)
              | ({2{lw_inst | s_type_ctrl}} & 2'b00)
              | ({2{i_type_ctrl}} & 2'b11);
assign alu_src = i_type_ctrl | s_type_ctrl;
// ? jalr don't need alu, only need change alu result source TODO
assign alu_res_src = jalr_inst | j_type_ctrl;
/////////////////////////////////////
//MEM
assign mem_read = lw_inst;
assign mem_write = s_type_ctrl;
assign branch = b_type_ctrl;
/////////////////////////////////////
//WB
assign mem_to_reg = lw_inst;
// * jal and jalr also need write register
assign reg_write = r_type_ctrl | lw_inst | i_type_ctrl | jalr_inst | j_type_ctrl;
/////////////////////////////////////




  
endmodule