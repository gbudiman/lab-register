	org		0x0000

	ori		$sp, $zero, 0x4000
	ori		$3, $zero, 15
	ori		$4, $zero, 8
	ori		$5, $zero, 3
	ori		$6, $zero, 17
	ori		$7, $zero, 6
	ori		$s0, $zero, 4		# $s0 contains constant 4

#	< push $3 >
	subu	$sp, $sp, $s0
	sw		$3, 0($sp)
#	< push $4 >
	subu	$sp, $sp, $s0
	sw		$4, 0($sp)
#	< push $5 >
	subu	$sp, $sp, $s0
	sw		$5, 0($sp)
#	< push $6 >
	subu	$sp, $sp, $s0
	sw		$6, 0($sp)
#	< push $7 >
	subu	$sp, $sp, $s0
	sw		$7, 0($sp)

#	< jump to mult >
	jal		mult
#	< jump to mult >
	jal		mult
#	< jump to mult >
	jal		mult
#	< jump to mult >
	jal		mult
#	15 * 8 * 3 * 17 * 6  should be at 0x3FFC
	halt

	org 0x0800
mult:
  lw      $t1, 0($sp)
  addiu   $sp, $sp, 4

  lw      $t2, 0($sp)
  addiu   $sp, $sp, 4

  andi    $t3, $zero, 0       # $t3 = result

reiterate:
  andi    $s1, $t1, 1
  beq     $s1, $zero, multiplier_is_0
multiplier_is_1:
  addu    $t3, $t3, $t2
multiplier_is_0:
  srl     $t1, $t1, 1
  sll     $t2, $t2, 1
  bne     $t1, $zero, reiterate

  addiu   $sp, $sp, -4
  sw      $t3, 0($sp)
	jr			$31
