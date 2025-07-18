extends Node
class_name Card

@onready var caster = get_tree().get_first_node_in_group("Warrior")
@export var APcost :int

func discard():
	#add one card to draw
	pass
	
func inHand():
	pass
	
func damage(amount:int, target:Node):
	if caster.has_method("temp_modifyDamage"):
		amount = caster.temp_modifyDamage(amount)
	if target.has_method("takeDamage"):
		target.takeDamage(amount)
		
func armor(amount:int):
	print("well this works")
	if caster.has_method("gainArmor"):
		caster.gainArmor(amount)

func temp_buffDamage(amount: int):
	caster.temp_modDamage += amount
