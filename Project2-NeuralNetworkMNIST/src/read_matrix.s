.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

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


    li s2, 0 # file descriptor integer
    li s3, 0 # size of array (rows by columns)
    li s4, 0 # int* pointer to matrix malloced
    li s5, 0 # int* pointer for read data (4 bytes)
    mv s6, a1 # int* pointer for number of rows 
    mv s7, a2 # int* pointer for number of columns
    li s8, 0 # iterator for loop count

    #File and Matrix Parameter Setup
    mv a1, a0
    li a2, 0
    jal ra fopen #open file in read mode
    mv s2, a0 # store unique file integer 
    li t1, -1
    beq s2, t1, open_wrong # if t0 == t1 then target

    mv a1, s2
    mv a2, s6
    li a3, 4
    jal ra fread
    mv s6, a2
    #Check Read for Errors
    li t1, 4
    mv t2, a0
    bne t2, t1, wrong_size # if t0 != t1 then target

    mv a1, s2
    mv a2, s7
    li a3, 4
    jal ra fread
    mv s7, a2
    li t1, 4
    mv t2, a0
    bne t2, t1, wrong_size # if t0 != t1 then target

    #Matrix Generation and Population
    lw t4, 0(s6)
    lw t5, 0(s7)
    mul s3, t4, t5 #find size of array to generate
    #addi s3, s3, 1
    li t1, 4
    mul t2, t1, s3 #4 * # of elements in array
    #addi t2, t2, 1
    mv a0, t2 #move to appropriate register
    jal ra malloc #malloc read_in array
    mv s4, a0 #move pointer to s4
    beq s4, x0, malloc_wrong

    mul s10, t2, t1
    addi s11, s10, -1
    #li a0, 4
    #jal ra malloc
    #mv s5, a0
    #beq s5, x0, malloc_wrong
    #addi s4, s4, -4
    li s5, 0 #loop iterator count
take_in:
    mv a1, s2 #setup for file reading; configure input
    mv a2, s4
    li a3, 4 #number of bytes to be read repeatedly
    jal ra fread

    mv t2, a0 # number of bytes actually read in t2
    li t1, 4 #compare to the 4 we want to have read
    bne t2, t1, wrong_size #if fread error

    addi s4, s4, 4 #traverse matrix for memory
    addi s5, s5, 1 #add one to iteration count
    beq s5, s3, end #if have reached maximum number of iterations
    jal take_in #rereun loop to scan in data

end:
    mv a1, s2 #file descriptor move
    jal ra fclose 
    mv t3, a0
    bne t3, x0, no_close #if fclose did not return 0, error

    li t4, 4
    mul t2, s3, t4
    sub s4, s4, t2

    addi s10, s11, 2

    #addi s3, s3, -1
    #addi s4, s4, -4
    

    mv a0, s4 # move int* pointer to array to desired output
    mv a1, s6 # set return # of rows to actual known #
    mv a2, s7 # set return # of columns to actual known #

    # Epilogue
    lw ra, 0(sp) #set return address
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
    addi sp, sp, 44 # sp =sp1 -a1t2 sets stack

    ret

malloc_wrong:
    li a1, 48
    jal exit2

open_wrong:
    li a1, 50
    jal exit2

wrong_size:
    li a1, 51
    jal exit2

no_close:
    li a1, 52
    jal exit2