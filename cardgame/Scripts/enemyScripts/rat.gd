extends "res://Scripts/enemy.gd"

func _ready() -> void:
	super()
	move_pool= [
		func():
			await dealDamage(3,select_target())
	]
