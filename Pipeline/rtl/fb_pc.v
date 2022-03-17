//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-08 21:55:49
//  LastEditTime: 2022-03-17 09:36:22
//  LastEditors: YiBo Zhang
//  Description: This is cpu's pc 
//  1. pc + 1 to find next commend(commend set in a rom, each room of rom are 32bit)
//  2. pc_write to keep pc's value not to change in data hazard
//  3. clear_inst use for jalr 1 clock lock, that will set output inst to 0.
//    if not do that, there will generate 2 continuous jalr and than make error.
/////////////////////////////////////
`include "fb_defines.v"
module fb_pc (
  input clk,
  input pc_reset,
  input pc_write,
  input [`FB_32BITS-1:0] new_address,
  input pc_clear,
  output reg[`FB_32BITS-1:0] out_address,
  output reg clear_inst
);

always @(posedge clk ) begin
  if(pc_clear == 1) begin
    clear_inst <= 1'b1;
  end
  if(pc_reset == 1) begin 
    out_address <= 32'b0;
  end
  else begin 
    //not reset and no hazard
    if(pc_write == 0) out_address <= new_address;
  end
end

endmodule