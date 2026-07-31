#####################################################################
#
# CSCB58 Winter 2022 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Harris Chong, 1007926425, chonghar, harris.chong@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed)
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 512 (update this as needed)
# - Display height in pixels: 512 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1, 2, and 3
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. Health/score - 2 points
# 2. Fail condition - 1 point
# 3. Win condition - 1 point
# 4. Double jump - 1 point
# 5. Pick up effects - 2 points
# 6. Moving platforms - 2 points
#
# Link to video demonstration for final submission:
# - https://www.youtube.com/watch?v=wHPwj4n5NGs&ab_channel=HarrisChong
#
# Are you OK with us sharing the video with people outside course staff?
# - no
#
# Any additional information that the TA needs to know:
# - For the second jump, you can only jump when falling back down from the first jump
# - There may be some glitchy pixel instances when you can fall through the moving platforms
#
#####################################################################
restart:
.eqv BASE_ADDRESS 0x10008000
.eqv CHARACTER 0x1000B908
.eqv HEART 0x1000992C
.eqv JUMP_POWER 0x1000B0B8
.eqv CHANGE_POWER 0x100096C8
.eqv TROPHY 0x100084EC
.eqv PLATFORM 0x86a4ac
.eqv HEART_COLOUR 0xff006f
.eqv JUMP_POWER_COLOUR 0xff600a
.eqv CHANGE_POWER_COLOUR 0x00ffee
.eqv TROPHY_COLOUR 0xcfad25
.eqv PLATFORM_1 0x1000B924
.eqv PLATFORM_2 0x1000A19C
.data
jump_state: .word 0 #0=standing, 1=jumping, 2=falling
jump_counter: .word 0 #keeps track of how high the character is in the jump
num_of_jumps: .word 2 #number of jumps possible
health: .word 3 #health value
jump_power: .word 0 #0=normal jump, 1=higher jump 
change_power: .word 0 #0=red character, 1=cyan
platform_1: .word 0 #keeps track of platform1 position
platform_2: .word 0 #keeps track of platform2 position
.text
li $t0, BASE_ADDRESS # $t0 stores the base address for display
li $s7, CHARACTER #$s7 stores base address for character (top left pixel)
li $s6, HEART #$s6 stores base address for heart (top left pixel)
li $s5, TROPHY #$s5 stores base address for trophy (top left pixel)
li $s4, JUMP_POWER #$s4 stores base address for jump power (top left pixel)
li $s3, CHANGE_POWER #$s3 stores base address for change power (top left pixel)
li $s2, PLATFORM_1 #$s2 stores base address for platform1 (top left pixel)
li $s1, PLATFORM_2 #$s1 stores base address for platform2 (top left pixel)
li $t1, 0xff0000 # $t1 stores the red colour code
li $t2, 0xffffff # $t2 stores the white colour code
li $t3, 0x3c4a4a # $t3 stores background colour

#Drawing background, platforms, and objects before main loop
jal draw_background

draw_change_power:
	li $t1, 0x00ffee
	li $t2, 0xffffff
	
	sw $t1, 4($s3) 
	sw $t1, 256($s3) 
	sw $t2, 260($s3)
	sw $t1, 264($s3)
	sw $t1, 512($s3)
	sw $t1, 516($s3)
	sw $t1, 520($s3)
	sw $t1, 768($s3)
	sw $t1, 776($s3)

draw_jump_power:
	li $t1, 0xff600a
	sw $t1, 8($s4)
	sw $t1, 260($s4)
	sw $t1, 264($s4)
	sw $t1, 268($s4)
	sw $t1, 512($s4)
	sw $t1, 520($s4)
	sw $t1, 528($s4)
	sw $t1, 776($s4)
	sw $t1, 1032($s4)
	
draw_heart:
	li $t1, 0xff006f # $t1 stores the red colour code
	sw $t1, 0($s6)
	sw $t1, 4($s6)
	sw $t1, 12($s6)
	sw $t1, 16($s6)
	sw $t1, 256($s6)
	sw $t1, 260($s6)
	sw $t1, 264($s6)
	sw $t1, 268($s6)
	sw $t1, 272($s6)
	sw $t1, 516($s6)
	sw $t1, 520($s6)
	sw $t1, 524($s6)
	sw $t1, 776($s6)

draw_trophy:
	li $t1, 0xcfad25 # $t1 stores the red colour code
	li $t2, 0x613700
	sw $t1, 0($s5)
	sw $t1, 8($s5)
	sw $t1, 256($s5)
	sw $t1, 260($s5)
	sw $t1, 264($s5)
	sw $t1, 516($s5)
	sw $t2, 768($s5)
	sw $t2, 772($s5)
	sw $t2, 776($s5)
	
draw_platform:
	li $a0, 2276
	jal draw_line
	li $a0, 2444
	jal draw_line
	li $a0, 3528
	jal draw_line
	li $a0, 4196
	jal draw_line
	li $a0, 4772
	jal draw_line
	li $a0, 5700
	jal draw_line
	li $a0, 6512
	jal draw_line
	li $a0, 6848
	jal draw_line
	li $a0, 7464
	jal draw_line

	li $a0, 9308
	jal draw_line
	li $a0, 10696
	jal draw_line
	li $a0, 11920
	jal draw_line
	li $a0, 13656
	jal draw_line
	li $a0, 13748
	jal draw_line
	li $a0, 15616
	jal draw_line

