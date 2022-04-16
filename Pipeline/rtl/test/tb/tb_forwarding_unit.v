//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-04-16 15:29:45
//  LastEditTime: 2022-04-16 15:43:02
//  LastEditors: YiBo Zhang
//  Description: this is testbranch for forward unit
//  
 /////////////////////////////////////
`timescale 1ns/1ps
`include "../../fb_forwarding_unit.v"
module tb_forwarding_unit;
  //signal declaration
  reg [4:0] id_ex_register_rs1;
  reg ex_mem_regwrite;           
  reg [4:0] ex_mem_register_rd;
  reg mem_wb_regwrite;  
  reg [4:0] mem_wb_register_rd;
  wire [1:0] forward_a;
  //dump information
  initial begin            
    $dumpfile("../wave/tb_forwarding_unit.vcd");        //生成的vcd文件名称
    $dumpvars(0, tb_forwarding_unit);     //tb模块名称
  end
  //test
  real TIME_INT = 5;
  integer i;
  reg [16:0] test_dat [3:0]; 
  initial begin
    $readmemb("./dat_forwarding_unit.bin", test_dat);
    for (i = 0; i < 4; i = i + 1) begin
      {id_ex_register_rs1, ex_mem_regwrite, ex_mem_register_rd, mem_wb_regwrite, mem_wb_register_rd} = test_dat[i];
      #TIME_INT;
    end
  end
  //module instantation
  fb_forwarding_unit tb(
    .id_ex_register_rs1(id_ex_register_rs1),
    .id_ex_register_rs2(5'b0),
    .ex_mem_regwrite(ex_mem_regwrite),
    .ex_mem_register_rd(ex_mem_register_rd),
    .mem_wb_regwrite(mem_wb_regwrite),
    .mem_wb_register_rd(mem_wb_register_rd)
  );
endmodule