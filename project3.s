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
    
