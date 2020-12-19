# Gabriello Lima
# glima
# 112803276

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

############################## Do not .include any files! #############################

.text
strlen:
	move $t0, $a0 #t0 now holds the address of string
	#la $t0, str #t0 now holds the address of string
	li $t1, '\0'
	li $t3, 0
	counting_string_length_loop:
	lb $t2, 0($t0) #loads a byte in the string
	beq $t1, $t2, after_strlen_loop
	addi $t3, $t3, 1 #increments t3 by one. T3 is the counter for str length.
	addi $t0, $t0, 1 #increments the index we're accessing in the string by one.
	j counting_string_length_loop
	after_strlen_loop:
		move $v0, $t3 #v0 now contains the string length that was in t3
    		jr $ra

index_of:
	
	move $t0, $a0 #t0 now stores the address of the inputted string
	move $t1, $a1 #t1 now stores the character we're looking for
	move $t2, $a2 #t2 now stores the start index
	bltz $t2, bad_return_index
	
	addi $sp, $sp, -16 #makes space to store the ra, temp values
	sw $ra, 0($sp) #saves ra on the stack
	sw $t2, 4($sp) #saves t2 on the stack
	sw $t1, 8($sp) #saves t1 on the stack
	sw $t0, 12($sp) #saves t0 on the stack
	jal strlen #get the string length
	move $t3, $v0 #stores the string length in t3
	lw $ra, 0($sp) #grabs ra from the stack
	lw $t2, 4($sp) #loads t2 from the stack
	lw $t1, 8($sp) #loads t1 from the stack
	lw $t0, 12($sp) #loads t0 from the stack
	addi $sp, $sp, 16 #deallocates the stack
	
	bgt $t2, $t3, bad_return_index #if the start index is greater than the string length its bad
	add $t0, $t0, $t2 #adds the starting index to the address of the string if its valid
	li $t5, '\0' #null terminating value
	finding_index_of_char:
	lb $t4, 0($t0) #t4 now grabs a character from the string
	beq $t4, $t1, good_return_index
	beq $t4, $t5, bad_return_index #if t4 is equal to the null terminated string we haven't found our character
	addi $t2, $t2, 1 #increments the index we're at by 1
	addi $t0, $t0, 1 #increments the character index of the string we're accessing by 1
	j finding_index_of_char
	bad_return_index:
		li $v0, -1 
		jr $ra
	
	good_return_index:
		move $v0, $t2
    		jr $ra

to_lowercase:
	move $t0, $a0 #t0 now stores the address of the inputted string

	li $t1, '\0'
	li $t3, 0 #counter
	li $t4, 'Z' #t4 = Z
	addi $t4, $t4, 1 
	to_lower_case_loop:
		lb $t2, 0($t0) #loads a byte in the string
		beq $t1, $t2, after_to_lowercase #if its a null terminated value then the strings over
		blt $t2, $t4, check_lower_bound#if its less than character after Z... its COULD be uppercase
		after_convert_lower_case:
			#t0 should now store the lowercase value
			addi $t0, $t0, 1 #increments the index we're accessing in the string by one.
			j to_lower_case_loop
	
	check_lower_bound:
		li $t5, 'A' #t5 = A
		addi $t5, $t5, -1
		bgt $t2, $t5, convert_to_lower_case
		j after_convert_lower_case
	
	convert_to_lower_case:
		addi $t3, $t3, 1 #increments t3 by one. T3 is the counter for how many we converted to lower case.
		addi $t2, $t2, 32
		sb $t2, 0($t0)
		#increment counter by 1
		j after_convert_lower_case
	
	after_to_lowercase:
	move $v0, $t3 #v0 now stores the number of uppercase characters we converted to lowercase
   	 jr $ra
	
