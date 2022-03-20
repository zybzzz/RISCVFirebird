//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-20 16:30:41
//  LastEditTime: 2022-03-20 16:33:55
//  LastEditors: YiBo Zhang
//  Description: this is 2 to 4 decode unit
//  
/////////////////////////////////////
//Digital ports:
//input: c:2
//output: e00,e01,e10,e11
/////////////////////////////////////
module t_f_decode (
  input [1:0] c,
  output e00,
  output e10,
  output e01,
  output e11
);

assign e00 = (~c[1] & ~c[0]);
assign e10 = (c[1] & ~c[0]);
assign e01 = (~c[1] & c[0]);
assign e11 = (c[1] & c[0]);
  
endmodule