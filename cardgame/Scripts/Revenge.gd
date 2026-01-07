extends "res://Scripts/Card.gd"

func play(target):
	caster.attackAnim()
	if caster.wasHurt:
		damage(8, target)
	else:
		damage(3, target)
	discard()
