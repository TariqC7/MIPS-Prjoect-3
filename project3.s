.data
    noInput: .asciiz "Input is empty." #String with an empty input
    tooLong: .asciiz "Input it is too long." #String that has more than 4 characters
    invalidInput: .asciiz "Invalid base-35 number." #String that includes one or more characters not in set
    userInput: .space 1000
.text
    main:
	
	#stores address of string
        li $v0, 8 
        la $a0, userInput 
	li $a1, 1000 
        syscall
        add $t0, $0, 0 #initialize $t0 register
        add $t1, $0, 0 #initialize $t1 register
	
	#Doing a check for an empty string
        la $t2, userInput 
        lb $t0, 0($t2)
        beq $t0, 10, isEmpty 
        beq $t0, 0 isEmpty
	
	#storing the Base-N number and iniializing new registers
	addi $s0, $0, 35 
        addi $t3, $0, 1 
        addi $t4, $0, 0
        addi $t5, $0, 0
	
	ignoreSpaces:
            lb $t0, 0($t2) #load address in $t2 to $t0
            addi $t2, $t2, 1 #Increment pointer
            addi $t1, $t1, 1 #Increment counter
            beq $t0, 32, ignoreSpaces #Jump to ignoreSpaces branch if equal
	    beq $t0, 10, isEmpty #Jump to isEmpty branch if equal
            beq $t0, $0, isEmpty #Jump to isEmpty branch if equal
            
	checkCharacters:
            lb $t0, 0($t2)
            addi $t2, $t2, 1
            addi $t1, $t1, 1
            beq $t0, 10, restart
	    beq $t0, 0, restart
            bne $t0, 32, checkCharacters
	    
	 checkRemainder:
            lb $t0, 0($t2)
            addi $t2, $t2, 1
            addi $t1, $t1, 1
            beq $t0, 10, restart
	    beq $t0, 0, restart
            bne $t0, 32, isInvalid #jump to isInvalid branch if not equal
            j checkRemainder
	    
	 restart:
            sub $t2, $t2, $t1 #restart the pointer
            la $t1, 0 #restart the counter
	    
	 continue:
            lb $t0, 0($t2)
            addi $t2, $t2, 1
            beq $t0, 32, continue
            addi $t2, $t2, -1
	    
	 stringLength:
            lb $t0, ($t2)
            addi $t2, $t2, 1
            addi $t1, $t1, 1
            beq $t0, 10, callconversionfunc
	    beq $t0, 0, callconversionfunc
            beq $t0, 32, callconversionfunc
            beq $t1, 5, isTooLong
            j stringLength
	    
	 callconversionfunc:
    		sub $t2, $t2, $t1 #move ptr back to start of string
    		addi $sp, $sp, -4 #allocating memory for stack
    		sw $ra, 0($sp) #only return address
    		move $a0, $t2
		li $a1, 3  
    li $a2, 1 #exponentiated base
    jal DecimalVersion #call to function
    move $a0, $v0 #print result
    li $v0, 1
    syscall
    lw $ra, 0($sp) 
    addi $sp, $sp, 4 #deallocating the memory
    jr $ra
	
	end:
            move $a0, $t5 #move value to $a0
            li $v0, 1 #print value
            syscall
            li $v0, 10 #end
            syscall
