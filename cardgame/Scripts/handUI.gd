extends Node2D

var spacing: int = 70
var centerOffset: Vector2 = Vector2.ZERO

func _ready():
	EventBus.connect("rearrangeHand", Callable(self, "rearrangeHand"))

func arrangeHand():
	var count = get_child_count()
	if count == 0:
		return
	
	var totalWidth = (count - 1) * spacing
	var leftmostCardPosition = -totalWidth / 2
	
	for i in range(count):
		var card = get_child(i)
		var target_pos = Vector2(leftmostCardPosition + i * spacing, 0) + centerOffset
		
		# We use a simple Tween just for the Position
		var tween = create_tween()
		# TRANS_SINE is smoother and less "bouncy" than TRANS_BACK 
		# which helps it feel more stable
		tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
		tween.tween_property(card, "position", target_pos, 0.2)

func rearrangeHand():
	await get_tree().process_frame
	arrangeHand()
	
