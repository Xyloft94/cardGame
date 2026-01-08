extends "res://Scripts/enemy.gd"

func _ready():
	super()
	move_pool = [
		# MOVE 1: Smash neighbors and Poison them
		func(): 
			await action_attack("neighbors", 5),
			#await action_dot("neighbors", "Poison", 2, 3),

		# MOVE 2: Roar (Buffs team and Heals self)
		func():
			await action_buff("all_enemies", 2)
			await get_tree().create_timer(.5).timeout
			await action_heal("self", 10),

		# MOVE 3: Fire Breath (Burn all players)
		func(): 
			await action_dot("all_players", "Burn", 3, 2),


		func():
			await dealDamage(5, select_target())
	]
	
