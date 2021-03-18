section .data

   msg1 : db "input the first string :"
   l1   : equ $-msg1
   msg2 : db "input the second string :"
   l2   : equ $-msg2
   newline : db 10
   c : db "check"
   l4 : equ $-c

;__________________________________________________________________

section .bss

  string  : resb 50
  string2 : resb 50
  temp    : resb 1
  len     : resd 1

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
  mov ecx , msg2
  mov edx , l2
  int 80h

  call read_string2
  call length
  call concatenate

;__________________________________________________________________

; concatenate string

 concatenate:

     mov ebx, string
     mov ecx, dword[len]
     mov edx, string2

   conc_loop :
       cmp byte[edx] , 0
       je conc_end
       mov al , byte[edx]
       mov byte[ebx+ecx] ,al
       inc ecx
       inc edx
       jmp conc_loop

   conc_end :
      call print_string
      call exit
;__________________________________________________________________

; reading the string

  read_string2:
     pusha
     mov ebx , string2
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

;function to print the read_string

   print_string:
      	pusha
      	mov ebx,string

      printing:

      		cmp byte[ebx],0
      		je end_print
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
      		jmp printing

      end_print:

          mov eax , 4
          mov ebx , 1
          mov ecx , newline
          mov edx , 1
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

  exit :

     mov eax , 1
     mov ebx , 0
     int 80h
