/**
 * Title: ULA 74181
 * Description: Modulo que representa a implementação de uma ULA 74181 que é um CI
 */

// Módulo que implementa uma ULA (Unidade Lógica e Aritmética) de 4 bits com base no CI 74181
module module_ula_74181 (
        // Refere-se ao tipo, 0 para menos significativo e 1 para mais significativo
        input  logic t = 0, 
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
        input  logic       b_in,
        // Resultador
        output logic [3:0] f,
        // Alto se A = B
        output logic       a_eq_b,
        // Carry-out
        output logic       c_out,
        output logic       b_out
    );

    // Sinais internos
    logic [3:0] logic_result, arith_result;

    // Registrador para armazenar o resultado completo (com carry extra)
    logic [4:0] result;

    always_comb begin
        logic [3:0] logic_f;    // Resultado das operações lógicas
        logic [4:0] arith_f;    // Resultado das operações aritméticas (com carry)

        logic [4:0] tmp;        // Para algumas operações específicas

        // === OPERAÇÕES LÓGICAS === //
        // Executadas quando m = 1 (modo lógico)
        case (s)
            // 1 - NOT A
            4'b0000:
                logic_f = ~a;
            // 2 - NOR
            4'b0001:
                logic_f = ~(a | b);
            // 3 - NOT A AND B
            4'b0010:
                logic_f = ~a & b;
            // 4 - ZERO
            4'b0011:
                logic_f = 4'b0000;
            // 5 - NAND
            4'b0100:
                logic_f = ~(a & b);
            // 6 - NOT B
            4'b0101:
                logic_f = ~b;
            // 7 - XOR
            4'b0110:
                logic_f = a ^ b;
            // 8 - A AND NOT B
            4'b0111:
                logic_f = a & ~b;
            // 9 - NOT A OR B
            4'b1000:
                logic_f = ~a | b;
            // 10 - XNOR
            4'b1001:
                logic_f = ~(a ^ b);
            // 11 - B
            4'b1010:
                logic_f = b;
            // 12 - AND
            4'b1011:
                logic_f = a & b;
            // 13 - TODOS OS BITS IGUAIS - VALOR MÁXIMO
            4'b1100:
                logic_f = 4'b1111;
            // 14 - A OR NOT B
            4'b1101:
                logic_f = a | ~b;
            // 15 - OR
            4'b1110:
                logic_f = a | b;
            // 16 - A
            4'b1111:
                logic_f = a;
        endcase

        // === OPERAÇÕES ARITMÉTICAS ===
        // Executadas quando m = 0 (modo aritmético)
        // Os operandos são estendidos para 5 bits para acomodar o carry-out
        case (s)
            // 1 - A PLUS CIN
            4'b0000:
                arith_f = a + c_in;
            // 2 - (A OR B) PLUS CIN
            4'b0001:
                arith_f = {1'b0, a | b} + c_in;
            // 3 - (A OR NOT B) PLUS CIN
            4'b0010:
                // arith_f = (a | ~b) + c_in;
                arith_f = {1'b0, a | ~b} + c_in;
            // 4 - MINUS 1 + CIN - Menos 1 (complemento de 2) ou 0
            4'b0011: begin
                // Base da operação especial: -1 se não houver c_in, senão 0
                if (c_in === 1)
                    arith_f = 5'b00000;
                else
                    arith_f = 5'b11111;

                // Se houve borrow in, decrementa
                if (b_in === 1)
                    arith_f = arith_f - 1;
            end
            // 5 - A PLUS A AND NOT B PLUS CIN
            4'b0100:
                arith_f = a + {1'b0, a & ~b} + c_in;
            // 6 - A OR B PLUS A AND NOT B PLUS CIN
            4'b0101:
                arith_f = {1'b0, a | b} + {1'b0, a & ~b} + c_in;
            // 7 - A - B - 1 + CIN
            4'b0110: begin 
                arith_f = a - b + c_in;
                if (t === 1'b0) begin 
                    arith_f = arith_f - 1;
                end
            end
            // 8 - (A AND NOT B) - 1 + CIN
            4'b0111:
                arith_f = {1'b0, a & ~b} - 1 + c_in;
            // 9 - A + A AND B + CIN
            4'b1000:
                arith_f = a + {1'b0, a & b} + c_in;
            // 10 - A + B + CIN
            4'b1001:
                arith_f = a + b + c_in;
            // 11 - A OR NOT B PLUS A AND B PLUS CIN
            4'b1010:
                arith_f = {1'b0, a | ~b} + {1'b0, a & b} + c_in;
            // 12 - A AND B - 1 + CIN
            4'b1011: begin 
                arith_f = {1'b0, a & b} + c_in;
                if (t === 1'b0) begin 
                    arith_f = arith_f - 1;
                end
            end
            // 13 - (c_in === 0) ? A + A* : A + A + 1
            // * - Cada bit é passado para a p´roxima posição mais significante
            4'b1100:
                //arith_f = {1'b0, a} + {1'b0, a} + c_in;
                //arith_f = a + (a << 1) + c_in;
                arith_f = a + a + c_in;
            // 14 - A OR B PLUS A + CIN
            4'b1101:
                arith_f = {1'b0, a | b} + a + c_in;
            // 15 - A OR NOT B PLUS A + CIN
            4'b1110:
                arith_f = {1'b0, a | ~b} + a + c_in;
            // 16 - A - 1 + CIN
            4'b1111: begin 
                arith_f = a + c_in;
                if (t === 1'b0) begin 
                    arith_f = arith_f - 1;
                end
            end
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
    assign b_out = result[4];
    assign a_eq_b = (a == b);         // Verificação de igualdade entre A e B

endmodule
