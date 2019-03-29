.globl player_image
.globl bullet_image

.globl x_coord
.globl y_coord
.globl bullet_x
.globl bullet_y
.globl bullet_active

.data
x_coord: .word 0
y_coord: .word 0

bullet_x: 	.word 0
bullet_y: 	.word 0
bullet_active: 	.word 0	# 1 true 0 false


player_image: .byte
	-1 -1  7 -1 -1
	-1  7  4  7 -1
	 7  4  4  4  7
	 7  7  7  7  7
	 7 -1  1 -1  7
		
bullet_image: .byte	
	-1  -1   1  -1  -1
	-1  -1   1  -1  -1
	-1  -1  -1  -1  -1
	-1  -1  -1  -1  -1 
	-1  -1  -1  -1  -1
