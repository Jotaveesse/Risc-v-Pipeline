`timescale 1ns / 1ps

module Controller (
    //Input
    input logic [6:0] Opcode,
    //7-bit opcode field from the instruction

    //Outputs
    output logic ALUSrc,
    //0: The second ALU operand comes from the second register file output (Read data 2); 
    //1: The second ALU operand is the sign-extended, lower 16 bits of the instruction.
    output logic [1:0] MemtoReg,
    //0: The value fed to the register Write data input comes from the ALU.
    //1: The value fed to the register Write data input comes from the data memory.
    output logic RegWrite, //The register on the Write register input is written with the value on the Write data input 
    output logic MemRead,  //Data memory contents designated by the address input are put on the Read data output
    output logic MemWrite, //Data memory contents designated by the address input are replaced by the value on the Write data input.
    output logic [2:0] ALUOp,  //000: LW/SW; 001:Branch; 010: Rtype; 011: Itype
    output logic Branch,  //0: branch is not taken; 1: branch is taken
    output logic Jal_Sel,
    output logic Jalr_Sel 
);

  logic [6:0] R_TYPE, I_TYPE, LOADS, SAVES, BR, JAL, JALR;

  assign R_TYPE = 7'b0110011;  //add, sub, and, or, xor, slt
  assign I_TYPE = 7'b0010011;  //addi, slli, srli, srai, slti
  assign LOADS = 7'b0000011;  //lw, lh, lb, lbu
  assign SAVES = 7'b0100011;  //sw, sh, sb
  assign BR = 7'b1100011;  //beq, bne, bge, blt
  assign JAL = 7'b1101111;
  assign JALR = 7'b1100111; 

  assign ALUSrc = (Opcode == LOADS || Opcode == SAVES || Opcode == I_TYPE || Opcode == JAL || Opcode == JALR);
  assign MemtoReg[0] = (Opcode == LOADS);
  assign MemtoReg[1] = (Opcode == JAL || Opcode == JALR);
  assign RegWrite = (Opcode == R_TYPE || Opcode == LOADS || Opcode == I_TYPE || Opcode == JAL || Opcode == JALR);
  assign MemRead = (Opcode == LOADS);
  assign MemWrite = (Opcode == SAVES);
  assign ALUOp[0] = (Opcode == BR || Opcode == I_TYPE);
  assign ALUOp[1] = (Opcode == R_TYPE || Opcode == I_TYPE);
  assign ALUOp[2] = Opcode == JAL;
  assign Branch = (Opcode == BR);
  assign Jal_Sel = (Opcode == JAL);
  assign Jalr_Sel = (Opcode == JALR);
endmodule
