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
	    
	 isEmpty:
            la $a0, noInput #loads string/message
            li $v0, 4 #prints string
            syscall

            li $v0, 10 #end of program
	    syscall
	    
	    isTooLong:
            la $a0, tooLong #loads string/message
            li $v0, 4 #prints string
            syscall

            li $v0, 10 #end of program
	    syscall
	    
	    isInvalid:
            la $a0, invalidInput #loads string/message
            li $v0, 4 #prints string
            syscall

            li $v0, 10 #end of program
	    syscall
	    
	    jr $ra

DecimalVersion:
    addi $sp, $sp, -8 #allocating memory for stack
    sw $ra, 0($sp) #storing return address
    sw $s3, 4($sp) #storing s register so it is not overwritten
    beq $a1, $0, return_zero #base case
    addi $a1, $a1, -1 #length - 1, so to start at end of string
    add $t0, $a0, $a1 #getting address of the last byte 
    lb $s3, 0($t0)  #loading the byte ^
    #INSERT THE CODE TO CONVERT BYTE TO DIGIT
    #asciiConversions:
            blt $s3, 48, isInvalid #if char is before 0 in ascii table, the input is invalid
	    blt $s3, 58, number
            blt $s3, 65, isInvalid
            blt $s3, 90, upperCase
            blt $s3, 97, isInvalid
            blt $s3, 122, lowerCase
	    blt $s3, 128, isInvalid
	    
    upperCase:
            addi $s3, $s3, -55
            jal More
   lowerCase:
            addi $s3, $s3, -87
            jal More	    
	    
   number:
            addi $s3, $s3, -48
            jal More
    #mul $s3, $s3, $a2 #multiplying the byte x the exponentiated base (starts at 1(35^0 = 1))
    #mul $a2, $a2, 35 #multiplying the exoonentiated base by 35 to get next power (35^1 ...)
    

	   
