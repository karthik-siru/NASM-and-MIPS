.data

  gap :  .asciiz " "
  prompt_1 : .asciiz "\nInput the number : "


.text

.globl main

main :

  add  $t0 , $zero , $zero
  addi $t1 , $zero , 1
  addi $t3 , $zero , 1

  li $v0 , 4
  la $a0 , prompt_1
  syscall
  
  li $v0 , 5
  syscall

  move $t4 , $v0

loop :

  slt $s0 , $t4 , $t3
  bne $s0 , $zero , end
  beq $t3 , 1 , first
  beq $t3 , 2 , second

  add $a0 , $t0 , $t1

  li $v0 , 1
  syscall

  move  $t0 , $t1
  move  $t1 , $a0
  addi $t3 , $t3 , 1

  li $v0 , 4
  la $a0 , gap
  syscall

  j loop

first  :
  li $v0 , 1
  move $a0 , $t0
  syscall
  addi $t3 , $t3 , 1

  li $v0 , 4
  la $a0 , gap
  syscall

  j loop

second :
  li $v0 , 1
  move $a0 , $t1
  syscall
  addi $t3 , $t3 , 1

  li $v0 , 4
  la $a0 , gap
  syscall

  j loop


end :
  li $v0 , 10
  syscall
