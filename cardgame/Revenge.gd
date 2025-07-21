extends "res://Scripts/Card.gd"

func play(target):
	if gameManager.warriorHurt:
		damage(8, target)
	else:
		damage(3, target)
	discard()
