extends Node
class_name Card

func play(target:Node):
	pass
	
func discard():
	#add one card to draw
	pass
	
func inHand():
	pass
	
func damage(amount:int, target:Node):
	if target.has_method("takeDamage"):
		target.takeDamage(amount)
		
func armor(amount:int, target:Node):
	if target.has_method("gainArmor"):
		target.gainArmor(amount)
		
	
	
