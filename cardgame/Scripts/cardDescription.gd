extends CanvasLayer

@export var Card: Panel 
@export var Description: Label
@export var costAP: Label
@export var apLabel: Label
@export var EnemyDescription: Panel
@export var enemyName: Label
@export var enemyHealth: Label
@export var enemyBuffs: Label
@export var PlayerDescription: Panel
@export var playerName: Label
@export var playerHealth: Label
@export var playerBuffs: Label
@export var playerArmor: Label

func _ready():
	apLabel.text = ("AP: " + str(gameManager.totalAP))
	



func _on_button_pressed():
	gameManager.endPlayerTurn()
