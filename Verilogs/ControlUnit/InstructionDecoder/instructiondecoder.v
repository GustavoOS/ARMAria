module instructiondecoder(
  Instruction,
  ID,
  RegD,//Destination Register
  RegA,//Channel A
  RegB,//Channel B
  Offset,
  Condicao
);


input [15:0] Instruction;
output reg [6:0] ID;
output reg [3:0] RegD, RegA, RegB, Condicao;
output reg [7:0] Offset;


reg [3:0] Opcode, funct2;
reg op;
reg [1:0] funct1;
reg [2:0] aux;


always @ ( * ) begin

  Offset=0;
  RegD=0;
  RegA=0;
  RegB=0;
  Condicao=4'hf;
  ID=0;
  funct1=0;
  funct2=Instruction[11:8];
  op=0;
  Opcode=Instruction[15:12];
  aux=0;

  case(Opcode)
    0:begin//Instructions 1 & 2
      op=Instruction[11];
      ID=(op)? 7'h2: 7'h1;
      Offset[5:0]=Instruction[10:6];
      RegD[2:0]=Instruction[2:0];
      RegA[2:0]=Instruction[5:3];
    end
    1:begin//Instructions 3~7
      op=Instruction[11];
      if(~op)begin//Instruction 3
        ID=7'h3;
        Offset[5:0]=Instruction[10:6];
        RegD[2:0]=Instruction[2:0];
        RegA[2:0]=Instruction[5:3];
      end
		else begin
        funct1=Instruction[10:9];
        case(funct1)
          0:begin//Instruction 4
            ID=7'h4;
            RegD[2:0]=Instruction[2:0];
            RegA[2:0]=Instruction[5:3];
            RegB[2:0]=Instruction[8:6];
          end

          1:begin//Instruction 5
            ID=7'h5;
            RegD[2:0]=Instruction[2:0];
            RegA[2:0]=Instruction[5:3];
            RegB[2:0]=Instruction[8:6];
          end

          2:begin//Instruction 6
            ID=7'h6;
            RegA[2:0]=Instruction[5:3];
            RegD[2:0]=Instruction[2:0];
            Offset[2:0]=Instruction[8:6];
          end

          3:begin//Instruction 7
            ID=7'h7;
            RegA[2:0]=Instruction[5:3];
            RegD[2:0]=Instruction[2:0];
            Offset[2:0]=Instruction[8:6];
          end

          default:begin
            ID=7'h7e;
          end
        endcase//Opcode=1, case(funct1)
      end
    end//Opcode=1

    2:begin//Instructions 8 & 9
      op=Instruction[11];
      ID=(op)? 7'h9 : 7'h8;
      Offset[7:0] = Instruction[7:0];
      RegD[2:0] = Instruction[10:8];
      RegA[2:0] = Instruction[10:8];
    end
    3:begin//Instructions 10 & 11
      op=Instruction[11];
      ID=(op)? 7'hb : 7'ha;
      Offset[7:0] = Instruction[7:0];
      RegD[2:0] = Instruction[10:8];
      RegA[2:0] = Instruction[10:8];
    end
    4:begin//D E F types, Instructions 12~39
        op=Instruction[11];
        funct2=Instruction[11:8];
        funct1=Instruction[7:6];
        if(op)begin//Instruction 39
          ID=7'h27;
          Offset[7:0] = Instruction[7:0];
          RegD[2:0] = Instruction[10:8];
          RegA = 4'hf;
          RegB = Instruction[10:8];
        end
		  else begin
          RegD[2:0]=Instruction[2:0];
          RegA[2:0]=Instruction[2:0];
          RegB[2:0]=Instruction[5:3];
          case(funct2)
          0:begin//Instructions 12~15
              ID = 7'hc+funct1;
          end
          1:begin//Instructions 16~19
              ID = 7'h10+funct1;
          end
          2:begin//Instructions 20~23
            ID = 7'h14+funct1;
          end
          3:begin//Instructions 24~27
            ID = 7'h18+funct1;
          end
          4:begin//Instructions 28~30
              case(funct1)
              1:begin//Instruction 28
                ID = 7'h1c;
                RegB[3] = 1;
              end
              2:begin//Instruction 29
                ID=7'h1d;
                RegD[3] = 1;
                RegA[3] = 1;
              end
              3:begin//Instruction 30
                ID=7'h1e;
                RegD[3] = 1;
                RegA[3] = 1;
                RegB[3] = 1;
              end
              default:begin
                ID=7'hc;
              end
              endcase//Opcode=4, funct2=4, case(funct1)
            end//Opcode=4. funct2=4


          5:begin//Instructions 31~33
                case(funct1)
                1:begin//Instruction 31
                  ID=7'h1f;
                  RegB[3]=1;
                end
                2:begin//Instruction 32
                  ID=7'h20;
                  RegD[3] = 1;
                  RegA[3] = 1;
                end
                3:begin//Instruction 33
                  ID=7'h21;
                  RegD[3]=1;
                  RegA[3]=1;
                end
                default:begin
                  ID=7'hc;
                end
                endcase//Opcode=4, funct2=5, case(funct1)
              end//Opcode=4. funct2=5

          6:begin//Instructions 34~37
                  case(funct1)
                  0:begin//Instruction 34
                    ID=7'h22;
                  end
                  1:begin//Instruction 35
                    ID=7'h23;
                    RegB[3]=1;
                  end
                  2:begin//Instruction 36
                    ID = 7'h24;
                    RegD[3] = 1;
                    RegA[3] = 1;
                  end
                  3:begin//Instruction 37
                    ID=7'h25;
                    RegD[3] = 1;
                    RegA[3] = 1;
                    RegB[3] = 1;
                  end
                  default:begin
                    ID=7'hc;
                  end
                  endcase//Opcode=4, funct2=6, case(funct1)
          end//Opcode=4. funct2=6
          7:begin//Instruction 38
            Condicao=Instruction[7:4];
            ID=7'h26;
            RegA[2:0]=Instruction[2:0];
          end

          default:begin
            ID=7'h7d;
          end

          endcase//Opcode=4, case(funct2)
        end//else
      end//Opcode=4

      5:begin//Instructions 40~47
        aux=Instruction[11:9];
        ID=7'h28+aux;
        RegD=Instruction[2:0];
        RegA=Instruction[5:3];
        RegB=Instruction[8:6];
      end

      6:begin//Instructions 48 & 49
        op=Instruction[11];
        ID=(op)? 7'h31: 7'h30;
        RegD[2:0]=Instruction[2:0];
        RegA[2:0]=Instruction[5:3];
        Offset[4:0]=Instruction[10:6];
      end

      7:begin//Instructions 50 & 51
        op=Instruction[11];
        ID=(op)? 7'h33: 7'h32;
        RegD[2:0]=Instruction[2:0];
        RegA[2:0]=Instruction[5:3];
        Offset[4:0]=Instruction[10:6];
      end

      8:begin//Instructions 52 & 53
        op=Instruction[11];
        ID=(op)? 7'h35: 7'h34;
        RegD[2:0]=Instruction[2:0];
        RegA[2:0]=Instruction[5:3];
        Offset[4:0]=Instruction[10:6];
      end

      9:begin//Instructions 54 & 55
        Offset[7:0]=Instruction[7:0];
        RegD[2:0]=Instruction[10:8];
        RegA=4'he;
        op=Instruction[11];
        ID=(op)?7'h37:7'h36;
      end

      10:begin//Instructions 56 & 57
        Offset[7:0]=Instruction[7:0];
        RegD[2:0]=Instruction[10:8];
        RegA=(op)?4'he : 4'hf;
        op=Instruction[11];
        ID=(op)?7'h39:7'h38;
      end

      11:begin  //Instructions 58 ~ 68
        funct2=Instruction[11:8];
        op=Instruction[7];
        funct1=Instruction[7:6];
        case(funct2)
          0:begin//Instructions 58
            ID=7'h3a;
          end
          2:begin//Instructions 59 ~ 62
            RegD[2:0]=Instruction[2:0];
            RegB[2:0]=Instruction[5:3];
            ID=7'h3b+funct1;
          end
          10:begin//Instructions 63 ~ 66
            RegD[2:0]=Instruction[2:0];
            RegB[2:0]=Instruction[5:3];
            ID=7'h3f+funct1;
          end
          4:begin//Instruction 67
            ID=7'h43;
            RegD=Instruction[2:0];
          end
          13:begin//Instruction 68
            ID=7'h44;
            RegD=Instruction[2:0];
          end
          14:begin
            case (funct1)
              0:begin //Instrunction 69 - OUTSS
                ID = 7'h45;
                RegD = Instruction[2:0];
              end
              1:begin //Instruction 70 - OUTLED
                ID = 7'h46;
                RegD = Instruction[2:0];
              end
              2:begin //Instruction 71 - INSW
                ID = 7'h47;
                RegD = Instruction[2:0];
              end
              default:ID=7'h7a;
            endcase
          end
			 default:begin
				ID=7'h7a;
			 end
        endcase//Opcode=11, case(funct2)
      end//Opcode=11

      12:begin//Instruction 72 - SWI
        ID=7'h48;
        Offset = 9; //Branches to 0x9
        RegB=4'hd;  //Link Register
      end

      13:begin//Instruction 73 - B
        ID=7'h49;
        Condicao=Instruction[11:8];
        Offset[7:0]=Instruction[7:0];
        RegA= 4'hf; //PC
      end

      14:begin//Instructions 74 & 75
        op=Instruction[11];
        ID = op?  7'h4b : 7'h4a; //HLT or NOP
      end
      15: begin //Reset State = 100
        ID = Instruction[15:0]==16'hffff ? 7'h64 : 7'h7f;
      end

      default:begin
        ID=7'h7f;
      end
    endcase//case(Opcode)

end
endmodule