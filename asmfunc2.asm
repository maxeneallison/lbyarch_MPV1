; callee assembly
; performs average the grayscale value for the current pixel


section .text
bits 64
default rel
global asmfunc2

asmfunc2:
    ; rcx - pointer to current RGB pixel

    xor rax, rax
    
    ; inputs
    movzx r10, byte [rcx]     ; Red
    add rax, r10
    
    movzx r10, byte [rcx + 1] ; Green
    add rax, r10
    
    movzx r10, byte [rcx + 2] ; Blue
    add rax, r10

    ; Compute average
    mov r10, 3
    xor rdx, rdx  ; Clear upper bits for division
    div r10
    ; Result is now in AL

    ret