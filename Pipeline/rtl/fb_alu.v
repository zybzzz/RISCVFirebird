//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-14 14:09:50
//  LastEditTime: 2022-03-15 11:31:59
//  LastEditors: YiBo Zhang
//  Description: this is alu
//  
/////////////////////////////////////
`include "./fb_defines.v" 
module fb_alu (
  input [18:0] alu_control,
  input [`FB_32BITS-1:0] op1,
  input [`FB_32BITS-1:0] op2,
  output [`FB_32BITS-1:0] alu_res,
  output [3:0] csr,                   //NF ZF CF VF
  output csr_write
);

wire op_mul;
wire op_mulh;
wire op_mulhsu;
wire op_mulhu;
wire op_div;
wire op_divu;
wire op_rem;
wire op_remu;
wire op_add;
wire op_sub;
wire op_sll;          // shift left logic
wire op_slt;          // set if less then 
wire op_sltu;         // set if less than (unsign)
wire op_xor;
wire op_srl;          // shift right logic
wire op_sra;          // shift right algorithm
wire op_or;
wire op_and;
wire op_branch;       // * branch instruction and set csr 

assign op_mul = alu_control[18];
assign op_mulh = alu_control[17];
assign op_mulhsu = alu_control[16];
assign op_mulhu = alu_control[15];
assign op_div = alu_control[14];
assign op_divu = alu_control[13];
assign op_rem = alu_control[12];
assign op_remu = alu_control[11];
assign op_add = alu_control[10];
assign op_sub = alu_control[9];
assign op_sll = alu_control[8];          
assign op_slt = alu_control[7];          
assign op_sltu = alu_control[6];        
assign op_xor = alu_control[5];
assign op_srl = alu_control[4];          
assign op_sra = alu_control[3];         
assign op_or = alu_control[2];
assign op_and = alu_control[1];
assign op_branch = alu_control[0];

wire [`FB_32BITS-1:0] mul_result;
wire [`FB_32BITS-1:0] mulh_result;
wire [`FB_32BITS-1:0] mulhsu_result;
wire [`FB_32BITS-1:0] mulhu_result;
wire [`FB_32BITS-1:0] div_result;
wire [`FB_32BITS-1:0] divu_result;
wire [`FB_32BITS-1:0] rem_result;
wire [`FB_32BITS-1:0] remu_result;
wire [`FB_32BITS-1:0] add_sub_result;
wire [`FB_32BITS-1:0] sll_result;
wire [`FB_32BITS-1:0] slt_result;
wire [`FB_32BITS-1:0] sltu_result;
wire [`FB_32BITS-1:0] xor_result;
wire [`FB_32BITS-1:0] srl_result;
wire [`FB_32BITS-1:0] sra_result;
wire [`FB_32BITS-1:0] or_result;
wire [`FB_32BITS-1:0] and_result;

/////////////////////////////////////////////
// * RV32M
assign {mulh_result, mul_result} = $signal(op1) * $signal(op2);
assign mulhsu_result = 32'b0;             //TODO wait for fix
assign mulhu_result = 32'b0;
assign div_result = $signal(op1) / $signal(op2);
assign divu_result = op1 / op2;
assign rem_result = $signal(op1) % $signal(op2);
assign remu_result = op1 % op2;
/////////////////////////////////////////////


assign xor_result = op1 ^ op2;
assign or_result = op1 | op2;
assign and_result = op1 & op2;

// use for add
wire [`FB_32BITS-1:0] adder_a;
wire [`FB_32BITS-1:0] adder_b;
wire adder_cin;
wire [`FB_32BITS-1:0] adder_result;
wire adder_cout;

// use for set csr status
wire NF;
wire ZF;
wire CF;
wire VF;


assign adder_a = op1;
assign adder_b = (op_sub || op_slt || op_sltu) ? ~op2 : op2;
assign adder_cin = (op_sub || op_slt || op_sltu) ? 1'b1 : 1'b0;
assign {adder_cout, adder_result} = adder_a + adder_b + adder_cin;

// set csr status
assign NF = (adder_result[31] == 1'b1);
assign ZF = (add_sub_result == 32'b0);
assign CF = adder_cout;
assign VF = ((adder_a[31] == 1'b0 && adder_b[31] == 1'b0 && adder_result[31] == 1'b1) ||
              (adder_a[31] == 1'b1 && adder_b[31] == 1'b1 && adder_result[31] == 1'b0));
assign csr = {NF, ZF, CF, VF};
assign csr_write = op_branch;

assign add_sub_result = adder_result;

assign slt_result[31:1] = 31'b0;
//TODO NF != VF maybe error 
assign slt_result[0] = (NF != VF);

assign sltu_result[31:1] = 31'b0;
assign sltu_result[0] = ~CF;

assign sll_result = op1 << op2[4:0];
assign srl_result = op1 >> op2[4:0];
assign sra_result = ($signal(op1)) >>> op2[4:0];

assign alu_res = ({32{op_mul}} & mul_result)
               | ({32{op_mulh}} & mulh_result)
               | ({32{op_mulhsu}} & mulhsu_result)
               | ({32{op_mulhu}} & mulhu_result)
               | ({32{op_div}} & div_result)
               | ({32{op_divu}} & divu_result)
               | ({32{op_rem}} & rem_result)
               | ({32{op_remu}} & remu_result)
               | ({32{op_add | op_sub}} & add_sub_result)
               | ({32{op_sll}} & sll_result)
               | ({32{op_slt}} & slt_result)
               | ({32{op_sltu}} & sltu_result)
               | ({32{op_xor}} & xor_result)
               | ({32{op_srl}} & srl_result)
               | ({32{op_sra}} & sra_result)
               | ({32{op_or}} & or_result)
               | ({32{op_and}} & and_result);


  
endmodule