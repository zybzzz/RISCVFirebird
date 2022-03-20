addi s0, zero, 1			# s0 forever 1 use for bne
addi s1, zero, 48			# ascii 48 - num 0
addi s2, zero, 58			# ascii 57 - num 9 this is 58
addi s3, zero, 66			# ascii 66 - B
begin: addi a1, zero, 0
lw t0, 1024(zero)
bne t0, s0, begin
# judge num or alpha
lw t0, 1025(zero)
blt t0, s1, alpha
bge t0, s2, alpha
# is num prepare argument
sub a0, t0, s1
num: ble a0, zero, sum_exit		#go to sum_exit if n <= 0
add a1, a1, a0			#add n to acc
addi a0, a0, -1			#subtract 1 from n
jal zero, num					#jump to sum, num is sum function
sum_exit: sw a1,1026(zero)			#return value acc
jal begin				#return to caller,may fix
alpha: add a1, a1, s3
sw a1,1026(zero)
jal begin
