extends Node

# Placar
var pontos_nos = 0
var pontos_eles = 0
var rodadas_vencidas_nos = 0 # Na mão atual (md3)
var rodadas_vencidas_eles = 0

# Estado da Mão
var valor_atual_rodada = 1 # Começa valendo 1, pode ir para 3, 6, 9, 12
var baralho_na_mesa = [] # O monte de cartas jogadas na mesa
var turno_atual = "" # "jogador" ou "bot"

# As Mãos (Arrays de dicionários de cartas)
var mao_jogador = []
var mao_bot = []

@onready var baralho_script = $Baralho 
@onready var maquina_estados = $MaquinaDeEstados

func _ready():
	print("Mesa montada. Iniciando jogo...")
	var estado_inicial = maquina_estados.get_node("Estado_InicioRodada")
	maquina_estados.trocar_estado(estado_inicial)

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
	
	# Função utilitária para mover carta de uma mão para a mesa
func jogar_carta_na_mesa(quem_jogou: String, indice_carta: int):
	var carta_jogada = null
	
	if quem_jogou == "jogador":
		# pop_at remove o item do array e o retorna
		carta_jogada = mao_jogador.pop_at(indice_carta)
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
