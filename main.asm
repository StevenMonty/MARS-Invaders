# Steven Montalbano
# smm285

.include "convenience.asm"
.include "game.asm"

.eqv	GAME_TICK_MS	16	# Defines the number of frames per second: 16ms -> 60fps

.data
.globl frame_counter
.globl _main_game_over
.globl level
.globl score		
.globl lives
.globl bullets_left

# Variables used by wait_for_next_frame - also used to limit sprite movement speed in update methods
last_frame_time:  	.word 0
frame_counter:  	.word 0

score: 			.word 0		# enemies destroyed
lives:			.word 0		# player lives left
bullets_left:		.word 0		# player bullets left
level:			.word 0		# difficulty level

begin:		.asciiz "Press"
begin2:		.asciiz "arrow key"
begin3:		.asciiz "to start"
begin4:		.asciiz "the game"
easy:		.asciiz "< Easy"
medium:		.asciiz "^ Medium"
hard:		.asciiz "> Hard"

.text
.globl main

main:	
	li t0, 0	# Score - init to 0
	sw t0, score
	sw t0, bullet_active
	li t0, 3	# Lives left - init to 3
	sw t0, lives
	li t0, 50	# Bullets left - init to 50
	sw t0, bullets_left
	
	li t1, 30	# starting x pos
	li t2, 52	# starting y pos
	sw t1, x_coord
	sw t2, y_coord

	li a0, 16	#	a0 = top-left x	
	li a1, 2	#	a1 = top-left y
	la a2, begin	#	a2 = pointer to string to print
	jal display_draw_text
	
	li a0, 7
	li a1, 10
	la a2, begin2
	jal display_draw_text
	
	li a0, 8
	li a1, 18
	la a2, begin3
	jal display_draw_text
	
	li a0, 8
	li a1, 25
	la a2, begin4
	jal display_draw_text	

	li a0, 8
	li a1, 39
	la a2, easy
	jal display_draw_text	
	
	li a0, 8
	li a1, 46
	la a2, medium
	jal display_draw_text	
		
	li a0, 8
	li a1, 53
	la a2, hard
	jal display_draw_text	
			
	jal display_update	
	
	_wait_for_start:	# wait for button press to start game
		
		jal handle_input
	
		lw t0, left_pressed	# easy 
		lw t1, right_pressed	# hard
		lw t2, up_pressed	# medium

		bnez t0, easy_Sel	# set level to easy
		bnez t1, hard_Sel	# set level to medium
		bnez t2, medium_Sel	# set level to hard
		
		j _wait_for_start
		
		easy_Sel:
		li t0, 4
		sw t0, level
		j _main_loop
		
		medium_Sel:
		li t0, 2
		sw t0, level
		j _main_loop
	
		hard_Sel:
		li t0, 0
		sw t0, level
		j _main_loop
		
	
	# update methods increment the sprites coordinates
	# draw methods display the sprite on the LED display at their x, y position	
						
_main_loop:
	jal detect_collision
	jal player_update
	jal enemy_update
	jal update_bullet	
	jal draw_arena
	jal player_draw
	jal draw_enemy
	jal draw_bullet		
	jal enemy_spawn

	jal     handle_input		 # updates the button pressed variables
	jal	display_update_and_clear
	jal	wait_for_next_frame 	 # This function will block waiting for the next frame
	b	_main_loop		 # continue game loop infinitely 
	
_main_game_over:
	exit

# --------------------------------------------------------------------------------------------------
# call once per main loop to keep the game running at 60FPS.
# if your code is too slow (longer than 16ms per frame), the framerate will drop.
# otherwise, this will account for different lengths of processing per frame.

wait_for_next_frame:
	enter	s0
	lw	s0, last_frame_time
_wait_next_frame_loop:
	# while (sys_time() - last_frame_time) < GAME_TICK_MS {}
	li	v0, 30
	syscall # why does this return a value in a0 instead of v0????????????
	sub	t1, a0, s0
	bltu	t1, GAME_TICK_MS, _wait_next_frame_loop

	# save the time
	sw	a0, last_frame_time

	# frame_counter++
	lw	t0, frame_counter
	inc	t0
	sw	t0, frame_counter
	leave	s0

# --------------------------------------------------------------------------------------------------
