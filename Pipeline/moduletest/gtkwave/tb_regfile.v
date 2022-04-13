`timescale 1ns/1ps
`include "../../rtl/fb_regfile.v"
module tb_regfile;
  reg clk;
  reg [4:0] read_addr;
  reg we_en;
  reg [4:0] write_addr;
  reg [31:0] write_val;
  wire [31:0] read_val;
  initial begin            
      $dumpfile("wave.vcd");        //生成的vcd文件名称
      $dumpvars(0, tb_regfile);    //tb模块名称
  end
  // clock generate
  real         CYCLE_200MHz = 5 ; 
  always begin
      clk = 0 ; #(CYCLE_200MHz/2) ;
      clk = 1 ; #(CYCLE_200MHz/2) ;
  end
  // motivation
  initial begin
    read_addr = 5'b01000;
    #CYCLE_200MHz;
    @(posedge clk);
    write_addr = 5'b01000;
    write_val = 32'b00100;
    we_en = 1;
    @(negedge clk);
    we_en = 0;
    #CYCLE_200MHz;
    $finish;
  end
  //module instantition
  fb_regfile t_regfile(
    .clk  (clk),
    .reset  (1'b0),
    .raddr1 (read_addr),
    .raddr2 (5'b0),
    .we   (we_en),
    .waddr  (write_addr),
    .wdata  (write_val),
    .rdata1 (read_val),
    .rdata2 ()
  );
  // print
  initial begin
    forever begin
      @(posedge clk);
      $display("read value is %h", read_val);
    end
  end

endmodule