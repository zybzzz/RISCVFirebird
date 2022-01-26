//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-01-26 12:17:57
//  LastEditTime: 2022-01-26 13:47:29
//  LastEditors: YiBo Zhang
//  Description: firebird pc single cycle
//  
/////////////////////////////////////
`include "./firebird_defines.v"
module firebird_pc (
  input clk,
  input pc_reset,
  input [`FIREBIRD_PC_SIZE-1:0] new_address,
  output reg[`FIREBIRD_PC_SIZE-1:0] out_address
);

always @(posedge clk ) begin
  if(pc_reset == 1) out_address <= 32'b0;
  else out_address <= new_address;
end

endmodule