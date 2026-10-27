addi x1,x0,10
addi x2,x0,20

add x3,x1,x2
add x4,x3,x1
add x5,x4,x2
add x6,x5,x3

loop:
beq x0,x0,loop
