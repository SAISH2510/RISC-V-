addi x1,x0,8
addi x2,x0,4

add x3,x1,x2
sub x4,x1,x2
and x5,x1,x2
or  x6,x1,x2
xor x7,x1,x2
sll x8,x2,x1
srl x9,x1,x2
slt x10,x2,x1

loop:
beq x0,x0,loop
