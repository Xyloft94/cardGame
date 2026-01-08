extends Node2D
 
 
@export var enemy1: PackedScene
@export var enemy2: PackedScene
@export var enemy3: PackedScene
@export var enemy4: PackedScene
#@export var player: PackedScene
@export var enemySlots: Node2D
@export var playerSlots: Node2D
@export var handUI: Node2D
@onready var Enemies = [enemy1, enemy2, enemy3, enemy4]



func _ready():
	gameManager.battleUI = $battleUI
	spawnPlayers()
	spawnEnemies()


func spawnPlayers():
	var markers = playerSlots.get_children()
	for i in range(gameManager.playerTeam.size()):
		var activePlayer = gameManager.playerTeam[i]
		var handComp = activePlayer.handComponent
		if activePlayer.get_parent():
			activePlayer.get_parent().remove_child(activePlayer)
		markers[i].add_child(activePlayer)
		activePlayer.position = Vector2.ZERO
		handComp.handContainer = handUI
		handComp.setupDeck()
		handComp.drawHand()
	gameManager.setAP()
	#var newPlayer = player.instantiate()
	#var hand_comp = newPlayer.get_node("handComponent")
	#hand_comp.handContainer = handUI
	#markers[0].add_child(newPlayer)
	#gameManager.Player = newPlayer
	#hand_comp.setupDeck()
	#hand_comp.drawHand()
	#gameManager.setAP()

func spawnEnemies():
	# 1. Clear the list completely before starting
	gameManager.enemyTeam.clear()
	
	var markers = enemySlots.get_children()
	
	# 2. Only spawn as many enemies as you have MARKERS for
	# This prevents "ghost" enemies from being added to the logic array
	var spawn_count = min(Enemies.size(), markers.size())
	
	for i in range(spawn_count):
		if Enemies[i] == null: continue # Safety check for empty export slots
		
		var newEnemy = Enemies[i].instantiate()
		markers[i].add_child(newEnemy)
		
		# 3. Add to the team array
		gameManager.enemyTeam.append(newEnemy)
		
		# Assign targets
		if gameManager.playerTeam.size() > 0:
			newEnemy.Player = gameManager.playerTeam[0]
	print("Final Enemy Team Size: ", gameManager.enemyTeam.size())
	
