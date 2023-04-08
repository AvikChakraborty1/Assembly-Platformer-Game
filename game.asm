#####################################################################
#
# CSCB58 Winter 2023 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Avik Chakraborty, 1007067745, chakr205
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 512 
# - Display height in pixels: 512
# - Base Address for Display: 0x10008000 ($gp)
#

.eqv	BASE_ADDRESS	0x10008000	#Base address value
.eqv	SLEEP_AMOUNT	20		#Base address value
.eqv	MAX_JUMP	15		#Base address value

.data
all_info:		.space	208	#1-40 space ship, 40-80 fire1 80-120 ufo 120-160 meteor 164 base address 168-208 fire 2
jump_left:		.byte	15
can_jump_again:		.byte 	1

.text

.globl main

main: 			li $v0 32
			li $a0 1000
			syscall

			li $t0, BASE_ADDRESS 			# $t0 stores the base address for display
			li $t1, 0xff0000
			li $t2, 0x000000
			li $t8, 0x976fb6 
			li $t4, 8060
			add $t0, $t0, $t4			# t0 stores current location of player
			sw $t1, 0($t0) 				# t0 stores the base address for display
			
draw_ground:		li $t9, BASE_ADDRESS
			li $t4, 13056
			li $t5, 13312
			add $t5, $t5, $t9
			add $t9, $t9, $t4
			
draw_ground_loop:	beq $t9, $t5, game_loop
			sw $t8, 0($t9)
			addi $t9, $t9, 4 		
			j draw_ground_loop
			
			li $t7, 1
			
game_loop:		li $v0 32
			li $a0 SLEEP_AMOUNT
			syscall
			
			beq $t7, 2, jumping 
			
check_falling:		lw $t6, 256($t0)			# check if pixel below is ground
			bne $t6, $t8, falling
			li $t7, 0
			la $t4, can_jump_again
			li $t5, 1
			sb $t5, 0($t4)
												
check_keypress:		li $t3 0xffff0000
			lw $t4 0($t3)
			beq $t4, 1, keypress_happened
			j game_loop
			
keypress_happened:	lw $t4 4($t3)
			beq $t4 0x77 w_pressed
			beq $t4 0x61 a_pressed
			beq $t4 0x64 d_pressed
			beq $t4 0x73 s_pressed
			#beq $t4 0x70 p_pressed
			#beq $t4 0x20 space_pressed
			j game_loop
			
a_pressed:		sw $t2, 0($t0)
			addi $t0, $t0, -4
			sw $t1, 0($t0)
			j game_loop
			
d_pressed:		sw $t2, 0($t0)
			addi $t0, $t0, 4
			sw $t1, 0($t0)
			j game_loop
			
s_pressed:		sw $t2, 0($t0)
			addi $t0, $t0, 256
			sw $t1, 0($t0)
			j game_loop
		
w_pressed:		beq $t7, 1, try_double_jump
			beq $t7, 2, game_loop
			
initial_jump:		li $t7, 2
			sw $t2, 0($t0)
			addi $t0, $t0, -256
			sw $t1, 0($t0)
			j game_loop

try_double_jump:	la $t4, can_jump_again
			lb $t5, 0($t4)
			beqz $t5, game_loop
			addi $t5, $t5, -1
			sb $t5, 0($t4)
			j initial_jump
			
falling:		li $t7, 1
			sw $t2, 0($t0)
			addi, $t0, $t0, 256	
			sw $t1, 0($t0)
			j check_keypress
			
jumping:		la $t4, jump_left
			lb $t5, 0($t4)
			
			beq $t5, $zero, at_peak_jump
			addi $t5, $t5, -1
			sb $t5, 0($t4)
						
			sw $t2, 0($t0)
			addi $t0, $t0, -256
			sw $t1, 0($t0)
			j check_keypress

at_peak_jump:		li $t7, 1
			la $t4, jump_left
			li $t5, MAX_JUMP
			sb $t5, 0($t4)
			
			#la $t4, can_jump_again
			#lb $t5, 0($t4)
			#addi $t5, $t5, -1
			#sb $t5, 0($t4)
			j check_keypress
			
			li $v0, 10
			syscall
            
            
            


