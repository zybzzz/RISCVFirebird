//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-14 13:39:48
//  LastEditTime: 2022-03-15 19:38:23
//  LastEditors: YiBo Zhang
//  Description: this is data mux use for forwarding
//  2 - 4 multiplexer
/////////////////////////////////////


/////////////////////////////////////
// *        selcode         comment
// *          00          data come from register
// *          10          data come from alu result
// *          01          data come from memory or alu result long from before
/////////////////////////////////////
/////////////////////////////////////
// Digital ports:
// input: sel:2,reg_data:32,forward_10_data:32,forward_01_data:32
// output: d:32
/////////////////////////////////////
`include "./fb_defines.v"
module fb_fwdmux (
  input [1:0] sel,
  input [`FB_32BITS-1:0] reg_data,
  input [`FB_32BITS-1:0] forward_10_data,
  input [`FB_32BITS-1:0] forward_01_data,
  output [`FB_32BITS-1:0] d
);
  
assign d = (sel == 2'b10) ? forward_10_data : 
           (sel == 2'b01) ? forward_01_data :
           reg_data;


endmodule
