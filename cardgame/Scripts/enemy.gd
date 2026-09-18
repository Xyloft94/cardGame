extends CharacterBody2D
class_name Enemy

@export var health :int 
@export var armor: int
var Player :CharacterBody2D # This is the variable your spawner looks for
var attackWheelValue :int
var modifiedDamage :int = 0
var attackFunctions: Array[Callable] = []

@export var Description :String
@export var Name :String
@export var animTree: AnimationTree
@export var attackLength: float
@export var hitLength: float
@export var deathLength: float
@export var particles: GPUParticles2D
@export var side: String
@export var statusComponent: Node2D

var move_pool: Array = [] 

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("Space"):
		Attack()
		print("Manual Attack Triggered")

# --- NEW: TARGETING GROUPS ---

func get_group(type: String, main_target: Node = null) -> Array:
	match type:
		"all_players": return gameManager.playerTeam.duplicate()
		"all_enemies": return gameManager.enemyTeam.duplicate()
		"self": return [self]
		"target": return [main_target]
		"neighbors":
			var team = gameManager.playerTeam
			var idx = team.find(main_target)
			var targets = [main_target]
			if idx > 0: targets.append(team[idx - 1])
			if idx < team.size() - 1: targets.append(team[idx + 1])
			return targets
	return [main_target]

func select_target() -> Node:
	var valid_entries: Array = []
	var total_weight: int = 0

	# Loop through the players based on their current slot index
	for i in range(gameManager.playerTeam.size()):
		var player = gameManager.playerTeam[i]
		if is_instance_valid(player):
			# Get the weight for this slot (falls back to 10 if index exceeds slot_weights)
			var weight = gameManager.slotWeights[i] if i < gameManager.slotWeights.size() else 10
			valid_entries.append({"player": player, "weight": weight})
			total_weight += weight

	# Return null if all players are dead/invalid
	if valid_entries.is_empty():
		return null

	# Roll a random number within the active weight sum
	var roll = randi_range(1, total_weight)
	var current_sum: int = 0

	for entry in valid_entries:
		current_sum += entry["weight"]
		if roll <= current_sum:
			return entry["player"]

	return valid_entries[0]["player"]
	
	#OLD TARGETING.
	#var valid_targets = gameManager.playerTeam.filter(func(p): return is_instance_valid(p))
	#if valid_targets.is_empty():
		#return null
	#return valid_targets.pick_random()

# --- CORE LOGIC ---

func Attack():
	if statusComponent:
		statusComponent.process_statuses()
	
	await get_tree().create_timer(0.5).timeout
	if move_pool.is_empty(): return
	
	var move = move_pool.pick_random()
	
	# SUPPORT BOTH STYLES: 
	# If the move is a function (Callable), run it. 
	# Otherwise, use the old dictionary match logic.
	if move is Callable:
		await move.call()
	else:
		match move["type"]:
			"attack":
				await dealDamage(move["value"])
			"buff":
				await buffDamage(move["value"])
			"heal":
				await heal(move["value"])
			"multi":
				await dealDamage(move["value"])
				await get_tree().create_timer(0.5).timeout
				await buffDamage(move["buff_value"])

#
func takeDamage(damage: int):
	health -= damage
	hitAnim() 
	Feedback(self.global_position, damage, "damage")
	if health <= 0:
		die()

func dealDamage(amount: int, target: Node = null):
	var debuff_power = statusComponent.get_total_reduction()
	var total_dmg = amount + modifiedDamage - debuff_power
# Ensure damage doesn't go below 0
	total_dmg = max(0, total_dmg)
	var t = target if target else select_target()
	if t == null: return
	attackAnim()
	await get_tree().create_timer(attackLength).timeout
	
	if t.has_method("takeDamage"):
		t.takeDamage(total_dmg)
		Feedback(t.global_position, total_dmg, "damage")
	modifiedDamage = 0

func buffDamage(amount: int):
	modifiedDamage += amount
	emitBuff()
	Feedback(self.global_position, amount, "buff")
	gameManager.hideenemyDescription()

func buffArmor(amount: int):
	armor += amount
	emitArmor()
	Feedback(self.global_position, amount, "armor")
	gameManager.hideenemyDescription()

