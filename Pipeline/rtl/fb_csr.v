//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-14 22:50:40
//  LastEditTime: 2022-03-15 20:21:02
//  LastEditors: YiBo Zhang
//  Description: this is csr only store calculate status
//  
/////////////////////////////////////
/////////////////////////////////////
// Digital ports:
// input: clk,we,csr:4
// output: NF,ZF,CF,VF
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