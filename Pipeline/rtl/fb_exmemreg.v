//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-14 10:47:18
//  LastEditTime: 2022-04-13 17:03:38
//  LastEditors: YiBo Zhang
//  Description: this is EX/MEM register
//  
/////////////////////////////////////
/////////////////////////////////////
// Digital ports:
// input: clk,we,rst,ex_mem_read,ex_mem_write,ex_branch,ex_mem_to_reg,ex_reg_write,ex_alu_res:32,ex_rs2_data:32,ex_register_rd:5,ex_inst:32
// output: mem_mem_read,mem_mem_write,mem_branch,mem_mem_to_reg,mem_reg_write,mem_alu_res:32,mem_rs2_data:32,mem_register_rd:5,mem_inst:32
/////////////////////////////////////
`include "./fb_defines.v"
module fb_exmemreg (
  input clk,
  input we,
  input rst,
  // input
  // * mem control signal
  input ex_mem_read,
  input ex_mem_write,
  // * wb control signal
  input ex_mem_to_reg,
  input ex_reg_write,
  // * data
  input [`FB_32BITS-1:0] ex_alu_res,    //alu calculate result
  input [`FB_32BITS-1:0] ex_rs2_data,   //rs2 data use for store
  // * register num
  input [4:0] ex_register_rd,           //register rd num use for data hazard unit
  // * branch instruction
  input ex_branch,
  input [`FB_32BITS-1:0] ex_pc,
  input [`FB_32BITS-1:0] ex_imm,
  input [5:0] ex_bra_control,
  // * instruction just for test
  input [`FB_32BITS-1:0] ex_inst,
  //output
  output reg mem_mem_read,
  output reg mem_mem_write,
  output reg mem_mem_to_reg,
  output reg mem_reg_write,
  output reg [`FB_32BITS-1:0] mem_alu_res,    //alu calculate result
  output reg [`FB_32BITS-1:0] mem_rs2_data,   //rs2 data use for store
  output reg [4:0] mem_register_rd,           //register rd num use for data hazard unit
  output reg mem_branch,
  output reg [`FB_32BITS-1:0] mem_pc,
  output reg [`FB_32BITS-1:0] mem_imm,
  output reg [5:0] mem_bra_control,
  output reg [`FB_32BITS-1:0] mem_inst
);

always @(posedge clk ) begin
  if(rst == 1) begin
    mem_mem_read<=0;
    mem_mem_write<=0;
    mem_mem_to_reg<=0;
    mem_reg_write<=0;
    mem_alu_res<=32'b0;
    mem_rs2_data<=32'b0;
    mem_register_rd<=5'b0;
    mem_branch<=0;
    mem_pc <= 32'b0;
    mem_imm <= 32'b0;
    mem_bra_control <= 6'b0;
    mem_inst <= 32'b0;
  end
  else begin
    if(we == 1) begin
      mem_mem_read<=ex_mem_read;
      mem_mem_write<=ex_mem_write;
      mem_mem_to_reg<=ex_mem_to_reg;
      mem_reg_write<=ex_reg_write;
      mem_alu_res<=ex_alu_res;
      mem_rs2_data<=ex_rs2_data;
      mem_register_rd<=ex_register_rd;
      mem_branch<=ex_branch;
      mem_pc<=ex_pc;
      mem_imm<=ex_imm;
      mem_bra_control<=ex_bra_control;
      mem_inst <= ex_inst;
    end
  end
end
endmodule