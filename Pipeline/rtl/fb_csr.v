//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-14 22:50:40
//  LastEditTime: 2022-03-14 22:55:40
//  LastEditors: YiBo Zhang
//  Description: this is csr only store calculate status
//  
/////////////////////////////////////
module fb_csr (
  input clk,
  input we,
  input IN_NF,
  input IN_ZF,
  input IN_CF,
  input IN_VF,
  output reg NF,
  output reg ZF,
  output reg CF,
  output reg VF
);

always @(posedge clk ) begin
  if (we == 1) begin
    NF <= IN_NF;
    ZF <= IN_ZF;
    CF <= IN_CF;
    VF <= IN_VF;
  end  
end

endmodule