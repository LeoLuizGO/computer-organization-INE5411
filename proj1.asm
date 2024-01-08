.data 	
	menudialog:	.asciiz "Menu: \n1- Remove Sticker of missing\n2- Update file\n3- Restart album\n4- Check Sticker\n5- Exit\n"
	
	checkpositivedialog: .asciiz "\nYou already have this sticker\n"
	
	checknegativedialog: .asciiz "\nYou do NOT have this sticker yet\n"
	
	notfoundstickerdialog: .asciiz "\nYou already have this sticker or it doesn't exist\n"
	
	newalbumdialog: .asciiz "New album detected, if you already have a album please check your files\n"
	
	checkdialog:	.asciiz "Write the sticker which you want to check if you already have it:\n"
	buffercheck:	.space 7
	
	removestickerdialog: .asciiz "Write the sticker which you want to remove:\n"
	confirm:	.asciiz "Do you want to create the missing stickers file? (y/n)"
	bufferconfirm:	.space 2
	
	fin:	.asciiz "todasfigurinhas.txt"
		.align 0
	finwords: .space 4048
	
	bufferin: .space 7
	#bufferin:	.asciiz "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       " #ta aqui
	#	.align 2
	
	fobtainedstickers: .asciiz "figurinhasobtidas.txt"
	fobtainedstickerswords: .space 4048
	
	fout:	.asciiz "figurinhasfaltantes.txt"
	foutwords:.space 4048
	
	arraystickerobtained: .byte 0

	array: .byte 0
