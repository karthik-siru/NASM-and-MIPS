section .data

   msg1 : db "input the string :"
   l1   : equ $-msg1
   msg2 : db "Yes",10
   l2   : equ $-msg2
   msg3 : db "No",10
   l3   : equ $-msg3
   newline : db 10

;__________________________________________________________________

section .bss

  string : resb 50
  temp   : resb 1
  len    : resb 1
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
  call length
  call check
  call exit

;______________________________________________________________________

; check function

check :
  pusha
  mov ebx ,string
  mov ecx ,dword[len]
  mov edx , 0

  cmp edx , ecx
  je yes

  dec ecx

  check_loop :
      cmp edx , ecx
      jae yes
      mov al , byte[ebx +edx]
      mov ah , byte[ebx +ecx]
      cmp al , ah
      jne no
      inc edx
      dec ecx
      jmp check_loop
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
