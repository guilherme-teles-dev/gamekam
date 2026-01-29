class_name EstadoJogo
extends Node

# Referência para a mesa (para acessar baralho, placar, etc.)
# O "Gerente" vai preencher isso automaticamente para nós.
var mesa

# Chamado quando o estado se torna ativo
func entrar():
	pass

# Chamado quando o estado deixa de ser ativo (limpeza)
func sair():
	pass

# Chamado a cada frame (se precisar de timer ou animação)
func processar(_delta):
	pass

# Chamado quando o jogador clica ou aperta tecla
func receber_input(_event):
	pass
