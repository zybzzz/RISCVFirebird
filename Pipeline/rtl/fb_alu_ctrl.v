//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-14 22:49:51
//  LastEditTime: 2022-04-23 15:18:36
//  LastEditors: YiBo Zhang
//  Description: alu control generate control signal for alu
//  
 /////////////////////////////////////
`include "./fb_defines.v"
module fb_alu_ctrl (
  input [1:0] alu_op,
  input [6:0] func7,
  input [2:0] func3,
  output [18:0] alu_control
);
////////////////////////////////////////
//Digital ports:
//input: alu_op:2,func7:7,func3:3
//output: alu_control:19
////////////////////////////////////////


/////////////////////////////////////////
// *        alu_op          instruction
// *         00              lw sw
// *         01             branch(B-type)
// *         10               R-type
// *         11            I-type(calculate)
//TODO fix alu_op generate
/////////////////////////////////////////
wire l_s_inst;
wire b_type;
wire r_type;
wire i_type;

assign l_s_inst = (alu_op == 2'b00);
assign b_type = (alu_op == 2'b01);
assign r_type = (alu_op == 2'b10);
assign i_type = (alu_op == 2'b11);


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

// ! use || or |, maybe error
assign op_add = (l_s_inst || 
                  (i_type && func3 == 3'b000) || 
                  (r_type && func3 == 3'b000 &&func7[5] == 0)) & ~op_mul;               //lw sw add addi

assign op_sub = (b_type ||
                  (r_type && func3 == 3'b000 &&func7[5] == 1)) & ~op_mul;               //b-type sub

assign op_sll = ((r_type || i_type) && func3 == 3'b001) & ~op_mulh;                      //sll slli
assign op_slt = ((r_type || i_type) && func3 == 3'b010) & ~op_mulhsu;                      //slt slti
assign op_sltu = ((r_type || i_type) && func3 == 3'b011) & ~op_mulhu;                     //sltu sltiu
assign op_xor = ((r_type || i_type) && func3 == 3'b100) & ~op_div;                      //xor xori                
assign op_srl = ((r_type || i_type) && func3 == 3'b101 && func7[5] == 0) & ~op_divu;     //srl srli
assign op_sra = ((r_type || i_type) && func3 == 3'b101 && func7[5] == 1) & ~op_divu;     //sra srai
assign op_or = ((r_type || i_type) && func3 == 3'b110) & ~op_rem;                       //or ori
assign op_and = ((r_type || i_type) && func3 == 3'b111) & ~op_remu;                      //and andi
assign op_branch = b_type;                                                    //branch instruction

//////////////////////////////////////
// * RV32M
wire op_mul;
wire op_mulh;
wire op_mulhsu;
wire op_mulhu;
wire op_div;
wire op_divu;
wire op_rem;
wire op_remu;
assign op_mul = (r_type && (func7[0] == 1'b1) && (func3 == 3'b000));
assign op_mulh = (r_type && (func7[0] == 1'b1) && (func3 == 3'b001));
assign op_mulhsu = (r_type && (func7[0] == 1'b1) && (func3 == 3'b010));
assign op_mulhu = (r_type && (func7[0] == 1'b1) && (func3 == 3'b011));
assign op_div = (r_type && (func7[0] == 1'b1) && (func3 == 3'b100));
assign op_divu = (r_type && (func7[0] == 1'b1) && (func3 == 3'b101));
assign op_rem = (r_type && (func7[0] == 1'b1) && (func3 == 3'b110));
assign op_remu = (r_type && (func7[0] == 1'b1) && (func3 == 3'b111));
//////////////////////////////////////

assign alu_control = {op_mul, op_mulh, op_mulhsu, op_mulhu,                 //RV32M
                      op_div, op_divu, op_rem, op_remu,
                      op_add, op_sub, op_sll, op_slt, op_sltu,              //RV32I
                      op_xor, op_srl, op_sra, op_or, op_and, op_branch};

endmodule
