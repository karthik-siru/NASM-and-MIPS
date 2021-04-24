section .data

   c: db "1"
   newline : db 10

;_________________________________________________________________

section .bss
    strg: resb 100
    strg1: resb 50
    strg2: resb 100
    stack: resb 1000
    dig1: resw 1
    n1: resw 1
    n2: resw 1
    n3: resw 1
    n4: resw 1
    t: resw 1
    max: resw 1
    num: resw 1
    temp: resb 1
    count: resw 1
    strlen: resw 1
    letter: resb 1
    check: resw 1
    enter : resw 1

;_________________________________________________________________

section .text
global _start:
_start:

    pusha
    mov ebx, strg
    call get_string
    popa
    mov ax, word[strlen]
    mov word[n1], ax
    mov word[n2], ax

    pusha
    mov ebx, strg1
    call get_string
    popa
    mov ax, word[strlen]
    mov word[n3],ax
    mov word[n4],ax

    mov ebx, strg
    mov eax, strg1
    mov ecx, strg2

;_________________________________________________________________

; if two bytes are equal , then we are calling the next function
; ecx contains the modified string .

for:
    cmp byte[ebx], 0
    je end_for
    mov dl, byte[ebx]
    cmp dl, byte[eax]
    je next

; c_1 function will move the byte into ecx( new modified string ) and increment ebx ,eax

 c_1:
    mov byte[ecx], dl
    inc ebx
    inc ecx
    jmp for

end_for:
    pusha
    mov ebx, strg2
    call put_string
    popa
    call ent
;_________________________________________________________________

exit:
    mov eax, 1
    mov ebx, 0
    int 80h

;_________________________________________________________________

; n4 - length of the string to be deleted

; eax is the string to be removed

next:
    pusha
    push edx
    mov dx, word[n4]
    mov word[n3], dx
    pop edx

next1:
    mov dl, byte[ebx]
    cmp dl, byte[eax]
    jne not1
    inc ebx
    inc eax
    cmp byte[eax], 0
    jne next1

     ; if we reached , here means that , we found the string 
    popa

    add ebx, dword[n4]
    mov dl, byte[ebx]

    jmp c_1

not1:
    popa
    jmp c_1

;_________________________________________________________________

get_string:
    mov byte[strlen], 0
    repeat:
    push ebx
    mov eax, 3
    mov ebx, 0
    mov ecx, temp
    mov edx, 1
    int 80h
    pop ebx
    cmp byte[temp], 10
    je stop
    mov al, byte[temp]
    mov byte[ebx], al
    inc ebx
    inc word[strlen]
    jmp repeat
    stop:
    mov byte[ebx], 0
    ret

;_________________________________________________________________

put_string:
    repeat1:
    mov al, byte[ebx]
    mov byte[temp], al
    cmp byte[temp], 0
    je sto
    push ebx
    mov eax, 4
    mov ebx, 1
    mov ecx, temp
    mov edx, 1
    int 80h
    pop ebx
    inc ebx
    jmp repeat1
    sto:
    ret
;_________________________________________________________________


put_words:
put:
    pusha
    call put_string
    popa
	pusha
    mov eax, 4
    mov ebx, 1
    mov ecx, c
    mov edx, 1
    int 80h
	popa
    add ebx, 50
    dec word[num]
    cmp word[num], 0
    jne put

    end_put:
    call ent
    ret

;_________________________________________________________________

ent:
    pusha
    mov byte[enter], 10
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    popa
    ret
