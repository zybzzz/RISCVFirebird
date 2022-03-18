//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-13 20:13:41
//  LastEditTime: 2022-03-18 09:29:05
//  LastEditors: YiBo Zhang
//  Description: this is control hazard unit 
/////////////////////////////////////
// * the control hazard unit work in IF / ID / MEM phase
// * IF : calculate jal address, lock 1 clock when jalr, predict branch instruction address
// * ID : calcuiate jalr address
// * MEM: to verify whether prediction is true or false. And if false generate predict error address.
/////////////////////////////////////
// * thinking of design : 
// * 1. use conbinational logic, not use temporal logic. temporal logic have delay time.
// * 2. jal,jalr,branch instruction all will be handled by same unit. reducing component usage but 
// * make logic complex.(Split it into 3 parts if necessary)
// * 3. predict error has the highest priority.
/////////////////////////////////////
// * why jalr lock 1 clock and generate address in ID phase ? 
// * if not, it will cause time hazard
// * error example:
// *    IF      /       ID       (judge and generate the next address)/
// *            /(use address fetch instruction (before than judge))       IF       /       ID
// * * * * * * * * * * * * * * * * * * * * * * * * *
// * correct example:
// *    IF      (judge and generate the next address)/       ID       /
// *            /(use address fetch instruction (after the judge))       IF       /       ID
// * * * * * * * * * * * * * * * * * * * * * * * * *
// * add nop(no operation) instruction follow the jalr maybe a solution too.
/////////////////////////////////////
// * continuous branch question（correctness of the program when facint continuous branch ）
// * first should to know is control hazard unit can guarantee 1 branch execute correctly.
// * two different case:
// * branch1(predict succ) - branch2(predict succ) ... in this case execute correctly
// * branch1(predict succ) - branch2(predict error) ... in this case the instructions before error 
// * branch can execute correctly and the instruction will be flush(the after branch instructions
// * will all be flush). Then PC will get predict error new address to fetch new instruction to execute.
/////////////////////////////////////