#Main loop
main:
	jal draw_health
	jal clear_platform_1
	jal move_platform_1
	jal clear_platform_2
	jal move_platform_2
	jal clear_character
	jal keypress_happened
	jal jumping
	jal gravity
	jal draw_character
	
	li $v0, 32
	li $a0, 60 # Wait one second (60 milliseconds)
	syscall
	j main

#moving platform 2
move_platform_2:
	addi $sp, $sp, -4  # allocate space on the stack
    	sw $ra, 0($sp)     # save the return address
    	
    	lw $a0, platform_2 #value of platform2
    	la $a1, platform_2 #address of platform2
    	li $t7, 8 #how far platform should move first
    	li $t8, 16 #how far platform should move back (8 forwawrd and 8 back, then reset)
    	lw $t6, PLATFORM_2 #location of original platform

    	ble $a0, $t8, continue #if platform further than original position, continue
    	sub $a0, $a0, 16
 	sw $a0, 0($a1) #else reset platform counter
continue:
    	bgt $a0, $t7, move_platform1_right #platform counter greater than 7, move right
    	ble $a0, $t7, move_platform1_left #platform counter less than 7, move left
    	
move_platform1_left:  
		#character on platform check
		lw $t0,-256($s1)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_left #checks all pixels above platform for character and moves left to follow platfomr
		lw $t0,-252($s1)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_left
		lw $t0,-248($s1)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_left
		lw $t0,-244($s1)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_left
		lw $t0,-240($s1)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_left
		lw $t0,-236($s1)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_left
		lw $t0,-232($s1)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_left
		j move_plat_left
follow_plat1_left:
		addi $sp, $sp, -4  # allocate space on the stack
    		sw $ra, 0($sp)     # save the return address
		jal follow_left
		lw $ra, 0($sp)      # restore the return address
    		addi $sp, $sp, 4  # allocate space on the stack
move_plat_left:	addi $s1, $s1, -4 #move up
		addi $a0, $a0, 1 #increase platform counter
		sw $a0, 0($a1)
		addi $sp, $sp, -4  # allocate space on the stack
    		sw $ra, 0($sp)     # save the return address
		jal draw_platform_2
		lw $ra, 0($sp)      # restore the return address
    		addi $sp, $sp, 4  # allocate space on the stack
		j stop_move
move_platform1_right:	
		#character on platform check
		lw $t0,-256($s1)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_right
		lw $t0,-252($s1)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_right
		lw $t0,-248($s1)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_right
		lw $t0,-244($s1)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_right
		lw $t0,-240($s1)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_right
		lw $t0,-236($s1)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_right
		lw $t0,-232($s1)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_right
		j move_plat_right
		
follow_plat1_right:
		addi $sp, $sp, -4  # allocate space on the stack
    		sw $ra, 0($sp)     # save the return address
		jal follow_right
		lw $ra, 0($sp)      # restore the return address
    		addi $sp, $sp, 4  # allocate space on the stack
    		
move_plat_right:addi $s1, $s1, 4#move down
		addi $a0, $a0, 1
		sw $a0, 0($a1)
		addi $sp, $sp, -4  # allocate space on the stack
    		sw $ra, 0($sp)     # save the return address
		jal draw_platform_2
		lw $ra, 0($sp)      # restore the return address
    		addi $sp, $sp, 4  # allocate space on the stack

stop_move:
	lw $ra, 0($sp)      # restore the return address
    	addi $sp, $sp, 4  # allocate space on the stack
	jr $ra

follow_left:
	addi $sp, $sp, -4  # allocate space on the stack
    	sw $ra, 0($sp)     # save the return address
    	jal clear_character
    	lw $ra, 0($sp)      # restore the return address
    	addi $sp, $sp, 4  # allocate space on the stack
	addi $s7, $s7, -4
	jr $ra 
follow_right:
	addi $sp, $sp, -4  # allocate space on the stack
    	sw $ra, 0($sp)     # save the return address
    	jal clear_character
    	lw $ra, 0($sp)      # restore the return address
    	addi $sp, $sp, 4  # allocate space on the stack
	addi $s7, $s7, 4
	jr $ra 

#moving platform 1
move_platform_1:
	addi $sp, $sp, -4  # allocate space on the stack
    	sw $ra, 0($sp)     # save the return address
    	
    	lw $a0, platform_1 #value 
    	la $a1, platform_1 #address 
    	li $t7, 8 #how far platform moves
    	li $t8, 16
    	lw $t6, PLATFORM_1 #location of original platform

    	ble $a0, $t8, continue_1 #if platform above original position, continue
    	sub $a0, $a0, 16
 	sw $a0, 0($a1) #else reset platform counter
continue_1:
    	bgt $a0, $t7, move_platform1_down #platform counter greater than 7, move down
    	ble $a0, $t7, move_platform1_up #platform counter less than 7, move up
    	
