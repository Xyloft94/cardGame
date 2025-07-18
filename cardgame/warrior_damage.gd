extends "res://Card.gd"
@export var Name: String



func play(target):
	if gameManager.warriorHurt:
		temp_buffDamage(5)
	damage(3, target)
	armor(3)
		
	
