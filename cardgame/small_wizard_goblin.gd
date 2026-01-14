extends "res://Scripts/enemy.gd"

func _ready() -> void:
	super()
	move_pool = [
		func():
			await action_dot("target", "Burn", 2, 3),
		func ():
			await dealDamage(4, select_target())
			
	]
