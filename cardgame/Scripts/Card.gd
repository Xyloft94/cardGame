extends Node2D
class_name Card

@onready var caster = get_tree().get_first_node_in_group("Warrior")
@export var APcost :int
@export var Description :String
@export var Highlight :ColorRect

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
		Feedback(target.global_position, amount, "damage")
	if target.has_method("takeDamage"):
		target.takeDamage(amount)
		Feedback(target.global_position, amount, "damage")
		
func armor(amount:int, target:Node):
	if target.has_method("gainArmor"):
		target.gainArmor(amount)
		print(target.Name, amount)
		Feedback(target.global_position, amount, "armor")

func temp_buffDamage(amount: int, target:Node):
	caster.temp_modDamage += amount
	Feedback(target.global_position, amount, "buff")
	
func AP_nextTurn(amount: int):
	gameManager.modAP += amount
	
func showDescription():
	gameManager.showCardDescription(Description, APcost)
	
func hideDescription():
	gameManager.hideCardDescription()

func scaleTween():
	pass

func Feedback(targetPosition: Vector2, amount: int, type: String):
	var offset :Vector2 = Vector2(-40, -90)
	var feedback = preload("res://feedBack.tscn").instantiate()
	feedback.showFeedback(amount, type)
	feedback.global_position = targetPosition + offset
	get_tree().current_scene.add_child(feedback)
