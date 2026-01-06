extends Node2D

@export var discriptionLabel: Label

var chosenCard: Node = null
var totalAP: int 
var modAP: int
var warriorHurt: bool 
var wizardHurt: bool
var currentTurn = TurnOrder.PLAYER
#var Player = get_tree().get_first_node_in_group("Player")
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
	Player1 = warriorScene.instantiate()
	Player2 = warriorScene.instantiate()
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
	
	# Loop through every player in the team and have them refill their hand
	for member in playerTeam:
		if is_instance_valid(member):
			member.handComponent.reDraw()
	
	# Ensure the UI reflects the current active player's hand immediately
	battleUI.handUI.arrangeHand()

func enemyTurn():
	print("this is the enemy turn")
	for currentEnemy in enemyTeam.duplicate():
		if is_instance_valid(currentEnemy):
			currentEnemy.Attack()
			await get_tree().create_timer(currentEnemy.attackLength + 0.5).timeout
	endEnemyTurn()

func endPlayerTurn():
	warriorHurt = false
	wizardHurt = false
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
	# 1. Calculate the team's total AP capacity
	var teamTotal = 0
	for member in playerTeam:
		if is_instance_valid(member):
			teamTotal += member.AP # Assumes your Warrior script has a 'var AP'
	
	# 2. Add any bonus AP from the previous turn (modAP)
	totalAP = teamTotal + modAP
	
	# 3. Update the UI label
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

func showenemyDescription(enemy: CharacterBody2D):
	battleUI.EnemyDescription.visible = true
	battleUI.enemyName.text = enemy.Name
	battleUI.enemyHealth.text = ("Health : " + str(enemy.health))
	battleUI.enemyBuffs.text = ("Attack + " + str(enemy.modifiedDamage))

func hideenemyDescription():
	battleUI.EnemyDescription.visible = false

func showplayerDescription(player: CharacterBody2D):
	battleUI.PlayerDescription.visible = true
	battleUI.playerName.text = player.Name
	battleUI.playerHealth.text = ("Health : " + str(player.health))
	battleUI.playerBuffs.text = ("Attack + " + str(player.temp_modDamage))
	battleUI.playerArmor.text = ("Armor : " + str(player.armor))
	
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
	battleUI.handUI.arrangeHand()
	showplayerDescription(activePlayer)
