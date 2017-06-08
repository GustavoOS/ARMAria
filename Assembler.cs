using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ARMAria_AssemblerNoGUI
{
    class memoria
    {
        public int code, user, priv, io, data, memorysize, cc, cu, cp, cio, cd;
        public memoria()
        {
            memorysize = 79;
            user = 24;
            priv = 36;
            io = 48;
            data = 38;
            code = 0;
            cc = code;
            cu = user;
            cp = priv;
            cio = io;
            cd = data;
        }

        public int address(int local)
        {
            switch (local)
            {
                case 1:
                    return cc;
                case 2:
                    return cu;
                case 3:
                    return cp;
                case 4:
                    return cio;
                case 5:
                    return cd;
                default:
                    return -1;
            }
        }
        public bool canadd(int local, int quant)
        {
            switch (local)
            {
                case 1:
                    if (cc + quant - 1 < user)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                //break;
                case 2:
                    if (cu + quant - 1 < priv)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                //break;
                case 3:
                    if (cp + quant - 1 < io)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                //break;
                case 4:
                    if (cio + quant - 1 < data)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                //break;
                case 5:
                    if (cd + quant <= memorysize)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                //break;
                default:
                    return false;
                    //break;
            }
        }
        public bool add(int local, int quant)
        {
            switch (local)
            {
                case 1:
                    if (cc + quant - 1 < user)
                    {
                        cc += quant;
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                    break;
                case 2:
                    if (cu + quant - 1 < priv)
                    {
                        cu += quant;
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                    break;
                case 3:
                    if (cp + quant - 1 < io)
                    {
                        cp += quant;
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                    break;
                case 4:
                    if (cio + quant - 1 < data)
                    {
                        cio += quant;
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                    break;
                case 5:
                    if (cd + quant <= memorysize)
                    {
                        cd += quant;
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                    break;
                default:
                    return false;
                    break;
            }
        }

    }
    class Program
    {

        static String convBinario(int number, int lenght)
        {
            String max = "";
            int maxint;
            for (int i = 0; i < lenght; i++)
            {
                max += "1";
            }
            maxint = Convert.ToInt32(max, 2);
            number = number < 0 ? 0 : number;
            number = number > maxint ? maxint : number;
            String saida = "";
            max = Convert.ToString(number, 2);
            int lenaux = max.Length;
            for (int i = 0; i < lenght - lenaux; i++)
            {
                saida += "0";
            }
            saida += max;
            return saida;
        }
        static String convlBinario(long number, int lenght)
        {
            String max = "";
            long maxint;
            for (int i = 0; i < lenght; i++)
            {
                max += "1";
            }
            maxint = Convert.ToInt64(max, 2);
            number = number < 0 ? 0 : number;
            number = number > maxint ? maxint : number;
            String saida = "";
            max = Convert.ToString(number, 2);
            int lenaux = max.Length;
            for (int i = 0; i < lenght - lenaux; i++)
            {
                saida += "0";
            }
            saida += max;
            return saida;
        }
        static String convsBinario(int number)
        {
            int lenght = 8;
            String max = "";
            number = number < -127 ? -127 : number;
            number = number > 127 ? 127 : number;
            String saida = "";
            max = Convert.ToString(number, 2);
            max = max.Substring(24);
            int lenaux = max.Length;
            for (int i = 0; i < lenght - lenaux; i++)
            {
                saida += "0";
            }
            saida += max;
            return saida;
        }
        static String extractValues(int type)
        {
            String output = "";
            switch (type)
            {
                case 1:
                    Console.WriteLine("Digite um imediato no intervalo 0-31");
                    output += convBinario(Convert.ToInt32(Console.ReadLine()), 5);
                    Console.WriteLine("Digite o número do registrador da esquerda no intervalo 0-7");
                    output += convBinario(Convert.ToInt32(Console.ReadLine()), 3);
                    Console.WriteLine("Digite o número do registrador da direita no intervalo 0-7");
                    output += convBinario(Convert.ToInt32(Console.ReadLine()), 3);
                    break;
                case 2:
                    Console.WriteLine("Digite o número do registrador da esquerda no intervalo 0-7");
                    output += convBinario(Convert.ToInt32(Console.ReadLine()), 3);
                    Console.WriteLine("Digite o número do registrador do meio no intervalo 0-7");
                    output += convBinario(Convert.ToInt32(Console.ReadLine()), 3);
                    Console.WriteLine("Digite o número do registrador da direita no intervalo 0-7");
                    output += convBinario(Convert.ToInt32(Console.ReadLine()), 3);
                    break;
                case 3:
                    Console.WriteLine("Digite o imediato do registrador da esquerda no intervalo 0-7");
                    output += convBinario(Convert.ToInt32(Console.ReadLine()), 3);
                    Console.WriteLine("Digite o número do registrador da esquerda no intervalo 0-7");
                    output += convBinario(Convert.ToInt32(Console.ReadLine()), 3);
                    Console.WriteLine("Digite o número do registrador da direita no intervalo 0-7");
                    output += convBinario(Convert.ToInt32(Console.ReadLine()), 3);
                    break;
                case 4:
                    Console.WriteLine("Digite o número do registrador no intervalo 0-7");
                    output += convBinario(Convert.ToInt32(Console.ReadLine()), 3);
                    Console.WriteLine("Digite o imediato no intervalo 0-255");
                    output += convBinario(Convert.ToInt32(Console.ReadLine()), 8);
                    break;
                case 5:
                    Console.WriteLine("Aviso:Caso a instrução use um registrador alto, realize a soma NumeroDoRegistrador-7, não use os registradores 13, 14 e 15!");
                    Console.WriteLine("Digite o número do registrador da esquerda no intervalo 0-7");
                    output += convBinario(Convert.ToInt32(Console.ReadLine()), 3);
                    Console.WriteLine("Digite o registrador da direita no intervalo 0-7");
                    output += convBinario(Convert.ToInt32(Console.ReadLine()), 3);
                    break;
                case 6:
                    Console.WriteLine("Digite o código da condição no intervalo 0-15");
                    output += convBinario(Convert.ToInt32(Console.ReadLine()), 4);
                    Console.WriteLine("Digite o registrador no intervalo 0-12");
                    int aux = Convert.ToInt32(Console.ReadLine());
                    aux = aux > 12 ? 12 : aux;
                    output += convBinario(aux, 4);
                    break;
                case 7:
                    Console.WriteLine("Digite o código da condição no intervalo 0-15");
                    output += convBinario(Convert.ToInt32(Console.ReadLine()), 4);
                    Console.WriteLine("Digite o registrador da direita no intervalo -127 a +127");
                    output += convlBinario(Convert.ToInt64(Convert.ToString(Convert.ToInt32(Console.ReadLine())), 2), 8);
                    break;
                default:
                    Console.WriteLine("Tipo inválido");
                    break;
            }
            return output;
        }


        static String CalculaInstrucao(int id)
        {
            String ID = "";
            //Console.WriteLine("ID = " + id);
            switch (id)
            {
                case 1:
                    Console.WriteLine("Mnemônico: LSL");
                    Console.WriteLine("Descrição: Deslocamento lógico à esquerda");
                    ID = "00000";
                    ID += extractValues(1);
                    break;
                case 2:
                    Console.WriteLine("Mnemônico: LSR");
                    Console.WriteLine("Descrição: DeslocameDeslocamento lógico à direita");
                    ID = "00001";
                    ID += extractValues(1);
                    break;
                case 3:
                    Console.WriteLine("Mnemônico: ASR");
                    Console.WriteLine("Descrição: Deslocamento aritmético à direita");
                    ID = "00010";
                    ID += extractValues(1);
                    break;
                case 4:
                    Console.WriteLine("Mnemônico: ADD");
                    Console.WriteLine("Descrição: Soma");
                    ID = "0001100";
                    ID += extractValues(2);
                    break;
                case 5:
                    Console.WriteLine("Mnemônico: SUB");
                    Console.WriteLine("Descrição: Subtração");
                    ID = "0001101";
                    ID += extractValues(2);
                    break;
                case 6:
                    Console.WriteLine("Mnemônico: ADD");
                    Console.WriteLine("Descrição: Soma");
                    ID = "0001110";
                    ID += extractValues(3);
                    break;
                case 7:
                    Console.WriteLine("Mnemônico: SUB");
                    Console.WriteLine("Descrição: Subtração");
                    ID = "0001111";
                    ID += extractValues(3);
                    break;
                case 8:
                    Console.WriteLine("Mnemônico: MOV");
                    Console.WriteLine("Descrição: Movimenta conteúdo");
                    ID = "00100";
                    ID += extractValues(4);
                    break;
                case 9:
                    Console.WriteLine("Mnemônico: CMP");
                    Console.WriteLine("Descrição: Comparação");
                    ID = "00101";
                    ID += extractValues(4);
                    break;
                case 10:
                    Console.WriteLine("Mnemônico: ADD");
                    Console.WriteLine("Descrição: Soma");
                    ID = "00110";
                    ID += extractValues(4);
                    break;
                case 11:
                    Console.WriteLine("Mnemônico: SUB");
                    Console.WriteLine("Descrição: Subtração");
                    ID = "00111";
                    ID += extractValues(4);
                    break;
                case 12:
                    Console.WriteLine("Mnemônico: AND");
                    Console.WriteLine("Descrição: E bit a bit");
                    ID = "0100000000";
                    ID += extractValues(5);
                    break;
                case 13:
                    Console.WriteLine("Mnemônico: EXOR");
                    Console.WriteLine("Descrição: XOR");
                    ID = "0100000001";
                    ID += extractValues(5);
                    break;
                case 14:
                    Console.WriteLine("Mnemônico: LSL");
                    Console.WriteLine("Descrição: Deslocamento lógico à esquerda");
                    ID = "0100000010";
                    ID += extractValues(5);
                    break;
                case 15:
                    Console.WriteLine("Mnemônico: LSR");
                    Console.WriteLine("Descrição: Deslocamento lógico à direita");
                    ID = "0100000011";
                    ID += extractValues(5);
                    break;
                case 16:
                    Console.WriteLine("Mnemônico: ASR");
                    Console.WriteLine("Descrição: Deslocamento aritmético à direita");
                    ID = "0100000100";
                    ID += extractValues(5);
                    break;
                case 17:
                    Console.WriteLine("Mnemônico: ADC");
                    Console.WriteLine("Descrição: Soma com carry");
                    ID = "0100000101";
                    ID += extractValues(5);
                    break;
                case 18:
                    Console.WriteLine("Mnemônico: SBC");
                    Console.WriteLine("Descrição: Subtrai com carry");
                    ID = "0100000110";
                    ID += extractValues(5);
                    break;
                case 19:
                    Console.WriteLine("Mnemônico: ROR");
                    Console.WriteLine("Descrição: Rotação à direita");
                    ID = "0100000111";
                    ID += extractValues(5);
                    break;
                case 20:
                    Console.WriteLine("Mnemônico: TST");
                    Console.WriteLine("Descrição: Teste baseado em E lógico");
                    ID = "0100001000";
                    ID += extractValues(5);
                    break;
                case 21:
                    Console.WriteLine("Mnemônico: NEG");
                    Console.WriteLine("Descrição: Inverte Sinal");
                    ID = "0100001001";
                    ID += extractValues(5);
                    break;

                case 22:
                    Console.WriteLine("Mnemônico: CMP");
                    Console.WriteLine("Descrição: Comparação");
                    ID = "0100001010";
                    ID += extractValues(5);
                    break;

                case 23:
                    Console.WriteLine("Mnemônico: CMN");
                    Console.WriteLine("Descrição: Compara números negativos");
                    ID = "0100001011";
                    ID += extractValues(5);
                    break;
                case 24:
                    Console.WriteLine("Mnemônico: ORR");
                    Console.WriteLine("Descrição: OU lógico");
                    ID = "0100001100";
                    ID += extractValues(5);
                    break;
                case 25:
                    Console.WriteLine("Mnemônico: MUL");
                    Console.WriteLine("Descrição: Multiplicação de inteiros");
                    ID = "0100001101";
                    ID += extractValues(5);
                    break;
                case 26:
                    Console.WriteLine("Mnemônico: BIC");
                    Console.WriteLine("Descrição: Bit Clear (AND NOT)");
                    ID = "0100001110";
                    ID += extractValues(5);
                    break;
                case 27:
                    Console.WriteLine("Mnemônico: MVN");
                    Console.WriteLine("Descrição: NOT bit a bit");
                    ID = "0100001111";
                    ID += extractValues(5);
                    break;

                case 28:
                    Console.WriteLine("Mnemônico: ADD");
                    Console.WriteLine("Descrição: Soma");
                    ID = "0100010001";
                    ID += extractValues(5);
                    break;
                case 29:
                    Console.WriteLine("Mnemônico: ADD");
                    Console.WriteLine("Descrição: Soma");
                    ID = "0100010010";
                    ID += extractValues(5);
                    break;
                case 30:
                    Console.WriteLine("Mnemônico: ADD");
                    Console.WriteLine("Descrição: Soma");
                    ID = "0100010011";
                    ID += extractValues(5);
                    break;
                case 31:
                    Console.WriteLine("Mnemônico: CMP");
                    Console.WriteLine("Descrição: Comparação");
                    ID = "0100010101";
                    ID += extractValues(5);
                    break;
                case 32:
                    Console.WriteLine("Mnemônico: CMP");
                    Console.WriteLine("Descrição: Comparação");
                    ID = "0100010110";
                    ID += extractValues(5);
                    break;
                case 33:
                    Console.WriteLine("Mnemônico: CMP");
                    Console.WriteLine("Descrição: Comparação");
                    ID = "0100010111";
                    ID += extractValues(5);
                    break;
                case 34:
                    Console.WriteLine("Mnemônico: DIV");
                    Console.WriteLine("Descrição: Divisão Inteira");
                    ID = "0100011000";
                    ID += extractValues(5);
                    break;
                case 35:
                    Console.WriteLine("Mnemônico: MOV");
                    Console.WriteLine("Descrição: Movimenta Conteúdo");
                    ID = "0100011001";
                    ID += extractValues(5);
                    break;
                case 36:
                    Console.WriteLine("Mnemônico: MOV");
                    Console.WriteLine("Descrição: Movimenta Conteúdo");
                    ID = "0100011010";
                    ID += extractValues(5);
                    break;
                case 37:
                    Console.WriteLine("Mnemônico: MOV");
                    Console.WriteLine("Descrição: Movimenta Conteúdo");
                    ID = "0100011011";
                    ID += extractValues(5);
                    break;
                case 38:
                    Console.WriteLine("Mnemônico: BX");
                    Console.WriteLine("Descrição: Ramificação Indireta");
                    ID = "01000111";
                    ID += extractValues(6);
                    break;
                case 39:
                    Console.WriteLine("Mnemônico: LDR");
                    Console.WriteLine("Descrição: Carrega registrador de endereço relativo ao PC");
                    ID = "01001";
                    ID += extractValues(4);
                    break;
                case 40:
                    Console.WriteLine("Mnemônico: STR");
                    Console.WriteLine("Descrição: Guarda registrador como palavra");
                    ID = "0101000";
                    ID += extractValues(2);
                    break;
                case 41:
                    Console.WriteLine("Mnemônico: STRH");
                    Console.WriteLine("Descrição: Guarda registrador como meia palavra");
                    ID = "0101001";
                    ID += extractValues(2);
                    break;
                case 42:
                    Console.WriteLine("Mnemônico: STRB");
                    Console.WriteLine("Descrição: Guarda registrador como byte");
                    ID = "0101010";
                    ID += extractValues(2);
                    break;
                case 43:
                    Console.WriteLine("Mnemônico: LDRSB");
                    Console.WriteLine("Descrição: Carrega reg. com byte sinalizado");
                    ID = "0101011";
                    ID += extractValues(2);
                    break;
                case 44:
                    Console.WriteLine("Mnemônico: LDR");
                    Console.WriteLine("Descrição: Guarda registrador como palavra");
                    ID = "0101100";
                    ID += extractValues(2);
                    break;
                case 45:
                    Console.WriteLine("Mnemônico: LDRH");
                    Console.WriteLine("Descrição: Carrega registrador com meia palavra");
                    ID = "0101101";
                    ID += extractValues(2);
                    break;
                case 46:
                    Console.WriteLine("Mnemônico: LDRB");
                    Console.WriteLine("Descrição: Carrega registrador com byte");
                    ID = "0101110";
                    ID += extractValues(2);
                    break;
                case 47:
                    Console.WriteLine("Mnemônico: LDRSH");
                    Console.WriteLine("Descrição: Carrega reg. com meia palavra sinalizada");
                    ID = "0101111";
                    ID += extractValues(2);
                    break;
                case 48:
                    Console.WriteLine("Mnemônico: STR");
                    Console.WriteLine("Descrição: Guarda registrador como palavra");
                    ID = "01100";
                    ID += extractValues(1);
                    break;
                case 49:
                    Console.WriteLine("Mnemônico: LDR");
                    Console.WriteLine("Descrição: Carrega registrador com palavra");
                    ID = "01101";
                    ID += extractValues(1);
                    break;
                case 50:
                    Console.WriteLine("Mnemônico: STRB");
                    Console.WriteLine("Descrição: Guarda registrador como byte");
                    ID = "01110";
                    ID += extractValues(1);
                    break;
                case 51:
                    Console.WriteLine("Mnemônico: LDRB");
                    Console.WriteLine("Descrição: Carrega registrador com byte");
                    ID = "01111";
                    ID += extractValues(1);
                    break;
                case 52:
                    Console.WriteLine("Mnemônico: STRH");
                    Console.WriteLine("Descrição: Guarda registrador como meia palavra");
                    ID = "10000";
                    ID += extractValues(1);
                    break;
                case 53:
                    Console.WriteLine("Mnemônico: LDRH");
                    Console.WriteLine("Descrição: Carrega registrador com meia palavra");
                    ID = "10001";
                    ID += extractValues(1);
                    break;
                case 54:
                    Console.WriteLine("Mnemônico: STR");
                    Console.WriteLine("Descrição: Guarda registrador como palavra");
                    ID = "10010";
                    ID += extractValues(4);
                    break;
                case 55:
                    Console.WriteLine("Mnemônico: LDR");
                    Console.WriteLine("Descrição: Carrega registrador com palavra");
                    ID = "10011";
                    ID += extractValues(4);
                    break;
                case 56:
                    Console.WriteLine("Mnemônico: ADD");
                    Console.WriteLine("Descrição: Soma Ld, pc, #imediato*4");
                    ID = "10100";
                    ID += extractValues(4);
                    break;
                case 57:
                    Console.WriteLine("Mnemônico: ADD");
                    Console.WriteLine("Descrição: Soma Ld, sp,#imediato*4");
                    ID = "10101";
                    ID += extractValues(4);
                    break;
                case 58:
                    Console.WriteLine("Mnemônico: CLRSTK");
                    Console.WriteLine("Descrição: Limpa Pilha");
                    ID = "10110000";
                    ID += convBinario(0, 8);
                    break;
                case 59:
                    Console.WriteLine("Mnemônico: SXTH");
                    Console.WriteLine("Descrição: Extende sinal a meia palavra");
                    ID = "1011001000";
                    ID += extractValues(5);
                    break;
                case 60:
                    Console.WriteLine("Mnemônico: SXTB");
                    Console.WriteLine("Descrição: Extende sinal a byte");
                    ID = "1011001001";
                    ID += extractValues(5);
                    break;
                case 61:
                    Console.WriteLine("Mnemônico: UXTH");
                    Console.WriteLine("Descrição: Estende zero a meia palavra");
                    ID = "1011001010";
                    ID += extractValues(5);
                    break;
                case 62:
                    Console.WriteLine("Mnemônico: UXTB");
                    Console.WriteLine("Descrição: Estende zero a byte");
                    ID = "1011001011";
                    ID += extractValues(5);
                    break;
                case 63:
                    Console.WriteLine("Mnemônico: REV");
                    Console.WriteLine("Descrição: Reversão de bytes em palavra");
                    ID = "1011101000";
                    ID += extractValues(5);
                    break;
                case 64:
                    Console.WriteLine("Mnemônico: REV16");
                    Console.WriteLine("Descrição: Reverte bytes de meia palavra");
                    ID = "1011101001";
                    ID += extractValues(5);
                    break;
                case 65:
                    Console.WriteLine("Mnemônico: MOD");
                    Console.WriteLine("Descrição: Resto de divisão");
                    ID = "1011101010";
                    ID += extractValues(5);
                    break;
                case 66:
                    Console.WriteLine("Mnemônico: REVSH");
                    Console.WriteLine("Descrição: Reversão de bytes de meias palavras sinalizadas");
                    ID = "1011101011";
                    ID += extractValues(5);
                    break;
                case 67:
                    Console.WriteLine("Mnemônico: PUSH");
                    Console.WriteLine("Descrição: Empilha Registrador");
                    ID = "10110100";
                    ID += convBinario(0, 5);
                    Console.WriteLine("Digite o número do registrador baixo no intervalo 0-7");
                    ID += convBinario(Convert.ToInt32(Console.ReadLine()), 3);
                    break;
                case 68:
                    Console.WriteLine("Mnemônico: POP");
                    Console.WriteLine("Descrição: Desempilha Registrador");
                    ID = "10111101";
                    ID += convBinario(0, 5);
                    Console.WriteLine("Digite o número do registrador baixo no intervalo 0-7");
                    ID += convBinario(Convert.ToInt32(Console.ReadLine()), 3);
                    break;
                case 69:
                    Console.WriteLine("Mnemônico: SWI");
                    Console.WriteLine("Descrição: Software Interruption");
                    ID = "1100";
                    ID += convBinario(0, 12);
                    break;
                case 70:
                    Console.WriteLine("Mnemônico: B");
                    Console.WriteLine("Descrição: Ramificação");
                    ID = "1101";
                    ID += extractValues(7);
                    break;
                case 71:
                    Console.WriteLine("Mnemônico: NOP");
                    Console.WriteLine("Descrição: Pula operação");
                    ID = "11100";
                    ID += convBinario(0, 11);
                    break;
                case 72:
                    Console.WriteLine("Mnemônico: HALT");
                    Console.WriteLine("Descrição: Para operações");
                    ID = "11101";
                    ID += convBinario(0, 11);
                    break;

                default:
                    ID = "0";
                    Console.WriteLine("Instrução Inválida");
                    break;
            }

            return ID;
        }

        [STAThread]
        static void Main(string[] args)
        {
            StringBuilder texto = new StringBuilder();
            memoria processador = new memoria();
            Console.WriteLine("ARMARIA Assembler");
            Console.WriteLine("Desenvlvido por Gustavo Souza");
            Console.WriteLine(@"https://github.com/GustavoOS/");
            Console.WriteLine("-------------------");
            Console.WriteLine();


            Console.WriteLine();
            Console.WriteLine("Configuração:");
            Console.Write("|" + processador.code + "---Code---"); Console.Write(processador.user - 1); Console.WriteLine("|");
            Console.Write("|" + processador.user + "---User Stack---"); Console.Write(processador.priv - 1); Console.WriteLine("|");
            Console.Write("|" + processador.priv + "---Privileged Stack---"); Console.Write(processador.io - 1); Console.WriteLine("|");
            Console.Write("|" + processador.io + "---Input Output---"); Console.Write(processador.data - 1); Console.WriteLine("|");
            Console.Write("|" + processador.data + "---Data---"); Console.Write(processador.memorysize); Console.WriteLine("|");
            Console.WriteLine("");
            Console.WriteLine("");
            Console.WriteLine("Digite 0 para sair do assembler ou outro número para continuar");
            String read = Console.ReadLine();
            int fluxo;
            fluxo = read != "" ? Convert.ToInt32(read) : 0;
            List<int> enderecos = new List<int>();
            List<byte> dados = new List<byte>();
            List<int> insts = new List<int>(); //Record all instruction as integers
            while (fluxo != 0)
            //for(int i=0; i<72; i++)
            {

                Console.WriteLine();
                Console.WriteLine("O que você gostaria de fazer agora?");
                Console.WriteLine("Digite 0 para fazer nada nesta iteração ");
                Console.WriteLine("Digite 1 para calcular nova instrução");
                Console.WriteLine("Digite 2 para gravar byte");
                Console.WriteLine("Digite 3 para gravar halfword. Esta é a opção para gravar instruções.");
                Console.WriteLine("Digite 4 para gravar palavra");
                Console.WriteLine("Digite 5 para ver dados armazenados");
                //Console.WriteLine("Programa capado temporariamente");
                read = Console.ReadLine();
                Console.WriteLine();

                int option;
                if (read != "")
                {
                    option = Convert.ToInt32(read);
                }
                else
                {
                    option = 0;
                }
                //option = 1; //Capa o programa para apenas calcular as istruções e salvar
                switch (option)
                {
                    case 0:
                        //fluxo = 0;
                        break;
                    case 1:
                        Console.WriteLine("Digite a ID da instrução");

                        String instrucao = CalculaInstrucao(Convert.ToInt32(Console.ReadLine()));
                        insts.Add(Convert.ToInt32(instrucao, 2));//Armazena as instruções como inteiras
                        Console.WriteLine("Decimal: " + Convert.ToInt32(instrucao, 2));
                        Console.WriteLine("Binário: " + instrucao);
                        break;
                    case 2:
                        Console.WriteLine("Onde você deseja adicionar?");
                        Console.WriteLine("Digite: 1 para região Code, 2 para região User Stack, 3 para região Privileged Stack, 4 para Região E/S, 5 para região Dados");
                        int local = Convert.ToInt32(Console.ReadLine());
                        local = local < 1 ? 1 : local > 5 ? 5 : local;
                        Console.WriteLine("Digite um dado no intervalo de 0-255");
                        byte dado = Convert.ToByte(Console.ReadLine());
                        if (processador.canadd(local, 1))
                        {
                            dados.Add(dado);
                            enderecos.Add(processador.address(local));
                            processador.add(local, 1);
                        }
                        else
                        {
                            Console.WriteLine("Seção cheia");
                        }

                        break;
                    case 3:
                        Console.WriteLine("Onde você deseja adicionar?");
                        Console.WriteLine("Digite: 1 para região Code, 2 para região User Stack, 3 para região Privileged Stack, 4 para Região E/S, 5 para região Dados");
                        int local1 = Convert.ToInt32(Console.ReadLine());
                        local1 = local1 < 1 ? 1 : local1 > 5 ? 5 : local1;
                        Console.WriteLine("Digite um dado no intervalo de 0-65535");
                        String leitura = convlBinario(Convert.ToInt64(Console.ReadLine()), 16);

                        if (processador.canadd(local1, 2))
                        {
                            String aux = "";
                            for (int j = 0; j < 2; j++)
                            {
                                aux = leitura.Substring(j * 8, 8);
                                dados.Add(Convert.ToByte(aux, 2));
                                enderecos.Add(processador.address(local1));
                                processador.add(local1, 1);
                            }
                        }
                        else
                        {
                            Console.WriteLine("Não cabe nesta seção");
                        }

                        break;
                    case 4:
                        Console.WriteLine("Onde você deseja adicionar?");
                        Console.WriteLine("Digite: 1 para região Code, 2 para região User Stack, 3 para região Privileged Stack, 4 para Região E/S, 5 para região Dados");
                        int local2 = Convert.ToInt32(Console.ReadLine());
                        local2 = local2 < 1 ? 1 : local2 > 5 ? 5 : local2;
                        Console.WriteLine("Digite um dado no intervalo de 0-4294967295");
                        String leitura1 = convlBinario(Convert.ToInt64(Console.ReadLine()), 32);

                        if (processador.canadd(local2, 4))
                        {
                            String aux = "";
                            for (int k = 0; k < 4; k++)
                            {
                                aux = leitura1.Substring(k * 8, 8);
                                dados.Add(Convert.ToByte(aux, 2));
                                enderecos.Add(processador.address(local2));
                                processador.add(local2, 1);
                            }
                        }
                        else
                        {
                            Console.WriteLine("Não cabe nesta seção");
                        }

                        break;
                    case 5:
                        Console.WriteLine("Endereço - Dados");
                        for (int l = 0; l < dados.Count; l++)
                        {
                            Console.WriteLine(enderecos[l] + "  -  " + dados[l]);
                        }
                        break;
                    default:
                        Console.WriteLine("Opção Inválida");
                        break;
                }
                Console.WriteLine();



                //While end
                Console.WriteLine("Digite 0 para sair do assembler ou outro número para continuar");
                read = Console.ReadLine();
                fluxo = read != "" ? Convert.ToInt32(read) : 0;
            }
            texto.AppendLine(@"//Instructions");
            foreach (int d in insts)
            {
                texto.AppendLine(d.ToString());
            }
            texto.AppendLine();
            texto.AppendLine(@"//Memory");
            texto.AppendLine(@"//Paste this onto reset on external memory");
            ; texto.AppendLine();
            for (int i = 0; i < dados.Count; i++)
            {
                if (enderecos[i] != 52 && enderecos[i] != 53)
                {
                    texto.AppendLine("RAM[" + enderecos[i] + "] <= " + dados[i] + ";");
                }
            }
            for (int i = 0; i < processador.memorysize + 1; i++)
            {
                if (enderecos.IndexOf(i) == -1 && i!=52 && i!= 53)
                {
                    texto.AppendLine("RAM[" + i + "] <= 0;");
                }
            }
            Console.WriteLine("Salvando");
            using (SaveFileDialog sFile = new SaveFileDialog())
            {
                sFile.Filter = "Arquivo de texto|*.txt";
                sFile.Title = "Salve a saída do Assembler";
                sFile.FileName = "Memory";
                sFile.ShowDialog();
                Console.WriteLine(sFile.FileName);
                System.IO.File.WriteAllText(sFile.FileName, texto.ToString());
            }
            Console.ReadLine();//Pause
        }
    }
}
