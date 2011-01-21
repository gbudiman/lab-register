	org		0x0000
	ori		$sp, $zero, 0x3FFC
	ori		$t0, $zero, 2010		# t0 - YEAR
	ori		$t1, $zero, 9			# t1 - MONTH
	ori		$t2, $zero, 14		# t2 - DAY
	andi	$t3, $zero, 0			# t3 - zerofill result
	andi	$t4, $zero, 0			# t4 - temporary accumulator
	ori		$s0, $zero, 4			# $s0 contains constant 4
	
	subu	$sp, $sp, $s0
	sw		$t0, 4($sp)				# push YEAR -> $t0
	subu	$sp, $sp, $s0
	sw		$t1, 4($sp)				# push MONTH -> $t1
	subu	$sp, $sp, $s0
	sw		$t2, 4($sp)				# push DAY -> $t2

	lw		$t3, 4($sp)				# $t3 += DAY
	addiu	$sp, $sp, 4				# pop DAY -> $t3
	lw		$t4, 4($sp)
	addiu	$sp, $sp, 4				# pop MONTH -> $t4
	ori		$s1, $zero, 1			# $s1 now contains 1
	subu	$t4, $t4, $s1			# $t4 = $t4 - $s1

	subu	$sp, $sp, $s0			
	sw		$t4, 4($sp)				# push MONTH - 1
	ori		$t4, $zero, 30			# t4 = 30
	subu	$sp, $sp, $s0
	sw		$t4, 4($sp)				# push 30
	jal 	mult					# (MONTH - 1) * 30
	
	lw		$t4, 4($sp)
	addiu	$sp, $sp, 4				# pop multiplication result
	addu	$t3, $t3, $t4			# add to result register

	lw		$t4, 4($sp)
	addiu	$sp, $sp, 4				# pop YEAR -. $t4
	ori		$s1, $zero, 2000		# $s1 now contains 2000
	subu	$t4, $t4, $s1			# $t4 = $t4 - $s1

	subu	$sp, $sp, $s0
	sw		$t4, 4($sp)				# push YEAR - 2000
	ori		$t4, $zero, 365			# t4 = 365
	subu	$sp, $sp, $s0
	sw		$t4, 4($sp)				# push 365
	jal		mult					# (YEAR - 2000) * 365

	lw		$t4, 4($sp)
	addiu	$sp, $sp, 4				# pop multiplication result
	addu	$t3, $t3, $t4			# add to result register

	subu	$sp, $sp, $s0
	sw		$t3, 4($sp)				# push final result
	halt

mult:
  lw      $t1, 4($sp)
  addiu   $sp, $sp, 4

  lw      $t2, 4($sp)
  addiu   $sp, $sp, 4

  andi    $t8, $zero, 0       # $t3 = result

reiterate:
  andi    $s1, $t1, 1
  beq     $s1, $zero, multiplier_is_0
multiplier_is_1:
  addu    $t8, $t8, $t2
multiplier_is_0:
  srl     $t1, $t1, 1
  sll     $t2, $t2, 1
  bne     $t1, $zero, reiterate

  addiu   $sp, $sp, -4
  sw      $t8, 4($sp)
	jr			$31
