module tb_ula_74181_arit;

    logic [7:0] a, b; 
    logic [3:0] s;
    logic m, c_in;
    logic [7:0] f;
    logic a_eq_b, c_out;

    // Instancia a ULA
    ula_8bits dut (
                  .a(a), .b(b), .s(s),
                  .m(m), .c_in(c_in),
                  .f(f), .a_eq_b(a_eq_b),
                  .c_out(c_out)
              );

    // Tarefa para teste
    task automatic testa(
            input [7:0] ta, tb, 
            input [3:0] ts,
            input tm, tc_in,
            input [7:0] f_esperado,
            input c_out_esperado
        );
        begin
            a = ta;
            b = tb;
            s = ts;
            m = tm;
            c_in = tc_in;
            #1; // espera avaliação combinacional
            if (f !== f_esperado || c_out !== c_out_esperado) begin
                $display("ERRO: m=%0b s=%04b a=%03d b=%03d c_in=%0b -> f=%03d (esperado=%03d) c_out=%0b (esperado=%03b)",
                         m, s, a, b, c_in, f, f_esperado, c_out, c_out_esperado);
            end
            else begin
                $display("OK: m=%0b s=%04b a=%03d b=%03d c_in=%0b -> f=%03d c_out=%0b",
                         m, s, a, b, c_in, f, c_out);
            end
        end
    endtask

    initial begin
        $dumpfile("ula_arit.vcd");
        $dumpvars(0, tb_ula_74181_arit);

        $display("#############################");
        $display("MODO ARITMÉTICO");
        $display("#############################");

        m = 0; // modo aritmético

        // 1º Caso - A PLUS CIN
        $display("1 Caso - A + Cin");
        //    a            b            s         m  c_in   f            c_out
        testa(8'b11000011, 8'b00000000, 4'b0000, 0, 0,      8'b11000011, 0); // Sem Cin
        testa(8'b11000011, 8'b00000000, 4'b0000, 0, 1,      8'b11000100, 0); // Com Cin
        testa(8'b11111111, 8'b00000000, 4'b0000, 0, 1,      8'b00000000, 1); // com Cout

        // 2º Caso - (A OR B) PLUS CIN
        $display("2 Caso - A OR B + Cin");
        testa(8'b11000011, 8'b11000000, 4'b0000, 0, 0,      8'b11000011, 0); // Sem Cin
        testa(8'b11000011, 8'b00000001, 4'b0000, 0, 1,      8'b11000100, 0); // Com Cin

        // 3º Caso - (A OR NOT B) PLUS CIN
        $display("3 Caso - (A OR NOT B) + Cin");
        testa(8'b00000001, 8'b11111111, 4'b0010, 0, 0,      8'b00000001, 0); // Sem Cin
        testa(8'b00000001, 8'b11111111, 4'b0010, 0, 1,      8'b00000010, 0); // Com Cin
        testa(8'b00000001, 8'b00000000, 4'b0010, 0, 1,      8'b00000000, 1); // Com Cout

        // 4º Caso - MINUS 1 + CIN
        $display("4 Caso - MINUS 1 + CIN");
        testa(8'b00000000, 8'b00000000, 4'b0011, 0, 0,      8'b11111111, 0); // Sem Cin
        testa(8'b00000000, 8'b00000000, 4'b0011, 0, 1,      8'b00000000, 1); // Com Cin

        // 5º Caso - A PLUS A AND NOT B PLUS CIN
        $display("5 Caso - A PLUS A AND NOT B PLUS CIN");
        testa(8'b00010010, 8'b00000001, 4'b0100, 0, 0,      8'b00100100, 0); // Sem Cin
        testa(8'b00010010, 8'b00000001, 4'b0100, 0, 1,      8'b00100101, 0); // Com Cin
        testa(8'b10000000, 8'b00010000, 4'b0100, 0, 1,      8'b00000001, 1); // Com Cout

        // 6º Caso -  A OR B PLUS A AND NOT B PLUS CIN
        $display("6 Caso -  A OR B PLUS A AND NOT B PLUS CIN");
        testa(8'b00110110, 8'b11110000, 4'b0101, 0, 0,      8'b11111100, 0); // Sem Cin

        // 7º Caso - A MINUS B MINUS 1 + CIN
        $display("7 Caso - A - B - 1 + Cin");
        testa(8'b11000011, 8'b01000010, 4'b0110, 0, 0,      8'b10000000, 0);

        // 8º Caso - A AND (NOT B) MINUS 1 + CIN
        $display("8 Caso - A AND (NOT B) - 1 + Cin");
        testa(8'b00110011, 8'b00010001, 4'b0111, 0, 0,      8'b00010001, 0);
        
        // 9º Caso - A PLUS (A AND B) PLUS CIN
        $display("9 Caso - A + (A AND B) + Cin");
        testa(8'b01000010, 8'b00000010, 4'b1000, 0, 0,      8'b01000100, 0);

        // 10º Caso - A PLUS B PLUS CIN
        $display("10 Caso - A + B + Cin");
        testa(8'b00000011, 8'b11000000, 4'b1001, 0, 0,      8'b11000011, 0); // Sem Cin
        testa(8'b00000011, 8'b11000000, 4'b1001, 0, 1,      8'b11000100, 0); // Com Cin

        // 11º Caso - (A OR NOT B) PLUS A AND B PLUS CIN
        $display("11 Caso - (A OR NOT B) + (A AND B) + Cin");
        testa(8'b00010001, 8'b00000000, 4'b1010, 0, 0,      8'b11111111, 0); // Sem Cin
        testa(8'b00010001, 8'b00000000, 4'b1010, 0, 1,      8'b00000000, 1); // com Cin

        // 12º Caso - (A AND B) MINUS 1 + CIN
        $display("12 Caso - (A AND B) - 1 + Cin");
        testa(8'b11000011, 8'b11000011, 4'b1011, 0, 0,      8'b11000011, 0);

        // 13º Caso - A + A* + CIN
        // * - Cada bit é passado para a próxima posição mais significante
        $display("13 Caso - A + (A << 1) + Cin");
        testa(8'b11000011, 8'b00000001, 4'b1100, 0, 0,      8'b10000110, 1); // Sem Cin

        // 14º Caso - (A OR B PLUS A + CIN
        $display("14 Caso - A OR B PLUS A + CIN");
        testa(8'b01000010, 8'b01000010, 4'b1101, 0, 0,      8'b10000100, 1);

        // 15º Caso - A OR NOT B PLUS A + CIN
        $display("15 Caso - A OR NOT B PLUS A + CIN");
        testa(8'b11000011, 8'b11110000, 4'b1110, 0, 0,      8'b10010010, 1); // Sem Cin
        testa(8'b11000011, 8'b11110000, 4'b1110, 0, 1,      8'b10010011, 1); // Com Cin

        // 16º Caso - A - 1 + CIN
        $display("16 Caso - A - 1 + Cin");
        testa(8'b11000011, 8'b00000001, 4'b1111, 0, 0,      8'b11000010, 0);


        $display("#############################");
        $display("MODO LÓGICO");
        $display("#############################");

        m = 1; // modo lógico

        // 1 - NOT A
        $display("1 Caso - NOT A");
        testa(8'b01011010, 8'b00110011, 4'b0000, 1, 0,      8'b10100101, 0); // ~A

        // 2 - NOR
        $display("2 Caso - NOR");
        testa(8'b01011010, 8'b00110011, 4'b0001, 1, 0,      8'b10000100, 0); // ~(A | B)

        // 3 - NOT A AND B
        $display("3 Caso - NOT A AND B");
        testa(8'b01011010, 8'b00110011, 4'b0010, 1, 0,      8'b00100001, 0); // (~A) & B

        // 4 - ZERO
        $display("4 Caso - ZERO");
        testa(8'b01011010, 8'b00110011, 4'b0011, 1, 0,      8'b00000000, 0); // f = 0

        // 5 - NAND
        $display("5 Caso - NAND");
        testa(8'b01011010, 8'b00110011, 4'b0100, 1, 0,      8'b11101101, 0); // ~(A & B)

        // 6 - NOT B
        $display("6 Caso - NOT B");
        testa(8'b01011010, 8'b00110011, 4'b0101, 1, 0,      8'b11001100, 0); // ~B

        // 7 - XOR
        $display("7 Caso - XOR");
        testa(8'b01011010, 8'b00110011, 4'b0110, 1, 0,      8'b01101001, 0); // A ^ B

        // 8 - A AND NOT B
        $display("8 Caso - A AND NOT B");
        testa(8'b01011010, 8'b00110011, 4'b0111, 1, 0,      8'b01001000, 0); // A & (~B)

        // 9 - NOT A OR B
        $display("9 Caso - NOT A OR B");
        testa(8'b01011010, 8'b00110011, 4'b1000, 1, 0,      8'b10110111, 0); // (~A) | B

        // 10 - XNOR
        $display("10 Caso - XNOR");
        testa(8'b01011010, 8'b00110011, 4'b1001, 1, 0,      8'b10010110, 0); // ~(A ^ B)

        // 11 - B
        $display("11 Caso - B");
        testa(8'b01011010, 8'b00110011, 4'b1010, 1, 0,      8'b00110011, 0); // f = B

        // 12 - AND
        $display("12 Caso - AND");
        testa(8'b01011010, 8'b00110011, 4'b1011, 1, 0,      8'b00010010, 0); // A & B

        // 13 - TODOS OS BITS IGUAIS (11111111)
        $display("13 Caso - 11111111");
        testa(8'b01011010, 8'b00110011, 4'b1100, 1, 0,      8'b11111111, 0); // f = 1

        // 14 - A OR NOT B
        $display("14 Caso - A OR NOT B");
        testa(8'b01011010, 8'b00110011, 4'b1101, 1, 0,      8'b11011110, 0); // A | (~B)

        // 15 - OR
        $display("15 Caso - OR");
        testa(8'b01011010, 8'b00110011, 4'b1110, 1, 0,      8'b01111011, 0); // A | B

        // 16 - A
        $display("16 Caso - A");
        testa(8'b01011010, 8'b00110011, 4'b1111, 1, 0,      8'b01011010, 0); // f = A

        $display("Testes concluidos.");
        $finish;
    end

endmodule