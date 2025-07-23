`timescale 1ns / 1ps

module ALUController (
    //Inputs
    input logic [2:0] ALUOp,  // 3-bit opcode field from the Controller--000: LW/SW/AUIPC; 001:Branch; 010: Rtype; 011:Itype
    input logic [6:0] Funct7,  // bits 25 to 31 of the instruction
    input logic [2:0] Funct3,  // bits 12 to 14 of the instruction
    //Output
    output logic [3:0] Operation  // operation selection for ALU
);
    always_comb begin
        case(ALUOp)
            2'b000:
                    Operation = 4'b0100;  // LW/LH/LB/SW/SH/SB
            2'b001:
                if(Funct3 == 3'b000)    //BEQ
                    Operation = 4'b1000;
                else if(Funct3 == 3'b001)    //BNE
                    Operation = 4'b1001;
                else if(Funct3 == 3'b100)    //BLT
                    Operation = 4'b1010;
                else if(Funct3 == 3'b101)    //BGE
                    Operation = 4'b1011;
                else
                    Operation = 4'b0000;
            2'b010:
                if(Funct3 == 3'b000 && Funct7 == 7'b0000000)   //ADD
                    Operation = 4'b0100;
                else if(Funct3 == 3'b000 && Funct7 == 7'b0100000)   //SUB
                    Operation = 4'b0101;
                else if(Funct3 == 3'b111 && Funct7 == 7'b0000000)   //AND
                    Operation = 4'b0000;
                else if(Funct3 == 3'b110 && Funct7 == 7'b0000000)   //OR
                    Operation = 4'b0001;
                else if(Funct3 == 3'b100 && Funct7 == 7'b0000000)   //XOR
                    Operation = 4'b0010;
                else if(Funct3 == 3'b010 && Funct7 == 7'b0000000)   //SLT
                    Operation = 4'b1010;
                else
                    Operation = 4'b0000;
            2'b011:
                    if(Funct3 == 3'b000)    //ADDI
                        Operation = 4'b0100;
                    else if(Funct3 == 3'b010)   //SLTI
                        Operation = 4'b1010;
                    else if(Funct3 == 3'b001 && Funct7 == 7'b0000000)   //SLLI
                    Operation = 4'b1100;
                    else if(Funct3 == 3'b101 && Funct7 == 7'b0000000)   //SRLI
                        Operation = 4'b1101;
                    else if(Funct3 == 3'b101 && Funct7 == 7'b0100000)   //SRAI
                        Operation = 4'b1110;
                    else
                        Operation = 4'b0000;
            default:
                    Operation = 4'b0000;
        endcase
    end
endmodule
