section .data

   msg1 : db "input the string :"
   l1   : equ $-msg1
   newline : db 10

;__________________________________________________________________

section .bss

  string : resb 50
  temp   : resb 1
  len    : resd 1

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
  call reverse
  call print_string
  call exit
;__________________________________________________________________

; reverse function

reverse :
  pusha
  mov ebx ,string
  mov ecx ,dword[len]
  mov edx , 0

  cmp edx , ecx
  je exit

  dec ecx

  reverse_loop :
      cmp edx , ecx
      jae end_reverse
      mov al , byte[ebx +edx]
      mov ah , byte[ebx +ecx]
      mov byte[ebx + edx] ,ah
      mov byte[ebx + ecx] ,al
      inc edx
      dec ecx
      jmp reverse_loop

  end_reverse :
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

  exit :

     mov eax , 1
     mov ebx , 0
     int 80h
