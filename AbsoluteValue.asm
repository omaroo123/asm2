// AbsoluteValue.asm
// Compute absolute value |x|
// R0 = x (input)
// R1 = |x| (output)
// R2 = 1 if input was negative, 0 otherwise
// R3 = 1 if |x| cannot be computed, 0 otherwise

@R0
D=M
@NEGATIVE_CHECK
D;JLT    // Jump if x < 0

// If x is positive, store it in R1 and set flags to 0
@R1
M=D
@R2
M=0
@R3
M=0
@END
0;JMP

(NEGATIVE_CHECK)
@R0
D=M
@TWO_COMPLEMENT
D=-D    // Compute -x (two’s complement)

@R1
M=D    // Store |x| in R1
@R2
M=1    // Set flag R2 since x was negative

// Check for x == -32768 (uncomputable case)
@R0
D=M
@MIN_VALUE
D+1;JEQ    // If x == -32768, jump

@R3
M=0    // Otherwise, set R3 = 0
@END
0;JMP

(MIN_VALUE)
@R3
M=1    // Set R3 = 1 if x == -32768
@R1
M=R0   // Keep R1 unchanged

(END)
@END
0;JMP  // Infinite loop to halt execution
