extends Node2D
 
 
@export var enemy1: PackedScene
@export var enemy2: PackedScene
@export var enemy3: PackedScene
@export var enemy4: PackedScene
@export var difficulty_value: int = 10
#@export var player: PackedScene
@export var enemySlots: Node2D
@export var playerSlots: Node2D
@export var handUI: Node2D



func _ready():
	gameManager.battleUI = $battleUI
	spawnPlayers()
	
	# NEW: Get dynamic enemies from library
	var dynamic_enemies = enemyLibrary.get_encounter_scenes(difficulty_value)
	spawnEnemies(dynamic_enemies)

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

func spawnEnemies(scenes_to_spawn: Array[PackedScene]):
	gameManager.enemyTeam.clear()
	var markers = enemySlots.get_children()
	
	for i in range(scenes_to_spawn.size()):
		if i >= markers.size(): break # Stop if we run out of markers
		
		var newEnemy = scenes_to_spawn[i].instantiate()
		markers[i].add_child(newEnemy)
		gameManager.enemyTeam.append(newEnemy)
		
		# Assign basic target
		if not gameManager.playerTeam.is_empty():
			newEnemy.Player = gameManager.playerTeam[0]

	print("Final Enemy Team Size: ", gameManager.enemyTeam.size())
	
