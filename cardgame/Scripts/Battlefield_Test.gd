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
	gameManager.prepareBattlefield()
	spawnPlayers()
	
	# Grab budget set by MapNode (fallback to difficulty_value if 0 or unassigned)
	var active_budget = gameManager.current_battle_budget
	if active_budget <= 0:
		active_budget = difficulty_value
		
	# Pass the dynamic budget to enemyLibrary
	var dynamic_enemies = enemyLibrary.get_encounter_scenes(active_budget)
	spawnEnemies(dynamic_enemies)

func spawnPlayers():
	var markers = playerSlots.get_children()
	for i in range(gameManager.playerTeam.size()):
		var activePlayer = gameManager.playerTeam[i]
		activePlayer.handComponent.owner = activePlayer
		var handComp = activePlayer.handComponent
		if activePlayer.get_parent():
			activePlayer.get_parent().remove_child(activePlayer)
		markers[i].add_child(activePlayer)
		activePlayer.position = Vector2.ZERO
		handComp.handContainer = handUI
		handComp.setupDeck()
		handComp.drawHand()
	gameManager.setAP()


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
	
