// Xor.asm - Compute z = x ⊕ y (element-wise XOR)
// x is in R0, y is in R1; result is stored in R2.
// This program uses the identity: x ⊕ y = (x & ~y) | (~x & y)
// R3 is used as a temporary register.
// Note: R0 and R1 are preserved.

    // Compute (x & ~y)
    @R1
    D=M         // D = y
    D=!D        // D = ~y
    @R3
    M=D         // R3 = ~y
    @R0
    D=M         // D = x
    @R3
    D=D&M       // D = x & (~y)
    @R2
    M=D         // R2 = (x & ~y)

    // Compute (~x & y)
    @R0
    D=M         // D = x
    D=!D        // D = ~x
    @R3
    M=D         // R3 = ~x
    @R1
    D=M         // D = y
    @R3
    D=D&M       

    
    @R2
    D=D|M     
    @R2
    M=D         