generate_ciphertext_alphabet:
	#make space on the stack for s0-s3
	#make sp world aligned if its not already...
	#li $t1, 4
	#div $sp, $t1
	#mflo $sp
	#mfhi $t2
	#mul $sp, $sp, $t1
	#sub $t2, $t1, $t2
	#add $sp, $sp, $t2
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)

	move $t0, $a0 #t0 now stores the pos of the 63 bits saved for a0
	move $t9, $t0 #makes a copy of the base address of t0
	#move $t8, $t0 #makes a copy of the base address of t0
	move $t1, $a1 #t1 now stores the address of the keyphrase
	#lets say t3 stores the length of t0, or the ciphertext we're generating
	li $t6, '\0' #null terminating character
	li $t7, 0 #t7 will keep track of how many unique things we've added 
	li $t4, 0
	
	li $t3, 0
	li $s0, '0'
	li $s1, '9'
	li $s2, 'A'
	li $s3, 'z'
	ciphertext_main_loop:
		sub $t9, $t9, $t4 #make sure t9 always hase the base address
		li $t4, 0 #t4 will be 0 for checking purposes
		lb $t2, 0($t1) #t2 stores the character we're attempting to add
		beq $t2, $t6, finished_adding_keyphrase #if its a terminating character, we've finished the keyphrase
		#if t2 is less than 0, increment t1 call main loop
		blt $t2, $s0, go_next_character_cipher
		bgt $t2, $s3, go_next_character_cipher
		bgt $t2, $s1, potential_character_violation
		j check_if_already_added
		
		go_next_character_cipher:
			addi $t1, $t1, 1
			j ciphertext_main_loop
		potential_character_violation:
			blt $t2, $s2, go_next_character_cipher
		j check_if_already_added
		
		
		#move $t9, $t8
		
		
		
		j check_if_already_added
	
	add_to_ciphertext:
		sb $t2, 0($t0) #adds the character
		#printing for testing purpsoes 
		#move $a0, $t2
		#li $v0, 11
		#syscall
		addi $t0, $t0, 1 #increment t0 to make space for next character to add
		addi $t1, $t1, 1 #increment the character we're grabbing by 1
		addi $t7, $t7, 1 #increments t7 by one
		addi $t3, $t3, 1 #increments t3 by one
		j ciphertext_main_loop
		#have to keep track of how many unique things we added
	dont_add_to_ciphertext:
		addi $t1, $t1, 1 #increment the character we're grabbing by 1
		j ciphertext_main_loop
	
	check_if_already_added:
		lb $t5, 0($t9) #load the byte starting from the base address
		beqz $t3, add_to_ciphertext
		#if its ' ' dont add
		li $t8, ' '
		beq $t2, $t8, dont_add_to_ciphertext
		beq $t2, $t5, dont_add_to_ciphertext #if the characters are the same, dont add them
		addi $t4, $t4, 1
		addi $t9, $t9, 1 #increment the index we're accessing by one
		bne $t3, $t4, check_if_already_added #t3 = length, t4 = index of iteration
		#beq $t4, $t3, check_if_already_added
		#else if they're not the same, go through the entire loop
		#if the entire loop was traveresed, theres no matching character, add.
	j add_to_ciphertext
	
	finished_adding_keyphrase:
	j store_unique_count #stores the valu e of t7 in v0 for later purposes
	#now store in t0 the alphabet
	
	add_lowercase:
	li $t1, 'a' #first letter of lowercase alphabet
	#remeber we're adding onto t2
	add_lowercase_main_loop:
		sub $t9, $t9, $t4
		li $t4, 0
	check_if_already_added_lowercase:
		lb $t5, 0($t9) #load the byte starting from the base address
		beq $t1, $t5, dont_add_to_ciphertext_lowercase #if the characters are the same, dont add them
		addi $t4, $t4, 1
		addi $t9, $t9, 1 #increment the index we're accessing by one
		bne $t3, $t4, check_if_already_added_lowercase #t3 = length, t4 = index of iteration
		j add_to_cipher_text_lowercase
	
	dont_add_to_ciphertext_lowercase:
		addi $t1, $t1, 1
		li $t7, 'z'
		bgt $t1, $t7, finished_adding_lowercase
		j add_lowercase_main_loop
	add_to_cipher_text_lowercase:
		sb $t1, 0($t0) #adds the character
		addi $t0, $t0, 1 #increment address by 1
		addi $t1, $t1, 1
		addi $t3, $t3, 1
		li $t7, 'z'
		bgt $t1, $t7, finished_adding_lowercase
		j add_lowercase_main_loop
	
	li $t6, '|' #terminating character
	j ciphertext_main_loop
	finished_adding_lowercase:
	add_uppercase:
	li $t1, 'A' #first letter of lowercase alphabet
	#remeber we're adding onto t2
	add_uppercase_main_loop:
		sub $t9, $t9, $t4
		li $t4, 0
	check_if_already_added_uppercase:
		lb $t5, 0($t9) #load the byte starting from the base address
		beq $t1, $t5, dont_add_to_ciphertext_uppercase #if the characters are the same, dont add them
		addi $t4, $t4, 1
		addi $t9, $t9, 1 #increment the index we're accessing by one
		bne $t3, $t4, check_if_already_added_uppercase #t3 = length, t4 = index of iteration
		j add_to_cipher_text_uppercase
	
	dont_add_to_ciphertext_uppercase:
		addi $t1, $t1, 1
		li $t7, 'Z'
		bgt $t1, $t7, finished_adding_uppercase
		j add_uppercase_main_loop
	add_to_cipher_text_uppercase:
		sb $t1, 0($t0) #adds the character
		addi $t0, $t0, 1 #increment address by 1
		addi $t1, $t1, 1
		addi $t3, $t3, 1
		li $t7, 'Z'
		bgt $t1, $t7, finished_adding_uppercase
		j add_uppercase_main_loop
		
		
		
		
		
		
		
	finished_adding_uppercase:
		add_digits:
	li $t1, '0' #first letter of lowercase alphabet
	#remeber we're adding onto t2
	add_digits_main_loop:
		sub $t9, $t9, $t4
		li $t4, 0
	check_if_already_added_digits:
		lb $t5, 0($t9) #load the byte starting from the base address
		beq $t1, $t5, dont_add_to_ciphertext_digits #if the characters are the same, dont add them
		addi $t4, $t4, 1
		addi $t9, $t9, 1 #increment the index we're accessing by one
		bne $t3, $t4, check_if_already_added_digits #t3 = length, t4 = index of iteration
		j add_to_cipher_text_digits
	
	dont_add_to_ciphertext_digits:
		addi $t1, $t1, 1
		li $t7, 'Z'
		bgt $t1, $t7, finished_adding_digits
		j add_digits_main_loop
	add_to_cipher_text_digits:
		sb $t1, 0($t0) #adds the character
		addi $t0, $t0, 1 #increment address by 1
		addi $t1, $t1, 1
		addi $t3, $t3, 1
		li $t7, '9'
		bgt $t1, $t7, finished_adding_digits
		j add_digits_main_loop
	
	store_unique_count:
	move $v0, $t7 #stores t7 in v0
	j add_lowercase
	
	finished_adding_digits:
	
	
		#make space on the stack for s0-s3
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16 #deallocate the stack
	
    		jr $ra

