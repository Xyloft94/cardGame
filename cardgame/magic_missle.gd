extends "res://Scripts/Card.gd"


func play(target):
	caster.attackAnim()
	damage(6, target)
	discard()
