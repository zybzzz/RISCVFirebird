addi t0, zero, 4
label: add t1, t1, t2
addi t2, t2, 1
bne t2, t0, label		#last bne will flush pipeline
nop
add t1, t1, zero