count_lowercase_letters:
	move $t0, $a0 #t0 now stores the address of Counts[0]. Increment by 4 to access the next iteration.
	move $t1, $a1 #t1 now stores the address of the message. Increment by 1 to access the next character.
	#initialize with zeros
	li $t2, 0 #t2 = 0
	li $t3, 0 #t3 = 0 for counting purposes
	li $t4, 26 #t4 = 26
	initialize_counts_with_zero:
		sw $t2, 0($t0)
		addi $t0, $t0, 4 #gets the next counts[i]
		addi $t3, $t3, 1 #increments t3 by 1
		blt $t3, $t4, initialize_counts_with_zero #less than 26
		#beq $t3, $t4, initialize_counts_with_zero #26
		j after_initialize_count_with_zeros
		
	after_initialize_count_with_zeros:	
		move $t0, $a0 #t0 now stores the address of Counts[0]. Increment by 4 to access the next iteration.
		li $t2, 'a'
		li $t3, 'z'
		li $t4, '\0' #null terminating character
		li $t9, 0 #will keep track of the total number we add
		j main_counting_loop
	main_counting_loop:
		move $t0, $a0 #t0 now stores the address of Counts[0]. Increment by 4 to access the next iteration.
		lb $t5, 0($t1) #get the ith character from $t1
		addi $t1, $t1, 1 #increment t1 by 1
		beq $t5, $t4, end_of_message #if its the null terminating character, end the counting loop
		bge $t5, $t2, lower_bound_confirmed_counts #if the character is >= a then check its upperbound
		j main_counting_loop
		#if it makes it here... go next character in string
		
		
		lower_bound_confirmed_counts:
			ble $t5, $t3, upper_bound_confirmed_counts #if the character <= z then its a lowercase character
			j main_counting_loop
			#if it makes it here... go next character
		
		upper_bound_confirmed_counts:
			li $t6, 97
			sub $t5, $t5, $t6 #decrement the ascii value by 97 to get its position in the array
			li $t6, 4
			mul $t5, $t5, $t6 #multiply by four to get 4 bytes
			add $t0, $t0, $t5 #move the address to the position
			lw $t6, 0($t0) #load the count at that position
			addi $t6, $t6, 1 #increment the count by 1
			sw $t6, 0($t0) #stores incremented value again
			addi $t9, $t9, 1 #increments it so we can return this value in v0. LOOK UP for def.
			j main_counting_loop
		
		
	end_of_message:	
		move $v0, $t9
    		jr $ra

