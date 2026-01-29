extends Sprite2D

func configurar(dados):
	var v = str(dados["valor"])
	
	# Tradução para bater com seus arquivos (K, Q, J, A)
	if v == "king": v = "king" # ou "K", dependendo do nome do seu PNG
	elif v == "queen": v = "queen"
	elif v == "jack": v = "jack"
	elif v == "ace": v = "A"
	
	var n = str(dados["naipe"]).to_lower()
	var nome_arquivo = v + "_of_" + n + ".png"
	var caminho = "res://assets/test_cards/" + nome_arquivo
	
	if FileAccess.file_exists(caminho):
		texture = load(caminho)
	else:
		print("Erro ao encontrar: ", caminho)
