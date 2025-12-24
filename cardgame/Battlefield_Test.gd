extends Node2D
 
 
@export var enemy1: PackedScene
@export var enemy2: PackedScene
@export var enemy3: PackedScene
@export var enemy4: PackedScene
@export var player: PackedScene
@export var enemySlots: Node2D
@export var playerSlots: Node2D
@export var handUI: Node2D
@onready var Enemies = [enemy1, enemy2]



func _ready():
	gameManager.battleUI = $battleUI
	spawnPlayers()
	spawnEnemies()


func spawnPlayers():
	var markers = playerSlots.get_children()
	var newPlayer = player.instantiate()
	var hand_comp = newPlayer.get_node("handComponent")
	hand_comp.handContainer = handUI
	markers[0].add_child(newPlayer)
	gameManager.Player = newPlayer
	hand_comp.setupDeck()
	hand_comp.drawHand()
	gameManager.setAP()

func spawnEnemies():
	gameManager.enemyTeam.clear()
	var markers = enemySlots.get_children()
	for i in range(Enemies.size()):
		var newEnemy = Enemies[i].instantiate()
		var targetMarker = markers[i]
		targetMarker.add_child(newEnemy)
		gameManager.enemyTeam.append(newEnemy)
		newEnemy.Player = gameManager.Player
	print(gameManager.enemyTeam.size(), "This is how many enemies there are")
	
