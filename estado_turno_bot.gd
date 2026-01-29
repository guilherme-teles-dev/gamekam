extends EstadoJogo

func entrar():
	print("\n--- VEZ DO BOT ---")
	
	# Simulação de "pensar" (opcional, mas bom pra ver o log)
	await get_tree().create_timer(1.0).timeout
	
	# IA Super complexa: Joga sempre a primeira carta (índice 0)
	if mesa.mao_bot.size() > 0:
		mesa.jogar_carta_na_mesa("bot", 0)
	
	# TRANSIÇÃO:
	# Aqui a lógica do truco complica, pois depende de quem ganhou a mão.
	# MAS, para testar hoje, vamos forçar voltar para o jogador ou terminar a rodada.
	
	# Se ainda tiverem cartas, volta pro jogador. Se não, resolve a mão.
	if mesa.mao_jogador.size() > 0:
		get_parent().trocar_estado(get_parent().get_node("Estado_TurnoJogador"))
	else:
		# Ainda não criamos o script de Resolução, então vamos só avisar
		print("--- Fim da vaza (mão) ---")
		# Aqui o jogo vai parar por enquanto pois não tem pra onde ir
