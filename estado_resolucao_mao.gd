extends EstadoJogo

func entrar():
	print("\n--- RESOLUÇÃO DA MÃO ---")
	resolver_vencedor_mao()

func resolver_vencedor_mao():
	var carta_1 = mesa.baralho_na_mesa[0] # Primeira carta jogada
	var carta_2 = mesa.baralho_na_mesa[1] # Segunda carta jogada
	
	# Calcula força
	var f1 = mesa.baralho_script.obter_forca_truco(carta_1["carta"])
	var f2 = mesa.baralho_script.obter_forca_truco(carta_2["carta"])
	
	var vencedor_da_mao = "" # "jogador" ou "bot"
	
	# Verifica quem jogou qual carta para atribuir a vitória corretamente
	# (Lembre-se: carta_1 nem sempre é do jogador, depende de quem começou)
	var dono_c1 = carta_1["dono"]
	var dono_c2 = carta_2["dono"]
	
	if f1 > f2:
		vencedor_da_mao = dono_c1
	elif f2 > f1:
		vencedor_da_mao = dono_c2
	else:
		vencedor_da_mao = "empate"

	print("Vencedor da Vaza: " + vencedor_da_mao.to_upper())
	
	# --- ATUALIZAR PLACAR DA RODADA ---
	if vencedor_da_mao == "jogador":
		mesa.vazas_nos += 1
	elif vencedor_da_mao == "bot":
		mesa.vazas_eles += 1
	else:
		mesa.empates += 1
		# Regra simplificada de empate: Ambos ganham ponto na vaza 
		# (No Truco real a regra de empate é complexa, vamos manter simples por enquanto)
		mesa.vazas_nos += 1
		mesa.vazas_eles += 1
	
	mesa.baralho_na_mesa.clear() # Limpa a mesa
	
	verificar_fim_rodada(vencedor_da_mao)

func verificar_fim_rodada(ultimo_vencedor):
	print("Placar da Rodada -> Nós: " + str(mesa.vazas_nos) + " | Eles: " + str(mesa.vazas_eles))
	
	# CONDIÇÃO DE VITÓRIA DA RODADA (Primeiro a fazer 2 ou regra de empate)
	var rodada_acabou = false
	var quem_ganhou_tento = ""
	
	if mesa.vazas_nos >= 2 and mesa.vazas_nos > mesa.vazas_eles:
		quem_ganhou_tento = "jogador"
		rodada_acabou = true
	elif mesa.vazas_eles >= 2 and mesa.vazas_eles > mesa.vazas_nos:
		quem_ganhou_tento = "bot"
		rodada_acabou = true
	elif mesa.vazas_nos >= 2 and mesa.vazas_eles >= 2:
		# Caso raro de empate na terceira ou segunda
		# Por enquanto, quem ganhou a última leva
		quem_ganhou_tento = ultimo_vencedor 
		rodada_acabou = true
		
	if rodada_acabou:
		finalizar_tento(quem_ganhou_tento)
	else:
		# A rodada continua!
		# Quem ganhou essa mão começa jogando a próxima
		print(">> Próxima mão...")
		if ultimo_vencedor == "jogador":
			get_parent().trocar_estado(get_parent().get_node("Estado_TurnoJogador"))
		elif ultimo_vencedor == "bot":
			get_parent().trocar_estado(get_parent().get_node("Estado_TurnoBot"))
		else:
			# Se empatou, quem começou a mão empatada começa a próxima (Regra Paulista)
			# Simplificando: Volta para o jogador
			get_parent().trocar_estado(get_parent().get_node("Estado_TurnoJogador"))

func finalizar_tento(ganhador):
	print("\n==================================")
	print("FIM DA RODADA! Vencedor: " + ganhador.to_upper())
	print("==================================\n")
	
	# Soma pontos no placar GLOBAL
	if ganhador == "jogador":
		mesa.pontos_nos += mesa.valor_atual_rodada
	else:
		mesa.pontos_eles += mesa.valor_atual_rodada
		
	print("PLACAR GERAL: Nós " + str(mesa.pontos_nos) + " x " + str(mesa.pontos_eles) + " Eles")
	
	# Reseta variáveis da rodada
	mesa.vazas_nos = 0
	mesa.vazas_eles = 01
	mesa.empates = 0
	mesa.valor_atual_rodada = 1
	mesa.mao_jogador.clear()
	mesa.mao_bot.clear()
	
	# Reinicia o ciclo (Nova distribuição de cartas)
	# Pequena pausa dramática
	await get_tree().create_timer(2.0).timeout
	get_parent().trocar_estado(get_parent().get_node("Estado_InicioRodada"))
