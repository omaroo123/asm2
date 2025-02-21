// EvaluateExpression.asm - Compute z = (x - y) * (x + y)
// x is in R0, y is in R1; result z is stored in R2.
// R0 and R1 remain unchanged.
// Temporary registers used: R3-R10.

    // Compute diff = x - y and store in R3.
    @R0
    D=M
    @R1
    D=D-M
    @R3
    M=D            // R3 = diff

    // Compute sum = x + y and store in R4.
    @R0
    D=M
    @R1
    D=D+M
    @R4
    M=D            // R4 = sum

    // --- Determine product sign ---
    // Compute diffSign in R5: 0 if diff >= 0, 1 if diff < 0.
    @R3
    D=M
    @DIFF_POS
    D;JGE
    @R5
    M=1
    @SUM_CHECK
    0;JMP
(DIFF_POS)
    @R5
    M=0
(SUM_CHECK)
    // Compute sumSign in R6: 0 if sum >= 0, 1 if sum < 0.
    @R4
    D=M
    @SUM_POS
    D;JGE
    @R6
    M=1
    @SET_SIGN
    0;JMP
(SUM_POS)
    @R6
    M=0
(SET_SIGN)
    // Product sign = diffSign XOR sumSign.
    // If R5 != R6 then product will be negative.
    @R5
    D=M
    @R6
    D=D-M      // D = diffSign - sumSign
    @NEGATIVE
    D;JNE      // if nonzero, product is negative
    @R7
    M=0        // otherwise, product is non-negative
    @CONT_SIGN
    0;JMP
(NEGATIVE)
    @R7
    M=1
(CONT_SIGN)

    // --- Compute absolute values ---
    // |diff| in R8.
    @R3
    D=M
    @ABS_DIFF_POS
    D;JGE
    D=-D
(ABS_DIFF_POS)
    @R8
    M=D

    // |sum| in R9.
    @R4
    D=M
    @ABS_SUM_POS
    D;JGE
    D=-D
(ABS_SUM_POS)
    @R9
    M=D

    // --- Multiply |diff| (R8) by |sum| (R9) using repeated addition ---
    // Set product accumulator in R10 to 0.
    @0
    D=A
    @R10
    M=D

(MULT_LOOP)
    @R9
    D=M
    @END_MULT
    D;JEQ         // if |sum| is 0, exit loop
    // Add |diff| (R8) to accumulator (R10).
    @R10
    D=M
    @R8
    D=D+M
    @R10
    M=D
    // Decrement |sum| counter in R9.
    @R9
    D=M
    @1
    D=D-1
    @R9
    M=D
    @MULT_LOOP
    0;JMP
(END_MULT)

    // --- Apply product sign ---
    // If product sign (R7) is 1, then negate the product.
    @R7
    D=M
    @SKIP_NEG
    D;JEQ         // if R7 == 0, skip negation
    @R10
    D=M
    D=-D
    @R10
    M=D
(SKIP_NEG)

    // Store the final product in R2.
    @R10
    D=M
    @R2
    M=D

    // Infinite loop to end the program.
(END)
    @END
    0;JMP

