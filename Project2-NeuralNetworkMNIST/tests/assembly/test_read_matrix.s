.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"

.text
main:
    # Read matrix into memory
    la s0, file_path

    li a0, 4 #create int* for row length
    jal malloc
    mv s1, a0

    li a0, 4 #create int* for column length
    jal malloc
    mv s2, a0

    mv a0, s0 #move into argument registers and call readmatrix
    mv a1, s1
    mv a2, s2
    jal read_matrix
    mv s3, a0 #move output int* to matrix into s3

    # Print out elements of matrix
    mv a0 s3
    lw a1 0(s1)
    lw a2 0(s2)
    jal print_int_array

    # Terminate the program

    jal exit