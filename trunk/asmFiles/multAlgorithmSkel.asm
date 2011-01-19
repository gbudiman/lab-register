	org		0x0000
	ori		$sp, $zero, 0x3FF8 # two spots lower

mult:
	#     < insert your code here >
	#     < notice that the stack has already been setup >
	or		$s3, $zero, $zero 			# $s3 = result
	or		$s4, $zero, $zero
	ori		$s4, $s4, 1					# $s4 = 1, masking
	or		$s5, $zero, $zero			# $s5 = number of shifts done
	or		$s6, $zero, $zero
	ori		$s6, $s6, 32				# $s6 = 32, iteration limits
	lw		$t1, 0($sp)					
	addiu	$sp, $sp, 4
	lw		$t2, 0($sp)
	addiu	$sp, $sp, 4

test_for_iteration:
	beq		$s5, $s6, fin				# 32 iterations reached -> FIN
normal_op:
	and		$s1, $t1, $s4				# $s1 = multiplier, grab LSB only
	beq		$s1, $0, multiplier_is_0	# compare with 0
multiplier_is_1:						# LSB = 1, do process
	add		$s3, $s3, $t2
multiplier_is_0:						# LSB = 0, do next iteration
	srl		$t1, $t1, 1					# shift right multiplier
	sll		$t2, $t2, 1					# shift left multiplicand
	addiu	$s5, $s5, 1					# increment iterator
	jal		test_for_iteration
	#			< END >
fin:
	srl		$s7, $s5, 3					# SRL 3 times on 32 to yield 4
	subu	$sp, $sp, $s7
	sw		$s3, 0($sp)
	halt

	org		0x3FF8
	cfw		1000000	
	cfw		4295
