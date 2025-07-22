extends "res://Scripts/Card.gd"


func play(target):
	armor(4, target)
	AP_nextTurn(1)
	discard()
