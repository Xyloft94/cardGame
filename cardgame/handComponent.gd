extends Node2D

var deckList: Dictionary = {}
var drawPile: Array[PackedScene] = []
var handContainer: Node2D
var intelligence: int




func _ready():
	if owner:
		intelligence = owner.intelligence
		deckList = owner.deckList
	

func setupDeck():
	for path in deckList.keys():
		var count = deckList[path]
		var cardScene = load(path)
		for i in count:
			drawPile.append(cardScene)
	drawPile.shuffle()
	
func drawHand():
	for i in intelligence:
		drawCard()
		
func drawCard():
	if drawPile.is_empty():
		return
	var cardScene = drawPile.pop_front()
	var card = cardScene.instantiate()
	card.caster = owner
	handContainer.add_child(card)
	handContainer.arrangeHand()
	
func reDraw():
	var numberToDraw = intelligence - handContainer.get_child_count()
	for i in numberToDraw:
		drawCard()
