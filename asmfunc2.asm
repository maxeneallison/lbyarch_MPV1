; callee assembly
; gagawa ng stack frame
; performs average the grayscale value for the current pixel


section .text
bits 64
default rel
global asmfunc2

asmfunc2:
    ; Input:
    ; rcx - pointer to current RGB pixel

    xor rax, rax
    movzx r10, byte [rcx]     ; Red
    add rax, r10
    movzx r10, byte [rcx + 1] ; Green
    add rax, r10
    movzx r10, byte [rcx + 2] ; Blue
    add rax, r10

    ; Calculate average
    mov r10, 3
    xor rdx, rdx  ; Clear upper bits for division
    div r10
    ; Result is now in AL

    ret