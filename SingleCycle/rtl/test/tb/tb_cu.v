//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-04-15 19:50:22
//  LastEditTime: 2022-04-15 20:06:35
//  LastEditors: YiBo Zhang
//  Description: this is testbranch for single cycle cu
//  
/////////////////////////////////////
`timescale 1ns/1ps
`include "../../firebird_cu.v"
module tb_cu;
  //signal declaration
  reg [6:0] opcodes [3:0];
  wire branch;
  wire mem_read;
  wire mem_to_reg;
  wire [1:0] alu_op;
  wire mem_write;
  wire alu_src;
  wire reg_write;
  // dump information
  initial begin            
    $dumpfile("../wave/tb_cu.vcd");        //生成的vcd文件名称
    $dumpvars(0, tb_cu);                   //tb模块名称
  end
  real TIME_INT = 5;
  integer i;
  initial begin
    $readmemb("./dat_tbcu.bin", opcodes);
    for(i = 0; i < 4; i = i + 1)begin
      #TIME_INT;
    end
    $finish;
  end
  //module instantiation
  firebird_cu tb(
    .opcode(opcodes[i]),
    .branch(branch),
    .mem_read(mem_read),
    .mem_to_reg(mem_to_reg),
    .alu_op(alu_op),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .reg_write(reg_write)
  );
endmodule
