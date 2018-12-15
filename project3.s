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
	
    
