.include "convenience.asm"
.include "game.asm"


.data

.globl draw_arena

.text
draw_arena:
	enter
	
	li a0, 0
	li a1, 0
	li a2, DISPLAY_W
	li a3, DISPLAY_H
	li v1, 0  		# Background color = Black

	jal display_fill_rect
	
	# score display
	li a0, 1
	li a1, 58
	lw a2, bullets_left		
	jal display_draw_int

	# lives display
	lw t0, lives
	beq t0, 3, _3Lives
	beq t0, 2, _2Lives
	beq t0, 1, _1Life

	_3Lives:	# display 2 ships in the corner
			# fall into next code block
	li a0, 52
	li a1, 58
	jal player_draw_args
		
	_2Lives:	# display 1 ship in the corner
	li a0, 58	# fall into next code block
	li a1, 58
	jal player_draw_args
			
	_1Life:		# display no ships in the corner

	leave
	