move_platform1_up:  
		#character on platform check
		lw $t0,-256($s2)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_up
		lw $t0,-252($s2)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_up
		lw $t0,-248($s2)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_up
		lw $t0,-244($s2)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_up
		lw $t0,-240($s2)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_up
		lw $t0,-236($s2)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_up
		lw $t0,-232($s2)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_up
		j move_plat_up
follow_plat1_up:
		addi $sp, $sp, -4  # allocate space on the stack
    		sw $ra, 0($sp)     # save the return address
		jal follow_up
		lw $ra, 0($sp)      # restore the return address
    		addi $sp, $sp, 4  # allocate space on the stack
move_plat_up:	addi $s2, $s2, -256 #move up
		addi $a0, $a0, 1 #increase platform counter
		sw $a0, 0($a1)
		addi $sp, $sp, -4  # allocate space on the stack
    		sw $ra, 0($sp)     # save the return address
		jal draw_platform_1
		lw $ra, 0($sp)      # restore the return address
    		addi $sp, $sp, 4  # allocate space on the stack
		j stop_move_1
move_platform1_down:	
		#character on platform check
		lw $t0,-256($s2)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_down
		lw $t0,-252($s2)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_down
		lw $t0,-248($s2)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_down
		lw $t0,-244($s2)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_down
		lw $t0,-240($s2)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_down
		lw $t0,-236($s2)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_down
		lw $t0,-232($s2)
		li $t1, 0xff0000
		beq $t0, $t1, follow_plat1_down
		j move_plat_down
		
follow_plat1_down:
		addi $sp, $sp, -4  # allocate space on the stack
    		sw $ra, 0($sp)     # save the return address
		jal follow_down
		lw $ra, 0($sp)      # restore the return address
    		addi $sp, $sp, 4  # allocate space on the stack
    		
move_plat_down:	addi $s2, $s2, 256 #move down
		addi $a0, $a0, 1
		sw $a0, 0($a1)
		addi $sp, $sp, -4  # allocate space on the stack
    		sw $ra, 0($sp)     # save the return address
		jal draw_platform_1
		lw $ra, 0($sp)      # restore the return address
    		addi $sp, $sp, 4  # allocate space on the stack

stop_move_1:
	lw $ra, 0($sp)      # restore the return address
    	addi $sp, $sp, 4  # allocate space on the stack
	jr $ra

follow_up:
	addi $sp, $sp, -4  # allocate space on the stack
    	sw $ra, 0($sp)     # save the return address
    	jal clear_character
    	lw $ra, 0($sp)      # restore the return address
    	addi $sp, $sp, 4  # allocate space on the stack
	addi $s7, $s7, -256
	jr $ra 
follow_down:
	addi $sp, $sp, -4  # allocate space on the stack
    	sw $ra, 0($sp)     # save the return address
    	jal clear_character
    	lw $ra, 0($sp)      # restore the return address
    	addi $sp, $sp, 4  # allocate space on the stack
	addi $s7, $s7, 256
	jr $ra 
	
draw_background:
    # Draw the background 
    li $t5, BASE_ADDRESS # Address for the start of the display
    li $t6, 4096 # Total number of pixels (512 width * 512 height)

    draw_loop:
        sw $t3, 0($t5) # Set the pixel to white
        addi $t5, $t5, 4 # Move to the next pixel
        addi $t6, $t6, -1 # Decrement the pixel counter
        bnez $t6, draw_loop # Repeat the loop if there are more pixels to draw

    jr $ra    	

#draws platform of 7 pixels to the right given parameter $a0 location
draw_line:
li $t2, 0x86a4ac # $t2 stores the platform colour
	addi $t0, $a0, BASE_ADDRESS
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	sw $t2, 16($t0)
	sw $t2, 20($t0)
	sw $t2, 24($t0)
	jr $ra

draw_platform_1:
li $t2, 0x86a4ac # $t2 stores the platform colour
	sw $t2, 0($s2)
	sw $t2, 4($s2)
	sw $t2, 8($s2)
	sw $t2, 12($s2)
	sw $t2, 16($s2)
	sw $t2, 20($s2)
	sw $t2, 24($s2)
	jr $ra

clear_platform_1:
li $t2, 0x3c4a4a# # $t2 stores the platform colour
	sw $t2, 0($s2)
	sw $t2, 4($s2)
	sw $t2, 8($s2)
	sw $t2, 12($s2)
	sw $t2, 16($s2)
	sw $t2, 20($s2)
	sw $t2, 24($s2)
	jr $ra
	
draw_platform_2:
li $t2, 0x86a4ac # $t2 stores the platform colour
	sw $t2, 0($s1)
	sw $t2, 4($s1)
	sw $t2, 8($s1)
	sw $t2, 12($s1)
	sw $t2, 16($s1)
	sw $t2, 20($s1)
	sw $t2, 24($s1)
	jr $ra

clear_platform_2:
li $t2, 0x3c4a4a# # $t2 stores the platform colour
	sw $t2, 0($s1)
	sw $t2, 4($s1)
	sw $t2, 8($s1)
	sw $t2, 12($s1)
	sw $t2, 16($s1)
	sw $t2, 20($s1)
	sw $t2, 24($s1)
	jr $ra
	
