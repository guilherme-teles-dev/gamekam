extends Sprite2D

func configurar(dados):
	# Pega os valores direto: "2", "3", "Q" e "clubs", "spades", etc.
	var valor = str(dados["valor"])
	var naipe = str(dados["naipe"]).to_lower() # Garante que está em minúsculo
	
	# Monta o nome exatamente como está na sua pasta assets/test_cards/
	var nome_arquivo = valor + "_of_" + naipe + ".png"
	var caminho = "res://assets/test_cards/" + nome_arquivo
	
	print("Tentando carregar: ", caminho) # Isso vai te mostrar no console o erro exato
	
	if FileAccess.file_exists(caminho):
		texture = load(caminho)
		scale = Vector2(0.5, 0.5)
		visible = true # Garante que a carta não está escondida
	else:
		print("ERRO FATAL: O arquivo não existe no caminho: ", caminho)
