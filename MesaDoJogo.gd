extends Node
const hand = preload("res://Mao.tscn")

# --- ADICIONE ESTAS VARIÁVEIS DE PLACAR ---
var vazas_nos = 0
var vazas_eles = 0
var empates = 0

var pontos_nos = 0
var pontos_eles = 0
# ------------------------------------------

var valor_atual_rodada = 1 
var baralho_na_mesa = []

# ... (Variáveis de placar iguais) ...

var turno_atual = "" 

# CORREÇÃO 1: Vamos apenas declarar as variáveis aqui, mas instanciar no _ready
var mao_jogador : Node2D
var mao_bot : Node2D

@onready var baralho_script = $Baralho 
@onready var maquina_estados = $MaquinaDeEstados

func _ready():
	# 1. Configuração Inicial
	mao_jogador = hand.instantiate()
	mao_jogador.position = Vector2(576, 550)
	add_child(mao_jogador)
	
	mao_bot = hand.instantiate()
	mao_bot.position = Vector2(576, 100)
	add_child(mao_bot)
	
	print("Mesa montada.")
	
	# 2. Inicia o loop do jogo
	var estado_inicial = maquina_estados.get_node("Estado_InicioRodada")
	if estado_inicial:
		maquina_estados.trocar_estado(estado_inicial)
		
		# --- AQUI ESTAVA O PROBLEMA ---
		# Tiramos o # da frente para forçar o jogo a começar
		#comecar_nova_rodada() 

func comecar_nova_rodada():
	print("--- Distribuindo Cartas e Iniciando Rodada ---")
	baralho_script.criar_baralho()
	
	# IMPORTANTE: Se tiver cartas velhas, limpar (implementar limpar_mao depois)
	# mao_jogador.limpar_mao() 
	# mao_bot.limpar_mao()

	# 1. Dá as cartas (Lógica que você já tinha)
	for dados in baralho_script.dar_mao_de_truco():
		mao_jogador.adicionar_carta(dados["valor"], dados["naipe"])
		
	for dados in baralho_script.dar_mao_de_truco():
		mao_bot.adicionar_carta(dados["valor"], dados["naipe"])
	
	# 2. Anima a entrada das mãos (Visual)
	mao_jogador.animar_entrada()
	if mao_bot: mao_bot.animar_entrada()
	
	# Aguarda a animação (ajuste o tempo conforme sua animação, ex: 1.0 ou 2.0 segundos)
	await get_tree().create_timer(1.5).timeout
	
	print("Animação finalizada. Passando a vez para o JOGADOR.")
	
	# --- A CORREÇÃO CRUCIAL ESTÁ AQUI EMBAIXO ---
	# Agora que as cartas foram dadas e a animação acabou, 
	# FORÇAMOS o estado a mudar para o turno do jogador.
	var estado_jogo = maquina_estados.get_node("Estado_TurnoJogador") # Verifique o nome exato do nó!
	if estado_jogo:
		maquina_estados.trocar_estado(estado_jogo)
	else:
		print("ERRO CRÍTICO: Não encontrei o nó 'Estado_TurnoJogador' na máquina de estados.")

func jogar_carta_na_mesa(quem_jogou: String, indice_carta: int):
	var carta_no = null
	
	# CORREÇÃO 2: Acessar o ARRAY 'cartas_na_mao' dentro do script da Mão
	if quem_jogou == "jogador":
		# Verifica se o índice é válido para evitar crash
		if indice_carta < mao_jogador.cartas_na_mao.size():
			carta_no = mao_jogador.cartas_na_mao.pop_at(indice_carta)
			
	elif quem_jogou == "bot":
		if indice_carta < mao_bot.cartas_na_mao.size():
			carta_no = mao_bot.cartas_na_mao.pop_at(indice_carta)
		
	if carta_no:
		# Visual: Removemos da mão (filho da mão) e adicionamos na Mesa
		carta_no.get_parent().remove_child(carta_no) # Tira da Mão
		add_child(carta_no) # Coloca na Mesa (MesaDoJogo)
		
		# Move a carta visualmente para o centro da mesa (animação viria aqui)
		carta_no.position = Vector2(576, 324) 
		
		# Dados: Guardamos a referência
		var jogada = {"carta_no": carta_no, "dono": quem_jogou}
		baralho_na_mesa.append(jogada)
		
		# CORREÇÃO 2 (Propriedades): Acessamos com ponto (.) pois é um Objeto, não Dicionário
		print(quem_jogou.capitalize() + " jogou: " + str(carta_no.valor) + " de " + str(carta_no.naipe))
		
		# Importante: Mandar a mão se reorganizar visualmente pois tiramos uma carta
		if quem_jogou == "jogador": mao_jogador.organizar_cartas()
		else: mao_bot.organizar_cartas()
		
		return true
		
	return false

func _input(event):
	# Só roda quando clica com o botão esquerdo
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("\n--- DIAGNÓSTICO DO CLIQUE (Versão Universal) ---")
		
		# ACESSANDO VIA VIEWPORT (Funciona em nós brancos/Node)
		var viewport = get_viewport()
		var mouse_pos = viewport.get_mouse_position()
		
		print("Posição do Mouse: ", mouse_pos)
		
		# 1. VERIFICAR INTERFACE (UI)
		var ui_bloqueadora = viewport.gui_get_hovered_control()
		if ui_bloqueadora:
			print("🚨 ALERTA UI: O clique foi pego por: ", ui_bloqueadora.name)
			print("   (Tipo: ", ui_bloqueadora.get_class(), ")")
			print("   -> Solução: Mude o 'Mouse > Filter' deste nó para 'Ignore'.")
		else:
			print("✅ Nenhuma UI bloqueando o mouse.")
			
		# 2. VERIFICAR FÍSICA (Area2D / Cartas)
		var parametros = PhysicsPointQueryParameters2D.new()
		parametros.position = mouse_pos
		parametros.collide_with_areas = true 
		parametros.collide_with_bodies = false
		
		# Pedimos o World2D emprestado do viewport
		var world_2d = viewport.world_2d
		var resultados = world_2d.direct_space_state.intersect_point(parametros)
		
		if resultados.size() > 0:
			print("🟢 FÍSICA: Colisão detectada com:")
			for item in resultados:
				# Tenta mostrar o nome do objeto e do pai dele
				var objeto = item.collider
				var pai = objeto.get_parent()
				print("   - Objeto: ", objeto.name, " | Pai: ", pai.name if pai else "Sem pai")
		else:
			print("❌ FÍSICA: O mouse não tocou em nenhum CollisionShape2D.")
		
		print("-----------------------------\n")
