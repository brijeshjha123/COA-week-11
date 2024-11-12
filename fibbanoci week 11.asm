.model small
.stack 100h
.data
    msg db 'Enter the value of n (0-9): $'      ; Message to prompt user
    fib_res db ?                                ; To store nth Fibonacci term
    n db ?                                      ; User input (single-digit number)
    result_msg db 0Dh, 0Ah, 'Fibonacci term: $' ; Message to display result
    result db '00$', 0Dh, 0Ah                   ; Space to store result as string

.code
main:
    mov ax, @data
    mov ds, ax                ; Initialize data segment

    ; Display message to enter the value of n
    mov ah, 09h
    lea dx, msg
    int 21h

    ; Take single-digit input from user
    mov ah, 01h
    int 21h
    sub al, '0'               ; Convert ASCII to integer
    mov n, al                 ; Store user input in 'n'

    ; Check if input is 0 or 1
    mov al, n
    cmp al, 0
    je fib_zero               ; If n = 0, set result to 0
    cmp al, 1
    je fib_one                ; If n = 1, set result to 1

    ; Initialize Fibonacci terms for calculation
    mov cl, al                ; Move n to CL for loop count
    mov al, 1                 ; Set AL = 1 for F(1)
    mov bl, 0                 ; Set BL = 0 for F(0)
    dec cl                    ; Adjust count to loop n-1 times

fib_loop:
    ; Calculate next term: F(n) = F(n-1) + F(n-2)
    mov ah, al                ; Store current F(n-1) in AH
    add al, bl                ; AL = F(n) = F(n-1) + F(n-2)
    mov bl, ah                ; Update F(n-2) to previous F(n-1)
    dec cl
    jnz fib_loop              ; Loop until CL becomes zero (reached nth term)

    ; Store the nth Fibonacci term in fib_res
    mov fib_res, al

display_result:
    ; Display result message
    mov ah, 09h
    lea dx, result_msg
    int 21h

    ; Convert result to ASCII and store in 'result' for correct display
    mov al, fib_res
    aam                       ; Split AL into AH (tens) and AL (units)
    add ah, '0'               ; Convert tens to ASCII
    add al, '0'               ; Convert units to ASCII
    mov result[0], ah         ; Store tens digit in result
    mov result[1], al         ; Store units digit in result
    jmp display_final

single_digit:
    add al, '0'               ; Convert single digit to ASCII
    mov result[0], al         ; Store single digit in result
    mov result[1], '$'        ; Add end-of-string marker

display_final:
    ; Display the result
    lea dx, result
    mov ah, 09h
    int 21h

    ; End the program
    mov ah, 4Ch
    int 21h

fib_zero:
    mov fib_res, 0            ; F(0) = 0
    jmp display_result

fib_one:
    mov fib_res, 1            ; F(1) = 1
    jmp display_result