sort_alphabet_by_count:
	move $t0, $a0 #string for sorted alphabet
	move $t1, $a1 #int[] counts is stored in t1
	li $t9, 0 #will keep track of the total number of times we did this massive loop
	find_highest_count_start:
		li $t2, 0
		li $t4, 0
		li $t5, 26
		highest_count_main_loop:
			lw $t3, 0($t1) #get the array at pos i
			addi $t1, $t1, 4 #get the next pos in the array
			bgt $t3, $t2, greater_than_count_case
			j not_greater_than_count_case
			greater_than_count_case:
				move $t2, $t3 #t2 now stores the highest value
			not_greater_than_count_case:
				addi $t4, $t4, 1 #increment t4 by 1 for counting purposes
				blt $t4, $t5, highest_count_main_loop
				j add_highest_count_to_string
			#if it makes it here, t2 now stores the highest count
	add_highest_count_to_string:
		#find the pos of highest count
		move $t1, $a1 #get the base address of the array
		li $t7, 0
		find_highest_count_pos:
			lw $t3, 0($t1) #get the array at pos i
			beq $t3, $t2, highest_count_found
			addi $t1, $t1, 4 #get the next pos in the array
			addi $t7, $t7, 4 #for math purposes
			j find_highest_count_pos
		
		highest_count_found:
			li $t3, 4
			div $t7, $t3 #divide t7 by t3
			mflo $t7 #t7 stores the remainder of the above operation
			#add $t7, $t7, 'a' #this gives the actual character that was stored in count[]
			addi $t7, $t7, 97
			
			#lets print each character as we add it.
			#move $a0, $t7
			#li $v0, 11
			#syscall
			
			
			
			
			sb $t7, 0($t0) #store it in the string
			addi $t0, $t0, 1 #increment the string by 1 to make space for the next character...
			#now at count negate the value and subtract 1...
			neg $t2, $t2
			addi $t2, $t2, -1
			sw $t2, 0($t1) #stores the negation of the highest number -1 at its respective postion
			move $t1, $a1 #reload the base address of the array
			addi $t9, $t9, 1 #increments the number of times we've done this big loop by 1
			blt $t9, $t5, find_highest_count_start
			#if it makes it here we're done!
			j finished_iterating_through_highest_count_array
    
    finished_iterating_through_highest_count_array:
    		move $t0, $a0 #get the base address of the array
    		#move $v0, $t0
    		jr $ra

generate_plaintext_alphabet:
	move $t0, $a0 #t0 stores the string we're creating
	move $t1, $a1 #t1 stores the sorted alphabet
	li $t2, 'a' #t2 = a
	li $t7, 'z' #t7 = z
	add_to_string_main_loop_plaintext:
	li $t3, 0
	move $t1, $a1 #t1 stores the sorted alphabet
		get_number_of_times_to_add_plaintext:
			li $t4, 8
			lb $t5 0($t1) #t5 stores the character we're grabbing
			addi $t1, $t1, 1 #increase the character we're grabbing by one
			#iterate through the first 8 numbers
			beq $t2, $t5, add_number_of_times_plaintext
			addi $t3, $t3, 1
			blt $t3 $t4, get_number_of_times_to_add_plaintext
			#if its none of the above, set t3 to 7 so it adds ONCE and call 
			li $t3, 8
	j add_number_of_times_plaintext
	
	
	
	add_number_of_times_plaintext: #t3 stores the number of times we should add it (8-t3)
		li $t6, 9
		sub $t3, $t6, $t3 #t3 = 9-t3 this is how many times we add it
		add_number_of_times_main_loop_plaintext:
			sb $t2, 0($t0) #store the character we grabbed
			
			#move $a0, $t2
			#li $v0, 11 #print a character
			#syscall 
			
			
			
			addi $t0, $t0, 1 #increment the string by one to make space for the next char
			addi $t3, $t3, -1 #decrement t3
			bgtz $t3, add_number_of_times_main_loop_plaintext
			#when its equal to 0, increment t2 by one and call add_to_string_main_loop
			addi $t2, $t2, 1 #increment t2 by one each iteration to get the entire alphabet
			bgt $t2, $t7, finished_adding_to_string_plaintext # if t2 or the character we're working with next is > z we're done here
			j add_to_string_main_loop_plaintext
	
	
	finished_adding_to_string_plaintext:
		li $t2, '\0'
		sb $t2, 0($t0)
		#move $t0, $a0
		#move $v0, $t0
   	 	jr $ra

