extends EstadoJogo

func entrar():
	print("\n--- RESOLUÇÃO DA MÃO ---")
	resolver_vencedor_mao()

func resolver_vencedor_mao():
	var jogada_1 = mesa.baralho_na_mesa[0] 
	var jogada_2 = mesa.baralho_na_mesa[1] 
	
	# 1. Recuperamos o Objeto Carta Visual
	# CORREÇÃO: A chave correta é "carta_no", definida lá no MesaDoJogo.gd
	var objeto_carta_1 = jogada_1["carta_no"]
	var objeto_carta_2 = jogada_2["carta_no"]
	
	# 2. Criamos dicionários temporários para a função 'obter_forca_truco' entender
	# (Pois a função antiga espera um dicionário, não um objeto visual)
	var dados_c1 = {"valor": objeto_carta_1.valor, "naipe": objeto_carta_1.naipe}
	var dados_c2 = {"valor": objeto_carta_2.valor, "naipe": objeto_carta_2.naipe}
	
	# 3. Calcula força
	var f1 = mesa.baralho_script.obter_forca_truco(dados_c1)
	var f2 = mesa.baralho_script.obter_forca_truco(dados_c2)
	
	var vencedor_da_mao = "" 
	var dono_c1 = jogada_1["dono"]
	var dono_c2 = jogada_2["dono"]
	
	if f1 > f2:
		vencedor_da_mao = dono_c1
	elif f2 > f1:
		vencedor_da_mao = dono_c2
	else:
		vencedor_da_mao = "empate"

	print("Vencedor da Vaza: " + vencedor_da_mao.to_upper())
	
	# --- Atualização do Placar (O resto segue igual) ---
	if vencedor_da_mao == "jogador":
		mesa.vazas_nos += 1
	elif vencedor_da_mao == "bot":
		mesa.vazas_eles += 1
	else:
		mesa.empates += 1
		mesa.vazas_nos += 1
		mesa.vazas_eles += 1
	
	# Limpa visualmente as cartas da mesa (Destruindo os nós)
	for jogada in mesa.baralho_na_mesa:
		jogada["carta_no"].queue_free()
		
	mesa.baralho_na_mesa.clear() # Limpa o array lógico
	
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
	
	# --- CORREÇÃO: LIMPEZA DA MESA (O Bug estava aqui) ---
	# Se alguém correu do truco com cartas na mesa, elas ficaram lá.
	# Precisamos destruir os visuais e limpar a lista lógica.
	for jogada in mesa.baralho_na_mesa:
		if is_instance_valid(jogada["carta_no"]):
			jogada["carta_no"].queue_free()
	mesa.baralho_na_mesa.clear()
	# -----------------------------------------------------

	# Reseta variáveis da rodada
	mesa.vazas_nos = 0
	mesa.vazas_eles = 0
	mesa.empates = 0
	mesa.valor_atual_rodada = 1

	# Destrói todas as cartas visuais que sobraram na mão
	for carta in mesa.mao_jogador.cartas_na_mao:
		carta.queue_free()
	mesa.mao_jogador.cartas_na_mao.clear()
	
	for carta in mesa.mao_bot.cartas_na_mao:
		carta.queue_free()
	mesa.mao_bot.cartas_na_mao.clear()
	
	# Reinicia o ciclo (Nova distribuição de cartas)
	await get_tree().create_timer(2.0).timeout
	get_parent().trocar_estado(get_parent().get_node("Estado_InicioRodada"))
