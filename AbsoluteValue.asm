// AbsoluteValue.asm - Compute z = |x|
// x is stored in R0; result |x| is stored in R1.
// R2 is the "negative" flag (1 if x < 0, else 0).
// R3 is the error flag (1 if x = -32768, since |x| cannot be represented).
// R0 is not modified.

    @R0
    D=M          // D = x
    @POSITIVE
    D;JGE        // if x >= 0, jump to positive branch

    // ----- Negative branch (x < 0) -----
    @1
    D=A
    @R2
    M=D          // R2 = 1 (x is negative)

    // Test for edge case: x == -32768.
    // In 16-bit 2's complement, -32768 equals its own negation.
    @R0
    D=M          // D = x
    D=-D         // D = -x
    @R0
    D=D-M       // D = (-x) - x; will be 0 only if x == -32768.
    @EDGE
    D;JEQ       // if D == 0, jump to edge-case handling

    // Normal negative number: compute |x| = -x.
    @R0
    D=M
    D=-D
    @R1
    M=D         // R1 = |x|
    @0
    D=A
    @R3
    M=D         // R3 = 0 (no error)
    @END
    0;JMP

(POSITIVE)
    // ----- Non-negative branch (x >= 0) -----
    @R0
    D=M
    @R1
    M=D         // R1 = x (absolute value is the same)
    @0
    D=A
    @R2
    M=D         // R2 = 0 (x is not negative)
    @R3
    M=D         // R3 = 0 (no error)

(EDGE)
    // ----- Edge case: x == -32768 -----
    // Absolute value cannot be computed.
    @R0
    D=M
    @R1
    M=D         // Leave R1 unchanged (contains x)
    @1
    D=A
    @R3
    M=D         // R3 = 1 (error flag)

(END)
    // End of program.



