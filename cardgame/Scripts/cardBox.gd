extends Area2D

@export var parent: Node2D
@export var card: bool


func _on_mouse_entered():
	parent.showDescription()
	


func _on_mouse_exited():
	parent.hideDescription()
	
