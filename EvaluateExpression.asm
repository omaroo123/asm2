// EvaluateExpression.asm - Compute z = (x - y) * (x + y) = x^2 - y^2
// x is in R0, y is in R1; result z is stored in R2.
// Registers R3-R15 are used as temporary storage.
// R0 and R1 are not modified.

// --- Compute diff = x - y (in R3) and sum = x + y (in R4) ---
    @R0
    D=M
    @R1
    D=D-M
    @R3
    M=D         // R3 = diff

    @R0
    D=M
    @R1
    D=D+M
    @R4
    M=D         // R4 = sum

// --- Determine product sign ---
// R5 = diffSign: 0 if diff >= 0, 1 if diff < 0.
    @R3
    D=M
    @DIFF_POS
    D;JGE
    @R5
    M=1
    @DIFF_DONE
    0;JMP
(DIFF_POS)
    @R5
    M=0
(DIFF_DONE)

// R6 = sumSign: 0 if sum >= 0, 1 if sum < 0.
    @R4
    D=M
    @SUM_POS
    D;JGE
    @R6
    M=1
    @SUM_DONE
    0;JMP
(SUM_POS)
    @R6
    M=0
(SUM_DONE)

// Compute product sign: R7 = 1 if (R5 XOR R6) is true; else 0.
    @R5
    D=M
    @R6
    D=D-M      // D = R5 - R6
    @NEG_SIGN
    D;JNE      // if nonzero, product is negative
    @R7
    M=0       // product is nonnegative
    @CONT_SIGN
    0;JMP
(NEG_SIGN)
    @R7
    M=1       // product will be negative
(CONT_SIGN)

// --- Compute absolute values ---
// Absolute value of diff into R8.
    @R3
    D=M
    @ABS_DIFF_POS
    D;JGE
    D=-D
(ABS_DIFF_POS)
    @R8
    M=D

// Absolute value of sum into R9.
    @R4
    D=M
    @ABS_SUM_POS
    D;JGE
    D=-D
(ABS_SUM_POS)
    @R9
    M=D

// --- Binary Multiplication: Compute R10 = R8 * R9 ---
// (We treat R8 as the multiplicand and R9 as the multiplier.)

    // Clear product accumulator.
    @0
    D=A
    @R10
    M=D

    // Initialize constant ONE in R14 and TWO in R15.
    @1
    D=A
    @R14
    M=D
    @2
    D=A
    @R15
    M=D

    // Set loop counter R11 to 16 (we will process 16 bits).
    @16
    D=A
    @R11
    M=D

(MULT_LOOP)
    @R11
    D=M
    @END_MULT_LOOP
    D;JEQ     // if counter == 0, exit multiplication loop

    // --- Test least-significant bit of R9 ---
    @R9
    D=M
    @R14
    D=D&M    // D = R9 & 1
    @SKIP_ADD
    D;JEQ    // if LSB is 0, skip addition
        // Add multiplicand R8 to product R10.
        @R10
        D=M
        @R8
        D=D+M
        @R10
        M=D
(SKIP_ADD)

    // --- Shift multiplicand left by 1: R8 = R8 + R8 ---
    @R8
    D=M
    D=D+M
    @R8
    M=D

    // --- Shift multiplier R9 right by 1 ---
    // We compute the quotient Q = floor(R9/2) using a loop.
    @0
    D=A
    @R13
    M=D       // R13 will hold the quotient; initialize to 0

(RSHIFT_LOOP)
    @R9
    D=M
    @R15
    D=D-M   // Compute D = R9 - 2
    @RSHIFT_DONE
    D;JLT   // if R9 < 2, exit right-shift loop
        // Subtract 2 from R9.
        @R9
        D=M
        @R15
        D=D-M   // D = R9 - 2
        @R9
        M=D    // update R9

        // Increment quotient in R13: R13 = R13 + 1.
        @R13
        D=M
        @R14
        D=D+M   // D = R13 + 1 (since R14 is 1)
        @R13
        M=D

        @RSHIFT_LOOP
        0;JMP
(RSHIFT_DONE)
    // Now store quotient back into R9.
    @R13
    D=M
    @R9
    M=D

    // --- Decrement loop counter R11 by 1 ---
    @R11
    D=M
    @R14
    D=D-M   // D = R11 - 1
    @R11
    M=D

    @MULT_LOOP
    0;JMP
(END_MULT_LOOP)

// --- Apply product sign ---
// If R7 == 1 then negate the product in R10.
    @R7
    D=M
    @SKIP_NEG
    D;JEQ     // if R7 == 0, skip negation
    @R10
    D=M
    D=-D
    @R10
    M=D
(SKIP_NEG)

// --- Store final product in R2 ---
    @R10
    D=M
    @R2
    M=D

// End program.
(END)
    @END
    0;JMP


