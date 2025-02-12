// Xor.asm
// Compute x XOR y element-wise
// R0 = x
// R1 = y
// R2 = Result (x ⊕ y)

@R0
D=M
@R1
D=D|M      // TEMP1 = x OR y
@TEMP1
M=D

@R0
D=M
@R1
D=D&M      // TEMP2 = x AND y
@TEMP2
M=D

@TEMP2
D=M
D=!D       // TEMP3 = NOT (x AND y)
@TEMP3
M=D

@TEMP1
D=M
@TEMP3
D=D&M      // x XOR y = (x OR y) AND (NOT (x AND y))
@R2
M=D
