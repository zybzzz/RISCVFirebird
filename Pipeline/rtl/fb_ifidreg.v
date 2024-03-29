//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-09 21:52:14
//  LastEditTime: 2022-03-18 17:25:05
//  LastEditors: YiBo Zhang
//  Description: this is assembly line level register in IF/ID phrase
//  1. pc use for branch 
//  2. pc + 1 use for jalr 
//  3. instruction use for decode and other analysises
 /////////////////////////////////////
`include "./fb_defines.v"
module fb_ifidreg (
  input clk,
  input lock,    //use for data hazerd, lock data and look like insert boob
  input we,      //write enable
  input rst,     //reset signel: control hazard's prediction error need reset the rigister
  input [`FB_32BITS-1:0] if_pc,     //pc from if phrase
  input [`FB_32BITS-1:0] if_pc_add_1,     //pc + 1 from if phrase
  input [`FB_32BITS-1:0] if_inst,   //instruction from if phrase
  input [5:0] in_bra_control,       //bra control
  output reg [`FB_32BITS-1:0] id_pc,  //pc in reg present for id phrase read
  output reg [`FB_32BITS-1:0] id_pc_add_1,  //pc + 1 in reg use for jalr
  output reg [`FB_32BITS-1:0] id_inst,  //instruction in reg present for id phrase to read
  output reg [5:0] out_bra_control        //bra_control
);

// reg [`FB_32BITS-1:0] pc_register;
// reg [`FB_32BITS-1:0] pc_add_1_register;
// reg [`FB_32BITS-1:0] inst_register;

always @(posedge clk ) begin
  if (rst == 1) begin
    id_pc <= `FB_32BITS'b0;
    id_pc_add_1 <= `FB_32BITS'b0;
    id_inst <= `FB_32BITS'b0;
    out_bra_control <= 6'b0;
  end
  else begin
    if (we == 1 && lock == 0) begin   //not lock data    
      id_pc <= if_pc;
      id_pc_add_1 <= if_pc_add_1;
      id_inst <= if_inst;
      out_bra_control <= in_bra_control;
    end
  end
end

// always @(negedge clk ) begin
//   id_pc <= pc_register;
//   id_pc_add_1 <= pc_add_1_register;
//   id_inst <= inst_register;
// end

  
endmodule
