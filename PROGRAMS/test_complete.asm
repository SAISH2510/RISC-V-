addi x1,x0,10
addi x2,x0,20
addi x3,x0,30

add x4,x1,x2
sub x5,x4,x1
and x6,x5,x2
or  x7,x6,x3
xor x8,x7,x1

sw x8,0(x0)

lw x9,0(x0)

add x10,x9,x2
add x11,x10,x3
add x12,x11,x4

beq x12,x12,label

addi x13,x0,111
addi x14,x0,222

label:

addi x15,x0,50

add x16,x15,x12

sub x17,x16,x1

and x18,x17,x2

or x19,x18,x3

xor x20,x19,x4

loop:

beq x0,x0,loop
