extends Node2D

@export var test_player :Node2D
@export var test_ui :Node2D

func _ready():
	# 1. Grab the component
	gameManager.battleUI = $battleUI
	var hand_comp = test_player.get_node("handComponent")
	
	# 2. Manual Injection (Just like your Battlefield does)
	hand_comp.handContainer = test_ui
	
	# 3. Test the logic
	hand_comp.setupDeck()
	hand_comp.drawHand()
	
	print("Sandbox: Hand drawn. Use the 'F6' key to run this scene specifically.")
