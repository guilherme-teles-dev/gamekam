extends Control

# --- REFERÊNCIAS ---
@onready var ui_menu = $UIMenu # Se ainda estiver usando este container
@onready var btn_jogar = %jogar 
@onready var anim = $AnimationPlayer 

# --- PRE-CARREGAMENTO ---
var cena_jogo = preload("res://partida.tscn")

func _ready():
	# ... (Seu código de mouse_filter que já fizemos antes continua aqui) ...
	if btn_jogar:
		btn_jogar.pressed.connect(_on_jogar_pressed)
	if has_node("Personagem"): # Verifica se o nó existe para não dar erro
		$Personagem.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	if has_node("Personagem2"):
		$Personagem2.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_jogar_pressed():
	print("Iniciando animação dos bonecos...")
	btn_jogar.disabled = true
	
	# 1. Toca a animação que criamos
	anim.play("EntrarCena")
	
	# 2. ESPERA O CLÍMAX (0.5 segundos)
	# É aqui que os bonecos estão no meio da tela, tampando a visão
	await get_tree().create_timer(0.5).timeout
	
	# --- TROCA DE CENA MÁGICA ---
	# Enquanto os bonecos estão na tela, a gente troca o fundo "escondido"
	
	print("Bonecos no centro! Trocando o cenário atrás deles...")
	
	# Instancia o jogo
	var nova_partida = cena_jogo.instantiate()
	get_parent().add_child(nova_partida)
	
	# Opcional: Se você quer que o Menu suma IMEDIATAMENTE quando o jogo entra:
	if ui_menu:
		ui_menu.visible = false
		
	# 3. Espera os bonecos saírem da tela (o resto da animação)
	await anim.animation_finished
	
	# 4. Limpeza final
	print("Animação acabou. Destruindo menu.")
	#queue_free()
