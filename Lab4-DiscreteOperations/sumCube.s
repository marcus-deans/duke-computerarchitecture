.text 
.globl main
main:
    addi sp, sp, -12

    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)

    li s0, 1
    li s1, 2

    mv a0, s0
    mv a1, s1

    jal foo

    lw t0, 4(sp)
    lw t1, 8(sp)

    # mv t2, a0
    add t5, s0, s1; # t0 = t1 + t2
    add t5, t5, a0; # t0 = t1 + imm
    
    # addi a0, zero, 1
    li a0, 1
    mv a1, t5
    ecall

    j exit

exit:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
    jr ra
    # li a0, 0
    # jr ra
    # li a0, 10

    # ecall

foo:
    addi sp, sp, -8

    sw s0, 0(sp)
    sw s1, 4(sp)

    li s0, 0
    li s1, 0

    add a0, a0, a1
    
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    jr ra