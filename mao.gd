extends Node2D

func _ready():
	# Começa totalmente transparente (invisível), mas o nó continua lá
	modulate.a = 0

# Carrega a cena da carta para poder criar cópias
var cena_carta = preload("res://Carta.tscn")

# Lista para guardar as referências das cartas na mão
var cartas_na_mao: Array = []

# Configuração visual
var espacamento = 200 # Distância entre cartas

func adicionar_carta(valor, naipe):
	# 1. Cria a nova carta
	var nova_carta = cena_carta.instantiate()
	
	# 2. Configura os dados dela
	nova_carta.configurar_carta(valor, naipe)
	
	# 3. Adiciona na árvore de cena (filho desta Mão)
	add_child(nova_carta)
	
	# 4. Salva na lista
	cartas_na_mao.append(nova_carta)
	
	# 5. Recalcula as posições para ficar bonito
	organizar_cartas()
	pass

func organizar_cartas():
	# Loop para colocar uma carta ao lado da outra
	for i in range(cartas_na_mao.size()):
		var carta = cartas_na_mao[i]
		
		# Animação simples de posição (Tween) seria ideal aqui, 
		# mas vamos fazer direto por enquanto:
		var nova_posicao_x = i * espacamento
		carta.position = Vector2(nova_posicao_x, 0)
		
		# Dica de polimento: Se quiser centralizar a mão na tela
		# você precisaria de um cálculo de offset baseado no tamanho total.

func animar_entrada():
	# Cria uma animação suave (Tween)
	var tween = create_tween()
	# Muda a transparência (modulate.a) de 0 para 1 em 0.5 segundos
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
