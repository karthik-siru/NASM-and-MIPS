section .data

c   : db "fine",10
l4  : equ $-c
newline : db 10
gap : db " "
l   : equ $-gap
msg1 : db "Longest Strings : " ,10
l1   : equ $-msg1
msg2 : db "Shortest Strings : ",10
l2   : equ $-msg2

;__________________________________________________________________

section .bss
    strg  : resb 50
    strg1 : resb 50
    stack : resb 1000
    temp  : resb 1
    count : resd 1
    strlen: resd 1
    val           : resd 1
    str_len_long  : resw 1
    str_len_short : resw 1
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

    call longest

    call print_longest

    call shortest

    call print_shortest
;__________________________________________________________________

; exit function

exit:
    mov eax, 1
    mov ebx, 0
    int 80h

;__________________________________________________________________

; Let's store the index of the longest and print that at the end

 longest :

      pusha
      mov edx , 1

      pusha
      mov ebx , stack
      call length
      mov ax , word[strlen]
      mov word[str_len_long] , ax
      mov word[val] , 0
      popa

  repeat :

      cmp edx , dword[count]
      je end_longest
      mov  eax , edx
      mov  cl , 50
      mul  cl
      mov  ecx , eax
      pusha
      mov  ebx ,stack
      add  ebx ,ecx
      call length
      popa
      mov ax , word[strlen]
      cmp ax , word[str_len_long]
      ja change
      inc edx
      jmp repeat

  change :

      mov word[str_len_long] , ax
      mov dword[val] , edx
      inc edx
      jmp repeat

  end_longest :

      mov eax , 4
      mov ebx , 1
      mov ecx , msg1
      mov edx , l1
      int 80h

      popa
      ret

;__________________________________________________________________


print_longest :
    pusha

    mov edx , 0
    mov ebx , stack
  loop :

    cmp edx , dword[count]
    je end_pl
    mov  eax , edx
    mov  cl , 50
    mul  cl
    mov  ecx , eax
    pusha
    mov  ebx ,stack
    add  ebx ,ecx
    call length
    popa
    mov ax , word[strlen]
    cmp ax , word[str_len_long]
    je print_pl
    inc edx
    jmp loop

  print_pl :

    mov  eax , edx
    mov  cl , 50
    mul  cl
    mov  ecx , eax
    pusha
    mov  ebx ,stack
    add  ebx ,ecx
    call print_string
    popa
    inc edx
    jmp loop
  end_pl :
    popa
    ret

;__________________________________________________________________

print_shortest :
    pusha

    mov edx , 0
    mov ebx , stack
  loop_s :

    cmp edx , dword[count]
    je end_pl
    mov  eax , edx
    mov  cl , 50
    mul  cl
    mov  ecx , eax
    pusha
    mov  ebx ,stack
    add  ebx ,ecx
    call length
    popa
    mov ax , word[strlen]
    cmp ax , word[str_len_short]
    je print_sl
    inc edx
    jmp loop_s

  print_sl :

    mov  eax , edx
    mov  cl , 50
    mul  cl
    mov  ecx , eax
    pusha
    mov  ebx ,stack
    add  ebx ,ecx
    call print_string
    popa
    inc edx
    jmp loop_s
  end_sl :
    popa
    ret


;__________________________________________________________________
; Let's store the index of the shortest and print that at the end

 shortest :

      pusha
      mov edx , 1

      pusha
      mov ebx , stack
      call length
      mov ax , word[strlen]
      mov word[str_len_short] , ax
      mov word[val] , 0
      popa

  repeat_shortest:

      cmp edx , dword[count]
      je end_shortest
      mov  eax , edx
      mov  cl , 50
      mul  cl
      mov  ecx , eax
      pusha
      mov  ebx ,stack
      add  ebx ,ecx
      call length
      popa
      mov ax , word[strlen]
      cmp ax, word[str_len_short]
      jb  change_shortest
      inc edx
      jmp repeat_shortest

  change_shortest :

      mov word[str_len_short] , ax
      mov dword[val] , edx
      inc edx
      jmp repeat_shortest

  end_shortest :

      mov eax , 4
      mov ebx , 1
      mov ecx , msg2
      mov edx , l2
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

;length of the string :::
; pusha
; mov ebx , string
; popa

 length :
      mov dword[strlen],0
    length_loop:
      cmp byte[ebx],0
      je end_length
      inc dword[strlen]
      inc ebx
      jmp length_loop

   end_length:
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
     mov ecx , newline
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
