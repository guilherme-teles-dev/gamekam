extends Node

# Placar
var pontos_nos = 0
var pontos_eles = 0
var rodadas_vencidas_nos = 0 
var rodadas_vencidas_eles = 0

# Estado da Mão
var valor_atual_rodada = 1 
var baralho_na_mesa = [] 
var turno_atual = "" 

# Recursos Visuais
var cena_da_carta = preload("res://carta_visual.tscn")
var mao_jogador = []
var mao_bot = []

@onready var baralho_script = $Baralho 
@onready var maquina_estados = $MaquinaDeEstados

func _ready():
	print("Mesa montada. Iniciando jogo...")
	var estado_inicial = maquina_estados.get_node("Estado_InicioRodada")
	maquina_estados.trocar_estado(estado_inicial)

func comecar_nova_rodada():
	limpar_visual_da_mesa()
	baralho_script.criar_baralho()
	
	# 1. Dá as cartas (Lógica)
	mao_jogador = baralho_script.dar_mao_de_truco()
	mao_bot = baralho_script.dar_mao_de_truco()
	
	# 2. MOSTRA AS CARTAS NA TELA (O que estava faltando aparecer logo no início)
	atualizar_mao_visual_jogador()
	
	print("Cartas distribuídas e visíveis!")

func limpar_visual_da_mesa():
	baralho_na_mesa.clear()
	for filho in $CartasNaMesa.get_children():
		if filho is not Marker2D:
			filho.queue_free()

func atualizar_mao_visual_jogador():
	# Verificação de segurança: O nó MaoJogador precisa existir na cena!
	if not has_node("MaoJogador"):
		print("ERRO: Nó MaoJogador não encontrado!")
		return

	for n in $MaoJogador.get_children():
		n.queue_free()
	
	var total_cartas = mao_jogador.size()
	for i in range(total_cartas):
		var dados = mao_jogador[i]
		var nova_carta = cena_da_carta.instantiate()
		$MaoJogador.add_child(nova_carta)
		
		nova_carta.configurar(dados["valor"], dados["naipe"])
		nova_carta.scale = Vector2(0.35, 0.35) 
		
		var espacamento = 110 
		var x_pos = (i - (total_cartas - 1) / 2.0) * espacamento
		nova_carta.position = Vector2(x_pos, 0)
		nova_carta.rotation_degrees = (i - (total_cartas - 1) / 2.0) * 10

func jogar_carta_na_mesa(quem_jogou: String, indice_carta: int):
	var carta_dados = null
	
	if quem_jogou == "jogador":
		if indice_carta < mao_jogador.size():
			carta_dados = mao_jogador.pop_at(indice_carta)
	elif quem_jogou == "bot":
		if indice_carta < mao_bot.size():
			carta_dados = mao_bot.pop_at(indice_carta)
		
	if carta_dados:
		# 1. Dados
		var jogada = {"carta": carta_dados, "dono": quem_jogou}
		baralho_na_mesa.append(jogada)
		
		# 2. Visual
		var nova_carta = cena_da_carta.instantiate()
		$CartasNaMesa.add_child(nova_carta)
		nova_carta.configurar(carta_dados["valor"], carta_dados["naipe"])
		nova_carta.scale = Vector2(0.25, 0.25)
		
		var pos_destino = Vector2.ZERO
		
		if quem_jogou == "jogador":
			# Pega a posição global do marcador da mão
			nova_carta.global_position = $MaoJogador.global_position
			pos_destino = $CartasNaMesa/PosicaoJogador.global_position
			atualizar_mao_visual_jogador()
		else:
			# Bot joga de cima para o marcador do bot
			nova_carta.global_position = Vector2(get_viewport().size.x / 2, -100)
			pos_destino = $CartasNaMesa/PosicaoBot.global_position
		
		# Animação
		var tween = create_tween()
		tween.tween_property(nova_carta, "global_position", pos_destino, 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(nova_carta, "rotation", 0, 0.5)
		
		print(quem_jogou.capitalize() + " jogou: " + str(carta_dados["valor"]))
		return true
	return false
