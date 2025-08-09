module tb_ula_74181_arit;

    logic [3:0] a, b, s;
    logic m, c_in;
    logic [3:0] f;
    logic a_eq_b, c_out;

    // Instancia a ULA
    module_ula_74181 dut (
                         .a(a), .b(b), .s(s),
                         .m(m), .c_in(c_in),
                         .f(f), .a_eq_b(a_eq_b),
                         .c_out(c_out)
                     );

    // Tarefa para teste
    task automatic testa(
            input [3:0] ta, tb, ts,
            input tm, tc_in,
            input [3:0] f_esperado,
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
                $display("ERRO: m=%0b s=%04b a=%02d b=%02d c_in=%0b -> f=%02d (esperado=%0d) c_out=%0b (esperado=%0b)",
                         m, s, a, b, c_in, f, f_esperado, c_out, c_out_esperado);
            end
            else begin
                $display("OK: m=%0b s=%04b a=%02d b=%02d c_in=%0b -> f=%02d c_out=%0b",
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
        //    a        b        s        m  c_in    f        c_out
        testa(4'b0101, 4'b0011, 4'b0000, 0, 0,      4'b0101, 0); // Sem Cin
        testa(4'b0101, 4'b0011, 4'b0000, 0, 1,      4'b0110, 0); // Com Cin
        testa(4'b1111, 4'b0011, 4'b0000, 0, 1,      4'b0000, 1); // com Cout

        // 2º Caso - (A OR B) PLUS CIN
        $display("2 Caso - A OR B + Cin");
        testa(4'b0101, 4'b0011, 4'b0001, 0, 0,      4'b0111, 0); // Sem Cin
        testa(4'b0101, 4'b0011, 4'b0001, 0, 1,      4'b1000, 0); // Com Cin

        // 3º Caso - (A OR NOT B) PLUS CIN
        $display("3 Caso - A OR NOT B + Cin");
        testa(4'b0001, 4'b1111, 4'b0010, 0, 0,      4'b0001, 0); // Sem Cin
        testa(4'b0001, 4'b1111, 4'b0010, 0, 1,      4'b0010, 0); // Com Cin
        testa(4'b0001, 4'b0000, 4'b0010, 0, 1,      4'b0000, 1); // Com Cout

        // 4º Caso - MINUS 1 + CIN
        $display("4 Caso - A - B - 1 + Cin");
        testa(4'b0000, 4'b0000, 4'b0110, 0, 0,      4'b1111, 1); // Sem Cin
        testa(4'b0000, 4'b0000, 4'b0110, 0, 1,      4'b0000, 0); // Sem Cin

        // 5º Caso - A PLUS A AND NOT B PLUS CIN
        $display("5 Caso - (A AND NOT B) - 1 + Cin");
        testa(4'b0001, 4'b0000, 4'b0100, 0, 0,      4'b0010, 0); // Sem Cin
        testa(4'b0001, 4'b0000, 4'b0100, 0, 1,      4'b0011, 0); // Sem Cin
        testa(4'b1111, 4'b0000, 4'b0100, 0, 1,      4'b1111, 1); // Com Cout

        // 6º Caso - A OR B PLUS A AND NOT B PLUS CIN
        $display("6 Caso - (A AND NOT B) - 1 + Cin");
        testa(4'b0001, 4'b0000, 4'b0101, 0, 0,      4'b0010, 0); // Sem Cin
        testa(4'b0011, 4'b0001, 4'b0101, 0, 1,      4'b0110, 0); // Sem Cin
        testa(4'b1111, 4'b0000, 4'b0101, 0, 1,      4'b1111, 1); // Com Cout

        // 7º Caso - A - B - 1 + CIN
        $display("7 Caso - (A AND NOT B) - 1 + Cin");
        testa(4'b0011, 4'b0001, 4'b0110, 0, 0,      4'b0001, 0); // Sem Cin
        testa(4'b0011, 4'b0001, 4'b0110, 0, 1,      4'b0010, 0); // com Cin
        testa(4'b0011, 4'b0100, 4'b0110, 0, 0,      4'b1110, 1); // A < B sem Cin
        testa(4'b0011, 4'b0100, 4'b0110, 0, 1,      4'b1111, 1); // A < B com Cin
        testa(4'b0001, 4'b0101, 4'b0110, 0, 1,      4'b1100, 1); // A < B sem Cin

        // 8º Caso - (A AND NOT B) - 1 + CIN
        $display("8 caso - (A AND NOT B) - 1 + Cin");
        testa(4'b0011, 4'b0001, 4'b0111, 0, 0,      4'b0001, 0); // Sem Cin
        testa(4'b0011, 4'b0001, 4'b0111, 0, 1,      4'b0010, 0); // com Cin

        // 9º Caso - A + A AND B + CIN
        $display("9 Caso - (A AND NOT B) - 1 + Cin");
        testa(4'b0011, 4'b0001, 4'b1000, 0, 0,      4'b0100, 0); // Sem Cin
        testa(4'b0011, 4'b0001, 4'b1000, 0, 1,      4'b0101, 0); // com Cin

        // 10º Caso - A + B + CIN
        $display("10 Caso - (A AND NOT B) - 1 + Cin");
        testa(4'b0011, 4'b0001, 4'b1001, 0, 0,      4'b0100, 0); // Sem Cin
        testa(4'b0011, 4'b0001, 4'b1001, 0, 1,      4'b0101, 0); // com Cin 

        // 11º Caso - A OR NOT B PLUS A AND B PLUS CIN
        $display("11 Caso - A OR NOT B PLUS A AND B PLUS CIN");
        testa(4'b0001, 4'b0000, 4'b1010, 0, 0,      4'b1111, 0); // Sem Cin
        testa(4'b0001, 4'b0000, 4'b1010, 0, 1,      4'b0000, 1); // com Cin

        // 12º Caso - A AND B - 1 + CIN
        $display("12 Caso - A AND B - 1 + CIN");
        testa(4'b0011, 4'b0001, 4'b1011, 0, 0,      4'b0000, 0); // Sem Cin
        testa(4'b0011, 4'b0001, 4'b1011, 0, 1,      4'b0001, 0); // com Cin

        // 13º Caso - (c_in === 0) ? A + A* : A + A + 1
        // * - Cada bit é passado para a p´roxima posição mais significante 
        $display("13 Caso - A AND B - 1 + CIN");
        testa(4'b0011, 4'b0001, 4'b1100, 0, 0,      4'b0110, 0); // Sem Cin
        testa(4'b0011, 4'b0001, 4'b1100, 0, 1,      4'b0111, 0); // com Cin

        // 14º Caso - A OR B PLUS A + CIN
        $display("14 Caso - A OR B PLUS A + CIN");
        testa(4'b0011, 4'b0001, 4'b1101, 0, 0,      4'b0110, 0); // Sem Cin
        testa(4'b0011, 4'b0001, 4'b1101, 0, 1,      4'b0111, 0); // com Cin

        // 15º Caso - A OR NOT B PLUS A + CIN
        $display("15 Caso - A OR NOT B PLUS A + CIN");
        testa(4'b0011, 4'b1101, 4'b1110, 0, 0,      4'b0110, 0); // Sem Cin
        testa(4'b0011, 4'b1110, 4'b1110, 0, 1,      4'b0111, 0); // com Cin

        // 16º Caso - A - 1 + CIN
        $display("16 Caso - A - 1 + CIN");
        testa(4'b0011, 4'b0001, 4'b1111, 0, 0,      4'b0010, 0); // Sem Cin
        testa(4'b0011, 4'b0001, 4'b1111, 0, 1,      4'b0011, 0); // com Cin

        $display("#############################");
        $display("MODO LOGICO");
        $display("#############################");

        m = 1; // modo lógico

        // 1 - NOT A
        $display("1 Caso - NOT A");
        testa(4'b0101, 4'b0011, 4'b0000, 1, 0, 4'b1010, 0);

        // 2 - NOR
        $display("2 Caso - NOR");
        testa(4'b0101, 4'b0011, 4'b0001, 1, 0, 4'b1000, 0);

        // 3 - NOT A AND B
        $display("3 Caso - NOT A AND B");
        testa(4'b0101, 4'b0011, 4'b0010, 1, 0, 4'b0010, 0);

        // 4 - ZERO
        $display("4 Caso - ZERO");
        testa(4'b0101, 4'b0011, 4'b0011, 1, 0, 4'b0000, 0);

        // 5 - NAND
        $display("5 Caso - NAND");
        testa(4'b0101, 4'b0011, 4'b0100, 1, 0, 4'b1110, 0);

        // 6 - NOT B
        $display("6 Caso - NOT B");
        testa(4'b0101, 4'b0011, 4'b0101, 1, 0, 4'b1100, 0);

        // 7 - XOR
        $display("7 Caso - XOR");
        testa(4'b0101, 4'b0011, 4'b0110, 1, 0, 4'b0110, 0);

        // 8 - A AND NOT B
        $display("8 Caso - A AND NOT B");
        testa(4'b0101, 4'b0011, 4'b0111, 1, 0, 4'b0100, 0);

        // 9 - NOT A OR B
        $display("9 Caso - NOT A OR B");
        testa(4'b0101, 4'b0011, 4'b1000, 1, 0, 4'b1011, 0);

        // 10 - XNOR
        $display("10 Caso - XNOR");
        testa(4'b0101, 4'b0011, 4'b1001, 1, 0, 4'b1001, 0);

        // 11 - B
        $display("11 Caso - B");
        testa(4'b0101, 4'b0011, 4'b1010, 1, 0, 4'b0011, 0);

        // 12 - AND
        $display("12 Caso - AND");
        testa(4'b0101, 4'b0011, 4'b1011, 1, 0, 4'b0001, 0);

        // 13 - TODOS OS BITS IGUAIS (1111)
        $display("13 Caso - 1111");
        testa(4'b0101, 4'b0011, 4'b1100, 1, 0, 4'b1111, 0);

        // 14 - A OR NOT B
        $display("14 Caso - A OR NOT B");
        testa(4'b0101, 4'b0011, 4'b1101, 1, 0, 4'b1101, 0);

        // 15 - OR
        $display("15 Caso - OR");
        testa(4'b0101, 4'b0011, 4'b1110, 1, 0, 4'b0111, 0);

        // 16 - A
        $display("16 Caso - A");
        testa(4'b0101, 4'b0011, 4'b1111, 1, 0, 4'b0101, 0);

        $display("Testes concluidos.");
        $finish;
    end

endmodule
