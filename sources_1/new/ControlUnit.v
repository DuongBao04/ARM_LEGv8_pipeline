`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Control Unit for ARMv8-like CPU
//////////////////////////////////////////////////////////////////////////////////

module ControlUnit(
    input  [10:0] opcode,
    output reg Reg2Loc,
    output reg ALUSrc,
    output reg MemToReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg [1:0] ALUOp
);
    always @(*) begin
        Reg2Loc   = 0;
        ALUSrc    = 0;
        MemToReg  = 0;
        RegWrite  = 0;
        MemRead   = 0;
        MemWrite  = 0;
        Branch    = 0;
        ALUOp     = 2'b00;

        // ==========================
        // Branch instructions
        // ==========================
        if (opcode[10:5] == 6'b000101) begin // B
            Reg2Loc = 0;
            ALUSrc  = 0;
            MemToReg = 0;
            RegWrite = 0;
            MemRead  = 0;
            MemWrite = 0;
            Branch   = 1;
            ALUOp    = 2'b01;

        end else if (opcode[10:3] == 8'b10110100) begin // CBZ
            Reg2Loc = 1;
            ALUSrc  = 0;
            MemToReg = 0;
            RegWrite = 0;
            MemRead  = 0;
            MemWrite = 0;
            Branch   = 1;
            ALUOp    = 2'b01;

        // ==========================
        // I-type immediate instructions
        // ==========================
        end else if (
            opcode[10:1] == 10'b1001000100 || // ADDI
            opcode[10:1] == 10'b1001001000 || // ANDI
            opcode[10:1] == 10'b1011001000 || // ORRI
            opcode[10:1] == 10'b1101000100    // SUBI
        ) begin
            Reg2Loc = 0;
            ALUSrc  = 1;
            MemToReg = 0;
            RegWrite = 1;
            MemRead  = 0;
            MemWrite = 0;
            Branch   = 0;
            ALUOp    = 2'b11;

        // ==========================
        // Load / Store
        // ==========================
        end else begin
            case (opcode)
                11'h7C2: begin  // LDUR
                    Reg2Loc = 0;
                    ALUSrc  = 1;
                    MemToReg = 1;
                    RegWrite = 1;
                    MemRead  = 1;
                    MemWrite = 0;
                    Branch   = 0;
                    ALUOp    = 2'b00;
                end
                11'h7C0: begin  // STUR
                    Reg2Loc = 1;
                    ALUSrc  = 1;
                    MemToReg = 0;
                    RegWrite = 0;
                    MemRead  = 0;
                    MemWrite = 1;
                    Branch   = 0;
                    ALUOp    = 2'b00;
                end

                // ==========================
                // R-Type instructions
                // ==========================
                11'h458, 11'h450, 11'h650, 11'h69B, 11'h69A, 11'h550, 11'h658: begin
                    Reg2Loc = 0;
                    ALUSrc  = 0;
                    MemToReg = 0;
                    RegWrite = 1;
                    MemRead  = 0;
                    MemWrite = 0;
                    Branch   = 0;
                    ALUOp    = 2'b10;
                end
            endcase
        end
    end
endmodule
