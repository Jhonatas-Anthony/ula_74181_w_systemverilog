module tb_ula_74181;

    logic [3:0] a, b, s;
    logic m, c_in;
    logic [3:0] f;
    logic a_eq_b, c_out;

    module_ula_74181 dut (.a(a), .b(b), .s(s), .m(m), .c_in(c_in), .f(f), .a_eq_b(a_eq_b), .c_out(c_out));

    initial begin
        $dumpfile("ula_74181.vcd");
        $dumpvars(0, tb_ula_74181);

        m = 0;
        for (int ss = 0; ss < 16; ss++) begin
            s = ss[3:0];

            // s = 4'b1100;
            for (int aa = 0; aa < 16; aa++) begin
                for (int bb = 0; bb < 16; bb++) begin
                    for (int cc = 0; cc <= 1; cc++) begin
                        a = aa[3:0];
                        b = bb[3:0];
                        c_in = cc;
                        #1;
                        $display(" m |   s  |   a  |   b  | cin |   f  | cout | a_eq_b ");
                        $display(" %1b | %04b | %04b | %04b |  %1b  | %04b |  %1b   |   %1b",
                                 m, s, a, b, c_in, f, c_out, a_eq_b);
                    end
                end
            end
        end

        $finish;
    end

endmodule
