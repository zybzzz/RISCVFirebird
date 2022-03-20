//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-20 15:12:09
//  LastEditTime: 2022-03-20 15:18:18
//  LastEditors: YiBo Zhang
//  Description: this is 2 to 4 mutex
//  
/////////////////////////////////////
`include "./fb_defines.v"
module fb_t_f_mux (
  input [1:0] sel,
  input [`FB_32BITS-1:0] d00,
  input [`FB_32BITS-1:0] d01,
  input [`FB_32BITS-1:0] d10,
  input [`FB_32BITS-1:0] d11,
  output [`FB_32BITS-1:0] data
);

assign data = ({32{~sel[1] & ~sel[0]}} & d00)
            | ({32{~sel[1] & sel[0]}} & d01)
            | ({32{sel[1] & ~sel[0]}} & d10)
            | ({32{sel[1] & sel[0]}} & d11);

            
endmodule