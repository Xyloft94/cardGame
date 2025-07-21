extends CanvasLayer

@export var Card: Panel 
@export var Description: Label
@export var costAP: Label
@export var apLabel: Label

func _ready():
	apLabel.text = str(gameManager.totalAP)
