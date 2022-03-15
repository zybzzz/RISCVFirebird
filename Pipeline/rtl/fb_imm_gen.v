//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-10 09:11:45
//  LastEditTime: 2022-03-14 22:44:54
//  LastEditors: YiBo Zhang
//  Description: generate imm number for different type instruction
//  I B J S Type have imm, R Type don't have imm
 /////////////////////////////////////
`include "./fb_defines.v"
module fb_imm_gen (
  input [`FB_32BITS-1:0] inst,
  output  [`FB_32BITS-1:0] imm
);

////////////////////////////////////////////////////////////
// use ? : to replace case
// spicing fron instruction and use operator code to select
// I 00000|11 (lw)
//   00100|11 (calculate I-type)
//   11001|11 (jalr --- I type)
// S 01000|11
// B 11000|11
// J 11011|11
// 00000 11001 -> I 01000 -> S 11000 -> B(imm in B will left move 1 bit)
// 11011 -> J (imm in J will be put together by J-type rule)
// each imm is 32bit
///////////////////////////////////////////////////////////
wire [4:0]sel_opcode ;
assign sel_opcode = inst[6:2];
assign imm = (sel_opcode == 5'b00000 || sel_opcode == 5'b11001 || sel_opcode == 5'b00100) ? {{20{inst[31]}},inst[31:20]}:
      (sel_opcode == 5'b01000) ? {{20{inst[31]}}, inst[31:25], inst[11:7]}:
      (sel_opcode == 5'b11000) ? {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0}:  
      (sel_opcode == 5'b11011) ? {{13{inst[31]}}, inst[19:12], inst[20], inst[30:21]}:
      32'b0;
      

endmodule