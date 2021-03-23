.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue
addi sp, sp, -20 # sp =sp1 -a1t2 sets stack
sw ra, 0(sp) #set return address
sw s1, 4(sp) 
sw s2, 8(sp)
sw s3, 12(sp)
sw s4, 16(sp)
#mv a0, zero #xit code = 0

addi t0, x0, 0 # t0 x0 0
mv s1, a1 # size of register
li s2, 0 #loop counter
li s3, 0 #current largest number
li s4, 0 #address holder for a0
li t4, 0

li t2, 1
blt a1, t2, length_short # if t0 < t1 then target
j loop_start

length_short:
li a1, 7
jal exit2


loop_start:

lw t1, 0(a0) #load number from stack
bgt t1, s3, loop_continue #if current number > prior larger number
addi s2, s2, 1 #add one to the loop counter
addi a0, a0, 4 #traverse through stack
bge s2, s1, loop_end # if number of iterations = length then exit
j loop_start #repeat loop

loop_continue:
#mv s4, a0 #save address of current value (which is the largest)
mv s3, t1
mv s4, s2
#mv t4, a0
addi s2, s2, 1 #add one to the loop counter
beq s2, s1, loop_end # if number of iterations = length then exit
addi a0, a0, 4 #traverse through stack
j loop_start #continue loop

loop_end:
    mv a0, s4 # a0= s4
    #mv a0, t4 #a0 = t4

    # Epilogue
    lw ra, 0(sp)
    lw s1, 4(sp) # 
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    addi sp, sp, 20 #pop stack
    #addi a0, x0, 10 #ends the program in venus
    
    ret