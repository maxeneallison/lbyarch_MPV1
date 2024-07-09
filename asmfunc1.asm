; callee

section .text
bits 64
default rel 
global cvtRGBToGray

cvtRGBToGray:
    ; Parameters (volatile):
        ; rcx - img2 (destination grayscale image)
        ; rdx - img1 (source RGB image)
        ; r8  - m (width)
        ; r9  - n (height)
    

    push rbp                
    mov rbp, rsp           
    
    ;  non-volatile registers
    push rsi                
    push rdi                
    push r12                
    push r13                
    push r14    
    push r15
                
    ; allocate shadow space and ensure 16-byte alignment
    sub rsp, 8*5            ; shadow space (5 * 8)
                            ; This provides the required 32 bytes of shadow space
                            ; plus 8 additional bytes to ensure 16-byte alignment

    ; input parameters in non-volatile registers
    mov r12, rcx            ; Store img2 pointer (destination)
    mov r13, rdx            ; Store img1 pointer (source)
    mov r14, r8             ; Store width in r14

    ; compute total number of pixels (w*h)
    mov rax, r8             
    mul r9                  ; Multiply width by height 
    mov r15, rax            

pixel_loop:
    xor rax, rax            ; for RGB values

    ; average of RGB
    movzx r10, byte [r13]     ; Red
    add rax, r10
    
    movzx r10, byte [r13 + 1] ; Green
    add rax, r10
    
    movzx r10, byte [r13 + 2] ; Blue
    add rax, r10

    ; compute average
    mov r10, 3
    xor rdx, rdx            ; Clear upper bits for division
    div r10

    ; store result in the destination image
    mov [r12], al

    ; move to next pixel
    add r13, 3              ; Move source pointer to next pixel (RGB = 3 bytes)
    inc r12                 ; Move destination pointer to next byte

    ; check if done
    dec r15                 ; Decrement total pixel count
    jnz pixel_loop          ; If not zero, continue loop

    
    add rsp, 8*5            ; Remove shadow space (40 bytes)

    ; Restore non-volatile registers
    pop r15
    pop r14                 
    pop r13                 
    pop r12                 
    pop rdi                 
    pop rsi                 
    
    ; Restore the original stack frame
    pop rbp                
    ret