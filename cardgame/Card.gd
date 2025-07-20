extends Node2D
class_name Card

@onready var caster = get_tree().get_first_node_in_group("Warrior")
@export var APcost :int
@export var Discription :String

func _physics_process(delta):
	pass

func play(target:Node):
	pass

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
	if caster.has_method("gainArmor"):
		caster.gainArmor(amount)

func temp_buffDamage(amount: int):
	caster.temp_modDamage += amount
	
func AP_nextTurn(amount: int):
	gameManager.modAP = amount
	
func showDiscription():
	print("working?")
	var label = gameManager.discriptionLabel
	label.text = Discription
	label.visible = true
	label.global_position = global_position + Vector2(100, 0)
	
func hideDiscription():
	gameManager.discriptionLabel.visible = false
