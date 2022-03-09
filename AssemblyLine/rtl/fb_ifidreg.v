//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-09 21:52:14
//  LastEditTime: 2022-03-09 22:24:16
//  LastEditors: YiBo Zhang
//  Description: this is assembly line level register in IF/ID phrase
//  1. pc use for branch 
//  2. instruction use for decode and other analysises
 /////////////////////////////////////
`include "./fb_defines.v"
module fb_ifidreg (
  input clk,
  input lock,    //use for data hazerd, lock data and look like insert boob
  input we,      //write enable
  input [`FB_32BITS-1:0] if_pc,     //pc from if phrase
  input [`FB_32BITS-1:0] if_inst,   //instruction from if phrase
  output reg [`FB_32BITS-1:0] id_pc,  //pc in reg present for id phrase read
  output reg [`FB_32BITS-1:0] id_inst  //instruction in reg present for id phrase to read
);

reg [`FB_32BITS-1:0] pc_register;
reg [`FB_32BITS-1:0] inst_register;

//////////////////////////////////////////////////////
/// posedge write then negedge read (data forwarding)
//////////////////////////////////////////////////////
always @(posedge clk ) begin
  if (we == 1) begin
    if (lock == 0) begin      //not lock data
      pc_register <= if_pc;
      inst_register <= if_inst;
    end
  end
end

always @(negedge clk ) begin
  id_pc <= pc_register;
  id_inst <= inst_register;
end

  
endmodule
