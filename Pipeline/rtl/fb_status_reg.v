//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-19 16:14:53
//  LastEditTime: 2022-03-19 16:22:02
//  LastEditors: YiBo Zhang
//  Description: this is status register of keyboard 
//  
/////////////////////////////////////
`include "./fb_defines.v"
module fb_status_reg (
  input clk,
  input en,
  input av,
  output reg [`FB_32BITS-1:0] status
);
  
always @(posedge clk ) begin
  if(en == 1'b1) begin
    status <= {31{0}, av};
  end
end
endmodule