extends Node2D

var deckList: Dictionary = {}
var drawPile: Array[PackedScene] = []
var discardPile: Array[PackedScene] = [] # Track played cards
var handContainer: Node2D
var intelligence: int


func _ready():
	_sync_owner_data()


func _sync_owner_data():
	var p = owner if owner else get_parent()
	if p:
		if "intelligence" in p:
			intelligence = p.intelligence
		if "deckList" in p:
			deckList = p.deckList


func setupDeck():
	_sync_owner_data()
	drawPile.clear()
	discardPile.clear()
	
	for path in deckList.keys():
		var count = deckList[path]
		var cardScene = load(path)
		if cardScene:
			for i in count:
				drawPile.append(cardScene)
	drawPile.shuffle()


func drawHand():
	for i in intelligence:
		drawCard()


func drawCard():
	# If draw pile is empty, attempt to reshuffle discard pile
	if drawPile.is_empty():
		if not discardPile.is_empty():
			drawPile = discardPile.duplicate()
			discardPile.clear()
			drawPile.shuffle()
			print("Draw pile empty: Reshuffled discard pile back into draw pile!")
		else:
			print("Both draw and discard piles are empty!")
			return

	var cardScene = drawPile.pop_front()
	var card = cardScene.instantiate()
	var p = owner if owner else get_parent()
	card.caster = p
	
	# If this unit is NOT active, hold card invisibly under handComponent
	if gameManager.activePlayer != p:
		add_child(card)
		card.visible = false
	else:
		if is_instance_valid(handContainer):
			handContainer.add_child(card)
			if handContainer.has_method("arrangeHand"):
				handContainer.arrangeHand()
		else:
			add_child(card)
			card.visible = false


func reDraw():
	_sync_owner_data()
	var p = owner if owner else get_parent()
	
	if gameManager.activePlayer == p:
		# 1. Move any local cards sitting in handComponent up to the handContainer UI
		if is_instance_valid(handContainer):
			for child in get_children():
				if child is Card:
					remove_child(child)
					handContainer.add_child(child)
					child.visible = true
		
		# 2. Calculate how many MORE cards needed to reach intelligence
		var current_hand_count = handContainer.get_child_count() if is_instance_valid(handContainer) else 0
		var numberToDraw = intelligence - current_hand_count
		
		if numberToDraw > 0:
			for i in numberToDraw:
				drawCard()
	else:
		# For inactive party members, top off their hidden cards up to intelligence
		var current_local_count = get_child_count()
		var numberToDraw = intelligence - current_local_count
		
		if numberToDraw > 0:
			for i in numberToDraw:
				drawCard()