draw_health:
	lw $a0, health#value of state
	
	li $t1, 0xff0000 # $t1 stores the red colour code
	li $t3, 0x3c4a4a# background colour
	addi $t0, $zero, BASE_ADDRESS
	
	beqz $a0, stop_health_0
	
	#1 heart
	sw $t1, 524($t0)
	sw $t1, 532($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)
	sw $t1, 1040($t0)
	
	beq $a0, 1, stop_health_1 #after drawing 1 heart, if heart=1, dont draw rest and clear
	
	#2 heart
	sw $t1, 540($t0)
	sw $t1, 548($t0)
	sw $t1, 796($t0)
	sw $t1, 800($t0)
	sw $t1, 804($t0)
	sw $t1, 1056($t0)

	beq $a0, 2, stop_health_2
	
	#3 heart
	sw $t1, 556($t0)
	sw $t1, 564($t0)
	sw $t1, 812($t0)
	sw $t1, 816($t0)
	sw $t1, 820($t0)
	sw $t1, 1072($t0)
	
	beq $a0, 3, stop_health_3
	
	#4 heart
	sw $t1, 572($t0)
	sw $t1, 580($t0)
	sw $t1, 828($t0)
	sw $t1, 832($t0)
	sw $t1, 836($t0)
	sw $t1, 1088($t0)
	jr $ra

#when health is 0, clears all previously drawn hearts
stop_health_0:
#1 heart
	sw $t3, 524($t0)
	sw $t3, 532($t0)
	sw $t3, 780($t0)
	sw $t3, 784($t0)
	sw $t3, 788($t0)
	sw $t3, 1040($t0)
	
	#2 heart
	sw $t3, 540($t0)
	sw $t3, 548($t0)
	sw $t3, 796($t0)
	sw $t3, 800($t0)
	sw $t3, 804($t0)
	sw $t3, 1056($t0)
	
	#3 heart
	sw $t3, 556($t0)
	sw $t3, 564($t0)
	sw $t3, 812($t0)
	sw $t3, 816($t0)
	sw $t3, 820($t0)
	sw $t3, 1072($t0)
	
	#4 heart
	sw $t3, 572($t0)
	sw $t3, 580($t0)
	sw $t3, 828($t0)
	sw $t3, 832($t0)
	sw $t3, 836($t0)
	sw $t3, 1088($t0)
	j draw_losescreen

#when health is 1, clears 2-3 previously drawn hearts
stop_health_1:	
#2 heart
	sw $t3, 540($t0)
	sw $t3, 548($t0)
	sw $t3, 796($t0)
	sw $t3, 800($t0)
	sw $t3, 804($t0)
	sw $t3, 1056($t0)
	
	#3 heart
	sw $t3, 556($t0)
	sw $t3, 564($t0)
	sw $t3, 812($t0)
	sw $t3, 816($t0)
	sw $t3, 820($t0)
	sw $t3, 1072($t0)
	
	#4 heart
	sw $t3, 572($t0)
	sw $t3, 580($t0)
	sw $t3, 828($t0)
	sw $t3, 832($t0)
	sw $t3, 836($t0)
	sw $t3, 1088($t0)
	jr $ra

#when health is 2, clears 1-2 previously drawn hearts
stop_health_2:		
	#3 heart
	sw $t3, 556($t0)
	sw $t3, 564($t0)
	sw $t3, 812($t0)
	sw $t3, 816($t0)
	sw $t3, 820($t0)
	sw $t3, 1072($t0)
	
	#4 heart
	sw $t3, 572($t0)
	sw $t3, 580($t0)
	sw $t3, 828($t0)
	sw $t3, 832($t0)
	sw $t3, 836($t0)
	sw $t3, 1088($t0)
	jr $ra

#when health is 3, clears 4th previously drawn heart case
stop_health_3:		
	#4 heart
	sw $t3, 572($t0)
	sw $t3, 580($t0)
	sw $t3, 828($t0)
	sw $t3, 832($t0)
	sw $t3, 836($t0)
	sw $t3, 1088($t0)
	jr $ra
	
