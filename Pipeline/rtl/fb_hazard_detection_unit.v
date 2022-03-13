//////////////////////////////////////
//  Author: YiBo Zhang
//  Date: 2022-03-10 10:19:37
//  LastEditTime: 2022-03-13 16:27:25
//  LastEditors: YiBo Zhang
//  Description: this is data hazard detection unit
//  
 /////////////////////////////////////
`include "./fb_defines.v"
module fb_hazard_detection_unit (
  input id_ex_memread,      //the memread signal in ex phase
  input [4:0]id_ex_register_rd,  //register destination in ex phase
  input [9:0]inst,          //a part of instruction, rs1 rs2 decode from that
  output lock               //if need lock register, output lock signal
);

wire [4:0]if_id_register_rs1;
wire [4:0]if_id_register_rs2;

//decode the instruction
assign if_id_register_rs1 = inst[4:0];
assign if_id_register_rs2 = inst[9:5];

///////////////////////////////////////////////////////////////////////////////
//lock when:
//1.previous instruction have memory read(such as load instruction)
//2.previous write back destination equals now instruction source(rs1 or rs2)
//scene demo : ld x1, add x3, x1(data hazard), x2
///////////////////////////////////////////////////////////////////////////////
assign lock = ((id_ex_memread == 1) &&
                ((id_ex_register_rd == if_id_register_rs1) || 
                  (id_ex_register_rd == if_id_register_rs2))) ? 1 : 0;


endmodule