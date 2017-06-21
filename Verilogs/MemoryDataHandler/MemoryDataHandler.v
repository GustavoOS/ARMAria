module MemoryDataHandler(
  OData, IData,
  Read,//Read memory
  DataWriteByte3, DataWriteByte2, DataWriteByte1, DataWriteByte0,//Write memory
  PreMemIn,//outputs
  MemOut,//Input from register Bank
  control//Control Unit
  );

  // input [7:0] DataReadByte3, DataReadByte2, DataReadByte1, DataReadByte0;
  input [31:0] MemOut, Read;
  input [15:0] IData;
  input [3:0] control;
  output reg [7:0] DataWriteByte3, DataWriteByte2, DataWriteByte1, DataWriteByte0;
  output reg [31:0] PreMemIn, OData;


  always @ ( * ) begin
    PreMemIn=0;
    DataWriteByte3=0;
    DataWriteByte2=0;
    DataWriteByte1=0;
    DataWriteByte0=0;
    OData = 0;
    case (control)
      1:begin //Control==1, WRITE BYTE
      DataWriteByte0=MemOut[7:0];
      end
      2:begin //WRITE  WORD
        DataWriteByte0 = MemOut[7:0];
        DataWriteByte1 = MemOut[15:8];
        DataWriteByte2 = MemOut[23:16];
        DataWriteByte3 = MemOut[31:24];
      end
      3:begin//WRITE HALFWORD
        DataWriteByte0=MemOut[7:0];
        DataWriteByte1=MemOut[15:8];
      end
      4:begin //READ BYTE
        PreMemIn[7:0] = Read[7:0];
      end
      5:begin //READ HALFWORD
        PreMemIn[15:0] = Read[15:0];
      end
      6:begin //READ WORD
        PreMemIn = Read;
      end
      7:begin //Input from switch
        PreMemIn[15:0] = IData;
      end
      8:begin //Output
        OData = MemOut;
      end
      default:begin//Control==0
        PreMemIn=0;//Nothing at all
      end
    endcase

  end

endmodule
