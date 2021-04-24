.data

 string   : .space 1024
 newline  : .asciiz "\n"
 prompt_1 : .asciiz "\nInput the string : "
 long     : .asciiz "\nLongest-Word : "
 short    : .asciiz "\nShortest-Word : "

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

  move $t0 , $a0
  add  $t5 , $zero , $zero
  add  $t3 , $zero , $zero
  li   $s0 , ' '
  li   $s1 , '\n'
  add  $t6 , $zero , $zero
  add  $t7 , $zero , $t6
Find_Longest :

    li $v0 , 4
    la $a0 , long
    syscall

    strlen:
        lb   $t1 0($t0)
        beq  $t1  $zero  end_find_longest
        beq  $t1 $s0 end
        addi $t0 $t0 1
        addi $t3 $t3 1
        j strlen

    end:
    addi $t6 , $t6 , 1
    bge  $t3 $t5 exchange
    addi $t0 , $t0 , 1
    add  $t3 , $zero , $zero
    j strlen

    exchange :
       add  $t7 , $zero , $t6
       add  $t5 , $t3 , $zero
       addi $t0 , $t0 , 1
       add  $t3 , $zero , $zero
       j strlen

  end_find_longest :
     addi $t3 , $t3, -1
     bge  $t5 $t3 Print_longest
     add  $t5 , $t3 , $zero
     addi  $t7 , $t7 , 1


  Print_longest :

    la  $t0 , string
    addi $t2, $zero , 1

    print_loop :

     beq  $t2 , $t7 print_string
     lb   $t1 , 0($t0)
     beq  $t1 ,$s0 , increase
     addi $t0 , $t0 , 1
     j print_loop

    increase :
     addi $t2 , $t2,1
     addi $t0 , $t0 , 1
     j print_loop

     print_string:

      li  $v0, 11
      lb  $t1  , 0($t0)
      beq $t1 , $s0   Find_Shortest
      beq $t1 , $s1   Find_Shortest
      beq $t1 , $zero Find_Shortest
      move $a0 , $t1
      syscall
      addi $t0 , $t0 , 1
      j print_string


#_______________________________________________________________


     Find_Shortest :

         la   $t0 , string
         addi $t5 , $zero , 200
         add  $t3 , $zero , $zero
         li   $s0 , ' '
         li   $s1 , '\n'
         add  $t6 , $zero , $zero
         add  $t7 , $zero , $zero

         li $v0 , 4
         la $a0 , newline
         syscall

         li $v0 , 4
         la $a0 , short
         syscall

       strlen_s:
           lb   $t1 0($t0)
           beq  $t1 $zero  end_find_shortest
           beq  $t1 $s0 end_s
           addi $t0 $t0 1
           addi $t3 $t3 1
           j strlen_s

       end_s:
       addi $t6 , $t6 , 1
       ble  $t3 $t5 exchange_s
       addi $t0 , $t0 , 1
       add  $t3 , $zero , $zero
       j strlen_s

       exchange_s :
          add  $t7 , $zero , $t6
          add  $t5 , $t3 , $zero
          addi $t0 , $t0 , 1
          add  $t3 , $zero , $zero
          j strlen_s

     end_find_shortest :
        addi $t3 , $t3, -1
        ble  $t5 $t3 Print_Shortest
        add  $t5 , $t3 , $zero
        addi  $t7 , $t7 , 1


     Print_Shortest :

       la  $t0 , string
       addi $t2, $zero , 1

       print_loop_s :

        beq  $t2 , $t7 print_string_s
        lb   $t1 , 0($t0)
        beq  $t1 ,$s0 , increase_s
        addi $t0 , $t0 , 1
        j print_loop_s

       increase_s :
        addi $t2 , $t2,1
        addi $t0 , $t0 , 1
        j print_loop_s

        print_string_s:

         li  $v0, 11
         lb  $t1  , 0($t0)
         beq $t1 , $s0 exit
         beq $t1 , $s1 exit
         beq $t1 , $zero exit
         move $a0 , $t1
         syscall
         addi $t0 , $t0 , 1
         j print_string_s

     exit :

        li $v0 , 10
        syscall
