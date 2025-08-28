extends Node2D
class_name Card

@onready var caster = get_tree().get_first_node_in_group("Warrior")
@export var APcost :int
@export var Description :String
@export var Highlight :ColorRect
@export var Sprite :Sprite2D

func _physics_process(delta):
	pass

func play(target:Node):
	pass

func discard():
	Sprite.visible = false
	await get_tree().create_timer(.8).timeout
	EventBus.emit_signal("rearrangeHand")
	queue_free()
	
func inHand():
	pass
	
func damage(amount:int, target:Node):
	caster.attackAnim()
	var timerLength = caster.attackLength
	print(timerLength)
	gameManager.hideenemyDescription()
	await get_tree().create_timer(timerLength).timeout
	if caster.has_method("temp_modifyDamage"):
		amount = caster.temp_modifyDamage(amount)
	if target.has_method("takeDamage"):
		print("WHORK NOW")
		target.takeDamage(amount)
		Feedback(target.global_position, amount, "damage")
		
func armor(amount:int, target:Node):
	if target.has_method("gainArmor"):
		caster.emitArmor()
		target.gainArmor(amount)
		print(target.Name, amount)
		Feedback(target.global_position, amount, "armor")

func temp_buffDamage(amount: int, target:Node):
	caster.emitBuff()
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
