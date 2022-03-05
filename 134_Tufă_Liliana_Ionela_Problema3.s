.data
	n: .space 4
	mesaj: .asciiz "nu exista"
	nl: .asciiz "\n"
	v: .space 400
	x: .word 0
	y: .word 0
	
.text

main:
	li $v0, 5
	syscall			#citim numarul n
	move $t0, $v0
	#sw $t0, n		
	
	subu $sp, $sp, 4
	#lw $t0, n		#punem numarul n in stiva
	sw $t0, 0($sp)
	
	li $s0, 0
loop:
	beq $s0, $t0, exit
	li $v0, 5		#de n ori citim lungimea fiecarui vector
	syscall 
	move $t1, $v0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	addi $s0, $s0, 1
	j loop_citire
loop_citire:
	bge $t4, $t1, main2
	li $v0, 5
	syscall
	move $t3, $v0		#punem elementele in vector
	sb $t3, v($t2)
	addi $t4, $t4, 1
	addi $t2, $t2, 4
	j loop_citire
main2:
	la $t3, v		#punem adresa vectorului in $t3
	jal nr_pare		#sarim la nr_pare
	li $s0, -1
	lw $t0, 4($sp)
	addu $sp, $sp, 4
	beq $t0, $s0, afisare_mesaj	#verificam daca e egal cu -1
	move $a0, $t0
	li $v0, 1
	syscall
	
	la $a0, nl
	li $v0, 4
	syscall
	j loop
	
afisare_mesaj:
	la $a0, mesaj
	li $v0, 4
	syscall
	
	la $a0, nl
	li $v0, 4
	syscall
	j loop
exit:
	addu $sp, $sp, 4
	li $v0, 10
	syscall
	
nr_pare:
	subu $sp, $sp, 4
	sw $fp, 0($sp)		#memoram vechea valoare a lui $fp
	addiu $fp, $sp, 0
	
	li $s0, 0
	li $s2, 2
	
	li $t4, -1
	sw $t4, x
	sw $t4, y	#pozitiile x si y le facem -1
	
parc_vector:
	bge $s0, $t1, verificare	#parcurgem elem vectorului
	lw $t2, 0($t3)
	rem $s1, $t2, $s2
	addi $t3, $t3, 4	
	beq $s1, $0, pozitie		#verificam daca e par
	addi $s0, $s0, 1
	j parc_vector
pozitie:

	lw $s3, x
	beq $s3, $t4, pozitie1		#daca prima pozitie e -1, atunci incrementam prima pozitie
	sw $s0, y
	addi $s0, $s0, 1		
	j parc_vector
pozitie1:
	sw $s0, x
	move $s3, $s0
	addi $s0, $s0, 1		
	j parc_vector			#alfel a doua pozitie e incrementata

verificare:
	lw $s3, x
	lw $s4, y
	bne $s3, $s4, adaugare.vector	#daca nu sunt egale mergem la adaugare.vector, alfel punem -1 in stiva
nu_exista:	
	#li $s3, -1
	subu $sp, $sp, 4
	sw $s3, 8($sp)
	lw $s0, 0($sp)
	addu $sp,$sp,  4
	jr $ra
adaugare.vector:
	beq $s4, $t4, adaug_0
	sub $s3, $s3, $s4
	abs $s3, $s3

	subu $sp, $sp, 4
	sw $s3, 8($sp)			#punem diferenta pozitiilor in stiva
	lw $s0, 0($sp)
	addu $sp, $sp, 4
	jr $ra
adaug_0:
	beq $s3, $t4, nu_exista 
	li $s4, 0
	subu $sp, $sp, 4
	sw $s4, 8($sp)			#daca exista un singur numar par, acela este primul si ultimul si diferenta pozitiilor este 0			
	lw $s0, 0($sp)
	addu $sp, $sp, 4
	jr $ra
