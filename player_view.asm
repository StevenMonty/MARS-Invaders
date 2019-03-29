## This file implements the functions that display the player object

# Include the convenience file so that we save some typing! :)
.include "convenience.asm"
# Include the game settings file with the board settings! :)
.include "game.asm"
# We will need to access the player model
#.include "player_model.asm"

# This function needs to be called by other files, so it needs to be global
.globl player_draw
.globl player_draw_args

.text
			
player_draw:
	enter
	lw	a0, x_coord
	lw	a1, y_coord
	la	a2, player_image 	# pointer to the image
	jal	display_blit_5x5_trans
	leave

#a0, a1 expected 	
player_draw_args:	# used in the arena to draw the player sprite in the corner to represent lives
	enter a0, a1
	
	la	a2, player_image 	# pointer to the image
	jal	display_blit_5x5_trans
	
	leave a0, a1
	
	
