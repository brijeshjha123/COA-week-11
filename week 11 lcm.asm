.STACK 100h

.DATA
    num1 DB 4                ; First number (single byte)
    num2 DB 6                ; Second number (single byte)
    gcd_res DB 0             ; To store GCD result (single byte)
    lcm_res DW 0             ; To store LCM result (two bytes for larger result)
    resultMsg DB 'The LCM is: $' ; Message to display

.CODE
main:
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Load num1 and num2 into AL and BL for GCD calculation
    MOV AL, num1             ; Move the first number to AL
    MOV BL, num2             ; Move the second number to BL
    CALL gcd                 ; Call GCD procedure to calculate GCD of num1 and num2
    MOV gcd_res, AL          ; Store the calculated GCD result in gcd_res

    ; Calculate LCM using the formula: (num1 * num2) / GCD
    MOV AL, num1             ; Load num1 into AL for multiplication
    MOV AH, 0                ; Clear AH (required for 16-bit multiplication)
    MOV DL, num2             ; Load num2 into DL
    MUL DL                   ; Multiply AL by DL, result is stored in AX (num1 * num2)

    ; Divide the product in AX by the GCD to find LCM
    MOV CL, gcd_res          ; Load the GCD into CL
    DIV CL                   ; Divide AX by GCD, result is in AL (remainder in AH)

    ; Store the LCM result in lcm_res
    MOV lcm_res, AX          ; Save the result of (num1 * num2) / GCD in lcm_res

    ; Print the result message
    LEA DX, resultMsg        ; Load the address of resultMsg into DX
    MOV AH, 09h              ; DOS function to print a string
    INT 21h                  ; Display the result message

    ; Display the LCM value in decimal
    MOV AX, lcm_res          ; Load the LCM result into AX for display
    CALL PrintDecimal        ; Call PrintDecimal procedure to print AX as a decimal

    ; End the program
    MOV AH, 4Ch              ; DOS function to terminate program
    INT 21h

; Procedure to calculate GCD using the Euclidean algorithm
gcd PROC
    ; Check if BL is zero, which means the GCD is already in AL
    CMP BL, 0
    JE end_gcd               ; If BL is zero, exit gcd procedure (GCD is in AL)
gcd_loop:
    MOV AH, 0                ; Clear AH for division
    DIV BL                   ; Divide AL by BL, remainder goes into AH
    MOV AL, BL               ; Move BL into AL (next dividend)
    MOV BL, AH               ; Move remainder into BL (next divisor)
    CMP BL, 0                ; Check if remainder is zero
    JNE gcd_loop             ; If remainder is not zero, repeat loop
end_gcd:
    RET                      ; GCD is in AL when BL becomes zero
gcd ENDP

; Procedure to print a 16-bit number in AX as a decimal number
PrintDecimal PROC
    ; This procedure converts the number in AX to decimal and prints each digit
    MOV CX, 10               ; Set divisor to 10 for decimal system
    MOV BX, 0                ; Initialize BX to count number of digits

decimal_loop:
    XOR DX, DX               ; Clear DX before division
    DIV CX                   ; Divide AX by 10, quotient in AX, remainder in DX
    PUSH DX                  ; Push remainder (digit) onto the stack
    INC BX                   ; Increase digit count
    CMP AX, 0                ; Check if quotient is zero
    JNE decimal_loop         ; If quotient is not zero, continue loop

print_digits:
    POP DX                   ; Retrieve digits from stack
    ADD DL, '0'              ; Convert the digit to ASCII character
    MOV AH, 02h              ; DOS function to print character
    INT 21h                  ; Display the character
    DEC BX                   ; Decrease digit counter
    JNZ print_digits         ; Repeat until all digits are printed

    RET
PrintDecimal ENDP

END main