/////////////////////////////////////
/////////////////////////////////////
// Digital ports:
// input: pc:32,inst:32,branch,NF,ZF,CF,VF,rs1_data:32,jalr_en,bra_pc:32,bra_imm:32,i_bra_control:6,jalr_imm:32
// output: address_src,predict_pc:32,predict_err_pc:32,register_rst,pc_src,lock,o_bra_control:6
/////////////////////////////////////
`include "./fb_defines.v"
`include "./fb_imm_gen.v"
module fb_ctrl_hazard_unit (
  input [`FB_32BITS-1:0] pc,        //pc(use for jal and branch instruction)
  input [`FB_32BITS-1:0] inst,      //instruction(use for jal and branch instruction)
  ////////////////////////////////////////
  input branch,                     //is b-type instruction(after exe phase, from ex/mem register)
  input [`FB_32BITS-1:0] bra_pc,                  //pc(come from EX/MEM register, use for branch predict error)
  input [`FB_32BITS-1:0] bra_imm,       //offset(come from EX/MEM register, use for branch predict error)
  input NF,
  input ZF,
  input CF,
  input VF,                         //csr status
  input [5:0] i_bra_control,
  ////////////////////////////////////////
  input jalr_en,                         //jalr must lock 1 clock
  input [`FB_32BITS-1:0] jalr_imm,       // imm use for jalr
  input [`FB_32BITS-1:0] rs1_data,       // rs1 data use for jalr
  ////////////////////////////////////////
  output address_src,                    //instruction address 0:predict_pc(success) 1:predict_err_pc(predict error)
  output [`FB_32BITS-1:0] predict_pc,                //pc generate by static prediction
  output [`FB_32BITS-1:0] predict_err_pc,            //pc when prediction error
  output register_rst,               //reset the IF/ID ID/EX EX/MEM when prediction error
  output pc_src,                         //0:auto increase (pc + 1) 1: control unit predict address
  output lock,                         //lock when jalr
  output [5:0] o_bra_control           //use for i_bra_control, in judge predict error.
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
assign jalr_type = (inst[6:0] == 7'b1100111);
assign b_type = (inst[6:0] == 7'b1100011);


//change pc source when: 1. jal 2. jalr calculate address finish 3. branch predict 4. branch predict error 
assign pc_src = j_type | jalr_en | b_type | is_predict_error;
// assign pc_src = j_type | jalr_type | b_type;
// ! 100% unlock in next clock because IF lock generate 32'b0 instruction
assign lock = jalr_type & (~jalr_en);

assign beq_ins = (inst[14:12] == 3'b000);
assign bne_ins = (inst[14:12] == 3'b001);
assign blt_ins = (inst[14:12] == 3'b100);
assign bge_ins = (inst[14:12] == 3'b101);
assign bltu_ins = (inst[14:12] == 3'b110);
assign bgeu_ins = (inst[14:12] == 3'b111);

assign o_bra_control = {beq_ins, bne_ins, blt_ins, bge_ins, bltu_ins, bgeu_ins};

//offset of jump (signal extent by imm generate unit)
wire [`FB_32BITS-1:0] offset;
assign offset = imm;

// assign predict_pc = (j_type) ? pc + offset :                //jal
//              (jalr_type) ? ((rs1_data + offset) & (~32'b1)) :     //jalr
//              (offset[`FB_32BITS-1] == 1)? pc + offset :     //b-type jump back
//              pc + 1;                                        //b-type jump front

// default 0
assign predict_pc = ({32{j_type}} & (pc + offset))
                  | ({32{b_type & offset[`FB_32BITS-1]}} & (pc + offset))
                  | ({32{b_type & ~offset[`FB_32BITS-1]}} & (pc + 1))
                  | ({32{jalr_en}} & ((rs1_data + jalr_imm) & (~32'b1)));

//j-type no error
// assign predict_err_pc = (offset[`FB_32BITS-1] == 1)? pc + 1 :   //b-type jump back
//                         pc + offset;                            //b-type jump front

assign predict_err_pc = ({32{bra_imm[`FB_32BITS-1]}} & (bra_pc + 1))
                      | ({32{~bra_imm[`FB_32BITS-1]}} & (bra_pc + bra_imm));

wire is_predict_error;

//* use csr status and branch type to judge predict error
assign is_predict_error = ((branch & i_bra_control[5] & bra_imm[`FB_32BITS-1]) & (ZF == 1'b0))    //back
                        | ((branch & i_bra_control[5] & ~bra_imm[`FB_32BITS-1]) & (ZF == 1'b1))   //front
                        | ((branch & i_bra_control[4] & bra_imm[`FB_32BITS-1]) & (ZF == 1'b1))    //back
                        | ((branch & i_bra_control[4] & ~bra_imm[`FB_32BITS-1]) & (ZF == 1'b0))   //front
                        | ((branch & i_bra_control[3] & bra_imm[`FB_32BITS-1]) & (NF == VF))      //back
                        | ((branch & i_bra_control[3] & ~bra_imm[`FB_32BITS-1]) & (NF != VF))     //front
                        | ((branch & i_bra_control[2] & bra_imm[`FB_32BITS-1]) & (NF != VF))      //back
                        | ((branch & i_bra_control[2] & ~bra_imm[`FB_32BITS-1]) & (NF == VF))     //front
                        | ((branch & i_bra_control[1] & bra_imm[`FB_32BITS-1]) & (CF == 1'b1))    //back
                        | ((branch & i_bra_control[1] & ~bra_imm[`FB_32BITS-1]) & (CF == 1'b0))   //front
                        | ((branch & i_bra_control[0] & bra_imm[`FB_32BITS-1]) & (CF == 1'b0))    //back
                        | ((branch & i_bra_control[0] & ~bra_imm[`FB_32BITS-1]) & (CF == 1'b1));  //front
//change predict address and register_rst status when predict error
assign address_src = is_predict_error;
assign register_rst = is_predict_error;

  
endmodule