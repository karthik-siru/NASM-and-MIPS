section .data
 msg1    : db "enter the number of elements in the array :"
 l1      : equ $-msg1
 msg2    : db "enter the digits :",10
 l2      : equ $-msg2
 msg3    : db "most frequent element :"
 l3      : equ $-msg3
 msg4    : db "least frequent element :"
 l4      : equ $-msg4
 msg5    : db "check"
 l5      : equ $-msg5
 newline : db 10

section .bss
  n     : resd 1
  n1    : resd 1
  num1  : resw 1
  num2  : resd 1
  index : resb 1
  temp  : resb 1
  num   : resw 1
  count : resb 1
  array : resw 50
  freq  : resw 50

section .text
global _start:
_start:

 mov eax , 4
 mov ebx , 1
 mov ecx , msg1
 mov edx , l1
 int 80h

 call read_num

 mov ax , word[num]
 mov word[n] , ax


 mov eax , 4
 mov ebx , 1
 mov ecx , msg2
 mov edx , l2
 int 80h

call read_array

call freq_loop

call largest
call smallest
call exit


freq_loop :
   pusha
   mov ebx , array
   mov edx , 0

cmp_loop_f :
   cmp edx , dword[n]
   je end_f
   mov ax , word[ebx + edx*2]
   mov word[num2], ax
   mov word[num1], dx
   call frequency_count
   inc edx
   jmp  cmp_loop_f

end_f :
   popa
   ret


; largest in the freq array ::

largest :

    pusha
    mov ebx , freq
    mov edx , 1
    mov ax , word[ebx]
    mov word[num1] , 0
    mov word[num2] , 0

cmp_loop_l :

    cmp edx , dword[n]
    je end_l
    mov ax , word[ebx +2*edx]
    cmp ax, word[num1]
    jae change
    inc edx
    jmp cmp_loop_l

change :

    mov ax , word[ebx +2*edx]
    mov word[num1], ax
    mov word[num2], dx
    inc edx
    jmp cmp_loop_l


end_l :

    popa

    pusha

    mov eax , 4
    mov ebx , 1
    mov ecx , msg3
    mov edx , l3
    int 80h

    popa

    mov ebx , array
    mov dx, word[num2]
    mov ax , word[ebx + 2*edx]
    mov word[num] , ax
    call print_num

    ret


  ; smallest function from here ::

smallest :

     pusha
     mov ebx , freq
     mov edx , 0
     mov ax  , word[num1]
     mov word[num2] ,0

cmp_loop_s :

     cmp edx , dword[n]
     je end_s
     mov ax , word[ebx +2*edx]
     cmp ax , word[num1]
     jbe change_s
     inc edx
     jmp cmp_loop_s

change_s :

    mov word[num1] , ax
    mov word[num2] , dx
    inc edx
    jmp cmp_loop_s

end_s :

    popa

    mov eax ,4
    mov ebx , 1
    mov ecx , msg4
    mov edx , l4
    int 80h

    mov ebx , array
    mov dx , word[num2]
    mov ax , word[ebx+2*edx]
    mov word[num] , ax
    call print_num

    ret


; this function counts the frequency of all elements and stores them in freq array

; n - size of the array
; num2 - number ,  whose frequency is to count
; num1 - index of the element
; n1   - frequency

frequency_count :
   pusha

   mov edx , 0
   mov ebx , array
   mov cx , word[num2]
   mov word[n1] , 0

cmp_loop_fc :

   cmp edx , dword[n]
   je end_fc
   mov ax , word[ebx + 2*edx ]
   cmp ax , cx
   je increment
   inc edx
   jmp cmp_loop_fc

increment :

   inc word[n1]
   inc edx
   jmp cmp_loop_fc

end_fc :
  popa
  pusha
  mov ax  , word[n1]
  mov dx  , word[num1]
  mov ebx , freq
  mov word[ebx +2*edx] , ax
  popa
  ret


; required functions for reading array and printing multi digit :;;

read_array:
    pusha

    mov ebx,array
    mov eax,0

read_loop:
    cmp eax,dword[n]
    je end_read
    call read_num

    mov cx,word[num]
    mov word[ebx+2*eax],cx
    inc eax

    jmp read_loop


read_num:
    pusha
    mov word[num], 0

loop_read:
    mov eax, 3
    mov ebx, 0
    mov ecx, temp
    mov edx, 1
    int 80h

    cmp byte[temp], 10
    je end_read

    mov ax, word[num]
    mov bx, 10
    mul bx
    mov bl, byte[temp]
    sub bl, 30h
    mov bh, 0
    add ax, bx
    mov word[num], ax

    jmp loop_read

end_read:
    popa
    ret

print_num:

      mov byte[count],0
      pusha

      extract_no:

      cmp word[num], 0
      je print_no
      inc byte[count]
      mov dx, 0
      mov ax, word[num]
      mov bx, 10
      div bx
      push dx
      mov word[num], ax
      jmp extract_no

print_no:

      cmp byte[count], 0
      je end_print
      dec byte[count]
      pop dx
      mov byte[temp], dl
      add byte[temp], 30h
      mov eax, 4
      mov ebx, 1
      mov ecx, temp
      mov edx, 1
      int 80h
      jmp print_no

end_print:

      mov eax,4
      mov ebx,1
      mov ecx,newline
      mov edx,1
      int 80h

      popa
      ret

exit :

     mov eax , 1
     mov ebx , 0
     int 80h