encrypt_letter:
	move $t0, $a0 #t0 holds dthe letter we're looking to encrypt
	move $t1, $a1 #t1 holds the index of the letter we're looking to encrypt
	move $t2, $a2 #t2 holds the plaintext alphabet
	move $t3, $a3 #t3 holds the ciphertext alphabet
						
										
	li $t8, 'z'
	li $t9, 'a'
	li $t7, -1
	bgt $t0, $t8, finished_finding_encrypted_character #this checks upperbound for invalid return
	blt $t0, $t9, finished_finding_encrypted_character #this checks lowerbound for invalid return								
	#iterate through plaintext until the letter is found
	li $t4, -1 #will be X in my equation of x + y = z
	search_through_plaintext:
		lb $t5, 0($t2)
		addi $t2, $t2, 1 #increments the plaintext alphabet by 1
		addi $t4, $t4, 1 #increments the counter by 1
		bne $t5, $t0, search_through_plaintext
		beq $t5, $t0, found_letter_in_plaintext
		
	found_letter_in_plaintext:
		#current count of it is one, accounted for in count_each_occurence
		li $t6, 0
		count_each_occurence:
			addi $t6, $t6, 1 #increments the counter by 1
			lb $t5, 0($t2)
			addi $t2, $t2, 1
			beq $t5, $t0, count_each_occurence
			bne $t5, $t0, mod_letter_index
			
	mod_letter_index:
		div $t1, $t6
		mfhi $t6
		#addi $t6, $t6, 1										########
		#t6 now stores y, or the second half of the equation
		add $t6, $t4, $t6 #t6 now stores z, or the end result of the equation
		add $t3, $t3, $t6 #this will give us the index of the ciphertext character
		lb $t7, 0($t3) #t7 stores the encryped character
		j finished_finding_encrypted_character
		
		finished_finding_encrypted_character:
   		 	move $v0, $t7 #moves the encryped character into v0
   		 	jr $ra
