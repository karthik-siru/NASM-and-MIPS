.data

  newline         :  .asciiz "\n"
  prompt_1        :  .asciiz "\nFirst-Number : "
  prompt_2        :  .asciiz "\nSecond-Number: "
  twin_primes     :  .asciiz "\nTwin Primes\n"
  not_twin_primes :  .asciiz "\nNot Twin Primes\n"

.text

.globl main

main :

#___________________________________________________________________

# Reading the input numbers

  li $v0 , 4
  la $a0 , prompt_1
  syscall

  li $v0 , 5
  syscall
  move $t0 , $v0

  li $v0 , 4
  la $a0 , prompt_2
  syscall

  li $v0 , 5
  syscall
  move $t1 , $v0

#___________________________________________________________________

#Check whether the given two inputs are prime numbers

  move $a0 , $t0
  add $v0 , $zero ,$zero
  jal prime
  beq $v0 , $zero , no

  move $a0 , $t1
  add $v0 , $zero ,$zero
  jal prime
  beq $v0 , $zero , no

#___________________________________________________________________

# Subtract the smaller one from bigger one and compares it with 2 .

  slt $s1 , $t1 ,$t0
  beq $s1 , 1 , first

  sub $t1, $t1 , $t0
  beq $t1 , 2 , yes
  j no

first :
  sub $t0 , $t0 , $t1
  beq $t0 , 2  , yes

  j no


#___________________________________________________________________


prime :

     addi $t2 , $zero, 3
     slt  $s1 , $a0 , $t2
     beq  $s1 , 1 ,no_prime
     addi $t3 , $zero , 3      # t3 is the iterator

   loop :

     beq  $t3 , $a0 , yes_prime
     div  $a0 , $t3
     mfhi $s2
     beq  $s2 , $zero , no_prime
     addi $t3 , $t3 , 1
     j loop

   yes_prime:
     addi $v0 , $zero , 1
     jr $ra

   no_prime :
     addi $v0 , $zero , 0
     jr $ra

#___________________________________________________________________

yes :
  li $v0 , 4
  la $a0 , twin_primes
  syscall
  j exit

no  :
  li $v0 , 4
  la $a0 , not_twin_primes
  syscall

exit :

 li $v0 , 10
 syscall
