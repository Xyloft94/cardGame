extends Node2D

var playerSlots: Array = [p0,p1,p2]
var enemySlots: Array = [e0,e1,e2,e3]
@export var p0 : Marker2D
@export var p1 : Marker2D
@export var p2 : Marker2D
@export var e0 : Marker2D
@export var e1 : Marker2D
@export var e2 : Marker2D
@export var e3 : Marker2D


func _ready() -> void:
	pass # Replace with function body.

func placeChar(char:CharacterBody2D):
	if char.side == "Player":
		var slot = playerSlots[char.slotNumber]
		char.global_position = slot.global_position
		add_child(char)
	elif char.side == "Enemy":
		var slot = enemySlots[char.slotNumber]
		char.global_position = slot.global_position
		add_child(char)