draw_winscreen:
	li $t1, 0x000000 # $t1 stores the black colour code
	addi $t0, $zero, BASE_ADDRESS
	
	#letter Y
	sw $t1, 6964($t0)
	sw $t1, 7224($t0)
	sw $t1, 7484($t0)
	sw $t1, 7740($t0)
	sw $t1, 7996($t0)
	sw $t1, 7232($t0)
	sw $t1, 6980($t0)
	
	#letter O
	sw $t1, 6988($t0)
	sw $t1, 6992($t0)
	sw $t1, 6996($t0)
	sw $t1, 7000($t0)
	sw $t1, 7004($t0)
	sw $t1, 7244($t0)
	sw $t1, 7260($t0)
	sw $t1, 7500($t0)
	sw $t1, 7516($t0)
	sw $t1, 7756($t0)
	sw $t1, 7772($t0)
	sw $t1, 8012($t0)
	sw $t1, 8016($t0)
	sw $t1, 8020($t0)
	sw $t1, 8024($t0)
	sw $t1, 8028($t0)
	
	#letter U
	sw $t1, 7012($t0)
	sw $t1, 7028($t0)
	sw $t1, 7268($t0)
	sw $t1, 7284($t0)
	sw $t1, 7524($t0)
	sw $t1, 7540($t0)
	sw $t1, 7780($t0)
	sw $t1, 7796($t0)
	sw $t1, 8036($t0)
	sw $t1, 8040($t0)
	sw $t1, 8044($t0)
	sw $t1, 8048($t0)
	sw $t1, 8052($t0)
	
	#letter W
	sw $t1, 7052($t0)
	sw $t1, 7068($t0)
	sw $t1, 7308($t0)
	sw $t1, 7324($t0)
	sw $t1, 7564($t0)
	sw $t1, 7572($t0)
	sw $t1, 7580($t0)
	sw $t1, 7820($t0)
	sw $t1, 7824($t0)
	sw $t1, 7832($t0)
	sw $t1, 7836($t0)
	sw $t1, 8076($t0)
	sw $t1, 8092($t0)
	
	#letter O
	sw $t1, 7076($t0)
	sw $t1, 7080($t0)
	sw $t1, 7084($t0)
	sw $t1, 7088($t0)
	sw $t1, 7092($t0)
	sw $t1, 7332($t0)
	sw $t1, 7348($t0)
	sw $t1, 7588($t0)
	sw $t1, 7604($t0)
	sw $t1, 7844($t0)
	sw $t1, 7860($t0)
	sw $t1, 8100($t0)
	sw $t1, 8104($t0)
	sw $t1, 8108($t0)
	sw $t1, 8112($t0)
	sw $t1, 8116($t0)
	
	#letter N
	sw $t1, 7100($t0)
	sw $t1, 7116($t0)
	sw $t1, 7356($t0)
	sw $t1, 7360($t0)
	sw $t1, 7372($t0)
	sw $t1, 7612($t0)
	sw $t1, 7620($t0)
	sw $t1, 7628($t0)
	sw $t1, 7868($t0)
	sw $t1, 7880($t0)
	sw $t1, 7884($t0)
	sw $t1, 8124($t0)
	sw $t1, 8140($t0)
	jr $ra
	
draw_losescreen:
	li $t1, 0x000000 # $t1 stores the black colour code
	addi $t0, $zero, BASE_ADDRESS
	
	#letter Y
	sw $t1, 6964($t0)
	sw $t1, 7224($t0)
	sw $t1, 7484($t0)
	sw $t1, 7740($t0)
	sw $t1, 7996($t0)
	sw $t1, 7232($t0)
	sw $t1, 6980($t0)
	
	#letter O
	sw $t1, 6988($t0)
	sw $t1, 6992($t0)
	sw $t1, 6996($t0)
	sw $t1, 7000($t0)
	sw $t1, 7004($t0)
	sw $t1, 7244($t0)
	sw $t1, 7260($t0)
	sw $t1, 7500($t0)
	sw $t1, 7516($t0)
	sw $t1, 7756($t0)
	sw $t1, 7772($t0)
	sw $t1, 8012($t0)
	sw $t1, 8016($t0)
	sw $t1, 8020($t0)
	sw $t1, 8024($t0)
	sw $t1, 8028($t0)
	
	#letter U
	sw $t1, 7012($t0)
	sw $t1, 7028($t0)
	sw $t1, 7268($t0)
	sw $t1, 7284($t0)
	sw $t1, 7524($t0)
	sw $t1, 7540($t0)
	sw $t1, 7780($t0)
	sw $t1, 7796($t0)
	sw $t1, 8036($t0)
	sw $t1, 8040($t0)
	sw $t1, 8044($t0)
	sw $t1, 8048($t0)
	sw $t1, 8052($t0)
	
	#letter L
	sw $t1, 7052($t0)
	sw $t1, 7308($t0)
	sw $t1, 7564($t0)
	sw $t1, 7820($t0)
	sw $t1, 8076($t0)
	sw $t1, 8080($t0)
	sw $t1, 8084($t0)
	
	#letter O
	sw $t1, 7068($t0)
	sw $t1, 7072($t0)
	sw $t1, 7076($t0)
	sw $t1, 7080($t0)
	sw $t1, 7324($t0)
	sw $t1, 7336($t0)
	sw $t1, 7580($t0)
	sw $t1, 7592($t0)
	sw $t1, 7836($t0)
	sw $t1, 7848($t0)
	sw $t1, 8092($t0)
	sw $t1, 8096($t0)
	sw $t1, 8100($t0)
	sw $t1, 8104($t0)
	
	#letter S
	sw $t1, 7088($t0)
	sw $t1, 7092($t0)
	sw $t1, 7096($t0)
	sw $t1, 7344($t0)
	sw $t1, 7600($t0)
	sw $t1, 7604($t0)
	sw $t1, 7608($t0)
	sw $t1, 7864($t0)
	sw $t1, 8112($t0)
	sw $t1, 8116($t0)
	sw $t1, 8120($t0)
	
	#letter E
	sw $t1, 7104($t0)
	sw $t1, 7108($t0)
	sw $t1, 7112($t0)
	sw $t1, 7116($t0)
	sw $t1, 7360($t0)
	sw $t1, 7616($t0)
	sw $t1, 7620($t0)
	sw $t1, 7624($t0)
	sw $t1, 7628($t0)
	sw $t1, 7872($t0)
	sw $t1, 8128($t0)
	sw $t1, 8132($t0)
	sw $t1, 8136($t0)
	sw $t1, 8140($t0)
	jr $ra 

