extends EstadoJogo

func entrar():
	print("\n--- VEZ DO BOT ---")
	await get_tree().create_timer(1.0).timeout
	
	# Bot joga a primeira carta que tiver (Lógica "Burra" temporária)
	if mesa.mao_bot.size() > 0:
		mesa.jogar_carta_na_mesa("bot", 0)
	
	# --- MUDANÇA AQUI ---
	# O Bot geralmente é o último a jogar nessa estrutura simples (Jogador puxa, Bot responde).
	# Vamos verificar se a mão acabou (se tem 2 cartas na mesa).
	
	if mesa.baralho_na_mesa.size() == 2:
		# A mão acabou (1 carta do jogador + 1 do bot)
		print("Mão finalizada. Chamando o Juiz...")
		var estado_juiz = get_parent().get_node("Estado_ResolucaoMao")
		get_parent().trocar_estado(estado_juiz)
	else:
		# Se por algum motivo o jogo continuar (ex: Truco em trios), passaria a vez.
		# No nosso caso 1x1, isso raramente acontece aqui, mas por segurança:
		var estado_jog = get_parent().get_node("Estado_TurnoJogador")
		get_parent().trocar_estado(estado_jog)
