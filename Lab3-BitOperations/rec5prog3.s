.text 
.globl main
main:
    addi sp, sp, -12
    sw ra, 0(sp)

    li t0, 1
    li t1, 2

    sw t0, 4(sp)
    sw t1, 8(sp)

    mv a0, t0
    mv a1, t1

    jal foo

    lw t0, 4(sp)
    lw t1, 8(sp)

    # mv t2, a0
    add t5, t0, t1; # t0 = t1 + t2
    add t5, t5, a0; # t0 = t1 + imm
    
    # addi a0, zero, 1
    li a0, 1
    mv a1, t5
    ecall

    j exit

exit:
    lw ra, 0(sp)
    addi sp, sp, 12
    jr ra
    # li a0, 0
    # jr ra
    # li a0, 10

    # ecall

foo:
    add a0, a0, a1
    jr ra