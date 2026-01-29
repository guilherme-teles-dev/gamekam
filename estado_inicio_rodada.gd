extends EstadoJogo

func entrar():
	print("--- [ESTADO] Iniciando Nova Rodada ---")
	
	# 1. Resetar e Embaralhar
	# Acessamos a mesa (pai do pai) -> pegamos o script do baralho -> chamamos a função
	mesa.baralho_script.criar_baralho()
	
	# 2. Distribuir as cartas
	mesa.mao_jogador = mesa.baralho_script.dar_mao_de_truco()
	mesa.mao_bot = mesa.baralho_script.dar_mao_de_truco()
	
	print("Cartas distribuídas!")
	print("Jogador: ", mesa.mao_jogador)
	print("Bot: ", mesa.mao_bot)
	
	# 3. Definir quem começa (Lógica simples por enquanto: sempre o jogador)
	mesa.turno_atual = "jogador"
	
	# 4. Transição de Estado
	# O trabalho desse estado acabou. Agora passamos a bola para o "Turno do Jogador".
	# get_parent() é a MaquinaDeEstados.
	var proximo_estado = get_parent().get_node("Estado_TurnoJogador")
	get_parent().trocar_estado(proximo_estado)

# Não precisamos de sair(), processar() ou receber_input() aqui, 
# pois esse estado é instantâneo e automático.
