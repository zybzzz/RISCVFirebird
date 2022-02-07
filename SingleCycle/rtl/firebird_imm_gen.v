//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-01-26 23:32:14
//  LastEditTime: 2022-01-27 09:57:51
//  LastEditors: YiBo Zhang
//  Description: this conponent is used for immediate generation
//  the instruction is input(immediate generate by different instruction) - 
//  - and select by operator(fron instruction) 
 /////////////////////////////////////
`include "firebird_defines.v"
module firebird_imm_gen (
  input [`FIREBIRD_INSTSUCTION_SIZE-1:0] inst,
  output  [`FIREBIRD_ALU_CAL_SIZE-1:0] imm
);
  
// use ? : to replace case
// spicing fron instruction and use operator to select
// I 000|0011
// S 010|0011
// B 110|0011
// 000 -> I 010 -> S 110 -> B(imm in B will left move 1 bit)
wire sel_opcode = inst[6:4];
assign imm = (sel_opcode == 3'b000) ? {{20{inst[31]}},inst[31:20]}:
      (sel_opcode == 3'b010) ? {{20{inst[31]}}, inst[31:25], inst[11:7]}:
      (sel_opcode == 3'b110) ? {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0}:  
      32'b0;
      

endmodule
