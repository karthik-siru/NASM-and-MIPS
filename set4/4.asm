section .data

   msg1 : db "input the string :"
   l1   : equ $-msg1
   ipt2 : db "input the second string :"
   i2   : equ $-ipt2
   msg2 : db "Yes",10
   l2   : equ $-msg2
   msg3 : db "No",10
   l3   : equ $-msg3
   c    : db "check"
   l4   : equ $-c
   newline : db 10

;__________________________________________________________________

section .bss

  string : resb 50
  string1: resb 50
  temp   : resb 1
  len    : resb 1
  len1   : resb 1
;__________________________________________________________________

section .text
global _start:
_start:

  mov eax , 4
  mov ebx , 1
  mov ecx , msg1
  mov edx , l1
  int 80h

  call read_string
  mov eax , 4
  mov ebx , 1
  mov ecx , ipt2
  mov edx , i2
  int 80h
  call read_string1
  call length
  call length1
  call compare
  call exit

;______________________________________________________________________

; check function

 compare:
    pusha

    ; check their lengths first ::

    mov al , byte[len]
    cmp al , byte[len1]
    jne no

    mov ebx , string
    mov ecx , string1

  compare_loop:
    cmp byte[ecx],0
    je yes
    mov al , byte[ebx]
    cmp al , byte[ecx]
    jne no
    inc ecx
    inc ebx
    jmp compare_loop

  yes :

     mov eax , 4
     mov ebx , 1
     mov ecx , msg2
     mov edx , l2
     int 80h
     popa
     ret

  no :
    mov eax , 4
    mov ebx , 1
    mov ecx , msg3
    mov edx , l3
    int 80h
    popa
    ret

;__________________________________________________________________

; length of the second string

 length1 :
    pusha
    mov ebx,string1
    mov dword[len1],0
  length_loop_1:
    cmp byte[ebx],0
    je end_length_1
    inc dword[len1]
    inc ebx
    jmp length_loop_1

  end_length_1:
    popa
    ret


 ;length of the string :::

  length :
     pusha
     mov ebx,string
     mov dword[len],0
 length_loop:
    cmp byte[ebx],0
    je end_length
    inc dword[len]
    inc ebx
    jmp length_loop

 end_length:
    popa
    ret

;__________________________________________________________________
; reading the string

  read_string1:
     pusha
     mov ebx , string1
     jmp reading

  read_string:
	   pusha
	   mov ebx,string
	reading:
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
		jmp reading

	end_read:
		mov byte[ebx],0
		popa
		ret

;__________________________________________________________________

  exit :

     mov eax , 1
     mov ebx , 0
     int 80h
