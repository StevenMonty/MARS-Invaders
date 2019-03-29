## This file implements the functions that control the enemy 
.include "enemy_struct.asm"
.include "convenience.asm"
.globl draw_enemy
.globl enemy_update
.globl enemy_spawn
.globl detect_collision

.data
collide: 	.asciiz "collision detected\n"
one:		.asciiz "made it past first branch\n"
two:		.asciiz "made it past second branch\n"
line:		.asciiz " \n"


collision_debug: .byte
	1 1  1 1 1
	1  -1  -1  -1 1
	 1  -1  -1  -1  1
	 1  -1  -1  -1  1
	 1 1  1 1  1

# array of enemy structs (active, x, y) update method loops through and if active then increments its y position


.text

draw_enemy:	 
	enter s0	
	li s0, 0	# int i = 0
	
		_draw_loop:
		beq s0, 5, _draw_exit	# while i < 5 (number of enemies)
		
		la t5, enemy_array	# load the enemy array into t5
		mul t1, s0, 12		# current enemy num * size between enemies
		add t5, t5, t1		# add the offset from prev instruction to the array address to get the current enemy
		lw  t2, active(t5)	# load the current enemys active status into t2
		
		beqz t2, _inactive	# if inactive, skip to bottom of the loop, draw nothing
		
		lw a0, x_pos(t5)
		lw a1, y_pos(t5)
		la a2, enemy_image 	# pointer to the image
		jal display_blit_5x5_trans
		j loop_cont

		_inactive:
		lw a0, x_pos(t5)
		lw a1, y_pos(t5)
#		beq a1, 53, loop_cont	# if end of screen, skip
		
		la a2, impact_image
		jal display_blit_5x5_trans
		
		loop_cont:
		inc s0				# i++
		j _draw_loop
	
	_draw_exit:
	leave s0
	
enemy_update:	
	
	enter s0
	li s0, 0	# int i = 0
	
	lw t1, level	# get level number 
	addi t1, t1, 8	# 8 FPS is the base number, add the level number to increase enemy speed
	
	lw t0, frame_counter		# get the current frame
	rem t0, t0, t1			# get the remainder of the current frame divided by the level
	bne t0, 0, _update_exit		# if the remainder is not 0, then exit. This only makes the enemies move every 4 frames	
		
		_update_loop:
		beq s0, 5, _update_exit	# while i < 5 (number of enemies)
		
		# iterate through the array of enemies and increment its y pos
		
		la t5, enemy_array	# load the enemy array into t5
		mul t1, s0, 12		# current enemy num * size between enemies
		add t5, t5, t1		# add the offset from prev instruction to the array address to get the current enemy address
		
		lw t0, active(t5)	# if enemy is inactive, jump to next loop iteration
		beqz t0, cont
		
		lw t0, y_pos(t5)	# load the current y position
		addi t0, t0, 1		# add one to move enemy down one pixel
		beq t0, 53, inactive	# if enemy y reaches 50, they are off the screen and become inactive
		sw t0, y_pos(t5)	# store the new y position to the array
		j cont			# if this line is reached, then  the enemy is still active and the inactive routine is skipped
		
		inactive:	
		li t1, 0		
		sw t1, active(t5)	# set the enemy as inactive so that they are no longer drawn
		lw t2, lives
		dec t2			# ******TODO********
		sw t2, lives		# if enemy reaches bottom of screen, the player loses a life		
		
		cont:																		
		inc s0			# i++
		b _update_loop

	_update_exit:
	leave s0
	
detect_collision: # a0 - address of the enemy		# TODO - ADD THE COLLISION ANIMATION

	enter s0, s1, s2, s7
	
	li s7, 0	# int i = 0
		
	detection_loop:
	
	la t5, enemy_array	# load the enemy array into t5
	mul t1, s7, 12		# current enemy num * size between enemies
	add t5, t5, t1		# add the offset from prev instruction to the array address to get the current enemy address	
	
	lw t0, active(t5)
	beq t0, 0, _loop_cont
	
	lw s0, x_pos(t5)	# load the x position of current enemy ship
	lw s1, y_pos(t5)	# load the y position of current enemy ship
	addi, s2, s0, 4		# add the ship width to the x pos of the enemy
	addi s3, s1, 4		# add the ship depth to the y pos of the enemy
	
	bullet:			# collision with bullet
	
	lw t0, bullet_x
	lw t1, bullet_y
	lw t3, bullet_active
	
	beq t3, 0, player	# if bullet is inactive, skip rest of sub routine
	
	addi t0, t0, 2		# add offset of the bullet being a 5x5 object but only displaying 1 pixel
	
	move t3, s0		# sprite coords start in the top left corner
	addi t3, t3, 4		# add ship width to the x pos of the enemy
	
	blt t0, s0, player	# if the bullet x < lower ship x, skip to player check
	bgt t0, t3, player	# if the bullet x > upper ship x, skip to player check (allows for any pixel of ship to be hit)
	bgt t1, s3, player	# if the bullet y > ship y, bullet has not reached enemy yet
			
	li t2, 0
	sw t2, active(t5)	# make ship go inactive on collision
	sw t2, bullet_active	# make the bullet go inactive on collision
	
	lw t3, score
	inc t3			# increment the score on ship destruction
	sw t3, score
												
	player:			# collision with player
	lw t0, x_coord		# load player x lower bound
	lw t1, y_coord		# load player y
	
	addi t2, t0, 4		# add width of the player x to get upper bound
	addi t3, t1, 4		# add depth of the player to the y

	blt t2, s0, _loop_cont	# if player upper x bound is < enemy lower x bound, no collision
	bgt t0, s2, _loop_cont	# if player upper y bound is > enemy lower y bound, no collision
	bgt t1, s3, _loop_cont 	# if player lower x bound is > enemy upper x bound, no collision
		
#	move a0, s0
#	move a1, s1
#	la a2, collision_debug
#	jal display_blit_5x5_trans
	
	lw t2, lives
	dec t2			# decrement the player lives on collision
	sw t2, lives	
	
	li t3, 0
	sw t3, active(t5)	# set enemy inactive on collision
	
	_loop_cont:
	inc s7			# i++
	blt s7, 5, detection_loop	# while i < 5

	leave s0, s1, s2, s7
	
enemy_spawn:	# iterate through the array of enemies and if one is inactive, then spawn a new one at a random x pos

	enter s0

	lw t0, frame_counter		# get the current frame
	rem t0, t0, 10			# get the remainder of the current frame divided by 10
	bne t0, 0, _spawn_exit		# if the remainder is not 0, then exit. This allows enemies to spawn every 10 frames

	li s0, 0			# int i = 0
	
	spawn_loop:

		beq s0, 5, _spawn_exit	# while i < 5
		
		li v0, 42		# random int gen
		li a0, 0		# gen #1
		li a1, 60		# upper bound
		syscall			# return random int to v0
		
		blt a0, 3, spawn_cont
		
		la t5, enemy_array	# load the enemy array into t5
		mul t1, s0, 12		# current enemy num * size between enemies
		add t5, t5, t1		# add the offset from prev instruction to the array address to get the current enemy
		
		lw t0, active(t5)	# load the active flag for the current enemy
		beq t0, 1, spawn_cont	# if enemy is alredy active, skip

		li t0, 1		# enemy active
		move t1, a0		# move the random int into the inital y position
		li t2, 0		# x = 0, top of screen
	
		sw t0, active(t5)	# store new values
		sw t1, x_pos(t5)
		sw t2, y_pos(t5)
		
		spawn_cont:
		inc s0
		j spawn_loop
	
	_spawn_exit:
	leave s0
