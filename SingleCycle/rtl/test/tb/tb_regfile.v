//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-04-15 15:34:40
//  LastEditTime: 2022-04-15 16:27:18
//  LastEditors: YiBo Zhang
//  Description: this is testbranch for single cycle regfile
//  
 /////////////////////////////////////
`timescale 1ns/1ps
`include "../../firebird_regfile.v"
`include "../../firebird_defines.v"
module tb_regfile;
  // signal declaration
  reg clk;
  reg [4:0] raddr1;
  reg [4:0] raddr2;
  reg we;           // write enable
  reg [4:0] waddr;
  reg [`FIREBIRD_REG_SIZE-1:0] wdata;
  wire [`FIREBIRD_REG_SIZE-1:0] rdata1;
  wire [`FIREBIRD_REG_SIZE-1:0] rdata2;
  // dump information
  initial begin            
    $dumpfile("../wave/tb_regfile.vcd");        //生成的vcd文件名称
    $dumpvars(0, tb_regfile);                   //tb模块名称
  end
  // clock generate
  real         CYCLE_200MHz = 5 ; 
  always begin
    clk = 0 ; #(CYCLE_200MHz/2) ;
    clk = 1 ; #(CYCLE_200MHz/2) ;
  end
  // test
  initial begin
    we = 1;
    waddr = 5'b111;
    wdata = 32'b1111;
    @(posedge clk);
    #1
    waddr = 5'b001;
    wdata = 32'b1100;
    @(posedge clk);
    #1
    we = 0;
    raddr1 = 5'b111;
    raddr2 = 5'b001;
    #2
    $finish;
  end

  firebird_regfile tb(
    .clk(clk),
    .reset(1'b0),
    .raddr1(raddr1),
    .raddr2(raddr2),
    .we(we),
    .waddr(waddr),
    .wdata(wdata),
    .rdata1(rdata1),
    .rdata2(rdata2)
  );


endmodule