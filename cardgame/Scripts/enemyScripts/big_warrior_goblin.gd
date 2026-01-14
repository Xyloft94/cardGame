extends "res://Scripts/enemy.gd"

func _ready() -> void:
	super()
	move_pool = [
		func():
			await action_attack("Neighbor", 5),
			
		func():
			await dealDamage(5, select_target()),
			#await action_dot("neighbors", "Poison", 2, 3)
			
		func():
			buffAnim()
			await buffArmor(4),
			
		func():
			await dealDamage(7, select_target())
	]
