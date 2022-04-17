`timescale 1ns/1ps
`include "../../fb_ctrl_hazard_unit.v"
module tb_ctrl_hazard_unit;
  //signal declaration-----------------
  reg [31:0] pc;
  reg [31:0] inst;
  reg [31:0] bra_pc;
  reg [31:0] bra_imm;
  
  reg [5:0] i_bra_control;
  reg branch;
  reg NF;
  reg ZF;
  reg CF;
  reg VF;

  wire address_src;
  wire [31:0] predict_pc;
  wire [31:0] predict_err_pc;
  wire register_rst;
  wire pc_src;
  wire lock;
  wire [5:0] o_bra_control;
  //--------------------------------
  // dump information
  initial begin            
    $dumpfile("../wave/tb_ctrl_hazard_unit.vcd");        //生成的vcd文件名称
    $dumpvars(0, tb_ctrl_hazard_unit);     //tb模块名称
  end
  //--------------------------------
  real TIME_INT = 5;
  integer i;
  reg [143:0] temp [2:0];
  initial begin
    $readmemh("./dat_ctrl_hazard_unit.hex", temp);
    for (i = 0; i < 3 ; i = i + 1) begin
      {pc, inst, bra_pc, bra_imm, i_bra_control, branch, NF, ZF, CF, VF} 
        = {temp[i][143:16], temp[i][13:8], temp[i][4:0]};
      #TIME_INT;
    end
    $finish;
  end

  fb_ctrl_hazard_unit tb(
      .pc(pc),
      .inst(inst),
      .branch(branch),
      .bra_pc(bra_pc),
      .bra_imm(bra_imm),
      .NF(NF),
      .ZF(ZF),
      .CF(CF),
      .VF(VF),
      .i_bra_control(i_bra_control),
      .jalr_en(1'b0),
      .jalr_imm(32'b0),
      .rs1_data(32'b0),
      .address_src(address_src),
      .predict_pc(predict_pc),
      .predict_err_pc(predict_err_pc),
      .register_rst(register_rst),
      .pc_src(pc_src),
      .lock(),
      .o_bra_control(o_bra_control)
    );


endmodule