addi x10, zero, 4
jal x1, sum
addi t1, x12,0
jal exit









sum: ble x10, x0, sum_exit		#go to sum_exit if n <= 0
add x11, x11, x10			#add n to acc
addi x10, x10, -1			#subtract 1 from n
jal x0, sum					#jump to sum
sum_exit: addi x12, x11, 0			#return value acc
jalr x0, 0(x1)				#return to caller

exit: nop