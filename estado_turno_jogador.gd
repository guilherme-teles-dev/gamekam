extends EstadoJogo

func entrar():
	print("\n--- SUA VEZ ---")
	mostrar_opcoes()

func mostrar_opcoes():
	print("Sua mão atual:")
	var indice = 1
	for carta in mesa.mao_jogador:
		# Ex: [1] 4 de Paus
		print("[" + str(indice) + "] " + carta["valor"] + " de " + carta["naipe"])
		indice += 1
	print("Pressione a tecla 1, 2 ou 3 para jogar a carta correspondente.")

# Aqui capturamos o teclado físico
func receber_input(event):
	if event is InputEventKey and event.pressed:
		
		var indice_escolhido = -1
		
		# Mapeando teclas físicas para índices do array (0, 1, 2)
		if event.keycode == KEY_1 or event.keycode == KEY_KP_1:
			indice_escolhido = 0
		elif event.keycode == KEY_2 or event.keycode == KEY_KP_2:
			indice_escolhido = 1
		elif event.keycode == KEY_3 or event.keycode == KEY_KP_3:
			indice_escolhido = 2
			
		# Se apertou uma tecla válida
		if indice_escolhido != -1:
			tentar_jogar(indice_escolhido)

func tentar_jogar(indice):
	if indice >= mesa.mao_jogador.size():
		print("ERRO: Carta inválida!")
		mostrar_opcoes()
		return

	# Executa a jogada
	mesa.jogar_carta_na_mesa("jogador", indice)
	
	# --- CORREÇÃO AQUI ---
	# Verificamos se a mesa ficou cheia (2 cartas) APÓS a minha jogada.
	if mesa.baralho_na_mesa.size() == 2:
		print("Mão finalizada pelo jogador. Chamando o Juiz...")
		var estado_juiz = get_parent().get_node("Estado_ResolucaoMao")
		get_parent().trocar_estado(estado_juiz)
	else:
		# Se só tem 1 carta (a minha), passa a vez para o Bot
		var proximo = get_parent().get_node("Estado_TurnoBot")
		get_parent().trocar_estado(proximo)
