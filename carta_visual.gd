extends Node2D

@onready var sprite = $Sprite2D

func configurar(valor, naipe):
	# Tradução dos Naipes
	var n_traduzido = naipe
	match naipe:
		"Paus": n_traduzido = "clubs"
		"Espadas": n_traduzido = "spades" # Se for clubs mesmo como você disse
		"Ouros": n_traduzido = "diamonds"
		"Copas": n_traduzido = "hearts"
	
	# Tradução dos Valores
	var v_traduzido = str(valor)
	match str(valor):
		"J": v_traduzido = "jack"
		"Q": v_traduzido = "queen"
		"K": v_traduzido = "king"
		"A": v_traduzido = "ace"

	# Monta o caminho exato: res://assets/Clubs_Jack.png
	var path = "res://assets/test_cards/" +  v_traduzido + "_of_"+ n_traduzido + ".png"
	
	if FileAccess.file_exists(path):
		sprite.texture = load(path)
	else:
		print("Atenção: Arquivo não encontrado: ", path)
