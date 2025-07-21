extends Node2D
class_name Card

@onready var caster = get_tree().get_first_node_in_group("Warrior")
@export var APcost :int
@export var Description :String

func _physics_process(delta):
	pass

func play(target:Node):
	pass

func discard():
	EventBus.emit_signal("rearrangeHand")
	queue_free()
	
func inHand():
	pass
	
func damage(amount:int, target:Node):
	if caster.has_method("temp_modifyDamage"):
		amount = caster.temp_modifyDamage(amount)
	if target.has_method("takeDamage"):
		target.takeDamage(amount)
		
func armor(amount:int, target:Node):
	if target.has_method("gainArmor"):
		target.gainArmor(amount)
		print(target.Name, amount)

func temp_buffDamage(amount: int, target:Node):
	caster.temp_modDamage += amount
	
func AP_nextTurn(amount: int):
	gameManager.modAP = amount
	
func showDiscription():
	gameManager.showDescription(Description, APcost)
	#var label = gameManager.discriptionLabel
	#label.text = Discription
	#label.visible = true
	#label.global_position = global_position + Vector2(100, 0)
	
func hideDiscription():
	gameManager.hideDescription()
	#gameManager.discriptionLabel.visible = false