encrypt:
	addi $sp, $sp, -36 #make space on the stack for $ra, and a0-a4
	sw $ra, 0($sp) #stores ra on the stack for later
	sw $s0, 4($sp) #stores s0 on the stack for later
	sw $s1, 8($sp) #stores s1 on the stack for later
	sw $s2, 12($sp) #stores s2 on the stack for later
	sw $s3, 16($sp) #stores s3 on the stack for later
	
	sw $s4, 20($sp) #stores s0 on the stack for later
	sw $s5, 24($sp) #stores s1 on the stack for later
	sw $s6, 28($sp) #stores s2 on the stack for later
	sw $s7, 32($sp) #stores s3 on the stack for later
	
	
	move $s0, $a0 #s0 stores the ciphertext string we're creating						CIPHERTEXR
	move $s1, $a1 #s1 stores the un-encrypted string we're given						PLAINTEXT
	move $s2, $a2 #s2 stores the keyphrase used for encryption (creates the ciphertext alphabet)		KEYPHRASE
	move $s3, $a3 #s3 stores the corpus used to generate the plain text alphabet				CORPUS
	
	#1 call to lowercase on plaintext and corpus
	move $a0, $s1
	jal to_lowercase 
	move $a0, $s3
	jal to_lowercase 
	#2 allocate 26 words of memory on the stack
	addi $sp, $sp, -104 #26 * 4
	#3 Call count_lowercase_letters(counts, corpus) array, message
	move $s4, $sp #saves the address of sp, stores the base of counts[]
	
	#addi $s4, $s4, 104 #get the base address of counts array
	
	move $a0, $s4 #a0 stores the base address of counts
	move $a1, $s3
	jal count_lowercase_letters
	#4 Allocate at least 27 bytes of memory on the stack to store the lowercase_letters string needed in the following step. Be sure to deallocate this memory later.
	addi $sp, $sp, -28 #used to be -27
	move $s5, $sp #s5 stores the base address of lowercase_letters
	li $t7, 'a'
	li $t4, 'z'
	addi $t4, $t4, 1 #increment z to whatever comes after							#t6 was replaced with s5
	add_lowercase_letters_on_stack_loop:
		sb $t7, 0($s5) #store letter on stack
		addi $t7, $t7, 1 #increment letter
		addi $s5, $s5, 1 #increment pos on stack
		blt $t7, $t4, add_lowercase_letters_on_stack_loop #while its less than z, keep adding characters 
		j after_add_lowercase_letters_on_stack_loop
	after_add_lowercase_letters_on_stack_loop:
	addi $s5, $s5, -25 #s5 is back to the base address of lowercase_letters
	#5 Call sort_alphabet_by_count(lowercase_letters, counts).
	move $a0, $s5 #base address of lowercase_letters which is now sorted by count...
	move $a1, $s4
	jal sort_alphabet_by_count #returns in v0 the sorted alphabet
	#move $t1, $v0 #t1 now stores the sorted alphabet
	#6 Allocate at least 63 bytes of memory on the stack to temporarily store the plaintext_alphabet string needed in the following step. Be sure to deallocate this memory later.
	addi $sp, $sp, -64 				#used to be -63
	move $s6, $sp #t2 stores the postion of plaintext_alphabet now						#t2 was replaced with s6
	#7 Call generate_plaintext_alphabet(plaintext_alphabet, lowercase_letters).
	move $a0, $s6 #t2 stores the postion of plaintext_alphabet
	move $a1, $s5 #base address of lowercase letters #move $a1, $t1 #t1 stires the sorted alphabet
	jal generate_plaintext_alphabet
	#8 Allocate at least 63 bytes of memory on the stack to temporarily store the ciphertext_alphabet string needed in the following step. Be sure to deallocate this memory later.
	addi $sp, $sp, -64				#used to be -63
	move $s7, $sp #stores the base address of cipher_text					#t3 is replaced with s7
	#9 Call generate_ciphertext_alphabet(ciphertext_alphabet, keyphrase).
	move $a0, $s7 #allocated memory for ciphertext alphabet
	move $a1, $s2 #keyphrase
	jal generate_ciphertext_alphabet
	
				#print ciphertext...
	#li $t3, '\n'
	#move $a0, $t3
	#li $v0, 11
	#syscall
	#li $t0, 0
	#li $t1, 63
	#print_ciphertext_loop:
	#	lb $t3, 0($s7)
	#	addi $s7, $s7, 1
	#	addi $t0, $t0, 1
	#	move $a0, $t3
	#	li $v0, 11
	#	syscall
	#	blt $t0, $t1, print_ciphertext_loop
	#	li $t3, '\n'
	#	move $a0, $t3
	#	li $v0, 11
	#	syscall
	
	#10 In a loop, call encrypt_letter to encrypt each lowercase letter of plaintext and write the return value into ciphertext. 
		#Each non-lowercase letter of plaintext should not be passed as an argument to encrypt_letter, but should instead simply be copied to ciphertext.
	li $t0, 'z'
	li $t4, 'a'
	li $t1, '\0'
	li $s2, 0 #counts lowercase letters encrypted				#place t2 w/ s2
	li $s3, 0 #counts nonlowercase letters not encryped			#replace t3 w. s3
	li $s4, -1
	encrypt_each_letter_loop:			#replaced all instances of t7 w/ s4
		addi $s4, $s4, 1
		li $t0, 'z'
		li $t4, 'a'
		li $t1, '\0'
		lb $t7, 0($s1)
		#print to test
		#move $a0, $t7
		#li $v0, 11
		#syscall
		
		
		beq $t7, $t1, after_encrypt_each_letter_loop #if its a null terminator end the loop
		blt $t7, $t4, increment_nonlowercase_count #if its less than a add it
		bgt $t7, $t0, increment_nonlowercase_count#if its greater than z merely add it
		#if it's '\0' then
		#int encrypt_letter(char plaintext_letter, int letter_index, string plaintext_alphabet, string ciphertext_alphabet)
		#if it's above 'z' then its not lowercase
		addi $s2, $s2, 1 #increments the count of lowercase letters encrpyed
		move $a0, $t7		#the character (has to be correct if s1 is correct)
		#move $a1, $t8		
		#add $a1, $s2, $s3	#the index of the character (has to be correct)
		
		move $a1, $s4 
		
		#sub $a1, $a1, $s3
		move $a2, $s6		#the base address of plaintext which should be right...
		move $a3, $s7		#the base address of ciphertext which should be right...
		jal  encrypt_letter
		#gonna print the letter we get every time...
		#move $a0, $v0
		#li $v0, 11
		#syscall
		#end print statement
		
		move $t7, $v0 #moves the encryped letter into t7
		add_letter_to_ciphertext_in_loop:
			sb $t7, 0($s0) #saves the character into ciphertext
					#move $a0, $t7
					#li $v0, 11
					#syscall
			addi $s0, $s0, 1 #increment the pos of ciphertext by 1
			addi $s1, $s1, 1 #increment pos of plaintext by 1
			j encrypt_each_letter_loop
		increment_nonlowercase_count:
			addi $s3, $s3, 1 #increments the count of nonlwoercase letters
			j add_letter_to_ciphertext_in_loop
			
			
			
			
	after_encrypt_each_letter_loop:
		sb $t7, 0($s0) #saves the null terminator character into ciphertext
		#store in ciphertext
		move $v0, $s2
		move $v1, $s3
		#deallocate stack and get ra off of it
		addi $sp, $sp, 260 #deallocate until we reach ra  			#used to be 257
		lw $ra, 0($sp) #get old ra off stack
		#restore s values
		lw $s0, 4($sp) 
		lw $s1, 8($sp) 
		lw $s2, 12($sp) 
		lw $s3, 16($sp)
		lw $s4, 20($sp) 
		lw $s5, 24($sp) 
		lw $s6, 28($sp) 
		lw $s7, 32($sp) 
		addi $sp, $sp, 36 #stack is now completely deallocated
    		jr $ra

