extends Node2D

@export var discriptionLabel: Label
var chosenCard: Node = null
var totalAP: int = 3
var modAP: int
var warriorHurt: bool 
var wizardHurt: bool
var currentTurn = TurnOrder.PLAYER
#var Player = get_tree().get_first_node_in_group("Player")
enum TurnOrder {PLAYER, ENEMY}


func _ready():
	EventBus.connect("takenDamage", Callable(self, "takenDamage"))

func selectedCard(card: Node):
	chosenCard = card
	print(card.Discription)
	
func selectedTarget(target: Node):
	if chosenCard and chosenCard.APcost <= totalAP:
		chosenCard.play(target.parent)
		totalAP = (totalAP - chosenCard.APcost)
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


	
