extends "res://Scripts/enemy.gd"


func _ready() -> void:
	super()
	move_pool = [
		func():
			buffAnim()
			await buffArmor(5),
		func():
			action_attack("neighbors", 6),
		func():
			buffAnim()
			await buffDamage(5),
		func():
			await dealDamage(8, select_target())
	]
