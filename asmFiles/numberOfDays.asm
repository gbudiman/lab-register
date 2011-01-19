	org		0x0000
	ori		$sp, $zero, 0x4000
	ori		$t0, $zero, 2010		# t0 - YEAR
	ori		$t1, $zero, 9			# t1 - MONTH
	ori		$t2, $zero, 17			# t2 - DAY
	andi	$t3, $zero, 0			# t3 - zerofill result
	andi	$t4, $zero, 0			# t4 - temporary accumulator
	ori		$s0, $zero, 4			# $s0 contains constant 4
	
	subu	$sp, $sp, $s0
	sw		$t0, 0($sp)				# push YEAR -> $t0
	subu	$sp, $sp, $s0
	sw		$t1, 0($sp)				# push MONTH -> $t1
	subu	$sp, $sp, $s0
	sw		$t2, 0($sp)				# push DAY -> $t2

	lw		$t3, 0($sp)				# $t3 += DAY
	addiu	$sp, $sp, 4				# pop DAY -> $t3
	lw		$t4, 0($sp)
	addiu	$sp, $sp, 4				# pop MONTH -> $t4
	ori		$s1, $zero, 1			# $s1 now contains 1
	subu	$t4, $t4, $s1			# $t4 = $t4 - $s1

	subu	$sp, $sp, $s0			
	sw		$t4, 0($sp)				# push MONTH - 1
	ori		$t4, $zero, 30			# t4 = 30
	subu	$sp, $sp, $s0
	sw		$t4, 0($sp)				# push 30
	jal 	mult					# (MONTH - 1) * 30
	
	lw		$t4, 0($sp)
	addiu	$sp, $sp, 4				# pop multiplication result
	addu	$t3, $t3, $t4			# add to result register

	lw		$t4, 0($sp)
	addiu	$sp, $sp, 4				# pop YEAR -. $t4
	ori		$s1, $zero, 2000		# $s1 now contains 2000
	subu	$t4, $t4, $s1			# $t4 = $t4 - $s1

	subu	$sp, $sp, $s0
	sw		$t4, 0($sp)				# push YEAR - 2000
	ori		$t4, $zero, 365			# t4 = 365
	subu	$sp, $sp, $s0
	sw		$t4, 0($sp)				# push 365
	jal		mult					# (YEAR - 2000) * 365

	lw		$t4, 0($sp)
	addiu	$sp, $sp, 4				# pop multiplication result
	addu	$t3, $t3, $t4			# add to result register

	subu	$sp, $sp, $s0
	sw		$t3, 0($sp)				# push final result
	halt

mult:
    or      $s3, $zero, $zero           # $s3 = result
    or      $s4, $zero, $zero
    ori     $s4, $s4, 1                 # $s4 = 1, masking
    or      $s5, $zero, $zero           # $s5 = number of shifts done
    or      $s6, $zero, $zero
    ori     $s6, $s6, 32                # $s6 = 32, iteration limits
    lw      $t1, 0($sp)
    addiu   $sp, $sp, 4
    lw      $t2, 0($sp)
    addiu   $sp, $sp, 4

test_for_iteration:
    beq     $s5, $s6, fin               # 32 iterations reached -> FIN
normal_op:
    and     $s1, $t1, $s4               # $s1 = multiplier, grab LSB only
    beq     $s1, $0, multiplier_is_0    # compare with 0
multiplier_is_1:                        # LSB = 1, do process
    add     $s3, $s3, $t2
multiplier_is_0:                        # LSB = 0, do next iteration
    srl     $t1, $t1, 1                 # shift right multiplier
    sll     $t2, $t2, 1                 # shift left multiplicand
    addiu   $s5, $s5, 1                 # increment iterator
    j       test_for_iteration
    #           < END >
fin:
    srl     $s7, $s5, 3                 # SRL 3 times on 32 to yield 4
    subu    $sp, $sp, $s7
    sw      $s3, 0($sp)
	jr		$31
    halt 

