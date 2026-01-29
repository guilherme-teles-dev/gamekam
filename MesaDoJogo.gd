extends Node

# Variáveis do Placar
var pontos_nos = 0
var pontos_eles = 0

# Pegando a referência do nó Baralho
# @onready garante que o Godot espere o nó "Baralho" carregar antes de pegar
@onready var baralho_script = $Baralho 

func _ready():
	print("Mesa montada. Iniciando jogo...")
	comecar_nova_rodada()

func comecar_nova_rodada():
	# Passo 1: O Juiz manda o Dealer reembaralhar
	baralho_script.criar_baralho()
	
	# Passo 2: O Juiz pede cartas para o jogador
	var mao_jogador = baralho_script.dar_mao_de_truco()
	
	# Passo 3: O Juiz pede cartas para o Bot
	var mao_bot = baralho_script.dar_mao_de_truco()
	
	print("Cartas do Jogador: ", mao_jogador)
	print("Cartas do Bot: ", mao_bot)
	
	# Aqui você chamaria a Máquina de Estados para iniciar o turno
