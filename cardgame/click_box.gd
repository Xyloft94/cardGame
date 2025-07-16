extends Area2D

@export var enemy: bool
@export var player: bool
@export var parent: Node2D
var group :String


func _ready():
	if enemy:
		add_to_group("Enemy")

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if player:
		if event is InputEventMouseButton and event.is_pressed():
			gameManager.selectedCard(parent)
			print("this works")
	if enemy:
		if event is InputEventMouseButton and event.is_pressed():
			gameManager.selectedTarget(parent)
			print("still works")
