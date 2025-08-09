module tb_ula_8bits;

    logic [7:0] a, b;
    logic [3:0] s;
    logic m, c_in;
    logic [7:0] f;
    logic c_out, a_eq_b;

    ula_8bits dut (
                  .a(a),
                  .b(b),
                  .s(s),
                  .m(m),
                  .c_in(c_in),
                  .f(f),
                  .c_out(c_out),
                  .a_eq_b(a_eq_b)
              );

    initial begin
        $dumpfile("ula_8bits.vcd");
        $dumpvars(0, tb_ula_8bits);

        // Cabeçalho
        // $display(" m |   s   |    a(bin)   a(dec) |    b(bin)   b(dec) | cin |    f(bin)   f(dec) | cout | a_eq_b");
        // $display("-----------------------------------------------------------------------------------------------");

        m = 0; // modo aritmético
        /* for (int ss = 0; ss < 16; ss++) begin
            s = ss[3:0]; */
            s=4'b0110;

            for (int aa = 0; aa < 256; aa += 51) begin  // passo maior p/ menos linhas
                for (int bb = 0; bb < 256; bb += 85) begin
                    for (int cc = 0; cc <= 1; cc++) begin
                        a = aa[7:0];
                        b = bb[7:0];
                        c_in = cc;
                        #1;
                        $display(" m |   s  |  abin  adec  |  bbin  bdec  | cin |  fbin  fdec  | cout | a_eq_b");
                        $display(" %1b | %04b | %08b %3d | %08b %3d |  %1b  | %08b %3d |  %1b   |   %1b",
                                 m, s, a, a, b, b, c_in, f, f, c_out, a_eq_b);
                    end
                end
            end
        /* end */

        $finish;
    end

endmodule
