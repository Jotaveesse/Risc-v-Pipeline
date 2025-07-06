`timescale 1ns / 1ps

module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )
        (
        input logic signed [DATA_WIDTH-1:0]    SrcA,
        input logic signed [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic signed [DATA_WIDTH-1:0] ALUResult
        );
    
        always_comb
        begin
            case(Operation)
                4'b0000:        // AND
                        ALUResult = SrcA & SrcB;
                4'b0001:        // OR
                        ALUResult = SrcA | SrcB;
                4'b0010:        // XOR
                        ALUResult = SrcA ^ SrcB;
                4'b0100:        // ADD
                        ALUResult = SrcA + SrcB;
                4'b0101:        // SUB
                        ALUResult = SrcA - SrcB;
                4'b1000:        // Equal
                        ALUResult = (SrcA == SrcB) ? 1 : 0;
                4'b1001:        // Less Than
                        ALUResult = (SrcA < SrcB) ? 1 : 0;
                4'b1100:        // Shift Left Logico
                        ALUResult = SrcA << SrcB;
                4'b1101:        // Shift Right Logico
                        ALUResult = SrcA >> SrcB[4:0];
                4'b1110:        // Shift Right Aritmetico
                        ALUResult = SrcA >>> SrcB[4:0];
                
            default:
                        ALUResult = 0;
            endcase
        end
endmodule