draw_character:
lw $a0, change_power
#checks change power variable to see which colour to draw character
beqz $a0, red
beq $a0, 1, cyan
red:
	li $t1, 0xff0000 # $t1 stores the red colour code
	li $t2, 0xffffff # $t2 stores the white colour code
	
	sw $t1, 4($s7) # paint the second unit on the first row green. Why $t0+4?
	sw $t1, 256($s7) # paint the first unit on the second row blue. Why +256?
	sw $t2, 260($s7)
	sw $t1, 264($s7)
	sw $t1, 512($s7)
	sw $t1, 516($s7)
	sw $t1, 520($s7)
	sw $t1, 768($s7)
	sw $t1, 776($s7)
	jr $ra
cyan:
	li $t1, 0x00ffee # $t1 stores the red colour code
	li $t2, 0xffffff # $t2 stores the white colour code
	
	sw $t1, 4($s7) # paint the second unit on the first row green. Why $t0+4?
	sw $t1, 256($s7) # paint the first unit on the second row blue. Why +256?
	sw $t2, 260($s7)
	sw $t1, 264($s7)
	sw $t1, 512($s7)
	sw $t1, 516($s7)
	sw $t1, 520($s7)
	sw $t1, 768($s7)
	sw $t1, 776($s7)
	jr $ra
	
clear_character:
	li $t3, 0x3C4A4A # $t3 stores the background colour code
	sw $t3, 4($s7) # paint the second unit on the first row green. Why $t0+4?
	sw $t3, 256($s7) # paint the first unit on the second row blue. Why +256?
	sw $t3, 260($s7)
	sw $t3, 264($s7)
	sw $t3, 512($s7)
	sw $t3, 516($s7)
	sw $t3, 520($s7)
	sw $t3, 768($s7)
	sw $t3, 776($s7)
	jr $ra

clear_heart:
	#increase hp
	lw $a0, health #value of state
	la $a1, health #address of state
	addi $a0, $a0, 1 #add one to value of health
	sw $a0 0($a1) #update jump counter value
		
	li $t1, 0x3C4A4A # $t1 stores the red colour code
	sw $t1, 0($s6)
	sw $t1, 4($s6)
	sw $t1, 12($s6)
	sw $t1, 16($s6)
	sw $t1, 256($s6)
	sw $t1, 260($s6)
	sw $t1, 264($s6)
	sw $t1, 268($s6)
	sw $t1, 272($s6)
	sw $t1, 516($s6)
	sw $t1, 520($s6)
	sw $t1, 524($s6)
	sw $t1, 776($s6)
	jr $ra

clear_jump_power:
	#increase jump height
	lw $a0, jump_power #value of state
	la $a1, jump_power #address of state
	addi $a0, $a0, 1 #add one to value of health
	sw $a0 0($a1) #update jump counter value
	
	li $t1, 0x3C4A4A # $t1 stores the red colour code
	sw $t1, 8($s4)
	sw $t1, 260($s4)
	sw $t1, 264($s4)
	sw $t1, 268($s4)
	sw $t1, 512($s4)
	sw $t1, 520($s4)
	sw $t1, 528($s4)
	sw $t1, 776($s4)
	sw $t1, 1032($s4)
	jr $ra

clear_change_power:
	#change colour
	lw $a0, change_power #value of state
	la $a1, change_power #address of state
	addi $a0, $a0, 1 #add one to value of health
	sw $a0 0($a1) #update jump counter value
	
	li $t1, 0x3C4A4A # $t1 stores the red colour code
	sw $t1, 4($s3) # paint the second unit on the first row green. Why $t0+4?
	sw $t1, 256($s3) # paint the first unit on the second row blue. Why +256?
	sw $t1, 260($s3)
	sw $t1, 264($s3)
	sw $t1, 512($s3)
	sw $t1, 516($s3)
	sw $t1, 520($s3)
	sw $t1, 768($s3)
	sw $t1, 776($s3)
	jr $ra

keypress_happened:
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	bne $t8, 1, key_exit

	lw $t8, 4($t9) 
	# updates character location
	beq $t8, 119, respond_to_w		# ASCII code of 'w' 
	beq $t8, 97, respond_to_a		# ASCII code of 'a' 
	beq $t8, 100, respond_to_d		# ASCII code of 'd'
	beq $t8, 112, respond_to_p

key_exit:	jr $ra

#jump
jumping:
	lw $a0, jump_state #value of state
	la $a3, jump_state #address of state
	lw $a1, jump_counter #value of counter
	la $a2, jump_counter #get address of counter
	
	beq $a0, 1, jump #if jump state is 1 start jumping
	bne $a0, 1, stop_jump#jump state is not 1, dont jump
jump: 	
	lw $t4, jump_power
	beq $t4, 1, higher_jump #if jump power variable is obtained, do the higher jump
	li $t9, 7
	ble $a1, $t9, jump_check #and if jump counter less than 4, jump
	bgt $a1, $t9, stop_jump #if counter is greater than 4, stop jumping
higher_jump:
	li $t9, 12
	ble $a1, $t9, jump_check #and if jump counter less than 4, jump
	bgt $a1, $t9, stop_jump #if counter is greater than 4, stop jumping
	
