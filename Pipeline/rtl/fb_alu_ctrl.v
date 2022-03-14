//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-14 22:49:51
//  LastEditTime: 2022-03-14 23:19:38
//  LastEditors: YiBo Zhang
//  Description: alu control generate control signal for alu
//  
 /////////////////////////////////////
`include "./fb_defines.v"
module fb_alu_ctrl (
  input [1:0] alu_op,
  input [6:0] func7,
  input [2:0] func3,
  output [10:0] alu_control
);

/////////////////////////////////////////
// *        alu_op          instruction
// *         00              lw sw
// *         01             branch(B-type)
// *         10            R-type and I-type(calculate)
/////////////////////////////////////////


// TODO set that op
wire op_add;
wire op_sub;
wire op_sll;          // shift left logic
wire op_slt;          // set if less then 
wire op_sltu;         // set if less than (unsign)
wire op_xor;
wire op_srl;          // shift right logic
wire op_sra;          // shift right algorithm
wire op_or;
wire op_and;
wire op_branch;       // * let alu know branch instruction and set csr 

assign alu_control = {op_add, op_sub, op_sll, op_slt, op_sltu,
                      op_xor, op_srl, op_sra, op_or, op_and, op_branch};

endmodule
