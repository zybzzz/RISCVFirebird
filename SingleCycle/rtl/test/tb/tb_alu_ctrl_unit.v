//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-04-15 23:15:48
//  LastEditTime: 2022-04-15 23:32:24
//  LastEditors: YiBo Zhang
//  Description: this is the test branch for single cycle alu control unit
//  
/////////////////////////////////////
`timescale 1ns/1ps
`include "../../firebird_alu_ctrl.v"
module tb_alu_ctrl_unit;
  //signal declaration
  reg [33:0] instandaluop [6:0];
  reg [31:0] instruction;
  reg [1:0] alu_op;
  wire [3:0] alu_ctrl_signal;
  //dump information
  initial begin            
    $dumpfile("../wave/tb_alu_ctrl_unit.vcd");        //生成的vcd文件名称
    $dumpvars(0, tb_alu_ctrl_unit);     //tb模块名称
  end
  // test
  real TIME_INT = 5;
  integer i;
  initial begin
    $readmemb("./dat_aluctrlunit.bin", instandaluop);
    for (i = 0; i < 7; i = i + 1) begin
      {instruction, alu_op} = instandaluop[i];
      #TIME_INT;
    end
    $finish;
  end
  //module instantation
  firebird_alu_ctrl tb(
    .inst({instruction[30], instruction[14:12]}),
    .alu_op(alu_op),
    .alu_ctrl_signal(alu_ctrl_signal)
  );
endmodule