.text
	main:
		la $s2, arraystickerobtained #importante: só vai ser carregado o endereço base desse array uma vez
		#verificar se o arquivo de figurinhas obtidas está vazio
		#abertura do arquivo
		li $v0, 13 			
		la $a0, fobtainedstickers			
		li $a1, 0 		# indica leitura		
		syscall 			
		move $s0, $v0 			
	
		#lê o arquivo
		li   $v0, 14       
		move $a0, $s0      
		la   $a1, fobtainedstickerswords  
		li   $a2, 4048   
		syscall      
	
		#printa o q tem no finwords
		li $v0, 4
		la $a0, fobtainedstickerswords
		syscall		
		
		#fecha o arquivo
		li $v0, 16
		move $a0, $s0
		syscall 
		
		la $s0, fobtainedstickerswords
		lb $t1, 0($s0)
		beq $t1, 0, newalbum
		bne $t1, 0, albumexists
	albumexists:
		#abertura do arquivo
		li $v0, 13 			
		la $a0, fout			
		li $a1, 0 		# indica leitura		
		syscall 			
		move $s0, $v0 			
	
		#lê o arquivo
		li   $v0, 14       
		move $a0, $s0      
		la   $a1, foutwords  
		li   $a2, 4048   
		syscall      
	
		#printa o q tem no finwords
		li $v0, 4
		la $a0, foutwords
		syscall		
		
		#fecha o arquivo
		li $v0, 16
		move $a0, $s0
		syscall 
		
		la $s0, foutwords
         	la $s1, array
	looparray:
		lb $t0, 0($s0)
		sb $t0, 0($s1)
		
		add $s0, $s0, 1
		add $s1, $s1, 1
		
		bne $t0, 32, looparray
	 newalbum:
			
		li $v0, 4 		# Comando.
		la $a0, newalbumdialog 	# Carrega string (endereço).
		syscall
		#abertura do arquivo
		li $v0, 13 			
		la $a0, fin			
		li $a1, 0 		# indica leitura		
		syscall 			
		move $s0, $v0 			
	
		#lê o arquivo
		li   $v0, 14       
		move $a0, $s0      
		la   $a1, finwords  
		li   $a2, 4048   
		syscall      
	
		#printa o q tem no finwords
		li $v0, 4
		la $a0, finwords
		syscall		
		
		#fecha o arquivo
		li $v0, 16
		move $a0, $s0
		syscall 
         
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
           	beq $t0, 4, check
           	beq $t0, 5, end
  #-----------------------------------------------remove------------------------------------------------------	
	removesticker:
		#---- acaba looparray
		#pede figurinha
		li $v0, 4 		# Comando.
		la $a0, removestickerdialog 	# Carrega string (endereço).
		syscall
		
		li $v0, 8 			#take in input
         	la $a0, bufferin 		#load byte space into address
         	li $a1, 6 			#numero do buffer
         	move $t0, $a0 			#salva a string em t0
         	syscall
         	
		la $s0, bufferin
  		la $s1, array
  		li $t9, 0
        loopverification:
        	lb $t0, 0($s0)	#elemento do buffer
        	lb $t1, 0($s1)  #elemento do array
        	
        	add $s0, $s0, 1
		add $s1, $s1, 1
        	
        	beq $t1, 9, restartcount	#se tiver um tab recomeça a contagem do buffer
        	beq $t1, 10, restartcount	#se tiver um enter tambem
        	beq $t1, 32, notfoundsticker	#se tiver espaço é pq acabou as figurinhas
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
        	j loopverification
        	
        foundstickerequalspecial:
        	lb $t2, 0($s1)
        	sb $t2, 0($s2)
        	addi $s2, $s2, 1
        	
        	lb $t2, 0($s1)
        	sb $t2, 0($s2)      
        	addi $s2, $s2, 1
        	
        	li $t2, 9
        	sb $t2, 0($s2)      
        	addi $s2, $s2, 1
        	
        	la $s1, array
        	li $t8, 8
        	sb $t8, 0($s1)
        	sb $t8, 1($s1)
        	j save
        	
        foundstickerequal:       	
        	lb $t2, -1($s1)
        	sb $t2, 0($s2)
        	addi $s2, $s2, 1
        	
        	lb $t2, -2($s1)
        	sb $t2, 1($s2)
        	addi $s2, $s2, 1
        	
        	lb $t2, -3($s1)
        	sb $t2, 2($s2) 
        	addi $s2, $s2, 1
        	       	
        	lb $t2, -4($s1)
        	sb $t2, 3($s2)
        	addi $s2, $s2, 1
        	
        	lb $t2, -5($s1)
        	sb $t2, 4($s2)
        	addi $s2, $s2, 1
        	
        	li $t2, 9			#tab ao final de cada adição de figurinha
        	sb $t2, 5($s2)
        	addi $s2, $s2, 1
        	
        	li $t8, 8			#usando 8 pra substituir a figurinha que foi excluido
        	sb $t8, -1($s1)			#pois na hora de passar pro buffer do arquivo de faltantes
        	sb $t8, -2($s1)			#passo apenas os elementos que nao sao 8
        	sb $t8, -3($s1)			#8 é o backspace na tabela ascii
        	sb $t8, -4($s1)
        	sb $t8, -5($s1)
        	j save
        notfoundsticker:
        	li $v0, 4
		la $a0, notfoundstickerdialog
		syscall
		j menu
        	
        	
 #-------------------------save-------------------------------------------------------------------------------       	
        	
        save:
        	li $v0, 4 # Comando.
		la $a0, confirm # Carrega string (endereço).
		syscall
		
		li $v0, 8 			#take in input
         	la $a0, bufferconfirm 		#load byte space into address
         	li $a1, 2 			#numero do buffer
         	move $t0, $a0 			#salva a string em t0
         	syscall
         	
         	la $s3, bufferconfirm
         	lb $t3, 0($s3)
         	
         	beq $t3, 121, continue	 	#se nao for y acaba o programa, depois é pra ir pra um menuzin
         	beq $t3, 89, continue
         	bne $t3, 89, menu
         	#salvar na nova lista ----------------------------------------------------------------------------
      continue:   	
         	la $t0, array
         	la $t1, foutwords
         	
         	move $a0, $t0
         	move $a1, $t1
         	jal saveinfout			#procedimento pra salvar cada elemento dentro do arquivo em txt
         	
         	#começa a salvar no arquivo
         	li $v0, 13 			# Comando para abrir novo arquivo. 
		la $a0, fout 			# Carrega nome do arquivo a ser aberto. 
		li $a1, 1 			# Aberto para escrita (flags s�o 0: read, 1: write).
		li $a2, 0 			# Modo ignorado (neste caso). 
		syscall 			# Abre arquivo (descritor do arquivo � colocado em $v0).
		move $s6, $v0 			# Salva o descritor do arquivo para uso no fechamento, por exemplo.
		
		# Escreve no arquivo aberto.
		li $v0, 15 			# Comando para escrever no arquivo. 
		move $a0, $s6 			# Descritor do arquivo � passado. 
		la $a1, foutwords 		# Endere�o do buffer do qual ser� copiado para o arquivo. 
		li $a2, 4048 			# Tmanho do buffer (hardcoded). 
		syscall 			# Escreve no arquivo.
	

		# Fechar o arquivo apos escrever.
		li $v0, 16 			# Comando para fechamento do arquivo. 
		move $a0, $s6 			# Descritor do arquivo � passado.
		syscall 			# Arquivo � fechado pelo sistema operacional.
		
		j saveinfobtainedstickers
        saveinfout:
        	addi $a0, $a0, -1
        	addi $a1, $a1, -1
        	loopsave:
        		lb $t0, 0($a0)
        		beq $t0, 8, equal_8

        		sb $t0, 0($a1)
        		addi $a0, $a0, 1
        		addi $a1, $a1, 1
        		
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
        	endsave:
        		jr $ra
        saveinfobtainedstickers:
        	la $t0, arraystickerobtained
         	la $t1, fobtainedstickerswords
         	
         	move $a0, $t0
         	move $a1, $t1
         	move $a2, $s2  #é preciso saber até onde foi o arraystickerobtained
         	jal movearraytobuffer
         	
         	
        	#começa a salvar no arquivo
         	li $v0, 13 			# Comando para abrir novo arquivo. 
		la $a0, fout 			# Carrega nome do arquivo a ser aberto. 
		li $a1, 1 			# Aberto para escrita (flags s�o 0: read, 1: write).
		li $a2, 0 			# Modo ignorado (neste caso). 
		syscall 			# Abre arquivo (descritor do arquivo � colocado em $v0).
		move $s6, $v0 			# Salva o descritor do arquivo para uso no fechamento, por exemplo.
		
		# Escreve no arquivo aberto.
		li $v0, 15 			# Comando para escrever no arquivo. 
		move $a0, $s6 			# Descritor do arquivo � passado. 
		la $a1, fobtainedstickerswords 	#Endere�o do buffer do qual ser� copiado para o arquivo. 
		li $a2, 4048 			# Tmanho do buffer (hardcoded). 
		syscall 			# Escreve no arquivo.
	

		# Fechar o arquivo apos escrever.
		li $v0, 16 			# Comando para fechamento do arquivo. 
		move $a0, $s6 			# Descritor do arquivo � passado.
		syscall 			# Arquivo � fechado pelo sistema operacional.
		
	movearraytobuffer:
		#sub $t2, $a2, $a0
		li $t0, 0
		looparraytobuffer:
			lb $t0, 0($a0)
        		sb $t0, 0($a1)
        		
        		addi $a0, $a0, 1
        		addi $a1, $a1, 1
        		
        		beq $a0, $t2, endloopa2b
        		bne $a0, $t2, looparraytobuffer
        	endloopa2b:
        		jr $ra
  #---------------------------------check------------------------------------		
	check:
		#pede figurinha para verificação
		
		li $v0, 4 		# Comando.
		la $a0, checkdialog 	# Carrega string (endereço).
		syscall
		
		li $v0, 8 			#take in input
         	la $a0, buffercheck 		#load byte space into address
         	li $a1, 6 			#numero do buffer
         	move $t0, $a0 			#salva a string em t0
         	syscall
         	
		la $s0, buffercheck
  		la $s1, array
  		li $t9, 0
        loopverificationcheck:
        	lb $t0, 0($s0)	#elemento do buffer
        	lb $t1, 0($s1)  #elemento do array
        	
        	add $s0, $s0, 1
		add $s1, $s1, 1
        	
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
        	j loopverificationcheck
        	
        foundstickercheck:
        	li $v0, 4 		# Comando.
		la $a0, checkpositivedialog 	# Carrega string (endereço).
		syscall
		j menu
	notfoundstickercheck:
		li $v0, 4
		la $a0, checknegativedialog
		syscall
		j menu
		
  #----------------------------------------------------restart album-----------------------------------------------------------
  
  #----------------------------------------------------end---------------------------------------------------------------------
	end: 
		nop
