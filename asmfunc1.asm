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
    ; sets up the stack frame for the function
    push rbp                
    mov rbp, rsp            ; Set up new base pointer

    ; preserves non-volatile regiters that will be used in the function
    push rsi                
    push rdi                
    push r12                
    push r13                
    push r14    
                
    sub rsp, 8*5            ; Allocates shadow space on the stack and ensures 16-byte alignment

    ; Preserve input parameters in non-volatile registers
    mov r12, rcx            ; Store img2 pointer 
    mov r13, rdx            ; Store img1 pointer
    mov r14, r8             ; Store width in r14

    ; Calculate total number of pixels (w*h) and store in r15
    mov rax, r8             
    mul r9                  ; Multiply width by height 
    mov r15, rax            ; Store total pixels in r15

; ===============================================
    pixel_loop:
        mov rcx, r13            ; will be the current source RGB pixel address
    
        ; Call asmfunc2 to calculate average, process the current pixel
        sub rsp, 32             ; Allocate shadow space for asmfunc2 call
        call asmfunc2           ; Call asmfunc2 function
        add rsp, 32             ; Clean up shadow space after call
    
        ; Store result in destination array
        mov [r12], al           
        
        ; Move to next pixel
        add r13, 3              ; Move source pointer to next pixel (RGB = 3 bytes)
        inc r12                 ; Move destination pointer to next byte
    

        dec r15                 ; Decrement total pixel count
        jnz pixel_loop         ; If not zero, continue loop
    
        ; Restores the stack and registers, then returns from the function
        add rsp, 8*5            ; Clean stack space
        pop r14                 
        pop r13                 
        pop r12                 
        pop rdi                 
        pop rsi                 
        pop rbp                
    ret                     