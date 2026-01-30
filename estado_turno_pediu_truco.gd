extends EstadoJogo

var quem_pediu = "" # "jogador" ou "bot"
var valor_proposto = 0

func entrar():
	print("\n!!!!!!!! TRUCO !!!!!!!!")
	
	# Determina quem pediu baseando-se em quem ERA o estado anterior
	# Se viemos do TurnoJogador, foi o jogador.
	var estado_anterior = get_parent().estado_atual_anterior # Precisaremos criar essa variavel na maquina
	
	if estado_anterior.name == "Estado_TurnoJogador":
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
	# Se o bot tiver Zap (14) ou 7 Copas (13), ele aceita. 
	# Se não, 50% de chance de correr ou aceitar.
	
	var tem_carta_boa = false
	for carta in mesa.mao_bot:
		if mesa.baralho_script.obter_forca_truco(carta) >= 13:
			tem_carta_boa = true
			
	var aceitou = false
	if tem_carta_boa:
		aceitou = true
	else:
		aceitou = (randi() % 2 == 0) # 50% de chance
	
	if aceitou:
		aceitar_truco()
	else:
		correr_do_truco()

func decisao_do_jogador():
	# Faremos isso no próximo passo (quando o bot pedir truco)
	pass

func aceitar_truco():
	print(">>> OPEDIDO FOI ACEITO! A rodada vale " + str(valor_proposto))
	mesa.valor_atual_rodada = valor_proposto
	
	# Volta para o estado anterior (quem pediu continua jogando)
	var maquina = get_parent()
	maquina.trocar_estado(maquina.estado_atual_anterior)

func correr_do_truco():
	print(">>> CORREU! O pedido foi recusado.")
	
	# Se alguém correu, o outro ganha a RODADA imediatamente.
	var vencedor_rodada = ""
	if quem_pediu == "jogador":
		vencedor_rodada = "jogador"
	else:
		vencedor_rodada = "bot"
		
	# Usamos uma função do juiz para finalizar a rodada sem jogar cartas
	var juiz = get_parent().get_node("Estado_ResolucaoMao")
	juiz.finalizar_tento(vencedor_rodada)
