extends Node

<<<<<<< Updated upstream
# Variáveis do Placar
=======
@export var cena_carta_visual: PackedScene 

# Placar
>>>>>>> Stashed changes
var pontos_nos = 0
var pontos_eles = 0

# Pegando a referência do nó Baralho
# @onready garante que o Godot espere o nó "Baralho" carregar antes de pegar
@onready var baralho_script = $Baralho 
<<<<<<< Updated upstream
=======
@onready var maquina_estados = $MaquinaDeEstados
@onready var container_cartas_mesa = $CartasNaMesa
>>>>>>> Stashed changes

func _ready():
	print("Mesa montada. Iniciando jogo...")
	comecar_nova_rodada()

func comecar_nova_rodada():
	# Passo 1: O Juiz manda o Dealer reembaralhar
	baralho_script.criar_baralho()
	
	# Passo 2: O Juiz pede cartas para o jogador
	mao_jogador = baralho_script.dar_mao_de_truco()
	
	# Passo 3: O Juiz pede cartas para o Bot
	mao_bot = baralho_script.dar_mao_de_truco()
	
	print("Cartas do Jogador: ", mao_jogador)
	print("Cartas do Bot: ", mao_bot)
	
<<<<<<< Updated upstream
	# Aqui você chamaria a Máquina de Estados para iniciar o turno
=======
	# Chamada para mostrar as cartas visualmente
	atualizar_visual_da_mao(mao_jogador)

func jogar_carta_na_mesa(quem_jogou: String, indice_carta: int):
	var carta_jogada = null
	
	if quem_jogou == "jogador":
		# pop_at remove o item do array e o retorna
		carta_jogada = mao_jogador.pop_at(indice_carta)
		# Atualiza o visual para remover a carta da mão na tela
		atualizar_visual_da_mao(mao_jogador)
	elif quem_jogou == "bot":
		carta_jogada = mao_bot.pop_at(indice_carta)
		
	if carta_jogada:
		# Adiciona ao monte da mesa
		# Vamos guardar quem jogou junto com a carta para saber quem ganha depois
		var jogada = {"carta": carta_jogada, "dono": quem_jogou}
		baralho_na_mesa.append(jogada)
		print(quem_jogou.capitalize() + " jogou: " + str(carta_jogada["valor"]) + " de " + str(carta_jogada["naipe"]))
		return true
		
	return false

func atualizar_visual_da_mao(lista_dados_cartas):
	for filho in container_cartas_mesa.get_children():
		filho.queue_free()
	
	var i = 0
	for dados in lista_dados_cartas:
		var nova_carta = cena_carta_visual.instantiate()
		container_cartas_mesa.add_child(nova_carta)
		
		# Define o espaçamento entre as cartas
		nova_carta.position.x = i * 130 
		nova_carta.position.y = 0
		
		if nova_carta.has_method("configurar"):
			nova_carta.configurar(dados)
		
		i += 1
>>>>>>> Stashed changes
