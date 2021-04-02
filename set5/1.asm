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
    start : resw 1
    end  : resw 1
    val   : resw 1
    temp_str : resb 50
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

    call modify

;__________________________________________________________________

; exit function

exit:
    mov eax, 1
    mov ebx, 0
    int 80h

;__________________________________________________________________

; This program just prints the stack in the reverse order .  edx - iterator , ecx  - edx*50 , ebx - for printing

 modify :

      pusha
      mov edx , dword[count]
      dec edx

  repeat :
      cmp edx , 0
      je end_modify
      mov  eax , edx
      mov  cl ,50
      mul  cl
      mov  ecx , eax
      pusha
      mov ebx ,stack
      add ebx ,ecx
      call print_string
      popa
      dec edx
      jmp repeat

  end_modify:

      mov ebx , stack
      call print_string

      mov eax , 4
      mov ebx , 1
      mov ecx , newline
      mov edx , 1
      int 80h
      popa
      ret



;__________________________________________________________________

;  Compare the byte and ebx -- string read
;  Here each string is loaded into 50 bytes space and eax+= 50
;  Finally eax contains - starting address of 50 byte space words
;  Count contains No.of words in the given string

extract_word:
    push eax
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
        	add eax, 50
        	push eax
        	inc ebx
        	inc word[count]
        	jmp words
    end_extract:
        	mov byte[eax], 0
        	inc word[count]
        	pop eax
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
