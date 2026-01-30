extends EstadoJogo

func entrar():
	print("--- [ESTADO] Iniciando Nova Rodada ---")
	
	# 1. Resetar e Embaralhar
	mesa.baralho_script.criar_baralho()
	
	# 2. Distribuir as cartas (Lógica)
	mesa.mao_jogador = mesa.baralho_script.dar_mao_de_truco()
	mesa.mao_bot = mesa.baralho_script.dar_mao_de_truco()
	
	# --- AQUI ESTÁ A CHAVE: Manda a mesa desenhar as cartas! ---
	mesa.atualizar_mao_visual_jogador() 
	# ----------------------------------------------------------
	
	print("Cartas distribuídas!")
	
	# 3. Definir quem começa
	mesa.turno_atual = "jogador"
	
	# 4. Transição de Estado
	var proximo_estado = get_parent().get_node("Estado_TurnoJogador")
	get_parent().trocar_estado(proximo_estado)
