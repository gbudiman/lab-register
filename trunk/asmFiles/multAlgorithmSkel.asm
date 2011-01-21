	org		0x0000
	ori		$sp, $zero, 0x3FF8 # two spots lower

mult:
	lw			$t1, 0($sp)
	addiu 	$sp, $sp, 4

	lw			$t2, 0($sp)
	addiu		$sp, $sp, 4

	andi		$t3, $zero, 0				# $t3 = result
	
reiterate:
	andi		$s1, $t1, 1
	beq			$s1, $zero, multiplier_is_0
multiplier_is_1:
	addu		$t3, $t3, $t2
multiplier_is_0:
	srl			$t1, $t1, 1
	sll			$t2, $t2, 1
	bne			$t1, $zero, reiterate

	addiu		$sp, $sp, -4
	sw			$t3, 0($sp)

	halt

	org		0x3FF8
	cfw		5	
	cfw		10
