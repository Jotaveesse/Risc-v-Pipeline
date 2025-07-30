`timescale 1ns / 1ps

module datamemory #(
    parameter DM_ADDRESS = 9,
    parameter DATA_W = 32
) (
    input logic clk,
    input logic MemRead,  // comes from control unit
    input logic MemWrite,  // Comes from control unit
    input logic [DM_ADDRESS - 1:0] a,  // Read / Write address - 9 LSB bits of the ALU output
    input logic [DATA_W - 1:0] wd,  // Write Data
    input logic [2:0] Funct3,  // bits 12 to 14 of the instruction
    output logic [DATA_W - 1:0] rd  // Read Data
);

  logic [31:0] raddress;
  logic [31:0] waddress;
  logic [31:0] Datain;
  logic [31:0] Dataout;
  logic [31:0] Datamiddle;
  logic [ 3:0] Wr;

  Memoria32Data mem32 (
      .raddress(raddress),
      .waddress(waddress),
      .Clk(~clk),
      .Datain(Datain),
      .Dataout(Dataout),
      .Wr(Wr)
  );

  always_ff @(*) begin
    raddress = {{22{1'b0}}, {a[8:2], {2{1'b0}}}};
    waddress = {{22{1'b0}}, {a[8:2], {2{1'b0}}}};
    Datain = wd;
    Wr = 4'b0000;

    if (MemRead) begin
      case (a[1:0])
        2'b00:  //LB
        Datamiddle <= Dataout;
        2'b01:  //LH
        Datamiddle <= Dataout >> 8;
        2'b10:  //LW
        Datamiddle <= Dataout >> 16;
        2'b11:  //LBU
        Datamiddle <= Dataout >> 24;
        default: rd <= Dataout;
      endcase
      case (Funct3)
        3'b000:  //LB
        rd = {{24{Datamiddle[7]}}, Datamiddle[7:0]};
        3'b001:  //LH
        rd <= {{16{Datamiddle[15]}}, Datamiddle[15:0]};
        3'b010:  //LW
        rd <= Datamiddle;
        3'b100:  //LBU
        rd = {{24{1'b0}}, Datamiddle[7:0]};
        default: rd <= Datamiddle;
      endcase
    end else if (MemWrite) begin
      case (Funct3)
        3'b000: begin  //SB
          Datain <= {{24{wd[31]}}, wd[7:0]};
          Wr = 4'b0001;
        end
        3'b001: begin  //SH
          Datain <= {{16{wd[31]}}, wd[15:0]};
          Wr = 4'b0011;
        end
        3'b010: begin  //SW
          Datain <= wd;
          Wr = 4'b1111;
        end
        default: begin
          Datain <= wd;
          Wr = 4'b1111;
        end
      endcase
    end
  end

endmodule
