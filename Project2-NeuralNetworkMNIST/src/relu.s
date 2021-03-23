.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Set every negative value = 0
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
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


li s4, 0 #set array incrementer to 0
mv s5, a1 # copy over length of vector

li s6, 1
blt a1, s6, length_short # if t0 < t1 then target
j loop_start

length_short:
li a1, 8
jal exit2

li s8, 4
li s11, 5
mul s9, s8, s11

li s4, 0
loop_start:

lw s3, 0(a0) #load number from vector
blt s3, x0, loop_continue # if the number if negative, make 0

addi s4, s4, 1 #increment array incrementer by 1
addi a0, a0, 4 #traverse stack

beq s4, s5, loop_end # if number of iterations = length then break
j loop_start #repeat loop

loop_continue:

sw x0, 0(a0) #set a[t2] = 0 bc negative number
addi s4, s4, 1 #increment array incrementer by 1
bge s4, s5, loop_end # if number of iterations = length then break
addi a0, a0, 4 #traverse stack
j loop_start #repeat loop

loop_end:

    # Epilogue
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

    addi a0, x0, 10 #ends the program in venus
    
	ret #pseudo for ja ra