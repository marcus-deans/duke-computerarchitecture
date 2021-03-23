.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    li t4, 1
    blt a1, t4, first_off # if row # < 1 then error code
    blt a2, t4, first_off # if column # < 1 then error code
    blt a4, t4, second_off #if row # < 1 then error code
    blt a5, t4, second_off # if column # < 1 then error code

    #mul t5, a1, a2
    #mul t2, a4, a5
    bne a2, a4, dim_off # if t0 != t1 then target
    
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

    li s2, 0 # m0 row counter
    li s3, 0 # m1 column counter
    li s4, 0 # m0 internal counter
    mv s5, a6 # m1 internal counter
    mv s6, a0 #pointer to start of m0
    mv s7, a1 # number of rows (height) of m0
    mv s8, a2 # number of columns (length) of m0
    mv s9, a3 # pointer to start of m1
    mv s10, a4 # 	a4 (int)   is the # of rows (height) of m1
    mv s11, a5 #	a5 (int)   is the # of columns (width) of m1
    li t4, 4 #use 4 for number of bytes in integer in future

li s2, 0 #counter for row iterations
outer_loop_start:
#but remember to star
li s3, 0 #counter for number of columns created
beq s2, s7, outer_loop_end #check it hasnt reached the end of the row
addi s2, s2, 1
jal ra inner_loop_start
#jal ra outer_loop_start #repeat for new row

inner_loop_start:
#CREATE COLUMN VECTOR
#malloc new vector; iterate by # of columns in m1; store ith index from outer loop
#malloc will have size in bytes of 4*row_number
#mul t1, t4, s10
#mv a0, t1
#jal ra malloc
#mv s1, a0 #store pointer for NEW COLUMN VECTOR

#mv s4, s9 #start internal counter at current s9
#li t3, 0 #loop iterator counter

#column_build:
#lw t1, 0(s9) #get value from m1
#sw t1, 0(s1) #store value in new column vector
#addi s1, s1, 4 #iterate by one byte in new column vector
##mul t2, t4, s11 # store 4*column length as length to interate by
#add s4, s4, t2 #iterate m1 by one row
#addi t3, t3, 1 #iterate loop by one
#bne t3, s10, column_build #if we haven't reached last row, then repeat

addi s3, s3, 1 #add one to column traversal counter

#mv a4, x0 #actual stride of m1

mv a0, s6 #load first array pointer into a0
mv a1, s9 #pointer of new column vector into a1 
mv a2, s8 #set vector length = number of columns in m0
li a3, 1 #stride of m0 always 1 as row vector
mv a4, s11 #stride of m1 is the number of columns

jal ra dot #calculate dot product for this row and column
mv s4, a0
sw s4, 0(s5) #move dot product result into matmul product
addi s5, s5, 4 #move one index along dot product (d) matrix
addi s9, s9, 4 #move along m1 by 4
bge s3, s11, inner_loop_end #if reached last column then break
jal ra inner_loop_start #otherwise compute next column dot product

inner_loop_end:
li t4, 4
mul t1, t4, s8
add s6, s6, t1 #move along row vector by 4 * column number
mul t2, t4, s11
sub s9, s9, t2
jal ra outer_loop_start

outer_loop_end:
#can just move epilogue code here as when this ends, the whole matrix is populated

    # Epilogue
#epilogue: #reset values
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
    addi sp, sp, 44 #pop stack
    
    ret

first_off:
    li a1, 2
    jal exit2

second_off:
    li a1, 3
    jal exit2

dim_off:
    li a1, 4
    jal exit2