//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-14 08:29:05
//  LastEditTime: 2022-03-14 09:19:33
//  LastEditors: YiBo Zhang
//  Description: this is data forwarding unit
//  
/////////////////////////////////////
`include "./fb_defines.v"
module fb_forwarding_unit (
  input [4:0] id_ex_register_rs1,
  input [4:0] id_ex_register_rs2,
  input ex_mem_regwrite,            //control signal in ex_mem register
  input [4:0] ex_mem_register_rd,
  input mem_wb_regwrite,            //control signal in mem_wb register
  input [4:0] mem_wb_register_rd,
  output [1:0] forward_a,           //control the alu source1 data from
  output [1:0] forward_b            //control the alu source2 data from
);
/////////////////////////////////////////////////
// forwarding code              comment
//      00                 data come from reg_file
//      10                 data come from alu result forwarding
//      01                 data come from memory or alu result which is long before now 
/////////////////////////////////////////////////
assign forward_a = (ex_mem_regwrite == 1 && 
                    ex_mem_register_rd != 0 &&
                    ex_mem_register_rd == id_ex_register_rs1) ? 2'b10 : 
                   (mem_wb_regwrite == 1 &&
                    mem_wb_register_rd != 0 &&
                    mem_wb_register_rd == id_ex_register_rs1) ? 2'b01 :
                    2'b00;

assign forward_b = (ex_mem_regwrite == 1 && 
                    ex_mem_register_rd != 0 &&
                    ex_mem_register_rd == id_ex_register_rs2) ? 2'b10 : 
                   (mem_wb_regwrite == 1 &&
                    mem_wb_register_rd != 0 &&
                    mem_wb_register_rd == id_ex_register_rs2) ? 2'b01 :
                    2'b00;


endmodule