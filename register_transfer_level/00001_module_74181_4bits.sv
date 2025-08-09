/**
 * Title: ULA 74181
 * Description: Modulo que representa a implementação de uma ULA 74181 que é um CI
 */

// Módulo que implementa uma ULA (Unidade Lógica e Aritmética) de 4 bits com base no CI 74181
module module_ula_74181 (
        // A (4 bits)
        input  logic [3:0] a,
        // B (4 bits)
        input  logic [3:0] b,
        // Seletor do tipo da operação - (função)
        input  logic [3:0] s,
        // Modo: 1 = lógica, 0 = aritmética
        input  logic       m,
        // Carry-in
        input  logic       c_in,
        // Resultador
        output logic [3:0] f,
        // Alto se A = B
        output logic       a_eq_b,
        // Carry-out
        output logic       c_out
    );

    // Sinais internos
    logic [3:0] logic_result, arith_result;
    logic carry;

    // Registrador para armazenar o resultado completo (com carry extra)
    logic [4:0] result;

    always_comb begin
        logic [3:0] logic_f;    // Resultado das operações lógicas
        logic [4:0] arith_f;    // Resultado das operações aritméticas (com carry)

        // === OPERAÇÕES LÓGICAS === //
        // Executadas quando m = 1 (modo lógico)
        case (s)
            // NOT A
            4'b0000:
                logic_f = ~a;
            // NOR
            4'b0001:
                logic_f = ~(a | b);
            // NOT A AND B
            4'b0010:
                logic_f = ~a & b;
            // ZERO
            4'b0011:
                logic_f = 4'b0000;
            // NAND
            4'b0100:
                logic_f = ~(a & b);
            // NOT B
            4'b0101:
                logic_f = ~b;
            // XOR
            4'b0110:
                logic_f = a ^ b;
            // A AND NOT B
            4'b0111:
                logic_f = a & ~b;
            // NOT A OR B
            4'b1000:
                logic_f = ~a | b;
            //XNOR
            4'b1001:
                logic_f = ~(a ^ b);
            // B
            4'b1010:
                logic_f = b;
            // AND
            4'b1011:
                logic_f = a & b;
            // TODOS OS BITS IGUAIS - VALOR MÁXIMO
            4'b1100:
                logic_f = 4'b1111;
            // A OR NOT B
            4'b1101:
                logic_f = a | ~b;
            // OR
            4'b1110:
                logic_f = a | b;
            // A
            4'b1111:
                logic_f = a;
        endcase

        // === OPERAÇÕES ARITMÉTICAS ===
        // Executadas quando m = 0 (modo aritmético)
        // Os operandos são estendidos para 5 bits para acomodar o carry-out
        case (s)
            // A + Cin
            4'b0000:
                arith_f = a + c_in;
            // (A OR B) + Cin
            4'b0001:
                arith_f = (a | b) + c_in;
            // (A OR NOT B) + Cin
            4'b0010:
                arith_f = (a | ~b) + c_in;
            // MINUS 1 + Cin - Menos 1 (complemento de 2) ou 0
            4'b0011:
                arith_f = 5'b11111 + c_in; // -1 + c_in
            // A PLUS A AND NOT B PLUS CIN
            4'b0100:
                arith_f = a + (a & ~b) + c_in;
            // A OR B PLUS A AND NOT B PLUS CIN
            4'b0101:
                arith_f = (a | b) + (a & ~b) + c_in;
            // A - B - 1 + CIN
            4'b0110:
                arith_f = a - b - 1 + c_in;
            // (A AND NOT B) - 1 + CIN
            4'b0111:
                arith_f = (a & ~b) - 1 - c_in;
            // A + A AND B + CIN
            4'b1000:
                arith_f = a + (a & b) + c_in;
            // A + B + CIN
            4'b1001:
                arith_f = a + b + c_in;
            // A OR NOT B PLUS A AND B PLUS CIN
            4'b1010:
                arith_f = (a | ~b) + (a & b) + c_in;
            // A AND B - 1 + CIN
            4'b1011:
                arith_f = a & b - 1 - c_in;
            // (c_in === 0) ? A + A* : A + A + 1
            // * - Cada bit é passado para a p´roxima posição mais significante 
            4'b1100:
                //arith_f = {1'b0, a} + {1'b0, a} + c_in;
                //arith_f = a + (a << 1) + c_in;
                arith_f = a + a + c_in;
            // A OR B PLUS A + CIN
            4'b1101:
                arith_f = (a | b) + a + c_in;
            // A OR NOT B PLUS A + CIN
            4'b1110:
                arith_f = (a | ~b) + a + c_in;
            // A - 1 + CIN
            4'b1111:
                arith_f = a - 1 - c_in;
        endcase

        // === Seleção do resultado final ===
        if (m)
            result = {1'b0, logic_f};     // Resultado lógico (sem carry)
        else
            result = arith_f;             // Resultado aritmético (com carry)

    end

    // === Atribuições finais às saídas ===
    assign f = result[3:0];           // Saída principal de 4 bits
    assign c_out = result[4];         // Carry-out do bit mais significativo
    assign a_eq_b = (a == b);         // Verificação de igualdade entre A e B

endmodule
