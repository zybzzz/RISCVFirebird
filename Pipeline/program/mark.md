#### branch hazard test
fe730ae3  beq t1, t2, -6
00730a63  beq t1, t2, 10

#### 有关branch分支类型
在真正的risc-v 32里面，指令是不会被放在单数的地址上的，但是在我们设计的机子中，指令不可避免的被放到单数地址的rom中，因此要适当改变branch指令的立即数生成规则。

#### loop_test
fe539ee3 bne t2, t0, -2