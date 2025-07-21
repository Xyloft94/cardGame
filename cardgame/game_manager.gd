extends Node2D

@export var discriptionLabel: Label
var chosenCard: Node = null
var totalAP: int = 3
var modAP: int
var warriorHurt: bool 
var wizardHurt: bool
var currentTurn = TurnOrder.PLAYER
#var Player = get_tree().get_first_node_in_group("Player")
var battleUI :CanvasLayer = null
enum TurnOrder {PLAYER, ENEMY}


func _ready():
	EventBus.connect("takenDamage", Callable(self, "takenDamage"))

func selectedCard(card: Node):
	chosenCard = card
	
func selectedTarget(target: Node):
	if chosenCard and chosenCard.APcost <= totalAP:
		chosenCard.play(target.parent)
		totalAP = (totalAP - chosenCard.APcost)
		battleUI.apLabel.text = str(totalAP)
		print(totalAP)
		
		
func enemyTurn():
	pass
	
func turnManager():
	if totalAP == 0:
		endPlayerTurn()
		
func endPlayerTurn():
	warriorHurt = false
	wizardHurt = false
	currentTurn = TurnOrder.ENEMY
	
func endEnemyTurn():
	resetAP()
	currentTurn = TurnOrder.PLAYER
	totalAP = (totalAP + modAP)
	battleUI.apLabel = totalAP
	
	
func takenDamage(Name:String):
	match Name:
		"Warrior":
			warriorHurt = true
		"Wizard":
			wizardHurt = true
			
func setAP():
	pass
	#totalAP = Player.AP

func resetAP():
	if modAP > 0:
		totalAP 
		totalAP = (modAP + 3)
	totalAP = 3
	
func showDescription(Description:String, cost:int):
	battleUI.Card.visible = true
	battleUI.Description.text = Description
	battleUI.costAP.text = (str(cost))
	
func hideDescription():
	battleUI.Card.visible = false
