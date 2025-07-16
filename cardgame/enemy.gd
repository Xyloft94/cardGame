extends Node2D
@export var health :int 

func takeDamage(damage: int):
	health -= damage
	print("health is now ", health, "you have taken ", damage, "damage")
