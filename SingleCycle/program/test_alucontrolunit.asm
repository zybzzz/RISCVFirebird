#this program is test for single cycle alu control unit
begin:lw t1, (t2)
sw t1, (t2)
bne t1, t2, begin
add t1, t2, t3
sub t1, t2, t3
and t1, t2, t3
or t1, t2, t3