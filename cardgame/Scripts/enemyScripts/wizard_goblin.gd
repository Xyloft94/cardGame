extends "res://Scripts/enemy.gd"

func _ready() -> void:
	super()
	move_pool = [
		func():
			await dealDamage(5, select_target()),
			await action_dot("Neighbors", "Burn", 4, 3),
		func():
			buffAnim()
			await buffDamage(6),
			
		func():
			await action_attack("all_players", 4),
			await action_dot("Neighbors", "Burn", 2, 2),
	]
