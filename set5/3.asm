section .data
c: db "fine",10
l4: equ $-c
newline : db 10
gap : db " "
l   : equ $-gap

;__________________________________________________________________

section .bss
    strg  : resb 50
    strg1 : resb 50
    stack : resb 1000
    temp  : resb 1
    count : resd 1
    iter  : resd 1
    pointers : resd 20
;__________________________________________________________________

section .text
global _start:
_start:

    pusha
    mov ebx, strg
    call read_string
    popa

    mov eax, stack
    mov ebx, strg
    mov word[count], 0

    call extract_word

    mov ecx , 0
    call sort1

;_________________________________________________________________

; exit function

exit:

    mov eax , 4
    mov ebx , 1
    mov ecx , newline
    mov edx , 1
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h

;__________________________________________________________________

;  Compare the byte and ebx -- string read
;  Here each string is loaded into 50 bytes space and eax+= 50
;  Finally eax contains - starting address of 50 byte space words
;  Count contains No.of words in the given string

extract_word:
    push eax
    mov edx , pointers
    mov dword[edx] , eax
    add edx , 4
    words:
        	mov cl, byte[ebx]
        	mov byte[eax], cl
        	inc eax
        	inc ebx
        	cmp byte[ebx], ' '
        	je space
        	cmp byte[ebx], 0
        	je end_extract
        	jmp words
    space:
        	mov byte[eax], 0
        	pop eax
        	add eax , 50
        	push eax
        	inc ebx
          mov dword[edx] , eax
          add edx , 4
        	inc word[count]
        	jmp words
    end_extract:
        	mov byte[eax], 0
          mov dword[edx],eax
        	inc word[count]
        	pop eax
        	ret

;__________________________________________________________________

;  sort the strings ,

sort1:
    cmp cx, word[count]
    je exit1
    mov edx, 0
    mov ebx, pointers
sort2:
    mov ax, word[count]
    sub ax, cx
    dec ax
    cmp dx, ax
    je exit2
    call strcmp
    add ebx, 4
    inc edx
    jmp sort2
exit2:
    inc ecx
    jmp sort1
exit1:

    mov word[iter] , 0
    mov edx, pointers
    mov eax, 0
  printstrings:
        mov ax, word[count]
        cmp ax, word[iter]
        je exit

        pusha
        mov ebx, dword[edx]
        call print_string
        popa
        add edx, 4
        inc word[iter]
        jmp printstrings


;__________________________________________________________________

; String Comparision function - swaps eax , and ebx if not equal

strcmp:
        pusha
        mov eax, dword[ebx]
        mov ecx, dword[ebx+4]
    compare:
        cmp byte[eax], 0
        je noswap
        cmp byte[ecx], 0
        je swap

        mov dl, byte[eax]
        cmp dl, byte[ecx]
        ja swap
        jb noswap
        inc eax
        inc ecx
        jmp compare
    swap:
        mov eax, dword[ebx]
        mov ecx, dword[ebx+4]
        mov dword[ebx], ecx
        mov dword[ebx+4], eax
        jmp exit_func
    noswap:
        jmp  exit_func

    exit_func:
  		popa
  		ret
;__________________________________________________________________
; Reads the string

read_string:

       push ebx
       mov eax,3
       mov ebx,0
       mov ecx,temp
       mov edx,1
       int 80h
       pop ebx

       cmp byte[temp],10
       je end_read

       mov al,byte[temp]
       mov byte[ebx],al
       inc ebx
       jmp read_string

end_read:
      mov byte[ebx],0
      ret

;__________________________________________________________________

; Prints the string , with enter character

print_string:

     cmp byte[ebx],0
     je  end_print
     mov al,byte[ebx]
     mov byte[temp],al
     pusha
     mov eax,4
     mov ebx,1
     mov ecx,temp
     mov edx,1
     int 80h
     popa
     inc ebx
     jmp print_string

end_print:

     mov eax , 4
     mov ebx , 1
     mov ecx , gap
     mov edx , 1
     int 80h
     ret

;__________________________________________________________________


; This is a check function , it is similar to printing something while finding the bugs

is_it_working:
          pusha

          mov eax , 4
          mov ebx , 1
          mov ecx , c
          mov edx , l4
          int 80h

          popa
          ret
;__________________________________________________________________
