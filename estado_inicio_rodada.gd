extends EstadoJogo

func entrar():
	print("Estado: Iniciando Rodada (Delegando para a Mesa)")
	
	# 1. Pega a referência da mesa
	# (Supondo que a estrutura é Mesa -> MaquinaDeEstados -> Estado)
	mesa = get_parent().get_parent() 
	
	# 2. Manda a Mesa fazer todo o trabalho pesado:
	# (Criar baralho, limpar mãos, distribuir, animar e depois mudar para TurnoJogador)
	mesa.comecar_nova_rodada()

func sair():
	# Não precisa fazer nada ao sair
	pass
