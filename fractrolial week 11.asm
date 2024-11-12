.STACK 100h

.DATA
    promptMsg DB 'Enter a single-digit number (0-9): $' ; Prompt message for user input
    resultMsg DB 'The factorial is: $'                  ; Message to display result
    num DB ?                                            ; Variable to store the user input
    factorial DW 1                                      ; To store the factorial result, initialized to 1

.CODE
main:
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Display the prompt message
    LEA DX, promptMsg
    MOV AH, 09h               ; DOS function to display string
    INT 21h

    ; Take a single-digit number as input from the user
    MOV AH, 01h               ; DOS function to take single character input
    INT 21h
    SUB AL, '0'               ; Convert ASCII to integer
    MOV num, AL               ; Store input number in 'num'

    ; Check if the number is 0 (since 0! = 1)
    CMP num, 0
    JE display_result         ; If num = 0, factorial is 1, skip calculation

    ; Initialize factorial calculation
    MOV AX, 1                 ; AX will hold the running factorial product
    MOV CL, num               ; Load the input number into CL as the counter

factorial_loop:
    MOV BX, AX                ; Move the current factorial value to BX for multiplication
    MUL CL                    ; Multiply AX by CL (AX = AX * CL)
    DEC CL                    ; Decrement CL by 1
    JNZ factorial_loop        ; Repeat until CL = 0

    ; Store the result in factorial variable
    MOV factorial, AX         ; Store AX (factorial result) in factorial

display_result:
    ; Display the result message
    LEA DX, resultMsg
    MOV AH, 09h               ; DOS function to display string
    INT 21h

    ; Display the factorial result
    MOV AX, factorial         ; Load factorial result into AX for display
    CALL PrintDecimal         ; Call PrintDecimal to display the number

    ; End the program
    MOV AH, 4Ch               ; DOS function to exit program
    INT 21h

; Procedure to print a 16-bit number in AX as decimal
PrintDecimal PROC
    MOV CX, 10                ; Set divisor to 10 for decimal conversion
    MOV BX, 0                 ; Initialize digit count

decimal_loop:
    XOR DX, DX                ; Clear DX for division
    DIV CX                    ; Divide AX by 10, quotient in AX, remainder in DX
    PUSH DX                   ; Push remainder (digit) onto stack
    INC BX                    ; Count the digit
    CMP AX, 0                 ; Check if AX is zero
    JNE decimal_loop          ; Repeat until AX is zero

print_digits:
    POP DX                    ; Get digit from stack
    ADD DL, '0'               ; Convert to ASCII
    MOV AH, 02h               ; DOS function to print character
    INT 21h                   ; Display the character
    DEC BX                    ; Decrement digit counter
    JNZ print_digits          ; Repeat until all digits are printed

    RET
PrintDecimal ENDP

END main
