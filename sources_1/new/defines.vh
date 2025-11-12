// ============================================================
// ARMLegV8 ALU Control Signal Definitions
// ============================================================

`define ALU_AND             4'b0000   // Logical AND
`define ALU_OR              4'b0001   // Logical OR
`define ALU_ADD             4'b0010   // Addition
`define ALU_XOR             4'b0011   // XOR
`define ALU_LSHIFT_LEFT     4'b0100   // Logical Shift Left
`define ALU_LSHIFT_RIGHT    4'b0101   // Logical Shift Right
`define ALU_SUB             4'b0110   // Subtraction

`define ALU_PASS_INPUT_B    4'b0111    
`define NOP                 4'b1111    // Not doing anything