.data

 string   : .space 1024
 stack    : .space 5000
 replace  : .space 100
 new      : .space 100
 prompt_1 : .asciiz "\nInput the string: "
 prompt_2 : .asciiz "\nWord to be replaced: "
 prompt_3 : .asciiz "\nNew Word : "
 result   : .asciiz "\nFinal-String : "
 newline  : .asciiz "\n"
 gap      : .asciiz " "
 f        : .asciiz "what !"

.text

.globl main

main :

  li $v0 , 4
  la $a0 , prompt_1
  syscall

  li $v0 , 8
  la $a0 , string
  li $a1 , 1024
  syscall

  la $t0 , string
  jal remove_nl

  li $v0 , 4
  la $a0 , prompt_2
  syscall

  li $v0 , 8
  la $a0 , replace
  li $a1 , 100
  syscall

  la $t0 , replace
  jal remove_nl

  li $v0 , 4
  la $a0 , prompt_3
  syscall

  li $v0 , 8
  la $a0 , new
  li $a1 , 100
  syscall

  la $t0 , new
  jal remove_nl

#_____________________________________________________________

  la $s0 , string
  la $s1 , stack
  li $s3 , ' '
  li $s4 , '\n'
  add $s5 , $zero ,$zero

  extract_words :
   move $t0 , $s1

   words_loop :
    lb $t1 , 0($s0)
    beq $t1 , $s3 , end_loop
    beqz $t1 , end_loop_words
    sb $t1 ,($s1)
    addi $s0 , $s0 , 1
    addi $s1 , $s1 , 1
    j words_loop

   end_loop:
    addi $s5 , $s5 , 1
    sb $zero ,($s1)
    move $s1 , $t0
    addi $s0 , $s0 , 1
    addi $s1 , $s1 ,50
    j extract_words

    end_loop_words:
     addi $s5 , $s5 , 1
     sb $zero , ($s1)

    la $s0 , stack
    la $s1 , replace
    li $v0 , 4
    la $a0 , result 
    syscall
#_____________________________________________________________

print_loop :
  move $t3 , $s0
  beqz $s5 , exit

  strcmp :

    lb $t1 , 0($s1)
    beqz $t1 , end_cmp
    lb $t2 , 0($s0)
    beqz $t2 , print_string
    addi $s0 , $s0 , 1
    addi $s1 , $s1 , 1
    bne $t1 , $t2 , print_string
    j strcmp

  print_string:

    addi $s5 , $s5 , -1
    move $s0 , $t3
    move $a0 , $s0
    syscall
    la $a0 , gap
    syscall
    addi $s0 , $s0 , 50
    la $s1 , replace
    j print_loop

  end_cmp :

    addi $s5 , $s5 , -1
    la $a0 , new
    syscall
    la $a0 , gap
    syscall
    move $s0 , $t3
    addi $s0 , $s0 , 50
    la $s1 , replace
    j print_loop

#_____________________________________________________________
remove_nl :
  li  $s0 ,'\n'
  nl_loop :
    lb  $t1 ,0($t0)
    beq $t1 , '\n' , end_nl
    beq $t1 , $zero , end_nl
    addi $t0 , $t0 , 1
    j nl_loop

  end_nl :

   sb $zero, ($t0)
   jr $ra

#_____________________________________________________________
exit :

  li $v0 , 10
  syscall
