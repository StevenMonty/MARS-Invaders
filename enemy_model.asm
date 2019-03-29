.globl enemy_image
.globl enemy_array
.globl impact_image

.data

enemy_array:	.word	0:15	# 3 fields x 5 enemies

# Enemy Model: - use the enemy_struct eqvs
# active flag - offset 0
# x coord     - offset 4
# y coord     - offset 8

enemy_image: .byte	# -1 = transparent
	1 -1  1 -1  1
	1  1  1  1  1
	1  3  3  3  1
       -1  1  3  1 -1
       -1 -1  1 -1 -1
	
impact_image: .byte
	7  0  7  0  7
	0  3  3  3  0
	7  3  1  3  7
	0  3  3  3  0
	7  0  7  0  7
