//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-10 09:11:45
//  LastEditTime: 2022-03-10 10:07:16
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
// I 0000|011
// S 0100|011
// B 1100|011
// J 1101|111
// 0000 -> I 0100 -> S 1100 -> B(imm in B will left move 1 bit)
// 1101 -> J (imm in J will be put together by J-type rule)
///////////////////////////////////////////////////////////
wire [3:0]sel_opcode ;
assign sel_opcode = inst[6:3];
assign imm = (sel_opcode == 4'b0000) ? {{20{inst[31]}},inst[31:20]}:
      (sel_opcode == 4'b0100) ? {{20{inst[31]}}, inst[31:25], inst[11:7]}:
      (sel_opcode == 4'b1100) ? {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0}:  
      (sel_opcode == 4'b0100) ? {inst[31], inst[19:12], inst[20], inst[30:21]}:
      32'b0;
      

endmodule