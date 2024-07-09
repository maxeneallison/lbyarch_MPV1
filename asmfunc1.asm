; callee

section .text
bits 64
default rel
global cvtRGBToGray

cvtRGBToGray:
    ; Parameters:
    ; rdx - img1 (source RGB image)
    ; rcx - img2 (destination grayscale image)
    ; r8  - width
    ; r9  - height

    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15

    ; Store parameters in non-volatile registers
    mov r12, rdx    ; Source image pointer
    mov r13, rcx    ; Destination image pointer
    mov r14, r8     ; Width
    mov r15, r9     ; Height

    ; Calculate total number of pixels
    mov rax, r14
    mul r15
    mov rbx, rax    ; Total pixels in rbx

pixel_loop:
    ; Get RGB values
    movzx r8, byte [r12]      ; Red
    movzx r9, byte [r12 + 1]  ; Green
    movzx r10, byte [r12 + 2] ; Blue

    ; Calculate grayscale value (average of R, G, B)
    mov rax, r8
    add rax, r9
    add rax, r10
    xor rdx, rdx
    mov rcx, 3
    div rcx         ; rax now contains the average

    ; Store grayscale value
    mov [r13], al

    ; Move to next pixel
    add r12, 3  ; Move source pointer (RGB = 3 bytes)
    inc r13     ; Move destination pointer

    ; Check if we're done
    dec rbx
    jnz pixel_loop

    ; Restore registers and return
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret