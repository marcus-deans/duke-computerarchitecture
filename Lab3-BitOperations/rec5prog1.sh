.text 
.globl main
main:
    addi sp, sp, -4
    sw ra, 0(sp)

    li a0, 1
    li a1, 2

    jal foo