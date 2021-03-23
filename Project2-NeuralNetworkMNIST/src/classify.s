

.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

   li s7, 5
   bne s7, a0, args_exit

   mv s0, a1 #char argv in s0
   #addi sp, sp, -24 #push stack
    addi sp, sp, -68 #push stack
    sw ra, 24(sp)
    sw s1, 28(sp)
    sw s3, 32(sp)
    sw s4, 36(sp)
    sw s5, 40(sp)
    sw s6, 44(sp)
    sw s7, 48(sp)
    sw s8, 52(sp)
    sw s9, 56(sp)
    sw s10, 60(sp)
    sw s11, 64(sp)


	# =====================================
    # LOAD MATRICES
    # =====================================


    # Load pretrained m0
    
    lw a0, 4(s0)
    addi a1, sp, 0
    addi a2, sp, 4
    jal ra, read_matrix
    mv s1, a0 #store matrix 0 in s1





    # Load pretrained m1

    lw a0, 8(s0)
    addi a1, sp, 8
    addi a2, sp, 12
    jal ra, read_matrix
    mv s2, a0 #store matrix 1 in s2





    # Load input matrix

    lw a0, 12(s0)
    addi a1, sp, 16
    addi a2, sp, 20
    jal ra, read_matrix
    mv s3, a0 #store input matrix in s3




    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    
    # LINEAR LAYER
    
    lw s7, 0(sp)    # m0 row
    lw s8, 20(sp)   # input col
    mul s4, s7, s8
    slli a0, s4, 2  # left shift a0
    jal ra, malloc
    #beq a0, zero, malloc error?
    mv s5, a0

    mv a0, s1      # m0
    #addi a1, sp, 0
    lw a1, 0(sp)   # m0 num row
    #addi a2, sp, 4
    lw a2, 4(sp)   # m0 num col

    mv a3, s3      # input
    #addi a4, sp, 16
    lw a4, 16(sp)   # input num row
    #addi a5, sp, 20
    lw a5, 20(sp)   # input num col

    mv a6, s5       # output
    jal ra, matmul

    #NONLINEAR LAYER
    mv a0, s5
    mv a1, s4
    jal ra, relu

    #LINEAR LAYER m1 relu
    #addi s7, sp, 8
    lw s7, 8(sp)    # m1 row
    #addi s8, sp, 20
    lw s8, 20(sp)   # product col
    mul s4, s7, s8
    slli a0, s4, 2  #left shift a0
    jal ra, malloc
    #beq a0, zero malloc error?
    mv s6, a0

    mv a0, s2       # m1
    #addi a1, sp, 8
    lw a1, 8(sp)    # m1 num row
    #addi a2, sp, 12
    lw a2, 12(sp)   # m1 num col

    mv a3, s5
    #addi a4, sp, 0
    lw a4, 0(sp)    # product num row
    #addi a5, sp, 20    
    lw a5, 20(sp)   # product num col

    mv a6, s6       # output
    jal ra, matmul


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    
    #lw a0, 16(s0)   #pointer to output name
    addi a0, s0, 16
    mv a1, s6 #pointer to start of matrix
    addi a2, sp, 8
    #lw a2, 8(sp) #number of rows in out matrix
    addi a3, sp, 20
    #lw a3, 20(sp) #number of columns in out matrix
    jal ra, write_matrix




    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s6
    mv a1, s4
    jal ra, argmax
    mv s10, a0 #store argmax index in s10


    # Print classification
    mv a1, s10 #move index to be printed
    jal print_int
    



    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    lw ra, 24(sp)
    lw s1, 28(sp)
    lw s3, 32(sp)
    lw s4, 36(sp)
    lw s5, 40(sp)
    lw s6, 44(sp)
    lw s7, 48(sp)
    lw s8, 52(sp)
    lw s9, 56(sp)
    lw s10, 60(sp)
    lw s11, 64(sp)
    addi sp, sp, 68 #pop stack
    #addi sp, sp, 24 #pop stack
    jal exit
    #print_int
    #print_int_array
    ret

args_exit:
    li a1 49
    jal exit2



