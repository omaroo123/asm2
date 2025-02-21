// AddWithOverflowCheck.asm - Compute z = x + y with overflow check.
// x is in R0, y is in R1; result is stored in R2.
// R3 is the overflow flag: 1 if overflow occurred, 0 otherwise.
// R0 and R1 are not modified.

    // Compute sum = x + y.
    @R0
    D=M
    @R1
    D=D+M
    @R2
    M=D         // R2 = x + y

    // Check overflow conditions.
    // Overflow occurs if:
    //   (x >= 0 and y >= 0 and (x+y) < 0) OR
    //   (x < 0 and y < 0 and (x+y) >= 0).

    // Check sign of x.
    @R0
    D=M
    @CHECK_NONNEG
    D;JGE      // if x >= 0, go to CHECK_NONNEG
    @CHECK_NEG
    0;JMP

(CHECK_NONNEG)
    // x is non-negative; check y.
    @R1
    D=M
    @X_NONNEG
    D;JGE      // if y >= 0, then both non-negative → check result.
    @SET_NO_OVERFLOW
    0;JMP

(X_NONNEG)
    // Both x and y are non-negative.
    @R2
    D=M
    @SET_OVERFLOW
    D;JLT      // if result < 0, overflow occurred.
    @SET_NO_OVERFLOW
    0;JMP

(CHECK_NEG)
    // x is negative; check y.
    @R1
    D=M
    @Y_NEG
    D;JLT      // if y < 0, then both negative → check result.
    @SET_NO_OVERFLOW
    0;JMP

(Y_NEG)
    // Both x and y are negative.
    @R2
    D=M
    @SET_OVERFLOW
    D;JGE      // if result >= 0, overflow occurred.
    @SET_NO_OVERFLOW
    0;JMP

(SET_OVERFLOW)
    @1
    D=A
    @R3
    M=D         // Set overflow flag to 1.
    @END
    0;JMP

(SET_NO_OVERFLOW)
    @0
    D=A
    @R3
    M=D         // Set overflow flag to 0.

(END)
    // End of program.
