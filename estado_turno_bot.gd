extends EstadoJogo

func entrar():
	print("\n--- VEZ DO BOT ---")
	await get_tree().create_timer(1.0).timeout
	
	# CORREÇÃO: Acessamos '.cartas_na_mao' para checar o tamanho
	if mesa.mao_bot.cartas_na_mao.size() > 0:
		# Joga a primeira carta da lista
		mesa.jogar_carta_na_mesa("bot", 0)
	
	# Verifica se a mão acabou (se tem 2 cartas na mesa)
	if mesa.baralho_na_mesa.size() == 2:
		print("Mão finalizada. Chamando o Juiz...")
		var estado_juiz = get_parent().get_node("Estado_ResolucaoMao")
		get_parent().trocar_estado(estado_juiz)
	else:
		# Se só tem 1 carta na mesa (o Bot jogou primeiro), passa a vez pro Jogador
		var estado_jog = get_parent().get_node("Estado_TurnoJogador")
		get_parent().trocar_estado(estado_jog)
