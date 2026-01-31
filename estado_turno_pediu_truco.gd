extends EstadoJogo

var quem_pediu = "" # "jogador" ou "bot"
var valor_proposto = 0

func entrar():
	print("\n!!!!!!!! TRUCO !!!!!!!!")
	
	# Determina quem pediu baseando-se em quem ERA o estado anterior
	var estado_anterior = get_parent().estado_atual_anterior
	
	# Proteção caso estado_anterior seja nulo (primeira rodada)
	if estado_anterior and estado_anterior.name == "Estado_TurnoJogador":
		quem_pediu = "jogador"
	else:
		quem_pediu = "bot"
	
	# Regra de valores: 1 -> 3 -> 6 -> 9 -> 12
	if mesa.valor_atual_rodada == 1:
		valor_proposto = 3
	else:
		valor_proposto = mesa.valor_atual_rodada + 3
		
	print(quem_pediu.to_upper() + " está pedindo para subir a aposta para: " + str(valor_proposto))
	
	if quem_pediu == "jogador":
		decisao_do_bot()
	else:
		decisao_do_jogador()

func decisao_do_bot():
	print("Bot está pensando...")
	await get_tree().create_timer(1.5).timeout
	
	# IA Simples: 
	var tem_carta_boa = false
	
	# CORREÇÃO 1: Iterar sobre o array 'cartas_na_mao'
	for carta_visual in mesa.mao_bot.cartas_na_mao:
		
		# CORREÇÃO 2: Criar dicionário para a função de força ler
		var dados_carta = {"valor": carta_visual.valor, "naipe": carta_visual.naipe}
		
		# Verifica Zap (14) ou 7 Copas (13) ou Espadilha (12)
		if mesa.baralho_script.obter_forca_truco(dados_carta) >= 12:
			tem_carta_boa = true
			
	var aceitou = false
	if tem_carta_boa:
		aceitou = true
	else:
		aceitou = (randi() % 2 == 0) # 50% de chance se a mão for ruim
	
	if aceitou:
		aceitar_truco()
	else:
		correr_do_truco()

func decisao_do_jogador():
	# Implementaremos botões de "Aceitar" ou "Correr" na tela depois.
	# Por enquanto, vamos fazer o jogador aceitar automaticamente para testar
	print("Jogador (Auto): Aceitou o desafio!")
	aceitar_truco()

func aceitar_truco():
	print(">>> O PEDIDO FOI ACEITO! A rodada vale " + str(valor_proposto))
	mesa.valor_atual_rodada = valor_proposto
	
	# Volta para o estado anterior (quem pediu continua jogando)
	var maquina = get_parent()
	if maquina.estado_atual_anterior:
		maquina.trocar_estado(maquina.estado_atual_anterior)
	else:
		# Fallback de segurança se perder o histórico
		print("ERRO: Histórico perdido. Voltando para o Jogador.")
		maquina.trocar_estado(maquina.get_node("Estado_TurnoJogador"))

func correr_do_truco():
	print(">>> CORREU! O pedido foi recusado.")
	
	# Se alguém correu, o outro ganha a RODADA imediatamente.
	var vencedor_rodada = ""
	# Se o jogador pediu e o bot correu -> Jogador ganha
	if quem_pediu == "jogador":
		vencedor_rodada = "jogador"
	else:
		vencedor_rodada = "bot"
		
	# Usamos uma função do juiz para finalizar a rodada sem jogar cartas
	var juiz = get_parent().get_node("Estado_ResolucaoMao")
	# Precisamos garantir que o juiz tenha acesso à mesa antes de chamar a função
	juiz.mesa = mesa 
	juiz.finalizar_tento(vencedor_rodada)