jump_check:	
	li $t5, BASE_ADDRESS
	addi $t6, $t5, 256
	ble $s7, $t6, stop_jump #check ceiling edge
	#check for platform collision above
  	lw $t0,-252($s7)
  	li $t1, PLATFORM
  	beq $t0, $t1, stop_jump
  	lw $t0, 0($s7)
  	li $t1, PLATFORM
  	beq $t0, $t1, stop_jump
  	lw $t0, 8($s7)
  	li $t1, PLATFORM
  	beq $t0, $t1, stop_jump
  	
		addi $s7, $s7, -256 #move up
		addi $a1, $a1, 1 #add one to value of jump counter
		sw $a1 0($a2) #update jump counter value
		j end_jump
stop_jump:	
		li $t8, 0 #set 0
		li $t7, 2 #set 2
   		sw $t7 0($a3) #reset jump state to 0
   		sw $t8 0($a2) #reset jump counter to 0
end_jump:	jr $ra

#fall
gravity:
addi $sp, $sp, -4  # allocate space on the stack
    sw $ra, 0($sp)     # save the return address
    
	lw $a0, jump_state #value of state
	la $a3, jump_state #address of state
	la $a2, num_of_jumps #address of num of jumps
	
	beq $a0, 2, fall #if jump state is 2 start falling
	beq $a0, 1, end_fall#jump state is jumping, dont change state
	bne $a0, 2, stop_fall#jump state is not 2 or 1, then its 0 and change

fall: 	
	#check screen edge
	li $t5, BASE_ADDRESS
	addi $t6, $t5, 15364
	bge $s7, $t6, reset_character #check bottom of edge screen, then reset character
	#check for platform collision below
  	lw $t0, 1024($s7)
  	li $t1, PLATFORM
  	beq $t0, $t1, stop_fall
  	lw $t0, 1028($s7)
  	li $t1, PLATFORM
  	beq $t0, $t1, stop_fall
  	lw $t0, 1032($s7)
  	li $t1, PLATFORM
  	beq $t0, $t1, stop_fall
  	#check for heart collision below
  	lw $t0, 1024($s7)
  	li $t1, HEART_COLOUR
  	beq $t0, $t1, clear_heart
  	lw $t0, 1028($s7)
  	li $t1, HEART_COLOUR
  	beq $t0, $t1, clear_heart
  	lw $t0, 1032($s7)
  	li $t1, HEART_COLOUR
  	beq $t0, $t1, clear_heart
  	#check for jump power collision below
  	lw $t0, 1024($s7)
  	li $t1, JUMP_POWER_COLOUR
  	beq $t0, $t1, clear_jump_power
  	lw $t0, 1028($s7)
  	li $t1, JUMP_POWER_COLOUR
  	beq $t0, $t1, clear_jump_power
  	lw $t0, 1032($s7)
  	li $t1, JUMP_POWER_COLOUR
  	beq $t0, $t1, clear_jump_power
  	#check for change power collision below
  	lw $t0, 1024($s7)
  	li $t1, CHANGE_POWER_COLOUR
  	beq $t0, $t1, clear_change_power
  	lw $t0, 1028($s7)
  	li $t1, CHANGE_POWER_COLOUR
  	beq $t0, $t1, clear_change_power
  	lw $t0, 1032($s7)
  	li $t1, CHANGE_POWER_COLOUR
  	beq $t0, $t1, clear_change_power
  	
	addi $s7, $s7, 256 #move down
	j end_fall
stop_fall:	
		li $t8, 0 #set 0
		li $t7, 2 #set 2
   		sw $t8 0($a3) #reset jump state to 0
   		sw $t7 0($a2) #reset num of jumps
end_fall:	
lw $ra, 0($sp)      # restore the return address
addi $sp, $sp, 4  # allocate space on the stack
jr $ra

#when character hits bottom of screen
reset_character:
lw $a0, health #value of health
la $a1, health #address of health
sub $a0, $a0, 1 #subtract one heart
sw $a0 0($a1) #update new health
li $s7, 0x1000B908 #reset character to starting position
jr $ra
	

respond_to_w:   
	lw $a0, jump_state #value
	la $a0, jump_state #get address
   	li $a1, 1 #new value
   	
   	lw $t3, num_of_jumps #value
	la $a2, num_of_jumps #address
	beqz $t3, limit #if num of jumps is 0, dont change state
	
	#decrement number of jumps available
	sub $t3, $t3, 1 
	sw $t3 0($a2)
   	
   	sw $a1 0($a0) #change jump state to 1
limit:   jr $ra
	
