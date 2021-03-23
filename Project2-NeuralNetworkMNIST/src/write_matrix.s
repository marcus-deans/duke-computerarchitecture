.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

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
    li s3, 0 # number of elements in matrix (rows * columns)
    li s4, 0 # pointer for row and column size memory
    li s5, 0 # int* pointer for read data (4 bytes)
    mv s6, a1 # int* pointer to start of matrix in memory
    mv s7, a2 # int of number of rows
    mv s8, a3 # int of number of columns
    li s9, 0 # iterator for loop count
    li s11, 30

    #File and Matrix Parameter Setup
    mv a1, a0
    li a2, 1
    jal ra fopen #open file in write mode
    mv s2, a0 # store unique file integer 
    li t1, -1
    beq s2, t1, open_wrong # if t0 == t1 then target

    #WRITE ROW AND COLUMN LENGTH
    li a0, 4 #create int* for column length
    li s4, 0 #clear previous 
    jal malloc
    mv s4, a0
    sw s7, 0(s4)

    li t1, 2
    mul s9, s11, t1
    addi s10, s11, 14

    mv a1, s2 #file descriptor of file to write to
    mv a2, s4 #point to buffer of file to write; number of rows
    li a3, 1 # number of elements to write
    li a4, 4 # size of each buffer element in bytes (int)
    jal ra fwrite
    #Check Read for Errors
    li t1, 1 #comparison for number of elements written
    mv t2, a0
    bne t2, t1, write_wrong # if t0 != t1 then target

    li a0, 4 #create int* for column length
    li s4, 0 #clear previous 
    jal malloc
    mv s4, a0
    sw s8, 0(s4)

    mv a1, s2 #file desciptor of file to write to
    mv a2, s4 #point to buffer of file to write; number of colujmns
    li a3, 1 #number of elements to write
    li a4, 4 # size of each buffer element in bytes (int)
    jal ra fwrite
    li t1, 1 #comparison for number of elements written
    mv t2, a0
    bne t2, t1, write_wrong # if t0 != t1 then target


###########################################################################################
#Matrix Generation and Population
    mul s3, s7, s8 #number of elements within matrix calculation
    li s5, 0 #loop iterator count

take_in:
    mv a1, s2 #setup for file reading; configure input
    mv a2, s6 #buffer of file to write from; current matrix in row-major
    li a3, 1 #number of elements to write
    li a4, 4 #size of each buffer element in bytes (int)
    jal ra fwrite

    mv t2, a0 # number of elements actually written
    li t1, 1 #compare to the 1 we want to have written
    bne t2, t1, write_wrong #if fread error

    addi s6, s6, 4 #traverse matrix for memory
    addi s5, s5, 1 #add one to iteration count
    beq s5, s3, end #if have reached maximum number of iterations
    jal take_in #rereun loop to scan in data
########################################################################################################

end:
    # Epilogue
    mv a1, s2 #file descriptor move
    jal ra fclose 
    mv t3, a0
    bne t3, x0, no_close #if fclose did not return 0, error

    li s11, 23
    #li t4, 4
    #addi s3, s3, -1
    #mul t2, s3, t4
    #sub s6, s6, t2

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

open_wrong:
    li a1, 53
    jal exit2

write_wrong:
    li a1, 55
    jal exit2

no_close:
    li a1, 55
    jal exit2