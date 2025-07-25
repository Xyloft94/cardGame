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
var Player: CharacterBody2D 
var Enemy: CharacterBody2D 
var canChooseCard: bool 
enum TurnOrder {PLAYER, ENEMY}


func _ready():
	EventBus.connect("takenDamage", Callable(self, "takenDamage"))
	canChooseCard = true
	
	
func _physics_process(delta):
	if Input.is_action_just_pressed("declick") and not canChooseCard:
		
		deselectCard(chosenCard)

func selectedCard(card: Node):
	if canChooseCard:
		chosenCard = card
		chosenCard.Highlight.visible = true
		cardClicked = true
		canChooseCard = false

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
		battleUI.apLabel.text = ("AP: " + str(totalAP))
		cardClicked = false
		hideCardDescription()
		canChooseCard = true 


func playerTurn():
	resetAP()
	Player.reDraw()
	modAP = 0

func enemyTurn():
	Enemy.Attack()

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
	totalAP = Player.AP

func resetAP():
	if modAP > 0:
		totalAP = (modAP + 3)
	else:
		totalAP = 3
	battleUI.apLabel.text = ("AP: " + str(totalAP))
	
	
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

