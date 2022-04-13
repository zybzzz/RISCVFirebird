//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-14 11:04:22
//  LastEditTime: 2022-04-13 17:05:01
//  LastEditors: YiBo Zhang
//  Description: this is MEM/RB register
//  1. this register don't have reset signal
 /////////////////////////////////////
 /////////////////////////////////////
 // Digital port:
 // input: clk,we,mem_mem_to_reg,mem_reg_write,mem_memory_data:32,mem_alu_res:32,mem_register_rd:5,mem_inst:32
 // output: wb_mem_to_reg,wb_reg_write,wb_memory_data:32,wb_alu_res:32,wb_register_rd:5,wb_inst:32
 /////////////////////////////////////
 
`include "./fb_defines.v"
module fb_memwbreg (
  input clk,
  input we,
  // input
  // * wb control signal
  input mem_mem_to_reg,
  input mem_reg_write,
  // * data
  input [`FB_32BITS-1:0] mem_memory_data,     //memory data
  input [`FB_32BITS-1:0] mem_alu_res,         //alu calculate result
  // * register num
  input [4:0] mem_register_rd,                //register rd num use for data hazard unit
  // * instruction just for test
  input [`FB_32BITS-1:0] mem_inst,
  //output
  output reg wb_mem_to_reg,
  output reg wb_reg_write,
  output reg [`FB_32BITS-1:0] wb_memory_data,     
  output reg [`FB_32BITS-1:0] wb_alu_res,
  output reg [4:0] wb_register_rd,
  output reg [`FB_32BITS-1:0] wb_inst     
);

always @(posedge clk ) begin
  if(we == 1) begin
    wb_mem_to_reg<=mem_mem_to_reg;
    wb_reg_write<=mem_reg_write;
    wb_memory_data<=mem_memory_data;
    wb_alu_res<=mem_alu_res;
    wb_register_rd<=mem_register_rd;
    wb_inst <= mem_inst;
  end
end
endmodule