extends "res://Scripts/enemy.gd"


func _ready() -> void:
	super()
	move_pool = [
		func():
			await dealDamage(7, select_target()),
		func():
			await dealDamage(5, select_target()),
			await action_dot("all_players", "Poison", 1, 5),
		func():
			buffAnim()
			await buffDamage(7),
		func():
			await action_attack("Neighbors", 6)
	]
