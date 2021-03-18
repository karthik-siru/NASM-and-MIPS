section .data
    a_cnt: db 0
    e_cnt: db 0
    i_cnt: db 0
    o_cnt: db 0
    u_cnt: db 0
    string_len: db 0
    msg1: db "Enter a string : "
    size1: equ $-msg1
    msg_a: db "No: of A : "
    size_a: equ $-msg_a
    msg_e: db "No: of E : "
    size_e: equ $-msg_e
    msg_i: db "No: of I : "
    size_i: equ $-msg_i
    msg_o: db "No: of O : "
    size_o: equ $-msg_o
    msg_u: db "No: of U : "
    size_u: equ $-msg_u
    newline : db 10

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
    mov edx,size1
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
    cmp al,'a'
    je inc_a
    cmp al,'e'
    je inc_e
    cmp al,'i'
    je inc_i
    cmp al,'o'
    je inc_o
    cmp al,'u'
    je inc_u
    cmp al,'A'
    je inc_a
    cmp al,'E'
    je inc_e
    cmp al,'I'
    je inc_i
    cmp al,'O'
    je inc_o
    cmp al,'U'
    je inc_u
    next:
    inc ebx
    jmp counting
;____________________________________________________________________
    end_counting:
    ;Printing the no of a
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_a
    mov edx, size_a
    int 80h
    add byte[a_cnt], 30h
    mov eax, 4
    mov ebx , 1
    mov ecx , a_cnt
    mov edx ,1
    int 80h
    call new_line

    ;Printing the no of e
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_e
    mov edx, size_e
    int 80h
    add byte[e_cnt], 30h
    mov eax, 4
    mov ebx, 1
    mov ecx, e_cnt
    mov edx, 1
    int 80h
    call new_line

    ;Printing the no of i
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_i
    mov edx, size_i
    int 80h
    add byte[i_cnt], 30h
    mov eax, 4
    mov ebx, 1
    mov ecx, i_cnt
    mov edx, 1
    int 80h
    call new_line
    ;Printing the no of o
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_o
    mov edx, size_o
    int 80h
    add byte[o_cnt], 30h
    mov eax, 4
    mov ebx, 1
    mov ecx, o_cnt
    mov edx, 1
    int 80h
    call new_line
    ;Printing the no of u
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_u
    mov edx, size_u
    int 80h
    add byte[u_cnt], 30h
    mov eax, 4
    mov ebx, 1
    mov ecx, u_cnt
    mov edx, 1
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

    inc_a:
    inc byte[a_cnt]
    jmp next

    inc_e:
    inc byte[e_cnt]
    jmp next

    inc_i:
    inc byte[i_cnt]
    jmp next

    inc_o:
    inc byte[o_cnt]
    jmp next

    inc_u:
    inc byte[u_cnt]
    jmp next
