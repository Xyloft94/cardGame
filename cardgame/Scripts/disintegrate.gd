extends "res://Scripts/Card.gd"

func play(target):
	caster.attackAnim()
	damage(20, target)
	discard()
