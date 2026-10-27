addi x1,x0,25
andi x2,x1,15
ori  x3,x1,3
xori x4,x1,5
slti x5,x1,30
slli x6,x1,1
srli x7,x1,2

loop:
beq x0,x0,loop
