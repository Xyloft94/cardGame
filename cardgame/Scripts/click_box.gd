extends Area2D

@export var card: bool
@export var parent: Node2D
var group :String





func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if card:
		if event is InputEventMouseButton and event.is_pressed():
			gameManager.selectedCard(parent)
	else:
		if event is InputEventMouseButton and event.is_pressed():
			gameManager.selectedTarget(self)
