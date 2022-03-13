//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-13 20:13:41
//  LastEditTime: 2022-03-13 23:03:13
//  LastEditors: YiBo Zhang
//  Description: this is control hazard unit 
//  ! now can't find method to judge predict error
/////////////////////////////////////
`include "./fb_defines.v"
module fb_ctrl_hazard_unit (
  input [`FB_32BITS-1:0] pc,        //pc
  input [`FB_32BITS-1:0] inst,      //instruction
  input [`FB_32BITS-1:0] imm,       //offset
  input branch,                     //is b-type instruction
  input [`FB_32BITS-1:0] alu_result,                 //alu result, decide whether b-type instruction success
  output address_src,                    //instruction address 0:predict_pc(success) 1:predict_err_pc(predict error)
  output predict_pc,                //pc generate by static prediction
  output predict_err_pc,            //pc when prediction error
  output register_rst               //reset the IF/ID ID/EX EX/MEM when prediction error
);

wire j_type = (pc[6:0] == 7'b1101111);
wire jalr_type = (pc[6:0] == 7'b 1100111);
wire b_type = (pc[6:0] == 7'b1100011);

wire beq_ins = (inst[14:12] == 3'b000);
wire bne_ins = (inst[14:12] == 3'b001);
wire blt_ins = (inst[14:12] == 3'b100);
wire bge_ins = (inst[14:12] == 3'b101);
wire bltu_ins = (inst[14:12] == 3'b110);
wire bgeu_ins = (inst[14:12] == 3'b111);

//offset of jump (signal extent by imm generate unit)
wire [`FB_32BITS-1:0] offset;
assign offset = imm;

assign predict_pc = (j_type) ? pc + offset :                //jal
             (jalr_type) ? ((pc + offset) & (~32'b1)) :     //jalr
             (offset[`FB_32BITS-1] == 1)? pc + offset :     //b-type jump back
             pc + 1;                                        //b-type jump front

//j-type no error
assign predict_err_pc = (offset[`FB_32BITS-1] == 1)? pc + 1 :   //b-type jump back
                        pc + offset;                            //b-type jump front

wire is_predict_error;
//TODO how to judge predict_error
assign is_predict_error = (branch == 0) ? 0 :
                          (beq_ins == 1) ? (alu_result != 32'b0) :
                          (bne_ins == 1) ? (alu_result == 32'b0) :
                          (blt_ins == 1) ? 1 :
                          0;
//change pc_scr and register_rst status when predict error
assign address_src = is_predict_error;
assign register_rst = is_predict_error;

  
endmodule