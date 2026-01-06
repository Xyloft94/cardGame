extends Area2D

@export var card: bool
@export var parent: Node2D
@export var player: bool
var group :String





func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
			if card:
				gameManager.selectedCard(parent)
				print("this should work")
			elif player:
				# If we are holding a card, the player is a TARGET (like for a Heal)
				if gameManager.chosenCard != null:
					gameManager.selectedTarget(self)
				# If we aren't holding a card, we are SELECTING the player
				else:
					gameManager.setActivePlayer(parent)
			else:
				# It's an enemy, always a target
				gameManager.selectedTarget(self)
