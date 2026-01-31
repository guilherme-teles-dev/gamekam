extends Node2D

signal clicada(minha_referencia)

var valor = ""
var naipe = ""

# Referência ao Sprite (onde a imagem vai aparecer)
# Se o seu nó tiver outro nome, ajuste aqui (ex: $Sprite)
@onready var sprite_visual = $Sprite2D 

# Dicionário para traduzir do seu código (PT-BR) para os arquivos (EN)
# Ajuste as chaves da esquerda conforme o que você usa no código (ex: "Paus" ou "Clubs")
var dicionario_naipes = {
	"Ouros": "diamonds",
	"Espadas": "spades",
	"Copas": "hearts",
	"Paus": "clubs"
}

# Dicionário para valores especiais (caso seus arquivos usem "ace" em vez de "A")
# Se seus arquivos forem "A_of_...", "K_of_...", deixe isso vazio ou remova.
var dicionario_valores = {
	"A": "ace",
	"K": "king",
	"Q": "queen",
	"J": "jack"
}

func _ready():
	# Se já tiver dados, atualiza
	if valor != "":
		atualizar_visual()

func configurar_carta(novo_valor, novo_naipe):
	valor = str(novo_valor) # Garante que é texto
	naipe = str(novo_naipe)
	
	if is_inside_tree():
		atualizar_visual()

func atualizar_visual():
	if not sprite_visual:
		return

	# 1. Traduz o naipe para inglês (para bater com o nome do arquivo)
	# O .get(naipe, naipe) significa: tente traduzir, se não achar, use o original.
	var naipe_arquivo = dicionario_naipes.get(naipe, naipe).to_lower()
	
	# 2. Traduz o valor (Ex: se vier "A", vira "ace" - se seus arquivos usarem nomes completos)
	# Se seus arquivos são "A_of_spades.png", pode remover o .get abaixo e usar só valor.to_lower()
	var valor_arquivo = dicionario_valores.get(valor, valor).to_lower()
	
	# 3. Monta o caminho exato: "res://assets/test_cards/2_of_clubs.png"
	var caminho = "res://assets/test_cards/" + valor_arquivo + "_of_" + naipe_arquivo + ".png"
	
	# 4. Carrega a imagem
	if FileAccess.file_exists(caminho):
		sprite_visual.texture = load(caminho)
		
		# Ajuste de escala (opcional, caso a imagem seja gigante)
		# sprite_visual.scale = Vector2(0.2, 0.2) 
	else:
		print("ERRO: Imagem não encontrada: ", caminho)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Cliquei na carta: ", valor, " de ", naipe)
		emit_signal("clicada", self)
