extends Node2D

var spacing: int = 90
var centerOffset: Vector2 = Vector2.ZERO

func arrangeHand():
	var count = get_child_count()
	if count == 0:
		return
	
	var totalWidth = (count - 1) * spacing
	var leftmostCardPosition = -totalWidth / 2
	
	for i in range(count):
		var card = get_child(i)
		card.position = Vector2(leftmostCardPosition + i * spacing, 0) + centerOffset
