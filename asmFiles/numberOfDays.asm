	org		0x0000
	ori		$sp, $zero, 0x4000
	ori		$t0, $zero, 2000		# t0 - YEAR
	ori		$t1, $zero, 1			# t1 - MONTH
	ori		$t2, $zero, 12			# t2 - DAY
	and		$t3, $zero, 0			# t3 - zerofill result
	ori		$0, $zero, 4			# $s0 contains constant 4
	
	subu	$sp, $sp, $s0
	sw		$t0, 0($sp)
	subu	$sp, $sp, $s0
	sw		$t1, 0($sp)
	subu	$sp, $sp, $s0
	sw		$t2, 0($sp)
	
