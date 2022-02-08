# RISCVFirebird
Firebird 是一个 RISC-V 架构的 CPU

仿真工具Digital：https://github.com/hneemann/Digital


## 目录结构
``` bash
.
├── AssemblyLine    # 五段流水线实现的火鸟CPU
├── Digital.jar     # Digital仿真工具 github:Digital
├── LICENSE         
├── README.md       
├── SingleCycle     #单周期实现的火鸟CPU
├── examples        #示例由原作者给出
├── icon.svg    
└── lib             #全局库

```

## 单周期实现
单周期作为 CPU 设计的入门实验，单周期的处理器仅仅实现了 ld st beq add sub or and 指令。
经过仿真的测试，ld st add 指令都能得到正确的执行，相关组件的问题都进行了一定的修复。

## 单周期实现仍然存在的问题
1. 分支跳转 beq 仍然没有进行测试
2. 存储器的编址和寻址问题仍然需要解决