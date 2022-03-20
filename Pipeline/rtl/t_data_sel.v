//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-20 16:41:46
//  LastEditTime: 2022-03-20 16:47:03
//  LastEditors: YiBo Zhang
//  Description: this is data select (temporary)
//  
/////////////////////////////////////
//Digital port:
//input: e00,e01,e11,d00:32,d01:32,d11:32
//output: data:32
/////////////////////////////////////
`include "./fb_defines.v"
module t_data_sel (
  input e00,
  input e01,
  input e11,
  input [`FB_32BITS-1:0] d00,
  input [`FB_32BITS-1:0] d01,
  input [`FB_32BITS-1:0] d11,
  output [`FB_32BITS-1:0] data
);

assign data = ({32{e00}} & d00)
            | ({32{e01}} & d01)
            | ({32{e11}} & d11);
  
endmodule