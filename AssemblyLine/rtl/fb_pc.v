//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-08 21:55:49
//  LastEditTime: 2022-03-08 23:09:30
//  LastEditors: YiBo Zhang
//  Description: This is cpu's pc 
//  1. pc + 1 to find next commend(commend set in a rom, each room of rom are 32bit)
//  2. pc_write to keep pc's value not to change in branch hazard
/////////////////////////////////////
`include "fb_defines.v"
module fb_pc (
  input clk,
  input pc_reset,
  input pc_write,
  input [`FB_32BITS-1:0] new_address,
  output reg[`FB_32BITS-1:0] out_address
);

always @(posedge clk ) begin
  if(pc_reset == 1) out_address <= 32'b0;
  else 
    //not reset and no hazard
    if(pc_write == 0) out_address <= new_address;
end

endmodule