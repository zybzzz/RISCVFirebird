//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-14 22:50:40
//  LastEditTime: 2022-03-15 11:48:26
//  LastEditors: YiBo Zhang
//  Description: this is csr only store calculate status
//  
/////////////////////////////////////
module fb_csr (
  input clk,
  input we,
  input [3:0] csr,
  output reg NF,
  output reg ZF,
  output reg CF,
  output reg VF
);

always @(posedge clk ) begin
  if (we == 1) begin
    NF <= csr[3];
    ZF <= csr[2];
    CF <= csr[1];
    VF <= csr[0];
  end  
end

endmodule