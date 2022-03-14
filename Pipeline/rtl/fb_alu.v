//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-14 14:09:50
//  LastEditTime: 2022-03-14 23:25:00
//  LastEditors: YiBo Zhang
//  Description: this is alu
//  
 /////////////////////////////////////
module fb_alu (
  input [10:0] alu_control,
  input [`FB_32BITS-1:0] op1,
  input [`FB_32BITS-1:0] op2,
  output [`FB_32BITS-1:0] alu_res
  // TODO some output csr signal
);

// TODO operate by alu control signal
// TODO when branch == 1 set csr
  
endmodule