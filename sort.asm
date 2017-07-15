
# CS350 Project 2 - Sort It Out!
# Author - Gajjan Jasani
# Date   - 03/15/2016

.data

newline:	.asciiz "\n"	# newline character
space  :	.asciiz " "	# space character
# list array of integers
list:	.word 4,5,7,2,5,9,1,5,6,7

.text
# Procedure: main
# Purpose  : Entry point of the program. Print unsorted list then sorts 
#	     it out by nested procedure and then prints the sorted list
# Registers : Use
# s0	: Save the first element of list
# s1	: Save the last element of list
# a	: Save various addresses and pass arguments
# t	: Temporarily used for different purposes

main:

    la   $a0, list	    # put address of list into $t0
    lw   $s0, 0($a0)	    # save element at index 0 to $s0
    lw   $s1, 36($a0)	    # save element at index 9 to $s1
     
    addi $t1, $zero, 0	    # i = 0 ($t1 = i)
loop_1:			    # print the UNSORTED list
    beq  $t1, 10, exit_loop1    # exit out if i = 10
    sll  $t3, $t1, 2	    # t3 = i*4
    lw   $t2, list($t3)	    # load word at address of t3 into t2
    #print current number
    li   $v0, 1
    move $a0, $t2
    syscall
    #add formatting after each number
    li   $v0, 4
    la   $a0, space
    syscall
    
    addi $t1, $t1, 1	    # i++
    j loop_1		    # keep looping

exit_loop1:

    #print a new line
    li   $v0, 4
    la   $a0, newline
    syscall
    
    la   $a0, list	    # pointer to the list
    li   $a1, 5		    # start
    li   $a2, 10		    # end
    li   $a3, 1		    # offset
    jal  spaced_insertion_sort  # calling the helper procesure
    
    addi $t1, $zero, 0	    # i = 0 ($t1 = i)
loop_2:			    # Print the SORTED list
    beq  $t1, 10, exit_loop2	# exit out if i = 10
    sll  $t3, $t1, 2	    	# t3 = i*4
    lw   $t2, list($t3)	   	# load word at address of t3 into t2
    #print current number
    li   $v0, 1
    move $a0, $t2
    syscall
    #add formatting after each number
    li   $v0, 4
    la   $a0, space
    syscall
    addi $t1, $t1, 1	    # i++
    j loop_2		    # keep looping

exit_loop2:
    #print a new line
    li   $v0, 4
    la   $a0, newline
    syscall
    #print spot_1
    li   $v0, 1
    move $a0, $s0
    syscall
    #print a new line
    li   $v0, 4
    la   $a0, newline
    syscall 
    #print spot_9
    li   $v0, 1
    move $a0, $s1
    syscall
    
    #-------------- End The Program -------------#
    li   $v0, 10          
    syscall
    
#-------------- spaced_insertion_sort function --------------#
# Procedure : spaced_insertion_sort function
# Purpose   : sort the eliments in list
# Register	: Use
# s0		: int current
# s1		: int index
# s3		: int element
# t		: Temporarily used for different purposes

spaced_insertion_sort:	
    # Saveing registers on stack
    add  $sp, $sp, -12	    # Decrement stack pointer by 12
    sw   $ra, 8($sp)   	    # Save $ra to stack
    sw   $s1, 4($sp)   	    # Save $s1 to stack
    sw   $s0, 0($sp)  	    # Save $s0 to stack
    
    add  $s0, $a1, $a3	    # current = start + offset
outer_loop:
    slt  $t0, $s0, $a2	    # t0 = 0 if current < end
    beq  $t0, $zero, exit1  # goto exit1 if current < end
    add  $t5, $s0, $s0	    # t5 = 2 * current
    add  $t5, $t5, $t5	    # t5 = 4 * current
    add  $t5, $a0, $t5	    # t5 = list + (4*current)
    lw   $s3, 0($t5)	    # element = list[current]
    sub  $s1, $s0, $a3	    # index = current - offset
    
inner_loop:
    slt  $t1, $s1, $a1	    # t1 = 1 if index < start
    bne  $t1, 0, exit2      # goto exit2 if index < start
    add  $t5, $s1, $s1	    # t5 = 2 * index
    add  $t5, $t5, $t5	    # t5 = 4 * index
    add  $t5, $a0, $t5	    # t5 = list + (4*index)
    lw   $t6, 0($t5)	    # t6 = list[index]
    slt  $t1, $s3, $t6	    # t1 = 1 if element < list[index]
    bne  $t1, 1, exit2      # goto exit2 if element >= list[index]
    add  $t3, $s1, $a3	    # t3 = index + offset
    add  $t3, $t3, $t3	    # t3 = 2 * (index+offset)
    add  $t3, $t3, $t3	    # t3 = 4 * (index+offset)
    add  $t3, $a0, $t3	    # t3 = list + 4*(index+offset)
    sw   $t6, 0($t3)	    # list[index + offset] = list[index]
    sub  $s1, $s1, $a3	    # index = index - offset
    j    inner_loop	    # continue looping in the inner_loop
    
exit2:
    add  $t3, $zero, 0	    # t3 = 0
    add  $t3, $s1, $a3	    # t3 = index + offset
    add  $t3, $t3, $t3	    # t3 = 2 * (index+offset)
    add  $t3, $t3, $t3	    # t3 = 4 * (index+offset)
    add  $t3, $a0, $t3	    # t3 = list + 4*(index+offset)
    sw   $s3, 0($t3)	    # list[index + offset] = element
    add  $s0, $s0, $a3	    # current = current + offset   
    j    outer_loop	    # continue looping in the outer_loop
    
exit1:
    # Restoring registers from stack
    lw   $s0, 0($sp)	    # Restore value of $s0 from stack
    lw   $s1, 4($sp)	    # Restore value of $s1 from stack
    lw   $ra, 8($sp)	    # Restore value of $ra from stack
    addi $sp, $sp, 12	    # Increment stack pointer by 12

    jr   $ra
