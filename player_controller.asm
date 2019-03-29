## This file implements the functions that control the player based on the keyboard input

.include "convenience.asm"
.include "game.asm"

.globl player_update
.globl draw_bullet
.globl update_bullet
.globl out_of_lives

.data
over:		.asciiz "Game Over"
over2:		.asciiz "Out of"
over3:		.asciiz "bullets"
over4:		.asciiz "Out of"
over5:		.asciiz "lives"
scorestr:	.asciiz "Score:"		
	
.text

player_update:

	enter

	lw t0, frame_counter		# get the current frame
	rem t0, t0, 2			# get the remainder of the current frame divided by 2
	bne t0, 0, _exit		# if the remainder is not 0, then exit. This makes the player move every 2 frames	

	lw t0, lives			
	beqz t0, out_of_lives		# if player has 0 lives left, exit the game
			
	jal handle_input 		# read in the user input
		
	lw t0, left_pressed
	lw t1, right_pressed
	lw t2, up_pressed
	lw t3, down_pressed
	lw t4, action_pressed
		
	beq t0, 1, _move_left
	beq t1, 1, _move_right
	beq t2, 1, _move_up
	beq t3, 1, _move_down
	beq t4, 1, _shoot_bullet
		
	leave
		
	_move_left:
	lw t0, x_coord
	addi t0, t0, -1
	beq t0, -1, _exit	# out of bounds check
	sw t0, x_coord
	leave
	
	_move_right:
	lw t0, x_coord
	addi t0, t0, 1
	beq t0, 60, _exit	# out of bounds check
	sw t0, x_coord
	leave	
		
	_move_up:
	lw t0, y_coord
	addi t0, t0, -1
	beq t0, -1, _exit	# out of bounds check
	sw t0, y_coord
	leave	
		
	_move_down:
	lw t0, y_coord
	addi t0, t0, 1
	beq t0, 54, _exit	# out of bounds check
	sw t0, y_coord
	leave	
		
	_shoot_bullet:	
	jal shoot_bullet
	leave
				
	_exit:
	leave	
				
shoot_bullet:
	enter
	
	lw t0, bullet_active
	bnez t0, _exit		# if bullet is active, exit func without shooting another
	
	lw t0, x_coord		# get initial pos of bullet from current ship pos
	lw t1, y_coord
	sw t0, bullet_x
	sw t1, bullet_y
	
	li t2, 1 		# bullet = active
	sw t2, bullet_active
	
	lw t3, bullets_left	# if player is out of bullets, exit the game
	beq t3, 0, out_of_bullets
	dec t3		
	sw t3, bullets_left

	leave

draw_bullet:
	enter

	lw t0, bullet_active	# if the bullet is inactive, exit without drawing
	beqz t0, __exit

	lw a0, bullet_x
	lw a1, bullet_y
	la a2, bullet_image
	jal display_blit_5x5_trans
	
	__exit:
	leave

update_bullet:
	enter a1, t0 
	
	lw t0, bullet_active
	beqz t0, ___exit
	
	lw t0, bullet_y			# move the bullet up one y position
	addi t0, t0, -1	
	
	beq t0, 0, _make_inactive	# if bullet y = top of screen, make bullet inactive
	
	sw t0, bullet_y			# else, update the bullet y pos

	___exit:
	leave a1, t0	
	
	_make_inactive:
	li t0, 0
	sw t0, bullet_active
	j ___exit
	
	
out_of_bullets:	
			
	li a0, 0		# clear sprites from screan - ##### NOT WORKING ####
	li a1, 0			# try setting enemies to inactive and updating them, move player back to start
	li a2, DISPLAY_W
	li a3, DISPLAY_H
	li v1, 0  		# Background color = Black
	jal display_fill_rect
	
	li a0, 15
	li a1, 9
	la a2, over2
	jal display_draw_text
	
	li a0, 11
	li a1, 17
	la a2, over3
	jal display_draw_text
	
	li a0, 5
	li a1, 25
	la a2, over
	jal display_draw_text
	
	li a0, 10
	li a1, 35
	la a2, scorestr
	jal display_draw_text

	li a0, 45
	li a1, 35
	lw a2, score
	jal display_draw_int
	
	jal display_update
		
	j _main_game_over	
	
	
out_of_lives:

	enter
	
	li a0, 0		# clear sprites from screan - ##### NOT WORKING ####
	li a1, 0			# try setting enemies to inactive and updating them, move player back to start
	li a2, DISPLAY_W
	li a3, DISPLAY_H
	li v1, 0  		# Background color = Black
	jal display_fill_rect
	
	li a0, 15
	li a1, 9
	la a2, over4
	jal display_draw_text
	
	li a0, 16
	li a1, 17
	la a2, over5
	jal display_draw_text
	
	li a0, 6
	li a1, 25
	la a2, over
	jal display_draw_text
	
	jal display_update
	
	li a0, 10
	li a1, 35
	la a2, scorestr
	jal display_draw_text

	li a0, 45
	li a1, 35
	lw a2, score
	jal display_draw_int
	
	j _main_game_over