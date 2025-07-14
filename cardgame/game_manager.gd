extends Node2D

var chosenCard: Node = null

func selectedCard(card: Node):
	chosenCard = card
	
func selectedTarget(target: Node):
	if chosenCard:
		chosenCard.play(target)
		print(chosenCard.Name)
	
