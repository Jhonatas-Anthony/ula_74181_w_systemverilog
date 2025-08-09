module ula_8bits (
    input  logic [7:0] a, b,       // Entradas de 8 bits
    input  logic [3:0] s,          // Seleção de operação
    input  logic       m,          // Modo: 0 = aritmético, 1 = lógico
    input  logic       c_in,       // Carry in geral
    output logic [7:0] f,          // Resultado
    output logic       c_out,      // Carry out geral
    output logic       a_eq_b      // A == B para 8 bits
);

    // Sinais internos para o carry entre as duas ULAs
    logic c_out_low, a_eq_b_low, a_eq_b_high;

    // ULA menos significativa (bits 3:0)
    module_ula_74181 ula_low (
        .a(a[3:0]),
        .b(b[3:0]),
        .s(s),
        .m(m),
        .c_in(c_in),
        .f(f[3:0]),
        .c_out(c_out_low),
        .a_eq_b(a_eq_b_low)
    );

    // ULA mais significativa (bits 7:4)
    module_ula_74181 ula_high (
        .a(a[7:4]),
        .b(b[7:4]),
        .s(s),
        .m(m),
        .c_in(c_out_low),
        .f(f[7:4]),
        .c_out(c_out),
        .a_eq_b(a_eq_b_high)
    );

    // Comparação de igualdade para 8 bits
    assign a_eq_b = a_eq_b_low & a_eq_b_high;

endmodule
