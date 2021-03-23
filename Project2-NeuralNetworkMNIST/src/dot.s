.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:

    # Prologue
addi sp, sp, -44 # sp =sp1 -a1t2 sets stack
sw ra, 0(sp) #set return address
sw s2, 4(sp) 
sw s3, 8(sp)
sw s4, 12(sp)
sw s5, 16(sp)
sw s6, 20(sp)
sw s7, 24(sp)
sw s8, 28(sp)
sw s9, 32(sp)
sw s10, 36(sp)
sw s11, 40(sp)

li s2, 0 #sum so far
li s3, 0 #loop counter
mv s6, a3 #stride of v0
mv s7, a4 #stride of v1
mv s8, a2 #length of vectors
li s10, 5


li t4, 1
blt s8, t4, vector_short # if a2 < a then target
blt s6, t4, stride_short
blt s7, t4, stride_short
li t5, 4
#problem with the stride is here, worth changing before we run the matmul
mul s6, s6, t5
mul s7, s7, t5
mul s11, s6, s7
j loop_start #otherwise continue to main program

vector_short:
li a1, 5
jal exit2

loop_start:

lw s4, 0(a0) #load number from first vector
lw s5, 0(a1) #load number from second vector

mul t3, s4, s5 #multiply components together
add s2, s2, t3 #add to total sum

addi s3, s3, 1 #add one to the loop counter
add a0, a0, s6 #add stride length to first vector address
add a1, a1, s7 #add stride length to second vector address
bge s3, s8, loop_end # if number of iterations = length then exit
j loop_start

loop_end:
    mv s9, s2
    mv a0, s9
    
    # Epilogue
epilogue:
    lw ra, 0(sp)
    lw s2, 4(sp)  
    lw s3, 8(sp)
    lw s4, 12(sp)
    lw s5, 16(sp)
    lw s6, 20(sp)
    lw s7, 24(sp)
    lw s8, 28(sp)
    lw s9, 32(sp)
    lw s10, 36(sp)
    lw s11, 40(sp)
    addi sp, sp, 44 #pop stack
    ret
    #jr ra
    #addi a0, x0, 10 #ends the program in venus

stride_short:
li a1, 6
jal exit2