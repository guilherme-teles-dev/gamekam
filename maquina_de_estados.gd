extends Node

# Variável que guarda quem está no comando agora
var estado_atual: EstadoJogo

# Pegamos a referência do pai (MesaDoJogo) para passar aos filhos
@onready var mesa = $".."

func _ready():
	# 1. Configuração Inicial: Apresenta a Mesa para todos os Estados filhos
	# Isso evita que a gente tenha que configurar um por um manualmente
	for filho in get_children():
		if filho is EstadoJogo:
			filho.mesa = mesa
	
	# 2. Define o estado inicial do jogo
	# Certifique-se que o nó filho se chama exatamente "Estado_InicioRodada"
	# trocar_estado($Estado_InicioRodada)

# --- FUNÇÃO PRINCIPAL DE TRANSIÇÃO ---
# É aqui que a mágica acontece. Um estado chama essa função para passar a vez.
func trocar_estado(novo_estado: EstadoJogo):
	# 1. Se já existe um estado rodando, avisa que ele vai sair
	if estado_atual:
		estado_atual.sair()
	
	# 2. Atualiza a variável para o novo estado
	estado_atual = novo_estado
	
	# 3. Avisa o novo estado que ele entrou no comando
	if estado_atual:
		print("Estado alterado para: ", estado_atual.name)
		estado_atual.entrar()

# --- DELEGAÇÃO (Passando a batata quente) ---
# O Godot chama essas funções no Gerente, e o Gerente repassa para o Estado Atual.

func _process(delta):
	if estado_atual:
		estado_atual.processar(delta)

func _input(event):
	if estado_atual:
		estado_atual.receber_input(event)
