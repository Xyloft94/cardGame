extends "res://Scripts/Card.gd"

func play(target):
	caster.attackAnim()
	damage(5, target)
	discard()
