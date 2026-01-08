extends Node2D

@export var discriptionLabel: Label

var chosenCard: Node = null
var totalAP: int 
var modAP: int
var warriorHurt: bool 
var wizardHurt: bool
var currentTurn = TurnOrder.PLAYER
var battleUI :CanvasLayer = null
var cardClicked :bool = false
var playerTeam: Array = []
var Player1: Player
var Player2: Player
var enemyTeam: Array = []
var canChooseCard: bool 
var activePlayer: Player
enum TurnOrder {PLAYER, ENEMY}


func _ready():
	var warriorScene = load("res://Warrior.tscn")
	var wizardScene = load("res://Wizard.tscn")
	Player1 = warriorScene.instantiate()
	Player2 = wizardScene.instantiate()
	add_child(Player1)
	add_child(Player2)
	playerTeam.append(Player1)
	playerTeam.append(Player2)
	activePlayer = Player1
	canChooseCard = true
	
func _physics_process(delta):
	if Input.is_action_just_pressed("declick") and not canChooseCard:
		
		deselectCard(chosenCard)

func selectedCard(card: Node):
	print("Clicked card: ", card.name)
	print("Can I choose? ", canChooseCard)
	if canChooseCard:
		chosenCard = card
		if chosenCard.Highlight:
			chosenCard.Highlight.visible = true
		cardClicked = true
		canChooseCard = false
		print("Card Selected Successfully!")

func deselectCard(card: Node):
	print("de-select card bro")
	chosenCard.Highlight.visible = false
	cardClicked = false
	hideCardDescription()
	canChooseCard = true
	chosenCard = null

func selectedTarget(target: Node):
	if chosenCard and chosenCard.APcost <= totalAP: 
		chosenCard.play(target.parent)
		totalAP = (totalAP - chosenCard.APcost)
		chosenCard.Highlight.visible = false
		battleUI.apLabel.text = ("AP: " + str(totalAP))
		cardClicked = false
		hideCardDescription()
		canChooseCard = true 

func playerTurn():
	resetAP()
	modAP = 0
	for member in playerTeam:
		if is_instance_valid(member):
			if member.has_method("start_turn"):
				await member.start_turn() 
			if member.handComponent:
				member.handComponent.reDraw()
			await get_tree().process_frame
	

	battleUI.handUI.arrangeHand()
	
	await get_tree().create_timer(0.5).timeout
	print("Player Turn Ready")

func enemyTurn():
	print("this is the enemy turn")
	for currentEnemy in enemyTeam.duplicate():
		if is_instance_valid(currentEnemy):
			currentEnemy.Attack()
			await get_tree().create_timer(currentEnemy.attackLength + 0.8).timeout
	await get_tree().create_timer(1).timeout
	endEnemyTurn()

func endPlayerTurn():
	for member in playerTeam:
		if is_instance_valid(member):
			member.wasHurt = false
	enemyTurn()

func endEnemyTurn():
	resetAP()
	playerTurn()


func takenDamage(Name:String):
	match Name:
		"Warrior":
			warriorHurt = true
		"Wizard":
			wizardHurt = true

func setAP():
	var teamTotal = 0
	for member in playerTeam:
		if is_instance_valid(member):
			teamTotal+= member.AP
	totalAP = teamTotal

func resetAP():
	var teamTotal = 0
	for member in playerTeam:
		if is_instance_valid(member):
			teamTotal += member.AP
	totalAP = teamTotal + modAP
	if battleUI and battleUI.apLabel:
		battleUI.apLabel.text = ("AP: " + str(totalAP))
	
	print("AP Reset! New total: ", totalAP)
	
	
func showCardDescription(Description:String, cost:int):
	battleUI.Card.visible = true
	battleUI.Description.text = Description
	battleUI.costAP.text = (str(cost))

func hideCardDescription():
	if not cardClicked:
		battleUI.Card.visible = false
	else:
		pass

func showenemyDescription(enemy: CharacterBody2D, status_text: String = ""):
	battleUI.EnemyDescription.visible = true
	battleUI.enemyName.text = enemy.Name
	battleUI.enemyHealth.text = ("Health: " + str(enemy.health))
	battleUI.enemyArmor.text = ("Armor: " + str(enemy.armor))
	battleUI.enemyBuffs.text = ("Attack + " + str(enemy.modifiedDamage))
	if status_text != "":
		battleUI.enemyStatus.text = status_text
		battleUI.enemyStatus.visible = true
	else:
		battleUI.enemyStatus.text = ""
		battleUI.enemyStatus.visible = false

func hideenemyDescription():
	battleUI.EnemyDescription.visible = false

func showplayerDescription(player: Player, status_text: String = ""):
	battleUI.PlayerDescription.visible = true
	battleUI.playerName.text = player.Name
	battleUI.playerHealth.text = ("Health: " + str(player.health))
	battleUI.playerArmor.text = ("Armor: " + str(player.armor))
	battleUI.playerBuffs.text = ("Attack + " + str(player.temp_modDamage))
	var label = battleUI.playerStatus
	
	if label:
		label.visible = (status_text != "")
	else:
		print("UI Warning: Could not find 'playerStatus' label in PlayerDescription panel")
	
func hideplayerDescription():
	battleUI.PlayerDescription.visible = false

func setActivePlayer(newPlayer: Player):
	if activePlayer == newPlayer: 
		return
	
	if activePlayer != null:
		var cards_to_move = battleUI.handUI.get_children()
		for card in cards_to_move:
			battleUI.handUI.remove_child(card)
			activePlayer.handComponent.add_child(card)
			card.visible = false
	
	activePlayer = newPlayer
	
	for card in activePlayer.handComponent.get_children():
		if card is Card: 
			activePlayer.handComponent.remove_child(card)
			battleUI.handUI.add_child(card)
			card.visible = true
			
			# --- THE FIX ---
			# Set them to (0,0) relative to the HandUI center.
			# Now, arrangeHand() will push them OUT from the middle 
			# exactly like it does during the initial draw.
			card.position = Vector2.ZERO 
	
	battleUI.handUI.arrangeHand()
	showplayerDescription(activePlayer)