func heal(amount: int):
	health += amount
	emitHealth()
	Feedback(self.global_position, amount, "heal")
	gameManager.hideenemyDescription()

# --- UI & ANIMATION ---

func Feedback(targetPosition: Vector2, amount: int, type: String):
	print("why no work")
	var offset :Vector2 = Vector2(-40, -90)
	var feedback = preload("res://feedBack.tscn").instantiate()
	feedback.showFeedback(amount, type)
	feedback.global_position = targetPosition + offset
	get_tree().current_scene.add_child(feedback)

func showDescription():
	var status_info = ""
	if statusComponent and not statusComponent.active_statuses.is_empty():
		var effects = statusComponent.active_statuses.keys()
		for i in range(effects.size()):
			var effect_name = effects[i]
			var data = statusComponent.active_statuses[effect_name]
			var line = "%s: %d DMG (%d turns)" % [effect_name, data["damage"], data["turns"]]
			status_info += ("\n" + line) if i > 0 else line
	gameManager.showenemyDescription(self, status_info)

func hideDescription():
	gameManager.hideenemyDescription()

func buffAnim():
	animTree.set("parameters/conditions/Buff", true)
	print(self.name, "should be moving")
	await get_tree().create_timer(.8).timeout
	animTree.set("parameters/conditions/Buff", false)

func attackAnim():
	animTree.set("parameters/conditions/Attack", true)
	await get_tree().create_timer(attackLength).timeout
	animTree.set("parameters/conditions/Attack", false)

func hitAnim():
	animTree.set("parameters/conditions/Hit", true)
	await get_tree().create_timer(hitLength).timeout
	animTree.set("parameters/conditions/Hit", false)

func emitArmor():
	particles.modulate = Color(1,1,1)
	particles.emitting = true
	await get_tree().create_timer(.5).timeout
	particles.emitting = false

func emitHealth():
	particles.modulate = Color(0,0,1)
	particles.emitting = true
	await get_tree().create_timer(.5).timeout
	particles.emitting = false

func emitBuff():
	particles.modulate = Color(1,0,0)
	particles.emitting = true
	await get_tree().create_timer(.5).timeout
	particles.emitting = false

func die():
	if gameManager.enemyTeam.has(self):
		gameManager.enemyTeam.erase(self)
		animTree.set("parameters/conditions/Death", true)
		await get_tree().create_timer(deathLength).timeout
		queue_free()
		
		
func action_attack(target_type: String, damage_value: int):
	var main_target = select_target()
	var targets = get_group(target_type, main_target)
	attackAnim()
	await get_tree().create_timer(attackLength).timeout
	for t in targets:
		if is_instance_valid(t):
			t.takeDamage(damage_value + modifiedDamage)
			Feedback(t.global_position, damage_value + modifiedDamage, "damage")
	modifiedDamage = 0

func action_buff(target_type: String, amount: int):
	await get_tree().create_timer(.8).timeout
	emitBuff()
	var targets = get_group(target_type)
	for t in targets:
		if t.has_method("buffDamage"):
			t.buffDamage(amount)

func action_armor(target_type: String, amount: int):
	await get_tree().create_timer(.8).timeout
	emitArmor()
	var targets = get_group(target_type)
	for t in targets:
		if t.has_method("buffArmor"):
			t.buffArmor(amount)

func action_heal(target_type: String, amount: int):
	await get_tree().create_timer(.8).timeout
	emitHealth()
	var targets = get_group(target_type)
	for t in targets:
		if t.has_method("heal"):
			t.heal(amount)

func action_dot(target_type: String, effect_name: String, dmg: int, duration: int):
	var main_target = select_target()
	var targets = get_group(target_type, main_target)
	
	attackAnim()
	await get_tree().create_timer(attackLength).timeout
	
	for t in targets:
		var status_node = t.get_node_or_null("statusComponent")
		if status_node:
			status_node.add_effect(effect_name, {
				"damage": dmg, 
				"turns": duration
			})
			t.hurtAnim()
			Feedback(t.global_position, 0, effect_name)
