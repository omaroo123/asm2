// AbsoluteValue.asm
// Compute absolute value |x|
// R0 = x (input)
// R1 = |x| (output)
// R2 = 1 if input was negative, 0 otherwise
// R3 = 1 if |x| cannot be computed, 0 otherwise

// Load x into D
@R0
D=M

// If x is positive or zero, store it directly in R1 and set flags to 0
@POSITIVE_CASE
D;JGE    

// Check if x == -32768 (1000000000000000 in two's complement)
@R0
D=M
@MIN_VALUE
D+1;JEQ  

// If x is negative but not -32768, compute -x using two’s complement
@R0
D=M
D=!D
D=D+1
@R1
M=D  // Store |x| in R1
@R2
M=1  // Set R2 since x was negative
@R3
M=0  // Set R3 to 0 since the absolute value was computable
@END
0;JMP

(POSITIVE_CASE)
// If x is positive, just store it in R1
@R0
D=M
@R1
M=D  
@R2
M=0  // Not negative
@R3
M=0  // Computable
@END
0;JMP

(MIN_VALUE)
// If x == -32768, keep R1 unchanged and set R3 = 1
@R1
M=R0  // Store R0 unchanged since absolute value cannot be computed
@R2
M=1   // Still negative
@R3
M=1   // Indicate absolute value cannot be computed
@END
0;JMP

(END)
@END
0;JMP  // Infinite loop

