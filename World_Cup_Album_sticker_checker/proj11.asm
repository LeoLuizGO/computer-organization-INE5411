.data 	
	#arquivos
	fin:	.asciiz "todasfigurinhas.txt"
		.align 0
	finwords: .space 4048
	
	fobtainedstickers: .asciiz "figurinhasobtidas.txt"
		.align 0
	fobtainedstickerswords: .space 4048
	
	fout:	.asciiz "figurinhasfaltantes.txt"			#figurinhas faltantes
		.align 0
	foutwords:.space 4048
	
	reset: .space 4048
	#mensagens e perguntas
	menudialog:	.asciiz "\nMenu: \n1- Remove Sticker of missing\n2- Update file\n3- Restart album\n4- Check Sticker\n5- Exit\n"
	
	menuerrordialog: .asciiz "\nThis command it is invalid. Please digit some valid command.\n"
	
	checkpositivedialog: .asciiz "\nYou already have this sticker\n"
	
	checknegativedialog: .asciiz "\nYou do NOT have this sticker yet\n"
	
	notfoundstickerdialog: .asciiz "\nYou already have this sticker or it doesn't exist\n"
	
	newalbumdialog: .asciiz "\nNew album detected, if you already have a album please check your files\n"
	
	existsalbumdialog: .asciiz "\nThe album already exist, if you want to restart please select the option 3 in menu\n"
	
	missingstickers:	.asciiz "\nThis is yours missings stickers\n"
	
	checkdialog:	.asciiz "\nWrite the sticker which you want to check if you already have it:\n"
	buffercheck:	.space 7
	
	removestickerdialog: .asciiz "\nWrite the sticker which you want to remove:\n"
	bufferin: .space 7
	
	confirm:	.asciiz "\nDo you want to create the missing stickers file? (y/n) \n"
	bufferconfirm:	.space 2
	
	restartalbumdialog:	.asciiz "\nAre you sure you want to restart the album and DELETE all the progress? (y/n) \n"
	bufferrestart:	.space 2
	
	restartalbumdialog2:	.asciiz "\nAlready do not have an album\n"
	
	restartalbumdialog3:	.asciiz "\nAlbum restarted successfully.\n"
	
	congratulationsmsg:	.asciiz "Album has been completed, congratulations! "
	
	obtainedstickersdialog:	.asciiz "\nThis is yours obtained stickers:\n"
	
	array: .byte 0
	
