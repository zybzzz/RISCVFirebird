//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-01-28 11:44:48
//  LastEditTime: 2022-04-16 09:30:01
//  LastEditors: YiBo Zhang
//  Description: alu_control to control alu 
//  the output [3:0] alu_ctrl_signal is the alu input
//  
//////////////////////////////////////
module firebird_alu_ctrl (
  input [3:0] inst,
  input [1:0] alu_op,
  output [3:0] alu_ctrl_signal
);


//  from the instruction function field
wire func_30;
wire func_14;
wire func_13;
wire func_12;

assign func_30 = inst[3];
assign func_14 = inst[2];
assign func_13 = inst[1];
assign func_12 = inst[0];

// the r-type instruction alu_ctrl_signal result
// * binary name must mark the length
wire [3:0]r_type_signal;
assign r_type_signal = ({4{~func_30 & ~func_14 & ~func_13 & ~func_12}} & 4'b0010)       // add
                   | ({4{func_30 & ~func_14 & ~func_13 & ~func_12}} & 4'b0110)       // subtract
                   | ({4{~func_30 & func_14 & func_13 & func_12}} & 4'b0000)       // AND
                   | ({4{~func_30 & func_14 & func_13 & ~func_12}} & 4'b0001);      // OR

// use aluop to generate alu_ctrl_signal
assign alu_ctrl_signal = ({4{~alu_op[1] & ~alu_op[0]}} & 4'b0010)
                       | ({4{~alu_op[1] & alu_op[0]}} & 4'b0110)
                       | ({4{alu_op[1] & ~alu_op[0]}} & r_type_signal);

endmodule