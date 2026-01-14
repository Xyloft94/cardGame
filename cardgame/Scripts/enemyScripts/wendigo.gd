extends "res://Scripts/enemy.gd"

func _ready() -> void:
	super()
	move_pool = [
		func():
			await action_dot("Neighbors", "Burn", 4, 3),
		func():
			await dealDamage(8, select_target()),
			await action_heal("self", 8),
		func():
			await buffDamage(4)
	]
