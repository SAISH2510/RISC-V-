addi x1,x0,100
addi x2,x0,200

sw x1,0(x0)
sw x2,4(x0)

lw x3,0(x0)
lw x4,4(x0)

loop:
beq x0,x0,loop
