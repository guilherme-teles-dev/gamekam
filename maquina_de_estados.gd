extends Node
var estado_atual: Node = null
var estado_atual_anterior: Node = null # <--- CRIAR ESSA VARIÁVEL

# Pegamos a referência do pai (MesaDoJogo) para passar aos filhos
@onready var mesa = $".."

func _ready():
	# 1. Configuração Inicial: Apresenta a Mesa para todos os Estados filhos
	# Isso evita que a gente tenha que configurar um por um manualmente
	for filho in get_children():
		if filho is EstadoJogo:
			filho.mesa = mesa
	pass
	
	# 2. Define o estado inicial do jogo
	# Certifique-se que o nó filho se chama exatamente "Estado_InicioRodada"
	# trocar_estado($Estado_InicioRodada)

# --- FUNÇÃO PRINCIPAL DE TRANSIÇÃO ---
# É aqui que a mágica acontece. Um estado chama essa função para passar a vez.
func trocar_estado(novo_estado: Node):
	if estado_atual:
		estado_atual_anterior = estado_atual # <--- SALVA QUEM ESTAVA RODANDO ANTES
		estado_atual.sair()
	
	estado_atual = novo_estado
	estado_atual.entrar()

# --- DELEGAÇÃO (Passando a batata quente) ---
# O Godot chama essas funções no Gerente, e o Gerente repassa para o Estado Atual.

func _process(delta):
	if estado_atual:
		estado_atual.processar(delta)

func _input(event):
	if estado_atual:
		estado_atual.receber_input(event)
