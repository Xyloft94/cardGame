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
enum TurnOrder {PLAYER, ENEMY}


func _ready():
	EventBus.connect("takenDamage", Callable(self, "takenDamage"))
	

func selectedCard(card: Node):
	chosenCard = card
	chosenCard.Highlight.visible = true
	cardClicked = true
	
func selectedTarget(target: Node):
	if chosenCard and chosenCard.APcost <= totalAP:
		chosenCard.play(target.parent)
		totalAP = (totalAP - chosenCard.APcost)
		battleUI.apLabel.text = str(totalAP)
		cardClicked = false
		hideCardDescription()
		print(totalAP)
		
func playerTurn():
	resetAP()
	Player.reDraw()

func enemyTurn():
	Enemy.Attack()
	
func endPlayerTurn():
	warriorHurt = false
	wizardHurt = false
	enemyTurn()
	
func endEnemyTurn():
	resetAP()
	currentTurn = TurnOrder.PLAYER
	totalAP = (totalAP + modAP)
	battleUI.apLabel.text = str(totalAP)
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
		totalAP 
		totalAP = (modAP + 3)
	totalAP = 3
	
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
	battleUI.enemyHealth.text = ("Health :" + str(enemy.health))
	battleUI.enemyBuffs.text = ("Attack + " + str(enemy.modifiedDamage))
	
func hideenemyDescription():
	battleUI.EnemyDescription.visible = false
