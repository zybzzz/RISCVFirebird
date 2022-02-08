//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-01-26 16:00:02
//  LastEditTime: 2022-02-08 13:28:03
//  LastEditors: YiBo Zhang
//  Description: register pile
//  
/////////////////////////////////////
`include "firebird_defines.v"
module firebird_regfile (
  input clk,
  input reset,
  input [4:0] raddr1,
  input [4:0] raddr2,
  input we,           // write enable
  input [4:0] waddr,
  input [`FIREBIRD_REG_SIZE-1:0] wdata,
  output [`FIREBIRD_REG_SIZE-1:0] rdata1,
  output [`FIREBIRD_REG_SIZE-1:0] rdata2
);

reg [`FIREBIRD_REG_SIZE-1:0] reg_array[31:0];
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

// read two data in one cycle (x0 is hardware 0)
// data1
assign rdata1 = (raddr1 == 5'b0) ? 5'b0 : reg_array[raddr1]; 
// data2
assign rdata2 = (raddr2 == 5'b0) ? 5'b0 : reg_array[raddr2]; 

endmodule