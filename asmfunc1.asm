; assembly caller

section .text
bits 64
default rel 
global cvtRGBToGray
extern asmfunc2

cvtRGBToGray:
    ; Parameters:
    ; rdx - img1 (source RGB image)
    ; rcx - img2 (destination grayscale image)
    ; r8  - m (width)
    ; r9  - n (height)

    ; Preserve non-volatile registers and align stack
    ; Function prologue
    push rbp                ; Save the base pointer
    mov rbp, rsp            ; Set up new base pointer
    push rsi                ; Save rsi register
    push rdi                ; Save rdi register
    push r12                ; Save r12 register
    push r13                ; Save r13 register
    push r14                ; Save r14 register
    sub rsp, 8*5            ; Allocate shadow space and align stack

    ; Preserve parameters
    mov r12, rcx            ; Store img2 pointer in r12
    mov r13, rdx            ; Store img1 pointer in r13
    mov r14, r8             ; Store width in r14

    ; Calculate total number of pixels
    mov rax, r8             ; Move width to rax
    mul r9                  ; Multiply width by height (assumed to be in r9)
    mov r15, rax            ; Store total pixels in r15

    .pixel_loop:
    ; Prepare parameters for asmfunc2
    mov rcx, r13            ; Set rcx to current source RGB pixel address

    ; Call asmfunc2 to calculate average
    sub rsp, 32             ; Allocate shadow space for asmfunc2 call
    call asmfunc2           ; Call asmfunc2 function
    add rsp, 32             ; Clean up shadow space after call

    ; Store result in destination array
    mov [r12], al           ; Store the result (in al) to destination

    ; Move to next pixel
    add r13, 3              ; Move source pointer to next pixel (RGB = 3 bytes)
    inc r12                 ; Move destination pointer to next byte

    ; Decrement pixel count and continue if not zero
    dec r15                 ; Decrement total pixel count
    jnz .pixel_loop         ; If not zero, continue loop

    ; Function epilogue
    add rsp, 8*5            ; Clean up stack space
    pop r14                 ; Restore r14
    pop r13                 ; Restore r13
    pop r12                 ; Restore r12
    pop rdi                 ; Restore rdi
    pop rsi                 ; Restore rsi
    pop rbp                 ; Restore base pointer
    ret                     ; Return from function