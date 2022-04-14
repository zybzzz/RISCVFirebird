`timescale 1ns/1ps
`include "../../rtl/fb_alu.v"
module tb_alu;
  reg [18:0] alu_control;
  reg [31:0] op1;
  reg [31:0] op2;
  wire [31:0] alu_res;
  wire [3:0] status_flag;
  wire csr_write;


  //--------------------------------
  // dump information
  initial begin            
      $dumpfile("tb_alu.vcd");        //生成的vcd文件名称
      $dumpvars(0, tb_alu);     //tb模块名称
  end
  //--------------------------------
  real TIME_INT = 5;
  initial begin
    alu_control = 19'b1;
    op1 = 32'b101;
    op2 = 32'b111;
    while (alu_control != 0) begin
      #TIME_INT;
      alu_control = alu_control << 1;
    end
    $finish;
  end

  fb_alu tb(
    .alu_control(alu_control),
    .op1(op1),
    .op2(op2),
    .alu_res(alu_res),
    .csr(status_flag),
    .csr_write(csr_write)
  );

endmodule