.text
	main:
		#abre o arquivo todasfigurinhas.txt para verificar a posição 4017
		li $v0, 13 			
		la $a0, fin			
		li $a1, 0 			
		li $a2, 0	
		syscall 			
		move $s6, $v0 			
	
		li   $v0, 14       
		move $a0, $s6     
		la   $a1, finwords  
		li   $a2, 4048   
		syscall      
		
		li $v0, 16
		move $a0, $s6
		syscall 
		
		la $t1, finwords
		lb $t2, 4017($t1)
		
		#essa posição determina se ja tem um album ou n
		beq $t2, 32, newalbum
		beq $t2, 8, fileexist 
		
	fileexist:
		#aquela verificação é mais pra ver se tem algum arquivo de figurinhas obtidas, essa ve no arquivo se ja tem algum album ou n
		li $v0, 13 			
		la $a0, fobtainedstickers			
		li $a1, 0 	
		li $a2, 0	
		syscall 			
		move $s6, $v0 			
		
		li   $v0, 14       
		move $a0, $s6     
		la   $a1, fobtainedstickerswords  
		li   $a2, 4048   
		syscall      
	
		li $v0, 4
		la $a0, fobtainedstickerswords
		syscall		
		
		li $v0, 16
		move $a0, $s6
		syscall 
		#se o primeiro caracter for um espaço entao é um novo album
		la $s0, fobtainedstickerswords
		lb $t1, 0($s0)
		beq $t1, 32, newalbum
		bne $t1, 32, albumexists
	albumexists:
		#printa msg de album existente e as figurinhsa faltantes
		li $v0, 4 		
		la $a0, existsalbumdialog 	
		syscall
	
		li $v0, 13 			
		la $a0, fout			
		li $a1, 0 		
		syscall 			
		move $s0, $v0 			
	
		li   $v0, 14       
		move $a0, $s0      
		la   $a1, foutwords  
		li   $a2, 4048   
		syscall      
	
		#printa a mensgaem das figurinhas faltantes
		li $v0, 4 		
		la $a0, missingstickers 
		syscall
		#printa o q tem no foutwords
		li $v0, 4
		la $a0, foutwords
		syscall		
		
		li $v0, 16
		move $a0, $s0
		syscall 
	#aqui passa as figurinhas faltantes para o array
		la $s0, foutwords
         	la $s1, array
	looparray:
		lb $t0, 0($s0)
		sb $t0, 0($s1)
		
		add $s0, $s0, 1
		add $s1, $s1, 1
		
		bne $t0, 32, looparray

		
		j menu
	 newalbum:
	 	#aqui escreve apenas um espaço no arquivo de figurinhas obtidas
	 	la $s0, fobtainedstickerswords
	 	li $t0, 32
	 	sb $t0, 0($s0)
	 
		li $v0, 13 			
		la $a0, fobtainedstickers	
		li $a1, 1 			
		li $a2, 0 			 
		syscall 			
		move $s6, $v0 			
		
		li $v0, 15 			
		move $a0, $s6 			
		la $a1, fobtainedstickerswords 	 
		li $a2, 4048 			
		syscall 			
	

		li $v0, 16 			
		move $a0, $s6 			
		syscall 			
			
		#printa mensagem de novo album			
		li $v0, 4 		
		la $a0, newalbumdialog 
		syscall
	
		#printa o q tem no finwords
		li $v0, 4
		la $a0, finwords
		syscall		
		#joga os valores de todasfigurinhas.txt no array	
         	la $s0, finwords
         	la $s1, array
	looparraynew:
		lb $t0, 0($s0)
		sb $t0, 0($s1)
		
		add $s0, $s0, 1
		add $s1, $s1, 1
		
		bne $t0, 32, looparraynew

  #---------------------menu-------------------------------------------------		
	menu:
		li $v0, 4 		# Comando.
		la $a0, menudialog 	# Carrega string (endereço).
		syscall
		
		li $v0, 5 		# Comando para ler inteiro.
		syscall
 		move $t0, $v0 		# Resultado é salvo em $t0.
           	
           	beq $t0, 1, removesticker
           	beq $t0, 2, save
           	beq $t0, 3, restartalbum
           	beq $t0, 4, check
           	beq $t0, 5, end
           	
           	#mensagem de erro
           	li $v0, 4 		
		la $a0, menuerrordialog
		syscall
           	bne $t0, 5, menu
  #-----------------------------------------------remove------------------------------------------------------	
	removesticker:
		#pede figurinha
		li $v0, 4 		
		la $a0, removestickerdialog 	
		syscall
		#escreve figurinha no bufferin
		li $v0, 8 			
         	la $a0, bufferin 		
         	li $a1, 6 			
         	move $t0, $a0 			
         	syscall
         	
		la $s0, bufferin
  		la $s1, array
  		li $t9, 0
  		li $t8, 0
  	#loop que verifica se a figurinha está no array (todas as figurinhas ou figurinhas faltantes)
        loopverification:
        	lb $t0, 0($s0)	#elemento do buffer
        	lb $t1, 0($s1)  #elemento do array
        	
        	add $s0, $s0, 1
		add $s1, $s1, 1
        	
        	beq $t1, 9, restartcount	#se tiver um tab recomeça a contagem do buffer
        	beq $t1, 10, restartcount	#se tiver um enter tambem
        	beq $t1, 32, notfoundsticker	#se tiver espaço é pq acabou as figurinhas
        	beq $t1, 8, restartcount
        	bne $t0, $t1, loopverification  #se n for igual continua o loop
        	beq $t0, $t1, count		#se for igual conta ate chegar a 5 ou 2
        	
        restartcount:
        	li $t9, 0
        	li $t8, 0			#zera os contadores
        	la $s0, bufferin
        	j loopverification
        	
        count:
        	beq $t0, 48, countspecial 	#caso especial do 00, em que é apenas 2, registrador especial pra ele (t8)
        	addi $t9, $t9, 1
        	beq $t9, 5, foundstickerequal
        	j loopverification
        	
        countspecial:
        	addi $t8, $t8, 1
        	addi $t9, $t9, 1		#há figurinhas com o número 0, então é bom que adicione 1 aqui também
        	beq $t8, 2, foundstickerequalspecial
        	beq $t9, 5, foundstickerequal
        	j loopverification
        	
        foundstickerequalspecial:		#salva na pilha
                la $s1, array			#calcula quantos digitos estão registrados na pilha para depois por esse numero exclui-los
        	addi $sp, $sp, -3
        	addi $s4, $s4, 3
        	lb $t2, 0($s1)
        	sb $t2, 0($sp)
        	lb $t2, 1($s1)
        	sb $t2, 1($sp)
        	li $t2, 9
        	sb $t2, 2($sp)
        	
        	li $t8, 8
        	sb $t8, 0($s1)
        	sb $t8, 1($s1)
        	j save
        	
        foundstickerequal:       	
        	addi $sp, $sp, -6
        	addi $s4, $s4, 6			#s4 apenas pra contar 
        	lb $t2, -5($s1)
        	sb $t2, 0($sp)
        	lb $t2, -4($s1)
        	sb $t2, 1($sp)
        	lb $t2, -3($s1)
        	sb $t2, 2($sp)
        	lb $t2, -2($s1)
        	sb $t2, 3($sp)
        	lb $t2, -1($s1)
        	sb $t2, 4($sp)
        	li $t2, 9
        	sb $t2, 5($sp)
        	
        	li $t8, 8			#usando 8 pra substituir a figurinha que foi excluido
        	sb $t8, -1($s1)			#pois na hora de passar pro buffer do arquivo de faltantes
        	sb $t8, -2($s1)			#passo apenas os elementos que nao sao 8
        	sb $t8, -3($s1)			#8 é o backspace na tabela ascii
        	sb $t8, -4($s1)
        	sb $t8, -5($s1)
        	
        	lb $t2, 0($s1)
        	beq $t2, 32, save
        	sb $t8, 0($s1)
        	
        	j save
        notfoundsticker:
        	li $v0, 4			#caso nada for encontrado, ou seja chegou a 32 (indica final de arquivo) e nao encontrou nada
		la $a0, notfoundstickerdialog 
		syscall
		j menu
	#----------------------------------save------------------------------------------------------------------------------
       	save:
        	li $v0, 4 
		la $a0, confirm
		syscall
		
		li $v0, 8 			
         	la $a0, bufferconfirm 		
         	li $a1, 2 			
         	move $t0, $a0 			
         	syscall
         	
         	la $s3, bufferconfirm
         	lb $t3, 0($s3)
         	
         	beq $t3, 121, continue	 	#se nao for y acaba o programa, depois é pra ir pra um menuzin
         	beq $t3, 89, continue		#pode ser Y também
         	bne $t3, 89, menu

      continue: 
      		la $s0, foutwords
      		
      		move $a0, $s0
        	jal deleteallfout
        	  	
        	  	  	  	
         	la $t0, array
         	la $t1, foutwords
         	la $t2, congratulationsmsg
         			
         	         	
         	move $a0, $t0
         	move $a1, $t1	         	
         	move $a2, $t2
         	
         	jal saveinfout			#procedimento pra salvar cada elemento dentro do arquivo em txt
         	
         	
         	li $v0, 13 			
		la $a0, fout 			
		li $a1, 1 			
		li $a2, 0 			
		syscall 			
		move $s6, $v0 			
		
		li $v0, 15 			
		move $a0, $s6 			 
		la $a1, foutwords 		
		li $a2, 4048 			
		syscall 			
	
		li $v0, 16 			
		move $a0, $s6 			
		syscall 			
		
		#escreve na posição 4017 de todasfigurinhas.txt 8 o que indica que não é um album novo
		la $t1, finwords
		li $t0, 8
		sb $t0, 4017($t1)
		
		li $t1, 0
		li $t0, 0
		#SALVAR SE TEM ALGUM PROGRESSO OU NÃO -- TODASFIGURINHAS.TXT
         	li $v0, 13 			 
		la $a0, fin 			
		li $a1, 1 			
		li $a2, 0 			
		syscall 			
		move $s6, $v0 			
		
		li $v0, 15 			 
		move $a0, $s6 			 
		la $a1, finwords 		
		li $a2, 4048 			
		syscall 			
	

		li $v0, 16 			
		move $a0, $s6 			
		syscall 			
		
		j saveinfobtainedstickers
        saveinfout:
        	#addi $a0, $a0, -1
        	#addi $a1, $a1, -1
        	li $t2, 0
        	loopsave:
        		lb $t0, 0($a0)
        		beq $t0, 8, equal_8

        		sb $t0, 0($a1)
        		addi $a0, $a0, 1
        		addi $a1, $a1, 1
        		addi $t2, $t2, 1        		
        		
        		beq $t2, 4048, endcongratulations
        		beq $t0, 32, endsave
        		bne $t0, 32, loopsave
        	equal_8:
        		addi $a0, $a0, 1
        		lb $t9, 1($a0)
        		beq $t9, 9, equal_tab_after_8	#caso tenha tab depois do backspace, aumenta um também, pra nao entrar no arquivo e ficar 2 tab
        		j loopsave
        	equal_tab_after_8:
        		addi $a0, $a0, 1
        		j loopsave
        	endcongratulations:
        		sub $a1, $a1, 4048		
        		loopendcongratulations:
        			lb $t0, ($a2)
        			sb $t0, ($a1)
        			addi $a1, $a1, 1
        			addi $a2, $a2, 1
        			bne $t0, 33, loopendcongratulations

        			jr $ra
        			
        	endsave:
        		li $t2, 32
        		sb $t2, 0($a1)
        		jr $ra
        saveinfobtainedstickers:
        	li $t2, 0
        	la $s0, fobtainedstickerswords
        	loopendfileobtainedstickers:	#esse loop vai ajduar a descobrir qual é o final do arquivo para adicionar as novas figurinhas

        	lb $t1, 0($s0)
        	addi $s0, $s0, 1
        	addi $t2, $t2, 1
        	bne $t1, 32, loopendfileobtainedstickers
        	
        	sub $t2, $t2, 1 #diminui um pra tirar o espaço de antes e por um novo no futuro
        	
        	la $t0, ($sp)
         	la $t1, fobtainedstickerswords
         	add $t1, $t1, $t2
         	
         	move $a0, $t0
         	move $a1, $t1
         	move $a3, $s4
         	jal movearraytobuffer
         	
         	
         	li $v0, 13 			
		la $a0, fobtainedstickers	
		li $a1, 1 			
		li $a2, 0 			 
		syscall 			
		move $s6, $v0 			
		
		li $v0, 15 			
		move $a0, $s6 			
		la $a1, fobtainedstickerswords 	 
		li $a2, 4048 			
		syscall 			

		li $v0, 16 			
		move $a0, $s6 			
		syscall 			
		
		#loop pra zerar o stack---------------------------------------------------------------------------
		li $t1, 0
		li $t2, 0
		la $s0, ($sp)
		
		looprestartsp:
		sb $t2, 0($sp)
		
		addi $sp, $sp, 1
		addi $t1, $t1, 1
		
		bne $t1, $s4, looprestartsp		#usando o numero calculado anteriormente de quantas adições de figurinhas foram feitas
		
		li $s4, 0
		li $t1, 0
		li $t2, 0
		li $t8, 0 
		li $t9, 0 #bom zerar os registradores, porque no futuro serão utilizados
		
		li $v0, 4
		la $a0, obtainedstickersdialog
		syscall	
		
		#printa o q tem no fobtainedstickers
		li $v0, 4
		la $a0, fobtainedstickerswords
		syscall	
		
		j menu
		
	movearraytobuffer:
		li $t1, 0
		li $t0, 0
		looparraytobuffer:
			lb $t0, 0($a0)
        		sb $t0, 0($a1)
        		
        		addi $a0, $a0, 1
        		addi $a1, $a1, 1
        		
        		addi $t1, $t1, 1
        		        		        		
        		beq $t1, $a3, endloopa2b
        		bne $t1, $a3, looparraytobuffer
        	endloopa2b:
        		li $t0, 32
        		sb $t0, 0($a1)
        		jr $ra
    #----------------------------------restart-----------------------------------------------------------------
    	restartalbum:
    		li $v0, 4 		
		la $a0, restartalbumdialog 	
		syscall
		
		li $v0, 8 			
         	la $a0, bufferrestart 		
         	li $a1, 2 			
         	move $t0, $a0 			
         	syscall
         	
         	la $t3, bufferrestart
         	lb $t3, 0($t3)
         	
         	beq $t3, 121, continuerestart	 	#se nao for y acaba o programa, depois é pra ir pra um menuzin
         	beq $t3, 89, continuerestart		#pode ser tanto y como Y
         	bne $t3, 89, menu
         	
         continuerestart:
         	la $t1, reset
         	li $t2, 32
         	
         	sb $t2, 0($t1)
         	sb $t2, 1($t1)
         	sb $t2, 2($t1)
         	sb $t2, 3($t1)

         	li $v0, 13 			
		la $a0, fobtainedstickers	
		li $a1, 1 			
		li $a2, 0 			 
		syscall 			
		move $s6, $v0 			
		
		li $v0, 15 			
		move $a0, $s6 			
		la $a1, reset 		
		li $a2, 4048 			
		syscall 			
	
		li $v0, 16 			
		move $a0, $s6 			
		syscall 	
		
		la $t1, finwords
		li $t0, 32			#SALVA 32 AQUI PARA INFORMAR QUE É ARQUIVO NOVO
		sb $t0, 4017($t1)
		
		li $t1, 0
		li $t0, 0
		
		#SALVAR SE TEM ALGUM PROGRESSO OU NÃO -- TODASFIGURINHAS.TXT
         	li $v0, 13 			
		la $a0, fin 			
		li $a1, 1 			
		li $a2, 0 			
		syscall 			
		move $s6, $v0 			
		
		li $v0, 15 			
		move $a0, $s6 			
		la $a1, finwords 		
		li $a2, 4048 			
		syscall 			

		li $v0, 16 			
		move $a0, $s6 			
		syscall 			
		
		
		li $t1, 0
		li $t2, 0
		
		j main
    #--------------------------------------check--------------------------------------------------------------- 		
        		
	check:
		#pede figurinha para verificação
		#mesma lógica do remove, mas para no processo
		li $v0, 4 		
		la $a0, checkdialog 	
		syscall
		
		li $v0, 8 			
         	la $a0, buffercheck 		
         	li $a1, 6 			
         	move $t0, $a0 			
         	syscall
         	
		la $s0, buffercheck
  		la $s1, fobtainedstickerswords
  		li $t8, 0
  		li $t9, 0
  		li $t3, 0
        loopverificationcheck:
        	lb $t0, 0($s0)	#elemento do buffer
        	lb $t1, 0($s1)  #elemento do buffer de figurinhas obtidas
        	
        	add $s0, $s0, 1
		add $s1, $s1, 1
        	add $t3, $t3, 1
        	
        	beq $t3, 4048, notfoundstickercheck
        	beq $t1, 9, restartcountcheck	#se tiver um tab recomeça a contagem do buffer
        	beq $t1, 10, restartcountcheck	#se tiver um enter tambem
        	beq $t1, 32, notfoundstickercheck		#se tiver espaço é pq acabou as figurinhas VERIFICAR AQUI ----------------------------------
        	bne $t0, $t1, loopverificationcheck  #se n for igual continua o loop
        	beq $t0, $t1, countcheck		#se for igual conta ate chegar a 5 ou 2
        	
        restartcountcheck:
        	li $t9, 0
        	li $t8, 0			#zera os contadores
        	la $s0, buffercheck
        	j loopverificationcheck
        	
        countcheck:
        	beq $t0, 48, countspecialcheck 	#caso especial do 00, em que é apenas 2, registrador especial pra ele (t8)
        	addi $t9, $t9, 1
        	beq $t9, 5, foundstickercheck
        	j loopverificationcheck
        	
        countspecialcheck:
        	addi $t8, $t8, 1
        	addi $t9, $t9, 1		#há figurinhas com o número 0, então é bom que adicione 1 aqui também
        	beq $t8, 2, foundstickercheck
        	beq $t9, 5, foundstickercheck
        	j loopverificationcheck
        	
        foundstickercheck:
        	li $v0, 4 		
		la $a0, checkpositivedialog 	
		syscall
		j menu
	notfoundstickercheck:
		li $t3, 0
		li $v0, 4
		la $a0, checknegativedialog
		syscall
		j menu
    #-------------------------------------------------fim----------------------------------------------------
 	deleteallfout:
 		la $s0, foutwords
 		li $t2, 0
 		li $t1, 0
 	loopdelfout:
 		lb $t0, ($s0)
 		beq $t0, 0, enddel
 		beq $t0, 32, enddel
 		sb $t1, ($s0)
 		addi $s0, $s0, 1
 		
 		bne $t0, 32, loopdelfout
 		
 	enddel:
 		li $v0, 4 		
		la $a0, foutwords 	
		syscall
 		jr $ra

 	
 	end:
 		nop
