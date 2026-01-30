extends Sprite2D

# Função que a Mesa vai chamar para configurar esta carta
func configurar_carta(dados):
	# Monta o nome: "A_Copas.png"
	var nome_arquivo = "2" + "_" + "clubs" + ".png"
	var caminho = "res://assets/" + nome_arquivo
	
	if FileAccess.file_exists(caminho):
		self.texture = load(caminho)
	else:
		print("Falha ao carregar imagem: ", caminho)
