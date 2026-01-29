extends Sprite2D

func configurar(dados):
	# Pega o valor (ex: "Q") e o naipe (ex: "spades")
	var v = str(dados["valor"])
	var n = str(dados["naipe"]).to_lower()
	
	# Monta o nome exato: "Q_of_spades.png"
	var nome_arquivo = v + "_of_" + n + ".png"
	var caminho = "res://assets/test_cards/" + nome_arquivo
	
	if FileAccess.file_exists(caminho):
		texture = load(caminho)
		scale = Vector2(0.5, 0.5) # Ajusta o tamanho
	else:
		print("ERRO: Nao achei a foto: ", caminho)
