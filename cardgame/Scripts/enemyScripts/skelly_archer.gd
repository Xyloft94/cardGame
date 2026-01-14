extends "res://Scripts/enemy.gd"

func _ready() -> void:
	super()
	move_pool = [
		func():
			await dealDamage(4, select_target()),
		func():
			await dealDamage(4, select_target()),
		func():
			await action_attack("all_players", 2)
	]
