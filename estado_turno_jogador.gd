extends EstadoJogo

func entrar():
	print("\n--- SUA VEZ ---")
	mostrar_opcoes()

func mostrar_opcoes():
	print("Sua mão atual:")
	var indice = 1
	
	# CORREÇÃO 1: Acessamos a lista 'cartas_na_mao' dentro do objeto mao_jogador
	for carta in mesa.mao_jogador.cartas_na_mao:
		
		# CORREÇÃO 2: Usamos ponto (.) porque agora 'carta' é um Nó/Objeto, não Dicionário
		print("[" + str(indice) + "] " + str(carta.valor) + " de " + str(carta.naipe))
		indice += 1
	
	print("Pressione 1, 2, 3 para jogar OU 'T' para pedir TRUCO.")
	
# Aqui capturamos o teclado físico
func receber_input(event):
	if event is InputEventKey and event.pressed:
		
		# --- INPUT DO TRUCO (Tecla T) ---
		if event.keycode == KEY_T:
			if mesa.valor_atual_rodada >= 12:
				print("A rodada já vale 12! Não dá pra aumentar mais.")
				return
			
			print(">>> Solicitando TRUCO...")
			var estado_truco = get_parent().get_node("Estado_TurnoPediuTruco")
			if estado_truco:
				get_parent().trocar_estado(estado_truco)
			return

		# --- INPUT DAS CARTAS (Teclas 1, 2, 3) ---
		var indice_escolhido = -1
		
		if event.keycode == KEY_1 or event.keycode == KEY_KP_1:
			indice_escolhido = 0
		elif event.keycode == KEY_2 or event.keycode == KEY_KP_2:
			indice_escolhido = 1
		elif event.keycode == KEY_3 or event.keycode == KEY_KP_3:
			indice_escolhido = 2
			
		if indice_escolhido != -1:
			tentar_jogar(indice_escolhido)

func tentar_jogar(indice):
	# CORREÇÃO 3: Verificamos o tamanho da lista interna
	if indice >= mesa.mao_jogador.cartas_na_mao.size():
		print("ERRO: Carta inválida ou já jogada!")
		# Não chamamos mostrar_opcoes() aqui para não spammar o console
		return

	# Executa a jogada
	mesa.jogar_carta_na_mesa("jogador", indice)
	
	# Verificamos se a mesa ficou cheia (2 cartas)
	if mesa.baralho_na_mesa.size() == 2:
		print("Mão finalizada pelo jogador. Chamando o Juiz...")
		var estado_juiz = get_parent().get_node("Estado_ResolucaoMao")
		get_parent().trocar_estado(estado_juiz)
	else:
		# Se só tem 1 carta (a minha), passa a vez para o Bot
		var proximo = get_parent().get_node("Estado_TurnoBot")
		get_parent().trocar_estado(proximo)
