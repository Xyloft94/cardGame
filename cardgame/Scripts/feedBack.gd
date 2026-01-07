extends Node2D

@export var label :Label 
@export var Arrow :Sprite2D
@export var animPlayer: AnimationPlayer

func showFeedback(number: int, type: String):
	if number == 0:
		label.text = type.capitalize()
	else:
		label.text = str(number)
	
	match type:
		"damage":
			label.modulate = Color.RED
		"burn":
			label.modulate = Color.ORANGE
		"poison":
			label.modulate = Color.GREEN_YELLOW
		"armor":
			label.modulate = Color(.8,.8,.8)
		"heal":
			label.modulate = Color.CYAN
		"buff":
			label.modulate = Color.RED
			Arrow.visible = true
			
	animPlayer.play("fade")
