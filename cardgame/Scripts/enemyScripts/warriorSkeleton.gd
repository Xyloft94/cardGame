extends "res://Scripts/enemy.gd"


func _ready() -> void:
	super()
	
	move_pool = [
		func(): 
			await action_attack("neighbors", 3),
			
		func():
			await dealDamage(3, select_target()),
			
		func():
			buffAnim()
			action_armor("self", 3)
	]
