extends Node

class_name Card

func play(target:Node):
	print("working")
	
func discard():
	#add one card to draw
	pass
	
func inHand():
	pass
	
func damage(amount:int, target:Node):
	if target.is_in_group("Enemy"):
		target.takeDamage(amount)
	
