.import ../../src/dot.s
.import ../../src/utils.s

# Set vector values for testing
.data
vector0: .word 1 2 3 4 5 6 7 8 9
vector1: .word 1 2 3 4 5 6 7 8 9
#vector1: .word 1 -1 2 -1 3 -1 4 -1 5 -1 6 -1 7 -1 8 -1 9 -1


.text
# main function for testing
main:
    # Load vector addresses into registers
    la s0 vector0
    la s1 vector1

    # Set vector attributes
    li s2 9 #length of vectors
    li s3 1 #stride of first vector
    li s4 1 #stride of second vector

    # mv a0 s0
    # li a1 1
    # mv a2 s2
    # jal print_int_array
    # mv a0 s1
    # jal print_int_array


    # Call dot function
    mv a0 s0
    mv a1 s1
    mv a2 s2
    mv a3 s3
    mv a4 s4
    jal ra dot

    # Print integer result
    mv a1 a0
    jal ra print_int

    # Print newline
    li a1 '\n'
    jal ra print_char

    # Exit
    jal exit
