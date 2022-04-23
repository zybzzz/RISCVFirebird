#fibonaci
addi s0, zero, 1
addi s1, zero, 48
addi s4, zero, 10	# use for print
begin: addi s2, zero, 0
addi s3, zero, 1
stat: nop
lw t0, 1024(zero)
bne t0, s0, stat
lw t0, 1025(zero)
sub t0, t0, s1
num: beq t0, zero, num_exit
addi t0, t0, -1
add t2, s2, s3
addi s2, s3, 0
addi s3, t2, 0
jal zero, num
num_exit: addi s9, zero, 0	#base pointer
addi s10, zero, 0		#change pointer
b_loop: beq s3, zero, print
rem t2, s3, s4
div s3, s3, s4
sw t2, (s10)
addi s10, s10, 1
jal zero, b_loop
print: addi t2, zero, 13
sw t2, 1026(zero)
p_loop: beq s10, s9, print_exit
addi s10, s10, -1
lw t2,(s10)
add t2, t2, s1 
sw t2, 1026(zero)
jal zero, p_loop
print_exit: addi t2, zero, 13
sw t2, 1026(zero)
jal zero, begin