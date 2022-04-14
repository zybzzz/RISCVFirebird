iverilog -I /Users/zhangyibo/riscvdesign/RISCVFirebird/Pipeline/rtl -o tb_ctrlunit ./tb_ctrlunit.v #compile
vvp -n tb_ctrlunit -lxt2  #generate wave file