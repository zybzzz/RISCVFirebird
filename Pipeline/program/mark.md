#### branch hazard test
fe730ae3  beq t1, t2, -6
00730a63  beq t1, t2, 10

#### 有关branch分支类型
在真正的risc-v 32里面，指令是不会被放在单数的地址上的，但是在我们设计的机子中，指令不可避免的被放到单数地址的rom中，因此要适当改变branch指令的立即数生成规则。

#### loop_test
fe539ee3 bne t2, t0, -2

#### keyboard test
``` shell
00100413  #addi s0, zero, 1
03000493  #addi s1, zero, 48
03a00913  #addi s2, zero, 58
04200993  #addi s3, zero, 66
00000593  #begin: addi a1, zero, 0
40002283  #lw t0, 1024(zero)
fe829ee3  #bne t0, s0, -2
40102283  #lw t0, 1025(zero)
0092ca63  #blt t0, s1, +10
0122d963  #bge t0, s2, +9
40928533  #sub a0, t0, s1
00a05463  #num: ble a0, zero, sum_exi  
00a585b3  #add a1, a1, a0
fff50513  #addi a0, a0, -1
ffbff06f  #jal zero, num
009585b3  #sum_exit:add a1, a1, s1
40b02123  #sw a1,1026(zero)
fe7ff06f  #jal zero, begin(-13)
00d00593  #alpha: addi a1, zero, 13
40b02123  #sw a1,1026(zero)
05200593  #R
40b02123
04900593  #I
40b02123
05300593  #S
40b02123
04300593  #C
40b02123
02d00593  #-
40b02123
05600593  #V
40b02123
00d00593  #huiche
40b02123
fc5ff06f  #jal zero, begin(-30)
```

### febonaci
``` shell
00100413  #addi s0, zero, 1
03000493  #addi s1, zero, 48
00a00a13  #addi s4, zero, 10	# use for print
00000913  #begin: addi s2, zero, 0
00100993  #addi s3, zero, 1
00000013  #stat: nop
40002283  #lw t0, 1024(zero)
fe829ee3  #bne t0, s0, stat
40102283  #lw t0, 1025(zero)
409282b3  #sub t0, t0, s1
00028663  #num: beq t0, zero, num_exit
fff28293  #addi t0, t0, -1
013903b3  #add t2, s2, s3
00098913  #addi s2, s3, 0
00038993  #addi s3, t2, 0
ff7ff06f  #jal zero, num
00000c93  #num_exit: addi s9, zero, 0	#base pointer
00000d13  #addi s10, zero, 0		#change pointer
00090663  #b_loop: beq s2, zero, print
034963b3  #rem t2, s2, s4
03494933  #div s2, s2, s4
007d2023  #sw t2, (s10)
001d0d13  #addi s10, s10, 1
ff7ff06f  #jal zero, b_loop
00d00393  #print: addi t2, zero, 13
40702123  #sw t2, 1026(zero)
019d0663  #p_loop: beq s10, s9, print_exit
fffd0d13  #addi s10, s10, -1
000d2383  #lw t2,(s10)
009383b3  #add t2, t2, s1
40702123  #sw t2, 1026(zero)
ff7ff06f  #jal zero, p_loop
00d00393  #print_exit: addi t2, zero, 13
40702123  #sw t2, 1026(zero)
fc3ff06f  #jal zero, begin
```