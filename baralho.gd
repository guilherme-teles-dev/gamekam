extends Node

# Lista que vai guardar as cartas (usaremos dicionários simples por enquanto)
var cartas = []
var naipes = ["diamonds", "spades", "hearts", "clubs"]
var valores = ["4", "5", "6", "7", "queen", "jack", "king", "A", "2", "3"]

func _ready():
	criar_baralho()

func criar_baralho():
	cartas.clear()
	# Loop duplo para criar as 40 cartas
	for n in naipes:
		for v in valores:
			# Adiciona um dicionário representando a carta
			cartas.append({"naipe": n, "valor": v})
	
	embaralhar()

func embaralhar():
	randomize() # Garante que o aleatório seja sempre diferente
	cartas.shuffle()
	print("Baralho embaralhado com ", cartas.size(), " cartas.")

# Função que alguém de fora vai chamar para pedir uma mão de 3 cartas
func dar_mao_de_truco():
	var mao = []
	for i in range(3):
		if cartas.size() > 0:
			mao.append(cartas.pop_front()) # Tira a primeira carta da pilha
	return mao
