# =============================================================================
#  raiz2.asm - calculo de sqrt(2) * pi em ponto flutuante
#  MIPS32 + coprocessador 1 - MARS 4.5
#  UTFPR / Arquitetura de Computadores
#
#  Etapa 1: sqrt(2) por Newton-Raphson (babilonico) sobre f(x) = x^2 - 2:
#      x(k+1) = x(k) - f(x(k))/f'(x(k)) = 0.5 * ( x(k) + 2/x(k) )
#  Etapa 2: multiplicacao do resultado por pi -> sqrt(2) * pi
#
#  Tudo roda em precisao dupla (.double, 64 bits). A raiz e conferida com a
#  instrucao sqrt.d do proprio hardware e o produto final e convertido para
#  precisao simples, para mostrar campo a campo o formato IEEE 754.
#
#  Registradores do coprocessador 1 usados (pares, sempre indice par):
#      $f2  = x        (aproximacao corrente da raiz)
#      $f4  = N = 2.0  (radicando)
#      $f6  = 0.5      (constante da media)
#      $f8  = epsilon  (tolerancia)
#      $f12 = argumento dos syscalls 2 e 3 (imprimir float/double)
#      $f26 = pi
#      $f28 = produto sqrt(2) * pi
#      $f16, $f18, $f20, $f22, $f24 = temporarios
# =============================================================================

        .data
        .align 3
d_um:        .double 1.0            # chute inicial x0
d_dois:      .double 2.0            # radicando N
d_meio:      .double 0.5            # fator da media aritmetica
d_eps:       .double 1.0e-15        # tolerancia do criterio de parada
d_pi:        .double 3.141592653589793   # pi em precisao dupla

msg_cab:     .asciiz "=== sqrt(2) * pi em ponto flutuante - Newton-Raphson (IEEE 754) ===\n\n"
msg_it:      .asciiz "iteracao "
msg_sep:     .asciiz ":  x = "
msg_err:     .asciiz "   |x^2 - 2| = "
msg_conv:    .asciiz "\nConvergiu em "
msg_iters:   .asciiz " iteracoes.\n\n"
msg_newton:  .asciiz "Newton-Raphson (double) = "
msg_sqrt:    .asciiz "sqrt.d do hardware      = "
msg_dif:     .asciiz "diferenca absoluta      = "
msg_prod:    .asciiz "\n--- Produto final ---\n"
msg_pi:      .asciiz "pi                      = "
msg_res:     .asciiz "sqrt(2) * pi            = "
msg_simples: .asciiz "\n--- Produto em IEEE 754 de precisao simples (32 bits) ---\n"
msg_valor:   .asciiz "valor (float)  = "
msg_hex:     .asciiz "hexadecimal    = "
msg_bin:     .asciiz "binario        = "
msg_sinal:   .asciiz "sinal          = "
msg_expr:    .asciiz "expoente bruto = "
msg_expv:    .asciiz "   expoente real (bruto - 127) = "
msg_mant:    .asciiz "mantissa bruta = "
msg_leg:     .asciiz "                 s  eeeeeeee  mmmmmmmmmmmmmmmmmmmmmmm\n"
esp:         .asciiz "  "
nl:          .asciiz "\n"

        .text
        .globl main

main:
        li      $v0, 4
        la      $a0, msg_cab
        syscall

        l.d     $f4, d_dois            # N   = 2.0
        l.d     $f2, d_um              # x0  = 1.0
        l.d     $f6, d_meio            # 0.5
        l.d     $f8, d_eps             # epsilon
        li      $t0, 0                 # k = 0 (contador de iteracoes)
        li      $t1, 50                # teto de seguranca

# ----------------------------------------------------------------- laco
loop:
        mul.d   $f16, $f2, $f2         # x^2
        sub.d   $f16, $f16, $f4        # x^2 - N
        abs.d   $f16, $f16             # erro = |x^2 - N|

        li      $v0, 4                 # "iteracao "
        la      $a0, msg_it
        syscall
        li      $v0, 1                 # k
        move    $a0, $t0
        syscall
        li      $v0, 4                 # ":  x = "
        la      $a0, msg_sep
        syscall
        li      $v0, 3                 # imprime x (double)
        mov.d   $f12, $f2
        syscall
        li      $v0, 4                 # "   |x^2 - 2| = "
        la      $a0, msg_err
        syscall
        li      $v0, 3                 # imprime o erro
        mov.d   $f12, $f16
        syscall
        li      $v0, 4
        la      $a0, nl
        syscall

        c.lt.d  $f16, $f8              # erro < epsilon ?
        bc1t    convergiu
        beq     $t0, $t1, convergiu    # trava de seguranca

        div.d   $f18, $f4, $f2         # N / x
        add.d   $f18, $f2, $f18        # x + N/x
        mul.d   $f2,  $f18, $f6        # x = 0.5 * (x + N/x)
        addi    $t0, $t0, 1
        j       loop

