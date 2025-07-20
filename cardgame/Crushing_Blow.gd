extends "res://Card.gd"

func _physics_process(delta):
	if caster.armor >= 10:
		APcost = 1

func play(target):
	damage(14, target)
