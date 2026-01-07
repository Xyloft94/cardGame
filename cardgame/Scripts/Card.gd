extends Node2D
class_name Card

var caster :Node2D
@export var APcost :int
@export var Description :String
@export var Highlight :ColorRect
@export var Sprite :Sprite2D


func get_group(type: String, main_target: Node = null) -> Array:
	match type:
		"single": return [main_target]
		"all_enemies": return gameManager.enemyTeam.duplicate()
		"all_players": return gameManager.playerTeam.duplicate()
		"neighbors": 
			var team = gameManager.enemyTeam if main_target in gameManager.enemyTeam else gameManager.playerTeam
			var idx = team.find(main_target)
			var targets = [main_target]
			if idx > 0: targets.append(team[idx - 1])
			if idx < team.size() - 1: targets.append(team[idx + 1])
			return targets
		"line":
			var team = gameManager.enemyTeam
			var idx = team.find(main_target)
			var targets = [main_target]
			if idx != -1 and idx + 2 < team.size():
				targets.append(team[idx + 2])
			return targets
	return []

func apply_to_group(targets: Array, effect_callable: Callable):
	for t in targets:
		if is_instance_valid(t):
			effect_callable.call(t)
			# Small delay so numbers don't overlap perfectly
			await get_tree().create_timer(0.1).timeout


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
		target.emitArmor()
		target.gainArmor(amount)
		print(target.Name, amount)
		Feedback(target.global_position, amount, "armor")

func temp_buffDamage(amount: int, target:Node):
	target.emitBuff()
	target.temp_modDamage += amount
	Feedback(target.global_position, amount, "buff")
	
func apply_dot(effect_name: String, damage: int, duration: int, target: Node):
	var status_node = target.get_node_or_null("statusComponent")
	if status_node:
		status_node.add_effect(effect_name, {
			"damage": damage, 
			"turns": duration
		})
		# Just show the feedback and the hit reaction
		target.hitAnim() 
		Feedback(target.global_position, 0, effect_name)
	
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
	
# Add to Card.gd
func apply_debuff(effect_name: String, power: int, duration: int, target: Node):
	var status_node = target.get_node_or_null("statusComponent")
	if status_node:
		status_node.add_effect(effect_name, {
			"reduction": power, # How much damage the enemy loses
			"turns": duration
		})
		target.hitAnim() 
		Feedback(target.global_position, power, effect_name)
