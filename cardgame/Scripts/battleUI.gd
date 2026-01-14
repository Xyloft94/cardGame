extends CanvasLayer

@export var handUI: Node2D
@export var Card: Panel 
@export var Description: Label
@export var costAP: Label
@export var apLabel: Label
@export var EnemyDescription: Panel
@export var enemyName: Label
@export var enemyHealth: Label
@export var enemyArmor: Label
@export var enemyBuffs: Label
@export var enemyStatus: Label
@export var PlayerDescription: Panel
@export var playerName: Label
@export var playerHealth: Label
@export var playerBuffs: Label
@export var playerArmor: Label
@export var playerStatus: Label

func _ready():
	await get_tree().create_timer(.1).timeout
	apLabel.text = ("AP: " + str(gameManager.totalAP))
	



func _on_button_pressed():
	if gameManager.isPlayerTurn:
		gameManager.endPlayerTurn()
