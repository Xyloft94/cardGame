extends "res://Scripts/enemy.gd"


func _ready():
	super()
	attackFunctions = [
		attackOne,
		attackTwo,
		attackOne,
		attackFour,
		attackOne
	]
