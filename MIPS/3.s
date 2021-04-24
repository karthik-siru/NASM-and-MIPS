.data

 s1 : .space 1024
 s2 : .space 1024
 fin : .space 2048
 prompt_1 : .asciiz "\nInput the first string : "
 prompt_2 : .asciiz "\nInput the second string : "
 result   : .asciiz "\nCombined-String : "
 newline : .asciiz "\n"

.text

.globl main

main :

  li $v0, 4
  la $a0 , prompt_1
  syscall

  li $v0 , 8
  la $a0 , s1
  li $a1 , 1024
  syscall

  li $v0 , 4
  la $a0 ,prompt_2
  syscall

  li $v0 , 8
  la $a0 , s2
  li $a1 , 1024
  syscall

  la $s1 , fin
  la $s2 , s1
  la $s3 , s2
  la $t2 , newline
copy_s1 :

  lb   $t0, ($s2)
  beq  $t0, $zero ,copy_s2
  sb   $t0, ($s1)
  addi $s2, $s2, 1
  addi $s1, $s1, 1
  j copy_s1

copy_s2 :
  addi $s1,$s1, -1

copy_s2_loop :

  lb   $t0, ($s3)
  beq  $t0, $zero ,end
  sb   $t0, ($s1)
  addi $s3, $s3, 1
  addi $s1, $s1, 1
  j copy_s2_loop

end :

  la $v0 , 4
  la $a0 , result
  syscall
  la $a0 , fin
  syscall

  la $v0 , 10
  syscall
