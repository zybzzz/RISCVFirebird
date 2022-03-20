//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-19 16:14:53
//  LastEditTime: 2022-03-20 20:35:40
//  LastEditors: YiBo Zhang
//  Description: this is status register of keyboard 
//  
/////////////////////////////////////
//Digital ports:
//input: clk,clr,av
//output: status:32
/////////////////////////////////////
`include "./fb_defines.v"
module fb_status_reg (
  input clk,
  input clr,
  input av,
  output reg [`FB_32BITS-1:0] status
);
  
always @(posedge clk ) begin
  if(av == 1'b1) begin
    status <= {{31{1'b0}}, av};
  end
end

always @(negedge clk ) begin
  if (clr == 1'b1) begin
    status <= 32'b0;
  end
end
endmodule