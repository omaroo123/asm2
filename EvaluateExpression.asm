// EvaluateExpression.asm - Compute z = (x - y) * (x + y)
// x is in R0, y is in R1; result z is stored in R2.
// This program does not modify R0 or R1.
// It uses registers R3-R10 as temporary storage.

    // Compute diff = x - y, store in R3.
    @R0
    D=M
    @R1
    D=D-M
    @R3
    M=D        // R3 = diff

    // Compute sum = x + y, store in R4.
    @R0
    D=M
    @R1
    D=D+M
    @R4
    M=D        // R4 = sum

    // --- Determine the product sign ---
    // Set R5 = diffSign: 0 if diff (R3) is non-negative, 1 if negative.
    @R3
    D=M
    @DIFF_POS
    D;JGE
    @R5
    M=1       // diffSign = 1
    @CHECK_SUM_SIGN
    0;JMP
(DIFF_POS)
    @R5
    M=0       // diffSign = 0
(CHECK_SUM_SIGN)
    // Set R6 = sumSign: 0 if sum (R4) is non-negative, 1 if negative.
    @R4
    D=M
    @SUM_POS
    D;JGE
    @R6
    M=1       // sumSign = 1
    @SET_PROD_SIGN
    0;JMP
(SUM_POS)
    @R6
    M=0       // sumSign = 0
(SET_PROD_SIGN)
    // Compute productSign = diffSign XOR sumSign.
    // (If R5 ≠ R6 then productSign = 1; else 0.) Store result in R7.
    @R5
    D=M
    @R6
    D=D-M   // D = diffSign - sumSign
    @SET_PROD_NEG
    D;JNE   // if nonzero, then productSign = 1
    @SET_PROD_POS
    0;JMP
(SET_PROD_NEG)
    @R7
    M=1     // product will be negative
    @AFTER_PROD_SIGN
    0;JMP
(SET_PROD_POS)
    @R7
    M=0     // product will be non-negative
(AFTER_PROD_SIGN)

    // --- Compute absolute values ---
    // Compute |diff| and store in R8.
    @R3
    D=M
    @ABS_DIFF_POS
    D;JGE
    @R3
    D=M
    D=-D
    @R8
    M=D
    @AFTER_ABS_DIFF
    0;JMP
(ABS_DIFF_POS)
    @R3
    D=M
    @R8
    M=D
(AFTER_ABS_DIFF)

    // Compute |sum| and store in R9.
    @R4
    D=M
    @ABS_SUM_POS
    D;JGE
    @R4
    D=M
    D=-D
    @R9
    M=D
    @AFTER_ABS_SUM
    0;JMP
(ABS_SUM_POS)
    @R4
    D=M
    @R9
    M=D
(AFTER_ABS_SUM)

    // --- Multiply |diff| (R8) by |sum| (R9) using repeated addition ---
    // Initialize product accumulator in R10 to 0.
    @0
    D=A
    @R10
    M=D

(MULT_LOOP)
    @R9
    D=M
    @END_MULT
    D;JEQ       // if R9 == 0, exit loop
    // Add abs(diff) (R8) to the accumulator (R10).
    @R10
    D=M
    @R8
    D=D+M
    @R10
    M=D
    // Decrement R9 by 1:
    @R9
    D=M
    @1
    D=D-1
    @R9
    M=D
    @MULT_LOOP
    0;JMP
(END_MULT)

    // --- Apply the correct sign to the product ---
    // If productSign (R7) is 1, then negate the product.
    @R7
    D=M
    @CHECK_PRODUCT_SIGN
    D;JEQ      // if 0, skip negation
    @R10
    D=M
    D=-D
    @R10
    M=D
(CHECK_PRODUCT_SIGN)

    // Store final product in R2.
    @R10
    D=M
    @R2
    M=D

    (END)
    // End of program.
