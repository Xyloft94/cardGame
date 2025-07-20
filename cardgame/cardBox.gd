extends Area2D

@export var parent: Node2D


func _on_mouse_entered():
	parent.showDiscription()
	


func _on_mouse_exited():
	parent.hideDiscription()
	

