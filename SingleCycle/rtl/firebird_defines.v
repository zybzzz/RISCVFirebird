`include "config.v"

`ifdef FIREBIRD_SINGLE_ADDR_SIZE_IS_32
  `define FIREBIRD_ADDR_SIZE_IS_32
  `define FIREBIRD_ADDR_SIZE 32
  `define FIREBIRD_PC_SIZE_IS_32
  `define FIREBIRD_PC_SIZE 32
  `define FIREBIRD_REG_SIZE_IS_32
  `define FIREBIRD_REG_SIZE 32
`endif