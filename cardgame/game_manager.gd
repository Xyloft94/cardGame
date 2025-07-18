extends Node2D

var chosenCard: Node = null
var totalAP : int = 3
var warriorHurt: bool = true
var wizardHurt: bool
var currentTurn = TurnOrder.PLAYER
enum TurnOrder {PLAYER, ENEMY}


func selectedCard(card: Node):
	chosenCard = card
	
func selectedTarget(target: Node):
	if chosenCard and chosenCard.APcost <= totalAP:
		chosenCard.play(target.parent)
		totalAP = (totalAP - chosenCard.APcost)
		print(chosenCard.Name, totalAP)
		
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
	currentTurn = TurnOrder.PLAYER
	
func takenDamage(Name:String):
	match Name:
		"Warrior":
			warriorHurt = true
		"Wizard":
			wizardHurt = true