decrypt:
	addi $sp, $sp, -36 #make space on the stack for $ra, and a0-a4
	sw $ra, 0($sp) #stores ra on the stack for later
	sw $s0, 4($sp) #stores s0 on the stack for later
	sw $s1, 8($sp) #stores s1 on the stack for later
	sw $s2, 12($sp) #stores s2 on the stack for later
	sw $s3, 16($sp) #stores s3 on the stack for later
	
	sw $s4, 20($sp) #stores s0 on the stack for later
	sw $s5, 24($sp) #stores s1 on the stack for later
	sw $s6, 28($sp) #stores s2 on the stack for later
	sw $s7, 32($sp) #stores s3 on the stack for later
	
	
	move $s0, $a0 #s0 stores the plaintext string we're creating						plaintext
	move $s1, $a1 #s1 stores the ciphertext string 	we're given							ciphertext
	move $s2, $a2 #s2 stores the keyphrase used for encryption (creates the ciphertext alphabet)		KEYPHRASE
	move $s3, $a3 #s3 stores the corpus used to generate the plain text alphabet				CORPUS

	
	#1 call to lowercase on and corpus
	move $a0, $s3
	jal to_lowercase 
	#2 allocate 26 words of memory on the stack
	addi $sp, $sp, -104 #26 * 4
	#3 Call count_lowercase_letters(counts, corpus) array, message
	move $s4, $sp #saves the address of sp, stores the base of counts[]
	move $a0, $s4 #a0 stores the base address of counts
	move $a1, $s3 #a1 stores the corupus
	jal count_lowercase_letters
	#4 Allocate at least 27 bytes of memory on the stack to store the lowercase_letters string needed in the following step. Be sure to deallocate this memory later.
	addi $sp, $sp, -28 #used to be -27
	move $s5, $sp #s5 stores the base address of lowercase_letters
	li $t7, 'a'
	li $t4, 'z'
	addi $t4, $t4, 1 #increment z to whatever comes after							#t6 was replaced with s5
	add_lowercase_letters_on_stack_decrypt_loop:
		sb $t7, 0($s5) #store letter on stack
		addi $t7, $t7, 1 #increment letter
		addi $s5, $s5, 1 #increment pos on stack
		blt $t7, $t4, add_lowercase_letters_on_stack_decrypt_loop #while its less than z, keep adding characters 
		j after_add_lowercase_letters_on_stack_decrypt_loop
	after_add_lowercase_letters_on_stack_decrypt_loop:
	addi $s5, $s5, -25 #s5 is back to the base address of lowercase_letters
	#5 Call sort_alphabet_by_count(lowercase_letters, counts).
	move $a0, $s5 #base address of lowercase_letters which is now sorted by count...
	move $a1, $s4
	jal sort_alphabet_by_count #returns in v0 the sorted alphabet
	#move $t1, $v0 #t1 now stores the sorted alphabet
	#6 Allocate at least 63 bytes of memory on the stack to temporarily store the plaintext_alphabet string needed in the following step. Be sure to deallocate this memory later.
	addi $sp, $sp, -64 				#used to be -63
	move $s6, $sp #t2 stores the postion of plaintext_alphabet now						#t2 was replaced with s6
	#7 Call generate_plaintext_alphabet(plaintext_alphabet, lowercase_letters).
	move $a0, $s6 #t2 stores the postion of plaintext_alphabet
	move $a1, $s5 #base address of lowercase letters #move $a1, $t1 #t1 stires the sorted alphabet
	jal generate_plaintext_alphabet
	#8 Allocate at least 63 bytes of memory on the stack to temporarily store the ciphertext_alphabet string needed in the following step. Be sure to deallocate this memory later.
	addi $sp, $sp, -64				#used to be -63
	move $s7, $sp #stores the base address of cipher_text					#t3 is replaced with s7
	#9 Call generate_ciphertext_alphabet(ciphertext_alphabet, keyphrase).
	move $a0, $s7 #allocated memory for ciphertext alphabet
	move $a1, $s2 #keyphrase
	jal generate_ciphertext_alphabet
	
	
	li $t0, 'a'
	li $t1, 'z'
	li $t2, 'A'
	li $t3, 'Z'
	li $t9, '\0'
	li $s4, 0
	li $s5, 0
	decrypt_main_loop: #s1, s0, s7, s6
		li $t8, ' ' 
		li $t0, 'a'
		li $t1, 'z'
		li $t2, 'A'
		li $t3, 'Z'
		li $t9, '\0'
		lb $t4, 0($s1) #grab the encryped character
		beq $t4, $t9, finished_decrypting_ciphertext
		beq $t4, $t8, add_letter_to_plaintext_in_loop
		bgt $t4, $t1, add_letter_to_plaintext_in_loop #if its above z then just add it and go next
		blt $t4, $t2, check_is_digit_upperbound #if its below A check if its a digit. if it is decrypt else add
		bgt $t4, $t3, check_upperbound_of_encrypted#if its greater than Z make sure its less than a
		#if it makes it here just decrypt it!
		#if it made it here its a lowercase letter
		#addi $s4, $s4, 1 #lowercount increment
		j find_position_in_ciphertext_alphabet
		
		check_is_digit_upperbound:
			li $t8, '9'
			#if its less than 9 it can still be a digit
			ble $t4, $t8, check_is_digit_lowerbound
			#else add it
			j add_letter_to_plaintext_in_loop
		check_is_digit_lowerbound:
			li $t8, '0'
			bge $t4, $t8, find_position_in_ciphertext_alphabet #if its a digit decrypt it else add it
			j add_letter_to_plaintext_in_loop
		
		
		add_letter_to_plaintext_in_loop:
		
			sb $t4, 0($s0) #saves the character into plaintext
					#move $a0, $t4
					#li $v0, 11
					#syscall
			addi $s5, $s5, 1 #total count increment
			addi $s0, $s0, 1 #increment the pos of ciphertext by 1
			addi $s1, $s1, 1 #increment pos of plaintext by 1
			j decrypt_main_loop
			
		check_upperbound_of_encrypted:
			blt $t4, $t0, add_letter_to_plaintext_in_loop #if its less than a just add it
			#else j call decrypt...
			
		find_position_in_ciphertext_alphabet:
		addi $s4, $s4, 1 #lowercount increment
		move $t8, $s7 #stores the base address of ciphertext alphabet
			find_position_in_ciphertext_alphabet_loop:
				#s7 holds the base position of the ciphertext alphabet
				lb $t5, 0($s7)
				beq $t4, $t5, found_ciphertext_position #if they're equal we found it
				#else increment ciphertext alphabet and call again
				addi $s7, $s7, 1
				j find_position_in_ciphertext_alphabet_loop
	
	
		found_ciphertext_position:
			sub $t6, $s7, $t8 #the difference between the found position and the base address is the position #, we store it in  t6
			move $s7, $t8 #restore the base position of the ciphertext alphabet
			#s6 stores the position of the plaintext alphabet
			add $t8, $s6, $t6 #base address + position = pos of decrypted character
			lb $t4, 0($t8) #t4 now stores the decrypted character
			j add_letter_to_plaintext_in_loop
		
	finished_decrypting_ciphertext:
		li $t7, '\0'
		sb $t7, 0($s0) #saves the null terminator character into ciphertext
		#store in ciphertext
		move $v0, $s4
		sub $s5, $s5, $s4 
		move $v1, $s5
		#deallocate stack and get ra off of it
		addi $sp, $sp, 260 #deallocate until we reach ra  			#used to be 257
		lw $ra, 0($sp) #get old ra off stack
		#restore s values
		lw $s0, 4($sp) 
		lw $s1, 8($sp) 
		lw $s2, 12($sp) 
		lw $s3, 16($sp)
		lw $s4, 20($sp) 
		lw $s5, 24($sp) 
		lw $s6, 28($sp) 
		lw $s7, 32($sp) 
		addi $sp, $sp, 36 #stack is now completely deallocated
    		jr $ra
    		jr $ra

############################## Do not .include any files! #############################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
