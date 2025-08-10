module ula_8bits (
    input  logic [7:0] a, b,       // Entradas de 8 bits
    input  logic [3:0] s,          // Seleção de operação
    input  logic       m,          // Modo: 0 = aritmético, 1 = lógico
    input  logic       c_in,       // Carry in geral
    input  logic       b_in,
    output logic [7:0] f,          // Resultado
    output logic       c_out,      // Carry out geral
    output logic       b_out,
    output logic       a_eq_b      // A == B para 8 bits
);

    // Sinais internos para o carry entre as duas ULAs
    logic c_out_low, a_eq_b_low, a_eq_b_high, b_out_low;
    logic c_in_high;

    assign low_is_zero = (a[3:0] == 4'b0000 && b[3:0] == 4'b0000);

    // ULA menos significativa (bits 3:0)
    module_ula_74181 ula_low (
        .a(a[3:0]),
        .b(b[3:0]),
        .s(s),
        .m(m),
        .c_in(c_in),
        .b_in(b_in),
        .f(f[3:0]),
        .c_out(c_out_low),
        .b_out(b_out_low),
        .a_eq_b(a_eq_b_low)
    );

    // Ajuste do c_in da parte alta
    // Ajuste do c_in da parte alta
    always_comb begin
        c_in_high = c_out_low;

        // Caso especial: MINUS 1 + CIN
        if (m == 0 && s == 4'b0011 && low_is_zero && c_in == 1)
            c_in_high = 1;
    end

    // ULA mais significativa (bits 7:4)
    module_ula_74181 ula_high (
        .a(a[7:4]),
        .b(b[7:4]),
        .s(s),
        .m(m),
        .c_in(c_in_high),
        .b_in(b_out_low),
        .f(f[7:4]),
        .c_out(c_out),
        .b_out(b_out),
        .a_eq_b(a_eq_b_high)
    );

    // Comparação de igualdade para 8 bits
    assign a_eq_b = a_eq_b_low & a_eq_b_high;

endmodule
