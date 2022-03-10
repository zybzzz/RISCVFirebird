//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-08 22:16:46
//  LastEditTime: 2022-03-10 11:45:55
//  LastEditors: YiBo Zhang
//  Description: register file
//  1. use posedge to write then use negedge to read to solve data hazard
//  that called register forwarding
 /////////////////////////////////////
`include "./fb_defines.v"
module fb_regfile (
  input clk,
  input reset,
  input [4:0] raddr1,
  input [4:0] raddr2,
  input we,           // write enable
  input [4:0] waddr,
  input [`FB_32BITS-1:0] wdata,
  output reg [`FB_32BITS-1:0] rdata1,     //write in negedge, so define as reg type FIXME:need test
  output reg [`FB_32BITS-1:0] rdata2
);

reg [`FB_32BITS-1:0] reg_array[31:0];
integer i;

// reset or write
always @(posedge clk ) begin
  if(reset == 1) begin
    for (i = 1; i < 32; i = i + 1) begin
      reg_array[i] <= 32'b0;
    end
    //reg_array[4] <= 32'b111;  //just for test
  end
  else
    if(we == 1) reg_array[waddr] <= wdata;
end

always @(negedge clk ) begin
  // read two data in one cycle (x0 is hardware 0)
  // data1
  rdata1 <= (raddr1 == 5'b0) ? 5'b0 : reg_array[raddr1]; 
  // data2
  rdata2 <= (raddr2 == 5'b0) ? 5'b0 : reg_array[raddr2]; 
end


endmodule