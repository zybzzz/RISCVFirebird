//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-20 14:51:18
//  LastEditTime: 2022-03-20 16:36:17
//  LastEditors: YiBo Zhang
//  Description: this unit is control access memory or external device
//  
/////////////////////////////////////
//Digital ports:
//input: in_add:11
//output: data_src:2,out_add:10
/////////////////////////////////////
module fb_mmu (
  input [10:0] in_add,  //in_add[10] judge is memory access or external device access
  output [1:0]data_src,      //where is data come from
  output [9:0]out_add   //out_add[9:0] is memory access address
);
  
assign out_add = in_add[9:0];
assign data_src = ({2{in_add[10] & ~in_add[1] & ~in_add[0]}} & 2'b00)   //status register
                | ({2{in_add[10] & ~in_add[1] & in_add[0]}} & 2'b01)    //data register
                | ({2{in_add[10] & in_add[1] & ~in_add[0]}} & 2'b10)    //terminal(keyboard)
                | ({2{~in_add[10]}} & 2'b11);                           //memory

endmodule 
