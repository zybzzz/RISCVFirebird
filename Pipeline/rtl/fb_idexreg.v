//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-14 09:35:21
//  LastEditTime: 2022-03-14 20:53:11
//  LastEditors: YiBo Zhang
//  Description: this is ID/EX register
//  
/////////////////////////////////////
`include "./fb_defines.v"
module fb_idexreg (
  input clk,
  input we,
  input rst,
  // input
  // * ex control signal
  input [1:0] id_alu_op,
  input id_alu_src,
  input id_alu_res_src,
  // * mem control signal
  input id_mem_read,
  input id_mem_write,
  input id_branch,
  // * wb control signal
  input id_mem_to_reg,
  input id_reg_write,
  // * pc + 1 for jalr
  input [`FB_32BITS-1:0] id_pc_add_1,
  // * data
  input [`FB_32BITS-1:0] id_rs1_data,
  input [`FB_32BITS-1:0] id_rs2_data,
  input [`FB_32BITS-1:0] id_imm,
  // * register num
  input [4:0] id_register_rs1,
  input [4:0] id_register_rs2,
  input [4:0] id_register_rd,
  // * function field
  input [6:0] id_func7,
  input [2:0] id_func3, 
  ///////////////////////////////////////
  //Digital ports:
  //input: clk,we,rst,id_alu_op:2,id_alu_src,id_alu_res_src,id_mem_read,id_mem_write,id_branch,id_mem_to_reg,id_reg_write,id_pc_add_1:32,id_rs1_data:32,id_rs2_data:32,id_imm:32,id_register_rs1:5,id_register_rs2:5,id_register_rd:5,id_func7:7,id_func3:3
  //output: ex_alu_op:2,ex_alu_src,ex_alu_res_src,ex_mem_read,ex_mem_write,ex_branch,ex_mem_to_reg,ex_reg_write,ex_pc_add_1:32,ex_rs1_data:32,ex_rs2_data:32,ex_imm:32,ex_register_rs1:5,ex_register_rs2:5,ex_register_rd:5,ex_func7:7,ex_func3:3
  ///////////////////////////////////////
  //output control signal
  output reg [1:0] ex_alu_op,
  output reg ex_alu_src,
  output reg ex_alu_res_src,
  output reg ex_mem_read,
  output reg ex_mem_write,
  output reg ex_branch,
  output reg ex_mem_to_reg,
  output reg ex_reg_write,
  //output for jalr
  output reg [`FB_32BITS-1:0] ex_pc_add_1,
  //output data
  output reg [`FB_32BITS-1:0] ex_rs1_data,
  output reg [`FB_32BITS-1:0] ex_rs2_data,
  output reg [`FB_32BITS-1:0] ex_imm,
  //output rigister num
  output reg [4:0] ex_register_rs1,
  output reg [4:0] ex_register_rs2,
  output reg [4:0] ex_register_rd,
  //output function field num
  output reg [6:0] ex_func7,
  output reg [2:0] ex_func3
);

always @(posedge clk ) begin
  if(rst == 1) begin
    ex_alu_op <= 2'b0;
    ex_alu_src <= 0;
    ex_alu_res_src <= 0;
    ex_mem_read <= 0;
    ex_mem_write <= 0;
    ex_branch <= 0;
    ex_mem_to_reg <= 0;
    ex_reg_write <= 0;
    ex_pc_add_1 <= 0;
    ex_rs1_data <= 32'b0;
    ex_rs2_data <= 32'b0;
    ex_imm <= 32'b0;
    ex_register_rs1 <= 5'b0;
    ex_register_rs2 <= 5'b0;
    ex_register_rd <= 5'b0;
    ex_func7<=7'b0;
    ex_func3<=3'b0;
  end
  else begin
    if(we == 1) begin
      ex_alu_op <= id_alu_op;
      ex_alu_src <= id_alu_src;
      ex_alu_res_src <= id_alu_res_src;
      ex_mem_read <= id_mem_read;
      ex_mem_write <= id_mem_write;
      ex_branch <= id_branch;
      ex_mem_to_reg <= id_mem_to_reg;
      ex_reg_write <= id_reg_write;
      ex_pc_add_1 <= id_pc_add_1;
      ex_rs1_data <= id_rs1_data;
      ex_rs2_data <= id_rs2_data;
      ex_imm <= id_imm;
      ex_register_rs1 <= id_register_rs1;
      ex_register_rs2 <= id_register_rs2;
      ex_register_rd <= id_register_rd;
      ex_func7<=id_func7;
      ex_func3<=id_func3;
    end
  end
end
endmodule