extends Node

# Lista que vai guardar as cartas (usaremos dicionários simples por enquanto)
var cartas = []
var naipes = ["Ouros", "Espadas", "Copas", "Paus"]
var valores = ["4", "5", "6", "7", "Q", "J", "K", "A", "2", "3"]

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

# Retorna um número inteiro representando a força da carta.
# Quanto maior o número, mais forte a carta.
func obter_forca_truco(carta):
	var v = carta["valor"]
	var n = carta["naipe"]
	
	# --- 1. VERIFICA MANILHAS (Combinação Valor + Naipe) ---
	if v == "4" and n == "Paus":
		return 14 # ZAP (A mais forte do jogo)
	if v == "7" and n == "Copas":
		return 13 # ESCOPETA/COPAS
	if v == "A" and n == "Espadas":
		return 12 # ESPADILHA
	if v == "7" and n == "Ouros":
		return 11 # PICA-FUMO/OUROS
		
	# --- 2. VERIFICA CARTAS COMUNS (Apenas Valor importa) ---
	# O naipe não importa para cartas que não são manilhas no Truco Paulista
	match v:
		"3": return 10
		"2": return 9
		"A": return 8
		"K": return 7
		"J": return 6
		"Q": return 5
		"7": return 4
		"6": return 3
		"5": return 2
		"4": return 1
		
	return 0 # Caso de erro (não deve acontecer)
