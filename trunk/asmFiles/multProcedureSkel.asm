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
    j	    test_for_iteration
    #           < END >
fin:
    srl     $s7, $s5, 3                 # SRL 3 times on 32 to yield 4
    subu    $sp, $sp, $s7
    sw      $s3, 0($sp)
	jr		$31
