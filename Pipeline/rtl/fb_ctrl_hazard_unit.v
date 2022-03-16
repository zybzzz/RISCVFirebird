//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-13 20:13:41
//  LastEditTime: 2022-03-16 19:37:56
//  LastEditors: YiBo Zhang
//  Description: this is control hazard unit 
//  ! continuous branch question
/////////////////////////////////////
/////////////////////////////////////
// * the control hazard unit should be used in if phase
// * if not, it will cause time hazard
// * error example:
// *    IF      /       ID       (judge and generate the next address)/
// *            /(use address fetch instruction (before than judge))       IF       /       ID
// * * * * * * * * * * * * * * * * * * * * * * * * *
// * correct example:
// *    IF      (judge and generate the next address)/       ID       /
// *            /(use address fetch instruction (after than judge))       IF       /       ID
/////////////////////////////////////
// * jalr must lock 1 clock
/////////////////////////////////////
/////////////////////////////////////
// Digital ports:
// input: pc:32,inst:32,branch,NF,ZF,CF,VF,rs1_data:32
// output: address_src,predict_pc:32,predict_err_pc:32,register_rst,pc_src
/////////////////////////////////////
`include "./fb_defines.v"
`include "./fb_imm_gen.v"
module fb_ctrl_hazard_unit (
  input [`FB_32BITS-1:0] pc,        //pc
  input [`FB_32BITS-1:0] inst,      //instruction
  // input [`FB_32BITS-1:0] imm,       //offset
  input branch,                     //is b-type instruction(after exe phase, from ex/mem register)
  input NF,
  input ZF,
  input CF,
  input VF,                         //csr status
  input [`FB_32BITS-1:0] rs1_data,       // rs1 data use for jalr
  input jalr_en,                         //jalr must lock 1 clock
  output address_src,                    //instruction address 0:predict_pc(success) 1:predict_err_pc(predict error)
  output [`FB_32BITS-1:0] predict_pc,                //pc generate by static prediction
  output [`FB_32BITS-1:0] predict_err_pc,            //pc when prediction error
  output register_rst,               //reset the IF/ID ID/EX EX/MEM when prediction error
  output pc_src,                         //0:auto increase (pc + 1) 1: control unit predict address
  output lock                         //lock when jalr
);


wire j_type;
wire jalr_type;
wire b_type;

wire beq_ins;
wire bne_ins;
wire blt_ins;
wire bge_ins;
wire bltu_ins;
wire bgeu_ins;

wire [`FB_32BITS-1:0] imm;

// * use imm gen module
fb_imm_gen temp_gen(inst, imm);


assign j_type = (inst[6:0] == 7'b1101111);
assign jalr_type = (inst[6:0] == 7'b 1100111);
assign b_type = (inst[6:0] == 7'b1100011);

assign pc_src = j_type | jalr_type | b_type;
assign lock = jalr_type & (~jalr_en);

assign beq_ins = (inst[14:12] == 3'b000);
assign bne_ins = (inst[14:12] == 3'b001);
assign blt_ins = (inst[14:12] == 3'b100);
assign bge_ins = (inst[14:12] == 3'b101);
assign bltu_ins = (inst[14:12] == 3'b110);
assign bgeu_ins = (inst[14:12] == 3'b111);

//offset of jump (signal extent by imm generate unit)
wire [`FB_32BITS-1:0] offset;
assign offset = imm;

assign predict_pc = (j_type) ? pc + offset :                //jal
             (jalr_type) ? ((rs1_data + offset) & (~32'b1)) :     //jalr
             (offset[`FB_32BITS-1] == 1)? pc + offset :     //b-type jump back
             pc + 1;                                        //b-type jump front

//j-type no error
assign predict_err_pc = (offset[`FB_32BITS-1] == 1)? pc + 1 :   //b-type jump back
                        pc + offset;                            //b-type jump front

wire is_predict_error;

//* use csr status and branch type to judge predict error
assign is_predict_error = ((branch & b_type & beq_ins) & (ZF == 1'b0))
                        | ((branch & b_type & bne_ins) & (ZF == 1'b1))
                        | ((branch & b_type & blt_ins) & (NF == VF))
                        | ((branch & b_type & bge_ins) & (NF != VF))
                        | ((branch & b_type & bltu_ins) & (CF == 1'b1))
                        | ((branch & b_type & bgeu_ins) & (CF == 1'b0));
//change predict address and register_rst status when predict error
assign address_src = is_predict_error;
assign register_rst = is_predict_error;

  
endmodule