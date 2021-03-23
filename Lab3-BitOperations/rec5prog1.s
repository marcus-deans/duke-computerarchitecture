.text 
.globl main
main:
    addi sp, sp, -4
    sw ra, 0(sp)

    li a0, 1
    li a1, 2

    jal foo

    mv t1, a0
    addi a0, zero, 1
    mv a1, t1
    ecall

    j exit

exit:
    lw ra, 0(sp)
    addi sp, sp, 4
    li a0, 0
    jr ra
    li a0, 10

    ecall

foo:
    add a0, a0, a1
    jr ra