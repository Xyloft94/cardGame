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
	if owner:
		intelligence = owner.intelligence
		deckList = owner.deckList
	drawPile.clear()
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
	
	# If I'm not the one currently playing, hide the card in my local folder
	if gameManager.activePlayer != owner:
		add_child(card)
		card.visible = false
	else:
		# Ensure the handContainer exists before adding
		if handContainer:
			handContainer.add_child(card)
			handContainer.arrangeHand()
		else:
			# Fallback: keep it local if UI isn't ready
			add_child(card)
			card.visible = false
	
func reDraw():
	# If I am the active player, my cards are in the UI (handContainer)
	# If I am NOT active, my cards are children of THIS node (handComponent)
	var current_hand_count = 0
	
	if gameManager.activePlayer == owner:
		current_hand_count = handContainer.get_child_count()
	else:
		current_hand_count = get_child_count()
	
	var numberToDraw = intelligence - current_hand_count
	
	# Safety check: don't draw negative cards if intelligence dropped
	if numberToDraw > 0:
		for i in numberToDraw:
			drawCard()
