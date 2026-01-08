extends "res://Scripts/Card.gd"

func play(target):
	caster.attackAnim()
	var targets = get_group("neighbors", target)
	var effect = func(t): 
		damage(6, t)
	await apply_to_group(targets, effect)
	
	# 5. Clean up
	discard()
