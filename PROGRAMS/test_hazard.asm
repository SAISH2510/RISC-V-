addi x1,x0,40

sw x1,0(x0)

lw x2,0(x0)

add x3,x2,x1

add x4,x3,x2

loop:
beq x0,x0,loop