respond_to_a:
	li $t5, BASE_ADDRESS
	sub $t7, $s7, $t5 #subtract base from character location
	li $t3, 256     # Divide to check if it's at the right end
  	div $t7, $t3
  	mfhi $t1
  	beqz $t1, no_left
  	#check for platform collision
  	lw $t0,0($s7)
  	li $t1, PLATFORM
  	beq $t0, $t1, no_left
  	lw $t0,252($s7)
  	li $t1, PLATFORM
  	beq $t0, $t1, no_left
  	lw $t0, 508($s7)
  	li $t1, PLATFORM
  	beq $t0, $t1, no_left
  	lw $t0, 764($s7)
  	li $t1, PLATFORM
  	beq $t0, $t1, no_left
  	#check for heart collision
  	lw $t0,0($s7)
  	li $t1, HEART_COLOUR
  	beq $t0, $t1, clear_heart
  	lw $t0,252($s7)
  	li $t1, HEART_COLOUR
  	beq $t0, $t1, clear_heart
  	lw $t0, 508($s7)
  	li $t1, HEART_COLOUR
  	beq $t0, $t1, clear_heart
  	lw $t0, 764($s7)
  	li $t1, HEART_COLOUR
  	beq $t0, $t1, clear_heart
  	#check for change collision
  	lw $t0,0($s7)
  	li $t1, CHANGE_POWER_COLOUR
  	beq $t0, $t1, clear_change_power
  	lw $t0,252($s7)
  	li $t1, CHANGE_POWER_COLOUR
  	beq $t0, $t1, clear_change_power
  	lw $t0, 508($s7)
  	li $t1, CHANGE_POWER_COLOUR
  	beq $t0, $t1, clear_change_power
  	lw $t0, 764($s7)
  	li $t1, CHANGE_POWER_COLOUR
  	beq $t0, $t1, clear_change_power

	addi $s7, $s7, -4        # Move position of ship left
no_left:jr $ra
	
respond_to_d:
	#check for screen edge collision
	li $t5, BASE_ADDRESS
	addi $t5, $t5, -12
	sub $t7, $s7, $t5 #subtract base from character location
	li $t3, 256     # Divide to check if it's at the right end
  	div $t7, $t3
  	mfhi $t1
  	beq $t1, $0, no_right
  	#check for platform collision
  	lw $t0,8($s7)
  	li $t1, PLATFORM
  	beq $t0, $t1, no_right
  	lw $t0,268($s7)
  	li $t1, PLATFORM
  	beq $t0, $t1, no_right
  	lw $t0, 524($s7)
  	li $t1, PLATFORM
  	beq $t0, $t1, no_right
  	lw $t0, 780($s7)
  	li $t1, PLATFORM
  	beq $t0, $t1, no_right
  	#check for heart collision
  	lw $t0,8($s7)
  	li $t1, HEART_COLOUR
  	beq $t0, $t1, clear_heart
  	lw $t0,268($s7)
  	li $t1, HEART_COLOUR
  	beq $t0, $t1, clear_heart
  	lw $t0, 524($s7)
  	li $t1, HEART_COLOUR
  	beq $t0, $t1, clear_heart
  	lw $t0, 780($s7)
  	li $t1, HEART_COLOUR
  	beq $t0, $t1, clear_heart
  	#check for trophy collision
  	lw $t0,8($s7)
  	li $t1, TROPHY_COLOUR
  	beq $t0, $t1, draw_winscreen
  	lw $t0,268($s7)
  	li $t1, TROPHY_COLOUR
  	beq $t0, $t1, draw_winscreen
  	lw $t0, 524($s7)
  	li $t1, TROPHY_COLOUR
  	beq $t0, $t1, draw_winscreen
  	lw $t0, 780($s7)
  	li $t1, TROPHY_COLOUR
  	beq $t0, $t1, draw_winscreen
  	#check for jump power collision
  	lw $t0,8($s7)
  	li $t1, JUMP_POWER_COLOUR
  	beq $t0, $t1, clear_jump_power
  	lw $t0,268($s7)
  	li $t1, JUMP_POWER_COLOUR
  	beq $t0, $t1, clear_jump_power
  	lw $t0, 524($s7)
  	li $t1, JUMP_POWER_COLOUR
  	beq $t0, $t1, clear_jump_power
  	lw $t0, 780($s7)
  	li $t1, JUMP_POWER_COLOUR
  	beq $t0, $t1, clear_jump_power
  	#check for change power collision
  	lw $t0,8($s7)
  	li $t1, CHANGE_POWER_COLOUR
  	beq $t0, $t1, clear_change_power
  	lw $t0,268($s7)
  	li $t1, CHANGE_POWER_COLOUR
  	beq $t0, $t1, clear_change_power
  	lw $t0, 524($s7)
  	li $t1, CHANGE_POWER_COLOUR
  	beq $t0, $t1, clear_change_power
  	lw $t0, 780($s7)
  	li $t1, CHANGE_POWER_COLOUR
  	beq $t0, $t1, clear_change_power
  	
	addi $s7, $s7, 4

no_right:jr $ra

respond_to_p:
li $t1, 3
li $t2, 0
la $a0, health #value of state
la $a1, jump_power
la $a2, change_power
li $t3, 0x1000B924
la $t4, platform_1 #address 
li $t5, 0x1000A19C
la $t6, platform_2

sw $t5, 0($s1)#reset platform 2 position
sw $t2, 0($t6)#reset platform 2 counter
sw $t2, 0($t4)#reset platform 1 counter
sw $t3, 0($s2)#reset platform 1 position
sw $t1, 0($a0)#reset health to 3
sw $t2, 0($a1)#reset jump to normal height
sw $t2, 0($a2)#reset colour to red
	j restart


li $v0, 10 # terminate the program gracefully
syscall
