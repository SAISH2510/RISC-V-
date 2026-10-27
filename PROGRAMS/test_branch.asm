addi x1,x0,10
addi x2,x0,10

beq x1,x2,target

addi x3,x0,99
addi x4,x0,88

target:

addi x5,x0,55
add x6,x5,x1

loop:
beq x0,x0,loop