# ------------------------------------------------- comparacao com o hardware
convergiu:
        li      $v0, 4
        la      $a0, msg_conv
        syscall
        li      $v0, 1
        move    $a0, $t0
        syscall
        li      $v0, 4
        la      $a0, msg_iters
        syscall

        li      $v0, 4
        la      $a0, msg_newton
        syscall
        li      $v0, 3
        mov.d   $f12, $f2
        syscall
        li      $v0, 4
        la      $a0, nl
        syscall

        sqrt.d  $f20, $f4              # raiz calculada pela FPU
        li      $v0, 4
        la      $a0, msg_sqrt
        syscall
        li      $v0, 3
        mov.d   $f12, $f20
        syscall
        li      $v0, 4
        la      $a0, nl
        syscall

        sub.d   $f22, $f2, $f20        # diferenca entre os dois metodos
        abs.d   $f22, $f22
        li      $v0, 4
        la      $a0, msg_dif
        syscall
        li      $v0, 3
        mov.d   $f12, $f22
        syscall
        li      $v0, 4
        la      $a0, nl
        syscall

# --------------------------------------------- etapa 2: multiplicacao por pi
        li      $v0, 4
        la      $a0, msg_prod
        syscall

        l.d     $f26, d_pi             # pi
        mul.d   $f28, $f2, $f26        # produto = sqrt(2) * pi

        li      $v0, 4
        la      $a0, msg_pi
        syscall
        li      $v0, 3
        mov.d   $f12, $f26
        syscall
        li      $v0, 4
        la      $a0, nl
        syscall

        li      $v0, 4
        la      $a0, msg_res
        syscall
        li      $v0, 3
        mov.d   $f12, $f28
        syscall
        li      $v0, 4
        la      $a0, nl
        syscall

# ------------------------------------------- dissecando o IEEE 754 simples
        li      $v0, 4
        la      $a0, msg_simples
        syscall

        cvt.s.d $f24, $f28             # double -> float (arredonda p/ 24 bits)
        mfc1    $t2, $f24              # $t2 = padrao de bits do float

        li      $v0, 4                 # valor em float
        la      $a0, msg_valor
        syscall
        li      $v0, 2
        mov.s   $f12, $f24
        syscall
        li      $v0, 4
        la      $a0, nl
        syscall

        li      $v0, 4                 # hexadecimal dos 32 bits
        la      $a0, msg_hex
        syscall
        li      $v0, 34
        move    $a0, $t2
        syscall
        li      $v0, 4
        la      $a0, nl
        syscall

        li      $v0, 4                 # binario separado por campos
        la      $a0, msg_bin
        syscall
        move    $a1, $t2               # sinal: bit 31
        li      $a2, 31
        li      $a3, 1
        jal     imprime_bits
        li      $v0, 4
        la      $a0, esp
        syscall
        move    $a1, $t2               # expoente: bits 30..23
        li      $a2, 30
        li      $a3, 8
        jal     imprime_bits
        li      $v0, 4
        la      $a0, esp
        syscall
        move    $a1, $t2               # mantissa: bits 22..0
        li      $a2, 22
        li      $a3, 23
        jal     imprime_bits
        li      $v0, 4
        la      $a0, nl
        syscall
        li      $v0, 4
        la      $a0, msg_leg
        syscall

        srl     $t3, $t2, 31           # sinal
        srl     $t4, $t2, 23           # expoente bruto
        andi    $t4, $t4, 0xFF
        li      $t5, 0x7FFFFF          # mantissa bruta
        and     $t5, $t2, $t5

        li      $v0, 4
        la      $a0, msg_sinal
        syscall
        li      $v0, 1
        move    $a0, $t3
        syscall
        li      $v0, 4
        la      $a0, nl
        syscall

        li      $v0, 4
        la      $a0, msg_expr
        syscall
        li      $v0, 1
        move    $a0, $t4
        syscall
        li      $v0, 4
        la      $a0, msg_expv
        syscall
        li      $v0, 1
        addi    $a0, $t4, -127
        syscall
        li      $v0, 4
        la      $a0, nl
        syscall

        li      $v0, 4
        la      $a0, msg_mant
        syscall
        li      $v0, 1
        move    $a0, $t5
        syscall
        li      $v0, 4
        la      $a0, nl
        syscall

        li      $v0, 10                # encerra
        syscall

# -----------------------------------------------------------------------------
#  imprime_bits - escreve na saida os bits de um valor inteiro
#      $a1 = valor
#      $a2 = posicao do bit mais significativo a imprimir (0..31)
#      $a3 = quantidade de bits
#  usa $t6..$t9, nao preserva $a0/$v0
# -----------------------------------------------------------------------------
imprime_bits:
        move    $t6, $a1               # valor
        move    $t7, $a2               # posicao corrente
        move    $t8, $a3               # bits restantes
pb_loop:
        blez    $t8, pb_fim
        srlv    $t9, $t6, $t7          # desloca o bit desejado p/ a posicao 0
        andi    $t9, $t9, 1
        addi    $a0, $t9, 48           # '0' = 48, '1' = 49
        li      $v0, 11                # imprime caractere
        syscall
        addi    $t7, $t7, -1
        addi    $t8, $t8, -1
        j       pb_loop
pb_fim:
        jr      $ra
