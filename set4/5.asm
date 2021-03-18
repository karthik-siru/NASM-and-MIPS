section .data
    s_cnt      : db 0
    string_len : db 0
    msg1       : db "Enter a string : "
    l1         : equ $-msg1
    msg2       : db "No: of TABS: "
    l2         : equ $-msg2
    newline    : db 10

;____________________________________________________________________

section .bss
    string: resb 50
    temp: resb 1

;____________________________________________________________________

section .data
    global _start
    _start:

    mov eax,4
    mov ebx,1
    mov ecx,msg1
    mov edx,l1
    int 80h

    mov ebx,string

    reading:
    push ebx
    mov eax, 3
    mov ebx, 0
    mov ecx, temp
    mov edx, 1
    int 80h
    pop ebx
    cmp byte[temp], 10
    je end_reading
    inc byte[string_len]
    mov al,byte[temp]
    mov byte[ebx], al
    inc ebx
    jmp reading
    end_reading:
    mov byte[ebx], 0


    mov ebx, string
    counting:
    mov al, byte[ebx]
    cmp al, 0
    je end_counting
    cmp al,' '
    je inc_s
    next:
    inc ebx
    jmp counting
;____________________________________________________________________
    end_counting:
    ;Printing the no of spaces
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, l2
    int 80h
    add byte[s_cnt], 30h
    mov eax, 4
    mov ebx , 1
    mov ecx , s_cnt
    mov edx ,1
    int 80h
    call new_line
    call exit
;____________________________________________________________________

 new_line :
    pusha
    mov eax , 4
    mov ebx , 1
    mov ecx , newline
    mov edx ,1
    int 80h
    popa
    ret

;____________________________________________________________________
    exit:
    mov eax, 1
    mov ebx, 0
    int 80h
;____________________________________________________________________

    inc_s:
    inc byte[s_cnt]
    jmp next
